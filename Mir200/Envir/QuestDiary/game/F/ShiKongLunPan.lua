local ShiKongLunPan = {}
local cont = { { { "时间锁", 1 }, { "混沌本源", 10 } }, { { "轮回沙漏", 1 }, { "混沌本源", 10 } }, { { "失落空间", 1 }, { "混沌本源", 10 } }, { { "灵符", 333 }, { "造化结晶", 10 } } }
local AttrData = { "攻击加成", "魔法加成", "道术加成", "体力增加", "防御加成", "攻击伤害", "伤害吸收", "打怪爆率" }

--获取罗盘解锁状态并返回一个tbl
function ShiKongLunPan.getFlagstate(actor)
    local state1 = getflagstatus(actor, VarCfg["F_时空轮盘位置1"])
    local state2 = getflagstatus(actor, VarCfg["F_时空轮盘位置2"])
    local state3 = getflagstatus(actor, VarCfg["F_时空轮盘位置3"])
    local flagTbl = { state1, state2, state3 }
    return flagTbl
end

--获取罗盘属性并返会一个tbl
function ShiKongLunPan.getVariableState(actor)
    local IsTbl = Player.getJsonTableByVar(actor, VarCfg["T_时光轮盘属性"])
    local NewTbl = {}
    for i = 1, 3 do
        local State = (IsTbl[i] == nil and "暂无属性") or IsTbl[i]
        NewTbl[i] = State
    end
    return NewTbl
end

--刷新前端属性
function shua_xin_qian_duan_xian_shi(actor)
    Player.setAttList(actor, "属性附加")
    Player.setAttList(actor, "爆率附加")
    setplaydef(actor, VarCfg["S$时空轮盘临时记录"], "")
    ShiKongLunPan.SyncResponse(actor)
end

--转动轮盘取值
function ShiKongLunPan.LuoPanQuZhi(actor)
    local attrTbl = ShiKongLunPan.getVariableState(actor)
    local NewTbl = {}
    for _, k in ipairs(AttrData) do
        local GaiLv = 3
        for _, v in ipairs(attrTbl) do
            if k == v then
                GaiLv = GaiLv - 1
            end
        end
        if GaiLv == 3 then
            table.insert(NewTbl, k)
        else
            if randomex(GaiLv * 2, 100) then
                -- release_print("提示",GaiLv*2,k)
                return k
            end
        end
    end
    return NewTbl[math.random(1, #NewTbl)]
end

--解锁罗盘
function ShiKongLunPan.Request1(actor, var)
    local flagTbl = ShiKongLunPan.getFlagstate(actor) --获取罗盘开启状态
    if flagTbl[var] == 1 then return end
    local name, num = Player.checkItemNumByTable(actor, cont[var])
    if name then
        Player.sendmsgEx(actor, string.format("提示#251|:#255|你的|%s#249|数量不足|%d#249|,解锁失败...", name, num))
        return
    end
    Player.takeItemByTable(actor, cont[var], "解锁罗盘" .. var .. "")
    setflagstatus(actor, VarCfg["F_时空轮盘位置" .. var .. ""], 1)
    --刷新前端
    ShiKongLunPan.SyncResponse(actor)
end

--转动罗盘
function ShiKongLunPan.Request2(actor, var)
    local flagTbl = ShiKongLunPan.getFlagstate(actor)
    if flagTbl[var] == 0 then
        Player.sendmsgEx(actor, "[提示]:#251|我报警了!")
        return
    end

    if getplaydef(actor, VarCfg["S$时空轮盘临时记录"]) ~= "" then
        Player.sendmsgEx(actor, "[提示]:#251|当前轮盘|[转动中]#249|请稍后!")
        return
    end
    local name, num = Player.checkItemNumByTable(actor, cont[4])
    if name then
        Player.sendmsgEx(actor, string.format("提示#251|:#255|你的|%s#249|数量不足|%d#249|,转动罗盘失败...", name, num))
        return
    end
    Player.takeItemByTable(actor, cont[4], "转动罗盘" .. var .. "")
    setflagstatus(actor, VarCfg["F_转动时空轮盘"], 1)
    local AttrTbl = ShiKongLunPan.getVariableState(actor)
    local QiShiWeiZhi = (AttrTbl[var] == "暂无属性" and 0) or AttrData[AttrTbl[var]]
    local FistrSite = AttrTbl[var] == "暂无属性" or AttrTbl[var] --开始位置
    local EndSite = ShiKongLunPan.LuoPanQuZhi(actor)
    setplaydef(actor, VarCfg["S$时空轮盘临时记录"], EndSite)
    AttrTbl[var] = EndSite
    Player.setJsonVarByTable(actor, VarCfg["T_时光轮盘属性"], AttrTbl)
    --播放前端动画
    local EffectsData = { FistrSite, EndSite }
    Message.sendmsg(actor, ssrNetMsgCfg.ShiKongLunPan_PlayEffects, 0, 0, var, EffectsData)
    delaygoto(actor, 2000, "shua_xin_qian_duan_xian_shi")
end

function ShiKongLunPan.LiaoJie(actor)
    setflagstatus(actor, VarCfg["F_了解时空轮盘"], 1)
end

--检测是否双倍
function ShiKongLunPan.CheckIsDouble(actor, _type)
    local attrTbl = ShiKongLunPan.getVariableState(actor)
    local multiple = 0
    for _, v in ipairs(attrTbl) do
        if _type == v then
            multiple = multiple + 1
        end
    end
    return multiple * multiple
end

--属性刷新
local function _onCalcAttr(actor, attrs)
    local attrTbl = ShiKongLunPan.getVariableState(actor)
    local attrtbl = {
        [210] = 6 * ShiKongLunPan.CheckIsDouble(actor, "攻击加成"), --攻击上限百分比
        [211] = 6 * ShiKongLunPan.CheckIsDouble(actor, "魔法加成"), --魔法上限百分比
        [212] = 6 * ShiKongLunPan.CheckIsDouble(actor, "道术加成"), --道术上限百分比
        [208] = 6 * ShiKongLunPan.CheckIsDouble(actor, "体力增加"), --生命值百分比
        [213] = 6 * ShiKongLunPan.CheckIsDouble(actor, "防御加成"), --物防上限百分比
        [25]  = 6 * ShiKongLunPan.CheckIsDouble(actor, "攻击伤害"), --增加攻击伤害元素
        [26]  = 6 * ShiKongLunPan.CheckIsDouble(actor, "伤害吸收"), --物理伤害减少 元素
    }
    calcAtts(attrs, attrtbl, "时空轮盘")
end
GameEvent.add(EventCfg.onCalcAttr, _onCalcAttr, ShiKongLunPan)

--爆率刷新
local function _onCalcBaoLv(actor, attrs)
    local attrtbl = {
        [204] = 6 * ShiKongLunPan.CheckIsDouble(actor, "打怪爆率"), --爆率倍数
    }
    calcAtts(attrs, attrtbl, "时空轮盘")
end
GameEvent.add(EventCfg.onCalcBaoLv, _onCalcBaoLv, ShiKongLunPan)

--注册网络消息
function ShiKongLunPan.SyncResponse(actor, logindatas)
    local flagTbl = ShiKongLunPan.getFlagstate(actor)
    local attrTbl = ShiKongLunPan.getVariableState(actor)
    local data = { flagTbl, attrTbl }
    local _login_data = { ssrNetMsgCfg.ShiKongLunPan_SyncResponse, 0, 0, 0, data }
    if logindatas then
        table.insert(logindatas, _login_data)
    else
        Message.sendmsg(actor, ssrNetMsgCfg.ShiKongLunPan_SyncResponse, 0, 0, 0, data)
    end
end

Message.RegisterNetMsg(ssrNetMsgCfg.ShiKongLunPan, ShiKongLunPan)

--登录触发
local function _onLoginEnd(actor, logindatas)
    ShiKongLunPan.SyncResponse(actor, logindatas)
end
GameEvent.add(EventCfg.onLoginEnd, _onLoginEnd, ShiKongLunPan)

return ShiKongLunPan

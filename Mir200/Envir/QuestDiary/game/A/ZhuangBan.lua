ZhuangBan = {}
ZhuangBan.ID = "装扮"
local cfg_ZhuangBan = include("QuestDiary/cfgcsv/cfg_ZhuangBan.lua")       --配置
local cfg_SetZhuangBan = include("QuestDiary/cfgcsv/cfg_SetZhuangBan.lua") --配置
local cost = { {} }
local give = { {} }
local zhuangBanCahce = {}
--变量名枚举索引用于插入缓存
local enumVarCfg = {
    [VarCfg["T_时装记录"]] = 1,
    [VarCfg["T_足迹记录"]] = 2,
    [VarCfg["T_光环记录"]] = 3,
}
--判断我是否获取了这个装扮，防刷
function ZhuangBan.IsHaveZhuangBan(actor, index)
    local result = false
    local list = ZhuangBan.GetZhuangBanList(actor)
    for _, value in ipairs(list) do
        result = table.contains(value, index)
        if result then
            break
        end
    end
    return result
end
--接收请求
function ZhuangBan.Request(actor,index)
    local cfg = cfg_ZhuangBan[index]
    if not cfg then
        Player.sendmsgEx(actor, "没有找到装扮#249")
        return
    end
    if not ZhuangBan.IsHaveZhuangBan(actor, index) then
        Player.sendmsgEx(actor, "你没有这个装扮#249")
        return
    end
    ZhuangBan.SetCurrFashion(actor, index)
    Player.sendmsgEx(actor,"更换成功")
    --local name, num = Player.checkItemNumByTable(actor, cost)
    --if name then
    --Player.sendmsgEx(actor, string.format("你的|%s#249|不足|%d#249", name, num))
    --return
    --end
end
--获取所有装扮，缓存方式
function ZhuangBan.GetZhuangBanList(actor)
    if zhuangBanCahce[actor] then
        return zhuangBanCahce[actor]
    end
    local result = {}
    result[1] = Player.getJsonTableByVar(actor, VarCfg["T_时装记录"])
    result[2] = Player.getJsonTableByVar(actor, VarCfg["T_足迹记录"])
    result[3] = Player.getJsonTableByVar(actor, VarCfg["T_光环记录"])
    zhuangBanCahce[actor] = result
    return result
end

function ZhuangBan.GetZhuangBanTotalNum(actor)
    local zhuangBanList = ZhuangBan.GetZhuangBanList(actor)
    local num = 0
    for _, value in ipairs(zhuangBanList) do
        num = num + #value
    end
    return num
end
--同步消息
-- function ZhuangBan.SyncResponse(actor, logindatas)
--     local data = {}
--     local _login_data = {ssrNetMsgCfg.ZhuangBan_SyncResponse, 0, 0, 0, data}
--     if logindatas then
--         table.insert(logindatas, _login_data)
--     else
--         Message.sendmsg(actor, ssrNetMsgCfg.ZhuangBan_SyncResponse, 0, 0, 0, data)
--     end
-- end
-- --登录触发
local function _onLoginEnd(actor, logindatas)
    -- ZhuangBan.SyncResponse(actor, logindatas)
    local shizhuangEff = getplaydef(actor, VarCfg["U_时装外观记录"])
    if shizhuangEff > 0 then
        setfeature(actor, 0, shizhuangEff, 655350, 0, 0)
        setfeature(actor, 1, 9999, 655350, 0, 0)
    end
    local zujiEff = getplaydef(actor, VarCfg["U_足迹外观记录"])
    if zujiEff > 0 then
        setmoveeff(actor, zujiEff, 1)
    end
    local guanghuanEff = getplaydef(actor, VarCfg["U_光环外观记录"])
    if guanghuanEff > 0 then
        seticon(actor, ConstCfg.iconWhere.guangHuan, 1, guanghuanEff, 0, 0, 0, 0, 1)
    end
end
--事件派发
GameEvent.add(EventCfg.onLoginEnd, _onLoginEnd, ZhuangBan)
GameEvent.add(EventCfg.onKFLogin, _onLoginEnd, ZhuangBan)

function ZhuangBan.OpenUI(actor)
    local data = {}
    data.curr = {
        [1] = getplaydef(actor, VarCfg["U_时装外观记录"]),
        [2] = getplaydef(actor, VarCfg["U_足迹外观记录"]),
        [3] = getplaydef(actor, VarCfg["U_光环外观记录"]),
    }
    data.received = ZhuangBan.GetZhuangBanList(actor)
    Message.sendmsg(actor, ssrNetMsgCfg.ZhuangBan_OpenUI, 0, 0, 0, data)

end

--记录装扮列表到变量
function ZhuangBan.AddFashionToVar(actor, index, Tvar)
    if not index or not Tvar then
        return
    end
    local list = Player.getJsonTableByVar(actor, Tvar)
    if not table.contains(list, index) then
        table.insert(list, index)
        Player.sendmsgEx(actor, "获得一个新装扮,可到装扮面板查看")
    end

    --添加装扮的时候更新到缓存
    local cacheIndex = enumVarCfg[Tvar]
    if zhuangBanCahce[actor] then
        zhuangBanCahce[actor][cacheIndex] = list
    end
    Player.setJsonVarByTable(actor, Tvar, list)
    Player.setAttList(actor,"属性附加")
    
    --增加装扮后获取全部数量，做事件派发
    local SkinNum = ZhuangBan.GetZhuangBanList(actor)
    local _Num = #SkinNum[1] + #SkinNum[2] + #SkinNum[3]
    GameEvent.push(EventCfg.onUPSkin, actor, _Num)
end

--设置当前装扮
function ZhuangBan.SetCurrFashion(actor, index)
    if not index then
        return
    end
    if type(index) ~= "number" then
        return
    end
    local cfg = cfg_ZhuangBan[index]
    if cfg.type == 1 then --设置时装
        FIllusionAppearance(actor, cfg.Shape[1], cfg.sEffect[1])
    elseif cfg.type == 2 then --设置足迹
        FSetMoveEff(actor, cfg.Shape[1])
    elseif cfg.type == 3 then --设置光环
        FSetGuangHuan(actor, cfg.Shape[1])
    end
    Player.setAttList(actor,"属性附加")
end

--穿装备触发
local function _onTakeOnEx(actor, itemobj, where, itemname, makeid)
    local cfg = cfg_SetZhuangBan[itemname]
    if cfg then
        for _, value in ipairs(cfg.Shape or {}) do
            ZhuangBan.AddFashionToVar(actor, value, cfg.Tvar)
        end
        ZhuangBan.SetCurrFashion(actor, cfg.Shape[1])
    end
end
GameEvent.add(EventCfg.onTakeOnEx, _onTakeOnEx, ZhuangBan)

local function _onTakeOffEx(actor, itemobj, where, itemname, makeid)

end
GameEvent.add(EventCfg.onTakeOffEx, _onTakeOffEx, ZhuangBan)


--显示时装触发
local function _onShowFashion(actor)
    local shizhuangEff = getplaydef(actor, VarCfg["U_时装外观记录"])
    if shizhuangEff > 0 then
        setfeature(actor, 0, shizhuangEff, 655350, 0, 0)
        setfeature(actor, 1, 9999, 655350, 0, 0)
    end
end
GameEvent.add(EventCfg.onShowFashion, _onShowFashion, ZhuangBan)

--取消显示时装触发
local function _onNotShowFashion(actor)
    setfeature(actor, 0, -1, 655350, 0, 0)
    setfeature(actor, 1, -1, 655350, 0, 0)
end
GameEvent.add(EventCfg.onNotShowFashion, _onNotShowFashion, ZhuangBan)

--大退小退触发--清理缓存
local function _onExitGame(actor)
    if zhuangBanCahce[actor] then
        zhuangBanCahce[actor] = nil
    end
end
GameEvent.add(EventCfg.onExitGame, _onExitGame, ZhuangBan)

--注册网络消息
Message.RegisterNetMsg(ssrNetMsgCfg.ZhuangBan, ZhuangBan)


--把属性字符串转换成数组
local function attrStrToAtts(attrStr)
    local attrs = {}
    for _, value in ipairs(attrStr) do
        local tmpAttr = string.split(value, "#")
        attrs[tonumber(tmpAttr[1])] = tonumber(tmpAttr[2])
    end
    return attrs
end
local function _onCalcAttr(actor,attrs)
    --计算套装的
    local zhuangBanIds = ZhuangBan.GetZhuangBanList(actor)
    local shuxing = {} -- 属性表
    for _, value in ipairs(zhuangBanIds or {}) do
        for _, v in ipairs(value) do
            local cfg = cfg_ZhuangBan[tonumber(v)]
            if cfg then
                if cfg.attrs then
                    local tmpAttrs = attrStrToAtts(cfg.attrs)
                    attsMerge(tmpAttrs, shuxing)
                end
            end
        end
    end
    calcAtts(attrs,shuxing,"装扮属性")
end

--属性附加触发
GameEvent.add(EventCfg.onCalcAttr, _onCalcAttr, ZhuangBan)

return ZhuangBan

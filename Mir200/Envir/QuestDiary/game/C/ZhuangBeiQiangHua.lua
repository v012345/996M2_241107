ZhuangBeiQiangHua = {}
ZhuangBeiQiangHua.ID = "装备强化"
local config = include("QuestDiary/cfgcsv/cfg_ZhuangBeiQiangHua.lua")
--位置映射变量
local varConfig = {
    [1] = VarCfg["U_装备强化_衣服"], --武器
    [0] = VarCfg["U_装备强化_武器"], --衣服
    [6] = VarCfg["U_装备强化_左手"], --左手
    [8] = VarCfg["U_装备强化_左戒"], --右戒指
    [10] = VarCfg["U_装备强化_腰带"], --腰带
    [4] = VarCfg["U_装备强化_头盔"], --头盔
    [3] = VarCfg["U_装备强化_项链"], --项链
    [5] = VarCfg["U_装备强化_右手"], --右手
    [7] = VarCfg["U_装备强化_右戒"], --右戒
    [11] = VarCfg["U_装备强化_靴子"], --靴子
}
function ZhuangBeiQiangHua.Request(actor, arg1, arg2, arg3, data)
    local var = varConfig[arg1]
    if not var then
        Player.sendmsgEx(actor, "参数错误!!#249")
        return
    end

    -- for key, value in pairs(varConfig) do
    --     setplaydef(actor,value,0)
    -- end

    local itemObj = linkbodyitem(actor, arg1)
    if itemObj == "0" then
        Player.sendmsgEx(actor, "当前位置没有穿戴装备!!#249")
        return
    end
    local level = getplaydef(actor, var)
    if level > 14 then
        Player.sendmsgEx(actor, "该装备已经强化到最高级!#249")
        return
    end
    local cfg = config[level]
    if not cfg then
        Player.sendmsgEx(actor, "该装备已经强化到最高级!#249")
        return
    end
    local name, num = Player.checkItemNumByTable(actor, cfg.cost)
    if name then
        Player.sendmsgEx(actor, string.format("你的|%s#249|不足|%d#249|!", name, num))
        return
    end
    Player.takeItemByTable(actor, cfg.cost, "装备强化")

    if checkitemw(actor,"强化+9999",1) then
        local itemobj = linkbodyitem(actor, 38)
        local usenum = getitemaddvalue(actor, itemobj, 2, 19) --获取信息标记信息 QF 穿戴触发 设置标记 13
        if usenum > 10 then --大于13次 执行
            usenum = usenum - 1
            changeitemname(actor, 38, "强化+999[可使用:" .. usenum - 10 .. "次]") --修改装备显示名字
            setitemaddvalue(actor, itemobj, 2, 19, usenum) --设置装备标记次数13（使用一次减少一次 装备消失）
            if randomex(1, 128) then
                setplaydef(actor, var, 15)
                ZhuangBeiQiangHua.SetItemCustomAbilEx(actor, itemObj, 15, arg1, cfg)
                Player.sendmsgEx(actor, "[强化+999]:#251|恭喜你触发|强化+999#249|专属BUFF|强化直接达到+15#249|...")
                Player.setAttList(actor, "属性附加")
                if level > 12 then
                    Player.setAttList(actor, "倍攻附加")
                end
                ZhuangBeiQiangHua.SyncResponse(actor)
                return
            end
        end
    end
    
    if randomex(cfg.Success) then
        setplaydef(actor, var, level + 1)
        ZhuangBeiQiangHua.SetItemCustomAbilEx(actor, itemObj, level + 1, arg1, cfg)
        Player.sendmsgEx(actor, "强化成功!")
    else
        Player.sendmsgEx(actor, "抱歉,强化失败了...#249")
    end

    Player.setAttList(actor, "属性附加")

    if level > 12 then
        Player.setAttList(actor, "倍攻附加")
    end
    ZhuangBeiQiangHua.SyncResponse(actor)
end

--给装备属性
function ZhuangBeiQiangHua.SetItemCustomAbilEx(actor, itemObj, level, where, cfg)
    setitemaddvalue(actor, itemObj, 2, 3, level) --星星
    local equipAttr = {}
    if where == 1 then
        equipAttr = cfg.weaponAttr
    elseif where == 0 then
        equipAttr = cfg.clothAttr
    else
        equipAttr = cfg.ornamentsAttr
    end
    local JianLingChuanShuoNum = 0
    local JiHanHuJiaPian = 0
    for _, value in ipairs(equipAttr) do
        if where == 1 then
            local numCount = getplaydef(actor, VarCfg["U_剧情_剑灵传说"])
            JianLingChuanShuoNum = numCount * 50
        end
        if where == 0 then
            local numCount = getplaydef(actor, VarCfg["U_极寒护甲片_使用次数"])
            JiHanHuJiaPian = numCount * 20
        end
        setitemaddvalue(actor, itemObj, 1, value[1], value[2] + JianLingChuanShuoNum + JiHanHuJiaPian)
        JianLingChuanShuoNum = 0
        JiHanHuJiaPian = 0
    end
    refreshitem(actor, itemObj)
    local itemBody = linkbodyitem(actor, where)
    refreshitem(actor, itemBody)
    recalcabilitys(actor)
end

function ZhuangBeiQiangHua.SyncResponse(actor, logindatas)
    local data = {
        [1] = getplaydef(actor, VarCfg["U_装备强化_衣服"]), --武器
        [0] = getplaydef(actor, VarCfg["U_装备强化_武器"]), --衣服
        [6] = getplaydef(actor, VarCfg["U_装备强化_左手"]), --左手
        [8] = getplaydef(actor, VarCfg["U_装备强化_左戒"]), --右戒指
        [10] = getplaydef(actor, VarCfg["U_装备强化_腰带"]), --腰带
        [4] = getplaydef(actor, VarCfg["U_装备强化_头盔"]), --头盔
        [3] = getplaydef(actor, VarCfg["U_装备强化_项链"]), --项链
        [5] = getplaydef(actor, VarCfg["U_装备强化_右手"]), --右手
        [7] = getplaydef(actor, VarCfg["U_装备强化_右戒"]), --右戒
        [11] = getplaydef(actor, VarCfg["U_装备强化_靴子"]), --靴子
    }
    local qhdsFlag = getflagstatus(actor, VarCfg["F_天命_强化大师标识"])
    local allLevel = getplaydef(actor,VarCfg["U_全身强化等级"])
    local _login_data = { ssrNetMsgCfg.ZhuangBeiQiangHua_SyncResponse, qhdsFlag, allLevel, 0, data }
    if logindatas then
        table.insert(logindatas, _login_data)
    else
        Message.sendmsg(actor, ssrNetMsgCfg.ZhuangBeiQiangHua_SyncResponse, qhdsFlag, allLevel, 0, data)
    end
end

--登录触发
local function _onLoginEnd(actor, logindatas)
    ZhuangBeiQiangHua.SyncResponse(actor, logindatas)
end

--穿装备
local function _onTakeOnEx(actor, itemobj, where, itemname, makeid)
    local var = varConfig[where]
    if var then
        local level = getplaydef(actor, var)
        setitemaddvalue(actor, itemobj, 2, 3, level)
        local tmpLevel = level
        tmpLevel = tmpLevel - 1
        if tmpLevel > 0 then
            local cfg = config[tmpLevel]
            ZhuangBeiQiangHua.SetItemCustomAbilEx(actor, itemobj, level, where, cfg)
        end
    end
end

--脱装备
local function _onTakeOffEx(actor, itemobj, where, itemname, makeid)
    local var = varConfig[where]
    if var then
        setitemaddvalue(actor, itemobj, 2, 3, 0)
        setitemaddvalue(actor, itemobj, 1, 0, 0)
        setitemaddvalue(actor, itemobj, 1, 1, 0)
        setitemaddvalue(actor, itemobj, 1, 2, 0)
        setitemaddvalue(actor, itemobj, 1, 3, 0)
        setitemaddvalue(actor, itemobj, 1, 4, 0)
        refreshitem(actor, itemobj)
    end
end

--倍功计算
local function _onCalcBeiGong(actor, beiGongs)
    local array = {
        getplaydef(actor, VarCfg["U_装备强化_衣服"]), --武器
        getplaydef(actor, VarCfg["U_装备强化_武器"]), --衣服
        getplaydef(actor, VarCfg["U_装备强化_左手"]), --左手
        getplaydef(actor, VarCfg["U_装备强化_左戒"]), --右戒指
        getplaydef(actor, VarCfg["U_装备强化_腰带"]), --腰带
        getplaydef(actor, VarCfg["U_装备强化_头盔"]), --头盔
        getplaydef(actor, VarCfg["U_装备强化_项链"]), --项链
        getplaydef(actor, VarCfg["U_装备强化_右手"]), --右手
        getplaydef(actor, VarCfg["U_装备强化_右戒"]), --右戒
        getplaydef(actor, VarCfg["U_装备强化_靴子"]), --靴子
    }
    local level = findMinValue(array)
    level = level - 1
    if level > 0 then
        if level > 15 then
            level = 15
        end
        local cfg = config[level]
        local beigong = {
            [1] = cfg.shenLi
        }
        calcAtts(beiGongs, beigong, "装备强化倍功")
    end
end

local function _onCalcAttr(actor, attrs)
    local array = {
        getplaydef(actor, VarCfg["U_装备强化_衣服"]), --武器
        getplaydef(actor, VarCfg["U_装备强化_武器"]), --衣服
        getplaydef(actor, VarCfg["U_装备强化_左手"]), --左手
        getplaydef(actor, VarCfg["U_装备强化_左戒"]), --右戒指
        getplaydef(actor, VarCfg["U_装备强化_腰带"]), --腰带
        getplaydef(actor, VarCfg["U_装备强化_头盔"]), --头盔
        getplaydef(actor, VarCfg["U_装备强化_项链"]), --项链
        getplaydef(actor, VarCfg["U_装备强化_右手"]), --右手
        getplaydef(actor, VarCfg["U_装备强化_右戒"]), --右戒
        getplaydef(actor, VarCfg["U_装备强化_靴子"]), --靴子
    }
    local level = findMinValue(array)
    setplaydef(actor,VarCfg["U_全身强化等级"],level)
    level = level - 1
    --全身装备强化到5级事件派发
    if level == 4  then
        GameEvent.push(EventCfg.onZhuangBeiQiangHua, actor, level)
        local taskPanelID = getplaydef(actor, VarCfg["U_主线任务面板进度"])
        if taskPanelID == 18 then
            FCheckTaskRedPoint(actor)
        end
    end
    if level == 6 then
        local taskPanelID = getplaydef(actor, VarCfg["U_主线任务面板进度"])
        if taskPanelID == 26 then
            FCheckTaskRedPoint(actor)
        end
    end
    if level > 0 then
        if level >= 14 then
            level = 14
        end
        local cfg = config[level]
        local attr = {}
        for _, value in ipairs(cfg.allAttr or {}) do
            attr[value[1]] = value[2]
        end
        calcAtts(attrs, attr, "装备强化")
    end
end

--计算倍功
GameEvent.add(EventCfg.onCalcBeiGong, _onCalcBeiGong, ZhuangBeiQiangHua)

--计算属性
GameEvent.add(EventCfg.onCalcAttr, _onCalcAttr, ZhuangBeiQiangHua)

--登录触发
GameEvent.add(EventCfg.onLoginEnd, _onLoginEnd, ZhuangBeiQiangHua)

--穿装备触发
GameEvent.add(EventCfg.onTakeOnEx, _onTakeOnEx, ZhuangBeiQiangHua)

--脱装备触发
GameEvent.add(EventCfg.onTakeOffEx, _onTakeOffEx, ZhuangBeiQiangHua)

---注册网络消息
Message.RegisterNetMsg(ssrNetMsgCfg.ZhuangBeiQiangHua, ZhuangBeiQiangHua)
return ZhuangBeiQiangHua

local WuXingLingTi = {}
WuXingLingTi.ID = "五行灵体"
local npcID = 502
local config = include("QuestDiary/cfgcsv/cfg_WuXingLingTi.lua") --配置
local give = { { "五行聚灵丹", 1 } }
--元宝提升
function WuXingLingTi.Request1(actor, index)
    local cfg = config[index]
    if not cfg then
        Player.sendmsgEx(actor, "参数错误#249")
        return
    end
    local count = getplaydef(actor, cfg.var)
    if count >= 10 then
        Player.sendmsgEx(actor, string.format("你的|%s属性#249|已经满级了", cfg.name))
        return
    end
    local cost = cfg.ybcost
    local name, num = Player.checkItemNumByTable(actor, cost)
    if name then
        Player.sendmsgEx(actor, string.format("你的|%s#249|不足|%d#249", name, num))
        return
    end
    Player.takeItemByTable(actor, cost, "五行灵体")
    if randomex(30) then
        setplaydef(actor, cfg.var, count + 1)
        Player.sendmsgEx(actor, string.format("%s属性#249|升级成功|%s#249", cfg.name, cfg.attrName))
        setflagstatus(actor,VarCfg["F_五行灵体提升一次"],1)
        Player.setAttList(actor, "属性附加")
    else
        Player.sendmsgEx(actor, "升级失败#249")
    end
    WuXingLingTi.SyncResponse(actor)
end

--灵符提升
function WuXingLingTi.Request2(actor, index)
    local cfg = config[index]
    if not cfg then
        Player.sendmsgEx(actor, "参数错误#249")
        return
    end
    local count = getplaydef(actor, cfg.var)
    if count >= 10 then
        Player.sendmsgEx(actor, string.format("你的|%s属性#249|已经满级了", cfg.name))
        return
    end
    local cost = cfg.lfcost
    local name, num = Player.checkItemNumByTable(actor, cost)
    if name then
        Player.sendmsgEx(actor, string.format("你的|%s#249|不足|%d#249", name, num))
        return
    end
    Player.takeItemByTable(actor, cost, "五行灵体")
    setplaydef(actor, cfg.var, count + 1)
    -- setflagstatus(actor,VarCfg["F_五行灵体提升一次"],1)
    FSetTaskRedPoint(actor, VarCfg["F_五行灵体提升一次"], 46)
    Player.sendmsgEx(actor, string.format("%s属性#249|升级成功|%s#249", cfg.name, cfg.attrName))
    Player.setAttList(actor, "属性附加")
    WuXingLingTi.SyncResponse(actor)
end

function WuXingLingTi.Request3(actor)
    if checktitle(actor, "五行灵体") then
        Player.sendmsgEx(actor, "你已经领取过了!#249")
        return
    end
    local result = true
    for _, value in ipairs(config) do
        if getplaydef(actor, value.var) < 10 then
            result = false
            break
        end
    end
    if result then
        if not Bag.checkBagEmptyNum(actor, 5) then
            Player.sendmsgEx(actor, "你的背包格子不足,至少留出5个空格!#249")
            return
        end
        confertitle(actor, "五行灵体")
        Player.giveItemByTable(actor, give, "五行灵体升满", 1, true)
        Player.sendmsgEx(actor, "领取成功!")
        WuXingLingTi.SyncResponse(actor)
    else
        Player.sendmsgEx(actor, "你还没有全部升级到10级!#249")
    end
end

--同步消息
function WuXingLingTi.SyncResponse(actor, logindatas)
    local data = {}
    for index, value in ipairs(config) do
        data[index] = getplaydef(actor, value.var)
    end
    local _login_data = { ssrNetMsgCfg.WuXingLingTi_SyncResponse, 0, 0, 0, data }
    if logindatas then
        table.insert(logindatas, _login_data)
    else
        Message.sendmsg(actor, ssrNetMsgCfg.WuXingLingTi_SyncResponse, 0, 0, 0, data)
    end
end

local function _onCalcAttr(actor, attrs)
    local shuxing = {}
    for _, value in ipairs(config) do
        local count = getplaydef(actor, value.var)
        if count > 0 then
            for _, v in ipairs(value.attrs or {}) do
                shuxing[v] = count * value.num
            end
        end
    end
    calcAtts(attrs, shuxing, "五行灵体")
end
--属性
GameEvent.add(EventCfg.onCalcAttr, _onCalcAttr, WuXingLingTi)

--登录触发
local function _onLoginEnd(actor, logindatas)
    WuXingLingTi.SyncResponse(actor, logindatas)
end
--事件派发
GameEvent.add(EventCfg.onLoginEnd, _onLoginEnd, WuXingLingTi)
--注册网络消息
Message.RegisterNetMsg(ssrNetMsgCfg.WuXingLingTi, WuXingLingTi)
return WuXingLingTi

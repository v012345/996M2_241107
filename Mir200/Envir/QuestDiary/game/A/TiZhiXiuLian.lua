local TiZhiXiuLian = {}
local randomdata = { 100, 30, 30, 30, 30, 30, 30, 30, 20, 20 }
local config = include("QuestDiary/cfgcsv/cfg_TiZhiXiuLian.lua") --小神魔配置
local allMaxCost = { { "元宝", 1000000 } }

function TiZhiXiuLian.Request(actor, arg1)
    local cfg = config[arg1]
    if not cfg then
        Player.sendmsgEx(actor, "参数错误1!")
        return
    end
    --当前等级
    local currLevel = getplaydef(actor, cfg.bindVar)
    if currLevel >= cfg.maxLevel then
        Player.sendmsgEx(actor, string.format("你的|%s#249|已经达到|%d级#249|了...", cfg.name, cfg.maxLevel))
        return
    end
    local name, num = Player.checkItemNumByTable(actor, cfg.cost)
    if name then
        Player.sendmsgEx(actor, string.format("你背包的|%s#249|不足|%d#249|...", name, num))
        return
    end
    local success = randomdata[currLevel + 1]
    if randomex(success) then
        Player.takeItemByTable(actor, cfg.cost, "体质修炼小神魔成功")
        setplaydef(actor, cfg.bindVar, currLevel + 1)
        Player.sendmsgEx(actor, "#255|恭喜,你的|" .. cfg.name .. "#249|达到了|" .. getplaydef(actor, cfg.bindVar) .. "级#249|实力更进一步...")
        TiZhiXiuLian.giveTitle(actor)
        TiZhiXiuLian.SyncResponse(actor)
        Player.setAttList(actor, "属性附加")
    else
        Player.takeItemByTable(actor, cfg.cost, "体质修炼小神魔失败")
        Player.sendmsgEx(actor, "你的|" .. cfg.name .. "#249|升级|失败#249|材料扣除...")
    end
end

function TiZhiXiuLian.ButtonLink1(actor)
    local isMax = TiZhiXiuLian.CheckAllMaxLevel(actor)
    if isMax then
        Player.sendmsgEx(actor, "你的体质修炼已经全部满级了...")
        return
    end
    local name, num = Player.checkItemNumByTable(actor, allMaxCost)
    if name then
        Player.sendmsgEx(actor, string.format("你的|%s#249|不足|%d#249|...", name, num))
        return
    end
    Player.takeItemByTable(actor, allMaxCost, "体质修炼小神魔一键全满")
    for _, value in ipairs(config) do
        local currLevel = getplaydef(actor, value.bindVar)
        --小于最大等级获得全满，免得被重置！
        if currLevel < value.maxLevel then
            setplaydef(actor, value.bindVar, value.maxLevel)
        end
    end
    Player.sendmsgEx(actor, "恭喜,你的体质修炼全部满级了!")
    Player.setAttList(actor, "属性附加")
    TiZhiXiuLian.giveTitle(actor)
    TiZhiXiuLian.SyncResponse(actor)
end

--全部修炼满级后给予称号！
function TiZhiXiuLian.giveTitle(actor)
    if checktitle(actor, "神魔·大成") then
        return
    end
    local isMax = TiZhiXiuLian.CheckAllMaxLevel(actor)
    if isMax then
        confertitle(actor, "神魔·大成", 1)
        messagebox(actor, "恭喜,你的体质修炼全部满级了,获得称号[神魔·大成]")
        Player.setAttList(actor, "属性附加")
        Player.setAttList(actor, "爆率附加")
        GameEvent.push(EventCfg.onTiZhiXiuLianUP, actor)
        return
    end
end

--检测神魔是否已经全部满级
function TiZhiXiuLian.CheckAllMaxLevel(actor)
    for _, value in ipairs(config) do
        if getplaydef(actor, value.bindVar) < value.maxLevel then
            return false
        end
    end
    return true
end

--注册网络消息
function TiZhiXiuLian.SyncResponse(actor, logindatas)
    local U101 = getplaydef(actor, VarCfg["U_神魔_暴戾一击"])
    local U102 = getplaydef(actor, VarCfg["U_神魔_伤害增幅"])
    local U103 = getplaydef(actor, VarCfg["U_神魔_钢铁之躯"])
    local U104 = getplaydef(actor, VarCfg["U_神魔_削铁如泥"])
    local U105 = getplaydef(actor, VarCfg["U_神魔_血牛达人"])
    local data = { U101, U102, U103, U104, U105 }
    local _login_data = { ssrNetMsgCfg.TiZhiXiuLian_SyncResponse, 0, 0, 0, data }
    if logindatas then
        table.insert(logindatas, _login_data)
    else
        Message.sendmsg(actor, ssrNetMsgCfg.TiZhiXiuLian_SyncResponse, 0, 0, 0, data)
    end
end
Message.RegisterNetMsg(ssrNetMsgCfg.TiZhiXiuLian, TiZhiXiuLian)

--附加属性
local function _onCalcAttr(actor, attrs)
    local shuxing = {}
    for _, value in ipairs(config) do
        local currLevel = getplaydef(actor, value.bindVar)
        if currLevel > 0 then
            shuxing[value.attrID] = currLevel
        end
    end
    calcAtts(attrs, shuxing, "小神魔附加")
end
--属性
GameEvent.add(EventCfg.onCalcAttr, _onCalcAttr, TiZhiXiuLian)

--登录触发
local function _onLoginEnd(actor, logindatas)
    TiZhiXiuLian.SyncResponse(actor, logindatas)
end
GameEvent.add(EventCfg.onLoginEnd, _onLoginEnd, TiZhiXiuLian)

return TiZhiXiuLian

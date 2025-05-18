local ShenMoZhiTi = {}
local config = include("QuestDiary/cfgcsv/cfg_ShenMoZhiTi.lua") --大神魔配置
local success = 50
local allMaxCost = { { "灵符", 2888 } }

--全部点满级
local function steMaxLevel(actor)
    for _, value in ipairs(config) do
        setplaydef(actor, value.bindVar, value.maxLevel)
    end
    Player.sendmsgEx(actor, "恭喜,你的神魔之体全部满级了!")
    Player.setAttList(actor, "属性附加")
    ShenMoZhiTi.giveTitle(actor)
    ShenMoZhiTi.SyncResponse(actor)
end

--满足条件满级
local function checkMaxLevel(actor)
    local  isCanAllMax, name = ShenMoZhiTi.IsCanAllMax(actor)
    if not isCanAllMax then
        messagebox(actor,"你的提升次数已经超过1000次,但你的["..name.."]提升次数不足10,无法全满,请提升到10次以后,再次提升才能全满!")
        return
    end
    Player.sendmsgEx(actor, "恭喜,你的提升次数已经超过1000次,获得神魔全满!")
    steMaxLevel(actor)
end

function ShenMoZhiTi.Request(actor, arg1)
    local cfg = config[arg1]
    if not cfg then
        Player.sendmsgEx(actor, "参数错误1!")
        return
    end
    --当前等级
    local currLevel = getplaydef(actor, cfg.bindVar)
    if currLevel < 10 then
        Player.sendmsgEx(actor, "当前次数小于10次,无法提升,请到一大陆[体质修炼]提升至10次")
        return
    end
    if currLevel >= cfg.maxLevel then
        Player.sendmsgEx(actor, string.format("你的|%s#249|已经达到|%d级#249|了...", cfg.name, cfg.maxLevel))
        return
    end
    local currCount = getplaydef(actor, VarCfg["U_神魔_升级次数"])
    if currCount >= 999 then
        checkMaxLevel(actor)
        return
    end
    
    local name, num = Player.checkItemNumByTable(actor, cfg.cost)
    if name then
        Player.sendmsgEx(actor, string.format("你背包的|%s#249|不足|%d#249|...", name, num))
        return
    end
    if randomex(success) then
        Player.takeItemByTable(actor, cfg.cost, "体质修炼大神魔成功")
        setplaydef(actor, cfg.bindVar, currLevel + 1)
        Player.sendmsgEx(actor, "#255|恭喜,你的|" .. cfg.name .. "#249|达到了|" .. getplaydef(actor, cfg.bindVar) .. "级#249|实力更进一步...")
        ShenMoZhiTi.giveTitle(actor)
        ShenMoZhiTi.SyncResponse(actor)
        Player.setAttList(actor, "属性附加")
    else
        Player.takeItemByTable(actor, cfg.cost, "体质修炼大神魔失败")
        if currLevel <= 10 then
            Player.sendmsgEx(actor, "你的|" .. cfg.name .. "#249|升级|失败#249|材料扣除,由此当前提升次数为10,不扣次数...")
        else
            setplaydef(actor, cfg.bindVar, currLevel - 1)
            Player.sendmsgEx(actor, "你的|" .. cfg.name .. "#249|升级|失败#249|材料扣除,等级-1...")
        end
    end
    setplaydef(actor, VarCfg["U_神魔_升级次数"], getplaydef(actor, VarCfg["U_神魔_升级次数"]) + 1)
    ShenMoZhiTi.SyncResponse(actor)
end

function ShenMoZhiTi.ButtonLink1(actor)
    local  isCanAllMax, name = ShenMoZhiTi.IsCanAllMax(actor)
    if not isCanAllMax then
        Player.sendmsgEx(actor, "全部提升10次以上才可以一键全满...")
        return
    end
    -- if not checktitle(actor,"神魔·大成") then
    --     Player.sendmsgEx(actor, "全部提升|10#249|次以上,并且拥有|神魔·大成#249|称号才可以一键全满...")
    --     return
    -- end
    local isMax = ShenMoZhiTi.CheckAllMaxLevel(actor)
    if isMax then
        Player.sendmsgEx(actor, "你的神魔之体已经全部满级了...")
        return
    end
    local name, num = Player.checkItemNumByTable(actor, allMaxCost)
    if name then
        Player.sendmsgEx(actor, string.format("你的|%s#249|不足|%d#249|...", name, num))
        return
    end
    Player.takeItemByTable(actor, allMaxCost, "神魔之体大神魔一键全满")
    steMaxLevel(actor)
end


--全部修炼满级后给予称号！
function ShenMoZhiTi.giveTitle(actor)
    if checktitle(actor, "神魔·完美") then
        return
    end
    local isMax = ShenMoZhiTi.CheckAllMaxLevel(actor)
    if isMax then
        deprivetitle(actor, "神魔·大成")
        confertitle(actor, "神魔·完美", 1)
        Player.setAttList(actor, "攻速附加")
        messagebox(actor, "恭喜,你的神魔之体全部满级了,获得称号[神魔·完美]")
        return
    end
end


--检测神魔是否已经全部满级
function ShenMoZhiTi.CheckAllMaxLevel(actor)
    for _, value in ipairs(config) do
        if getplaydef(actor, value.bindVar) < value.maxLevel then
            return false
        end
    end
    return true
end

--检测是否符合一键全满
--可以返回true
function ShenMoZhiTi.IsCanAllMax(actor)
    for _, value in ipairs(config) do
        if getplaydef(actor, value.bindVar) < 10 then
            return false,value.name
        end
    end
    return true,""
end


local function _onCalcAttackSpeed(actor, attackSpeeds)
    if checktitle(actor,"神魔·完美") then
        attackSpeeds[1] = attackSpeeds[1] + 20
    end
end
GameEvent.add(EventCfg.onCalcAttackSpeed, _onCalcAttackSpeed, ShenMoZhiTi)




--注册网络消息
Message.RegisterNetMsg(ssrNetMsgCfg.ShenMoZhiTi, ShenMoZhiTi)

function ShenMoZhiTi.SyncResponse(actor, logindatas)
    local U101 = getplaydef(actor,VarCfg["U_神魔_暴戾一击"])
    local U102 = getplaydef(actor,VarCfg["U_神魔_伤害增幅"])
    local U103 = getplaydef(actor,VarCfg["U_神魔_钢铁之躯"])
    local U104 = getplaydef(actor,VarCfg["U_神魔_削铁如泥"])
    local U105 = getplaydef(actor,VarCfg["U_神魔_血牛达人"])
    local U100 = getplaydef(actor,VarCfg["U_神魔_升级次数"])

    local data = {U101,U102,U103,U104,U105}

    local _login_data = {ssrNetMsgCfg.ShenMoZhiTi_SyncResponse, U100, 0, 0, data}
    if logindatas then
        table.insert(logindatas, _login_data)
    else
        Message.sendmsg(actor, ssrNetMsgCfg.ShenMoZhiTi_SyncResponse, U100, 0, 0, data)
    end
end

--登录触发
local function _onLoginEnd(actor, logindatas)
    ShenMoZhiTi.SyncResponse(actor, logindatas)
end
GameEvent.add(EventCfg.onLoginEnd, _onLoginEnd, ShenMoZhiTi)

return ShenMoZhiTi

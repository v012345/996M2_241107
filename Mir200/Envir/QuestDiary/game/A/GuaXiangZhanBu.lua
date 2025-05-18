local GuaXiangZhanBu = {}
local config = { "初窥天机", "通灵神眼", "天机尊者", "命运掌控", "玄秘宗师" }
local cost = { { "灵符", 100 } }
local function DeleteAllTitle(actor)
    for index, value in ipairs(config) do
        deprivetitle(actor, value)
    end
end

function GuaXiangZhanBu.Request(actor)
    -- deprivetitle(actor, "玄秘宗师")
    if checktitle(actor, "玄秘宗师") then
        Player.sendmsgEx(actor, "你已经拥有最高等级的[玄秘宗师]称号,无法继续占卜!#249")
        return
    end
    local buGuaCount = getplaydef(actor, VarCfg["U_占卜次数"])
    local weight = ""
    --20次以下不出5
    if buGuaCount < 20 then
        weight = "1#30|2#30|3#20|4#15"
    else
        weight = "1#30|2#30|3#20|4#20|5#5"
    end
    local randomNum = ransjstr(weight, 1, 3)
    randomNum = tonumber(randomNum)
    if buGuaCount >= 65 then
        randomNum = 5
    end
    local cfg = config[randomNum]
    if not cfg then
        Player.sendmsgEx(actor, "参数错误!#249")
        return
    end
    local name, num = Player.checkItemNumByTable(actor, cost)
    if name then
        Player.sendmsgEx(actor, string.format("你的|%s#249|不足|%d#249", name, num))
        return
    end
    Player.takeItemByTable(actor, cost, "占卜")
    DeleteAllTitle(actor)
    local titileName = cfg
    confertitle(actor, titileName)
    Player.setAttList(actor, "属性附加")
    Player.setAttList(actor, "爆率附加")
    Player.setAttList(actor, "攻速附加")
    setplaydef(actor, VarCfg["U_占卜次数"], buGuaCount + 1)
    Player.sendmsgEx(actor, string.format("你获得了|%s#249", titileName))

    GuaXiangZhanBu.SyncResponse(actor)
end

--同步消息
function GuaXiangZhanBu.SyncResponse(actor, logindatas)
    local buGuaCount = getplaydef(actor, VarCfg["U_占卜次数"])
    local _login_data = { ssrNetMsgCfg.GuaXiangZhanBu_SyncResponse, buGuaCount, 0, 0, {} }
    if logindatas then
        table.insert(logindatas, _login_data)
    else
        Message.sendmsg(actor, ssrNetMsgCfg.GuaXiangZhanBu_SyncResponse, buGuaCount, 0, 0, {})
    end
end

local function _onCalcAttackSpeed(actor, attackSpeeds)
    if checktitle(actor, "命运掌控") then
        attackSpeeds[1] = attackSpeeds[1] + 25
    elseif checktitle(actor, "玄秘宗师") then
        attackSpeeds[1] = attackSpeeds[1] + 50
    end
end

GameEvent.add(EventCfg.onCalcAttackSpeed, _onCalcAttackSpeed, GuaXiangZhanBu)


local function _onLoginEnd(actor, logindatas)
    GuaXiangZhanBu.SyncResponse(actor, logindatas)
end
--事件派发
GameEvent.add(EventCfg.onLoginEnd, _onLoginEnd, GuaXiangZhanBu)


-- VarCfg["F_天命_祝福之体标识"]
local function _onCalcAttr(actor, attrs)
    if getflagstatus(actor, VarCfg["F_天命_祝福之体标识"]) == 1 then
        local shuxing = {}
        local buGuaCount = getplaydef(actor, VarCfg["U_占卜次数"])
        if buGuaCount > 0 then
            if buGuaCount > 10 then
                buGuaCount = 10
            end
            local addtion = buGuaCount * 20
            shuxing[3] = addtion
            shuxing[4] = addtion
            shuxing[5] = addtion
            shuxing[6] = addtion
            shuxing[7] = addtion
            shuxing[8] = addtion
            calcAtts(attrs, shuxing, "占卜祝福之体")
        end
    end
end

--属性
GameEvent.add(EventCfg.onCalcAttr, _onCalcAttr, GuaXiangZhanBu)

--注册
Message.RegisterNetMsg(ssrNetMsgCfg.GuaXiangZhanBu, GuaXiangZhanBu)
return GuaXiangZhanBu

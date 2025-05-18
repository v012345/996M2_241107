local QiYuShiJian10 = {}
local cost = { { "灵符", 2000 } }
function QiYuShiJian10.Request(actor)
    local skillinfo = getskillinfo(actor, 2017, 1)
    local skillinfoUp = getskillinfo(actor, 2019, 1)
    ----------------验证奇遇----------------
    local verify = getplaydef(actor,VarCfg["S$奇遇事件10"])
    if verify ~= "老乞丐" then
        Player.sendmsgEx(actor, "提示#251|:#255|非法请求#249|")
        return
    end
    ----------------验证奇遇----------------

    if skillinfo == 3 then
        Player.sendmsgEx(actor, "提示#251|:#255|你已练习|如来神掌#249|请勿重复练习...")
        return
    end
    if skillinfoUp then
        Player.sendmsgEx(actor, "提示#251|:#255|你已练习|大日如来神掌#249|请勿重复练习...")
        return
    end
    if verify == "老乞丐" then
        local name, num = Player.checkItemNumByTable(actor, cost)
        if name then
            Player.sendmsgEx(actor, string.format("提示#251|:#255|你的|%s#249|不足|%d#249|...", name, num))
            return
        end
        Player.takeItemByTable(actor, cost, "如来神掌")
        addskill(actor, 2017, 3)
        setplaydef(actor, VarCfg["S$奇遇事件10"], "")
        Player.sendmsgEx(actor, "提示#251|:#255|恭喜你,学会|斩怪#249|神级|如来神掌#249|...")
    end
end

--攻击触发
local function _onAttackMonster(actor, Target, Hiter, MagicId, qieGe)
    if randomex(3, 100) then
        if getskilllevel(actor, 2017) == 3 then
            local x = getbaseinfo(Target, ConstCfg.gbase.x)
            local y = getbaseinfo(Target, ConstCfg.gbase.y)
            rangeharm(actor, x, y, 0, 0, 6, Player.getHpValue(Target, 1), 0, 2,63069)
        end
    end
end
GameEvent.add(EventCfg.onAttackMonster, _onAttackMonster, QiYuShiJian10)

function QiYuShiJian10.CloseUI(actor)
    ----------------验证奇遇----------------
    local verify = getplaydef(actor,VarCfg["S$奇遇事件10"])
    if verify ~= "老乞丐" then
        Player.sendmsgEx(actor, "提示#251|:#255|非法请求#249|")
        return
    end
    ----------------验证奇遇----------------
    QiYuHeZi.ClientAddEvent(actor,verify)
    setplaydef(actor,VarCfg["S$奇遇事件10"],"")
end

--触发事件后 初始变量
local function _LuckyEventinitVar(actor, LuckyEventName)
    if LuckyEventName == "老乞丐" then
        setplaydef(actor, VarCfg["S$奇遇事件10"], "老乞丐" )
    end
end
GameEvent.add(EventCfg.LuckyEventinitVar, _LuckyEventinitVar, QiYuShiJian10)

--注册网络消息
Message.RegisterNetMsg(ssrNetMsgCfg.QiYuShiJian10, QiYuShiJian10)

return QiYuShiJian10

local QiYuShiJian06 = {}


function QiYuShiJian06.Request(actor, arg1)
    ----------------验证奇遇----------------
    local verify = getplaydef(actor,VarCfg["S$奇遇事件6"])
    if verify ~= "技术大神的电脑" then
        Player.sendmsgEx(actor, "提示#251|:#255|非法请求#249|")
        return
    end
    ----------------验证奇遇----------------

    if arg1 == 1 then
        if verify == "技术大神的电脑" then
            addbuff(actor, 31006, 1800, 1, actor)
            Player.sendmsgEx(actor, "提示#251|:#255|攻击速度怎加|30%#249|,持续|1800#249|秒...")
            setplaydef(actor, VarCfg["S$奇遇事件6"], "")
            Player.setAttList(actor, "攻速附加")
        end
    elseif arg1 == 2 then
        if verify == "技术大神的电脑" then
            changespeed(actor, 1, 1)
            addbuff(actor, 31007, 1800, 1, actor)
            Player.sendmsgEx(actor, "提示#251|:#255|移动速度增加|5%#249|,持续|1800#249|秒...")
            setplaydef(actor, VarCfg["S$奇遇事件6"], "")
        end
    elseif arg1 == 3 then
        if verify == "技术大神的电脑" then
            addbuff(actor, 31008, 1800, 1, actor)
            Player.sendmsgEx(actor, "提示#251|:#255|攻击伤害怎加|10%#249|,持续|1800#249|秒...")
            setplaydef(actor, VarCfg["S$奇遇事件6"], "")
        end
    end
end

function QiYuShiJian06.CloseUI(actor)
    ----------------验证奇遇----------------
    local verify = getplaydef(actor,VarCfg["S$奇遇事件6"])
    if verify ~= "技术大神的电脑" then
        Player.sendmsgEx(actor, "提示#251|:#255|非法请求#249|")
        return
    end
    ----------------验证奇遇----------------
    QiYuHeZi.ClientAddEvent(actor,verify)
    setplaydef(actor,VarCfg["S$奇遇事件6"],"")
end

--触发事件后 初始变量
local function _LuckyEventinitVar(actor, LuckyEventName)
    if LuckyEventName == "技术大神的电脑" then
        setplaydef(actor, VarCfg["S$奇遇事件6"], "技术大神的电脑" )
    end
end
GameEvent.add(EventCfg.LuckyEventinitVar, _LuckyEventinitVar, QiYuShiJian06)



--注册网络消息
Message.RegisterNetMsg(ssrNetMsgCfg.QiYuShiJian06, QiYuShiJian06)

--增加攻击速度
local function _onCalcAttackSpeed(actor, attackSpeeds)
    local buff = hasbuff(actor, 31006)
    if buff then
        attackSpeeds[1] = attackSpeeds[1] + 30
    end
end
GameEvent.add(EventCfg.onCalcAttackSpeed, _onCalcAttackSpeed, QiYuShiJian06)

--buuf删除触发
local function _onBuffChange(actor, buffid, groupid, model)
    if buffid ==  31006 then
        if model == 4 then
            Player.setAttList(actor, "攻速附加")
        end
    end
    if buffid ==  31007 then
        if model == 4 then
            changespeed(actor, 1, 0)
        end
    end

end
GameEvent.add(EventCfg.onBuffChange, _onBuffChange, QiYuShiJian06)

return QiYuShiJian06

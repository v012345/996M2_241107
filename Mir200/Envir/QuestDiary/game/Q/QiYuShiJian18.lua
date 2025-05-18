local QiYuShiJian18 = {}


function QiYuShiJian18.Request(actor, arg1)
    ----------------验证奇遇----------------
    local verify = getplaydef(actor,VarCfg["S$奇遇事件18"])
    if verify ~= "未知的洞窟" then
        Player.sendmsgEx(actor, "提示#251|:#255|非法请求#249|")
        return
    end
    ----------------验证奇遇----------------

    if arg1 == 1 then
        if verify == "未知的洞窟" then
            local UserId = getconst(actor, "<$USERID>")
            sendmail(UserId, 5001, "未知的洞窟", "恭喜你获得灵石x3","灵石#3")
            Player.sendmsgEx(actor, "提示#251|:#255|恭喜你,获得|灵石#249|x3...")
            setplaydef(actor, VarCfg["S$奇遇事件18"], "")
        end
    elseif arg1 == 2 then
        if verify == "未知的洞窟" then
            local num = getplaydef(actor, VarCfg["S$修仙经验"])
            XiuXian.addXiuXian(actor, 100)
            Player.sendmsgEx(actor, "提示#251|:#255|恭喜你,获得|100#249|点,修仙经验...")
            setplaydef(actor, VarCfg["S$奇遇事件18"], "")
        end
    end
end


function QiYuShiJian18.CloseUI(actor)
    ----------------验证奇遇----------------
    local verify = getplaydef(actor,VarCfg["S$奇遇事件18"])
    if verify ~= "未知的洞窟" then
        Player.sendmsgEx(actor, "提示#251|:#255|非法请求#249|")
        return
    end
    ----------------验证奇遇----------------
    QiYuHeZi.ClientAddEvent(actor,verify)
    setplaydef(actor,VarCfg["S$奇遇事件18"],"")
end

--触发事件后 初始变量
local function _LuckyEventinitVar(actor, LuckyEventName)
    if LuckyEventName == "未知的洞窟" then
        setplaydef(actor, VarCfg["S$奇遇事件18"], "未知的洞窟")
    end
end
GameEvent.add(EventCfg.LuckyEventinitVar, _LuckyEventinitVar, QiYuShiJian18)


--注册网络消息
Message.RegisterNetMsg(ssrNetMsgCfg.QiYuShiJian18, QiYuShiJian18)


return QiYuShiJian18

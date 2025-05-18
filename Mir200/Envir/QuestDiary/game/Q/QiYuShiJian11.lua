local QiYuShiJian11 = {}

function QiYuShiJian11.Request(actor, arg1)
    ----------------验证奇遇----------------
    local verify = getplaydef(actor,VarCfg["S$奇遇事件11"])
    if verify ~= "腐化符文" then
        Player.sendmsgEx(actor, "提示#251|:#255|非法请求#249|")
        return
    end
    ----------------验证奇遇----------------

    if arg1 == 1 then
        if verify == "腐化符文" then
            changeexp(actor, "+", 50000000, false)
            Player.sendmsgEx(actor, "提示#251|:#255|恭喜你,获得|5000万#249|点经验...")
            setplaydef(actor, VarCfg["S$奇遇事件11"], "")
        end
    elseif arg1 == 2 then
        if verify == "腐化符文" then
            addbuff(actor, 31014, 1800, 1, actor)
            Player.sendmsgEx(actor, "提示#251|:#255|经验加成增加|20%#249|,持续|1800#249|秒...")
            setplaydef(actor, VarCfg["S$奇遇事件11"], "")
        end
    end
end


function QiYuShiJian11.CloseUI(actor)
    ----------------验证奇遇----------------
    local verify = getplaydef(actor,VarCfg["S$奇遇事件11"])
    if verify ~= "腐化符文" then
        Player.sendmsgEx(actor, "提示#251|:#255|非法请求#249|")
        return
    end
    ----------------验证奇遇----------------
    QiYuHeZi.ClientAddEvent(actor,verify)
    setplaydef(actor,VarCfg["S$奇遇事件11"],"")
end

--触发事件后 初始变量
local function _LuckyEventinitVar(actor, LuckyEventName)
    if LuckyEventName == "腐化符文" then
        setplaydef(actor, VarCfg["S$奇遇事件11"], "腐化符文" )
    end
end
GameEvent.add(EventCfg.LuckyEventinitVar, _LuckyEventinitVar, QiYuShiJian11)


--注册网络消息
Message.RegisterNetMsg(ssrNetMsgCfg.QiYuShiJian11, QiYuShiJian11)

return QiYuShiJian11

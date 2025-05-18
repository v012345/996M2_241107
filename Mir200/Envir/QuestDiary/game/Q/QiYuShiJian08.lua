local QiYuShiJian08 = {}
function QiYuShiJian08.Request(actor)
    ----------------验证奇遇----------------
    local verify = getplaydef(actor,VarCfg["S$奇遇事件8"])
    if verify ~= "无主的宝箱" then
        Player.sendmsgEx(actor, "提示#251|:#255|非法请求#249|")
        return
    end
    ----------------验证奇遇----------------
    if verify == "无主的宝箱" then
        local UserId = getconst(actor, "<$USERID>")
        sendmail(UserId, 5001, "无主的宝箱", "恭喜你获[无主的宝箱]x1","无主的宝箱#1")
        Player.sendmsgEx(actor, "提示#251|:#255|恭喜你,获得|无主的宝箱x1#249|...")
        setplaydef(actor, VarCfg["S$奇遇事件8"], "")
    end
end


function QiYuShiJian08.CloseUI(actor)
    ----------------验证奇遇----------------
    local verify = getplaydef(actor,VarCfg["S$奇遇事件8"])
    if verify ~= "无主的宝箱" then
        Player.sendmsgEx(actor, "提示#251|:#255|非法请求#249|")
        return
    end
    ----------------验证奇遇----------------
    QiYuHeZi.ClientAddEvent(actor,verify)
    setplaydef(actor,VarCfg["S$奇遇事件8"],"")
end

--触发事件后 初始变量
local function _LuckyEventinitVar(actor, LuckyEventName)
    if LuckyEventName == "无主的宝箱" then
        setplaydef(actor, VarCfg["S$奇遇事件8"], "无主的宝箱" )
    end
end
GameEvent.add(EventCfg.LuckyEventinitVar, _LuckyEventinitVar, QiYuShiJian08)

--注册网络消息
Message.RegisterNetMsg(ssrNetMsgCfg.QiYuShiJian08, QiYuShiJian08)

return QiYuShiJian08

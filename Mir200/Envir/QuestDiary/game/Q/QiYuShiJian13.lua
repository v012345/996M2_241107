local QiYuShiJian13 = {}



function QiYuShiJian13.Request(actor, arg1)
    ----------------验证奇遇----------------
    local verify = getplaydef(actor,VarCfg["S$奇遇事件13"])
    if verify ~= "诅咒的宝箱" then
        Player.sendmsgEx(actor, "提示#251|:#255|非法请求#249|")
        return
    end
    ----------------验证奇遇----------------
    if arg1 == 1 then
        if verify == "诅咒的宝箱" then
            addbuff(actor, 31017, 1800, 1, actor)
            Player.sendmsgEx(actor, "提示#251|:#255|你受到了宝箱的诅咒...")
            setplaydef(actor, VarCfg["S$奇遇事件13"], "")
        end
    elseif arg1 == 2 then
        if verify == "诅咒的宝箱" then
            local UserId = getconst(actor, "<$USERID>")
            sendmail(UserId, 5001, "诅咒的宝箱", "恭喜你获得100万金币","绑定金币#1000000")
            Player.sendmsgEx(actor, "提示#251|:#255|恭喜你,获得|100万#249|金币...")
            setplaydef(actor, VarCfg["S$奇遇事件13"], "")
        end
    end
end


function QiYuShiJian13.CloseUI(actor)
    ----------------验证奇遇----------------
    local verify = getplaydef(actor,VarCfg["S$奇遇事件13"])
    if verify ~= "诅咒的宝箱" then
        Player.sendmsgEx(actor, "提示#251|:#255|非法请求#249|")
        return
    end
    ----------------验证奇遇----------------
    QiYuHeZi.ClientAddEvent(actor,verify)
    setplaydef(actor,VarCfg["S$奇遇事件13"],"")
end

--触发事件后 初始变量
local function _LuckyEventinitVar(actor, LuckyEventName)
    if LuckyEventName == "诅咒的宝箱" then
        setplaydef(actor, VarCfg["S$奇遇事件13"], "诅咒的宝箱")
    end
end
GameEvent.add(EventCfg.LuckyEventinitVar, _LuckyEventinitVar, QiYuShiJian13)


--注册网络消息
Message.RegisterNetMsg(ssrNetMsgCfg.QiYuShiJian13, QiYuShiJian13)

return QiYuShiJian13

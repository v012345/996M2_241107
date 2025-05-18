local QiYuShiJian01 = {}


function QiYuShiJian01.Request(actor, arg1)
    ----------------验证奇遇----------------
    local verify = getplaydef(actor,VarCfg["S$奇遇事件1"])
    if verify ~= "巨龙幼崽" then
        Player.sendmsgEx(actor, "提示#251|:#255|非法请求#249|")
        return
    end
    ----------------验证奇遇----------------
    if arg1 == 1 then
        if verify == "巨龙幼崽" then
            local UserId = getconst(actor, "<$USERID>")
            sendmail(UserId, 5001, "巨龙幼崽", "恭喜你获得10万金币","绑定金币#100000")
            Player.sendmsgEx(actor, "提示#251|:#255|恭喜你,获得|10万#249|金币...")
            setplaydef(actor, VarCfg["S$奇遇事件1"], "")
        end
    elseif arg1 == 2 then
        if verify == "巨龙幼崽" then
            addbuff(actor, 31001, 3600, 1, actor)
            Player.sendmsgEx(actor, "提示#251|:#255|切割增加|2222#249|点,持续|3600#249|秒...")
            setplaydef(actor, VarCfg["S$奇遇事件1"], "")
        end
    end
end

function QiYuShiJian01.CloseUI(actor)
    ----------------验证奇遇----------------
    local verify = getplaydef(actor,VarCfg["S$奇遇事件1"])
    if verify ~= "巨龙幼崽" then
        Player.sendmsgEx(actor, "提示#251|:#255|非法请求#249|")
        return
    end
    ----------------验证奇遇----------------
    QiYuHeZi.ClientAddEvent(actor,verify)
    setplaydef(actor,VarCfg["S$奇遇事件1"],"")
end

--触发事件后 初始变量
local function _LuckyEventinitVar(actor, LuckyEventName)
    if LuckyEventName == "巨龙幼崽" then
        setplaydef(actor, VarCfg["S$奇遇事件1"], "巨龙幼崽" )
    end
end
GameEvent.add(EventCfg.LuckyEventinitVar, _LuckyEventinitVar, QiYuShiJian01)

--注册网络消息
Message.RegisterNetMsg(ssrNetMsgCfg.QiYuShiJian01, QiYuShiJian01)

return QiYuShiJian01

local QiYuShiJian14 = {}

function QiYuShiJian14.Request(actor, arg1)
    ----------------验证奇遇----------------
    local verify = getplaydef(actor,VarCfg["S$奇遇事件14"])
    if verify ~= "遗落的祭坛" then
        Player.sendmsgEx(actor, "提示#251|:#255|非法请求#249|")
        return
    end
    ----------------验证奇遇----------------
    if arg1 == 1 then
        if verify == "遗落的祭坛" then
            addbuff(actor, 31018, 1800, 1, actor)
            Player.sendmsgEx(actor, "提示#251|:#255|恭喜你,获得|天界的恩赐#249|Buff...")
            setplaydef(actor, VarCfg["S$奇遇事件14"], "")
        end
    elseif arg1 == 2 then
        if verify == "遗落的祭坛" then
            local UserId = getconst(actor, "<$USERID>")
            sendmail(UserId, 5001, "遗落的祭坛", "恭喜你获得1万元宝","元宝#10000")
            Player.sendmsgEx(actor, "提示#251|:#255|恭喜你,获得|1万#249|元宝并受到|天界的降罚#249|伤害...")
            addbuff(actor, 31019, 9, 1, actor)
            setplaydef(actor, VarCfg["S$奇遇事件14"], "")
        end
    end
end


function QiYuShiJian14.CloseUI(actor)
    ----------------验证奇遇----------------
    local verify = getplaydef(actor,VarCfg["S$奇遇事件14"])
    if verify ~= "遗落的祭坛" then
        Player.sendmsgEx(actor, "提示#251|:#255|非法请求#249|")
        return
    end
    ----------------验证奇遇----------------
    QiYuHeZi.ClientAddEvent(actor,verify)
    setplaydef(actor,VarCfg["S$奇遇事件14"],"")
end

--触发事件后 初始变量
local function _LuckyEventinitVar(actor, LuckyEventName)
    if LuckyEventName == "遗落的祭坛" then
        setplaydef(actor, VarCfg["S$奇遇事件14"], "遗落的祭坛")
    end
end
GameEvent.add(EventCfg.LuckyEventinitVar, _LuckyEventinitVar, QiYuShiJian14)


--注册网络消息
Message.RegisterNetMsg(ssrNetMsgCfg.QiYuShiJian14, QiYuShiJian14)

return QiYuShiJian14

local QiYuShiJian09 = {}

function QiYuShiJian09.Request(actor, arg1)
    ----------------验证奇遇----------------
    local verify = getplaydef(actor,VarCfg["S$奇遇事件9"])
    if verify ~= "美女出浴" then
        Player.sendmsgEx(actor, "提示#251|:#255|非法请求#249|")
        return
    end
    ----------------验证奇遇----------------
    if arg1 == 1 then
        if verify == "美女出浴" then
            addbuff(actor, 31011, 1800, 1, actor)
            Player.sendmsgEx(actor, "提示#251|:#255|暴击几率增加|5%#249|点,持续|3600#249|秒...")
            setplaydef(actor, VarCfg["S$奇遇事件9"], "")
        end
    elseif arg1 == 2 then
        if verify == "美女出浴" then
            addbuff(actor, 31012, 1800, 1, actor)
            Player.sendmsgEx(actor, "提示#251|:#255|最大生命上限增加|5%#249|,持续|1800#249|秒...")
            setplaydef(actor, VarCfg["S$奇遇事件9"], "")
        end
    end

end

function QiYuShiJian09.CloseUI(actor)
    ----------------验证奇遇----------------
    local verify = getplaydef(actor,VarCfg["S$奇遇事件9"])
    if verify ~= "美女出浴" then
        Player.sendmsgEx(actor, "提示#251|:#255|非法请求#249|")
        return
    end
    ----------------验证奇遇----------------
    QiYuHeZi.ClientAddEvent(actor,verify)
    setplaydef(actor,VarCfg["S$奇遇事件9"],"")
end

--触发事件后 初始变量
local function _LuckyEventinitVar(actor, LuckyEventName)
    if LuckyEventName == "美女出浴" then
        setplaydef(actor, VarCfg["S$奇遇事件9"], "美女出浴" )
    end
end
GameEvent.add(EventCfg.LuckyEventinitVar, _LuckyEventinitVar, QiYuShiJian09)


--注册网络消息
Message.RegisterNetMsg(ssrNetMsgCfg.QiYuShiJian09, QiYuShiJian09)

return QiYuShiJian09

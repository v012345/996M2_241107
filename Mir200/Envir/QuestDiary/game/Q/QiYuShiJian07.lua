local QiYuShiJian07 = {}


function QiYuShiJian07.Request(actor, arg1)
    ----------------验证奇遇----------------
    local verify = getplaydef(actor,VarCfg["S$奇遇事件7"])
    if verify ~= "老G的老舅" then
        Player.sendmsgEx(actor, "提示#251|:#255|非法请求#249|")
        return
    end
    ----------------验证奇遇----------------
    if arg1 == 1 then
        if verify == "老G的老舅" then
            addbuff(actor, 31009, 1800, 1, actor)
            Player.sendmsgEx(actor, "提示#251|:#255|切割增加|1000#249|点,持续|1800#249|秒...")
            setplaydef(actor, VarCfg["S$奇遇事件7"], "")
            Player.setAttList(actor, "属性附加")
        end
    elseif arg1 == 2 then
        if verify == "老G的老舅" then
            addbuff(actor, 31010, 1800, 1, actor)
            Player.sendmsgEx(actor, "提示#251|:#255|爆率增加|20%#249|,持续|1800#249|秒...")
            setplaydef(actor, VarCfg["S$奇遇事件7"], "")
            Player.setAttList(actor, "爆率附加")
        end
    end
end

local function _onBuffChange(actor, buffid, groupid, model)
    if buffid ==  31009 then
        if model == 4 then
            Player.setAttList(actor, "属性附加")
        end
    end
    if buffid ==  31010 then
        if model == 4 then
            Player.setAttList(actor, "爆率附加")
        end
    end
end
GameEvent.add(EventCfg.onBuffChange, _onBuffChange, QiYuShiJian07)



function QiYuShiJian07.CloseUI(actor)
    ----------------验证奇遇----------------
    local verify = getplaydef(actor,VarCfg["S$奇遇事件7"])
    if verify ~= "老G的老舅" then
        Player.sendmsgEx(actor, "提示#251|:#255|非法请求#249|")
        return
    end
    ----------------验证奇遇----------------
    QiYuHeZi.ClientAddEvent(actor,verify)
    setplaydef(actor,VarCfg["S$奇遇事件7"],"")
end

--触发事件后 初始变量
local function _LuckyEventinitVar(actor, LuckyEventName)
    if LuckyEventName == "老G的老舅" then
        setplaydef(actor, VarCfg["S$奇遇事件7"], "老G的老舅" )
    end
end
GameEvent.add(EventCfg.LuckyEventinitVar, _LuckyEventinitVar, QiYuShiJian07)


--注册网络消息
Message.RegisterNetMsg(ssrNetMsgCfg.QiYuShiJian07, QiYuShiJian07)

return QiYuShiJian07

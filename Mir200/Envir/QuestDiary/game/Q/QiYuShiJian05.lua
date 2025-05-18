local QiYuShiJian05 = {}

function QiYuShiJian05.Request(actor, arg1)
    ----------------验证奇遇----------------
    local verify = getplaydef(actor,VarCfg["S$奇遇事件5"])
    if verify ~= "狗策划的手机" then
        Player.sendmsgEx(actor, "提示#251|:#255|非法请求#249|")
        return
    end
    ----------------验证奇遇----------------

    if arg1 == 1 then
        if verify == "狗策划的手机" then
            addbuff(actor, 31003, 3600, 1, actor)
            Player.sendmsgEx(actor, "提示#251|:#255|切割增加|2222#249|点,持续|3600#249|秒...")
            setplaydef(actor, VarCfg["S$奇遇事件5"], "")
            Player.setAttList(actor, "属性附加")
        end
    elseif arg1 == 2 then
        if verify == "狗策划的手机" then
            addbuff(actor, 31004, 3600, 1, actor)
            Player.sendmsgEx(actor, "提示#251|:#255|爆率增加|20%#249|,持续|3600#249|秒...")
            setplaydef(actor, VarCfg["S$奇遇事件5"], "")
            Player.setAttList(actor, "爆率附加")
        end
    elseif arg1 == 3 then
        if verify == "狗策划的手机" then
            addbuff(actor, 31005, 3600, 1, actor)
            Player.sendmsgEx(actor, "提示#251|:#255|经验增加|20%#249|,持续|3600#249|秒...")
            setplaydef(actor, VarCfg["S$奇遇事件5"], "")
        end
    end
end

--buuf删除触发
local function _onBuffChange(actor, buffid, groupid, model)
    if buffid ==  31003 then
        if model == 4 then
            Player.setAttList(actor, "属性附加")
        end
    end
    if buffid ==  31004 then
        if model == 4 then
            Player.setAttList(actor, "爆率附加")
        end
    end
end
GameEvent.add(EventCfg.onBuffChange, _onBuffChange, QiYuShiJian05)

function QiYuShiJian05.CloseUI(actor)
    ----------------验证奇遇----------------
    local verify = getplaydef(actor,VarCfg["S$奇遇事件5"])
    if verify ~= "狗策划的手机" then
        Player.sendmsgEx(actor, "提示#251|:#255|非法请求#249|")
        return
    end
    ----------------验证奇遇----------------
    QiYuHeZi.ClientAddEvent(actor,verify)
    setplaydef(actor,VarCfg["S$奇遇事件5"],"")
end

--触发事件后 初始变量
local function _LuckyEventinitVar(actor, LuckyEventName)
    if LuckyEventName == "狗策划的手机" then
        setplaydef(actor, VarCfg["S$奇遇事件5"], "狗策划的手机" )
    end
end
GameEvent.add(EventCfg.LuckyEventinitVar, _LuckyEventinitVar, QiYuShiJian05)




--注册网络消息
Message.RegisterNetMsg(ssrNetMsgCfg.QiYuShiJian05, QiYuShiJian05)

return QiYuShiJian05

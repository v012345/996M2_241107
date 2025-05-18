local QiYuShiJian03 = {}

function QiYuShiJian03.Request(actor, arg1)
    ----------------验证奇遇----------------
    local verify = getplaydef(actor,VarCfg["S$奇遇事件3"])
    if verify ~= "邪恶秘籍" then
        Player.sendmsgEx(actor, "提示#251|:#255|非法请求#249|")
        return
    end
    ----------------验证奇遇----------------
    if arg1 == 1 then
        if verify == "邪恶秘籍" then
            local UserId = getconst(actor, "<$USERID>")
            sendmail(UserId, 5001, "邪恶秘籍", "恭喜你获得书页x3","书页#3")
            Player.sendmsgEx(actor, "提示#251|:#255|恭喜你,获得|书页#249|x3...")
            setplaydef(actor, VarCfg["S$奇遇事件3"], "")
        end
    elseif arg1 == 2 then
        if verify == "邪恶秘籍" then
            addbuff(actor, 31002, 1800, 1, actor)
            Player.setAttList(actor, "技能威力")
            Player.sendmsgEx(actor, "提示#251|:#255|全技能威力|+10%#249|点,持续|1800#249|秒...")
            setplaydef(actor, VarCfg["S$奇遇事件3"], "")
        end
    end
end

--计算属性触发
local function _onAddSkillPower(actor, attrs)
    --计算属性累加
    local shuxing = {}
    local buff = hasbuff(actor, 31002)
    if buff then
        shuxing["烈火剑法"] = 10
        shuxing["开天斩"] = 10
        shuxing["逐日剑法"] = 10
    end
    calcAtts(attrs, shuxing, "奇遇技能威力计算")
end
GameEvent.add(EventCfg.onAddSkillPower, _onAddSkillPower, QiYuShiJian03)

--buuf删除触发
local function _onBuffChange(actor, buffid, groupid, model)
    if buffid ==  31002 then
        if model == 4 then
            Player.setAttList(actor, "技能威力")
        end
    end
end
GameEvent.add(EventCfg.onBuffChange, _onBuffChange, QiYuShiJian03)


function QiYuShiJian03.CloseUI(actor)
    ----------------验证奇遇----------------
    local verify = getplaydef(actor,VarCfg["S$奇遇事件3"])
    if verify ~= "邪恶秘籍" then
        Player.sendmsgEx(actor, "提示#251|:#255|非法请求#249|")
        return
    end
    ----------------验证奇遇----------------
    QiYuHeZi.ClientAddEvent(actor,verify)
    setplaydef(actor,VarCfg["S$奇遇事件3"],"")
end

--触发事件后 初始变量
local function _LuckyEventinitVar(actor, LuckyEventName)
    if LuckyEventName == "邪恶秘籍" then
        setplaydef(actor, VarCfg["S$奇遇事件3"], "邪恶秘籍" )
    end
end
GameEvent.add(EventCfg.LuckyEventinitVar, _LuckyEventinitVar, QiYuShiJian03)

--注册网络消息
Message.RegisterNetMsg(ssrNetMsgCfg.QiYuShiJian03, QiYuShiJian03)

return QiYuShiJian03

local QiYuShiJian12 = {}


function QiYuShiJian12.Request(actor, arg1)
    ----------------验证奇遇----------------
    local verify = getplaydef(actor,VarCfg["S$奇遇事件12"])
    if verify ~= "契约" then
        Player.sendmsgEx(actor, "提示#251|:#255|非法请求#249|")
        return
    end
    ----------------验证奇遇----------------
    if arg1 == 1 then
        if verify == "契约" then
            addbuff(actor, 31015, 1800, 1, actor)
            Player.setAttList(actor, "爆率附加")
            Player.sendmsgEx(actor, "提示#251|:#255|恭喜你,获得|神圣契约#249|Buff...")
            setplaydef(actor, VarCfg["S$奇遇事件12"], "")
        end
    elseif arg1 == 2 then
        if verify == "契约" then
            addbuff(actor, 31016, 1800, 1, actor)
            Player.setAttList(actor, "爆率附加")
            Player.sendmsgEx(actor, "提示#251|:#255|恭喜你,获得|恶魔契约#249|Buff...")
            setplaydef(actor, VarCfg["S$奇遇事件12"], "")
        end
    end
end

--攻击怪物前触发
local function _onAttackDamageMonster(actor, Target, Hiter, MagicId, Damage, Model, attackDamageData)
    local buff1 = hasbuff(actor, 31015)
    if buff1 then
        attackDamageData.damage = attackDamageData.damage - math.floor(Damage * 0.2)
    end

    local buff2 = hasbuff(actor, 31016)
    if buff2 then
        attackDamageData.damage = attackDamageData.damage + math.floor(Damage * 0.2)
    end
end
GameEvent.add(EventCfg.onAttackDamageMonster, _onAttackDamageMonster, QiYuShiJian12)




local function _onBuffChange(actor, buffid, groupid, model)
    if buffid ==  31015 then
        if model == 4 then
            Player.setAttList(actor, "爆率附加")
        end
    end
    if buffid ==  31016 then
        if model == 4 then
            Player.setAttList(actor, "爆率附加")
        end
    end
end
GameEvent.add(EventCfg.onBuffChange, _onBuffChange, QiYuShiJian12)


function QiYuShiJian12.CloseUI(actor)
    ----------------验证奇遇----------------
    local verify = getplaydef(actor,VarCfg["S$奇遇事件12"])
    if verify ~= "契约" then
        Player.sendmsgEx(actor, "提示#251|:#255|非法请求#249|")
        return
    end
    ----------------验证奇遇----------------
    QiYuHeZi.ClientAddEvent(actor,verify)
    setplaydef(actor,VarCfg["S$奇遇事件12"],"")
end

--触发事件后 初始变量
local function _LuckyEventinitVar(actor, LuckyEventName)
    if LuckyEventName == "契约" then
        setplaydef(actor, VarCfg["S$奇遇事件12"], "契约" )
    end
end
GameEvent.add(EventCfg.LuckyEventinitVar, _LuckyEventinitVar, QiYuShiJian12)

--注册网络消息
Message.RegisterNetMsg(ssrNetMsgCfg.QiYuShiJian12, QiYuShiJian12)

return QiYuShiJian12

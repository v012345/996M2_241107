local QiYuShiJian02 = {}

function QiYuShiJian02.Request(actor, arg1)

    ----------------验证奇遇----------------
    local verify = getplaydef(actor,VarCfg["S$奇遇事件2"])
    if verify ~= "老铁匠" then
        Player.sendmsgEx(actor, "提示#251|:#255|非法请求#249|")
        return
    end
    ----------------验证奇遇----------------
    if arg1 == 1 then
        local itemobj = linkbodyitem(actor, 0)
        if itemobj ~= "0" then
            if verify == "老铁匠" then
                local abilGroup = 1
                clearitemcustomabil(actor,itemobj,abilGroup)
                changecustomitemtext(actor, itemobj, "\n\n\n\n\n[开光属性]:", abilGroup)
                changecustomitemtextcolor(actor, itemobj, 254, abilGroup)
                Player.addModifyCustomAttributes(actor, itemobj, abilGroup, 1, 1, 251, 30, 30, 1, 10)
                Player.sendmsgEx(actor, "提示#251|:#255|恭喜你,衣服获得最大生命|+10%#249|的开光属性...")
                setplaydef(actor, VarCfg["S$奇遇事件2"], "")
            end
        else
            Player.sendmsgEx(actor, "提示#251|:#255|你未穿戴|衣服#249|...")
        end
    elseif arg1 == 2 then
        local itemobj = linkbodyitem(actor, 1)
        if itemobj ~= "0" then
            if verify == "老铁匠" then
                local abilGroup = 1
                clearitemcustomabil(actor,itemobj,abilGroup)
                changecustomitemtext(actor, itemobj, "\n\n\n\n\n[开光属性]:", abilGroup)
                changecustomitemtextcolor(actor, itemobj, 254, abilGroup)
                Player.addModifyCustomAttributes(actor, itemobj, abilGroup, 1, 1, 251, 25, 25, 1, 10)
                Player.sendmsgEx(actor, "提示#251|:#255|恭喜你,武器获得攻击伤害|+10%#249|的开光属性...")
                setplaydef(actor, VarCfg["S$奇遇事件2"], "")
            end
        else
            Player.sendmsgEx(actor, "提示#251|:#255|你未穿戴|武器#249|...")
        end
    end
end

function QiYuShiJian02.CloseUI(actor)
    ----------------验证奇遇----------------
    local verify = getplaydef(actor,VarCfg["S$奇遇事件2"])
    if verify ~= "老铁匠" then
        Player.sendmsgEx(actor, "提示#251|:#255|非法请求#249|")
        return
    end
    ----------------验证奇遇----------------
    QiYuHeZi.ClientAddEvent(actor,verify)
    setplaydef(actor,VarCfg["S$奇遇事件2"],"")
end

--触发事件后 初始变量
local function _LuckyEventinitVar(actor, LuckyEventName)
    if LuckyEventName == "老铁匠" then
        setplaydef(actor, VarCfg["S$奇遇事件2"], "老铁匠" )
    end
end
GameEvent.add(EventCfg.LuckyEventinitVar, _LuckyEventinitVar, QiYuShiJian02)



--注册网络消息
Message.RegisterNetMsg(ssrNetMsgCfg.QiYuShiJian02, QiYuShiJian02)

return QiYuShiJian02

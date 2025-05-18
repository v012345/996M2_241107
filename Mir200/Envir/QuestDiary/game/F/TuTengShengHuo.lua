local TuTengShengHuo = {}
local cost = {{"Í¼ÌÚËéÆ¬", 1}}

function TuTengShengHuo.Request(actor)
    local _Num = getplaydef(actor, VarCfg["U_Í¼ÌÚÊ¥»ğ¼ÇÂ¼"])
    if _Num >= 10  then
        Player.sendmsgEx(actor, "ÌáÊ¾#251|:#255|ÄãµÄ|Í¼ÌÚËéÆ¬#249|ÒÑ¾­Ìá½»´ïµ½|".. _Num .."#249|´ÎÁË...")
        return
    end
    local name, num = Player.checkItemNumByTable(actor, cost)
    if name then
        Player.sendmsgEx(actor, string.format("ÌáÊ¾#251|:#255|ÄãµÄ|%s#249|²»×ã|%d#249|Ã¶,Ìá½»Ê§°Ü...", name, num))
        return
    end
    Player.takeItemByTable(actor, cost, "¿ªÍ¨µØÍ¼·ÑÓÃ")
    setplaydef(actor, VarCfg["U_Í¼ÌÚÊ¥»ğ¼ÇÂ¼"], _Num + 1)
    Player.sendmsgEx(actor, "ÌáÊ¾#251|:#255|ÄãµÄ|Í¼ÌÚËéÆ¬#249|Ìá½»´ÎÊı|+1#249|...")
    TuTengShengHuo.SyncResponse(actor)
    Player.setAttList(actor, "ÊôĞÔ¸½¼Ó")
end

--×¢²áÍøÂçÏûÏ¢
function TuTengShengHuo.SyncResponse(actor, logindatas)
    local Num = getplaydef(actor, VarCfg["U_Í¼ÌÚÊ¥»ğ¼ÇÂ¼"])
    local data ={Num}
    local _login_data = { ssrNetMsgCfg.TuTengShengHuo_SyncResponse, 0, 0, 0, data }
    if logindatas then
        table.insert(logindatas, _login_data)
    else
        Message.sendmsg(actor, ssrNetMsgCfg.TuTengShengHuo_SyncResponse, 0, 0, 0, data)
    end
end
Message.RegisterNetMsg(ssrNetMsgCfg.TuTengShengHuo, TuTengShengHuo)

local function _onCalcAttr(actor, attrs)
    local Num = getplaydef(actor, VarCfg["U_Í¼ÌÚÊ¥»ğ¼ÇÂ¼"])
    local shuxing = {}
    if Num > 0 and Num <= 10 then
        shuxing[75] = 100*Num
    end
    calcAtts(attrs, shuxing, "Í¼ÌÚËéÆ¬")
end
GameEvent.add(EventCfg.onCalcAttr, _onCalcAttr, TuTengShengHuo)

--µÇÂ¼´¥·¢
local function _onLoginEnd(actor, logindatas)
    TuTengShengHuo.SyncResponse(actor, logindatas)
end
GameEvent.add(EventCfg.onLoginEnd, _onLoginEnd, TuTengShengHuo)

return TuTengShengHuo

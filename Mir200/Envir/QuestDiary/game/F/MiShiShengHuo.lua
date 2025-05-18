local MiShiShengHuo = {}
local cost = {{"ÃÔÊ§Áé¹â", 1}}

function MiShiShengHuo.Request(actor)
    local _Num = getplaydef(actor, VarCfg["U_ÃÔÊ§Ê¥»ğ¼ÇÂ¼"])
    if _Num == 10  then
        Player.sendmsgEx(actor, "ÌáÊ¾#251|:#255|ÄãµÄ|ÃÔÊ§Áé¹â#249|ÒÑ¾­Ìá½»´ïµ½|".. _Num .."#249|´ÎÁË...")
        return
    end
    local name, num = Player.checkItemNumByTable(actor, cost)
    if name then
        Player.sendmsgEx(actor, string.format("ÌáÊ¾#251|:#255|ÄãµÄ|%s#249|²»×ã|%d#249|Ã¶,Ìá½»Ê§°Ü...", name, num))
        return
    end
    Player.takeItemByTable(actor, cost, "¿ªÍ¨µØÍ¼·ÑÓÃ")
    setplaydef(actor, VarCfg["U_ÃÔÊ§Ê¥»ğ¼ÇÂ¼"], _Num + 1)
    Player.sendmsgEx(actor, "ÌáÊ¾#251|:#255|ÄãµÄ|ÃÔÊ§Áé¹â#249|Ìá½»´ÎÊı|+1#249|...")
    MiShiShengHuo.SyncResponse(actor)
    Player.setAttList(actor, "ÊôĞÔ¸½¼Ó")
end

--×¢²áÍøÂçÏûÏ¢
function MiShiShengHuo.SyncResponse(actor, logindatas)
    local Num = getplaydef(actor, VarCfg["U_ÃÔÊ§Ê¥»ğ¼ÇÂ¼"])
    local data ={Num}
    local _login_data = { ssrNetMsgCfg.MiShiShengHuo_SyncResponse, 0, 0, 0, data }
    if logindatas then
        table.insert(logindatas, _login_data)
    else
        Message.sendmsg(actor, ssrNetMsgCfg.MiShiShengHuo_SyncResponse, 0, 0, 0, data)
    end
end
Message.RegisterNetMsg(ssrNetMsgCfg.MiShiShengHuo, MiShiShengHuo)

local function _onCalcAttr(actor, attrs)
    local Num = getplaydef(actor, VarCfg["U_ÃÔÊ§Ê¥»ğ¼ÇÂ¼"])
    local shuxing = {}
    if Num > 0 and Num <= 10 then
        shuxing[208] = Num
    end
    calcAtts(attrs, shuxing, "ÃÔÊ§Áé¹â")
end
GameEvent.add(EventCfg.onCalcAttr, _onCalcAttr, MiShiShengHuo)

--µÇÂ¼´¥·¢
local function _onLoginEnd(actor, logindatas)
    MiShiShengHuo.SyncResponse(actor, logindatas)
end
GameEvent.add(EventCfg.onLoginEnd, _onLoginEnd, MiShiShengHuo)

return MiShiShengHuo

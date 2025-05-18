local Public = {}
function Public.Request(actor, arg1)
    if arg1 == 1 then
        openstorage(actor)
    elseif arg1 == 2 then
        openplayer(actor)
    end
end
Message.RegisterNetMsg(ssrNetMsgCfg.Public, Public)
return Public
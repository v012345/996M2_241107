local KuaFuBuff = {}

function KuaFuBuff.Request(actor, arg1, arg2, arg3, data)
    addbuff(actor, arg1, arg2)
end
Message.RegisterNetMsg(ssrNetMsgCfg.KuaFuBuff, KuaFuBuff)
return KuaFuBuff

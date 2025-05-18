local test = {}
function test.Request(actor, arg1, arg2, arg3, data)
end
function test.Request1(actor, arg1, arg2, arg3, data)
end
Message.RegisterNetMsg(ssrNetMsgCfg.test, test)
return

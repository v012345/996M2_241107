Message = {}

--这个表包含了定义的所有网络消息
local dispatch_handler = {}


---发送消息
---* actor:	玩家对象
---* msgID:	消息ID
---* arg1:	参数1
---* arg2:  参数2
---* arg3:	参数3
---* data: 	消息体
function Message.sendmsg(actor, msgID, arg1, arg2, arg3, data)
    local str = data and tbl2json(data) or nil
    --LOGPrint("sendmsg msgID=", msgID, arg1, arg2, arg3, str)
    --LOGWrite("sendmsg msgID=", msgID, arg1, arg2, arg3, str)
    sendluamsg(actor, msgID, arg1, arg2, arg3, str)
end

function Message.dispatch(actor, msgID, arg1, arg2, arg3, str)
    --LOGPrint("dispatch msgID=", msgID, arg1, arg2, arg3, str)
    --LOGWrite("dispatch msgID=", msgID, arg1, arg2, arg3, str)
    
    local msgName = ssrNetMsgCfg[msgID]
    if not msgName then return end

    local module, method = msgName:match "([^.]*)_(.*)"
    local target = dispatch_handler[module]
    if not target or not target[method] then return end
    --如果是条件开启模块并且模块还未开启不处理网络消息
    -- local moduleid = target.ID
    -- if moduleid and xxx[moduleid] then
        --如果未开启
        --return
    -- end
    --派发
    -- printusetime(actor,1)
    local data = (str and str ~= "") and json2tbl(str) or nil
    target[method](actor, arg1, arg2, arg3, data)
    -- printusetime(actor,2)
    
end

function Message.RegisterNetMsg(msgType, target)
    dispatch_handler[msgType] = target
end

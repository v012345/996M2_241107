Message = {}

--���������˶��������������Ϣ
local dispatch_handler = {}


---������Ϣ
---* actor:	��Ҷ���
---* msgID:	��ϢID
---* arg1:	����1
---* arg2:  ����2
---* arg3:	����3
---* data: 	��Ϣ��
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
    --�������������ģ�鲢��ģ�黹δ����������������Ϣ
    -- local moduleid = target.ID
    -- if moduleid and xxx[moduleid] then
        --���δ����
        --return
    -- end
    --�ɷ�
    -- printusetime(actor,1)
    local data = (str and str ~= "") and json2tbl(str) or nil
    target[method](actor, arg1, arg2, arg3, data)
    -- printusetime(actor,2)
    
end

function Message.RegisterNetMsg(msgType, target)
    dispatch_handler[msgType] = target
end

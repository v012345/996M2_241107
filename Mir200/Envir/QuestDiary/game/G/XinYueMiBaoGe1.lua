local XinYueMiBaoGe1 = {}

--��������
function XinYueMiBaoGe1.Request(actor, var)
    if var == 1 then
        if not checkitems(actor,"�߼��þ�ͨ��֤#1",0,0) then
            Player.sendmsgEx(actor, "��ʾ#251|:#255|�Բ���,�㱳����û��|�߼��þ�ͨ��֤#249|�޷�����...")
            return
        end

        if getsysvar(VarCfg["A_�þ���ͼ����"]) ~= "��" then
            Player.sendmsgEx(actor, "��ʾ#251|:#255|�Բ���,����|22��05��--10��05��#249|֮�����...")
            return
        end
        map(actor, "�����ر���1")
    end

    if var == 2 then
        local RiChongNum = getplaydef(actor, VarCfg["J_�ճ��¼"])
        if RiChongNum < 68 then
            Player.sendmsgEx(actor, "��ʾ#251|:#255|�Բ���,����ճ�ֵ|����68Ԫ#249|�޷���ȡ...")
            return
        end

        if getplaydef(actor, VarCfg["J_�߼�ͨ��֤��ȡ״̬"]) == 1 then
            Player.sendmsgEx(actor, "��ʾ#251|:#255|�Բ���,������ȡ��|�߼��þ�ͨ��֤#249|�����ظ���ȡ...")
            return
        end

        if checkitems(actor, "�߼��þ�ͨ��֤#1", 0, 0) then
            local ItemObj = getitemobj(actor,"�߼��þ�ͨ��֤")
            local _time  = getitemaddvalue(actor, ItemObj, 2, 0)
            local time = (_time + 86400 >= 172800 and 172800) or _time + 86400
            setitemaddvalue(actor,ItemObj, 2, 0, time)
            Player.sendmsgEx(actor, "��ʾ#251|:#255|��ϲ��,�ɹ���ȡ|�߼��þ�ͨ��֤#249|ʱ���ѵ���24Сʱ...")
        else
            giveitem(actor, "�߼��þ�ͨ��֤", 1, 0, "ÿ�ճ�ֵ��ȡ")
            Player.sendmsgEx(actor, "��ʾ#251|:#255|��ϲ��,�ɹ���ȡ|�߼��þ�ͨ��֤#249|�Ѿ����ŵ�����...")
        end

        setplaydef(actor, VarCfg["J_�߼�ͨ��֤��ȡ״̬"], 1)
        XinYueMiBaoGe1.SyncResponse(actor)
    end


end
--ͬ����Ϣ
function XinYueMiBaoGe1.SyncResponse(actor, logindatas)
    local TongXingZheng = 0
    if checkitems(actor, "�߼��þ�ͨ��֤#1", 0, 0) then
        TongXingZheng = 1
    end
    local RiChongNum = getplaydef(actor, VarCfg["J_�ճ��¼"])

    local _login_data = {ssrNetMsgCfg.XinYueMiBaoGe1_SyncResponse, TongXingZheng, RiChongNum, 0, nil}
    if type(logindatas) == "table" then
        table.insert(logindatas, _login_data)
    else
        Message.sendmsg(actor, ssrNetMsgCfg.XinYueMiBaoGe1_SyncResponse, TongXingZheng, RiChongNum, 0, nil)
    end
end
Message.RegisterNetMsg(ssrNetMsgCfg.XinYueMiBaoGe1, XinYueMiBaoGe1)


--��¼����
local function _onLoginEnd(actor, logindatas)
    XinYueMiBaoGe1.SyncResponse(actor, logindatas)
end
GameEvent.add(EventCfg.onLoginEnd, _onLoginEnd, XinYueMiBaoGe1)


return XinYueMiBaoGe1
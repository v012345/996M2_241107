local XinYueHuanJing = {}
XinYueHuanJing.ID = "���»þ�"
--��������
function XinYueHuanJing.Request(actor,var)
    if not checkitems(actor,"�þ�ͨ��֤#1",0,0) then
        Player.sendmsgEx(actor, "��ʾ#251|:#255|�Բ���,�㱳����û��|�þ�ͨ��֤#249|�޷�����...")
        return
    end

    if getsysvar(VarCfg["A_�þ���ͼ����"]) ~= "��" then
        Player.sendmsgEx(actor, "��ʾ#251|:#255|�Բ���,����|22��05��--10��05��#249|֮�����...")
        return
    end
    
    if var == 1 then
        map(actor, "���»þ�1")
    end
    if var == 2 then
        map(actor, "���»þ�2")
    end
end

--ע��������Ϣ
Message.RegisterNetMsg(ssrNetMsgCfg.XinYueHuanJing, XinYueHuanJing)
return XinYueHuanJing
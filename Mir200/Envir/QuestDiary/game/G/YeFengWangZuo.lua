local YeFengWangZuo = {}
YeFengWangZuo.ID = "ҹ������"
--��������
function YeFengWangZuo.Request(actor)
    if checkitemw(actor,"�ڵ���ҹ", 1) then
        map(actor, "ҹ������")
    else
        Player.sendmsgEx(actor, "��ʾ#251|:#255|�Բ���,��û���䵽|�ڵ���ҹ#249|�޷�����...")
        return
    end
end
--ע��������Ϣ
Message.RegisterNetMsg(ssrNetMsgCfg.YeFengWangZuo, YeFengWangZuo)
return YeFengWangZuo
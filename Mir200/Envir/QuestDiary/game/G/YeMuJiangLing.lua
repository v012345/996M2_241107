local YeMuJiangLing = {}
YeMuJiangLing.ID = "ҹĻ����"
-- ҹ����Ԩ	142	96
local cost = {{"Ļ��", 1},{"ӰĻָ֮", 1},{"�컯�ᾧ", 188}}

--��������
function YeMuJiangLing.Request(actor)
    local name, num = Player.checkItemNumByTable(actor, cost)
    if name then
        Player.sendmsgEx(actor, string.format("���|%s#249|��������|%d#249|����ʧ��...", name, num))
        return
    end
    Player.takeItemByTable(actor, cost, "�ڵ���ҹ�۳�")
    giveitem(actor, "�ڵ���ҹ", 1, ConstCfg.binding, "�ڵ���ҹ")
    Message.sendmsg(actor, ssrNetMsgCfg.YeMuJiangLing_SyncResponse, 0, 0, 0, nil)
end

--ע��������Ϣ
Message.RegisterNetMsg(ssrNetMsgCfg.YeMuJiangLing, YeMuJiangLing)
return YeMuJiangLing
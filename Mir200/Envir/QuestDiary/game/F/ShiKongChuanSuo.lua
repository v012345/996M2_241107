local ShiKongChuanSuo = {}
local cost = { { "��ת����[��]+10", 1 }, { "������˹֮��", 5 }, { "����ʱ�յ�����", 1 }, { "���", 100000000 }, { "Ԫ��", 5880000 }, { "��ʯ", 288 } }

function ShiKongChuanSuo.Request(actor)
    local name, num = Player.checkItemNumByTable(actor, cost)
    if name then
        Player.sendmsgEx(actor, string.format("��ʾ#251|:#255|���|%s#249|����|%d#249|...", name, num))
        return
    end
    Player.takeItemByTable(actor, cost, "ʱ�մ���")
    giveitem(actor, "������ʱ����ת", 1, 0)
    Player.sendmsgEx(actor, "��ʾ#251|:#255|��ϲ��ϳ�|������ʱ����ת#249|�ɹ�...")
    ShiKongChuanSuo.SyncResponse(actor)
end

-- ͬ��һ����Ϣ
function ShiKongChuanSuo.SyncResponse(actor)
    Message.sendmsg(actor, ssrNetMsgCfg.ShiKongChuanSuo_SyncResponse, 0, 0, 0, nil)
end

Message.RegisterNetMsg(ssrNetMsgCfg.ShiKongChuanSuo, ShiKongChuanSuo)

return ShiKongChuanSuo

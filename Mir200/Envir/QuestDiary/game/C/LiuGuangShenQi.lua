local LiuGuangShenQi = {}
LiuGuangShenQi.cost = {
    {{ "��������[¾��]", 1 }, { "��������[��Ѫ]", 1 }, { "��������[����]", 1 }, { "��ʯ", 18 }},
    {{ "��������[��]", 1 }, { "���������[��]", 1 }, { "����ò���[��]", 1 }, { "��ʯ", 18 }}
}
LiuGuangShenQi.give = { "���ℇ[�ۺ�֮��]", "���⡤�ӻ�[��]" }
function LiuGuangShenQi.Request(actor, index)
    local cost = LiuGuangShenQi.cost[index]
    if not cost then
        return
    end
    local give = LiuGuangShenQi.give[index]
    if not give then
        return
    end

    local name, num = Player.checkItemNumByTable(actor, cost)
    if name then
        Player.sendmsgEx(actor, string.format("[��ʾ]:#251|����ʧ��,���|%s#249|��������|%d#249", name, num))
        return
    end
    Player.takeItemByTable(actor, cost, "���״���")
    giveitem(actor, give, 1, 0, "���״���")
    Player.sendmsgEx(actor, string.format("[��ʾ]:#251|��ϲ����ɹ�,���|[%s]#249|,��ȥ���԰�", give))
    Message.sendmsg(actor,ssrNetMsgCfg.LiuGuangShenQi_SyncResponse)
end

-----ע��������Ϣ
Message.RegisterNetMsg(ssrNetMsgCfg.LiuGuangShenQi, LiuGuangShenQi)

return LiuGuangShenQi

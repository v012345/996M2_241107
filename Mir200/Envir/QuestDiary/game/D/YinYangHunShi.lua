local YinYangHunShi = {}
local cost = { { "��", 1 }, { "��ڤ�л�", 10 }, { "��", 1 }, { "���", 200 } }
local showItme = { { "������ʯ", 1 } }
function YinYangHunShi.Request(actor)
    local name, num = Player.checkItemNumByTable(actor, cost)
    if name then
        Player.sendmsgEx(actor, string.format("[��ʾ]:#251|���|%s#249|��������|%d#249", name, num))
        return
    end
    Player.takeItemByTable(actor, cost, "������ʯ�ϳ�")
    Player.giveItemByTable(actor, showItme, "������ʯ�ϳ�")
    Player.sendmsgEx(actor, string.format("��ϲ��ɹ��ϳ�|%s#249", "������ʯ"))
end

Message.RegisterNetMsg(ssrNetMsgCfg.YinYangHunShi, YinYangHunShi)
return YinYangHunShi

local MingYunLuoPan = {}
local cost = {{"������Ƭ����Х֮��", 10}}

function MingYunLuoPan.Request(actor)

    local name, num = Player.checkItemNumByTable(actor, cost)
    if name then
        Player.sendmsgEx(actor, string.format("��ʾ#251|:#255|���|%s#249|����|%d#249|ö,����ʧ��...", name, num))
        return
    end

    Player.takeItemByTable(actor, cost, "����������̡��")
    giveitem(actor, "����������̡��", 1, ConstCfg.binding)
    setflagstatus(actor, VarCfg["F_����������̡��_��ȡ"], 1)
    Player.sendmsgEx(actor, "��ʾ#251|:#255|��ϲ�����|����������̡��#249|�ɹ�...")
    MingYunLuoPan.SyncResponse(actor)
end
local function _onKillMon(actor, monobj, monName)
    if getflagstatus(actor,VarCfg["F_��־塤������_��ɱ"]) == 1 then
        return
    end
    if monName == "��־塤������" then
        setflagstatus(actor,VarCfg["F_��־塤������_��ɱ"],1)
    end
end

GameEvent.add(EventCfg.onKillMon, _onKillMon, MingYunLuoPan)
-- ͬ��һ����Ϣ
function MingYunLuoPan.SyncResponse(actor)
    Message.sendmsg(actor, ssrNetMsgCfg.MingYunLuoPan_SyncResponse, 0, 0, 0, nil)
end
Message.RegisterNetMsg(ssrNetMsgCfg.MingYunLuoPan, MingYunLuoPan)

return MingYunLuoPan

local PingPanJiangLing = {}
PingPanJiangLing.ID = "ƽ�ѽ���"
local npcID = 331
--local config = include("QuestDiary/cfgcsv/cfg_PingPanJiangLing.lua") --����
local cost = { { "�Ѿ������ͷ­", 1 } }
local give = "����֮��"
--��������
function PingPanJiangLing.Request(actor)
    if checktitle(actor,give) then
        Player.sendmsgEx(actor, "���Ѿ������|����֮��#249|�ƺ�!")
        return
    end
    if not FCheckNPCRange(actor, npcID, 15) then
        Player.sendmsgEx(actor, "����PNC̫Զ!#249")
        return
    end
    local name, num = Player.checkItemNumByTable(actor, cost)
    if name then
        Player.sendmsgEx(actor, string.format("�ύʧ��,���|%s#249|����|%d#249", name, num))
        return
    end
    Player.takeItemByTable(actor, cost, "ƽ�ѽ���")
    confertitle(actor, give)
    Player.sendmsgEx(actor, "��ϲ������|����֮��#249|�ƺ�!")
    PingPanJiangLing.SyncResponse(actor)
end

--ͬ����Ϣ
function PingPanJiangLing.SyncResponse(actor)
    local data = {}
    Message.sendmsg(actor, ssrNetMsgCfg.PingPanJiangLing_SyncResponse, 0, 0, 0, data)
end

--ע��������Ϣ
Message.RegisterNetMsg(ssrNetMsgCfg.PingPanJiangLing, PingPanJiangLing)
return PingPanJiangLing

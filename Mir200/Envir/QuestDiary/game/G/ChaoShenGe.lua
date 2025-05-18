local ChaoShenGe = {}
ChaoShenGe.ID = "�����"
local npcID = 152
local config = include("QuestDiary/cfgcsv/cfg_ChaoShenGe.lua") --����
--��������
function ChaoShenGe.Request(actor, index)
    if not index then
        Player.sendmsgEx(actor, "��������1!")
        return
    end
    if "number" ~= type(index) then
        Player.sendmsgEx(actor, "��������2!")
        return
    end
    local cfg = config[index]
    if not cfg then
        Player.sendmsgEx(actor, "��������3!")
        return
    end
    local cost = cfg.equip
    local name, num = Player.checkItemNumByTable(actor, cost)
    if name then
        Player.sendmsgEx(actor, string.format("����ʧ��,��ı�����û��|%s#249", name))
        return
    end
    Player.takeItemByTable(actor, cost, "��������")
    local give = {}
    local lingFuName = "�����"
    if getflagstatus(actor, VarCfg["F_���״̬"]) == 1 then
        lingFuName = "���"
    end
    give = { { lingFuName, cfg.lingfu } }
    local uid = Player.GetUUID(actor)
    local mailTitle = "����������"
    local mailContent = string.format("���%s������%s,���%s:%s", ChaoShenGe.ID, cost[1][1], lingFuName, cfg.lingfu)
    Player.giveMailByTable(uid, 20, mailTitle, mailContent, give)
    Player.sendmsgEx(actor, "��ϲ����ճɹ�,�����ѷ���������,�����!")
    ChaoShenGe.SyncResponse(actor)
end

--ͬ����Ϣ
function ChaoShenGe.SyncResponse(actor, logindatas)
    local data = {}
    Message.sendmsg(actor, ssrNetMsgCfg.ChaoShenGe_SyncResponse, 0, 0, 0, data)
end
-- --��¼����
-- local function _onLoginEnd(actor, logindatas)
--     ChaoShenGe.SyncResponse(actor, logindatas)
-- end
-- --�¼��ɷ�
-- GameEvent.add(EventCfg.onLoginEnd, _onLoginEnd, ChaoShenGe)
--ע��������Ϣ
Message.RegisterNetMsg(ssrNetMsgCfg.ChaoShenGe, ChaoShenGe)
return ChaoShenGe

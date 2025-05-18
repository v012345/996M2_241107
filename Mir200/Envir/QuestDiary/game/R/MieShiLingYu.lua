local MieShiLingYu = {}
MieShiLingYu.ID = "��������"
local npcID = 237
local cost = { { "����������־��", 1 }, { "��������֮����", 1 }, { "̫�����������", 1 } }
local give = { { "̫���������[��ȫ��]", 1 } }
--local config = include("QuestDiary/cfgcsv/cfg_MieShiLingYu.lua") --����
--��������
function MieShiLingYu.Request(actor)
    if not FCheckNPCRange(actor, npcID, 15) then
        Player.sendmsgEx(actor, "����PNC̫Զ!#249")
        return
    end
    local name, num = Player.checkItemNumByTable(actor, cost)
    if name then
        Player.sendmsgEx(actor, string.format("���|%s#249|����|%d#249", name, num))
        return
    end
    if not Bag.checkBagEmptyNum(actor, 5) then
        Player.sendmsgEx(actor, "��ı������Ӳ���,��������5���ո�!#249")
        stop(actor)
    end
    Player.takeItemByTable(actor, cost, "�����������")
    Player.giveItemByTable(actor, give, "�����������", 1, true)
    MieShiLingYu.SyncResponse(actor)
    setflagstatus(actor,VarCfg["F_�ϳ�̫���������"],1)
    Player.sendmsgEx(actor, "��ʾ��#251|��ϲ������|̫���������[��ȫ��]#249")
end
--ͬ����Ϣ
function MieShiLingYu.SyncResponse(actor, logindatas)
    local data = {}
    local _login_data = {ssrNetMsgCfg.MieShiLingYu_SyncResponse, 0, 0, 0, data}
    if logindatas then
        table.insert(logindatas, _login_data)
    else
        Message.sendmsg(actor, ssrNetMsgCfg.MieShiLingYu_SyncResponse, 0, 0, 0, data)
    end
end
-- --��¼����
-- local function _onLoginEnd(actor, logindatas)
--     MieShiLingYu.SyncResponse(actor, logindatas)
-- end
-- --�¼��ɷ�
-- GameEvent.add(EventCfg.onLoginEnd, _onLoginEnd, MieShiLingYu)
--ע��������Ϣ
Message.RegisterNetMsg(ssrNetMsgCfg.MieShiLingYu, MieShiLingYu)
return MieShiLingYu
--init����
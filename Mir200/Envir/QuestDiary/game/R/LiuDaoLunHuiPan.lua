local LiuDaoLunHuiPan = {}
LiuDaoLunHuiPan.ID = "�����ֻ���"
local npcID = 457
--local config = include("QuestDiary/cfgcsv/cfg_LiuDaoLunHuiPan.lua") --����
local cost = { { "������ʯ", 188 }, { "�ֻؾ�", 1 }, { "��ʯ", 288 } }
local give = { { "�����ֻ���", 1 } }
--��������
function LiuDaoLunHuiPan.Request(actor)
    if not FCheckNPCRange(actor, npcID, 15) then
        Player.sendmsgEx(actor, "����PNC̫Զ!#249")
        return
    end
    local name, num = Player.checkItemNumByTable(actor, cost)
    if name then
        Player.sendmsgEx(actor, string.format("���|%s#249|����|%d#249", name, num))
        return
    end
    Player.takeItemByTable(actor, cost, "�����ֻ���")
    Player.giveItemByTable(actor, give, "�����ֻ���", 1, true)
    setflagstatus(actor,VarCfg["F_�����ֻ���_���"],1)
    messagebox(actor,"��ϲ���ñ�������[�����ֻ���]")
end

--ͬ����Ϣ
-- function LiuDaoLunHuiPan.SyncResponse(actor, logindatas)
--     local data = {}
--     local _login_data = {ssrNetMsgCfg.LiuDaoLunHuiPan_SyncResponse, 0, 0, 0, data}
--     if logindatas then
--         table.insert(logindatas, _login_data)
--     else
--         Message.sendmsg(actor, ssrNetMsgCfg.LiuDaoLunHuiPan_SyncResponse, 0, 0, 0, data)
--     end
-- end
-- --��¼����
-- local function _onLoginEnd(actor, logindatas)
--     LiuDaoLunHuiPan.SyncResponse(actor, logindatas)
-- end
-- --�¼��ɷ�
-- GameEvent.add(EventCfg.onLoginEnd, _onLoginEnd, LiuDaoLunHuiPan)
--ע��������Ϣ
Message.RegisterNetMsg(ssrNetMsgCfg.LiuDaoLunHuiPan, LiuDaoLunHuiPan)
return LiuDaoLunHuiPan

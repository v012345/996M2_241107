local FengYinJiTan = {}
FengYinJiTan.ID = "��ӡ��̳"
local npcID = 231
local mapId = "�������"
--local config = include("QuestDiary/cfgcsv/cfg_FengYinJiTan.lua") --����
local cost = { { "�������", 20 }, { "а��ӡ��", 20 }, { "���", 300000 } }
--��������
function FengYinJiTan.Request(actor)
    if not FCheckNPCRange(actor, npcID, 15) then
        Player.sendmsgEx(actor, "����PNC̫Զ!#249")
        return
    end
    local name, num = Player.checkItemNumByTable(actor, cost)
    if name then
        Player.sendmsgEx(actor, string.format("�ٻ�ʧ��,���|%s#249|����|%d#249", name, num))
        return
    end
    Player.takeItemByTable(actor, cost, "��ӡ��̳")

    FSetTaskRedPoint(actor, VarCfg["F_��ӡ��̳_���"], 11)
    
    genmon(mapId, 77, 76, "а��.����ħ��[SSS]", 1, 1, 255)
    Player.sendmsgEx(actor, "��ʾ��#251|���ٻ���|[а��.����ħ��[SSS]]#249")
    Message.sendmsg(actor, ssrNetMsgCfg.FengYinJiTan_Close, 0, 0, 0, {})
end

--ͬ����Ϣ
-- function FengYinJiTan.SyncResponse(actor, logindatas)
--     local data = {}
--     local _login_data = {ssrNetMsgCfg.FengYinJiTan_SyncResponse, 0, 0, 0, data}
--     if logindatas then
--         table.insert(logindatas, _login_data)
--     else
--         Message.sendmsg(actor, ssrNetMsgCfg.FengYinJiTan_SyncResponse, 0, 0, 0, data)
--     end
-- end
-- --��¼����
-- local function _onLoginEnd(actor, logindatas)
--     FengYinJiTan.SyncResponse(actor, logindatas)
-- end
-- --�¼��ɷ�
-- GameEvent.add(EventCfg.onLoginEnd, _onLoginEnd, FengYinJiTan)
--ע��������Ϣ
Message.RegisterNetMsg(ssrNetMsgCfg.FengYinJiTan, FengYinJiTan)
return FengYinJiTan
--init����

local YeShouZhiSen = {}
YeShouZhiSen.ID = "Ұ��֮ɭ"
local npcID = 111
local mapID = "Ұ��֮ɭ"
--local config = include("QuestDiary/cfgcsv/cfg_YeShouZhiSen.lua") --����
--��������
function YeShouZhiSen.Request(actor)
    if FCheckLevel(actor, 150) then
        Player.sendmsgEx(actor,"�ȼ�����150��,����ʧ��!")
        return
    end

    local monNum = getmoncount(mapID, -1, true)
    if monNum < 500 then
        genmon(mapID, 180, 240, "������", 200, 180, 150)
        genmon(mapID, 180, 240, "ɭ��Ұ��", 200, 180, 150)
        genmon(mapID, 180, 240, "��Ұ��", 200, 180, 150)
    end

    FMapEx(actor, mapID, true)
end
--ͬ����Ϣ
-- function YeShouZhiSen.SyncResponse(actor, logindatas)
--     local data = {}
--     local _login_data = {ssrNetMsgCfg.YeShouZhiSen_SyncResponse, 0, 0, 0, data}
--     if logindatas then
--         table.insert(logindatas, _login_data)
--     else
--         Message.sendmsg(actor, ssrNetMsgCfg.YeShouZhiSen_SyncResponse, 0, 0, 0, data)
--     end
-- end
-- --��¼����
-- local function _onLoginEnd(actor, logindatas)
--     YeShouZhiSen.SyncResponse(actor, logindatas)
-- end
-- --�¼��ɷ�
-- GameEvent.add(EventCfg.onLoginEnd, _onLoginEnd, YeShouZhiSen)
--ע��������Ϣ
Message.RegisterNetMsg(ssrNetMsgCfg.YeShouZhiSen, YeShouZhiSen)
return YeShouZhiSen
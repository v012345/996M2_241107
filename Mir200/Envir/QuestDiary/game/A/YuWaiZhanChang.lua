local YuWaiZhanChang = {}
YuWaiZhanChang.ID = "����ս��"
local npcID = 3060
--local config = include("QuestDiary/cfgcsv/cfg_YuWaiZhanChang.lua") --����
local cost = {{}}
local give = {{}}
local mapID = "����ս��"
--��������
function YuWaiZhanChang.Request(actor)
    if not FCheckNPCRange(actor, npcID, 15) then
        Player.sendmsgEx(actor, "����PNC̫Զ!#249")
        return
    end
    if not FCheckLevel(actor, 220) then
        Player.sendmsgEx(actor, "�ȼ�����220��,����ʧ��!#249")
        return
    end
    FMapMoveEx(actor, mapID, 23 ,22,0)
end
--ͬ����Ϣ
-- function YuWaiZhanChang.SyncResponse(actor, logindatas)
--     local data = {}
--     local _login_data = {ssrNetMsgCfg.YuWaiZhanChang_SyncResponse, 0, 0, 0, data}
--     if logindatas then
--         table.insert(logindatas, _login_data)
--     else
--         Message.sendmsg(actor, ssrNetMsgCfg.YuWaiZhanChang_SyncResponse, 0, 0, 0, data)
--     end
-- end
-- --��¼����
-- local function _onLoginEnd(actor, logindatas)
--     YuWaiZhanChang.SyncResponse(actor, logindatas)
-- end
-- --�¼��ɷ�
-- GameEvent.add(EventCfg.onLoginEnd, _onLoginEnd, YuWaiZhanChang)
--ע��������Ϣ
Message.RegisterNetMsg(ssrNetMsgCfg.YuWaiZhanChang, YuWaiZhanChang)
return YuWaiZhanChang
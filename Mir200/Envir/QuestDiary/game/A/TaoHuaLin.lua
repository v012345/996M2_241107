local TaoHuaLin = {}
TaoHuaLin.ID = "�һ���"
local npcID = 112
local mapID = "�һ���"
--local config = include("QuestDiary/cfgcsv/cfg_TaoHuaLin.lua") --����
--��������
function TaoHuaLin.Request(actor)
    if FCheckLevel(actor, 150) then
        Player.sendmsgEx(actor,"�ȼ�����150��,����ʧ��!")
        return
    end
    local monNum = getmoncount(mapID, -1, true)
    if monNum < 500 then
        genmon(mapID, 206, 194, "������", 150, 150, 213)
        genmon(mapID, 206, 194, "Ѳɽ��", 150, 150, 213)
        genmon(mapID, 206, 194, "ħ֮��", 150, 150, 213)
    end
    FMapEx(actor, mapID, true)
end
--ͬ����Ϣ
-- function TaoHuaLin.SyncResponse(actor, logindatas)
--     local data = {}
--     local _login_data = {ssrNetMsgCfg.TaoHuaLin_SyncResponse, 0, 0, 0, data}
--     if logindatas then
--         table.insert(logindatas, _login_data)
--     else
--         Message.sendmsg(actor, ssrNetMsgCfg.TaoHuaLin_SyncResponse, 0, 0, 0, data)
--     end
-- end
-- --��¼����
-- local function _onLoginEnd(actor, logindatas)
--     TaoHuaLin.SyncResponse(actor, logindatas)
-- end
-- --�¼��ɷ�
-- GameEvent.add(EventCfg.onLoginEnd, _onLoginEnd, TaoHuaLin)
--ע��������Ϣ
Message.RegisterNetMsg(ssrNetMsgCfg.TaoHuaLin, TaoHuaLin)
return TaoHuaLin
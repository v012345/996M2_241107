local LiuLiKuangDong = {}
LiuLiKuangDong.ID = "������"
local npcID = 113
--local config = include("QuestDiary/cfgcsv/cfg_LiuLiKuangDong.lua") --����
local mapID = "������"
--��������
function LiuLiKuangDong.Request(actor)
    if FCheckLevel(actor, 150) then
        Player.sendmsgEx(actor,"�ȼ�����150��,����ʧ��!")
        return
    end
    local monNum = getmoncount(mapID, -1, true)
    if monNum < 200 then
        genmon(mapID, 155, 127, "�󹤽ܷ�", 150, 120, 145)
        genmon(mapID, 155, 127, "ʯͷ��", 150, 120, 145)
        genmon(mapID, 155, 127, "��ʯ��", 150, 120, 145)
    end
    FMapEx(actor, mapID, true)
end
--ͬ����Ϣ
-- function LiuLiKuangDong.SyncResponse(actor, logindatas)
--     local data = {}
--     local _login_data = {ssrNetMsgCfg.LiuLiKuangDong_SyncResponse, 0, 0, 0, data}
--     if logindatas then
--         table.insert(logindatas, _login_data)
--     else
--         Message.sendmsg(actor, ssrNetMsgCfg.LiuLiKuangDong_SyncResponse, 0, 0, 0, data)
--     end
-- end
-- --��¼����
-- local function _onLoginEnd(actor, logindatas)
--     LiuLiKuangDong.SyncResponse(actor, logindatas)
-- end
-- --�¼��ɷ�
-- GameEvent.add(EventCfg.onLoginEnd, _onLoginEnd, LiuLiKuangDong)
--ע��������Ϣ
Message.RegisterNetMsg(ssrNetMsgCfg.LiuLiKuangDong, LiuLiKuangDong)
return LiuLiKuangDong
local NiuMaKuangGong = {}
NiuMaKuangGong.ID = "ţ�����"
local npcID = 0
--local config = include("QuestDiary/cfgcsv/cfg_NiuMaKuangGong.lua") --����
local cost = {{}}
local give = {{}}
--��������
function NiuMaKuangGong.Request(actor)
    --local name, num = Player.checkItemNumByTable(actor, cost)
    --if name then
        --Player.sendmsgEx(actor, string.format("���|%s#249|����|%d#249", name, num))
        --return
    --end
end
--ͬ����Ϣ
-- function NiuMaKuangGong.SyncResponse(actor, logindatas)
--     local data = {}
--     local _login_data = {ssrNetMsgCfg.NiuMaKuangGong_SyncResponse, 0, 0, 0, data}
--     if logindatas then
--         table.insert(logindatas, _login_data)
--     else
--         Message.sendmsg(actor, ssrNetMsgCfg.NiuMaKuangGong_SyncResponse, 0, 0, 0, data)
--     end
-- end
-- --��¼����
-- local function _onLoginEnd(actor, logindatas)
--     NiuMaKuangGong.SyncResponse(actor, logindatas)
-- end
-- --�¼��ɷ�
-- GameEvent.add(EventCfg.onLoginEnd, _onLoginEnd, NiuMaKuangGong)
--ע��������Ϣ
Message.RegisterNetMsg(ssrNetMsgCfg.NiuMaKuangGong, NiuMaKuangGong)
return NiuMaKuangGong
local KuangShiDaHeng = {}
KuangShiDaHeng.ID = "��ʯ���"
local npcID = 129
--local config = include("QuestDiary/cfgcsv/cfg_KuangShiDaHeng.lua") --����
local cost = {{}}
local give = {{}}
--��������
function KuangShiDaHeng.Request(actor)
    --local name, num = Player.checkItemNumByTable(actor, cost)
    --if name then
        --Player.sendmsgEx(actor, string.format("���|%s#249|����|%d#249", name, num))
        --return
    --end
end
--ͬ����Ϣ
-- function KuangShiDaHeng.SyncResponse(actor, logindatas)
--     local data = {}
--     local _login_data = {ssrNetMsgCfg.KuangShiDaHeng_SyncResponse, 0, 0, 0, data}
--     if logindatas then
--         table.insert(logindatas, _login_data)
--     else
--         Message.sendmsg(actor, ssrNetMsgCfg.KuangShiDaHeng_SyncResponse, 0, 0, 0, data)
--     end
-- end
-- --��¼����
-- local function _onLoginEnd(actor, logindatas)
--     KuangShiDaHeng.SyncResponse(actor, logindatas)
-- end
-- --�¼��ɷ�
-- GameEvent.add(EventCfg.onLoginEnd, _onLoginEnd, KuangShiDaHeng)
--ע��������Ϣ
Message.RegisterNetMsg(ssrNetMsgCfg.KuangShiDaHeng, KuangShiDaHeng)
return KuangShiDaHeng
local KuangHuanXiaoZhen = {}
KuangHuanXiaoZhen.ID = "��С��"
local npcID = 122
--local config = include("QuestDiary/cfgcsv/cfg_KuangHuanXiaoZhen.lua") --����
local cost = {{}}
local give = {{}}
--��������
function KuangHuanXiaoZhen.Request(actor)
    --local name, num = Player.checkItemNumByTable(actor, cost)
    --if name then
        --Player.sendmsgEx(actor, string.format("���|%s#249|����|%d#249", name, num))
        --return
    --end
end
--ͬ����Ϣ
-- function KuangHuanXiaoZhen.SyncResponse(actor, logindatas)
--     local data = {}
--     local _login_data = {ssrNetMsgCfg.KuangHuanXiaoZhen_SyncResponse, 0, 0, 0, data}
--     if logindatas then
--         table.insert(logindatas, _login_data)
--     else
--         Message.sendmsg(actor, ssrNetMsgCfg.KuangHuanXiaoZhen_SyncResponse, 0, 0, 0, data)
--     end
-- end
-- --��¼����
-- local function _onLoginEnd(actor, logindatas)
--     KuangHuanXiaoZhen.SyncResponse(actor, logindatas)
-- end
-- --�¼��ɷ�
-- GameEvent.add(EventCfg.onLoginEnd, _onLoginEnd, KuangHuanXiaoZhen)
--ע��������Ϣ
Message.RegisterNetMsg(ssrNetMsgCfg.KuangHuanXiaoZhen, KuangHuanXiaoZhen)
return KuangHuanXiaoZhen
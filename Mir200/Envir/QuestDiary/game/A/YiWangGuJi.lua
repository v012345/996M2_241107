local YiWangGuJi = {}
YiWangGuJi.ID = "�����ż�"
local npcID = 220
local mapID = "������½"
--local config = include("QuestDiary/cfgcsv/cfg_YiWangGuJi.lua") --����
local cost = {{}}
local give = {{}}
--��������
function YiWangGuJi.Request(actor)
    --local name, num = Player.checkItemNumByTable(actor, cost)
    --if name then
        --Player.sendmsgEx(actor, string.format("���|%s#249|����|%d#249", name, num))
        --return
    --end
    if not FCheckNPCRange(actor, npcID, 15) then
        Player.sendmsgEx(actor, "����PNC̫Զ!#249")
        return
    end
    if not FCheckLevel(actor, 120) then
        Player.sendmsgEx(actor, "�ȼ�����120��,����ʧ��!#249")
        return
    end
    FMapMoveEx(actor, mapID, 126,126,0)
end
--ͬ����Ϣ
-- function YiWangGuJi.SyncResponse(actor, logindatas)
--     local data = {}
--     local _login_data = {ssrNetMsgCfg.YiWangGuJi_SyncResponse, 0, 0, 0, data}
--     if logindatas then
--         table.insert(logindatas, _login_data)
--     else
--         Message.sendmsg(actor, ssrNetMsgCfg.YiWangGuJi_SyncResponse, 0, 0, 0, data)
--     end
-- end
-- --��¼����
-- local function _onLoginEnd(actor, logindatas)
--     YiWangGuJi.SyncResponse(actor, logindatas)
-- end
-- --�¼��ɷ�
-- GameEvent.add(EventCfg.onLoginEnd, _onLoginEnd, YiWangGuJi)
--ע��������Ϣ
Message.RegisterNetMsg(ssrNetMsgCfg.YiWangGuJi, YiWangGuJi)
return YiWangGuJi
local LianHunLu = {}
LianHunLu.ID = "����¯"
local npcID = 447
--local config = include("QuestDiary/cfgcsv/cfg_LianHunLu.lua") --����
local cost = { { "��ڤ�л�", 10 }, { "����ʯ", 888 }, { "Ԫ��", 888888 } }
local give = { { "������ת��", 1 } }
--��������
function LianHunLu.Request(actor)
    if not FCheckNPCRange(actor, npcID, 15) then
        Player.sendmsgEx(actor, "����PNC̫Զ!#249")
        return
    end
    local name, num = Player.checkItemNumByTable(actor, cost)
    if name then
        Player.sendmsgEx(actor, string.format("���|%s#249|����|%d#249", name, num))
        return
    end
    Player.takeItemByTable(actor, cost, "����¯")
    Player.giveItemByTable(actor, give, "����¯", 1, true)
    Player.sendmsgEx(actor, "��ϲ����|[������ת��]#250|,��ȥת����!")
end

--ͬ����Ϣ
-- function LianHunLu.SyncResponse(actor, logindatas)
--     local data = {}
--     local _login_data = {ssrNetMsgCfg.LianHunLu_SyncResponse, 0, 0, 0, data}
--     if logindatas then
--         table.insert(logindatas, _login_data)
--     else
--         Message.sendmsg(actor, ssrNetMsgCfg.LianHunLu_SyncResponse, 0, 0, 0, data)
--     end
-- end
-- --��¼����
-- local function _onLoginEnd(actor, logindatas)
--     LianHunLu.SyncResponse(actor, logindatas)
-- end
-- --�¼��ɷ�
-- GameEvent.add(EventCfg.onLoginEnd, _onLoginEnd, LianHunLu)
--ע��������Ϣ
Message.RegisterNetMsg(ssrNetMsgCfg.LianHunLu, LianHunLu)
return LianHunLu

local ZaoHuaJieJing = {}
ZaoHuaJieJing.ID = "�컯�ᾧ"
local npcID = 519
--local config = include("QuestDiary/cfgcsv/cfg_ZaoHuaJieJing.lua") --����
local cost = {{"��ʯ",5},{"����ʯ",300},{"�칤֮��",300},{"���",1000000}}
local give = {{"�컯�ᾧ",1}}
--��������
function ZaoHuaJieJing.Request(actor)
    local name, num = Player.checkItemNumByTable(actor, cost)
    if name then
        Player.sendmsgEx(actor, string.format("�ں�ʧ��,���|%s#249|����|%d#249", name, num))
        return
    end
    Player.takeItemByTable(actor, cost, "�컯�ᾧ�ں�")
    Player.giveItemByTable(actor, give, "�컯�ᾧ�ں�", 1, ConstCfg.binding)
    Player.sendmsgEx(actor, "�컯�ᾧ�ںϳɹ�")
end
--ͬ����Ϣ
-- function ZaoHuaJieJing.SyncResponse(actor, logindatas)
--     local data = {}
--     local _login_data = {ssrNetMsgCfg.ZaoHuaJieJing_SyncResponse, 0, 0, 0, data}
--     if logindatas then
--         table.insert(logindatas, _login_data)
--     else
--         Message.sendmsg(actor, ssrNetMsgCfg.ZaoHuaJieJing_SyncResponse, 0, 0, 0, data)
--     end
-- end
-- --��¼����
-- local function _onLoginEnd(actor, logindatas)
--     ZaoHuaJieJing.SyncResponse(actor, logindatas)
-- end
-- --�¼��ɷ�
-- GameEvent.add(EventCfg.onLoginEnd, _onLoginEnd, ZaoHuaJieJing)
--ע��������Ϣ
Message.RegisterNetMsg(ssrNetMsgCfg.ZaoHuaJieJing, ZaoHuaJieJing)
return ZaoHuaJieJing
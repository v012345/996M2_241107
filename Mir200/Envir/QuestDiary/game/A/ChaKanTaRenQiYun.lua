local ChaKanTaRenQiYun = {}
ChaKanTaRenQiYun.ID = "�鿴��������"
local npcID = 0
--local config = include("QuestDiary/cfgcsv/cfg_ChaKanTaRenQiYun.lua") --����
local cost = { {} }
local give = { {} }
--��������
function ChaKanTaRenQiYun.Request(actor)
    --local name, num = Player.checkItemNumByTable(actor, cost)
    --if name then
    --Player.sendmsgEx(actor, string.format("���|%s#249|����|%d#249", name, num))
    --return
    --end
end

function ChaKanTaRenQiYun.openUI(actor, arg1, arg2, arg3, data)
    local targetName = data[1]
    if not targetName then
        Player.sendmsgEx(actor, "��������#249")
        return
    end
    local targetObj = getplayerbyname(targetName)
    if not targetObj or targetObj == "" or targetObj == "0" or not isnotnull(targetObj) then
        Player.sendmsgEx(actor, string.format("���[%s]�����ߣ��޷��鿴��#249", targetName))
        return
    end
    local data = {}
    local unLockData = TianMing.GetLockState(targetObj)
    local myTianMingData = TianMing.GetTianMingList(targetObj)
    data.unLock = unLockData
    data.myTianMing = myTianMingData
    Message.sendmsg(actor, ssrNetMsgCfg.ChaKanTaRenQiYun_openUI, 0, 0, 0, data)
end

--ͬ����Ϣ
-- function ChaKanTaRenQiYun.SyncResponse(actor, logindatas)
--     local data = {}
--     local _login_data = {ssrNetMsgCfg.ChaKanTaRenQiYun_SyncResponse, 0, 0, 0, data}
--     if logindatas then
--         table.insert(logindatas, _login_data)
--     else
--         Message.sendmsg(actor, ssrNetMsgCfg.ChaKanTaRenQiYun_SyncResponse, 0, 0, 0, data)
--     end
-- end
-- --��¼����
-- local function _onLoginEnd(actor, logindatas)
--     ChaKanTaRenQiYun.SyncResponse(actor, logindatas)
-- end
-- --�¼��ɷ�
-- GameEvent.add(EventCfg.onLoginEnd, _onLoginEnd, ChaKanTaRenQiYun)
--ע��������Ϣ
Message.RegisterNetMsg(ssrNetMsgCfg.ChaKanTaRenQiYun, ChaKanTaRenQiYun)
return ChaKanTaRenQiYun

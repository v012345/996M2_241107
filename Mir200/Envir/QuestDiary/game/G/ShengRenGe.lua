local ShengRenGe = {}
ShengRenGe.ID = "ʥ�˸�"
local npcID = 804
local mapID = "ʥ�˸�"
--local config = include("QuestDiary/cfgcsv/cfg_ShengRenGe.lua") --����
local cost = {{}}
local give = {{}}
--��������
function ShengRenGe.Request(actor)
    local isInRange = FCheckNPCRange(actor, npcID, 15)
    if not isInRange then
        Player.sendmsgEx(actor, "����̫Զ#249")
        return
    end
    FMapMoveEx(actor,mapID,45,30,0)
    --local name, num = Player.checkItemNumByTable(actor, cost)
    --if name then
        --Player.sendmsgEx(actor, string.format("���|%s#249|����|%d#249", name, num))
        --return
    --end
end
--ͬ����Ϣ
-- function ShengRenGe.SyncResponse(actor, logindatas)
--     local data = {}
--     local _login_data = {ssrNetMsgCfg.ShengRenGe_SyncResponse, 0, 0, 0, data}
--     if logindatas then
--         table.insert(logindatas, _login_data)
--     else
--         Message.sendmsg(actor, ssrNetMsgCfg.ShengRenGe_SyncResponse, 0, 0, 0, data)
--     end
-- end
-- --��¼����
-- local function _onLoginEnd(actor, logindatas)
--     ShengRenGe.SyncResponse(actor, logindatas)
-- end
-- --�¼��ɷ�
-- GameEvent.add(EventCfg.onLoginEnd, _onLoginEnd, ShengRenGe)
--ע��������Ϣ
Message.RegisterNetMsg(ssrNetMsgCfg.ShengRenGe, ShengRenGe)
return ShengRenGe
local XieEShanGu = {}
XieEShanGu.ID = "а��ɽ��"
local npcID = 3458
--local config = include("QuestDiary/cfgcsv/cfg_XieEShanGu.lua") --����
local cost = {{}}
local give = {{}}
--��������
function XieEShanGu.Request(actor)
    local var = getplaydef(actor,VarCfg["U_�۷�ȼ�1"])
    if var < 5 then
        Player.sendmsgnewEx(actor, "�۷���������5��!")
        return
    end
    FMapMoveEx(actor, "а��ɽ��", 187, 184, 1)
    --local name, num = Player.checkItemNumByTable(actor, cost)
    --if name then
        --Player.sendmsgEx(actor, string.format("���|%s#249|����|%d#249", name, num))
        --return
    --end
end
--ͬ����Ϣ
-- function XieEShanGu.SyncResponse(actor, logindatas)
--     local data = {}
--     local _login_data = {ssrNetMsgCfg.XieEShanGu_SyncResponse, 0, 0, 0, data}
--     if logindatas then
--         table.insert(logindatas, _login_data)
--     else
--         Message.sendmsg(actor, ssrNetMsgCfg.XieEShanGu_SyncResponse, 0, 0, 0, data)
--     end
-- end
-- --��¼����
-- local function _onLoginEnd(actor, logindatas)
--     XieEShanGu.SyncResponse(actor, logindatas)
-- end
-- --�¼��ɷ�
-- GameEvent.add(EventCfg.onLoginEnd, _onLoginEnd, XieEShanGu)
--ע��������Ϣ
Message.RegisterNetMsg(ssrNetMsgCfg.XieEShanGu, XieEShanGu)
return XieEShanGu
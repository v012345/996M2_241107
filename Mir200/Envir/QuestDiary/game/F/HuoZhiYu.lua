local HuoZhiYu = {}
HuoZhiYu.ID = "��֮��"
local npcID = 3457
--local config = include("QuestDiary/cfgcsv/cfg_HuoZhiYu.lua") --����
local cost = {{}}
local give = {{}}
--��������
function HuoZhiYu.Request(actor)
    local var = getplaydef(actor,VarCfg["U_�۷�ȼ�1"])
    if var < 5 then
        Player.sendmsgnewEx(actor, "�۷���������5��!")
        return
    end
    FMapMoveEx(actor, "��֮��", 40, 40, 1)
end
--ͬ����Ϣ
-- function HuoZhiYu.SyncResponse(actor, logindatas)
--     local data = {}
--     local _login_data = {ssrNetMsgCfg.HuoZhiYu_SyncResponse, 0, 0, 0, data}
--     if logindatas then
--         table.insert(logindatas, _login_data)
--     else
--         Message.sendmsg(actor, ssrNetMsgCfg.HuoZhiYu_SyncResponse, 0, 0, 0, data)
--     end
-- end
-- --��¼����
-- local function _onLoginEnd(actor, logindatas)
--     HuoZhiYu.SyncResponse(actor, logindatas)
-- end
-- --�¼��ɷ�
-- GameEvent.add(EventCfg.onLoginEnd, _onLoginEnd, HuoZhiYu)
--ע��������Ϣ
Message.RegisterNetMsg(ssrNetMsgCfg.HuoZhiYu, HuoZhiYu)
return HuoZhiYu
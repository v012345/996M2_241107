local BeiMingShaoTa = {}
BeiMingShaoTa.ID = "��������"
local npcID = 330
--local config = include("QuestDiary/cfgcsv/cfg_BeiMingShaoTa.lua") --����
local cost = { {} }
local give = { {} }
--��������
function BeiMingShaoTa.Request(actor)
    local num = getplaydef(actor, VarCfg["U_����_��������_��������"])
    if num >= 100 then
        Player.sendmsgEx(actor, "���Ѿ��ύ���㹻���Ѿ�����,�����ٴ��ύ!#249")
        return
    end
    local itemNum = getbagitemcount(actor, "�Ѿ�����")
    if itemNum <= 0 then
        Player.sendmsgEx(actor, "�ύʧ��,��û���Ѿ�����!#249")
        return
    end
    takeitem(actor, "�Ѿ�����", itemNum, 0)
    setplaydef(actor, VarCfg["U_����_��������_��������"], num + itemNum)
    Player.sendmsgEx(actor, "���ύ��|" .. itemNum .. "#249|���Ѿ�����,�����Ŭ��!")
    if num + itemNum >= 100 then
        Player.sendmsgEx(actor, "���ύ���㹻��|�Ѿ�����#249|,��Ϊ���������|�Ѿ��ϳ�#249|����λ��!")
        local taskPanelID = getplaydef(actor, VarCfg["U_��������������"])
        if taskPanelID == 26 then
            FCheckTaskRedPoint(actor)
        end
    end
    BeiMingShaoTa.SyncResponse(actor)
end
function BeiMingShaoTa.SyncResponse(actor, logindatas)
    local num = getplaydef(actor, VarCfg["U_����_��������_��������"])
    local data = {}
    local _login_data = {ssrNetMsgCfg.BeiMingShaoTa_SyncResponse, num, 0, 0, data}
    if logindatas then
        table.insert(logindatas, _login_data)
    else
        Message.sendmsg(actor, ssrNetMsgCfg.BeiMingShaoTa_SyncResponse, num, 0, 0, data)
    end
end
--��¼����
local function _onLoginEnd(actor, logindatas)
    BeiMingShaoTa.SyncResponse(actor, logindatas)
end
-- --�¼��ɷ�
GameEvent.add(EventCfg.onLoginEnd, _onLoginEnd, BeiMingShaoTa)
--ע��������Ϣ
Message.RegisterNetMsg(ssrNetMsgCfg.BeiMingShaoTa, BeiMingShaoTa)
return BeiMingShaoTa

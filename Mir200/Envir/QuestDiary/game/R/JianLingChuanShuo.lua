local JianLingChuanShuo = {}
JianLingChuanShuo.ID = "���鴫˵"
local npcID = 235
local cost = { { "����֮��", 1 } }
--local config = include("QuestDiary/cfgcsv/cfg_JianLingChuanShuo.lua") --����
--��������
function JianLingChuanShuo.Request(actor)
    if not FCheckNPCRange(actor, npcID, 15) then
        Player.sendmsgEx(actor, "����PNC̫Զ!#249")
        return
    end
    local numCount = getplaydef(actor, VarCfg["U_����_���鴫˵"])
    if numCount >= 10 then
        Player.sendmsgEx(actor, string.format("�ύʧ��,���ֻ���ύ|%d#249|��", 10))
        return
    end
    local name, num = Player.checkItemNumByTable(actor, cost)
    if name then
        Player.sendmsgEx(actor, string.format("�ύʧ��,���|%s#249|����|%d#249", name, num))
        return
    end
    Player.takeItemByTable(actor, cost, "���鴫˵")
    setplaydef(actor, VarCfg["U_����_���鴫˵"], numCount + 1)
    local itemObj = linkbodyitem(actor, 1)
    if itemObj == "0" then
        Player.sendmsgEx(actor,"��û�д�������!#249")
        return
    end
    local g = getitemaddvalue(actor, itemObj, 1, 2,0)
    local m = getitemaddvalue(actor, itemObj, 1, 3,0)
    local d = getitemaddvalue(actor, itemObj, 1, 4,0)
    setitemaddvalue(actor, itemObj, 1, 2, g + 50)
    setitemaddvalue(actor, itemObj, 1, 3, m + 50)
    setitemaddvalue(actor, itemObj, 1, 4, d + 50)
    refreshitem(actor, itemObj)
    recalcabilitys(actor)
    JianLingChuanShuo.SyncResponse(actor)
end
--����װ����zhuangbeiqianghua
--װ��ǿ��
--ͬ����Ϣ
function JianLingChuanShuo.SyncResponse(actor)
    local data = {}
    local numCount = getplaydef(actor, VarCfg["U_����_���鴫˵"])
    Message.sendmsg(actor, ssrNetMsgCfg.JianLingChuanShuo_SyncResponse, numCount, 0, 0, data)
end

-- --��¼����
-- local function _onLoginEnd(actor, logindatas)
--     JianLingChuanShuo.SyncResponse(actor, logindatas)
-- end
-- --�¼��ɷ�
-- GameEvent.add(EventCfg.onLoginEnd, _onLoginEnd, JianLingChuanShuo)
--ע��������Ϣ
Message.RegisterNetMsg(ssrNetMsgCfg.JianLingChuanShuo, JianLingChuanShuo)
return JianLingChuanShuo
--init����

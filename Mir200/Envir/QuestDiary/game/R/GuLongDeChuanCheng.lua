local GuLongDeChuanCheng = {}
GuLongDeChuanCheng.ID = "�����Ĵ���"
local npcID = 236
local cost = { { "�����Ĵ���", 1 } }
-- local config = include("QuestDiary/cfgcsv/cfg_GuLongDeChuanCheng.lua") --����
--��������
function GuLongDeChuanCheng.Request(actor)
    if not FCheckNPCRange(actor, npcID, 15) then
        Player.sendmsgEx(actor, "����PNC̫Զ!#249")
        return
    end
    local numCount = getplaydef(actor, VarCfg["U_����_�����Ĵ���"])
    if numCount >= 5 then
        Player.sendmsgEx(actor, string.format("�ύʧ��,���ֻ���ύ|%d#249|��", 5))
        return
    end
    local name, num = Player.checkItemNumByTable(actor, cost)
    if name then
        Player.sendmsgEx(actor, string.format("�ύʧ��,���|%s#249|����|%d#249", name, num))
        return
    end
    Player.takeItemByTable(actor, cost, "�����Ĵ���")
    setplaydef(actor, VarCfg["U_����_�����Ĵ���"], numCount + 1)
    Player.setAttList(actor, "���Ը���")
    GuLongDeChuanCheng.SyncResponse(actor)
end
--ͬ����Ϣ
function GuLongDeChuanCheng.SyncResponse(actor)
    local data = {}
    local numCount = getplaydef(actor, VarCfg["U_����_�����Ĵ���"])
    Message.sendmsg(actor, ssrNetMsgCfg.GuLongDeChuanCheng_SyncResponse, numCount, 0, 0, data)
end
--��������
local function _onCalcAttr(actor, attrs)
    local shuxing = {}
    -- for _, value in ipairs(config) do
    --     local currLevel = getplaydef(actor, value.bindVar)
    --     if currLevel > 0 then
    --         shuxing[value.attrID] = currLevel
    --     end
    -- end
    local numCount = getplaydef(actor, VarCfg["U_����_�����Ĵ���"])
    if numCount > 0 then
        shuxing[206] = numCount * 1  --��󹥻���
        shuxing[207] = numCount * 1  --�������ֵ
        shuxing[81] = (numCount * 1) * 100 --�Թ���Ѫ
        calcAtts(attrs, shuxing, "�����Ĵ���")
    end
end
--����
GameEvent.add(EventCfg.onCalcAttr, _onCalcAttr, GuLongDeChuanCheng)
--ע��������Ϣ
Message.RegisterNetMsg(ssrNetMsgCfg.GuLongDeChuanCheng, GuLongDeChuanCheng)
return GuLongDeChuanCheng
--init����
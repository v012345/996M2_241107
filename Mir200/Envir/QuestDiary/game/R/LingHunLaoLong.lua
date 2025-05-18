local LingHunLaoLong = {}
LingHunLaoLong.ID = "�������"
local npcID = 324
--local config = include("QuestDiary/cfgcsv/cfg_LingHunLaoLong.lua") --����
local cost = {{"����Կ��",1}}
local give = {{}}
--��������
function LingHunLaoLong.Request(actor)
    if not FCheckNPCRange(actor, npcID, 15) then
        Player.sendmsgEx(actor, "����PNC̫Զ!#249")
        return
    end
    local count = getplaydef(actor,VarCfg["U_����_�������_����"])
    if count >= 10 then
        Player.sendmsgEx(actor, "���ֻ�ܽ��10�����#249")
        return
    end
    local name, num = Player.checkItemNumByTable(actor, cost)
    if name then
        Player.sendmsgEx(actor, string.format("���|%s#249|����|%d#249", name, num))
        return
    end
    Player.takeItemByTable(actor, cost, "�������")
    setplaydef(actor,VarCfg["U_����_�������_����"], count + 1)
    if count + 1 == 1 then
        local taskPanelID = getplaydef(actor, VarCfg["U_��������������"])
        if taskPanelID == 25 then
            FCheckTaskRedPoint(actor)
        end
    end
    Player.setAttList(actor, "���Ը���")
    LingHunLaoLong.SyncResponse(actor)
    ShengSiJingJie.SyncResponse(actor) --ͬ����������
    Player.sendmsgEx(actor, "������ɹ�!")
end
--ͬ����Ϣ
function LingHunLaoLong.SyncResponse(actor, logindatas)
    local data = {}
    local count = getplaydef(actor,VarCfg["U_����_�������_����"])
    local _login_data = {ssrNetMsgCfg.LingHunLaoLong_SyncResponse, count, 0, 0, data}
    if logindatas then
        table.insert(logindatas, _login_data)
    else
        Message.sendmsg(actor, ssrNetMsgCfg.LingHunLaoLong_SyncResponse, count, 0, 0, data)
    end
end
--��¼����
local function _onLoginEnd(actor, logindatas)
    LingHunLaoLong.SyncResponse(actor, logindatas)
end
--�¼��ɷ�
GameEvent.add(EventCfg.onLoginEnd, _onLoginEnd, LingHunLaoLong)

local function _onCalcAttr(actor, attrs)
    local shuxing = {}
    local count = getplaydef(actor,VarCfg["U_����_�������_����"])
    if count > 0 then
        shuxing[1] = 100 * count
        calcAtts(attrs, shuxing, "�������")
    end
end
--����
GameEvent.add(EventCfg.onCalcAttr, _onCalcAttr, LingHunLaoLong)
--ע��������Ϣ
Message.RegisterNetMsg(ssrNetMsgCfg.LingHunLaoLong, LingHunLaoLong)
return LingHunLaoLong
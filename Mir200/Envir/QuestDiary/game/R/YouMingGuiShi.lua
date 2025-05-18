local YouMingGuiShi = {}
YouMingGuiShi.ID = "��ڤ��ʹ"
local npcID = 446
--local config = include("QuestDiary/cfgcsv/cfg_YouMingGuiShi.lua") --����
-- local give = { { "����֮̾Ϣ��", 1 }, { "��������׹", 1 }, { "����֮��", 1 }, { "������", 1 }, { "�ƿذ���", 1 }, }
local cost = { {"�����ʯ",58},{"Ԫ��",3888888} }
--��������
local function isOpenMap(actor)
    local result
        if getflagstatus(actor,VarCfg["F_����_��ڤ��ʹ_��ͼ����"]) == 1 then
            result = true
        else
            result = false
    end 
    return result
end
function YouMingGuiShi.Request1(actor)
    if isOpenMap(actor) then
        Player.sendmsgEx(actor, "���Ѿ������˸ĵ�ͼ!#249")
        return
    end
    local name, num = Player.checkItemNumByTable(actor, cost)
    if name then
        Player.sendmsgEx(actor, string.format("����ʧ��,���|%s#249|����|%d#249", name, num))
        return
    end
    Player.takeItemByTable(actor, cost,"��ڤ��ʹ����")
    setflagstatus(actor,VarCfg["F_����_��ڤ��ʹ_��ͼ����"],1)
    YouMingGuiShi.SyncResponse(actor)
    Player.sendmsgEx(actor, "�����ɹ�!")
end
function YouMingGuiShi.Request2(actor)
    if isOpenMap(actor) then
        map(actor, "qipan")
    else
        Player.sendmsgEx(actor, "��û�п����ĵ�ͼ!#249")
    end
end
--ͬ����Ϣ
function YouMingGuiShi.SyncResponse(actor, logindatas)
    local data = {}
    local flag = getflagstatus(actor,VarCfg["F_����_��ڤ��ʹ_��ͼ����"])
    local _login_data = {ssrNetMsgCfg.YouMingGuiShi_SyncResponse, flag, 0, 0, data}
    if logindatas then
        table.insert(logindatas, _login_data)
    else
        Message.sendmsg(actor, ssrNetMsgCfg.YouMingGuiShi_SyncResponse, flag, 0, 0, data)
    end
end
--��¼����
local function _onLoginEnd(actor, logindatas)
    YouMingGuiShi.SyncResponse(actor, logindatas)
end
--�¼��ɷ�
GameEvent.add(EventCfg.onLoginEnd, _onLoginEnd, YouMingGuiShi)
--ע��������Ϣ
Message.RegisterNetMsg(ssrNetMsgCfg.YouMingGuiShi, YouMingGuiShi)
return YouMingGuiShi
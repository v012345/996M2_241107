local GuiLingYiShi = {}
GuiLingYiShi.ID = "������ʽ"
local npcID = 327
--local config = include("QuestDiary/cfgcsv/cfg_GuiLingYiShi.lua") --����
local cost = { { "����֮��", 20 }, { "����֮��", 20 } }
local mons = {
    "ɽ������ŵ˹[��������]",
    "��֮�������[����]",
    "�����Ԫ��ʦ",
    "���������ħ��",
    "��ر���ħ",
    "���¾�β����",
}
--��������
function GuiLingYiShi.Request(actor)
    if not FCheckNPCRange(actor, npcID, 15) then
        Player.sendmsgEx(actor, "����PNC̫Զ!#249")
        return
    end
    local name, num = Player.checkItemNumByTable(actor, cost)
    if name then
        Player.sendmsgEx(actor, string.format("���|%s#249|����|%d#249", name, num))
        return
    end
    Player.takeItemByTable(actor, cost, "������ʽ����")
    local x = getbaseinfo(actor, ConstCfg.gbase.x)
    local y = getbaseinfo(actor, ConstCfg.gbase.y)
    local monName = table.random(mons)
    genmon("������ַ", x, y, monName, 1, 1, 255)
    local num = getplaydef(actor, VarCfg["U_������ʽ�ٻ�_����"])
    if num < 10 then
        setplaydef(actor, VarCfg["U_������ʽ�ٻ�_����"],num+1)
    end
    Player.sendmsgEx(actor, string.format("��ɹ��ٻ���|%s#249", monName))
    Message.sendmsg(actor, ssrNetMsgCfg.GuiLingYiShi_Close, 0, 0, 0, {})
end

--ͬ����Ϣ
-- function GuiLingYiShi.SyncResponse(actor, logindatas)
--     local data = {}
--     local _login_data = {ssrNetMsgCfg.GuiLingYiShi_SyncResponse, 0, 0, 0, data}
--     if logindatas then
--         table.insert(logindatas, _login_data)
--     else
--         Message.sendmsg(actor, ssrNetMsgCfg.GuiLingYiShi_SyncResponse, 0, 0, 0, data)
--     end
-- end
-- --��¼����
-- local function _onLoginEnd(actor, logindatas)
--     GuiLingYiShi.SyncResponse(actor, logindatas)
-- end
-- --�¼��ɷ�
-- GameEvent.add(EventCfg.onLoginEnd, _onLoginEnd, GuiLingYiShi)

local function _onKillMon(actor, monobj, monName)
    local name = monName
    if name == "���¾�β����" then
        setflagstatus(actor,VarCfg["F_���¾�β������ɱ_���"],1)
    end
end
GameEvent.add(EventCfg.onKillMon, _onKillMon, GuiLingYiShi)
--ע��������Ϣ
Message.RegisterNetMsg(ssrNetMsgCfg.GuiLingYiShi, GuiLingYiShi)
return GuiLingYiShi

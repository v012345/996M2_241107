ShengSiJingJie = {}
ShengSiJingJie.ID = "��������"
local npcID = 325
--local config = include("QuestDiary/cfgcsv/cfg_ShengSiJingJie.lua") --����
local cost = {{"���",30000000}}
function go_ling_hun_lao_long_npc(actor)
    opennpcshowex(actor,324,2,2)
end
--��������
function ShengSiJingJie.Request1(actor)
    if not FCheckNPCRange(actor, npcID, 15) then
        Player.sendmsgEx(actor, "����PNC̫Զ!#249")
        return
    end
    if getflagstatus(actor,VarCfg["F_����_��������_��ͼ����"]) == 1 then
        Player.sendmsgEx(actor, "���Ѿ�������[��������]��ͼ!#249")
        return
    end
    local count = getplaydef(actor,VarCfg["U_����_�������_����"])
    if count < 10 then
        messagebox(actor, "�������������10��,�޷�������ͼ,�Ƿ�ǰ��NPC[�������]������?","@go_ling_hun_lao_long_npc","@exit")
        return
    end
    local name, num = Player.checkItemNumByTable(actor, cost)
    if name then
        Player.sendmsgEx(actor, string.format("����ʧ��,���|%s#249|����|%d#249", name, num))
        return
    end
    Player.takeItemByTable(actor, cost, "��������")
    setflagstatus(actor,VarCfg["F_����_��������_��ͼ����"],1)
    Player.sendmsgEx(actor, "��ϲ��ɹ�����[��������]��ͼ!")
end
function ShengSiJingJie.Request2(actor)
    if not FCheckNPCRange(actor, npcID, 15) then
        Player.sendmsgEx(actor, "����PNC̫Զ!#249")
        return
    end
    if getflagstatus(actor,VarCfg["F_����_��������_��ͼ����"]) == 0 then
        Player.sendmsgEx(actor, "��û�п���[��������]��ͼ,�޷�����!")
        return
    end
    map(actor, "��������")
end
--ͬ����Ϣ
function ShengSiJingJie.SyncResponse(actor, logindatas)
    local data = {}
    local count = getplaydef(actor,VarCfg["U_����_�������_����"])
    local flag = getflagstatus(actor,VarCfg["F_����_��������_��ͼ����"])
    local _login_data = {ssrNetMsgCfg.ShengSiJingJie_SyncResponse, count, flag, 0, data}
    if logindatas then
        table.insert(logindatas, _login_data)
    else
        Message.sendmsg(actor, ssrNetMsgCfg.ShengSiJingJie_SyncResponse, count, flag, 0, data)
    end
end
--��¼����
local function _onLoginEnd(actor, logindatas)
    ShengSiJingJie.SyncResponse(actor, logindatas)
end
--�¼��ɷ�
GameEvent.add(EventCfg.onLoginEnd, _onLoginEnd, ShengSiJingJie)
--ע��������Ϣ
Message.RegisterNetMsg(ssrNetMsgCfg.ShengSiJingJie, ShengSiJingJie)
return ShengSiJingJie
local ShenLongShiWei = {}
ShenLongShiWei.ID = "��������"
local npcID = 320
--local config = include("QuestDiary/cfgcsv/cfg_ShenLongShiWei.lua") --����
local cost = { { "�����ʯ", 10 } }
local give = { { "����������", 1 } }
--��ȡ����
function ShenLongShiWei.Request1(actor)
    setflagstatus(actor, VarCfg["F_����_��������_��ȡ"], 1)
    ShenLongShiWei.SyncResponse(actor)
end

--�ύ����
function ShenLongShiWei.Request2(actor)
    if not FCheckNPCRange(actor, npcID, 15) then
        Player.sendmsgEx(actor, "����PNC̫Զ!#249")
        return
    end
    local jindu = getplaydef(actor, VarCfg["U_����_��������_����"])
    if jindu >= 100 then
        Player.sendmsgEx(actor, "���Ѿ�����˷�ӡ!#249")
        return
    end
    local name, num = Player.checkItemNumByTable(actor, cost)
    if name then
        Player.sendmsgEx(actor, string.format("���|%s#249|����|%d#249", name, num))
        return
    end
    Player.takeItemByTable(actor, cost, "��������")
    local randomNum = math.random(6, 12)
    setplaydef(actor, VarCfg["U_����_��������_����"], jindu + randomNum)
    Player.sendmsgEx(actor, string.format("�ӹ̷�ӡ�ɹ�,��������|%s#249", randomNum))
    ShenLongShiWei.SyncResponse(actor)
end

--��ȡ����
function ShenLongShiWei.Request3(actor)
    local flag = getflagstatus(actor, VarCfg["F_����_��������_��ȡ����"])
    if flag == 1 then
        Player.sendmsgEx(actor, "���Ѿ���ȡ����!#249")
        return
    end
    local jindu = getplaydef(actor, VarCfg["U_����_��������_����"])
    if jindu < 100 then
        Player.sendmsgEx(actor, "�㻹û����ɷ�ӡ!#249")
        return
    end
    Player.giveItemByTable(actor, give, "������������", 1, true)
    setflagstatus(actor, VarCfg["F_����_��������_��ȡ����"], 1)
    Player.sendmsgEx(actor, "����ȡ��|����������#249|��ȥת����!")
    ShenLongShiWei.SyncResponse(actor)
end

--ͬ����Ϣ
function ShenLongShiWei.SyncResponse(actor, logindatas)
    local data = {}
    local falg = getflagstatus(actor, VarCfg["F_����_��������_��ȡ"])
    local falg2 = getflagstatus(actor, VarCfg["F_����_��������_��ȡ����"])
    local jindu = getplaydef(actor, VarCfg["U_����_��������_����"])
    local _login_data = { ssrNetMsgCfg.ShenLongShiWei_SyncResponse, falg, jindu, falg2, data }
    if logindatas then
        table.insert(logindatas, _login_data)
    else
        Message.sendmsg(actor, ssrNetMsgCfg.ShenLongShiWei_SyncResponse, falg, jindu, falg2, data)
    end
end

--��¼����
local function _onLoginEnd(actor, logindatas)
    ShenLongShiWei.SyncResponse(actor, logindatas)
end
--�¼��ɷ�
GameEvent.add(EventCfg.onLoginEnd, _onLoginEnd, ShenLongShiWei)
--ע��������Ϣ
Message.RegisterNetMsg(ssrNetMsgCfg.ShenLongShiWei, ShenLongShiWei)
return ShenLongShiWei

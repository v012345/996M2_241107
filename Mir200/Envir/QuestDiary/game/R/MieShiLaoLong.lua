local MieShiLaoLong = {}
MieShiLaoLong.ID = "��������"
local npcID = 508
--local config = include("QuestDiary/cfgcsv/cfg_MieShiLaoLong.lua") --����
local cost = { { "�����ӡʯ", 88 }, { "Ԫ��", 300000 } }
local give = { {} }
--��������
function MieShiLaoLong.Request1(actor)
    if not FCheckNPCRange(actor, npcID, 15) then
        Player.sendmsgEx(actor, "����PNC̫Զ!#249")
        return
    end
    if getflagstatus(actor,VarCfg["F_����_��������_����ͼ"]) == 1 then
        Player.sendmsgEx(actor, "���Ѿ�����˷�ӡ!#249")
        return
    end
    local name, num = Player.checkItemNumByTable(actor, cost)
        if name then
            Player.sendmsgEx(actor, string.format("���|%s#249|����|%d#249", name, num))
        return
    end
    Player.takeItemByTable(actor, cost, "��������")
    if randomex(30) then
        -- setflagstatus(actor,VarCfg["F_����_��������_����ͼ"],1)
        FSetTaskRedPoint(actor, VarCfg["F_����_��������_����ͼ"], 43)
        Player.sendmsgEx(actor, "�����ӡ�ɹ�!")
    else
        Player.sendmsgEx(actor, "�����ӡʧ����!#249")
    end
    
    MieShiLaoLong.SyncResponse(actor)
end
--��������
function MieShiLaoLong.Request2(actor)
    if getflagstatus(actor,VarCfg["F_����_��������_����ͼ"]) == 1 then
        map(actor, "��������")
    else
        Player.sendmsgEx(actor, "����ʧ��,δ���!#249")
    end
    
end

--ͬ����Ϣ
function MieShiLaoLong.SyncResponse(actor, logindatas)
    local data = {}
    local flag = getflagstatus(actor,VarCfg["F_����_��������_����ͼ"])
    local _login_data = {ssrNetMsgCfg.MieShiLaoLong_SyncResponse, flag, 0, 0, data}
    if logindatas then
        table.insert(logindatas, _login_data)
    else
        Message.sendmsg(actor, ssrNetMsgCfg.MieShiLaoLong_SyncResponse, flag, 0, 0, data)
    end
end
--��¼����
local function _onLoginEnd(actor, logindatas)
    MieShiLaoLong.SyncResponse(actor, logindatas)
end
--�¼��ɷ�
GameEvent.add(EventCfg.onLoginEnd, _onLoginEnd, MieShiLaoLong)
--ע��������Ϣ
Message.RegisterNetMsg(ssrNetMsgCfg.MieShiLaoLong, MieShiLaoLong)
return MieShiLaoLong

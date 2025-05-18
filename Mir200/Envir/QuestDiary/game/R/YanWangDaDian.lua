local YanWangDaDian = {}
YanWangDaDian.ID = "�������"
local npcID = 451
--local config = include("QuestDiary/cfgcsv/cfg_YanWangDaDian.lua") --����
local cost = { { "Ԫ��", 300000 }, { "����ˮ��", 188 } }
local give = { {} }
--��������
function YanWangDaDian.Request1(actor)
    if not FCheckNPCRange(actor, npcID, 15) then
        Player.sendmsgEx(actor, "����PNC̫Զ!#249")
        return
    end
    if getflagstatus(actor, VarCfg["F_����_��������Ƿ���"]) == 1 then
        Player.sendmsgEx(actor, "���Ѿ���������!#249")
        return
    end
    local name, num = Player.checkItemNumByTable(actor, cost)
        if name then
            Player.sendmsgEx(actor, string.format("���|%s#249|����|%d#249", name, num))
        return
    end
    Player.takeItemByTable(actor, cost, "�������")
    -- setflagstatus(actor, VarCfg["F_����_��������Ƿ���"], 1)
    FSetTaskRedPoint(actor, VarCfg["F_����_��������Ƿ���"], 35)
    Player.sendmsgEx(actor,"�ɹ�������������ͼ")
    YanWangDaDian.SyncResponse(actor)
end

function YanWangDaDian.Request2(actor)
    if not FCheckNPCRange(actor, npcID, 15) then
        Player.sendmsgEx(actor, "����PNC̫Զ!#249")
        return
    end
    if getflagstatus(actor, VarCfg["F_����_��������Ƿ���"]) == 0 then
        Player.sendmsgEx(actor, "û�п�����ͼ!#249")
        return
    else
        map(actor, "�������")
    end
end

--ͬ����Ϣ
function YanWangDaDian.SyncResponse(actor, logindatas)
    local data = {}
    local flag = getflagstatus(actor, VarCfg["F_����_��������Ƿ���"])
    local _login_data = { ssrNetMsgCfg.YanWangDaDian_SyncResponse, flag, 0, 0, data }
    if logindatas then
        table.insert(logindatas, _login_data)
    else
        Message.sendmsg(actor, ssrNetMsgCfg.YanWangDaDian_SyncResponse, flag, 0, 0, data)
    end
end

--��¼����
local function _onLoginEnd(actor, logindatas)
    YanWangDaDian.SyncResponse(actor, logindatas)
end
--�¼��ɷ�
GameEvent.add(EventCfg.onLoginEnd, _onLoginEnd, YanWangDaDian)

local function _onKillMon(actor, monobj)
    if FCheckMap(actor, "�޳���") then
        local count = getplaydef(actor, VarCfg["U_����_�������_����"])
        if count < 5000 then
            setplaydef(actor, VarCfg["U_����_�������_����"], count + 1)
            if (count + 1) >= 5000 then
                if getflagstatus(actor, VarCfg["F_����_��������Ƿ���"]) == 0 then
                    messagebox(actor, "�����޳���������С��,�ɹ�������������ͼ,��NPC������!")
                end
                -- setflagstatus(actor, VarCfg["F_����_��������Ƿ���"], 1)
                FSetTaskRedPoint(actor, VarCfg["F_����_��������Ƿ���"], 35)
                YanWangDaDian.SyncResponse(actor)
            end
        end
    end
end
GameEvent.add(EventCfg.onKillMon, _onKillMon, YanWangDaDian)

--ע��������Ϣ
Message.RegisterNetMsg(ssrNetMsgCfg.YanWangDaDian, YanWangDaDian)
return YanWangDaDian

local QianXianXianFeng = {}
QianXianXianFeng.ID = "����ǰ��"
local mapID = "����ǰ��"
local npcID = 329
--local config = include("QuestDiary/cfgcsv/cfg_QianXianXianFeng.lua") --����
local cost = {{}}
local give = {{}}
--��������
function QianXianXianFeng.Request(actor)
    if not FCheckNPCRange(actor, npcID, 15) then
        Player.sendmsgEx(actor, "����PNC̫Զ!#249")
        return
    end
    if getflagstatus(actor,VarCfg["F_����_����ǰ��_�Ƿ��ύ"]) == 1 then
        Player.sendmsgEx(actor, "���Ѿ���ȡ��������!#249")
        return
    end
    local num = getplaydef(actor, VarCfg["U_����_����ǰ��_ɱ������"])
    if num < 1000 then
        Player.sendmsgEx(actor, "ɱ����������1000!#249")
        return
    end
    setflagstatus(actor,VarCfg["F_����_����ǰ��_�Ƿ��ύ"],1)
    QianXianXianFeng.SyncResponse(actor)
    Player.setAttList(actor, "���Ը���")
end
--ͬ����Ϣ
function QianXianXianFeng.SyncResponse(actor)
    local data = {}
    local num = getplaydef(actor, VarCfg["U_����_����ǰ��_ɱ������"])
    Message.sendmsg(actor, ssrNetMsgCfg.QianXianXianFeng_SyncResponse, num, getflagstatus(actor,VarCfg["F_����_����ǰ��_�Ƿ��ύ"]), 0, data)
end
-- --��¼����
-- local function _onLoginEnd(actor, logindatas)
--     QianXianXianFeng.SyncResponse(actor, logindatas)
-- end
-- --�¼��ɷ�
-- GameEvent.add(EventCfg.onLoginEnd, _onLoginEnd, QianXianXianFeng)
-- VarCfg["U_����_����ǰ��_ɱ������"]

--��������
local function _onCalcAttr(actor, attrs)
    local shuxing = {}
    if getflagstatus(actor,VarCfg["F_����_����ǰ��_�Ƿ��ύ"]) == 1 then
        shuxing[200] = 1000
        calcAtts(attrs, shuxing, "�ȷ�ǰ���и�")
    end
end
--����
GameEvent.add(EventCfg.onCalcAttr, _onCalcAttr, QianXianXianFeng)

--ɱ�ִ���
local function _onKillMon(actor, monobj)
    local num = getplaydef(actor, VarCfg["U_����_����ǰ��_ɱ������"])
    if num >= 1000 then
        return
    end
    local myMapID = getbaseinfo(actor, ConstCfg.gbase.mapid)
    if mapID == myMapID then
        setplaydef(actor,VarCfg["U_����_����ǰ��_ɱ������"], num + 1)
    end
end
GameEvent.add(EventCfg.onKillMon, _onKillMon, QianXianXianFeng)
--ע��������Ϣ
Message.RegisterNetMsg(ssrNetMsgCfg.QianXianXianFeng, QianXianXianFeng)
return QianXianXianFeng
local JieJiuShaoNv = {}
JieJiuShaoNv.ID = "�����Ů"
local npcID = 516
--local config = include("QuestDiary/cfgcsv/cfg_JieJiuShaoNv.lua") --����
local cost = { {} }
local give = { { "Ԫ��", 100000 } }
local mapId = "�粼�ֶ���"
local shaoNvName = "��°�ӵ���Ů"
--��֤�Ƿ��б���
local function CheckBaby(actor)
    local result = false
    local ncount = getbaseinfo(actor, 38)
    for i = 0, ncount - 1 do
        local mon = getslavebyindex(actor, i)
        if mon and isnotnull(mon) then
            local mobName = getbaseinfo(mon, ConstCfg.gbase.name)
            if mobName == shaoNvName then
                result = mon
                break
            end
        end
    end
    return result
end

--��ȡ������ͼ����
local function getBabyPosition(actor)
    local mapid, x, y = nil, nil, nil
    local ncount = getbaseinfo(actor, 38)
    for i = 0, ncount - 1 do
        local mon = getslavebyindex(actor, i)
        if mon and isnotnull(mon) then
            local mobName = getbaseinfo(mon, ConstCfg.gbase.name)
            if mobName == shaoNvName then
                mapid, x, y = getbaseinfo(mon, ConstCfg.gbase.mapid), getbaseinfo(mon, ConstCfg.gbase.x),
                    getbaseinfo(mon, ConstCfg.gbase.y)
                break
            end
        end
    end
    return mapid, x, y
end

--��������
function JieJiuShaoNv.Request1(actor)
    if not FCheckNPCRange(actor, npcID, 15) then
        Player.sendmsgEx(actor, "����PNC̫Զ!#249")
        return
    end
    local count = getplaydef(actor, VarCfg["U_�����Ů_����"])
    if count >= 3 then
        Player.sendmsgEx(actor, "���Ѿ�����˸�����!#249")
        return
    end
    local monobj = CheckBaby(actor)
    if monobj then
        if not FCheckRange(monobj, 18, 18, 6) then
            Player.sendmsgEx(actor, "����̫Զ��!#249")
            return
        end
        killmonbyobj(actor, monobj, false, false, false)
        setplaydef(actor, VarCfg["U_�����Ů_����"], count + 1)
        if count + 1 == 1 then
            local taskPanelID = getplaydef(actor, VarCfg["U_��������������"])
            if taskPanelID == 48 then
                FCheckTaskRedPoint(actor)
            end
        end
        Player.sendmsgEx(actor, "��л��İ����������Ѿ����͵��ʼ�!#249")
        newdeletetask(actor, 202)
        local userid = getbaseinfo(actor, ConstCfg.gbase.id)
        Player.giveMailByTable(userid, 1, "�����Ů����", "����ȡ��Ľ����Ů����!", give)
        JieJiuShaoNv.SyncResponse(actor)
    else
        Player.sendmsgEx(actor, "��û�а��˴���ѽ!#249")
    end
    -- map(actor, mapId)
end

function JieJiuShaoNv.Request2(actor)
    if checktitle(actor,"��Ů������") then
        Player.sendmsgEx(actor,"���Ѿ���ȡ�˸óƺ�!#249")
        return
    end
    local count = getplaydef(actor, VarCfg["U_�����Ů_����"])
    if count < 3 then
        Player.sendmsgEx(actor, "���3�ν�Ȳſ�����ȡ�ƺŽ���!")
        return
    end
    confertitle(actor, "��Ů������")
    Player.sendmsgEx(actor, "��óƺ�:��Ů������")
end

--ͬ����Ϣ
function JieJiuShaoNv.SyncResponse(actor, logindatas)
    local data = {}
    local count = getplaydef(actor, VarCfg["U_�����Ů_����"])
    local _login_data = { ssrNetMsgCfg.JieJiuShaoNv_SyncResponse, count, 0, 0, data }
    if logindatas then
        table.insert(logindatas, _login_data)
    else
        Message.sendmsg(actor, ssrNetMsgCfg.JieJiuShaoNv_SyncResponse, count, 0, 0, data)
    end
end

--��¼����
local function _onLoginEnd(actor, logindatas)
    JieJiuShaoNv.SyncResponse(actor, logindatas)
end

--�¼��ɷ�
GameEvent.add(EventCfg.onLoginEnd, _onLoginEnd, JieJiuShaoNv)
--ɱ�ִ���
local function _onKillMon(actor, monobj)
    if randomex(1 ,288) then
        local count = getplaydef(actor, VarCfg["U_�����Ů_����"])
        if count >= 3 then
            return
        end
        local myMapID = getbaseinfo(actor, ConstCfg.gbase.mapid)
        if mapId == myMapID then
            if CheckBaby(actor) then
                return
            end
            recallmob(actor, shaoNvName, 7, 200, 0)
            darttime(actor, 1200, 0)
            newpicktask(actor, 202)
        end
    end
end
GameEvent.add(EventCfg.onKillMon, _onKillMon, JieJiuShaoNv)

--���񱻵������
local function _onClickTaskJieJiuShaoNv(actor, taskID)
    local mapid, x, y = getBabyPosition(actor)
    if mapid and x and y then
        if not FCheckMap(actor, mapid) then
            Player.sendmsgEx(actor, string.format("%s#249|�ڵ�ͼ|%s(%d,%d)#249", shaoNvName, mapid, x, y))
        else
            FMapMoveEx(actor, mapid, x, y)
        end
    end
end
GameEvent.add(EventCfg.onClickTaskJieJiuShaoNv, _onClickTaskJieJiuShaoNv, JieJiuShaoNv)

-- --��ʧ�ڳ�����
-- local function _onLoserCar(actor, car)
--     Player.sendmsgEx(actor, "�����Ů����ʧ��!")
--     newdeletetask(actor, 202)
-- end
-- GameEvent.add(EventCfg.onLoserCar, _onLoserCar, JieJiuShaoNv)
-- --�ڳ���������
-- -- local function _onCarDie(actor, car)
-- --     Player.sendmsgEx(actor, "�����Ů����ʧ��!")
-- --     newdeletetask(actor, 202)
-- -- end
-- -- GameEvent.add(EventCfg.onCarDie, _onCarDie, JieJiuShaoNv)
-- --�ڳ�����������
-- local function _onSlaveDamage(actor, hiter, car)
--     Player.sendmsgEx(actor, "[��°�ӵ���Ů]���ڱ����﹥��,������ǰ��Ԯ��!")
-- end
-- GameEvent.add(EventCfg.onSlaveDamage, _onSlaveDamage, JieJiuShaoNv)

--������������
local function _onSelfKillSlave(actor, mon)
    local monName = getbaseinfo(mon, ConstCfg.gbase.name)
    if monName == shaoNvName then
        Player.sendmsgEx(actor, "�����Ů����ʧ��!#249")
        newdeletetask(actor, 202)
    end
end
GameEvent.add(EventCfg.onSelfKillSlave, _onSelfKillSlave, JieJiuShaoNv)

local function _onClicknpc(actor, npcid, npcobj)
    if npcid == 513 then
        local shape = getplaydef(actor, VarCfg["U_ʱװ��ۼ�¼"])
        if shape ~= 40090 then
            Player.sendmsgEx(actor,"��û�лû���ѩ��,�޷�����#249")
            return
        end
        map(actor, mapId)
    end
end
GameEvent.add(EventCfg.onClicknpc, _onClicknpc, JieJiuShaoNv)

--ע��������Ϣ
Message.RegisterNetMsg(ssrNetMsgCfg.JieJiuShaoNv, JieJiuShaoNv)
return JieJiuShaoNv

local ZuLongZhiDi = {}
ZuLongZhiDi.ID = "����֮��"
local npcID = 333
--local config = include("QuestDiary/cfgcsv/cfg_ZuLongZhiDi.lua") --����
local cost = { { "���", 30000000 } }
local give = { {} }
--��������
function ZuLongZhiDi.Request1(actor)
    if not FCheckNPCRange(actor, npcID, 15) then
        Player.sendmsgEx(actor, "����PNC̫Զ!#249")
        return
    end
    if getflagstatus(actor, VarCfg["F_����_����֮��_�Ƿ���"]) == 1 then
        Player.sendmsgEx(actor, "���Ѿ������˴˵�ͼ,�����ظ�����!")
        return
    end
    local count = getplaydef(actor, VarCfg["U_����_����֮��_ɱ������"])
    if count < 10 then
        Player.sendmsgEx(actor, "������ͼʧ��,�������10��ɱ������!#249")
        return
    end
    local name, num = Player.checkItemNumByTable(actor, cost)
    if name then
        Player.sendmsgEx(actor, string.format("���|%s#249|����|%d#249", name, num))
        return
    end
    Player.takeItemByTable(actor, cost, "����֮�ؾ���")
    setflagstatus(actor, VarCfg["F_����_����֮��_�Ƿ���"], 1)
    Player.sendmsgEx(actor, "��ͼ�����ɹ�")
    ZuLongZhiDi.SyncResponse(actor)
end

function ZuLongZhiDi.Request2(actor)
    if not FCheckNPCRange(actor, npcID, 15) then
        Player.sendmsgEx(actor, "����PNC̫Զ!#249")
        return
    end
    if getflagstatus(actor, VarCfg["F_����_����֮��_�Ƿ���"]) == 1 then
        map(actor, "����֮��")
    else
        Player.sendmsgEx(actor, "���ȿ�����ͼ!#249")
    end
end

--ͬ����Ϣ
function ZuLongZhiDi.SyncResponse(actor)
    local data = {}
    local count = getplaydef(actor, VarCfg["U_����_����֮��_ɱ������"])
    local flag = getflagstatus(actor, VarCfg["F_����_����֮��_�Ƿ���"])
    Message.sendmsg(actor, ssrNetMsgCfg.ZuLongZhiDi_SyncResponse, count, flag, 0, data)
end

-- --��¼����
-- local function _onLoginEnd(actor, logindatas)
--     ZuLongZhiDi.SyncResponse(actor, logindatas)
-- end
-- --�¼��ɷ�
-- GameEvent.add(EventCfg.onLoginEnd, _onLoginEnd, ZuLongZhiDi)
--ע��������Ϣ
--ɱ�ִ���
local function _onKillMon(actor, monobj, monName)
    if checkitemw(actor, "̫���������[��ȫ��]", 1) then
        if randomex(2) then
            local mapId = getbaseinfo(monobj, ConstCfg.gbase.mapid)
            if mapId == "��֮����" then
                if monName ~= "��֮�ػ�" then
                    local x = getbaseinfo(monobj, ConstCfg.gbase.x)
                    local y = getbaseinfo(monobj, ConstCfg.gbase.y)
                    genmon(mapId, x, y, "��֮�ػ�", 0, 1, 249)
                    Player.sendmsgEx(actor, string.format("��ɱ����|%s#249|,��֮�ػ�������!", monName))
                end
            end
        end
    end
    if monName == "��֮�ػ�" then
        local count = getplaydef(actor, VarCfg["U_����_����֮��_ɱ������"])
        if count < 10 then
            setplaydef(actor, VarCfg["U_����_����֮��_ɱ������"], count + 1)
        end
    end
end
GameEvent.add(EventCfg.onKillMon, _onKillMon, ZuLongZhiDi)
Message.RegisterNetMsg(ssrNetMsgCfg.ZuLongZhiDi, ZuLongZhiDi)
return ZuLongZhiDi

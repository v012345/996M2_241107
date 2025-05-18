local DiZangWangDeShiLian = {}
local config = include("QuestDiary/cfgcsv/cfg_DiZangWangDeShiLian.lua") --����

local shiLianFunc = {
    [1] = function(actor)
        local myName = getbaseinfo(actor, ConstCfg.gbase.name)
        local oldMapId = getbaseinfo(actor, ConstCfg.gbase.mapid)
        local x = getbaseinfo(actor, ConstCfg.gbase.x)
        local y = getbaseinfo(actor, ConstCfg.gbase.y)
        local newMapId = myName .. "�˺�����"
        if oldMapId ~= "ۺ��" then
            Player.sendmsgEx(actor, "fuck you.#249")
            return
        end
        if checkmirrormap(newMapId) then
            delmirrormap(newMapId)
        end
        addmirrormap("02778", newMapId, "�ز���������", 15, oldMapId, 10056, x, y)
        genmon(newMapId, 55, 55, "�ز�����ľ��׮", 1, 1, 250)
        mapmove(actor, newMapId, 53, 56, 0)
        --���ز�����ʶ
        setplaydef(actor, VarCfg["M_�ز�����ʶ"], 1)
        setplaydef(actor, VarCfg["B_�ز�����һ���˺���¼"], 0)
    end,
    --��������
    [2] = function(actor)
        local time = 100
        local myName = getbaseinfo(actor, ConstCfg.gbase.name)
        local oldMapId = getbaseinfo(actor, ConstCfg.gbase.mapid)
        local x = getbaseinfo(actor, ConstCfg.gbase.x)
        local y = getbaseinfo(actor, ConstCfg.gbase.y)
        local newMapId = myName .. "��������"
        if oldMapId ~= "ۺ��" then
            Player.sendmsgEx(actor, "fuck you.#249")
            return
        end
        if checkmirrormap(newMapId) then
            delmirrormap(newMapId)
        end
        addmirrormap("06017", newMapId, "�ز���������", time, oldMapId, 15020, x, y)
        mapmove(actor, newMapId, 193, 180, 0)
        --���ز�����ʶ
        setplaydef(actor, VarCfg["M_�ز�����ʶ"], 2)
        --����NPC
        local npcInfo = {
            ["Idx"] = ConstCfg.customNpc["��������"],
            ["npcname"] = "�����������", -- NPC����
            ["appr"] = 1072, -- NPC����Ч��
            ["script"] = '��������',
            ["limit"] = time,
        }
        createnpc(newMapId, 34, 20, tbl2json(npcInfo))
    end,
    --��ħ����
    [3] = function(actor)
        local time = 180
        local myName = getbaseinfo(actor, ConstCfg.gbase.name)
        local oldMapId = getbaseinfo(actor, ConstCfg.gbase.mapid)
        local x = getbaseinfo(actor, ConstCfg.gbase.x)
        local y = getbaseinfo(actor, ConstCfg.gbase.y)
        local newMapId = myName .. "��ħ����"
        if oldMapId ~= "ۺ��" then
            Player.sendmsgEx(actor, "fuck you.#249")
            return
        end
        if checkmirrormap(newMapId) then
            delmirrormap(newMapId)
        end
        addmirrormap("02758", newMapId, "�ز���������", time, oldMapId, 10052, x, y)
        mapmove(actor, newMapId, 44, 36, 0)
        setplaydef(actor, VarCfg["M_�ز�����ʶ"], 3)
        Player.cloneSelfToHumanoid(actor, newMapId, 44, 36, myName .. "����ħ", "��ħ", 2, 249, 100)
    end,
    [4] = function(actor)
        local time = 600
        local myName = getbaseinfo(actor, ConstCfg.gbase.name)
        local oldMapId = getbaseinfo(actor, ConstCfg.gbase.mapid)
        local x = getbaseinfo(actor, ConstCfg.gbase.x)
        local y = getbaseinfo(actor, ConstCfg.gbase.y)
        local newMapId = myName .. "�׼�����"
        if oldMapId ~= "ۺ��" then
            Player.sendmsgEx(actor, "fuck you.#249")
            return
        end
        if checkmirrormap(newMapId) then
            delmirrormap(newMapId)
        end
        addmirrormap("02758", newMapId, "�ز���������", time, oldMapId, 10052, x, y)
        mapmove(actor, newMapId, 44, 36, 0)
        setplaydef(actor, VarCfg["M_�ز�����ʶ"], 4)
        --����NPC
        local npcInfo = {
            ["Idx"] = ConstCfg.customNpc["�׼�����"],
            ["npcname"] = "�׼�����", -- NPC����
            ["appr"] = 1329, -- NPC����Ч��
            ["script"] = '�׼�����',
            ["limit"] = time,
        }
        createnpc(newMapId, 43, 35, tbl2json(npcInfo))
    end,
    [5] = function(actor)
        local time = 1800
        local myName = getbaseinfo(actor, ConstCfg.gbase.name)
        local oldMapId = getbaseinfo(actor, ConstCfg.gbase.mapid)
        local x = getbaseinfo(actor, ConstCfg.gbase.x)
        local y = getbaseinfo(actor, ConstCfg.gbase.y)
        local newMapId = myName .. "��������"
        if oldMapId ~= "ۺ��" then
            Player.sendmsgEx(actor, "fuck you.#249")
            return
        end
        if checkmirrormap(newMapId) then
            delmirrormap(newMapId)
        end
        addmirrormap("06019", newMapId, "�ز���������", time, oldMapId, 010117, x, y)
        mapmove(actor, newMapId, 27, 27, 0)
        genmon(newMapId, 31, 26, "��˫�������[�޼�����]", 1, 1, 249)
        setplaydef(actor, VarCfg["M_�ز�����ʶ"], 5)
    end
}

function DiZangWangDeShiLian.Request(actor)
    local layerNum = getplaydef(actor, VarCfg["U_�ز���������"])
    local currLayerNum = layerNum + 1
    local func = shiLianFunc[currLayerNum]
    if not func then
        Player.sendmsgEx(actor, "��������ʧ��,���Ѿ��������������!#249")
        return
    end
    local cfg = config[currLayerNum]
    if not cfg then
        Player.sendmsgEx(actor, "��������!!!#249")
        return
    end
    local name, num = Player.checkItemNumByTable(actor, cfg.cost)
    if name then
        Player.sendmsgEx(actor, string.format("���|%s#249|����|%s#249", name, num))
        return
    end
    Player.takeItemByTable(actor, cfg.cost, "�ز���������")
    func(actor)
end

--ע��������Ϣ
Message.RegisterNetMsg(ssrNetMsgCfg.DiZangWangDeShiLian, DiZangWangDeShiLian)

--ͬ������
function DiZangWangDeShiLian.SyncResponse(actor, logindatas, data)
    local data = {}
    local layer = getplaydef(actor, VarCfg["U_�ز���������"])
    local _login_data = { ssrNetMsgCfg.DiZangWangDeShiLian_SyncResponse, layer, 0, 0, data }
    if logindatas then
        table.insert(logindatas, _login_data)
    else
        Message.sendmsg(actor, ssrNetMsgCfg.DiZangWangDeShiLian_SyncResponse, layer, 0, 0, data)
    end
end

--��¼����
local function _onLoginEnd(actor, logindatas)
    DiZangWangDeShiLian.SyncResponse(actor, logindatas)
end
GameEvent.add(EventCfg.onLoginEnd, _onLoginEnd, DiZangWangDeShiLian)

-- ����ҹ���ǰ����  �ز����������� �����˺�����+10%
local function _onStruckDamagePlayer(actor, Target, Hiter, MagicId, Damage, attackDamageData)
    if not checktitle(actor, "�ز���������") then return end
    if MagicId == 26 or MagicId == 66 or MagicId == 56 then
        attackDamageData.damage = attackDamageData.damage - Damage *0.1
    end
end
GameEvent.add(EventCfg.onStruckDamagePlayer, _onStruckDamagePlayer, DiZangWangDeShiLian)


--�л���ͼ����
local function _goSwitchMap(actor, cur_mapid, former_mapid)
    local myName = getbaseinfo(actor, ConstCfg.gbase.name)
    local layer1MapId = myName .. "�˺�����"
    local layer2MapId = myName .. "��������"
    local layer3MapId = myName .. "��ħ����"
    local layer4MapId = myName .. "�׼�����"
    local layer5MapId = myName .. "��������"
    if former_mapid == layer1MapId or former_mapid == layer2MapId or former_mapid == layer3MapId or former_mapid == layer4MapId or former_mapid == layer5MapId then
        if former_mapid == layer2MapId then
            delnpc("�����������", former_mapid)
        elseif former_mapid == layer4MapId then
            delnpc("�׼�����", former_mapid)
        elseif former_mapid == layer5MapId then
            local myName = getbaseinfo(actor, ConstCfg.gbase.name)
            if cur_mapid ~= myName .. "�ز�������������" then
                Message.sendmsg(actor, ssrNetMsgCfg.DiZangWangDeShiLian_SyncResponseLayer2End, 4, 0)
            end
            delnpc("��������[���ص�ͼ]", former_mapid)
        end
        delmirrormap(former_mapid)
    end
end
GameEvent.add(EventCfg.goSwitchMap, _goSwitchMap, DiZangWangDeShiLian)

--��������ǰ����
local function _onAttackDamageMonster(actor, Target, Hiter, MagicId, Damage, Model, attackDamageData)
    local layer1Flag = getplaydef(actor, VarCfg["M_�ز�����ʶ"])
    if layer1Flag == 1 then
        local damageRecord = getplaydef(actor, VarCfg["B_�ز�����һ���˺���¼"])
        damageRecord = damageRecord + Damage
        setplaydef(actor, VarCfg["B_�ز�����һ���˺���¼"], damageRecord)
        Message.sendmsg(actor, ssrNetMsgCfg.DiZangWangDeShiLian_SyncResponseDamage, 0, 0, 0, { damageRecord })
        if damageRecord > 200000000 then
            setplaydef(actor, VarCfg["M_�ز�����ʶ"], 0)
            setplaydef(actor, VarCfg["U_�ز���������"], 1)
            local myName = getbaseinfo(actor, ConstCfg.gbase.name)
            local newMapId = myName .. "�˺�����"
            delmirrormap(newMapId)
            DiZangWangDeShiLian.SyncResponse(actor)
        end
    end
end
GameEvent.add(EventCfg.onAttackDamageMonster, _onAttackDamageMonster, DiZangWangDeShiLian)

local function _onKillMon(actor, monobj, monName)
    local layerFlag = getplaydef(actor, VarCfg["M_�ز�����ʶ"])
    if layerFlag == 3 then
        local mapId = getbaseinfo(actor, ConstCfg.gbase.mapid)
        local mobNum = getmoncount(mapId, -1, true)
        if mobNum < 1 then
            delmirrormap(mapId)
            setplaydef(actor, VarCfg["U_�ز���������"], 3)
            Message.sendmsg(actor, ssrNetMsgCfg.DiZangWangDeShiLian_SyncResponse, 3, 1)
        end
    elseif layerFlag == 5 then
        local mobName = monName
        if mobName == "��˫�������[�޼�����]" then
            setplaydef(actor, VarCfg["U_�ز���������"], 5)
            setplaydef(actor, VarCfg["M_�ز�����ʶ"], 0)
            Message.sendmsg(actor, ssrNetMsgCfg.DiZangWangDeShiLian_SyncResponseLayer2End, 5, 1)
            messagebox(actor, "��ϲ��ͨ��ȫ������,��óƺ�[�ز���������],�ڱ���ͼ30,30ˢ����һ���������ص�ͼ��NPC!")
            local npcInfo = {
                ["Idx"] = ConstCfg.customNpc["��������"],
                ["npcname"] = "��������[���ص�ͼ]", -- NPC����
                ["appr"] = 454, -- NPC����Ч��
                ["script"] = '��������',
                ["limit"] = 3000,
            }
            confertitle(actor, "�ز���������")
            local mapId = getbaseinfo(actor, ConstCfg.gbase.mapid)
            createnpc(mapId, 30, 30, tbl2json(npcInfo))
            Player.setAttList(actor,"��������")
        end
    end
end

GameEvent.add(EventCfg.onKillMon, _onKillMon, DiZangWangDeShiLian)

--��������a
local function _onPlaydie(actor, hiter)
    local mobName = getbaseinfo(hiter, ConstCfg.gbase.name)
    if mobName == "��˫�������[�޼�����]" then
        Message.sendmsg(actor, ssrNetMsgCfg.DiZangWangDeShiLian_SyncResponseLayer2End, 4, 0)
    end
end
GameEvent.add(EventCfg.onPlaydie, _onPlaydie, DiZangWangDeShiLian)

--��������
local function _onCalcBeiGong(actor, beiGongs)
    local flag = getplaydef(actor, VarCfg["U_�ز���������"])
    if flag > 4 then
        local beigong = 15
        if beigong then
            beiGongs[1] = beiGongs[1] + beigong
        end
    end
end
GameEvent.add(EventCfg.onCalcBeiGong, _onCalcBeiGong, DiZangWangDeShiLian)


return DiZangWangDeShiLian

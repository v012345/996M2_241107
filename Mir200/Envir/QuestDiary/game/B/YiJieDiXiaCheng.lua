local YiJieDiXiaCheng = {}
local timeRanges = {
    { 13, 29, 13, 59 },
    { 19, 29, 19, 59 },
}

local Mobconfig1 = {
    { monName = "������ħ(���)", num = 15, x = 93, y = 80, range = 15, color = 251 },
    { monName = "ħ��֮��(���)", num = 2, x = 93, y = 80, range = 15, color = 251 },
    { monName = "����ħ��(���)", num = 15, x = 93, y = 80, range = 15, color = 251 },
    { monName = "�ؼ�����(���)", num = 15, x = 93, y = 80, range = 15, color = 251 },

    { monName = "������ħ(���)", num = 15, x = 201, y = 91, range = 15, color = 251 },
    { monName = "ħ��֮��(���)", num = 2, x = 201, y = 91, range = 15, color = 251 },
    { monName = "����ħ��(���)", num = 15, x = 201, y = 91, range = 15, color = 251 },
    { monName = "�ؼ�����(���)", num = 15, x = 201, y = 91, range = 15, color = 251 },

    { monName = "������ħ(���)", num = 15, x = 215, y = 205, range = 15, color = 251 },
    { monName = "ħ��֮��(���)", num = 2, x = 215, y = 205, range = 15, color = 251 },
    { monName = "����ħ��(���)", num = 15, x = 215, y = 205, range = 15, color = 251 },
    { monName = "�ؼ�����(���)", num = 15, x = 215, y = 205, range = 15, color = 251 },
}

local Mobconfig2 = {
    { monName = "���׻�����(���)", num = 1, x = 65, y = 208, range = 1, color = 251 },
    { monName = "���׻�����(���)", num = 1, x = 125, y = 266, range = 1, color = 251 },
}

local MobconfigGeRen1 = {
    { monName = "������ħ(���)", num = 7, x = 93, y = 80, range = 4, color = 251 },
    { monName = "ħ��֮��(���)", num = 1, x = 93, y = 80, range = 4, color = 251 },
    { monName = "����ħ��(���)", num = 7, x = 93, y = 80, range = 4, color = 251 },
    { monName = "�ؼ�����(���)", num = 7, x = 93, y = 80, range = 4, color = 251 },

    { monName = "������ħ(���)", num = 7, x = 201, y = 91, range = 4, color = 251 },
    { monName = "ħ��֮��(���)", num = 1, x = 201, y = 91, range = 4, color = 251 },
    { monName = "����ħ��(���)", num = 7, x = 201, y = 91, range = 4, color = 251 },
    { monName = "�ؼ�����(���)", num = 7, x = 201, y = 91, range = 4, color = 251 },

    { monName = "������ħ(���)", num = 7, x = 215, y = 205, range = 4, color = 251 },
    { monName = "ħ��֮��(���)", num = 1, x = 215, y = 205, range = 4, color = 251 },
    { monName = "����ħ��(���)", num = 7, x = 215, y = 205, range = 4, color = 251 },
    { monName = "�ؼ�����(���)", num = 7, x = 215, y = 205, range = 4, color = 251 },
}


local mapID = "dixiachengyiceng"
-- [dixiachengyiceng �����³����] n
-- [dixiachengyiceng �����³�һ��]
-- [dixiachengerceng �����³Ƕ���]
-- [dixiachengsanceng �����³�����]
-- [dixiachengdiceng �����³�(��)]

local mapIDs = {
    ["�����³�һ��"] = "dixiachengyiceng",
    ["�����³Ƕ���"] = "dixiachengerceng",
    ["�����³�����"] = "dixiachengsanceng",
    ["�����³�(��)"] = "dixiachengdiceng",
}

--�ж��Ƿ��ڻʱ��
local function isPublicTime()
    return getsysvar(VarCfg["G_����Գ�������ʶ"]) == 1
end

local function isPrivateTime(actor)
    return getplaydef(actor, VarCfg["J_�����³ǽ����Ƿ����"]) == 0
end

--���˸���
local function privateTask(actor)
    setflagstatus(actor, VarCfg["F_�����³ǽ��빫��or˽��"], 1)
    FSetTaskRedPoint(actor, VarCfg["F_�����³ǽ���"], 16)
    local name = getbaseinfo(actor, ConstCfg.gbase.name)
    local newMapId = name .. mapIDs["�����³�һ��"]
    if checkmirrormap(newMapId) then
        mapmove(actor, newMapId, 89, 204)
        sendmsg("0", 2,
            '{"Msg":"[' ..
            name .. ']���������ս��[����]","FColor":251,"BColor":0,"Type":6,"Time":6,"SendName":"ϵͳ��","SendId":"123","X":"-300"}')
        local remainingTime = tonumber(mirrormaptime(newMapId, 0)) or 0
        local monMap = getmoncount(newMapId, -1, true)
        if monMap > 0 then
            local monIdx = tonumber(getdbmonfieldvalue("��硤������˹[���˼�BOSS]", "idx")) or 0
            local bossNum = getmoncount(newMapId, monIdx, true)
            if bossNum > 0 then
                senddelaymsg(actor, "���ս��һ���ڵĹ�����ȫ����ɱ���ڵ�ͼ�м�(142.142)�ٻ���[��硤������˹],����ʣ��ʱ��:%s", remainingTime or 0, 250, 1)
            else
                senddelaymsg(actor, "ǰ����ͼ(93,80),(201,91),(215,205)��ɱ����,����ʣ��ʱ��:%s", remainingTime, 250, 1)
            end
        else
            senddelaymsg(actor, "���ս����[��硤������˹]�ѱ���ɱ,��ǰ��(154.137)������һ��,����ʣ��ʱ��:%s", remainingTime or 0, 250, 1)
            local name = getbaseinfo(actor, ConstCfg.gbase.name)
            local newMapId = name .. mapIDs["�����³�һ��"]
            local newMapId2 = name .. mapIDs["�����³Ƕ���"]
            local newMapId3 = name .. mapIDs["�����³�����"]
            local newMapId4 = name .. mapIDs["�����³�(��)"]
            mapeffect(2001 + math.random(1000), newMapId, 154, 137, 17009, 1800, 0, actor)
            addmapgate(newMapId, newMapId, 154, 137, 2, newMapId2, 39, 298, 1800)
        end
    else
        local isBool = isPrivateTime(actor)
        if not isBool then
            Player.sendmsgEx(actor, "�����Ѿ�������,����������!#249")
            return
        end
        setplaydef(actor, VarCfg["U_���ս���׼�1"], 0)
        setplaydef(actor, VarCfg["U_���ս���׼�2"], 0)
        addmirrormap(mapIDs["�����³�һ��"], newMapId, "�����³�һ��", 1800, "������½", 015042, 241, 156)
        setplaydef(actor, VarCfg["J_�����³ǽ����Ƿ����"], 1)
        for _, value in ipairs(MobconfigGeRen1) do
            genmon(newMapId, value.x, value.y, value.monName, value.range, value.num, value.color)
        end
        mapmove(actor, newMapId, 89, 204)
        sendmsg("0", 2,
            '{"Msg":"[' ..
            name .. ']���������ս��[����]","FColor":251,"BColor":0,"Type":6,"Time":6,"SendName":"ϵͳ��","SendId":"123","X":"-300"}')
        local remainingTime = tonumber(mirrormaptime(newMapId, 0)) or 0
        senddelaymsg(actor, "ǰ����ͼ(93,80),(201,91),(215,205)��ɱ����,����ʣ��ʱ��:%s", remainingTime, 250, 1)
    end
end

--��������
local function publicTask(actor)
    local isBool = isPublicTime()
    if not isBool then
        Player.sendmsgEx(actor, "��ǰ���ڿ���ʱ����,��ֹ����!#249")
        return
    end
    setflagstatus(actor, VarCfg["F_�����³ǽ��빫��or˽��"], 0)
    FSetTaskRedPoint(actor, VarCfg["F_�����³ǽ���"], 16)
    mapmove(actor, mapID, 89, 204)
    local name = getbaseinfo(actor, ConstCfg.gbase.name)
    sendmsg("0", 2,
        '{"Msg":"[' ..
        name .. ']���������ս��[�Ŷ�]","FColor":251,"BColor":0,"Type":6,"Time":6,"SendName":"ϵͳ��","SendId":"123","X":"-300"}')
end
function YiJieDiXiaCheng.Request(actor, arg1)
    if arg1 == 1 then
        privateTask(actor)
    elseif arg1 == 2 then
        publicTask(actor)
    end
end

--���ʼ

local function _onYiJieLieChangStart()
    FsendHuoDongGongGao("���ս����ѿ���.")
    setsysvar(VarCfg["G_���ս���׼�1"], 0)
    setsysvar(VarCfg["G_���ս���׼�2"], 0)
    setsysvar(VarCfg["G_���ս��һ��ɱ��"], 0)
    killmonsters("dixiachengyiceng", "*", 0, false)
    killmonsters("dixiachengerceng", "*", 0, false)
    killmonsters("dixiachengdiceng", "*", 0, false)
    delmapgate("dixiachengyiceng", "dixiachengyiceng")
    delmapgate("dixiachengerceng", "dixiachengerceng")
    delmapgate("dixiachengsanceng", "dixiachengsanceng")
    for _, value in ipairs(Mobconfig1) do
        genmon(mapID, value.x, value.y, value.monName, value.range, value.num, value.color)
    end
end
--���ʼ
GameEvent.add(EventCfg.onYiJieLieChangStart, _onYiJieLieChangStart, YiJieDiXiaCheng)

function yan_chi_chuang_jian_npc(actor, newMapId2)
    local num = getsysvar(VarCfg["G_NPCID���"])
    num = num + 1
    local npcInfo = {
        ["Idx"] = ConstCfg.customNpc["���������new"] + num, -- �Զ���NPC��Idx��NPC�������ʱ�����������ᴫ��Idxֵ
        ["npcname"] = "�������", -- NPC����
        ["appr"] = 7280, -- NPC����Ч��
        ["script"] = '���������', -- NPC��ؽű����ƣ���ʾEnvir\Market_def\NewNPC.txt
        ["limit"] = 1800, -- �������� (��) ����64_24.05.23����
    }
    createnpc(newMapId2, 77, 48, tbl2json(npcInfo))
    --����NPC��
    num = num + 1
    local npcInfo = {
        ["Idx"] = ConstCfg.customNpc["���������new"] + num, -- �Զ���NPC��Idx��NPC�������ʱ�����������ᴫ��Idxֵ
        ["npcname"] = "�������", -- NPC����
        ["appr"] = 7281, -- NPC����Ч��
        ["script"] = '���������', -- NPC��ؽű����ƣ���ʾEnvir\Market_def\NewNPC.txt
        ["limit"] = 1800, -- �������� (��) ����64_24.05.23����
    }
    createnpc(newMapId2, 261, 248, tbl2json(npcInfo))
    setsysvar(VarCfg["G_NPCID���"], num)
end

local function _onKillMon(actor, monobj, monName)
    -- 0=��������
    if getflagstatus(actor, VarCfg["F_�����³ǽ��빫��or˽��"]) == 0 then
        if FCheckMap(actor, "dixiachengyiceng") then
            if string.find(monName, "%(���%)") then
                local monMap = getmoncount("dixiachengyiceng", -1, true)
                if monMap == 0 then
                    FsendHuoDongGongGao("���ս��һ���ڵĹ�����ȫ����ɱ���ڵ�ͼ�м�(142.142)�ٻ���[��硤������˹]")
                    genmon("dixiachengyiceng", 146, 146, "��硤������˹", 1, 1, 251)
                end
            end

            if monName == "��硤������˹" then
                FsendHuoDongGongGao("���ս����[��硤������˹]�ѱ���ɱ,��ǰ��(154.137)������һ��!")
                setsysvar(VarCfg["G_���ս��һ��ɱ��"], 0)
                for _, value in ipairs(Mobconfig2) do
                    genmon("dixiachengerceng", value.x, value.y, value.monName, value.range, value.num, value.color) --ˢ����
                end
                mapeffect(2000, "dixiachengyiceng", 154, 137, 17009, 600, 0, actor)
                addmapgate("dixiachengyiceng", "dixiachengyiceng", 154, 137, 2, "dixiachengerceng", 39, 297, 600)
            end
        elseif FCheckMap(actor, "dixiachengerceng") then
            if monName == "��硤ͼ���Ȳ�" then
                FsendHuoDongGongGao("���ս������[��硤ͼ���Ȳ�]�ѱ���ɱ,�ڵ�ͼ(221.89)�ٻ���[��硤���ն�!")
                genmon("dixiachengerceng", 221, 89, "��硤���ն�", 1, 1, 251)
            elseif monName == "��硤���ն�" then
                FsendHuoDongGongGao("���ս������[��硤���ն�]�ѱ���ɱ,��ǰ��(226.85)������һ��!")
                mapeffect(2000, "dixiachengerceng", 226, 85, 17009, 600, 0, actor)
                addmapgate("dixiachengerceng", "dixiachengerceng", 226, 85, 2, "dixiachengsanceng", 249, 264, 600)

                mapeffect(2000, "dixiachengsanceng", 147, 155, 17009, 1200, 0, actor)
                addmapgate("dixiachengsanceng", "dixiachengsanceng", 147, 155, 2, "dixiachengdiceng", 45, 107, 1200)
                genmon("dixiachengdiceng", 59, 92, "��硤������˹[�ŶӼ�BOSS]", 1, 1, 251)
            end
        end
    else
        --���˸���
        local name = getbaseinfo(actor, ConstCfg.gbase.name)
        local newMapId = name .. mapIDs["�����³�һ��"]
        local newMapId2 = name .. mapIDs["�����³Ƕ���"]
        local newMapId3 = name .. mapIDs["�����³�����"]
        local newMapId4 = name .. mapIDs["�����³�(��)"]
        if FCheckMap(actor, newMapId) then
            if string.find(monName, "%(���%)") then
                local monMap = getmoncount(newMapId, -1, true)
                if monMap == 0 then
                    local remainingTime = tonumber(mirrormaptime(newMapId, 0)) or 0
                    senddelaymsg(actor, "���ս��һ���ڵĹ�����ȫ����ɱ���ڵ�ͼ�м�(142.142)�ٻ���[��硤������˹],����ʣ��ʱ��:%s", remainingTime or 0, 250,
                        1)
                    genmon(newMapId, 146, 146, "��硤������˹[���˼�BOSS]", 1, 1, 251)
                end
            end
            if monName == "��硤������˹[���˼�BOSS]" then
                --��������
                local remainingTime = tonumber(mirrormaptime(newMapId, 0)) or 0
                senddelaymsg(actor, "���ս����[��硤������˹]�ѱ���ɱ,��ǰ��(154.137)������һ��,����ʣ��ʱ��:%s", remainingTime or 0, 250, 1)
                local newMapId2 = name .. mapIDs["�����³Ƕ���"]
                addmirrormap(mapIDs["�����³Ƕ���"], newMapId2, "�����³Ƕ���", remainingTime, "������½", 015044, 241, 155)
                for _, value in ipairs(Mobconfig2) do
                    genmon(newMapId2, value.x, value.y, value.monName, value.range, value.num, value.color) --ˢ����
                end
                mapeffect(2001 + math.random(1000), newMapId, 154, 137, 17009, 1800, 0, actor)
                addmapgate(newMapId, newMapId, 154, 137, 2, newMapId2, 39, 298, 1800)
                delaygoto(actor, 1000, "yan_chi_chuang_jian_npc," .. newMapId2)
            end
            --���㴥��
        elseif FCheckMap(actor, newMapId2) then
            if monName == "��硤ͼ���Ȳ�[���˼�BOSS]" then
                local remainingTime = tonumber(mirrormaptime(newMapId, 0)) or 0
                senddelaymsg(actor, "[��硤ͼ���Ȳ�]�ѱ���ɱ,�ڵ�ͼ(221.89)�ٻ���[��硤���ն�],����ʣ��ʱ��:%s", remainingTime or 0, 250, 1)
                genmon(newMapId2, 221, 89, "��硤���ն�[���˼�BOSS]", 1, 1, 251)
            elseif monName == "��硤���ն�[���˼�BOSS]" then
                local remainingTime = tonumber(mirrormaptime(newMapId, 0)) or 0
                senddelaymsg(actor, "[��硤���ն�]�ѱ���ɱ,��ǰ��(226.85)������һ��,����ʣ��ʱ��:%s", remainingTime or 0, 250, 1)
                addmirrormap(mapIDs["�����³�����"], newMapId3, "�����³�����", remainingTime, "������½", 015044, 241, 155)
                mapeffect(2000 + math.random(1000), newMapId2, 226, 85, 17009, remainingTime, 0, actor)
                addmapgate(newMapId2, newMapId2, 226, 85, 2, newMapId3, 249, 264, remainingTime)
                --�������һ��
                addmirrormap(mapIDs["�����³�(��)"], newMapId4, "�����³�(��)", remainingTime, "������½", 015044, 241, 155)
                mapeffect(2000 + math.random(1000), newMapId3, 147, 155, 17009, remainingTime, 0, actor)
                addmapgate(newMapId3, newMapId3, 147, 155, 2, newMapId4, 45, 107, remainingTime)
                genmon(newMapId4, 59, 92, "��硤������˹[���˼�BOSS]", 1, 1, 251)
            end
            --�Ĳ㴥��
        elseif FCheckMap(actor, newMapId4) then
            if monName == "��硤������˹[���˼�BOSS]" then
                local remainingTime = tonumber(mirrormaptime(newMapId, 0)) or 0
                senddelaymsg(actor, "���Ѿ���������ս��[����],%s���˳���ͼ!", remainingTime or 0, 250, 1)
            end
        end
    end
end
GameEvent.add(EventCfg.onKillMon, _onKillMon, YiJieDiXiaCheng)

Message.RegisterNetMsg(ssrNetMsgCfg.YiJieDiXiaCheng, YiJieDiXiaCheng)
return YiJieDiXiaCheng

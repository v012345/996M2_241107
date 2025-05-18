local HaFaXiSiZhiMu = {}
local mirrorMapId1 = "������˹֮Ĺ(һ��)"
local mirrorMapId2 = "������˹֮Ĺ(����)"
local monName1 = "��ħ�������Ŷ���"
local knights = {
    { "[����ʿ]������", 42, 88 },
    { "[����ʿ]����˹", 84, 43 },
    { "[����ʿ]���¶�", 73, 78 },
    { "[����ʿ]������", 90, 100 },
}
--������˹֮Ĺ������
function ha_fa_xi_si_expire(actor)
    mapmove(actor, "���ƽԭ", 121, 129)
    sendcentermsg(actor, 250, 0, "[ϵͳ��ʾ]��������˹�����ѽ�����", 0, 5)
    sendcentermsg(actor, 250, 0, "[ϵͳ��ʾ]��������˹�����ѽ�����", 0, 5)
    sendcentermsg(actor, 250, 0, "[ϵͳ��ʾ]��������˹�����ѽ�����", 0, 5)
end

--���������ͼ��mapid=����+��ͼ���������ص�ͼID
---* actor����Ҷ���
---* mapId��ԭ��ͼID
---* mapName����ͼ����
---* mapTime�������ͼʱ��
---* miniMpa��С��ͼ���
--- @param actor string
--- @param mapId string
--- @param mapName string
--- @param mapTime integer
--- @param miniMpa integer
--- @return string
local function CreateMapGenmon(actor, mapId, mapName, mapTime, miniMpa)
    local myName = getbaseinfo(actor, ConstCfg.gbase.name)
    local oldMapId = getbaseinfo(actor, ConstCfg.gbase.mapid)
    local x = getbaseinfo(actor, ConstCfg.gbase.x)
    local y = getbaseinfo(actor, ConstCfg.gbase.y)
    local newMapId = myName .. mapName
    if checkmirrormap(newMapId) then
        delmirrormap(newMapId)
    end
    addmirrormap(mapId, newMapId, mapName, mapTime, oldMapId, miniMpa, x, y)
    return newMapId
end
function HaFaXiSiZhiMu.Request(actor)
    local num = getplaydef(actor, VarCfg["J_������˹֮Ĺ��ս����"])
    if num > 0 then
        Player.sendmsgEx(actor, "[��ʾ]:#251|���������ս��������˹֮Ĺ,����������!#249")
        return
    end
    local newMapId = CreateMapGenmon(actor, "newhafaxisi", mirrorMapId1, 1800, 015031)
    genmon(newMapId, 24, 32, monName1, 1, 1, 249)
    mapmove(actor, newMapId, 70, 74, 0)
    setplaydef(actor, VarCfg["N$������˹֮Ĺ����"], 1)
    sendcentermsg(actor, 249, 0, "������˹֮Ĺʣ��ʱ��: %d��", 0, 1800, "@ha_fa_xi_si_expire")
    setplaydef(actor, VarCfg["J_������˹֮Ĺ��ս����"], 1)
    setontimer(actor,174,1) --��������
    setflagstatus(actor,VarCfg["F_������˹֮Ĺ_����"],1)
end

--ɱ�ִ���
local function _onKillMon(actor, monobj, monName)
    local mapId = getbaseinfo(actor, ConstCfg.gbase.mapid)
    local myName = getbaseinfo(actor, ConstCfg.gbase.name)
    local checkMapId = myName .. mirrorMapId1
    if checkMapId == mapId then
        if monName == monName1 then
            setontimer(actor, 172, 2)
            local newMapId = myName .. mirrorMapId2
            if checkmirrormap(newMapId) then
                delmirrormap(newMapId)
            end
            addmirrormap("newhafaxisi2", newMapId, mirrorMapId2, 1800, "���ƽԭ", 015032, 121, 129)
            mapeffect(1000, mapId, 14, 21, 17009, 1800, 1, actor)
            addmapgate(myName .. "������˹֮Ĺ2", mapId, 14, 21, 2, newMapId, 112, 121, 1800)
            setplaydef(actor, VarCfg["M_������˹֮Ĺ"], 0)
            --������һ��Ĺ���,��NPC
            --ˢ��
            for _, value in ipairs(knights) do
                genmon(newMapId, value[2], value[3], value[1], 1, 1, 249)
            end
            --����npc
            local accountID = tonumber(getconst(actor,"<$USERACCOUNT>")) or 0
            local npcInfo = {
                ["Idx"] = accountID + math.random(1000,9999), -- �Զ���NPC��Idx��NPC�������ʱ�����������ᴫ��Idxֵ
                ["npcname"] = "������˹��̳", -- NPC����
                ["appr"] = 1379, -- NPC����Ч��
                ["script"] = '������˹��̳', -- NPC��ؽű����ƣ���ʾEnvir\Market_def\NewNPC.txt
                ["limit"] = 1800, -- �������� (��) ����64_24.05.23����
            }
            createnpc(newMapId, 45, 45, tbl2json(npcInfo))
        end
    end
    local checkMapId2 = myName .. mirrorMapId2
    if checkMapId2 == mapId then
        local isKill = true
        for _, value in ipairs(knights) do
            local idx = tonumber(getdbmonfieldvalue(value[1], "idx"))
            local num = getmoncount(mapId, idx, true)
            if num > 0 then
                isKill = false
                break
            end
        end
        if isKill then
            if string.find(monName, "��ʿ") then
                setontimer(actor, 173, 2)
            end
        end
        if monName == "������˹֮��" then
            local x = getbaseinfo(actor, ConstCfg.gbase.x)
            local y = getbaseinfo(actor, ConstCfg.gbase.y)
            genmon(mapId, x, y, "����������˹���־�֮��", 1, 1, 249)
            scenevibration(actor, 0, 3, 1)
            sendcentermsg(actor, 250, 0, "[ϵͳ��ʾ]���㵱ǰ�Ѿ���������������˹���־�֮����", 0, 5)
            sendcentermsg(actor, 250, 0, "[ϵͳ��ʾ]���㵱ǰ�Ѿ���������������˹���־�֮����", 0, 5)
            sendcentermsg(actor, 250, 0, "[ϵͳ��ʾ]���㵱ǰ�Ѿ���������������˹���־�֮����", 0, 5)
        elseif monName == "����������˹���־�֮��" then
            setflagstatus(actor,VarCfg["F_������˹֮Ĺ���һ��"],1)
            sendcentermsg(actor, 250, 0, "[ϵͳ��ʾ]��������˹�����˹֮Ĺ������", 0, 5)
            sendcentermsg(actor, 250, 0, "[ϵͳ��ʾ]��������˹�����˹֮Ĺ������", 0, 5)
            sendcentermsg(actor, 250, 0, "[ϵͳ��ʾ]��������˹�����˹֮Ĺ������", 0, 5)
        end
    end
end
GameEvent.add(EventCfg.onKillMon, _onKillMon, HaFaXiSiZhiMu)
--��ʱ������
local function _HaFaXiSiZhiMuOnTimer(actor)
    local mapId = getbaseinfo(actor, ConstCfg.gbase.mapid)
    local myName = getbaseinfo(actor, ConstCfg.gbase.name)
    if mapId ~= myName .. mirrorMapId1 then
        setofftimer(actor, 172)
        return
    end
    sendcentermsg(actor, 250, 0, "[ϵͳ��ʾ]����һ��ؿ����ӵ��Ѿ��򿪣���ǰ�����꣺11.18���ź����ڶ���", 0, 1)
end
--��ʾ��ʱ������
GameEvent.add(EventCfg.HaFaXiSiZhiMuOnTimer, _HaFaXiSiZhiMuOnTimer, HaFaXiSiZhiMu)

--��ʱ������
local function _HaFaXiSiJiTanOnTimer(actor)
    local mapId = getbaseinfo(actor, ConstCfg.gbase.mapid)
    local myName = getbaseinfo(actor, ConstCfg.gbase.name)
    if mapId ~= myName .. mirrorMapId2 then
        setofftimer(actor, 173)
        return
    end
    sendcentermsg(actor, 250, 0, "[ϵͳ��ʾ]�����ѻ�ɱ����ʿ,��ǰ������:(45,45)�ٻ�[������˹֮��]", 0, 1)
end
--��ʾ��ʱ������
GameEvent.add(EventCfg.HaFaXiSiJiTanOnTimer, _HaFaXiSiJiTanOnTimer, HaFaXiSiZhiMu)

--�л���ͼ
local function _goSwitchMap(actor, cur_mapid, former_mapid)
    if getplaydef(actor, VarCfg["N$������˹֮Ĺ����"]) == 1 then
        if not string.find(cur_mapid,"������˹֮Ĺ") then
            cleardelaygoto(actor,1)
            setplaydef(actor, VarCfg["N$������˹֮Ĺ����"],0)
        end
    end
end
GameEvent.add(EventCfg.goSwitchMap, _goSwitchMap, HaFaXiSiZhiMu)

Message.RegisterNetMsg(ssrNetMsgCfg.HaFaXiSiZhiMu, HaFaXiSiZhiMu)
return HaFaXiSiZhiMu

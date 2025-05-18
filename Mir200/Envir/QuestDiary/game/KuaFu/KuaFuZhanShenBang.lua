local KuaFuZhanShenBang = {}
KuaFuZhanShenBang.ID = "���ս���"
local npcID = 130
--local config = include("QuestDiary/cfgcsv/cfg_KuaFuZhanShenBang.lua") --����
local cost = { {} }
local give = { {} }
local var = "���ս�������"
local var1 = VarCfg["A_�������а�"]
local titles = {
    "ս��֮��",
    "������",
    "�����ƾ�",
}

local flags = {
    VarCfg["F_ս��֮��_����Ч��"],
    VarCfg["F_������_����Ч��"],
    VarCfg["F_�����ƾ�_����Ч��"],
}

--��֤���Ƿ��ڰ���
local function _getPositionByKey(key, data)
    for index, item in ipairs(data) do
        local itemKey = next(item)
        if itemKey == key then
            return index
        end
    end
    -- ���δ�ҵ�������nil
    return nil
end

local function _getRankingPosition(number, dataList)
    -- ��� dataList �� nil����ʼ��Ϊ�ձ�
    if not dataList then
        dataList = {}
    end
    -- ����������������������а�ֻ����ǰ����
    local maxRank = 3
    -- ��� dataList Ϊ�գ�ֱ�ӷ��ص�һ��
    if #dataList == 0 then
        return 1
    end
    -- ��ʼ�� position Ϊ���а񳤶ȼ�һ������δ�ܽ������а�
    local position = #dataList + 1
    -- �������а��ҵ���ֵӦ�����λ��
    for index, item in ipairs(dataList) do
        local key, value = next(item)
        if value and value[1] then
            local listNumber = value[1]
            if number > listNumber then
                -- �ҵ�Ӧ�����λ��
                position = index
                break
            end
        end
        -- ���������Ч��������һ��ѭ��
    end
    -- ������а�����������ֵδ�ܽ���ǰ���������� nil
    if position > maxRank then
        return nil
    end
    return position
end

local function _onKuaFuZhanShenBangToKuaFu(actor, arg1)
    local strs = string.split(arg1, "|")
    local rankings = Player.GetGlobalTempTable2(var)
    local power = math.floor(Player.GetPower(actor))
    if not _getRankingPosition(power, rankings) then
        Player.sendmsgEx(actor, "���ս������,�޷��ϰ���������а�!#249")
        return
    end

    local id = Player.GetUUID(actor)
    local name = Player.GetName(actor)
    local myRankData = {}
    myRankData[id] = { power, name, tonumber(strs[1]), tonumber(strs[2]) }
    --����ǰ�ж����Ƿ��ڰ��ϣ�����ڰ���ֱ�Ӹ������ݣ��������������
    local myRank = _getPositionByKey(id, rankings)
    if myRank then
        rankings[myRank] = myRankData
    else
        table.insert(rankings, myRankData)
    end
    --�������������
    table.sort(rankings, function(a, b)
        -- ��ȡ��һ����ֵ��
        local keyA, valueA = next(a)
        local keyB, valueB = next(b)
        -- �Ƚ���ֵ��С
        return valueA[1] > valueB[1]
    end)
    -- ������鳤�ȣ��������������ֻ����ǰ����
    if #rankings > 3 then
        -- �ض����飬ֻ����ǰ����Ԫ��
        for i = #rankings, 4, -1 do
            table.remove(rankings, i)
        end
    end
    --������ϵ����ݣ���¼һ�����ϴε�����
    myRank = _getPositionByKey(id, rankings)
    local lastRank = getplaydef(actor, VarCfg["U_��¼�ϴ�ȫ������"])
    if myRank then
        setplaydef(actor, VarCfg["U_��¼�ϴ�ȫ������"], myRank)
    else
        setplaydef(actor, VarCfg["U_��¼�ϴ�ȫ������"], 0)
    end
    --��������
    Player.SetGlobalTempTable2(var, rankings)
    KuaFuZhanShenBang.SyncResponse(actor)
    --������ϴ�һ�����򲻷������ݵ�����
    if lastRank == myRank then
        Player.sendmsgEx(actor, "�������û�з����仯#249")
    else
        local keys = {}
        for _, item in ipairs(rankings) do
            local key = next(item)
            table.insert(keys, key)
        end
        --����֪ͨ������������
        FG_KuaFuToBenFuEvent(EventCfg.onKuaFuZhanShenBangToBenFu, table.concat(keys, "|"))
        local title = titles[myRank]
        if title then
            messagebox(actor, "��ϲ���ϰ�ɹ�,��õ�" .. myRank .. "��,��óƺ�[" .. title .. "]")
        end
        local msgStr = "��ϲ���[" .. name .. "]�ٵǿ��ս����" .. myRank .. "������þ�������������"
        sendmsg("0", 2, '{"Msg":"' .. msgStr .. '","FColor":249,"BColor":0,"Type":5,"Time":3,"Y":"100"}')
    end
end
GameEvent.add("onKuaFuZhanShenBangToKuaFu", _onKuaFuZhanShenBangToKuaFu, KuaFuZhanShenBang)
--�������󵽿��ִ��
function KuaFuZhanShenBang.Request(actor, arg1, arg2)
    if not checkkuafu(actor) then
        return
    end
    FBenFuToKuaFuEvent(actor, EventCfg.onKuaFuZhanShenBangToKuaFu, arg1 .. "|" .. arg2)
end

--������ȡ�ҵ�����
local function _getBenFuMyRank(actor, uuidList)
    local uuid = Player.GetUUID(actor)
    for index, value in ipairs(uuidList or {}) do
        if value == uuid then
            return index
        end
    end
    return nil
end

--ѭ��ɾ���ƺ� �� ��ʶ
local function _delAllTitle(actor)
    for _, value in ipairs(titles) do
        if checktitle(actor, value) then
            deprivetitle(actor, value)
            Player.setAttList(actor, "���Ը���")
        end
    end

    for _, value in ipairs(flags) do
        setflagstatus(actor, value, 0)
    end
end

--ˢ�¸������а�
local function _refreshPlayerRanking(actor, uuidList)
    local lastRank = getplaydef(actor, VarCfg["U_��¼�ϴ�ȫ������"])
    if lastRank > 0 then
        _delAllTitle(actor)
    end
    local playerRank = _getBenFuMyRank(actor, uuidList)
    if playerRank then
        local title = titles[playerRank]
        local flag = flags[playerRank]
        if title then
            confertitle(actor, title)
            setflagstatus(actor, flag, 1) --�����
            Player.setAttList(actor, "���Ը���")
        end
    else
        setplaydef(actor, VarCfg["U_��¼�ϴ�ȫ������"], 0)
    end
end

--ˢ�������˵����а�
local function _refreshAllRanking()
    local uuids = getsysvar(var1) or ""
    local uuidList = string.split(uuids, "|") or {}
    local list = getplayerlst(1)
    for _, actor in ipairs(list or {}) do
        if getplaydef(actor, "N$ս����½���") == 1 then
            _refreshPlayerRanking(actor, uuidList)
        end
    end
end

--֪ͨ��������������������
local function _onKuaFuZhanShenBangToBenFu(arg1)
    setsysvar(var1, arg1)
    _refreshAllRanking()
end
GameEvent.add(EventCfg.onKuaFuZhanShenBangToBenFu, _onKuaFuZhanShenBangToBenFu, KuaFuZhanShenBang)

--���������ִ��
local function _onKuaFuZhanShenBangSyncResponse(actor)
    KuaFuZhanShenBang.SyncResponse(actor)
end
GameEvent.add(EventCfg.onKuaFuZhanShenBangSyncResponse, _onKuaFuZhanShenBangSyncResponse, KuaFuZhanShenBang)
function KuaFuZhanShenBang.RequestSync(actor)
    FBenFuToKuaFuEvent(actor, EventCfg.onKuaFuZhanShenBangSyncResponse, "")
end

-- ͬ����Ϣ
function KuaFuZhanShenBang.SyncResponse(actor, logindatas)
    local data = Player.GetGlobalTempTable2(var)
    Message.sendmsg(actor, ssrNetMsgCfg.KuaFuZhanShenBang_SyncResponse, 0, 0, 0, data)
end

local function _loginRefreshRanking(actor)
    local uuids = getsysvar(var1) or ""
    if uuids ~= "" then
        local uuidList = string.split(uuids, "|") or {}
        _refreshPlayerRanking(actor, uuidList)
    else
        setplaydef(actor, VarCfg["U_��¼�ϴ�ȫ������"], 0)
    end
end

--��½��ʱ��������
function kua_fu_zhan_bang_login(actor)
    _loginRefreshRanking(actor)
    setplaydef(actor, "N$ս����½���", 1)
end

-- --�����¼����
local function _onLoginEnd(actor, logindatas)
    delaygoto(actor, 10000, "kua_fu_zhan_bang_login")
end
--�¼��ɷ�
GameEvent.add(EventCfg.onLoginEnd, _onLoginEnd, KuaFuZhanShenBang)

-- VarCfg["F_ս��֮��_����Ч��"]
-- VarCfg["F_������_����Ч��"]
-- VarCfg["F_�����ƾ�_����Ч��"]
-- ս��֮�� ����ս���͵�
local attackAddtions = {
    0.2,0.1,0.05
}
local function _onAttackDamagePlayer(actor, Target, Hiter, MagicId, Damage, Model, attackDamageData)
    local attackIndex = 0
    if getflagstatus(actor,VarCfg["F_ս��֮��_����Ч��"]) == 1 then
        attackIndex = 1
    elseif getflagstatus(actor,VarCfg["F_������_����Ч��"]) == 1 then
        attackIndex = 2
    elseif getflagstatus(actor,VarCfg["F_�����ƾ�_����Ч��"]) == 1 then
        attackIndex = 3
    end
    local attackAddtion = attackAddtions[attackIndex]
    if attackAddtion then
        local myPower = getplaydef(actor, VarCfg["U_ս����"])
        local TargetPower = getplaydef(Target, VarCfg["U_ս����"])
        --�ҵ�ս������Ŀ��ս������
        if myPower > TargetPower then
            attackDamageData.damage = attackDamageData.damage + math.ceil(Damage * attackAddtion)
        end
    end
end

GameEvent.add(EventCfg.onAttackDamagePlayer, _onAttackDamagePlayer, KuaFuZhanShenBang)
--ע��������Ϣ
Message.RegisterNetMsg(ssrNetMsgCfg.KuaFuZhanShenBang, KuaFuZhanShenBang)
return KuaFuZhanShenBang

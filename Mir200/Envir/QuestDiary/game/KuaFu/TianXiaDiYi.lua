local TianXiaDiYi = {}
TianXiaDiYi.ID = "���µ�һ"
local npcID = 131
local config = include("QuestDiary/cfgcsv/cfg_TianXiaDiYi.lua") --����
local cost = { {} }
local give = { {} }
local currMapId = "���µ�һ"
local killCd = 30 --��ɱ��� 30s
local campaignName = "���µ�һ"
local dataVar = campaignName .. "�����"
local campaignData
--��ȡ��Ϸ����
local function _getData()
    if not campaignData then
        campaignData = Player.GetGlobalTempTable2(dataVar)
    end
    return campaignData
end
--������Ϸ����
local function _setData(data)
    Player.SetGlobalTempTable2(dataVar, data)
    campaignData = data
end
--�����ݽ�������
local function _getMyRank(actor, data)
    local result = {}
    local dataArray = {}
    for name, info in pairs(data) do
        table.insert(dataArray, { name = name, score = info.Score })
    end
    table.sort(dataArray, function(a, b)
        return a.score > b.score
    end)

    local myRank, myPoint
    local userName = Player.GetName(actor)
    for i, v in ipairs(dataArray) do
        if v.name == userName then
            myRank = i
            myPoint = v.score
        end
    end
    result = {
        rankSort = dataArray,
        myRank = myRank,
        myPoint = myPoint
    }
    return result
end

--�������
local function _onKFTianXiaDiYiEnter(actor)
    local mapKey = Player.MapKey(actor)
    if currMapId == mapKey then
        Player.sendmsgEx(actor, "���ڻ��ͼ!#249")
        return
    end

    --�жϻ�Ƿ��ڽ�����
    if getsysvar(VarCfg["G_���µ�һ"]) == 0 then
        --��ǰû�п����
        Player.sendmsgEx(actor, "��ǰû�п����!#249")
        return
    end
    map(actor, currMapId)
end
GameEvent.add(EventCfg.onKFTianXiaDiYiEnter, _onKFTianXiaDiYiEnter, TianXiaDiYi)

local function CheckIsLinQu(actor)
    if getflagstatus(actor, VarCfg["F_���µ�һ�Ƿ���ȡ"]) == 1 then
        Player.sendmsgEx(actor, "���Ѿ���ȡ��������#249")
        return false
    end
    local isTime = isTimeInRange(19, 31, 19, 41)
    if not isTime then
        Player.sendmsgEx(actor, string.format("����|19:31-19:41#249|��ȡ����!"))
        return false
    end
    local weekDayNumber = tonumber(os.date("%w"))
    if weekDayNumber ~= 1 and weekDayNumber ~= 3 and weekDayNumber ~= 5 then
        Player.sendmsgEx(actor, string.format("���ڻ��|(��һ������������)#249|��ȡ����!"))
        return false
    end
    return true
end
--@����ִ��
local function _onKFTianXiaDiYiLingQuBenFu(actor, arg1)
    if not CheckIsLinQu(actor) then
        return
    end
    local strs = string.split(arg1, "#")
    local myRank = tonumber(strs[1]) or 0
    local myPoint = tonumber(strs[2]) or 0
    local cfg = config[myRank]
    local rankStr = ""
    local otherReward = config[11].reward
    local reward = {}
    if cfg then
        reward = cfg.reward
    else
        reward = config[11].reward
    end
    
    if myRank <= 10 then
        rankStr = "��" .. myRank .. "��"
    else
        rankStr = "���뽱"
    end
    if myPoint < 1 then
        reward = otherReward
        rankStr = "���뽱"
    end

    local mailTitle = "���µ�һ����"
    local mailContent = "��ϲ�������µ�һ��У����" .. rankStr .. "������ȡ���Ľ�����"
    local uid = Player.GetUUID(actor)
    Player.giveMailByTable(uid, 1, mailTitle, mailContent, reward, 1, true)
    if myRank == 1 then
        if checktitle(actor,"���µ�һ") then
            deprivetitle(actor,"���µ�һ")
        end
        confertitle(actor, "���µ�һ", 1)
        Player.setAttList(actor, "���Ը���")
        Player.setAttList(actor, "���ٸ���")
        messagebox(actor, "���ڻ�л�õ�һ������ϲ����[���µ�һ]�ƺţ���Ч��48Сʱ��")
    end
    Player.sendmsgEx(actor, "��ϲ����ȡ�����ɹ����뵽�ʼ����գ�")
    setflagstatus(actor, VarCfg["F_���µ�һ�Ƿ���ȡ"], 1)
end
GameEvent.add(EventCfg.onKFTianXiaDiYiLingQuBenFu, _onKFTianXiaDiYiLingQuBenFu, TianXiaDiYi)
--�����ȡ������Ȼ�󵽱������ͽ�����
--@���ִ��
local function _onKFTianXiaDiYiLingQu(actor)
    local data = _getData()
    local rankData = _getMyRank(actor, data)
    if not rankData.myRank then
        Player.sendmsgEx(actor, "û�л�ȡ������ݣ���ȡʧ�ܣ�#249")
        return
    end
    if not rankData.myPoint then
        Player.sendmsgEx(actor, "û�л�ȡ������ݣ���ȡʧ�ܣ�#249")
        return
    end
    local myRank = rankData.myRank or 0
    local myPoint = rankData.myPoint  or 0
    FKuaFuToBenFuEvent(actor, EventCfg.onKFTianXiaDiYiLingQuBenFu, myRank .. "#" .. myPoint)
end
GameEvent.add(EventCfg.onKFTianXiaDiYiLingQu, _onKFTianXiaDiYiLingQu, TianXiaDiYi)
--��ȡʱ�ڱ���ִ��
function TianXiaDiYi.LingQu(actor)
    if not CheckIsLinQu(actor) then
        return
    end
    FBenFuToKuaFuEvent(actor, EventCfg.onKFTianXiaDiYiLingQu, "")
end

--��������
function TianXiaDiYi.Request(actor)
    if not checkkuafu(actor) then
        FMapMoveKF(actor, "kuafu2", 131, 159, 1)
        opennpcshowex(actor, 131, 0, 5)
    else
        FBenFuToKuaFuEvent(actor, EventCfg.onKFTianXiaDiYiEnter, "")
    end
end

--���ʼ
local function _onKFTianXiaDiYiStart()
    if not checkkuafuserver() then
        FsendHuoDongGongGao("������µ�һ��ѿ���������")
    end
    campaignData = nil
    Player.SetGlobalTempTable2(dataVar, {})
end
GameEvent.add(EventCfg.onKFTianXiaDiYiStart, _onKFTianXiaDiYiStart, TianXiaDiYi)
--�����
local function _onKFTianXiaDiYiEnd()
    FMoveMapPlay(currMapId, "kuafu2", 132, 165, 5)
    if not checkkuafuserver() then
        FsendHuoDongGongGao("������µ�һ��ѽ���!")
    end
end
GameEvent.add(EventCfg.onKFTianXiaDiYiEnd, _onKFTianXiaDiYiEnd, TianXiaDiYi)
--ÿ����ͬ��һ������
local function _onKFTianXiaDiYiSync()
    local tMapPlayerList = Player.GetMapPlayerList(currMapId)
    for _, actor in ipairs(tMapPlayerList) do
        local data = _getData()
        local rankData = _getMyRank(actor, data)
        Message.sendmsg(actor, ssrNetMsgCfg.TianXiaDiYi_SyncRank, 0, 0, 0, rankData)
    end
end
GameEvent.add(EventCfg.onKFTianXiaDiYiSync, _onKFTianXiaDiYiSync, TianXiaDiYi)

--�����ִ��
local function _onKFTianXiaDiYiPanelSync(actor)
    local data = _getData()
    local rankData = _getMyRank(actor, data)
    Message.sendmsg(actor, ssrNetMsgCfg.TianXiaDiYi_PanelSync, 0, 0, 0, rankData)
end
GameEvent.add(EventCfg.onKFTianXiaDiYiPanelSync, _onKFTianXiaDiYiPanelSync, TianXiaDiYi)
function TianXiaDiYi.PanelSync(actor)
    FBenFuToKuaFuEvent(actor, EventCfg.onKFTianXiaDiYiPanelSync, "")
end

--ע��������Ϣ
local function _onkillplay(killer, target)
    if not checkkuafu(killer) then
        return
    end
    if Player.MapKey(killer) ~= currMapId then
        return
    end
    if not Player.IsPlayer(killer) then
        --����һ�ɱ
        return
    end

    local nowTime = os.time()
    local data = _getData()
    local killer_name = Player.GetName(killer)
    local role_name = Player.GetName(target)

    data[killer_name] = data[killer_name] or {}              --��ʼ����ɱ������
    data[role_name] = data[role_name] or {}                  --��ʼ����ɱ������

    data[killer_name].Score = data[killer_name].Score or 0   --��ʼ������
    data[role_name].Score = data[role_name].Score or 0       --��ʼ������
    data[role_name].KillTime = data[role_name].KillTime or 0 --��ʼ����ɱʱ��

    local addScore = 0
    local subScore = 0
    --�����ɱ�߻��ִ���1
    local role_name_score = data[role_name].Score --��ɱ�߻���
    --��ұ�ɱ30�ڲ����һ��ķ�
    local timeDifference = nowTime - data[role_name].KillTime
    if timeDifference >= killCd then
        if role_name_score > 1 then
            subScore = math.floor(role_name_score / 2)
        end
    else
        Player.sendmsgEx(killer, "���ɱ����ң�30���ڱ���ɱ�����޷���ø���ҵĻ��֡�")
    end
    --��ɱ�����߱�ɱ�ߵ�һ�����+1��
    addScore = subScore + 1
    data[killer_name].Score = data[killer_name].Score + addScore
    --��ɱ�ߵĻ���-��ɱ�ߵ�һ�����
    data[role_name].Score = math.max(0, data[role_name].Score - subScore)
    --���±�ɱ�ߵ�����ʱ��
    data[role_name].KillTime = nowTime
    Player.sendmsgEx(killer, string.format("���ɱ����ң����|%d#249|���֣���ǰ����|%d#249", addScore, data[killer_name].Score))
    if subScore > 0 then
        Player.sendmsgEx(target, string.format("�㱻��һ�ɱ�ˣ�ʧȥ��|%d#249|����", subScore))
    end
    --��������
    _setData(data)
end
GameEvent.add(EventCfg.onkillplay, _onkillplay, TianXiaDiYi)

--�ڶ����¼��������
local function _roBeforedawn()
    campaignData = nil
    Player.SetGlobalTempTable2(dataVar, {})
end
GameEvent.add(EventCfg.roBeforedawn, _roBeforedawn, TianXiaDiYi)

Message.RegisterNetMsg(ssrNetMsgCfg.TianXiaDiYi, TianXiaDiYi)
return TianXiaDiYi

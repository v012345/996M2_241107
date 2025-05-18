local TianXuanZhiRen = {}
TianXuanZhiRen.ID = "��ѡ֮��"
local config = include("QuestDiary/cfgcsv/cfg_TianXuanZhiRen.lua")
local top1Reward = {
    { "����ָ", 1 },
    { "����ս��[ʱװ]", 1 },
    { "�߼�����ä��", 1 },
    { "����ר��ä��", 1 },
    { "�Լ�������", 1 },
}

--��ȡ��һ�ֵ�ʣ��ʱ��
function TianXuanZhiRen.nextRoundTime()
    local startTime = getsysvar(VarCfg["G_��ѡ֮�˿�ʼʱ���"])
    local min = getsysvar(VarCfg["G_�������Ӽ�ʱ��"])
    if startTime > 0 and min < 120 then
        local round = TianXuanZhiRen.currentRound()
        local currTime = os.time()
        local interval
        if round == 1 then
            interval = 1740
        else
            interval = 1800
        end

        local elapsed_time = currTime - startTime
        local remaining_time = interval - elapsed_time
        return remaining_time
    else
        return -1
    end
end

--��ȡ��ǰ����
function TianXuanZhiRen.currentRound()
    local min = getsysvar(VarCfg["G_�������Ӽ�ʱ��"])
    local human_var
    if min < 30 then
        human_var = 1
    elseif min >= 30 and min < 60 then
        human_var = 2
    elseif min >= 60 and min < 90 then
        human_var = 3
    elseif min >= 90 then
        human_var = 4
    end
    return human_var
end

--����򿪽���
function TianXuanZhiRen.RequestOpenUI(actor)
    local min = getsysvar(VarCfg["G_�������Ӽ�ʱ��"])
    if min > 150 then
        Player.sendmsgEx(actor, "��ѽ���!#249")
        return
    end
    local roundNumber = TianXuanZhiRen.currentRound()
    local data = {}
    data["rankingArr"] = {}                                          -- ��������
    data["myNumberList"] = {}                                        --�ҵĺ����б�
    for i = 1, 4 do
        local ranking = sorthumvar("TianXuanZhiRen_" .. i, 0, 1, 10) --��ȡ������ҽ���ʽ
        table.insert(data["rankingArr"], ranking)
        table.insert(data["myNumberList"], getplayvar(actor, "HUMAN", "TianXuanZhiRen_" .. i))
    end
    local myNumber = getplayvar(actor, "HUMAN", "TianXuanZhiRen_" .. roundNumber) --�ҵĵ�ǰ����

    Message.sendmsg(actor, ssrNetMsgCfg.TianXuanZhiRen_ResponseOpenUI, min, myNumber, roundNumber, data)
end

--�������˱���
local function _PlayerVar(actor)
    for i = 1, 4 do
        FIniPlayVar(actor, "TianXuanZhiRen_" .. i, false)
    end
end
GameEvent.add(EventCfg.goPlayerVar, _PlayerVar, TianXuanZhiRen)

--���ͽ���
local function _sendReward(round)
    if round > 4 or not round then
        return
    end

    local actor_list = getplayerlst(0)
    for i, actor in ipairs(actor_list or {}) do
        local roundNumber = round
        local is_ShouChong = getflagstatus(actor, VarCfg["F_�Ƿ��׳�"]) --�Ƿ��׳�
        if is_ShouChong == 1 then
            FSetPlayVar(actor, "TianXuanZhiRen_" .. roundNumber, math.random(9000, 9999)) --���ɺ���
        end
    end

    local chineseNumbers = { "һ", "��", "��", "��", "��", "��", "��", "��", "��", "ʮ" }
    local ranking = sorthumvar("TianXuanZhiRen_" .. round, 0, 1, 10)
    local rankingNew = {}
    --���û������
    if #ranking < 2 then
        return
    end
    for i = 1, #ranking, 2 do
        local pair = { ranking[i], ranking[i + 1] }
        table.insert(rankingNew, pair)
    end
    local gonggaoY = 100
    for index, value in ipairs(rankingNew) do
        local cfg = config[index]
        if cfg then
            local Reward = clone(cfg.reward)
            if index == 1 then
                local random = math.random(#top1Reward)
                table.insert(Reward, top1Reward[random])
            end
            
            local mailTitle = "��ѡ֮�˵�" .. chineseNumbers[round] .. "�ֵ�" .. chineseNumbers[index] .. "������"
            local mailContent = string.format("%s���ã���ϲ������ѡ֮�˵�%s���л�õ�%s��������ȡ���Ľ���", value[1], chineseNumbers[round], chineseNumbers[index])
            local rewardStr = getItemArrToStr(Reward)
            -- release_print(rewardStr)
            local gongGaostr = string.format("��ϲ���[%s]����ѡ֮�˻�л�õ�%s��,��ý���[%s]", value[1], chineseNumbers[index],rewardStr)
            local modified_str = gongGaostr:gsub("1Ԫ", "")
            FsendTianXuanZhiRen(modified_str, gonggaoY)
            gonggaoY = gonggaoY + 40
            Player.giveMailByTable("#" .. value[1], 1, mailTitle, mailContent, Reward, 1, true)
        end
    end
    GameEvent.push(EventCfg.goTXTiming)  --��ѡ֮�˿�ʼ��ʱ
end
--���ͽ���
GameEvent.add(EventCfg.goTXreward, _sendReward, TianXuanZhiRen)

--����֪ͨ
local function _goTXSendTongZhi()
    FsendHuoDongGongGao("���뱾����ѡ֮�˿�����ʣ��5���ӣ����λ���ץ�����ᣡ����")
end
GameEvent.add(EventCfg.goTXSendTongZhi, _goTXSendTongZhi, TianXuanZhiRen)

--��ʱ������������һ�ֵ�ʱ��
local function _goTXTiming()
    setsysvar(VarCfg["G_��ѡ֮�˿�ʼʱ���"], os.time())
    local nextTime = TianXuanZhiRen.nextRoundTime()
    local playerList = getplayerlst(1)
    for _, actor in ipairs(playerList) do
        Message.sendmsg(actor, ssrNetMsgCfg.TianXuanZhiRen_UpdataTime, nextTime, 0, 0, {})
    end
end
GameEvent.add(EventCfg.goTXTiming, _goTXTiming, TianXuanZhiRen)

local function _onLoginEnd(actor, logindatas)
    local nextTime = TianXuanZhiRen.nextRoundTime()
    -- release_print(nextTime)
    Message.sendmsg(actor, ssrNetMsgCfg.TianXuanZhiRen_UpdataTime, nextTime, 0, 0, {})
end

GameEvent.add(EventCfg.onLoginEnd, _onLoginEnd, TianXuanZhiRen)

--ע��������Ϣ
Message.RegisterNetMsg(ssrNetMsgCfg.TianXuanZhiRen, TianXuanZhiRen)


return TianXuanZhiRen

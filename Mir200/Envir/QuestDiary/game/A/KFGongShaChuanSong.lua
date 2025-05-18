local KFGongShaChuanSong = {}
local NpcId = 126
KFGongShaChuanSong.SwinReward = 10000  --�״ι�ɳʤ��������
KFGongShaChuanSong.SloserReward = 3000 --�״ι�ɳʧ�ܷ�����
KFGongShaChuanSong.money = "�����#"
KFGongShaChuanSong.minimum = 600       --��С���ֲ��ܻ�ȡ����
KFGongShaChuanSong.killPoint = 50      --ɱ�˻��50����
KFGongShaChuanSong.killedPoint = 10    --��ɱ���10����
KFGongShaChuanSong.guaJiPoint = 3      --�һ�����
KFGongShaChuanSong.guildPoints = Player.getJsonTableByVar(nil, VarCfg["A_�л���ּ�¼���"])
--�����л��ܻ���
function KFGongShaChuanSong.calculateGuildPoints()
    local winnerGuildName = castleinfo(2) --ʤ�����л�
    local winnerPoints = 0
    local loserPoints = 0
    local guildPoints = Player.getJsonTableByVar(nil, VarCfg["A_�л���ּ�¼���"])
    for guildName, players in pairs(guildPoints) do
        local totalPoints = 0
        for _, points in pairs(players) do
            if points >= KFGongShaChuanSong.minimum then
                totalPoints = totalPoints + points
            end
        end

        if guildName == winnerGuildName then
            winnerPoints = totalPoints
        else
            loserPoints = loserPoints + totalPoints
        end
    end
    return winnerGuildName, winnerPoints, loserPoints
end

--����
function KFGongShaChuanSong.RequestCS(actor, arg1)
    if not arg1 then
        return
    end
    if not checkkuafu(actor) then
        return
    end
    FBenFuToKuaFuRunScript(actor, 1, arg1)
end

------------������Ϣ-------------
--ͬ����Ϣ --����ִ�У���Ҫ���ݵ����
function KFGongShaChuanSong.SyncResponse(actor)
    FBenFuToKuaFuRunScript(actor, 2, "")
end

local function _onKFGongShaRewardSync(actor)
    local winReward, loserReward, chengZhuReward     = 0, 0, 0
    winReward                                        = KFGongShaChuanSong.SwinReward
    loserReward                                      = KFGongShaChuanSong.SloserReward
    local myPoints                                   = getplaydef(actor, VarCfg["U_��ɳ���ֿ��"]) --���˹�ɳ����
    local winnerGuildName, winnerPoints, loserPoints = KFGongShaChuanSong.calculateGuildPoints() --ʤ�����лᣬʤ�������֣�ʧ�ܷ�����
    local bossName                                   = castleinfo(3)
    -- local bossNameId                                 = getbaseinfo(getplayerbyname(bossName), ConstCfg.gbase.id)
    local castleidentity                             = castleidentity(actor)
    local data                                       = {
        ["winReward"] = winReward,
        ["loserReward"] = loserReward,
        -- ["chengZhuReward"] = chengZhuReward,
        ["myPoints"] = myPoints,
        ["winnerGuildName"] = winnerGuildName,
        ["winnerPoints"] = winnerPoints,
        ["loserPoints"] = loserPoints,
        ["bossName"] = bossName,
        -- ["bossNameId"] = bossNameId,
        ["castleidentity"] = castleidentity,
    }
    Message.sendmsg(actor, ssrNetMsgCfg.KFGongShaChuanSong_SyncResponse, 0, 0, 0, data)
end
GameEvent.add(EventCfg.onKFGongShaRewardSync, _onKFGongShaRewardSync, KFGongShaChuanSong)

--˫����ȡ���ҽ���  --����ִ�У���Ҫ���ݵ����
function KFGongShaChuanSong.LingQu(actor)
    FBenFuToKuaFuRunScript(actor, 3, "")
end

--��ɳ��ȡ����
local function _onKFGongShaLinQu(actor)
    if getmyguild(actor) == "0" then
        Player.sendmsgEx(actor, string.format("��û�м����л�#249"))
        return
    end

    local isLingQu = getflagstatus(actor,VarCfg["F_�����ɳ�Ƿ���ȡ"])
    if isLingQu == 1 then
        Player.sendmsgEx(actor, string.format("���Ѿ���ȡ��������!#249"))
        return
    end
    local isTime = isTimeInRange(22, 04, 22, 59)
    if not isTime then
        Player.sendmsgEx(actor, string.format("����|22:05-23:00#249|��ȡ����!"))
        return
    end

    local winReward, loserReward = 0, 0 --ʤ�����ܽ�����ʧ�ܷ��ܽ���
    winReward = KFGongShaChuanSong.SwinReward
    loserReward = KFGongShaChuanSong.SloserReward
    local myPoints = getplaydef(actor, VarCfg["U_��ɳ���ֿ��"])
    if myPoints < 600 then
        Player.sendmsgEx(actor, string.format("��Ļ�Ծ��С��600,�޷���ȡ!#249"))
        return
    end

    local winnerGuildName, winnerPoints, loserPoints = KFGongShaChuanSong.calculateGuildPoints()
    local castleidentity                             = castleidentity(actor) --��ȡɳ�Ϳ����
    local MyReward
    local sbk_type
    --ɳ�Ϳ�ʧ�ܷ�
    if castleidentity == 0 then
        if loserPoints == 0 then
            return
        end
        MyReward = (loserReward / loserPoints) * myPoints --�����㷨�������/ʧ�ܷ��ܻ���*�ҵĻ���
        sbk_type = "ɳ�Ϳ�ʧ�ܷ�����"
    else
        if winnerPoints == 0 then
            return
        end
        MyReward = (winReward / winnerPoints) * myPoints --�����㷨�������/ʧ�ܷ��ܻ���*�ҵĻ���
        sbk_type = "ɳ�Ϳ�ʤ��������"
    end
    MyReward = numberRound(MyReward)
    setflagstatus(actor,VarCfg["F_�����ɳ�Ƿ���ȡ"],1)
    FKuaFuToBenFuGongShaReward(actor, sbk_type, KFGongShaChuanSong.money .. MyReward)
    Player.sendmsgEx(actor, "�����ѷ��͵��ʼ�,�뵽�ʼ�����!")
end

GameEvent.add(EventCfg.onKFGongShaLinQu, _onKFGongShaLinQu, KFGongShaChuanSong)


Message.RegisterNetMsg(ssrNetMsgCfg.KFGongShaChuanSong, KFGongShaChuanSong)

-----------��Ϸ�¼�-----------------
-- ��������������ҵĻ��ֵ��л���
-- guildName: �л�����
-- playerName: �������
-- points: ��һ�õĻ���
function KFGongShaChuanSong.addPlayerPoints(guildName, playerName, points)
    -- ����л��Ƿ���ڣ�����������򴴽�
    if not KFGongShaChuanSong.guildPoints[guildName] then
        KFGongShaChuanSong.guildPoints[guildName] = {}
    end

    -- �������Ƿ���ڣ�����������򴴽�
    if not KFGongShaChuanSong.guildPoints[guildName][playerName] then
        KFGongShaChuanSong.guildPoints[guildName][playerName] = 0
    end
    KFGongShaChuanSong.guildPoints[guildName][playerName] = points
    Player.setJsonVarByTable(nil, VarCfg["A_�л���ּ�¼���"], KFGongShaChuanSong.guildPoints)
end

--��ʼ --���ִ��
local function _Castlewaract()
    setsysvar(VarCfg["A_�л���ּ�¼���"], "")
    KFGongShaChuanSong.guildPoints = {} --������ܴ��ڵĻ���
    setsysvar(VarCfg["A_ɳ������ȡ"], "")
    setsysvar(VarCfg["A_ʤ�����л��Ա��ȡ��¼"], "")
    setsysvar(VarCfg["A_���а���ȡ��¼"], "")
    setsysvar(VarCfg["A_��һ��Ѫ�������"], "����")
    local player_list = getplayerlst(1)
    if checkkuafuserver() then
        setontimerex(2, 3)
    end
    for i, actor in ipairs(player_list) do
        --û����ִ��һ��
        setontimer(actor, 2, 3, 0, 1)
    end
end
-- ���� --���ִ��
local function _Castlewarend()
    if checkkuafuserver() then
        setofftimerex(2)
        local player_list = getplayerlst()
        for i, actor in ipairs(player_list) do
            setofftimer(actor, 2)
        end
    end
end
--������ --���ִ��
local function _Castlewaring(actor)
    if not checkkuafu(actor) then
        return
    end
    if castleinfo(5) then
        if FCheckMap(actor, "new0150") or FCheckMap(actor, "kuafu0150") then
            local points = getplaydef(actor, VarCfg["U_��ɳ���ֿ��"])
            setplaydef(actor, VarCfg["U_��ɳ���ֿ��"], points + KFGongShaChuanSong.guaJiPoint)
            local name = getbaseinfo(actor, ConstCfg.gbase.name)
            local guild = getbaseinfo(actor, ConstCfg.gbase.guild)
            KFGongShaChuanSong.addPlayerPoints(guild, name, points + KFGongShaChuanSong.guaJiPoint)
        end
        --ǿ���޳�������ͼ
        -- if not FCheckMap(actor, "new0150") and not FCheckMap(actor, "n3") and not FCheckMap(actor, "��Դ��") then
        --     Player.sendmsgEx(actor,"��ɳ�ڼ䲻������ͼ��֣�")
        --     mapmove(actor, ConstCfg.main_city, 330, 330, 5)
        -- end
    end
end

--��¼���� --���ִ��
local function _onKFLogin(actor)
    --������ڹ��ǿ�����ʱ��
    if castleinfo(5) then
        setontimer(actor, 2, 3, 0, 1)
    end
end
GameEvent.add(EventCfg.onKFLogin, _onKFLogin, KFGongShaChuanSong)
--�����ж�ʱ��
GameEvent.add(EventCfg.gocastlewaring, _Castlewaring, KFGongShaChuanSong)
--ɳ�Ϳ˿�ʼ����
GameEvent.add(EventCfg.gocastlewarstart, _Castlewaract, KFGongShaChuanSong)
--ɳ�Ϳ˽�������
GameEvent.add(EventCfg.goCastlewarend, _Castlewarend, KFGongShaChuanSong)

--ɱ�˴���
local function _Castlewarkill(actor, play)
    if not checkkuafu(actor) then
        return
    end
    --����ɱ�˻���
    if castleinfo(5) then
        if getbaseinfo(actor, ConstCfg.gbase.issbk) then
            --ɱ���߻���
            local points = getplaydef(actor, VarCfg["U_��ɳ���ֿ��"])
            setplaydef(actor, VarCfg["U_��ɳ���ֿ��"], points + KFGongShaChuanSong.killPoint)
            local name = getbaseinfo(actor, ConstCfg.gbase.name)
            local guild = getbaseinfo(actor, ConstCfg.gbase.guild)
            KFGongShaChuanSong.addPlayerPoints(guild, name, points + KFGongShaChuanSong.killPoint)

            --��ɱ�߻���
            local killedPoints = getplaydef(play, VarCfg["U_��ɳ���ֿ��"])
            setplaydef(play, VarCfg["U_��ɳ���ֿ��"], killedPoints + KFGongShaChuanSong.killedPoint)
            local killedName = getbaseinfo(play, ConstCfg.gbase.name)
            local killedGuild = getbaseinfo(play, ConstCfg.gbase.guild)
            KFGongShaChuanSong.addPlayerPoints(killedGuild, killedName, killedPoints + KFGongShaChuanSong.killedPoint)
            --��������ƺŴ���
            if checkkuafu(actor) then
                --��ɳ�ڼ��һ����ɱ�ж��л��Ա
                if getsysvar(VarCfg["A_��һ��Ѫ�������"]) == "����" then
                    if randomex(50, 100) then
                        FKuaFuToBenFuRunScript(actor, 4)
                    end
                    local name = getbaseinfo(actor, ConstCfg.gbase.name)
                    setsysvar(VarCfg["A_��һ��Ѫ�������"], name)
                end
            else
                if not checktitle(actor, "��һ��Ѫ") then
                    if getsysvar(VarCfg["A_��һ��Ѫ�������"]) == "����" then
                        local name = getbaseinfo(actor, ConstCfg.gbase.name)
                        setsysvar(VarCfg["A_��һ��Ѫ�������"], name)
                        if randomex(50, 100) then
                            confertitle(actor, "��һ��Ѫ")
                            GameEvent.push(EventCfg.onAddAchievementTitle, actor, "��һ��Ѫ")
                        end
                    end
                end
            end
        end
    end
    addbuff(actor, 31030)
    local KillNum = getplaydef(actor, VarCfg["N$��ɱ����"])
    KillNum = KillNum + 1
    setplaydef(actor, VarCfg["N$��ɱ����"], KillNum)
    GameEvent.push(EventCfg.onContinuousKillPlayer, actor, KillNum)

    if KillNum <= 10 then
        local effecf = 62100
        playeffect(actor, effecf + KillNum, -50, 80, 1, 0, 1)
    elseif KillNum > 10 then
        playeffect(actor, 62110, -50, 80, 1, 0, 1)
    end
end
GameEvent.add(EventCfg.onkillplay, _Castlewarkill, KFGongShaChuanSong)


--���ͬ������
local function _goKFGongShaSync()
    local playList = getplayerlst()
    for _, actor in ipairs(playList) do
        -- KFGongShaChuanSong_HuiZhang
        Message.sendmsg(actor, ssrNetMsgCfg.KFGongShaChuanSong_SyncPoints, 0, 0, 0, KFGongShaChuanSong.guildPoints)
    end
end
GameEvent.add(EventCfg.goKFGongShaSync, _goKFGongShaSync, KFGongShaChuanSong)
return

local GongShaChuanSong = {}
local NpcId = 109
GongShaChuanSong.SwinReward = 14000      --�״ι�ɳʤ��������
GongShaChuanSong.SloserReward = 6000    --�״ι�ɳʧ�ܷ�����
-- GongShaChuanSong.SchengZhuReward = 2000 --�״γ�������
GongShaChuanSong.winReward = 3500       --����ʤ��������
GongShaChuanSong.loserReward = 1500      --����ʧ�ܷ�����
-- GongShaChuanSong.chengZhuReward = 1000  --������������
GongShaChuanSong.money = "�����#"
GongShaChuanSong.minimum = 600  --��С���ֲ��ܻ�ȡ����
GongShaChuanSong.killPoint = 50 --ɱ�˻��50����
GongShaChuanSong.killedPoint = 10 --��ɱ���10����
GongShaChuanSong.guaJiPoint = 3 --�һ�����
GongShaChuanSong.guildPoints = Player.getJsonTableByVar(nil, VarCfg["A_�л���ּ�¼"])
-- Player.getJsonTableByVar(nil, VarCfg["A_�л���ּ�¼"])
--�����л��ܻ���
function GongShaChuanSong.calculateGuildPoints()
    local winnerGuildName = castleinfo(2) --ʤ�����л�
    local winnerPoints = 0
    local loserPoints = 0
    local guildPoints = Player.getJsonTableByVar(nil, VarCfg["A_�л���ּ�¼"])
    for guildName, players in pairs(guildPoints) do
        local totalPoints = 0
        for _, points in pairs(players) do
            if points >= GongShaChuanSong.minimum then
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
function GongShaChuanSong.RequestCS(actor, arg1)
    if not arg1 then
        return
    end
    -- if not getbaseinfo(actor, ConstCfg.gbase.issaferect) then
    --     Player.sendmsg(actor, "ֻ���ڰ�ȫ�����ͣ�")
    --     return
    -- end

    local isInRange = FCheckNPCRange(actor, NpcId, 15)
    if not isInRange then
        Player.sendmsgEx(actor, "����̫Զ#249")
        return
    end

    if checkkuafuconnect() then
        Player.sendmsgEx(actor, "����ѿ�����������ɳ�ѹرգ�#249")
        return
    end

    local isGongSha = castleinfo(5)
    if not isGongSha then
        Player.sendmsgEx(actor, "�ǹ�ɳʱ��,��ֹ����#249")
        return
    end

    if arg1 == 1 then
        mapmove(actor, "n3", 629, 283)
    elseif arg1 == 2 then
        mapmove(actor, "n3", 637, 313)
    elseif arg1 == 3 then
        mapmove(actor, "n3", 659, 288)
    elseif arg1 == 4 then
        mapmove(actor, "n3", 674, 332)
    end
    local name = getbaseinfo(actor, ConstCfg.gbase.name)
    guildnoticemsg(actor, 251, 249, "��ʿ��" .. name .. "����ʼ��սɳ�ǣ�")
end

------------������Ϣ-------------
--ͬ����Ϣ
function GongShaChuanSong.SyncResponse(actor)
    --�ж��״���ɳ����
    local gongShaConunt = getsysvar(VarCfg["G_��ɳ����"])
    local winReward, loserReward, chengZhuReward = 0, 0, 0
    --������ɳ
    if gongShaConunt > 1 then
        winReward = GongShaChuanSong.winReward
        loserReward = GongShaChuanSong.loserReward
        --�״ι�ɳ
    else
        winReward = GongShaChuanSong.SwinReward
        loserReward = GongShaChuanSong.SloserReward
    end
    local myPoints                                   = getplaydef(actor, VarCfg["J_��ɳ����"]) --���˹�ɳ����
    local winnerGuildName, winnerPoints, loserPoints = GongShaChuanSong.calculateGuildPoints() --ʤ�����лᣬʤ�������֣�ʧ�ܷ�����
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
    Message.sendmsg(actor, ssrNetMsgCfg.GongShaChuanSong_SyncResponse, 0, 0, 0, data)
end

--�᳤��ȡ����
function GongShaChuanSong.HuiZhang(actor)
    if castleidentity(actor) ~= 2 then
        Player.sendmsgEx(actor, "����Ц�ˣ��㲻���ϴ�#249")
        return
    end

    if getsysvar(VarCfg["A_ɳ������ȡ"]) ~= "" then
        Player.sendmsgEx(actor, string.format("������|[%s]#249|��ȡ����", getsysvar(VarCfg["A_ɳ������ȡ"])))
        return
    end

    local isTime = isTimeInRange(22, 04, 23, 00)
    if not isTime then
        Player.sendmsgEx(actor, string.format("����|22:05-23:00#249|��ȡ����!"))
        return
    end

    local name = getbaseinfo(actor, ConstCfg.gbase.name)
    setsysvar(VarCfg["A_ɳ������ȡ"], name)
    confertitle(actor, "ɳ��֮��", 1)
    local timestamp = os.time()
    changetitletime(actor, "ɳ��֮��", "=", timestamp + 129600)
    Player.sendmsgEx(actor, string.format("��ȡ�ɹ�,�ƺ��Ѿ�Ϊ���Զ�����,��Ч��36��Сʱ!"))
    Player.setAttList(actor, "���ʸ���")
end

--ʤ������Ա��ȡ�ƺŽ���
function GongShaChuanSong.ChengYuan(actor)
    if castleidentity(actor) == 2 then
        Player.sendmsgEx(actor, "����ɳ�Ϳ��ϴ�,�޷���ȡ!#249")
        return
    end

    if castleidentity(actor) == 0 then
        Player.sendmsgEx(actor, "�㲻��ʤ�����л��Ա��#249")
        return
    end

    local isTime = isTimeInRange(22, 04, 23, 00)
    if not isTime then
        Player.sendmsgEx(actor, string.format("����|22:05-23:00#249|��ȡ����!"))
        return
    end
    local lingQuList = Player.getJsonTableByVar(nil, VarCfg["A_ʤ�����л��Ա��ȡ��¼"])
    local userId = getbaseinfo(actor, ConstCfg.gbase.id)
    if table.contains(lingQuList, userId) then
        Player.sendmsgEx(actor, string.format("���Ѿ���ȡ����!"))
        return
    end
    table.insert(lingQuList, userId)
    Player.setJsonVarByTable(nil, VarCfg["A_ʤ�����л��Ա��ȡ��¼"], lingQuList)
    confertitle(actor, "ʤ��֮ʦ", 1)
    local timestamp = os.time()
    changetitletime(actor, "ʤ��֮ʦ", "=", timestamp + 129600)
    Player.sendmsgEx(actor, string.format("��ȡ�ɹ�,�ƺ��Ѿ�Ϊ���Զ�����,��Ч��36��Сʱ!"))
    Player.setAttList(actor, "���ʸ���")
end

--˫����ȡ���ҽ���
function GongShaChuanSong.LingQu(actor)
    if getmyguild(actor) == "0" then
        Player.sendmsgEx(actor, string.format("��û�м����л�#249"))
        return
    end

    local isLingQu = getplaydef(actor, VarCfg["J_�Ƿ���ȡɳ����"])
    if isLingQu > 0 then
        Player.sendmsgEx(actor, string.format("���Ѿ���ȡ��������!#249"))
        return
    end

    local isTime = isTimeInRange(22, 05, 23, 00)
    if not isTime then
        Player.sendmsgEx(actor, string.format("����|22:05-23:00#249|��ȡ����!"))
        return
    end

    --��������
    local function round(num)
        local decimal = num % 1 -- ��ȡС������
        if decimal >= 0.5 then
            return math.ceil(num)
        else
            return math.floor(num)
        end
    end
    -- local openday = getsysvar(VarCfg["G_��������"])
    local gongShaConunt = getsysvar(VarCfg["G_��ɳ����"])
    local winReward, loserReward = 0, 0 --ʤ�����ܽ�����ʧ�ܷ��ܽ���
    if gongShaConunt > 1 then
        winReward = GongShaChuanSong.winReward
        loserReward = GongShaChuanSong.loserReward
    else
        winReward = GongShaChuanSong.SwinReward
        loserReward = GongShaChuanSong.SloserReward
    end
    local myPoints = getplaydef(actor, VarCfg["J_��ɳ����"])

    if myPoints < 600 then
        Player.sendmsgEx(actor, string.format("��Ļ�Ծ��С��600,�޷���ȡ!#249"))
        return
    end

    local winnerGuildName, winnerPoints, loserPoints = GongShaChuanSong.calculateGuildPoints()
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
    local userid = getbaseinfo(actor, ConstCfg.gbase.id)
    MyReward = round(MyReward)
    setplaydef(actor,VarCfg["J_�Ƿ���ȡɳ����"] ,1)
    sendmail(userid, 1, sbk_type, "����ȡ����ɳ�Ϳ˽���", GongShaChuanSong.money .. MyReward)
    Player.sendmsgEx(actor,"�����ѷ��͵��ʼ�,�뵽�ʼ�����!")
    if sbk_type == "ɳ�Ϳ�ʤ��������" then
        GameEvent.push(EventCfg.GetCastleRewards, actor)
    end
end

Message.RegisterNetMsg(ssrNetMsgCfg.GongShaChuanSong, GongShaChuanSong)

-----------��Ϸ�¼�-----------------
-- ��������������ҵĻ��ֵ��л���
-- guildName: �л�����
-- playerName: �������
-- points: ��һ�õĻ���
function GongShaChuanSong.addPlayerPoints(guildName, playerName, points)
    -- ����л��Ƿ���ڣ�����������򴴽�
    if not GongShaChuanSong.guildPoints[guildName] then
        GongShaChuanSong.guildPoints[guildName] = {}
    end

    -- �������Ƿ���ڣ�����������򴴽�
    if not GongShaChuanSong.guildPoints[guildName][playerName] then
        GongShaChuanSong.guildPoints[guildName][playerName] = 0
    end
    GongShaChuanSong.guildPoints[guildName][playerName] = points
    Player.setJsonVarByTable(nil, VarCfg["A_�л���ּ�¼"], GongShaChuanSong.guildPoints)
end

--��ʼ
local function _Castlewaract()
    setsysvar(VarCfg["A_�л���ּ�¼"], "")
    GongShaChuanSong.guildPoints = {} --������ܴ��ڵĻ���
    setsysvar(VarCfg["A_ɳ������ȡ"], "")
    setsysvar(VarCfg["A_ʤ�����л��Ա��ȡ��¼"], "")
    setsysvar(VarCfg["A_���а���ȡ��¼"], "")
    setsysvar(VarCfg["A_��һ��Ѫ�������"], "����")
    local player_list = getplayerlst(1)
    for i, actor in ipairs(player_list) do
        if checkkuafu(actor) then --����в�ʹ�����
            return
        end
        --û����ִ��һ��
        setontimer(actor, 2, 3, 0, 1)
    end
end
-- ����
local function _Castlewarend()
    local player_list = getplayerlst()
    for i, actor in ipairs(player_list) do
        if checkkuafu(actor) then  --����в�ʹ�����
            return
        end
        setofftimer(actor, 2)
    end
end
--������
local function _Castlewaring(actor)
    if checkkuafu(actor) then
        return
    end
    if castleinfo(5) then
        if FCheckMap(actor, "new0150") or FCheckMap(actor, "kuafu0150") then
            local points = getplaydef(actor, VarCfg["J_��ɳ����"])
            setplaydef(actor, VarCfg["J_��ɳ����"], points + GongShaChuanSong.guaJiPoint)
            local name = getbaseinfo(actor, ConstCfg.gbase.name)
            local guild = getbaseinfo(actor, ConstCfg.gbase.guild)
            GongShaChuanSong.addPlayerPoints(guild, name, points + GongShaChuanSong.guaJiPoint)
        end
        --ǿ���޳�������ͼ
        -- if not FCheckMap(actor, "new0150") and not FCheckMap(actor, "n3") and not FCheckMap(actor, "��Դ��") then
        --     Player.sendmsgEx(actor,"��ɳ�ڼ䲻������ͼ��֣�")
        --     mapmove(actor, ConstCfg.main_city, 330, 330, 5)
        -- end
    end
end

--��¼����
local function _onLoginEnd(actor)
    --������ڹ��ǿ�����ʱ��
    if checkkuafu(actor) then
        return
    end
    if castleinfo(5) then
        setontimer(actor, 2, 3, 0, 1)
    end
end
GameEvent.add(EventCfg.onLoginEnd, _onLoginEnd, GongShaChuanSong)
GameEvent.add(EventCfg.onKFLogin, _onLoginEnd, GongShaChuanSong)
--�����ж�ʱ��
GameEvent.add(EventCfg.gocastlewaring, _Castlewaring, GongShaChuanSong)
--ɳ�Ϳ˿�ʼ����
GameEvent.add(EventCfg.gocastlewarstart, _Castlewaract, GongShaChuanSong)
--ɳ�Ϳ˽�������
GameEvent.add(EventCfg.goCastlewarend, _Castlewarend, GongShaChuanSong)

--ɱ�˴���
local function _Castlewarkill(actor, play)
    if checkkuafu(actor) then
        return
    end
    --����ɱ�˻���
    if castleinfo(5) then
        if getbaseinfo(actor, ConstCfg.gbase.issbk) then
            --ɱ���߻���
            local points = getplaydef(actor, VarCfg["J_��ɳ����"])
            setplaydef(actor, VarCfg["J_��ɳ����"], points + GongShaChuanSong.killPoint)
            local name = getbaseinfo(actor, ConstCfg.gbase.name)
            local guild = getbaseinfo(actor, ConstCfg.gbase.guild)
            GongShaChuanSong.addPlayerPoints(guild, name, points + GongShaChuanSong.killPoint)

            --��ɱ�߻���
            local killedPoints = getplaydef(play, VarCfg["J_��ɳ����"])
            setplaydef(play, VarCfg["J_��ɳ����"], killedPoints + GongShaChuanSong.killedPoint)
            local killedName = getbaseinfo(play, ConstCfg.gbase.name)
            local killedGuild = getbaseinfo(play, ConstCfg.gbase.guild)
            GongShaChuanSong.addPlayerPoints(killedGuild, killedName, killedPoints + GongShaChuanSong.killedPoint)
            --��������ƺŴ���
            if checkkuafu(actor) then
                --��ɳ�ڼ��һ����ɱ�ж��л��Ա
                if getsysvar(VarCfg["A_��һ��Ѫ�������"]) == "����" then
                    if randomex(50,100) then
                        FKuaFuToBenFuRunScript(actor,4)
                    end
                    local name = getbaseinfo(actor,ConstCfg.gbase.name)
                    setsysvar(VarCfg["A_��һ��Ѫ�������"], name)
                end
            else
                if not checktitle(actor, "��һ��Ѫ") then
                    if getsysvar(VarCfg["A_��һ��Ѫ�������"]) == "����" then
                        local name = getbaseinfo(actor,ConstCfg.gbase.name)
                        setsysvar(VarCfg["A_��һ��Ѫ�������"], name)
                        if randomex(50,100) then
                            confertitle(actor,"��һ��Ѫ")
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
GameEvent.add(EventCfg.onkillplay, _Castlewarkill, GongShaChuanSong)
-- GameEvent.add(EventCfg.gomapeventwalk, _mapeventwalk,CastWar)
return

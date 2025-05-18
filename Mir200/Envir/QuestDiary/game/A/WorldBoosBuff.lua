local WorldBoosBuff = {}
--��������󴥷�
local function _onAttackMonster(actor, Target, Hiter, MagicId, qieGe)
    if checkitemw(actor, "��Ԫ֮�ȡ���˪����", 1) then
        local currHpPer = Player.getHpPercentage(actor)
        if currHpPer <= 3 or currHpPer == 100 then return end
        humanhp(actor, "+", 388)
    end
    if checkitems(actor, "Ѫ������������֮��#1", 0, 0) then
        local Num = getplaydef(actor, VarCfg["N$��֮̾Ϣ_��������"])
        Num = Num + 1
        if Num == 40 then
            local QieGe = getbaseinfo(actor, ConstCfg.gbase.custom_attr, 200)
            humanhp(Target, "-", QieGe * 3, 106, 0, actor) --����նѪ
            Num = 0
        end
        setplaydef(actor, VarCfg["N$��֮̾Ϣ_��������"], Num)
    end
end
GameEvent.add(EventCfg.onAttackMonster, _onAttackMonster, WorldBoosBuff)

--��������󴥷�
local function _onAttackPlayer(actor, Target, Hiter, MagicId)
    --ħ���������쵶�� ����2%�ĸ��ʴ���������2*2��Χ���γ�һ����磬������Ѿ�ÿ��ָ�3%�����������ͬʱ����200����ֵ������10S����ȴ120S
    if randomex(2, 100) then
        if checkitemw(actor, "ħ���������쵶��", 1) then
            local buff = hasbuff(actor, 31055) --������CD
            if not buff then
                local MyGuildName = getbaseinfo(actor, ConstCfg.gbase.guild)
                gotolabel(actor, 3, "daofengjiejiefujinhanghui," .. MyGuildName .. "", 2)
                playeffect(actor, 63050, 0, 0, 1, 0, 0)
                addbuff(actor, 31055, 120)
            end
        end
    end
    --PK ��������100%�����ֵ�˺��� �����ٻ���ʯ��������ѣĿ��
    local buff = hasbuff(actor, 31059)
    if buff then
        local Damage = getbaseinfo(actor, ConstCfg.gbase.mc2)
        humanhp(Target, "-", Damage, 1, 0, actor)
        if randomex(2, 100) then
            playeffect(Target, 15259, 0, 0, 1, 0, 0)
            local x, y = getbaseinfo(Target, ConstCfg.gbase.x), getbaseinfo(Target, ConstCfg.gbase.y)
            rangeharm(actor, x, y, 0, 0, 10, 5000, 0, 0) -- ����1��
        end
    end
end
GameEvent.add(EventCfg.onAttackPlayer, _onAttackPlayer, WorldBoosBuff)

--������ǰ����
local function _onStruckDamagePlayer(actor, Target, Hiter, MagicId, Damage, attackDamageData)
    --�������͡��������� �ܵ�ʥ���Եı���  �����һ�����ս���20%���˺�
    if checkitems(actor, "�������͡���������#1", 0, 0) then
        local bool = MagicId == 26 or MagicId == 56
        if bool then
            attackDamageData.damage = attackDamageData.damage - (Damage * 0.2)
        end
    end
end
GameEvent.add(EventCfg.onStruckDamagePlayer, _onStruckDamagePlayer, WorldBoosBuff)

--�����總���л��Ա���� 2*2 ��Χ
function daofengjiejiefujinhanghui(actor, TgtGuildName)
    local MyGuildName = getbaseinfo(actor, ConstCfg.gbase.guild)
    if MyGuildName == TgtGuildName then
        addbuff(actor, 31058, 10)
    end
end

-- ɱ�����ﴥ��
local function _onkillplay(actor, Target)
    -- Ѫ������������֮��  ��ɱĿ��֮��,͵ȡ�Է�10%�������������10%����󹥻�,����1����.ͬһĿ��ֻ�ܱ�͵ȡһ��,��ȴ1����
    if not checkitemw(actor, "Ѫ������������֮��", 1) then return end
    local killNum = getplaydef(actor, VarCfg["N$Ѫ����������"])
    if killNum == 4 then return end
    killNum = killNum + 1
    setplaydef(actor, VarCfg["N$Ѫ����������"],killNum)
    addbuff(actor, 31056, 0, killNum, actor)
end
GameEvent.add(EventCfg.onkillplay, _onkillplay, WorldBoosBuff)

--ɱ�����ﴥ��
local function _onKillMon(actor, monobj, monName)
    --��ⱳ���Ƿ���
    if checkitems(actor, "����ͳ�졤ľ֮�泲#1", 0, 0) then
        local ncount = getbaseinfo(actor, 38)
        if ncount >= 5 then return end
        recallmob(actor, "����֩��", 7, 30, 1)
    end
end
GameEvent.add(EventCfg.onKillMon, _onKillMon, WorldBoosBuff)

-- ��������ǰ���� actor=��� Target=�������� Hiter=����
local function _onAttackDamageBB(actor, Target, Hiter, MagicId, Damage)
    local BBName = getbaseinfo(Hiter, ConstCfg.gbase.name)
    if BBName == "����֩��" then
        killmonbyobj(actor, Hiter, false, false, true) --ɱ������
        local MaxDC = getbaseinfo(actor, ConstCfg.gbase.dc2)
        local x, y = getbaseinfo(Target, ConstCfg.gbase.x), getbaseinfo(Target, ConstCfg.gbase.y)
        rangeharm(actor, x, y, 1, 0, 6, MaxDC * 0.3, 0, 0)
    end
    if BBName == "�����ʹ�" then
        killmonbyobj(actor, Hiter, false, false, true) --ɱ������
        local x, y = getbaseinfo(Target, ConstCfg.gbase.x), getbaseinfo(Target, ConstCfg.gbase.y)
        rangeharm(actor, x, y, 1, 0, 6, 100, 0, 0)     --�̶�100�����˺�
        makeposion(Target, 0, 1, 1, 0)                 --�����̶�״̬
    end
end
GameEvent.add(EventCfg.onAttackDamageBB, _onAttackDamageBB, WorldBoosBuff)

--��������
local function _onPlaydie(actor, hiter)
    --������������ħ����  ������������������ʱ���ʸ�������һ��ӡ��  ��һ���ض�նɱ����99%Ѫ��
    if checkitemw(actor, "������������ħ����", 1) then
        local buff = hasbuff(actor, 31060)
        if not buff then
            addbuff(actor, 31060)
        end
    end
end
GameEvent.add(EventCfg.onPlaydie, _onPlaydie, WorldBoosBuff)

--�ͷż��ܴ��� ʹ��ȼ�շ���
local function _onRanShaoFaZe(actor)
    local buff = hasbuff(actor, 31059)
    if buff then
        FkfDelBuff(actor, 31059)
    else
        addbuff(actor, 31059)
    end
end
GameEvent.add(EventCfg["ʹ��ȼ�շ���"], _onRanShaoFaZe, WorldBoosBuff)

--�� ����ͳ�졤ľ֮�泲
local function _onTakeOn72(actor, itemobj, itemname)
    if itemname ~= "����ͳ�졤ľ֮�泲" then return end
    local buff = hasbuff(actor, 31054)
    if buff then return end
    addbuff(actor, 31054)
end
GameEvent.add(EventCfg.onTakeOn72, _onTakeOn72, WorldBoosBuff)

--�� ����ͳ�졤ľ֮�泲
local function _onTakeOff72(actor, itemobj, itemname)
    if itemname ~= "����ͳ�졤ľ֮�泲" then return end
    local buff = hasbuff(actor, 31054)
    if buff then
        FkfDelBuff(actor, 31054)
    end
end
GameEvent.add(EventCfg.onTakeOff72, _onTakeOff72, WorldBoosBuff)

--�� �������͡���������
local function _onTakeOn11(actor, itemobj, itemname)
    if itemname ~= "�������͡���������" then return end
    addskill(actor, 2020, 3)
end
GameEvent.add(EventCfg.onTakeOn11, _onTakeOn11, WorldBoosBuff)

--�� �������͡���������
local function _onTakeOff11(actor, itemobj, itemname)
    if itemname ~= "�������͡���������" then return end
    delskill(actor, 2020)
end
GameEvent.add(EventCfg.onTakeOff11, _onTakeOff11, WorldBoosBuff)

--�µ�һ�촥��
local function _onNewDay(actor)
    if checkitems(actor, "ħ���������쵶��#1", 0, 0) then
        local Mum = math.random(1, 10)
        setplaydef(actor, VarCfg["N$J_����֮��_����"], Mum)
        Player.setAttList(actor, "��������")
    end
end
GameEvent.add(EventCfg.onNewDay, _onNewDay, WorldBoosBuff)

--��¼����
local function _onLoginEnd(actor)
    local buff = hasbuff(actor, 31056)
    if buff then
        delbuff(actor, 31056)
    end
end
GameEvent.add(EventCfg.onLoginEnd, _onLoginEnd, WorldBoosBuff)


return WorldBoosBuff

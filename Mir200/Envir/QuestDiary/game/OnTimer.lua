--ȫ�ֶ�ʱ��


function ontimerex1()
    if getsysvar(VarCfg["G_��һ����ҽ���"]) > 2 then
        setsysvar(VarCfg["G_�������Ӽ�ʱ��"], getsysvar(VarCfg["G_�������Ӽ�ʱ��"]) + 1)
    end
    local varG1 = getsysvar(VarCfg["G_�������Ӽ�ʱ��"])
    -- release_print("���Ӷ�ʱ��,varG1", varG1)
    GameEvent.push(EventCfg.gameEventTimer, varG1)
    
    --������ѡ֮�˽���
    -- local func = funOntimerex1[varG1]
    -- if func then
    --     func()
    -- end
end

--�����ɳͬ������
function ontimerex2()
    GameEvent.push(EventCfg.goKFGongShaSync)
end

--նɱ�����춨ʱ��
function ontimerex3()
    GameEvent.push(EventCfg.onKFZhanJiangDuoQiSync)
end

--���µ�һ��ʱ��
function ontimerex4()
    GameEvent.push(EventCfg.onKFTianXiaDiYiSync)
end

--���ǽ�����ʱ����
function ontimerex24()
    GameEvent.push(EventCfg.goCastlewarend)
    setofftimerex(24)
end

------------------------------------���˶�ʱ��begin---------------------------------
function ontimer1(actor)
    local currHpPer = Player.getHpPercentage(actor) or 0
    if currHpPer == 100 then
        return
    end
    --�ز�����ֹ��Ѫ
    local diZangWangDeShiLianFlag = getplaydef(actor, VarCfg["M_�ز�����ʶ"])
    if diZangWangDeShiLianFlag > 0 and diZangWangDeShiLianFlag < 5 then
        return
    end
    --���֮·����Ѫ
    if getplaydef(actor, VarCfg["M_���֮·"]) > 0 then
        return
    end
    --�����³ǲ���Ѫ
    if FCheckMap(actor,"dixiachengerceng") then
        return
    end
    if not hasbuff(actor, 10001) then
        local tzAddHp = getplaydef(actor, VarCfg["N$��ս�ָ�Ѫ��"])
        if tzAddHp > 0 then
            humanhp(actor, "+", math.ceil(Player.getHpValue(actor, tzAddHp)), 4)
        end
    end

    local sAddHp = tonumber(getplaydef(actor, VarCfg["N$ÿ��ָ�Ѫ��"])) or 0
    if sAddHp > 0 then
        humanhp(actor, "+", sAddHp, 4)
    end
    local sAddMp = tonumber(getplaydef(actor, VarCfg["N$ÿ��ָ�����"])) or 0
    if sAddMp > 0 then
        humanmp(actor, "+", sAddMp)
    end
    
    if getflagstatus(actor, VarCfg["F_����������"]) == 1 then
        local hp = Player.getHpPercentage(actor)
        if hp > 60 and getplaydef(actor,"N$������") == 1  then
            delattlist(actor,"������")
            setplaydef(actor,"N$������",0)
        end
    else
        if  getplaydef(actor,"N$������") == 1 then
            delattlist(actor,"������")
            setplaydef(actor,"N$������",0)
        end
    end
end

--��ɳ���˶�ʱ��
function ontimer2(actor)
    GameEvent.push(EventCfg.gocastlewaring, actor)
end

--ʵʱ��ձ�������
function ontimer3(actor)
    if getflagstatus(actor, VarCfg["F_����_����ר����ʶ"]) == 1 then
        -- release_print("��ձ�����")
        local baoJi = getbaseinfo(actor, ConstCfg.gbase.custom_attr, 21)
        if baoJi > 0 then
            changehumnewvalue(actor, 21, -10000, 655350)
        end
    end
end

--Ѳ����ʱ��
function ontimer4(actor)
    GameEvent.push(EventCfg.onXunHangOnTime, actor)
end

--�ɽٶ�ʱ��_���֮·
function ontimer5(actor)
    GameEvent.push(EventCfg.onDuJieOnTiemr, actor)
end

--�������̽���
function ontimer6(actor)
    GameEvent.push(EventCfg.onFXQPReward, actor)
end

--��ˮ��ʱ��
function ontimer7(actor)
    GameEvent.push(EventCfg.onQMHTimer, actor)
end

--����֮����ʱ��
function ontimer8(actor)
    GameEvent.push(EventCfg.onMYZWimer, actor)
end

--�����ݵ㶨ʱ��
function ontimer9(actor)
    GameEvent.push(EventCfg.onJQPDimer, actor)
end

--��������ʱ��
function ontimer10(actor)
    local currHpPer = Player.getHpPercentage(actor) or 0
    if currHpPer == 100 then
        return
    end
    local addHp = tonumber(getplaydef(actor, "N$��������Ѫ")) or 0
    humanhp(actor, "+", addHp, 4)
end

--��������Ѫ
function ontimer11(actor)
    local currHpPer = Player.getHpPercentage(actor) or 0
    if currHpPer == 100 then
        return
    end
    humanhp(actor, "+", math.ceil(Player.getHpValue(actor, 20)), 4)
end

--�������1 ÿ��1ִ��
function ontimer101(actor)
    GameEvent.push(EventCfg.ReliveCountdown_1, actor)
end

--�������2 ÿ��1ִ��
function ontimer102(actor)
    GameEvent.push(EventCfg.ReliveCountdown_2, actor)
end

--�������3 ÿ��1ִ��
function ontimer103(actor)
    GameEvent.push(EventCfg.ReliveCountdown_3, actor)
end

--360��������ʱ��   60Sһִ��
function ontimer104(actor)
    local Num = getplaydef(actor, VarCfg["J_����ʱ��"])
    Num = Num + 1
    setplaydef(actor, VarCfg["J_����ʱ��"], Num)
    if Num <= 360 then
        GameEvent.push(EventCfg.onTimer104, actor)
    end
    --���������ӱ�
    if getflagstatus(actor,VarCfg["F_���������ӱ�"]) == 1 then
        addbuff(actor,31071,0,1,actor,{})
    end
end

local tb = {
    "С��ʾ/С���ɣ����ⱳ���������Բ���ҹ����ҰӰ�죬�磬���±��飬�����ڵ���ҹ����ȡ�",
    "С��ʾ/С���ɣ����������⻷���Լ������������������Ŷ��",
    "С��ʾ/С���ɣ�ת�������ǿ����ۼӵģ������ǵġ�",
    "С��ʾ/С���ɣ������ӡ��ǰ���������ٵ���Ҫ;����",
    "С��ʾ/С���ɣ������ż��ľ������˿���ʹ����ʯ�һ�����Ŷ",
    "С��ʾ/С���ɣ�����ʯ���칤֮�������ڼ����½�ϳɸ߼����ϡ�",
    "С��ʾ/С���ɣ������п���ѡ���Ƿ���տ�����װ����ǿ��װ����",
    "С��ʾ/С���ɣ�ȫ����ʬ����������3.",
    "С��ʾ/С���ɣ�װ���㼶����ͨװ��---����--ϡ��ר��---��ʥʷʫ---��֮����---������",
}

function ontimer105(actor)
    local random = math.random(1,#tb)
    callscriptex(actor,"SENDMSG",5,tb[random])
end

--������˹֮Ĺ
function ontimer172(actor)
    GameEvent.push(EventCfg.HaFaXiSiZhiMuOnTimer, actor)
end

--������˹֮Ĺ
function ontimer173(actor)
    GameEvent.push(EventCfg.HaFaXiSiJiTanOnTimer, actor)
end

--������˹֮Ĺ����
function ontimer174(actor)
    local myName = getbaseinfo(actor, ConstCfg.gbase.name)
    if not FCheckMap(actor, myName .. "������˹֮Ĺ(һ��)") then
        setofftimer(actor, 174)
    end
    if randomex(50) then
        local hpper = Player.getHpValue(actor, 5)
        humanhp(actor, "-", hpper)
        playeffect(actor, 1079, 0, 0, 1, 1, 1)
    end
end

function ontimer170(actor)
    GameEvent.push(EventCfg.HaFaXiSiZhiMuOnTimer, actor)
end

------------------------------------���˶�ʱ��end---------------------------------

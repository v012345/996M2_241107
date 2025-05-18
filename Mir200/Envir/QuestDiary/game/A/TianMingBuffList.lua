local TianMingBuff = {}


TianMingBuff[1000] = function(actor, Target, Hiter, MagicId)
    if randomex(2) then
        makeposion(Target, 13, 3, 0, 1)
        local myName = Player.GetNameEx(actor)
        local targetName = Player.GetNameEx(Target)
        Player.buffTipsMsg(actor, "[֩����]:���Ŀ��[{" .. targetName .. "/FCOLOR=243}]������,����3S!")
        Player.buffTipsMsg(Target, "[֩����]:�㱻���[{" .. myName .. "/FCOLOR=243}]������,����3S!")
    end
end

--����ʱ3%�����ٻ����׺䶥��Ŀ�������󹥻�60%���˺�
TianMingBuff[1001] = function(actor, Target, Hiter, MagicId)
    if randomex(3) then
        local myMaxAttackNum = getbaseinfo(actor, ConstCfg.gbase.dc2)
        local damage = math.ceil(myMaxAttackNum * 0.6)
        humanhp(Target, "-", damage, 1, nil, nil, nil)
        playeffect(Target, 15237, 0, 0, 1, 0, 0)
    end
end

--����ξ� �����и����ͷ�����ξ�������2*2��Χ���γɽ��ʹ�Ѿ�ÿ��ָ�3%�������ֵ������5S��
TianMingBuff[1002] = function(actor, Target, Hiter, MagicId)
    if randomex(1,128) then
        addbuff(actor, 30077)
    end
end

TianMingBuff[1003] = function(actor, Target, Hiter, MagicId)
    local hpPer = Player.getHpPercentage(actor)
    if hpPer > 3 and hpPer < 100 then
        humanhp(actor, "+", Player.getHpValue(actor, 1), 4)
    end
end

--�ͷ��������ܺ��´ι�����������30%���˺�
TianMingBuff[1004] = function(actor, Target, Hiter, MagicId)
    if getplaydef(actor, VarCfg["N$�ͷ��������ܸ����˺�"]) == 1 then
        local getDamage = tonumber(getconst(actor, "<$DAMAGEVALUE>"))
        local damage = math.ceil(getDamage * 0.3)
        if damage > 0 then
            humanhp(Target, "-", math.ceil(getDamage * 0.3), 1, nil, nil, nil)
            setplaydef(actor, VarCfg["N$�ͷ��������ܸ����˺�"], 0)
        end
    end
end

--Ѫ������
TianMingBuff[1005] = function(actor, Target, Hiter, MagicId)
    local targetHp = Player.getHpValue(Target, 3)
    humanhp(Target, "-", targetHp, 60, 0, actor)
end

--Ԫ��֮��
TianMingBuff[1006] = function(actor, Target, Hiter, MagicId)
    if randomex(1,200) then
        recallself(actor, 60, 1, 120, 254)
        local selflist = clonelist(actor)
        local seflObj = selflist[#selflist]
        local myName = Player.GetNameEx(actor)
        changemonname(seflObj, myName .. "��Ԫ��")
        callscriptex(seflObj,"ChangeSpeedEX", 2, getplaydef(actor, VarCfg["U_�����ٶ�"]) - 100)
        Player.buffTipsMsg(actor, "[Ԫ��֮��]:���ٻ����Լ���Ԫ��Ϊ����ս,����Ϊ60��!")
    end
end

--��Ӱ --����ʱ����1%�ļ��ʴӵ��˵���Ұ����ʧ2�룬���ӷ���+ 20%
TianMingBuff[1007] = function(actor, Target, Hiter, MagicId)
    if randomex(1,128) then
        addbuff(actor, 30086)
        Player.buffTipsMsg(actor, "[��Ӱ]:��������,���ӷ���+20%,����2��!")
    end
end

--����ʱ��2%�ĸ����ͷ����򣬽�4*4��Χ��5��������Ϊ������������������20%�����˺���
TianMingBuff[1008] = function(actor, Target, Hiter, MagicId)
    if randomex(2) then
        addbuff(actor, 30087)
        changemode(actor, 11, 5, 4, 1)
        Player.buffTipsMsg(actor, "[��������]:���ͷ�����������,4*4��Χ��Ϊ��������,����20%�����˺�,����5��!")
    end
end
--����������2%�ĸ���������ˣ�ʹ�����2S�����ӵȼ���ࡣ��ѹ
TianMingBuff[1009] = function(actor, Target, Hiter, MagicId)
    if randomex(2) then
        if getbaseinfo(Target,-1) == false then
            return
        end
        local myName = Player.GetNameEx(actor)
        local targetName = Player.GetNameEx(Target)
        Player.buffTipsMsg(actor, "[��ѹ]:�������[{" .. targetName .. "/FCOLOR=243}]2��!")
        Player.buffTipsMsg(Target, "[��ѹ]:�㱻���[{" .. myName .. "/FCOLOR=243}]������2��!")
        changemode(Target, 11, 2, 1, 0)
    end
end
--������+10%��ÿ�ι�����������Ѫ��3%����ʵ�˺���
TianMingBuff[1010] = function(actor, Target, Hiter, MagicId)
    local hpPer = Player.getHpValue(actor, 3)
    if hpPer > 0 then
        humanhp(Target, "-", hpPer, 60, nil, nil, nil)
    end
end

--����֮�� 9�ι������һ���ػ�
TianMingBuff[1011] = function(actor, Target, Hiter, MagicId)
    local num = getplaydef(actor,"N$����֮��")
    setplaydef(actor,"N$����֮��",num + 1)
    if num + 1 >= 9 then
        setplaydef(actor,"N$����֮��",0)
        --Player.buffTipsMsg(actor, "[����֮��]:����ÿ9�ι��������Ŀ����ɹ���X300%���ػ���!")
        humanhp(Target, "-", getbaseinfo(actor,51,4)*3, 110, 0, actor)
    end
end

--��������	����״̬������ʱ�����ָ�1%����ֵ
TianMingBuff[1012] = function(actor, Target, Hiter, MagicId)
    if not ReliveMain.GetReliveState(actor) then
        humanhp(actor, "+", Player.getHpValue(actor, 1), 4)
    end
end

TianMingBuff[2000] = function(actor, Target, Hiter, MagicId)
    local targetPKPonits = getbaseinfo(Target, ConstCfg.gbase.pkvalue)
    if targetPKPonits >= 100 then
        humanhp(Target, "-", 50, 1)
    end
end
-- ������͵ �������ʱ����1%�ĸ�����ȡ����1%�Ľ�ҡ���ÿ�����100W��ÿ�����2000W
TianMingBuff[2001] = function(actor, Target, Hiter, MagicId)
    if randomex(1) then
        -- if not hasbuff(actor, 30073) then
            -- addbuff(actor, 30073, 60)
        local currentGlod = tonumber(getplaydef(actor, VarCfg["J_����������͵�������"]))
        if currentGlod < 20000000 then
            local targetGold = querymoney(Target, 1)
            local gold = calculatePercentageResult(targetGold, 1)
            if gold > 0 then
                if gold > 1000000 then
                    gold = 1000000
                end
                local myName = Player.GetNameEx(actor)
                local targetName = Player.GetNameEx(Target)
                changemoney(Target, 1, "-", gold, "������͵��ȡ���:" .. myName, true)
                local myID = getbaseinfo(actor, ConstCfg.gbase.id)
                local targetID = getbaseinfo(Target, ConstCfg.gbase.id)
                local give = {{"���",gold}}
                Player.giveMailByTable(myID, 1, "������͵", "��͵ȡ�����[" .. targetName .. "]���:" .. gold, give)
                -- Player.giveMailByTable(targetID, 1, "������͵", "�㱻���[" .. myName .. "]͵ȡ�˽��:" .. gold)
                sendmail(targetID,1,"������͵", "�㱻���[" .. myName .. "]͵ȡ�˽��:" .. gold)
                setplaydef(actor, VarCfg["J_����������͵�������"], currentGlod + gold)
            end
        end
        -- end
    end
end

TianMingBuff[2002] = function(actor, Target, Hiter, MagicId)
    if randomex(2) then
        if not hasbuff(actor, 30084) then
            local myName = Player.GetNameEx(actor)
            local targetName = Player.GetNameEx(Target)
            setattackmode(Target, 1, 3)
            Player.buffTipsMsg(actor, "[��սֹս]:���[{" .. targetName .. "/FCOLOR=243}]����ǿ�ƺ�ƽģʽ3��!")
            Player.buffTipsMsg(Target, "[��սֹս]:�㱻���[{" .. myName .. "/FCOLOR=243}]ǿ�ƺ�ƽģʽ3��!")
            addbuff(actor, 30084)
        end
    end
end

TianMingBuff[2003] = function(actor, Target, Hiter, MagicId)
    if Player.checkCd(actor, VarCfg["�ռ�����CD"], 60, true) then
        local myName = Player.GetNameEx(actor)
        local targetName = Player.GetNameEx(Target)
        if checkkuafu(actor) then
            FAddBuffKF(Target, 30089, 10)
        else
            addbuff(Target, 30089, 10)
        end
        Player.buffTipsMsg(actor, "[�ռ�����]:������[{" .. targetName .. "/FCOLOR=243}]ʹ���˿ռ�����,10�����޷��سǺʹ���!")
        Player.buffTipsMsg(Target, "[�ռ�����]:���[{" .. myName .. "/FCOLOR=243}]����ʹ���˿ռ�����,10�����޷��سǺʹ���!!")
    end
end

TianMingBuff[2004] = function(actor, Target, Hiter, MagicId)
    if randomex(5) then
        if not Player.checkCd(actor, VarCfg["��������CD"], 120, true) then
            return
        end
        local targetBeiGong = tonumber(getconst(Target, "<$POWERRATE>"))
        if targetBeiGong > 1 then
            local targetRealBeiGong = (targetBeiGong - 1) * 100
            local stealBeiGong = math.ceil(targetRealBeiGong * 0.3)
            if stealBeiGong > 0 then
                setplaydef(actor, VarCfg["N$͵ȡ����"], stealBeiGong)
                --�����ҵı���
                local myBeiGong = tonumber(getconst(actor, "<$POWERRATE>")) * 100 + stealBeiGong
                setplaydef(actor, VarCfg["N$��ұ���"], stealBeiGong)
                powerrate(actor, myBeiGong, 655350)
                --��ȡ����
                local currBeiGong = getconst(actor, "<$POWERRATE>")
                setplaydef(actor, VarCfg["T_����"], currBeiGong)
                --�ӳ�5���ָ�
                delaygoto(actor, 5000, "jielidali_beigonghuifu")
                --���öԷ���
                local TargetMyBeiGong = tonumber(getconst(Target, "<$POWERRATE>")) * 100 - stealBeiGong
                powerrate(Target, TargetMyBeiGong, 655350)
                local TargetCurrBeiGong = getconst(Target, "<$POWERRATE>")
                setplaydef(Target, VarCfg["T_����"], TargetCurrBeiGong)
                delaygoto(Target, 5000, "jielidali_beigonghuifu")
    
                local myName = Player.GetNameEx(actor)
                local targetName = Player.GetNameEx(Target)
                Player.buffTipsMsg(actor, "[��������]:��͵ȡ�����[{" .. targetName .. "/FCOLOR=243}]30%����!")
                Player.buffTipsMsg(Target, "[��������]:�㱻���[{" .. myName .. "/FCOLOR=243}]͵ȡ��30%����!")
            end
        end
    end
end

TianMingBuff[3000] = function(actor, Target, Hiter, MagicId)
    if Player.canLifesteal(actor) then
        humanhp(actor, "+", 20, 4, nil, nil, nil)
    end
end
--ÿ8�������նɱĿ��1%���������ֵ�������Թ���Ч��
TianMingBuff[3001] = function(actor, Target, Hiter, MagicId)
    local count = getplaydef(actor, VarCfg["N$���¿��ϵ�������"])
    setplaydef(actor, VarCfg["N$���¿��ϵ�������"], count + 1)
    if count >= 8 then
        setplaydef(actor, VarCfg["N$���¿��ϵ�������"], 0)
        local calcHp = Player.getHpValue(Target, 1)
        humanhp(Target, "-", calcHp, 1, 0, actor)
    end
end

--����ʱ������ֵ����30%�Ĺ���������75%����ʵ�˺�
TianMingBuff[3002] = function(actor, Target, Hiter, MagicId, qieGe)
    local targetHp = Player.getHpPercentage(Target)
    if targetHp < 30 then
        if qieGe then
            local qiege = getbaseinfo(actor, ConstCfg.gbase.custom_attr, 200)
            local damage = math.ceil(qiege * 0.75)
            qieGe.damage = qieGe.damage + damage
        end
    end
end

--��������ʱ�����ָ�1888������ֵ
TianMingBuff[3003] = function(actor, Target, Hiter, MagicId)
    -- local nowmonhp = Player.getHpPercentage(actor)
    if Player.canLifesteal(actor) then
        humanhp(actor, "+", 1888, 4, nil, nil, nil)
    end
end
--ÿ�ι���ʱ������������1%���и��˺����������10%��ֹͣ����5���״̬���㣡
TianMingBuff[3004] = function(actor, Target, Hiter, MagicId, qieGe)
    if not qieGe then
        return
    end
    addbuff(actor, 30069)
    local dieJia = getbuffinfo(actor, 30069, 1)
    if dieJia > 0 then
        local currQieGe = getbaseinfo(actor, ConstCfg.gbase.custom_attr, 200)
        qieGe.damage = qieGe.damage + math.ceil(currQieGe * (dieJia / 100))
    end
end

--��������ʱ20%�ĸ����ͷŽ��з籩��10%�����ͷű�˪���ǡ�
TianMingBuff[3005] = function(actor, Target, Hiter, MagicId, qieGe)
    if not qieGe then
        return
    end
    --���з籩
    if randomex(5) then
        if not hasbuff(actor, 30076) then
            addbuff(actor, 30075)
            addbuff(actor, 30076)
        end
    end
    --��˪����
    if randomex(3) then
        local x = getbaseinfo(actor, ConstCfg.gbase.x)
        local y = getbaseinfo(actor, ConstCfg.gbase.y)
        local myMaxAttackNum = getbaseinfo(actor, ConstCfg.gbase.dc2)
        rangeharm(actor, x, y, 3, myMaxAttackNum, 0, 0, 0, 2)
        playeffect(actor, 15195, 0, 0, 1, 0, 0)
    end
end


--���й����˺�+8%���ܵ����˺�+8%
TianMingBuff[4000] = function(actor, Target, Hiter, MagicId, Damage, Model, attackDamageData)
    attackDamageData.damage = attackDamageData.damage + math.ceil(Damage * 0.08)
end

--�����һ𽣷��˺�10%
TianMingBuff[4001] = function(actor, Target, Hiter, MagicId, Damage, Model, attackDamageData)
    if MagicId == 26 then
        attackDamageData.damage = attackDamageData.damage + math.ceil(Damage * 0.1)
    end
end

--ȫ�����˺�+20%
TianMingBuff[4002] = function(actor, Target, Hiter, MagicId, Damage, Model, attackDamageData)
    if MagicId ~= 7 or MagicId ~= 0 or MagicId ~= 12 then
        attackDamageData.damage = attackDamageData.damage + math.ceil(Damage * 0.2)
    end
end

--HPÿ�½�1%����������1%�Ķ����˺������99%
TianMingBuff[4003] = function(actor, Target, Hiter, MagicId, Damage, Model, attackDamageData)
    local hpPer = Player.getHpPercentage(actor)
    if hpPer < 100 then
        local damage = math.ceil(100 - hpPer)
        if damage > 0 then
            local finalDamage = math.ceil(Damage * (damage / 100))
            attackDamageData.damage = attackDamageData.damage + finalDamage
        end
    end
end

--���ɵй�--ÿӵ��1000W��ң��������1%���˺������10%
TianMingBuff[4004] = function(actor, Target, Hiter, MagicId, Damage, Model, attackDamageData)
    local gold = getbindmoney(actor, "���")
    local addition = math.ceil(gold / 10000000)
    -- release_print(addition)
    if addition > 10 then
        addition = 10
    end
    local damageAddtion = math.ceil(Damage * (addition / 100))
    attackDamageData.damage = attackDamageData.damage + damageAddtion
end

--��Ŀ�������͵Ϯ��ͨ�˺�����25% �����˺�����50%
TianMingBuff[4005] = function(actor, Target, Hiter, MagicId, Damage, Model, attackDamageData)
    local myDir = getbaseinfo(actor, 69)
    local targetDir = getbaseinfo(Target, 69)
    if myDir == targetDir then
        if MagicId == 7 or MagicId == 0 or MagicId == 12 then
            attackDamageData.damage = attackDamageData.damage + math.ceil(Damage * 0.25)
        else
            attackDamageData.damage = attackDamageData.damage + math.ceil(Damage * 0.50)
        end
    end
end

--�����˺�+10%
TianMingBuff[4006] = function(actor, Target, Hiter, MagicId, Damage, Model, attackDamageData)
    if MagicId ~= 7 and MagicId ~= 0 and MagicId ~= 12 then
        attackDamageData.damage = attackDamageData.damage + math.ceil(Damage * 0.1)
    end
end

--��Ұ�޳�������ʱ��ɵ������˺�����������޷�Ԥ�⡣
TianMingBuff[4007] = function(actor, Target, Hiter, MagicId, Damage, Model, attackDamageData)
    local result, difference = getRandomDifference(Damage)
    attackDamageData.damage = attackDamageData.damage + difference
end

--ʹ���һ𽣷�ʱ����6%�ļ������ͷ�һ�Ρ��һ𽣷��˺�+ 10%
TianMingBuff[4008] = function(actor, Target, Hiter, MagicId, Damage, Model, attackDamageData)
    if MagicId == 26 then
        if randomex(6) then
            releasemagic_target(actor, 26, 1, 3, Target, 1)
            Player.buffTipsMsg(actor, "[�һ�����]:����ʹ���һ𽣷�ʱ,�����ٴ��ͷ�,�һ𽣷��˺�+10%!")
            attackDamageData.damage = attackDamageData.damage + math.ceil(Damage * 0.1)
        end
    end
end

--�����ٶ�+20%����ɱ�˺�+15%
TianMingBuff[4009] = function(actor, Target, Hiter, MagicId, Damage, Model, attackDamageData)
    if MagicId == 12 then
        attackDamageData.damage = attackDamageData.damage + math.ceil(Damage * 0.2)
    end
end

--�Ե������120%���˺��������ܵ�120%���˺�
TianMingBuff[4010] = function(actor, Target, Hiter, MagicId, Damage, Model, attackDamageData)
    attackDamageData.damage = attackDamageData.damage + math.ceil(Damage * 1.2)
end


--�������Լ��ȼ��ߵ����ʱ��ÿ���1�������2%�Ķ����˺������20%
TianMingBuff[5000] = function(actor, Target, Hiter, MagicId, Damage, Model, attackDamageData)
    local myLeve = getbaseinfo(actor, ConstCfg.gbase.level)
    local targetLeve = getbaseinfo(Target, ConstCfg.gbase.level)
    local differenceLevel = math.abs(targetLeve - myLeve)
    if differenceLevel > 0 then
        if differenceLevel > 20 then
            differenceLevel = 20
        end
        local currDame = math.ceil(Damage * (differenceLevel / 100))
        -- release_print(currDame)
        attackDamageData.damage = attackDamageData.damage + currDame
    end
end
--�������ʱ��������15%���������ֵ������10s
TianMingBuff[5001] = function(actor, Target, Hiter, MagicId, Damage, Model, attackDamageData)
    if actor == Target then
        return
    end
    --buff��ȴ
    if Player.checkCd(actor, VarCfg["Ѫ��ѹ�ƶ�Ŀ��CD"], 30, true) then
        if Player.checkCd(actor, VarCfg["Ѫ��ѹ���ܻ�CD"], 10, true) then --���Ŀ��û��buff
            --���������ִ��
            if checkkuafu(Target) then
                FKuaFuToBenFuRunScript(Target,5001,0)
            else
                if Player.GetAttr(Target,208) > 15 then
                    changehumnewvalue(Target, 208, -15, 10)
                else
                    local targetHp = Player.getHpValue(Target, 15)
                    changehumnewvalue(Target, 1, -targetHp, 10)
                end
            end
            local myName = Player.GetNameEx(actor)
            local targetName = Player.GetNameEx(Target)
            Player.buffTipsMsg(actor, "[Ѫ��ѹ��]:������[{" .. targetName .. "/FCOLOR=243}],ʩ����[Ѫ��ѹ��]BUFF,�Է��������ֵ-15%,����10S!")
            Player.buffTipsMsg(Target, "[Ѫ��ѹ��]:�㱻���[{" .. myName .. "/FCOLOR=243}]ʩ����[Ѫ��ѹ��]BUFF,�������ֵ-15%,����10S!")
        else
            local targetName = Player.GetNameEx(Target)
            Player.buffTipsMsg(actor, "[Ѫ��ѹ��]:Ŀ�����[{" .. targetName .. "/FCOLOR=243}],�Ѿ���ʩ����[Ѫ��ѹ��]BUFF,��Ŀ��ʹ��ʧ��!")
        end
    end
end

--����һ����ɱ�Լ��ı��Ϊ���� �������˻���˺��ӳ�30%
TianMingBuff[5002] = function(actor, Target, Hiter, MagicId, Damage, Model, attackDamageData)
    local currTargetId = getbaseinfo(Target, ConstCfg.gbase.id)
    local targetId = getplaydef(actor, VarCfg["T_����_����_��¼�Է�ID"])
    if currTargetId == targetId then
        attackDamageData.damage = attackDamageData.damage + math.ceil(attackDamageData.damage * 0.3)
    end
end

--�����ֱ��Լ��̵���Ҷ������20%���˺���
TianMingBuff[5003] = function(actor, Target, Hiter, MagicId, Damage, Model, attackDamageData)
    local myName = Player.GetNameEx(actor)
    local targetName = Player.GetNameEx(Target)
    if GbkLength(myName) > GbkLength(targetName) then
        attackDamageData.damage = attackDamageData.damage + math.ceil(Damage * 0.2)
    end
end

--�����ֱ��Լ�������Ҷ������20%���˺���
TianMingBuff[5004] = function(actor, Target, Hiter, MagicId, Damage, Model, attackDamageData)
    local myName = Player.GetNameEx(actor)
    local targetName = Player.GetNameEx(Target)
    if GbkLength(myName) < GbkLength(targetName) then
        attackDamageData.damage = attackDamageData.damage + math.ceil(Damage * 0.2)
    end
end

--�������� ��������Է��� �ظ��Լ�����
TianMingBuff[5005] = function(actor, Target, Hiter, MagicId, Damage, Model, attackDamageData)
    local random = math.random(1,10000)
    if random <= 50 then
        if Player.checkCd(actor, VarCfg["������CD"], 90, true) then
            addhpper(actor,"+",50)
            addmpper(Target,"-",100)
            local myName = Player.GetNameEx(actor)
            local targetName = Player.GetNameEx(Target)
            Player.buffTipsMsg(actor, "[��������]:������[{" .. targetName .. "/FCOLOR=243}],ʩ����[��������]BUFF,�Է��������,�����ָ�50%����!")
            Player.buffTipsMsg(Target, "[��������]:�㱻���[{" .. myName .. "/FCOLOR=243}]ʩ����[��������]BUFF,������������!")
        end
    end
end
--�Ի���
--�Ե�������5�������
--��5%�ĸ���ʹ������2
--���޷�����(CD:60S
TianMingBuff[5006] = function(actor, Target, Hiter, MagicId, Damage, Model, attackDamageData)
    if Player.GetLevel(actor) - Player.GetLevel(Target) >= 5 then
        if Player.checkCd(actor, VarCfg["�Ի���CD"], 60, true) then
            local random = math.random(1,10000)
            if random <= 50 then
                changemode(Target, 11, 2, 1, 2)    --������Χ3 ����ʱ��5��
                addbuff(actor, 31075, 60, 1, actor)
                local myName = Player.GetNameEx(actor)
                local targetName = Player.GetNameEx(Target)
                Player.buffTipsMsg(actor, "[�Ի���]:�㽫{" .. targetName .. "/FCOLOR=243}����{2��/FCOLOR=243}...")
                Player.buffTipsMsg(Target, "[�Ի���]:�㱻[{" .. myName .. "/FCOLOR=243}]����{2��/FCOLOR=243}...")
            end
        end
    end
end
--Ϊ�Ҷ���
--�ڹ����������˺�����
--����10%
TianMingBuff[5007] = function(actor, Target, Hiter, MagicId, Damage, Model, attackDamageData)
    if getbaseinfo(actor,60) then
        attackDamageData.damage = attackDamageData.damage + math.ceil(Damage * 0.1)
    end
end

--�����ʱ���Թ��˺�+15%
TianMingBuff[6000] = function(actor, Target, Hiter, MagicId, Damage, Model, attackDamageData)
    local isGroup = getbaseinfo(actor, ConstCfg.gbase.team_num)
    if isGroup == 0 then
        attackDamageData.damage = attackDamageData.damage + math.ceil(Damage * 0.15)
    end
end
--�Թֱ�������+15%
TianMingBuff[6001] = function(actor, Target, Hiter, MagicId, Damage, Model, attackDamageData)
    if randomex(10) then
        humanhp(Target, "-", Damage * 2, 2, 0, actor)
    end
end


--�κι�����ĵ��˶��ᱻ���Լ����������%2
TianMingBuff[7000] = function(actor, Target, Hiter, MagicId)
    if not hasbuff(actor, 30071) then
        addbuff(actor, 30071, 30)
        local myName = Player.GetNameEx(actor)
        local targetName = Player.GetNameEx(Target)
        Player.buffTipsMsg(actor, "[�������]:��������Ŀ��[{" .. targetName .. "/FCOLOR=243}],����5S!")
        Player.buffTipsMsg(Target, "[�������]:�㱻[{" .. myName .. "/FCOLOR=243}]������,����5S!")
        local myHp = Player.getHpValue(actor, 2)
        humanhp(Target, "-", myHp, 1, 0, actor)
        humanhp(Target, "-", myHp, 1, 1, actor)
        humanhp(Target, "-", myHp, 1, 2, actor)
        humanhp(Target, "-", myHp, 1, 3, actor)
        humanhp(Target, "-", myHp, 1, 4, actor)
    end
end

TianMingBuff[7001] = function(actor, Target, Hiter, MagicId)
    if randomex(5) then
        releasemagic(actor, 2, 1, 3, 2, 0)
        Player.buffTipsMsg(actor, "[���ֻش�]:���ͷ���������!")
    end
end

TianMingBuff[7002] = function(actor, Target, Hiter, MagicId)
    if randomex(3) then
        -- changespeedex(Target, 2, -30, 3)
        local myName = Player.GetNameEx(actor)
        local targetName = Player.GetNameEx(Target)
        Player.buffTipsMsg(actor, "[��������]:�㽵����[{" .. targetName .. "/FCOLOR=243}]30%�Ĺ����ٶ�,����3S!")
        Player.buffTipsMsg(Target, "[��������]:�㱻[{" .. myName .. "/FCOLOR=243}]������30%�Ĺ����ٶ�,����3S!")
    end
end

--��Ѫ����50%35%20%ʱ�ֱ��ٻ�һ������ÿ���������20S �̳�����80%�Ļ������ԡ�
TianMingBuff[7003] = function(actor, Target, Hiter, MagicId)
    local hpPer = Player.getHpPercentage(actor)
    local recallList = clonelist(actor)
    if hpPer < 50 and hpPer > 35 and #recallList == 0 then
        recallself(actor, 20, 1, 100, 249)
    elseif hpPer < 35 and hpPer > 20 and #recallList < 2 then
        recallself(actor, 20, 1, 100, 249)
    elseif hpPer < 20 and #recallList < 3 then
        recallself(actor, 20, 1, 100, 249)
    end
end

--��Ѫ������20%ʱ���и��ʽ������Ԫ�ռ䣬3�����Ѫ�ص�ԭλ�á�
TianMingBuff[7004] = function(actor, Target, Hiter, MagicId)
    if checkkuafu(actor) then
        return
    end
    local hpPer = Player.getHpPercentage(actor)
    if hpPer < 20 then
        if randomex(15) then
            if Player.checkCd(actor, VarCfg["���޶���CD"], 300, true) then
                if getflagstatus(actor, VarCfg.F_isGuaJi) == 1 then
                    setplaydef(actor, "N$���޶��۽����Ƿ�һ�",1)
                end
                local myName1 = Player.GetNameEx(actor)
                Player.buffTipsMsg(Target, "[���޶���]:Ŀ��[{" .. myName1 .. "/FCOLOR=243}]�������Ԫ�ռ�,3�����Ѫ����ԭλ��!")
                if checkkuafu(actor) then
                    FKuaFuToBenFuRunScript(actor, 5, "")
                else
                    addbuff(actor, 30095)
                    local oldMapId = getbaseinfo(actor, ConstCfg.gbase.mapid)
                    local myName = Player.GetName(actor)
                    local newMapId = myName .. "y"
                    local x = getbaseinfo(actor, ConstCfg.gbase.x)
                    local y = getbaseinfo(actor, ConstCfg.gbase.y)
                    addmirrormap("db001", newMapId, "���Ԫ�ռ�" .. "(" .. myName .. ")", 3, oldMapId, 0, x, y)
                    Player.buffTipsMsg(actor, "[���޶���]:�������Ԫ�ռ䣬3�����Ѫ�ص�ԭλ�á�")
                    map(actor, newMapId)
                end
            end
        end
    end
end

--������
TianMingBuff[7005] = function(actor, Target, Hiter, MagicId)
    local hpPer = Player.getHpPercentage(actor)
    if hpPer < 60 and getplaydef(actor,"N$������") == 0 then
        setplaydef(actor,"N$������",1)
        addattlist(actor, "������", "=", "3#213#20|3#214#20", 1)
    end
end

TianMingBuff[8000] = function(actor, Target, Hiter, MagicId)
    if not hasbuff(actor, 30092) then
        addbuff(actor, 30092)
        makeposion(Target, 12, 1.5, 0, 0)
        local myName = Player.GetNameEx(actor)
        local targetName = Player.GetNameEx(Target)
        Player.buffTipsMsg(actor, "[��и�ɻ�]:�������[{" .. targetName .. "/FCOLOR=243}],����1.5S!")
        Player.buffTipsMsg(Target, "[��и�ɻ�]:�㱻[{" .. myName .. "/FCOLOR=243}]ʹ��[��и�ɻ�]������1.5S!")
    end
end

--�����﹥��ʱ3%���ʻָ�10%��Ѫ����
TianMingBuff[9000] = function(actor, Target, Hiter, MagicId)
    if randomex(3) then
        if Player.canLifesteal(actor) then
            humanhp(actor, "+", Player.getHpValue(actor, 10), 4, nil, nil, nil)
            Player.buffTipsMsg(actor, "[ԽսԽ��]:���Ѫ���ָ�10%")
        end
    end
end

--�ܵ�����ʱ��1%�����ͷ���ʥս����
TianMingBuff[10000] = function(actor, Target, Hiter, MagicId, Damage, attackDamageData)
    if randomex(1) then
        releasemagic(actor, 15, 1, 3, 2, 0)
        Player.buffTipsMsg(actor, "[���Ŷݼ�]:���ͷ��˼���[��ʥս����]")
    end
end

--�һ���
TianMingBuff[10001] = function(actor, Target, Hiter, MagicId, Damage, attackDamageData)
    if getflagstatus(actor, VarCfg.F_isGuaJi) == 1 then
        attackDamageData.damage = attackDamageData.damage + math.ceil(Damage * 0.05)
    end
end

--PK�˺�+15%��󹥻�15% ѡ���������������㲢��PKʱ���ܵ��˺���������15%
TianMingBuff[10002] = function(actor, Target, Hiter, MagicId, Damage, attackDamageData)
    attackDamageData.damage = attackDamageData.damage - math.ceil(Damage * 0.15)
end

--������ʱ�нϸ߸�����ȫ���������˺���
TianMingBuff[10003] = function(actor, Target, Hiter, MagicId, Damage, attackDamageData)
    if randomex(3) then
        humanhp(Target, "-", Damage, 1, 0, actor)
        local myName = Player.GetNameEx(actor)
        local targetName = Player.GetNameEx(Target)
        Player.buffTipsMsg(actor, string.format("[�Ѿ��ƶ�]:�㷴����{%s/FCOLOR=249}���˺���[{%s/FCOLOR=243}]", Damage, targetName))
        Player.buffTipsMsg(Target, string.format("[�Ѿ��ƶ�]:[{%s/FCOLOR=243}]������{%s/FCOLOR=249}���˺�!", myName, Damage))
    end
end

--��������
TianMingBuff[10004] = function(actor, Target, Hiter, MagicId, Damage, attackDamageData)
    local hpPer = Player.getHpPercentage(actor)
    if hpPer < 30 then
        if not hasbuff(actor, 30079) then
            addbuff(actor, 30079)
            Player.buffTipsMsg(actor, "[��������]:ÿ��ָ�3%�������ֵ,ֱ��Ѫ������30%")
        end
    end
end

-- ������ÿ3��ظ�5%���������ֵ �ܵ��˺�����5555���˺�
TianMingBuff[10005] = function(actor, Target, Hiter, MagicId, Damage, attackDamageData)
    if Damage >= 5555 then
        local subDamage = 5555
        attackDamageData.damage = attackDamageData.damage + subDamage
    else
        attackDamageData.damage = attackDamageData.damage + Damage
    end
end

--�Ե������120%���˺��������ܵ�120%���˺�
TianMingBuff[10006] = function(actor, Target, Hiter, MagicId, Damage, attackDamageData)
    attackDamageData.damage = attackDamageData.damage - math.ceil(Damage + 1.2)
end

--�������ȼ�����+2 �����﹥��ʱ�����˺�+10%
TianMingBuff[11000] = function(actor, Target, Hiter, MagicId, Damage, attackDamageData)
    attackDamageData.damage = attackDamageData.damage - math.ceil(Damage * 0.1)
end

--���ֿܵ�+10%
TianMingBuff[11001] = function(actor, Target, Hiter, MagicId, Damage, attackDamageData)
    if MagicId ~= 7 or MagicId ~= 0 or MagicId ~= 12 then
        attackDamageData.damage = attackDamageData.damage + math.ceil(Damage * 0.1)
    end
end

--ɳ�ǰ��� ���������ܵ��˺�����20%
TianMingBuff[11002] = function(actor, Target, Hiter, MagicId, Damage, attackDamageData)
    if getbaseinfo(actor,60) then
        attackDamageData.damage = attackDamageData.damage + math.ceil(Damage * 0.2)
    end
end

TianMingBuff[13000] = function(actor)
    changespeedex(actor, 1, 15, 5)
    Player.buffTipsMsg(actor, "[��֮��]:���������15%�ƶ��ٶ�.����5S!")
end

--ÿɱ��һֻ�����ù���Ѫ��1%�Ľ�ң�ÿ������1ǧ��
TianMingBuff[14000] = function(actor, monobj)
    local MoneyPueer = tonumber(getplaydef(actor, VarCfg["J_�����в�֮��������"]))
    if MoneyPueer < 10000000 then
        local mobMaxHp = getbaseinfo(monobj, ConstCfg.gbase.maxhp)
        local moneyNum = math.ceil(mobMaxHp * 0.01)
        changemoney(actor, 3, "+", moneyNum, "�в�֮���ȡ", true)
        setplaydef(actor, VarCfg["J_�����в�֮��������"], MoneyPueer + moneyNum)
    end
end
--��ɱ������и��ʸ�����Ϊ�Լ�ս��������10����.���3ֻ
TianMingBuff[14001] = function(actor, monobj)
    if randomex(3) then
        local myBabyNum = getbaseinfo(actor, ConstCfg.gbase.pets_num)
        if myBabyNum < 3 then
            local monName = getbaseinfo(monobj, ConstCfg.gbase.name)
            recallmob(actor, monName, 1, 10)
            Player.buffTipsMsg(actor, "[����ǲ��]:��ѹ���[" .. monName .. "]������,Ϊ�Լ�ս��,����10����!")
        end
    end
end

--ÿ�λ�ɱ����ʱ�и�������100������ֵ������300000��
TianMingBuff[14002] = function(actor, monobj)
    if randomex(10) then
        local currHp = getplaydef(actor, VarCfg["U_����_ԡѪ��ħ_Ѫ��"])
        if currHp < 300000 then
            setplaydef(actor, VarCfg["U_����_ԡѪ��ħ_Ѫ��"], currHp + 100)
            Player.setAttList(actor, "���Ը���")
        end
    end
end

--�Ϸ���ɱ������100��PKֵ
TianMingBuff[15000] = function(actor, play)
    local currentPkValue = getbaseinfo(actor, ConstCfg.gbase.pkvalue)
    setbaseinfo(actor, ConstCfg.sbase.pkvalue, currentPkValue - 100)
    Player.buffTipsMsg(actor, "[�Ϸ���ɱ]:���PKֵ-100!")
end

--ÿ��ɱһ����ң���������1%�������ʺ��Ʒ����ʣ��������15%,����������������������ʧ��
TianMingBuff[15001] = function(actor, play)
    local killConunt = getplaydef(actor, VarCfg["N$���������¼����"])
    local currCount = killConunt + 1
    if killConunt < 15 then
        setplaydef(actor, VarCfg["N$���������¼����"], currCount)
    end
    if killConunt > 15 then
        killConunt = 15
    end
    delattlist(actor, "��������")
    addattlist(actor, "��������", "=", string.format("3#21#%d|3#28#%d", currCount, currCount), 1)
end

--ÿɱ��һ����ң��ָ������������ֵ20%����CD��
TianMingBuff[15002] = function(actor, play)
    local hpPer = Player.getHpValue(actor, 20)
    humanhp(actor, "+", hpPer, 4, nil, nil, nil)
    Player.buffTipsMsg(actor, "[ԡѪ��ս]:��ɱ���HP+20%!")
end

--��Ԫ������ɱ��Ŀ���ָ������������ֵ5%��
TianMingBuff[15003] = function(actor, play)
    addhpper(actor, "+", 5)
    Player.buffTipsMsg(actor, "[��Ԫ����]:��ɱ���HP+5%!")
end


--����������ʱ�и�������50�㹥����������3000�㣩
TianMingBuff[16000] = function(actor, hiter)
    if randomex(50) then
        local tatol = getplaydef(actor, VarCfg["U_����_Խ��Խ�¹����ۼ�"])
        if tatol < 3000 then
            setplaydef(actor, VarCfg["U_����_Խ��Խ�¹����ۼ�"], tatol + 50)
            Player.buffTipsMsg(actor, "[Խ��Խ�¹�]:������+50!")
            delattlist(actor, "Խ��Խ��")
            addattlist(actor, "Խ��Խ��", "=", "3#4#" .. tatol + 50, 1)
        end
    end
end

--����һ�ɱ�󣬶������ɱ������200��PKֵ
TianMingBuff[16001] = function(actor, hiter)
    if getbaseinfo(hiter,-1) == false then
        return
    end
    if getconst(hiter, ConstCfg.equipconst["����"]) ~= "�����С���������" or getconst(hiter, ConstCfg.equipconst["ѫ��"]) ~= "��Դ֮��" then
        local hiterName = Player.GetNameEx(hiter)
        Player.buffTipsMsg(actor, "[����֮��]:�㱻" .. hiterName .. "��ɱ,���ڶԷ�������װ��,���ߺ���,�޷�����PKֵ!")
    else
        local currPkValue = getbaseinfo(hiter, ConstCfg.gbase.pkvalue)
        setbaseinfo(hiter, ConstCfg.sbase.pkvalue, currPkValue + 200)
        local myName = Player.GetNameEx(actor)
        local hiterName = Player.GetNameEx(hiter)
        Player.buffTipsMsg(actor, "[����֮��]:�㱻" .. hiterName .. "��ɱ,�Է�PKֵ+200!")
        Player.buffTipsMsg(hiter, "[����֮��]:���ɱ��" .. myName .. ",�Է�[����֮��]BUFF��Ч,��������200��PKֵ!")
    end
end
--����ʱ��ɱ���Լ��ĵ�����ɶԷ����HP30%����ʵ�˺���
TianMingBuff[16002] = function(actor, hiter)
    local myName = Player.GetNameEx(actor)
    local hiterName = Player.GetNameEx(hiter)
    Player.buffTipsMsg(actor, "[ͬ���ھ�]:�㱻[{" .. hiterName .. "/FCOLOR=243}]��ɱ,�Ե�����ɶԷ����HP30%����ʵ�˺�!")
    Player.buffTipsMsg(hiter, "[ͬ���ھ�]:���ɱ��[{" .. myName .. "/FCOLOR=243}],�Է�����BUFF,����������HP30%����ʵ�˺�!")
    humanhp(hiter, "-", Player.getHpValue(hiter, 30), 1, 0, actor)
end

--�����ɱ�Լ����˵��ձ��ʽ���100%�������ɵ��ӣ�
TianMingBuff[16003] = function(actor, hiter)
    if getbaseinfo(hiter,-1) == false then
        return
    end
    local myName = Player.GetNameEx(actor)
    local hiterName = Player.GetNameEx(hiter)
    if getplaydef(hiter, VarCfg["J_����Ȧ������_���䱬��"]) == 0 then
        setplaydef(hiter, VarCfg["J_����Ȧ������_���䱬��"], 1)
        addbuff(hiter, 30102, GetReaminSecondsTo24() + 30)
        Player.buffTipsMsg(actor, "[����ȦȦ������]:��������[{" .. hiterName .. "/FCOLOR=243}],�Է�����-100%")
        Player.buffTipsMsg(hiter, "[����ȦȦ������]:�㱻[{" .. myName .. "/FCOLOR=243}],������,����-100%,���ջָ�!")
        Player.setAttList(hiter, "���ʸ���")
    end
end

TianMingBuff[16004] = function(actor, hiter)
    if getbaseinfo(hiter,-1) == false then
        return
    end
    local hitetId = getbaseinfo(hiter, ConstCfg.gbase.id)
    local hitetName = Player.GetNameEx(hiter)
    setplaydef(actor, VarCfg["T_����_����_��¼�Է�ID"], hitetId)
    Player.buffTipsMsg(actor, "[����]:�㱻[{" .. hitetName .. "/FCOLOR=243}]��ɱ,�Ը�����˺�����30%!")
end

--��������������ʧ
TianMingBuff[16005] = function(actor, hiter)
    delattlist(actor, "��������")
end
--������������
TianMingBuff[16006] = function(actor, hiter)
    local times = os.time()
end

return TianMingBuff

local ZhuangBeiBuffList = {}
local cfg_IsBoss = include("QuestDiary/cfgcsv/cfg_IsBoss.lua") --boss�б�
local cfg_BuBeiQieGeMon = include("QuestDiary/cfgcsv/cfg_BuBeiQieGeMon.lua")
local cfg_ShenLongDiGuo = include("QuestDiary/cfgcsv/cfg_ShenLongDiGuo_data.lua")

--ȫ������������1000��ͷ��
--��������[��Ѫ]--����Ŀ��ʱÿ���ָ�[100]������ֵ
ZhuangBeiBuffList[1000] = function(actor, Target, Hiter, MagicId)
    local currHpPer = Player.getHpPercentage(actor)
    if currHpPer <= 3 or currHpPer == 100 then return end
    humanhp(actor, "+", 100)
end

--���ℇ[�ۺ�֮��]--����Ŀ��ʱÿ���ָ�[300]������ֵ
ZhuangBeiBuffList[1001] = function(actor, Target, Hiter, MagicId)
    local currHpPer = Player.getHpPercentage(actor)
    if currHpPer <= 3 or currHpPer == 100 then return end
    humanhp(actor, "+", 300)
end
-- ���֮ŭ����� ����Ŀ��ʱ������ȡĿ������ֵ ����ʱ�и��ʽ�����ŭ״̬�������������ұ����˺�+20%������6S.
ZhuangBeiBuffList[1002] = function(actor, Target, Hiter, MagicId)
    if randomex(3) then
        if Player.checkCd(actor, VarCfg["���֮ŭCD"], 30, true) then
            changehumnewvalue(actor, 21, 100, 6)
            changehumnewvalue(actor, 22, 20, 6)
        end
    end
    if Player.canLifesteal(actor) then
        humanhp(actor, "+", 300)
    end
end
--�����ĳ��׵�׹ �Ե͵ȼ���Ŀ��ʩ��(�һ�)��(����) ��(����)ʱ�и��ʴ�������Ŀ��[1S] ����1 1/10
ZhuangBeiBuffList[1003] = function(actor, Target, Hiter, MagicId)
    if MagicId == 26 or MagicId == 66 or MagicId == 56 then
        if randomex(1, 10) then
            local myLeve = getbaseinfo(actor, ConstCfg.gbase.level)
            local targetLeve = getbaseinfo(Target, ConstCfg.gbase.level)
            if targetLeve < myLeve then
                local x, y = getbaseinfo(Target, ConstCfg.gbase.x), getbaseinfo(Target, ConstCfg.gbase.y)
                rangeharm(actor, x, y, 0, 0, 2, 1, 1, 0, 20500) -- ����1*1��Χ�ڵ���1��
                playsound(actor, 100001, 1, 0)                  --���ű�����Ч
                local myName = Player.GetNameEx(actor)
                local targetName = Player.GetNameEx(Target)
                Player.buffTipsMsg(actor, "[���ĳ��׵�׹]:�������Ŀ��[{" .. targetName .. "/FCOLOR=243}],����1S...")
                Player.buffTipsMsg(Target, "[���ĳ��׵�׹]:�㱻[{" .. myName .. "/FCOLOR=243}]������,����1S...")
            end
        end
    end
end
--�������� �����и������[����*333%]���˺� �ɹ�����1/128
ZhuangBeiBuffList[1004] = function(actor, Target, Hiter, MagicId)
    if randomex(1, 128) then
        local mydcmax = getbaseinfo(actor, ConstCfg.gbase.dc2)
        local tgtdechp = mydcmax * 3.33
        humanhp(Target, "-", tgtdechp, 1, 0, actor)
        Player.buffTipsMsg(actor, "[��������]:����˹���[{" .. tgtdechp .. "/FCOLOR=243}]��ʵ�˺�...")
    end
end
-- ���ƿ��׵硹 ����ʱ�и��ʿ��ٻ����׶�Ŀ�����[8��]��������һ�����20%�˺�������ÿ����������30%�˺�![CD��60��] 1/88����
ZhuangBeiBuffList[1005] = function(actor, Target, Hiter, MagicId)
    if getbaseinfo(Target, -1) == false then
        return
    end
    if randomex(1, 88) then
        local buffcd = hasbuff(actor, 30011)
        if not buffcd then
            addbuff(Target, 30081) --���Է���Ӱ�����buff
            setplaydef(Target, VarCfg["N$�׵������"], 0) --���Է���ֵΪ0
            addbuff(actor, 30011, 60, 1, actor)
        end
    end
end
-- ��� ʩ�ż���ʱ�и��ʴ���˫��ʩ��Ч�� �ü��ܶ������ͷ�һ��[CD60��]
ZhuangBeiBuffList[1006] = function(actor, Target, Hiter, MagicId)
    local buffcd = hasbuff(actor, 30015)
    if not buffcd then
        if MagicId == 26 or MagicId == 66 or MagicId == 56 then
            releasemagic(actor, MagicId, 1, 3, 1, 1)
            addbuff(actor, 30015, 60, 1, actor)
            local skillname = getskillname(MagicId)
            Player.buffTipsMsg(actor, "[���]:����˫��ʩ��Ч��,����[{" .. skillname .. "/FCOLOR=243}]���ͷ�һ��...")
        end
    end
end
-- ��ڤ֮�� ʩ�ż���ʱ�и��ʴ���˫��ʩ��Ч���ü��ܶ������ͷ�һ��[CD60��]
ZhuangBeiBuffList[1007] = function(actor, Target, Hiter, MagicId)
    if randomex(1, 128) then
        if MagicId == 26 or MagicId == 66 or MagicId == 56 then
            releasemagic(actor, MagicId, 1, 3, 1, 1)
            local skillname = getskillname(MagicId)
            Player.buffTipsMsg(actor, "[��ڤ֮��]:����˫��ʩ��Ч��,����[{" .. skillname .. "/FCOLOR=243}]���ͷ�һ��...")
        end
    end
end
-- ��������  ʩ���һ�ʱ�и��ʴ���˫��ʩ��Ч�� �ü��ܶ������ͷ�һ��[CD60��]
ZhuangBeiBuffList[1008] = function(actor, Target, Hiter, MagicId)
    local buffcd = hasbuff(actor, 30024)
    if not buffcd then
        if MagicId == 26 then
            releasemagic(actor, MagicId, 1, 3, 1, 1)
            addbuff(actor, 30024, 60, 1, actor)
            local skillname = getskillname(MagicId)
            Player.buffTipsMsg(actor, "[��������]:����˫��ʩ��Ч��,����[{" .. skillname .. "/FCOLOR=243}]���ͷ�һ��...")
        end
    end
end
-- ��ľ֮ͫ ����ʱ�и���ǿ�����Ŀ��[1]�� 1/128
ZhuangBeiBuffList[1009] = function(actor, Target, Hiter, MagicId)
    if randomex(1, 128) then
        local x, y = getbaseinfo(Target, ConstCfg.gbase.x), getbaseinfo(Target, ConstCfg.gbase.y)
        rangeharm(actor, x, y, 0, 0, 3, 1, 0, 0, nil, 1) -- ���Ŀ��[1]��
        local myName = Player.GetNameEx(actor)
        local targetName = Player.GetNameEx(Target)
        Player.buffTipsMsg(actor, "[��ľ֮ͫ]:�㽫[{" .. targetName .. "/FCOLOR=243}]���[{1��/FCOLOR=243}]...")
        Player.buffTipsMsg(Target, "[��ľ֮ͫ]:�㱻[{" .. myName .. "/FCOLOR=243}]���[{1��/FCOLOR=243}]...")
    end
end

-- Ѫħ����MAX ʩ���һ𽣷����ʱ���Ŀ��[1-3]��
ZhuangBeiBuffList[1011] = function(actor, Target, Hiter, MagicId)
    if MagicId == 26 then
        if randomex(1, 128) then
            local x, y = getbaseinfo(Target, ConstCfg.gbase.x), getbaseinfo(Target, ConstCfg.gbase.y)
            local itemnum = math.random(1, 3)
            rangeharm(actor, x, y, 0, 0, 2, itemnum, 0, 0, 20500, 1) -- ��������1��
            playsound(actor, 100001, 1, 0)                           --���ű�����Ч
            local myName = Player.GetNameEx(actor)
            local targetName = Player.GetNameEx(Target)
            Player.buffTipsMsg(actor,
                "[Ѫħ����MAX]:�㽫[{" .. targetName .. "/FCOLOR=243}]����[{" .. itemnum .. "��/FCOLOR=243}]...")
            Player.buffTipsMsg(Target,
                "[Ѫħ����MAX]:�㱻[{" .. myName .. "/FCOLOR=243}]����[{" .. itemnum .. "��/FCOLOR=243}]...")
        end
    end
end
-- ʴ�¾�  ʩ��Ұ����ײʱ�ɽ�Ŀ��ײ��̱��2��..
ZhuangBeiBuffList[1012] = function(actor, Target, Hiter, MagicId)
    if MagicId == 27 then
        changemode(Target, 11, 2)
        local myName = Player.GetNameEx(actor)
        local targetName = Player.GetNameEx(Target)
        Player.buffTipsMsg(actor, "[ʴ�¾�]:�ͷ�Ұ����ײʹ{" .. targetName .. "/FCOLOR=243}����̱��״̬{2/FCOLOR=243}��...")
        Player.buffTipsMsg(Target, "[Ѫħ����MAX]:{" .. myName .. "/FCOLOR=243}�ͷ�Ұ����ײʹ�����̱��״̬{2/FCOLOR=243}��...")
    end
end
--ʧ��ռ� ��������븴��CD�󴥷�����ʱ�����ָ�(2%)���������ֵ10��  CD��120��
ZhuangBeiBuffList[1013] = function(actor, Target, Hiter, MagicId)
    if ReliveMain.GetReliveState(actor) then return end -- ������
    local buff1 = hasbuff(actor, 30053)                 --��ʱbuff  120��
    local buff2 = hasbuff(actor, 30052)                 --״̬buff  10��
    if not buff1 then
        addbuff(actor, 30052, 10, 1, actor)
        addbuff(actor, 30053, 120, 1, actor)
        Player.buffTipsMsg(actor, "[ʧ��ռ�]:������Ѫ{2%/FCOLOR=243}���Ѫ������{10/FCOLOR=243}��...")
    end
    if not buff2 then
        if Player.canLifesteal(actor) then
            humanhp(actor, "+", Player.getHpValue(actor, 2), 4) --������Ѫ2%
        end
    end
end

--����֮�� �������ý���[������]״̬����ʱ�и�����ɱ���[1]���Ч�� 1/188����
ZhuangBeiBuffList[1014] = function(actor, Target, Hiter, MagicId)
    if randomex(1, 188) then
        local x, y = getbaseinfo(Target, ConstCfg.gbase.x), getbaseinfo(Target, ConstCfg.gbase.y)
        rangeharm(actor, x, y, 0, 0, 2, 1, 1, 0, 20500) -- ����1*1��Χ�ڵ���1��
        playsound(actor, 100001, 1, 0)                  --���ű�����Ч
        local myName = Player.GetNameEx(actor)
        local targetName = Player.GetNameEx(Target)
        Player.buffTipsMsg(actor, "[����֮��]:�������Ŀ��[{" .. targetName .. "/FCOLOR=243}],����1S...")
        Player.buffTipsMsg(Target, "[����֮��]:�㱻[{" .. myName .. "/FCOLOR=243}]������,����1S...")
    end
end

-- �����ݶ� ����ʱ�и��ʱ���Ŀ��[1]��(CD15S) �����������߱���Ч�� 1/88
ZhuangBeiBuffList[1015] = function(actor, Target, Hiter, MagicId)
    if randomex(1, 88) then
        local x, y = getbaseinfo(Target, ConstCfg.gbase.x), getbaseinfo(Target, ConstCfg.gbase.y)
        rangeharm(actor, x, y, 0, 0, 2, 1, 0, 0, 20500, 1) -- ���ʱ���Ŀ��[1]��
        playsound(actor, 100001, 1, 0)                     --���ű�����Ч
    end
end
-- ������ѹ������ʱ�и��ʽ�������״̬������10S������״̬���������ǵĹ���Ч��������CD:30S����
-- �����۹���ݵ����ָ�����1.5%���������
-- ����������ݵ����и�Ŀ��1.5%���������
ZhuangBeiBuffList[1016] = function(actor, Target, Hiter, MagicId)
    if randomex(1, 300) then
        if not hasbuff(actor, 31034) then
            addbuff(actor, 31034, 30)
            addbuff(actor, 31035, 10)
        end
    end
    if getbaseinfo(Target, -1) == false then --��������
        local basePer = 1.5
        if hasbuff(actor, 31035) then
            basePer = basePer * 2
        end
        --�Ƿ������Ѫ����
        if Player.canLifesteal(actor) then
            local hpPer = Player.getHpValue(actor, basePer)
            humanhp(actor, "+", hpPer, 4)
        end
    else --������
        local basePer = 1.5
        if hasbuff(actor, 31035) then
            basePer = basePer * 2
        end
        local hpPer = Player.getHpValue(Target, basePer)
        humanhp(Target, "-", hpPer, 1, 0, actor)
    end
end

-- ħ��֮צ   �ͷ��һ�� 1/88 �ָ�����
ZhuangBeiBuffList[1017] = function(actor, Target, Hiter, MagicId)
    if MagicId ~= 26 then return end
    if randomex(1, 88) then
        humanhp(actor, "+", Player.getHpValue(actor, 10), 4) --�Լ���Ѫ10%
    end
end

-- ������   1/128����Ϊ��ƽģʽ
ZhuangBeiBuffList[1018] = function(actor, Target, Hiter, MagicId)
    if randomex(1, 128) then
        changeattackmode(actor, 1)
    end
end

-- ��������� ����ʱ����ʹ�������������������һ��  ����5��-��ȴ30��  
ZhuangBeiBuffList[1019] = function(actor, Target, Hiter, MagicId)
    local buffCD = hasbuff(actor, 31084)
    if buffCD then return end
    if randomex(1, 1) then
        addbuff(actor, 31084, 30)
        addbuff(actor, 31085, 5)
        Player.setAttList(actor, "��������")
        Player.buffTipsMsg(actor, "[���������]:��������{50%/FCOLOR=243}����{5��/FCOLOR=243}...")
    end
end



--�����˴�����2000��ͷ��
-- ��ҹǱ����    �����ڲ����õ��������(3%)�ĸ���նɱĿ������[99%]���������ֵ   1/128 random
ZhuangBeiBuffList[2000] = function(actor, Target, Hiter, MagicId)
    if ReliveMain.GetReliveState(actor) then return end          -- ������
    if randomex(1, 128) then
        humanhp(Target, "-", Player.getHpValue(Target, 99), 106) --�۳�99%Ѫ��
        local myName = Player.GetNameEx(actor)
        local targetName = Player.GetNameEx(Target)
        Player.buffTipsMsg(actor, "[��ҹǱ����]:նɱ��[{" .. targetName .. "/FCOLOR=243}]99%���Ѫ��...")
        Player.buffTipsMsg(Target, "[��ҹǱ����]:�㱻[{" .. myName .. "/FCOLOR=243}]նɱ99%���Ѫ��...")
    end
end

-- Դ�����    PKʱ�и��ʶ�Ŀ����ɽ���(2����)   1/108 random
ZhuangBeiBuffList[2001] = function(actor, Target, Hiter, MagicId)
    if randomex(1, 108) then
        changemode(Target, 11, 2, 1, 2)
    end
end

-- Զ�ŵ�׹    �һ𽣷���նɱĿ��[10%]������ֵ
ZhuangBeiBuffList[2002] = function(actor, Target, Hiter, MagicId)
    if MagicId == 26 then
        humanhp(Target, "-", Player.getHpValue(Target, 10), 106, 0, actor) --�۳�10%Ѫ��
        local myName = Player.GetNameEx(actor)
        local targetName = Player.GetNameEx(Target)
        Player.buffTipsMsg(actor, "[Զ�ŵ�׹]:�ͷ��һ𽣷�,նɱ��[{" .. targetName .. "/FCOLOR=243}]10%���Ѫ��...")
        Player.buffTipsMsg(Target, "[Զ�ŵ�׹]:[{" .. myName .. "/FCOLOR=243}]�Է��ͷ��һ𽣷�,�㱻նɱ10%���Ѫ��...")
    end
end
-- ���˳�    ����ʱ�и���ж��Ŀ��[1��]װ�����ص��������棡 1/128
ZhuangBeiBuffList[2003] = function(actor, Target, Hiter, MagicId)
    if randomex(1, 158) then
        local itemnum = math.random(0, 11)
        local itemobj = linkbodyitem(Target, itemnum)
        if itemobj ~= "0" then
            local itemname = getiteminfo(Target, itemobj, 7)
            local itemidx = getiteminfo(Target, itemobj, 1)
            takeoffitem(Target, itemnum, itemidx)
            local myName = Player.GetNameEx(actor)
            local targetName = Player.GetNameEx(Target)
            Player.buffTipsMsg(actor,
                "[���˳�]:�㽫[{" .. targetName .. "/FCOLOR=243}]��[{" .. itemname .. "/FCOLOR=243}]��ر���...")
            Player.buffTipsMsg(Target, "[���˳�]:�㱻[{" .. myName .. "/FCOLOR=243}]��[{" .. itemname .. "/FCOLOR=243}]��ر���...")
        end
    end
end
-- ǧ���   �����и��ʴ��Ŀ�걳����[����ʯ]  1/128
ZhuangBeiBuffList[2004] = function(actor, Target, Hiter, MagicId)
    if randomex(1, 158) then
        local num1 = getbagitemcount(Target, "���Ǵ���ʯ", 0)
        local num2 = getbagitemcount(Target, "�������ʯ", 0)
        if num1 >= 1 then
            takeitem(Target, "���Ǵ���ʯ", num1, 0, "ǧ���buff�۳�")
        end
        if num2 >= 1 then
            takeitem(Target, "�������ʯ", num2, 0, "ǧ���buff�۳�")
        end
        local myName = Player.GetNameEx(actor)
        local targetName = Player.GetNameEx(Target)
        Player.buffTipsMsg(actor, "[ǧ���]:�㽫[{" .. targetName .. "/FCOLOR=243}]��[{���͵���/FCOLOR=243}]����ʧ��...")
        Player.buffTipsMsg(Target, "[ǧ���]:[{" .. myName .. "/FCOLOR=243}]�����[{���͵���/FCOLOR=243}]����ʧ��...")
    end
end
-- ���Կ־�   ����������ֵ����(50%)�����Ｄ����и�[99999]������ֵ��
ZhuangBeiBuffList[2005] = function(actor, Target, Hiter, MagicId)
    local calculate = Player.getHpPercentage(Target)
    if calculate > 50 then
        humanhp(Target, "-", 99999, 106, 0, actor) --����նѪ
    end
end
-- ��������׹   ������Ѫ����ֱ��նɱ(30%)����ֵ(60����ֻ������һ�ε�ǰBUFF)
ZhuangBeiBuffList[2006] = function(actor, Target, Hiter, MagicId)
    local buffcd = hasbuff(actor, 30019)
    if not buffcd then
        local calculate = Player.getHpPercentage(Target)
        if calculate > 99 then
            humanhp(Target, "-", Player.getHpValue(Target, 30), 106, 0, actor) --����նѪ
            addbuff(actor, 30019, 60, 1, actor)
            local targetName = Player.GetNameEx(Target)
            Player.buffTipsMsg(actor, "[��������׹]:նɱ[{" .. targetName .. "/FCOLOR=243}]��[{30%/FCOLOR=243}]Ѫ��...")
        end
    end
end
-- ҹħ֮��   ���������е�Ŀ��ÿ������Ѫ[1%] ��Ѫ����60S
ZhuangBeiBuffList[2007] = function(actor, Target, Hiter, MagicId)
    if randomex(1, 188) then
        addbuff(Target, 30022, 5, 1, actor)
        local targetName = Player.GetNameEx(Target)
        Player.buffTipsMsg(actor,
            "[ҹħ֮��]:ʹ[{" .. targetName .. "/FCOLOR=243}]��{����/FCOLOR=243}����,ÿ���Ѫ{1%/FCOLOR=243}����{5/FCOLOR=243}��...")
    end
end
-- ҹ����ߡ���    ����ʱ�и���ж��Ŀ��[1��]װ�����ص��������棡 1/228
ZhuangBeiBuffList[2009] = function(actor, Target, Hiter, MagicId)
    if randomex(1, 228) then
        if Player.checkCd(actor, VarCfg["ҹ�����CD"], 30, true) then
            local itemnum = math.random(0, 11)
            local itemobj = linkbodyitem(Target, itemnum)
            if itemobj ~= "0" then
                local itemname = getiteminfo(Target, itemobj, 7)
                local itemidx = getiteminfo(Target, itemobj, 1)
                takeoffitem(actor, itemnum, itemidx)
                local myName = Player.GetNameEx(actor)
                local targetName = Player.GetNameEx(Target)
                Player.buffTipsMsg(actor,
                    "[ҹ����ߡ���]:�㽫[{" .. targetName .. "/FCOLOR=243}]��[{" .. itemname .. "/FCOLOR=243}]��ر���...")
                Player.buffTipsMsg(Target,
                    "[ҹ����ߡ���]:�㱻[{" .. myName .. "/FCOLOR=243}]��[{" .. itemname .. "/FCOLOR=243}]��ر���...")
            end
        end
    end
end
-- �����ǧ�á�    �����ڲ����õ��������(3%)�ĸ���նɱĿ������[99%]���������ֵ   1/128 random [CD300��]
ZhuangBeiBuffList[2009] = function(actor, Target, Hiter, MagicId)
    if ReliveMain.GetReliveState(actor) then return end -- ������

    if randomex(1, 128) then
        if Player.checkCd(actor, VarCfg["�����ǧ�á�CD"], 300, true) then
            humanhp(Target, "-", Player.getHpValue(Target, 99), 106, 0, actor) --�۳�99%Ѫ��
            playeffect(Target, 16020, 0, 0, 1, 0, 0)
            local targetName = Player.GetNameEx(Target)
            Player.buffTipsMsg(actor, "[�����ǧ�á�]:նɱ[{" .. targetName .. "/FCOLOR=243}]��[{99%/FCOLOR=243}]Ѫ��...")
        end
    end
end
-- ������һȭ �и��ʽ�Ŀ��������   1/228 random [CD180��]
ZhuangBeiBuffList[2010] = function(actor, Target, Hiter, MagicId)
    if randomex(1, 228) then
        local buffcd = hasbuff(actor, 30033)
        if Player.checkCd(actor, VarCfg["������һȭCD"], 180, true) then
            mapmove(Target, "n3", 330, 330, 5)
            local myName = Player.GetNameEx(actor)
            local targetName = Player.GetNameEx(Target)
            Player.buffTipsMsg(actor, "[������һȭ]:�㽫[{" .. targetName .. "/FCOLOR=243}]���[{����֮��/FCOLOR=243}]...")
            Player.buffTipsMsg(Target, "[������һȭ]:�㱻[{" .. myName .. "/FCOLOR=243}]���[{����֮��/FCOLOR=243}]...")
        end
    end
end
-- ��ħ������� �����и��ʴ��Ŀ��[66%]������ֵ�ָ�����[66%]������ֵ(��PK����)   1/68 random [CD60��]
ZhuangBeiBuffList[2011] = function(actor, Target, Hiter, MagicId)
    if randomex(1, 68) then
        humanhp(Target, "-", Player.getHpValue(Target, 66), 1, 0, actor) --Ŀ���Ѫ66%
        humanhp(actor, "+", Player.getHpValue(actor, 66), 4)             --�Լ���Ѫ66%
        local myName = Player.GetNameEx(actor)
        local targetName = Player.GetNameEx(Target)
        Player.buffTipsMsg(actor,
            "[��ħ�������]:��նɱ��[{" .. targetName .. "/FCOLOR=243}]{66%/FCOLOR=243}�����Ѫ�����ָ��Լ�{66%/FCOLOR=243}Ѫ��...")
        Player.buffTipsMsg(Target, "[��ħ�������]:�㱻[{" .. myName .. "/FCOLOR=243}]նɱ{66%/FCOLOR=243}�����Ѫ��...")
    end
end
--˺�������  PKʱ ÿ�˵�նɱĿ���������ֵ10%
ZhuangBeiBuffList[2012] = function(actor, Target, Hiter, MagicId)
    local daoshunum = getplaydef(actor, VarCfg["N$_˺�������"])
    if daoshunum >= 8 then
        humanhp(Target, "-", Player.getHpValue(Target, 10), 106, 0, actor)
        setplaydef(actor, VarCfg["N$_˺�������"], 0) --��������
        local myName = Player.GetNameEx(actor)
        Player.buffTipsMsg(Target, "[˺�������]:նɱ[{" .. myName .. "/FCOLOR=243}]{10%/FCOLOR=243}���Ѫ��...")
    else
        setplaydef(actor, VarCfg["N$_˺�������"], daoshunum + 1) --������1
    end
end
--Ѫɫ֮�� �и���ʹ�Է��������10�� 1/128����
ZhuangBeiBuffList[2013] = function(actor, Target, Hiter, MagicId)
    if randomex(1, 128) then
        local _ac   = getbaseinfo(Target, ConstCfg.gbase.ac)
        local _ac2  = getbaseinfo(Target, ConstCfg.gbase.ac2)
        local _mac  = getbaseinfo(Target, ConstCfg.gbase.mac)
        local _mac2 = getbaseinfo(Target, ConstCfg.gbase.mac2)
        changehumability(Target, 1, -_ac, 10)
        changehumability(Target, 2, -_ac2, 10)
        changehumability(Target, 3, -_mac, 10)
        changehumability(Target, 4, -_mac2, 10)

        local myName = Player.GetNameEx(actor)
        local targetName = Player.GetNameEx(Target)
        Player.buffTipsMsg(actor, "[1]:�����[{" .. targetName .. "/FCOLOR=243}]�ķ���{10/FCOLOR=243}��...")
        Player.buffTipsMsg(Target, "[Ѫɫ֮��]:�㱻[{" .. myName .. "/FCOLOR=243}]��շ���{10/FCOLOR=243}��...")
    end
end
--���ն�֮�� ����ʱ�и��ʻָ�ȫ������ 1/128
ZhuangBeiBuffList[2014] = function(actor, Target, Hiter, MagicId)
    if randomex(1, 128) then
        humanhp(actor, "=", Player.getHpValue(actor, 100), 4)
        Player.buffTipsMsg(actor, "[���ն�֮��]:�ָ�[{100%/FCOLOR=243}]������...")
    end
end
--�ߵ�����֮�� PKʱ�и��ʽ�Ŀ�������������� 1/128 ����
ZhuangBeiBuffList[2015] = function(actor, Target, Hiter, MagicId)
    if randomex(1, 128) then
        local buffcd = hasbuff(actor, 30040)
        if not buffcd then
            local itemobj = linkbodyitem(Target, 1)
            local itemidx = getiteminfo(Target, itemobj, 1)
            takeoffitem(Target, 1, itemidx)
            addbuff(actor, 30040, 30, 1, actor)
            local myName = Player.GetNameEx(actor)
            local targetName = Player.GetNameEx(Target)
            local itemname = getiteminfo(Target, itemobj, 1)
            Player.buffTipsMsg(actor,
                "[���˳�]:�㽫[{" .. targetName .. "/FCOLOR=243}]��[{" .. itemname .. "/FCOLOR=243}]��ر���...")
            Player.buffTipsMsg(Target, "[���˳�]:�㱻[{" .. myName .. "/FCOLOR=243}]��[{" .. itemname .. "/FCOLOR=243}]��ر���...")
        end
    end
end
--�ڰ��޽� �һ𽣷���նɱ Ŀ��10%����ֵ
ZhuangBeiBuffList[2016] = function(actor, Target, Hiter, MagicId)
    if MagicId == 26 then
        humanhp(Target, "-", Player.getHpValue(Target, 10), 106, 0, actor) --նɱ10%����
        local targetName = Player.GetNameEx(Target)
        Player.buffTipsMsg(actor, "[�ڰ��޽�]:նɱ[{" .. targetName .. "/FCOLOR=243}]{10%/FCOLOR=243}��Ѫ��...")
    end
end
--��Ӱɱ��� PKʱ�и���ʹ�Է�����
ZhuangBeiBuffList[2017] = function(actor, Target, Hiter, MagicId)
    if randomex(1, 128) then
        local pkvalue = getbaseinfo(Target, ConstCfg.gbase.pkvalue)
        setbaseinfo(Target, ConstCfg.sbase.pkvalue, pkvalue + 1000)
        addbuff(Target, 30043, 5, 1, actor)
    end
end
--׷���� �����и��ʴ��Ŀ��[50%]������ֵ�ָ�����[20%]������ֵ(��PK����) 1/158
ZhuangBeiBuffList[2018] = function(actor, Target, Hiter, MagicId)
    if randomex(1, 158) then
        humanhp(Target, "-", Player.getHpValue(Target, 50), 106, 0, actor) --����նѪ
        humanhp(actor, "+", Player.getHpValue(actor, 20), 4)               --����նѪ
        local targetName = Player.GetNameEx(Target)
        Player.buffTipsMsg(actor,
            "[׷����]:�㽫[{" .. targetName .. "/FCOLOR=243}]��Ѫ�����{50%/FCOLOR=243}���ָ�����{20%/FCOLOR=243}Ѫ��...")
    end
end
--�������ӡ ����ʱ�и��ʽ�Ŀ��[�·�]���뱳�� 1/158 ����
ZhuangBeiBuffList[2019] = function(actor, Target, Hiter, MagicId)
    if randomex(1, 158) then
        local itemobj = linkbodyitem(Target, 0)
        local itemidx = getiteminfo(Target, itemobj, 1)
        takeoffitem(Target, 0, itemidx)
        local myName = Player.GetNameEx(actor)
        local targetName = Player.GetNameEx(Target)
        local itemname = getiteminfo(Target, itemobj, 0)
        Player.buffTipsMsg(actor,
            "[�������ӡ]:�㽫[{" .. targetName .. "/FCOLOR=243}]��[{" .. itemname .. "/FCOLOR=243}]��ر���...")
        Player.buffTipsMsg(Target, "[�������ӡ]:�㱻[{" .. myName .. "/FCOLOR=243}]��[{" .. itemname .. "/FCOLOR=243}]��ر���...")
    end
end
--�������� �����︴�����������״̬2�� �´ι�����նɱ����15%������ֵ
ZhuangBeiBuffList[2020] = function(actor, Target, Hiter, MagicId)
    if getplaydef(actor, VarCfg["S$_��������"]) == "1" then
        humanhp(Target, "-", Player.getHpValue(Target, 15), 106, 0, actor) --����նѪ
        setplaydef(actor, VarCfg["S$_��������"], "")
    end
end
--�������� ��������ʱ�и���ʹĿ������[10��]���������е�Ŀ��ÿ������Ѫ[2%] 1/128
ZhuangBeiBuffList[2021] = function(actor, Target, Hiter, MagicId)
    if randomex(1, 128) then
        local tgtbuff = hasbuff(Target, 30045)
        if not tgtbuff then
            addbuff(Target, 30045, 10, 1, actor)
            local myName = Player.GetNameEx(actor)
            local targetName = Player.GetNameEx(Target)
            Player.buffTipsMsg(actor,
                "[��������]:ʹ{" .. targetName .. "/FCOLOR=243}����{����/FCOLOR=243}״̬,ÿ������{2%/FCOLOR=243}��������{10/FCOLOR=243}��...")
            Player.buffTipsMsg(Target,
                "[��������]:{" .. myName .. "/FCOLOR=243}]ʹ�����{����/FCOLOR=243}״̬,ÿ������{2%/FCOLOR=243}��������{10/FCOLOR=243}��...")
        end
    end
end
--ǧɽ��  1/128���ʽ��Է��������3��
ZhuangBeiBuffList[2022] = function(actor, Target, Hiter, MagicId)
    if randomex(1, 128) then
        addbuff(Target, 30046, 3, 1, actor)
        Player.setAttList(Target, "��������")

        local myName = Player.GetNameEx(actor)
        local targetName = Player.GetNameEx(Target)
        Player.buffTipsMsg(actor, "[ǧɽ��]:ʹ{" .. targetName .. "/FCOLOR=243}����{�������/FCOLOR=243}״̬,����{3/FCOLOR=243}��...")
        Player.buffTipsMsg(Target, "[ǧɽ��]:{" .. myName .. "/FCOLOR=243}]ʹ�����{�������/FCOLOR=243}״̬,����{3/FCOLOR=243}��...")
    end
end
--������С� ����ʱ�и��ʶ�Ŀ�����̱��[1��] ���һָ�����(30%)���������ֵ��
ZhuangBeiBuffList[2023] = function(actor, Target, Hiter, MagicId)
    if randomex(1, 128) then
        humanhp(actor, "+", Player.getHpValue(actor, 30), 4) --����նѪ
        local x, y = getbaseinfo(Target, ConstCfg.gbase.x), getbaseinfo(Target, ConstCfg.gbase.y)
        rangeharm(actor, x, y, 0, 0, 10, 1000, 0, 0)         -- ����1��
        local targetName = Player.GetNameEx(Target)
        Player.buffTipsMsg(actor,
            "[������С�]:ʹ{" .. targetName .. "/FCOLOR=243}̱��{1��/FCOLOR=243}���ָ�����{30%/FCOLOR=243}�������ֵ...")
    end
end
-- ��Ԩ�����¡��    ����ʱ�и���ж��Ŀ��[1��]װ�����ص��������棡 1/128
ZhuangBeiBuffList[2024] = function(actor, Target, Hiter, MagicId)
    if randomex(1, 128) then
        local itemnum = math.random(0, 11)
        local itemobj = linkbodyitem(Target, itemnum)
        if itemobj ~= "0" then
            local itemname = getiteminfo(Target, itemobj, 7)
            local itemidx = getiteminfo(Target, itemobj, 1)
            takeoffitem(Target, itemnum, itemidx)
            local myName = Player.GetNameEx(actor)
            local targetName = Player.GetNameEx(Target)
            Player.buffTipsMsg(actor,
                "[��Ԩ�����¡��]:�㽫[{" .. targetName .. "/FCOLOR=243}]��[{" .. itemname .. "/FCOLOR=243}]��ر���...")
            Player.buffTipsMsg(Target,
                "[��Ԩ�����¡��]:�㱻[{" .. myName .. "/FCOLOR=243}]��[{" .. itemname .. "/FCOLOR=243}]��ر���...")
        end
    end
end
-- ����ᾧ  ����ʱ�и��ʶ�Ŀ����ɽ���[3��]��������������[30%](����3��) 1/138
ZhuangBeiBuffList[2025] = function(actor, Target, Hiter, MagicId)
    if randomex(1, 138) then
        changemode(Target, 11, 3, 1, 2) --������Χ3 ����ʱ��5��
        addbuff(actor, 30046, 3, 1, actor)
        local myName = Player.GetNameEx(actor)
        local targetName = Player.GetNameEx(Target)
        Player.buffTipsMsg(actor,
            "[����ᾧ]:�㽫{" .. targetName .. "/FCOLOR=243}����{3��/FCOLOR=243}�����ӹ�����{30%/FCOLOR=243}����{3��/FCOLOR=243}...")
        Player.buffTipsMsg(Target, "[����ᾧ]:�㱻[{" .. myName .. "/FCOLOR=243}]����{3��/FCOLOR=243}...")
    end
end
-- ���� �����и��ʴ��Ŀ��[30%]������ֵ�������[10%]������ֵ(��PK����) 1/158����
ZhuangBeiBuffList[2026] = function(actor, Target, Hiter, MagicId)
    if randomex(1, 158) then
        humanhp(Target, "-", Player.getHpValue(Target, 30), 1, 0, actor) --���Ŀ��[30%]
        humanhp(actor, "-", Player.getHpValue(actor, 10), 1, 0, Target)  --�������[10%]
        local targetName = Player.GetNameEx(Target)
        Player.buffTipsMsg(actor,
            "[����]: ��{" .. targetName .. "/FCOLOR=243}��Ѫ��նɱ{30%/FCOLOR=243}���Լ���Ѫ������{10%/FCOLOR=243}...")
    end
end
-- ����֮�� ����ʱ�и������Ŀ�����еķ�����10��   ����նɱĿ��[10%]���������ֵ��1/108 ����
ZhuangBeiBuffList[2027] = function(actor, Target, Hiter, MagicId)
    if randomex(1, 108) then
        local _ac   = getbaseinfo(Target, ConstCfg.gbase.ac)
        local _ac2  = getbaseinfo(Target, ConstCfg.gbase.ac2)
        local _mac  = getbaseinfo(Target, ConstCfg.gbase.mac)
        local _mac2 = getbaseinfo(Target, ConstCfg.gbase.mac2)
        changehumability(Target, 1, -_ac, 10)
        changehumability(Target, 2, -_ac2, 10)
        changehumability(Target, 3, -_mac, 10)
        changehumability(Target, 4, -_mac2, 10)
        humanhp(Target, "-", Player.getHpValue(Target, 10), 1, 0, actor) --�������[10%]

        local myName = Player.GetNameEx(actor)
        local targetName = Player.GetNameEx(Target)
        Player.buffTipsMsg(actor,
            "[����֮��]:ʹ{" .. targetName .. "/FCOLOR=243}����{�������/FCOLOR=243}״̬������նɱ{10%/FCOLOR=243}���Ѫ��...")
        Player.buffTipsMsg(Target,
            "[����֮��]:{" .. myName .. "/FCOLOR=243}]ʹ�����{�������/FCOLOR=243}״̬������նɱ{10%/FCOLOR=243}���Ѫ��...")
    end
end
-- ���ϴ��  �һ𽣷���նɱĿ��[20%]������ֵ
ZhuangBeiBuffList[2028] = function(actor, Target, Hiter, MagicId)
    if MagicId == 26 then
        humanhp(Target, "-", Player.getHpValue(Target, 20), 1, 0, actor)
        local targetName = Player.GetNameEx(Target)
        Player.buffTipsMsg(actor, "[���ϴ��]:�ͷ��һ𽣷�նɱ{" .. targetName .. "/FCOLOR=243}{20%/FCOLOR=243}���Ѫ��...")
    end
end
-- ���˵���ת   ����ʱ�и����и�Ŀ��[10%-50%]������ֵ���һָ�����[15%-30%]��Ѫ����(BUFFЧ��ֻ��������Ч) 1/138 ����
ZhuangBeiBuffList[2029] = function(actor, Target, Hiter, MagicId)
    if randomex(1, 138) then
        local tgtnum = math.random(10, 50)
        local mynum  = math.random(15, 30)
        humanhp(Target, "-", Player.getHpValue(Target, tgtnum), 1, 0, actor)
        humanhp(actor, "+", Player.getHpValue(actor, mynum), 4)

        local targetName = Player.GetNameEx(Target)
        Player.buffTipsMsg(actor,
            "[���˵���ת]:նɱ{" ..
            targetName .. "/FCOLOR=243}{" .. tgtnum .. "%/FCOLOR=243}���Ѫ�����ָ�����{" .. mynum .. "%/FCOLOR=243}���Ѫ��...")
    end
end
-- ӵ���ڰ��� ����ʱ�и��ʽ�Ŀ�����[��ä2��] 1/128����
ZhuangBeiBuffList[2030] = function(actor, Target, Hiter, MagicId)
    if randomex(1, 128) then
        local x, y = getconst(Target, "<$SCREENWIDTH>") / 2 - 20, getconst(Target, "<$SCREENHEIGHT>") / 2 + 50
        screffects(Target, 10, 17527, x, y, 1, 2, 0)
    end
end
-- �ڰ�֮�� ����ʱ�и��ʴ���[�����ж�]ֱ��նɱĿ��[100%]���������ֵ�� 1/388 ����
ZhuangBeiBuffList[2031] = function(actor, Target, Hiter, MagicId)
    if randomex(1, 388) then
        humanhp(Target, "-", Player.getHpValue(Target, 100), 1, 0, actor)
        local myName = Player.GetNameEx(actor)
        local targetName = Player.GetNameEx(Target)
        Player.buffTipsMsg(actor, "[�ڰ�֮��]:նɱ��[{" .. targetName .. "/FCOLOR=243}]100%Ѫ��...")
        Player.buffTipsMsg(Target, "[�ڰ�֮��]:�㱻[{" .. myName .. "/FCOLOR=243}],նɱ100%Ѫ��...")
    end
end

-- ħ�塸���С� ����ʱ�и��ʴ���[�����ж�]ֱ��նɱĿ��[100%]���������ֵ�� 1/88 ����
ZhuangBeiBuffList[2032] = function(actor, Target, Hiter, MagicId)
    if randomex(1, 88) then
        humanhp(Target, "-", Player.getHpValue(Target, 10), 1, 0, actor)
        humanhp(actor, "+", Player.getHpValue(actor, 10), 4)
        local myName = Player.GetNameEx(actor)
        local targetName = Player.GetNameEx(Target)
        Player.buffTipsMsg(actor, "[ħ�塸���С�]:նɱ��[{" .. targetName .. "/FCOLOR=243}]10%���Ѫ�����ָ�����10%Ѫ��...")
        Player.buffTipsMsg(Target, "[ħ�塸���С�]:�㱻[{" .. myName .. "/FCOLOR=243}],նɱ10%���Ѫ��...")
    end
end

-- ħ�������� 1/128������ä2�� ��130��������Ч
ZhuangBeiBuffList[2033] = function(actor, Target, Hiter, MagicId)
    local TgtLevel = getbaseinfo(Target, ConstCfg.gbase.level)
    if TgtLevel > 130 then return end
    if randomex(1, 128) then
        local x, y = getconst(Target, "<$SCREENWIDTH>") / 2 - 20, getconst(Target, "<$SCREENHEIGHT>") / 2 + 50
        screffects(Target, 10, 17527, x, y, 1, 2, 0)
    end
end

-- �Ž��� ÿ�ι����۳�����3%�����MPֵ��������ͬ���˺� 20%MP֮�²�����
ZhuangBeiBuffList[2034] = function(actor, Target, Hiter, MagicId)
    local MyMp = Player.getMpPercentage(actor)
    if MyMp >= 20 then
        humanmp(actor, "-", Player.getMpValue(actor, 3))
        humanhp(Target, "-", Player.getHpValue(actor, 3), 106, 0, actor)
    end
end

-- ���꾻ƿ ������������и��� ����ƿ������5S��ÿ��۳�10%Ѫ����5����CD
ZhuangBeiBuffList[2035] = function(actor, Target, Hiter, MagicId)
    local markname = getplaydef(actor, VarCfg["S$_���꾻ƿ���"])
    if markname == "" then return end
    local tgtname = getbaseinfo(Target, ConstCfg.gbase.name)
    if tgtname ~= markname then return end
    local buff1
    hasbuff(actor, 31069)
    if buff1 then return end
    if randomex(2) then
        addbuff(actor, 31069, 300) --���������buff��ʱ  300s
        local oldMapId = getbaseinfo(Target, ConstCfg.gbase.mapid)
        local targetName = Player.GetNameEx(Target)
        local newMapId = targetName .. "y"
        local x = getbaseinfo(Target, ConstCfg.gbase.x)
        local y = getbaseinfo(Target, ConstCfg.gbase.y)
        addmirrormap("db001", newMapId, "ƿ������" .. "(" .. targetName .. ")", 3, oldMapId, 0, x, y)
        local myName1 = Player.GetNameEx(actor)
        local targetName1 = Player.GetNameEx(Target)
        addbuff(Target, 31068, 5)
        Player.buffTipsMsg(actor, "[���꾻ƿ]:�㽫[{" .. targetName1 .. "/FCOLOR=243}]����ƿ������...")
        Player.buffTipsMsg(Target, "[���꾻ƿ]:�㱻[{" .. myName1 .. "/FCOLOR=243}]����ƿ������...")
        map(Target, newMapId)
    end
end

-- Ⱥ��֮ŭ���� �Թ���Ѫ5%(��װ���������)��1/128����ʹ�Է����� Ⱥ��֮ŭbuff 
ZhuangBeiBuffList[2036] = function(actor, Target, Hiter, MagicId)
    if randomex(1, 128) then
        local tgtbuff = hasbuff(Target, 31079)
        if tgtbuff then return  end
        addbuff(Target, 31079)
        local myName1 = Player.GetNameEx(actor)
        local targetName1 = Player.GetNameEx(Target)
        Player.buffTipsMsg(actor, "[Ⱥ��֮ŭ����]:��ʹ[{" .. targetName1 .. "/FCOLOR=243}]�ܵ���{Ⱥ��֮ŭ/FCOLOR=243}�Ĵ��...")
        Player.buffTipsMsg(Target, "[Ⱥ��֮ŭ����]:�㱻[{" .. myName1 .. "/FCOLOR=243}]ʩ����{Ⱥ�Ǵ��/FCOLOR=243}״̬...")
    end
end

-- �ǻԡ���ɱ���� �����˺� ��������һ��ʱ����նɱ5%���������1/128��
ZhuangBeiBuffList[2037] = function(actor, Target, Hiter, MagicId)
    if randomex(1, 128) then
        humanhp(Target, "-", Player.getHpValue(Target, 5), 106)
        local myName1 = Player.GetNameEx(actor)
        local targetName1 = Player.GetNameEx(Target)
        Player.buffTipsMsg(actor, "[�ǻԡ���ɱ����]:������[{" .. targetName1 .. "/FCOLOR=243}]���{5%/FCOLOR=243}����...")
        Player.buffTipsMsg(Target, "[�ǻԡ���ɱ����]:�㱻[{" .. myName1 .. "/FCOLOR=243}]�����{5%/FCOLOR=243}�������...")
    end
end

-- ���ڶ��� ����������3%������ä3��.�Եȼ��������������Ч
ZhuangBeiBuffList[2038] = function(actor, Target, Hiter, MagicId)
    local MyLevel  = getbaseinfo(actor, ConstCfg.gbase.level)
    local TgtLevel = getbaseinfo(Target, ConstCfg.gbase.level)
    if TgtLevel > MyLevel then return end
    if randomex(3, 100) then
        local x, y = getconst(Target, "<$SCREENWIDTH>") / 2 - 20, getconst(Target, "<$SCREENHEIGHT>") / 2 + 50
        screffects(Target, 10, 17527, x, y, 1, 3, 0)
    end
end

--�������ﴥ����3000��ͷ��
--����ʱ�и����и����[1%-3%]���������ֵ��(�Լ�����BOSS����Ч)

--����ָ��  ��������ʱ�����и�1%-3%���Ѫ��  ��������1/128
ZhuangBeiBuffList[3000] = function(actor, Target, Hiter, MagicId)
    local targetNmae = getbaseinfo(Target, ConstCfg.gbase.name)
    local cfg = cfg_IsBoss[targetNmae] --����Ч��BOSS
    if cfg then return end
    if randomex(1, 128) then
        local qiGe = math.random(3)
        humanhp(Target, "-", Player.getHpValue(Target, qiGe), 106, 0, actor)
        Player.buffTipsMsg(actor, "[����ָ��]:�и����[{" .. qiGe .. "%/FCOLOR=243}]���Ѫ��...")
    end
end
-- �����硤ն�ˡ� ������(5000W����ֵ)���µĹ���ʱ���������и�[2%]���������ֵ��
ZhuangBeiBuffList[3001] = function(actor, Target, Hiter, MagicId)
    local monhpmavx = getbaseinfo(Target, ConstCfg.gbase.maxhp)
    if monhpmavx <= 50000000 then
        humanhp(Target, "-", Player.getHpValue(Target, 2), 106, 0, actor)
        -- Player.buffTipsMsg(actor, "[�����硤ն�ˡ�]:�и����[2%/FCOLOR=243}]���Ѫ��...")
    end
end
-- ����   ����ʱ�и���ֱ�Ӵ�������۹��ڵĹ���(5%)�������ֵ(BOSSЧ��Ϊ1%) 1/128 ����
ZhuangBeiBuffList[3002] = function(actor, Target, Hiter, MagicId)
    if randomex(1, 128) then
        local monname = getbaseinfo(Target, ConstCfg.gbase.name)
        if cfg_ShenLongDiGuo[monname] then
            humanhp(Target, "-", Player.getHpValue(Target, cfg_ShenLongDiGuo[monname].Damage), 106, 0, actor) --����նѪ
        end
    end
end
-- -- Ԥ����  ��������ѧϰ[Բ��֮��]���ܺ󴥷�����ʱ��(3*3)��Χ�ڵĹ�����ɹ�����[*66%]�ĶԹ��и
-- ZhuangBeiBuffList[3003] = function(actor, Target, Hiter, MagicId)
--     if MagicId == 12 then
--         local dcnum = getbaseinfo(actor, ConstCfg.gbase.dc2)
--         local selfx = getbaseinfo(actor, ConstCfg.gbase.x)
--         local selfy = getbaseinfo(actor, ConstCfg.gbase.y)
--         rangeharm(actor, selfx, selfy, 3, 0, 6, dcnum*0.66, 0, 2)
--     end
-- end
-- ��Ȫ  ÿʮ�����ᴥ����(3*3)��Χ�ڵ����й������(66��)�ĶԹ��и
ZhuangBeiBuffList[3004] = function(actor, Target, Hiter, MagicId)
    local monname = getbaseinfo(Target, ConstCfg.gbase.name)
    if cfg_BuBeiQieGeMon[monname] then return end

    local daoshunum = getplaydef(actor, VarCfg["N$_��Ȫ����"])
    if daoshunum >= 13 then
        local selfx = getbaseinfo(actor, ConstCfg.gbase.x)
        local selfy = getbaseinfo(actor, ConstCfg.gbase.y)
        rangeharm(actor, selfx, selfy, 3, 0, 6, 660000, 0, 2)
        setplaydef(actor, VarCfg["N$_��Ȫ����"], 0) --��������
        Player.buffTipsMsg(actor, "[��Ȫ]:�и�3*3��Χ�ڹ���[{66��/FCOLOR=243}]Ѫ��...")
    else
        setplaydef(actor, VarCfg["N$_��Ȫ����"], daoshunum + 1) --������1
    end
end
--����֮�� ��������ֵ����(20%)�Ĺ���ʱ���� ���[2.0]���Թ��и���˺���
ZhuangBeiBuffList[3005] = function(actor, Target, Hiter, MagicId)
    local calculate = Player.getHpPercentage(Target)
    if calculate <= 20 then
        local qiege = getbaseinfo(actor, 51, 200)
        humanhp(Target, "-", qiege * 2, 106, 0, actor)
    end
end
--���°Գ� ����ʱ�и����и����[1%-3%]���������ֵ��(�Լ�����BOSS����Ч)
ZhuangBeiBuffList[3006] = function(actor, Target, Hiter, MagicId)
    local monname = getbaseinfo(Target, ConstCfg.gbase.name)
    if not cfg_BuBeiQieGeMon[monname] then
        if randomex(1, 128) then
            local num = math.random(1, 3)
            humanhp(Target, "-", Player.getHpValue(Target, num), 106, 0, actor) --�и����Ѫ��1-3%
        end
    end
end
--����ʹ������ ����ʱ�����и����[1%]������ֵ(�и�Ч���Լ�����BOSS�޷���Ч)
ZhuangBeiBuffList[3007] = function(actor, Target, Hiter, MagicId)
    local monname = getbaseinfo(Target, ConstCfg.gbase.name)
    if not cfg_BuBeiQieGeMon[monname] then
        humanhp(Target, "-", Player.getHpValue(Target, 1), 106, 0, actor) --�и����Ѫ��1-3%
    end
end
--����õ��  ����ʱ�и����и����[1%-3%]���������ֵ��(�Լ�����BOSS����Ч) 1/100 ����
ZhuangBeiBuffList[3008] = function(actor, Target, Hiter, MagicId)
    local monname = getbaseinfo(Target, ConstCfg.gbase.name)
    if not cfg_BuBeiQieGeMon[monname] then
        if randomex(1, 100) then
            local num = math.random(1, 3)
            humanhp(Target, "-", Player.getHpValue(Target, num), 106, 0, actor) --�и����Ѫ��1-3%
        end
    end
end
--����֮�� ����ʱ�и���ֱ�Ӵ�������½�ڵ� ����(5%)�������ֵ�� 1/128
ZhuangBeiBuffList[3009] = function(actor, Target, Hiter, MagicId)
    local monname = getbaseinfo(Target, ConstCfg.gbase.name)
    if not cfg_BuBeiQieGeMon[monname] then return end
    if randomex(1, 128) then
        humanhp(Target, "-", Player.getHpValue(Target, 5), 106, 0, actor) --�и����Ѫ��5%
    end
end

--����֮�� �����и����и����(5%)������ֵ�� 1/100 ����
ZhuangBeiBuffList[3010] = function(actor, Target, Hiter, MagicId)
    local monname = getbaseinfo(Target, ConstCfg.gbase.name)
    if cfg_BuBeiQieGeMon[monname] then return end
    if randomex(1, 100) then
        humanhp(Target, "-", Player.getHpValue(Target, 5), 106, 0, actor) --����նѪ5%
    end
end
--��ʦȭ�� ���ʱ����[ħ����*50%]�ĶԹ��и�
ZhuangBeiBuffList[3011] = function(actor, Target, Hiter, MagicId)
    local monname = getbaseinfo(Target, ConstCfg.gbase.name)
    if cfg_BuBeiQieGeMon[monname] then return end
    local mcmax = getbaseinfo(actor, ConstCfg.gbase.mc2)
    humanhp(Target, "-", mcmax * 0.5, 106, 0, actor) --ħ��50%�и�
end
--���˴����� ��������ֵ����30%ʱ�����и�[1%]
ZhuangBeiBuffList[3012] = function(actor, Target, Hiter, MagicId)
    local monname = getbaseinfo(Target, ConstCfg.gbase.name)
    if cfg_BuBeiQieGeMon[monname] then return end

    local nowmonhp = Player.getHpPercentage(Target)
    if nowmonhp <= 30 then
        humanhp(Target, "-", Player.getHpValue(Target, 1), 106, 0, actor) --����նѪ1%
    end
end
--�ϴ峤�Ļ��� ����Ŀ��ʱÿ���ָ�[200]������ֵ
ZhuangBeiBuffList[3013] = function(actor, Target, Hiter, MagicId)
    local nowmonhp = Player.getHpPercentage(actor)
    if nowmonhp >= 3 and nowmonhp ~= 100 then
        humanhp(actor, "+", 200, 4)
    end
end
--��ҹ��֮�� ����Ŀ��ʱÿ���ָ�[388]������ֵ
ZhuangBeiBuffList[3014] = function(actor, Target, Hiter, MagicId)
    if Player.canLifesteal(actor) then
        humanhp(actor, "+", 388, 4, nil, nil, nil)
    end
end

--��ɫ��ħ֮�� [����BUFF]����ʱ���ʴ��������и�(1%)����ֵ(�и�BUFF����ʮ��,BUFF��ȴ120��)  1/188 ����
ZhuangBeiBuffList[3015] = function(actor, Target, Hiter, MagicId)
    if randomex(1, 188) then
        local buff1 = hasbuff(actor, 30061)
        if not buff1 then
            addbuff(actor, 30061, 120, 1, actor)
            addbuff(actor, 30062, 10, 1, actor)
            Player.buffTipsMsg(actor, "[��ɫ��ħ֮��]:�����и����{1%/FCOLOR=243}Ѫ��,����{10/FCOLOR=243}��...")
        end
    end
    local buff2 = hasbuff(actor, 30062)
    if buff2 then
        humanhp(Target, "-", Player.getHpValue(Target, 1), 106, 0, actor) --����նѪ1%
    end
end

--Ѫɫ֮Ӱ ÿ��ָ�����(�ȼ�*10)������ֵ����ʱ������(�����۹�)�����ڵĹ���������[55555]��Թ��и
ZhuangBeiBuffList[3016] = function(actor, Target, Hiter, MagicId)
    local monname = getbaseinfo(Target, ConstCfg.gbase.name)
    if cfg_ShenLongDiGuo[monname] then
        humanhp(Target, "-", 55555, 106, 0, actor) --����նѪ55555
    end
end

-- �׹�֮�� ��������ʱ��1/128�����ٻ�һֻ����Э������ս��1�����ѱ�
ZhuangBeiBuffList[3017] = function(actor, Target, Hiter, MagicId)
    if randomex(1, 128) then
        recallmob(actor, "����", 7, 1, 1)
    end
end

--���֮ŭ��� ��������10%����ʩ�Ӷ���,����ÿ����ʧ����*150%���˺�,����5��
ZhuangBeiBuffList[3018] = function(actor, Target, Hiter, MagicId)
    if randomex(1, 10) then
        addbuff(Target, 31092, 5, 1, actor, nil)
    end
end

--ӭ��ѩ�� ����ʱ�и����ٻ�һֻѩ�˰�����ս��������30�룬ѩ������ʱ�ͷ�ѩ������3X3��Χ��Ŀ�����5000��̶��˺�������50%�ĸ��ʱ���1S.
ZhuangBeiBuffList[3019] = function(actor, Target, Hiter, MagicId)
    if randomex(1, 188) then
        local x = getbaseinfo(actor,ConstCfg.gbase.x)
        local y = getbaseinfo(actor,ConstCfg.gbase.y)
        recallmobex(actor, "ʥ��ѩ��", x, y, 0, 1, 5, 0, 1, 1, 0)
    end
end

-- ȫ������ǰ��������Ѫǰ����4000��ͷ��
--̫���������[��ȫ��] ÿ�������������[1.5��]�Թ��и�   �Թ������[2.0��]�Թ��и�
ZhuangBeiBuffList[4000] = function(actor, Target, Hiter, MagicId, Damage, Model, attackDamageData)
    local daoshunum = getplaydef(actor, VarCfg["N$_��������"])
    if daoshunum >= 3 then
        if getbaseinfo(Target, -1) then --���˴���
            local damagenum = math.floor(Damage * 1.5)
            humanhp(Target, "-", damagenum, 106)
            setplaydef(actor, VarCfg["N$_��������"], 0)
            -- local myName = Player.GetNameEx(actor)
            -- local targetName = Player.GetNameEx(Target)
            -- Player.buffTipsMsg(actor, "[̫���������]:նɱ��[{" .. targetName .. "/FCOLOR=243}]��" .. damagenum .. "����...")
            -- Player.buffTipsMsg(Target,  "[̫���������]:�㱻[{" .. myName .. "/FCOLOR=243}],նɱ" .. damagenum .. "����...")
        else --�Թִ���
            local monname = getbaseinfo(Target, ConstCfg.gbase.name)
            if cfg_BuBeiQieGeMon[monname] then return end
            humanhp(Target, "-", Damage * 2, 106, 0, actor)
            setplaydef(actor, VarCfg["N$_��������"], 0)
        end
    else
        setplaydef(actor, VarCfg["N$_��������"], daoshunum + 1) --������1
    end
end

--�۹�������(������)    �����һ������˺����� 2%  -- 26	�һ𽣷�-- 56	���ս���-- 66	����ն
ZhuangBeiBuffList[4006] = function(actor, Target, Hiter, MagicId, Damage, Model, attackDamageData)
    if MagicId == 26 or MagicId == 66 or MagicId == 56 then
        attackDamageData.damage = attackDamageData.damage + math.floor(Damage * 0.02)
    end
end

--�۹�������(�ɳ���)    �����һ������˺����� 4%
ZhuangBeiBuffList[4007] = function(actor, Target, Hiter, MagicId, Damage, Model, attackDamageData)
    if MagicId == 26 or MagicId == 66 or MagicId == 56 then
        attackDamageData.damage = attackDamageData.damage + math.floor(Damage * 0.04)
    end
end

--�۹�������(������)    �����һ������˺����� 6%
ZhuangBeiBuffList[4008] = function(actor, Target, Hiter, MagicId, Damage, Model, attackDamageData)
    if MagicId == 26 or MagicId == 66 or MagicId == 56 then
        attackDamageData.damage = attackDamageData.damage + math.floor(Damage * 0.06)
    end
end
--�۹�������(��ȫ��)    �����һ������˺����� 8%
ZhuangBeiBuffList[4009] = function(actor, Target, Hiter, MagicId, Damage, Model, attackDamageData)
    if MagicId == 26 or MagicId == 66 or MagicId == 56 then
        attackDamageData.damage = attackDamageData.damage + math.floor(Damage * 0.08)
    end
end
--�۹�������(������)    �����һ������˺����� 10%
ZhuangBeiBuffList[4010] = function(actor, Target, Hiter, MagicId, Damage, Model, attackDamageData)
    if MagicId == 26 or MagicId == 66 or MagicId == 56 then
        attackDamageData.damage = attackDamageData.damage + math.floor(Damage * 0.1)
    end
end
--���������֮��   ����ʱ�и����ٻ����׶�[3*3��Χ]��Ŀ�����(1S)�������5����������ֵ�ĶԹ��и(CD60��)
ZhuangBeiBuffList[4011] = function(actor, Target, Hiter, MagicId, Damage, Model, attackDamageData)
    local buffCD = hasbuff(actor, 30010)
    if not buffCD then
        local tgtx, tgty = getbaseinfo(Target, ConstCfg.gbase.x), getbaseinfo(Target, ConstCfg.gbase.y)
        local dcnum = getbaseinfo(actor, ConstCfg.gbase.dc2)
        rangeharm(actor, tgtx, tgty, 3, dcnum * 5, 0, nil, nil, 0, 214) --�׻�Ч��
        makeposion(Target, 5, 1, 0, 1)
        addbuff(actor, 30010, 60)
        Player.buffTipsMsg(actor, "[���������֮��]:�ٻ����׶�3*3��Χ��Ŀ�����1��,�����5����������ֵ�ĶԹ��и�...")
    end

    if not getbaseinfo(Target, -1) then --�Թִ���
        if Player.getHpPercentage(actor) >= 3 then
            humanhp(actor, "+", Damage * 0.05, 4)
        end
    end
end
-- Ұ��֮��    ʩ�ż��ܺ��´ι������[2]���˺�!(60����ֻ������һ�ε�ǰBUFF)
ZhuangBeiBuffList[4012] = function(actor, Target, Hiter, MagicId, Damage, Model, attackDamageData)
    local buffcd = hasbuff(actor, 30013)
    if not buffcd then
        if MagicId == 26 or MagicId == 66 or MagicId == 56 then
            addbuff(actor, 30013, 60, 1, actor)
            setplaydef(actor, VarCfg["S$_Ұ��֮��"], "���ͷ�")
        end
    end
    if getplaydef(actor, VarCfg["S$_Ұ��֮��"]) == "���ͷ�" then
        attackDamageData.damage = attackDamageData.damage + Damage
        setplaydef(actor, VarCfg["S$_Ұ��֮��"], "")
    end
end
--�����ߵ��ؼ�   ȫ�����˺�+ 10% ħ���ܼ��ܵȼ���+ 1 �����˺�+10% ��������3�κ��ݻٿ����ߵ��ؼ���3/3��
ZhuangBeiBuffList[4013] = function(actor, Target, Hiter, MagicId, Damage, Model, attackDamageData)
    if MagicId == 26 or MagicId == 66 or MagicId == 56 then
        attackDamageData.damage = attackDamageData.damage + (Damage * 0.1)
    end
end
--���˹� ����ʱ�����и�Ŀ��(3%)�������ֵ (30����ֻ������һ�ε�ǰBUFF) 1/88
ZhuangBeiBuffList[4014] = function(actor, Target, Hiter, MagicId, Damage, Model, attackDamageData)
    if Model == 1 then
        if randomex(1, 88) then
            local buffCd = hasbuff(actor, 30018)
            if not buffCd then
                humanhp(Target, "-", Player.getHpValue(Target, 3), 106, 0, actor) --���������� ��Ѫ3%
                addbuff(actor, 30018, 30, 1, actor)
                local targetName = Player.GetNameEx(Target)
                Player.buffTipsMsg(actor, "[���˹�]:��������նɱ[{" .. targetName .. "/FCOLOR=243}]��3%Ѫ��...")
            end
        end
    end
end
--��ˡ  ����Ŀ��ʱ������ȡĿ������ֵ5%�Թ���Ѫ ����3%Ѫ�����²���Ч   PKʱ�и��ʽ�Ŀ������BUFF��������1/128
ZhuangBeiBuffList[4015] = function(actor, Target, Hiter, MagicId, Damage, Model, attackDamageData)
    if getbaseinfo(Target, -1) then --���˴���
        if randomex(1, 128) then
            addbuff(Target, 30020, 10, 1, actor)
        end
    else
        if Player.canLifesteal(actor) then
            humanhp(actor, "+", Damage * 0.05, 4) --��Ѫ5%
        end
    end
end
--�������  ʩ�ſ���ն֮���´ι����ض������ [3.0]���ĶԹ��и�[CD:60��]
ZhuangBeiBuffList[4016] = function(actor, Target, Hiter, MagicId, Damage, Model, attackDamageData)
    local f_var = getplaydef(actor, VarCfg["S$_�������"])
    local buffcd = hasbuff(actor, 30028)
    if MagicId == 66 then
        if f_var ~= "1" then
            setplaydef(actor, getplaydef(actor, VarCfg["S$_�������"]), "1")
        end
    end
    if not buffcd and f_var == "1" then
        attackDamageData = attackDamageData + Damage * 2
        setplaydef(actor, getplaydef(actor, VarCfg["S$_�������"]), "")
        addbuff(actor, 30028, 60, 1, actor)
        Player.buffTipsMsg(actor, "[�������]:�����˺��Թ����[{3��/FCOLOR=243}]�˺�...")
    end
end
--����֮��  ���︴��󴥷�����[2��]�´ι����ض����[3.0]���˺�[CD:30��]
ZhuangBeiBuffList[4017] = function(actor, Target, Hiter, MagicId, Damage, Model, attackDamageData)
    if getplaydef(actor, VarCfg["S$_����֮��"]) == "1" then
        attackDamageData.damage = attackDamageData.damage + Damage * 2
        Player.buffTipsMsg(actor, "[����֮��]:�����˺��Թ����[{3��/FCOLOR=243}]�˺�...")
        setplaydef(actor, VarCfg["S$_����֮��"], "")
    end
end
--����þ� ����Ŀ��ʱ������ȡ����ֵ5%��Ѫ  ��������ʱ ��������նɱ����3%����ֵ
ZhuangBeiBuffList[4018] = function(actor, Target, Hiter, MagicId, Damage, Model, attackDamageData)
    if getbaseinfo(Target, -1) then --�������
        humanhp(Target, "-", Player.getHpValue(Target, 3), 106, 0, actor)
        local targetName = Player.GetNameEx(Target)
        -- Player.buffTipsMsg(actor, "[����þ�]:����նɱ[{"..targetName.."/FCOLOR=243}]3%���Ѫ��...")
    else
        if Player.canLifesteal(actor) then
            humanhp(actor, "+", Damage * 0.05, 1, nil, nil, nil) --��Ѫ5%
        end
    end
end
--�޾��Ļ����� �������и����������8���� ÿ���������˺�ֵ��70%   30��ֻ����һ��
ZhuangBeiBuffList[4019] = function(actor, Target, Hiter, MagicId, Damage, Model, attackDamageData)
    local monname = getbaseinfo(Target, ConstCfg.gbase.name)
    if cfg_BuBeiQieGeMon[monname] then return end
    if randomex(1, 128) then
        local buffcd = hasbuff(actor, 30032)
        if not buffcd then
            for i = 1, 8 do
                humanhp(Target, "-", Damage * 0.7, 106, 0, actor)
                addbuff(actor, 30032, 30, 1, actor)
            end
        end
    end
end
--��˪֮�� ÿ�˵��´�2���˺�
ZhuangBeiBuffList[4020] = function(actor, Target, Hiter, MagicId, Damage, Model, attackDamageData)
    local daoshunum = getplaydef(actor, VarCfg["N$_��˪֮��"])
    if daoshunum >= 8 then
        setplaydef(actor, VarCfg["N$_��˪֮��"], 0) --������0
        attackDamageData.damage = attackDamageData.damage + Damage
    else
        setplaydef(actor, VarCfg["N$_��˪֮��"], daoshunum + 1) --������1
    end
end

--��յ���·�� �ͷż��ܺ��´ι������2���˺� 30SCD
ZhuangBeiBuffList[4021] = function(actor, Target, Hiter, MagicId, Damage, Model, attackDamageData)
    local buffcd = hasbuff(actor, 30038)
    if not buffcd then
        if MagicId == 26 or MagicId == 66 or MagicId == 56 then
            attackDamageData.damage = attackDamageData.damage + Damage
            addbuff(actor, 30038, 30, 1, actor)
            Player.buffTipsMsg(actor, "[�����·��]:����˫���˺�...")
        end
    end
end

--�������ˡ���Ԩ֮�� �Թ�5%��Ѫ ���� Ѫ������98% 1/5���� նɱ�Է�50%Ѫ�� ����������ر���  ���н�еbuff��3s�޷�����������
ZhuangBeiBuffList[4022] = function(actor, Target, Hiter, MagicId, Damage, Model, attackDamageData)
    if getbaseinfo(Target, -1) then --���˴���
        local TgtHp = Player.getHpPercentage(Target)
        if TgtHp >= 98 then
            if randomex(20,100) then
                if Player.checkCd(actor, VarCfg["�������ˡ���Ԩ֮��CD"], 10, true) then
                    local itemobj = linkbodyitem(Target, 1)
                    local itemidx = getiteminfo(Target, itemobj, 1)
                    takeoffitem(Target, 1, itemidx)
                    humanhp(Target, "-", Player.getHpValue(Target, 50), 106, 0, actor) --����նѪ1%
                    addbuff(Target, 30041, 30, 1, actor)
                    Player.buffTipsMsg(actor, "[�������ˡ���Ԩ֮��]:նɱ�Է�{50%/FCOLOR=243}Ѫ��,�����ӽ�е״̬{3/FCOLOR=243}��...")
                end
            end
        end
    else --�Թִ���
        if Player.canLifesteal(actor) then
            humanhp(actor, "+", Damage * 0.05, 4)
        end
    end
end
--һ�������� �Ƹ���ʣ�+ 5% ����ʱ�и���նɱ����[15%]����ֵ 1/128
ZhuangBeiBuffList[4023] = function(actor, Target, Hiter, MagicId, Damage, Model, attackDamageData)
    if getbaseinfo(Target, -1) then                                  --���˴���
        if randomex(1, 128) then
            humanhp(Target, "-", Player.getHpValue(Target, 15), 106, 0, actor) --նѪ15%
            Player.buffTipsMsg(actor, "[һ��������]:նɱ�Է�{15%/FCOLOR=243}Ѫ��...")
        end
    else --�Թִ���
        if Player.canLifesteal(actor) then
            humanhp(actor, "+", Damage * 0.05, 4)
        end
    end
end
--������������֮�� ����Ŀ��ʱ������ȡĿ������ֵ ����ʱնɱ����ֵ����(30%)��Ŀ�� (�Գ���BOSSЧ��ֻնɱ15%����ֵ) (��BUFF��������Ч������15���CD)
ZhuangBeiBuffList[4024] = function(actor, Target, Hiter, MagicId, Damage, Model, attackDamageData)
    if getbaseinfo(Target, -1) then --���˴���
        local tgtmaxHp = Player.getHpPercentage(Target)
        if tgtmaxHp <= 30 then
            local buffcd = hasbuff(actor, 30048)
            if not buffcd then
                humanhp(Target, "-", Player.getHpValue(Target, tgtmaxHp), 106, 0, actor) --նѪ 30
                addbuff(actor, 30048, 15, 1, actor)
            end
        end
    else --�Թִ���
        if Player.canLifesteal(actor) then
            humanhp(actor, "+", Damage * 0.05, 4)
        end
        local monname = getbaseinfo(Target, ConstCfg.gbase.name)
        if cfg_BuBeiQieGeMon[monname] then --����BOSS
            local tgtmaxHp = Player.getHpPercentage(Target)
            if tgtmaxHp <= 15 then
                local buffcd = hasbuff(actor, 30048)
                if not buffcd then
                    killmonbyobj(actor, Target, true, true, true) --ɱ������
                    addbuff(actor, 30048, 15, 1, actor)
                    Player.buffTipsMsg(Target, "[������������֮��]:նɱѪ������{15%/FCOLOR=243}��BOSS����...")
                end
            end
        else --�ⲻ��BOSS
            local tgtmaxHp = Player.getHpPercentage(Target)
            if tgtmaxHp <= 30 then
                local buffcd = hasbuff(actor, 30048)
                if not buffcd then
                    killmonbyobj(actor, Target, true, true, true) --ɱ������
                    addbuff(actor, 30048, 15, 1, actor)
                    Player.buffTipsMsg(Target, "[������������֮��]:նɱѪ������{30%/FCOLOR=243}�Ĺ���...")
                end
            end
        end
    end
end

--ħԨ��� ʩ�ż��ܺ��´ι������[3]���˺�!(20����ֻ������һ�ε�ǰBUFF)
ZhuangBeiBuffList[4025] = function(actor, Target, Hiter, MagicId, Damage, Model, attackDamageData)
    if MagicId == 26 or MagicId == 66 or MagicId == 56 then --���˴���
        setplaydef(actor, VarCfg["S$_ħԨ���"], 1)
    end
    if getplaydef(actor, VarCfg["S$_ħԨ���"]) == "1" then
        local buff = hasbuff(actor, 30049)
        if not buff then
            attackDamageData.damage = attackDamageData.damage + Damage * 2
            Player.buffTipsMsg(actor, "[ħԨ���]:�Թ������{3/FCOLOR=243}���˺�...")
            setplaydef(actor, VarCfg["S$_ħԨ���"], "")
            addbuff(actor, 30049, 20, 1, actor)
        end
    end
end
--����֧�� ����ʱ�и��ʴ������[5.0��]�˺����һָ�����(20%)���������ֵ�� 1/188����
ZhuangBeiBuffList[4026] = function(actor, Target, Hiter, MagicId, Damage, Model, attackDamageData)
    if randomex(1, 188) then
        attackDamageData.damage = attackDamageData.damage + Damage * 4 --���5���˺�
        humanhp(actor, "+", Player.getHpValue(actor, 20), 4)           --�ָ�����20%����
        local targetName = Player.GetNameEx(Target)
        Player.buffTipsMsg(actor, "[����֧��]:{" .. targetName ..
            "/FCOLOR=243}���{5/FCOLOR=243}���˺�,���ָ�����{20%/FCOLOR=243}Ѫ��...")
    end
end

--���֮�� ����ʱ�����и�Ŀ��(5%)�������ֵ(30����ֻ������һ�ε�ǰ��BUFF) 1/88 ����
ZhuangBeiBuffList[4027] = function(actor, Target, Hiter, MagicId, Damage, Model, attackDamageData)
    if Model == 1 then
        if randomex(1, 88) then
            local buff = hasbuff(actor, 30060)
            if not buff then
                humanhp(Target, "-", Player.getHpValue(Target, 5), 106, 0, actor) --���������� ��Ѫ5%
                addbuff(actor, 30060, 30, 1, actor)
                local targetName = Player.GetNameEx(Target)
                Player.buffTipsMsg(actor, "[���֮��]:��{" ..
                    targetName .. "/FCOLOR=243}���{5%/FCOLOR=243}Ѫ����{նɱ/FCOLOR=243}�˺�...")
            end
        end
    end
end

--��EX������˪֮�� ��������(����)ʱ�и��ʼ���һ��˫�ش��Ч����  1/188 ����
ZhuangBeiBuffList[4028] = function(actor, Target, Hiter, MagicId, Damage, Model, attackDamageData)
    if Model == 1 then
        if randomex(1, 188) then
            attackDamageData.damage = attackDamageData.damage + Damage
            Player.buffTipsMsg(actor, "[��EX������˪֮��]:���������󼤻�{2/FCOLOR=243}�����Ч��...")
        end
    end
end

--������� ������������״̬[����]�����´ι������[3.0]���˺���
ZhuangBeiBuffList[4029] = function(actor, Target, Hiter, MagicId, Damage, Model, attackDamageData)
    if getplaydef(actor, VarCfg["S$_�������"]) == "1" then
        if not Player.checkCd(actor, VarCfg["����CD"], 60, true) then return end

        attackDamageData.damage = attackDamageData.damage + Damage * 2
        Player.buffTipsMsg(actor, "[�������]:��Ŀ�����3���˺�...")
        setplaydef(actor, VarCfg["S$_�������"], "")
    end
end

--�����ʼ� �����������¼[��ɱ��]����Ϸ�����´���Ŀ��PKʱ����[20%]���˺�ֵ
ZhuangBeiBuffList[4030] = function(actor, Target, Hiter, MagicId, Damage, Model, attackDamageData)
    local notesname = getplaydef(actor, VarCfg["S$_�����ʼǱ��"])
    local targetName = Player.GetNameEx(Target)
    if notesname == targetname then
        attackDamageData = attackDamageData.damage + Damage * 0.2
    end
end

--�ź��䡤���������  ����ܣ�ֱ��նɱѪ������10%�Ĺ���  ����ݣ�����ʱ�и��ʴ���1-3�����ع���
ZhuangBeiBuffList[4031] = function(actor, Target, Hiter, MagicId, Damage, Model, attackDamageData)
    local itemobj = linkbodyitem(actor, 26)
    local usenum = getitemaddvalue(actor, itemobj, 2, 19, nil) --��ȡ�������Ա��
    if usenum == 4 then
        local tgtmaxHp = Player.getHpPercentage(Target)
        if tgtmaxHp <= 10 then
            killmonbyobj(actor, Target, true, true, true) --ɱ������
            Player.buffTipsMsg(actor, "[�ź��䡤���������]:����{4/FCOLOR=243}������,ֱ��նɱѪ������{10%/FCOLOR=243}�Ĺ���...")
        end
    elseif usenum == 5 then
        if randomex(1, 88) then
            local number = math.random(1, 3)
            attackDamageData.damage = attackDamageData.damage + Damage * number
            Player.buffTipsMsg(actor, "[�ź��䡤���������]:����{5/FCOLOR=243}������,����{" .. number + 1 .. "��/FCOLOR=243}����...")
        end
    end
end

--����֮�� (��ս��״̬��)ʹ��ʮ��һɱ�ᴥ����������һ���ض������Ŀ��[1��]
ZhuangBeiBuffList[4032] = function(actor, Target, Hiter, MagicId, Damage, Model, attackDamageData)
    local buff = hasbuff(actor, 10001)
    if not buff then
        if MagicId == 82 then
            local x, y = getbaseinfo(Target, ConstCfg.gbase.x), getbaseinfo(Target, ConstCfg.gbase.y)
            rangeharm(actor, x, y, 0, 0, 2, 1, 1, 0, 20500) -- ����2*2��Χ�ڵ���1��
            playsound(actor, 100001, 1, 0)                  --���ű�����Ч
        end
    end
end

--�Ա�������Ŀ����ɶ���30%���˺�
ZhuangBeiBuffList[4033] = function(actor, Target, Hiter, MagicId, Damage, Model, attackDamageData)
    local result1, result2 = checkhumanstate(Target, 7)
    -- makeposion(Target, 12, 100)
    if result1 then
        attackDamageData.damage = attackDamageData.damage + math.floor(Damage * 0.3)
        Player.buffTipsMsg(actor, "[˪���ػ�����]:�Ա�������Ŀ����ɶ���30%�˺�")
    end
end

--��Ԫ֮�ȡ���˪���� ������5%�ļ���ʹĿ�����뺮��״̬������3�룬ʹ�乥�����ͷ���ǿ�Ƚ���30%��ͬʱ����2%�ļ���ʹ�����������״̬������1.5�롣
ZhuangBeiBuffList[4034] = function(actor, Target, Hiter, MagicId, Damage, Model, attackDamageData)
    if getbaseinfo(Target, -1) then   --���˴���
        if randomex(5, 100) then
            addbuff(Target, 31055, 5) --DBuff
        end
    else                              --�Թִ���
        if randomex(2, 100) then
            local x, y = getbaseinfo(Target, ConstCfg.gbase.x), getbaseinfo(Target, ConstCfg.gbase.y)
            rangeharm(actor, x, y, 0, 0, 2, 1, 0, 2, 20500) -- ����2*2��Χ�ڵ���1��
            playsound(actor, 100001, 1, 0)                  --���ű�����Ч
        end
    end
end

--��֮�������� ÿ�������������[1.5��]�Թ��и�   �Թ������[2.0��]�Թ��и�
ZhuangBeiBuffList[4035] = function(actor, Target, Hiter, MagicId, Damage, Model, attackDamageData)
    local monname = getbaseinfo(Target, ConstCfg.gbase.name)
    if cfg_BuBeiQieGeMon[monname] then return end

    local daoshunum = getplaydef(actor, VarCfg["N$_���µ���"])
    if daoshunum >= 3 then
        if getbaseinfo(Target, -1) then --���˴���
            local damagenum = math.floor(Damage * 1.5)
            humanhp(Target, "-", damagenum, 106, 0, actor)
            setplaydef(actor, VarCfg["N$_���µ���"], 0)
        else --�Թִ���
            humanhp(Target, "-", Damage * 2, 106, 0, actor)
            setplaydef(actor, VarCfg["N$_���µ���"], 0)
        end
    else
        setplaydef(actor, VarCfg["N$_���µ���"], daoshunum + 1) --������1
    end
end

--�ǹ� �����˺�+5%
ZhuangBeiBuffList[4036] = function(actor, Target, Hiter, MagicId, Damage, Model, attackDamageData)
    if MagicId == 26 or MagicId == 66 or MagicId == 56 then
        attackDamageData.damage = attackDamageData.damage + (Damage * 0.05)
    end
end

--�ս��� ÿ���9S����һ���ػ�״̬
ZhuangBeiBuffList[4037] = function(actor, Target, Hiter, MagicId, Damage, Model, attackDamageData)
    if getplaydef(actor, VarCfg["S$_�ս���"]) ~= "���ͷ�" then return end
    attackDamageData.damage = attackDamageData.damage + (Damage * 0.5)
    setplaydef(actor, VarCfg["S$_�ս���"], "")
end

--ҹ�硤���ܽ���  ����չ��ս�����������״̬����״̬���﹥�������������������״̬ÿ��ֻ��ά��5��  ���˺�����+20%  �����˺�+20%��
ZhuangBeiBuffList[4038] = function(actor, Target, Hiter, MagicId, Damage, Model, attackDamageData)
    local isFight = hasbuff(actor, 10001) --��ȡս��״̬
    if not isFight then
        addbuff(actor, 31080)
    end
end

--�����  ������չ��ս����5���ڻ��30%��ֹ�������ʼӳ�
ZhuangBeiBuffList[4039] = function(actor, Target, Hiter, MagicId, Damage, Model, attackDamageData)
    local isFight = hasbuff(actor, 10001) --��ȡս��״̬
    if not isFight then
        addbuff(actor, 31093, 5, 1, actor, nil)
    end
end

-- ��֮��������⽣!  ����Ŀ��ʱ������ȡĿ������ֵÿ�������������[3.0��]�˺� ÿ�����Թ������[5.0��]�˺�
ZhuangBeiBuffList[4040] = function(actor, Target, Hiter, MagicId, Damage, Model, attackDamageData)
    local daoshunum = getplaydef(actor, VarCfg["N$_��֮������"])
    daoshunum = daoshunum + 1
    if getbaseinfo(Target, -1) then --���˴���
        if daoshunum >= 3 then
            attackDamageData.damage = attackDamageData.damage + Damage * 2
            setplaydef(actor, VarCfg["N$_��֮������"], 0) --������0
            return
        end
        setplaydef(actor, VarCfg["N$_��֮������"], daoshunum) --������1
    else --�Թִ���
        local monname = getbaseinfo(Target, ConstCfg.gbase.name)
        if cfg_BuBeiQieGeMon[monname] then return end
        humanhp(actor, "+", Damage * 0.05, 4)
        if daoshunum >= 3 then
            attackDamageData.damage = attackDamageData.damage + Damage * 4
            setplaydef(actor, VarCfg["N$_��֮������"], 0) --������0
            return
        end
        setplaydef(actor, VarCfg["N$_��֮������"], daoshunum) --������1
    end
end

--������ǰ��������Ѫǰ����5000��ͷ��
-- С��ħ��׹�� ����ʱ�и����и�Ŀ��[10%-50%]��
ZhuangBeiBuffList[5000] = function(actor, Target, Hiter, MagicId, Damage, Model, attackDamageData)
    if randomex(1, 118) then
        local dechp = math.random(10, 50)                           --���ֵ10-50
        humanhp(Target, "-", Player.getHpValue(Target, dechp), 106, 0, actor) --նѪ ���ֵ10-50
        local myName = Player.GetNameEx(actor)
        local targetName = Player.GetNameEx(Target)
        Player.buffTipsMsg(actor, "[С��ħ��׹��]:նɱ��[{" .. targetName .. "/FCOLOR=243}]" .. dechp .. "%���Ѫ��...")
        Player.buffTipsMsg(Target, "[С��ħ��׹��]:�㱻[{" .. myName .. "/FCOLOR=243}],նɱ" .. dechp .. "%���Ѫ��...")
    end
end

-- ����������־�� ÿ�������������[1.5��]�Թ��и�
ZhuangBeiBuffList[5001] = function(actor, Target, Hiter, MagicId, Damage, Model, attackDamageData)
    local daoshunum = getplaydef(actor, VarCfg["N$_��������"])
    if daoshunum >= 3 then
        humanhp(Target, "-", Damage * 1.5, 106, 0, actor)
        setplaydef(actor, VarCfg["N$_��������"], 0) --������0
        -- local myName = Player.GetNameEx(actor)
        -- local targetName = Player.GetNameEx(Target)
        -- Player.buffTipsMsg(actor, "[����������־��]:նɱ��[{" .. targetName .. "/FCOLOR=243}]"..Damage * 1.5 .."����...")
        -- Player.buffTipsMsg(Target,  "[����������־��]:�㱻[{" .. myName .. "/FCOLOR=243}],նɱ"..Damage * 1.5 .."����...")
    else
        setplaydef(actor, VarCfg["N$_��������"], daoshunum + 1) --������1
    end
end
--����֮�� ������Ѫ����ֱ��նɱ(10%)����ֵ (60����ֻ������һ�ε�ǰBUFF)
ZhuangBeiBuffList[5002] = function(actor, Target, Hiter, MagicId, Damage, Model, attackDamageData)
    local buffcd = hasbuff(actor, 30012)
    if not buffcd then
        local tgtplayhp = Player.getHpPercentage(Target)
        if tgtplayhp == 100 then
            humanhp(Target, "-", Player.getHpValue(Target, 10), 106, 0, actor)
            addbuff(actor, 30012, 60, 1, actor)
            local myName = Player.GetNameEx(actor)
            local targetName = Player.GetNameEx(Target)
            Player.buffTipsMsg(actor, "[����֮��]:նɱ��[{" .. targetName .. "/FCOLOR=243}]10%���Ѫ��...")
            Player.buffTipsMsg(Target, "[����֮��]:�㱻[{" .. myName .. "/FCOLOR=243}],նɱ10%���Ѫ��...")
        end
    end
end
-- ��ɷ�� ������Ч����(@���+Ŀ������) �����Ա��Ŀ���[���˺�����15%] (С�˺�����Ч��ʧЧ��Ҫ���±��)
ZhuangBeiBuffList[5003] = function(actor, Target, Hiter, MagicId, Damage, Model, attackDamageData)
    local markname = getplaydef(actor, VarCfg["S$_׷ɱ���"])
    if markname == "" then return end
    local tgtname = getbaseinfo(Target, ConstCfg.gbase.name)
    if tgtname ~= markname then return end
    attackDamageData.damage = attackDamageData.damage + (Damage * 0.15)
end
-- ج��֮�ס�� ������Ч����(@���+Ŀ������) �����Ա��Ŀ���[���˺�����15%] (С�˺�����Ч��ʧЧ��Ҫ���±��)
ZhuangBeiBuffList[5004] = function(actor, Target, Hiter, MagicId, Damage, Model, attackDamageData)
    local markname = getplaydef(actor, VarCfg["S$_׷ɱ���"])
    if markname ~= "" then
        local tgtname = getbaseinfo(Target, ConstCfg.gbase.name)
        if tgtname ~= markname then
            return
        else
            attackDamageData.damage = attackDamageData.damage + (Damage * 0.15)
        end
    end
end
-- ʱ��֮�֡��۱� ������Ѫ����ֱ��նɱ(30%)����ֵ(60����ֻ������һ�ε�ǰBUFF)
ZhuangBeiBuffList[5005] = function(actor, Target, Hiter, MagicId, Damage, Model, attackDamageData)
    local tgtplayhp = Player.getHpPercentage(Target)
    if tgtplayhp == 100 then
        local buff = hasbuff(actor, 30054)
        if not buff then
            humanhp(Target, "-", Player.getHpValue(Target, 30), 106, 0, actor)
            addbuff(actor, 30054, 60, 1, actor)
            local targetName = Player.GetNameEx(Target)
            Player.buffTipsMsg(actor, "[ʱ��֮�֡��۱�]:նɱ��[{" .. targetName .. "/FCOLOR=243}]30%���Ѫ��...")
        end
    end
end

-- ������֮�ۡ� ����ʱնɱ����ֵ����(20%)��Ŀ��(��BUFF��������Ч������10���CD)
ZhuangBeiBuffList[5007] = function(actor, Target, Hiter, MagicId, Damage, Model, attackDamageData)
    local tgtplayhp = Player.getHpPercentage(Target)
    if tgtplayhp < 20 then
        local buff = hasbuff(Target, 30059)
        if not buff then
            humanhp(Target, "-", Player.getHpValue(Target, tgtplayhp), 106, 0, actor) --նɱĿ��ʣ��Ѫ��
            playeffect(Target, 16020, 0, 0, 1, 0, 0)
            addbuff(actor, 30059, 10, 1, actor)
            local targetName = Player.GetNameEx(Target)
            Player.buffTipsMsg(actor, "[������֮�ۡ�]:{" .. targetName .. "/FCOLOR=243}��������{20%/FCOLOR=243},ֱ�ӽ���նɱ...")
        end
    end
end

--���}�ý��RSSS�� ÿ��ָ�����(�ȼ�*10)������ֵ������ֵ����[50%]ʱ������һ�ι����и�����(20%)������ֵ(CD120��)
ZhuangBeiBuffList[5008] = function(actor, Target, Hiter, MagicId, Damage, Model, attackDamageData)
    local calculate = Player.getHpPercentage(actor)
    if calculate < 50 then
        local buff = hasbuff(actor, 30072)
        if not buff then
            humanhp(Target, "-", Player.getHpValue(Target, 20), 106, 0, actor) --�и�20%Ѫ��
            addbuff(actor, 30072, 120, 1, actor)
            local targetName = Player.GetNameEx(Target)
            Player.buffTipsMsg(actor, "[���}�ý��RSSS��]:նɱ[{" .. targetName .. "/FCOLOR=243}]{20%/FCOLOR=243}��Ѫ��...")
        end
    end
end

--������������ħ����  ������������������ʱ���ʸ�������һ��ӡ��  ��һ���ض�նɱ����99%Ѫ��
ZhuangBeiBuffList[5009] = function(actor, Target, Hiter, MagicId, Damage, Model, attackDamageData)
    local buff = hasbuff(actor, 31060)
    if buff then
        humanhp(Target, "-", Player.getHpValue(Target, 99), 106, 0, actor) --�и�99%Ѫ��
        local targetName = Player.GetNameEx(Target)
        Player.buffTipsMsg(actor, "[���}�ý��RSSS��]:նɱ[{" .. targetName .. "/FCOLOR=243}]{99%/FCOLOR=243}��Ѫ��...")
        delbuff(actor, 31060)
    end
end

--������������� ����ǿ�ƶ��ֺ�ƽģʽ3�� ���ʽ�������1�� ���ʻ��˶���1��     ����1/10   60S CD
ZhuangBeiBuffList[5010] = function(actor, Target, Hiter, MagicId, Damage, Model, attackDamageData)
    local buffCD = hasbuff(actor, 31081)
    if buffCD then return end
    if randomex(1, 10) then
        addbuff(actor, 31081, 60)  --���� ���Լ���ӵ���ʱbuff
        local buffSort = math.random(1, 3)
        local myName = Player.GetNameEx(actor)
        local targetName = Player.GetNameEx(Target)
        if buffSort == 1 then
            setattackmode(Target, 1, 3)                                --�޸ĶԷ�����״̬ ��ƽ
            Player.buffTipsMsg(actor, "[�������������]:ʹ[{" .. targetName .. "/FCOLOR=243}]�����ƽģʽ{3/FCOLOR=243}��...")
            Player.buffTipsMsg(Target, "[�������������]:�㱻[{" .. myName .. "/FCOLOR=243}],ʩ����ǿ�ƺ�ƽ״̬{3/FCOLOR=243}��...")
        elseif buffSort == 2 then
            changemode(Target, 11, 1, 2, 2)                            --������Χ2 ����ʱ��1��
            Player.buffTipsMsg(actor, "[�������������]:ʹ[{" .. targetName .. "/FCOLOR=243}]�������״̬{1/FCOLOR=243}��...")
            Player.buffTipsMsg(Target, "[�������������]:�㱻[{" .. myName .. "/FCOLOR=243}],ʩ���˽���״̬{1/FCOLOR=243}��...")
        elseif buffSort == 3 then
            local x, y = getbaseinfo(Target, ConstCfg.gbase.x), getbaseinfo(Target, ConstCfg.gbase.y)
            rangeharm(actor, x, y, 1, 0, 1, 1, 0, 0)                   --���˶���1��  
            Player.buffTipsMsg(actor, "[�������������]:��[{" .. targetName .. "/FCOLOR=243}]����{1/FCOLOR=243}��...")
            Player.buffTipsMsg(Target, "[�������������]:�㱻[{" .. myName .. "/FCOLOR=243}]����{1/FCOLOR=243}��...")
        end
    end
end


--����ҫ������������ӡ���һ𽣷�3S  ���������ʣ�100%   CD:30S��  31087 ����ҫ����ӡ�һ�CD   31088����ҫ��Buff��ʱCD
ZhuangBeiBuffList[5011] = function(actor, Target, Hiter, MagicId, Damage, Model, attackDamageData)
    local buffCD = hasbuff(actor, 31087)
    if buffCD then return end
    addbuff(actor, 31087, 30)
    addbuff(Target, 31107, 3)
    local myName = Player.GetNameEx(actor)
    local targetName = Player.GetNameEx(Target)
    Player.buffTipsMsg(actor, "[����ҫ��]:��ӡ[{" .. targetName .. "/FCOLOR=243}]�һ𽣷�{3/FCOLOR=243}��...")
    Player.buffTipsMsg(Target, "[����ҫ��]:�㱻[{" .. myName .. "/FCOLOR=243}],��ӡ�һ𽣷�{3/FCOLOR=243}��...")
end


--��������ǰ��������Ѫǰ����6000��ͷ��-----------------------------------

--1%�Թ���Ѫ ����3%Ѫ�����²���Ч
ZhuangBeiBuffList[6000] = function(actor, Target, Hiter, MagicId, Damage, Model, attackDamageData)
    if Player.canLifesteal(actor) then
        local hp = calculatePercentageResult(Damage, 1)
        humanhp(actor, "+", hp)
    end
end
-- �硤��[��֪] �⡤��[����] �桤��[��ҫ]  5%�Թ���Ѫ ����3%Ѫ�����²���Ч
ZhuangBeiBuffList[6001] = function(actor, Target, Hiter, MagicId, Damage, Model, attackDamageData)
    if Player.canLifesteal(actor) then
        humanhp(actor, "+", Damage * 0.05)
    end
end

--������׹ ������Ѫ����ֱ��նɱ(10%)����ֵ (60����ֻ������һ�ε�ǰBUFF)
ZhuangBeiBuffList[6002] = function(actor, Target, Hiter, MagicId, Damage, Model, attackDamageData)
    local monname = getbaseinfo(Target, ConstCfg.gbase.name)
    if cfg_BuBeiQieGeMon[monname] then return end

    local buffCd = hasbuff(actor, 30002)
    local tgtcurhp = Player.getHpPercentage(Target)
    if not buffCd and tgtcurhp >= 99 then
        addbuff(actor, 30002, 60, 1, actor) --���CD
        humanhp(Target, "-", Player.getHpValue(Target, 10), 106)
        Player.buffTipsMsg(actor, "[������׹]:�и����{10%/FCOLOR=243}]���Ѫ��...")
    end
end
-- ��������֮���� ÿ�����Թ������[2.0��]�Թ��и�
ZhuangBeiBuffList[6003] = function(actor, Target, Hiter, MagicId, Damage, Model, attackDamageData)
    local monname = getbaseinfo(Target, ConstCfg.gbase.name)
    if cfg_BuBeiQieGeMon[monname] then return end

    local daoshunum = getplaydef(actor, VarCfg["N$_��������"])
    if daoshunum >= 3 then
        humanhp(Target, "-", Damage * 2, 106, 0, actor)
        -- Player.buffTipsMsg(actor, "[����������־��]:�и����[{" .. Damage * 2 .. "/FCOLOR=243}]����...")
        setplaydef(actor, VarCfg["N$_��������"], 0) --������0
    else
        setplaydef(actor, VarCfg["N$_��������"], daoshunum + 1) --������1
    end
end
--�¹�ӡ��  ÿ��ɱһֻ�����ۻ�һ��[�¹�ӡ��]�ۻ���50�������[10]���и��˺�(23��-08��ʱ�������˺�Ϊ30��)
ZhuangBeiBuffList[6004] = function(actor, Target, Hiter, MagicId, Damage, Model, attackDamageData)
    local _KillMonNum = getplaydef(actor, VarCfg["U_ɱ����������"])
    if _KillMonNum >= 50 then
        local nowtime = checktimeInPeriod(23, 0, 8, 0)
        local qiege = getbaseinfo(actor, ConstCfg.gbase.custom_attr, 200)
        if nowtime then
            humanhp(Target, "-", qiege * 30, 106, 0, actor) --30��
            Player.buffTipsMsg(actor, "[�¹�ӡ��]:�Թ������[{" .. qiege * 30 .. "/FCOLOR=243}]��ʵ�˺�...")
        else
            humanhp(Target, "-", qiege * 10, 106, 0, actor) --10��
            Player.buffTipsMsg(actor, "[�¹�ӡ��]:�Թ������[{" .. qiege * 10 .. "/FCOLOR=243}]��ʵ�˺�...")
        end
        setplaydef(actor, VarCfg["U_ɱ����������"], 0)
    end
end
--���ս����ս� ����Ŀ��ʱ������ȡĿ������ֵ ÿ(18)�ι���նɱ���ﵱǰ5%����ֵ
ZhuangBeiBuffList[6005] = function(actor, Target, Hiter, MagicId, Damage, Model, attackDamageData)
    local monname = getbaseinfo(Target, ConstCfg.gbase.name)
    if cfg_BuBeiQieGeMon[monname] then return end
    local daoshunum = getplaydef(actor, VarCfg["N$_�սᵶ��"])
    if daoshunum >= 18 then
        humanhp(Target, "-", Player.getHpValue(Target, 5), 106, 0, actor)
        Player.buffTipsMsg(actor, "[���ս����ս�]:�Թ���նɱ[{5%/FCOLOR=243}]���Ѫ��...")
        setplaydef(actor, VarCfg["N$_�սᵶ��"], 0) --������0
    else
        setplaydef(actor, VarCfg["N$_�սᵶ��"], daoshunum + 1) --������1
    end
    if Player.canLifesteal(actor) then
        humanhp(actor, "+", Damage * 0.05)
    end
end
--������� նɱѪ������[10%]�Ĺ���[CD:15S]
ZhuangBeiBuffList[6006] = function(actor, Target, Hiter, MagicId, Damage, Model, attackDamageData)
    local monname = getbaseinfo(Target, ConstCfg.gbase.name)
    if cfg_BuBeiQieGeMon[monname] then return end

    local buffcd = hasbuff(actor, 30008)
    if not buffcd then
        local nowmonhp = Player.getHpPercentage(Target)
        if nowmonhp <= 10 then
            killmonbyobj(actor, Target, true, true, true) --ɱ������
            addbuff(actor, 30008, 15, 1, actor)
            Player.buffTipsMsg(actor, "[�������]:����Ѫ������[{10%/FCOLOR=243}]����ֱ��նɱ...")
        end
    end
end
--����˪��  ��������ֵ����30%�Ĺ���ʱ�����и�[1%]�������ֵ��
ZhuangBeiBuffList[6007] = function(actor, Target, Hiter, MagicId, Damage, Model, attackDamageData)
    local monname = getbaseinfo(Target, ConstCfg.gbase.name)
    if cfg_BuBeiQieGeMon[monname] then return end

    local nowmonhp = Player.getHpPercentage(Target)
    if nowmonhp <= 30 then
        humanhp(Target, "-", Player.getHpValue(Target, 1), 106, 0, actor) --����նѪ1%
    end
end
--����֮�С�����  ����Ŀ��ʱ������ȡĿ������ֵ
ZhuangBeiBuffList[6008] = function(actor, Target, Hiter, MagicId, Damage, Model, attackDamageData)
    if Player.canLifesteal(actor) then
        humanhp(actor, "+", Damage * 0.05)
    end
end
--��ͷ̨ նɱ����ֵ����[10%]Ŀ��(CD30��)
ZhuangBeiBuffList[6009] = function(actor, Target, Hiter, MagicId, Damage, Model, attackDamageData)
    local monname = getbaseinfo(Target, ConstCfg.gbase.name)
    if cfg_BuBeiQieGeMon[monname] then return end

    local buffcd = hasbuff(actor, 30036)
    if not buffcd then
        local nowmonhp = Player.getHpPercentage(Target)
        if nowmonhp <= 10 then
            killmonbyobj(actor, Target, true, true, true) --ɱ������
            addbuff(actor, 30036, 30, 1, actor)
            Player.buffTipsMsg(actor, "[��ͷ̨]:����Ѫ������10%,����ֱ��նɱ...")
        end
    end
end
--������֮��  ����Ŀ��ʱ������ȡĿ������ֵ ����������+ 10%
ZhuangBeiBuffList[6010] = function(actor, Target, Hiter, MagicId, Damage, Model, attackDamageData)
    if Player.canLifesteal(actor) then
        humanhp(actor, "+", Damage * 0.05, 4)
    end
end
--����ȭ��  ÿ�ι�������ʱ����[10%]�����˺� ��Ч������ʮ�κ󴥷�����Ч������ (Ч���������Ҫ�������µ���BUFF)
ZhuangBeiBuffList[6011] = function(actor, Target, Hiter, MagicId, Damage, Model, attackDamageData)
    local daoshunum = getplaydef(actor, VarCfg["N$_��ȭ����"])
    attackDamageData.damage = attackDamageData.damage + Damage * ((daoshunum + 1) / 10)
    setplaydef(actor, VarCfg["N$_��ȭ����"], daoshunum + 1) --������0
    if daoshunum >= 9 then
        setplaydef(actor, VarCfg["N$_��ȭ����"], 0) --������0
    end
end
--�����ѹ������� ����Ŀ��ʱ������ȡĿ������ֵ ����ʱ�и������[700%]�ĶԹ��и�
ZhuangBeiBuffList[6012] = function(actor, Target, Hiter, MagicId, Damage, Model, attackDamageData)
    if Player.canLifesteal(actor) then
        humanhp(actor, "+", Damage * 0.05, 4)
    end

    if randomex(1, 128) then
        local attnum = getbaseinfo(actor, ConstCfg.gbase.dc2)
        humanhp(Target, "-", attnum * 7, 106, 0, actor) --�и���� ����7���������˺�
    end
end

--Ԧ���ߡ����� ����Ŀ��ʱ������ȡĿ������ֵ ����ʱ�и���նɱ����[1.5%]����ֵ 1/100 ����
ZhuangBeiBuffList[6013] = function(actor, Target, Hiter, MagicId, Damage, Model, attackDamageData)
    if Player.canLifesteal(actor) then
        humanhp(actor, "+", Damage * 0.05)
    end
    if randomex(1, 100) then
        humanhp(Target, "-", Player.getHpValue(Target, 1.5), 106, 0, actor)
    end
end

--����һָ ����ʱ�и��ʴ���[����һָ]ֱ��ն ɱĿ��[100%]���������ֵ�� 1/588
ZhuangBeiBuffList[6014] = function(actor, Target, Hiter, MagicId, Damage, Model, attackDamageData)
    local monname = getbaseinfo(Target, ConstCfg.gbase.name)
    if cfg_BuBeiQieGeMon[monname] then return end
    if randomex(1, 588) then
        killmonbyobj(actor, Target, true, true, true) --ɱ������
    end
end

--���� �Թ���Ѫ5%
ZhuangBeiBuffList[6015] = function(actor, Target, Hiter, MagicId, Damage, Model, attackDamageData)
    if Player.canLifesteal(actor) then
        humanhp(actor, "+", Damage * 0.05)
    end
end

-- �ʵ���׹    �ͷſ�����´��˺�����20%
ZhuangBeiBuffList[6016] = function(actor, Target, Hiter, MagicId, Damage, Model, attackDamageData)
    if MagicId == 26 or MagicId == 66 or MagicId == 56 then
        setplaydef(actor, VarCfg["S$_�ʵ���׹"], "���ͷ�")
    end
    if getplaydef(actor, VarCfg["S$_�ʵ���׹"]) == "���ͷ�" then
        attackDamageData.damage = attackDamageData.damage + Damage * 0.2
        setplaydef(actor, VarCfg["S$_�ʵ���׹"], "")
    end
end

-- �ո���   ����20WѪ�����ڵĹ��1/88�����и����8%�ĵ�����ֵ
ZhuangBeiBuffList[6017] = function(actor, Target, Hiter, MagicId, Damage, Model, attackDamageData)
    local HpMax = getbaseinfo(Target, ConstCfg.gbase.maxhp)
    if HpMax <= 200000 then
        if randomex(1, 88) then
            local num = math.random(1, 8)
            humanhp(Target, "-", Player.getHpValue(Target, num), 106, 0, actor)
        end
    end
end

--����֮׹  ��������ͬһĿ��7��,���������һ��,��ɵ���*300%�ĸ����˺�
ZhuangBeiBuffList[6018] = function(actor, Target, Hiter, MagicId, Damage, Model, attackDamageData)
    local objList = Player.getJsonTableByVar(actor, VarCfg["S$����֮׹����"])
    table.insert(objList, Target)
    local objNum = 0
    if #objList < 4 then
        objNum = getplaydef(actor,VarCfg["N$����֮׹����"])
        objNum = objNum + 1
        setplaydef(actor, VarCfg["N$����֮׹����"], objNum)
    else
        setplaydef(actor, VarCfg["S$����֮׹����"], "")
        setplaydef(actor, VarCfg["N$����֮׹����"], 0)
        return
    end
    if objNum == 7 then
        local ScMax = getbaseinfo(actor, ConstCfg.gbase.sc2)
        humanhp(Target, "-", ScMax * 3, 106, 0, actor) --��ɵ���*300%���˺�
        setplaydef(actor, VarCfg["N$����֮׹����"], 0)
    end
end


-- �����׵�������|�������������   "�Թ��˺���ֵ�������֮һ �������100%   10%�����и����1%Ѫ�� ����Ѫ������40%ʱʧЧ"
ZhuangBeiBuffList[6019] = function(actor, Target, Hiter, MagicId, Damage, Model, attackDamageData)

    local monname = getbaseinfo(Target, ConstCfg.gbase.name)
    if cfg_BuBeiQieGeMon[monname] then return end
    local Num = math.random(33, 100)
    attackDamageData = attackDamageData.damage + Damage * Num
    if randomex(1, 10) then
        local tgtplayhp = Player.getHpPercentage(Target)
        if tgtplayhp >= 40 then
            humanhp(Target, "-", Player.getHpValue(Target, 1), 106, 0, actor) --նɱĿ��ʣ��Ѫ��
        end
    end
end

--ħ�С��ɻ�(A)       նɱ����ֵ����[2%]��Ŀ��(CD10��)
ZhuangBeiBuffList[6020] = function(actor, Target, Hiter, MagicId, Damage, Model, attackDamageData)
    local monname = getbaseinfo(Target, ConstCfg.gbase.name)
    if cfg_BuBeiQieGeMon[monname] then return end
    local nowmonhp = Player.getHpPercentage(Target)
    if nowmonhp <= 2 then
        if Player.checkCd(actor, VarCfg["N$ħ��նɱCD"], 10, false) then
            killmonbyobj(actor, Target, true, true, true) --ɱ������
            Player.buffTipsMsg(actor, "[ħ�С��ɻ�]:նɱѪ������[{2%/FCOLOR=243}]�Ĺ���...")
        end
    end
end

--ħ�С��ɻ�(S)       նɱ����ֵ����[3%]��Ŀ��(CD10��)
ZhuangBeiBuffList[6021] = function(actor, Target, Hiter, MagicId, Damage, Model, attackDamageData)
    local monname = getbaseinfo(Target, ConstCfg.gbase.name)
    if cfg_BuBeiQieGeMon[monname] then return end
    local nowmonhp = Player.getHpPercentage(Target)
    if nowmonhp <= 3 then
        if Player.checkCd(actor, VarCfg["N$ħ��նɱCD"], 10, false) then
            killmonbyobj(actor, Target, true, true, true) --ɱ������
            Player.buffTipsMsg(actor, "[ħ�С��ɻ�]:նɱѪ������[{3%/FCOLOR=243}]�Ĺ���...")
        end
    end
end

--ħ�С��ɻ�(SR)      նɱ����ֵ����[4%]��Ŀ��(CD10��)
ZhuangBeiBuffList[6022] = function(actor, Target, Hiter, MagicId, Damage, Model, attackDamageData)
    local monname = getbaseinfo(Target, ConstCfg.gbase.name)
    if cfg_BuBeiQieGeMon[monname] then return end
    local nowmonhp = Player.getHpPercentage(Target)
    if nowmonhp <= 4 then
        if Player.checkCd(actor, VarCfg["N$ħ��նɱCD"], 10, false) then
            killmonbyobj(actor, Target, true, true, true) --ɱ������
            Player.buffTipsMsg(actor, "[ħ�С��ɻ�]:նɱѪ������[{4%/FCOLOR=243}]�Ĺ���...")
        end
    end
end

--ħ�С��ɻ�(SSR)     նɱ����ֵ����[5%]��Ŀ��(CD10��)
ZhuangBeiBuffList[6023] = function(actor, Target, Hiter, MagicId, Damage, Model, attackDamageData)
    local monname = getbaseinfo(Target, ConstCfg.gbase.name)
    if cfg_BuBeiQieGeMon[monname] then return end
    local nowmonhp = Player.getHpPercentage(Target)
    if nowmonhp <= 5 then
        if Player.checkCd(actor, VarCfg["N$ħ��նɱCD"], 10, false) then
            killmonbyobj(actor, Target, true, true, true) --ɱ������
            Player.buffTipsMsg(actor, "[ħ�С��ɻ�]:նɱѪ������[{5%/FCOLOR=243}]�Ĺ���...")
        end
    end
end

--ħ�С��ɻ�(SSSR)    նɱ����ֵ����[10%]��Ŀ��(CD10��)
ZhuangBeiBuffList[6024] = function(actor, Target, Hiter, MagicId, Damage, Model, attackDamageData)
    local monname = getbaseinfo(Target, ConstCfg.gbase.name)
    if cfg_BuBeiQieGeMon[monname] then return end
    local nowmonhp = Player.getHpPercentage(Target)
    if nowmonhp <= 10 then
        if Player.checkCd(actor, VarCfg["N$ħ��նɱCD"], 10, false) then
            killmonbyobj(actor, Target, true, true, true) --ɱ������
            Player.buffTipsMsg(actor, "[ħ�С��ɻ�]:նɱѪ������[{10%/FCOLOR=243}]�Ĺ���...")
        end
    end
end


--��ȫ������������7000��ͷ��-----------------------------------
--����Ӱ֮�� ��������ֵ����(50%)��ʱ���˲��ָ�����[15%]�������ֵ(CD60��)
ZhuangBeiBuffList[7000] = function(actor, Target, Hiter, MagicId)
    local tgtcurhp = Player.getHpPercentage(actor)
    if tgtcurhp >= 50 then return end
    local buffCd = hasbuff(actor, 30003)
    if not buffCd then
        addhpper(actor, "+", 15)
        addbuff(actor, 30003, 60, 1, actor) --���CD
        Player.buffTipsMsg(actor, "[����Ӱ֮��]��BUFF�������㵱ǰ����Ѫ������50%���Ѿ��ָ���15%������ֵ��")
    end
end
--����֮�� ������ʱ�и��ʻָ�[10%]������ֵ (30����ֻ������һ�ε�ǰBUFF)
ZhuangBeiBuffList[7001] = function(actor, Target, Hiter, MagicId)
    if randomex(10, 100) then
        local buffCd = hasbuff(actor, 30004)
        if not buffCd then
            addhpper(actor, "+", 10)
            addbuff(actor, 30004, 30, 1, actor) --���CD
            Player.buffTipsMsg(actor, "[����֮��]��BUFF�������ָ�10%���Ѫ��...")
        end
    end
end

--ҹ��֮�� ����ֵ����(20%)ʱ����BUFF����1��ָ�����(100%)����ֵ[CD��120��]
ZhuangBeiBuffList[7002] = function(actor, Target, Hiter, MagicId)
    local myhp = Player.getHpPercentage(actor)
    if myhp >= 20 then return end
    if not Player.checkCd(actor, VarCfg["����CD"], 60, true) then return end

    local buffid = hasbuff(actor, 30005)
    if not buffid then
        changemode(actor, 2, 1)                               --����1����
        humanhp(actor, "+", Player.getHpValue(actor, 100), 4) --�ָ�100%Ѫ��
        addbuff(actor, 30005, 120, 1, actor)                  --���CD
        Player.buffTipsMsg(actor, "[ҹ��֮��]��BUFF�������㵱ǰ����ֵ����20%���Ѿ��ָ���100%...")
    end
end

--������� ʩ�ſ���ն֮���´ι����ض������ [3.0]���ĶԹ��и�[CD:60��]
ZhuangBeiBuffList[7003] = function(actor, Target, Hiter, MagicId)
    local tgtcurhp = Player.getHpPercentage(actor)
    if tgtcurhp <= 20 then
        local buffcd = hasbuff(actor, 30014)
        if not buffcd then
            humanhp(actor, "+", Player.getHpValue(actor, 100), 4, nil, nil, nil) --�ָ�100%Ѫ��
            addbuff(actor, 30014, 30, 1, actor)
        end
    end
end
--��� ÿ2���ӱض�����һ��[��������]�ɵֵ�һ��Ŀ��ļ����˺������ܱ����ƺ���ٻ��׽ٽ��٣��Ի��ƻ��ܵ�Ŀ�����[20%]�������ֵ���˺�!
ZhuangBeiBuffList[7004] = function(actor, Target, Hiter, MagicId)
    if getplaydef(actor, VarCfg["S$_���״̬"]) == "1" then --�����´��˺�����
        local x, y = getbaseinfo(Target, ConstCfg.gbase.x), getbaseinfo(Target, ConstCfg.gbase.y)
        setplaydef(actor, VarCfg["S$_���״̬"], "")
        rangeharm(actor, x, y, 1, 0, 12, 20, 0, 0, 56) -- ����1��
        clearplayeffect(actor, 16016)                  --ɾ����Ч
        addbuff(actor, 30080)                          --��Ӽ�ʱbuff
    end
end

--�ź��䡤���������� �����������ֵ����(50%)ʱ����ÿ��ָ�[3%]����ֵ������(10%)��������(��Ѫ��BUFFЧ������10S��CD120��)
ZhuangBeiBuffList[7005] = function(actor, Target, Hiter, MagicId)
    local myhp = Player.getHpPercentage(actor)
    if myhp <= 50 then
        local buff = hasbuff(actor, 30100)
        if not buff then
            addbuff(actor, 30100, 10, 1, actor)
            Player.buffTipsMsg(actor, "[�ź��䡤����������]����{10%/FCOLOR=243}�������޲�ÿ��ָ�{3%/FCOLOR=243}���Ѫ��,����{10/FCOLOR=243}��...")
        end
    end
end

--����֮ŭ PKʱ����ֵ����[10%]ʱ�������������(5*5)��Χ�ڵ��������㣡�һָ�����(30%)���������ֵ��CD:60��
ZhuangBeiBuffList[7006] = function(actor, Target, Hiter, MagicId)
    local myhp = Player.getHpPercentage(actor)
    if myhp <= 10 then
        local buff = hasbuff(actor, 30101)
        if not buff then
            local selfx = getbaseinfo(actor, ConstCfg.gbase.x)
            local selfy = getbaseinfo(actor, ConstCfg.gbase.y)
            local mapid = getbaseinfo(actor, ConstCfg.gbase.mapid)
            mapmove(actor, mapid, selfx, selfy, 10) -- ������
            addhpper(actor, "+", 30)                -- �ָ�10%����
            addbuff(actor, 30101, 60, 1, actor)
            Player.buffTipsMsg(actor, "[����֮ŭ]:����{5x5/FCOLOR=243}��Χ�����㲢�ָ�{30%/FCOLOR=243}Ѫ��...")
        end
    end
end

--���˹���������8000��ͷ��-----------------------------------

--ҹɫɱ������ �����﹥��ʱ�и��ʶ���Ŀ��[2��]
ZhuangBeiBuffList[8000] = function(actor, Target, Hiter, MagicId)
    if randomex(1, 88) then
        local tgtx = getbaseinfo(Target, ConstCfg.gbase.x)
        local tgty = getbaseinfo(Target, ConstCfg.gbase.y)
        rangeharm(actor, tgtx, tgty, 1, 1, 10, 2000, 0, 1)
        local myName = Player.GetNameEx(actor)
        local targetName = Player.GetNameEx(Target)
        Player.buffTipsMsg(actor, "[ҹɫɱ������]:�㽫[{" .. targetName .. "/FCOLOR=243}]����2��...")
        Player.buffTipsMsg(Target, "[ҹɫɱ������]:�㱻[{" .. myName .. "/FCOLOR=243}],����2��...")
    end
end

--ҹ��֮�� �ܵ�����ն�˺�ʱ   ���ʽ�������״̬1�� 1/128
ZhuangBeiBuffList[8001] = function(actor, Target, Hiter, MagicId)
    if not Player.checkCd(actor, VarCfg["����CD"], 60, true) then return end
    if MagicId == 66 then
        if randomex(1,128) then
            changemode(actor, 2, 1)                               --����1����
        end
    end
end

--�̡�����֮�� ������ʱ,5%���ʼ�������20%���٣�����5S
ZhuangBeiBuffList[8002] = function(actor, Target, Hiter, MagicId)
    if randomex(5, 100) then
        local tgtBuff = hasbuff(Target, 31086)
        if tgtBuff then return end
        addbuff(Target, 31086, 5)
        Player.setAttList(Target, "���ٸ���")
    end
end

--ҥӰ������ �ܵ�����������չ���ʱ,25%���ʻָ�20%Ѫ��
ZhuangBeiBuffList[8003] = function(actor, Target, Hiter, MagicId)
    if MagicId == 66 or MagicId == 56   then
        if randomex(1,4) then
            humanhp(actor, "+", Player.getHpValue(actor, 20), 4)         --�ָ����������20%Ѫ��
        end
    end
end
--�����﹥��������9000��ͷ��-----------------------------------
--��ȫ����������--ǰ��10000��ͷ��-----------------------------------

--ӽ̾����[��]  ������ʱ�и߸��ʷ���(50%)���˺����ָ�����[50%]������ֵ 1/10���� 120SCD
ZhuangBeiBuffList[10000] = function(actor, Target, Hiter, MagicId, Damage, attackDamageData)
    local buff = hasbuff(actor, 31070)
    if buff then return end
    if randomex(1, 10) then
        addbuff(actor, 31070, 120)
        local targetX = getbaseinfo(Target, ConstCfg.gbase.x)
        local targetY = getbaseinfo(Target, ConstCfg.gbase.y)
        rangeharm(actor, targetX, targetY, 1, 0, 6, Damage * 0.5, 0) --�����ܵ��˺���50%����ʵ�˺���
        humanhp(actor, "+", Player.getHpValue(actor, 50), 4)         --�ָ����������50%Ѫ��
        local myName = Player.GetNameEx(actor)
        local targetName = Player.GetNameEx(Target)
        Player.buffTipsMsg(actor, "[ӽ̾����]:���[{" .. targetName .. "/FCOLOR=243}]������50%�˺�...")
        Player.buffTipsMsg(Target, "[ӽ̾����]:�㱻[{" .. myName .. "/FCOLOR=243}]������50%�˺�...")
    end
end
--���溮��(��)  ����ֵ����[30%]ʱ�����޵�״̬1�� ���һָ�����(100%)���������ֵ�� [CD150��]
ZhuangBeiBuffList[10001] = function(actor, Target, Hiter, MagicId, Damage, attackDamageData)
    local calculate = Player.getHpPercentage(actor)
    if calculate <= 30 then
        if Player.checkCd(actor, VarCfg["���溮��CD"], 180, true) then
            -- humanhp(actor, "+", Player.getHpValue(actor, 100), 4) --�ָ����������100%Ѫ��
            changemode(actor, 1, 1)                               --�޵�1��
        end
    end
end
--���֮ѥ  ������ʱ�и��ʻָ�[10%]������ֵ (30����ֻ������һ�ε�ǰBUFF) 1/100 ����
ZhuangBeiBuffList[10002] = function(actor, Target, Hiter, MagicId, Damage, attackDamageData)
    if randomex(1, 100) then
        local buffcd = hasbuff(actor, 30027)
        if not buffcd then
            humanhp(actor, "+", Player.getHpValue(actor, 10), 4) --�ָ����������10%Ѫ��
            Player.buffTipsMsg(actor, "[���֮ѥ]:�ָ�[{10%/FCOLOR=243}Ѫ��...")
        end
    end
end
--����֮̾Ϣ��  ����󴥷��������[����״̬10��]�˺�     ����[+20%],�������ֵ[+30%] ֮������޵�״̬1��(����CD180��)
ZhuangBeiBuffList[10003] = function(actor, Target, Hiter, MagicId, Damage, attackDamageData)
    local buff = hasbuff(actor, 30034)
    if buff then
        attackDamageData.damage = attackDamageData.damage + Damage * 0.2
    end
end
--����֮��(��ʥ) ����������ֵ����[20%]ʱ�������� ����[2*2��Χ]�ڵ�Ŀ��1S(CD60��)
ZhuangBeiBuffList[10004] = function(actor, Target, Hiter, MagicId, Damage, attackDamageData)
    local calculate = Player.getHpPercentage(actor)
    if calculate <= 20 then
        local buffcd = hasbuff(actor, 30037)
        if not buffcd then
            local x, y = getbaseinfo(actor, ConstCfg.gbase.x), getbaseinfo(actor, ConstCfg.gbase.y)
            rangeharm(actor, x, y, 2, 0, 2, 1, 1, 0, 20500) -- ����2*2��Χ�ڵ���1��
            playsound(actor, 100001, 1, 0)                  --���ű�����Ч
            local myName = Player.GetNameEx(actor)
            local targetName = Player.GetNameEx(Target)
            Player.buffTipsMsg(actor, "[����֮��(��ʥ)]:�������Ŀ��[{" .. targetName .. "/FCOLOR=243}],����1S...")
            Player.buffTipsMsg(Target, "[����֮��(��ʥ)]:�㱻[{" .. myName .. "/FCOLOR=243}]������,����1S...")
            addbuff(actor, 30037, 60, 1, actor)
        end
    end
end
--��Ȼ֮����Ԫ������ ������ʱ�и��ʷ���50%�˺�,���ָ�����50%���� 1/10
ZhuangBeiBuffList[10005] = function(actor, Target, Hiter, MagicId, Damage, attackDamageData)
    if randomex(1, 10) then
        local num = math.floor(Damage * 0.5)
        humanhp(Target, "-", num, 1, 0, actor) --�����ܵ��˺���50%����ʵ�˺���
        humanhp(actor, "+", num, 4)  --�ָ����������50%Ѫ��
        Player.buffTipsMsg(actor, "[��Ȼ֮����Ԫ������]:��������{" .. num .. "/FCOLOR=243}�˺����ָ�{" .. num .. "/FCOLOR=243}������...")
    end
end
--����Ӱ����ӡ֮�� Ѫ������(30%)ʱ�ָ�����[50%]Ѫ�������ƿ���Χ�����������(CD60��)
ZhuangBeiBuffList[10006] = function(actor, Target, Hiter, MagicId, Damage, attackDamageData)
    local calculate = Player.getHpPercentage(actor)
    if calculate <= 30 then
        local buffCd = hasbuff(actor, 30042)
        if not buffCd then
            local x, y = getbaseinfo(actor, ConstCfg.gbase.x), getbaseinfo(actor, ConstCfg.gbase.y)
            humanhp(actor, "+", Player.getHpValue(actor, 50), 1) --�ָ����������0%Ѫ��
            rangeharm(actor, x, y, 3, 0, 1, 3, 0, 0)             -- �ƶ�3��
            addbuff(actor, 30042, 60, 1, actor)                  --���CD
        end
    end
end
--����֮Ӱ ������ʱ�и��ʷ���[30%]�����˺� 1/10 ����
ZhuangBeiBuffList[10007] = function(actor, Target, Hiter, MagicId, Damage, attackDamageData)
    if randomex(1, 20) then
        humanhp(Target, "-", Damage * 0.3, 1, 0, actor) --�����˺�30%
        Player.buffTipsMsg(actor, "[����֮Ӱ]:��������{30%/FCOLOR=243}�˺�...")
    end
end
--ʱ���� ��������ֵ����(30%)������Ѫ״̬(BUFFЧ������2�롤BUFF��ȴ120S)
ZhuangBeiBuffList[10008] = function(actor, Target, Hiter, MagicId, Damage, attackDamageData)
    local calculate = Player.getHpPercentage(actor)
    if calculate <= 30 then
        local buffcd = hasbuff(actor, 30050)
        if not buffcd then
            changemode(actor, 1, 2) --�޵�2��
            addbuff(actor, 30050, 120, 1, actor)
            Player.buffTipsMsg(actor, "[ʱ����]:����{��Ѫ/FCOLOR=243}״̬����{2/FCOLOR=243}��...")
        end
    end
end
--�ֻ�ɳ© ������ֵ�ﵽ(50%)ʱ�ָ�����[40%] ���������ֵ��(BUFF��ȴ60��)
ZhuangBeiBuffList[10009] = function(actor, Target, Hiter, MagicId, Damage, attackDamageData)
    local calculate = Player.getHpPercentage(actor)
    if calculate <= 50 then
        local buff = hasbuff(actor, 30051)
        if not buff then
            humanhp(actor, "+", Player.getHpValue(actor, 40), 1, nil, nil, nil) --�ָ����������40%Ѫ��
            addbuff(actor, 30051, 60, 1, actor)
            Player.buffTipsMsg(actor, "[�ֻ�ɳ©]:�ָ�{40%/FCOLOR=243}���Ѫ��...")
        end
    end
end
--����֮ѥ ������ʱ�и��ʴ����޵�״̬(1��) 1/188 ����
ZhuangBeiBuffList[10010] = function(actor, Target, Hiter, MagicId, Damage, attackDamageData)
    if randomex(1, 188) then
        changemode(actor, 1, 1) --�޵�1��
        Player.buffTipsMsg(actor, "[����֮ѥ]:�����޵�{1/FCOLOR=243}��...")
    end
end

--�������� ����CD��Ѫ������[20%]��������Ч������������100%�˺��� CD 10��
ZhuangBeiBuffList[10011] = function(actor, Target, Hiter, MagicId, Damage, attackDamageData)
    local bool = ReliveMain.GetReliveState(actor)
    if ReliveMain.GetReliveState(actor) then return end -- ������
    local calculate = Player.getHpPercentage(actor)
    if calculate <= 20 then
        local buff = hasbuff(actor, 30065)
        if not buff then
            changemode(actor, 19, 10, 10)
            addbuff(actor, 30065, 30, 1, actor)
            Player.buffTipsMsg(actor, "[��������]:�����Ч������10��...")
        end
    end
end

--������ �����˺�ʱ����1/128 ����50%�������ҹ�������ʱ ����������50%�и� 1/108
ZhuangBeiBuffList[10012] = function(actor, Target, Hiter, MagicId, Damage, attackDamageData)
    if randomex(1, 128) then
        addbuff(actor, 30030, 30, 1, actor)
        Player.buffTipsMsg(actor, "[������]:����������[{50%/FCOLOR=243}]�ҹ�������������[{50%/FCOLOR=243}]�ĶԹ��и����[{30/FCOLOR=243}]��...")
    end
    local buff = hasbuff(actor, 30030)
    if not buff then
        local fangyu = getbaseinfo(actor, ConstCfg.gbase.ac2)
        humanhp(Target, "-", fangyu * 0.5, 106, 0, actor) --նɱ����  ������50%���˺�
    end
end

--����ͼ�کg �һ������ռ���5%
ZhuangBeiBuffList[10013] = function(actor, Target, Hiter, MagicId, Damage, attackDamageData)
    if MagicId == 26 or MagicId == 66 or MagicId == 56 then
        attackDamageData.damage = attackDamageData.damage - Damage * 0.05
    end
end

--����֮�� �һ������ռ���15%
ZhuangBeiBuffList[10014] = function(actor, Target, Hiter, MagicId, Damage, attackDamageData)
    if MagicId == 26 or MagicId == 66 or MagicId == 56 then
        attackDamageData.damage = attackDamageData.damage - Damage * 0.15
    end
end

--������ �һ������ռ���10%
ZhuangBeiBuffList[10015] = function(actor, Target, Hiter, MagicId, Damage, attackDamageData)
    if MagicId == 26 or MagicId == 66 or MagicId == 56 then
        attackDamageData.damage = attackDamageData.damage - Damage * 0.1
    end
end

--�ǻԵĵ���T  8%���ʸ�һ���˺�
ZhuangBeiBuffList[10016] = function(actor, Target, Hiter, MagicId, Damage, attackDamageData)
    if randomex(8, 100) then
        setplaydef(actor,VarCfg["S$�ǻԵĵ���"],"��")
    end
end

--ԭ�������ҡ� ����Ѫ������50%ʱ�ܵ������˺� ��5%���ʻָ���50%Ѫ��  
ZhuangBeiBuffList[10017] = function(actor, Target, Hiter, MagicId, Damage, attackDamageData)
    local calculate = Player.getHpPercentage(actor)
    if calculate <= 50 then
        if randomex(5, 100) then
            humanhp(actor, "=", Player.getHpValue(actor, 50), 1) --�ָ�������50%Ѫ��
        end
    end
end




--����ҹ�������--ǰ��11000��ͷ��-----------------------------------
-- ����֮�� PKʱ����ֵ����[10%]ʱ�������������(5*5)��Χ�ڵ��������㣡[CD:20S]
ZhuangBeiBuffList[11000] = function(actor, Target, Hiter, MagicId, Damage, attackDamageData)
    local calculate = Player.getHpPercentage(actor)
    if calculate <= 10 then
        local buffCd = hasbuff(actor, 30007)
        if not buffCd then
            local selfx = getbaseinfo(actor, ConstCfg.gbase.x)
            local selfy = getbaseinfo(actor, ConstCfg.gbase.y)
            local mapid = getbaseinfo(actor, ConstCfg.gbase.mapid)
            mapmove(actor, mapid, selfx, selfy, 10)
            addbuff(actor, 30007, 20, 1, actor)
            Player.buffTipsMsg(actor, "[����֮��]:�㴥����5*5��Χ��������...")
            Player.buffTipsMsg(Target, "[����֮��]:�Է�������5*5��Χ��������...")
        end
    end
end
--����  ��������ֵ����(15%)��ʱ���˲�� �ָ�����[55%]�������ֵ(CD120S)
ZhuangBeiBuffList[11001] = function(actor, Target, Hiter, MagicId, Damage, attackDamageData)
    local calculate = Player.getHpPercentage(actor)
    if calculate > 3 and calculate < 15 then --����3%С��15%
        local buffcd = hasbuff(actor, 30016)
        if not buffcd then
            humanhp(actor, "+", Player.getHpValue(actor, 55), 4) --�ָ����Ѫ��55%
            addbuff(actor, 30016, 120, 1, actor)
            Player.buffTipsMsg(actor, "[����]:˲��ָ�[{55%/FCOLOR=243}]����Ѫ��...")
        end
    end
end
--����ѹ��Ѫɫ���  ������ʱ�������ֵ����50%�ᴥ��[Ѫɫ���]����(5��)ͬʱ��������(50%��󹥻���)!�ڽ��ĳ���ʱ���ڶ����޷��뿪��緶Χ��(CD60��)
ZhuangBeiBuffList[11002] = function(actor, Target, Hiter, MagicId, Damage, attackDamageData)
    local calculate = Player.getHpPercentage(actor)
    if calculate < 50 then --����3%С��15%
        local buffcd = hasbuff(actor, 30056)
        if not buffcd then
            changehumnewvalue(actor, 210, 50, 5) --����50%������ ����5��
            changemode(Target, 11, 5, 3, 2)      --������Χ3 ����ʱ��5��
            addbuff(actor, 30056, 60, 1, actor)
            local myName = Player.GetNameEx(actor)
            local targetName = Player.GetNameEx(Target)
            Player.buffTipsMsg(actor,
                "[����ѹ��Ѫɫ���]:���{" ..
                targetName .. "/FCOLOR=243}�ͷ�{��ѹ/FCOLOR=243}״̬������{50%/FCOLOR=243}��������,����{5/FCOLOR=243}��...")
            Player.buffTipsMsg(Target, "[����ѹ��Ѫɫ���]:�㱻[{" .. myName .. "/FCOLOR=243}]�ͷ�{��ѹ/FCOLOR=243}״̬,����5S...")
        end
    end
end
--���ţ� ����ֵ����[30%]ʱ,�ɵ�����Ѫ[3%]������ѪЧ������[3��] (CD120��)
ZhuangBeiBuffList[11003] = function(actor, Target, Hiter, MagicId, Damage, attackDamageData)
    local calculate = Player.getHpPercentage(actor)
    if calculate < 30 then
        local buffcd1 = hasbuff(actor, 30058)
        local buffcd2 = hasbuff(actor, 30057)
        if not buffcd1 then
            addbuff(actor, 30057, 3, 1, actor)
            addbuff(actor, 30058, 120, 1, actor)
        end
        if buffcd2 then
            humanhp(actor, "+", Player.getHpValue(actor, 3), 4) --�ָ����Ѫ��3%
        end
    end
end

-- ���顤��ɱ ��������5%���ʽ���2��  1/128
ZhuangBeiBuffList[11004] = function(actor, Target, Hiter, MagicId, Damage, attackDamageData)
     if randomex(1, 128) then
        --����ʱ����
        local time = 2
        local myLevel = getbaseinfo(actor, ConstCfg.gbase.level)
        local targetLevel = getbaseinfo(Target, ConstCfg.gbase.level)
        if  targetLevel > myLevel then
            time = 1
        end
        changemode(Target, 11, time, 3, 2)      --������Χ3 ����ʱ��2��
        local myName = Player.GetNameEx(actor)
        local targetName = Player.GetNameEx(Target)
        Player.buffTipsMsg(actor,"[���顤��ɱ]:���{" ..targetName .. "/FCOLOR=243}�ͷ�{����/FCOLOR=243}״̬����{"..time.."/FCOLOR=243}��...")
        Player.buffTipsMsg(Target, "[���顤��ɱ]:�㱻[{" .. myName .. "/FCOLOR=243}]�ͷ�{����/FCOLOR=243}״̬,����"..time.."S...")
     end
end

--̫������������� ��ֹ�Ƹ���
ZhuangBeiBuffList[11005] = function(actor, Target, Hiter, MagicId, Damage, attackDamageData)
    --�ҵķ�ֹ�Ƹ���
    local targetTmp = gethumnewvalue(Target, 47)
    if targetTmp ~= 0 then return end --��������˸���򲻴���
    local myPreventPoFuHuo = 500
    local targetPoFuHuo = getbaseinfo(Target, ConstCfg.gbase.custom_attr, 47)
    if targetPoFuHuo > 0 then
        local finalPreventPoFuHuo = 0     --���տ۳�������
        if targetPoFuHuo < myPreventPoFuHuo then
            finalPreventPoFuHuo = targetPoFuHuo
        else
            finalPreventPoFuHuo = myPreventPoFuHuo
        end
        changehumnewvalue(Target, 47, -finalPreventPoFuHuo, 1)
        local showPoFuHuo = (finalPreventPoFuHuo * 2) / 100
        changehumnewvalue(Target, 234, -showPoFuHuo, 1)
    end
end

--�����﹥������--ǰ��12000��ͷ��-----------------------------------
return ZhuangBeiBuffList

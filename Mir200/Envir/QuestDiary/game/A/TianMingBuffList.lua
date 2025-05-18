local TianMingBuff = {}


TianMingBuff[1000] = function(actor, Target, Hiter, MagicId)
    if randomex(2) then
        makeposion(Target, 13, 3, 0, 1)
        local myName = Player.GetNameEx(actor)
        local targetName = Player.GetNameEx(Target)
        Player.buffTipsMsg(actor, "[蜘蛛侠]:你对目标[{" .. targetName .. "/FCOLOR=243}]减速了,持续3S!")
        Player.buffTipsMsg(Target, "[蜘蛛侠]:你被玩家[{" .. myName .. "/FCOLOR=243}]减速了,持续3S!")
    end
end

--攻击时3%概率召唤五雷轰顶对目标造成最大攻击60%的伤害
TianMingBuff[1001] = function(actor, Target, Hiter, MagicId)
    if randomex(3) then
        local myMaxAttackNum = getbaseinfo(actor, ConstCfg.gbase.dc2)
        local damage = math.ceil(myMaxAttackNum * 0.6)
        humanhp(Target, "-", damage, 1, nil, nil, nil)
        playeffect(Target, 15237, 0, 0, 1, 0, 0)
    end
end

--翡翠梦境 攻击有概率释放翡翠梦境：自身2*2范围内形成结界使友军每秒恢复3%最大生命值，持续5S。
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

--释放主动技能后下次攻击会额外造成30%的伤害
TianMingBuff[1004] = function(actor, Target, Hiter, MagicId)
    if getplaydef(actor, VarCfg["N$释放主动技能附加伤害"]) == 1 then
        local getDamage = tonumber(getconst(actor, "<$DAMAGEVALUE>"))
        local damage = math.ceil(getDamage * 0.3)
        if damage > 0 then
            humanhp(Target, "-", math.ceil(getDamage * 0.3), 1, nil, nil, nil)
            setplaydef(actor, VarCfg["N$释放主动技能附加伤害"], 0)
        end
    end
end

--血刀老祖
TianMingBuff[1005] = function(actor, Target, Hiter, MagicId)
    local targetHp = Player.getHpValue(Target, 3)
    humanhp(Target, "-", targetHp, 60, 0, actor)
end

--元神之力
TianMingBuff[1006] = function(actor, Target, Hiter, MagicId)
    if randomex(1,200) then
        recallself(actor, 60, 1, 120, 254)
        local selflist = clonelist(actor)
        local seflObj = selflist[#selflist]
        local myName = Player.GetNameEx(actor)
        changemonname(seflObj, myName .. "·元神")
        callscriptex(seflObj,"ChangeSpeedEX", 2, getplaydef(actor, VarCfg["U_攻击速度"]) - 100)
        Player.buffTipsMsg(actor, "[元神之力]:你召唤了自己的元神为你作战,持续为60秒!")
    end
end

--魅影 --攻击时，有1%的几率从敌人的视野里消失2秒，忽视防御+ 20%
TianMingBuff[1007] = function(actor, Target, Hiter, MagicId)
    if randomex(1,128) then
        addbuff(actor, 30086)
        Player.buffTipsMsg(actor, "[魅影]:你隐身了,忽视防御+20%,持续2秒!")
    end
end

--攻击时，2%的概率释放领域，将4*4范围在5秒内设置为禁锢区域，且自身增加20%攻击伤害。
TianMingBuff[1008] = function(actor, Target, Hiter, MagicId)
    if randomex(2) then
        addbuff(actor, 30087)
        changemode(actor, 11, 5, 4, 1)
        Player.buffTipsMsg(actor, "[神王领域]:你释放了神王领域,4*4范围设为禁锢区域,增加20%攻击伤害,持续5秒!")
    end
end
--攻击敌人有2%的概率威慑敌人，使其禁锢2S，无视等级差距。威压
TianMingBuff[1009] = function(actor, Target, Hiter, MagicId)
    if randomex(2) then
        if getbaseinfo(Target,-1) == false then
            return
        end
        local myName = Player.GetNameEx(actor)
        local targetName = Player.GetNameEx(Target)
        Player.buffTipsMsg(actor, "[威压]:你禁锢了[{" .. targetName .. "/FCOLOR=243}]2秒!")
        Player.buffTipsMsg(Target, "[威压]:你被玩家[{" .. myName .. "/FCOLOR=243}]禁锢了2秒!")
        changemode(Target, 11, 2, 1, 0)
    end
end
--攻击力+10%，每次攻击附带自身血量3%的真实伤害。
TianMingBuff[1010] = function(actor, Target, Hiter, MagicId)
    local hpPer = Player.getHpValue(actor, 3)
    if hpPer > 0 then
        humanhp(Target, "-", hpPer, 60, nil, nil, nil)
    end
end

--攻速之王 9次攻击造成一次重击
TianMingBuff[1011] = function(actor, Target, Hiter, MagicId)
    local num = getplaydef(actor,"N$攻速之王")
    setplaydef(actor,"N$攻速之王",num + 1)
    if num + 1 >= 9 then
        setplaydef(actor,"N$攻速之王",0)
        --Player.buffTipsMsg(actor, "[攻速之王]:人物每9次攻击都会对目标造成攻击X300%的重击。!")
        humanhp(Target, "-", getbaseinfo(actor,51,4)*3, 110, 0, actor)
    end
end

--垂死挣扎	复活状态不可用时刀刀恢复1%生命值
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
-- 绝世神偷 攻击玩家时，有1%的概率窃取身上1%的金币。（每次最多100W）每天最高2000W
TianMingBuff[2001] = function(actor, Target, Hiter, MagicId)
    if randomex(1) then
        -- if not hasbuff(actor, 30073) then
            -- addbuff(actor, 30073, 60)
        local currentGlod = tonumber(getplaydef(actor, VarCfg["J_天命绝世神偷金币上限"]))
        if currentGlod < 20000000 then
            local targetGold = querymoney(Target, 1)
            local gold = calculatePercentageResult(targetGold, 1)
            if gold > 0 then
                if gold > 1000000 then
                    gold = 1000000
                end
                local myName = Player.GetNameEx(actor)
                local targetName = Player.GetNameEx(Target)
                changemoney(Target, 1, "-", gold, "绝世神偷窃取金币:" .. myName, true)
                local myID = getbaseinfo(actor, ConstCfg.gbase.id)
                local targetID = getbaseinfo(Target, ConstCfg.gbase.id)
                local give = {{"金币",gold}}
                Player.giveMailByTable(myID, 1, "绝世神偷", "你偷取了玩家[" .. targetName .. "]金币:" .. gold, give)
                -- Player.giveMailByTable(targetID, 1, "绝世神偷", "你被玩家[" .. myName .. "]偷取了金币:" .. gold)
                sendmail(targetID,1,"绝世神偷", "你被玩家[" .. myName .. "]偷取了金币:" .. gold)
                setplaydef(actor, VarCfg["J_天命绝世神偷金币上限"], currentGlod + gold)
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
            Player.buffTipsMsg(actor, "[以战止战]:玩家[{" .. targetName .. "/FCOLOR=243}]被你强制和平模式3秒!")
            Player.buffTipsMsg(Target, "[以战止战]:你被玩家[{" .. myName .. "/FCOLOR=243}]强制和平模式3秒!")
            addbuff(actor, 30084)
        end
    end
end

TianMingBuff[2003] = function(actor, Target, Hiter, MagicId)
    if Player.checkCd(actor, VarCfg["空间锁定CD"], 60, true) then
        local myName = Player.GetNameEx(actor)
        local targetName = Player.GetNameEx(Target)
        if checkkuafu(actor) then
            FAddBuffKF(Target, 30089, 10)
        else
            addbuff(Target, 30089, 10)
        end
        Player.buffTipsMsg(actor, "[空间锁定]:你对玩家[{" .. targetName .. "/FCOLOR=243}]使用了空间锁定,10秒内无法回城和传送!")
        Player.buffTipsMsg(Target, "[空间锁定]:玩家[{" .. myName .. "/FCOLOR=243}]对你使用了空间锁定,10秒内无法回城和传送!!")
    end
end

TianMingBuff[2004] = function(actor, Target, Hiter, MagicId)
    if randomex(5) then
        if not Player.checkCd(actor, VarCfg["借力打力CD"], 120, true) then
            return
        end
        local targetBeiGong = tonumber(getconst(Target, "<$POWERRATE>"))
        if targetBeiGong > 1 then
            local targetRealBeiGong = (targetBeiGong - 1) * 100
            local stealBeiGong = math.ceil(targetRealBeiGong * 0.3)
            if stealBeiGong > 0 then
                setplaydef(actor, VarCfg["N$偷取倍攻"], stealBeiGong)
                --设置我的倍攻
                local myBeiGong = tonumber(getconst(actor, "<$POWERRATE>")) * 100 + stealBeiGong
                setplaydef(actor, VarCfg["N$玩家倍攻"], stealBeiGong)
                powerrate(actor, myBeiGong, 655350)
                --获取倍攻
                local currBeiGong = getconst(actor, "<$POWERRATE>")
                setplaydef(actor, VarCfg["T_倍攻"], currBeiGong)
                --延迟5秒后恢复
                delaygoto(actor, 5000, "jielidali_beigonghuifu")
                --设置对方的
                local TargetMyBeiGong = tonumber(getconst(Target, "<$POWERRATE>")) * 100 - stealBeiGong
                powerrate(Target, TargetMyBeiGong, 655350)
                local TargetCurrBeiGong = getconst(Target, "<$POWERRATE>")
                setplaydef(Target, VarCfg["T_倍攻"], TargetCurrBeiGong)
                delaygoto(Target, 5000, "jielidali_beigonghuifu")
    
                local myName = Player.GetNameEx(actor)
                local targetName = Player.GetNameEx(Target)
                Player.buffTipsMsg(actor, "[借力打力]:你偷取了玩家[{" .. targetName .. "/FCOLOR=243}]30%倍攻!")
                Player.buffTipsMsg(Target, "[借力打力]:你被玩家[{" .. myName .. "/FCOLOR=243}]偷取了30%倍攻!")
            end
        end
    end
end

TianMingBuff[3000] = function(actor, Target, Hiter, MagicId)
    if Player.canLifesteal(actor) then
        humanhp(actor, "+", 20, 4, nil, nil, nil)
    end
end
--每8刀会额外斩杀目标1%的最大生命值！（仅对怪有效）
TianMingBuff[3001] = function(actor, Target, Hiter, MagicId)
    local count = getplaydef(actor, VarCfg["N$以下克上刀数计算"])
    setplaydef(actor, VarCfg["N$以下克上刀数计算"], count + 1)
    if count >= 8 then
        setplaydef(actor, VarCfg["N$以下克上刀数计算"], 0)
        local calcHp = Player.getHpValue(Target, 1)
        humanhp(Target, "-", calcHp, 1, 0, actor)
    end
end

--攻击时对生命值低于30%的怪物额外造成75%的真实伤害
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

--攻击怪物时刀刀恢复1888点生命值
TianMingBuff[3003] = function(actor, Target, Hiter, MagicId)
    -- local nowmonhp = Player.getHpPercentage(actor)
    if Player.canLifesteal(actor) then
        humanhp(actor, "+", 1888, 4, nil, nil, nil)
    end
end
--每次攻击时都会增加人物1%的切割伤害（最高上限10%）停止攻击5秒后状态清零！
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

--攻击怪物时20%的概率释放剑刃风暴，10%概率释放冰霜新星。
TianMingBuff[3005] = function(actor, Target, Hiter, MagicId, qieGe)
    if not qieGe then
        return
    end
    --剑刃风暴
    if randomex(5) then
        if not hasbuff(actor, 30076) then
            addbuff(actor, 30075)
            addbuff(actor, 30076)
        end
    end
    --冰霜新星
    if randomex(3) then
        local x = getbaseinfo(actor, ConstCfg.gbase.x)
        local y = getbaseinfo(actor, ConstCfg.gbase.y)
        local myMaxAttackNum = getbaseinfo(actor, ConstCfg.gbase.dc2)
        rangeharm(actor, x, y, 3, myMaxAttackNum, 0, 0, 0, 2)
        playeffect(actor, 15195, 0, 0, 1, 0, 0)
    end
end


--所有攻击伤害+8%，受到的伤害+8%
TianMingBuff[4000] = function(actor, Target, Hiter, MagicId, Damage, Model, attackDamageData)
    attackDamageData.damage = attackDamageData.damage + math.ceil(Damage * 0.08)
end

--增加烈火剑法伤害10%
TianMingBuff[4001] = function(actor, Target, Hiter, MagicId, Damage, Model, attackDamageData)
    if MagicId == 26 then
        attackDamageData.damage = attackDamageData.damage + math.ceil(Damage * 0.1)
    end
end

--全技能伤害+20%
TianMingBuff[4002] = function(actor, Target, Hiter, MagicId, Damage, Model, attackDamageData)
    if MagicId ~= 7 or MagicId ~= 0 or MagicId ~= 12 then
        attackDamageData.damage = attackDamageData.damage + math.ceil(Damage * 0.2)
    end
end

--HP每下降1%，攻击增加1%的额外伤害，最高99%
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

--富可敌国--每拥有1000W金币，额外造成1%的伤害。最多10%
TianMingBuff[4004] = function(actor, Target, Hiter, MagicId, Damage, Model, attackDamageData)
    local gold = getbindmoney(actor, "金币")
    local addition = math.ceil(gold / 10000000)
    -- release_print(addition)
    if addition > 10 then
        addition = 10
    end
    local damageAddtion = math.ceil(Damage * (addition / 100))
    attackDamageData.damage = attackDamageData.damage + damageAddtion
end

--从目标人物后背偷袭普通伤害增加25% 技能伤害增加50%
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

--技能伤害+10%
TianMingBuff[4006] = function(actor, Target, Hiter, MagicId, Damage, Model, attackDamageData)
    if MagicId ~= 7 and MagicId ~= 0 and MagicId ~= 12 then
        attackDamageData.damage = attackDamageData.damage + math.ceil(Damage * 0.1)
    end
end

--狂野无常，攻击时造成的最终伤害大幅波动，无法预测。
TianMingBuff[4007] = function(actor, Target, Hiter, MagicId, Damage, Model, attackDamageData)
    local result, difference = getRandomDifference(Damage)
    attackDamageData.damage = attackDamageData.damage + difference
end

--使用烈火剑法时，有6%的几率再释放一次。烈火剑法伤害+ 10%
TianMingBuff[4008] = function(actor, Target, Hiter, MagicId, Damage, Model, attackDamageData)
    if MagicId == 26 then
        if randomex(6) then
            releasemagic_target(actor, 26, 1, 3, Target, 1)
            Player.buffTipsMsg(actor, "[烈火灵主]:你在使用烈火剑法时,触发再次释放,烈火剑法伤害+10%!")
            attackDamageData.damage = attackDamageData.damage + math.ceil(Damage * 0.1)
        end
    end
end

--攻击速度+20%，刺杀伤害+15%
TianMingBuff[4009] = function(actor, Target, Hiter, MagicId, Damage, Model, attackDamageData)
    if MagicId == 12 then
        attackDamageData.damage = attackDamageData.damage + math.ceil(Damage * 0.2)
    end
end

--对敌人造成120%的伤害，自身受到120%的伤害
TianMingBuff[4010] = function(actor, Target, Hiter, MagicId, Damage, Model, attackDamageData)
    attackDamageData.damage = attackDamageData.damage + math.ceil(Damage * 1.2)
end


--攻击比自己等级高的玩家时，每相差1级，造成2%的额外伤害。最多20%
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
--攻击玩家时，降低其15%的最大生命值，持续10s
TianMingBuff[5001] = function(actor, Target, Hiter, MagicId, Damage, Model, attackDamageData)
    if actor == Target then
        return
    end
    --buff冷却
    if Player.checkCd(actor, VarCfg["血脉压制对目标CD"], 30, true) then
        if Player.checkCd(actor, VarCfg["血脉压制受击CD"], 10, true) then --如果目标没有buff
            --跨服到本服执行
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
            Player.buffTipsMsg(actor, "[血脉压制]:你对玩家[{" .. targetName .. "/FCOLOR=243}],施加了[血脉压制]BUFF,对方最大生命值-15%,持续10S!")
            Player.buffTipsMsg(Target, "[血脉压制]:你被玩家[{" .. myName .. "/FCOLOR=243}]施加了[血脉压制]BUFF,最大生命值-15%,持续10S!")
        else
            local targetName = Player.GetNameEx(Target)
            Player.buffTipsMsg(actor, "[血脉压制]:目标玩家[{" .. targetName .. "/FCOLOR=243}],已经被施加了[血脉压制]BUFF,对目标使用失败!")
        end
    end
end

--对上一个击杀自己的标记为恶人 攻击此人获得伤害加成30%
TianMingBuff[5002] = function(actor, Target, Hiter, MagicId, Damage, Model, attackDamageData)
    local currTargetId = getbaseinfo(Target, ConstCfg.gbase.id)
    local targetId = getplaydef(actor, VarCfg["T_天命_复仇_记录对方ID"])
    if currTargetId == targetId then
        attackDamageData.damage = attackDamageData.damage + math.ceil(attackDamageData.damage * 0.3)
    end
end

--对名字比自己短的玩家额外造成20%的伤害。
TianMingBuff[5003] = function(actor, Target, Hiter, MagicId, Damage, Model, attackDamageData)
    local myName = Player.GetNameEx(actor)
    local targetName = Player.GetNameEx(Target)
    if GbkLength(myName) > GbkLength(targetName) then
        attackDamageData.damage = attackDamageData.damage + math.ceil(Damage * 0.2)
    end
end

--对名字比自己长的玩家额外造成20%的伤害。
TianMingBuff[5004] = function(actor, Target, Hiter, MagicId, Damage, Model, attackDamageData)
    local myName = Player.GetNameEx(actor)
    local targetName = Player.GetNameEx(Target)
    if GbkLength(myName) < GbkLength(targetName) then
        attackDamageData.damage = attackDamageData.damage + math.ceil(Damage * 0.2)
    end
end

--吸蓝大蓝 概率吸光对方蓝 回复自己生命
TianMingBuff[5005] = function(actor, Target, Hiter, MagicId, Damage, Model, attackDamageData)
    local random = math.random(1,10000)
    if random <= 50 then
        if Player.checkCd(actor, VarCfg["吸蓝大法CD"], 90, true) then
            addhpper(actor,"+",50)
            addmpper(Target,"-",100)
            local myName = Player.GetNameEx(actor)
            local targetName = Player.GetNameEx(Target)
            Player.buffTipsMsg(actor, "[吸蓝大蓝]:你对玩家[{" .. targetName .. "/FCOLOR=243}],施加了[吸蓝大蓝]BUFF,对方蓝量清空,自生恢复50%生命!")
            Player.buffTipsMsg(Target, "[吸蓝大蓝]:你被玩家[{" .. myName .. "/FCOLOR=243}]施加了[吸蓝大蓝]BUFF,你的蓝量被清空!")
        end
    end
end
--迷魂阵
--对低于自身5级的玩家
--有5%的概率使其束缚2
--秒无法还手(CD:60S
TianMingBuff[5006] = function(actor, Target, Hiter, MagicId, Damage, Model, attackDamageData)
    if Player.GetLevel(actor) - Player.GetLevel(Target) >= 5 then
        if Player.checkCd(actor, VarCfg["迷魂阵CD"], 60, true) then
            local random = math.random(1,10000)
            if random <= 50 then
                changemode(Target, 11, 2, 1, 2)    --禁锢范围3 禁锢时间5秒
                addbuff(actor, 31075, 60, 1, actor)
                local myName = Player.GetNameEx(actor)
                local targetName = Player.GetNameEx(Target)
                Player.buffTipsMsg(actor, "[迷魂阵]:你将{" .. targetName .. "/FCOLOR=243}禁锢{2秒/FCOLOR=243}...")
                Player.buffTipsMsg(Target, "[迷魂阵]:你被[{" .. myName .. "/FCOLOR=243}]禁锢{2秒/FCOLOR=243}...")
            end
        end
    end
end
--为我独尊
--在攻城区域内伤害额外
--提升10%
TianMingBuff[5007] = function(actor, Target, Hiter, MagicId, Damage, Model, attackDamageData)
    if getbaseinfo(actor,60) then
        attackDamageData.damage = attackDamageData.damage + math.ceil(Damage * 0.1)
    end
end

--不组队时，对怪伤害+15%
TianMingBuff[6000] = function(actor, Target, Hiter, MagicId, Damage, Model, attackDamageData)
    local isGroup = getbaseinfo(actor, ConstCfg.gbase.team_num)
    if isGroup == 0 then
        attackDamageData.damage = attackDamageData.damage + math.ceil(Damage * 0.15)
    end
end
--对怪暴击概率+15%
TianMingBuff[6001] = function(actor, Target, Hiter, MagicId, Damage, Model, attackDamageData)
    if randomex(10) then
        humanhp(Target, "-", Damage * 2, 2, 0, actor)
    end
end


--任何攻击你的敌人都会被灼自己最大生命的%2
TianMingBuff[7000] = function(actor, Target, Hiter, MagicId)
    if not hasbuff(actor, 30071) then
        addbuff(actor, 30071, 30)
        local myName = Player.GetNameEx(actor)
        local targetName = Player.GetNameEx(Target)
        Player.buffTipsMsg(actor, "[烈焰焚身]:你灼烧了目标[{" .. targetName .. "/FCOLOR=243}],持续5S!")
        Player.buffTipsMsg(Target, "[烈焰焚身]:你被[{" .. myName .. "/FCOLOR=243}]灼烧了,持续5S!")
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
        Player.buffTipsMsg(actor, "[妙手回春]:你释放了治疗术!")
    end
end

TianMingBuff[7002] = function(actor, Target, Hiter, MagicId)
    if randomex(3) then
        -- changespeedex(Target, 2, -30, 3)
        local myName = Player.GetNameEx(actor)
        local targetName = Player.GetNameEx(Target)
        Player.buffTipsMsg(actor, "[寒冰护体]:你降低了[{" .. targetName .. "/FCOLOR=243}]30%的攻击速度,持续3S!")
        Player.buffTipsMsg(Target, "[寒冰护体]:你被[{" .. myName .. "/FCOLOR=243}]降低了30%的攻击速度,持续3S!")
    end
end

--当血量在50%35%20%时分别召唤一个分身，每个分身持续20S 继承人物80%的基础属性。
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

--当血量低于20%时，有概率进入异次元空间，3秒后满血回到原位置。
TianMingBuff[7004] = function(actor, Target, Hiter, MagicId)
    if checkkuafu(actor) then
        return
    end
    local hpPer = Player.getHpPercentage(actor)
    if hpPer < 20 then
        if randomex(15) then
            if Player.checkCd(actor, VarCfg["大罗洞观CD"], 300, true) then
                if getflagstatus(actor, VarCfg.F_isGuaJi) == 1 then
                    setplaydef(actor, "N$大罗洞观进入是否挂机",1)
                end
                local myName1 = Player.GetNameEx(actor)
                Player.buffTipsMsg(Target, "[大罗洞观]:目标[{" .. myName1 .. "/FCOLOR=243}]进入异次元空间,3秒后满血返回原位置!")
                if checkkuafu(actor) then
                    FKuaFuToBenFuRunScript(actor, 5, "")
                else
                    addbuff(actor, 30095)
                    local oldMapId = getbaseinfo(actor, ConstCfg.gbase.mapid)
                    local myName = Player.GetName(actor)
                    local newMapId = myName .. "y"
                    local x = getbaseinfo(actor, ConstCfg.gbase.x)
                    local y = getbaseinfo(actor, ConstCfg.gbase.y)
                    addmirrormap("db001", newMapId, "异次元空间" .. "(" .. myName .. ")", 3, oldMapId, 0, x, y)
                    Player.buffTipsMsg(actor, "[大罗洞观]:进入异次元空间，3秒后满血回到原位置。")
                    map(actor, newMapId)
                end
            end
        end
    end
end

--铮铮铁骨
TianMingBuff[7005] = function(actor, Target, Hiter, MagicId)
    local hpPer = Player.getHpPercentage(actor)
    if hpPer < 60 and getplaydef(actor,"N$铮铮铁骨") == 0 then
        setplaydef(actor,"N$铮铮铁骨",1)
        addattlist(actor, "铮铮铁骨", "=", "3#213#20|3#214#20", 1)
    end
end

TianMingBuff[8000] = function(actor, Target, Hiter, MagicId)
    if not hasbuff(actor, 30092) then
        addbuff(actor, 30092)
        makeposion(Target, 12, 1.5, 0, 0)
        local myName = Player.GetNameEx(actor)
        local targetName = Player.GetNameEx(Target)
        Player.buffTipsMsg(actor, "[无懈可击]:你冰冻了[{" .. targetName .. "/FCOLOR=243}],持续1.5S!")
        Player.buffTipsMsg(Target, "[无懈可击]:你被[{" .. myName .. "/FCOLOR=243}]使用[无懈可击]冰冻了1.5S!")
    end
end

--被怪物攻击时3%概率恢复10%的血量。
TianMingBuff[9000] = function(actor, Target, Hiter, MagicId)
    if randomex(3) then
        if Player.canLifesteal(actor) then
            humanhp(actor, "+", Player.getHpValue(actor, 10), 4, nil, nil, nil)
            Player.buffTipsMsg(actor, "[越战越勇]:你的血量恢复10%")
        end
    end
end

--受到攻击时有1%概率释放神圣战甲术
TianMingBuff[10000] = function(actor, Target, Hiter, MagicId, Damage, attackDamageData)
    if randomex(1) then
        releasemagic(actor, 15, 1, 3, 2, 0)
        Player.buffTipsMsg(actor, "[奇门遁甲]:你释放了技能[神圣战甲术]")
    end
end

--挂机佬
TianMingBuff[10001] = function(actor, Target, Hiter, MagicId, Damage, attackDamageData)
    if getflagstatus(actor, VarCfg.F_isGuaJi) == 1 then
        attackDamageData.damage = attackDamageData.damage + math.ceil(Damage * 0.05)
    end
end

--PK伤害+15%最大攻击15% 选择后防御力永久清零并且PK时承受的伤害永久增加15%
TianMingBuff[10002] = function(actor, Target, Hiter, MagicId, Damage, attackDamageData)
    attackDamageData.damage = attackDamageData.damage - math.ceil(Damage * 0.15)
end

--被攻击时有较高概率完全反击本次伤害。
TianMingBuff[10003] = function(actor, Target, Hiter, MagicId, Damage, attackDamageData)
    if randomex(3) then
        humanhp(Target, "-", Damage, 1, 0, actor)
        local myName = Player.GetNameEx(actor)
        local targetName = Player.GetNameEx(Target)
        Player.buffTipsMsg(actor, string.format("[已静制动]:你反弹了{%s/FCOLOR=249}点伤害给[{%s/FCOLOR=243}]", Damage, targetName))
        Player.buffTipsMsg(Target, string.format("[已静制动]:[{%s/FCOLOR=243}]反弹了{%s/FCOLOR=249}点伤害!", myName, Damage))
    end
end

--永生灵体
TianMingBuff[10004] = function(actor, Target, Hiter, MagicId, Damage, attackDamageData)
    local hpPer = Player.getHpPercentage(actor)
    if hpPer < 30 then
        if not hasbuff(actor, 30079) then
            addbuff(actor, 30079)
            Player.buffTipsMsg(actor, "[永生灵体]:每秒恢复3%最大生命值,直至血量大于30%")
        end
    end
end

-- 永动机每3秒回复5%的最大生命值 受到伤害减少5555点伤害
TianMingBuff[10005] = function(actor, Target, Hiter, MagicId, Damage, attackDamageData)
    if Damage >= 5555 then
        local subDamage = 5555
        attackDamageData.damage = attackDamageData.damage + subDamage
    else
        attackDamageData.damage = attackDamageData.damage + Damage
    end
end

--对敌人造成120%的伤害，自身受到120%的伤害
TianMingBuff[10006] = function(actor, Target, Hiter, MagicId, Damage, attackDamageData)
    attackDamageData.damage = attackDamageData.damage - math.ceil(Damage + 1.2)
end

--人物最大等级上限+2 被人物攻击时承受伤害+10%
TianMingBuff[11000] = function(actor, Target, Hiter, MagicId, Damage, attackDamageData)
    attackDamageData.damage = attackDamageData.damage - math.ceil(Damage * 0.1)
end

--技能抵抗+10%
TianMingBuff[11001] = function(actor, Target, Hiter, MagicId, Damage, attackDamageData)
    if MagicId ~= 7 or MagicId ~= 0 or MagicId ~= 12 then
        attackDamageData.damage = attackDamageData.damage + math.ceil(Damage * 0.1)
    end
end

--沙城霸主 攻城区域受到伤害降低20%
TianMingBuff[11002] = function(actor, Target, Hiter, MagicId, Damage, attackDamageData)
    if getbaseinfo(actor,60) then
        attackDamageData.damage = attackDamageData.damage + math.ceil(Damage * 0.2)
    end
end

TianMingBuff[13000] = function(actor)
    changespeedex(actor, 1, 15, 5)
    Player.buffTipsMsg(actor, "[溜之大吉]:复活后增加15%移动速度.持续5S!")
end

--每杀死一只怪物获得怪物血量1%的金币（每天上限1千万）
TianMingBuff[14000] = function(actor, monobj)
    local MoneyPueer = tonumber(getplaydef(actor, VarCfg["J_天命招财之灵金币上限"]))
    if MoneyPueer < 10000000 then
        local mobMaxHp = getbaseinfo(monobj, ConstCfg.gbase.maxhp)
        local moneyNum = math.ceil(mobMaxHp * 0.01)
        changemoney(actor, 3, "+", moneyNum, "招财之灵获取", true)
        setplaydef(actor, VarCfg["J_天命招财之灵金币上限"], MoneyPueer + moneyNum)
    end
end
--击杀怪物后有概率复活其为自己战斗，持续10分钟.最多3只
TianMingBuff[14001] = function(actor, monobj)
    if randomex(3) then
        local myBabyNum = getbaseinfo(actor, ConstCfg.gbase.pets_num)
        if myBabyNum < 3 then
            local monName = getbaseinfo(monobj, ConstCfg.gbase.name)
            recallmob(actor, monName, 1, 10)
            Player.buffTipsMsg(actor, "[拘灵遣将]:你把怪物[" .. monName .. "]复活了,为自己战斗,持续10分钟!")
        end
    end
end

--每次击杀怪物时有概率增加100点生命值（上限300000）
TianMingBuff[14002] = function(actor, monobj)
    if randomex(10) then
        local currHp = getplaydef(actor, VarCfg["U_天命_浴血狂魔_血量"])
        if currHp < 300000 then
            setplaydef(actor, VarCfg["U_天命_浴血狂魔_血量"], currHp + 100)
            Player.setAttList(actor, "属性附加")
        end
    end
end

--合法击杀，减少100点PK值
TianMingBuff[15000] = function(actor, play)
    local currentPkValue = getbaseinfo(actor, ConstCfg.gbase.pkvalue)
    setbaseinfo(actor, ConstCfg.sbase.pkvalue, currentPkValue - 100)
    Player.buffTipsMsg(actor, "[合法击杀]:你的PK值-100!")
end

--每击杀一个玩家，增加自身1%暴击几率和破防几率，最高上限15%,自身死亡或下线则属性消失。
TianMingBuff[15001] = function(actor, play)
    local killConunt = getplaydef(actor, VarCfg["N$势如破竹记录次数"])
    local currCount = killConunt + 1
    if killConunt < 15 then
        setplaydef(actor, VarCfg["N$势如破竹记录次数"], currCount)
    end
    if killConunt > 15 then
        killConunt = 15
    end
    delattlist(actor, "势如破竹")
    addattlist(actor, "势如破竹", "=", string.format("3#21#%d|3#28#%d", currCount, currCount), 1)
end

--每杀死一名玩家，恢复自身最大生命值20%。无CD。
TianMingBuff[15002] = function(actor, play)
    local hpPer = Player.getHpValue(actor, 20)
    humanhp(actor, "+", hpPer, 4, nil, nil, nil)
    Player.buffTipsMsg(actor, "[浴血奋战]:击杀玩家HP+20%!")
end

--吸元秘术，杀死目标后恢复自身最大生命值5%。
TianMingBuff[15003] = function(actor, play)
    addhpper(actor, "+", 5)
    Player.buffTipsMsg(actor, "[吸元秘术]:击杀玩家HP+5%!")
end


--当人物死亡时有概率增加50点攻击力（上限3000点）
TianMingBuff[16000] = function(actor, hiter)
    if randomex(50) then
        local tatol = getplaydef(actor, VarCfg["U_天命_越挫越勇攻击累加"])
        if tatol < 3000 then
            setplaydef(actor, VarCfg["U_天命_越挫越勇攻击累加"], tatol + 50)
            Player.buffTipsMsg(actor, "[越挫越勇攻]:攻击力+50!")
            delattlist(actor, "越挫越勇")
            addattlist(actor, "越挫越勇", "=", "3#4#" .. tatol + 50, 1)
        end
    end
end

--被玩家击杀后，额外给击杀者增加200点PK值
TianMingBuff[16001] = function(actor, hiter)
    if getbaseinfo(hiter,-1) == false then
        return
    end
    if getconst(hiter, ConstCfg.equipconst["腰带"]) ~= "【传承】秩序腰带" or getconst(hiter, ConstCfg.equipconst["勋章"]) ~= "本源之力" then
        local hiterName = Player.GetNameEx(hiter)
        Player.buffTipsMsg(actor, "[诅咒之体]:你被" .. hiterName .. "击杀,由于对方有特殊装备,免疫红名,无法增加PK值!")
    else
        local currPkValue = getbaseinfo(hiter, ConstCfg.gbase.pkvalue)
        setbaseinfo(hiter, ConstCfg.sbase.pkvalue, currPkValue + 200)
        local myName = Player.GetNameEx(actor)
        local hiterName = Player.GetNameEx(hiter)
        Player.buffTipsMsg(actor, "[诅咒之体]:你被" .. hiterName .. "击杀,对方PK值+200!")
        Player.buffTipsMsg(hiter, "[诅咒之体]:你击杀了" .. myName .. ",对方[诅咒之体]BUFF生效,你增加了200点PK值!")
    end
end
--死亡时对杀死自己的敌人造成对方最大HP30%的真实伤害。
TianMingBuff[16002] = function(actor, hiter)
    local myName = Player.GetNameEx(actor)
    local hiterName = Player.GetNameEx(hiter)
    Player.buffTipsMsg(actor, "[同归于尽]:你被[{" .. hiterName .. "/FCOLOR=243}]击杀,对敌人造成对方最大HP30%的真实伤害!")
    Player.buffTipsMsg(hiter, "[同归于尽]:你击杀了[{" .. myName .. "/FCOLOR=243}],对方触发BUFF,对你造成最大HP30%的真实伤害!")
    humanhp(hiter, "-", Player.getHpValue(hiter, 30), 1, 0, actor)
end

--诅咒击杀自己的人当日爆率降低100%。（不可叠加）
TianMingBuff[16003] = function(actor, hiter)
    if getbaseinfo(hiter,-1) == false then
        return
    end
    local myName = Player.GetNameEx(actor)
    local hiterName = Player.GetNameEx(hiter)
    if getplaydef(hiter, VarCfg["J_画个圈诅咒你_诅咒爆率"]) == 0 then
        setplaydef(hiter, VarCfg["J_画个圈诅咒你_诅咒爆率"], 1)
        addbuff(hiter, 30102, GetReaminSecondsTo24() + 30)
        Player.buffTipsMsg(actor, "[画个圈圈诅咒你]:你诅咒了[{" .. hiterName .. "/FCOLOR=243}],对方爆率-100%")
        Player.buffTipsMsg(hiter, "[画个圈圈诅咒你]:你被[{" .. myName .. "/FCOLOR=243}],诅咒了,爆率-100%,次日恢复!")
        Player.setAttList(hiter, "爆率附加")
    end
end

TianMingBuff[16004] = function(actor, hiter)
    if getbaseinfo(hiter,-1) == false then
        return
    end
    local hitetId = getbaseinfo(hiter, ConstCfg.gbase.id)
    local hitetName = Player.GetNameEx(hiter)
    setplaydef(actor, VarCfg["T_天命_复仇_记录对方ID"], hitetId)
    Player.buffTipsMsg(actor, "[复仇]:你被[{" .. hitetName .. "/FCOLOR=243}]击杀,对该玩家伤害提升30%!")
end

--势如破竹死亡消失
TianMingBuff[16005] = function(actor, hiter)
    delattlist(actor, "势如破竹")
end
--归来仍是少年
TianMingBuff[16006] = function(actor, hiter)
    local times = os.time()
end

return TianMingBuff

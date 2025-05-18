local ZhuangBeiBuffList = {}
local cfg_IsBoss = include("QuestDiary/cfgcsv/cfg_IsBoss.lua") --boss列表
local cfg_BuBeiQieGeMon = include("QuestDiary/cfgcsv/cfg_BuBeiQieGeMon.lua")
local cfg_ShenLongDiGuo = include("QuestDiary/cfgcsv/cfg_ShenLongDiGuo_data.lua")

--全部攻击触发（1000开头）
--流光淬火剣[饮血]--攻击目标时每刀恢复[100]点生命值
ZhuangBeiBuffList[1000] = function(actor, Target, Hiter, MagicId)
    local currHpPer = Player.getHpPercentage(actor)
    if currHpPer <= 3 or currHpPer == 100 then return end
    humanhp(actor, "+", 100)
end

--流光剣[综合之力]--攻击目标时每刀恢复[300]点生命值
ZhuangBeiBuffList[1001] = function(actor, Target, Hiter, MagicId)
    local currHpPer = Player.getHpPercentage(actor)
    if currHpPer <= 3 or currHpPer == 100 then return end
    humanhp(actor, "+", 300)
end
-- 天劫之怒★★★★ 攻击目标时大量吸取目标生命值 攻击时有概率进入天怒状态：刀刀暴击，且暴击伤害+20%，持续6S.
ZhuangBeiBuffList[1002] = function(actor, Target, Hiter, MagicId)
    if randomex(3) then
        if Player.checkCd(actor, VarCfg["天劫之怒CD"], 30, true) then
            changehumnewvalue(actor, 21, 100, 6)
            changehumnewvalue(actor, 22, 20, 6)
        end
    end
    if Player.canLifesteal(actor) then
        humanhp(actor, "+", 300)
    end
end
--遗忘的赤炎吊坠 对低等级的目标施放(烈火)或(开天) 或(逐日)时有概率触发冰冻目标[1S] 概率1 1/10
ZhuangBeiBuffList[1003] = function(actor, Target, Hiter, MagicId)
    if MagicId == 26 or MagicId == 66 or MagicId == 56 then
        if randomex(1, 10) then
            local myLeve = getbaseinfo(actor, ConstCfg.gbase.level)
            local targetLeve = getbaseinfo(Target, ConstCfg.gbase.level)
            if targetLeve < myLeve then
                local x, y = getbaseinfo(Target, ConstCfg.gbase.x), getbaseinfo(Target, ConstCfg.gbase.y)
                rangeharm(actor, x, y, 0, 0, 2, 1, 1, 0, 20500) -- 冰冻1*1范围内敌人1秒
                playsound(actor, 100001, 1, 0)                  --播放冰冻音效
                local myName = Player.GetNameEx(actor)
                local targetName = Player.GetNameEx(Target)
                Player.buffTipsMsg(actor, "[忘的赤炎吊坠]:你冰冻了目标[{" .. targetName .. "/FCOLOR=243}],持续1S...")
                Player.buffTipsMsg(Target, "[忘的赤炎吊坠]:你被[{" .. myName .. "/FCOLOR=243}]冰冻了,持续1S...")
            end
        end
    end
end
--撒旦の镯 攻击有概率造成[攻击*333%]的伤害 成功概率1/128
ZhuangBeiBuffList[1004] = function(actor, Target, Hiter, MagicId)
    if randomex(1, 128) then
        local mydcmax = getbaseinfo(actor, ConstCfg.gbase.dc2)
        local tgtdechp = mydcmax * 3.33
        humanhp(Target, "-", tgtdechp, 1, 0, actor)
        Player.buffTipsMsg(actor, "[撒旦の镯]:打掉了怪物[{" .. tgtdechp .. "/FCOLOR=243}]真实伤害...")
    end
end
-- 「掌控雷电」 攻击时有概率可召唤天雷对目标进行[8次]连击，第一次造成20%伤害，后续每次连击增加30%伤害![CD：60秒] 1/88概率
ZhuangBeiBuffList[1005] = function(actor, Target, Hiter, MagicId)
    if getbaseinfo(Target, -1) == false then
        return
    end
    if randomex(1, 88) then
        local buffcd = hasbuff(actor, 30011)
        if not buffcd then
            addbuff(Target, 30081) --给对方添加八连击buff
            setplaydef(Target, VarCfg["N$雷电八连击"], 0) --给对方赋值为0
            addbuff(actor, 30011, 60, 1, actor)
        end
    end
end
-- 离火 施放技能时有概率触发双重施法效果 让技能额外在释放一次[CD60秒]
ZhuangBeiBuffList[1006] = function(actor, Target, Hiter, MagicId)
    local buffcd = hasbuff(actor, 30015)
    if not buffcd then
        if MagicId == 26 or MagicId == 66 or MagicId == 56 then
            releasemagic(actor, MagicId, 1, 3, 1, 1)
            addbuff(actor, 30015, 60, 1, actor)
            local skillname = getskillname(MagicId)
            Player.buffTipsMsg(actor, "[离火]:触发双重施法效果,技能[{" .. skillname .. "/FCOLOR=243}]再释放一次...")
        end
    end
end
-- 幽冥之环 施放技能时有概率触发双重施法效果让技能额外在释放一次[CD60秒]
ZhuangBeiBuffList[1007] = function(actor, Target, Hiter, MagicId)
    if randomex(1, 128) then
        if MagicId == 26 or MagicId == 66 or MagicId == 56 then
            releasemagic(actor, MagicId, 1, 3, 1, 1)
            local skillname = getskillname(MagicId)
            Player.buffTipsMsg(actor, "[幽冥之环]:触发双重施法效果,技能[{" .. skillname .. "/FCOLOR=243}]再释放一次...")
        end
    end
end
-- 归墟万物  施放烈火时有概率触发双重施法效果 让技能额外在释放一次[CD60秒]
ZhuangBeiBuffList[1008] = function(actor, Target, Hiter, MagicId)
    local buffcd = hasbuff(actor, 30024)
    if not buffcd then
        if MagicId == 26 then
            releasemagic(actor, MagicId, 1, 3, 1, 1)
            addbuff(actor, 30024, 60, 1, actor)
            local skillname = getskillname(MagicId)
            Player.buffTipsMsg(actor, "[归墟万物]:触发双重施法效果,技能[{" .. skillname .. "/FCOLOR=243}]再释放一次...")
        end
    end
end
-- 赤木之瞳 攻击时有概率强制麻痹目标[1]秒 1/128
ZhuangBeiBuffList[1009] = function(actor, Target, Hiter, MagicId)
    if randomex(1, 128) then
        local x, y = getbaseinfo(Target, ConstCfg.gbase.x), getbaseinfo(Target, ConstCfg.gbase.y)
        rangeharm(actor, x, y, 0, 0, 3, 1, 0, 0, nil, 1) -- 麻痹目标[1]秒
        local myName = Player.GetNameEx(actor)
        local targetName = Player.GetNameEx(Target)
        Player.buffTipsMsg(actor, "[赤木之瞳]:你将[{" .. targetName .. "/FCOLOR=243}]麻痹[{1秒/FCOLOR=243}]...")
        Player.buffTipsMsg(Target, "[赤木之瞳]:你被[{" .. myName .. "/FCOLOR=243}]麻痹[{1秒/FCOLOR=243}]...")
    end
end

-- 血魔护臂MAX 施放烈火剑法概率冰冻目标[1-3]秒
ZhuangBeiBuffList[1011] = function(actor, Target, Hiter, MagicId)
    if MagicId == 26 then
        if randomex(1, 128) then
            local x, y = getbaseinfo(Target, ConstCfg.gbase.x), getbaseinfo(Target, ConstCfg.gbase.y)
            local itemnum = math.random(1, 3)
            rangeharm(actor, x, y, 0, 0, 2, itemnum, 0, 0, 20500, 1) -- 冰冻敌人1秒
            playsound(actor, 100001, 1, 0)                           --播放冰冻音效
            local myName = Player.GetNameEx(actor)
            local targetName = Player.GetNameEx(Target)
            Player.buffTipsMsg(actor,
                "[血魔护臂MAX]:你将[{" .. targetName .. "/FCOLOR=243}]冰冻[{" .. itemnum .. "秒/FCOLOR=243}]...")
            Player.buffTipsMsg(Target,
                "[血魔护臂MAX]:你被[{" .. myName .. "/FCOLOR=243}]冰冻[{" .. itemnum .. "秒/FCOLOR=243}]...")
        end
    end
end
-- 蚀月镜  施放野蛮冲撞时可将目标撞至瘫痪2秒..
ZhuangBeiBuffList[1012] = function(actor, Target, Hiter, MagicId)
    if MagicId == 27 then
        changemode(Target, 11, 2)
        local myName = Player.GetNameEx(actor)
        local targetName = Player.GetNameEx(Target)
        Player.buffTipsMsg(actor, "[蚀月镜]:释放野蛮冲撞使{" .. targetName .. "/FCOLOR=243}进入瘫痪状态{2/FCOLOR=243}秒...")
        Player.buffTipsMsg(Target, "[血魔护臂MAX]:{" .. myName .. "/FCOLOR=243}释放野蛮冲撞使你进入瘫痪状态{2/FCOLOR=243}秒...")
    end
end
--失落空间 当人物进入复活CD后触发攻击时刀刀恢复(2%)的最大生命值10秒  CD：120秒
ZhuangBeiBuffList[1013] = function(actor, Target, Hiter, MagicId)
    if ReliveMain.GetReliveState(actor) then return end -- 复活中
    local buff1 = hasbuff(actor, 30053)                 --记时buff  120秒
    local buff2 = hasbuff(actor, 30052)                 --状态buff  10秒
    if not buff1 then
        addbuff(actor, 30052, 10, 1, actor)
        addbuff(actor, 30053, 120, 1, actor)
        Player.buffTipsMsg(actor, "[失落空间]:刀刀吸血{2%/FCOLOR=243}最大血量持续{10/FCOLOR=243}秒...")
    end
    if not buff2 then
        if Player.canLifesteal(actor) then
            humanhp(actor, "+", Player.getHpValue(actor, 2), 4) --刀刀吸血2%
        end
    end
end

--冰河之心 人物永久进入[防冰冻]状态攻击时有概率造成冰冻[1]秒的效果 1/188概率
ZhuangBeiBuffList[1014] = function(actor, Target, Hiter, MagicId)
    if randomex(1, 188) then
        local x, y = getbaseinfo(Target, ConstCfg.gbase.x), getbaseinfo(Target, ConstCfg.gbase.y)
        rangeharm(actor, x, y, 0, 0, 2, 1, 1, 0, 20500) -- 冰冻1*1范围内敌人1秒
        playsound(actor, 100001, 1, 0)                  --播放冰冻音效
        local myName = Player.GetNameEx(actor)
        local targetName = Player.GetNameEx(Target)
        Player.buffTipsMsg(actor, "[冰河之心]:你冰冻了目标[{" .. targetName .. "/FCOLOR=243}],持续1S...")
        Player.buffTipsMsg(Target, "[冰河之心]:你被[{" .. myName .. "/FCOLOR=243}]冰冻了,持续1S...")
    end
end

-- 永恒凛冬 攻击时有概率冰冻目标[1]秒(CD15S) 人物永久免疫冰冻效果 1/88
ZhuangBeiBuffList[1015] = function(actor, Target, Hiter, MagicId)
    if randomex(1, 88) then
        local x, y = getbaseinfo(Target, ConstCfg.gbase.x), getbaseinfo(Target, ConstCfg.gbase.y)
        rangeharm(actor, x, y, 0, 0, 2, 1, 0, 0, 20500, 1) -- 概率冰冻目标[1]秒
        playsound(actor, 100001, 1, 0)                     --播放冰冻音效
    end
end
-- 龙魂威压：攻击时有概率进入龙魂状态，持续10S，龙魂状态下灭世骸骨的攻击效果翻倍（CD:30S）。
-- 攻击［怪物］刀刀恢复自身1.5%最大生命，
-- 攻击［人物］刀刀切割目标1.5%的最大生。
ZhuangBeiBuffList[1016] = function(actor, Target, Hiter, MagicId)
    if randomex(1, 300) then
        if not hasbuff(actor, 31034) then
            addbuff(actor, 31034, 30)
            addbuff(actor, 31035, 10)
        end
    end
    if getbaseinfo(Target, -1) == false then --攻击怪物
        local basePer = 1.5
        if hasbuff(actor, 31035) then
            basePer = basePer * 2
        end
        --是否符合吸血条件
        if Player.canLifesteal(actor) then
            local hpPer = Player.getHpValue(actor, basePer)
            humanhp(actor, "+", hpPer, 4)
        end
    else --攻击人
        local basePer = 1.5
        if hasbuff(actor, 31035) then
            basePer = basePer * 2
        end
        local hpPer = Player.getHpValue(Target, basePer)
        humanhp(Target, "-", hpPer, 1, 0, actor)
    end
end

-- 魔兽之爪   释放烈火后 1/88 恢复生命
ZhuangBeiBuffList[1017] = function(actor, Target, Hiter, MagicId)
    if MagicId ~= 26 then return end
    if randomex(1, 88) then
        humanhp(actor, "+", Player.getHpValue(actor, 10), 4) --自己加血10%
    end
end

-- 勿忘我   1/128设置为和平模式
ZhuangBeiBuffList[1018] = function(actor, Target, Hiter, MagicId)
    if randomex(1, 128) then
        changeattackmode(actor, 1)
    end
end

-- 无序的凝视 攻击时概率使自身神力倍攻总数提高一半  持续5秒-冷却30秒  
ZhuangBeiBuffList[1019] = function(actor, Target, Hiter, MagicId)
    local buffCD = hasbuff(actor, 31084)
    if buffCD then return end
    if randomex(1, 1) then
        addbuff(actor, 31084, 30)
        addbuff(actor, 31085, 5)
        Player.setAttList(actor, "倍攻附加")
        Player.buffTipsMsg(actor, "[无序的凝视]:倍功增加{50%/FCOLOR=243}持续{5秒/FCOLOR=243}...")
    end
end



--攻击人触发（2000开头）
-- 暗夜潜行者    复活在不可用的情况下有(3%)的概率斩杀目标人物[99%]的最大生命值   1/128 random
ZhuangBeiBuffList[2000] = function(actor, Target, Hiter, MagicId)
    if ReliveMain.GetReliveState(actor) then return end          -- 复活中
    if randomex(1, 128) then
        humanhp(Target, "-", Player.getHpValue(Target, 99), 106) --扣除99%血量
        local myName = Player.GetNameEx(actor)
        local targetName = Player.GetNameEx(Target)
        Player.buffTipsMsg(actor, "[暗夜潜行者]:斩杀了[{" .. targetName .. "/FCOLOR=243}]99%最大血量...")
        Player.buffTipsMsg(Target, "[暗夜潜行者]:你被[{" .. myName .. "/FCOLOR=243}]斩杀99%最大血量...")
    end
end

-- 源火禁锢    PK时有概率对目标造成禁锢(2秒钟)   1/108 random
ZhuangBeiBuffList[2001] = function(actor, Target, Hiter, MagicId)
    if randomex(1, 108) then
        changemode(Target, 11, 2, 1, 2)
    end
end

-- 远古吊坠    烈火剑法可斩杀目标[10%]的生命值
ZhuangBeiBuffList[2002] = function(actor, Target, Hiter, MagicId)
    if MagicId == 26 then
        humanhp(Target, "-", Player.getHpValue(Target, 10), 106, 0, actor) --扣除10%血量
        local myName = Player.GetNameEx(actor)
        local targetName = Player.GetNameEx(Target)
        Player.buffTipsMsg(actor, "[远古吊坠]:释放烈火剑法,斩杀了[{" .. targetName .. "/FCOLOR=243}]10%最大血量...")
        Player.buffTipsMsg(Target, "[远古吊坠]:[{" .. myName .. "/FCOLOR=243}]对方释放烈火剑法,你被斩杀10%最大血量...")
    end
end
-- 离人愁    攻击时有概率卸下目标[1件]装备返回到背包里面！ 1/128
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
                "[离人愁]:你将[{" .. targetName .. "/FCOLOR=243}]的[{" .. itemname .. "/FCOLOR=243}]打回背包...")
            Player.buffTipsMsg(Target, "[离人愁]:你被[{" .. myName .. "/FCOLOR=243}]将[{" .. itemname .. "/FCOLOR=243}]打回背包...")
        end
    end
end
-- 千年结   攻击有概率打掉目标背包的[传送石]  1/128
ZhuangBeiBuffList[2004] = function(actor, Target, Hiter, MagicId)
    if randomex(1, 158) then
        local num1 = getbagitemcount(Target, "主城传送石", 0)
        local num2 = getbagitemcount(Target, "随机传送石", 0)
        if num1 >= 1 then
            takeitem(Target, "主城传送石", num1, 0, "千年结buff扣除")
        end
        if num2 >= 1 then
            takeitem(Target, "随机传送石", num2, 0, "千年结buff扣除")
        end
        local myName = Player.GetNameEx(actor)
        local targetName = Player.GetNameEx(Target)
        Player.buffTipsMsg(actor, "[千年结]:你将[{" .. targetName .. "/FCOLOR=243}]的[{传送道具/FCOLOR=243}]打消失了...")
        Player.buffTipsMsg(Target, "[千年结]:[{" .. myName .. "/FCOLOR=243}]把你的[{传送道具/FCOLOR=243}]打消失了...")
    end
end
-- 无言恐惧   攻击对生命值高于(50%)的人物激活刀刀切割[99999]点生命值！
ZhuangBeiBuffList[2005] = function(actor, Target, Hiter, MagicId)
    local calculate = Player.getHpPercentage(Target)
    if calculate > 50 then
        humanhp(Target, "-", 99999, 106, 0, actor) --刀刀斩血
    end
end
-- 玄阴〃吊坠   攻击满血人物直接斩杀(30%)生命值(60秒内只允许触发一次当前BUFF)
ZhuangBeiBuffList[2006] = function(actor, Target, Hiter, MagicId)
    local buffcd = hasbuff(actor, 30019)
    if not buffcd then
        local calculate = Player.getHpPercentage(Target)
        if calculate > 99 then
            humanhp(Target, "-", Player.getHpValue(Target, 30), 106, 0, actor) --刀刀斩血
            addbuff(actor, 30019, 60, 1, actor)
            local targetName = Player.GetNameEx(Target)
            Player.buffTipsMsg(actor, "[玄阴〃吊坠]:斩杀[{" .. targetName .. "/FCOLOR=243}]的[{30%/FCOLOR=243}]血量...")
        end
    end
end
-- 夜魔之绕   被梦魇命中的目标每秒额外掉血[1%] 掉血持续60S
ZhuangBeiBuffList[2007] = function(actor, Target, Hiter, MagicId)
    if randomex(1, 188) then
        addbuff(Target, 30022, 5, 1, actor)
        local targetName = Player.GetNameEx(Target)
        Player.buffTipsMsg(actor,
            "[夜魔之绕]:使[{" .. targetName .. "/FCOLOR=243}]被{梦魇/FCOLOR=243}命中,每秒掉血{1%/FCOLOR=243}持续{5/FCOLOR=243}秒...")
    end
end
-- 夜幽面具★★★    攻击时有概率卸下目标[1件]装备返回到背包里面！ 1/228
ZhuangBeiBuffList[2009] = function(actor, Target, Hiter, MagicId)
    if randomex(1, 228) then
        if Player.checkCd(actor, VarCfg["夜幽面具CD"], 30, true) then
            local itemnum = math.random(0, 11)
            local itemobj = linkbodyitem(Target, itemnum)
            if itemobj ~= "0" then
                local itemname = getiteminfo(Target, itemobj, 7)
                local itemidx = getiteminfo(Target, itemobj, 1)
                takeoffitem(actor, itemnum, itemidx)
                local myName = Player.GetNameEx(actor)
                local targetName = Player.GetNameEx(Target)
                Player.buffTipsMsg(actor,
                    "[夜幽面具★★★]:你将[{" .. targetName .. "/FCOLOR=243}]的[{" .. itemname .. "/FCOLOR=243}]打回背包...")
                Player.buffTipsMsg(Target,
                    "[夜幽面具★★★]:你被[{" .. myName .. "/FCOLOR=243}]将[{" .. itemname .. "/FCOLOR=243}]打回背包...")
            end
        end
    end
end
-- ⊙墟魂千幻⊙    复活在不可用的情况下有(3%)的概率斩杀目标人物[99%]的最大生命值   1/128 random [CD300秒]
ZhuangBeiBuffList[2009] = function(actor, Target, Hiter, MagicId)
    if ReliveMain.GetReliveState(actor) then return end -- 复活中

    if randomex(1, 128) then
        if Player.checkCd(actor, VarCfg["⊙墟魂千幻⊙CD"], 300, true) then
            humanhp(Target, "-", Player.getHpValue(Target, 99), 106, 0, actor) --扣除99%血量
            playeffect(Target, 16020, 0, 0, 1, 0, 0)
            local targetName = Player.GetNameEx(Target)
            Player.buffTipsMsg(actor, "[⊙墟魂千幻⊙]:斩杀[{" .. targetName .. "/FCOLOR=243}]的[{99%/FCOLOR=243}]血量...")
        end
    end
end
-- 给你马一拳 有概率将目标打回主城   1/228 random [CD180秒]
ZhuangBeiBuffList[2010] = function(actor, Target, Hiter, MagicId)
    if randomex(1, 228) then
        local buffcd = hasbuff(actor, 30033)
        if Player.checkCd(actor, VarCfg["给你马一拳CD"], 180, true) then
            mapmove(Target, "n3", 330, 330, 5)
            local myName = Player.GetNameEx(actor)
            local targetName = Player.GetNameEx(Target)
            Player.buffTipsMsg(actor, "[给你马一拳]:你将[{" .. targetName .. "/FCOLOR=243}]打回[{流星之城/FCOLOR=243}]...")
            Player.buffTipsMsg(Target, "[给你马一拳]:你被[{" .. myName .. "/FCOLOR=243}]打回[{流星之城/FCOLOR=243}]...")
        end
    end
end
-- 天魔心脏★★★ 攻击有概率打掉目标[66%]的生命值恢复自身[66%]的生命值(仅PK触发)   1/68 random [CD60秒]
ZhuangBeiBuffList[2011] = function(actor, Target, Hiter, MagicId)
    if randomex(1, 68) then
        humanhp(Target, "-", Player.getHpValue(Target, 66), 1, 0, actor) --目标扣血66%
        humanhp(actor, "+", Player.getHpValue(actor, 66), 4)             --自己加血66%
        local myName = Player.GetNameEx(actor)
        local targetName = Player.GetNameEx(Target)
        Player.buffTipsMsg(actor,
            "[天魔心脏★★★]:你斩杀掉[{" .. targetName .. "/FCOLOR=243}]{66%/FCOLOR=243}的最大血量并恢复自己{66%/FCOLOR=243}血量...")
        Player.buffTipsMsg(Target, "[天魔心脏★★★]:你被[{" .. myName .. "/FCOLOR=243}]斩杀{66%/FCOLOR=243}的最大血量...")
    end
end
--撕裂者面具  PK时 每八刀斩杀目标最大生命值10%
ZhuangBeiBuffList[2012] = function(actor, Target, Hiter, MagicId)
    local daoshunum = getplaydef(actor, VarCfg["N$_撕裂者面具"])
    if daoshunum >= 8 then
        humanhp(Target, "-", Player.getHpValue(Target, 10), 106, 0, actor)
        setplaydef(actor, VarCfg["N$_撕裂者面具"], 0) --刀数归零
        local myName = Player.GetNameEx(actor)
        Player.buffTipsMsg(Target, "[撕裂者面具]:斩杀[{" .. myName .. "/FCOLOR=243}]{10%/FCOLOR=243}最大血量...")
    else
        setplaydef(actor, VarCfg["N$_撕裂者面具"], daoshunum + 1) --刀数加1
    end
end
--血色之眼 有概率使对方防御清空10秒 1/128概率
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
        Player.buffTipsMsg(actor, "[1]:你清空[{" .. targetName .. "/FCOLOR=243}]的防御{10/FCOLOR=243}秒...")
        Player.buffTipsMsg(Target, "[血色之眼]:你被[{" .. myName .. "/FCOLOR=243}]清空防御{10/FCOLOR=243}秒...")
    end
end
--克苏恩之眼 攻击时有概率恢复全部生命 1/128
ZhuangBeiBuffList[2014] = function(actor, Target, Hiter, MagicId)
    if randomex(1, 128) then
        humanhp(actor, "=", Player.getHpValue(actor, 100), 4)
        Player.buffTipsMsg(actor, "[克苏恩之眼]:恢复[{100%/FCOLOR=243}]的生命...")
    end
end
--颠倒罪人之戒 PK时有概率将目标的武器打进背包 1/128 概率
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
                "[离人愁]:你将[{" .. targetName .. "/FCOLOR=243}]的[{" .. itemname .. "/FCOLOR=243}]打回背包...")
            Player.buffTipsMsg(Target, "[离人愁]:你被[{" .. myName .. "/FCOLOR=243}]将[{" .. itemname .. "/FCOLOR=243}]打回背包...")
        end
    end
end
--黑暗限界 烈火剑法可斩杀 目标10%生命值
ZhuangBeiBuffList[2016] = function(actor, Target, Hiter, MagicId)
    if MagicId == 26 then
        humanhp(Target, "-", Player.getHpValue(Target, 10), 106, 0, actor) --斩杀10%生命
        local targetName = Player.GetNameEx(Target)
        Player.buffTipsMsg(actor, "[黑暗限界]:斩杀[{" .. targetName .. "/FCOLOR=243}]{10%/FCOLOR=243}的血量...")
    end
end
--◆影杀阵◆ PK时有概率使对方红名
ZhuangBeiBuffList[2017] = function(actor, Target, Hiter, MagicId)
    if randomex(1, 128) then
        local pkvalue = getbaseinfo(Target, ConstCfg.gbase.pkvalue)
        setbaseinfo(Target, ConstCfg.sbase.pkvalue, pkvalue + 1000)
        addbuff(Target, 30043, 5, 1, actor)
    end
end
--追殺者 攻击有概率打掉目标[50%]的生命值恢复自身[20%]的生命值(仅PK触发) 1/158
ZhuangBeiBuffList[2018] = function(actor, Target, Hiter, MagicId)
    if randomex(1, 158) then
        humanhp(Target, "-", Player.getHpValue(Target, 50), 106, 0, actor) --刀刀斩血
        humanhp(actor, "+", Player.getHpValue(actor, 20), 4)               --刀刀斩血
        local targetName = Player.GetNameEx(Target)
        Player.buffTipsMsg(actor,
            "[追殺者]:你将[{" .. targetName .. "/FCOLOR=243}]的血量打掉{50%/FCOLOR=243}并恢复自身{20%/FCOLOR=243}血量...")
    end
end
--死亡ゅ封印 攻击时有概率将目标[衣服]打入背包 1/158 概率
ZhuangBeiBuffList[2019] = function(actor, Target, Hiter, MagicId)
    if randomex(1, 158) then
        local itemobj = linkbodyitem(Target, 0)
        local itemidx = getiteminfo(Target, itemobj, 1)
        takeoffitem(Target, 0, itemidx)
        local myName = Player.GetNameEx(actor)
        local targetName = Player.GetNameEx(Target)
        local itemname = getiteminfo(Target, itemobj, 0)
        Player.buffTipsMsg(actor,
            "[死亡ゅ封印]:你将[{" .. targetName .. "/FCOLOR=243}]的[{" .. itemname .. "/FCOLOR=243}]打回背包...")
        Player.buffTipsMsg(Target, "[死亡ゅ封印]:你被[{" .. myName .. "/FCOLOR=243}]将[{" .. itemname .. "/FCOLOR=243}]打回背包...")
    end
end
--死亡假面 当人物复活后会进入隐身状态2秒 下次攻击会斩杀人物15%的生命值
ZhuangBeiBuffList[2020] = function(actor, Target, Hiter, MagicId)
    if getplaydef(actor, VarCfg["S$_死亡假面"]) == "1" then
        humanhp(Target, "-", Player.getHpValue(Target, 15), 106, 0, actor) --刀刀斩血
        setplaydef(actor, VarCfg["S$_死亡假面"], "")
    end
end
--死亡射线 攻击人物时有概率使目标灼烧[10秒]被灼烧命中的目标每秒额外掉血[2%] 1/128
ZhuangBeiBuffList[2021] = function(actor, Target, Hiter, MagicId)
    if randomex(1, 128) then
        local tgtbuff = hasbuff(Target, 30045)
        if not tgtbuff then
            addbuff(Target, 30045, 10, 1, actor)
            local myName = Player.GetNameEx(actor)
            local targetName = Player.GetNameEx(Target)
            Player.buffTipsMsg(actor,
                "[死亡射线]:使{" .. targetName .. "/FCOLOR=243}进入{灼烧/FCOLOR=243}状态,每秒灼烧{2%/FCOLOR=243}生命持续{10/FCOLOR=243}秒...")
            Player.buffTipsMsg(Target,
                "[死亡射线]:{" .. myName .. "/FCOLOR=243}]使你进入{灼烧/FCOLOR=243}状态,每秒灼烧{2%/FCOLOR=243}生命持续{10/FCOLOR=243}秒...")
        end
    end
end
--千山破  1/128概率将对方倍攻清空3秒
ZhuangBeiBuffList[2022] = function(actor, Target, Hiter, MagicId)
    if randomex(1, 128) then
        addbuff(Target, 30046, 3, 1, actor)
        Player.setAttList(Target, "倍攻附加")

        local myName = Player.GetNameEx(actor)
        local targetName = Player.GetNameEx(Target)
        Player.buffTipsMsg(actor, "[千山破]:使{" .. targetName .. "/FCOLOR=243}进入{倍攻清空/FCOLOR=243}状态,持续{3/FCOLOR=243}秒...")
        Player.buffTipsMsg(Target, "[千山破]:{" .. myName .. "/FCOLOR=243}]使你进入{倍攻清空/FCOLOR=243}状态,持续{3/FCOLOR=243}秒...")
    end
end
--罪恶审判× 攻击时有概率对目标造成瘫痪[1秒] 并且恢复自身(30%)的最大生命值！
ZhuangBeiBuffList[2023] = function(actor, Target, Hiter, MagicId)
    if randomex(1, 128) then
        humanhp(actor, "+", Player.getHpValue(actor, 30), 4) --刀刀斩血
        local x, y = getbaseinfo(Target, ConstCfg.gbase.x), getbaseinfo(Target, ConstCfg.gbase.y)
        rangeharm(actor, x, y, 0, 0, 10, 1000, 0, 0)         -- 定身1秒
        local targetName = Player.GetNameEx(Target)
        Player.buffTipsMsg(actor,
            "[罪恶审判×]:使{" .. targetName .. "/FCOLOR=243}瘫痪{1秒/FCOLOR=243}并恢复自身{30%/FCOLOR=243}最大生命值...")
    end
end
-- 深渊的亵渎☆☆    攻击时有概率卸下目标[1件]装备返回到背包里面！ 1/128
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
                "[深渊的亵渎☆☆]:你将[{" .. targetName .. "/FCOLOR=243}]的[{" .. itemname .. "/FCOLOR=243}]打回背包...")
            Player.buffTipsMsg(Target,
                "[深渊的亵渎☆☆]:你被[{" .. myName .. "/FCOLOR=243}]将[{" .. itemname .. "/FCOLOR=243}]打回背包...")
        end
    end
end
-- 赤焰结晶  攻击时有概率对目标造成禁锢[3秒]且自身攻击力增加[30%](持续3秒) 1/138
ZhuangBeiBuffList[2025] = function(actor, Target, Hiter, MagicId)
    if randomex(1, 138) then
        changemode(Target, 11, 3, 1, 2) --禁锢范围3 禁锢时间5秒
        addbuff(actor, 30046, 3, 1, actor)
        local myName = Player.GetNameEx(actor)
        local targetName = Player.GetNameEx(Target)
        Player.buffTipsMsg(actor,
            "[赤焰结晶]:你将{" .. targetName .. "/FCOLOR=243}禁锢{3秒/FCOLOR=243}并增加攻击力{30%/FCOLOR=243}持续{3秒/FCOLOR=243}...")
        Player.buffTipsMsg(Target, "[赤焰结晶]:你被[{" .. myName .. "/FCOLOR=243}]禁锢{3秒/FCOLOR=243}...")
    end
end
-- 抉择 攻击有概率打掉目标[30%]的生命值自身减少[10%]的生命值(仅PK触发) 1/158概率
ZhuangBeiBuffList[2026] = function(actor, Target, Hiter, MagicId)
    if randomex(1, 158) then
        humanhp(Target, "-", Player.getHpValue(Target, 30), 1, 0, actor) --打掉目标[30%]
        humanhp(actor, "-", Player.getHpValue(actor, 10), 1, 0, Target)  --自身减少[10%]
        local targetName = Player.GetNameEx(Target)
        Player.buffTipsMsg(actor,
            "[抉择]: 将{" .. targetName .. "/FCOLOR=243}的血量斩杀{30%/FCOLOR=243}并自己的血量减少{10%/FCOLOR=243}...")
    end
end
-- 天殇之痕 攻击时有概率清空目标所有的防御力10秒   并且斩杀目标[10%]的最大生命值！1/108 概率
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
        humanhp(Target, "-", Player.getHpValue(Target, 10), 1, 0, actor) --自身减少[10%]

        local myName = Player.GetNameEx(actor)
        local targetName = Player.GetNameEx(Target)
        Player.buffTipsMsg(actor,
            "[天殇之痕]:使{" .. targetName .. "/FCOLOR=243}进入{防御清空/FCOLOR=243}状态并附带斩杀{10%/FCOLOR=243}最大血量...")
        Player.buffTipsMsg(Target,
            "[天殇之痕]:{" .. myName .. "/FCOLOR=243}]使你进入{防御清空/FCOLOR=243}状态并附带斩杀{10%/FCOLOR=243}最大血量...")
    end
end
-- 灵魂洗礼  烈火剑法可斩杀目标[20%]的生命值
ZhuangBeiBuffList[2028] = function(actor, Target, Hiter, MagicId)
    if MagicId == 26 then
        humanhp(Target, "-", Player.getHpValue(Target, 20), 1, 0, actor)
        local targetName = Player.GetNameEx(Target)
        Player.buffTipsMsg(actor, "[灵魂洗礼]:释放烈火剑法斩杀{" .. targetName .. "/FCOLOR=243}{20%/FCOLOR=243}最大血量...")
    end
end
-- 命运的轮转   攻击时有概率切割目标[10%-50%]的生命值！且恢复自身[15%-30%]的血量！(BUFF效果只对人物生效) 1/138 概率
ZhuangBeiBuffList[2029] = function(actor, Target, Hiter, MagicId)
    if randomex(1, 138) then
        local tgtnum = math.random(10, 50)
        local mynum  = math.random(15, 30)
        humanhp(Target, "-", Player.getHpValue(Target, tgtnum), 1, 0, actor)
        humanhp(actor, "+", Player.getHpValue(actor, mynum), 4)

        local targetName = Player.GetNameEx(Target)
        Player.buffTipsMsg(actor,
            "[命运的轮转]:斩杀{" ..
            targetName .. "/FCOLOR=243}{" .. tgtnum .. "%/FCOLOR=243}最大血量并恢复自身{" .. mynum .. "%/FCOLOR=243}最大血量...")
    end
end
-- 拥抱黑暗吧 攻击时有概率将目标打入[致盲2秒] 1/128概率
ZhuangBeiBuffList[2030] = function(actor, Target, Hiter, MagicId)
    if randomex(1, 128) then
        local x, y = getconst(Target, "<$SCREENWIDTH>") / 2 - 20, getconst(Target, "<$SCREENHEIGHT>") / 2 + 50
        screffects(Target, 10, 17527, x, y, 1, 2, 0)
    end
end
-- 黑暗之触 攻击时有概率触发[即死判定]直接斩杀目标[100%]的最大生命值！ 1/388 概率
ZhuangBeiBuffList[2031] = function(actor, Target, Hiter, MagicId)
    if randomex(1, 388) then
        humanhp(Target, "-", Player.getHpValue(Target, 100), 1, 0, actor)
        local myName = Player.GetNameEx(actor)
        local targetName = Player.GetNameEx(Target)
        Player.buffTipsMsg(actor, "[黑暗之触]:斩杀了[{" .. targetName .. "/FCOLOR=243}]100%血量...")
        Player.buffTipsMsg(Target, "[黑暗之触]:你被[{" .. myName .. "/FCOLOR=243}],斩杀100%血量...")
    end
end

-- 魔族「传承」 攻击时有概率触发[即死判定]直接斩杀目标[100%]的最大生命值！ 1/88 概率
ZhuangBeiBuffList[2032] = function(actor, Target, Hiter, MagicId)
    if randomex(1, 88) then
        humanhp(Target, "-", Player.getHpValue(Target, 10), 1, 0, actor)
        humanhp(actor, "+", Player.getHpValue(actor, 10), 4)
        local myName = Player.GetNameEx(actor)
        local targetName = Player.GetNameEx(Target)
        Player.buffTipsMsg(actor, "[魔族「传承」]:斩杀了[{" .. targetName .. "/FCOLOR=243}]10%最大血量并恢复自身10%血量...")
        Player.buffTipsMsg(Target, "[魔族「传承」]:你被[{" .. myName .. "/FCOLOR=243}],斩杀10%最大血量...")
    end
end

-- 魔化的眼罩 1/128概率致盲2秒 对130级以上无效
ZhuangBeiBuffList[2033] = function(actor, Target, Hiter, MagicId)
    local TgtLevel = getbaseinfo(Target, ConstCfg.gbase.level)
    if TgtLevel > 130 then return end
    if randomex(1, 128) then
        local x, y = getconst(Target, "<$SCREENWIDTH>") / 2 - 20, getconst(Target, "<$SCREENHEIGHT>") / 2 + 50
        screffects(Target, 10, 17527, x, y, 1, 2, 0)
    end
end

-- 芭蕉扇 每次攻击扣除自身3%的最大MP值，并附带同等伤害 20%MP之下不触发
ZhuangBeiBuffList[2034] = function(actor, Target, Hiter, MagicId)
    local MyMp = Player.getMpPercentage(actor)
    if MyMp >= 20 then
        humanmp(actor, "-", Player.getMpValue(actor, 3))
        humanhp(Target, "-", Player.getHpValue(actor, 3), 106, 0, actor)
    end
end

-- 琥珀净瓶 攻击点名玩家有概率 收入瓶中世界5S，每秒扣初10%血量，5分钟CD
ZhuangBeiBuffList[2035] = function(actor, Target, Hiter, MagicId)
    local markname = getplaydef(actor, VarCfg["S$_琥珀净瓶标记"])
    if markname == "" then return end
    local tgtname = getbaseinfo(Target, ConstCfg.gbase.name)
    if tgtname ~= markname then return end
    local buff1
    hasbuff(actor, 31069)
    if buff1 then return end
    if randomex(2) then
        addbuff(actor, 31069, 300) --触发后添加buff计时  300s
        local oldMapId = getbaseinfo(Target, ConstCfg.gbase.mapid)
        local targetName = Player.GetNameEx(Target)
        local newMapId = targetName .. "y"
        local x = getbaseinfo(Target, ConstCfg.gbase.x)
        local y = getbaseinfo(Target, ConstCfg.gbase.y)
        addmirrormap("db001", newMapId, "瓶中世界" .. "(" .. targetName .. ")", 3, oldMapId, 0, x, y)
        local myName1 = Player.GetNameEx(actor)
        local targetName1 = Player.GetNameEx(Target)
        addbuff(Target, 31068, 5)
        Player.buffTipsMsg(actor, "[琥珀净瓶]:你将[{" .. targetName1 .. "/FCOLOR=243}]收入瓶中世界...")
        Player.buffTipsMsg(Target, "[琥珀净瓶]:你被[{" .. myName1 .. "/FCOLOR=243}]收入瓶中世界...")
        map(Target, newMapId)
    end
end

-- 群星之怒★★★ 对怪吸血5%(套装属性添加了)，1/128概率使对方进入 群星之怒buff 
ZhuangBeiBuffList[2036] = function(actor, Target, Hiter, MagicId)
    if randomex(1, 128) then
        local tgtbuff = hasbuff(Target, 31079)
        if tgtbuff then return  end
        addbuff(Target, 31079)
        local myName1 = Player.GetNameEx(actor)
        local targetName1 = Player.GetNameEx(Target)
        Player.buffTipsMsg(actor, "[群星之怒★★★]:你使[{" .. targetName1 .. "/FCOLOR=243}]受到了{群星之怒/FCOLOR=243}的打击...")
        Player.buffTipsMsg(Target, "[群星之怒★★★]:你被[{" .. myName1 .. "/FCOLOR=243}]施加了{群星打击/FCOLOR=243}状态...")
    end
end

-- 星辉·猎杀狩命 致命伤害 触发致命一击时概率斩杀5%最大生命（1/128）
ZhuangBeiBuffList[2037] = function(actor, Target, Hiter, MagicId)
    if randomex(1, 128) then
        humanhp(Target, "-", Player.getHpValue(Target, 5), 106)
        local myName1 = Player.GetNameEx(actor)
        local targetName1 = Player.GetNameEx(Target)
        Player.buffTipsMsg(actor, "[星辉·猎杀狩命]:你打掉了[{" .. targetName1 .. "/FCOLOR=243}]最大{5%/FCOLOR=243}生命...")
        Player.buffTipsMsg(Target, "[星辉·猎杀狩命]:你被[{" .. myName1 .. "/FCOLOR=243}]打掉了{5%/FCOLOR=243}最大生命...")
    end
end

-- ◆黑洞◆ 攻击人物有3%概率致盲3秒.对等级高于自身的人无效
ZhuangBeiBuffList[2038] = function(actor, Target, Hiter, MagicId)
    local MyLevel  = getbaseinfo(actor, ConstCfg.gbase.level)
    local TgtLevel = getbaseinfo(Target, ConstCfg.gbase.level)
    if TgtLevel > MyLevel then return end
    if randomex(3, 100) then
        local x, y = getconst(Target, "<$SCREENWIDTH>") / 2 - 20, getconst(Target, "<$SCREENHEIGHT>") / 2 + 50
        screffects(Target, 10, 17527, x, y, 1, 3, 0)
    end
end

--攻击怪物触发（3000开头）
--攻击时有概率切割怪物[1%-3%]的最大生命值！(对极少数BOSS不生效)

--天神指环  攻击怪物时概率切割1%-3%最大血量  触发概率1/128
ZhuangBeiBuffList[3000] = function(actor, Target, Hiter, MagicId)
    local targetNmae = getbaseinfo(Target, ConstCfg.gbase.name)
    local cfg = cfg_IsBoss[targetNmae] --不生效的BOSS
    if cfg then return end
    if randomex(1, 128) then
        local qiGe = math.random(3)
        humanhp(Target, "-", Player.getHpValue(Target, qiGe), 106, 0, actor)
        Player.buffTipsMsg(actor, "[天神指环]:切割怪物[{" .. qiGe .. "%/FCOLOR=243}]最大血量...")
    end
end
-- 〈御风·斩浪〉 攻击对(5000W生命值)以下的怪物时触发刀刀切割[2%]的最大生命值！
ZhuangBeiBuffList[3001] = function(actor, Target, Hiter, MagicId)
    local monhpmavx = getbaseinfo(Target, ConstCfg.gbase.maxhp)
    if monhpmavx <= 50000000 then
        humanhp(Target, "-", Player.getHpValue(Target, 2), 106, 0, actor)
        -- Player.buffTipsMsg(actor, "[〈御风·斩浪〉]:切割怪物[2%/FCOLOR=243}]最大血量...")
    end
end
-- 万雷   攻击时有概率直接打掉神龙帝国内的怪物(5%)最大生命值(BOSS效果为1%) 1/128 概率
ZhuangBeiBuffList[3002] = function(actor, Target, Hiter, MagicId)
    if randomex(1, 128) then
        local monname = getbaseinfo(Target, ConstCfg.gbase.name)
        if cfg_ShenLongDiGuo[monname] then
            humanhp(Target, "-", Player.getHpValue(Target, cfg_ShenLongDiGuo[monname].Damage), 106, 0, actor) --刀刀斩血
        end
    end
end
-- -- 预言者  当持有者学习[圆弧之刃]技能后触发攻击时对(3*3)范围内的怪物造成攻击力[*66%]的对怪切割！
-- ZhuangBeiBuffList[3003] = function(actor, Target, Hiter, MagicId)
--     if MagicId == 12 then
--         local dcnum = getbaseinfo(actor, ConstCfg.gbase.dc2)
--         local selfx = getbaseinfo(actor, ConstCfg.gbase.x)
--         local selfy = getbaseinfo(actor, ConstCfg.gbase.y)
--         rangeharm(actor, selfx, selfy, 3, 0, 6, dcnum*0.66, 0, 2)
--     end
-- end
-- 黄泉  每十三刀会触发对(3*3)范围内的所有怪物造成(66万)的对怪切割！
ZhuangBeiBuffList[3004] = function(actor, Target, Hiter, MagicId)
    local monname = getbaseinfo(Target, ConstCfg.gbase.name)
    if cfg_BuBeiQieGeMon[monname] then return end

    local daoshunum = getplaydef(actor, VarCfg["N$_黄泉刀数"])
    if daoshunum >= 13 then
        local selfx = getbaseinfo(actor, ConstCfg.gbase.x)
        local selfy = getbaseinfo(actor, ConstCfg.gbase.y)
        rangeharm(actor, selfx, selfy, 3, 0, 6, 660000, 0, 2)
        setplaydef(actor, VarCfg["N$_黄泉刀数"], 0) --刀数归零
        Player.buffTipsMsg(actor, "[黄泉]:切割3*3范围内怪物[{66万/FCOLOR=243}]血量...")
    else
        setplaydef(actor, VarCfg["N$_黄泉刀数"], daoshunum + 1) --刀数加1
    end
end
--鬼魅之踪 攻击生命值低于(20%)的怪物时触发 造成[2.0]倍对怪切割的伤害！
ZhuangBeiBuffList[3005] = function(actor, Target, Hiter, MagicId)
    local calculate = Player.getHpPercentage(Target)
    if calculate <= 20 then
        local qiege = getbaseinfo(actor, 51, 200)
        humanhp(Target, "-", qiege * 2, 106, 0, actor)
    end
end
--天下霸唱 攻击时有概率切割怪物[1%-3%]的最大生命值！(对极少数BOSS不生效)
ZhuangBeiBuffList[3006] = function(actor, Target, Hiter, MagicId)
    local monname = getbaseinfo(Target, ConstCfg.gbase.name)
    if not cfg_BuBeiQieGeMon[monname] then
        if randomex(1, 128) then
            local num = math.random(1, 3)
            humanhp(Target, "-", Player.getHpValue(Target, num), 106, 0, actor) --切割最大血量1-3%
        end
    end
end
--大天使的神威 攻击时刀刀切割怪物[1%]的生命值(切割效果对极少数BOSS无法生效)
ZhuangBeiBuffList[3007] = function(actor, Target, Hiter, MagicId)
    local monname = getbaseinfo(Target, ConstCfg.gbase.name)
    if not cfg_BuBeiQieGeMon[monname] then
        humanhp(Target, "-", Player.getHpValue(Target, 1), 106, 0, actor) --切割最大血量1-3%
    end
end
--罗盘玫瑰  攻击时有概率切割怪物[1%-3%]的最大生命值！(对极少数BOSS不生效) 1/100 概率
ZhuangBeiBuffList[3008] = function(actor, Target, Hiter, MagicId)
    local monname = getbaseinfo(Target, ConstCfg.gbase.name)
    if not cfg_BuBeiQieGeMon[monname] then
        if randomex(1, 100) then
            local num = math.random(1, 3)
            humanhp(Target, "-", Player.getHpValue(Target, num), 106, 0, actor) --切割最大血量1-3%
        end
    end
end
--龙魂之力 攻击时有概率直接打掉极恶大陆内的 怪物(5%)最大生命值！ 1/128
ZhuangBeiBuffList[3009] = function(actor, Target, Hiter, MagicId)
    local monname = getbaseinfo(Target, ConstCfg.gbase.name)
    if not cfg_BuBeiQieGeMon[monname] then return end
    if randomex(1, 128) then
        humanhp(Target, "-", Player.getHpValue(Target, 5), 106, 0, actor) --切割最大血量5%
    end
end

--咆哮之意 攻击有概率切割怪物(5%)的生命值！ 1/100 概率
ZhuangBeiBuffList[3010] = function(actor, Target, Hiter, MagicId)
    local monname = getbaseinfo(Target, ConstCfg.gbase.name)
    if cfg_BuBeiQieGeMon[monname] then return end
    if randomex(1, 100) then
        humanhp(Target, "-", Player.getHpValue(Target, 5), 106, 0, actor) --刀刀斩血5%
    end
end
--法师拳套 打怪时附带[魔法力*50%]的对怪切割
ZhuangBeiBuffList[3011] = function(actor, Target, Hiter, MagicId)
    local monname = getbaseinfo(Target, ConstCfg.gbase.name)
    if cfg_BuBeiQieGeMon[monname] then return end
    local mcmax = getbaseinfo(actor, ConstCfg.gbase.mc2)
    humanhp(Target, "-", mcmax * 0.5, 106, 0, actor) --魔法50%切割
end
--厄运代言人 怪物生命值低于30%时刀刀切割[1%]
ZhuangBeiBuffList[3012] = function(actor, Target, Hiter, MagicId)
    local monname = getbaseinfo(Target, ConstCfg.gbase.name)
    if cfg_BuBeiQieGeMon[monname] then return end

    local nowmonhp = Player.getHpPercentage(Target)
    if nowmonhp <= 30 then
        humanhp(Target, "-", Player.getHpValue(Target, 1), 106, 0, actor) --刀刀斩血1%
    end
end
--老村长的怀表 攻击目标时每刀恢复[200]点生命值
ZhuangBeiBuffList[3013] = function(actor, Target, Hiter, MagicId)
    local nowmonhp = Player.getHpPercentage(actor)
    if nowmonhp >= 3 and nowmonhp ~= 100 then
        humanhp(actor, "+", 200, 4)
    end
end
--守夜人之徽 攻击目标时每刀恢复[388]点生命值
ZhuangBeiBuffList[3014] = function(actor, Target, Hiter, MagicId)
    if Player.canLifesteal(actor) then
        humanhp(actor, "+", 388, 4, nil, nil, nil)
    end
end

--蓝色恶魔之眼 [特殊BUFF]攻击时概率触发刀刀切割(1%)生命值(切割BUFF持续十秒,BUFF冷却120秒)  1/188 概率
ZhuangBeiBuffList[3015] = function(actor, Target, Hiter, MagicId)
    if randomex(1, 188) then
        local buff1 = hasbuff(actor, 30061)
        if not buff1 then
            addbuff(actor, 30061, 120, 1, actor)
            addbuff(actor, 30062, 10, 1, actor)
            Player.buffTipsMsg(actor, "[蓝色恶魔之眼]:刀刀切割怪物{1%/FCOLOR=243}血量,持续{10/FCOLOR=243}秒...")
        end
    end
    local buff2 = hasbuff(actor, 30062)
    if buff2 then
        humanhp(Target, "-", Player.getHpValue(Target, 1), 106, 0, actor) --刀刀斩血1%
    end
end

--血色之影 每秒恢复人物(等级*10)的生命值攻击时附带对(神龙帝国)区域内的怪物额外造成[55555]点对怪切割！
ZhuangBeiBuffList[3016] = function(actor, Target, Hiter, MagicId)
    local monname = getbaseinfo(Target, ConstCfg.gbase.name)
    if cfg_ShenLongDiGuo[monname] then
        humanhp(Target, "-", 55555, 106, 0, actor) --刀刀斩血55555
    end
end

-- 白骨之镰 攻击怪物时，1/128概率召唤一只骷髅协助你作战，1分钟叛变
ZhuangBeiBuffList[3017] = function(actor, Target, Hiter, MagicId)
    if randomex(1, 128) then
        recallmob(actor, "骷髅", 7, 1, 1)
    end
end

--光辉之怒·鸩 攻击怪物10%概率施加毒素,怪物每秒损失道术*150%的伤害,持续5秒
ZhuangBeiBuffList[3018] = function(actor, Target, Hiter, MagicId)
    if randomex(1, 10) then
        addbuff(Target, 31092, 5, 1, actor, nil)
    end
end

--迎新雪人 攻击时有概率召唤一只雪人帮助你战斗，持续30秒，雪人死亡时释放雪崩：对3X3范围内目标造成5000点固定伤害，并有50%的概率冰冻1S.
ZhuangBeiBuffList[3019] = function(actor, Target, Hiter, MagicId)
    if randomex(1, 188) then
        local x = getbaseinfo(actor,ConstCfg.gbase.x)
        local y = getbaseinfo(actor,ConstCfg.gbase.y)
        recallmobex(actor, "圣诞雪人", x, y, 0, 1, 5, 0, 1, 1, 0)
    end
end

-- 全部攻击前触发（掉血前）（4000开头）
--太虚古龙领域[完全体] 每三刀对人物造成[1.5倍]对怪切割   对怪物造成[2.0倍]对怪切割
ZhuangBeiBuffList[4000] = function(actor, Target, Hiter, MagicId, Damage, Model, attackDamageData)
    local daoshunum = getplaydef(actor, VarCfg["N$_古龙刀数"])
    if daoshunum >= 3 then
        if getbaseinfo(Target, -1) then --对人触发
            local damagenum = math.floor(Damage * 1.5)
            humanhp(Target, "-", damagenum, 106)
            setplaydef(actor, VarCfg["N$_古龙刀数"], 0)
            -- local myName = Player.GetNameEx(actor)
            -- local targetName = Player.GetNameEx(Target)
            -- Player.buffTipsMsg(actor, "[太虚古龙领域]:斩杀了[{" .. targetName .. "/FCOLOR=243}]的" .. damagenum .. "生命...")
            -- Player.buffTipsMsg(Target,  "[太虚古龙领域]:你被[{" .. myName .. "/FCOLOR=243}],斩杀" .. damagenum .. "生命...")
        else --对怪触发
            local monname = getbaseinfo(Target, ConstCfg.gbase.name)
            if cfg_BuBeiQieGeMon[monname] then return end
            humanhp(Target, "-", Damage * 2, 106, 0, actor)
            setplaydef(actor, VarCfg["N$_古龙刀数"], 0)
        end
    else
        setplaydef(actor, VarCfg["N$_古龙刀数"], daoshunum + 1) --刀数加1
    end
end

--帝国の神龙(幼年期)    开天烈火逐日伤害增加 2%  -- 26	烈火剑法-- 56	逐日剑法-- 66	开天斩
ZhuangBeiBuffList[4006] = function(actor, Target, Hiter, MagicId, Damage, Model, attackDamageData)
    if MagicId == 26 or MagicId == 66 or MagicId == 56 then
        attackDamageData.damage = attackDamageData.damage + math.floor(Damage * 0.02)
    end
end

--帝国の神龙(成长期)    开天烈火逐日伤害增加 4%
ZhuangBeiBuffList[4007] = function(actor, Target, Hiter, MagicId, Damage, Model, attackDamageData)
    if MagicId == 26 or MagicId == 66 or MagicId == 56 then
        attackDamageData.damage = attackDamageData.damage + math.floor(Damage * 0.04)
    end
end

--帝国の神龙(成熟期)    开天烈火逐日伤害增加 6%
ZhuangBeiBuffList[4008] = function(actor, Target, Hiter, MagicId, Damage, Model, attackDamageData)
    if MagicId == 26 or MagicId == 66 or MagicId == 56 then
        attackDamageData.damage = attackDamageData.damage + math.floor(Damage * 0.06)
    end
end
--帝国の神龙(完全体)    开天烈火逐日伤害增加 8%
ZhuangBeiBuffList[4009] = function(actor, Target, Hiter, MagicId, Damage, Model, attackDamageData)
    if MagicId == 26 or MagicId == 66 or MagicId == 56 then
        attackDamageData.damage = attackDamageData.damage + math.floor(Damage * 0.08)
    end
end
--帝国の神龙(究极体)    开天烈火逐日伤害增加 10%
ZhuangBeiBuffList[4010] = function(actor, Target, Hiter, MagicId, Damage, Model, attackDamageData)
    if MagicId == 26 or MagicId == 66 or MagicId == 56 then
        attackDamageData.damage = attackDamageData.damage + math.floor(Damage * 0.1)
    end
end
--神兵·雷神之威   攻击时有概率召唤天雷对[3*3范围]的目标麻痹(1S)，并造成5倍攻击力数值的对怪切割！(CD60秒)
ZhuangBeiBuffList[4011] = function(actor, Target, Hiter, MagicId, Damage, Model, attackDamageData)
    local buffCD = hasbuff(actor, 30010)
    if not buffCD then
        local tgtx, tgty = getbaseinfo(Target, ConstCfg.gbase.x), getbaseinfo(Target, ConstCfg.gbase.y)
        local dcnum = getbaseinfo(actor, ConstCfg.gbase.dc2)
        rangeharm(actor, tgtx, tgty, 3, dcnum * 5, 0, nil, nil, 0, 214) --雷击效果
        makeposion(Target, 5, 1, 0, 1)
        addbuff(actor, 30010, 60)
        Player.buffTipsMsg(actor, "[神兵·雷神之威]:召唤天雷对3*3范围的目标麻痹1秒,并造成5倍攻击力数值的对怪切割...")
    end

    if not getbaseinfo(Target, -1) then --对怪触发
        if Player.getHpPercentage(actor) >= 3 then
            humanhp(actor, "+", Damage * 0.05, 4)
        end
    end
end
-- 野火之握    施放技能后下次攻击造成[2]倍伤害!(60秒内只允许触发一次当前BUFF)
ZhuangBeiBuffList[4012] = function(actor, Target, Hiter, MagicId, Damage, Model, attackDamageData)
    local buffcd = hasbuff(actor, 30013)
    if not buffcd then
        if MagicId == 26 or MagicId == 66 or MagicId == 56 then
            addbuff(actor, 30013, 60, 1, actor)
            setplaydef(actor, VarCfg["S$_野火之握"], "可释放")
        end
    end
    if getplaydef(actor, VarCfg["S$_野火之握"]) == "可释放" then
        attackDamageData.damage = attackDamageData.damage + Damage
        setplaydef(actor, VarCfg["S$_野火之握"], "")
    end
end
--苦修者的秘籍   全技能伤害+ 10% 魔法盾技能等级：+ 1 技能伤害+10% 人物死亡3次后会摧毁苦修者的秘籍（3/3）
ZhuangBeiBuffList[4013] = function(actor, Target, Hiter, MagicId, Damage, Model, attackDamageData)
    if MagicId == 26 or MagicId == 66 or MagicId == 56 then
        attackDamageData.damage = attackDamageData.damage + (Damage * 0.1)
    end
end
--旧人归 暴击时概率切割目标(3%)最大生命值 (30秒内只允许触发一次当前BUFF) 1/88
ZhuangBeiBuffList[4014] = function(actor, Target, Hiter, MagicId, Damage, Model, attackDamageData)
    if Model == 1 then
        if randomex(1, 88) then
            local buffCd = hasbuff(actor, 30018)
            if not buffCd then
                humanhp(Target, "-", Player.getHpValue(Target, 3), 106, 0, actor) --触发暴击后 扣血3%
                addbuff(actor, 30018, 30, 1, actor)
                local targetName = Player.GetNameEx(Target)
                Player.buffTipsMsg(actor, "[旧人归]:触发暴击斩杀[{" .. targetName .. "/FCOLOR=243}]的3%血量...")
            end
        end
    end
end
--天恕  攻击目标时大量吸取目标生命值5%对怪吸血 人物3%血量以下不生效   PK时有概率将目标所有BUFF触发禁用1/128
ZhuangBeiBuffList[4015] = function(actor, Target, Hiter, MagicId, Damage, Model, attackDamageData)
    if getbaseinfo(Target, -1) then --对人触发
        if randomex(1, 128) then
            addbuff(Target, 30020, 10, 1, actor)
        end
    else
        if Player.canLifesteal(actor) then
            humanhp(actor, "+", Damage * 0.05, 4) --吸血5%
        end
    end
end
--勾魂夺魄  施放开天斩之后下次攻击必定能造成 [3.0]倍的对怪切割[CD:60秒]
ZhuangBeiBuffList[4016] = function(actor, Target, Hiter, MagicId, Damage, Model, attackDamageData)
    local f_var = getplaydef(actor, VarCfg["S$_勾魂夺魄"])
    local buffcd = hasbuff(actor, 30028)
    if MagicId == 66 then
        if f_var ~= "1" then
            setplaydef(actor, getplaydef(actor, VarCfg["S$_勾魂夺魄"]), "1")
        end
    end
    if not buffcd and f_var == "1" then
        attackDamageData = attackDamageData + Damage * 2
        setplaydef(actor, getplaydef(actor, VarCfg["S$_勾魂夺魄"]), "")
        addbuff(actor, 30028, 60, 1, actor)
        Player.buffTipsMsg(actor, "[勾魂夺魄]:本次伤害对怪造成[{3倍/FCOLOR=243}]伤害...")
    end
end
--悲鸣之焰  人物复活后触发隐身[2秒]下次攻击必定造成[3.0]倍伤害[CD:30秒]
ZhuangBeiBuffList[4017] = function(actor, Target, Hiter, MagicId, Damage, Model, attackDamageData)
    if getplaydef(actor, VarCfg["S$_悲鸣之焰"]) == "1" then
        attackDamageData.damage = attackDamageData.damage + Damage * 2
        Player.buffTipsMsg(actor, "[悲鸣之焰]:本次伤害对怪造成[{3倍/FCOLOR=243}]伤害...")
        setplaydef(actor, VarCfg["S$_悲鸣之焰"], "")
    end
end
--鬼面裁决 攻击目标时大量吸取生命值5%吸血  攻击人物时 刀刀触发斩杀人物3%生命值
ZhuangBeiBuffList[4018] = function(actor, Target, Hiter, MagicId, Damage, Model, attackDamageData)
    if getbaseinfo(Target, -1) then --如果打人
        humanhp(Target, "-", Player.getHpValue(Target, 3), 106, 0, actor)
        local targetName = Player.GetNameEx(Target)
        -- Player.buffTipsMsg(actor, "[鬼面裁决]:刀刀斩杀[{"..targetName.."/FCOLOR=243}]3%最大血量...")
    else
        if Player.canLifesteal(actor) then
            humanhp(actor, "+", Damage * 0.05, 1, nil, nil, nil) --吸血5%
        end
    end
end
--无尽的华尔兹 攻击是有概率连续造成8连击 每次造成最大伤害值的70%   30秒只触发一次
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
--寒霜之握 每八刀下次2倍伤害
ZhuangBeiBuffList[4020] = function(actor, Target, Hiter, MagicId, Damage, Model, attackDamageData)
    local daoshunum = getplaydef(actor, VarCfg["N$_寒霜之握"])
    if daoshunum >= 8 then
        setplaydef(actor, VarCfg["N$_寒霜之握"], 0) --刀数归0
        attackDamageData.damage = attackDamageData.damage + Damage
    else
        setplaydef(actor, VarCfg["N$_寒霜之握"], daoshunum + 1) --刀数加1
    end
end

--天空的引路人 释放技能后下次攻击造成2倍伤害 30SCD
ZhuangBeiBuffList[4021] = function(actor, Target, Hiter, MagicId, Damage, Model, attackDamageData)
    local buffcd = hasbuff(actor, 30038)
    if not buffcd then
        if MagicId == 26 or MagicId == 66 or MagicId == 56 then
            attackDamageData.damage = attackDamageData.damage + Damage
            addbuff(actor, 30038, 30, 1, actor)
            Player.buffTipsMsg(actor, "[天空引路人]:触发双倍伤害...")
        end
    end
end

--格萨拉克·地渊之声 对怪5%吸血 对人 血量大于98% 1/5概率 斩杀对放50%血量 并将武器打回背包  且有缴械buff（3s无法穿戴武器）
ZhuangBeiBuffList[4022] = function(actor, Target, Hiter, MagicId, Damage, Model, attackDamageData)
    if getbaseinfo(Target, -1) then --对人触发
        local TgtHp = Player.getHpPercentage(Target)
        if TgtHp >= 98 then
            if randomex(20,100) then
                if Player.checkCd(actor, VarCfg["格萨拉克·地渊之声CD"], 10, true) then
                    local itemobj = linkbodyitem(Target, 1)
                    local itemidx = getiteminfo(Target, itemobj, 1)
                    takeoffitem(Target, 1, itemidx)
                    humanhp(Target, "-", Player.getHpValue(Target, 50), 106, 0, actor) --刀刀斩血1%
                    addbuff(Target, 30041, 30, 1, actor)
                    Player.buffTipsMsg(actor, "[格萨拉克·地渊之声]:斩杀对方{50%/FCOLOR=243}血量,并附加缴械状态{3/FCOLOR=243}秒...")
                end
            end
        end
    else --对怪触发
        if Player.canLifesteal(actor) then
            humanhp(actor, "+", Damage * 0.05, 4)
        end
    end
end
--一剑开天门 破复活几率：+ 5% 攻击时有概率斩杀人物[15%]生命值 1/128
ZhuangBeiBuffList[4023] = function(actor, Target, Hiter, MagicId, Damage, Model, attackDamageData)
    if getbaseinfo(Target, -1) then                                  --对人触发
        if randomex(1, 128) then
            humanhp(Target, "-", Player.getHpValue(Target, 15), 106, 0, actor) --斩血15%
            Player.buffTipsMsg(actor, "[一剑开天门]:斩杀对方{15%/FCOLOR=243}血量...")
        end
    else --对怪触发
        if Player.canLifesteal(actor) then
            humanhp(actor, "+", Damage * 0.05, 4)
        end
    end
end
--封龙劍メ驱逐之刃 攻击目标时大量吸取目标生命值 攻击时斩杀生命值低于(30%)的目标 (对超级BOSS效果只斩杀15%生命值) (该BUFF对人物有效·内置15秒的CD)
ZhuangBeiBuffList[4024] = function(actor, Target, Hiter, MagicId, Damage, Model, attackDamageData)
    if getbaseinfo(Target, -1) then --对人触发
        local tgtmaxHp = Player.getHpPercentage(Target)
        if tgtmaxHp <= 30 then
            local buffcd = hasbuff(actor, 30048)
            if not buffcd then
                humanhp(Target, "-", Player.getHpValue(Target, tgtmaxHp), 106, 0, actor) --斩血 30
                addbuff(actor, 30048, 15, 1, actor)
            end
        end
    else --对怪触发
        if Player.canLifesteal(actor) then
            humanhp(actor, "+", Damage * 0.05, 4)
        end
        local monname = getbaseinfo(Target, ConstCfg.gbase.name)
        if cfg_BuBeiQieGeMon[monname] then --这是BOSS
            local tgtmaxHp = Player.getHpPercentage(Target)
            if tgtmaxHp <= 15 then
                local buffcd = hasbuff(actor, 30048)
                if not buffcd then
                    killmonbyobj(actor, Target, true, true, true) --杀死怪物
                    addbuff(actor, 30048, 15, 1, actor)
                    Player.buffTipsMsg(Target, "[封龙劍メ驱逐之刃]:斩杀血量低于{15%/FCOLOR=243}的BOSS怪物...")
                end
            end
        else --这不是BOSS
            local tgtmaxHp = Player.getHpPercentage(Target)
            if tgtmaxHp <= 30 then
                local buffcd = hasbuff(actor, 30048)
                if not buffcd then
                    killmonbyobj(actor, Target, true, true, true) --杀死怪物
                    addbuff(actor, 30048, 15, 1, actor)
                    Player.buffTipsMsg(Target, "[封龙劍メ驱逐之刃]:斩杀血量低于{30%/FCOLOR=243}的怪物...")
                end
            end
        end
    end
end

--魔渊面具 施放技能后下次攻击造成[3]倍伤害!(20秒内只允许触发一次当前BUFF)
ZhuangBeiBuffList[4025] = function(actor, Target, Hiter, MagicId, Damage, Model, attackDamageData)
    if MagicId == 26 or MagicId == 66 or MagicId == 56 then --对人触发
        setplaydef(actor, VarCfg["S$_魔渊面具"], 1)
    end
    if getplaydef(actor, VarCfg["S$_魔渊面具"]) == "1" then
        local buff = hasbuff(actor, 30049)
        if not buff then
            attackDamageData.damage = attackDamageData.damage + Damage * 2
            Player.buffTipsMsg(actor, "[魔渊面具]:对怪物造成{3/FCOLOR=243}倍伤害...")
            setplaydef(actor, VarCfg["S$_魔渊面具"], "")
            addbuff(actor, 30049, 20, 1, actor)
        end
    end
end
--信念支柱 攻击时有概率触发造成[5.0倍]伤害并且恢复自身(20%)的最大生命值！ 1/188概率
ZhuangBeiBuffList[4026] = function(actor, Target, Hiter, MagicId, Damage, Model, attackDamageData)
    if randomex(1, 188) then
        attackDamageData.damage = attackDamageData.damage + Damage * 4 --造成5倍伤害
        humanhp(actor, "+", Player.getHpValue(actor, 20), 4)           --恢复自身20%生命
        local targetName = Player.GetNameEx(Target)
        Player.buffTipsMsg(actor, "[信念支柱]:{" .. targetName ..
            "/FCOLOR=243}造成{5/FCOLOR=243}倍伤害,并恢复自身{20%/FCOLOR=243}血量...")
    end
end

--星瀚之力 暴击时概率切割目标(5%)最大生命值(30秒内只允许触发一次当前的BUFF) 1/88 概率
ZhuangBeiBuffList[4027] = function(actor, Target, Hiter, MagicId, Damage, Model, attackDamageData)
    if Model == 1 then
        if randomex(1, 88) then
            local buff = hasbuff(actor, 30060)
            if not buff then
                humanhp(Target, "-", Player.getHpValue(Target, 5), 106, 0, actor) --触发暴击后 扣血5%
                addbuff(actor, 30060, 30, 1, actor)
                local targetName = Player.GetNameEx(Target)
                Player.buffTipsMsg(actor, "[星瀚之力]:对{" ..
                    targetName .. "/FCOLOR=243}造成{5%/FCOLOR=243}血量的{斩杀/FCOLOR=243}伤害...")
            end
        end
    end
end

--【EX级】哀霜之触 攻击触发(暴击)时有概率激活一次双重打击效果！  1/188 概率
ZhuangBeiBuffList[4028] = function(actor, Target, Hiter, MagicId, Damage, Model, attackDamageData)
    if Model == 1 then
        if randomex(1, 188) then
            attackDamageData.damage = attackDamageData.damage + Damage
            Player.buffTipsMsg(actor, "[【EX级】哀霜之触]:触发暴击后激活{2/FCOLOR=243}倍打击效果...")
        end
    end
end

--忍者面具 复活后进入隐身状态[两秒]并且下次攻击造成[3.0]倍伤害。
ZhuangBeiBuffList[4029] = function(actor, Target, Hiter, MagicId, Damage, Model, attackDamageData)
    if getplaydef(actor, VarCfg["S$_忍者面具"]) == "1" then
        if not Player.checkCd(actor, VarCfg["隐身CD"], 60, true) then return end

        attackDamageData.damage = attackDamageData.damage + Damage * 2
        Player.buffTipsMsg(actor, "[忍者面具]:对目标造成3倍伤害...")
        setplaydef(actor, VarCfg["S$_忍者面具"], "")
    end
end

--死亡笔记 人物死亡后记录[击杀者]的游戏名称下次与目标PK时增加[20%]的伤害值
ZhuangBeiBuffList[4030] = function(actor, Target, Hiter, MagicId, Damage, Model, attackDamageData)
    local notesname = getplaydef(actor, VarCfg["S$_死亡笔记标记"])
    local targetName = Player.GetNameEx(Target)
    if notesname == targetname then
        attackDamageData = attackDamageData.damage + Damage * 0.2
    end
end

--古核武·变异基因体  变异④：直接斩杀血量低于10%的怪物  变异⑤：攻击时有概率触发1-3倍多重攻击
ZhuangBeiBuffList[4031] = function(actor, Target, Hiter, MagicId, Damage, Model, attackDamageData)
    local itemobj = linkbodyitem(actor, 26)
    local usenum = getitemaddvalue(actor, itemobj, 2, 19, nil) --获取鉴定属性编号
    if usenum == 4 then
        local tgtmaxHp = Player.getHpPercentage(Target)
        if tgtmaxHp <= 10 then
            killmonbyobj(actor, Target, true, true, true) --杀死怪物
            Player.buffTipsMsg(actor, "[古核武·变异基因体]:变异{4/FCOLOR=243}号属性,直接斩杀血量低于{10%/FCOLOR=243}的怪物...")
        end
    elseif usenum == 5 then
        if randomex(1, 88) then
            local number = math.random(1, 3)
            attackDamageData.damage = attackDamageData.damage + Damage * number
            Player.buffTipsMsg(actor, "[古核武·变异基因体]:变异{5/FCOLOR=243}号属性,触发{" .. number + 1 .. "重/FCOLOR=243}攻击...")
        end
    end
end

--悲鸣之泣 (非战斗状态下)使用十步一杀会触发接下来第一刀必定会麻痹目标[1秒]
ZhuangBeiBuffList[4032] = function(actor, Target, Hiter, MagicId, Damage, Model, attackDamageData)
    local buff = hasbuff(actor, 10001)
    if not buff then
        if MagicId == 82 then
            local x, y = getbaseinfo(Target, ConstCfg.gbase.x), getbaseinfo(Target, ConstCfg.gbase.y)
            rangeharm(actor, x, y, 0, 0, 2, 1, 1, 0, 20500) -- 冰冻2*2范围内敌人1秒
            playsound(actor, 100001, 1, 0)                  --播放冰冻音效
        end
    end
end

--对被冰冻的目标造成额外30%的伤害
ZhuangBeiBuffList[4033] = function(actor, Target, Hiter, MagicId, Damage, Model, attackDamageData)
    local result1, result2 = checkhumanstate(Target, 7)
    -- makeposion(Target, 12, 100)
    if result1 then
        attackDamageData.damage = attackDamageData.damage + math.floor(Damage * 0.3)
        Player.buffTipsMsg(actor, "[霜冻守护の心]:对被冰冻的目标造成额外30%伤害")
    end
end

--天元之奕·冰霜凝视 攻击有5%的几率使目标陷入寒噤状态，持续3秒，使其攻击力和法术强度降低30%。同时还有2%的几率使怪物陷入冰冻状态，持续1.5秒。
ZhuangBeiBuffList[4034] = function(actor, Target, Hiter, MagicId, Damage, Model, attackDamageData)
    if getbaseinfo(Target, -1) then   --对人触发
        if randomex(5, 100) then
            addbuff(Target, 31055, 5) --DBuff
        end
    else                              --对怪触发
        if randomex(2, 100) then
            local x, y = getbaseinfo(Target, ConstCfg.gbase.x), getbaseinfo(Target, ConstCfg.gbase.y)
            rangeharm(actor, x, y, 0, 0, 2, 1, 0, 2, 20500) -- 冰冻2*2范围内敌人1秒
            playsound(actor, 100001, 1, 0)                  --播放冰冻音效
        end
    end
end

--天之剑·碎月 每三刀对人物造成[1.5倍]对怪切割   对怪物造成[2.0倍]对怪切割
ZhuangBeiBuffList[4035] = function(actor, Target, Hiter, MagicId, Damage, Model, attackDamageData)
    local monname = getbaseinfo(Target, ConstCfg.gbase.name)
    if cfg_BuBeiQieGeMon[monname] then return end

    local daoshunum = getplaydef(actor, VarCfg["N$_碎月刀数"])
    if daoshunum >= 3 then
        if getbaseinfo(Target, -1) then --对人触发
            local damagenum = math.floor(Damage * 1.5)
            humanhp(Target, "-", damagenum, 106, 0, actor)
            setplaydef(actor, VarCfg["N$_碎月刀数"], 0)
        else --对怪触发
            humanhp(Target, "-", Damage * 2, 106, 0, actor)
            setplaydef(actor, VarCfg["N$_碎月刀数"], 0)
        end
    else
        setplaydef(actor, VarCfg["N$_碎月刀数"], daoshunum + 1) --刀数加1
    end
end

--星光 技能伤害+5%
ZhuangBeiBuffList[4036] = function(actor, Target, Hiter, MagicId, Damage, Model, attackDamageData)
    if MagicId == 26 or MagicId == 66 or MagicId == 56 then
        attackDamageData.damage = attackDamageData.damage + (Damage * 0.05)
    end
end

--终结者 每间隔9S设置一次重击状态
ZhuangBeiBuffList[4037] = function(actor, Target, Hiter, MagicId, Damage, Model, attackDamageData)
    if getplaydef(actor, VarCfg["S$_终结者"]) ~= "可释放" then return end
    attackDamageData.damage = attackDamageData.damage + (Damage * 0.5)
    setplaydef(actor, VarCfg["S$_终结者"], "")
end

--夜风·不败剑意  人物展开战斗后进入武神状态，该状态人物攻防将大幅度提升，武神状态每次只能维持5秒  （伤害吸收+20%  攻击伤害+20%）
ZhuangBeiBuffList[4038] = function(actor, Target, Hiter, MagicId, Damage, Model, attackDamageData)
    local isFight = hasbuff(actor, 10001) --获取战斗状态
    if not isFight then
        addbuff(actor, 31080)
    end
end

--万法面具  与人物展开战斗后5秒内获得30%防止暴击几率加成
ZhuangBeiBuffList[4039] = function(actor, Target, Hiter, MagicId, Damage, Model, attackDamageData)
    local isFight = hasbuff(actor, 10001) --获取战斗状态
    if not isFight then
        addbuff(actor, 31093, 5, 1, actor, nil)
    end
end

-- 龙之力·不灭光剑!  攻击目标时大量吸取目标生命值每三刀对人物造成[3.0倍]伤害 每三刀对怪物造成[5.0倍]伤害
ZhuangBeiBuffList[4040] = function(actor, Target, Hiter, MagicId, Damage, Model, attackDamageData)
    local daoshunum = getplaydef(actor, VarCfg["N$_龙之力刀数"])
    daoshunum = daoshunum + 1
    if getbaseinfo(Target, -1) then --对人触发
        if daoshunum >= 3 then
            attackDamageData.damage = attackDamageData.damage + Damage * 2
            setplaydef(actor, VarCfg["N$_龙之力刀数"], 0) --刀数归0
            return
        end
        setplaydef(actor, VarCfg["N$_龙之力刀数"], daoshunum) --刀数加1
    else --对怪触发
        local monname = getbaseinfo(Target, ConstCfg.gbase.name)
        if cfg_BuBeiQieGeMon[monname] then return end
        humanhp(actor, "+", Damage * 0.05, 4)
        if daoshunum >= 3 then
            attackDamageData.damage = attackDamageData.damage + Damage * 4
            setplaydef(actor, VarCfg["N$_龙之力刀数"], 0) --刀数归0
            return
        end
        setplaydef(actor, VarCfg["N$_龙之力刀数"], daoshunum) --刀数加1
    end
end

--攻击人前触发（掉血前）（5000开头）
-- 小妖魔吊坠♀ 攻击时有概率切割目标[10%-50%]的
ZhuangBeiBuffList[5000] = function(actor, Target, Hiter, MagicId, Damage, Model, attackDamageData)
    if randomex(1, 118) then
        local dechp = math.random(10, 50)                           --随机值10-50
        humanhp(Target, "-", Player.getHpValue(Target, dechp), 106, 0, actor) --斩血 随机值10-50
        local myName = Player.GetNameEx(actor)
        local targetName = Player.GetNameEx(Target)
        Player.buffTipsMsg(actor, "[小妖魔吊坠♀]:斩杀了[{" .. targetName .. "/FCOLOR=243}]" .. dechp .. "%最大血量...")
        Player.buffTipsMsg(Target, "[小妖魔吊坠♀]:你被[{" .. myName .. "/FCOLOR=243}],斩杀" .. dechp .. "%最大血量...")
    end
end

-- 〈古龙·意志〉 每三刀对人物造成[1.5倍]对怪切割
ZhuangBeiBuffList[5001] = function(actor, Target, Hiter, MagicId, Damage, Model, attackDamageData)
    local daoshunum = getplaydef(actor, VarCfg["N$_古龙刀数"])
    if daoshunum >= 3 then
        humanhp(Target, "-", Damage * 1.5, 106, 0, actor)
        setplaydef(actor, VarCfg["N$_古龙刀数"], 0) --刀数归0
        -- local myName = Player.GetNameEx(actor)
        -- local targetName = Player.GetNameEx(Target)
        -- Player.buffTipsMsg(actor, "[〈古龙·意志〉]:斩杀了[{" .. targetName .. "/FCOLOR=243}]"..Damage * 1.5 .."生命...")
        -- Player.buffTipsMsg(Target,  "[〈古龙·意志〉]:你被[{" .. myName .. "/FCOLOR=243}],斩杀"..Damage * 1.5 .."生命...")
    else
        setplaydef(actor, VarCfg["N$_古龙刀数"], daoshunum + 1) --刀数加1
    end
end
--死亡之戒 攻击满血人物直接斩杀(10%)生命值 (60秒内只允许触发一次当前BUFF)
ZhuangBeiBuffList[5002] = function(actor, Target, Hiter, MagicId, Damage, Model, attackDamageData)
    local buffcd = hasbuff(actor, 30012)
    if not buffcd then
        local tgtplayhp = Player.getHpPercentage(Target)
        if tgtplayhp == 100 then
            humanhp(Target, "-", Player.getHpValue(Target, 10), 106, 0, actor)
            addbuff(actor, 30012, 60, 1, actor)
            local myName = Player.GetNameEx(actor)
            local targetName = Player.GetNameEx(Target)
            Player.buffTipsMsg(actor, "[死亡之戒]:斩杀了[{" .. targetName .. "/FCOLOR=243}]10%最大血量...")
            Player.buffTipsMsg(Target, "[死亡之戒]:你被[{" .. myName .. "/FCOLOR=243}],斩杀10%最大血量...")
        end
    end
end
-- 天煞符 激活标记效果：(@标记+目标名字) 攻击对标记目标的[总伤害增加15%] (小退后增伤效果失效需要重新标记)
ZhuangBeiBuffList[5003] = function(actor, Target, Hiter, MagicId, Damage, Model, attackDamageData)
    local markname = getplaydef(actor, VarCfg["S$_追杀标记"])
    if markname == "" then return end
    local tgtname = getbaseinfo(Target, ConstCfg.gbase.name)
    if tgtname ~= markname then return end
    attackDamageData.damage = attackDamageData.damage + (Damage * 0.15)
end
-- 噩梦之首★★ 激活标记效果：(@标记+目标名字) 攻击对标记目标的[总伤害增加15%] (小退后增伤效果失效需要重新标记)
ZhuangBeiBuffList[5004] = function(actor, Target, Hiter, MagicId, Damage, Model, attackDamageData)
    local markname = getplaydef(actor, VarCfg["S$_追杀标记"])
    if markname ~= "" then
        local tgtname = getbaseinfo(Target, ConstCfg.gbase.name)
        if tgtname ~= markname then
            return
        else
            attackDamageData.damage = attackDamageData.damage + (Damage * 0.15)
        end
    end
end
-- 时间之轮·聚变 攻击满血人物直接斩杀(30%)生命值(60秒内只允许触发一次当前BUFF)
ZhuangBeiBuffList[5005] = function(actor, Target, Hiter, MagicId, Damage, Model, attackDamageData)
    local tgtplayhp = Player.getHpPercentage(Target)
    if tgtplayhp == 100 then
        local buff = hasbuff(actor, 30054)
        if not buff then
            humanhp(Target, "-", Player.getHpValue(Target, 30), 106, 0, actor)
            addbuff(actor, 30054, 60, 1, actor)
            local targetName = Player.GetNameEx(Target)
            Player.buffTipsMsg(actor, "[时间之轮·聚变]:斩杀了[{" .. targetName .. "/FCOLOR=243}]30%最大血量...")
        end
    end
end

-- “破晓之眼” 攻击时斩杀生命值低于(20%)的目标(该BUFF对人物有效·内置10秒的CD)
ZhuangBeiBuffList[5007] = function(actor, Target, Hiter, MagicId, Damage, Model, attackDamageData)
    local tgtplayhp = Player.getHpPercentage(Target)
    if tgtplayhp < 20 then
        local buff = hasbuff(Target, 30059)
        if not buff then
            humanhp(Target, "-", Player.getHpValue(Target, tgtplayhp), 106, 0, actor) --斩杀目标剩余血量
            playeffect(Target, 16020, 0, 0, 1, 0, 0)
            addbuff(actor, 30059, 10, 1, actor)
            local targetName = Player.GetNameEx(Target)
            Player.buffTipsMsg(actor, "[“破晓之眼”]:{" .. targetName .. "/FCOLOR=243}生命低于{20%/FCOLOR=243},直接将其斩杀...")
        end
    end
end

--·聖裁降臨SSS· 每秒恢复人物(等级*10)的生命值当生命值低于[50%]时触发下一次攻击切割人物(20%)的生命值(CD120秒)
ZhuangBeiBuffList[5008] = function(actor, Target, Hiter, MagicId, Damage, Model, attackDamageData)
    local calculate = Player.getHpPercentage(actor)
    if calculate < 50 then
        local buff = hasbuff(actor, 30072)
        if not buff then
            humanhp(Target, "-", Player.getHpValue(Target, 20), 106, 0, actor) --切割20%血量
            addbuff(actor, 30072, 120, 1, actor)
            local targetName = Player.GetNameEx(Target)
            Player.buffTipsMsg(actor, "[·聖裁降臨SSS·]:斩杀[{" .. targetName .. "/FCOLOR=243}]{20%/FCOLOR=243}的血量...")
        end
    end
end

--天妖现世·荡魔逆仙  栩栩如生的死亡复活时概率给予自身一个印记  下一刀必定斩杀对手99%血量
ZhuangBeiBuffList[5009] = function(actor, Target, Hiter, MagicId, Damage, Model, attackDamageData)
    local buff = hasbuff(actor, 31060)
    if buff then
        humanhp(Target, "-", Player.getHpValue(Target, 99), 106, 0, actor) --切割99%血量
        local targetName = Player.GetNameEx(Target)
        Player.buffTipsMsg(actor, "[·聖裁降臨SSS·]:斩杀[{" .. targetName .. "/FCOLOR=243}]{99%/FCOLOR=243}的血量...")
        delbuff(actor, 31060)
    end
end

--新月领域△核心 概率强制对手和平模式3秒 概率禁锢对手1秒 概率击退对手1格     概率1/10   60S CD
ZhuangBeiBuffList[5010] = function(actor, Target, Hiter, MagicId, Damage, Model, attackDamageData)
    local buffCD = hasbuff(actor, 31081)
    if buffCD then return end
    if randomex(1, 10) then
        addbuff(actor, 31081, 60)  --进来 给自己添加倒计时buff
        local buffSort = math.random(1, 3)
        local myName = Player.GetNameEx(actor)
        local targetName = Player.GetNameEx(Target)
        if buffSort == 1 then
            setattackmode(Target, 1, 3)                                --修改对方攻击状态 和平
            Player.buffTipsMsg(actor, "[新月领域△核心]:使[{" .. targetName .. "/FCOLOR=243}]进入和平模式{3/FCOLOR=243}秒...")
            Player.buffTipsMsg(Target, "[新月领域△核心]:你被[{" .. myName .. "/FCOLOR=243}],施加了强制和平状态{3/FCOLOR=243}秒...")
        elseif buffSort == 2 then
            changemode(Target, 11, 1, 2, 2)                            --禁锢范围2 禁锢时间1秒
            Player.buffTipsMsg(actor, "[新月领域△核心]:使[{" .. targetName .. "/FCOLOR=243}]进入禁锢状态{1/FCOLOR=243}秒...")
            Player.buffTipsMsg(Target, "[新月领域△核心]:你被[{" .. myName .. "/FCOLOR=243}],施加了禁锢状态{1/FCOLOR=243}秒...")
        elseif buffSort == 3 then
            local x, y = getbaseinfo(Target, ConstCfg.gbase.x), getbaseinfo(Target, ConstCfg.gbase.y)
            rangeharm(actor, x, y, 1, 0, 1, 1, 0, 0)                   --击退对手1格  
            Player.buffTipsMsg(actor, "[新月领域△核心]:将[{" .. targetName .. "/FCOLOR=243}]击退{1/FCOLOR=243}格...")
            Player.buffTipsMsg(Target, "[新月领域△核心]:你被[{" .. myName .. "/FCOLOR=243}]击退{1/FCOLOR=243}格...")
        end
    end
end


--『神耀』攻击人物后封印其烈火剑法3S  （触发概率：100%   CD:30S）  31087 『神耀』封印烈火CD   31088『神耀』Buff计时CD
ZhuangBeiBuffList[5011] = function(actor, Target, Hiter, MagicId, Damage, Model, attackDamageData)
    local buffCD = hasbuff(actor, 31087)
    if buffCD then return end
    addbuff(actor, 31087, 30)
    addbuff(Target, 31107, 3)
    local myName = Player.GetNameEx(actor)
    local targetName = Player.GetNameEx(Target)
    Player.buffTipsMsg(actor, "[『神耀』]:封印[{" .. targetName .. "/FCOLOR=243}]烈火剑法{3/FCOLOR=243}秒...")
    Player.buffTipsMsg(Target, "[『神耀』]:你被[{" .. myName .. "/FCOLOR=243}],封印烈火剑法{3/FCOLOR=243}秒...")
end


--攻击怪物前触发（掉血前）（6000开头）-----------------------------------

--1%对怪吸血 人物3%血量以下不生效
ZhuangBeiBuffList[6000] = function(actor, Target, Hiter, MagicId, Damage, Model, attackDamageData)
    if Player.canLifesteal(actor) then
        local hp = calculatePercentageResult(Damage, 1)
        humanhp(actor, "+", hp)
    end
end
-- 电·刀[感知] 光·蛇[腾焰] 焰·冰[闪耀]  5%对怪吸血 人物3%血量以下不生效
ZhuangBeiBuffList[6001] = function(actor, Target, Hiter, MagicId, Damage, Model, attackDamageData)
    if Player.canLifesteal(actor) then
        humanhp(actor, "+", Damage * 0.05)
    end
end

--黑莲项坠 攻击满血怪物直接斩杀(10%)生命值 (60秒内只允许触发一次当前BUFF)
ZhuangBeiBuffList[6002] = function(actor, Target, Hiter, MagicId, Damage, Model, attackDamageData)
    local monname = getbaseinfo(Target, ConstCfg.gbase.name)
    if cfg_BuBeiQieGeMon[monname] then return end

    local buffCd = hasbuff(actor, 30002)
    local tgtcurhp = Player.getHpPercentage(Target)
    if not buffCd and tgtcurhp >= 99 then
        addbuff(actor, 30002, 60, 1, actor) --添加CD
        humanhp(Target, "-", Player.getHpValue(Target, 10), 106)
        Player.buffTipsMsg(actor, "[黑莲项坠]:切割怪物{10%/FCOLOR=243}]最大血量...")
    end
end
-- 〈古龙·之力〉 每三刀对怪物造成[2.0倍]对怪切割
ZhuangBeiBuffList[6003] = function(actor, Target, Hiter, MagicId, Damage, Model, attackDamageData)
    local monname = getbaseinfo(Target, ConstCfg.gbase.name)
    if cfg_BuBeiQieGeMon[monname] then return end

    local daoshunum = getplaydef(actor, VarCfg["N$_古龙刀数"])
    if daoshunum >= 3 then
        humanhp(Target, "-", Damage * 2, 106, 0, actor)
        -- Player.buffTipsMsg(actor, "[〈古龙·意志〉]:切割怪物[{" .. Damage * 2 .. "/FCOLOR=243}]生命...")
        setplaydef(actor, VarCfg["N$_古龙刀数"], 0) --刀数归0
    else
        setplaydef(actor, VarCfg["N$_古龙刀数"], daoshunum + 1) --刀数加1
    end
end
--月光印记  每击杀一只怪物累积一层[月光印记]累积到50层后可造成[10]倍切割伤害(23点-08点时间段造成伤害为30倍)
ZhuangBeiBuffList[6004] = function(actor, Target, Hiter, MagicId, Damage, Model, attackDamageData)
    local _KillMonNum = getplaydef(actor, VarCfg["U_杀死怪物数量"])
    if _KillMonNum >= 50 then
        local nowtime = checktimeInPeriod(23, 0, 8, 0)
        local qiege = getbaseinfo(actor, ConstCfg.gbase.custom_attr, 200)
        if nowtime then
            humanhp(Target, "-", qiege * 30, 106, 0, actor) --30倍
            Player.buffTipsMsg(actor, "[月光印记]:对怪物造成[{" .. qiege * 30 .. "/FCOLOR=243}]真实伤害...")
        else
            humanhp(Target, "-", qiege * 10, 106, 0, actor) --10倍
            Player.buffTipsMsg(actor, "[月光印记]:对怪物造成[{" .. qiege * 10 .. "/FCOLOR=243}]真实伤害...")
        end
        setplaydef(actor, VarCfg["U_杀死怪物数量"], 0)
    end
end
--殇日剑·终结 攻击目标时大量吸取目标生命值 每(18)次攻击斩杀怪物当前5%生命值
ZhuangBeiBuffList[6005] = function(actor, Target, Hiter, MagicId, Damage, Model, attackDamageData)
    local monname = getbaseinfo(Target, ConstCfg.gbase.name)
    if cfg_BuBeiQieGeMon[monname] then return end
    local daoshunum = getplaydef(actor, VarCfg["N$_终结刀数"])
    if daoshunum >= 18 then
        humanhp(Target, "-", Player.getHpValue(Target, 5), 106, 0, actor)
        Player.buffTipsMsg(actor, "[殇日剑·终结]:对怪物斩杀[{5%/FCOLOR=243}]最大血量...")
        setplaydef(actor, VarCfg["N$_终结刀数"], 0) --刀数归0
    else
        setplaydef(actor, VarCfg["N$_终结刀数"], daoshunum + 1) --刀数加1
    end
    if Player.canLifesteal(actor) then
        humanhp(actor, "+", Damage * 0.05)
    end
end
--怪兽面具 斩杀血量低于[10%]的怪物[CD:15S]
ZhuangBeiBuffList[6006] = function(actor, Target, Hiter, MagicId, Damage, Model, attackDamageData)
    local monname = getbaseinfo(Target, ConstCfg.gbase.name)
    if cfg_BuBeiQieGeMon[monname] then return end

    local buffcd = hasbuff(actor, 30008)
    if not buffcd then
        local nowmonhp = Player.getHpPercentage(Target)
        if nowmonhp <= 10 then
            killmonbyobj(actor, Target, true, true, true) --杀死怪物
            addbuff(actor, 30008, 15, 1, actor)
            Player.buffTipsMsg(actor, "[怪兽面具]:怪物血量低于[{10%/FCOLOR=243}]将其直接斩杀...")
        end
    end
end
--寂梦霜魂  攻击生命值低于30%的怪物时刀刀切割[1%]最大生命值。
ZhuangBeiBuffList[6007] = function(actor, Target, Hiter, MagicId, Damage, Model, attackDamageData)
    local monname = getbaseinfo(Target, ConstCfg.gbase.name)
    if cfg_BuBeiQieGeMon[monname] then return end

    local nowmonhp = Player.getHpPercentage(Target)
    if nowmonhp <= 30 then
        humanhp(Target, "-", Player.getHpValue(Target, 1), 106, 0, actor) --刀刀斩血1%
    end
end
--鸣封之刃·永恒  攻击目标时大量吸取目标生命值
ZhuangBeiBuffList[6008] = function(actor, Target, Hiter, MagicId, Damage, Model, attackDamageData)
    if Player.canLifesteal(actor) then
        humanhp(actor, "+", Damage * 0.05)
    end
end
--断头台 斩杀生命值低于[10%]目标(CD30秒)
ZhuangBeiBuffList[6009] = function(actor, Target, Hiter, MagicId, Damage, Model, attackDamageData)
    local monname = getbaseinfo(Target, ConstCfg.gbase.name)
    if cfg_BuBeiQieGeMon[monname] then return end

    local buffcd = hasbuff(actor, 30036)
    if not buffcd then
        local nowmonhp = Player.getHpPercentage(Target)
        if nowmonhp <= 10 then
            killmonbyobj(actor, Target, true, true, true) --杀死怪物
            addbuff(actor, 30036, 30, 1, actor)
            Player.buffTipsMsg(actor, "[断头台]:怪物血量低于10%,将其直接斩杀...")
        end
    end
end
--屠龙者之刃  攻击目标时大量吸取目标生命值 攻击倍数：+ 10%
ZhuangBeiBuffList[6010] = function(actor, Target, Hiter, MagicId, Damage, Model, attackDamageData)
    if Player.canLifesteal(actor) then
        humanhp(actor, "+", Damage * 0.05, 4)
    end
end
--≮神拳≯  每次攻击怪物时增加[10%]的总伤害 当效果叠加十次后触发增伤效果清零 (效果清零后需要人物重新叠加BUFF)
ZhuangBeiBuffList[6011] = function(actor, Target, Hiter, MagicId, Damage, Model, attackDamageData)
    local daoshunum = getplaydef(actor, VarCfg["N$_神拳刀数"])
    attackDamageData.damage = attackDamageData.damage + Damage * ((daoshunum + 1) / 10)
    setplaydef(actor, VarCfg["N$_神拳刀数"], daoshunum + 1) --刀数归0
    if daoshunum >= 9 then
        setplaydef(actor, VarCfg["N$_神拳刀数"], 0) --刀数归0
    end
end
--名刀⊙观世正宗 攻击目标时大量吸取目标生命值 攻击时有概率造成[700%]的对怪切割
ZhuangBeiBuffList[6012] = function(actor, Target, Hiter, MagicId, Damage, Model, attackDamageData)
    if Player.canLifesteal(actor) then
        humanhp(actor, "+", Damage * 0.05, 4)
    end

    if randomex(1, 128) then
        local attnum = getbaseinfo(actor, ConstCfg.gbase.dc2)
        humanhp(Target, "-", attnum * 7, 106, 0, actor) --切割怪物 自身7倍攻击力伤害
    end
end

--驭风者·离殇 攻击目标时大量吸取目标生命值 攻击时有概率斩杀怪物[1.5%]生命值 1/100 概率
ZhuangBeiBuffList[6013] = function(actor, Target, Hiter, MagicId, Damage, Model, attackDamageData)
    if Player.canLifesteal(actor) then
        humanhp(actor, "+", Damage * 0.05)
    end
    if randomex(1, 100) then
        humanhp(Target, "-", Player.getHpValue(Target, 1.5), 106, 0, actor)
    end
end

--死亡一指 攻击时有概率触发[死亡一指]直接斩 杀目标[100%]的最大生命值！ 1/588
ZhuangBeiBuffList[6014] = function(actor, Target, Hiter, MagicId, Damage, Model, attackDamageData)
    local monname = getbaseinfo(Target, ConstCfg.gbase.name)
    if cfg_BuBeiQieGeMon[monname] then return end
    if randomex(1, 588) then
        killmonbyobj(actor, Target, true, true, true) --杀死怪物
    end
end

--漩涡 对怪吸血5%
ZhuangBeiBuffList[6015] = function(actor, Target, Hiter, MagicId, Damage, Model, attackDamageData)
    if Player.canLifesteal(actor) then
        humanhp(actor, "+", Damage * 0.05)
    end
end

-- 彩蝶吊坠    释放开天后，下次伤害增加20%
ZhuangBeiBuffList[6016] = function(actor, Target, Hiter, MagicId, Damage, Model, attackDamageData)
    if MagicId == 26 or MagicId == 66 or MagicId == 56 then
        setplaydef(actor, VarCfg["S$_彩蝶吊坠"], "可释放")
    end
    if getplaydef(actor, VarCfg["S$_彩蝶吊坠"]) == "可释放" then
        attackDamageData.damage = attackDamageData.damage + Damage * 0.2
        setplaydef(actor, VarCfg["S$_彩蝶吊坠"], "")
    end
end

-- 收割者   攻击20W血量以内的怪物，1/88概率切割最大8%的的生命值
ZhuangBeiBuffList[6017] = function(actor, Target, Hiter, MagicId, Damage, Model, attackDamageData)
    local HpMax = getbaseinfo(Target, ConstCfg.gbase.maxhp)
    if HpMax <= 200000 then
        if randomex(1, 88) then
            local num = math.random(1, 8)
            humanhp(Target, "-", Player.getHpValue(Target, num), 106, 0, actor)
        end
    end
end

--星神之坠  连续攻击同一目标7次,将造成致命一击,造成道术*300%的附加伤害
ZhuangBeiBuffList[6018] = function(actor, Target, Hiter, MagicId, Damage, Model, attackDamageData)
    local objList = Player.getJsonTableByVar(actor, VarCfg["S$星神之坠名单"])
    table.insert(objList, Target)
    local objNum = 0
    if #objList < 4 then
        objNum = getplaydef(actor,VarCfg["N$星神之坠层数"])
        objNum = objNum + 1
        setplaydef(actor, VarCfg["N$星神之坠层数"], objNum)
    else
        setplaydef(actor, VarCfg["S$星神之坠名单"], "")
        setplaydef(actor, VarCfg["N$星神之坠层数"], 0)
        return
    end
    if objNum == 7 then
        local ScMax = getbaseinfo(actor, ConstCfg.gbase.sc2)
        humanhp(Target, "-", ScMax * 3, 106, 0, actor) --造成道术*300%的伤害
        setplaydef(actor, VarCfg["N$星神之坠层数"], 0)
    end
end


-- △△雷道天卷△△|△△玄天令△△   "对怪伤害总值提高三分之一 至多提高100%   10%概率切割怪物1%血量 怪物血量低于40%时失效"
ZhuangBeiBuffList[6019] = function(actor, Target, Hiter, MagicId, Damage, Model, attackDamageData)

    local monname = getbaseinfo(Target, ConstCfg.gbase.name)
    if cfg_BuBeiQieGeMon[monname] then return end
    local Num = math.random(33, 100)
    attackDamageData = attackDamageData.damage + Damage * Num
    if randomex(1, 10) then
        local tgtplayhp = Player.getHpPercentage(Target)
        if tgtplayhp >= 40 then
            humanhp(Target, "-", Player.getHpValue(Target, 1), 106, 0, actor) --斩杀目标剩余血量
        end
    end
end

--魔刃·噬魂(A)       斩杀生命值低于[2%]的目标(CD10秒)
ZhuangBeiBuffList[6020] = function(actor, Target, Hiter, MagicId, Damage, Model, attackDamageData)
    local monname = getbaseinfo(Target, ConstCfg.gbase.name)
    if cfg_BuBeiQieGeMon[monname] then return end
    local nowmonhp = Player.getHpPercentage(Target)
    if nowmonhp <= 2 then
        if Player.checkCd(actor, VarCfg["N$魔刃斩杀CD"], 10, false) then
            killmonbyobj(actor, Target, true, true, true) --杀死怪物
            Player.buffTipsMsg(actor, "[魔刃·噬魂]:斩杀血量低于[{2%/FCOLOR=243}]的怪物...")
        end
    end
end

--魔刃·噬魂(S)       斩杀生命值低于[3%]的目标(CD10秒)
ZhuangBeiBuffList[6021] = function(actor, Target, Hiter, MagicId, Damage, Model, attackDamageData)
    local monname = getbaseinfo(Target, ConstCfg.gbase.name)
    if cfg_BuBeiQieGeMon[monname] then return end
    local nowmonhp = Player.getHpPercentage(Target)
    if nowmonhp <= 3 then
        if Player.checkCd(actor, VarCfg["N$魔刃斩杀CD"], 10, false) then
            killmonbyobj(actor, Target, true, true, true) --杀死怪物
            Player.buffTipsMsg(actor, "[魔刃·噬魂]:斩杀血量低于[{3%/FCOLOR=243}]的怪物...")
        end
    end
end

--魔刃·噬魂(SR)      斩杀生命值低于[4%]的目标(CD10秒)
ZhuangBeiBuffList[6022] = function(actor, Target, Hiter, MagicId, Damage, Model, attackDamageData)
    local monname = getbaseinfo(Target, ConstCfg.gbase.name)
    if cfg_BuBeiQieGeMon[monname] then return end
    local nowmonhp = Player.getHpPercentage(Target)
    if nowmonhp <= 4 then
        if Player.checkCd(actor, VarCfg["N$魔刃斩杀CD"], 10, false) then
            killmonbyobj(actor, Target, true, true, true) --杀死怪物
            Player.buffTipsMsg(actor, "[魔刃·噬魂]:斩杀血量低于[{4%/FCOLOR=243}]的怪物...")
        end
    end
end

--魔刃·噬魂(SSR)     斩杀生命值低于[5%]的目标(CD10秒)
ZhuangBeiBuffList[6023] = function(actor, Target, Hiter, MagicId, Damage, Model, attackDamageData)
    local monname = getbaseinfo(Target, ConstCfg.gbase.name)
    if cfg_BuBeiQieGeMon[monname] then return end
    local nowmonhp = Player.getHpPercentage(Target)
    if nowmonhp <= 5 then
        if Player.checkCd(actor, VarCfg["N$魔刃斩杀CD"], 10, false) then
            killmonbyobj(actor, Target, true, true, true) --杀死怪物
            Player.buffTipsMsg(actor, "[魔刃·噬魂]:斩杀血量低于[{5%/FCOLOR=243}]的怪物...")
        end
    end
end

--魔刃·噬魂(SSSR)    斩杀生命值低于[10%]的目标(CD10秒)
ZhuangBeiBuffList[6024] = function(actor, Target, Hiter, MagicId, Damage, Model, attackDamageData)
    local monname = getbaseinfo(Target, ConstCfg.gbase.name)
    if cfg_BuBeiQieGeMon[monname] then return end
    local nowmonhp = Player.getHpPercentage(Target)
    if nowmonhp <= 10 then
        if Player.checkCd(actor, VarCfg["N$魔刃斩杀CD"], 10, false) then
            killmonbyobj(actor, Target, true, true, true) --杀死怪物
            Player.buffTipsMsg(actor, "[魔刃·噬魂]:斩杀血量低于[{10%/FCOLOR=243}]的怪物...")
        end
    end
end


--被全部攻击触发（7000开头）-----------------------------------
--暗·影之翼 人物生命值低于(50%)的时候会瞬间恢复人物[15%]最大生命值(CD60秒)
ZhuangBeiBuffList[7000] = function(actor, Target, Hiter, MagicId)
    local tgtcurhp = Player.getHpPercentage(actor)
    if tgtcurhp >= 50 then return end
    local buffCd = hasbuff(actor, 30003)
    if not buffCd then
        addhpper(actor, "+", 15)
        addbuff(actor, 30003, 60, 1, actor) --添加CD
        Player.buffTipsMsg(actor, "[暗·影之翼]的BUFF触发：你当前人物血量低于50%，已经恢复了15%的生命值！")
    end
end
--审判之魂 被攻击时有概率恢复[10%]的生命值 (30秒内只允许触发一次当前BUFF)
ZhuangBeiBuffList[7001] = function(actor, Target, Hiter, MagicId)
    if randomex(10, 100) then
        local buffCd = hasbuff(actor, 30004)
        if not buffCd then
            addhpper(actor, "+", 10)
            addbuff(actor, 30004, 30, 1, actor) --添加CD
            Player.buffTipsMsg(actor, "[审判之魂]的BUFF触发：恢复10%最大血量...")
        end
    end
end

--夜魂之殇 生命值低于(20%)时触发BUFF隐身1秒恢复自身(100%)生命值[CD：120秒]
ZhuangBeiBuffList[7002] = function(actor, Target, Hiter, MagicId)
    local myhp = Player.getHpPercentage(actor)
    if myhp >= 20 then return end
    if not Player.checkCd(actor, VarCfg["隐身CD"], 60, true) then return end

    local buffid = hasbuff(actor, 30005)
    if not buffid then
        changemode(actor, 2, 1)                               --隐身1秒钟
        humanhp(actor, "+", Player.getHpValue(actor, 100), 4) --恢复100%血量
        addbuff(actor, 30005, 120, 1, actor)                  --添加CD
        Player.buffTipsMsg(actor, "[夜魂之殇]的BUFF触发：你当前生命值低于20%，已经恢复到100%...")
    end
end

--勾魂夺魄 施放开天斩之后下次攻击必定能造成 [3.0]倍的对怪切割[CD:60秒]
ZhuangBeiBuffList[7003] = function(actor, Target, Hiter, MagicId)
    local tgtcurhp = Player.getHpPercentage(actor)
    if tgtcurhp <= 20 then
        local buffcd = hasbuff(actor, 30014)
        if not buffcd then
            humanhp(actor, "+", Player.getHpValue(actor, 100), 4, nil, nil, nil) --恢复100%血量
            addbuff(actor, 30014, 30, 1, actor)
        end
    end
end
--天机 每2分钟必定会获得一个[能量护盾]可抵挡一次目标的技能伤害，护盾被击破后会召唤雷劫降临，对击破护盾的目标造成[20%]最大生命值的伤害!
ZhuangBeiBuffList[7004] = function(actor, Target, Hiter, MagicId)
    if getplaydef(actor, VarCfg["S$_天机状态"]) == "1" then --设置下次伤害开关
        local x, y = getbaseinfo(Target, ConstCfg.gbase.x), getbaseinfo(Target, ConstCfg.gbase.y)
        setplaydef(actor, VarCfg["S$_天机状态"], "")
        rangeharm(actor, x, y, 1, 0, 12, 20, 0, 0, 56) -- 定身1秒
        clearplayeffect(actor, 16016)                  --删除特效
        addbuff(actor, 30080)                          --添加计时buff
    end
end

--古核武·生化基因体 当人物的生命值低于(50%)时触发每秒恢复[3%]生命值且增加(10%)攻击倍数(回血等BUFF效果持续10S·CD120秒)
ZhuangBeiBuffList[7005] = function(actor, Target, Hiter, MagicId)
    local myhp = Player.getHpPercentage(actor)
    if myhp <= 50 then
        local buff = hasbuff(actor, 30100)
        if not buff then
            addbuff(actor, 30100, 10, 1, actor)
            Player.buffTipsMsg(actor, "[古核武·生化基因体]增加{10%/FCOLOR=243}攻击上限并每秒恢复{3%/FCOLOR=243}最大血量,持续{10/FCOLOR=243}秒...")
        end
    end
end

--狂意之怒 PK时生命值低于[10%]时随机传送至附近(5*5)范围内的随机坐标点！且恢复人物(30%)的最大生命值！CD:60秒
ZhuangBeiBuffList[7006] = function(actor, Target, Hiter, MagicId)
    local myhp = Player.getHpPercentage(actor)
    if myhp <= 10 then
        local buff = hasbuff(actor, 30101)
        if not buff then
            local selfx = getbaseinfo(actor, ConstCfg.gbase.x)
            local selfy = getbaseinfo(actor, ConstCfg.gbase.y)
            local mapid = getbaseinfo(actor, ConstCfg.gbase.mapid)
            mapmove(actor, mapid, selfx, selfy, 10) -- 随机落点
            addhpper(actor, "+", 30)                -- 恢复10%生命
            addbuff(actor, 30101, 60, 1, actor)
            Player.buffTipsMsg(actor, "[狂意之怒]:触发{5x5/FCOLOR=243}范围随机落点并恢复{30%/FCOLOR=243}血量...")
        end
    end
end

--被人攻击触发（8000开头）-----------------------------------

--夜色杀手披风 被人物攻击时有概率定身目标[2秒]
ZhuangBeiBuffList[8000] = function(actor, Target, Hiter, MagicId)
    if randomex(1, 88) then
        local tgtx = getbaseinfo(Target, ConstCfg.gbase.x)
        local tgty = getbaseinfo(Target, ConstCfg.gbase.y)
        rangeharm(actor, tgtx, tgty, 1, 1, 10, 2000, 0, 1)
        local myName = Player.GetNameEx(actor)
        local targetName = Player.GetNameEx(Target)
        Player.buffTipsMsg(actor, "[夜色杀手披风]:你将[{" .. targetName .. "/FCOLOR=243}]定身2秒...")
        Player.buffTipsMsg(Target, "[夜色杀手披风]:你被[{" .. myName .. "/FCOLOR=243}],定身2秒...")
    end
end

--夜魂之殇 受到开天斩伤害时   概率进入神隐状态1秒 1/128
ZhuangBeiBuffList[8001] = function(actor, Target, Hiter, MagicId)
    if not Player.checkCd(actor, VarCfg["隐身CD"], 60, true) then return end
    if MagicId == 66 then
        if randomex(1,128) then
            changemode(actor, 2, 1)                               --隐身1秒钟
        end
    end
end

--刺·束缚之隐 被攻击时,5%概率减缓对手20%攻速，持续5S
ZhuangBeiBuffList[8002] = function(actor, Target, Hiter, MagicId)
    if randomex(5, 100) then
        local tgtBuff = hasbuff(Target, 31086)
        if tgtBuff then return end
        addbuff(Target, 31086, 5)
        Player.setAttList(Target, "攻速附加")
    end
end

--谣影套属性 受到开天或者逐日攻击时,25%概率恢复20%血量
ZhuangBeiBuffList[8003] = function(actor, Target, Hiter, MagicId)
    if MagicId == 66 or MagicId == 56   then
        if randomex(1,4) then
            humanhp(actor, "+", Player.getHpValue(actor, 20), 4)         --恢复最大生命的20%血量
        end
    end
end
--被怪物攻击触发（9000开头）-----------------------------------
--被全部攻击触发--前（10000开头）-----------------------------------

--咏叹沉沦[男]  被攻击时有高概率反弹(50%)的伤害并恢复自身[50%]的生命值 1/10概率 120SCD
ZhuangBeiBuffList[10000] = function(actor, Target, Hiter, MagicId, Damage, attackDamageData)
    local buff = hasbuff(actor, 31070)
    if buff then return end
    if randomex(1, 10) then
        addbuff(actor, 31070, 120)
        local targetX = getbaseinfo(Target, ConstCfg.gbase.x)
        local targetY = getbaseinfo(Target, ConstCfg.gbase.y)
        rangeharm(actor, targetX, targetY, 1, 0, 6, Damage * 0.5, 0) --反弹受到伤害的50%（真实伤害）
        humanhp(actor, "+", Player.getHpValue(actor, 50), 4)         --恢复最大生命的50%血量
        local myName = Player.GetNameEx(actor)
        local targetName = Player.GetNameEx(Target)
        Player.buffTipsMsg(actor, "[咏叹沉沦]:你对[{" .. targetName .. "/FCOLOR=243}]反弹了50%伤害...")
        Player.buffTipsMsg(Target, "[咏叹沉沦]:你被[{" .. myName .. "/FCOLOR=243}]反弹了50%伤害...")
    end
end
--鬼焰寒甲(精)  生命值低于[30%]时触发无敌状态1秒 并且恢复人物(100%)的最大生命值！ [CD150秒]
ZhuangBeiBuffList[10001] = function(actor, Target, Hiter, MagicId, Damage, attackDamageData)
    local calculate = Player.getHpPercentage(actor)
    if calculate <= 30 then
        if Player.checkCd(actor, VarCfg["鬼焰寒甲CD"], 180, true) then
            -- humanhp(actor, "+", Player.getHpValue(actor, 100), 4) --恢复最大生命的100%血量
            changemode(actor, 1, 1)                               --无敌1秒
        end
    end
end
--天火之靴  被攻击时有概率恢复[10%]的生命值 (30秒内只允许触发一次当前BUFF) 1/100 概率
ZhuangBeiBuffList[10002] = function(actor, Target, Hiter, MagicId, Damage, attackDamageData)
    if randomex(1, 100) then
        local buffcd = hasbuff(actor, 30027)
        if not buffcd then
            humanhp(actor, "+", Player.getHpValue(actor, 10), 4) --恢复最大生命的10%血量
            Player.buffTipsMsg(actor, "[天火之靴]:恢复[{10%/FCOLOR=243}血量...")
        end
    end
end
--■龙之叹息■  复活后触发人物进入[霸体状态10秒]伤害     吸收[+20%],最大生命值[+30%] 之后进入无敌状态1秒(霸体CD180秒)
ZhuangBeiBuffList[10003] = function(actor, Target, Hiter, MagicId, Damage, attackDamageData)
    local buff = hasbuff(actor, 30034)
    if buff then
        attackDamageData.damage = attackDamageData.damage + Damage * 0.2
    end
end
--寒冬之冠(神圣) 当人物生命值低于[20%]时触发冰冻 自身[2*2范围]内的目标1S(CD60秒)
ZhuangBeiBuffList[10004] = function(actor, Target, Hiter, MagicId, Damage, attackDamageData)
    local calculate = Player.getHpPercentage(actor)
    if calculate <= 20 then
        local buffcd = hasbuff(actor, 30037)
        if not buffcd then
            local x, y = getbaseinfo(actor, ConstCfg.gbase.x), getbaseinfo(actor, ConstCfg.gbase.y)
            rangeharm(actor, x, y, 2, 0, 2, 1, 1, 0, 20500) -- 冰冻2*2范围内敌人1秒
            playsound(actor, 100001, 1, 0)                  --播放冰冻音效
            local myName = Player.GetNameEx(actor)
            local targetName = Player.GetNameEx(Target)
            Player.buffTipsMsg(actor, "[寒冬之冠(神圣)]:你冰冻了目标[{" .. targetName .. "/FCOLOR=243}],持续1S...")
            Player.buffTipsMsg(Target, "[寒冬之冠(神圣)]:你被[{" .. myName .. "/FCOLOR=243}]冰冻了,持续1S...")
            addbuff(actor, 30037, 60, 1, actor)
        end
    end
end
--自然之力·元素披风 被攻击时有概率反弹50%伤害,并恢复自身50%生命 1/10
ZhuangBeiBuffList[10005] = function(actor, Target, Hiter, MagicId, Damage, attackDamageData)
    if randomex(1, 10) then
        local num = math.floor(Damage * 0.5)
        humanhp(Target, "-", num, 1, 0, actor) --反弹受到伤害的50%（真实伤害）
        humanhp(actor, "+", num, 4)  --恢复最大生命的50%血量
        Player.buffTipsMsg(actor, "[自然之力·元素披风]:反弹本次{" .. num .. "/FCOLOR=243}伤害并恢复{" .. num .. "/FCOLOR=243}点生命...")
    end
end
--【暗影】咒印之铠 血量低于(30%)时恢复自身[50%]血量并且推开周围人物三格距离(CD60秒)
ZhuangBeiBuffList[10006] = function(actor, Target, Hiter, MagicId, Damage, attackDamageData)
    local calculate = Player.getHpPercentage(actor)
    if calculate <= 30 then
        local buffCd = hasbuff(actor, 30042)
        if not buffCd then
            local x, y = getbaseinfo(actor, ConstCfg.gbase.x), getbaseinfo(actor, ConstCfg.gbase.y)
            humanhp(actor, "+", Player.getHpValue(actor, 50), 1) --恢复最大生命的0%血量
            rangeharm(actor, x, y, 3, 0, 1, 3, 0, 0)             -- 推动3格
            addbuff(actor, 30042, 60, 1, actor)                  --添加CD
        end
    end
end
--混沌之影 被攻击时有概率反弹[30%]所受伤害 1/10 概率
ZhuangBeiBuffList[10007] = function(actor, Target, Hiter, MagicId, Damage, attackDamageData)
    if randomex(1, 20) then
        humanhp(Target, "-", Damage * 0.3, 1, 0, actor) --反弹伤害30%
        Player.buffTipsMsg(actor, "[混沌之影]:反弹本次{30%/FCOLOR=243}伤害...")
    end
end
--时间锁 当你生命值低于(30%)进入锁血状态(BUFF效果持续2秒·BUFF冷却120S)
ZhuangBeiBuffList[10008] = function(actor, Target, Hiter, MagicId, Damage, attackDamageData)
    local calculate = Player.getHpPercentage(actor)
    if calculate <= 30 then
        local buffcd = hasbuff(actor, 30050)
        if not buffcd then
            changemode(actor, 1, 2) --无敌2秒
            addbuff(actor, 30050, 120, 1, actor)
            Player.buffTipsMsg(actor, "[时间锁]:进入{锁血/FCOLOR=243}状态持续{2/FCOLOR=243}秒...")
        end
    end
end
--轮回沙漏 当生命值达到(50%)时恢复人物[40%] 的最大生命值！(BUFF冷却60秒)
ZhuangBeiBuffList[10009] = function(actor, Target, Hiter, MagicId, Damage, attackDamageData)
    local calculate = Player.getHpPercentage(actor)
    if calculate <= 50 then
        local buff = hasbuff(actor, 30051)
        if not buff then
            humanhp(actor, "+", Player.getHpValue(actor, 40), 1, nil, nil, nil) --恢复最大生命的40%血量
            addbuff(actor, 30051, 60, 1, actor)
            Player.buffTipsMsg(actor, "[轮回沙漏]:恢复{40%/FCOLOR=243}最大血量...")
        end
    end
end
--戰場之靴 被攻击时有概率触发无敌状态(1秒) 1/188 概率
ZhuangBeiBuffList[10010] = function(actor, Target, Hiter, MagicId, Damage, attackDamageData)
    if randomex(1, 188) then
        changemode(actor, 1, 1) --无敌1秒
        Player.buffTipsMsg(actor, "[戰場之靴]:触发无敌{1/FCOLOR=243}秒...")
    end
end

--孤月天轮 复活CD中血量低于[20%]触发护身效果：蓝量抵消100%伤害。 CD 10秒
ZhuangBeiBuffList[10011] = function(actor, Target, Hiter, MagicId, Damage, attackDamageData)
    local bool = ReliveMain.GetReliveState(actor)
    if ReliveMain.GetReliveState(actor) then return end -- 复活中
    local calculate = Player.getHpPercentage(actor)
    if calculate <= 20 then
        local buff = hasbuff(actor, 30065)
        if not buff then
            changemode(actor, 19, 10, 10)
            addbuff(actor, 30065, 30, 1, actor)
            Player.buffTipsMsg(actor, "[孤月天轮]:激活护身效果持续10秒...")
        end
    end
end

--灵魂枷锁 承受伤害时概率1/128 提升50%防御力且攻击怪物时 附带防御力50%切割 1/108
ZhuangBeiBuffList[10012] = function(actor, Target, Hiter, MagicId, Damage, attackDamageData)
    if randomex(1, 128) then
        addbuff(actor, 30030, 30, 1, actor)
        Player.buffTipsMsg(actor, "[灵魂枷锁]:防御力提升[{50%/FCOLOR=243}]且攻击附带防御力[{50%/FCOLOR=243}]的对怪切割持续[{30/FCOLOR=243}]秒...")
    end
    local buff = hasbuff(actor, 30030)
    if not buff then
        local fangyu = getbaseinfo(actor, ConstCfg.gbase.ac2)
        humanhp(Target, "-", fangyu * 0.5, 106, 0, actor) --斩杀怪物  防御力50%的伤害
    end
end

--龍族图腾ゞ 烈火开天逐日减伤5%
ZhuangBeiBuffList[10013] = function(actor, Target, Hiter, MagicId, Damage, attackDamageData)
    if MagicId == 26 or MagicId == 66 or MagicId == 56 then
        attackDamageData.damage = attackDamageData.damage - Damage * 0.05
    end
end

--天雷之环 烈火开天逐日减伤15%
ZhuangBeiBuffList[10014] = function(actor, Target, Hiter, MagicId, Damage, attackDamageData)
    if MagicId == 26 or MagicId == 66 or MagicId == 56 then
        attackDamageData.damage = attackDamageData.damage - Damage * 0.15
    end
end

--麒麟心 烈火开天逐日减伤10%
ZhuangBeiBuffList[10015] = function(actor, Target, Hiter, MagicId, Damage, attackDamageData)
    if MagicId == 26 or MagicId == 66 or MagicId == 56 then
        attackDamageData.damage = attackDamageData.damage - Damage * 0.1
    end
end

--星辉的祷告乀  8%概率格挡一切伤害
ZhuangBeiBuffList[10016] = function(actor, Target, Hiter, MagicId, Damage, attackDamageData)
    if randomex(8, 100) then
        setplaydef(actor,VarCfg["S$星辉的祷告"],"格挡")
    end
end

--原初■混乱■ 自身血量低于50%时受到人物伤害 有5%概率恢复至50%血量  
ZhuangBeiBuffList[10017] = function(actor, Target, Hiter, MagicId, Damage, attackDamageData)
    local calculate = Player.getHpPercentage(actor)
    if calculate <= 50 then
        if randomex(5, 100) then
            humanhp(actor, "=", Player.getHpValue(actor, 50), 1) --恢复生命至50%血量
        end
    end
end




--被玩家攻击触发--前（11000开头）-----------------------------------
-- 往生之手 PK时生命值低于[10%]时随机传送至附近(5*5)范围内的随机坐标点！[CD:20S]
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
            Player.buffTipsMsg(actor, "[往生之手]:你触发在5*5范围内随机落点...")
            Player.buffTipsMsg(Target, "[往生之手]:对方触发在5*5范围内随机落点...")
        end
    end
end
--寂梦  人物生命值低于(15%)的时候会瞬间 恢复人物[55%]最大生命值(CD120S)
ZhuangBeiBuffList[11001] = function(actor, Target, Hiter, MagicId, Damage, attackDamageData)
    local calculate = Player.getHpPercentage(actor)
    if calculate > 3 and calculate < 15 then --大于3%小于15%
        local buffcd = hasbuff(actor, 30016)
        if not buffcd then
            humanhp(actor, "+", Player.getHpValue(actor, 55), 4) --恢复最大血量55%
            addbuff(actor, 30016, 120, 1, actor)
            Player.buffTipsMsg(actor, "[寂梦]:瞬间恢复[{55%/FCOLOR=243}]自身血量...")
        end
    end
end
--【镇压】血色结界  被攻击时如果生命值低于50%会触发[血色结界]持续(5秒)同时增加自身(50%最大攻击力)!在结界的持续时间内对手无法离开结界范围！(CD60秒)
ZhuangBeiBuffList[11002] = function(actor, Target, Hiter, MagicId, Damage, attackDamageData)
    local calculate = Player.getHpPercentage(actor)
    if calculate < 50 then --大于3%小于15%
        local buffcd = hasbuff(actor, 30056)
        if not buffcd then
            changehumnewvalue(actor, 210, 50, 5) --增加50%攻击力 持续5秒
            changemode(Target, 11, 5, 3, 2)      --禁锢范围3 禁锢时间5秒
            addbuff(actor, 30056, 60, 1, actor)
            local myName = Player.GetNameEx(actor)
            local targetName = Player.GetNameEx(Target)
            Player.buffTipsMsg(actor,
                "[【镇压】血色结界]:你对{" ..
                targetName .. "/FCOLOR=243}释放{镇压/FCOLOR=243}状态并增加{50%/FCOLOR=243}攻击上限,持续{5/FCOLOR=243}秒...")
            Player.buffTipsMsg(Target, "[【镇压】血色结界]:你被[{" .. myName .. "/FCOLOR=243}]释放{镇压/FCOLOR=243}状态,持续5S...")
        end
    end
end
--活着！ 生命值低于[30%]时,可刀刀回血[3%]刀刀回血效果持续[3秒] (CD120秒)
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
            humanhp(actor, "+", Player.getHpValue(actor, 3), 4) --恢复最大血量3%
        end
    end
end

-- 生灵·屠杀 攻击人物5%概率禁锢2秒  1/128
ZhuangBeiBuffList[11004] = function(actor, Target, Hiter, MagicId, Damage, attackDamageData)
     if randomex(1, 128) then
        --禁锢时间秒
        local time = 2
        local myLevel = getbaseinfo(actor, ConstCfg.gbase.level)
        local targetLevel = getbaseinfo(Target, ConstCfg.gbase.level)
        if  targetLevel > myLevel then
            time = 1
        end
        changemode(Target, 11, time, 3, 2)      --禁锢范围3 禁锢时间2秒
        local myName = Player.GetNameEx(actor)
        local targetName = Player.GetNameEx(Target)
        Player.buffTipsMsg(actor,"[生灵·屠杀]:你对{" ..targetName .. "/FCOLOR=243}释放{禁锢/FCOLOR=243}状态持续{"..time.."/FCOLOR=243}秒...")
        Player.buffTipsMsg(Target, "[生灵·屠杀]:你被[{" .. myName .. "/FCOLOR=243}]释放{禁锢/FCOLOR=243}状态,持续"..time.."S...")
     end
end

--太古龍神·镇魂神武 防止破复活
ZhuangBeiBuffList[11005] = function(actor, Target, Hiter, MagicId, Damage, attackDamageData)
    --我的防止破复活
    local targetTmp = gethumnewvalue(Target, 47)
    if targetTmp ~= 0 then return end --如果被减了复活，则不触发
    local myPreventPoFuHuo = 500
    local targetPoFuHuo = getbaseinfo(Target, ConstCfg.gbase.custom_attr, 47)
    if targetPoFuHuo > 0 then
        local finalPreventPoFuHuo = 0     --最终扣除的属性
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

--被怪物攻击触发--前（12000开头）-----------------------------------
return ZhuangBeiBuffList

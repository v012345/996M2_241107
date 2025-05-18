local WorldBoosBuff = {}
--攻击怪物后触发
local function _onAttackMonster(actor, Target, Hiter, MagicId, qieGe)
    if checkitemw(actor, "天元之奕·冰霜凝视", 1) then
        local currHpPer = Player.getHpPercentage(actor)
        if currHpPer <= 3 or currHpPer == 100 then return end
        humanhp(actor, "+", 388)
    end
    if checkitems(actor, "血饮雷霆·束缚之力#1", 0, 0) then
        local Num = getplaydef(actor, VarCfg["N$龙之叹息_刀数计数"])
        Num = Num + 1
        if Num == 40 then
            local QieGe = getbaseinfo(actor, ConstCfg.gbase.custom_attr, 200)
            humanhp(Target, "-", QieGe * 3, 106, 0, actor) --刀刀斩血
            Num = 0
        end
        setplaydef(actor, VarCfg["N$龙之叹息_刀数计数"], Num)
    end
end
GameEvent.add(EventCfg.onAttackMonster, _onAttackMonster, WorldBoosBuff)

--攻击人物后触发
local function _onAttackPlayer(actor, Target, Hiter, MagicId)
    --魔王领域·无异刀锋 攻击2%的概率触发以自身2*2范围内形成一个结界，结界内友军每秒恢复3%最大生命，且同时增加200防御值，持续10S。冷却120S
    if randomex(2, 100) then
        if checkitemw(actor, "魔王领域·无异刀锋", 1) then
            local buff = hasbuff(actor, 31055) --刀锋结界CD
            if not buff then
                local MyGuildName = getbaseinfo(actor, ConstCfg.gbase.guild)
                gotolabel(actor, 3, "daofengjiejiefujinhanghui," .. MyGuildName .. "", 2)
                playeffect(actor, 63050, 0, 0, 1, 0, 0)
                addbuff(actor, 31055, 120)
            end
        end
    end
    --PK 刀刀附带100%最大法力值伤害。 概率召唤陨石攻击并晕眩目标
    local buff = hasbuff(actor, 31059)
    if buff then
        local Damage = getbaseinfo(actor, ConstCfg.gbase.mc2)
        humanhp(Target, "-", Damage, 1, 0, actor)
        if randomex(2, 100) then
            playeffect(Target, 15259, 0, 0, 1, 0, 0)
            local x, y = getbaseinfo(Target, ConstCfg.gbase.x), getbaseinfo(Target, ConstCfg.gbase.y)
            rangeharm(actor, x, y, 0, 0, 10, 5000, 0, 0) -- 定身1秒
        end
    end
end
GameEvent.add(EventCfg.onAttackPlayer, _onAttackPlayer, WorldBoosBuff)

--被攻击前触发
local function _onStruckDamagePlayer(actor, Target, Hiter, MagicId, Damage, attackDamageData)
    --焱月神晖·光明永存 受到圣神光辉的庇佑  减少烈火和逐日剑法20%的伤害
    if checkitems(actor, "焱月神晖·光明永存#1", 0, 0) then
        local bool = MagicId == 26 or MagicId == 56
        if bool then
            attackDamageData.damage = attackDamageData.damage - (Damage * 0.2)
        end
    end
end
GameEvent.add(EventCfg.onStruckDamagePlayer, _onStruckDamagePlayer, WorldBoosBuff)

--刀锋结界附近行会成员触发 2*2 范围
function daofengjiejiefujinhanghui(actor, TgtGuildName)
    local MyGuildName = getbaseinfo(actor, ConstCfg.gbase.guild)
    if MyGuildName == TgtGuildName then
        addbuff(actor, 31058, 10)
    end
end

-- 杀死人物触发
local function _onkillplay(actor, Target)
    -- 血饮雷霆·束缚之力  击杀目标之后,偷取对方10%的最大生命，和10%的最大攻击,持续1分钟.同一目标只能被偷取一次,冷却1分钟
    if not checkitemw(actor, "血饮雷霆·束缚之力", 1) then return end
    local killNum = getplaydef(actor, VarCfg["N$血饮雷霆层数"])
    if killNum == 4 then return end
    killNum = killNum + 1
    setplaydef(actor, VarCfg["N$血饮雷霆层数"],killNum)
    addbuff(actor, 31056, 0, killNum, actor)
end
GameEvent.add(EventCfg.onkillplay, _onkillplay, WorldBoosBuff)

--杀死怪物触发
local function _onKillMon(actor, monobj, monName)
    --检测背包是否有
    if checkitems(actor, "树妖统领·木之虫巢#1", 0, 0) then
        local ncount = getbaseinfo(actor, 38)
        if ncount >= 5 then return end
        recallmob(actor, "爆裂蜘蛛", 7, 30, 1)
    end
end
GameEvent.add(EventCfg.onKillMon, _onKillMon, WorldBoosBuff)

-- 宝宝攻击前触发 actor=玩家 Target=攻击对象 Hiter=宝宝
local function _onAttackDamageBB(actor, Target, Hiter, MagicId, Damage)
    local BBName = getbaseinfo(Hiter, ConstCfg.gbase.name)
    if BBName == "爆裂蜘蛛" then
        killmonbyobj(actor, Hiter, false, false, true) --杀死宝宝
        local MaxDC = getbaseinfo(actor, ConstCfg.gbase.dc2)
        local x, y = getbaseinfo(Target, ConstCfg.gbase.x), getbaseinfo(Target, ConstCfg.gbase.y)
        rangeharm(actor, x, y, 1, 0, 6, MaxDC * 0.3, 0, 0)
    end
    if BBName == "树妖仆从" then
        killmonbyobj(actor, Hiter, false, false, true) --杀死宝宝
        local x, y = getbaseinfo(Target, ConstCfg.gbase.x), getbaseinfo(Target, ConstCfg.gbase.y)
        rangeharm(actor, x, y, 1, 0, 6, 100, 0, 0)     --固定100点真伤害
        makeposion(Target, 0, 1, 1, 0)                 --附加绿毒状态
    end
end
GameEvent.add(EventCfg.onAttackDamageBB, _onAttackDamageBB, WorldBoosBuff)

--死亡触发
local function _onPlaydie(actor, hiter)
    --天妖现世·荡魔逆仙  栩栩如生的死亡复活时概率给予自身一个印记  下一刀必定斩杀对手99%血量
    if checkitemw(actor, "天妖现世·荡魔逆仙", 1) then
        local buff = hasbuff(actor, 31060)
        if not buff then
            addbuff(actor, 31060)
        end
    end
end
GameEvent.add(EventCfg.onPlaydie, _onPlaydie, WorldBoosBuff)

--释放技能触发 使用燃烧法则
local function _onRanShaoFaZe(actor)
    local buff = hasbuff(actor, 31059)
    if buff then
        FkfDelBuff(actor, 31059)
    else
        addbuff(actor, 31059)
    end
end
GameEvent.add(EventCfg["使用燃烧法则"], _onRanShaoFaZe, WorldBoosBuff)

--穿 树妖统领·木之虫巢
local function _onTakeOn72(actor, itemobj, itemname)
    if itemname ~= "树妖统领·木之虫巢" then return end
    local buff = hasbuff(actor, 31054)
    if buff then return end
    addbuff(actor, 31054)
end
GameEvent.add(EventCfg.onTakeOn72, _onTakeOn72, WorldBoosBuff)

--脱 树妖统领·木之虫巢
local function _onTakeOff72(actor, itemobj, itemname)
    if itemname ~= "树妖统领·木之虫巢" then return end
    local buff = hasbuff(actor, 31054)
    if buff then
        FkfDelBuff(actor, 31054)
    end
end
GameEvent.add(EventCfg.onTakeOff72, _onTakeOff72, WorldBoosBuff)

--穿 焱月神晖·光明永存
local function _onTakeOn11(actor, itemobj, itemname)
    if itemname ~= "焱月神晖·光明永存" then return end
    addskill(actor, 2020, 3)
end
GameEvent.add(EventCfg.onTakeOn11, _onTakeOn11, WorldBoosBuff)

--脱 焱月神晖·光明永存
local function _onTakeOff11(actor, itemobj, itemname)
    if itemname ~= "焱月神晖·光明永存" then return end
    delskill(actor, 2020)
end
GameEvent.add(EventCfg.onTakeOff11, _onTakeOff11, WorldBoosBuff)

--新的一天触发
local function _onNewDay(actor)
    if checkitems(actor, "魔王领域·无异刀锋#1", 0, 0) then
        local Mum = math.random(1, 10)
        setplaydef(actor, VarCfg["N$J_刀锋之心_倍攻"], Mum)
        Player.setAttList(actor, "倍攻附加")
    end
end
GameEvent.add(EventCfg.onNewDay, _onNewDay, WorldBoosBuff)

--登录触发
local function _onLoginEnd(actor)
    local buff = hasbuff(actor, 31056)
    if buff then
        delbuff(actor, 31056)
    end
end
GameEvent.add(EventCfg.onLoginEnd, _onLoginEnd, WorldBoosBuff)


return WorldBoosBuff

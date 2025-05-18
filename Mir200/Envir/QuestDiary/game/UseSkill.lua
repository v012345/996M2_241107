UseSkill = {}
--双重施法映射
local shuangChongShiFaMap = {
    [26] = true,
    [66] = true,
    [56] = true,
}
--对人物攻击触发
local function _onYeMan(actor, target)
    --狂热野蛮
        if actor == target then return end
        if getskillinfo(actor, 2016, 1) then
            local tgtlevel = getbaseinfo(target, ConstCfg.gbase.level)
            local mylevel  = getbaseinfo(actor, ConstCfg.gbase.level)
            if mylevel > tgtlevel then
                addbuff(target, 30108, 2)
                local myName = Player.GetNameEx(actor)
                local targetName = Player.GetNameEx(target)
                Player.buffTipsMsg(actor, "[狂热野蛮]:你将{" .. targetName .. "/FCOLOR=243}封印技能{2/FCOLOR=243}秒...")
                Player.buffTipsMsg(target, "[狂热野蛮]:你被{" .. myName .. "/FCOLOR=243}封印技能{2/FCOLOR=243}秒...")
            end
        end
end
GameEvent.add(EventCfg["使用野蛮对人"], _onYeMan, UseSkill)
--所有攻击触发
local function _onAttack(actor, Target, Hiter, MagicId)
    --双重施法  1/10 概率
    if shuangChongShiFaMap[MagicId] then
        if randomex(1, 20) then
            if getskillinfo(actor, 2015, 1) then
                releasemagic(actor, MagicId, 1, 3, 1, 1)
            end
        end
    end
end
GameEvent.add(EventCfg.onAttack, _onAttack, UseSkill)


-- --圆弧之刃
-- local function _onBeginMagic(actor, MagicId, maigicName, target, x, y)
--     -- 预言者  当持有者学习[ ]技能后触发攻击时对(3*3)范围内的怪物造成攻击力[*66%]的对怪切割！
--     if MagicId == 2013 then
--         local monName = getbaseinfo(target, ConstCfg.gbase.name)
--         local BuZaoChengEWaiShangHai = cfg_BuZaoChengEWaiShangHai[monName] 
--         if BuZaoChengEWaiShangHai then
--             return
--         end

--         local attnum = getbaseinfo(actor,ConstCfg.gbase.dc2)
--         local var = 1.2
--         local x, y = getbaseinfo(actor, ConstCfg.gbase.x), getbaseinfo(actor, ConstCfg.gbase.y)
--         if checkitemw(actor, "预言者", 1) then
--             var = var + 0.66
--         end
--         rangeharm(actor, x, y, 3, 0, 6, attnum * var, 0, 2)
--         playeffect(actor, 16021, 0, 0, 1, 1, 1)
--     end
-- end
--对怪物触发
-- GameEvent.add(EventCfg.onBeginMagic, _onBeginMagic, UseSkill)
return

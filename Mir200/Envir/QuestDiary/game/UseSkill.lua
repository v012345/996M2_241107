UseSkill = {}
--˫��ʩ��ӳ��
local shuangChongShiFaMap = {
    [26] = true,
    [66] = true,
    [56] = true,
}
--�����﹥������
local function _onYeMan(actor, target)
    --����Ұ��
        if actor == target then return end
        if getskillinfo(actor, 2016, 1) then
            local tgtlevel = getbaseinfo(target, ConstCfg.gbase.level)
            local mylevel  = getbaseinfo(actor, ConstCfg.gbase.level)
            if mylevel > tgtlevel then
                addbuff(target, 30108, 2)
                local myName = Player.GetNameEx(actor)
                local targetName = Player.GetNameEx(target)
                Player.buffTipsMsg(actor, "[����Ұ��]:�㽫{" .. targetName .. "/FCOLOR=243}��ӡ����{2/FCOLOR=243}��...")
                Player.buffTipsMsg(target, "[����Ұ��]:�㱻{" .. myName .. "/FCOLOR=243}��ӡ����{2/FCOLOR=243}��...")
            end
        end
end
GameEvent.add(EventCfg["ʹ��Ұ������"], _onYeMan, UseSkill)
--���й�������
local function _onAttack(actor, Target, Hiter, MagicId)
    --˫��ʩ��  1/10 ����
    if shuangChongShiFaMap[MagicId] then
        if randomex(1, 20) then
            if getskillinfo(actor, 2015, 1) then
                releasemagic(actor, MagicId, 1, 3, 1, 1)
            end
        end
    end
end
GameEvent.add(EventCfg.onAttack, _onAttack, UseSkill)


-- --Բ��֮��
-- local function _onBeginMagic(actor, MagicId, maigicName, target, x, y)
--     -- Ԥ����  ��������ѧϰ[ ]���ܺ󴥷�����ʱ��(3*3)��Χ�ڵĹ�����ɹ�����[*66%]�ĶԹ��и
--     if MagicId == 2013 then
--         local monName = getbaseinfo(target, ConstCfg.gbase.name)
--         local BuZaoChengEWaiShangHai = cfg_BuZaoChengEWaiShangHai[monName] 
--         if BuZaoChengEWaiShangHai then
--             return
--         end

--         local attnum = getbaseinfo(actor,ConstCfg.gbase.dc2)
--         local var = 1.2
--         local x, y = getbaseinfo(actor, ConstCfg.gbase.x), getbaseinfo(actor, ConstCfg.gbase.y)
--         if checkitemw(actor, "Ԥ����", 1) then
--             var = var + 0.66
--         end
--         rangeharm(actor, x, y, 3, 0, 6, attnum * var, 0, 2)
--         playeffect(actor, 16021, 0, 0, 1, 1, 1)
--     end
-- end
--�Թ��ﴥ��
-- GameEvent.add(EventCfg.onBeginMagic, _onBeginMagic, UseSkill)
return

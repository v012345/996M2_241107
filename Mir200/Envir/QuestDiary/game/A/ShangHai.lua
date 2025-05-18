ShangHai = {}

--攻击怪物触发
---* actor：玩家对象
---* monobj：怪物对象
local function AttackMonster(actor,Target,Hiter,MagicId)
    local qiegenum = getplaydef(actor,"N$怪物切割")
    if qiegenum > 0 then
        humanhp(Target,"-",qiegenum, 16, 0, actor)
    end
end

GameEvent.add(EventCfg.onAttackMonster,AttackMonster,ShangHai)

return ShangHai
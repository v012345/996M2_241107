ShangHai = {}

--�������ﴥ��
---* actor����Ҷ���
---* monobj���������
local function AttackMonster(actor,Target,Hiter,MagicId)
    local qiegenum = getplaydef(actor,"N$�����и�")
    if qiegenum > 0 then
        humanhp(Target,"-",qiegenum, 16, 0, actor)
    end
end

GameEvent.add(EventCfg.onAttackMonster,AttackMonster,ShangHai)

return ShangHai
local VariableAdditionaAttributes = {}

local function _onCalcAttr(actor, attrs)
    local shuxing = {
    }
    -- if getflagstatus(actor, VarCfg["F_�����Ĵ�����Ʒʹ��"]) == 1 then
    --     local atts = {
    --         [34] = 300,
    --         [208] = 5,
    --         [210] = 5,
    --     }
    --     attsMerge(atts, shuxing)
    -- end
    local youAnDeGuShenZhiXiangShuXing = Player.getJsonTableByVar(actor, VarCfg["T_�İ��Ĺ���֮�����Լ�¼"])
    local s = getplaydef(actor, VarCfg["T_�İ��Ĺ���֮�����Լ�¼"])
    if table.nums(youAnDeGuShenZhiXiangShuXing) > 0 then
        local atts = {}
        for i, v in ipairs(youAnDeGuShenZhiXiangShuXing) do
            atts[v[1]] = v[2]
        end
        attsMerge(atts, shuxing)
    end
    calcAtts(attrs, shuxing, "������������")
end

--����
GameEvent.add(EventCfg.onCalcAttr, _onCalcAttr, VariableAdditionaAttributes)
--������ǰ����
-- local function _onTakeOnWeapon(actor, itemobj)
--     local attackAttrNum = getplaydef(actor, VarCfg["U_����֮�����Լ�¼"])
--     local itemobj1 = linkbodyitem(actor, 1)
--     setitemaddvalue(actor, itemobj, 1, 2, attackAttrNum)
--     setitemaddvalue(actor, itemobj1, 1, 2, attackAttrNum)
--     refreshitem(actor, itemobj)
--     recalcabilitys(actor)
-- end
-- --����ǰ��������
-- local function _onTakeOffWeapon(actor, itemobj)
--     --�������
--     local itemobj1 = linkbodyitem(actor, 1)
--     setitemaddvalue(actor, itemobj, 1, 2, 0)
--     setitemaddvalue(actor, itemobj1, 1, 2, 0)
--     refreshitem(actor, itemobj)
--     recalcabilitys(actor)
-- end

-- --������ǰ����
-- GameEvent.add(EventCfg.onTakeOnWeapon, _onTakeOnWeapon, VariableAdditionaAttributes)
-- --����ǰ��������
-- GameEvent.add(EventCfg.onTakeOffWeapon, _onTakeOffWeapon, VariableAdditionaAttributes)
return VariableAdditionaAttributes

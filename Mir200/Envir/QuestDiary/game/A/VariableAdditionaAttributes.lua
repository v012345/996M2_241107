local VariableAdditionaAttributes = {}

local function _onCalcAttr(actor, attrs)
    local shuxing = {
    }
    -- if getflagstatus(actor, VarCfg["F_古龙的传承物品使用"]) == 1 then
    --     local atts = {
    --         [34] = 300,
    --         [208] = 5,
    --         [210] = 5,
    --     }
    --     attsMerge(atts, shuxing)
    -- end
    local youAnDeGuShenZhiXiangShuXing = Player.getJsonTableByVar(actor, VarCfg["T_幽暗的古神之像属性记录"])
    local s = getplaydef(actor, VarCfg["T_幽暗的古神之像属性记录"])
    if table.nums(youAnDeGuShenZhiXiangShuXing) > 0 then
        local atts = {}
        for i, v in ipairs(youAnDeGuShenZhiXiangShuXing) do
            atts[v[1]] = v[2]
        end
        attsMerge(atts, shuxing)
    end
    calcAtts(attrs, shuxing, "变量附加属性")
end

--属性
GameEvent.add(EventCfg.onCalcAttr, _onCalcAttr, VariableAdditionaAttributes)
--穿武器前触发
-- local function _onTakeOnWeapon(actor, itemobj)
--     local attackAttrNum = getplaydef(actor, VarCfg["U_剑灵之谜属性记录"])
--     local itemobj1 = linkbodyitem(actor, 1)
--     setitemaddvalue(actor, itemobj, 1, 2, attackAttrNum)
--     setitemaddvalue(actor, itemobj1, 1, 2, attackAttrNum)
--     refreshitem(actor, itemobj)
--     recalcabilitys(actor)
-- end
-- --脱下前武器触发
-- local function _onTakeOffWeapon(actor, itemobj)
--     --清空属性
--     local itemobj1 = linkbodyitem(actor, 1)
--     setitemaddvalue(actor, itemobj, 1, 2, 0)
--     setitemaddvalue(actor, itemobj1, 1, 2, 0)
--     refreshitem(actor, itemobj)
--     recalcabilitys(actor)
-- end

-- --穿武器前触发
-- GameEvent.add(EventCfg.onTakeOnWeapon, _onTakeOnWeapon, VariableAdditionaAttributes)
-- --脱下前武器触发
-- GameEvent.add(EventCfg.onTakeOffWeapon, _onTakeOffWeapon, VariableAdditionaAttributes)
return VariableAdditionaAttributes

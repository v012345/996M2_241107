--圣药附加
local onDaiYaoShengYao = {}
local config = include("QuestDiary/cfgcsv/cfg_UseShengYao.lua") --配置

--计算属性触发
local function _onCalcAttr(actor, attrs)
    local shuxing = {}
    for _, value in pairs(config) do
        local count = getplaydef(actor, value.var)
        if count > 0 then
            for _, v in ipairs(value.attrs or {}) do
                shuxing[v[1]] = count
            end
        end
    end
    calcAtts(attrs, shuxing, "圣药触发")
end

-- VarCfg["U_疾风斩月丹_次数"]
local function _onCalcAttackSpeed(actor, attackSpeeds)
    local count = getplaydef(actor, VarCfg["U_疾风斩月丹_次数"])
    if count > 0 then
        attackSpeeds[1] = attackSpeeds[1] + count
    end
    if hasbuff(actor,31048) then
        attackSpeeds[1] = attackSpeeds[1] + 10
    end
end
--攻速属性
GameEvent.add(EventCfg.onCalcAttackSpeed, _onCalcAttackSpeed, onDaiYaoShengYao)

GameEvent.add(EventCfg.onCalcAttr, _onCalcAttr, onDaiYaoShengYao)
return onDaiYaoShengYao
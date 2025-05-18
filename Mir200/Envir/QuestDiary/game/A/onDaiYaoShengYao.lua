--ʥҩ����
local onDaiYaoShengYao = {}
local config = include("QuestDiary/cfgcsv/cfg_UseShengYao.lua") --����

--�������Դ���
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
    calcAtts(attrs, shuxing, "ʥҩ����")
end

-- VarCfg["U_����ն�µ�_����"]
local function _onCalcAttackSpeed(actor, attackSpeeds)
    local count = getplaydef(actor, VarCfg["U_����ն�µ�_����"])
    if count > 0 then
        attackSpeeds[1] = attackSpeeds[1] + count
    end
    if hasbuff(actor,31048) then
        attackSpeeds[1] = attackSpeeds[1] + 10
    end
end
--��������
GameEvent.add(EventCfg.onCalcAttackSpeed, _onCalcAttackSpeed, onDaiYaoShengYao)

GameEvent.add(EventCfg.onCalcAttr, _onCalcAttr, onDaiYaoShengYao)
return onDaiYaoShengYao
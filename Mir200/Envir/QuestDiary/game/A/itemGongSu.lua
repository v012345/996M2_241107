local  itemGongSu = {}
local cfg_TaoZhuangGongSu = include("QuestDiary/cfgcsv/cfg_TaoZhuangGongSu.lua") --套装的爆率配置
-- local cfg_ChengHaoBaoLv = include("QuestDiary/cfgcsv/cfg_ChengHaoBaoLv.lua") --称号爆率配置
--穿套装触发
local function _onGroupItemOnEx(actor ,idx)
    if cfg_TaoZhuangGongSu[tonumber(idx)] then
        Player.setAttList(actor, "攻速附加")
    end
end
GameEvent.add(EventCfg.onGroupItemOnEx, _onGroupItemOnEx, itemGongSu)

--脱套装触发
local function onGroupItemOffEx(actor ,idx)
    if cfg_TaoZhuangGongSu[tonumber(idx)] then
        Player.setAttList(actor, "攻速附加")
    end
end
GameEvent.add(EventCfg.onGroupItemOffEx, onGroupItemOffEx, itemGongSu)

local function _onCalcAttackSpeed(actor, attackSpeeds)
    local suitIds = Player.getJsonTableByVar(actor, VarCfg["T_记录套装ID"])
    local gongSu = 0
    if #suitIds > 0 then
        for _, value in ipairs(suitIds) do
            local cfg = cfg_TaoZhuangGongSu[tonumber(value)]
            if cfg then
                gongSu = gongSu + cfg.gongSu
            end
        end
    end
    attackSpeeds[1] = attackSpeeds[1] + gongSu
end
--攻速属性
GameEvent.add(EventCfg.onCalcAttackSpeed, _onCalcAttackSpeed, itemGongSu)
return itemGongSu
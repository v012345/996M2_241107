local  itemBaoLv = {}
itemBaoLv.ID = "物品爆率"
local cfg_TaoZhuangBaoLv = include("QuestDiary/cfgcsv/cfg_TaoZhuangBaoLv.lua") --套装的爆率配置
local cfg_ChengHaoBaoLv = include("QuestDiary/cfgcsv/cfg_ChengHaoBaoLv.lua") --称号爆率配置
--穿套装触发
local function _onGroupItemOnEx(actor ,idx)
    if cfg_TaoZhuangBaoLv[tonumber(idx)] then
        Player.setAttList(actor, "爆率附加")
    end
end
GameEvent.add(EventCfg.onGroupItemOnEx, _onGroupItemOnEx, itemBaoLv)

--脱套装触发
local function onGroupItemOffEx(actor ,idx)
    if cfg_TaoZhuangBaoLv[tonumber(idx)] then
        Player.setAttList(actor, "爆率附加")
    end
end
GameEvent.add(EventCfg.onGroupItemOffEx, onGroupItemOffEx, itemBaoLv)


local function _onCalcBaoLv(actor,attrs)
    --计算套装的
    local suitIds = Player.getJsonTableByVar(actor, VarCfg["T_记录套装ID"])
    local baoLv = 0
    if #suitIds > 0 then
        for _, value in ipairs(suitIds) do
            local cfg = cfg_TaoZhuangBaoLv[tonumber(value)]
            if cfg then
                baoLv = baoLv + cfg.baoLv
            end
        end
    end
    --计算称号的
    local chengHaoList = newgettitlelist(actor)
    for key, value in pairs(chengHaoList) do
        local titleName = getstditeminfo(tonumber(key),ConstCfg.stditeminfo.name)
        local cfg = cfg_ChengHaoBaoLv[titleName]
        if cfg then
            baoLv = baoLv + (cfg.baoLv or 0)
        end
    end
    local shuxing = {}
    if baoLv > 0 then
        shuxing[204] = baoLv
    end
    calcAtts(attrs,shuxing,"爆率附加:套装装备称号")
end

--爆率属性
GameEvent.add(EventCfg.onCalcBaoLv, _onCalcBaoLv, itemBaoLv)


return itemBaoLv
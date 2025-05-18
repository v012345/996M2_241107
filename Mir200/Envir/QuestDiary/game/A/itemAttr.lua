local  itemQieGe = {}
local cfg_TaoZhuangAttr = include("QuestDiary/cfgcsv/cfg_TaoZhuangAttr.lua") --套装的爆率配置
local cfg_ChengHaoAttr = include("QuestDiary/cfgcsv/cfg_ChengHaoAttr.lua") --称号爆率配置
--穿套装触发
local function _onGroupItemOnEx(actor ,idx)
    if cfg_TaoZhuangAttr[tonumber(idx)] then
        Player.setAttList(actor, "属性附加")
    end
end
GameEvent.add(EventCfg.onGroupItemOnEx, _onGroupItemOnEx, itemQieGe)

--脱套装触发
local function onGroupItemOffEx(actor ,idx)
    if cfg_TaoZhuangAttr[tonumber(idx)] then
        Player.setAttList(actor, "属性附加")
    end
end
GameEvent.add(EventCfg.onGroupItemOffEx, onGroupItemOffEx, itemQieGe)
--把属性字符串转换成数组
local function attrStrToAtts(attrStr)
    local attrs = {}
    for _, value in ipairs(attrStr) do
        local tmpAttr = string.split(value, "#")
        attrs[tonumber(tmpAttr[1])] = tonumber(tmpAttr[2])
    end
    return attrs
end
--属性附加触发
local function _onCalcAttr(actor,attrs)
    --计算套装的
    local suitIds = Player.getJsonTableByVar(actor, VarCfg["T_记录套装ID"])
    local qieGe = 0
    local qieGeAddtion = 0
    local shuxing = {} -- 属性表
    if #suitIds > 0 then
        for _, value in ipairs(suitIds) do
            local cfg = cfg_TaoZhuangAttr[tonumber(value)]
            if cfg then
                if cfg.attr then
                    local attrStr = {}
                    if type(cfg.attr) == "string" then
                        attrStr = {cfg.attr}
                    elseif type(cfg.attr) == "table" then
                        attrStr = cfg.attr
                    end
                    local tmpAttrs = attrStrToAtts(attrStr)
                    attsMerge(tmpAttrs, shuxing)
                end
            end
        end
    end
    --计算称号的
    local chengHaoList = newgettitlelist(actor)
    for key, value in pairs(chengHaoList) do
        local titleName = getstditeminfo(tonumber(key),ConstCfg.stditeminfo.name)
        local cfg = cfg_ChengHaoAttr[titleName]
        if cfg then
            if cfg.attr then
                local attrStr = {}
                if type(cfg.attr) == "string" then
                    attrStr = {cfg.attr}
                elseif type(cfg.attr) == "table" then
                    attrStr = cfg.attr
                end
                local tmpAttrs = attrStrToAtts(attrStr)
                attsMerge(tmpAttrs, shuxing)
            end
        end
    end
    -- if qieGe > 0 then
    --     if shuxing[200] then
    --         shuxing[200] = shuxing[200] + qieGe
    --     else
    --         shuxing[200] = qieGe
    --     end
    -- end
    -- if qieGeAddtion > 0 then
    --     if shuxing[205] then
    --         shuxing[205] = shuxing[205] + qieGeAddtion
    --     else
    --         shuxing[205] = qieGeAddtion
    --     end
        
    -- end
    calcAtts(attrs,shuxing,"套装和称号属性")
end

--属性附加触发
GameEvent.add(EventCfg.onCalcAttr, _onCalcAttr, itemQieGe)


return itemQieGe
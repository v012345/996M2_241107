local  itemQieGe = {}
local cfg_TaoZhuangAttr = include("QuestDiary/cfgcsv/cfg_TaoZhuangAttr.lua") --��װ�ı�������
local cfg_ChengHaoAttr = include("QuestDiary/cfgcsv/cfg_ChengHaoAttr.lua") --�ƺű�������
--����װ����
local function _onGroupItemOnEx(actor ,idx)
    if cfg_TaoZhuangAttr[tonumber(idx)] then
        Player.setAttList(actor, "���Ը���")
    end
end
GameEvent.add(EventCfg.onGroupItemOnEx, _onGroupItemOnEx, itemQieGe)

--����װ����
local function onGroupItemOffEx(actor ,idx)
    if cfg_TaoZhuangAttr[tonumber(idx)] then
        Player.setAttList(actor, "���Ը���")
    end
end
GameEvent.add(EventCfg.onGroupItemOffEx, onGroupItemOffEx, itemQieGe)
--�������ַ���ת��������
local function attrStrToAtts(attrStr)
    local attrs = {}
    for _, value in ipairs(attrStr) do
        local tmpAttr = string.split(value, "#")
        attrs[tonumber(tmpAttr[1])] = tonumber(tmpAttr[2])
    end
    return attrs
end
--���Ը��Ӵ���
local function _onCalcAttr(actor,attrs)
    --������װ��
    local suitIds = Player.getJsonTableByVar(actor, VarCfg["T_��¼��װID"])
    local qieGe = 0
    local qieGeAddtion = 0
    local shuxing = {} -- ���Ա�
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
    --����ƺŵ�
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
    calcAtts(attrs,shuxing,"��װ�ͳƺ�����")
end

--���Ը��Ӵ���
GameEvent.add(EventCfg.onCalcAttr, _onCalcAttr, itemQieGe)


return itemQieGe
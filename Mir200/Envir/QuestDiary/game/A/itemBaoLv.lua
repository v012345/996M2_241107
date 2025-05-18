local  itemBaoLv = {}
itemBaoLv.ID = "��Ʒ����"
local cfg_TaoZhuangBaoLv = include("QuestDiary/cfgcsv/cfg_TaoZhuangBaoLv.lua") --��װ�ı�������
local cfg_ChengHaoBaoLv = include("QuestDiary/cfgcsv/cfg_ChengHaoBaoLv.lua") --�ƺű�������
--����װ����
local function _onGroupItemOnEx(actor ,idx)
    if cfg_TaoZhuangBaoLv[tonumber(idx)] then
        Player.setAttList(actor, "���ʸ���")
    end
end
GameEvent.add(EventCfg.onGroupItemOnEx, _onGroupItemOnEx, itemBaoLv)

--����װ����
local function onGroupItemOffEx(actor ,idx)
    if cfg_TaoZhuangBaoLv[tonumber(idx)] then
        Player.setAttList(actor, "���ʸ���")
    end
end
GameEvent.add(EventCfg.onGroupItemOffEx, onGroupItemOffEx, itemBaoLv)


local function _onCalcBaoLv(actor,attrs)
    --������װ��
    local suitIds = Player.getJsonTableByVar(actor, VarCfg["T_��¼��װID"])
    local baoLv = 0
    if #suitIds > 0 then
        for _, value in ipairs(suitIds) do
            local cfg = cfg_TaoZhuangBaoLv[tonumber(value)]
            if cfg then
                baoLv = baoLv + cfg.baoLv
            end
        end
    end
    --����ƺŵ�
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
    calcAtts(attrs,shuxing,"���ʸ���:��װװ���ƺ�")
end

--��������
GameEvent.add(EventCfg.onCalcBaoLv, _onCalcBaoLv, itemBaoLv)


return itemBaoLv
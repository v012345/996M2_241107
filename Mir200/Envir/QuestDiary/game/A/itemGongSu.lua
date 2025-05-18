local  itemGongSu = {}
local cfg_TaoZhuangGongSu = include("QuestDiary/cfgcsv/cfg_TaoZhuangGongSu.lua") --��װ�ı�������
-- local cfg_ChengHaoBaoLv = include("QuestDiary/cfgcsv/cfg_ChengHaoBaoLv.lua") --�ƺű�������
--����װ����
local function _onGroupItemOnEx(actor ,idx)
    if cfg_TaoZhuangGongSu[tonumber(idx)] then
        Player.setAttList(actor, "���ٸ���")
    end
end
GameEvent.add(EventCfg.onGroupItemOnEx, _onGroupItemOnEx, itemGongSu)

--����װ����
local function onGroupItemOffEx(actor ,idx)
    if cfg_TaoZhuangGongSu[tonumber(idx)] then
        Player.setAttList(actor, "���ٸ���")
    end
end
GameEvent.add(EventCfg.onGroupItemOffEx, onGroupItemOffEx, itemGongSu)

local function _onCalcAttackSpeed(actor, attackSpeeds)
    local suitIds = Player.getJsonTableByVar(actor, VarCfg["T_��¼��װID"])
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
--��������
GameEvent.add(EventCfg.onCalcAttackSpeed, _onCalcAttackSpeed, itemGongSu)
return itemGongSu
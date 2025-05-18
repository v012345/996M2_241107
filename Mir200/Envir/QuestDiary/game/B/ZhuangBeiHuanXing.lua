--װ������
local ZhuangBeiHuanXing = {}
local config = include("QuestDiary/cfgcsv/cfg_ZhuangBeiHuanXing.lua") --װ������
local cost = { { "��ʯ", 2 }, { "���", 1000000 } }
local abilGroup = 1
function ZhuangBeiHuanXing.Request(actor, where)
    if where ~= 1 and where ~= 0 then
        Player.sendmsgEx(actor, "[��ʾ]:#251|������·���������!#249")
        return
    end

    local itemobj = linkbodyitem(actor, where)
    if itemobj == "0" then
        if where == 1 then
            Player.sendmsgEx(actor, "[��ʾ]:#251|������û������!#249")
        else
            Player.sendmsgEx(actor, "[��ʾ]:#251|������û���·�!#249")
        end
        return
    end

    local name, mum = Player.checkItemNumByTable(actor, cost)
    if name then
        Player.sendmsgEx(actor, string.format("[��ʾ]:#251|ϴ��ʧ��,���|%s#249|����|%d#249|", name, mum))
        return
    end

    Player.takeItemByTable(actor, cost, "װ������")
    local U_Num = getplaydef(actor, VarCfg["U_���׿������"])
    U_Num = U_Num + 1
    setplaydef(actor, VarCfg["U_���׿������"], U_Num)
    if U_Num == 1 then
        local taskPanelID = getplaydef(actor, VarCfg["U_��������������"])
        if taskPanelID == 23 then
            FCheckTaskRedPoint(actor)
        end
    end
    if U_Num == 5 then
        GameEvent.push(EventCfg.onJianJiaKaiGuan, actor, U_Num)
    end
    clearitemcustomabil(actor,itemobj,abilGroup)
    changecustomitemtext(actor, itemobj, "\n\n\n\n\n[��������]:", abilGroup)
    changecustomitemtextcolor(actor, itemobj, 254, abilGroup)

    local new_Config = {}

    for _, value in ipairs(config) do
        if value.where == where then
           table.insert(new_Config, value)
        end
    end

    for index, value in ipairs(new_Config) do
        local str = table.concat(value.ransjstr, "|")
        local attrValue = ransjstr(str, 1, 3)
        attrValue = tonumber(attrValue)
        Player.addModifyCustomAttributes(actor, itemobj, abilGroup, index, value.attrType, value.attrColor, value.realAttrId,
            value.attrId, value.isAttrPercent, attrValue)
    end
    --ͬ��һ����Ϣ
    ZhuangBeiHuanXing.SyncResponse(actor)
end

-------------������Ϣ������--------------------------
Message.RegisterNetMsg(ssrNetMsgCfg.ZhuangBeiHuanXing, ZhuangBeiHuanXing)
--ͬ����Ϣ
function ZhuangBeiHuanXing.SyncResponse(actor)
    Message.sendmsg(actor, ssrNetMsgCfg.ZhuangBeiHuanXing_SyncResponse)
end

return ZhuangBeiHuanXing

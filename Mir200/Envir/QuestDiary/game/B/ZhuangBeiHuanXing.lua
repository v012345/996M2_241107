--装备唤醒
local ZhuangBeiHuanXing = {}
local config = include("QuestDiary/cfgcsv/cfg_ZhuangBeiHuanXing.lua") --装备唤醒
local cost = { { "灵石", 2 }, { "金币", 1000000 } }
local abilGroup = 1
function ZhuangBeiHuanXing.Request(actor, where)
    if where ~= 1 and where ~= 0 then
        Player.sendmsgEx(actor, "[提示]:#251|请放入衣服或者武器!#249")
        return
    end

    local itemobj = linkbodyitem(actor, where)
    if itemobj == "0" then
        if where == 1 then
            Player.sendmsgEx(actor, "[提示]:#251|你身上没有武器!#249")
        else
            Player.sendmsgEx(actor, "[提示]:#251|你身上没有衣服!#249")
        end
        return
    end

    local name, mum = Player.checkItemNumByTable(actor, cost)
    if name then
        Player.sendmsgEx(actor, string.format("[提示]:#251|洗练失败,你的|%s#249|不足|%d#249|", name, mum))
        return
    end

    Player.takeItemByTable(actor, cost, "装备觉醒")
    local U_Num = getplaydef(actor, VarCfg["U_剑甲开光次数"])
    U_Num = U_Num + 1
    setplaydef(actor, VarCfg["U_剑甲开光次数"], U_Num)
    if U_Num == 1 then
        local taskPanelID = getplaydef(actor, VarCfg["U_主线任务面板进度"])
        if taskPanelID == 23 then
            FCheckTaskRedPoint(actor)
        end
    end
    if U_Num == 5 then
        GameEvent.push(EventCfg.onJianJiaKaiGuan, actor, U_Num)
    end
    clearitemcustomabil(actor,itemobj,abilGroup)
    changecustomitemtext(actor, itemobj, "\n\n\n\n\n[开光属性]:", abilGroup)
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
    --同步一次消息
    ZhuangBeiHuanXing.SyncResponse(actor)
end

-------------网络消息↓↓↓--------------------------
Message.RegisterNetMsg(ssrNetMsgCfg.ZhuangBeiHuanXing, ZhuangBeiHuanXing)
--同步消息
function ZhuangBeiHuanXing.SyncResponse(actor)
    Message.sendmsg(actor, ssrNetMsgCfg.ZhuangBeiHuanXing_SyncResponse)
end

return ZhuangBeiHuanXing

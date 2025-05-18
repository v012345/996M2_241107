local XingCuiCan = {}
XingCuiCan.ID = "星璀璨"
local npcID = 825
--local config = include("QuestDiary/cfgcsv/cfg_XingCuiCan.lua") --配置
local mainName = "群星之怒★★★"
local cost = { { "星图残卷", 10 }, { "元宝", 1880000 } }
local abilGroup = 4
--接收请求
function XingCuiCan.Request(actor)
    local isInRange = FCheckNPCRange(actor, npcID, 15)
    if not isInRange then
        Player.sendmsgEx(actor, "距离太远#249")
        return
    end
    local itemobj = linkbodyitem(actor, 1)
    local equipName = getiteminfo(actor, itemobj, ConstCfg.iteminfo.name)
    if equipName ~= mainName then
        Player.sendmsgEx(actor, string.format("提示：#251|你身上没有穿戴|%s#249|无法觉醒!", mainName))
        return
    end
    local name, num = Player.checkItemNumByTable(actor, cost)
    if name then
        Player.sendmsgEx(actor, string.format("你的|%s#249|不足|%d#249", name, num))
        return
    end
    local values = Item.getEquipCustomAttrValue(actor, 1, abilGroup + 1) --读取后的数组 下标需要+1
    local cusotmAttrValue1 = values[1] or 0
    local cusotmAttrValue2 = values[2] or 0
    if cusotmAttrValue2 >= 1000 then
        Player.sendmsgEx(actor, "提示：#251|你的#250|" .. mainName .. "#249|已经觉醒|10#249|次了,无法继续觉醒...")
        return
    end
    Player.takeItemByTable(actor, cost, mainName)
    local realAttrId1, realAttrId2 = 4, 79
    local attrId1, attrId2 = 93, 94
    clearitemcustomabil(actor, itemobj, abilGroup)
    changecustomitemtext(actor, itemobj, "[の群星璀璨の觉醒]:", abilGroup)
    changecustomitemtextcolor(actor, itemobj, 252, abilGroup)
    Player.addModifyCustomAttributes(actor, itemobj, abilGroup, 1, 0, 0, realAttrId1, attrId1, 0, cusotmAttrValue1 + 99) --设置属性1生命
    Player.addModifyCustomAttributes(actor, itemobj, abilGroup, 2, 0, 0, realAttrId2, attrId2, 1, cusotmAttrValue2 + 100) --设置属性2
    Player.sendmsgEx(actor, "恭喜你觉醒成功!")
    XingCuiCan.SyncResponse(actor)
end
--同步消息
function XingCuiCan.SyncResponse(actor)
    local data = {}
    Message.sendmsg(actor, ssrNetMsgCfg.XingCuiCan_SyncResponse, 0, 0, 0, data)
end
-- --登录触发
-- local function _onLoginEnd(actor, logindatas)
--     XingCuiCan.SyncResponse(actor, logindatas)
-- end
-- --事件派发
-- GameEvent.add(EventCfg.onLoginEnd, _onLoginEnd, XingCuiCan)
--注册网络消息
Message.RegisterNetMsg(ssrNetMsgCfg.XingCuiCan, XingCuiCan)
return XingCuiCan
local BiBoQiangHua = {}
BiBoQiangHua.ID = "碧波强化"
local npcID = 817
--local config = include("QuestDiary/cfgcsv/cfg_BiBoQiangHua.lua") --配置
local cost = {{"碧波灵珠",20},{"造化结晶",10},{"灵符",400}}
local give = {{}}
local mainName = "碧波强化"
local abilGroup = 2
--接收请求
function BiBoQiangHua.Request(actor)
    local isInRange = FCheckNPCRange(actor, npcID, 15)
    if not isInRange then
        Player.sendmsgEx(actor, "距离太远#249")
        return
    end
    local itemobj = linkbodyitem(actor, 21)
    local equipName = getiteminfo(actor, itemobj, ConstCfg.iteminfo.name)
    if equipName ~= "ζ法相天地ζ" then
        Player.sendmsgEx(actor, string.format("提示：#251|你身上没有穿戴|%s#249|无法强化!"))
        return
    end
    local name, num = Player.checkItemNumByTable(actor, cost)
    if name then
        Player.sendmsgEx(actor, string.format("你的|%s#249|不足|%d#249", name, num))
        return
    end
    local values = Item.getEquipCustomAttrValue(actor, 21, abilGroup + 1) --读取后的数组 下标需要+1
    local cusotmAttrValue1 = values[1] or 0
    local cusotmAttrValue2 = values[2] or 0
    if cusotmAttrValue1 >= 20 then
        Player.sendmsgEx(actor, "提示：#251|你的#250|"..mainName.."#249|已经强化|20#249|次了,无法继续强化...")
        return
    end
    Player.takeItemByTable(actor, cost, mainName)
    local realAttrId1, realAttrId2 = 208, 209
    local attrId1, attrId2 = 87, 88
    clearitemcustomabil(actor, itemobj, abilGroup)
    changecustomitemtext(actor, itemobj, "["..mainName.."]:", abilGroup)
    changecustomitemtextcolor(actor, itemobj, 252, abilGroup)
    Player.addModifyCustomAttributes(actor, itemobj, abilGroup, 1, 0, 0, realAttrId1, attrId1, 1, cusotmAttrValue1 + 1) --设置属性1
    Player.addModifyCustomAttributes(actor, itemobj, abilGroup, 2, 0, 0, realAttrId2, attrId2, 1, cusotmAttrValue2 + 1) --设置属性2
    Player.sendmsgEx(actor,"恭喜你强化成功!")
    BiBoQiangHua.SyncResponse(actor)
end
--同步消息
function BiBoQiangHua.SyncResponse(actor)
    local data = {}
    Message.sendmsg(actor, ssrNetMsgCfg.BiBoQiangHua_SyncResponse, 0, 0, 0, data)
end
-- --登录触发
-- local function _onLoginEnd(actor, logindatas)
--     BiBoQiangHua.SyncResponse(actor, logindatas)
-- end
-- --事件派发
-- GameEvent.add(EventCfg.onLoginEnd, _onLoginEnd, BiBoQiangHua)
--注册网络消息
Message.RegisterNetMsg(ssrNetMsgCfg.BiBoQiangHua, BiBoQiangHua)
return BiBoQiangHua
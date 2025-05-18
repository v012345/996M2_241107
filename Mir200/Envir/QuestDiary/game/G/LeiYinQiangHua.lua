local LeiYinQiangHua = {}
LeiYinQiangHua.ID = "雷隐强化"
local npcID = 815
local cost = { { "雷隐精粹", 20 }, { "造化结晶", 10 }, { "灵符", 400 } }
local mainName = "雷隐强化"
local abilGroup = 0
--接收请求
function LeiYinQiangHua.Request(actor)
    local isInRange = FCheckNPCRange(actor, npcID, 15)
    if not isInRange then
        Player.sendmsgEx(actor, "距离太远#249")
        return
    end
    local itemobj = linkbodyitem(actor, 21)
    local equipName = getiteminfo(actor, itemobj, ConstCfg.iteminfo.name)
    if equipName ~= "ζ法相天地ζ" then
        Player.sendmsgEx(actor, string.format("提示：#251|你身上没有穿戴|%s#249|无法强化!","ζ法相天地ζ"))
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
    local realAttrId1, realAttrId2 = 228, 28
    local attrId1, attrId2 = 83, 84
    clearitemcustomabil(actor, itemobj, abilGroup)
    changecustomitemtext(actor, itemobj, "["..mainName.."]:", abilGroup)
    changecustomitemtextcolor(actor, itemobj, 252, abilGroup)
    Player.addModifyCustomAttributes(actor, itemobj, abilGroup, 1, 0, 0, realAttrId1, attrId1, 1, cusotmAttrValue1 + 1) --设置属性1
    Player.addModifyCustomAttributes(actor, itemobj, abilGroup, 2, 0, 0, realAttrId2, attrId2, 1, cusotmAttrValue2 + 1) --设置属性2
    Player.sendmsgEx(actor,"恭喜你强化成功!")
    LeiYinQiangHua.SyncResponse(actor)
    -- Player.setAttList(actor,"攻速附加")
end

--同步消息
function LeiYinQiangHua.SyncResponse(actor)
    local data = {}
    Message.sendmsg(actor, ssrNetMsgCfg.LeiYinQiangHua_SyncResponse, 0, 0, 0, data)
end
--注册网络消息
Message.RegisterNetMsg(ssrNetMsgCfg.LeiYinQiangHua, LeiYinQiangHua)
return LeiYinQiangHua

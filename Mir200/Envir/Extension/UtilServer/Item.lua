Item = {}

--检查idx是否是货币
function Item.isCurrency(idx)
    local stdmode = getstditeminfo(idx, ConstCfg.stditeminfo.stdmode)
    return stdmode == 41
end

--检查idx是否是物品
function Item.isItem(idx)
    local stdmode = getstditeminfo(idx, ConstCfg.stditeminfo.stdmode)
    if stdmode == 41 then return end
    return not ConstCfg.stdmodewheremap[stdmode]
end

--检查idx是否是装备
function Item.isEquip(idx)
    local stdmode = getstditeminfo(idx, ConstCfg.stditeminfo.stdmode)
    if stdmode == 41 then return end
    return ConstCfg.stdmodewheremap[stdmode]
end

--获取where通过idx
function Item.getWheresByIdx(idx)
    local stdmode = getstditeminfo(idx, ConstCfg.stditeminfo.stdmode)
    return ConstCfg.stdmodewheremap[stdmode]
end

--获取idx通过where
function Item.getIdxByWhere(actor, where)
    local equipobj = linkbodyitem(actor, where)
    if equipobj == "0" then return end
    return getiteminfo(actor, equipobj, ConstCfg.iteminfo.idx)
end

--获取物品名字通过idx
function Item.getNameByIdx(idx)
    if idx == ConstCfg.money.bdjade then
        return "玉币"
    end
    return getstditeminfo(idx, ConstCfg.stditeminfo.name)
end

--通过唯一ID获取物品名字
function Item.getNameMakeid(actor, makeId)
    local itemObj = getitembymakeindex(actor, makeId)
    local itemName = nil
    if itemObj ~= "0" then
        itemName =getiteminfo(actor,itemObj,ConstCfg.iteminfo.name)
    end
    return itemName
end
--根据位置获取装备自定义属性的属性值
---*  actor : 个人对象
---*  pos : 位置
---*  customAttrIndex : 自定义属性索引
function Item.getEquipCustomAttrValue(actor, pos, customAttrIndex)
    local itemobj = linkbodyitem(actor, pos)
    local customString = getitemcustomabil(actor, itemobj)
    if customString == "" then
        return {}
    end
    local customTable = json2tbl(customString)
    local abils = customTable["abil"]
    if not abils then
        return {}
    end
    local values = abils[customAttrIndex]
    if not values then
        return {}
    end
    if not values.v then
        return {}
    end
    local result = {}
    for i, v in ipairs(values.v) do
        table.insert(result, v[3])
    end
    return result
end

return Item
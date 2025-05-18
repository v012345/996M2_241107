Item = {}

--���idx�Ƿ��ǻ���
function Item.isCurrency(idx)
    local stdmode = getstditeminfo(idx, ConstCfg.stditeminfo.stdmode)
    return stdmode == 41
end

--���idx�Ƿ�����Ʒ
function Item.isItem(idx)
    local stdmode = getstditeminfo(idx, ConstCfg.stditeminfo.stdmode)
    if stdmode == 41 then return end
    return not ConstCfg.stdmodewheremap[stdmode]
end

--���idx�Ƿ���װ��
function Item.isEquip(idx)
    local stdmode = getstditeminfo(idx, ConstCfg.stditeminfo.stdmode)
    if stdmode == 41 then return end
    return ConstCfg.stdmodewheremap[stdmode]
end

--��ȡwhereͨ��idx
function Item.getWheresByIdx(idx)
    local stdmode = getstditeminfo(idx, ConstCfg.stditeminfo.stdmode)
    return ConstCfg.stdmodewheremap[stdmode]
end

--��ȡidxͨ��where
function Item.getIdxByWhere(actor, where)
    local equipobj = linkbodyitem(actor, where)
    if equipobj == "0" then return end
    return getiteminfo(actor, equipobj, ConstCfg.iteminfo.idx)
end

--��ȡ��Ʒ����ͨ��idx
function Item.getNameByIdx(idx)
    if idx == ConstCfg.money.bdjade then
        return "���"
    end
    return getstditeminfo(idx, ConstCfg.stditeminfo.name)
end

--ͨ��ΨһID��ȡ��Ʒ����
function Item.getNameMakeid(actor, makeId)
    local itemObj = getitembymakeindex(actor, makeId)
    local itemName = nil
    if itemObj ~= "0" then
        itemName =getiteminfo(actor,itemObj,ConstCfg.iteminfo.name)
    end
    return itemName
end
--����λ�û�ȡװ���Զ������Ե�����ֵ
---*  actor : ���˶���
---*  pos : λ��
---*  customAttrIndex : �Զ�����������
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
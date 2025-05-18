Bag = {}

--获取背包物品数量
---*  item: 物品ID/物品名称
---@param item integer|string
---@return integer
function Bag.getItemNum(actor, item)
	local ItemName = item
	if type(item) == "number" then
		ItemName = getstditeminfo(item, ConstCfg.stditeminfo.name)
	end
	local ItemNum = getbagitemcount(actor, ItemName)
	return ItemNum
end

--检查物品数量
---*  item: 物品ID/物品名称
---*  num: 检查的数量
---@param item integer|string
---@param num integer
---@return boolean
function Bag.checkItemNum(actor, item, num)
	num = num or 1
	local count = Bag.getItemNum(actor, item)
	return count >= num
end

--检查背包空格数量
---*  num: 检查的数量
---@param num integer
---@return boolean
function Bag.checkBagEmptyNum(actor, num)
	local empty_num = getbagblank(actor)
	return empty_num >= num
end

--检查背包是否足够给予物品 items
function Bag.checkBagEmptyItems(actor, items)
	local bagEmptyNum = Bag.getbagblank(actor)
	local needEmptyNum = 0
	for _, item in ipairs(items) do
		local idx, num = item[1], item[2]
		if not Item.isCurrency(idx) then --物品 装备
			needEmptyNum = needEmptyNum + 1
		end
	end
	return bagEmptyNum >= needEmptyNum
end

--获取背包中某件物品对象
function Bag.getItemObjByIdx(actor, idx)
	local item_num = getbaseinfo(actor, ConstCfg.gbase.bag_num)
	for i = 0, item_num - 1 do
		local itemobj = getiteminfobyindex(actor, i)
		local itemidx = getiteminfo(actor, itemobj, ConstCfg.iteminfo.idx)
		if itemidx == idx then
			return itemobj
		end
	end
end

--获取背包中某件物品唯一id
function Bag.getItemMakeIdByIdx(actor, idx)
	local itemobj = Bag.getItemObjByIdx(actor, idx)
	if not itemobj then return end
	return getiteminfo(actor, itemobj, ConstCfg.iteminfo.id)
end

--检查背包是否有某件物品的数量通过唯一id
function Bag.checkItemNumByMakeIndex(actor, makeindex, num)
	num = num or 1

	local item_num = getbaseinfo(actor, ConstCfg.gbase.bag_num)
	for i = 0, item_num - 1 do
		local itemobj = getiteminfobyindex(actor, i)
		local itemmakeid = getiteminfo(actor, itemobj, ConstCfg.iteminfo.id)
		if itemmakeid == makeindex then
			if num > 1 then
				local overlap = getiteminfo(actor, itemobj, ConstCfg.iteminfo.overlap)
				if overlap < num then return false end
			end
			return true
		end
	end

	return false
end

--获取背包中某件物品对象通过唯一ID
function Bag.getItemObjByMakeIndex(actor, makeindex)
	local item_num = getbaseinfo(actor, ConstCfg.gbase.bag_num)
	for i = 0, item_num - 1 do
		local itemobj = getiteminfobyindex(actor, i)
		local itemmakeindex = getiteminfo(actor, itemobj, ConstCfg.iteminfo.id)
		if itemmakeindex == makeindex then
			return itemobj
		end
	end
end

return Bag

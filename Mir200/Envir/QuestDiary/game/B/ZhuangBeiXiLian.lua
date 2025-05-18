--[[
--装备洗练
]]
local ZhuangBeiXiLian = {}
local config = include("QuestDiary/cfgcsv/cfg_ZhuangBeiXiLian.lua") --洗练
local cost = { { "焚天石", 66 }, { "天工之锤", 66 }, { "金币", 200000 } } --消耗1
local cost1 = { { "焚天石", 33 }, { "天工之锤", 33 }, { "灵符", 40 } } --消耗2
local abilGroup = 2
--枚举装备类别
local equipmentCategories = {
    [0] = { 2, "衣服" }, -- 衣服
    [1] = { 1, "武器" }, -- 武器
    [3] = { 3, "项链" }, -- 首饰项链
    [4] = { 3, "头盔" }, -- 首饰头盔
    [5] = { 3, "右手镯" }, -- 首饰右手镯
    [6] = { 3, "左手镯" }, -- 首饰左手镯
    [7] = { 3, "右戒指" }, -- 首饰右戒指
    [8] = { 3, "左戒指" }, -- 首饰左戒指
    [10] = { 3, "腰带" }, -- 首饰腰带
    [11] = { 3, "靴子" } -- 首饰靴子
}
--洗练等级
local xiLianLevel = { { "普通", 254, 500 }, { "一般", 251, 300 }, { "精致", 253, 150 }, { "稀有", 215, 40 }, { "史诗", 70, 10 } }
-- 判断数字是否等于变量（变量可以是单个数字或数组）
---* 当前数字
---* 对比的数字或者数组
local function checkValue(value, variable)
    if type(variable) == "number" then
        return value == variable
    elseif type(variable) == "table" then
        for _, v in ipairs(variable) do
            if value == v then
                return true
            end
        end
    end
    return false
end
--计算百分比数值
local function calculatePercentageResult(total, num)
    if total == 0 then
        return 0
    end
    local value = (num / 100) * total
    return math.floor(value + 0.5) -- 四舍五入
end

---------------网络消息----------------
function ZhuangBeiXiLian.Request(actor, where, XiLianType)
    if not where then return end
    --获取类型
    local equipmentType = equipmentCategories[where]
    if equipmentType == nil then
        Player.sendmsgEx(actor, "[提示]:#251|只能洗练武器衣服首饰!#249")
        return
    end

    local itemobj = linkbodyitem(actor, where)
    if itemobj == "0" then
        Player.sendmsgEx(actor, "[提示]:#251|你身上没有穿戴#250|" .. equipmentType[2] .. "#249")
        return
    end
    local equipName = getiteminfo(actor,itemobj,ConstCfg.iteminfo.name)
    if equipName == "【噬魂】王之孤影" then
        Player.sendmsgEx(actor, "[提示]:#251|【噬魂】王之孤影#249|禁止洗练！")
        return
    end
    local curCost = cost
    if XiLianType == 1 then
        curCost = cost
    elseif XiLianType == 2 then
        curCost = cost1
    else
        Player.sendmsgEx(actor, "参数错误!")
        return
    end

    local name, num = Player.checkItemNumByTable(actor, curCost)
    if name then
        Player.sendmsgEx(actor, string.format("[提示]:#251|你的#250|%s#249|不足#250|%s#249|个", name, num))
        return
    end
    Player.takeItemByTable(actor, curCost, "装备洗练")

    ---洗练开始
    local xiLianLevelQuanZhong = {}
    for i, v in ipairs(xiLianLevel) do
        table.insert(xiLianLevelQuanZhong, string.format("%d#%d", i, v[3]))
    end
    local setLevel = ransjstr(table.concat(xiLianLevelQuanZhong, "|"), 1, 3)
    setLevel = tonumber(setLevel) or 1
    local newConfig = {}
    local attrListWeight = {}
    for i, value in ipairs(config) do
        if checkValue(equipmentType[1], value.where) then
            table.insert(newConfig, value)
            table.insert(attrListWeight, i .. "#" .. value.weight)
        end
    end

    if XiLianType == 2 then
        setLevel = 5
    end

    
    --洗练事件派发 
    ---* actor:玩家对象
    ---* setLevel:洗练属性的条数
    GameEvent.push(EventCfg.onZhuangBeiXiLian, actor, setLevel)
    -- release_print(table.concat(attrListWeight, "|"))
    --抽取属性列表
    local attrListWeightResult = {}
    for i = 1, setLevel do
        local id = ransjstr(table.concat(attrListWeight, "|"), 1, 3)
        id = tonumber(id)
        table.insert(attrListWeightResult, id)
    end

    ---先清理一次属性
    clearitemcustomabil(actor, itemobj, abilGroup)
    ---添加属性
    local levelName = xiLianLevel[setLevel][1]
    local levelColor = xiLianLevel[setLevel][2]
    changecustomitemtext(actor, itemobj, "[".. levelName .."]:", abilGroup)
    changecustomitemtextcolor(actor, itemobj, levelColor, abilGroup)
    local extraAttributes = {} --需要单独计算的属性
    for i, v in ipairs(attrListWeightResult) do
        local value = config[v]
        local attrValue
        --首饰的属性随机
        if equipmentType[1] == 3 then
            attrValue = math.random(value.random2[1], value.random2[2])
        else
        --剑甲的属性随机
            attrValue = math.random(value.random1[1], value.random1[2])
        end
        --系统是否万分比
        if value.systmeIsAttrPercent == 1 then
            attrValue = attrValue * 100
        end
        -- release_print(value.realAttrId, value.attrId)
        Player.addModifyCustomAttributes(actor, itemobj, abilGroup, i, value.attrType, value.attrColor, value.realAttrId, value.attrId, value.isAttrPercent, attrValue)
        if v == 4 or v == 11 or v == 14 then
            if not extraAttributes[v] then
                extraAttributes[v] = attrValue
            else
                extraAttributes[v] = extraAttributes[v] + attrValue
            end
        end
    end
    --3#3#123|3#4#456|3#1#789|3#9#111|3#10#222
    setaddnewabil(actor,-2,"=","3#3#0|3#4#0|3#1#0|3#9#0|3#10#0",itemobj)
    --如果有需要计算的属性
    local itemid = getiteminfo(actor,itemobj,ConstCfg.iteminfo.idx)
    if table.nums(extraAttributes) > 0 then
        local attackMin = 0 --攻击上限
        local attackMax = 0 --攻击下限
        local hp = 0 --血
        local defenseMin = 0 --防御下限
        local defenseMax = 0 --防御上限
        for key, value in pairs(extraAttributes) do
            if key == 4 then
                attackMin = getstditematt(itemid, 3)
                attackMax = getstditematt(itemid, 4)
                attackMin = calculatePercentageResult(attackMin, value)
                attackMax = calculatePercentageResult(attackMax, value)

            end
            if key == 11 then
                hp = getstditematt(itemid, 1)
                hp = calculatePercentageResult(hp, value)
            end
            if key == 14 then
                defenseMin = getstditematt(itemid, 9)
                defenseMax = getstditematt(itemid, 10)
                defenseMin = calculatePercentageResult(defenseMin, value)
                defenseMax = calculatePercentageResult(defenseMax, value)
            end
        end
        --开始给予计算的属性
        setaddnewabil(actor,-2,"=",string.format("3#3#%d|3#4#%d|3#1#%d|3#9#%d|3#10#%d", attackMin, attackMax, hp, defenseMin, defenseMax),itemobj)
    end
    local num = getplaydef(actor,VarCfg["U_装备洗练总次数"])
    setplaydef(actor,VarCfg["U_装备洗练总次数"], num + 1)
    if num + 1 == 3 then
       local taskPanelID = getplaydef(actor, VarCfg["U_主线任务面板进度"])
        if taskPanelID == 10 then
            FCheckTaskRedPoint(actor)
        end
    end
    -- --同步一次消息
    ZhuangBeiXiLian.SyncResponse(actor)
end

-------------网络消息↓↓↓--------------------------
Message.RegisterNetMsg(ssrNetMsgCfg.ZhuangBeiXiLian, ZhuangBeiXiLian)
--同步网络消息
function ZhuangBeiXiLian.SyncResponse(actor)
    Message.sendmsg(actor, ssrNetMsgCfg.ZhuangBeiXiLian_SyncResponse)
end

return ZhuangBeiXiLian

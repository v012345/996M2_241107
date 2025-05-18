local HunZhuangJieMian = {}
local config = include("QuestDiary/cfgcsv/cfg_HunZhuangLevel.lua") --不可被记录地图
local whereMaps = {
    [101] = true,
    [102] = true,
    [103] = true,
    [104] = true,
    [105] = true,
    [106] = true
}

local whereList = { 101, 102, 103, 104, 105, 106}
--计算魂装的等级
local function calcHunZhuangLevel(actor, where)
    local CheckLevel = {}
    if whereMaps[where] then
        local level = 0
        for _, value in ipairs(whereList) do
            local EquipObj = linkbodyitem(actor, value)
            if EquipObj ~= "0" then
                local EquipName = getiteminfo(actor, EquipObj, ConstCfg.iteminfo.name)
                local cfg = config[EquipName]
                if cfg then
                    level = level + cfg.level
                    table.insert(CheckLevel, cfg.level)
                end
            else
                table.insert(CheckLevel, 0)
            end
        end
        setplaydef(actor, VarCfg["U_魂装等级"], level)
    end
    local Num1 = (CheckLevel[1] == nil and 0) or CheckLevel[1]
    local Num2 = (CheckLevel[2] == nil and 0) or CheckLevel[2]
    local Num3 = (CheckLevel[3] == nil and 0) or CheckLevel[3]
    local Num4 = (CheckLevel[4] == nil and 0) or CheckLevel[4]
    local Num5 = (CheckLevel[5] == nil and 0) or CheckLevel[5]
    local Num6 = (CheckLevel[6] == nil and 0) or CheckLevel[6]
    local minlevel = math.min(Num1,Num2,Num3,Num4,Num5,Num6)
    setplaydef(actor, VarCfg["T_魂装等级"], minlevel)
    Player.setAttList(actor, "属性附加")
end

--魂装套装等级
local LevelAttr = {5,10,15,20,25,30,35,40,50,60}
local function _onCalcAttr(actor, attrs)
    local _level = getplaydef(actor, VarCfg["T_魂装等级"])
    local level = (_level == "" and 0) or tonumber(_level)
    if level < 1 then return end
    local shuxing = {}
    if LevelAttr[level] then
        shuxing[25] = LevelAttr[level]
        shuxing[26] = LevelAttr[level]
    end
    calcAtts(attrs, shuxing, "魂装套装属性")
end
GameEvent.add(EventCfg.onCalcAttr, _onCalcAttr, HunZhuangJieMian)


--穿装备触发
local function _onTakeOnEx(actor, itemobj, where, itemname, makeid)
    calcHunZhuangLevel(actor, where)
end
GameEvent.add(EventCfg.onTakeOnEx, _onTakeOnEx, HunZhuangJieMian)

--脱装备触发
local function _onTakeOffEx(actor, itemobj, where, itemname, makeid)
    calcHunZhuangLevel(actor, where)
end
GameEvent.add(EventCfg.onTakeOffEx, _onTakeOffEx, HunZhuangJieMian)

return HunZhuangJieMian

JinJiZhiMen = {}
local config = include("QuestDiary/cfgcsv/cfg_JinJiZhiMen.lua") --配置信息
local group_sizes = { 9, 9, 9, 9 }
local tuJianCache = {}
JinJiZhiMen.ID = "禁忌之门"
--枚举地图编号
local mapIds = { "禁忌之门一层", "禁忌之门二层", "禁忌之门三层", "禁忌之门四层" }
--计算索引
local function calculateNumber(group, index, group_sizes)
    if group < 1 or group > #group_sizes then
        return false
    end
    if index < 1 or index > group_sizes[group] then
        return false
    end
    local number = 0
    for i = 1, group - 1 do
        number = number + group_sizes[i]
    end
    number = number + index
    return number
end

--计算数组区间
local function GetInterval(segment)
    -- 检查传入的段号是否有效（在有效范围内）
    if segment < 1 or segment > #group_sizes then
        return false
    end
    -- 计算当前段的起始索引
    -- 初始化起始索引为1
    local start_index = 1
    -- 通过累加之前段的长度来计算起始索引
    for i = 1, segment - 1 do
        start_index = start_index + group_sizes[i]
    end

    -- 计算当前段的结束索引
    local end_index = start_index + group_sizes[segment] - 1

    -- 获取当前段的元素
    local result = {}
    for i = start_index, end_index do
        table.insert(result, config[i])
    end

    return result
end

--设置图鉴缓存
local function SetTuJianCache(actor, data)
    tuJianCache[actor] = data
end

--删除图鉴缓存
local function DelTuJianCache(actor)
    tuJianCache[actor] = nil
end

--获取图鉴列表
local function GetTuJianList(actor)
    if tuJianCache[actor] then
        return tuJianCache[actor]
    end
    local result = Player.getJsonTableByVar(actor, VarCfg.T_tujian)
    tuJianCache[actor] = result
    return result
end

--激活图鉴
local function ActivateTuJian(actor, tuJianName)
    local tuJianList = GetTuJianList(actor)
    if tuJianList[tuJianName] then
        Player.sendmsgEx(actor, tuJianName .. "已激活!#249")
        return
    end
    tuJianList[tuJianName] = 1
    SetTuJianCache(actor, tuJianList)
    Player.setJsonVarByTable(actor, VarCfg.T_tujian, tuJianList)
    Player.sendmsgEx(actor,"恭喜激活成功了!")
    JinJiZhiMen.SyncResponse(actor, nil, tuJianList)
end

--判断当前图鉴是否全部激活
local function IsAllTuJianActivate(actor, index)
    local tuJianList = GetTuJianList(actor)
    local currTuJianList = GetInterval(index)
    if not currTuJianList then
        return false
    end
    for _, v in pairs(currTuJianList) do
        if not tuJianList[v.name] then
            return false
        end
    end
    return true
end

--获取图鉴属性
local function GetTuJianAttr(actor)
    local tuJianList = GetTuJianList(actor)
    local shuxing = {}
    for _, value in ipairs(config) do
        if tuJianList[value.name] then
            for i, v in ipairs(value.attr) do
                if not shuxing[v[1]] then
                    shuxing[v[1]] = v[2]
                else
                    shuxing[v[1]] = shuxing[v[1]] + v[2]
                end
            end
        end
    end
    return shuxing
end

--把图鉴属性转换成属性字符串
local function GetTuJianAttrStr(actor)
    local shuxing = GetTuJianAttr(actor)
    local str = ""
    local attrList = {}
    for key, value in pairs(shuxing) do
        table.insert(attrList, "3#" .. key .. "#" .. value)
    end
    str = table.concat(attrList, "|")
    return str
end

function JinJiZhiMen.GetAttrStr(actor)
    return GetTuJianAttrStr(actor)
end

--给装备附加属性
local function AddEquipTuJianAttr(actor)
    local attrStr = GetTuJianAttrStr(actor)
    if attrStr ~= "" then
        setaddnewabil(actor, 43, "=", "3#171#0|3#172#0|3#1#0|3#4#0|3#75#0|3#173#0|3#170#0|3#3#0")
        setaddnewabil(actor, 43, "=", attrStr)
        local itemObj = linkbodyitem(actor, 43)
        refreshitem(actor, itemObj)
    end
end

--获取用于属性计算的属性
local function GetTuJianAttrCalc(actor)
    local shuxing = GetTuJianAttr(actor)
    local result = {}
    if shuxing[171] then
        result[204] = shuxing[171]
    end
    if shuxing[172] then
        result[200] = shuxing[172]
    end
    local beigopng = 0
    if shuxing[173] then
        beigopng = shuxing[173]
    end
    return result, beigopng
end

function JinJiZhiMen.Request(actor, arg1, arg2)
    local itemObj = linkbodyitem(actor, 43)
    if itemObj == "0" then
        Player.sendmsgEx(actor, "你没有装备修仙装备,不可以激活!#249")
        return
    end
    local index = calculateNumber(arg1, arg2, group_sizes)
    if not index then
        Player.sendmsgEx(actor, "参数错误1!#249")
        return
    end
    local cfg = config[index]
    if not cfg then
        Player.sendmsgEx(actor, "参数错误2!#249")
        return
    end
    local tuJianList = GetTuJianList(actor)
    if tuJianList[cfg.name] then
        Player.sendmsgEx(actor, cfg.name .. "已激活!#249")
        return
    end
    local name, num = Player.checkItemNumByTable(actor, cfg.cost)
    if name then
        Player.sendmsgEx(actor, string.format("你的|%s#249|不足|%d#249", name, num))
        return
    end
    Player.takeItemByTable(actor, cfg.cost, "禁忌之门")
    if randomex(cfg.random) then
        ActivateTuJian(actor, cfg.name)
        AddEquipTuJianAttr(actor)
        FSetTaskRedPoint(actor, VarCfg["F_禁忌之门激活"], 12)
        Player.setAttList(actor, "属性附加")
        Player.setAttList(actor, "倍攻附加")
    else
        Player.sendmsgEx(actor, "激活失败了!#249")
        local tuJianList = GetTuJianList(actor)
        JinJiZhiMen.SyncResponse(actor, nil, tuJianList)
    end
end

function JinJiZhiMen.EnterMap(actor, arg1)
    local isActivate = IsAllTuJianActivate(actor, arg1)
    if not isActivate then
        Player.sendmsgEx(actor, "你没有激活全部禁物,无法进入!#249")
        return
    end
    local mapId = mapIds[arg1]
    if not mapId then
        Player.sendmsgEx(actor, "参数错误!#249")
        return
    end
    GameEvent.push(EventCfg.onJinRuJiJiZhiMen,actor)

    map(actor, mapId)
    delaygoto(actor, 10, "entermapmsg")
end

--同步数据
function JinJiZhiMen.SyncResponse(actor, logindatas, data)
    if not data then
        data = GetTuJianList(actor)
    end
    local _login_data = { ssrNetMsgCfg.JinJiZhiMen_SyncResponse, 0, 0, 0, data }
    if logindatas then
        table.insert(logindatas, _login_data)
    else
        Message.sendmsg(actor, ssrNetMsgCfg.JinJiZhiMen_SyncResponse, 0, 0, 0, data)
    end
end

-----------网络消息-----------
--注册网络消息
Message.RegisterNetMsg(ssrNetMsgCfg.JinJiZhiMen, JinJiZhiMen)

--引擎事件-----
--传装备附加属性
local function _onTakeOn43(actor, itemobj)
    AddEquipTuJianAttr(actor)
end
GameEvent.add(EventCfg.onTakeOn43, _onTakeOn43, JinJiZhiMen)

--计算倍攻触发
local function _onCalcBeiGong(actor, beiGongs)
    local shuxing, beigong = GetTuJianAttrCalc(actor)
    if beigong then
        beiGongs[1] = beiGongs[1] + beigong
    end
end
--计算倍攻
GameEvent.add(EventCfg.onCalcBeiGong, _onCalcBeiGong, JinJiZhiMen)

local function _onCalcAttr(actor, attrs)
    local shuxing, beigong = GetTuJianAttrCalc(actor)
    local num = table.nums(shuxing)
    if num > 0 then
        calcAtts(attrs, shuxing, "禁忌之门")
    end
end
--属性
GameEvent.add(EventCfg.onCalcAttr, _onCalcAttr, JinJiZhiMen)


--登录触发
local function _onLoginEnd(actor, logindatas)
    JinJiZhiMen.SyncResponse(actor, logindatas)
end
--事件派发
GameEvent.add(EventCfg.onLoginEnd, _onLoginEnd, JinJiZhiMen)

--大退小退触发--清理缓存
local function _onExitGame(actor)
    DelTuJianCache(actor)
end
GameEvent.add(EventCfg.onExitGame, _onExitGame, JinJiZhiMen)

--切换地图触发
local function _goSwitchMap(actor, cur_mapid, former_mapid)
    -- 禁忌之门一层
    -- 禁忌之门二层
    -- 禁忌之门三层
    -- 禁忌之门四层
    if cur_mapid == "禁忌之门一层" or cur_mapid == "禁忌之门二层" or cur_mapid == "禁忌之门三层" or cur_mapid == "禁忌之门四层" then
        setplaydef(actor, VarCfg["M_禁忌之门爆率"], 1)
        Player.setAttList(actor, "爆率附加")
    elseif former_mapid == "禁忌之门一层" or former_mapid == "禁忌之门二层" or former_mapid == "禁忌之门三层" or former_mapid == "禁忌之门四层" then
        setplaydef(actor, VarCfg["M_禁忌之门爆率"], 0)
        Player.setAttList(actor, "爆率附加")
    end
end
GameEvent.add(EventCfg.goSwitchMap, _goSwitchMap, JinJiZhiMen)

local function _onCalcBaoLv(actor, attrs)
    if getplaydef(actor, VarCfg["M_禁忌之门爆率"]) == 1 then
        local shuxing = {
            [204] = 300
        }
        calcAtts(attrs, shuxing, "爆率附加:禁忌之门进入地图")
    end
end
GameEvent.add(EventCfg.onCalcBaoLv, _onCalcBaoLv, JinJiZhiMen)


return JinJiZhiMen

local KuaFuZhanShenBang = {}
KuaFuZhanShenBang.ID = "跨服战神榜"
local npcID = 130
--local config = include("QuestDiary/cfgcsv/cfg_KuaFuZhanShenBang.lua") --配置
local cost = { {} }
local give = { {} }
local var = "跨服战神榜排行"
local var1 = VarCfg["A_本服排行榜"]
local titles = {
    "战神之巅",
    "苍穹霸主",
    "修罗破军",
}

local flags = {
    VarCfg["F_战神之巅_攻击效果"],
    VarCfg["F_苍穹霸主_攻击效果"],
    VarCfg["F_修罗破军_攻击效果"],
}

--验证我是否在榜上
local function _getPositionByKey(key, data)
    for index, item in ipairs(data) do
        local itemKey = next(item)
        if itemKey == key then
            return index
        end
    end
    -- 如果未找到，返回nil
    return nil
end

local function _getRankingPosition(number, dataList)
    -- 如果 dataList 是 nil，初始化为空表
    if not dataList then
        dataList = {}
    end
    -- 定义最大排名数，例如排行榜只保留前三名
    local maxRank = 3
    -- 如果 dataList 为空，直接返回第一名
    if #dataList == 0 then
        return 1
    end
    -- 初始化 position 为排行榜长度加一（假设未能进入排行榜）
    local position = #dataList + 1
    -- 遍历排行榜，找到数值应插入的位置
    for index, item in ipairs(dataList) do
        local key, value = next(item)
        if value and value[1] then
            local listNumber = value[1]
            if number > listNumber then
                -- 找到应插入的位置
                position = index
                break
            end
        end
        -- 如果数据无效，继续下一次循环
    end
    -- 如果排行榜已满，且数值未能进入前三名，返回 nil
    if position > maxRank then
        return nil
    end
    return position
end

local function _onKuaFuZhanShenBangToKuaFu(actor, arg1)
    local strs = string.split(arg1, "|")
    local rankings = Player.GetGlobalTempTable2(var)
    local power = math.floor(Player.GetPower(actor))
    if not _getRankingPosition(power, rankings) then
        Player.sendmsgEx(actor, "你的战力不够,无法上榜或已在排行榜!#249")
        return
    end

    local id = Player.GetUUID(actor)
    local name = Player.GetName(actor)
    local myRankData = {}
    myRankData[id] = { power, name, tonumber(strs[1]), tonumber(strs[2]) }
    --排序前判断我是否在榜上，如果在榜上直接更新数据，否则插入新数据
    local myRank = _getPositionByKey(id, rankings)
    if myRank then
        rankings[myRank] = myRankData
    else
        table.insert(rankings, myRankData)
    end
    --对数组进行排序
    table.sort(rankings, function(a, b)
        -- 获取第一个键值对
        local keyA, valueA = next(a)
        local keyB, valueB = next(b)
        -- 比较数值大小
        return valueA[1] > valueB[1]
    end)
    -- 检查数组长度，如果超过三个，只保留前三个
    if #rankings > 3 then
        -- 截断数组，只保留前三个元素
        for i = #rankings, 4, -1 do
            table.remove(rankings, i)
        end
    end
    --排序完毕的数据，记录一下我上次的排名
    myRank = _getPositionByKey(id, rankings)
    local lastRank = getplaydef(actor, VarCfg["U_记录上次全服排名"])
    if myRank then
        setplaydef(actor, VarCfg["U_记录上次全服排名"], myRank)
    else
        setplaydef(actor, VarCfg["U_记录上次全服排名"], 0)
    end
    --保存数据
    Player.SetGlobalTempTable2(var, rankings)
    KuaFuZhanShenBang.SyncResponse(actor)
    --如果和上次一样，则不发送数据到本服
    if lastRank == myRank then
        Player.sendmsgEx(actor, "你的排名没有发生变化#249")
    else
        local keys = {}
        for _, item in ipairs(rankings) do
            local key = next(item)
            table.insert(keys, key)
        end
        --发送通知到本服服务器
        FG_KuaFuToBenFuEvent(EventCfg.onKuaFuZhanShenBangToBenFu, table.concat(keys, "|"))
        local title = titles[myRank]
        if title then
            messagebox(actor, "恭喜你上榜成功,获得第" .. myRank .. "名,获得称号[" .. title .. "]")
        end
        local msgStr = "恭喜玩家[" .. name .. "]荣登跨服战神榜第" .. myRank .. "名，获得巨量属性提升。"
        sendmsg("0", 2, '{"Msg":"' .. msgStr .. '","FColor":249,"BColor":0,"Type":5,"Time":3,"Y":"100"}')
    end
end
GameEvent.add("onKuaFuZhanShenBangToKuaFu", _onKuaFuZhanShenBangToKuaFu, KuaFuZhanShenBang)
--接收请求到跨服执行
function KuaFuZhanShenBang.Request(actor, arg1, arg2)
    if not checkkuafu(actor) then
        return
    end
    FBenFuToKuaFuEvent(actor, EventCfg.onKuaFuZhanShenBangToKuaFu, arg1 .. "|" .. arg2)
end

--本服获取我的排名
local function _getBenFuMyRank(actor, uuidList)
    local uuid = Player.GetUUID(actor)
    for index, value in ipairs(uuidList or {}) do
        if value == uuid then
            return index
        end
    end
    return nil
end

--循环删除称号 和 标识
local function _delAllTitle(actor)
    for _, value in ipairs(titles) do
        if checktitle(actor, value) then
            deprivetitle(actor, value)
            Player.setAttList(actor, "属性附加")
        end
    end

    for _, value in ipairs(flags) do
        setflagstatus(actor, value, 0)
    end
end

--刷新个人排行榜
local function _refreshPlayerRanking(actor, uuidList)
    local lastRank = getplaydef(actor, VarCfg["U_记录上次全服排名"])
    if lastRank > 0 then
        _delAllTitle(actor)
    end
    local playerRank = _getBenFuMyRank(actor, uuidList)
    if playerRank then
        local title = titles[playerRank]
        local flag = flags[playerRank]
        if title then
            confertitle(actor, title)
            setflagstatus(actor, flag, 1) --给标记
            Player.setAttList(actor, "属性附加")
        end
    else
        setplaydef(actor, VarCfg["U_记录上次全服排名"], 0)
    end
end

--刷新所有人的排行榜
local function _refreshAllRanking()
    local uuids = getsysvar(var1) or ""
    local uuidList = string.split(uuids, "|") or {}
    local list = getplayerlst(1)
    for _, actor in ipairs(list or {}) do
        if getplaydef(actor, "N$战神榜登陆完成") == 1 then
            _refreshPlayerRanking(actor, uuidList)
        end
    end
end

--通知本服，更新所有人排行
local function _onKuaFuZhanShenBangToBenFu(arg1)
    setsysvar(var1, arg1)
    _refreshAllRanking()
end
GameEvent.add(EventCfg.onKuaFuZhanShenBangToBenFu, _onKuaFuZhanShenBangToBenFu, KuaFuZhanShenBang)

--跨服到本服执行
local function _onKuaFuZhanShenBangSyncResponse(actor)
    KuaFuZhanShenBang.SyncResponse(actor)
end
GameEvent.add(EventCfg.onKuaFuZhanShenBangSyncResponse, _onKuaFuZhanShenBangSyncResponse, KuaFuZhanShenBang)
function KuaFuZhanShenBang.RequestSync(actor)
    FBenFuToKuaFuEvent(actor, EventCfg.onKuaFuZhanShenBangSyncResponse, "")
end

-- 同步消息
function KuaFuZhanShenBang.SyncResponse(actor, logindatas)
    local data = Player.GetGlobalTempTable2(var)
    Message.sendmsg(actor, ssrNetMsgCfg.KuaFuZhanShenBang_SyncResponse, 0, 0, 0, data)
end

local function _loginRefreshRanking(actor)
    local uuids = getsysvar(var1) or ""
    if uuids ~= "" then
        local uuidList = string.split(uuids, "|") or {}
        _refreshPlayerRanking(actor, uuidList)
    else
        setplaydef(actor, VarCfg["U_记录上次全服排名"], 0)
    end
end

--登陆的时候检测排名
function kua_fu_zhan_bang_login(actor)
    _loginRefreshRanking(actor)
    setplaydef(actor, "N$战神榜登陆完成", 1)
end

-- --跨服登录触发
local function _onLoginEnd(actor, logindatas)
    delaygoto(actor, 10000, "kua_fu_zhan_bang_login")
end
--事件派发
GameEvent.add(EventCfg.onLoginEnd, _onLoginEnd, KuaFuZhanShenBang)

-- VarCfg["F_战神之巅_攻击效果"]
-- VarCfg["F_苍穹霸主_攻击效果"]
-- VarCfg["F_修罗破军_攻击效果"]
-- 战神之巅 攻击战力低的
local attackAddtions = {
    0.2,0.1,0.05
}
local function _onAttackDamagePlayer(actor, Target, Hiter, MagicId, Damage, Model, attackDamageData)
    local attackIndex = 0
    if getflagstatus(actor,VarCfg["F_战神之巅_攻击效果"]) == 1 then
        attackIndex = 1
    elseif getflagstatus(actor,VarCfg["F_苍穹霸主_攻击效果"]) == 1 then
        attackIndex = 2
    elseif getflagstatus(actor,VarCfg["F_修罗破军_攻击效果"]) == 1 then
        attackIndex = 3
    end
    local attackAddtion = attackAddtions[attackIndex]
    if attackAddtion then
        local myPower = getplaydef(actor, VarCfg["U_战斗力"])
        local TargetPower = getplaydef(Target, VarCfg["U_战斗力"])
        --我的战斗力比目标战斗力高
        if myPower > TargetPower then
            attackDamageData.damage = attackDamageData.damage + math.ceil(Damage * attackAddtion)
        end
    end
end

GameEvent.add(EventCfg.onAttackDamagePlayer, _onAttackDamagePlayer, KuaFuZhanShenBang)
--注册网络消息
Message.RegisterNetMsg(ssrNetMsgCfg.KuaFuZhanShenBang, KuaFuZhanShenBang)
return KuaFuZhanShenBang

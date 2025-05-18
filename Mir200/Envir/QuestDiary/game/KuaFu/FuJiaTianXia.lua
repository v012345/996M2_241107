local FuJiaTianXia = {}
FuJiaTianXia.ID = "富甲天下"
local npcID = 130
--local config = include("QuestDiary/cfgcsv/cfg_FuJiaTianXia.lua") --配置
local cost = {
    { { "金币", 1000000 } },
    { { "金币", 5000000 } },
    { { "金币", 10000000 } },
}

local var1 = VarCfg["A_本服富甲天下"]

local titles = {
    "富甲天下第一名",
    "富甲天下第二名",
    "富甲天下第三名",
    "富甲天下第四名",
    "富甲天下第五名",
    "富甲天下第六名",
}
local txtPath = '..\\..\\跨服排行榜\\捐赠榜.txt'
local rankData
--写入文件
local function _writeText(data)
    clearnamelist(txtPath)
    local txt = tbl2json(data)
    addtextlist(txtPath, txt, 0)
end

--读取文件返回table
local function _readText()
    local content1, content2 = getliststring(txtPath, 0)
    if content1 == "" or not content1 then
        return {}
    end
    local str = content1 .. ":" .. content2
    return json2tbl(str)
end
--设置数据
local function _setData(data)
    rankData = data
    _writeText(data)
end
--获取数据
local function _getData()
    if not rankData then
        rankData = _readText()
    end
    return rankData
end

--获取排行之后的前六名数据，并且进行排序
local function _getRankData(isGetUid)
    local dataList = {}
    local inputData = _getData()
    for key, value in pairs(inputData) do
        if isGetUid then
            table.insert(dataList, { key = key, money = value.money, name = value.name })
        else
            table.insert(dataList, { money = value.money, name = value.name })
        end
    end
    -- 按照 money 值降序排序
    table.sort(dataList, function(a, b)
        return a.money > b.money
    end)

    -- 如果数量超过6个，只保留前六个
    if #dataList > 6 then
        for i = #dataList, 7, -1 do
            table.remove(dataList, i)
        end
    end
    return dataList
end

--获取前六名的捐献uid
local function getFuJiaTianXiaUidList()
    local dataList = _getRankData(true)
    -- 初始化一个空表，用于存储键
    local keys = {}
    -- 遍历数据，提取键并按顺序存入表
    for _, item in ipairs(dataList) do
        table.insert(keys, item.key)
    end
    return keys
end

--获取我的排名
local function _getMyRank(actor, ranks)
    local uid = Player.GetUUID(actor)
    for index, value in ipairs(ranks) do
        if uid == value then
            return index
        end
    end
    return nil
end

--获取我的捐献数
local function _getMyDonate(actor)
    local uid = Player.GetUUID(actor)
    local data = _getData()
    local myDonate = 0
    if data[uid] then
        myDonate = data[uid].money or 0
    end
    return myDonate
end

--循环删除称号 和 标识
local function _delAllTitle(actor)
    for _, value in ipairs(titles) do
        if checktitle(actor, value) then
            deprivetitle(actor, value)
            Player.setAttList(actor, "属性附加")
        end
    end
end

--刷新个人排行榜
local function _refreshPlayerRanking(actor, uuidList)
    local lastRank = getplaydef(actor, VarCfg["U_富甲天下上次排名"])
    --如果上次排名不是0，则重置
    if lastRank > 0 then
        setflagstatus(actor, VarCfg["F_富甲天下第一名"], 0)
        _delAllTitle(actor)
    end
    local playerRank = _getMyRank(actor, uuidList)
    if playerRank then
        local title = titles[playerRank]
        if title then
            confertitle(actor, title)
            Player.setAttList(actor, "属性附加")
        end
        setplaydef(actor, VarCfg["U_富甲天下上次排名"],playerRank)
        --第一名给一个标识
        if playerRank == 1 then
            setflagstatus(actor, VarCfg["F_富甲天下第一名"], 1)
        end
    else
        --如果不在榜了 就给0
        setplaydef(actor, VarCfg["U_富甲天下上次排名"], 0)
    end
end

--刷新所有人的排行榜
local function _refreshAllRanking()
    local uuids = getsysvar(var1) or ""
    local uuidList = string.split(uuids, "|") or {}
    local list = getplayerlst(1)
    for _, actor in ipairs(list or {}) do
        if getplaydef(actor, "N$富甲天下登陆完成") == 1 then
            _refreshPlayerRanking(actor, uuidList)
        end
    end
end

--回本服刷新排名
local function _onFuJiaTianXiaToBenFu(arg1)
    setsysvar(var1, arg1)
    _refreshAllRanking()
end
GameEvent.add(EventCfg.onFuJiaTianXiaToBenFu, _onFuJiaTianXiaToBenFu, FuJiaTianXia)
--在跨服执行 开始捐献
local function _onFuJiaTianXiaToKuaFu(actor, num)
    local num = tonumber(num) or 0
    if num == 0 then
        Player.sendmsgEx(actor, "参数错误#249")
        return
    end
    local currData = _getData()
    local id = Player.GetUUID(actor)
    local name = Player.GetName(actor)
    local myData = currData[id]
    --如果已经存在就累加   否则创建数据
    if myData then
        -- 累加 money 值
        myData.money = (myData.money or 0) + num
    else
        -- 创建新的数据表，并添加到 currData 中
        myData = {
            money = num,
            name = name
        }
        currData[id] = myData
    end
    _setData(currData)
    local ranks = getFuJiaTianXiaUidList()
    local myRank = _getMyRank(actor, ranks)
    local lastRank = getplaydef(actor, VarCfg["U_富甲天下上次排名"])
    if myRank then
        if myRank ~= lastRank then
            setplaydef(actor, VarCfg["U_富甲天下上次排名"], myRank)
            FG_KuaFuToBenFuEvent(EventCfg.onFuJiaTianXiaToBenFu, table.concat(ranks, "|"))
            local title = titles[myRank]
            if title then
                messagebox(actor, "恭喜你上榜成功,获得第" .. myRank .. "名,获得称号[" .. title .. "]")
                local msgStr = "恭喜玩家[" .. name .. "]荣登富甲天下排行榜第" .. myRank .. "名，获得巨量属性提升。"
                sendmsg("0", 2, '{"Msg":"' .. msgStr .. '","FColor":249,"BColor":0,"Type":5,"Time":3,"Y":"100"}')
            end
        end
    end
    FuJiaTianXia.SyncResponse(actor)
end
GameEvent.add(EventCfg.onFuJiaTianXiaToKuaFu, _onFuJiaTianXiaToKuaFu, FuJiaTianXia)
--接收请求
function FuJiaTianXia.Request(actor, arg1)
    if not checkkuafu(actor) then
        return
    end
    local currCost = cost[arg1]
    if not currCost then
        return
    end
    local name, num = Player.checkItemNumByTable(actor, currCost)
    if name then
        Player.sendmsgEx(actor, string.format("你的|%s#249|不足|%d#249", name, num))
        return
    end
    local moneyNum = currCost[1][2]
    Player.takeItemByTable(actor, currCost, "跨服捐献")
    FBenFuToKuaFuEvent(actor, EventCfg.onFuJiaTianXiaToKuaFu, moneyNum)
end

--跨服到本服执行
local function _onFuJiaTianXiaSyncResponse(actor)
    FuJiaTianXia.SyncResponse(actor)
end
GameEvent.add(EventCfg.onFuJiaTianXiaSyncResponse, _onFuJiaTianXiaSyncResponse, FuJiaTianXia)
function FuJiaTianXia.RequestSync(actor)
    FBenFuToKuaFuEvent(actor, EventCfg.onFuJiaTianXiaSyncResponse, "")
end

--攻沙结束后清空排行榜
local function _goCastlewarend()
    rankData = nil
    clearnamelist(txtPath)
end
GameEvent.add(EventCfg.goCastlewarend,_goCastlewarend,FuJiaTianXia)

--同步消息
function FuJiaTianXia.SyncResponse(actor, logindatas)
    local data = _getRankData()
    local MyDonate = _getMyDonate(actor)
    Message.sendmsg(actor, ssrNetMsgCfg.FuJiaTianXia_SyncResponse, 0, 0, 0, {data=data,MyDonate=MyDonate})
end

--第一名攻击buff
local function _onAttackPlayer(actor, Target, Hiter, MagicId)
    if randomex(1,128) then
        if getflagstatus(actor, VarCfg["F_富甲天下第一名"]) == 1 then
            setplayvar(Target, "HUMAN", VarCfg["隐身CD"], os.time(), 1) --直接储存当前时间
            local myName = Player.GetNameEx(actor)
            local targetName = Player.GetNameEx(Target)
            Player.buffTipsMsg(actor, "[富甲天下]:{" .. targetName .. "/FCOLOR=243}{30秒/FCOLOR=243}内无法隐身...")
            Player.buffTipsMsg(Target, "[富甲天下]:你被[{" .. myName .. "/FCOLOR=243}]施加了buff{30秒/FCOLOR=243}内无法隐身...")
        end
    end
end
GameEvent.add(EventCfg.onAttackPlayer, _onAttackPlayer, FuJiaTianXia)

--登陆刷新排行榜
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
function kua_fu_fu_jia_tian_xia(actor)
    _loginRefreshRanking(actor)
    setplaydef(actor, "N$富甲天下登陆完成", 1)
end
--登陆触发
local function _onLoginEnd(actor, logindatas)
    delaygoto(actor, 8000, "kua_fu_fu_jia_tian_xia")
end
--事件派发
GameEvent.add(EventCfg.onLoginEnd, _onLoginEnd, FuJiaTianXia)
--注册网络消息
Message.RegisterNetMsg(ssrNetMsgCfg.FuJiaTianXia, FuJiaTianXia)
return FuJiaTianXia

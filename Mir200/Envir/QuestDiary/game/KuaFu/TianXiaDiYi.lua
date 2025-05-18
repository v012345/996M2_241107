local TianXiaDiYi = {}
TianXiaDiYi.ID = "天下第一"
local npcID = 131
local config = include("QuestDiary/cfgcsv/cfg_TianXiaDiYi.lua") --配置
local cost = { {} }
local give = { {} }
local currMapId = "天下第一"
local killCd = 30 --击杀间隔 30s
local campaignName = "天下第一"
local dataVar = campaignName .. "活动数据"
local campaignData
--获取游戏数据
local function _getData()
    if not campaignData then
        campaignData = Player.GetGlobalTempTable2(dataVar)
    end
    return campaignData
end
--设置游戏数据
local function _setData(data)
    Player.SetGlobalTempTable2(dataVar, data)
    campaignData = data
end
--对数据进行排序
local function _getMyRank(actor, data)
    local result = {}
    local dataArray = {}
    for name, info in pairs(data) do
        table.insert(dataArray, { name = name, score = info.Score })
    end
    table.sort(dataArray, function(a, b)
        return a.score > b.score
    end)

    local myRank, myPoint
    local userName = Player.GetName(actor)
    for i, v in ipairs(dataArray) do
        if v.name == userName then
            myRank = i
            myPoint = v.score
        end
    end
    result = {
        rankSort = dataArray,
        myRank = myRank,
        myPoint = myPoint
    }
    return result
end

--请求进入活动
local function _onKFTianXiaDiYiEnter(actor)
    local mapKey = Player.MapKey(actor)
    if currMapId == mapKey then
        Player.sendmsgEx(actor, "已在活动地图!#249")
        return
    end

    --判断活动是否在进行中
    if getsysvar(VarCfg["G_天下第一"]) == 0 then
        --当前没有开启活动
        Player.sendmsgEx(actor, "当前没有开启活动!#249")
        return
    end
    map(actor, currMapId)
end
GameEvent.add(EventCfg.onKFTianXiaDiYiEnter, _onKFTianXiaDiYiEnter, TianXiaDiYi)

local function CheckIsLinQu(actor)
    if getflagstatus(actor, VarCfg["F_天下第一是否领取"]) == 1 then
        Player.sendmsgEx(actor, "您已经领取过奖励了#249")
        return false
    end
    local isTime = isTimeInRange(19, 31, 19, 41)
    if not isTime then
        Player.sendmsgEx(actor, string.format("请在|19:31-19:41#249|领取奖励!"))
        return false
    end
    local weekDayNumber = tonumber(os.date("%w"))
    if weekDayNumber ~= 1 and weekDayNumber ~= 3 and weekDayNumber ~= 5 then
        Player.sendmsgEx(actor, string.format("请在活动日|(周一、周三、周五)#249|领取奖励!"))
        return false
    end
    return true
end
--@本服执行
local function _onKFTianXiaDiYiLingQuBenFu(actor, arg1)
    if not CheckIsLinQu(actor) then
        return
    end
    local strs = string.split(arg1, "#")
    local myRank = tonumber(strs[1]) or 0
    local myPoint = tonumber(strs[2]) or 0
    local cfg = config[myRank]
    local rankStr = ""
    local otherReward = config[11].reward
    local reward = {}
    if cfg then
        reward = cfg.reward
    else
        reward = config[11].reward
    end
    
    if myRank <= 10 then
        rankStr = "第" .. myRank .. "名"
    else
        rankStr = "参与奖"
    end
    if myPoint < 1 then
        reward = otherReward
        rankStr = "参与奖"
    end

    local mailTitle = "天下第一奖励"
    local mailContent = "恭喜您在天下第一活动中，获得" .. rankStr .. "，请领取您的奖励！"
    local uid = Player.GetUUID(actor)
    Player.giveMailByTable(uid, 1, mailTitle, mailContent, reward, 1, true)
    if myRank == 1 then
        if checktitle(actor,"天下第一") then
            deprivetitle(actor,"天下第一")
        end
        confertitle(actor, "天下第一", 1)
        Player.setAttList(actor, "属性附加")
        Player.setAttList(actor, "攻速附加")
        messagebox(actor, "你在活动中获得第一名，恭喜你获得[天下第一]称号，有效期48小时！")
    end
    Player.sendmsgEx(actor, "恭喜你领取奖励成功，请到邮件查收！")
    setflagstatus(actor, VarCfg["F_天下第一是否领取"], 1)
end
GameEvent.add(EventCfg.onKFTianXiaDiYiLingQuBenFu, _onKFTianXiaDiYiLingQuBenFu, TianXiaDiYi)
--跨服获取排名，然后到本服发送奖励！
--@跨服执行
local function _onKFTianXiaDiYiLingQu(actor)
    local data = _getData()
    local rankData = _getMyRank(actor, data)
    if not rankData.myRank then
        Player.sendmsgEx(actor, "没有获取到活动数据，领取失败！#249")
        return
    end
    if not rankData.myPoint then
        Player.sendmsgEx(actor, "没有获取到活动数据，领取失败！#249")
        return
    end
    local myRank = rankData.myRank or 0
    local myPoint = rankData.myPoint  or 0
    FKuaFuToBenFuEvent(actor, EventCfg.onKFTianXiaDiYiLingQuBenFu, myRank .. "#" .. myPoint)
end
GameEvent.add(EventCfg.onKFTianXiaDiYiLingQu, _onKFTianXiaDiYiLingQu, TianXiaDiYi)
--领取时在本服执行
function TianXiaDiYi.LingQu(actor)
    if not CheckIsLinQu(actor) then
        return
    end
    FBenFuToKuaFuEvent(actor, EventCfg.onKFTianXiaDiYiLingQu, "")
end

--接收请求
function TianXiaDiYi.Request(actor)
    if not checkkuafu(actor) then
        FMapMoveKF(actor, "kuafu2", 131, 159, 1)
        opennpcshowex(actor, 131, 0, 5)
    else
        FBenFuToKuaFuEvent(actor, EventCfg.onKFTianXiaDiYiEnter, "")
    end
end

--活动开始
local function _onKFTianXiaDiYiStart()
    if not checkkuafuserver() then
        FsendHuoDongGongGao("跨服天下第一活动已开启！！！")
    end
    campaignData = nil
    Player.SetGlobalTempTable2(dataVar, {})
end
GameEvent.add(EventCfg.onKFTianXiaDiYiStart, _onKFTianXiaDiYiStart, TianXiaDiYi)
--活动结束
local function _onKFTianXiaDiYiEnd()
    FMoveMapPlay(currMapId, "kuafu2", 132, 165, 5)
    if not checkkuafuserver() then
        FsendHuoDongGongGao("跨服天下第一活动已结束!")
    end
end
GameEvent.add(EventCfg.onKFTianXiaDiYiEnd, _onKFTianXiaDiYiEnd, TianXiaDiYi)
--每三秒同步一次数据
local function _onKFTianXiaDiYiSync()
    local tMapPlayerList = Player.GetMapPlayerList(currMapId)
    for _, actor in ipairs(tMapPlayerList) do
        local data = _getData()
        local rankData = _getMyRank(actor, data)
        Message.sendmsg(actor, ssrNetMsgCfg.TianXiaDiYi_SyncRank, 0, 0, 0, rankData)
    end
end
GameEvent.add(EventCfg.onKFTianXiaDiYiSync, _onKFTianXiaDiYiSync, TianXiaDiYi)

--到跨服执行
local function _onKFTianXiaDiYiPanelSync(actor)
    local data = _getData()
    local rankData = _getMyRank(actor, data)
    Message.sendmsg(actor, ssrNetMsgCfg.TianXiaDiYi_PanelSync, 0, 0, 0, rankData)
end
GameEvent.add(EventCfg.onKFTianXiaDiYiPanelSync, _onKFTianXiaDiYiPanelSync, TianXiaDiYi)
function TianXiaDiYi.PanelSync(actor)
    FBenFuToKuaFuEvent(actor, EventCfg.onKFTianXiaDiYiPanelSync, "")
end

--注册网络消息
local function _onkillplay(killer, target)
    if not checkkuafu(killer) then
        return
    end
    if Player.MapKey(killer) ~= currMapId then
        return
    end
    if not Player.IsPlayer(killer) then
        --非玩家击杀
        return
    end

    local nowTime = os.time()
    local data = _getData()
    local killer_name = Player.GetName(killer)
    local role_name = Player.GetName(target)

    data[killer_name] = data[killer_name] or {}              --初始化击杀者数据
    data[role_name] = data[role_name] or {}                  --初始化被杀者数据

    data[killer_name].Score = data[killer_name].Score or 0   --初始化积分
    data[role_name].Score = data[role_name].Score or 0       --初始化积分
    data[role_name].KillTime = data[role_name].KillTime or 0 --初始化被杀时间

    local addScore = 0
    local subScore = 0
    --如果被杀者积分大于1
    local role_name_score = data[role_name].Score --被杀者积分
    --玩家被杀30内不会扣一半的分
    local timeDifference = nowTime - data[role_name].KillTime
    if timeDifference >= killCd then
        if role_name_score > 1 then
            subScore = math.floor(role_name_score / 2)
        end
    else
        Player.sendmsgEx(killer, "你击杀的玩家，30秒内被击杀过，无法获得该玩家的积分。")
    end
    --击杀者拿走被杀者的一半积分+1分
    addScore = subScore + 1
    data[killer_name].Score = data[killer_name].Score + addScore
    --被杀者的积分-被杀者的一半积分
    data[role_name].Score = math.max(0, data[role_name].Score - subScore)
    --更新被杀者的死亡时间
    data[role_name].KillTime = nowTime
    Player.sendmsgEx(killer, string.format("你击杀了玩家，获得|%d#249|积分，当前积分|%d#249", addScore, data[killer_name].Score))
    if subScore > 0 then
        Player.sendmsgEx(target, string.format("你被玩家击杀了，失去了|%d#249|积分", subScore))
    end
    --保存数据
    _setData(data)
end
GameEvent.add(EventCfg.onkillplay, _onkillplay, TianXiaDiYi)

--第二天登录变量重置
local function _roBeforedawn()
    campaignData = nil
    Player.SetGlobalTempTable2(dataVar, {})
end
GameEvent.add(EventCfg.roBeforedawn, _roBeforedawn, TianXiaDiYi)

Message.RegisterNetMsg(ssrNetMsgCfg.TianXiaDiYi, TianXiaDiYi)
return TianXiaDiYi

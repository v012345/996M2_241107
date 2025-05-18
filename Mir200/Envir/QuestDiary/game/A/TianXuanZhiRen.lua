local TianXuanZhiRen = {}
TianXuanZhiRen.ID = "天选之人"
local config = include("QuestDiary/cfgcsv/cfg_TianXuanZhiRen.lua")
local top1Reward = {
    { "金手指", 1 },
    { "烈焰战车[时装]", 1 },
    { "高级神器盲盒", 1 },
    { "神秘专属盲盒", 1 },
    { "自己摸的鱼", 1 },
}

--获取下一轮的剩余时间
function TianXuanZhiRen.nextRoundTime()
    local startTime = getsysvar(VarCfg["G_天选之人开始时间戳"])
    local min = getsysvar(VarCfg["G_开区分钟计时器"])
    if startTime > 0 and min < 120 then
        local round = TianXuanZhiRen.currentRound()
        local currTime = os.time()
        local interval
        if round == 1 then
            interval = 1740
        else
            interval = 1800
        end

        local elapsed_time = currTime - startTime
        local remaining_time = interval - elapsed_time
        return remaining_time
    else
        return -1
    end
end

--获取当前轮数
function TianXuanZhiRen.currentRound()
    local min = getsysvar(VarCfg["G_开区分钟计时器"])
    local human_var
    if min < 30 then
        human_var = 1
    elseif min >= 30 and min < 60 then
        human_var = 2
    elseif min >= 60 and min < 90 then
        human_var = 3
    elseif min >= 90 then
        human_var = 4
    end
    return human_var
end

--请求打开界面
function TianXuanZhiRen.RequestOpenUI(actor)
    local min = getsysvar(VarCfg["G_开区分钟计时器"])
    if min > 150 then
        Player.sendmsgEx(actor, "活动已结束!#249")
        return
    end
    local roundNumber = TianXuanZhiRen.currentRound()
    local data = {}
    data["rankingArr"] = {}                                          -- 排名数据
    data["myNumberList"] = {}                                        --我的号码列表
    for i = 1, 4 do
        local ranking = sorthumvar("TianXuanZhiRen_" .. i, 0, 1, 10) --获取所有玩家降序方式
        table.insert(data["rankingArr"], ranking)
        table.insert(data["myNumberList"], getplayvar(actor, "HUMAN", "TianXuanZhiRen_" .. i))
    end
    local myNumber = getplayvar(actor, "HUMAN", "TianXuanZhiRen_" .. roundNumber) --我的当前号码

    Message.sendmsg(actor, ssrNetMsgCfg.TianXuanZhiRen_ResponseOpenUI, min, myNumber, roundNumber, data)
end

--声明个人变量
local function _PlayerVar(actor)
    for i = 1, 4 do
        FIniPlayVar(actor, "TianXuanZhiRen_" .. i, false)
    end
end
GameEvent.add(EventCfg.goPlayerVar, _PlayerVar, TianXuanZhiRen)

--发送奖励
local function _sendReward(round)
    if round > 4 or not round then
        return
    end

    local actor_list = getplayerlst(0)
    for i, actor in ipairs(actor_list or {}) do
        local roundNumber = round
        local is_ShouChong = getflagstatus(actor, VarCfg["F_是否首充"]) --是否首充
        if is_ShouChong == 1 then
            FSetPlayVar(actor, "TianXuanZhiRen_" .. roundNumber, math.random(9000, 9999)) --生成号码
        end
    end

    local chineseNumbers = { "一", "二", "三", "四", "五", "六", "七", "八", "九", "十" }
    local ranking = sorthumvar("TianXuanZhiRen_" .. round, 0, 1, 10)
    local rankingNew = {}
    --如果没有名额
    if #ranking < 2 then
        return
    end
    for i = 1, #ranking, 2 do
        local pair = { ranking[i], ranking[i + 1] }
        table.insert(rankingNew, pair)
    end
    local gonggaoY = 100
    for index, value in ipairs(rankingNew) do
        local cfg = config[index]
        if cfg then
            local Reward = clone(cfg.reward)
            if index == 1 then
                local random = math.random(#top1Reward)
                table.insert(Reward, top1Reward[random])
            end
            
            local mailTitle = "天选之人第" .. chineseNumbers[round] .. "轮第" .. chineseNumbers[index] .. "名奖励"
            local mailContent = string.format("%s您好，恭喜您在天选之人第%s轮中获得第%s名，请领取您的奖励", value[1], chineseNumbers[round], chineseNumbers[index])
            local rewardStr = getItemArrToStr(Reward)
            -- release_print(rewardStr)
            local gongGaostr = string.format("恭喜玩家[%s]在天选之人活动中获得第%s名,获得奖励[%s]", value[1], chineseNumbers[index],rewardStr)
            local modified_str = gongGaostr:gsub("1元", "")
            FsendTianXuanZhiRen(modified_str, gonggaoY)
            gonggaoY = gonggaoY + 40
            Player.giveMailByTable("#" .. value[1], 1, mailTitle, mailContent, Reward, 1, true)
        end
    end
    GameEvent.push(EventCfg.goTXTiming)  --天选之人开始计时
end
--发送奖励
GameEvent.add(EventCfg.goTXreward, _sendReward, TianXuanZhiRen)

--发送通知
local function _goTXSendTongZhi()
    FsendHuoDongGongGao("距离本轮天选之人开奖还剩余5分钟，请各位玩家抓紧机会！！！")
end
GameEvent.add(EventCfg.goTXSendTongZhi, _goTXSendTongZhi, TianXuanZhiRen)

--计时，用来计算下一轮的时间
local function _goTXTiming()
    setsysvar(VarCfg["G_天选之人开始时间戳"], os.time())
    local nextTime = TianXuanZhiRen.nextRoundTime()
    local playerList = getplayerlst(1)
    for _, actor in ipairs(playerList) do
        Message.sendmsg(actor, ssrNetMsgCfg.TianXuanZhiRen_UpdataTime, nextTime, 0, 0, {})
    end
end
GameEvent.add(EventCfg.goTXTiming, _goTXTiming, TianXuanZhiRen)

local function _onLoginEnd(actor, logindatas)
    local nextTime = TianXuanZhiRen.nextRoundTime()
    -- release_print(nextTime)
    Message.sendmsg(actor, ssrNetMsgCfg.TianXuanZhiRen_UpdataTime, nextTime, 0, 0, {})
end

GameEvent.add(EventCfg.onLoginEnd, _onLoginEnd, TianXuanZhiRen)

--注册网络消息
Message.RegisterNetMsg(ssrNetMsgCfg.TianXuanZhiRen, TianXuanZhiRen)


return TianXuanZhiRen

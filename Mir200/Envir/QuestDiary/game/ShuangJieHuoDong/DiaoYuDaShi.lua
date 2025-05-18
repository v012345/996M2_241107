local DiaoYuDaShi = {}
DiaoYuDaShi.ID = "钓鱼大师"
local npcID = 160
local config = include("QuestDiary/cfgcsv/cfg_DiaoYuDaShi.lua") --配置
--增加一个钓位
local cost = { { "元宝", 2000000 } }
local give = { {} }
--免费次数
local freeCount = 10
--购买次数
local buyCount = 30
function diao_yu_shou_huo(actor)
    if getplaydef(actor, "N$钓鱼状态") == 1 then
        local fishingRodNum = getplaydef(actor, VarCfg["B_鱼竿数量"]) + 1
        local weight1 = {}
        local weight2 = {}
        local weight3 = {}
        for index, value in ipairs(config) do
            if fishingRodNum > 0 then
                table.insert(weight1, string.format("%s#%s", index, value.weight1))
            end
            if fishingRodNum > 1 then
                table.insert(weight2, string.format("%s#%s", index, value.weight2))
            end
            if fishingRodNum > 2 then
                table.insert(weight3, string.format("%s#%s", index, value.weight3))
            end
        end
        local resultIndex1
        local resultIndex2
        local resultIndex3
        if #weight1 > 0 then
            resultIndex1 = ransjstr(table.concat(weight1, "|"), 1, 3)
        end
        if #weight2 > 0 then
            resultIndex2 = ransjstr(table.concat(weight2, "|"), 1, 3)
        end
        if #weight3 > 0 then
            resultIndex3 = ransjstr(table.concat(weight3, "|"), 1, 3)
        end
        local gives = {}
        if resultIndex1 then
            local cfg = config[tonumber(resultIndex1)]
            table.insert(gives, cfg.give[1])
        end
        if resultIndex2 then
            local cfg = config[tonumber(resultIndex2)]
            table.insert(gives, cfg.give[1])
        end
        if resultIndex3 then
            local cfg = config[tonumber(resultIndex3)]
            table.insert(gives, cfg.give[1])
        end
        -- dump(gives)
        --发送钓鱼结果到邮箱
        local uid = Player.GetUUID(actor)
        Player.giveMailByTable(uid, 1, "鱼获奖励", "请领取您的鱼获奖励", gives, 1, true)
        Player.sendmsgEx(actor, "鱼获奖励已发送到邮箱")
        Message.sendmsg(actor, ssrNetMsgCfg.DiaoYuDaShi_ShouHuo, 0, 0, 0, gives)
        setplaydef(actor, "N$钓鱼状态", 0)
        DiaoYuDaShi.SyncResponse(actor)
    end
end

--接收请求 开始钓鱼
function DiaoYuDaShi.Request(actor)
    if getplaydef(actor, "N$钓鱼状态") == 1 then
        Player.sendmsgEx(actor, "你已经在钓鱼了#249")
        return
    end
    --购买的次数
    local buyFishingNum = getplaydef(actor, VarCfg["B_购买的次数"])
    --今日钓鱼次数
    local toDayFishingCount = getplaydef(actor, VarCfg["J_今日钓鱼次数"])
    --剩余免费次数
    local _freeCount = freeCount - toDayFishingCount
    --剩余总次数
    local totalCount = _freeCount + buyFishingNum
    if totalCount <= 0 then
        Player.sendmsgEx(actor, "你已经没有次数了#249")
        return
    end
    if _freeCount > 0 then
        setplaydef(actor, VarCfg["J_今日钓鱼次数"], toDayFishingCount + 1)
    else
        setplaydef(actor, VarCfg["B_购买的次数"], buyFishingNum - 1)
    end
    setplaydef(actor, VarCfg["J_今日钓鱼总次数"], getplaydef(actor, VarCfg["J_今日钓鱼总次数"]) + 1)
    DiaoYuDaShi.SyncResponse(actor)
    Message.sendmsg(actor, ssrNetMsgCfg.DiaoYuDaShi_StartFishing)
    setplaydef(actor, "N$钓鱼状态", 1)
    delaygoto(actor, 6000, "diao_yu_shou_huo")
end

--购买位置
function DiaoYuDaShi.BuyPos(actor)
    local name, num = Player.checkItemNumByTable(actor, cost)
    if name then
        Player.sendmsgEx(actor, string.format("添加鱼竿失败，你的|%s#249|不足|%d#249", name, num))
        return
    end

    local fishingRodNum = getplaydef(actor, VarCfg["B_鱼竿数量"])
    if fishingRodNum >= 2 then
        Player.sendmsgEx(actor, "最多只能添加2个鱼竿#249")
        return
    end
    Player.takeItemByTable(actor, cost, "购买鱼竿")
    setplaydef(actor, VarCfg["B_鱼竿数量"], fishingRodNum + 1)
    Player.sendmsgEx(actor, "添加鱼竿成功")
    DiaoYuDaShi.SyncResponse(actor)
end

--购买钓鱼次数
function DiaoYuDaShi.BuyCount(actor)
    if querymoney(actor, 7) < 100 then
        Player.sendmsgEx(actor, "你的|非绑定灵符#249|不足|100#249")
        return
    end
    --今日购买次数
    local toDayBuyCount = getplaydef(actor, VarCfg["J_今日钓鱼购买次数"])
    if toDayBuyCount >= buyCount then
        Player.sendmsgEx(actor, "每天最多只能购买30次#249")
        return
    end
    local fishingNum = getplaydef(actor, VarCfg["B_购买的次数"])
    changemoney(actor, 7, "-", 100, "购买钓鱼次数", true)
    setplaydef(actor, VarCfg["B_购买的次数"], fishingNum + 1)
    setplaydef(actor, VarCfg["J_今日钓鱼购买次数"], toDayBuyCount + 1)
    Player.sendmsgEx(actor, "购买钓鱼次数成功")
    DiaoYuDaShi.SyncResponse(actor)
end

--同步消息
function DiaoYuDaShi.SyncResponse(actor, logindatas)
    local fishingNum = getplaydef(actor, VarCfg["J_今日钓鱼购买次数"])
    local data = {fishingNum}
    local fishingRodNum = getplaydef(actor, VarCfg["B_鱼竿数量"])
    local toDayFishingCount = getplaydef(actor, VarCfg["J_今日钓鱼总次数"])
    local buyFishingNum = getplaydef(actor, VarCfg["B_购买的次数"])
    local _login_data = { ssrNetMsgCfg.DiaoYuDaShi_SyncResponse, fishingRodNum, toDayFishingCount, buyFishingNum, data }
    if logindatas then
        table.insert(logindatas, _login_data)
    else
        Message.sendmsg(actor, ssrNetMsgCfg.DiaoYuDaShi_SyncResponse, fishingRodNum, toDayFishingCount, buyFishingNum,
            data)
    end
end

--登录触发
local function _onLoginEnd(actor, logindatas)
    DiaoYuDaShi.SyncResponse(actor, logindatas)
end
--事件派发
GameEvent.add(EventCfg.onLoginEnd, _onLoginEnd, DiaoYuDaShi)
local function _onNewDay(actor)
    DiaoYuDaShi.SyncResponse(actor)
end
GameEvent.add(EventCfg.onNewDay, _onNewDay, DiaoYuDaShi)
--注册网络消息
Message.RegisterNetMsg(ssrNetMsgCfg.DiaoYuDaShi, DiaoYuDaShi)
return DiaoYuDaShi


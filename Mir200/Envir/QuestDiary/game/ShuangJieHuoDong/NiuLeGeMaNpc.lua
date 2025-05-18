local NiuLeGeMaNpc = {}
NiuLeGeMaNpc.ID = "牛了个马NPC"
local npcID = 156
local config = include("QuestDiary/cfgcsv/cfg_NiuLeGeMaNpc.lua") --配置
local cost = {{}}
local give = {{}}
--接收请求
function NiuLeGeMaNpc.Request(actor)
    --local name, num = Player.checkItemNumByTable(actor, cost)
    --if name then
        --Player.sendmsgEx(actor, string.format("你的|%s#249|不足|%d#249", name, num))
        --return
    --end
end
--同步消息
function NiuLeGeMaNpc.SyncResponse(actor, logindatas)
    local ranks = Player.getJsonTableByVar(nil, VarCfg["A_牛了个马排行榜"])
    Message.sendmsg(actor, ssrNetMsgCfg.NiuLeGeMaNpc_SyncResponse, 0, 0, 0, ranks)
end
-- --登录触发
-- local function _onLoginEnd(actor, logindatas)
--     NiuLeGeMaNpc.SyncResponse(actor, logindatas)
-- end
-- --事件派发
-- GameEvent.add(EventCfg.onLoginEnd, _onLoginEnd, NiuLeGeMaNpc)
local function _onBeforedawn(openday)
    local ranks = Player.getJsonTableByVar(nil, VarCfg["A_牛了个马排行榜"])
    local ranksSort = {}
    for k, v in pairs(ranks) do
        table.insert(ranksSort, { name = k, time = v })
    end
    table.sort(ranksSort, function(a, b)
        return a.time < b.time
    end)
    --取前三名
    local top3 = {}
    for i = 1, 3 do
        if ranksSort[i] then
            top3[i] = ranksSort[i]
        end
    end
    --给前三名奖励
    for i, v in ipairs(top3) do
        local rankChinese = formatNumberToChinese(i)
        local mailTitle = string.format("牛了个马第%s名奖励", rankChinese)
        local mailContent = string.format("恭喜你获得牛了个马第%s名，请领取您的奖励！", rankChinese)
        local t = config[i].give
        local isbind = true
        local mailRewards = {}
        for _, item in ipairs(t) do
            local items = {}
            if item[3] or isbind then
                items = { item[1], item[2] * 1, ConstCfg.binding }
            else
                items = { item[1], item[2] * 1 }
            end
            table.insert(mailRewards, table.concat(items, "#"))
        end
        local mailRewardStr = table.concat(mailRewards, "&")
        sendmail("#"..v.name, 1, mailTitle, mailContent, mailRewardStr)
    end
    Player.setJsonVarByTable(nil, VarCfg["A_牛了个马排行榜"], {})
end
GameEvent.add(EventCfg.roBeforedawn, _onBeforedawn, NiuLeGeMaNpc)
--注册网络消息
Message.RegisterNetMsg(ssrNetMsgCfg.NiuLeGeMaNpc, NiuLeGeMaNpc)
return NiuLeGeMaNpc
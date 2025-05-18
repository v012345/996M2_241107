local HunLuanDuTu = {}
HunLuanDuTu.ID = "混乱赌徒"
local npcID = 832
local config = include("QuestDiary/cfgcsv/cfg_HunLuanDuTu.lua") --配置
local cost = { { "元宝", 300000 } }
local cooling = 43200

function delay_hun_luan_du_tu_result(actor, resultIndex)
    if getplaydef(actor, "N$混乱赌徒防止刷") ~= 1 then
        return
    end
    resultIndex = tonumber(resultIndex)
    local cfg = config[resultIndex]
    local userid = Player.GetUUID(actor)
    if type(cfg.give) == "table" then
        local msgStr = getItemArrToStr(cfg.give)
        Player.sendmsgEx(actor, string.format("恭喜你获得|%s#249|,奖励已发送到邮件!", msgStr))
        local mailTitle = "混乱赌徒抽取奖励"
        local mailContent = string.format("恭喜你获得%s", msgStr)
        Player.giveMailByTable(userid, 1, mailTitle, mailContent, cfg.give, 1, true)
    else
        Player.sendmsgEx(actor, "抱歉,你没有获取任何奖励!#249")
        local mailTitle = "混乱赌徒抽取奖励"
        local mailContent = "抱歉,你没有获取任何奖励!"
        sendmail(userid, 1, mailTitle, mailContent)
    end
    setplaydef(actor, "N$混乱赌徒防止刷", 0)
end

--接收请求
function HunLuanDuTu.Request(actor)
    if getplaydef(actor, "N$混乱赌徒防止刷") == 1 then
        Player.sendmsgEx(actor, "请等待上一次抽取完成!#249")
        return
    end
    local lastTime = getplaydef(actor, VarCfg["B_上次抽取时间"])
    local currTime = os.time()
    local diff = currTime - lastTime
    if diff < cooling then
        local name, num = Player.checkItemNumByTable(actor, cost)
        if name then
            Player.sendmsgEx(actor, string.format("你的|%s#249|不足|%d#249", name, num))
            return
        end
        Player.takeItemByTable(actor, cost, "混乱赌徒")
    else
        setplaydef(actor, VarCfg["B_上次抽取时间"], os.time())
        Player.sendmsgEx(actor, "当前抽取免费")
        HunLuanDuTu.Sync(actor)
    end
    local count = getplaydef(actor, VarCfg["B_记录抽取次数"])
    local startIndex = 1
    if count < 19 then
        startIndex = 2
    end
    local weights = {}
    for i = startIndex, #config do
        local tmp = { i, config[i].weight }
        table.insert(weights, table.concat(tmp, "#"))
    end
    local weightStr = table.concat(weights, "|")
    local result1 = ransjstr(weightStr, 1, 3)
    local resultIndex = tonumber(result1)
    if count == 29 then
        resultIndex = 1
    end
    setplaydef(actor, VarCfg["B_记录抽取次数"], count + 1)
    setplaydef(actor, "N$混乱赌徒防止刷", 1)
    delaygoto(actor, 1200, "delay_hun_luan_du_tu_result,"..resultIndex)
    Message.sendmsg(actor, ssrNetMsgCfg.HunLuanDuTu_Response, resultIndex, 0, 0, {})
end

function HunLuanDuTu.Sync(actor)
    local lastTime = getplaydef(actor, VarCfg["B_上次抽取时间"])
    local currTime = os.time()
    local diff = currTime - lastTime
    local flag = 0
    if diff >= cooling then
        flag = 1
    else
        flag = 0
    end
    diff = math.floor(cooling - diff)
    if diff < 0 then
        diff = 0
    end
    Message.sendmsg(actor, ssrNetMsgCfg.HunLuanDuTu_Sync, diff, flag, 0, {})
end

--同步消息
-- function HunLuanDuTu.SyncResponse(actor, logindatas)
--     local data = {}
--     local _login_data = {ssrNetMsgCfg.HunLuanDuTu_SyncResponse, 0, 0, 0, data}
--     if logindatas then
--         table.insert(logindatas, _login_data)
--     else
--         Message.sendmsg(actor, ssrNetMsgCfg.HunLuanDuTu_SyncResponse, 0, 0, 0, data)
--     end
-- end
-- --登录触发
-- local function _onLoginEnd(actor, logindatas)
--     HunLuanDuTu.SyncResponse(actor, logindatas)
-- end
-- --事件派发
-- GameEvent.add(EventCfg.onLoginEnd, _onLoginEnd, HunLuanDuTu)
--注册网络消息
Message.RegisterNetMsg(ssrNetMsgCfg.HunLuanDuTu, HunLuanDuTu)
return HunLuanDuTu

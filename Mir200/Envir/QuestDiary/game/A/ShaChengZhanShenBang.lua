local ShaChengZhanShenBang = {}
ShaChengZhanShenBang.ID = "沙城战神榜"
local npcID = 0
--local config = include("QuestDiary/cfgcsv/cfg_ShaChengZhanShenBang.lua") --配置
local cost = { {} }
local gives = {
    { "至尊宝箱", 1 },
    { "钻石宝箱", 1 },
    { "黄金宝箱", 1 },
    { "白银宝箱", 1 },
    { "白银宝箱", 1 },
    { "白银宝箱", 1 } }
--判断我是否在排行榜内 并且返回名次
local function checkMyRank(actor, ranks)
    if not ranks then
        return
    end
    if #ranks == 0 then
        return
    end
    local myName = getbaseinfo(actor, ConstCfg.gbase.name)
    for i, v in ipairs(ranks) do
        if v.name == myName then
            return i
        end
    end
end
--接收请求
function ShaChengZhanShenBang.Request(actor)
    local lingQuList = Player.getJsonTableByVar(nil, VarCfg["A_排行榜领取记录"])
    local userId = getbaseinfo(actor, ConstCfg.gbase.id)
    if table.contains(lingQuList, userId) then
        Player.sendmsgEx(actor, string.format("你已经领取过了!#249"))
        return
    end
    local isTime = isTimeInRange(22, 04, 23, 00)
    if not isTime then
        Player.sendmsgEx(actor, string.format("请在|22:05-23:00#249|领取奖励!"))
        return
    end
    local Tdata = Player.getJsonTableByVar(nil, VarCfg["A_行会积分记录"])
    local gongshaRank = {}
    for i, v in pairs(Tdata) do
        for key, value in pairs(v) do
            table.insert(gongshaRank,
                {
                    name = key,
                    point = value
                }
            )
        end
    end
    --排序
    table.sort(gongshaRank, function(a, b)
        return a.point > b.point
    end)
    --只取前六名
    if #gongshaRank > 6 then
        for i = #gongshaRank, 7, -1 do
            table.remove(gongshaRank, i)
        end
    end
    --获取我的名字
    local myRank = checkMyRank(actor, gongshaRank)
    if not myRank then
        Player.sendmsgEx(actor, string.format("你没有在排行榜!#249"))
        return
    end
    local give = gives[myRank]
    if not give then
        Player.sendmsgEx(actor, string.format("获取奖励失败!#249"))
        return
    end
    Player.sendmsgEx(actor, string.format("你成功领取了第%d名奖励,请到邮件查收!#249", myRank))
    Player.giveMailByTable(userId, 1, "沙城战神榜", string.format("沙城战神榜第%d名奖励", myRank), { give }, 1, true)
    table.insert(lingQuList, userId)
    Player.setJsonVarByTable(nil, VarCfg["A_排行榜领取记录"], lingQuList)
end

--同步消息
-- function ShaChengZhanShenBang.SyncResponse(actor, logindatas)
--     local data = {}
--     local _login_data = {ssrNetMsgCfg.ShaChengZhanShenBang_SyncResponse, 0, 0, 0, data}
--     if logindatas then
--         table.insert(logindatas, _login_data)
--     else
--         Message.sendmsg(actor, ssrNetMsgCfg.ShaChengZhanShenBang_SyncResponse, 0, 0, 0, data)
--     end
-- end
-- --登录触发
-- local function _onLoginEnd(actor, logindatas)
--     ShaChengZhanShenBang.SyncResponse(actor, logindatas)
-- end
-- --事件派发
-- GameEvent.add(EventCfg.onLoginEnd, _onLoginEnd, ShaChengZhanShenBang)
--注册网络消息
Message.RegisterNetMsg(ssrNetMsgCfg.ShaChengZhanShenBang, ShaChengZhanShenBang)
return ShaChengZhanShenBang

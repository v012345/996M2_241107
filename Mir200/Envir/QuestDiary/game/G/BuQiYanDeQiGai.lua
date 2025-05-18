local BuQiYanDeQiGai = {}
BuQiYanDeQiGai.ID = "不起眼的乞丐"
local npcID = 831
--local config = include("QuestDiary/cfgcsv/cfg_BuQiYanDeQiGai.lua") --配置
local cost = { {} }
local give = { { "谣将印信", 1 } }
local targetNum = 1000000000
--接收请求
function BuQiYanDeQiGai.Request(actor, goldNum)
    if type(goldNum) ~= "number" then
        Player.sendmsgEx(actor, "参数错误!#249")
        return
    end
    if goldNum <= 0 then
        Player.sendmsgEx(actor, "输入数量不正确!#249")
        return
    end
    local cost = { { "金币", goldNum } }
    local name, num = Player.checkItemNumByTable(actor, cost)
    if name then
        Player.sendmsgEx(actor, string.format("你的|%s#249|不足|%d#249", name, num))
        return
    end
    Player.takeItemByTable(actor, cost, BuQiYanDeQiGai.ID)
    local currNum = getplaydef(actor, VarCfg["B_不起眼的乞丐金币数量"])
    setplaydef(actor, VarCfg["B_不起眼的乞丐金币数量"], currNum + goldNum)
    BuQiYanDeQiGai.SyncResponse(actor)
end

function BuQiYanDeQiGai.LingQu(actor)
    local currNum = getplaydef(actor, VarCfg["B_不起眼的乞丐金币数量"])
    if currNum < targetNum then
        Player.sendmsgEx(actor, "数量不够!#249")
        return
    end
    if not Bag.checkBagEmptyNum(actor, 5) then
        Player.sendmsgEx(actor, "你的背包格子不足,至少留出5个空格!#249")
        return
    end
    Player.giveItemByTable(actor, give, "谣将印信", 1, true)
    setflagstatus(actor, VarCfg["F_不起眼的乞丐是否领取"], 1)
    Player.sendmsgEx(actor, "恭喜你获得|谣将印信#249")
    setplaydef(actor, VarCfg["B_不起眼的乞丐金币数量"], 0)
    BuQiYanDeQiGai.SyncResponse(actor)
end

-- VarCfg["B_不起眼的乞丐金币数量"]
-- VarCfg["F_不起眼的乞丐是否领取"]
--同步消息
function BuQiYanDeQiGai.SyncResponse(actor, logindatas)
    local data = {}
    local currNum = getplaydef(actor, VarCfg["B_不起眼的乞丐金币数量"])
    -- local flag = getflagstatus(actor, VarCfg["F_不起眼的乞丐是否领取"])
    local _login_data = { ssrNetMsgCfg.BuQiYanDeQiGai_SyncResponse, currNum, 0, 0, data }
    if logindatas then
        table.insert(logindatas, _login_data)
    else
        Message.sendmsg(actor, ssrNetMsgCfg.BuQiYanDeQiGai_SyncResponse, currNum, 0, 0, data)
    end
end

--登录触发
local function _onLoginEnd(actor, logindatas)
    BuQiYanDeQiGai.SyncResponse(actor, logindatas)
end
--事件派发
GameEvent.add(EventCfg.onLoginEnd, _onLoginEnd, BuQiYanDeQiGai)
--注册网络消息
Message.RegisterNetMsg(ssrNetMsgCfg.BuQiYanDeQiGai, BuQiYanDeQiGai)
return BuQiYanDeQiGai

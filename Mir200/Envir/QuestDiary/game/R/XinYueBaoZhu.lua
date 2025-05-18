local XinYueBaoZhu = {}
XinYueBaoZhu.ID = "新月宝珠"
local cost = { { "月光印记", 1 }, { "月光手环", 1 }, { "新月之冠", 1 } }
local give = { { "新月宝珠", 1 } }
local npcID = 232
--local config = include("QuestDiary/cfgcsv/cfg_XinYueBaoZhu.lua") --配置
--接收请求
function XinYueBaoZhu.Request(actor)
    if not FCheckNPCRange(actor, npcID, 15) then
        Player.sendmsgEx(actor, "距离PNC太远!#249")
        return
    end
    local name, num = Player.checkItemNumByTable(actor, cost)
    if name then
        Player.sendmsgEx(actor, string.format("你的|%s#249|不足|%d#249", name, num))
        return
    end
    if not Bag.checkBagEmptyNum(actor, 5) then
        Player.sendmsgEx(actor, "你的背包格子不足,至少留出5个空格!#249")
        stop(actor)
    end
    Player.takeItemByTable(actor, cost, "新月宝珠剧情")
    Player.giveItemByTable(actor, give, "新月宝珠剧情", 1, true)
    XinYueBaoZhu.SyncResponse(actor)
    Player.sendmsgEx(actor, "提示：#251|恭喜你获得了|新月宝珠#249")
    setflagstatus(actor, VarCfg["F_新月宝珠_完成"], 1)
end

--同步消息
function XinYueBaoZhu.SyncResponse(actor, logindatas)
    local data = {}
    local _login_data = { ssrNetMsgCfg.XinYueBaoZhu_SyncResponse, 0, 0, 0, data }
    if logindatas then
        table.insert(logindatas, _login_data)
    else
        Message.sendmsg(actor, ssrNetMsgCfg.XinYueBaoZhu_SyncResponse, 0, 0, 0, data)
    end
end

--重载属性
local function attrReload(actor)
    delattlist(actor, "黑夜传说")
    if checkitemw(actor, "新月宝珠", 1) then
        if checktimeInPeriod(22, 59, 7, 59) then
            addattlist(actor, "黑夜传说", "=", "3#3#160|3#4#160", 1)
        end
    end
end
------------登录触发
local function _onLoginEnd(actor, logindatas)
    -- XinYueBaoZhu.SyncResponse(actor, logindatas)
    attrReload(actor)
end
GameEvent.add(EventCfg.onLoginEnd, _onLoginEnd, XinYueBaoZhu)
------------夜晚触发
local function _noStartingDark(actor)
    attrReload(actor)
end
GameEvent.add(EventCfg.onStartingDark, _noStartingDark, XinYueBaoZhu)
-----------白天触发
local function _noStartingDay(actor)
    attrReload(actor)
end
GameEvent.add(EventCfg.onStartingDay, _noStartingDay, XinYueBaoZhu)
--穿装备
local function _onTakeOnEx(actor, itemobj, where, itemname, makeid)
    if itemname == "新月宝珠" then
        attrReload(actor)
    end
end
GameEvent.add(EventCfg.onTakeOnEx, _onTakeOnEx, XinYueBaoZhu)

--脱装备
local function _onTakeOffEx(actor, itemobj, where, itemname, makeid)
    if itemname == "新月宝珠" then
        attrReload(actor)
    end
end
GameEvent.add(EventCfg.onTakeOffEx, _onTakeOffEx, XinYueBaoZhu)
--注册网络消息
Message.RegisterNetMsg(ssrNetMsgCfg.XinYueBaoZhu, XinYueBaoZhu)
return XinYueBaoZhu
--init内容

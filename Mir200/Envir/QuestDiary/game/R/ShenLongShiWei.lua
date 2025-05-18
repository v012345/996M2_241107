local ShenLongShiWei = {}
ShenLongShiWei.ID = "神龙侍卫"
local npcID = 320
--local config = include("QuestDiary/cfgcsv/cfg_ShenLongShiWei.lua") --配置
local cost = { { "异界神石", 10 } }
local give = { { "三生仙灵藤", 1 } }
--领取任务
function ShenLongShiWei.Request1(actor)
    setflagstatus(actor, VarCfg["F_剧情_神龙侍卫_领取"], 1)
    ShenLongShiWei.SyncResponse(actor)
end

--提交进度
function ShenLongShiWei.Request2(actor)
    if not FCheckNPCRange(actor, npcID, 15) then
        Player.sendmsgEx(actor, "距离PNC太远!#249")
        return
    end
    local jindu = getplaydef(actor, VarCfg["U_剧情_神龙侍卫_进度"])
    if jindu >= 100 then
        Player.sendmsgEx(actor, "你已经完成了封印!#249")
        return
    end
    local name, num = Player.checkItemNumByTable(actor, cost)
    if name then
        Player.sendmsgEx(actor, string.format("你的|%s#249|不足|%d#249", name, num))
        return
    end
    Player.takeItemByTable(actor, cost, "神龙侍卫")
    local randomNum = math.random(6, 12)
    setplaydef(actor, VarCfg["U_剧情_神龙侍卫_进度"], jindu + randomNum)
    Player.sendmsgEx(actor, string.format("加固封印成功,进度增加|%s#249", randomNum))
    ShenLongShiWei.SyncResponse(actor)
end

--领取奖励
function ShenLongShiWei.Request3(actor)
    local flag = getflagstatus(actor, VarCfg["F_剧情_神龙侍卫_领取奖励"])
    if flag == 1 then
        Player.sendmsgEx(actor, "你已经领取过了!#249")
        return
    end
    local jindu = getplaydef(actor, VarCfg["U_剧情_神龙侍卫_进度"])
    if jindu < 100 then
        Player.sendmsgEx(actor, "你还没有完成封印!#249")
        return
    end
    Player.giveItemByTable(actor, give, "神龙侍卫剧情", 1, true)
    setflagstatus(actor, VarCfg["F_剧情_神龙侍卫_领取奖励"], 1)
    Player.sendmsgEx(actor, "你领取了|三生仙灵藤#249|快去转生吧!")
    ShenLongShiWei.SyncResponse(actor)
end

--同步消息
function ShenLongShiWei.SyncResponse(actor, logindatas)
    local data = {}
    local falg = getflagstatus(actor, VarCfg["F_剧情_神龙侍卫_领取"])
    local falg2 = getflagstatus(actor, VarCfg["F_剧情_神龙侍卫_领取奖励"])
    local jindu = getplaydef(actor, VarCfg["U_剧情_神龙侍卫_进度"])
    local _login_data = { ssrNetMsgCfg.ShenLongShiWei_SyncResponse, falg, jindu, falg2, data }
    if logindatas then
        table.insert(logindatas, _login_data)
    else
        Message.sendmsg(actor, ssrNetMsgCfg.ShenLongShiWei_SyncResponse, falg, jindu, falg2, data)
    end
end

--登录触发
local function _onLoginEnd(actor, logindatas)
    ShenLongShiWei.SyncResponse(actor, logindatas)
end
--事件派发
GameEvent.add(EventCfg.onLoginEnd, _onLoginEnd, ShenLongShiWei)
--注册网络消息
Message.RegisterNetMsg(ssrNetMsgCfg.ShenLongShiWei, ShenLongShiWei)
return ShenLongShiWei

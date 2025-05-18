local YunLie = {}
YunLie.ID = "云烈"
local npcID = 319
--local config = include("QuestDiary/cfgcsv/cfg_YunLie.lua") --配置
local cost = { { "魔龙牙", 10 }, { "魔龙骨", 10 } }
-- local give = {{}}
--接收请求
function YunLie.Request1(actor)
    setflagstatus(actor, VarCfg["F_剧情_云烈_领取"], 1)
    YunLie.SyncResponse(actor)
end

--召唤
function YunLie.Request2(actor)
    if not FCheckNPCRange(actor, npcID, 15) then
        Player.sendmsgEx(actor, "距离PNC太远!#249")
        return
    end
    local name, num = Player.checkItemNumByTable(actor, cost)
    if name then
        Player.sendmsgEx(actor, string.format("你的|%s#249|不足|%d#249", name, num))
        return
    end
    Player.takeItemByTable(actor, cost, "云烈剧情")
    local x = getbaseinfo(actor, ConstCfg.gbase.x)
    local y = getbaseinfo(actor, ConstCfg.gbase.y)
    genmon("南风森林", x, y, "上古魔龙", 1, 1, 255)
    Player.sendmsgEx(actor, "你成功召唤了|上古魔龙#249|击杀boss,有概率获得任务物品!")
    Player.sendmsgEx(actor, "你成功召唤了|上古魔龙#249|击杀boss,有概率获得任务物品!")
    Player.sendmsgEx(actor, "你成功召唤了|上古魔龙#249|击杀boss,有概率获得任务物品!")
    local num = getplaydef(actor, VarCfg["U_上古魔龙召唤_数量"])
    if num < 3 then
        setplaydef(actor, VarCfg["U_上古魔龙召唤_数量"],num+1)
        if num+1 == 1 then
            local taskPanelID = getplaydef(actor, VarCfg["U_主线任务面板进度"])
            if taskPanelID == 18 then
                FCheckTaskRedPoint(actor)
            end
        end
    end
    Message.sendmsg(actor, ssrNetMsgCfg.YunLie_Close, 0, 0, 0, {})
end

--同步消息
function YunLie.SyncResponse(actor, logindatas)
    local data = {}
    local flag = getflagstatus(actor, VarCfg["F_剧情_云烈_领取"])
    local _login_data = { ssrNetMsgCfg.YunLie_SyncResponse, flag, 0, 0, data }
    if logindatas then
        table.insert(logindatas, _login_data)
    else
        Message.sendmsg(actor, ssrNetMsgCfg.YunLie_SyncResponse, flag, 0, 0, data)
    end
end

--登录触发
local function _onLoginEnd(actor, logindatas)
    YunLie.SyncResponse(actor, logindatas)
end
--事件派发
GameEvent.add(EventCfg.onLoginEnd, _onLoginEnd, YunLie)
--注册网络消息
Message.RegisterNetMsg(ssrNetMsgCfg.YunLie, YunLie)
return YunLie

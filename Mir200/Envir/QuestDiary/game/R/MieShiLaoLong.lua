local MieShiLaoLong = {}
MieShiLaoLong.ID = "灭世牢笼"
local npcID = 508
--local config = include("QuestDiary/cfgcsv/cfg_MieShiLaoLong.lua") --配置
local cost = { { "龙魂封印石", 88 }, { "元宝", 300000 } }
local give = { {} }
--接收请求
function MieShiLaoLong.Request1(actor)
    if not FCheckNPCRange(actor, npcID, 15) then
        Player.sendmsgEx(actor, "距离PNC太远!#249")
        return
    end
    if getflagstatus(actor,VarCfg["F_剧情_灭世牢笼_解封地图"]) == 1 then
        Player.sendmsgEx(actor, "你已经解除了封印!#249")
        return
    end
    local name, num = Player.checkItemNumByTable(actor, cost)
        if name then
            Player.sendmsgEx(actor, string.format("你的|%s#249|不足|%d#249", name, num))
        return
    end
    Player.takeItemByTable(actor, cost, "灭世牢笼")
    if randomex(30) then
        -- setflagstatus(actor,VarCfg["F_剧情_灭世牢笼_解封地图"],1)
        FSetTaskRedPoint(actor, VarCfg["F_剧情_灭世牢笼_解封地图"], 43)
        Player.sendmsgEx(actor, "解除封印成功!")
    else
        Player.sendmsgEx(actor, "解除封印失败了!#249")
    end
    
    MieShiLaoLong.SyncResponse(actor)
end
--接收请求
function MieShiLaoLong.Request2(actor)
    if getflagstatus(actor,VarCfg["F_剧情_灭世牢笼_解封地图"]) == 1 then
        map(actor, "灭世牢笼")
    else
        Player.sendmsgEx(actor, "进入失败,未解封!#249")
    end
    
end

--同步消息
function MieShiLaoLong.SyncResponse(actor, logindatas)
    local data = {}
    local flag = getflagstatus(actor,VarCfg["F_剧情_灭世牢笼_解封地图"])
    local _login_data = {ssrNetMsgCfg.MieShiLaoLong_SyncResponse, flag, 0, 0, data}
    if logindatas then
        table.insert(logindatas, _login_data)
    else
        Message.sendmsg(actor, ssrNetMsgCfg.MieShiLaoLong_SyncResponse, flag, 0, 0, data)
    end
end
--登录触发
local function _onLoginEnd(actor, logindatas)
    MieShiLaoLong.SyncResponse(actor, logindatas)
end
--事件派发
GameEvent.add(EventCfg.onLoginEnd, _onLoginEnd, MieShiLaoLong)
--注册网络消息
Message.RegisterNetMsg(ssrNetMsgCfg.MieShiLaoLong, MieShiLaoLong)
return MieShiLaoLong

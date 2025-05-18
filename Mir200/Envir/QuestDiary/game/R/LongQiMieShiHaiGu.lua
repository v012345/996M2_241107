local LongQiMieShiHaiGu = {}
LongQiMieShiHaiGu.ID = "龙器灭世骸骨"
local npcID = 509
--local config = include("QuestDiary/cfgcsv/cfg_LongQiMieShiHaiGu.lua") --配置
local cost = { { "[龍器]祖龍號角", 1 }, { "造化结晶", 188 }, { "灭世魔龙结晶", 1 }, { "元宝", 5550000 } }
local give = { { "[龍器]灭世骸骨", 1 } }
--接收请求
function LongQiMieShiHaiGu.Request(actor)
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
        return
    end
    Player.takeItemByTable(actor, cost, "龙器灭世骸骨")
    setflagstatus(actor, VarCfg["F_龙器灭世骸骨"], 1)
    Player.giveItemByTable(actor, give, "龙器灭世骸骨", 1, true)
    local myName = getbaseinfo(actor, ConstCfg.gbase.name)
    Player.sendmsgnewEx(actor, 0, 0, string.format("玩家|%s#253|在|灭世牢笼#249|成功合成|[龍器]灭世骸骨#249|实力获得大幅提升", myName))
    Player.sendmsgEx(actor, "恭喜你合成成功!")
end

--同步消息
-- function LongQiMieShiHaiGu.SyncResponse(actor, logindatas)
--     local data = {}
--     local _login_data = {ssrNetMsgCfg.LongQiMieShiHaiGu_SyncResponse, 0, 0, 0, data}
--     if logindatas then
--         table.insert(logindatas, _login_data)
--     else
--         Message.sendmsg(actor, ssrNetMsgCfg.LongQiMieShiHaiGu_SyncResponse, 0, 0, 0, data)
--     end
-- end
-- --登录触发
-- local function _onLoginEnd(actor, logindatas)
--     LongQiMieShiHaiGu.SyncResponse(actor, logindatas)
-- end
-- --事件派发
-- GameEvent.add(EventCfg.onLoginEnd, _onLoginEnd, LongQiMieShiHaiGu)
--注册网络消息
Message.RegisterNetMsg(ssrNetMsgCfg.LongQiMieShiHaiGu, LongQiMieShiHaiGu)
return LongQiMieShiHaiGu

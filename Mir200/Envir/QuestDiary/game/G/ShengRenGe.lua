local ShengRenGe = {}
ShengRenGe.ID = "圣人阁"
local npcID = 804
local mapID = "圣人阁"
--local config = include("QuestDiary/cfgcsv/cfg_ShengRenGe.lua") --配置
local cost = {{}}
local give = {{}}
--接收请求
function ShengRenGe.Request(actor)
    local isInRange = FCheckNPCRange(actor, npcID, 15)
    if not isInRange then
        Player.sendmsgEx(actor, "距离太远#249")
        return
    end
    FMapMoveEx(actor,mapID,45,30,0)
    --local name, num = Player.checkItemNumByTable(actor, cost)
    --if name then
        --Player.sendmsgEx(actor, string.format("你的|%s#249|不足|%d#249", name, num))
        --return
    --end
end
--同步消息
-- function ShengRenGe.SyncResponse(actor, logindatas)
--     local data = {}
--     local _login_data = {ssrNetMsgCfg.ShengRenGe_SyncResponse, 0, 0, 0, data}
--     if logindatas then
--         table.insert(logindatas, _login_data)
--     else
--         Message.sendmsg(actor, ssrNetMsgCfg.ShengRenGe_SyncResponse, 0, 0, 0, data)
--     end
-- end
-- --登录触发
-- local function _onLoginEnd(actor, logindatas)
--     ShengRenGe.SyncResponse(actor, logindatas)
-- end
-- --事件派发
-- GameEvent.add(EventCfg.onLoginEnd, _onLoginEnd, ShengRenGe)
--注册网络消息
Message.RegisterNetMsg(ssrNetMsgCfg.ShengRenGe, ShengRenGe)
return ShengRenGe
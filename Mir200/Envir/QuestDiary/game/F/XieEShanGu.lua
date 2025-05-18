local XieEShanGu = {}
XieEShanGu.ID = "邪恶山谷"
local npcID = 3458
--local config = include("QuestDiary/cfgcsv/cfg_XieEShanGu.lua") --配置
local cost = {{}}
local give = {{}}
--接收请求
function XieEShanGu.Request(actor)
    local var = getplaydef(actor,VarCfg["U_巅峰等级1"])
    if var < 5 then
        Player.sendmsgnewEx(actor, "巅峰入世不足5重!")
        return
    end
    FMapMoveEx(actor, "邪恶山谷", 187, 184, 1)
    --local name, num = Player.checkItemNumByTable(actor, cost)
    --if name then
        --Player.sendmsgEx(actor, string.format("你的|%s#249|不足|%d#249", name, num))
        --return
    --end
end
--同步消息
-- function XieEShanGu.SyncResponse(actor, logindatas)
--     local data = {}
--     local _login_data = {ssrNetMsgCfg.XieEShanGu_SyncResponse, 0, 0, 0, data}
--     if logindatas then
--         table.insert(logindatas, _login_data)
--     else
--         Message.sendmsg(actor, ssrNetMsgCfg.XieEShanGu_SyncResponse, 0, 0, 0, data)
--     end
-- end
-- --登录触发
-- local function _onLoginEnd(actor, logindatas)
--     XieEShanGu.SyncResponse(actor, logindatas)
-- end
-- --事件派发
-- GameEvent.add(EventCfg.onLoginEnd, _onLoginEnd, XieEShanGu)
--注册网络消息
Message.RegisterNetMsg(ssrNetMsgCfg.XieEShanGu, XieEShanGu)
return XieEShanGu
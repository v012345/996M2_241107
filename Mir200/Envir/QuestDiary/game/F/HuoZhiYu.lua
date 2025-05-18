local HuoZhiYu = {}
HuoZhiYu.ID = "火之域"
local npcID = 3457
--local config = include("QuestDiary/cfgcsv/cfg_HuoZhiYu.lua") --配置
local cost = {{}}
local give = {{}}
--接收请求
function HuoZhiYu.Request(actor)
    local var = getplaydef(actor,VarCfg["U_巅峰等级1"])
    if var < 5 then
        Player.sendmsgnewEx(actor, "巅峰入世不足5重!")
        return
    end
    FMapMoveEx(actor, "火之域", 40, 40, 1)
end
--同步消息
-- function HuoZhiYu.SyncResponse(actor, logindatas)
--     local data = {}
--     local _login_data = {ssrNetMsgCfg.HuoZhiYu_SyncResponse, 0, 0, 0, data}
--     if logindatas then
--         table.insert(logindatas, _login_data)
--     else
--         Message.sendmsg(actor, ssrNetMsgCfg.HuoZhiYu_SyncResponse, 0, 0, 0, data)
--     end
-- end
-- --登录触发
-- local function _onLoginEnd(actor, logindatas)
--     HuoZhiYu.SyncResponse(actor, logindatas)
-- end
-- --事件派发
-- GameEvent.add(EventCfg.onLoginEnd, _onLoginEnd, HuoZhiYu)
--注册网络消息
Message.RegisterNetMsg(ssrNetMsgCfg.HuoZhiYu, HuoZhiYu)
return HuoZhiYu
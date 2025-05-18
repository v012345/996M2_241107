local TianYuanBianGuan = {}
TianYuanBianGuan.ID = "天元边关"
local npcID = 118
--local config = include("QuestDiary/cfgcsv/cfg_TianYuanBianGuan.lua") --配置
local mapID = "天元边关"
--接收请求
function TianYuanBianGuan.Request(actor)
    if not FCheckLevel(actor, 60) then
        Player.sendmsgEx(actor,"等级不足60级,进入失败!#249")
        return
    end

    FSetTaskRedPoint(actor, VarCfg["F_进入天元边关完成"], 2)
    FMapMoveEx(actor, mapID, 98, 91, 3)
end
--同步消息
-- function TianYuanBianGuan.SyncResponse(actor, logindatas)
--     local data = {}
--     local _login_data = {ssrNetMsgCfg.TianYuanBianGuan_SyncResponse, 0, 0, 0, data}
--     if logindatas then
--         table.insert(logindatas, _login_data)
--     else
--         Message.sendmsg(actor, ssrNetMsgCfg.TianYuanBianGuan_SyncResponse, 0, 0, 0, data)
--     end
-- end
-- --登录触发
-- local function _onLoginEnd(actor, logindatas)
--     TianYuanBianGuan.SyncResponse(actor, logindatas)
-- end
-- --事件派发
-- GameEvent.add(EventCfg.onLoginEnd, _onLoginEnd, TianYuanBianGuan)
--注册网络消息
Message.RegisterNetMsg(ssrNetMsgCfg.TianYuanBianGuan, TianYuanBianGuan)
return TianYuanBianGuan
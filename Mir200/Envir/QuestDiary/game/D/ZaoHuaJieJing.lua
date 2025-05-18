local ZaoHuaJieJing = {}
ZaoHuaJieJing.ID = "造化结晶"
local npcID = 519
--local config = include("QuestDiary/cfgcsv/cfg_ZaoHuaJieJing.lua") --配置
local cost = {{"灵石",5},{"焚天石",300},{"天工之锤",300},{"金币",1000000}}
local give = {{"造化结晶",1}}
--接收请求
function ZaoHuaJieJing.Request(actor)
    local name, num = Player.checkItemNumByTable(actor, cost)
    if name then
        Player.sendmsgEx(actor, string.format("融合失败,你的|%s#249|不足|%d#249", name, num))
        return
    end
    Player.takeItemByTable(actor, cost, "造化结晶融合")
    Player.giveItemByTable(actor, give, "造化结晶融合", 1, ConstCfg.binding)
    Player.sendmsgEx(actor, "造化结晶融合成功")
end
--同步消息
-- function ZaoHuaJieJing.SyncResponse(actor, logindatas)
--     local data = {}
--     local _login_data = {ssrNetMsgCfg.ZaoHuaJieJing_SyncResponse, 0, 0, 0, data}
--     if logindatas then
--         table.insert(logindatas, _login_data)
--     else
--         Message.sendmsg(actor, ssrNetMsgCfg.ZaoHuaJieJing_SyncResponse, 0, 0, 0, data)
--     end
-- end
-- --登录触发
-- local function _onLoginEnd(actor, logindatas)
--     ZaoHuaJieJing.SyncResponse(actor, logindatas)
-- end
-- --事件派发
-- GameEvent.add(EventCfg.onLoginEnd, _onLoginEnd, ZaoHuaJieJing)
--注册网络消息
Message.RegisterNetMsg(ssrNetMsgCfg.ZaoHuaJieJing, ZaoHuaJieJing)
return ZaoHuaJieJing
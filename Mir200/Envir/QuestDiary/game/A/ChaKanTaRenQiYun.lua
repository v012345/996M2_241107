local ChaKanTaRenQiYun = {}
ChaKanTaRenQiYun.ID = "查看他人气运"
local npcID = 0
--local config = include("QuestDiary/cfgcsv/cfg_ChaKanTaRenQiYun.lua") --配置
local cost = { {} }
local give = { {} }
--接收请求
function ChaKanTaRenQiYun.Request(actor)
    --local name, num = Player.checkItemNumByTable(actor, cost)
    --if name then
    --Player.sendmsgEx(actor, string.format("你的|%s#249|不足|%d#249", name, num))
    --return
    --end
end

function ChaKanTaRenQiYun.openUI(actor, arg1, arg2, arg3, data)
    local targetName = data[1]
    if not targetName then
        Player.sendmsgEx(actor, "参数错误！#249")
        return
    end
    local targetObj = getplayerbyname(targetName)
    if not targetObj or targetObj == "" or targetObj == "0" or not isnotnull(targetObj) then
        Player.sendmsgEx(actor, string.format("玩家[%s]不在线，无法查看！#249", targetName))
        return
    end
    local data = {}
    local unLockData = TianMing.GetLockState(targetObj)
    local myTianMingData = TianMing.GetTianMingList(targetObj)
    data.unLock = unLockData
    data.myTianMing = myTianMingData
    Message.sendmsg(actor, ssrNetMsgCfg.ChaKanTaRenQiYun_openUI, 0, 0, 0, data)
end

--同步消息
-- function ChaKanTaRenQiYun.SyncResponse(actor, logindatas)
--     local data = {}
--     local _login_data = {ssrNetMsgCfg.ChaKanTaRenQiYun_SyncResponse, 0, 0, 0, data}
--     if logindatas then
--         table.insert(logindatas, _login_data)
--     else
--         Message.sendmsg(actor, ssrNetMsgCfg.ChaKanTaRenQiYun_SyncResponse, 0, 0, 0, data)
--     end
-- end
-- --登录触发
-- local function _onLoginEnd(actor, logindatas)
--     ChaKanTaRenQiYun.SyncResponse(actor, logindatas)
-- end
-- --事件派发
-- GameEvent.add(EventCfg.onLoginEnd, _onLoginEnd, ChaKanTaRenQiYun)
--注册网络消息
Message.RegisterNetMsg(ssrNetMsgCfg.ChaKanTaRenQiYun, ChaKanTaRenQiYun)
return ChaKanTaRenQiYun

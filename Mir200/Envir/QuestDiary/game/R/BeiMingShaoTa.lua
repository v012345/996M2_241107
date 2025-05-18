local BeiMingShaoTa = {}
BeiMingShaoTa.ID = "悲鸣哨塔"
local npcID = 330
--local config = include("QuestDiary/cfgcsv/cfg_BeiMingShaoTa.lua") --配置
local cost = { {} }
local give = { {} }
--接收请求
function BeiMingShaoTa.Request(actor)
    local num = getplaydef(actor, VarCfg["U_剧情_悲鸣哨塔_线索数量"])
    if num >= 100 then
        Player.sendmsgEx(actor, "你已经提交了足够的叛军线索,无需再次提交!#249")
        return
    end
    local itemNum = getbagitemcount(actor, "叛军线索")
    if itemNum <= 0 then
        Player.sendmsgEx(actor, "提交失败,你没有叛军线索!#249")
        return
    end
    takeitem(actor, "叛军线索", itemNum, 0)
    setplaydef(actor, VarCfg["U_剧情_悲鸣哨塔_线索数量"], num + itemNum)
    Player.sendmsgEx(actor, "你提交了|" .. itemNum .. "#249|个叛军线索,请继续努力!")
    if num + itemNum >= 100 then
        Player.sendmsgEx(actor, "你提交了足够的|叛军线索#249|,已为你分析出了|叛军老巢#249|所在位置!")
        local taskPanelID = getplaydef(actor, VarCfg["U_主线任务面板进度"])
        if taskPanelID == 26 then
            FCheckTaskRedPoint(actor)
        end
    end
    BeiMingShaoTa.SyncResponse(actor)
end
function BeiMingShaoTa.SyncResponse(actor, logindatas)
    local num = getplaydef(actor, VarCfg["U_剧情_悲鸣哨塔_线索数量"])
    local data = {}
    local _login_data = {ssrNetMsgCfg.BeiMingShaoTa_SyncResponse, num, 0, 0, data}
    if logindatas then
        table.insert(logindatas, _login_data)
    else
        Message.sendmsg(actor, ssrNetMsgCfg.BeiMingShaoTa_SyncResponse, num, 0, 0, data)
    end
end
--登录触发
local function _onLoginEnd(actor, logindatas)
    BeiMingShaoTa.SyncResponse(actor, logindatas)
end
-- --事件派发
GameEvent.add(EventCfg.onLoginEnd, _onLoginEnd, BeiMingShaoTa)
--注册网络消息
Message.RegisterNetMsg(ssrNetMsgCfg.BeiMingShaoTa, BeiMingShaoTa)
return BeiMingShaoTa

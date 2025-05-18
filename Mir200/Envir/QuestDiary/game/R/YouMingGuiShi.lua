local YouMingGuiShi = {}
YouMingGuiShi.ID = "幽冥鬼使"
local npcID = 446
--local config = include("QuestDiary/cfgcsv/cfg_YouMingGuiShi.lua") --配置
-- local give = { { "■龙之叹息■", 1 }, { "玄阴〃吊坠", 1 }, { "纯阴之体", 1 }, { "灵魂枷锁", 1 }, { "掌控奥义", 1 }, }
local cost = { {"异界神石",58},{"元宝",3888888} }
--接收请求
local function isOpenMap(actor)
    local result
        if getflagstatus(actor,VarCfg["F_剧情_幽冥鬼使_地图开启"]) == 1 then
            result = true
        else
            result = false
    end 
    return result
end
function YouMingGuiShi.Request1(actor)
    if isOpenMap(actor) then
        Player.sendmsgEx(actor, "你已经开启了改地图!#249")
        return
    end
    local name, num = Player.checkItemNumByTable(actor, cost)
    if name then
        Player.sendmsgEx(actor, string.format("开启失败,你的|%s#249|不足|%d#249", name, num))
        return
    end
    Player.takeItemByTable(actor, cost,"幽冥鬼使剧情")
    setflagstatus(actor,VarCfg["F_剧情_幽冥鬼使_地图开启"],1)
    YouMingGuiShi.SyncResponse(actor)
    Player.sendmsgEx(actor, "开启成功!")
end
function YouMingGuiShi.Request2(actor)
    if isOpenMap(actor) then
        map(actor, "qipan")
    else
        Player.sendmsgEx(actor, "你没有开启改地图!#249")
    end
end
--同步消息
function YouMingGuiShi.SyncResponse(actor, logindatas)
    local data = {}
    local flag = getflagstatus(actor,VarCfg["F_剧情_幽冥鬼使_地图开启"])
    local _login_data = {ssrNetMsgCfg.YouMingGuiShi_SyncResponse, flag, 0, 0, data}
    if logindatas then
        table.insert(logindatas, _login_data)
    else
        Message.sendmsg(actor, ssrNetMsgCfg.YouMingGuiShi_SyncResponse, flag, 0, 0, data)
    end
end
--登录触发
local function _onLoginEnd(actor, logindatas)
    YouMingGuiShi.SyncResponse(actor, logindatas)
end
--事件派发
GameEvent.add(EventCfg.onLoginEnd, _onLoginEnd, YouMingGuiShi)
--注册网络消息
Message.RegisterNetMsg(ssrNetMsgCfg.YouMingGuiShi, YouMingGuiShi)
return YouMingGuiShi
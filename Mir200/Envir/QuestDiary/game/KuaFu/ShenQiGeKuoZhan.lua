local ShenQiGeKuoZhan = {}
ShenQiGeKuoZhan.ID = "神器格扩展"
local npcID = 129
local config = include("QuestDiary/cfgcsv/cfg_ShenQiGeKuoZhan.lua") --配置
local function _getCurrShenQiGeZi(actor)
    return getplaydef(actor, VarCfg["U_新加背包神器格子数"])
end
--设置格子数
local function _setCurrShenQiGeZi(actor, num)
    setplaydef(actor, VarCfg["U_新加背包神器格子数"], num)
end
--接收请求
function ShenQiGeKuoZhan.Request(actor, index)
    if not index then
        return
    end
    local currShenQiGeZi = _getCurrShenQiGeZi(actor)
    local cfg = config[currShenQiGeZi + 1]
    if not cfg then
        Player.sendmsgEx(actor, "最多只能扩展十个格子!#249")
        return
    end
    local cost = {}
    if index == 1 then
        cost = cfg.freeCost
    elseif index == 2 then
        cost = cfg.payCost
    else
        Player.sendmsgEx(actor, "参数错误!#249")
        return
    end
    local name, num = Player.checkItemNumByTable(actor, cost)
    if name then
        Player.sendmsgEx(actor, string.format("你的|%s#249|不足|%d#249", name, num))
        return
    end
    Player.takeItemByTable(actor, cost, "神器格扩展", 1)
    _setCurrShenQiGeZi(actor, currShenQiGeZi + 1)
    Player.sendmsgEx(actor, "扩展成功!")
    ShenQiGeKuoZhan.SyncResponse(actor)
end

--同步消息
function ShenQiGeKuoZhan.SyncResponse(actor, logindatas)
    local num = _getCurrShenQiGeZi(actor)
    local data = {}
    local _login_data = { ssrNetMsgCfg.ShenQiGeKuoZhan_SyncResponse, num, 0, 0, data }
    if logindatas then
        table.insert(logindatas, _login_data)
    else
        Message.sendmsg(actor, ssrNetMsgCfg.ShenQiGeKuoZhan_SyncResponse, num, 0, 0, data)
    end
end

--登录触发
local function _onLoginEnd(actor, logindatas)
    ShenQiGeKuoZhan.SyncResponse(actor, logindatas)
end
--事件派发
GameEvent.add(EventCfg.onLoginEnd, _onLoginEnd, ShenQiGeKuoZhan)
--注册网络消息
Message.RegisterNetMsg(ssrNetMsgCfg.ShenQiGeKuoZhan, ShenQiGeKuoZhan)
return ShenQiGeKuoZhan

local LingHunLaoLong = {}
LingHunLaoLong.ID = "灵魂牢笼"
local npcID = 324
--local config = include("QuestDiary/cfgcsv/cfg_LingHunLaoLong.lua") --配置
local cost = {{"牢笼钥匙",1}}
local give = {{}}
--接收请求
function LingHunLaoLong.Request(actor)
    if not FCheckNPCRange(actor, npcID, 15) then
        Player.sendmsgEx(actor, "距离PNC太远!#249")
        return
    end
    local count = getplaydef(actor,VarCfg["U_剧情_灵魂牢笼_次数"])
    if count >= 10 then
        Player.sendmsgEx(actor, "最多只能解放10次灵魂#249")
        return
    end
    local name, num = Player.checkItemNumByTable(actor, cost)
    if name then
        Player.sendmsgEx(actor, string.format("你的|%s#249|不足|%d#249", name, num))
        return
    end
    Player.takeItemByTable(actor, cost, "灵魂牢笼")
    setplaydef(actor,VarCfg["U_剧情_灵魂牢笼_次数"], count + 1)
    if count + 1 == 1 then
        local taskPanelID = getplaydef(actor, VarCfg["U_主线任务面板进度"])
        if taskPanelID == 25 then
            FCheckTaskRedPoint(actor)
        end
    end
    Player.setAttList(actor, "属性附加")
    LingHunLaoLong.SyncResponse(actor)
    ShengSiJingJie.SyncResponse(actor) --同步生死境界
    Player.sendmsgEx(actor, "解放灵魂成功!")
end
--同步消息
function LingHunLaoLong.SyncResponse(actor, logindatas)
    local data = {}
    local count = getplaydef(actor,VarCfg["U_剧情_灵魂牢笼_次数"])
    local _login_data = {ssrNetMsgCfg.LingHunLaoLong_SyncResponse, count, 0, 0, data}
    if logindatas then
        table.insert(logindatas, _login_data)
    else
        Message.sendmsg(actor, ssrNetMsgCfg.LingHunLaoLong_SyncResponse, count, 0, 0, data)
    end
end
--登录触发
local function _onLoginEnd(actor, logindatas)
    LingHunLaoLong.SyncResponse(actor, logindatas)
end
--事件派发
GameEvent.add(EventCfg.onLoginEnd, _onLoginEnd, LingHunLaoLong)

local function _onCalcAttr(actor, attrs)
    local shuxing = {}
    local count = getplaydef(actor,VarCfg["U_剧情_灵魂牢笼_次数"])
    if count > 0 then
        shuxing[1] = 100 * count
        calcAtts(attrs, shuxing, "灵魂牢笼")
    end
end
--属性
GameEvent.add(EventCfg.onCalcAttr, _onCalcAttr, LingHunLaoLong)
--注册网络消息
Message.RegisterNetMsg(ssrNetMsgCfg.LingHunLaoLong, LingHunLaoLong)
return LingHunLaoLong
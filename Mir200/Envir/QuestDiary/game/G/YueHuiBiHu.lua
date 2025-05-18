local YueHuiBiHu = {}
YueHuiBiHu.ID = "月辉庇护"
local npcID = 828
--local config = include("QuestDiary/cfgcsv/cfg_YueHuiBiHu.lua") --配置
local cost = { { "〝回魂〞", 1 }, { "灵符", 888 } }
--接收请求
function YueHuiBiHu.Request(actor)
    local count = getplaydef(actor, VarCfg["B_月辉庇护_次数"])
    if count >= 5 then
        Player.sendmsgEx(actor, "最多只能提交5次!#249")
        return
    end
    local name, num = Player.checkItemNumByTable(actor, cost)
    if name then
        Player.sendmsgEx(actor, string.format("你的|%s#249|不足|%d#249", name, num))
        return
    end
    Player.takeItemByTable(actor, cost, YueHuiBiHu.ID)
    setplaydef(actor, VarCfg["B_月辉庇护_次数"], count + 1)
    Player.setAttList(actor, "属性附加")
    YueHuiBiHu.SyncResponse(actor)
    Player.sendmsgEx(actor, "提交成功!")
end

--同步消息
function YueHuiBiHu.SyncResponse(actor, logindatas)
    local data = {}
    local num = getplaydef(actor, VarCfg["B_月辉庇护_次数"])
    local _login_data = { ssrNetMsgCfg.YueHuiBiHu_SyncResponse, num, 0, 0, data }
    if logindatas then
        table.insert(logindatas, _login_data)
    else
        Message.sendmsg(actor, ssrNetMsgCfg.YueHuiBiHu_SyncResponse, num, 0, 0, data)
    end
end

local function _onCalcAttr(actor, attrs)
    local Num = getplaydef(actor, VarCfg["B_月辉庇护_次数"])
    local shuxing = {}
    if Num > 0 and Num <= 10 then
        shuxing[233] = Num
    end
    calcAtts(attrs, shuxing, "月光庇护")
end
GameEvent.add(EventCfg.onCalcAttr, _onCalcAttr, YueHuiBiHu)

--登录触发
local function _onLoginEnd(actor, logindatas)
    YueHuiBiHu.SyncResponse(actor, logindatas)
end
--事件派发
GameEvent.add(EventCfg.onLoginEnd, _onLoginEnd, YueHuiBiHu)
--注册网络消息
Message.RegisterNetMsg(ssrNetMsgCfg.YueHuiBiHu, YueHuiBiHu)
return YueHuiBiHu

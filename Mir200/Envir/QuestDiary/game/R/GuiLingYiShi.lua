local GuiLingYiShi = {}
GuiLingYiShi.ID = "归灵仪式"
local npcID = 327
--local config = include("QuestDiary/cfgcsv/cfg_GuiLingYiShi.lua") --配置
local cost = { { "妖月之心", 20 }, { "厥阴之灵", 20 } }
local mons = {
    "山神修普诺斯[至高神灵]",
    "暗之神·麦尔柯[咆哮]",
    "巨灵大元素师",
    "堕落的审判魔王",
    "大地暴剑魔",
    "妖月九尾狐王",
}
--接收请求
function GuiLingYiShi.Request(actor)
    if not FCheckNPCRange(actor, npcID, 15) then
        Player.sendmsgEx(actor, "距离PNC太远!#249")
        return
    end
    local name, num = Player.checkItemNumByTable(actor, cost)
    if name then
        Player.sendmsgEx(actor, string.format("你的|%s#249|不足|%d#249", name, num))
        return
    end
    Player.takeItemByTable(actor, cost, "归灵仪式剧情")
    local x = getbaseinfo(actor, ConstCfg.gbase.x)
    local y = getbaseinfo(actor, ConstCfg.gbase.y)
    local monName = table.random(mons)
    genmon("妖月遗址", x, y, monName, 1, 1, 255)
    local num = getplaydef(actor, VarCfg["U_归灵仪式召唤_数量"])
    if num < 10 then
        setplaydef(actor, VarCfg["U_归灵仪式召唤_数量"],num+1)
    end
    Player.sendmsgEx(actor, string.format("你成功召唤了|%s#249", monName))
    Message.sendmsg(actor, ssrNetMsgCfg.GuiLingYiShi_Close, 0, 0, 0, {})
end

--同步消息
-- function GuiLingYiShi.SyncResponse(actor, logindatas)
--     local data = {}
--     local _login_data = {ssrNetMsgCfg.GuiLingYiShi_SyncResponse, 0, 0, 0, data}
--     if logindatas then
--         table.insert(logindatas, _login_data)
--     else
--         Message.sendmsg(actor, ssrNetMsgCfg.GuiLingYiShi_SyncResponse, 0, 0, 0, data)
--     end
-- end
-- --登录触发
-- local function _onLoginEnd(actor, logindatas)
--     GuiLingYiShi.SyncResponse(actor, logindatas)
-- end
-- --事件派发
-- GameEvent.add(EventCfg.onLoginEnd, _onLoginEnd, GuiLingYiShi)

local function _onKillMon(actor, monobj, monName)
    local name = monName
    if name == "妖月九尾狐王" then
        setflagstatus(actor,VarCfg["F_妖月九尾狐王击杀_完成"],1)
    end
end
GameEvent.add(EventCfg.onKillMon, _onKillMon, GuiLingYiShi)
--注册网络消息
Message.RegisterNetMsg(ssrNetMsgCfg.GuiLingYiShi, GuiLingYiShi)
return GuiLingYiShi

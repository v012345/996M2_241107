local XianWangBaoZang = {}
XianWangBaoZang.ID = "仙王宝藏"
local npcID = 443
local mapID = "xianwang"
--local config = include("QuestDiary/cfgcsv/cfg_XianWangBaoZang.lua") --配置
local config = {
    { monName = "◆仙之守护者·雷◆", num = 1, x = 58, y = 53, range = 1, color = 251 },
    { monName = "◆仙之守护者·火◆", num = 1, x = 166, y = 53, range = 1, color = 251 },
    { monName = "◆仙之守护者·风◆", num = 1, x = 166, y = 136, range = 1, color = 251 },
    { monName = "◆仙之守护者·电◆", num = 1, x = 56, y = 137, range = 1, color = 251 },
    { monName = "仙王奴仆", num = 70, x = 109, y = 97, range = 100, color = 227 },
    { monName = "仙王侍从", num = 70, x = 109, y = 97, range = 100, color = 227 },
    { monName = "仙王侍女", num = 70, x = 109, y = 97, range = 100, color = 227 },
    { monName = "仙王力士", num = 70, x = 109, y = 97, range = 100, color = 227 },
}


local cost = { {} }
local give = { {} }
--接收请求
function XianWangBaoZang.Request(actor)
    FMapEx(actor,mapID)
    --local name, num = Player.checkItemNumByTable(actor, cost)
    --if name then
    --Player.sendmsgEx(actor, string.format("你的|%s#249|不足|%d#249", name, num))
    --return
    --end
end

function XianWangBaoZang.EnterMap(actor)
    FMapEx(actor,mapID)
end

--同步消息
-- function XianWangBaoZang.SyncResponse(actor, logindatas)
--     local data = {}
--     local _login_data = {ssrNetMsgCfg.XianWangBaoZang_SyncResponse, 0, 0, 0, data}
--     if logindatas then
--         table.insert(logindatas, _login_data)
--     else
--         Message.sendmsg(actor, ssrNetMsgCfg.XianWangBaoZang_SyncResponse, 0, 0, 0, data)
--     end
-- end
-- --登录触发
-- local function _onLoginEnd(actor, logindatas)
--     XianWangBaoZang.SyncResponse(actor, logindatas)
-- end
-- --事件派发
-- GameEvent.add(EventCfg.onLoginEnd, _onLoginEnd, XianWangBaoZang)
--活动开始
local function _onXianWangBaoZangStart()
    FsendHuoDongGongGao("仙王宝藏活动已开启，可从活动大厅进入活动。")
    setsysvar(VarCfg["G_仙王宝藏杀怪"], 0)
    for _, value in ipairs(config) do
        genmon(mapID, value.x, value.y, value.monName, value.range, value.num, value.color)
    end
end
GameEvent.add(EventCfg.onXianWangBaoZangStart, _onXianWangBaoZangStart, XianWangBaoZang)

local function _onKillMon(actor, monobj, monName)
    if FCheckMap(actor, mapID) then
        if string.find(monName,"仙之守护者") then
            local num = getsysvar(VarCfg["G_仙王宝藏杀怪"])
            setsysvar(VarCfg["G_仙王宝藏杀怪"], num + 1)
            if (num + 1) >= 4 then
                FsendHuoDongGongGao("仙王宝藏内的[仙之守护者]已全部击杀，在地图中间召唤出[◆◆◆遗忘之王·仙帝◆◆◆]")
                setsysvar(VarCfg["G_仙王宝藏杀怪"], 0)
                genmon(mapID, 109, 97, "◆◆◆遗忘之王·仙帝◆◆◆", 1, 1, 251)
            end
        end
    end
end
GameEvent.add(EventCfg.onKillMon, _onKillMon, XianWangBaoZang)

--注册网络消息
Message.RegisterNetMsg(ssrNetMsgCfg.XianWangBaoZang, XianWangBaoZang)
return XianWangBaoZang

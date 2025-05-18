local ZuLongZhiDi = {}
ZuLongZhiDi.ID = "祖龙之地"
local npcID = 333
--local config = include("QuestDiary/cfgcsv/cfg_ZuLongZhiDi.lua") --配置
local cost = { { "金币", 30000000 } }
local give = { {} }
--接收请求
function ZuLongZhiDi.Request1(actor)
    if not FCheckNPCRange(actor, npcID, 15) then
        Player.sendmsgEx(actor, "距离PNC太远!#249")
        return
    end
    if getflagstatus(actor, VarCfg["F_剧情_祖龙之地_是否开启"]) == 1 then
        Player.sendmsgEx(actor, "你已经开启了此地图,无需重复开启!")
        return
    end
    local count = getplaydef(actor, VarCfg["U_剧情_祖龙之地_杀怪数量"])
    if count < 10 then
        Player.sendmsgEx(actor, "开启地图失败,请先完成10个杀怪任务!#249")
        return
    end
    local name, num = Player.checkItemNumByTable(actor, cost)
    if name then
        Player.sendmsgEx(actor, string.format("你的|%s#249|不足|%d#249", name, num))
        return
    end
    Player.takeItemByTable(actor, cost, "祖龙之地剧情")
    setflagstatus(actor, VarCfg["F_剧情_祖龙之地_是否开启"], 1)
    Player.sendmsgEx(actor, "地图开启成功")
    ZuLongZhiDi.SyncResponse(actor)
end

function ZuLongZhiDi.Request2(actor)
    if not FCheckNPCRange(actor, npcID, 15) then
        Player.sendmsgEx(actor, "距离PNC太远!#249")
        return
    end
    if getflagstatus(actor, VarCfg["F_剧情_祖龙之地_是否开启"]) == 1 then
        map(actor, "祖龙之地")
    else
        Player.sendmsgEx(actor, "请先开启地图!#249")
    end
end

--同步消息
function ZuLongZhiDi.SyncResponse(actor)
    local data = {}
    local count = getplaydef(actor, VarCfg["U_剧情_祖龙之地_杀怪数量"])
    local flag = getflagstatus(actor, VarCfg["F_剧情_祖龙之地_是否开启"])
    Message.sendmsg(actor, ssrNetMsgCfg.ZuLongZhiDi_SyncResponse, count, flag, 0, data)
end

-- --登录触发
-- local function _onLoginEnd(actor, logindatas)
--     ZuLongZhiDi.SyncResponse(actor, logindatas)
-- end
-- --事件派发
-- GameEvent.add(EventCfg.onLoginEnd, _onLoginEnd, ZuLongZhiDi)
--注册网络消息
--杀怪触发
local function _onKillMon(actor, monobj, monName)
    if checkitemw(actor, "太虚古龙领域[完全体]", 1) then
        if randomex(2) then
            local mapId = getbaseinfo(monobj, ConstCfg.gbase.mapid)
            if mapId == "龙之禁域" then
                if monName ~= "龙之守护" then
                    local x = getbaseinfo(monobj, ConstCfg.gbase.x)
                    local y = getbaseinfo(monobj, ConstCfg.gbase.y)
                    genmon(mapId, x, y, "龙之守护", 0, 1, 249)
                    Player.sendmsgEx(actor, string.format("你杀死了|%s#249|,龙之守护出现了!", monName))
                end
            end
        end
    end
    if monName == "龙之守护" then
        local count = getplaydef(actor, VarCfg["U_剧情_祖龙之地_杀怪数量"])
        if count < 10 then
            setplaydef(actor, VarCfg["U_剧情_祖龙之地_杀怪数量"], count + 1)
        end
    end
end
GameEvent.add(EventCfg.onKillMon, _onKillMon, ZuLongZhiDi)
Message.RegisterNetMsg(ssrNetMsgCfg.ZuLongZhiDi, ZuLongZhiDi)
return ZuLongZhiDi

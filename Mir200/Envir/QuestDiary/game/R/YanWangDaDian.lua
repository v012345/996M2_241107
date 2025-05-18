local YanWangDaDian = {}
YanWangDaDian.ID = "阎王大殿"
local npcID = 451
--local config = include("QuestDiary/cfgcsv/cfg_YanWangDaDian.lua") --配置
local cost = { { "元宝", 300000 }, { "幻灵水晶", 188 } }
local give = { {} }
--接收请求
function YanWangDaDian.Request1(actor)
    if not FCheckNPCRange(actor, npcID, 15) then
        Player.sendmsgEx(actor, "距离PNC太远!#249")
        return
    end
    if getflagstatus(actor, VarCfg["F_剧情_阎王大殿是否开启"]) == 1 then
        Player.sendmsgEx(actor, "你已经开启过了!#249")
        return
    end
    local name, num = Player.checkItemNumByTable(actor, cost)
        if name then
            Player.sendmsgEx(actor, string.format("你的|%s#249|不足|%d#249", name, num))
        return
    end
    Player.takeItemByTable(actor, cost, "阎王大殿")
    -- setflagstatus(actor, VarCfg["F_剧情_阎王大殿是否开启"], 1)
    FSetTaskRedPoint(actor, VarCfg["F_剧情_阎王大殿是否开启"], 35)
    Player.sendmsgEx(actor,"成功开启阎王大殿地图")
    YanWangDaDian.SyncResponse(actor)
end

function YanWangDaDian.Request2(actor)
    if not FCheckNPCRange(actor, npcID, 15) then
        Player.sendmsgEx(actor, "距离PNC太远!#249")
        return
    end
    if getflagstatus(actor, VarCfg["F_剧情_阎王大殿是否开启"]) == 0 then
        Player.sendmsgEx(actor, "没有开启地图!#249")
        return
    else
        map(actor, "阎王大殿")
    end
end

--同步消息
function YanWangDaDian.SyncResponse(actor, logindatas)
    local data = {}
    local flag = getflagstatus(actor, VarCfg["F_剧情_阎王大殿是否开启"])
    local _login_data = { ssrNetMsgCfg.YanWangDaDian_SyncResponse, flag, 0, 0, data }
    if logindatas then
        table.insert(logindatas, _login_data)
    else
        Message.sendmsg(actor, ssrNetMsgCfg.YanWangDaDian_SyncResponse, flag, 0, 0, data)
    end
end

--登录触发
local function _onLoginEnd(actor, logindatas)
    YanWangDaDian.SyncResponse(actor, logindatas)
end
--事件派发
GameEvent.add(EventCfg.onLoginEnd, _onLoginEnd, YanWangDaDian)

local function _onKillMon(actor, monobj)
    if FCheckMap(actor, "无常殿") then
        local count = getplaydef(actor, VarCfg["U_剧情_阎王大殿_计数"])
        if count < 5000 then
            setplaydef(actor, VarCfg["U_剧情_阎王大殿_计数"], count + 1)
            if (count + 1) >= 5000 then
                if getflagstatus(actor, VarCfg["F_剧情_阎王大殿是否开启"]) == 0 then
                    messagebox(actor, "你在无常殿吓退了小鬼,成功开启阎王大殿地图,在NPC处进入!")
                end
                -- setflagstatus(actor, VarCfg["F_剧情_阎王大殿是否开启"], 1)
                FSetTaskRedPoint(actor, VarCfg["F_剧情_阎王大殿是否开启"], 35)
                YanWangDaDian.SyncResponse(actor)
            end
        end
    end
end
GameEvent.add(EventCfg.onKillMon, _onKillMon, YanWangDaDian)

--注册网络消息
Message.RegisterNetMsg(ssrNetMsgCfg.YanWangDaDian, YanWangDaDian)
return YanWangDaDian

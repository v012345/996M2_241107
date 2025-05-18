local LiuDaoMoYu = {}
local cost = { { "魔域钥匙", 1 }, { "异界神石", 388 }, { "金币", 20000000 } }

function LiuDaoMoYu.Request1(actor)
    local mapbool = getflagstatus(actor, VarCfg["F_六道魔域_激活标识"])
    if mapbool == 1 then return end
    local name, num = Player.checkItemNumByTable(actor, cost)
    if name then
        Player.sendmsgEx(actor, string.format("提示#251|:#255|你的|%s#249|不足|%d#249|...", name, num))
        return
    end
    Player.takeItemByTable(actor, cost, "开通地图费用")
    FSetTaskRedPoint(actor, VarCfg["F_六道魔域_激活标识"], 56)
    setflagstatus(actor, VarCfg["F_六道魔域_激活标识"], 1)
    Player.sendmsgEx(actor, "提示#251|:#255|恭喜你开通|六道魔域#249|成功...")
    LiuDaoMoYu.SyncResponse(actor)
end

function LiuDaoMoYu.Request2(actor)
    local mapbool = getflagstatus(actor, VarCfg["F_六道魔域_激活标识"])
    if mapbool == 0 then
        Player.sendmsgEx(actor, "提示#251|:#255|对不起,你|未开通#249|六道魔域,进入失败...")
        return
    else
        mapmove(actor, "六道魔域", 57, 65, 1)
    end
end

--注册网络消息
function LiuDaoMoYu.SyncResponse(actor, logindatas)
    local mapbool = getflagstatus(actor, VarCfg["F_六道魔域_激活标识"])
    local _login_data = { ssrNetMsgCfg.LiuDaoMoYu_SyncResponse, mapbool, 0, 0, nil }
    if logindatas then
        table.insert(logindatas, _login_data)
    else
        Message.sendmsg(actor, ssrNetMsgCfg.LiuDaoMoYu_SyncResponse, mapbool, 0, 0, nil)
    end
end

Message.RegisterNetMsg(ssrNetMsgCfg.LiuDaoMoYu, LiuDaoMoYu)
local function _onKillMon(actor, monobj, monName)
    if monName == "大筒木羽衣∷六道仙人∷" then
        local count = getplaydef(actor, VarCfg["B_六道轮回尘_保底"])
        if count >= 50 then
            additemtodroplist(actor, monobj, "六道轮回尘")
        end
        setplaydef(actor, VarCfg["B_六道轮回尘_保底"], count + 1)
    end
end
GameEvent.add(EventCfg.onKillMon, _onKillMon, LiuDaoMoYu)
--登录触发
local function _onLoginEnd(actor, logindatas)
    LiuDaoMoYu.SyncResponse(actor, logindatas)
end
GameEvent.add(EventCfg.onLoginEnd, _onLoginEnd, LiuDaoMoYu)

return LiuDaoMoYu

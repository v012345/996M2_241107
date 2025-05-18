local JieJiuShaoNv = {}
JieJiuShaoNv.ID = "解救少女"
local npcID = 516
--local config = include("QuestDiary/cfgcsv/cfg_JieJiuShaoNv.lua") --配置
local cost = { {} }
local give = { { "元宝", 100000 } }
local mapId = "哥布林洞窟"
local shaoNvName = "被掳掠的少女"
--验证是否有宝宝
local function CheckBaby(actor)
    local result = false
    local ncount = getbaseinfo(actor, 38)
    for i = 0, ncount - 1 do
        local mon = getslavebyindex(actor, i)
        if mon and isnotnull(mon) then
            local mobName = getbaseinfo(mon, ConstCfg.gbase.name)
            if mobName == shaoNvName then
                result = mon
                break
            end
        end
    end
    return result
end

--获取宝宝地图坐标
local function getBabyPosition(actor)
    local mapid, x, y = nil, nil, nil
    local ncount = getbaseinfo(actor, 38)
    for i = 0, ncount - 1 do
        local mon = getslavebyindex(actor, i)
        if mon and isnotnull(mon) then
            local mobName = getbaseinfo(mon, ConstCfg.gbase.name)
            if mobName == shaoNvName then
                mapid, x, y = getbaseinfo(mon, ConstCfg.gbase.mapid), getbaseinfo(mon, ConstCfg.gbase.x),
                    getbaseinfo(mon, ConstCfg.gbase.y)
                break
            end
        end
    end
    return mapid, x, y
end

--接收请求
function JieJiuShaoNv.Request1(actor)
    if not FCheckNPCRange(actor, npcID, 15) then
        Player.sendmsgEx(actor, "距离PNC太远!#249")
        return
    end
    local count = getplaydef(actor, VarCfg["U_解救少女_次数"])
    if count >= 3 then
        Player.sendmsgEx(actor, "你已经完成了该任务!#249")
        return
    end
    local monobj = CheckBaby(actor)
    if monobj then
        if not FCheckRange(monobj, 18, 18, 6) then
            Player.sendmsgEx(actor, "距离太远了!#249")
            return
        end
        killmonbyobj(actor, monobj, false, false, false)
        setplaydef(actor, VarCfg["U_解救少女_次数"], count + 1)
        if count + 1 == 1 then
            local taskPanelID = getplaydef(actor, VarCfg["U_主线任务面板进度"])
            if taskPanelID == 48 then
                FCheckTaskRedPoint(actor)
            end
        end
        Player.sendmsgEx(actor, "感谢你的帮助，奖励已经发送到邮件!#249")
        newdeletetask(actor, 202)
        local userid = getbaseinfo(actor, ConstCfg.gbase.id)
        Player.giveMailByTable(userid, 1, "解救少女奖励", "请领取你的解救少女奖励!", give)
        JieJiuShaoNv.SyncResponse(actor)
    else
        Player.sendmsgEx(actor, "你没有把人带来呀!#249")
    end
    -- map(actor, mapId)
end

function JieJiuShaoNv.Request2(actor)
    if checktitle(actor,"少女拯救者") then
        Player.sendmsgEx(actor,"你已经领取了该称号!#249")
        return
    end
    local count = getplaydef(actor, VarCfg["U_解救少女_次数"])
    if count < 3 then
        Player.sendmsgEx(actor, "完成3次解救才可以领取称号奖励!")
        return
    end
    confertitle(actor, "少女拯救者")
    Player.sendmsgEx(actor, "获得称号:少女拯救者")
end

--同步消息
function JieJiuShaoNv.SyncResponse(actor, logindatas)
    local data = {}
    local count = getplaydef(actor, VarCfg["U_解救少女_次数"])
    local _login_data = { ssrNetMsgCfg.JieJiuShaoNv_SyncResponse, count, 0, 0, data }
    if logindatas then
        table.insert(logindatas, _login_data)
    else
        Message.sendmsg(actor, ssrNetMsgCfg.JieJiuShaoNv_SyncResponse, count, 0, 0, data)
    end
end

--登录触发
local function _onLoginEnd(actor, logindatas)
    JieJiuShaoNv.SyncResponse(actor, logindatas)
end

--事件派发
GameEvent.add(EventCfg.onLoginEnd, _onLoginEnd, JieJiuShaoNv)
--杀怪触发
local function _onKillMon(actor, monobj)
    if randomex(1 ,288) then
        local count = getplaydef(actor, VarCfg["U_解救少女_次数"])
        if count >= 3 then
            return
        end
        local myMapID = getbaseinfo(actor, ConstCfg.gbase.mapid)
        if mapId == myMapID then
            if CheckBaby(actor) then
                return
            end
            recallmob(actor, shaoNvName, 7, 200, 0)
            darttime(actor, 1200, 0)
            newpicktask(actor, 202)
        end
    end
end
GameEvent.add(EventCfg.onKillMon, _onKillMon, JieJiuShaoNv)

--任务被点击触发
local function _onClickTaskJieJiuShaoNv(actor, taskID)
    local mapid, x, y = getBabyPosition(actor)
    if mapid and x and y then
        if not FCheckMap(actor, mapid) then
            Player.sendmsgEx(actor, string.format("%s#249|在地图|%s(%d,%d)#249", shaoNvName, mapid, x, y))
        else
            FMapMoveEx(actor, mapid, x, y)
        end
    end
end
GameEvent.add(EventCfg.onClickTaskJieJiuShaoNv, _onClickTaskJieJiuShaoNv, JieJiuShaoNv)

-- --丢失镖车触发
-- local function _onLoserCar(actor, car)
--     Player.sendmsgEx(actor, "解救少女任务失败!")
--     newdeletetask(actor, 202)
-- end
-- GameEvent.add(EventCfg.onLoserCar, _onLoserCar, JieJiuShaoNv)
-- --镖车死亡触发
-- -- local function _onCarDie(actor, car)
-- --     Player.sendmsgEx(actor, "解救少女任务失败!")
-- --     newdeletetask(actor, 202)
-- -- end
-- -- GameEvent.add(EventCfg.onCarDie, _onCarDie, JieJiuShaoNv)
-- --镖车被攻击触发
-- local function _onSlaveDamage(actor, hiter, car)
--     Player.sendmsgEx(actor, "[被掳掠的少女]正在被怪物攻击,请立即前往援救!")
-- end
-- GameEvent.add(EventCfg.onSlaveDamage, _onSlaveDamage, JieJiuShaoNv)

--宝宝死亡触发
local function _onSelfKillSlave(actor, mon)
    local monName = getbaseinfo(mon, ConstCfg.gbase.name)
    if monName == shaoNvName then
        Player.sendmsgEx(actor, "解救少女任务失败!#249")
        newdeletetask(actor, 202)
    end
end
GameEvent.add(EventCfg.onSelfKillSlave, _onSelfKillSlave, JieJiuShaoNv)

local function _onClicknpc(actor, npcid, npcobj)
    if npcid == 513 then
        local shape = getplaydef(actor, VarCfg["U_时装外观记录"])
        if shape ~= 40090 then
            Player.sendmsgEx(actor,"你没有幻化成雪舞,无法进入#249")
            return
        end
        map(actor, mapId)
    end
end
GameEvent.add(EventCfg.onClicknpc, _onClicknpc, JieJiuShaoNv)

--注册网络消息
Message.RegisterNetMsg(ssrNetMsgCfg.JieJiuShaoNv, JieJiuShaoNv)
return JieJiuShaoNv

local XianWangXuanShang = {}
XianWangXuanShang.ID = "仙王悬赏"
local npcID = 3473
local mapID = "xianwang"
local config = include("QuestDiary/cfgcsv/cfg_XianWangXuanShang.lua") --配置
local MmonCfg = {}
for _, value in ipairs(config) do
    MmonCfg[value.monName] = value
end
-- dump(MmonCfg)
local cost = { {} }
local give = { {} }
local function getJvar(actor, var)
    local result = 0
    --如果是第一个任务
    if var == "J25" and getplaydef(actor, var) == 0 then
        result = 1
    else
        result = getplaydef(actor, var)
    end
    return result
end

--获取数据
local function GetData(actor)
    local data = {}
    for _, value in ipairs(config) do
        local numVar = getplaydef(actor, value.numVar) or 0
        local stateVar = getJvar(actor, value.stateVar)
        local tmp = { num = numVar, state = stateVar, max = value.max }
        table.insert(data, tmp)
    end
    return data
end
--接收请求
function XianWangXuanShang.Request(actor, index)
    local cfg = config[index]
    if not cfg then
        Player.sendmsgEx(actor, "参数错误1！#249")
        return
    end
    local stat = getJvar(actor, cfg.stateVar)

    if stat == 0 then
        local cost = cfg.cost
        if not cost then
            Player.sendmsgEx(actor, "参数错误2！#249")
            return
        end
        local name, num = Player.checkItemNumByTable(actor, cost)
        if name then
            Player.sendmsgEx(actor, string.format("领取任务失败，你的|%s#249|不足|%d#249", name, num))
            return
        end
        Player.takeItemByTable(actor, cost, "领取仙王悬赏")
        setplaydef(actor, cfg.stateVar, 1)
        XianWangXuanShang.SyncResponse(actor)
        Player.sendmsgEx(actor, string.format("领取击杀|%s#249|任务成功", cfg.monName))
    elseif stat == 2 then
        local mailTitle = "仙王悬赏任务完成"
        local mailContent = "恭喜你完成了仙王悬赏任务，请领取您的奖励"
        local usetId = getbaseinfo(actor, ConstCfg.gbase.id)
        Player.giveMailByTable(usetId,1, mailTitle, mailContent,cfg.give,1,true)
        setplaydef(actor, cfg.stateVar, 3)
        Player.sendmsgEx(actor, "奖励已发送，请到邮箱查看!")
        XianWangXuanShang.SyncResponse(actor)
    elseif stat == 3 then
        Player.sendmsgEx(actor, "你已经领取过了!")
    end
end

function XianWangXuanShang.OpenUI(actor)
    local data = GetData(actor)
    Message.sendmsg(actor, ssrNetMsgCfg.XianWangXuanShang_OpenUI, 0, 0, 0, data)
end

--同步消息
function XianWangXuanShang.SyncResponse(actor)
    local data = GetData(actor)
    Message.sendmsg(actor, ssrNetMsgCfg.XianWangXuanShang_SyncResponse, 0, 0, 0, data)
end

-- --登录触发
-- local function _onLoginEnd(actor, logindatas)
--     XianWangXuanShang.SyncResponse(actor, logindatas)
-- end
-- --事件派发
-- GameEvent.add(EventCfg.onLoginEnd, _onLoginEnd, XianWangXuanShang)

local function _onKillMon(actor, monobj, monName)
    if FCheckMap(actor, mapID) then
        local renYiNum = getplaydef(actor, "J24") --任意怪物
        if (renYiNum + 1) < 51 then
            setplaydef(actor, "J24", renYiNum + 1)
        elseif getJvar(actor, "J25") == 1 then
            setplaydef(actor, "J25", 2)
        end
        local cfg = MmonCfg[monName]
        if cfg then
            if getplaydef(actor, cfg.stateVar) == 1 then
                local num = getplaydef(actor, cfg.numVar) --指定怪物
                setplaydef(actor, cfg.numVar, num + 1)    --计数
                if (num + 1) >= cfg.max then
                    setplaydef(actor, cfg.stateVar, 2)
                end
            end
        end
    end
end
GameEvent.add(EventCfg.onKillMon, _onKillMon, XianWangXuanShang)

--注册网络消息
Message.RegisterNetMsg(ssrNetMsgCfg.XianWangXuanShang, XianWangXuanShang)
return XianWangXuanShang

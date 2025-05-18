local YueGuangYuHui = {}
YueGuangYuHui.ID = "月光余晖"
local npcID = 515
local config = include("QuestDiary/cfgcsv/cfg_YueGuangYuHui.lua") --配置
--是否全部提交
local function IsAllSubmit(actor)
    local result = true
    for index, value in ipairs(config) do
        local count = getplaydef(actor, value.var)
        if count < value.max then
            result = false
            break
        end
    end
    return result
end 
--接收请求
function YueGuangYuHui.Request(actor, index)
    if not FCheckNPCRange(actor, npcID, 15) then
        Player.sendmsgEx(actor, "距离PNC太远!#249")
        return
    end
    local cfg = config[index]
    if not cfg then
        Player.sendmsgEx(actor, "参数错误#249")
        return
    end

    local count = getplaydef(actor, cfg.var)
    if count >= cfg.max then
        Player.sendmsgEx(actor, string.format("最多只能提交%d次!#249", cfg.max))
        if not checktitle(actor,"月光余晖") then
            confertitle(actor, "月光余晖")
            GameEvent.push(EventCfg.onGetTaskTitle, actor, "月光余晖") --任务触发
        end
        return
    end
    local cost = cfg.cost
    local name, num = Player.checkItemNumByTable(actor, cost)
    if name then
        Player.sendmsgEx(actor, string.format("你的|%s#249|不足|%d#249", name, num))
        return
    end
    Player.takeItemByTable(actor, cost, "月光余晖")
    setplaydef(actor, cfg.var, count + 1)
    Player.setAttList(actor, "属性附加")
    Player.sendmsgEx(actor, "提交成功!")
    if not checktitle(actor,"月光余晖") then
        if IsAllSubmit(actor) then
            confertitle(actor, "月光余晖")
            messagebox(actor, "恭喜你已全部提交,获得称号:[月光余晖]")
        end
    end
    YueGuangYuHui.SyncResponse(actor)
end

--同步消息
function YueGuangYuHui.SyncResponse(actor, logindatas)
    local data = {}
    for index, value in ipairs(config) do
        data[index] = getplaydef(actor, value.var)
    end
    local _login_data = { ssrNetMsgCfg.YueGuangYuHui_SyncResponse, 0, 0, 0, data }
    if logindatas then
        table.insert(logindatas, _login_data)
    else
        Message.sendmsg(actor, ssrNetMsgCfg.YueGuangYuHui_SyncResponse, 0, 0, 0, data)
    end
end

--登录触发
local function _onLoginEnd(actor, logindatas)
    YueGuangYuHui.SyncResponse(actor, logindatas)
end
--事件派发
GameEvent.add(EventCfg.onLoginEnd, _onLoginEnd, YueGuangYuHui)

local function _onCalcAttr(actor, attrs)
    local shuxing = {}
    for _, value in ipairs(config) do
        local count = getplaydef(actor, value.var)
        if count > 0 then
            shuxing[value.attr] = value.addNum * count
        end
    end
    calcAtts(attrs, shuxing, "月光余晖")
end
--属性
GameEvent.add(EventCfg.onCalcAttr, _onCalcAttr, YueGuangYuHui)

--注册网络消息
Message.RegisterNetMsg(ssrNetMsgCfg.YueGuangYuHui, YueGuangYuHui)
return YueGuangYuHui

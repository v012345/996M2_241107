local RongXueZhiChi = {}
RongXueZhiChi.ID = "溶血之池"
local npcID = 824
local config = {
    {
        ["cost"] = { { "血色残刃", 1 } },
        ["attr"] = 200,
        ["value"] = 50,
        ["var"] = VarCfg["B_溶血之池_次数1"],
        ["max"] = 100
    },
    {
        ["cost"] = { { "破天印记", 1 } },
        ["attr"] = 25,
        ["value"] = 1,
        ["var"] = VarCfg["B_溶血之池_次数2"],
        ["max"] = 5
    }
}
--接收请求
function RongXueZhiChi.Request(actor, index)
    local cfg = config[index]
    if not cfg then
        Player.sendmsgEx(actor, "参数错误!#249")
        return
    end
    local cost = cfg.cost
    local max = cfg.max
    local name = cfg["cost"][1][1]
    local count = getplaydef(actor, cfg.var)
    if count >= max then
        Player.sendmsgEx(actor, string.format("%s#249|最对只能提交|%d#249|次!", name, count))
        return
    end
    local name, num = Player.checkItemNumByTable(actor, cost)
    if name then
        Player.sendmsgEx(actor, string.format("提交失败,你的|%s#249|不足|%d#249", name, num))
        return
    end
    setplaydef(actor, cfg.var, count + 1)
    Player.takeItemByTable(actor, cost, "溶血之池提交")
    Player.setAttList(actor, "属性附加")
    Player.sendmsgEx(actor,"提交成功!")
    RongXueZhiChi.SyncResponse(actor)
end

function RongXueZhiChi.EnterMap(actor)
    for _, value in ipairs(config) do
        local name = value["cost"][1][1]
        local max = value.max
        local count = getplaydef(actor, value.var)
        if count < max then
            Player.sendmsgEx(actor, string.format("进入失败,你的|%s#249|提交次数不足|%d#249", name, max))
            return
        end
    end
    mapmove(actor, "溶血之池", 18, 100, 1)
end

local function _onCalcAttr(actor, attrs)
    local shuxing = {}
    for _, value in ipairs(config) do
        local count = getplaydef(actor, value.var)
        if count > 0 then
            shuxing[value["attr"]] = value.value * count
        end
    end
    calcAtts(attrs, shuxing, "溶血之池")
end
GameEvent.add(EventCfg.onCalcAttr, _onCalcAttr, RongXueZhiChi)
--同步消息
function RongXueZhiChi.SyncResponse(actor, logindatas)
    local data = {}
    local count1 = getplaydef(actor, VarCfg["B_溶血之池_次数1"])
    local count2 = getplaydef(actor, VarCfg["B_溶血之池_次数2"])
    local _login_data = { ssrNetMsgCfg.RongXueZhiChi_SyncResponse, count1, count2, 0, data }
    if logindatas then
        table.insert(logindatas, _login_data)
    else
        Message.sendmsg(actor, ssrNetMsgCfg.RongXueZhiChi_SyncResponse, count1, count2, 0, data)
    end
end

--登录触发
local function _onLoginEnd(actor, logindatas)
    RongXueZhiChi.SyncResponse(actor, logindatas)
end
--事件派发
GameEvent.add(EventCfg.onLoginEnd, _onLoginEnd, RongXueZhiChi)
--注册网络消息
Message.RegisterNetMsg(ssrNetMsgCfg.RongXueZhiChi, RongXueZhiChi)
return RongXueZhiChi

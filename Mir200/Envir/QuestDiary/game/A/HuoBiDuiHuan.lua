local HuoBiDuiHuan = {}
local Cost = {{"金币", 1000000},{"灵符", 10},{"灵符", 100},{"灵符", 1000}}
local MoneyNum = {10000,10000,100000,1000000}

--接收请求
function HuoBiDuiHuan.Request(actor,var)
    if var > 4 then return end

    local DuiHuanNum = getplaydef(actor, VarCfg["J_每日货币兑换次数"])
    local MaxUL = 20
    if getflagstatus(actor, VarCfg["F_是否首充"]) == 1 then
        MaxUL = MaxUL + 20
    end

    if getflagstatus(actor, VarCfg["F_解绑状态"]) == 1 then
        MaxUL = MaxUL + 20
    end
    if checktitle(actor, "打工皇帝") then
        MaxUL = MaxUL + 40
    end

    if var ==  1 then
        if DuiHuanNum >= MaxUL then
            Player.sendmsgEx(actor, "提示#251|:#255|你今天的|金币兑换元宝#249|,次数已经达到上线了...")
            return
        end
    end

    local name, num = Player.checkItemNumByTable(actor, {Cost[var]})
    if name then
        Player.sendmsgEx(actor, string.format("你的|%s#249|不足|%d#249|枚...", name, num))
        return
    end

    Player.takeItemByTable(actor, {Cost[var]}, "货币兑换扣除")

    changemoney(actor, 2, "+", MoneyNum[var], "货币兑换获得", true)

    if var ==  1 then
        setplaydef(actor, VarCfg["J_每日货币兑换次数"], DuiHuanNum + 1)
    end
    HuoBiDuiHuan.SyncResponse(actor)
end

--同步消息
function HuoBiDuiHuan.SyncResponse(actor, logindatas)

    local DuiHuanNum = getplaydef(actor, VarCfg["J_每日货币兑换次数"])
    local MaxUL = 20
    if getflagstatus(actor, VarCfg["F_是否首充"]) == 1 then
        MaxUL = MaxUL + 20
    end
    if getflagstatus(actor, VarCfg["F_解绑状态"]) == 1 then
        MaxUL = MaxUL + 20
    end
    if checktitle(actor, "打工皇帝") then
        MaxUL = MaxUL + 40
    end
    local data = {DuiHuanNum, MaxUL}
    local _login_data = {ssrNetMsgCfg.HuoBiDuiHuan_SyncResponse, 0, 0, 0, data}
    if type(logindatas) == "table" then
        table.insert(logindatas, _login_data)
    else
        Message.sendmsg(actor, ssrNetMsgCfg.HuoBiDuiHuan_SyncResponse, 0, 0, 0, data)
    end
end


--登录触发
local function _onLoginEnd(actor, logindatas)
 HuoBiDuiHuan.SyncResponse(actor, logindatas)
end
GameEvent.add(EventCfg.onLoginEnd, _onLoginEnd, HuoBiDuiHuan)



--注册网络消息
Message.RegisterNetMsg(ssrNetMsgCfg.HuoBiDuiHuan, HuoBiDuiHuan)
return HuoBiDuiHuan
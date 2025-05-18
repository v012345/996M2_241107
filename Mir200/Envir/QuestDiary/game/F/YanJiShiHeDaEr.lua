local YanJiShiHeDaEr = {}
local cost = {{"炎魂碎片", 1}}
function YanJiShiHeDaEr.Request(actor,var)
    if var == 1 then
        local Number = getplaydef(actor, VarCfg["U_炎魂碎片_提交数量"])
        if Number >= 10 then
            Player.sendmsgEx(actor, "提示#251|:#255|对不起,你提交|炎魂碎片#249|已经到达|10次#249|了...")
            return
        end
        local name, num = Player.checkItemNumByTable(actor, cost)
        if name then
            Player.sendmsgEx(actor, string.format("提示#251|:#255|你的|%s#249|不足|%d#249|...", name, num))
            return
        end
        Player.takeItemByTable(actor, cost, "炎魂碎片扣除")
        setplaydef(actor, VarCfg["U_炎魂碎片_提交数量"], Number+1)
        Player.sendmsgEx(actor, "提示#251|:#255|恭喜你,提交|炎魂碎片#249|成功...")
        Player.setAttList(actor, "属性附加")
        YanJiShiHeDaEr.SyncResponse(actor)
    end



    if var == 2 then
        local Number = getplaydef(actor, VarCfg["U_炎魂碎片_提交数量"])
        if Number < 10 then
            Player.sendmsgEx(actor, "提示#251|:#255|对不起,你提交|炎魂碎片#249|不足|10次#249|无法领取...")
            return
        end

        local bool = getflagstatus(actor, VarCfg["F_日耀精华_领取状态"] )
        if bool == 1 then
            Player.sendmsgEx(actor, "提示#251|:#255|对不起,你领取|日耀精华#249|了,请勿重复领取...")
            return
        end
        giveitem(actor, "日耀精华", 1, 0, "给予玩家日耀精华")
        setflagstatus(actor, VarCfg["F_日耀精华_领取状态"], 1)
       
    end
end

--叠加属性
local function _onCalcAttr(actor, attrs)
    local shuxing = {}
    local num = getplaydef(actor, VarCfg["U_炎魂碎片_提交数量"])
    if num > 0 then
        shuxing[1]   = 1000 * num  --生命
        shuxing[200] = 388  * num  --切割值
    end
    calcAtts(attrs, shuxing, "焰祭师·赫达尔")
end
GameEvent.add(EventCfg.onCalcAttr, _onCalcAttr, YanJiShiHeDaEr)

--注册网络消息
function YanJiShiHeDaEr.SyncResponse(actor, logindatas)
    local num = getplaydef(actor, VarCfg["U_炎魂碎片_提交数量"])
    local bool = getflagstatus(actor, VarCfg["F_日耀精华_领取状态"] )
    local _login_data = { ssrNetMsgCfg.YanJiShiHeDaEr_SyncResponse, num, bool, 0, nil }
    if logindatas then
        table.insert(logindatas, _login_data)
    else
        Message.sendmsg(actor, ssrNetMsgCfg.YanJiShiHeDaEr_SyncResponse, num, bool, 0, nil)
    end
end
Message.RegisterNetMsg(ssrNetMsgCfg.YanJiShiHeDaEr, YanJiShiHeDaEr)

--登录触发
local function _onLoginEnd(actor, logindatas)
    YanJiShiHeDaEr.SyncResponse(actor, logindatas)
end
GameEvent.add(EventCfg.onLoginEnd, _onLoginEnd, YanJiShiHeDaEr)


return YanJiShiHeDaEr

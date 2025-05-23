local MiShiShengHuo = {}
local cost = {{"迷失灵光", 1}}

function MiShiShengHuo.Request(actor)
    local _Num = getplaydef(actor, VarCfg["U_迷失圣火记录"])
    if _Num == 10  then
        Player.sendmsgEx(actor, "提示#251|:#255|你的|迷失灵光#249|已经提交达到|".. _Num .."#249|次了...")
        return
    end
    local name, num = Player.checkItemNumByTable(actor, cost)
    if name then
        Player.sendmsgEx(actor, string.format("提示#251|:#255|你的|%s#249|不足|%d#249|枚,提交失败...", name, num))
        return
    end
    Player.takeItemByTable(actor, cost, "开通地图费用")
    setplaydef(actor, VarCfg["U_迷失圣火记录"], _Num + 1)
    Player.sendmsgEx(actor, "提示#251|:#255|你的|迷失灵光#249|提交次数|+1#249|...")
    MiShiShengHuo.SyncResponse(actor)
    Player.setAttList(actor, "属性附加")
end

--注册网络消息
function MiShiShengHuo.SyncResponse(actor, logindatas)
    local Num = getplaydef(actor, VarCfg["U_迷失圣火记录"])
    local data ={Num}
    local _login_data = { ssrNetMsgCfg.MiShiShengHuo_SyncResponse, 0, 0, 0, data }
    if logindatas then
        table.insert(logindatas, _login_data)
    else
        Message.sendmsg(actor, ssrNetMsgCfg.MiShiShengHuo_SyncResponse, 0, 0, 0, data)
    end
end
Message.RegisterNetMsg(ssrNetMsgCfg.MiShiShengHuo, MiShiShengHuo)

local function _onCalcAttr(actor, attrs)
    local Num = getplaydef(actor, VarCfg["U_迷失圣火记录"])
    local shuxing = {}
    if Num > 0 and Num <= 10 then
        shuxing[208] = Num
    end
    calcAtts(attrs, shuxing, "迷失灵光")
end
GameEvent.add(EventCfg.onCalcAttr, _onCalcAttr, MiShiShengHuo)

--登录触发
local function _onLoginEnd(actor, logindatas)
    MiShiShengHuo.SyncResponse(actor, logindatas)
end
GameEvent.add(EventCfg.onLoginEnd, _onLoginEnd, MiShiShengHuo)

return MiShiShengHuo

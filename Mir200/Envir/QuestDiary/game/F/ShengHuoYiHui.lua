local ShengHuoYiHui = {}


function ShengHuoYiHui.Request(actor)
    local Num1 = getplaydef(actor, VarCfg["U_悲魂圣火记录"])
    local Num2 = getplaydef(actor, VarCfg["U_图腾圣火记录"])
    local Num3 = getplaydef(actor, VarCfg["U_禁忌圣火记录"])
    local Num4 = getplaydef(actor, VarCfg["U_迷失圣火记录"])
    local bool = getflagstatus(actor, VarCfg["F_圣火遗迹_领取状态"])
    if Num1 ~= 10 then
        Player.sendmsgEx(actor, "提示#251|:#255|你的|悲魂圣火#249|提交次数不足|10次#249|...")
        return
    elseif Num2 ~= 10 then
        Player.sendmsgEx(actor, "提示#251|:#255|你的|图腾圣火#249|提交次数不足|10次#249|...")
        return
    elseif Num3 ~= 10 then
        Player.sendmsgEx(actor, "提示#251|:#255|你的|禁忌圣火#249|提交次数不足|10次#249|...")
        return
    elseif Num4 ~= 10 then
        Player.sendmsgEx(actor, "提示#251|:#255|你的|迷失圣火#249|提交次数不足|10次#249|...")
        return
    end
    if bool == 1 then
        Player.sendmsgEx(actor, "提示#251|:#255|你已领取过|圣火遗灰#249|请勿重复领取...")
        return
    end
    giveitem(actor, "圣火遗灰", 1, 0)
    setflagstatus(actor, VarCfg["F_圣火遗迹_领取状态"], 1)
    Player.sendmsgEx(actor, "提示#251|:#255|恭喜你,领取|圣火遗灰#249|成功...")
    ShengHuoYiHui.SyncResponse(actor)

end

--注册网络消息
function ShengHuoYiHui.SyncResponse(actor, logindatas)
    local Num1 = getplaydef(actor, VarCfg["U_悲魂圣火记录"])
    local Num2 = getplaydef(actor, VarCfg["U_图腾圣火记录"])
    local Num3 = getplaydef(actor, VarCfg["U_禁忌圣火记录"])
    local Num4 = getplaydef(actor, VarCfg["U_迷失圣火记录"])
    local bool = getflagstatus(actor, VarCfg["F_圣火遗迹_领取状态"])
    local data ={Num1, Num2, Num3, Num4, bool}

    local _login_data = { ssrNetMsgCfg.ShengHuoYiHui_SyncResponse, 0, 0, 0, data }
    if logindatas then
        table.insert(logindatas, _login_data)
    else
        Message.sendmsg(actor, ssrNetMsgCfg.ShengHuoYiHui_SyncResponse, 0, 0, 0, data)
    end
end
Message.RegisterNetMsg(ssrNetMsgCfg.ShengHuoYiHui, ShengHuoYiHui)

--登录触发
local function _onLoginEnd(actor, logindatas)
    ShengHuoYiHui.SyncResponse(actor, logindatas)
end
GameEvent.add(EventCfg.onLoginEnd, _onLoginEnd, ShengHuoYiHui)

return ShengHuoYiHui

local GuDiXiaYiJi = {}
local cost = {{"混沌本源", 38}}

function GuDiXiaYiJi.Request(actor, var)
    if var == 1 then
        local bool = getflagstatus(actor, VarCfg["F_古地下遗迹_开启状态"])
        if bool == 1 then
            Player.sendmsgEx(actor, "提示#251|:#255|对不起,你已开启|古地下遗迹#249|地图了,请勿重复提交...")
            return
        end
        local DianFengLevel = getplaydef(actor,VarCfg["U_巅峰等级2"])
        if DianFengLevel < 5 then
            Player.sendmsgEx(actor, "提示#251|:#255|对不起,你未达到|巅峰出尘5#249|,开启失败...")
            return
        end
        --扣除混沌本源
        local name, num = Player.checkItemNumByTable(actor, cost)
        if name then
            Player.sendmsgEx(actor, string.format("提示#251|:#255|你的|%s#249|不足|%d#249|枚,开启失败...", name, num))
            return
        end
        Player.takeItemByTable(actor, cost, "古地下遗迹开启")
        setflagstatus(actor, VarCfg["F_古地下遗迹_开启状态"], 1)
        GuDiXiaYiJi.SyncResponse(actor)
    end

    if var == 2 then
        local bool = getflagstatus(actor, VarCfg["F_古地下遗迹_开启状态"] )
        if bool == 0 then
            Player.sendmsgEx(actor, "提示#251|:#255|对不起,你还未开启|古地下遗迹#249|地图了,无法进入...")
            return
        end
        map(actor, "古地下遗迹")
    end
end

--注册网络消息
function GuDiXiaYiJi.SyncResponse(actor, logindatas)
    local bool = getflagstatus(actor, VarCfg["F_古地下遗迹_开启状态"])
    local _login_data = { ssrNetMsgCfg.GuDiXiaYiJi_SyncResponse, bool, 0, 0, nil}
    if logindatas then
        table.insert(logindatas, _login_data)
    else
        Message.sendmsg(actor, ssrNetMsgCfg.GuDiXiaYiJi_SyncResponse, bool, 0, 0, nil)
    end
end
Message.RegisterNetMsg(ssrNetMsgCfg.GuDiXiaYiJi, GuDiXiaYiJi)

--登录触发
local function _onLoginEnd(actor, logindatas)
    GuDiXiaYiJi.SyncResponse(actor, logindatas)
end
GameEvent.add(EventCfg.onLoginEnd, _onLoginEnd, GuDiXiaYiJi)

return GuDiXiaYiJi

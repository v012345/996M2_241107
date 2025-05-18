local MoFaDeShiLian = {}
local cost = {{"无尽愤怒", 1},{"血魔护臂MAX", 1}}

function MoFaDeShiLian.Request(actor,var)
    if var == 1 then
        local bool = getflagstatus(actor, VarCfg["F_神语的试炼_无尽愤怒"])
        if bool == 1 then
            Player.sendmsgEx(actor, "提示#251|:#255|对不起,你已提交|无尽愤怒#249|了,请勿重复提交...")
            return
        else
            local name, num = Player.checkItemNumByTable(actor, {cost[1]})
            if name then
                Player.sendmsgEx(actor, string.format("提示#251|:#255|你的|%s#249|不足|%d#249|件,提交失败...", name, num))
                return
            end
            Player.takeItemByTable(actor, {cost[1]}, "激活扣除")
            if randomex(40, 100) then
                setflagstatus(actor, VarCfg["F_神语的试炼_无尽愤怒"], 1)
                Player.setAttList(actor, "属性附加")
            else
                Player.sendmsgEx(actor, "提示#251|:#255|对不起,提交|失败#249|请再接再厉...")
            end
            MoFaDeShiLian.SyncResponse(actor)
        end
    end
    if var == 2 then
        local bool = getflagstatus(actor, VarCfg["F_神语的试炼_血魔护臂MAX"])
        if bool == 1 then
            Player.sendmsgEx(actor, "提示#251|:#255|对不起,你已提交|血魔护臂MAX#249|了,请勿重复提交...")
            return
        else
            local name, num = Player.checkItemNumByTable(actor, {cost[2]})
            if name then
                Player.sendmsgEx(actor, string.format("提示#251|:#255|你的|%s#249|不足|%d#249|件,提交失败...", name, num))
                return
            end
            Player.takeItemByTable(actor, {cost[2]}, "激活扣除")
            if randomex(40, 100) then
                setflagstatus(actor, VarCfg["F_神语的试炼_血魔护臂MAX"], 1)
                Player.setAttList(actor, "属性附加")
            else
                Player.sendmsgEx(actor, "提示#251|:#255|对不起,提交|失败#249|请再接再厉...")
            end
            MoFaDeShiLian.SyncResponse(actor)
        end
    end
end

--叠加属性
local function _onCalcAttr(actor, attrs)
    local shuxing = {}
    local bool1 = getflagstatus(actor, VarCfg["F_神语的试炼_无尽愤怒"])
    local bool2 = getflagstatus(actor, VarCfg["F_神语的试炼_血魔护臂MAX"])
    if bool1 == 1 then
        shuxing[206] = 5  --最大攻击力
    end

    if  bool2 == 1 then
        shuxing[207] = 5  --最大生命值
    end


    if  bool1 == 1 and bool2 == 1 then
        shuxing[200] = 2888  --切割值
    end
    calcAtts(attrs, shuxing, "神语的试炼")
end
GameEvent.add(EventCfg.onCalcAttr, _onCalcAttr, MoFaDeShiLian)






--注册网络消息
function MoFaDeShiLian.SyncResponse(actor, logindatas)
    local bool1 = getflagstatus(actor, VarCfg["F_神语的试炼_无尽愤怒"])
    local bool2 = getflagstatus(actor, VarCfg["F_神语的试炼_血魔护臂MAX"])

    local data ={ bool1,bool2}
    local _login_data = { ssrNetMsgCfg.MoFaDeShiLian_SyncResponse, 0, 0, 0, data }
    if logindatas then
        table.insert(logindatas, _login_data)
    else
        Message.sendmsg(actor, ssrNetMsgCfg.MoFaDeShiLian_SyncResponse, 0, 0, 0, data)
    end
end
Message.RegisterNetMsg(ssrNetMsgCfg.MoFaDeShiLian, MoFaDeShiLian)

--登录触发
local function _onLoginEnd(actor, logindatas)
    MoFaDeShiLian.SyncResponse(actor, logindatas)
end
GameEvent.add(EventCfg.onLoginEnd, _onLoginEnd, MoFaDeShiLian)





return MoFaDeShiLian

local TeQuan = {}

function TeQuan.Request(actor)
    local ZhiGouMoney = querymoney(actor, 24)
    local ZhiGouBoll = getflagstatus(actor, VarCfg["F_解绑状态"])
    if ZhiGouBoll == 1 then return end -- 是否已经直购

    if ZhiGouMoney >= 98 then
        changemoney(actor, 24, "-", 98, "扣除直购点")
        confertitle(actor, "牛马特权")
        Player.setAttList(actor, "属性附加")
        Player.setAttList(actor, "攻速附加")
        setflagstatus(actor, VarCfg["F_解绑状态"] , 1)
        Player.sendmsgEx(actor, "提示#251|:#255|恭喜你,购买|牛马特权#249|成功,祝你游戏愉快...")
        GameEvent.push(EventCfg.onTeQuankaiTong, actor)
    else
        -----------------------↓↓↓拉起前端充值↓↓↓-----------------------
        Message.sendmsg(actor, ssrNetMsgCfg.TeQuan_TopUp, 98, 0, 0, nil)
        -----------------------↑↑↑拉起前端充值↑↑↑-----------------------
    end
end

function TeQuan.PickType(actor,var)
    pullpay(actor, 98, var, 24)
end

--充值回调
local function _onRecharge(actor, gold, productid, moneyid)
    if moneyid == 24 then
        if gold == 98 then
            local Num = getplaydef(actor,VarCfg["U_直购记录"])
            setplaydef(actor,VarCfg["U_直购记录"], Num + gold)
            changemoney(actor, 24, "-", 98, "扣除直购点")
            confertitle(actor, "牛马特权")
            Player.setAttList(actor, "属性附加")
            Player.setAttList(actor, "攻速附加")
            setflagstatus(actor, VarCfg["F_解绑状态"] , 1)
            Player.sendmsgEx(actor, "提示#251|:#255|恭喜你,购买|牛马特权#249|成功,祝你游戏愉快...")
            GameEvent.push(EventCfg.onTeQuankaiTong, actor)
        end
    end
end
GameEvent.add(EventCfg.onRecharge, _onRecharge, TeQuan)

--攻速附加
local function _onCalcAttackSpeed(actor, attackSpeeds)
    if checktitle(actor,"牛马特权") then
        attackSpeeds[1] = attackSpeeds[1] + 20
    end
end
GameEvent.add(EventCfg.onCalcAttackSpeed, _onCalcAttackSpeed, TeQuan)


--没有解绑特权玩家 绑定物品
local function _onMondropItemex(actor, item)
    if getflagstatus(actor, VarCfg["F_解绑状态"]) == 0 then
        setitemaddvalue(actor, item, 2, 1, ConstCfg.binding)
    end
end
GameEvent.add(EventCfg.onMondropItemex, _onMondropItemex, TeQuan)



Message.RegisterNetMsg(ssrNetMsgCfg.TeQuan, TeQuan)
return TeQuan
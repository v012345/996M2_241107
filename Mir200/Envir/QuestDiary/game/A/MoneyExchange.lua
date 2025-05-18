local MoneyExchange = {}

function MoneyExchange.Request(actor,arg1,arg2)
    arg2 = math.floor(arg2)
    if MoneyExchange.detection(arg2) == false then
        return
    end
    local MoneyData = {{"钻石",arg2}}
    --兑换元宝
    if arg1 == 1 then
        MoneyExchange.Exchange(actor,MoneyData,arg2,2,50000,"元宝")
    --兑换灵符
    elseif arg1 == 2 then
        MoneyExchange.Exchange(actor,MoneyData,arg2,5,20,"灵符")
    else
        Player.sendmsg(actor,"兑换参数错误！")
    end
end

function MoneyExchange.detection(Num)
    if Num == "" or Num == nil then
        Player.sendmsg("请输入兑换的数量！")
        return false
    end
    if type(Num) ~= "number" then
        Player.sendmsg("只能输入数字！")
        return false
    end
    if Num > 9999 then
        Player.sendmsg("兑换数量不能超过9999!")
        return false
    end
    if Num < 1 then
        Player.sendmsg("兑换数量必须大于1")
        return false
    end
    return true
end

function MoneyExchange.Exchange(actor,MoneyData,MoneyMum,MoneyIdx,multiple,MoneyName)
    local name,num = Player.checkItemNumByTable(actor, MoneyData)
    if name then
        messagebox(actor, "兑换失败，您的"..name.."不足"..num..",是否充值一点？", "@openrecharge", "@quxiao")
        return
    else
        Player.takeItemByTable(actor, MoneyData, "钻石兑换"..MoneyName)
        local money = MoneyMum*multiple
        changemoney(actor,MoneyIdx,"+",money,"钻石兑换"..MoneyName,true)
        local msgData = {
            {"#FFFFFF","恭喜您成功兑换"},
            {"#00FF00","["..tostring(money)..MoneyName.."]"}
        }
        Player.sendmsg(actor,msgData)
    end
end

--注册网络消息
Message.RegisterNetMsg(ssrNetMsgCfg.MoneyExchange,MoneyExchange)

return MoneyExchange
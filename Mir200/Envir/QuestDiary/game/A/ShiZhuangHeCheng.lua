local ShiZhuangHeCheng = {}

local where = 17

function ShiZhuangHeCheng.Request(actor, arg1)
    -- 同步一次,网络消息防止没有回传的时候重复点击
    Message.sendmsg(actor, ssrNetMsgCfg.ShiZhuangHeCheng_SyncResponse)
    if type(arg1) ~= "number" then
        return
    end
    local config = cfg_ShiZhuangHeCheng[arg1]
    if not config then
        Player.sendmsg(actor, "非法操作")
        return
    end
    local currName = Player.getEquipNameByPos(actor, where)

    if currName == cfg_ShiZhuangHeCheng[#cfg_ShiZhuangHeCheng].equip then
        Player.sendmsgEx(actor, "你的时装已满级!#249")
        return
    end
    if not Bag.checkBagEmptyNum(actor,5) then
        Player.sendmsgEx(actor, "你的背包格子不足!")
        return
    end
    local name, num = Player.checkItemNumByTable(actor, config.consumption)
    if name then
        Player.sendmsgEx(actor, string.format("你的|%s#249|不足|%d#249", name, num))
        return
    end
    local currDaLu = getplaydef(actor,VarCfg["U_记录大陆"])
    if currDaLu < config.dalu then
        local chinaNumber = formatNumberToChinese(config.dalu)
        Player.sendmsgEx(actor, string.format("解锁|%s大陆#249|后才能继续合成!", chinaNumber))
        return
    end

    if currName ~= config.equip and config.equip ~= "空" then
        Player.sendmsg(actor, string.format("你身上没有%s,合成失败!", config.equip))
        return
    end

    if currName ~= nil and config.equip == "空" then
        Player.sendmsg(actor, "你身上已经有更高级的装备了")
        return
    end

    local isSuccess
    if currName == nil then
        isSuccess = giveonitem(actor, where, config.give, 1, ConstCfg.binding)
    else
        takew(actor, currName, 1)
        isSuccess = giveonitem(actor, where, config.give, 1, ConstCfg.binding)
    end
    Player.takeItemByTable(actor, config.consumption,"时装升级")
    Player.sendmsgEx(actor, string.format("恭喜你成功合成|%s#249", config.give))
    local name = getbaseinfo(actor, ConstCfg.gbase.name)
    local msgData = {
        {"","恭喜["},
        {"#FF0000",name},
        {"","]"},
        {"","成功合成"},
        {"#00FF00",config.give},
        {"",",实力获得大幅提升!"},
        {"","<我也想要/@ShiZhuangHeCheng>"},
    }
    Player.sendmsgnew(actor, 254, nil, msgData)


end

Message.RegisterNetMsg(ssrNetMsgCfg.ShiZhuangHeCheng, ShiZhuangHeCheng)

return ShiZhuangHeCheng
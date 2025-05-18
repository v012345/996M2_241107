local ShaLuYinJi = {}
local where = 12
function ShaLuYinJi.Request(actor)
    --同步一次,网络消息防止没有回传的时候重复点击
    Message.sendmsg(actor, ssrNetMsgCfg.ShaLuYinJi_SyncResponse)
    local equipLevel = Player.getEquipFieldByPos(actor, where, 1) or 0
    equipLevel = tonumber(equipLevel)
    if equipLevel > #cfg_ShaLuYinJi then
        Player.sendmsgEx(actor, "[提示]:#251|你的|[杀戮刻印]#249|已满级!")
        return
    end
    if not Bag.checkBagEmptyNum(actor,5) then
        Player.sendmsgEx(actor, "你的背包格子不足!")
        return
    end
    local myLeve = getbaseinfo(actor, ConstCfg.gbase.level)
    if myLeve < 80 and equipLevel > 9 then
        Player.sendmsgEx(actor, "请到下一个大陆继续提升!")
        return
    end

    local config = cfg_ShaLuYinJi[equipLevel]
    local name, num = Player.checkItemNumByTable(actor, config.cost)
    if name then
        Player.sendmsgEx(actor, string.format("你的|%s#249|不足|%d#249", name, num))
        return
    end
    local currDaLu = getplaydef(actor,VarCfg["U_记录大陆"])
    if currDaLu < config.dalu then
        local chinaNumber = formatNumberToChinese(config.dalu)
        Player.sendmsgEx(actor, string.format("解锁|%s大陆#249|后才能继续提升!", chinaNumber))
        return
    end
    local currName = Player.getEquipNameByPos(actor, where)
    local isSuccess
    if equipLevel == 0 then
        isSuccess = giveonitem(actor, where, config.give, 1)
    else
        takew(actor, currName, 1)
        isSuccess = giveonitem(actor, where, config.give, 1)
        local num = getplaydef(actor, VarCfg["U_怪物猎人层数"])
        setaddnewabil(actor,12,"=","3#200#".. num .."")
        if config.give == "杀戮刻印Lv.5" then
            local taskPanelID = getplaydef(actor, VarCfg["U_主线任务面板进度"])
            if taskPanelID == 7 then
                FCheckTaskRedPoint(actor)
            end
        end
        if config.give == "杀戮刻印Lv.15" then
            GameEvent.push(EventCfg.onShaLuKeYinMax,actor)
        end
    end
    if isSuccess then
        Player.takeItemByTable(actor, config.cost,"杀戮刻印记升级")
        Player.sendmsgEx(actor, string.format("恭喜你成功合成|%s#250", config.give))
        local name = getbaseinfo(actor, ConstCfg.gbase.name)
        local msgData = {
            {"","恭喜["},
            {"#FF0000",name},
            {"","]"},
            {"","成功合成"},
            {"#00FF00",config.give},
            {"",",实力获得大幅提升!"},
            {"","<我也想要/@ShaLuYinJi>"},
        }
        Player.sendmsgnew(actor, 254, nil, msgData)
    else
        Player.sendmsg(actor, "合成失败,请联系客服!")
    end
end

Message.RegisterNetMsg(ssrNetMsgCfg.ShaLuYinJi, ShaLuYinJi)

return ShaLuYinJi
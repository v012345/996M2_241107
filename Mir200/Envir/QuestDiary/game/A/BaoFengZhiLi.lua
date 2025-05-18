local BaoFengZhiLi = {}
local where = 14
function BaoFengZhiLi.Request(actor)
    --同步一次,网络消息防止没有回传的时候重复点击
    Message.sendmsg(actor, ssrNetMsgCfg.BaoFengZhiLi_SyncResponse)
    --获取位置自定义字段信息
    local equipLevel = Player.getEquipFieldByPos(actor, where, 1) or 0
    equipLevel = tonumber(equipLevel)
    if equipLevel > #cfg_BaoFengZhiLi then
        Player.sendmsgEx(actor, "[提示]:#251|你的|[疾风刻印]#249|已满级!")
        GameEvent.push(EventCfg.onJiFengKeYinMax, actor)
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

    local config = cfg_BaoFengZhiLi[equipLevel]
    local name, num = Player.checkItemNumByTable(actor, config.cost)
    if name then
        Player.sendmsgEx(actor, string.format("你的|%s#249|不足|%d#249", name, num))
        return
    end
    local currName = Player.getEquipNameByPos(actor, where)
    local isSuccess
    if equipLevel == 0 then
        isSuccess = giveonitem(actor, where, config.give, 1)
        if  config.give == "疾风刻印Lv.10" then
            GameEvent.push(EventCfg.onJiFengKeYinMax, actor)
        end
    else
        takew(actor, currName, 1)
        isSuccess = giveonitem(actor, where, config.give, 1)
    end
    if isSuccess then
        Player.takeItemByTable(actor, config.cost,"暴风之力升级")
        if config.give == "疾风刻印Lv.5" then
            local taskPanelID = getplaydef(actor, VarCfg["U_主线任务面板进度"])
            if taskPanelID == 8 then
                FCheckTaskRedPoint(actor)
            end
        end
        Player.sendmsgEx(actor, string.format("恭喜你成功合成|%s#250", config.give))
        local name = getbaseinfo(actor, ConstCfg.gbase.name)
        local msgData = {
            {"","恭喜["},
            {"#FF0000",name},
            {"","]"},
            {"","成功合成"},
            {"#00FF00",config.give},
            {"",",实力获得大幅提升!"},
            {"","<我也想要/@BaoFengZhiLi>"},
        }
        Player.sendmsgnew(actor, 254, nil, msgData)
    else
        Player.sendmsg(actor, "合成失败,请联系客服!")
    end
end
Message.RegisterNetMsg(ssrNetMsgCfg.BaoFengZhiLi, BaoFengZhiLi)
return BaoFengZhiLi
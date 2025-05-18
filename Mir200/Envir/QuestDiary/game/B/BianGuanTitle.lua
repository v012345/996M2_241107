local BianGuanTitle = {}
function BianGuanTitle.Request(actor)
    local currLeve = getplaydef(actor,VarCfg.U_bian_guan_title)
    local cfg = cfg_BianGuanTitle[currLeve]
    if not cfg then
        Player.sendmsgEx(actor, "边关守护者已满级!#249")
        return
    end
    local name, num = Player.checkItemNumByTable(actor, cfg.cost)
    if name then
        Player.sendmsgEx(actor, string.format("你的|%s#249|不足|%s#249", name, num))
        return
    end
    Player.takeItemByTable(actor, cfg.cost, "边关称号")
    local randomNum = 70
    if currLeve < 5 then
        randomNum = 100
    else
        randomNum = 70
    end
    if not randomex(randomNum) then
        Player.sendmsgEx(actor, string.format("升级失败!#249", cfg.titleNext))
        BianGuanTitle.SyncResponse(actor)
        return
    end
    deprivetitle(actor, cfg.title)
    confertitle(actor, cfg.titleNext,1)
    Player.sendmsgEx(actor, string.format("恭喜你获得称号|[%s]", cfg.titleNext))
    setplaydef(actor, VarCfg.U_bian_guan_title, currLeve + 1)
    BianGuanTitle.SyncResponse(actor)
    Player.setAttList(actor, "属性附加")
    --给任务红点
    if currLeve + 1 == 1 then
        local taskPanelID = getplaydef(actor, VarCfg["U_主线任务面板进度"])
        if taskPanelID == 3 then
            FCheckTaskRedPoint(actor)
        end
    elseif currLeve + 1 == 5 then
        local taskPanelID = getplaydef(actor, VarCfg["U_主线任务面板进度"])
        if taskPanelID == 5 then
            FCheckTaskRedPoint(actor)
        end
    end
end

Message.RegisterNetMsg(ssrNetMsgCfg.BianGuanTitle, BianGuanTitle)

function BianGuanTitle.SyncResponse(actor, logindatas)
    local currLeve = getplaydef(actor,VarCfg.U_bian_guan_title)
    local _login_data = {ssrNetMsgCfg.BianGuanTitle_SyncResponse, currLeve}
    if logindatas then
        table.insert(logindatas, _login_data)
    else
        Message.sendmsg(actor, ssrNetMsgCfg.BianGuanTitle_SyncResponse, currLeve)
    end

end

--登录触发
local function _onLoginEnd(actor, logindatas)
    BianGuanTitle.SyncResponse(actor, logindatas)
end
--事件派发
GameEvent.add(EventCfg.onLoginEnd, _onLoginEnd, BianGuanTitle)


return BianGuanTitle
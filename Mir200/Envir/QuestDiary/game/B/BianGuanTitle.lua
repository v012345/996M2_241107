local BianGuanTitle = {}
function BianGuanTitle.Request(actor)
    local currLeve = getplaydef(actor,VarCfg.U_bian_guan_title)
    local cfg = cfg_BianGuanTitle[currLeve]
    if not cfg then
        Player.sendmsgEx(actor, "�߹��ػ���������!#249")
        return
    end
    local name, num = Player.checkItemNumByTable(actor, cfg.cost)
    if name then
        Player.sendmsgEx(actor, string.format("���|%s#249|����|%s#249", name, num))
        return
    end
    Player.takeItemByTable(actor, cfg.cost, "�߹سƺ�")
    local randomNum = 70
    if currLeve < 5 then
        randomNum = 100
    else
        randomNum = 70
    end
    if not randomex(randomNum) then
        Player.sendmsgEx(actor, string.format("����ʧ��!#249", cfg.titleNext))
        BianGuanTitle.SyncResponse(actor)
        return
    end
    deprivetitle(actor, cfg.title)
    confertitle(actor, cfg.titleNext,1)
    Player.sendmsgEx(actor, string.format("��ϲ���óƺ�|[%s]", cfg.titleNext))
    setplaydef(actor, VarCfg.U_bian_guan_title, currLeve + 1)
    BianGuanTitle.SyncResponse(actor)
    Player.setAttList(actor, "���Ը���")
    --��������
    if currLeve + 1 == 1 then
        local taskPanelID = getplaydef(actor, VarCfg["U_��������������"])
        if taskPanelID == 3 then
            FCheckTaskRedPoint(actor)
        end
    elseif currLeve + 1 == 5 then
        local taskPanelID = getplaydef(actor, VarCfg["U_��������������"])
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

--��¼����
local function _onLoginEnd(actor, logindatas)
    BianGuanTitle.SyncResponse(actor, logindatas)
end
--�¼��ɷ�
GameEvent.add(EventCfg.onLoginEnd, _onLoginEnd, BianGuanTitle)


return BianGuanTitle
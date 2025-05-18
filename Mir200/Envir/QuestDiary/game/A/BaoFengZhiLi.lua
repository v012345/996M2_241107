local BaoFengZhiLi = {}
local where = 14
function BaoFengZhiLi.Request(actor)
    --ͬ��һ��,������Ϣ��ֹû�лش���ʱ���ظ����
    Message.sendmsg(actor, ssrNetMsgCfg.BaoFengZhiLi_SyncResponse)
    --��ȡλ���Զ����ֶ���Ϣ
    local equipLevel = Player.getEquipFieldByPos(actor, where, 1) or 0
    equipLevel = tonumber(equipLevel)
    if equipLevel > #cfg_BaoFengZhiLi then
        Player.sendmsgEx(actor, "[��ʾ]:#251|���|[�����ӡ]#249|������!")
        GameEvent.push(EventCfg.onJiFengKeYinMax, actor)
        return
    end
    if not Bag.checkBagEmptyNum(actor,5) then
        Player.sendmsgEx(actor, "��ı������Ӳ���!")
        return
    end
    local myLeve = getbaseinfo(actor, ConstCfg.gbase.level)
    if myLeve < 80 and equipLevel > 9 then
        Player.sendmsgEx(actor, "�뵽��һ����½��������!")
        return
    end

    local config = cfg_BaoFengZhiLi[equipLevel]
    local name, num = Player.checkItemNumByTable(actor, config.cost)
    if name then
        Player.sendmsgEx(actor, string.format("���|%s#249|����|%d#249", name, num))
        return
    end
    local currName = Player.getEquipNameByPos(actor, where)
    local isSuccess
    if equipLevel == 0 then
        isSuccess = giveonitem(actor, where, config.give, 1)
        if  config.give == "�����ӡLv.10" then
            GameEvent.push(EventCfg.onJiFengKeYinMax, actor)
        end
    else
        takew(actor, currName, 1)
        isSuccess = giveonitem(actor, where, config.give, 1)
    end
    if isSuccess then
        Player.takeItemByTable(actor, config.cost,"����֮������")
        if config.give == "�����ӡLv.5" then
            local taskPanelID = getplaydef(actor, VarCfg["U_��������������"])
            if taskPanelID == 8 then
                FCheckTaskRedPoint(actor)
            end
        end
        Player.sendmsgEx(actor, string.format("��ϲ��ɹ��ϳ�|%s#250", config.give))
        local name = getbaseinfo(actor, ConstCfg.gbase.name)
        local msgData = {
            {"","��ϲ["},
            {"#FF0000",name},
            {"","]"},
            {"","�ɹ��ϳ�"},
            {"#00FF00",config.give},
            {"",",ʵ����ô������!"},
            {"","<��Ҳ��Ҫ/@BaoFengZhiLi>"},
        }
        Player.sendmsgnew(actor, 254, nil, msgData)
    else
        Player.sendmsg(actor, "�ϳ�ʧ��,����ϵ�ͷ�!")
    end
end
Message.RegisterNetMsg(ssrNetMsgCfg.BaoFengZhiLi, BaoFengZhiLi)
return BaoFengZhiLi
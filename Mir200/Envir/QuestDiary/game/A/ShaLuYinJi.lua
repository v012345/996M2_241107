local ShaLuYinJi = {}
local where = 12
function ShaLuYinJi.Request(actor)
    --ͬ��һ��,������Ϣ��ֹû�лش���ʱ���ظ����
    Message.sendmsg(actor, ssrNetMsgCfg.ShaLuYinJi_SyncResponse)
    local equipLevel = Player.getEquipFieldByPos(actor, where, 1) or 0
    equipLevel = tonumber(equipLevel)
    if equipLevel > #cfg_ShaLuYinJi then
        Player.sendmsgEx(actor, "[��ʾ]:#251|���|[ɱ¾��ӡ]#249|������!")
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

    local config = cfg_ShaLuYinJi[equipLevel]
    local name, num = Player.checkItemNumByTable(actor, config.cost)
    if name then
        Player.sendmsgEx(actor, string.format("���|%s#249|����|%d#249", name, num))
        return
    end
    local currDaLu = getplaydef(actor,VarCfg["U_��¼��½"])
    if currDaLu < config.dalu then
        local chinaNumber = formatNumberToChinese(config.dalu)
        Player.sendmsgEx(actor, string.format("����|%s��½#249|����ܼ�������!", chinaNumber))
        return
    end
    local currName = Player.getEquipNameByPos(actor, where)
    local isSuccess
    if equipLevel == 0 then
        isSuccess = giveonitem(actor, where, config.give, 1)
    else
        takew(actor, currName, 1)
        isSuccess = giveonitem(actor, where, config.give, 1)
        local num = getplaydef(actor, VarCfg["U_�������˲���"])
        setaddnewabil(actor,12,"=","3#200#".. num .."")
        if config.give == "ɱ¾��ӡLv.5" then
            local taskPanelID = getplaydef(actor, VarCfg["U_��������������"])
            if taskPanelID == 7 then
                FCheckTaskRedPoint(actor)
            end
        end
        if config.give == "ɱ¾��ӡLv.15" then
            GameEvent.push(EventCfg.onShaLuKeYinMax,actor)
        end
    end
    if isSuccess then
        Player.takeItemByTable(actor, config.cost,"ɱ¾��ӡ������")
        Player.sendmsgEx(actor, string.format("��ϲ��ɹ��ϳ�|%s#250", config.give))
        local name = getbaseinfo(actor, ConstCfg.gbase.name)
        local msgData = {
            {"","��ϲ["},
            {"#FF0000",name},
            {"","]"},
            {"","�ɹ��ϳ�"},
            {"#00FF00",config.give},
            {"",",ʵ����ô������!"},
            {"","<��Ҳ��Ҫ/@ShaLuYinJi>"},
        }
        Player.sendmsgnew(actor, 254, nil, msgData)
    else
        Player.sendmsg(actor, "�ϳ�ʧ��,����ϵ�ͷ�!")
    end
end

Message.RegisterNetMsg(ssrNetMsgCfg.ShaLuYinJi, ShaLuYinJi)

return ShaLuYinJi
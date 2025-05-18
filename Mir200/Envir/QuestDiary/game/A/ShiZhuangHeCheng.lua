local ShiZhuangHeCheng = {}

local where = 17

function ShiZhuangHeCheng.Request(actor, arg1)
    -- ͬ��һ��,������Ϣ��ֹû�лش���ʱ���ظ����
    Message.sendmsg(actor, ssrNetMsgCfg.ShiZhuangHeCheng_SyncResponse)
    if type(arg1) ~= "number" then
        return
    end
    local config = cfg_ShiZhuangHeCheng[arg1]
    if not config then
        Player.sendmsg(actor, "�Ƿ�����")
        return
    end
    local currName = Player.getEquipNameByPos(actor, where)

    if currName == cfg_ShiZhuangHeCheng[#cfg_ShiZhuangHeCheng].equip then
        Player.sendmsgEx(actor, "���ʱװ������!#249")
        return
    end
    if not Bag.checkBagEmptyNum(actor,5) then
        Player.sendmsgEx(actor, "��ı������Ӳ���!")
        return
    end
    local name, num = Player.checkItemNumByTable(actor, config.consumption)
    if name then
        Player.sendmsgEx(actor, string.format("���|%s#249|����|%d#249", name, num))
        return
    end
    local currDaLu = getplaydef(actor,VarCfg["U_��¼��½"])
    if currDaLu < config.dalu then
        local chinaNumber = formatNumberToChinese(config.dalu)
        Player.sendmsgEx(actor, string.format("����|%s��½#249|����ܼ����ϳ�!", chinaNumber))
        return
    end

    if currName ~= config.equip and config.equip ~= "��" then
        Player.sendmsg(actor, string.format("������û��%s,�ϳ�ʧ��!", config.equip))
        return
    end

    if currName ~= nil and config.equip == "��" then
        Player.sendmsg(actor, "�������Ѿ��и��߼���װ����")
        return
    end

    local isSuccess
    if currName == nil then
        isSuccess = giveonitem(actor, where, config.give, 1, ConstCfg.binding)
    else
        takew(actor, currName, 1)
        isSuccess = giveonitem(actor, where, config.give, 1, ConstCfg.binding)
    end
    Player.takeItemByTable(actor, config.consumption,"ʱװ����")
    Player.sendmsgEx(actor, string.format("��ϲ��ɹ��ϳ�|%s#249", config.give))
    local name = getbaseinfo(actor, ConstCfg.gbase.name)
    local msgData = {
        {"","��ϲ["},
        {"#FF0000",name},
        {"","]"},
        {"","�ɹ��ϳ�"},
        {"#00FF00",config.give},
        {"",",ʵ����ô������!"},
        {"","<��Ҳ��Ҫ/@ShiZhuangHeCheng>"},
    }
    Player.sendmsgnew(actor, 254, nil, msgData)


end

Message.RegisterNetMsg(ssrNetMsgCfg.ShiZhuangHeCheng, ShiZhuangHeCheng)

return ShiZhuangHeCheng
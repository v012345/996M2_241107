local EquipMake5 = {}
EquipMake5.ID = 15400
EquipMake5.where = 2 --װ��λ��
function EquipMake5.Request(actor)
    local equipInfo = linkbodyitem(actor, EquipMake5.where)
    local equipIndex
    local heChengInfo
    if equipInfo == "0" then
        heChengInfo = cfg_baoshi.null
    else
        equipIndex = getiteminfo(actor, equipInfo, 2)
        heChengInfo = cfg_baoshi[equipIndex]
    end
    if heChengInfo == nil then
        Player.sendmsg(actor, "����������ٴγ���")
        return
    end
    if equipIndex == heChengInfo.upleve then
        Player.sendmsg(actor, "�ϳ�ʧ�ܣ����ı�ʯ�Ѿ������ˣ�")
        return
    end
    local name, num = Player.checkItemNumByTable(actor, heChengInfo.consume)
    if name then
        Player.sendmsg(actor, "�ϳ�ʧ�ܣ�����" .. name .. "����" .. num)
        return
    end
    if equipInfo ~= "0" then
        if Player.takeItemToBody(actor, EquipMake5.where) == false then
            Player.sendmsg(actor, "�ϳ�ʧ�ܣ�����װ�������ڣ�")
            return
        end
    end
    Player.takeItemByTable(actor, heChengInfo.consume, "��ʯ�ϳ�")
    local equipName = getstditeminfo(heChengInfo.upleve, ConstCfg.stditeminfo.name)
    giveonitem(actor, EquipMake5.where, equipName, 1, 0)
    local userName = getbaseinfo(actor, ConstCfg.gbase.name)
    local msgData = {}
    local priveatMsg = ""
    if equipName == "[��ʮ��]���Ǻӱ�ʯ" then
        msgData = {
            { "", "��ϲ���[" },
            { "242", userName },
            { "", "]�ɹ��ϳ�������ʯ[" },
            { "242", equipName },
            { "", "]����ϲ�ɺأ�" },
        }
        Player.sendcentermsg(actor, 250, 0, msgData)
    else
        msgData = {
            { "", "��ϲ���[" },
            { "242", userName },
            { "", "]�ɹ��ϳ�װ��[" },
            { "242", equipName },
            { "", "]����ϲ�ɺأ�" },
        }
        Player.sendmsgnew(actor, 250, 0, msgData)
    end
    Player.sendmsg(actor, "��ϲ���ɹ��ϳ�"..equipName)
    Player.screffects(actor, 60364,90)
    
end

--ע��������Ϣ
Message.RegisterNetMsg(ssrNetMsgCfg.EquipMake5, EquipMake5)
return EquipMake5

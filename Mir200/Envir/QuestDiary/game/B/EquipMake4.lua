local EquipMake4 = {}
EquipMake4.ID = 15300
EquipMake4.where = 9 --װ��λ��
function EquipMake4.Request(actor)
    local equipInfo = linkbodyitem(actor, EquipMake4.where)
    local equipIndex
    local heChengInfo
    if equipInfo == "0" then
        heChengInfo = cfg_hufu.null
    else
        equipIndex = getiteminfo(actor, equipInfo, 2)
        heChengInfo = cfg_hufu[equipIndex]
    end
    if heChengInfo == nil then
        Player.sendmsg(actor, "����������ٴγ���")
        return
    end
    if equipIndex == heChengInfo.upleve then
        Player.sendmsg(actor, "�ϳ�ʧ�ܣ����Ļ����Ѿ������ˣ�")
        return
    end
    local name, num = Player.checkItemNumByTable(actor, heChengInfo.consume)
    if name then
        Player.sendmsg(actor, "�ϳ�ʧ�ܣ�����" .. name .. "����" .. num)
        return
    end
    if equipInfo ~= "0" then
        if Player.takeItemToBody(actor, EquipMake4.where) == false then
            Player.sendmsg(actor, "�ϳ�ʧ�ܣ�����װ�������ڣ�")
            return
        end
    end
    Player.takeItemByTable(actor, heChengInfo.consume, "�����ϳ�")
    local equipName = getstditeminfo(heChengInfo.upleve, ConstCfg.stditeminfo.name)
    giveonitem(actor, EquipMake4.where, equipName, 1, 0)
    local userName = getbaseinfo(actor, ConstCfg.gbase.name)
    local msgData = {}
    local priveatMsg = ""
    if equipName == "[��ʮ��]���Ǻӻ���" then
        msgData = {
            { "", "��ϲ���[" },
            { "242", userName },
            { "", "]�ɹ��ϳ���������[" },
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
Message.RegisterNetMsg(ssrNetMsgCfg.EquipMake4, EquipMake4)
return EquipMake4

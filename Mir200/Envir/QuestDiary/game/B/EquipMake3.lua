local EquipMake3 = {}
EquipMake3.ID = 15200
EquipMake3.where = 14 --װ��λ��
function EquipMake3.Request(actor)
    local equipInfo = linkbodyitem(actor, EquipMake3.where)
    local equipIndex
    local heChengInfo
    if equipInfo == "0" then
        heChengInfo = cfg_zhangu.null
    else
        equipIndex = getiteminfo(actor, equipInfo, 2)
        heChengInfo = cfg_zhangu[equipIndex]
    end
    if heChengInfo == nil then
        Player.sendmsg(actor, "����������ٴγ���")
        return
    end
    if equipIndex == heChengInfo.upleve then
        Player.sendmsg(actor, "�ϳ�ʧ�ܣ�����ս���Ѿ������ˣ�")
        return
    end
    local name, num = Player.checkItemNumByTable(actor, heChengInfo.consume)
    if name then
        Player.sendmsg(actor, "�ϳ�ʧ�ܣ�����" .. name .. "����" .. num)
        return
    end
    if equipInfo ~= "0" then
        if Player.takeItemToBody(actor, EquipMake3.where) == false then
            Player.sendmsg(actor, "�ϳ�ʧ�ܣ�����װ�������ڣ�")
            return
        end
    end
    Player.takeItemByTable(actor, heChengInfo.consume, "ս�ĺϳ�")
    local equipName = getstditeminfo(heChengInfo.upleve, ConstCfg.stditeminfo.name)
    giveonitem(actor, EquipMake3.where, equipName, 1, 0)
    local userName = getbaseinfo(actor, ConstCfg.gbase.name)
    local msgData = {}
    local priveatMsg = ""
    if equipName == "[��ʮ��]���Ǻ�ս��" then
        msgData = {
            { "", "��ϲ���[" },
            { "242", userName },
            { "", "]�ɹ��ϳ�����ս��[" },
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
Message.RegisterNetMsg(ssrNetMsgCfg.EquipMake3, EquipMake3)
return EquipMake3

local EquipMake2 = {}
EquipMake2.ID = 15100
EquipMake2.where = 15 --װ��λ��
function EquipMake2.Request(actor)
    local equipInfo = linkbodyitem(actor, EquipMake2.where)
    local equipIndex
    local heChengInfo
    if equipInfo == "0" then
        heChengInfo = cfg_shenyin.null
    else
        equipIndex = getiteminfo(actor, equipInfo, 2)
        heChengInfo = cfg_shenyin[equipIndex]
    end
    if heChengInfo == nil then
        Player.sendmsg(actor, "����������ٴγ���")
        return
    end
    if equipIndex == heChengInfo.upleve then
        Player.sendmsg(actor, "�ϳ�ʧ�ܣ�������ӡ�Ѿ������ˣ�")
        return
    end
    local name, num = Player.checkItemNumByTable(actor, heChengInfo.consume)
    if name then
        Player.sendmsg(actor, "�ϳ�ʧ�ܣ�����" .. name .. "����" .. num)
        return
    end
    if equipInfo ~= "0" then
        if Player.takeItemToBody(actor, EquipMake2.where) == false then
            Player.sendmsg(actor, "�ϳ�ʧ�ܣ�����װ�������ڣ�")
            return
        end
    end
    Player.takeItemByTable(actor, heChengInfo.consume, "��ӡ�ϳ�")
    local equipName = getstditeminfo(heChengInfo.upleve, ConstCfg.stditeminfo.name)
    giveonitem(actor, EquipMake2.where, equipName, 1, 0)
    local userName = getbaseinfo(actor, ConstCfg.gbase.name)
    local msgData = {}
    local priveatMsg = ""
    if equipName == "[��ʮ��]���Ǻ�ӡ��" then
        msgData = {
            { "", "��ϲ���[" },
            { "242", userName },
            { "", "]�ɹ��ϳ�������ӡ[" },
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
Message.RegisterNetMsg(ssrNetMsgCfg.EquipMake2, EquipMake2)
return EquipMake2

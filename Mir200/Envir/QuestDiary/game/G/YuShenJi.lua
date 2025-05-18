local YuShenJi = {}
--local config = include("QuestDiary/cfgcsv/cfg_YuShenJi.lua") --����
YuShenJi.ID = "�����"
local npcID = 826
local mainName = "�����"
local cost = { { "��ͼ�о�", 10 }, { "Ԫ��", 1880000 } }
local abilGroup = 4
--��������
function YuShenJi.Request(actor)
    local isInRange = FCheckNPCRange(actor, npcID, 15)
    if not isInRange then
        Player.sendmsgEx(actor, "����̫Զ#249")
        return
    end
    local itemobj = linkbodyitem(actor, 0)
    local equipName = getiteminfo(actor, itemobj, ConstCfg.iteminfo.name)
    if equipName ~= mainName then
        Player.sendmsgEx(actor, string.format("��ʾ��#251|������û�д���|%s#249|�޷�����!", mainName))
        return
    end
    local name, num = Player.checkItemNumByTable(actor, cost)
    if name then
        Player.sendmsgEx(actor, string.format("����ʧ��,���|%s#249|����|%d#249", name, num))
        return
    end
    local values = Item.getEquipCustomAttrValue(actor, 0, abilGroup + 1) --��ȡ������� �±���Ҫ+1
    local cusotmAttrValue1 = values[1] or 0
    local cusotmAttrValue2 = values[2] or 0
    if cusotmAttrValue2 >= 10 then
        Player.sendmsgEx(actor, "��ʾ��#251|���#250|" .. mainName .. "#249|�Ѿ�����|10#249|����,�޷���������...")
        return
    end
    Player.takeItemByTable(actor, cost, mainName)
    local realAttrId1, realAttrId2 = 1, 26
    local attrId1, attrId2 = 92, 89
    clearitemcustomabil(actor, itemobj, abilGroup)
    changecustomitemtext(actor, itemobj, "[��������ξ���]:", abilGroup)
    changecustomitemtextcolor(actor, itemobj, 252, abilGroup)
    Player.addModifyCustomAttributes(actor, itemobj, abilGroup, 1, 0, 0, realAttrId1, attrId1, 0, cusotmAttrValue1 + 2000) --��������1����
    Player.addModifyCustomAttributes(actor, itemobj, abilGroup, 2, 0, 0, realAttrId2, attrId2, 1, cusotmAttrValue2 + 1) --��������2
    Player.sendmsgEx(actor, "��ϲ����ѳɹ�!")
    YuShenJi.SyncResponse(actor)
end

--ͬ����Ϣ
function YuShenJi.SyncResponse(actor)
    local data = {}
    Message.sendmsg(actor, ssrNetMsgCfg.YuShenJi_SyncResponse, 0, 0, 0, data)
end
-- --��¼����
-- local function _onLoginEnd(actor, logindatas)
--     YuShenJi.SyncResponse(actor, logindatas)
-- end
-- --�¼��ɷ�
-- GameEvent.add(EventCfg.onLoginEnd, _onLoginEnd, YuShenJi)
--ע��������Ϣ
Message.RegisterNetMsg(ssrNetMsgCfg.YuShenJi, YuShenJi)
return YuShenJi

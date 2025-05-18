local XingCuiCan = {}
XingCuiCan.ID = "����"
local npcID = 825
--local config = include("QuestDiary/cfgcsv/cfg_XingCuiCan.lua") --����
local mainName = "Ⱥ��֮ŭ����"
local cost = { { "��ͼ�о�", 10 }, { "Ԫ��", 1880000 } }
local abilGroup = 4
--��������
function XingCuiCan.Request(actor)
    local isInRange = FCheckNPCRange(actor, npcID, 15)
    if not isInRange then
        Player.sendmsgEx(actor, "����̫Զ#249")
        return
    end
    local itemobj = linkbodyitem(actor, 1)
    local equipName = getiteminfo(actor, itemobj, ConstCfg.iteminfo.name)
    if equipName ~= mainName then
        Player.sendmsgEx(actor, string.format("��ʾ��#251|������û�д���|%s#249|�޷�����!", mainName))
        return
    end
    local name, num = Player.checkItemNumByTable(actor, cost)
    if name then
        Player.sendmsgEx(actor, string.format("���|%s#249|����|%d#249", name, num))
        return
    end
    local values = Item.getEquipCustomAttrValue(actor, 1, abilGroup + 1) --��ȡ������� �±���Ҫ+1
    local cusotmAttrValue1 = values[1] or 0
    local cusotmAttrValue2 = values[2] or 0
    if cusotmAttrValue2 >= 1000 then
        Player.sendmsgEx(actor, "��ʾ��#251|���#250|" .. mainName .. "#249|�Ѿ�����|10#249|����,�޷���������...")
        return
    end
    Player.takeItemByTable(actor, cost, mainName)
    local realAttrId1, realAttrId2 = 4, 79
    local attrId1, attrId2 = 93, 94
    clearitemcustomabil(actor, itemobj, abilGroup)
    changecustomitemtext(actor, itemobj, "[��Ⱥ���貤ξ���]:", abilGroup)
    changecustomitemtextcolor(actor, itemobj, 252, abilGroup)
    Player.addModifyCustomAttributes(actor, itemobj, abilGroup, 1, 0, 0, realAttrId1, attrId1, 0, cusotmAttrValue1 + 99) --��������1����
    Player.addModifyCustomAttributes(actor, itemobj, abilGroup, 2, 0, 0, realAttrId2, attrId2, 1, cusotmAttrValue2 + 100) --��������2
    Player.sendmsgEx(actor, "��ϲ����ѳɹ�!")
    XingCuiCan.SyncResponse(actor)
end
--ͬ����Ϣ
function XingCuiCan.SyncResponse(actor)
    local data = {}
    Message.sendmsg(actor, ssrNetMsgCfg.XingCuiCan_SyncResponse, 0, 0, 0, data)
end
-- --��¼����
-- local function _onLoginEnd(actor, logindatas)
--     XingCuiCan.SyncResponse(actor, logindatas)
-- end
-- --�¼��ɷ�
-- GameEvent.add(EventCfg.onLoginEnd, _onLoginEnd, XingCuiCan)
--ע��������Ϣ
Message.RegisterNetMsg(ssrNetMsgCfg.XingCuiCan, XingCuiCan)
return XingCuiCan
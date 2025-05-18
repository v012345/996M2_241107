local ChiReQiangHua = {}
ChiReQiangHua.ID = "����ǿ��"
local npcID = 816
--local config = include("QuestDiary/cfgcsv/cfg_ChiReQiangHua.lua") --����
local cost = {{"����֮��",20},{"�컯�ᾧ",10},{"���",400}}
local give = {{}}
local mainName = "����ǿ��"
local abilGroup = 1
--��������
function ChiReQiangHua.Request(actor)
    local isInRange = FCheckNPCRange(actor, npcID, 15)
    if not isInRange then
        Player.sendmsgEx(actor, "����̫Զ#249")
        return
    end
    local itemobj = linkbodyitem(actor, 21)
    local equipName = getiteminfo(actor, itemobj, ConstCfg.iteminfo.name)
    if equipName ~= "�Ʒ�����ئ�" then
        Player.sendmsgEx(actor, string.format("��ʾ��#251|������û�д���|%s#249|�޷�ǿ��!"))
        return
    end
    local name, num = Player.checkItemNumByTable(actor, cost)
    if name then
        Player.sendmsgEx(actor, string.format("���|%s#249|����|%d#249", name, num))
        return
    end
    local values = Item.getEquipCustomAttrValue(actor, 21, abilGroup + 1) --��ȡ������� �±���Ҫ+1
    local cusotmAttrValue1 = values[1] or 0
    local cusotmAttrValue2 = values[2] or 0
    if cusotmAttrValue1 >= 20 then
        Player.sendmsgEx(actor, "��ʾ��#251|���#250|"..mainName.."#249|�Ѿ�ǿ��|20#249|����,�޷�����ǿ��...")
        return
    end
    Player.takeItemByTable(actor, cost, mainName)
    local realAttrId1, realAttrId2 = 25, 206
    local attrId1, attrId2 = 85, 86
    clearitemcustomabil(actor, itemobj, abilGroup)
    changecustomitemtext(actor, itemobj, "["..mainName.."]:", abilGroup)
    changecustomitemtextcolor(actor, itemobj, 252, abilGroup)
    Player.addModifyCustomAttributes(actor, itemobj, abilGroup, 1, 0, 0, realAttrId1, attrId1, 1, cusotmAttrValue1 + 1) --��������1
    Player.addModifyCustomAttributes(actor, itemobj, abilGroup, 2, 0, 0, realAttrId2, attrId2, 1, cusotmAttrValue2 + 1) --��������2
    Player.sendmsgEx(actor,"��ϲ��ǿ���ɹ�!")
    ChiReQiangHua.SyncResponse(actor)
end
--ͬ����Ϣ
function ChiReQiangHua.SyncResponse(actor)
    local data = {}
    Message.sendmsg(actor, ssrNetMsgCfg.ChiReQiangHua_SyncResponse, 0, 0, 0, data)
end
-- --��¼����
-- local function _onLoginEnd(actor, logindatas)
--     ChiReQiangHua.SyncResponse(actor, logindatas)
-- end
-- --�¼��ɷ�
-- GameEvent.add(EventCfg.onLoginEnd, _onLoginEnd, ChiReQiangHua)
--ע��������Ϣ
Message.RegisterNetMsg(ssrNetMsgCfg.ChiReQiangHua, ChiReQiangHua)
return ChiReQiangHua
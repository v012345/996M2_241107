local HunYuanFaXiang = {}
HunYuanFaXiang.ID = "��Ԫ����"
local npcID = 819
--local config = include("QuestDiary/cfgcsv/cfg_HunYuanFaXiang.lua") --����
local cost = { { "������", 400 }, { "�컯�ᾧ", 488 }, { "���", 8888 } }
local give = { { "���}������ئ�", 1 } }
local buffFlagMaps = {
    [31095] = VarCfg["F_��֮����"],
    [31096] = VarCfg["F_��֮����"],
    [31097] = VarCfg["F_ˮ֮����"],
    [31098] = VarCfg["F_��֮����"],
}
-- ����ǿ��
-- ����ǿ��
-- �̲�ǿ��
-- ����ǿ��
local list = {"����ǿ��","����ǿ��","�̲�ǿ��","����ǿ��"}
--��������
function HunYuanFaXiang.Request(actor)
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
    if not Bag.checkBagEmptyNum(actor, 5) then
        Player.sendmsgEx(actor, "��ı������Ӳ���,��������5���ո�!#249")
        stop(actor)
        return
    end
    for index, value in ipairs(list) do
        local values = Item.getEquipCustomAttrValue(actor, 21, index)
        local cusotmAttrValue = values[1] or 0
        if cusotmAttrValue < 20 then
            Player.sendmsgEx(actor, string.format("����ʧ��,���|%s#249|ǿ����������|%d#249", value, 20))
            return
        end
    end
    Player.takeItemByTable(actor, cost, "��Ԫ����")
    takew(actor, "�Ʒ�����ئ�", 1)
    --ɾ��һ��buff
    delbuff(actor,31094)
    for key, value in pairs(buffFlagMaps) do
        delbuff(actor,key)
    end
    Player.giveItemByTable(actor, give, "��Ԫ����")
    Player.sendmsgEx(actor, "��ϲ����ѳɹ�!")
    HunYuanFaXiang.SyncResponse(actor)
end

--ͬ����Ϣ
function HunYuanFaXiang.SyncResponse(actor)
    local data = {}
    Message.sendmsg(actor, ssrNetMsgCfg.HunYuanFaXiang_SyncResponse, 0, 0, 0, data)
end
-- --��¼����
-- local function _onLoginEnd(actor, logindatas)
--     HunYuanFaXiang.SyncResponse(actor, logindatas)
-- end
-- --�¼��ɷ�
-- GameEvent.add(EventCfg.onLoginEnd, _onLoginEnd, HunYuanFaXiang)
--ע��������Ϣ
Message.RegisterNetMsg(ssrNetMsgCfg.HunYuanFaXiang, HunYuanFaXiang)
return HunYuanFaXiang

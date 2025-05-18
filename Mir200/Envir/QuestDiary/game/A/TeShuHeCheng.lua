
local TeShuHeCheng = {}
local cfg_TeShu_DouLi = include("QuestDiary/cfgcsv/cfg_TeShu_DouLi.lua")
local cfg_TeShu_GuangHuan = include("QuestDiary/cfgcsv/cfg_TeShu_GuangHuan.lua")
local cfg_TeShu_LongZhiXin = include("QuestDiary/cfgcsv/cfg_TeShu_LongZhiXin.lua")
local cfg_TeShu_ShenShouHu = include("QuestDiary/cfgcsv/cfg_TeShu_ShenShouHu.lua")
local cfg_TeShu_DunPai = include("QuestDiary/cfgcsv/cfg_TeShu_DunPai.lua")
local config = {
    {pos = 13, config = cfg_TeShu_DouLi, name="��ħ����"},
    {pos = 2, config = cfg_TeShu_GuangHuan, name="�ָ��⻷"},
    {pos = 9, config = cfg_TeShu_LongZhiXin, name="����֮��"},
    {pos = 15, config = cfg_TeShu_ShenShouHu, name="���ػ�"},
    {pos = 16, config = cfg_TeShu_DunPai, name="ʥ�����"}
}

function TeShuHeCheng.Request(actor, pos, index)
    local cfg = config[pos]
    if not cfg then
        Player.sendmsg(actor, "�ύ����!")
        return
    end
    local equipObj  = linkbodyitem(actor,cfg.pos)
    local equipName
    local field1
    if equipObj ~= "0" then
        equipName = getiteminfo(actor,equipObj,ConstCfg.iteminfo.name)
        field1 = getstditeminfo(equipName,ConstCfg.stditeminfo.custom29)
    else
        field1 = 0
    end
    --����δ����װ��
    if field1 == 0 and index == 1 then
        index = 0
    end
    if not Bag.checkBagEmptyNum(actor,5) then
        Player.sendmsgEx(actor, "��ı������Ӳ���!")
        return
    end
    local HC_cfg = cfg.config[index]
    if not HC_cfg then
        Player.sendmsgEx(actor, string.format("���|%s#249|�������������������߼���װ��",cfg.name))
        return
    end

    if equipName ~= HC_cfg.equip and HC_cfg.equip ~= "δ����" then
        Player.sendmsgEx(actor, string.format("������û�д���|%s#249",HC_cfg.equip))
        return
    end
    
    local name,num = Player.checkItemNumByTable(actor, HC_cfg.cost)
    if name then
        Player.sendmsgEx(actor, string.format("���|%s#249|����|%s#249", name, num))
        return
    end
    Player.takeItemByTable(actor, HC_cfg.cost)
    if HC_cfg.equip ~= "δ����" then
        takew(actor, HC_cfg.equip, 1)
    end
    --�������֮��
    if pos == 3 then
        GameEvent.push(EventCfg.LongZhiXinUp, actor, HC_cfg.give)
    end

    giveonitem(actor, cfg.pos, HC_cfg.give)

    Player.sendmsgEx(actor, "�ϳɳɹ�!")
    Message.sendmsg(actor,ssrNetMsgCfg.TeShuHeCheng_SyncResponse)
end
------������Ϣע��------
Message.RegisterNetMsg(ssrNetMsgCfg.TeShuHeCheng, TeShuHeCheng)

return TeShuHeCheng
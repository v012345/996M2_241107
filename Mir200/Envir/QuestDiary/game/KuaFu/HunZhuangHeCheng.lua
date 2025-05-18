local HunZhuangHeCheng = {}
HunZhuangHeCheng.ID = "��װ�ϳ�"
local cfg_HunZhuang_WuQi = include("QuestDiary/cfgcsv/cfg_HunZhuang_WuQi.lua")
local cfg_HunZhuang_YiFu = include("QuestDiary/cfgcsv/cfg_HunZhuang_YiFu.lua")
local cfg_HunZhuang_TouKui = include("QuestDiary/cfgcsv/cfg_HunZhuang_TouKui.lua")
local cfg_HunZhuang_XiangLian = include("QuestDiary/cfgcsv/cfg_HunZhuang_XiangLian.lua")
local cfg_HunZhuang_ShouZhuo = include("QuestDiary/cfgcsv/cfg_HunZhuang_ShouZhuo.lua")
local cfg_HunZhuang_ZhiHuan = include("QuestDiary/cfgcsv/cfg_HunZhuang_ZhiHuan.lua")
local config = {
    { pos = 101, config = cfg_HunZhuang_WuQi, name = "��װ����" },
    { pos = 102, config = cfg_HunZhuang_YiFu, name = "��װ�·�" },
    { pos = 103, config = cfg_HunZhuang_TouKui, name = "��װͷ��" },
    { pos = 104, config = cfg_HunZhuang_XiangLian, name = "��װ����" },
    { pos = 105, config = cfg_HunZhuang_ShouZhuo, name = "��װ����" },
    { pos = 106, config = cfg_HunZhuang_ZhiHuan, name = "��װָ��" }
}
--��������
function HunZhuangHeCheng.Request(actor, parentIndex, childIndex)
    local config = config[parentIndex]
    if not config then
        Player.sendmsgEx(actor, "��������1#249")
        return
    end
    local cfg = config.config[childIndex]
    if not cfg then
        Player.sendmsgEx(actor, "��������2#249")
        return
    end
    local cost = cfg.cost
    local name, num = Player.checkItemNumByTable(actor, cost)
    if name then
        Player.sendmsgEx(actor, string.format("�ϳ�ʧ��,���|%s#249|����|%d#249", name, num))
        return
    end
    if not Bag.checkBagEmptyNum(actor, 5) then
        Player.sendmsgEx(actor, "��ı������Ӳ���,��������5���ո�!#249")
        stop(actor)
        return
    end
    Player.takeItemByTable(actor, cost, "��װ�ϳ�")
    Player.giveItemByTable(actor, cfg.give, "��װ�ϳ�", 1, true)
    Player.sendmsgEx(actor, string.format("��ϲ��,�ɹ��ϳ�[%s]", cfg.give[1][1]))
    HunZhuangHeCheng.SyncResponse(actor)
end

--ͬ����Ϣ
function HunZhuangHeCheng.SyncResponse(actor)
    Message.sendmsg(actor, ssrNetMsgCfg.HunZhuangHeCheng_SyncResponse, 0, 0, 0, {})
end
-- --��¼����
-- local function _onLoginEnd(actor, logindatas)
--     HunZhuangHeCheng.SyncResponse(actor, logindatas)
-- end
-- --�¼��ɷ�
-- GameEvent.add(EventCfg.onLoginEnd, _onLoginEnd, HunZhuangHeCheng)
--ע��������Ϣ
Message.RegisterNetMsg(ssrNetMsgCfg.HunZhuangHeCheng, HunZhuangHeCheng)
return HunZhuangHeCheng

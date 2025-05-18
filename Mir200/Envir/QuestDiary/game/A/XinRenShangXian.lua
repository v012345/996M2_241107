local XinRenShangXian = {}
local cfg_ShangXianBuGuai = include("QuestDiary/cfgcsv/cfg_ShangXianBuGuai.lua") --��������
local function _onNewHuman(actor)
    Message.sendmsg(actor, ssrNetMsgCfg.XinRenShangXian_SyncResponse)
    for _, value in ipairs(cfg_ShangXianBuGuai) do
        local monID = getdbmonfieldvalue(value.name, "idx")
        local monNum = getmoncount("��Դ��", monID, true)
        if monNum <= value.minNum then
            genmon("��Դ��", value.x, value.y, value.name, value.range, value.num, value.color)
        end
    end
end
GameEvent.add(EventCfg.onNewHuman, _onNewHuman, XinRenShangXian)
local function _onClicknpc(actor, npcid, npcobj)
    if npcid == 3004 then
        local monNum = getmoncount("��ľ��", -1, true)
        if monNum < 200 then
            genmon("��ľ��", 165, 115, "��ľ��", 150, 100, 213)
            genmon("��ľ��", 165, 115, "��ľ��", 150, 100, 213)
            genmon("��ľ��", 165, 115, "С����", 150, 100, 213)
        end
    end
end
GameEvent.add(EventCfg.onClicknpc, _onClicknpc, XinRenShangXian)
--ע��������Ϣ
Message.RegisterNetMsg(ssrNetMsgCfg.XinRenShangXian, XinRenShangXian)
return XinRenShangXian

local XinRenShangXian = {}
local cfg_ShangXianBuGuai = include("QuestDiary/cfgcsv/cfg_ShangXianBuGuai.lua") --任务配置
local function _onNewHuman(actor)
    Message.sendmsg(actor, ssrNetMsgCfg.XinRenShangXian_SyncResponse)
    for _, value in ipairs(cfg_ShangXianBuGuai) do
        local monID = getdbmonfieldvalue(value.name, "idx")
        local monNum = getmoncount("起源村", monID, true)
        if monNum <= value.minNum then
            genmon("起源村", value.x, value.y, value.name, value.range, value.num, value.color)
        end
    end
end
GameEvent.add(EventCfg.onNewHuman, _onNewHuman, XinRenShangXian)
local function _onClicknpc(actor, npcid, npcobj)
    if npcid == 3004 then
        local monNum = getmoncount("仙木林", -1, true)
        if monNum < 200 then
            genmon("仙木林", 165, 115, "桃木灵", 150, 100, 213)
            genmon("仙木林", 165, 115, "樟木灵", 150, 100, 213)
            genmon("仙木林", 165, 115, "小树精", 150, 100, 213)
        end
    end
end
GameEvent.add(EventCfg.onClicknpc, _onClicknpc, XinRenShangXian)
--注册网络消息
Message.RegisterNetMsg(ssrNetMsgCfg.XinRenShangXian, XinRenShangXian)
return XinRenShangXian

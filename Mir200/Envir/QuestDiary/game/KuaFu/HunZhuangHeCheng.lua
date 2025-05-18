local HunZhuangHeCheng = {}
HunZhuangHeCheng.ID = "混装合成"
local cfg_HunZhuang_WuQi = include("QuestDiary/cfgcsv/cfg_HunZhuang_WuQi.lua")
local cfg_HunZhuang_YiFu = include("QuestDiary/cfgcsv/cfg_HunZhuang_YiFu.lua")
local cfg_HunZhuang_TouKui = include("QuestDiary/cfgcsv/cfg_HunZhuang_TouKui.lua")
local cfg_HunZhuang_XiangLian = include("QuestDiary/cfgcsv/cfg_HunZhuang_XiangLian.lua")
local cfg_HunZhuang_ShouZhuo = include("QuestDiary/cfgcsv/cfg_HunZhuang_ShouZhuo.lua")
local cfg_HunZhuang_ZhiHuan = include("QuestDiary/cfgcsv/cfg_HunZhuang_ZhiHuan.lua")
local config = {
    { pos = 101, config = cfg_HunZhuang_WuQi, name = "魂装武器" },
    { pos = 102, config = cfg_HunZhuang_YiFu, name = "魂装衣服" },
    { pos = 103, config = cfg_HunZhuang_TouKui, name = "魂装头盔" },
    { pos = 104, config = cfg_HunZhuang_XiangLian, name = "魂装项链" },
    { pos = 105, config = cfg_HunZhuang_ShouZhuo, name = "魂装手镯" },
    { pos = 106, config = cfg_HunZhuang_ZhiHuan, name = "魂装指环" }
}
--接收请求
function HunZhuangHeCheng.Request(actor, parentIndex, childIndex)
    local config = config[parentIndex]
    if not config then
        Player.sendmsgEx(actor, "参数错误1#249")
        return
    end
    local cfg = config.config[childIndex]
    if not cfg then
        Player.sendmsgEx(actor, "参数错误2#249")
        return
    end
    local cost = cfg.cost
    local name, num = Player.checkItemNumByTable(actor, cost)
    if name then
        Player.sendmsgEx(actor, string.format("合成失败,你的|%s#249|不足|%d#249", name, num))
        return
    end
    if not Bag.checkBagEmptyNum(actor, 5) then
        Player.sendmsgEx(actor, "你的背包格子不足,至少留出5个空格!#249")
        stop(actor)
        return
    end
    Player.takeItemByTable(actor, cost, "混装合成")
    Player.giveItemByTable(actor, cfg.give, "混装合成", 1, true)
    Player.sendmsgEx(actor, string.format("恭喜你,成功合成[%s]", cfg.give[1][1]))
    HunZhuangHeCheng.SyncResponse(actor)
end

--同步消息
function HunZhuangHeCheng.SyncResponse(actor)
    Message.sendmsg(actor, ssrNetMsgCfg.HunZhuangHeCheng_SyncResponse, 0, 0, 0, {})
end
-- --登录触发
-- local function _onLoginEnd(actor, logindatas)
--     HunZhuangHeCheng.SyncResponse(actor, logindatas)
-- end
-- --事件派发
-- GameEvent.add(EventCfg.onLoginEnd, _onLoginEnd, HunZhuangHeCheng)
--注册网络消息
Message.RegisterNetMsg(ssrNetMsgCfg.HunZhuangHeCheng, HunZhuangHeCheng)
return HunZhuangHeCheng

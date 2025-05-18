local HunYuanFaXiang = {}
HunYuanFaXiang.ID = "混元法相"
local npcID = 819
--local config = include("QuestDiary/cfgcsv/cfg_HunYuanFaXiang.lua") --配置
local cost = { { "天尊令", 400 }, { "造化结晶", 488 }, { "灵符", 8888 } }
local give = { { "ζ聖●法相天地ζ", 1 } }
local buffFlagMaps = {
    [31095] = VarCfg["F_风之法相"],
    [31096] = VarCfg["F_火之法相"],
    [31097] = VarCfg["F_水之法相"],
    [31098] = VarCfg["F_土之法相"],
}
-- 雷隐强化
-- 炽热强化
-- 碧波强化
-- 落岩强化
local list = {"雷隐强化","炽热强化","碧波强化","落岩强化"}
--接收请求
function HunYuanFaXiang.Request(actor)
    local itemobj = linkbodyitem(actor, 21)
    local equipName = getiteminfo(actor, itemobj, ConstCfg.iteminfo.name)
    if equipName ~= "ζ法相天地ζ" then
        Player.sendmsgEx(actor, string.format("提示：#251|你身上没有穿戴|%s#249|无法强化!"))
        return
    end
    local name, num = Player.checkItemNumByTable(actor, cost)
    if name then
        Player.sendmsgEx(actor, string.format("你的|%s#249|不足|%d#249", name, num))
        return
    end
    if not Bag.checkBagEmptyNum(actor, 5) then
        Player.sendmsgEx(actor, "你的背包格子不足,至少留出5个空格!#249")
        stop(actor)
        return
    end
    for index, value in ipairs(list) do
        local values = Item.getEquipCustomAttrValue(actor, 21, index)
        local cusotmAttrValue = values[1] or 0
        if cusotmAttrValue < 20 then
            Player.sendmsgEx(actor, string.format("觉醒失败,你的|%s#249|强化次数不足|%d#249", value, 20))
            return
        end
    end
    Player.takeItemByTable(actor, cost, "混元法相")
    takew(actor, "ζ法相天地ζ", 1)
    --删除一次buff
    delbuff(actor,31094)
    for key, value in pairs(buffFlagMaps) do
        delbuff(actor,key)
    end
    Player.giveItemByTable(actor, give, "混元法相")
    Player.sendmsgEx(actor, "恭喜你觉醒成功!")
    HunYuanFaXiang.SyncResponse(actor)
end

--同步消息
function HunYuanFaXiang.SyncResponse(actor)
    local data = {}
    Message.sendmsg(actor, ssrNetMsgCfg.HunYuanFaXiang_SyncResponse, 0, 0, 0, data)
end
-- --登录触发
-- local function _onLoginEnd(actor, logindatas)
--     HunYuanFaXiang.SyncResponse(actor, logindatas)
-- end
-- --事件派发
-- GameEvent.add(EventCfg.onLoginEnd, _onLoginEnd, HunYuanFaXiang)
--注册网络消息
Message.RegisterNetMsg(ssrNetMsgCfg.HunYuanFaXiang, HunYuanFaXiang)
return HunYuanFaXiang

local GuLongDeChuanCheng = {}
GuLongDeChuanCheng.ID = "古龙的传承"
local npcID = 236
local cost = { { "古龙的传承", 1 } }
-- local config = include("QuestDiary/cfgcsv/cfg_GuLongDeChuanCheng.lua") --配置
--接收请求
function GuLongDeChuanCheng.Request(actor)
    if not FCheckNPCRange(actor, npcID, 15) then
        Player.sendmsgEx(actor, "距离PNC太远!#249")
        return
    end
    local numCount = getplaydef(actor, VarCfg["U_剧情_古龙的传承"])
    if numCount >= 5 then
        Player.sendmsgEx(actor, string.format("提交失败,最多只能提交|%d#249|次", 5))
        return
    end
    local name, num = Player.checkItemNumByTable(actor, cost)
    if name then
        Player.sendmsgEx(actor, string.format("提交失败,你的|%s#249|不足|%d#249", name, num))
        return
    end
    Player.takeItemByTable(actor, cost, "古龙的传承")
    setplaydef(actor, VarCfg["U_剧情_古龙的传承"], numCount + 1)
    Player.setAttList(actor, "属性附加")
    GuLongDeChuanCheng.SyncResponse(actor)
end
--同步消息
function GuLongDeChuanCheng.SyncResponse(actor)
    local data = {}
    local numCount = getplaydef(actor, VarCfg["U_剧情_古龙的传承"])
    Message.sendmsg(actor, ssrNetMsgCfg.GuLongDeChuanCheng_SyncResponse, numCount, 0, 0, data)
end
--附加属性
local function _onCalcAttr(actor, attrs)
    local shuxing = {}
    -- for _, value in ipairs(config) do
    --     local currLevel = getplaydef(actor, value.bindVar)
    --     if currLevel > 0 then
    --         shuxing[value.attrID] = currLevel
    --     end
    -- end
    local numCount = getplaydef(actor, VarCfg["U_剧情_古龙的传承"])
    if numCount > 0 then
        shuxing[206] = numCount * 1  --最大攻击力
        shuxing[207] = numCount * 1  --最大生命值
        shuxing[81] = (numCount * 1) * 100 --对怪吸血
        calcAtts(attrs, shuxing, "古龙的传承")
    end
end
--属性
GameEvent.add(EventCfg.onCalcAttr, _onCalcAttr, GuLongDeChuanCheng)
--注册网络消息
Message.RegisterNetMsg(ssrNetMsgCfg.GuLongDeChuanCheng, GuLongDeChuanCheng)
return GuLongDeChuanCheng
--init内容
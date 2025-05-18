local JianLingChuanShuo = {}
JianLingChuanShuo.ID = "剑灵传说"
local npcID = 235
local cost = { { "剑灵之谜", 1 } }
--local config = include("QuestDiary/cfgcsv/cfg_JianLingChuanShuo.lua") --配置
--接收请求
function JianLingChuanShuo.Request(actor)
    if not FCheckNPCRange(actor, npcID, 15) then
        Player.sendmsgEx(actor, "距离PNC太远!#249")
        return
    end
    local numCount = getplaydef(actor, VarCfg["U_剧情_剑灵传说"])
    if numCount >= 10 then
        Player.sendmsgEx(actor, string.format("提交失败,最多只能提交|%d#249|次", 10))
        return
    end
    local name, num = Player.checkItemNumByTable(actor, cost)
    if name then
        Player.sendmsgEx(actor, string.format("提交失败,你的|%s#249|不足|%d#249", name, num))
        return
    end
    Player.takeItemByTable(actor, cost, "剑灵传说")
    setplaydef(actor, VarCfg["U_剧情_剑灵传说"], numCount + 1)
    local itemObj = linkbodyitem(actor, 1)
    if itemObj == "0" then
        Player.sendmsgEx(actor,"你没有穿戴武器!#249")
        return
    end
    local g = getitemaddvalue(actor, itemObj, 1, 2,0)
    local m = getitemaddvalue(actor, itemObj, 1, 3,0)
    local d = getitemaddvalue(actor, itemObj, 1, 4,0)
    setitemaddvalue(actor, itemObj, 1, 2, g + 50)
    setitemaddvalue(actor, itemObj, 1, 3, m + 50)
    setitemaddvalue(actor, itemObj, 1, 4, d + 50)
    refreshitem(actor, itemObj)
    recalcabilitys(actor)
    JianLingChuanShuo.SyncResponse(actor)
end
--穿脱装备在zhuangbeiqianghua
--装备强化
--同步消息
function JianLingChuanShuo.SyncResponse(actor)
    local data = {}
    local numCount = getplaydef(actor, VarCfg["U_剧情_剑灵传说"])
    Message.sendmsg(actor, ssrNetMsgCfg.JianLingChuanShuo_SyncResponse, numCount, 0, 0, data)
end

-- --登录触发
-- local function _onLoginEnd(actor, logindatas)
--     JianLingChuanShuo.SyncResponse(actor, logindatas)
-- end
-- --事件派发
-- GameEvent.add(EventCfg.onLoginEnd, _onLoginEnd, JianLingChuanShuo)
--注册网络消息
Message.RegisterNetMsg(ssrNetMsgCfg.JianLingChuanShuo, JianLingChuanShuo)
return JianLingChuanShuo
--init内容

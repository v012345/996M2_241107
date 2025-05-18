local LunHuiYongJie = {}
LunHuiYongJie.ID = "轮回永劫"
local npcID = 805
local abilGroup = 0
--local config = include("QuestDiary/cfgcsv/cfg_LunHuiYongJie.lua") --配置
local cost = { { "混沌本源", 88 }, { "造化结晶", 88 }, { "元宝", 4880000 } }
local function _getTianMingList(actor)
    local result = {}
    for i = 1, 24 do
        local Tvar = VarCfg["T_天命记录_" .. i]
        if Tvar then
            local value = Player.getJsonTableByVar(actor, Tvar)
            table.insert(result, { Tvar, value })
        end
    end
    return result
end
local function _checkLaiQuZiRu(actor)
    local result = false
    local values = _getTianMingList(actor)
    for _, value in ipairs(values) do
        local datas = json2tbl(value[2])
        if datas[1] == 4 and datas[2] == 35 then
            result = true
            break
        end
    end
    return result
end
local function _getLaiQuZiRuVar(actor)
    local values = _getTianMingList(actor)
    for _, value in ipairs(values) do
        local datas = json2tbl(value[2])
        if datas[1] == 4 and datas[2] == 35 then
            return value[1]
        end
    end
    return nil
end
--接收请求
function LunHuiYongJie.Request(actor)
    local isInRange = FCheckNPCRange(actor, npcID, 15)
    if not isInRange then
        Player.sendmsgEx(actor, "距离太远#249")
        return
    end
    if getflagstatus(actor, VarCfg["F_轮回永劫"]) == 1 then
        Player.sendmsgEx(actor, "你已经吞噬过了!#249")
        return
    end
    local Tvar = _getLaiQuZiRuVar(actor)
    if not Tvar then
        Player.sendmsgEx(actor, "吞噬失败,你没有|圣品气运#243|来去自如#249")
        return
    end
    local itemobj = linkbodyitem(actor, 29)
    local equipName = getiteminfo(actor, itemobj, ConstCfg.iteminfo.name)
    if equipName ~= "「穿梭」时间轮转" then
        Player.sendmsgEx(actor, "吞噬失败,你没有穿戴|「穿梭」时间轮转#249")
        return
    end
    local name, num = Player.checkItemNumByTable(actor, cost)
    if name then
        Player.sendmsgEx(actor, string.format("吞噬失败,你的|%s#249|不足|%d#249", name, num))
        return
    end
    Player.takeItemByTable(actor, cost, "轮回永劫")
    setplaydef(actor, Tvar, "")
    TianMing.clearCache(actor)
    TianMing.setCache(actor)
    changecustomitemtext(actor, itemobj, "[轮回永劫]:", abilGroup)
    changecustomitemtextcolor(actor, itemobj, 252, abilGroup)
    Player.addModifyCustomAttributes(actor, itemobj, abilGroup, 1, 0, 0, 170, 91, 1, 1) --设置属性1
    setflagstatus(actor, VarCfg["F_天命来去自如"], 0)
    setflagstatus(actor, VarCfg["F_轮回永劫"], 1)
    messagebox(actor, "恭喜你获得[永久无视战斗状态,随时脱离战场]圣品气运[来去自如]消失!")
    LunHuiYongJie.SyncResponse(actor)
end

--同步消息
function LunHuiYongJie.SyncResponse(actor)
    local data = {}
    Message.sendmsg(actor, ssrNetMsgCfg.LunHuiYongJie_SyncResponse, 0, 0, 0, data)
end
-- --登录触发
-- local function _onLoginEnd(actor, logindatas)
--     LunHuiYongJie.SyncResponse(actor, logindatas)
-- end
-- --事件派发
-- GameEvent.add(EventCfg.onLoginEnd, _onLoginEnd, LunHuiYongJie)
--注册网络消息
Message.RegisterNetMsg(ssrNetMsgCfg.LunHuiYongJie, LunHuiYongJie)
return LunHuiYongJie

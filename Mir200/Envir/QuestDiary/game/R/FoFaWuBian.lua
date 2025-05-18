local FoFaWuBian = {}
FoFaWuBian.ID = "佛法无边"
local npcID = 506
--local config = include("QuestDiary/cfgcsv/cfg_FoFaWuBian.lua") --配置
local cost = { { "造化结晶", 88 }, { "书页", 2222 } }
local give = { {} }
local skillID1 = 2017
local skillID2 = 2019
--接收请求
function FoFaWuBian.Request(actor)
    if not FCheckNPCRange(actor, npcID, 15) then
        Player.sendmsgEx(actor, "距离PNC太远!#249")
        return
    end
    if getskillinfo(actor, skillID2, 1) then
        Player.sendmsgEx(actor, "你已经学习了大日如来神掌#249")
        return
    end
    if not getskillinfo(actor, skillID1, 1) then
        Player.sendmsgEx(actor, "你没有学习|如来神掌#249|无法学习|大日如来神掌#249|,如来神掌可在|奇遇事件#249|学习")
        return
    end
    local name, num = Player.checkItemNumByTable(actor, cost)
    if name then
        Player.sendmsgEx(actor, string.format("你的|%s#249|不足|%d#249", name, num))
        return
    end
    Player.takeItemByTable(actor, cost, "佛法无边")
    delskill(actor, skillID1)
    addskill(actor, skillID2, 3)
    setflagstatus(actor, VarCfg["F_大日如来神掌_学习"], 1)
    Player.sendmsgEx(actor, "恭喜你学习技能:|大日如来神掌#249")
end

--注册网络消息
local function _onAttack(actor, Target, Hiter, MagicId)
    if randomex(3, 100) then
        if getskillinfo(actor, skillID2, 1) then
            local x = getbaseinfo(Target, ConstCfg.gbase.x)
            local y = getbaseinfo(Target, ConstCfg.gbase.y)
            rangeharm(actor, x, y, 0, 0, 6, Player.getHpValue(Target, 2), 0, 2,63105)
        end
    end
end
GameEvent.add(EventCfg.onAttack, _onAttack, FoFaWuBian)
Message.RegisterNetMsg(ssrNetMsgCfg.FoFaWuBian, FoFaWuBian)
return FoFaWuBian

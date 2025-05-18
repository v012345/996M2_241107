local ZuLongMiBao = {}
ZuLongMiBao.ID = "祖龙秘宝"
local npcID = 328
--local config = include("QuestDiary/cfgcsv/cfg_ZuLongMiBao.lua") --配置
local cost = { { "龙之逆鳞", 88 }, { "元宝", 3000000 } }
local give = { { "[龍器]祖龍號角", 1 } }
--接收请求
function ZuLongMiBao.Request(actor)
    if not FCheckNPCRange(actor, npcID, 15) then
        Player.sendmsgEx(actor, "距离PNC太远!#249")
        return
    end
    local name, num = Player.checkItemNumByTable(actor, cost)
    if name then
        Player.sendmsgEx(actor, string.format("你的|%s#249|不足|%d#249", name, num))
        return
    end
    Player.takeItemByTable(actor, cost, "祖龙秘宝剧情")
    Player.giveItemByTable(actor, give, "祖龙秘宝剧情")
    setflagstatus(actor,VarCfg["F_[龍器]祖龍號角_完成"],1)
    Player.sendmsgEx(actor, "你成功打造了|[龍器]祖龍號角#249|")
end

--同步消息
-- function ZuLongMiBao.SyncResponse(actor, logindatas)
--     local data = {}
--     local _login_data = {ssrNetMsgCfg.ZuLongMiBao_SyncResponse, 0, 0, 0, data}
--     if logindatas then
--         table.insert(logindatas, _login_data)
--     else
--         Message.sendmsg(actor, ssrNetMsgCfg.ZuLongMiBao_SyncResponse, 0, 0, 0, data)
--     end
-- end
-- --登录触发
-- local function _onLoginEnd(actor, logindatas)
--     ZuLongMiBao.SyncResponse(actor, logindatas)
-- end
-- --事件派发
-- GameEvent.add(EventCfg.onLoginEnd, _onLoginEnd, ZuLongMiBao)
--注册网络消息

-- [龍器]祖龍號角

--攻击触发
local function _onAttack(actor, Target, Hiter, MagicId)
    if not checkitemw(actor, "[龍器]祖龍號角", 1) then
        return
    end
    --攻击怪物
    if getbaseinfo(Target, -1) == false then
        if Player.canLifesteal(actor) then
            local perHp = Player.getHpValue(actor, 1)
            humanhp(actor, "+", perHp, 4)
        end
        --攻击人
    else
        local perHp = Player.getHpValue(Target, 1)
        humanhp(Target, "-", perHp, 1, 0, actor)
    end
    if randomex(5,1000) then
        recallmob(actor,"龙之守护",1,1)
    end
end
GameEvent.add(EventCfg.onAttack, _onAttack, ZuLongMiBao)
local function _onKillMon(actor, monobj, monName)
    local num = getplaydef(actor, VarCfg["U_龙之守护击杀_数量"])
    if num < 10 then
        local name = monName
        if name == "龙之守护" then
            setplaydef(actor, VarCfg["U_龙之守护击杀_数量"],num+1)
        end
    end
end

GameEvent.add(EventCfg.onKillMon, _onKillMon, ZuLongMiBao)
Message.RegisterNetMsg(ssrNetMsgCfg.ZuLongMiBao, ZuLongMiBao)
return ZuLongMiBao

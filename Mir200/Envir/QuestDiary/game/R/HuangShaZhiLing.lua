local HuangShaZhiLing = {}
HuangShaZhiLing.ID = "黄沙之灵"
local npcID = 322
--local config = include("QuestDiary/cfgcsv/cfg_HuangShaZhiLing.lua") --配置
local cost = { { "流金沙砾", 10 }, { "天工之锤", 1888 } }
local give = { { "[風魂]黃沙之靈", 1 } }
--接收请求
function HuangShaZhiLing.Request(actor)
    if not FCheckNPCRange(actor, npcID, 15) then
        Player.sendmsgEx(actor, "距离PNC太远!#249")
        return
    end
    local name, num = Player.checkItemNumByTable(actor, cost)
    if name then
        Player.sendmsgEx(actor, string.format("打造失败,你的|%s#249|不足|%d#249", name, num))
        return
    end
    if not Bag.checkBagEmptyNum(actor, 5) then
        Player.sendmsgEx(actor, "你的背包格子不足,至少留出5个空格!#249")
        stop(actor)
    end
    Player.takeItemByTable(actor, cost, "黄沙之灵")
    Player.giveItemByTable(actor, give, "黄沙之灵", 1, true)
    FSetTaskRedPoint(actor, VarCfg["F_黄沙之灵_完成"], 22)
    Player.sendmsgEx(actor, "提示：#251|你成功打造了|[風魂]黃沙之靈#249")
    HuangShaZhiLing.SyncResponse(actor)
end

--同步消息
function HuangShaZhiLing.SyncResponse(actor)
    local data = {}
    Message.sendmsg(actor, ssrNetMsgCfg.HuangShaZhiLing_SyncResponse, 0, 0, 0, data)
end

-- --登录触发
-- local function _onLoginEnd(actor, logindatas)
--     HuangShaZhiLing.SyncResponse(actor, logindatas)
-- end
-- --事件派发
-- GameEvent.add(EventCfg.onLoginEnd, _onLoginEnd, HuangShaZhiLing)
--杀怪触发
local function _onKillMon(actor, monobj, monName)
    if monName == "怨灵之体" then
        if randomex(10) then
            local mapID = getbaseinfo(actor, ConstCfg.gbase.mapid)
            local x, y = getbaseinfo(monobj, ConstCfg.gbase.x), getbaseinfo(monobj, ConstCfg.gbase.y)
            genmon(mapID, x, y, "狂沙之魂", 0, 1, 249)
            Player.sendmsgEx(actor, "你杀死了|怨灵之体#255|，召唤了|狂沙之魂#249")
        end
    end
end
GameEvent.add(EventCfg.onKillMon, _onKillMon, HuangShaZhiLing)
--攻击怪物触发
local function _onAttackMonster(actor, Target, Hiter, MagicId, qieGe)
    if randomex(5) then
        if checkitemw(actor, "[風魂]黃沙之靈", 1) or checkitemw(actor, "飓风之灵", 1) then
            local attackNum = getbaseinfo(actor, ConstCfg.gbase.custom_attr, 4)
            local damage = math.floor(attackNum * 1.2)
            local cfg_posM = {}
            cfg_posM[1] = getbaseinfo(Target, 2)
            local mapID = getbaseinfo(actor, 3)
            local x = getbaseinfo(actor, 4)
            local y = getbaseinfo(actor, 5)
            local mons = getobjectinmap(mapID, x, y, 3, 2)
            if #mons < 1 then return end
            for i, mon in ipairs(mons or {}) do
                if i >= 10 then
                    break
                end
                if Target ~= mon then
                    cfg_posM[#cfg_posM + 1] = getbaseinfo(mon, 2)
                    local mobName = getbaseinfo(mon, ConstCfg.gbase.name)
                    local race = getdbmonfieldvalue(mobName, "race")
                    if race ~= 250 then
                        humanhp(mon, "-", damage, 1, 0.3 * i, actor)
                    end
                end
            end
            Message.sendmsg(actor, ssrNetMsgCfg.HuangShaZhiLing_ScenePlayEffectEx, 0, 0, 0, cfg_posM)
        end
    end
end
GameEvent.add(EventCfg.onAttackMonster, _onAttackMonster, HuangShaZhiLing)
--注册网络消息
Message.RegisterNetMsg(ssrNetMsgCfg.HuangShaZhiLing, HuangShaZhiLing)
return HuangShaZhiLing

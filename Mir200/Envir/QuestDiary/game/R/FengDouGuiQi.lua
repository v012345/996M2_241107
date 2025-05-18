local FengDouGuiQi = {}
FengDouGuiQi.ID = "酆都鬼器"
local npcID = 449
local config = include("QuestDiary/cfgcsv/cfg_FengDouGuiQi.lua") --配置
local cost = { { "锁魂咒", 1 }, { "降魔杵", 1 } }
local give = { { "锁魂幡", 1 } }
local abilGroup = 0
--接收请求
function FengDouGuiQi.Request(actor)
    local name, num = Player.checkItemNumByTable(actor, cost)
    if name then
        Player.sendmsgEx(actor, string.format("你的|%s#249|不足|%d#249", name, num))
        return
    end
    Player.takeItemByTable(actor, cost, "酆都鬼器")
    Player.giveItemByTable(actor, give, "酆都鬼器", 1, true)
    setflagstatus(actor, VarCfg["F_锁魂幡_完成"], 1)
    Player.sendmsgEx(actor, "恭喜你成功合成|锁魂幡#249")
end

--同步消息
-- function FengDouGuiQi.SyncResponse(actor, logindatas)
--     local data = {}
--     local _login_data = {ssrNetMsgCfg.FengDouGuiQi_SyncResponse, 0, 0, 0, data}
--     if logindatas then
--         table.insert(logindatas, _login_data)
--     else
--         Message.sendmsg(actor, ssrNetMsgCfg.FengDouGuiQi_SyncResponse, 0, 0, 0, data)
--     end
-- end
-- --登录触发
-- local function _onLoginEnd(actor, logindatas)
--     FengDouGuiQi.SyncResponse(actor, logindatas)
-- end
-- --事件派发
-- GameEvent.add(EventCfg.onLoginEnd, _onLoginEnd, FengDouGuiQi)
--杀怪触发
local function _onKillMon(actor, monobj, monName)
    if checkitemw(actor, "锁魂幡", 1) then
        local cfg = config[monName]
        if cfg then
            local itemobj = FFindEquipObj(actor, "锁魂幡")
            if not itemobj then
                return
            end
            changecustomitemtext(actor, itemobj, "<IMG:res/tips/5.png>", abilGroup)
            local atts = Player.getAllModifyCustomAttributes(actor, itemobj, abilGroup + 1)
            if cfg.type == 1 then
                local attrId = cfg.attr1[1]
                local currIndex = cfg.attr1[2]
                local currValue = atts[currIndex] or 0
                if currValue >= cfg.max then
                    return
                end
                local isPer = cfg.attr1[3]
                local attrValue = cfg.addNum + currValue
                Player.addModifyCustomAttributes(actor, itemobj, abilGroup, currIndex, 1, 250, attrId, 0, isPer,
                    attrValue)
                local attrId2 = cfg.attr2[1]
                local currIndex2 = cfg.attr2[2]
                local isPer2 = cfg.attr2[3]
                local attrValue2 = math.floor((currValue / cfg.ratio)) * cfg.ratioNum
                if attrValue2 > 0 then
                    Player.addModifyCustomAttributes(actor, itemobj, abilGroup, currIndex2, 1, 250, attrId2, 0, isPer2,
                        attrValue2)
                end
            else
                if randomex(cfg.random) then
                    local attrId = cfg.attr1[1]
                    local currIndex = cfg.attr1[2]
                    local currValue = atts[currIndex] or 0
                    if currValue >= cfg.max then
                        return
                    end
                    local isPer = cfg.attr1[3]
                    local attrValue = cfg.addNum + currValue
                    Player.addModifyCustomAttributes(actor, itemobj, abilGroup, currIndex, 0, 250, cfg.attrOther, attrId,
                        isPer, attrValue)
                    -- release_print("当前攻速", attrValue)
                    setplaydef(actor, VarCfg["U_剧情_锁魂幡_攻速"], attrValue)
                    Player.setAttList(actor, "攻速附加")
                end
            end
        end
    end
end
GameEvent.add(EventCfg.onKillMon, _onKillMon, FengDouGuiQi)

--穿装备
local function _onTakeOnEx(actor, itemobj, where, itemname, makeid)
    if itemname == "锁魂幡" then
        Player.setAttList(actor, "攻速附加")
    end
end
GameEvent.add(EventCfg.onTakeOnEx, _onTakeOnEx, FengDouGuiQi)
--脱装备
local function _onTakeOffEx(actor, itemobj, where, itemname, makeid)
    if itemname == "锁魂幡" then
        Player.setAttList(actor, "攻速附加")
    end
end
GameEvent.add(EventCfg.onTakeOffEx, _onTakeOffEx, FengDouGuiQi)

local function _onCalcAttackSpeed(actor, attackSpeeds)
    if checkitemw(actor, "锁魂幡", 1) then
        local count = getplaydef(actor, VarCfg["U_剧情_锁魂幡_攻速"])
        local gongSu = count
        attackSpeeds[1] = attackSpeeds[1] + gongSu
    end
end
--攻速属性
GameEvent.add(EventCfg.onCalcAttackSpeed, _onCalcAttackSpeed, FengDouGuiQi)

--注册网络消息
Message.RegisterNetMsg(ssrNetMsgCfg.FengDouGuiQi, FengDouGuiQi)
return FengDouGuiQi

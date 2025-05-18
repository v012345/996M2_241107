local DiZangWangDeShiLian = {}
local config = include("QuestDiary/cfgcsv/cfg_DiZangWangDeShiLian.lua") --配置

local shiLianFunc = {
    [1] = function(actor)
        local myName = getbaseinfo(actor, ConstCfg.gbase.name)
        local oldMapId = getbaseinfo(actor, ConstCfg.gbase.mapid)
        local x = getbaseinfo(actor, ConstCfg.gbase.x)
        local y = getbaseinfo(actor, ConstCfg.gbase.y)
        local newMapId = myName .. "伤害试炼"
        if oldMapId ~= "酆都" then
            Player.sendmsgEx(actor, "fuck you.#249")
            return
        end
        if checkmirrormap(newMapId) then
            delmirrormap(newMapId)
        end
        addmirrormap("02778", newMapId, "地藏王的试炼", 15, oldMapId, 10056, x, y)
        genmon(newMapId, 55, 55, "地藏王的木人桩", 1, 1, 250)
        mapmove(actor, newMapId, 53, 56, 0)
        --给地藏王标识
        setplaydef(actor, VarCfg["M_地藏王标识"], 1)
        setplaydef(actor, VarCfg["B_地藏王第一层伤害记录"], 0)
    end,
    --生存试炼
    [2] = function(actor)
        local time = 100
        local myName = getbaseinfo(actor, ConstCfg.gbase.name)
        local oldMapId = getbaseinfo(actor, ConstCfg.gbase.mapid)
        local x = getbaseinfo(actor, ConstCfg.gbase.x)
        local y = getbaseinfo(actor, ConstCfg.gbase.y)
        local newMapId = myName .. "生存试炼"
        if oldMapId ~= "酆都" then
            Player.sendmsgEx(actor, "fuck you.#249")
            return
        end
        if checkmirrormap(newMapId) then
            delmirrormap(newMapId)
        end
        addmirrormap("06017", newMapId, "地藏王的试炼", time, oldMapId, 15020, x, y)
        mapmove(actor, newMapId, 193, 180, 0)
        --给地藏王标识
        setplaydef(actor, VarCfg["M_地藏王标识"], 2)
        --创建NPC
        local npcInfo = {
            ["Idx"] = ConstCfg.customNpc["生存试炼"],
            ["npcname"] = "完成生存试炼", -- NPC名称
            ["appr"] = 1072, -- NPC外形效果
            ["script"] = '生存试炼',
            ["limit"] = time,
        }
        createnpc(newMapId, 34, 20, tbl2json(npcInfo))
    end,
    --心魔试炼
    [3] = function(actor)
        local time = 180
        local myName = getbaseinfo(actor, ConstCfg.gbase.name)
        local oldMapId = getbaseinfo(actor, ConstCfg.gbase.mapid)
        local x = getbaseinfo(actor, ConstCfg.gbase.x)
        local y = getbaseinfo(actor, ConstCfg.gbase.y)
        local newMapId = myName .. "心魔试炼"
        if oldMapId ~= "酆都" then
            Player.sendmsgEx(actor, "fuck you.#249")
            return
        end
        if checkmirrormap(newMapId) then
            delmirrormap(newMapId)
        end
        addmirrormap("02758", newMapId, "地藏王的试炼", time, oldMapId, 10052, x, y)
        mapmove(actor, newMapId, 44, 36, 0)
        setplaydef(actor, VarCfg["M_地藏王标识"], 3)
        Player.cloneSelfToHumanoid(actor, newMapId, 44, 36, myName .. "的心魔", "心魔", 2, 249, 100)
    end,
    [4] = function(actor)
        local time = 600
        local myName = getbaseinfo(actor, ConstCfg.gbase.name)
        local oldMapId = getbaseinfo(actor, ConstCfg.gbase.mapid)
        local x = getbaseinfo(actor, ConstCfg.gbase.x)
        local y = getbaseinfo(actor, ConstCfg.gbase.y)
        local newMapId = myName .. "献祭试炼"
        if oldMapId ~= "酆都" then
            Player.sendmsgEx(actor, "fuck you.#249")
            return
        end
        if checkmirrormap(newMapId) then
            delmirrormap(newMapId)
        end
        addmirrormap("02758", newMapId, "地藏王的试炼", time, oldMapId, 10052, x, y)
        mapmove(actor, newMapId, 44, 36, 0)
        setplaydef(actor, VarCfg["M_地藏王标识"], 4)
        --创建NPC
        local npcInfo = {
            ["Idx"] = ConstCfg.customNpc["献祭试炼"],
            ["npcname"] = "献祭试炼", -- NPC名称
            ["appr"] = 1329, -- NPC外形效果
            ["script"] = '献祭试炼',
            ["limit"] = time,
        }
        createnpc(newMapId, 43, 35, tbl2json(npcInfo))
    end,
    [5] = function(actor)
        local time = 1800
        local myName = getbaseinfo(actor, ConstCfg.gbase.name)
        local oldMapId = getbaseinfo(actor, ConstCfg.gbase.mapid)
        local x = getbaseinfo(actor, ConstCfg.gbase.x)
        local y = getbaseinfo(actor, ConstCfg.gbase.y)
        local newMapId = myName .. "最终试炼"
        if oldMapId ~= "酆都" then
            Player.sendmsgEx(actor, "fuck you.#249")
            return
        end
        if checkmirrormap(newMapId) then
            delmirrormap(newMapId)
        end
        addmirrormap("06019", newMapId, "地藏王的试炼", time, oldMapId, 010117, x, y)
        mapmove(actor, newMapId, 27, 27, 0)
        genmon(newMapId, 31, 26, "无双赤鬼昆克[无间炼狱]", 1, 1, 249)
        setplaydef(actor, VarCfg["M_地藏王标识"], 5)
    end
}

function DiZangWangDeShiLian.Request(actor)
    local layerNum = getplaydef(actor, VarCfg["U_地藏王的试炼"])
    local currLayerNum = layerNum + 1
    local func = shiLianFunc[currLayerNum]
    if not func then
        Player.sendmsgEx(actor, "进入试炼失败,你已经完成了所有试炼!#249")
        return
    end
    local cfg = config[currLayerNum]
    if not cfg then
        Player.sendmsgEx(actor, "参数错误!!!#249")
        return
    end
    local name, num = Player.checkItemNumByTable(actor, cfg.cost)
    if name then
        Player.sendmsgEx(actor, string.format("你的|%s#249|不足|%s#249", name, num))
        return
    end
    Player.takeItemByTable(actor, cfg.cost, "地藏王的试炼")
    func(actor)
end

--注册网络消息
Message.RegisterNetMsg(ssrNetMsgCfg.DiZangWangDeShiLian, DiZangWangDeShiLian)

--同步数据
function DiZangWangDeShiLian.SyncResponse(actor, logindatas, data)
    local data = {}
    local layer = getplaydef(actor, VarCfg["U_地藏王的试炼"])
    local _login_data = { ssrNetMsgCfg.DiZangWangDeShiLian_SyncResponse, layer, 0, 0, data }
    if logindatas then
        table.insert(logindatas, _login_data)
    else
        Message.sendmsg(actor, ssrNetMsgCfg.DiZangWangDeShiLian_SyncResponse, layer, 0, 0, data)
    end
end

--登录触发
local function _onLoginEnd(actor, logindatas)
    DiZangWangDeShiLian.SyncResponse(actor, logindatas)
end
GameEvent.add(EventCfg.onLoginEnd, _onLoginEnd, DiZangWangDeShiLian)

-- 被玩家攻击前触发  地藏王的试炼： 技能伤害减免+10%
local function _onStruckDamagePlayer(actor, Target, Hiter, MagicId, Damage, attackDamageData)
    if not checktitle(actor, "地藏王的试炼") then return end
    if MagicId == 26 or MagicId == 66 or MagicId == 56 then
        attackDamageData.damage = attackDamageData.damage - Damage *0.1
    end
end
GameEvent.add(EventCfg.onStruckDamagePlayer, _onStruckDamagePlayer, DiZangWangDeShiLian)


--切换地图触发
local function _goSwitchMap(actor, cur_mapid, former_mapid)
    local myName = getbaseinfo(actor, ConstCfg.gbase.name)
    local layer1MapId = myName .. "伤害试炼"
    local layer2MapId = myName .. "生存试炼"
    local layer3MapId = myName .. "心魔试炼"
    local layer4MapId = myName .. "献祭试炼"
    local layer5MapId = myName .. "最终试炼"
    if former_mapid == layer1MapId or former_mapid == layer2MapId or former_mapid == layer3MapId or former_mapid == layer4MapId or former_mapid == layer5MapId then
        if former_mapid == layer2MapId then
            delnpc("完成生存试炼", former_mapid)
        elseif former_mapid == layer4MapId then
            delnpc("献祭试炼", former_mapid)
        elseif former_mapid == layer5MapId then
            local myName = getbaseinfo(actor, ConstCfg.gbase.name)
            if cur_mapid ~= myName .. "地藏王的秘密世界" then
                Message.sendmsg(actor, ssrNetMsgCfg.DiZangWangDeShiLian_SyncResponseLayer2End, 4, 0)
            end
            delnpc("最终试炼[隐藏地图]", former_mapid)
        end
        delmirrormap(former_mapid)
    end
end
GameEvent.add(EventCfg.goSwitchMap, _goSwitchMap, DiZangWangDeShiLian)

--攻击怪物前触发
local function _onAttackDamageMonster(actor, Target, Hiter, MagicId, Damage, Model, attackDamageData)
    local layer1Flag = getplaydef(actor, VarCfg["M_地藏王标识"])
    if layer1Flag == 1 then
        local damageRecord = getplaydef(actor, VarCfg["B_地藏王第一层伤害记录"])
        damageRecord = damageRecord + Damage
        setplaydef(actor, VarCfg["B_地藏王第一层伤害记录"], damageRecord)
        Message.sendmsg(actor, ssrNetMsgCfg.DiZangWangDeShiLian_SyncResponseDamage, 0, 0, 0, { damageRecord })
        if damageRecord > 200000000 then
            setplaydef(actor, VarCfg["M_地藏王标识"], 0)
            setplaydef(actor, VarCfg["U_地藏王的试炼"], 1)
            local myName = getbaseinfo(actor, ConstCfg.gbase.name)
            local newMapId = myName .. "伤害试炼"
            delmirrormap(newMapId)
            DiZangWangDeShiLian.SyncResponse(actor)
        end
    end
end
GameEvent.add(EventCfg.onAttackDamageMonster, _onAttackDamageMonster, DiZangWangDeShiLian)

local function _onKillMon(actor, monobj, monName)
    local layerFlag = getplaydef(actor, VarCfg["M_地藏王标识"])
    if layerFlag == 3 then
        local mapId = getbaseinfo(actor, ConstCfg.gbase.mapid)
        local mobNum = getmoncount(mapId, -1, true)
        if mobNum < 1 then
            delmirrormap(mapId)
            setplaydef(actor, VarCfg["U_地藏王的试炼"], 3)
            Message.sendmsg(actor, ssrNetMsgCfg.DiZangWangDeShiLian_SyncResponse, 3, 1)
        end
    elseif layerFlag == 5 then
        local mobName = monName
        if mobName == "无双赤鬼昆克[无间炼狱]" then
            setplaydef(actor, VarCfg["U_地藏王的试炼"], 5)
            setplaydef(actor, VarCfg["M_地藏王标识"], 0)
            Message.sendmsg(actor, ssrNetMsgCfg.DiZangWangDeShiLian_SyncResponseLayer2End, 5, 1)
            messagebox(actor, "恭喜你通过全部试炼,获得称号[地藏王的试炼],在本地图30,30刷新了一个进入隐藏地图的NPC!")
            local npcInfo = {
                ["Idx"] = ConstCfg.customNpc["最终试炼"],
                ["npcname"] = "最终试炼[隐藏地图]", -- NPC名称
                ["appr"] = 454, -- NPC外形效果
                ["script"] = '最终试炼',
                ["limit"] = 3000,
            }
            confertitle(actor, "地藏王的试炼")
            local mapId = getbaseinfo(actor, ConstCfg.gbase.mapid)
            createnpc(mapId, 30, 30, tbl2json(npcInfo))
            Player.setAttList(actor,"倍攻附加")
        end
    end
end

GameEvent.add(EventCfg.onKillMon, _onKillMon, DiZangWangDeShiLian)

--死亡触发a
local function _onPlaydie(actor, hiter)
    local mobName = getbaseinfo(hiter, ConstCfg.gbase.name)
    if mobName == "无双赤鬼昆克[无间炼狱]" then
        Message.sendmsg(actor, ssrNetMsgCfg.DiZangWangDeShiLian_SyncResponseLayer2End, 4, 0)
    end
end
GameEvent.add(EventCfg.onPlaydie, _onPlaydie, DiZangWangDeShiLian)

--倍攻触发
local function _onCalcBeiGong(actor, beiGongs)
    local flag = getplaydef(actor, VarCfg["U_地藏王的试炼"])
    if flag > 4 then
        local beigong = 15
        if beigong then
            beiGongs[1] = beiGongs[1] + beigong
        end
    end
end
GameEvent.add(EventCfg.onCalcBeiGong, _onCalcBeiGong, DiZangWangDeShiLian)


return DiZangWangDeShiLian

local HaFaXiSiZhiMu = {}
local mirrorMapId1 = "哈法西斯之墓(一层)"
local mirrorMapId2 = "哈法西斯之墓(二层)"
local monName1 = "炎魔督军·古尔达"
local knights = {
    { "[四骑士]杰兰特", 42, 88 },
    { "[四骑士]加雷斯", 84, 43 },
    { "[四骑士]贝德尔", 73, 78 },
    { "[四骑士]帕西瓦", 90, 100 },
}
--哈法西斯之墓任务到期
function ha_fa_xi_si_expire(actor)
    mapmove(actor, "神风平原", 121, 129)
    sendcentermsg(actor, 250, 0, "[系统提示]：哈法西斯副本已结束！", 0, 5)
    sendcentermsg(actor, 250, 0, "[系统提示]：哈法西斯副本已结束！", 0, 5)
    sendcentermsg(actor, 250, 0, "[系统提示]：哈法西斯副本已结束！", 0, 5)
end

--创建镜像地图（mapid=名字+地图名），返回地图ID
---* actor：玩家对象
---* mapId：原地图ID
---* mapName：地图名字
---* mapTime：镜像地图时间
---* miniMpa：小地图编号
--- @param actor string
--- @param mapId string
--- @param mapName string
--- @param mapTime integer
--- @param miniMpa integer
--- @return string
local function CreateMapGenmon(actor, mapId, mapName, mapTime, miniMpa)
    local myName = getbaseinfo(actor, ConstCfg.gbase.name)
    local oldMapId = getbaseinfo(actor, ConstCfg.gbase.mapid)
    local x = getbaseinfo(actor, ConstCfg.gbase.x)
    local y = getbaseinfo(actor, ConstCfg.gbase.y)
    local newMapId = myName .. mapName
    if checkmirrormap(newMapId) then
        delmirrormap(newMapId)
    end
    addmirrormap(mapId, newMapId, mapName, mapTime, oldMapId, miniMpa, x, y)
    return newMapId
end
function HaFaXiSiZhiMu.Request(actor)
    local num = getplaydef(actor, VarCfg["J_哈法西斯之墓挑战次数"])
    if num > 0 then
        Player.sendmsgEx(actor, "[提示]:#251|你今天已挑战过哈法西斯之墓,请明天再来!#249")
        return
    end
    local newMapId = CreateMapGenmon(actor, "newhafaxisi", mirrorMapId1, 1800, 015031)
    genmon(newMapId, 24, 32, monName1, 1, 1, 249)
    mapmove(actor, newMapId, 70, 74, 0)
    setplaydef(actor, VarCfg["N$哈法西斯之墓副本"], 1)
    sendcentermsg(actor, 249, 0, "哈法西斯之墓剩余时间: %d秒", 0, 1800, "@ha_fa_xi_si_expire")
    setplaydef(actor, VarCfg["J_哈法西斯之墓挑战次数"], 1)
    setontimer(actor,174,1) --开启雷劈
    setflagstatus(actor,VarCfg["F_哈法西斯之墓_进入"],1)
end

--杀怪触发
local function _onKillMon(actor, monobj, monName)
    local mapId = getbaseinfo(actor, ConstCfg.gbase.mapid)
    local myName = getbaseinfo(actor, ConstCfg.gbase.name)
    local checkMapId = myName .. mirrorMapId1
    if checkMapId == mapId then
        if monName == monName1 then
            setontimer(actor, 172, 2)
            local newMapId = myName .. mirrorMapId2
            if checkmirrormap(newMapId) then
                delmirrormap(newMapId)
            end
            addmirrormap("newhafaxisi2", newMapId, mirrorMapId2, 1800, "神风平原", 015032, 121, 129)
            mapeffect(1000, mapId, 14, 21, 17009, 1800, 1, actor)
            addmapgate(myName .. "哈法西斯之墓2", mapId, 14, 21, 2, newMapId, 112, 121, 1800)
            setplaydef(actor, VarCfg["M_哈法西斯之墓"], 0)
            --创建下一层的怪物,和NPC
            --刷怪
            for _, value in ipairs(knights) do
                genmon(newMapId, value[2], value[3], value[1], 1, 1, 249)
            end
            --创建npc
            local accountID = tonumber(getconst(actor,"<$USERACCOUNT>")) or 0
            local npcInfo = {
                ["Idx"] = accountID + math.random(1000,9999), -- 自定义NPC的Idx，NPC点击触发时，触发参数会传回Idx值
                ["npcname"] = "哈法西斯祭坛", -- NPC名称
                ["appr"] = 1379, -- NPC外形效果
                ["script"] = '哈法西斯祭坛', -- NPC相关脚本名称，表示Envir\Market_def\NewNPC.txt
                ["limit"] = 1800, -- 生命周期 (秒) 引擎64_24.05.23新增
            }
            createnpc(newMapId, 45, 45, tbl2json(npcInfo))
        end
    end
    local checkMapId2 = myName .. mirrorMapId2
    if checkMapId2 == mapId then
        local isKill = true
        for _, value in ipairs(knights) do
            local idx = tonumber(getdbmonfieldvalue(value[1], "idx"))
            local num = getmoncount(mapId, idx, true)
            if num > 0 then
                isKill = false
                break
            end
        end
        if isKill then
            if string.find(monName, "骑士") then
                setontimer(actor, 173, 2)
            end
        end
        if monName == "哈法西斯之魂" then
            local x = getbaseinfo(actor, ConstCfg.gbase.x)
            local y = getbaseinfo(actor, ConstCfg.gbase.y)
            genmon(mapId, x, y, "暴君哈法西斯·恐惧之主", 1, 1, 249)
            scenevibration(actor, 0, 3, 1)
            sendcentermsg(actor, 250, 0, "[系统提示]：你当前已经惊动暴君哈法西斯·恐惧之主！", 0, 5)
            sendcentermsg(actor, 250, 0, "[系统提示]：你当前已经惊动暴君哈法西斯·恐惧之主！", 0, 5)
            sendcentermsg(actor, 250, 0, "[系统提示]：你当前已经惊动暴君哈法西斯·恐惧之主！", 0, 5)
        elseif monName == "暴君哈法西斯·恐惧之主" then
            setflagstatus(actor,VarCfg["F_哈法西斯之墓完成一次"],1)
            sendcentermsg(actor, 250, 0, "[系统提示]：你完成了哈法西斯之墓副本！", 0, 5)
            sendcentermsg(actor, 250, 0, "[系统提示]：你完成了哈法西斯之墓副本！", 0, 5)
            sendcentermsg(actor, 250, 0, "[系统提示]：你完成了哈法西斯之墓副本！", 0, 5)
        end
    end
end
GameEvent.add(EventCfg.onKillMon, _onKillMon, HaFaXiSiZhiMu)
--定时器触发
local function _HaFaXiSiZhiMuOnTimer(actor)
    local mapId = getbaseinfo(actor, ConstCfg.gbase.mapid)
    local myName = getbaseinfo(actor, ConstCfg.gbase.name)
    if mapId ~= myName .. mirrorMapId1 then
        setofftimer(actor, 172)
        return
    end
    sendcentermsg(actor, 250, 0, "[系统提示]：第一层关卡连接点已经打开，请前往坐标：11.18过桥后进入第二层", 0, 1)
end
--提示定时器触发
GameEvent.add(EventCfg.HaFaXiSiZhiMuOnTimer, _HaFaXiSiZhiMuOnTimer, HaFaXiSiZhiMu)

--定时器触发
local function _HaFaXiSiJiTanOnTimer(actor)
    local mapId = getbaseinfo(actor, ConstCfg.gbase.mapid)
    local myName = getbaseinfo(actor, ConstCfg.gbase.name)
    if mapId ~= myName .. mirrorMapId2 then
        setofftimer(actor, 173)
        return
    end
    sendcentermsg(actor, 250, 0, "[系统提示]：你已击杀四骑士,请前往坐标:(45,45)召唤[哈法西斯之魂]", 0, 1)
end
--提示定时器触发
GameEvent.add(EventCfg.HaFaXiSiJiTanOnTimer, _HaFaXiSiJiTanOnTimer, HaFaXiSiZhiMu)

--切换地图
local function _goSwitchMap(actor, cur_mapid, former_mapid)
    if getplaydef(actor, VarCfg["N$哈法西斯之墓副本"]) == 1 then
        if not string.find(cur_mapid,"哈法西斯之墓") then
            cleardelaygoto(actor,1)
            setplaydef(actor, VarCfg["N$哈法西斯之墓副本"],0)
        end
    end
end
GameEvent.add(EventCfg.goSwitchMap, _goSwitchMap, HaFaXiSiZhiMu)

Message.RegisterNetMsg(ssrNetMsgCfg.HaFaXiSiZhiMu, HaFaXiSiZhiMu)
return HaFaXiSiZhiMu

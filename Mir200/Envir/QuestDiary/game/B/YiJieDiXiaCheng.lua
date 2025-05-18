local YiJieDiXiaCheng = {}
local timeRanges = {
    { 13, 29, 13, 59 },
    { 19, 29, 19, 59 },
}

local Mobconfig1 = {
    { monName = "爆毒神魔(异界)", num = 15, x = 93, y = 80, range = 15, color = 251 },
    { monName = "魔族之主(异界)", num = 2, x = 93, y = 80, range = 15, color = 251 },
    { monName = "震天魔神(异界)", num = 15, x = 93, y = 80, range = 15, color = 251 },
    { monName = "重甲守卫(异界)", num = 15, x = 93, y = 80, range = 15, color = 251 },

    { monName = "爆毒神魔(异界)", num = 15, x = 201, y = 91, range = 15, color = 251 },
    { monName = "魔族之主(异界)", num = 2, x = 201, y = 91, range = 15, color = 251 },
    { monName = "震天魔神(异界)", num = 15, x = 201, y = 91, range = 15, color = 251 },
    { monName = "重甲守卫(异界)", num = 15, x = 201, y = 91, range = 15, color = 251 },

    { monName = "爆毒神魔(异界)", num = 15, x = 215, y = 205, range = 15, color = 251 },
    { monName = "魔族之主(异界)", num = 2, x = 215, y = 205, range = 15, color = 251 },
    { monName = "震天魔神(异界)", num = 15, x = 215, y = 205, range = 15, color = 251 },
    { monName = "重甲守卫(异界)", num = 15, x = 215, y = 205, range = 15, color = 251 },
}

local Mobconfig2 = {
    { monName = "赤炎火龙王(异界)", num = 1, x = 65, y = 208, range = 1, color = 251 },
    { monName = "赤炎火龙王(异界)", num = 1, x = 125, y = 266, range = 1, color = 251 },
}

local MobconfigGeRen1 = {
    { monName = "爆毒神魔(异界)", num = 7, x = 93, y = 80, range = 4, color = 251 },
    { monName = "魔族之主(异界)", num = 1, x = 93, y = 80, range = 4, color = 251 },
    { monName = "震天魔神(异界)", num = 7, x = 93, y = 80, range = 4, color = 251 },
    { monName = "重甲守卫(异界)", num = 7, x = 93, y = 80, range = 4, color = 251 },

    { monName = "爆毒神魔(异界)", num = 7, x = 201, y = 91, range = 4, color = 251 },
    { monName = "魔族之主(异界)", num = 1, x = 201, y = 91, range = 4, color = 251 },
    { monName = "震天魔神(异界)", num = 7, x = 201, y = 91, range = 4, color = 251 },
    { monName = "重甲守卫(异界)", num = 7, x = 201, y = 91, range = 4, color = 251 },

    { monName = "爆毒神魔(异界)", num = 7, x = 215, y = 205, range = 4, color = 251 },
    { monName = "魔族之主(异界)", num = 1, x = 215, y = 205, range = 4, color = 251 },
    { monName = "震天魔神(异界)", num = 7, x = 215, y = 205, range = 4, color = 251 },
    { monName = "重甲守卫(异界)", num = 7, x = 215, y = 205, range = 4, color = 251 },
}


local mapID = "dixiachengyiceng"
-- [dixiachengyiceng 异界地下城入口] n
-- [dixiachengyiceng 异界地下城一层]
-- [dixiachengerceng 异界地下城二层]
-- [dixiachengsanceng 异界地下城三层]
-- [dixiachengdiceng 异界地下城(终)]

local mapIDs = {
    ["异界地下城一层"] = "dixiachengyiceng",
    ["异界地下城二层"] = "dixiachengerceng",
    ["异界地下城三层"] = "dixiachengsanceng",
    ["异界地下城(终)"] = "dixiachengdiceng",
}

--判断是否在活动时间
local function isPublicTime()
    return getsysvar(VarCfg["G_异界猎场开启标识"]) == 1
end

local function isPrivateTime(actor)
    return getplaydef(actor, VarCfg["J_异界地下城今日是否进入"]) == 0
end

--个人副本
local function privateTask(actor)
    setflagstatus(actor, VarCfg["F_异界地下城进入公共or私人"], 1)
    FSetTaskRedPoint(actor, VarCfg["F_异界地下城进入"], 16)
    local name = getbaseinfo(actor, ConstCfg.gbase.name)
    local newMapId = name .. mapIDs["异界地下城一层"]
    if checkmirrormap(newMapId) then
        mapmove(actor, newMapId, 89, 204)
        sendmsg("0", 2,
            '{"Msg":"[' ..
            name .. ']进入了异界战场[个人]","FColor":251,"BColor":0,"Type":6,"Time":6,"SendName":"系统：","SendId":"123","X":"-300"}')
        local remainingTime = tonumber(mirrormaptime(newMapId, 0)) or 0
        local monMap = getmoncount(newMapId, -1, true)
        if monMap > 0 then
            local monIdx = tonumber(getdbmonfieldvalue("异界·阿布霍斯[个人级BOSS]", "idx")) or 0
            local bossNum = getmoncount(newMapId, monIdx, true)
            if bossNum > 0 then
                senddelaymsg(actor, "异界战场一层内的怪物已全部击杀，在地图中间(142.142)召唤出[异界·阿布霍斯],任务剩余时间:%s", remainingTime or 0, 250, 1)
            else
                senddelaymsg(actor, "前往地图(93,80),(201,91),(215,205)击杀怪物,任务剩余时间:%s", remainingTime, 250, 1)
            end
        else
            senddelaymsg(actor, "异界战场内[异界·阿布霍斯]已被击杀,请前往(154.137)进入下一层,任务剩余时间:%s", remainingTime or 0, 250, 1)
            local name = getbaseinfo(actor, ConstCfg.gbase.name)
            local newMapId = name .. mapIDs["异界地下城一层"]
            local newMapId2 = name .. mapIDs["异界地下城二层"]
            local newMapId3 = name .. mapIDs["异界地下城三层"]
            local newMapId4 = name .. mapIDs["异界地下城(终)"]
            mapeffect(2001 + math.random(1000), newMapId, 154, 137, 17009, 1800, 0, actor)
            addmapgate(newMapId, newMapId, 154, 137, 2, newMapId2, 39, 298, 1800)
        end
    else
        local isBool = isPrivateTime(actor)
        if not isBool then
            Player.sendmsgEx(actor, "今天已经进入活动了,请明天再来!#249")
            return
        end
        setplaydef(actor, VarCfg["U_异界战场献祭1"], 0)
        setplaydef(actor, VarCfg["U_异界战场献祭2"], 0)
        addmirrormap(mapIDs["异界地下城一层"], newMapId, "异界地下城一层", 1800, "遗忘大陆", 015042, 241, 156)
        setplaydef(actor, VarCfg["J_异界地下城今日是否进入"], 1)
        for _, value in ipairs(MobconfigGeRen1) do
            genmon(newMapId, value.x, value.y, value.monName, value.range, value.num, value.color)
        end
        mapmove(actor, newMapId, 89, 204)
        sendmsg("0", 2,
            '{"Msg":"[' ..
            name .. ']进入了异界战场[个人]","FColor":251,"BColor":0,"Type":6,"Time":6,"SendName":"系统：","SendId":"123","X":"-300"}')
        local remainingTime = tonumber(mirrormaptime(newMapId, 0)) or 0
        senddelaymsg(actor, "前往地图(93,80),(201,91),(215,205)击杀怪物,任务剩余时间:%s", remainingTime, 250, 1)
    end
end

--公共副本
local function publicTask(actor)
    local isBool = isPublicTime()
    if not isBool then
        Player.sendmsgEx(actor, "当前不在开放时间内,禁止进入!#249")
        return
    end
    setflagstatus(actor, VarCfg["F_异界地下城进入公共or私人"], 0)
    FSetTaskRedPoint(actor, VarCfg["F_异界地下城进入"], 16)
    mapmove(actor, mapID, 89, 204)
    local name = getbaseinfo(actor, ConstCfg.gbase.name)
    sendmsg("0", 2,
        '{"Msg":"[' ..
        name .. ']进入了异界战场[团队]","FColor":251,"BColor":0,"Type":6,"Time":6,"SendName":"系统：","SendId":"123","X":"-300"}')
end
function YiJieDiXiaCheng.Request(actor, arg1)
    if arg1 == 1 then
        privateTask(actor)
    elseif arg1 == 2 then
        publicTask(actor)
    end
end

--活动开始

local function _onYiJieLieChangStart()
    FsendHuoDongGongGao("异界战场活动已开启.")
    setsysvar(VarCfg["G_异界战场献祭1"], 0)
    setsysvar(VarCfg["G_异界战场献祭2"], 0)
    setsysvar(VarCfg["G_异界战场一层杀怪"], 0)
    killmonsters("dixiachengyiceng", "*", 0, false)
    killmonsters("dixiachengerceng", "*", 0, false)
    killmonsters("dixiachengdiceng", "*", 0, false)
    delmapgate("dixiachengyiceng", "dixiachengyiceng")
    delmapgate("dixiachengerceng", "dixiachengerceng")
    delmapgate("dixiachengsanceng", "dixiachengsanceng")
    for _, value in ipairs(Mobconfig1) do
        genmon(mapID, value.x, value.y, value.monName, value.range, value.num, value.color)
    end
end
--活动开始
GameEvent.add(EventCfg.onYiJieLieChangStart, _onYiJieLieChangStart, YiJieDiXiaCheng)

function yan_chi_chuang_jian_npc(actor, newMapId2)
    local num = getsysvar(VarCfg["G_NPCID编号"])
    num = num + 1
    local npcInfo = {
        ["Idx"] = ConstCfg.customNpc["异界神柱右new"] + num, -- 自定义NPC的Idx，NPC点击触发时，触发参数会传回Idx值
        ["npcname"] = "异界神柱", -- NPC名称
        ["appr"] = 7280, -- NPC外形效果
        ["script"] = '异界神柱左', -- NPC相关脚本名称，表示Envir\Market_def\NewNPC.txt
        ["limit"] = 1800, -- 生命周期 (秒) 引擎64_24.05.23新增
    }
    createnpc(newMapId2, 77, 48, tbl2json(npcInfo))
    --创建NPC右
    num = num + 1
    local npcInfo = {
        ["Idx"] = ConstCfg.customNpc["异界神柱左new"] + num, -- 自定义NPC的Idx，NPC点击触发时，触发参数会传回Idx值
        ["npcname"] = "异界神柱", -- NPC名称
        ["appr"] = 7281, -- NPC外形效果
        ["script"] = '异界神柱右', -- NPC相关脚本名称，表示Envir\Market_def\NewNPC.txt
        ["limit"] = 1800, -- 生命周期 (秒) 引擎64_24.05.23新增
    }
    createnpc(newMapId2, 261, 248, tbl2json(npcInfo))
    setsysvar(VarCfg["G_NPCID编号"], num)
end

local function _onKillMon(actor, monobj, monName)
    -- 0=公共副本
    if getflagstatus(actor, VarCfg["F_异界地下城进入公共or私人"]) == 0 then
        if FCheckMap(actor, "dixiachengyiceng") then
            if string.find(monName, "%(异界%)") then
                local monMap = getmoncount("dixiachengyiceng", -1, true)
                if monMap == 0 then
                    FsendHuoDongGongGao("异界战场一层内的怪物已全部击杀，在地图中间(142.142)召唤出[异界·阿布霍斯]")
                    genmon("dixiachengyiceng", 146, 146, "异界·阿布霍斯", 1, 1, 251)
                end
            end

            if monName == "异界·阿布霍斯" then
                FsendHuoDongGongGao("异界战场内[异界·阿布霍斯]已被击杀,请前往(154.137)进入下一层!")
                setsysvar(VarCfg["G_异界战场一层杀怪"], 0)
                for _, value in ipairs(Mobconfig2) do
                    genmon("dixiachengerceng", value.x, value.y, value.monName, value.range, value.num, value.color) --刷二层
                end
                mapeffect(2000, "dixiachengyiceng", 154, 137, 17009, 600, 0, actor)
                addmapgate("dixiachengyiceng", "dixiachengyiceng", 154, 137, 2, "dixiachengerceng", 39, 297, 600)
            end
        elseif FCheckMap(actor, "dixiachengerceng") then
            if monName == "异界·图尔兹查" then
                FsendHuoDongGongGao("异界战场二层[异界·图尔兹查]已被击杀,在地图(221.89)召唤出[异界·库苏恩!")
                genmon("dixiachengerceng", 221, 89, "异界·库苏恩", 1, 1, 251)
            elseif monName == "异界·库苏恩" then
                FsendHuoDongGongGao("异界战场二层[异界·库苏恩]已被击杀,请前往(226.85)进入下一层!")
                mapeffect(2000, "dixiachengerceng", 226, 85, 17009, 600, 0, actor)
                addmapgate("dixiachengerceng", "dixiachengerceng", 226, 85, 2, "dixiachengsanceng", 249, 264, 600)

                mapeffect(2000, "dixiachengsanceng", 147, 155, 17009, 1200, 0, actor)
                addmapgate("dixiachengsanceng", "dixiachengsanceng", 147, 155, 2, "dixiachengdiceng", 45, 107, 1200)
                genmon("dixiachengdiceng", 59, 92, "异界·吉尔格斯[团队级BOSS]", 1, 1, 251)
            end
        end
    else
        --个人副本
        local name = getbaseinfo(actor, ConstCfg.gbase.name)
        local newMapId = name .. mapIDs["异界地下城一层"]
        local newMapId2 = name .. mapIDs["异界地下城二层"]
        local newMapId3 = name .. mapIDs["异界地下城三层"]
        local newMapId4 = name .. mapIDs["异界地下城(终)"]
        if FCheckMap(actor, newMapId) then
            if string.find(monName, "%(异界%)") then
                local monMap = getmoncount(newMapId, -1, true)
                if monMap == 0 then
                    local remainingTime = tonumber(mirrormaptime(newMapId, 0)) or 0
                    senddelaymsg(actor, "异界战场一层内的怪物已全部击杀，在地图中间(142.142)召唤出[异界·阿布霍斯],任务剩余时间:%s", remainingTime or 0, 250,
                        1)
                    genmon(newMapId, 146, 146, "异界·阿布霍斯[个人级BOSS]", 1, 1, 251)
                end
            end
            if monName == "异界·阿布霍斯[个人级BOSS]" then
                --创建二层
                local remainingTime = tonumber(mirrormaptime(newMapId, 0)) or 0
                senddelaymsg(actor, "异界战场内[异界·阿布霍斯]已被击杀,请前往(154.137)进入下一层,任务剩余时间:%s", remainingTime or 0, 250, 1)
                local newMapId2 = name .. mapIDs["异界地下城二层"]
                addmirrormap(mapIDs["异界地下城二层"], newMapId2, "异界地下城二层", remainingTime, "遗忘大陆", 015044, 241, 155)
                for _, value in ipairs(Mobconfig2) do
                    genmon(newMapId2, value.x, value.y, value.monName, value.range, value.num, value.color) --刷二层
                end
                mapeffect(2001 + math.random(1000), newMapId, 154, 137, 17009, 1800, 0, actor)
                addmapgate(newMapId, newMapId, 154, 137, 2, newMapId2, 39, 298, 1800)
                delaygoto(actor, 1000, "yan_chi_chuang_jian_npc," .. newMapId2)
            end
            --二层触发
        elseif FCheckMap(actor, newMapId2) then
            if monName == "异界·图尔兹查[个人级BOSS]" then
                local remainingTime = tonumber(mirrormaptime(newMapId, 0)) or 0
                senddelaymsg(actor, "[异界·图尔兹查]已被击杀,在地图(221.89)召唤出[异界·库苏恩],任务剩余时间:%s", remainingTime or 0, 250, 1)
                genmon(newMapId2, 221, 89, "异界·库苏恩[个人级BOSS]", 1, 1, 251)
            elseif monName == "异界·库苏恩[个人级BOSS]" then
                local remainingTime = tonumber(mirrormaptime(newMapId, 0)) or 0
                senddelaymsg(actor, "[异界·库苏恩]已被击杀,请前往(226.85)进入下一层,任务剩余时间:%s", remainingTime or 0, 250, 1)
                addmirrormap(mapIDs["异界地下城三层"], newMapId3, "异界地下城三层", remainingTime, "遗忘大陆", 015044, 241, 155)
                mapeffect(2000 + math.random(1000), newMapId2, 226, 85, 17009, remainingTime, 0, actor)
                addmapgate(newMapId2, newMapId2, 226, 85, 2, newMapId3, 249, 264, remainingTime)
                --创建最后一层
                addmirrormap(mapIDs["异界地下城(终)"], newMapId4, "异界地下城(终)", remainingTime, "遗忘大陆", 015044, 241, 155)
                mapeffect(2000 + math.random(1000), newMapId3, 147, 155, 17009, remainingTime, 0, actor)
                addmapgate(newMapId3, newMapId3, 147, 155, 2, newMapId4, 45, 107, remainingTime)
                genmon(newMapId4, 59, 92, "异界·吉尔格斯[个人级BOSS]", 1, 1, 251)
            end
            --四层触发
        elseif FCheckMap(actor, newMapId4) then
            if monName == "异界·吉尔格斯[个人级BOSS]" then
                local remainingTime = tonumber(mirrormaptime(newMapId, 0)) or 0
                senddelaymsg(actor, "你已经完成了异界战场[个人],%s后退出地图!", remainingTime or 0, 250, 1)
            end
        end
    end
end
GameEvent.add(EventCfg.onKillMon, _onKillMon, YiJieDiXiaCheng)

Message.RegisterNetMsg(ssrNetMsgCfg.YiJieDiXiaCheng, YiJieDiXiaCheng)
return YiJieDiXiaCheng

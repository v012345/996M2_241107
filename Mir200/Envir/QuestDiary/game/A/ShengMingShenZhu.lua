local ShengMingShenZhu = {}
ShengMingShenZhu.ID = "生命神柱"
local npcID = 3473
--local config = include("QuestDiary/cfgcsv/cfg_ShengMingShenZhu.lua") --配置
local cost = { {} }
local give = { {} }

local xianJiVar = {
    [3475] = VarCfg["G_异界战场献祭1"],
    [3476] = VarCfg["G_异界战场献祭2"],
    [2509] = VarCfg["U_异界战场献祭1"],
    [2510] = VarCfg["U_异界战场献祭2"],
}

local mapIDs = {
    ["异界地下城一层"] = "dixiachengyiceng",
    ["异界地下城二层"] = "dixiachengerceng",
    ["异界地下城三层"] = "dixiachengsanceng",
    ["异界地下城(终)"] = "dixiachengdiceng",
}

local function GETgetsysvarOrgetplaydef(actor, var)
    if string.find(var, "G") then
        return getsysvar(var)
    elseif string.find(var, "U") then
        return getplaydef(actor, var)
    else
        return 0
    end
end

local function SETsetsysvarOrsetplaydef(actor, var, value)
    if string.find(var, "G") then
        return setsysvar(var, value)
    elseif string.find(var, "U") then
        return setplaydef(actor, var, value)
    else
        return 0
    end
end
--接收请求
function ShengMingShenZhu.Request(actor, npcid)
    local currHp = getbaseinfo(actor, ConstCfg.gbase.curhp)
    if currHp < 300000 then
        Player.sendmsgEx(actor, "你的血量小于30W,无法献祭!#249")
        return
    end
    local cfg = xianJiVar[npcid]
    if not cfg then
        Player.sendmsgEx(actor, "参数错误!")
        return
    end

    local currXj = GETgetsysvarOrgetplaydef(actor, cfg)
    if currXj >= 3000000 then
        Player.sendmsgEx(actor, "献祭失败,当前献祭血量已超过3000万!#249")
        return
    end
    SETsetsysvarOrsetplaydef(actor, cfg, currXj + 300000)
    humanhp(actor, "-", 300000, 1)
    Player.sendmsgEx(actor, "献祭成功,扣除30W血量!")
    local var1 = ""
    local var2 = ""
    if getflagstatus(actor, VarCfg["F_异界地下城进入公共or私人"]) == 0 then
        var1 = VarCfg["G_异界战场献祭1"]
        var2 = VarCfg["G_异界战场献祭2"]
    else
        var1 = VarCfg["U_异界战场献祭1"]
        var2 = VarCfg["U_异界战场献祭2"]
    end

    local currxj1 = GETgetsysvarOrgetplaydef(actor, var1)
    local currxj2 = GETgetsysvarOrgetplaydef(actor, var2)

    local totalHP = currxj1 + currxj2
    if totalHP >= 6000000 then
        if getflagstatus(actor, VarCfg["F_异界地下城进入公共or私人"]) == 0 then
            FsendHuoDongGongGao("异界战场献祭已完成，在地图中间(153.170)召唤出[异界·图尔兹查]")
            genmon("dixiachengerceng", 153, 170, "异界·图尔兹查", 1, 1, 251)
        else
            local name = getbaseinfo(actor, ConstCfg.gbase.name)
            local newMapId = name .. mapIDs["异界地下城一层"]
            local remainingTime = mirrormaptime(newMapId, 0)
            senddelaymsg(actor, "异界战场献祭已完成，在地图中间(153.170)召唤出[异界·图尔兹查],任务剩余时间:%s", remainingTime or 0, 250, 1)
            genmon(name .. "dixiachengerceng", 153, 170, "异界·图尔兹查[个人级BOSS]", 1, 1, 251)
        end
    end
    if getflagstatus(actor, VarCfg["F_异界地下城进入公共or私人"]) == 0 then
        local players = getplaycount("dixiachengerceng", 1, 1)
        for index, player in ipairs(type(players) == "table" and players or {}) do
            ShengMingShenZhu.SyncResponse(player)
        end
    else
        ShengMingShenZhu.SyncResponse(actor)
    end
end

--同步消息
function ShengMingShenZhu.SyncResponse(actor)
    if getflagstatus(actor, VarCfg["F_异界地下城进入公共or私人"]) == 0 then
        local var1 = VarCfg["G_异界战场献祭1"]
        local var2 = VarCfg["G_异界战场献祭2"]
        local currxj1 = GETgetsysvarOrgetplaydef(actor, var1)
        local currxj2 = GETgetsysvarOrgetplaydef(actor, var2)
        local data = {
            ["3475"] = currxj1,
            ["3476"] = currxj2
        }
        Message.sendmsg(actor, ssrNetMsgCfg.ShengMingShenZhu_SyncResponse, 0, 0, 0, data)
    else
        local var1 = VarCfg["U_异界战场献祭1"]
        local var2 = VarCfg["U_异界战场献祭2"]
        local currxj1 = GETgetsysvarOrgetplaydef(actor, var1)
        local currxj2 = GETgetsysvarOrgetplaydef(actor, var2)
        local data = {
            ["2509"] = currxj1,
            ["2510"] = currxj2
        }
        Message.sendmsg(actor, ssrNetMsgCfg.ShengMingShenZhu_SyncResponse, 0, 0, 0, data)
    end
end

-- --登录触发
-- local function _onLoginEnd(actor, logindatas)
--     ShengMingShenZhu.SyncResponse(actor, logindatas)
-- end
-- --事件派发
-- GameEvent.add(EventCfg.onLoginEnd, _onLoginEnd, ShengMingShenZhu)
function ge_ren_di_xia_cheng_jin_ru_er_ceng(actor, time)
    local remainingTime = tonumber(time) or 0
    senddelaymsg(actor, "前往(77,47),(261,249)献祭生命,召唤[异界·图尔兹查],任务剩余时间:%s", remainingTime, 250, 1)
end

function ge_ren_di_xia_cheng_jin_ru_san_ceng(actor, time)
    local remainingTime = tonumber(time) or 0
    senddelaymsg(actor, "前往(147,155)进入异界大猎场,任务剩余时间:%s", remainingTime, 250, 1)
end

function ge_ren_di_xia_cheng_jin_ru_zhong(actor, time)
    local remainingTime = tonumber(time) or 0
    senddelaymsg(actor, "前往(147,155)击杀最终BOSS[异界·吉尔格斯],任务剩余时间:%s", remainingTime, 250, 1)
end

--踩点触发
local function _onBeforerOute(actor, mapid, x, y)
    local name = Player.GetName(actor)
    local mapID = name .. mapIDs["异界地下城二层"]
    local mapID3 = name .. mapIDs["异界地下城三层"]
    local mapID4 = name .. mapIDs["异界地下城(终)"]
    if mapid == mapID then
        local newMapId = name .. mapIDs["异界地下城一层"]
        local remainingTime = tonumber(mirrormaptime(newMapId, 0)) or 0
        delaygoto(actor, 500, "ge_ren_di_xia_cheng_jin_ru_er_ceng," .. remainingTime)
        local npcObj1 = getnpcbyindex(2509)
        local npcObj2 = getnpcbyindex(2510)
        if npcObj1 == nil or npcObj2 == nil then
            delaygoto(actor, 500, "yan_chi_chuang_jian_npc,"..mapID)
        end
    elseif mapid == mapID3 then
        local newMapId = name .. mapIDs["异界地下城一层"]
        local remainingTime = tonumber(mirrormaptime(newMapId, 0)) or 0
        delaygoto(actor, 500, "ge_ren_di_xia_cheng_jin_ru_san_ceng," .. remainingTime)
    elseif mapid == mapID4 then
        local newMapId = name .. mapIDs["异界地下城(终)"]
        local remainingTime = tonumber(mirrormaptime(newMapId, 0)) or 0
        delaygoto(actor, 500, "ge_ren_di_xia_cheng_jin_ru_zhong," .. remainingTime)
    end
end
GameEvent.add(EventCfg.onBeforerOute, _onBeforerOute, ShengMingShenZhu)
--注册网络消息
Message.RegisterNetMsg(ssrNetMsgCfg.ShengMingShenZhu, ShengMingShenZhu)
return ShengMingShenZhu

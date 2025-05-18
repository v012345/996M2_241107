XunHangGuaJi = {}

local cfg_JinZhiJiLuDiTu = include("QuestDiary/cfgcsv/cfg_JinZhiJiLuDiTu.lua") --禁止记录的地图

local flag = { VarCfg["F_巡航开关1"], VarCfg["F_巡航开关2"], VarCfg["F_巡航开关3"] }

local record = { VarCfg["T_巡航记录地图1"], VarCfg["T_巡航记录地图2"], VarCfg["T_巡航记录地图3"] }

--禁止记录的地图镜像后缀
-- local mapSuffix = { "伤害试炼", "生存试炼", "心魔试炼", "献祭试炼", "最终试炼" }

function xunhang_start_auto_attack(actor)
    setplaydef(actor, VarCfg["M_是否在巡航地图"], 1)
    startautoattack(actor)
end

local timeCache = {}

--获取巡航信息
function XunHangGuaJi.GetXunHangInfo(actor)
    local arrData = {
        flag = {},
        record = {},
        status = 0
    }
    for _, value in ipairs(flag) do
        table.insert(arrData.flag, getflagstatus(actor, value))
    end
    for _, value in ipairs(record) do
        table.insert(arrData.record, Player.getJsonTableByVar(actor, value))
    end
    arrData.status = getplaydef(actor, VarCfg["N$巡航挂机开启状态"])
    return arrData
end

function XunHangGuaJi.OpenUI(actor)
    local data = XunHangGuaJi.GetXunHangInfo(actor)
    Message.sendmsg(actor, ssrNetMsgCfg.XunHangGuaJi_OpenUI, 0, 0, 0, data)
end

--判断地图是否可以巡航
function XunHangGuaJi.CheckMap(actor, mapId)
    if cfg_JinZhiJiLuDiTu[mapId] then
        return false
    end
    local myName = getbaseinfo(actor, ConstCfg.gbase.name)
    local findSting = string.find(mapId, myName)
    if findSting then
        return false
    end
    return true
end

function XunHangGuaJi.RecordXunHang(actor, arg1)
    local var = record[arg1]
    if not var then
        Player.sendmsgEx(actor, "参数错误!#249")
        return
    end
    local mapInfo = getplaydef(actor, var)
    if mapInfo ~= "" then
        setplaydef(actor, var, "")
        Player.sendmsgEx(actor, "删除成功!")
        XunHangGuaJi.SyncResponse(actor)
    else
        local mapId = getbaseinfo(actor, ConstCfg.gbase.mapid)
        local myName = getbaseinfo(actor, ConstCfg.gbase.name)
        if string.find(mapId, myName) then
            Player.sendmsgEx(actor,"副本地图禁止记录#249")
            return
        end
        local checkMap = XunHangGuaJi.CheckMap(actor, mapId)
        if not checkMap then
            Player.sendmsgEx(actor, "当前地图禁止巡航!#249")
            return
        end
        local mapName = getbaseinfo(actor, ConstCfg.gbase.map_title)
        local mapInfo = { mapId, mapName }
        Player.setJsonVarByTable(actor, var, mapInfo)
        Player.sendmsgEx(actor, "添加成功!")
        XunHangGuaJi.SyncResponse(actor)
    end
end

--进入挂机地图
function XunHangGuaJi.EnterGuaJiMap(actor)
    local mapList = {}
    for _, value in ipairs(record) do
        local arr = Player.getJsonTableByVar(actor, value)
        if arr[1] then
            table.insert(mapList, arr[1])
        end
    end
    if #mapList > 0 then
        local mapId = mapList[math.random(1, #mapList)]
        map(actor, mapId)
        delaygoto(actor, 1000, "xunhang_start_auto_attack")
        return true
    else
        return false
    end
end

function XunHangGuaJi.StartGuaJi(actor)
    local isGuaJi = getplaydef(actor, VarCfg["N$巡航挂机开启状态"])
    if isGuaJi == 0 then
        local isJiLu = XunHangGuaJi.EnterGuaJiMap(actor)
        if not isJiLu then
            Player.sendmsgEx(actor, "你没有记录任何地图!#249")
            return
        end
        setplaydef(actor, VarCfg["N$巡航挂机开启状态"], 1)
        setplaydef(actor, VarCfg["N$挂机死亡次数"], 0)
        setontimer(actor, 4, 15, 0, 0)
        Player.sendmsgEx(actor, "开启成功!")
    else
        setplaydef(actor, VarCfg["N$巡航挂机开启状态"], 0)
        setofftimer(actor, 4)
        Player.sendmsgEx(actor, "巡航挂机已关闭!#249")
    end
    XunHangGuaJi.SyncResponse(actor)
end

--关闭巡航挂机 --外部接口
function XunHangGuaJi.CloseGuaJi(actor)
    if getplaydef(actor, VarCfg["N$巡航挂机开启状态"]) == 1 then
        setplaydef(actor, VarCfg["N$巡航挂机开启状态"], 0)
        setofftimer(actor, 4)
        Player.sendmsgEx(actor, "巡航挂机已关闭!#249")
        XunHangGuaJi.SyncResponse(actor)
    end 
end

function XunHangGuaJi.OnAndOff(actor, arg1)
    local var = flag[arg1]
    if not var then
        Player.sendmsgEx(actor, "参数错误!#249")
        return
    end
    if getflagstatus(actor,VarCfg["F_是否首充"]) == 0 then
        messagebox(actor,"你没有进行首充，无法开启，是否前往首充？","@open_shou_chong","@quxiao")
        return
    end
    local status = getflagstatus(actor, var)
    if status == 0 then
        setflagstatus(actor, var, 1)
    else
        setflagstatus(actor, var, 0)
        --关闭第三项时 重置次数
        if arg1 == 3 then
            setplaydef(actor, VarCfg["N$挂机死亡次数"], 0)
        end
    end
    XunHangGuaJi.SyncResponse(actor)
end

--同步消息
function XunHangGuaJi.SyncResponse(actor)
    local data = XunHangGuaJi.GetXunHangInfo(actor)
    Message.sendmsg(actor, ssrNetMsgCfg.XunHangGuaJi_SyncResponse, 0, 0, 0, data)
end

Message.RegisterNetMsg(ssrNetMsgCfg.XunHangGuaJi, XunHangGuaJi)

--被人物攻击触发
local function _onStruckPlayer(actor, Target, Hiter, MagicId)
    if not hasbuff(actor, 30104) then
        if getplaydef(actor, VarCfg["N$巡航挂机开启状态"]) == 1 then
            if getflagstatus(actor, VarCfg["F_巡航开关1"]) == 1 then
                local mapId = getbaseinfo(actor, ConstCfg.gbase.mapid)
                map(actor, mapId)
                delaygoto(actor, 1000, "xunhang_start_auto_attack")
                addbuff(actor, 30104, 30)
            end
        end
    end
end
GameEvent.add(EventCfg.onStruckPlayer, _onStruckPlayer, XunHangGuaJi)
--被怪物攻击触发
local function _onStruckMonster(actor, Target, Hiter, MagicId)
    if getplaydef(actor, VarCfg["N$巡航挂机开启状态"]) == 1 then
        if getflagstatus(actor, VarCfg["F_巡航开关2"]) == 1 then
            local hpPer = Player.getHpPercentage(actor)
            if hpPer <= 50 then
                mapmove(actor, ConstCfg.main_city, 330, 330, 5)
                addhpper(actor, "=", 100)
            end
        end
    end
end
GameEvent.add(EventCfg.onStruckMonster, _onStruckMonster, XunHangGuaJi)

--死亡触发
local function _onPlaydie(actor, hiter)
    if getplaydef(actor, VarCfg["N$巡航挂机开启状态"]) == 1 then
        if getflagstatus(actor, VarCfg["F_巡航开关3"]) == 1 then
            local dieNum = getplaydef(actor, VarCfg["N$挂机死亡次数"])
            setplaydef(actor, VarCfg["N$挂机死亡次数"], dieNum + 1)
            --死亡超过十次关闭巡航挂机
            if dieNum + 1 >= 10 then
                setplaydef(actor, VarCfg["N$巡航挂机开启状态"], 0)
                setofftimer(actor, 4) --关闭定时器
                XunHangGuaJi.SyncResponse(actor)
            end
        end
    end
end

GameEvent.add(EventCfg.onPlaydie, _onPlaydie, XunHangGuaJi)

--巡航挂机定时器触发
local function _onXunHangOnTime(actor)
    if getplaydef(actor, VarCfg["M_是否在巡航地图"]) == 0 or FCheckMap(actor,"n3") then
        local result = XunHangGuaJi.EnterGuaJiMap(actor)
        if not result then
            setplaydef(actor, VarCfg["N$巡航挂机开启状态"], 0)
            setofftimer(actor, 4)
            Player.sendmsgEx(actor, "巡航地图不存在,已关闭巡航!")
            XunHangGuaJi.SyncResponse(actor)
            return
        end
    end
    -- if getflagstatus(actor, VarCfg.F_isGuaJi) == 0 then
    --     startautoattack(actor)
    -- end
    local lastTime = timeCache[actor] or os.time()
    local timeDifference = os.time() - lastTime
    -- release_print("定时器",timeDifference)
    --30秒不打怪自动随机
    if timeDifference > 30 then
        local result = XunHangGuaJi.EnterGuaJiMap(actor)
        if not result then
            setplaydef(actor, VarCfg["N$巡航挂机开启状态"], 0)
            setofftimer(actor, 4)
            Player.sendmsgEx(actor, "巡航地图不存在,已关闭巡航!")
            XunHangGuaJi.SyncResponse(actor)
            return
        end
    end
end
GameEvent.add(EventCfg.onXunHangOnTime, _onXunHangOnTime, XunHangGuaJi)

--攻击怪物触发
local function _onAttackMonster(actor, Target, Hiter, MagicId, qieGe)
    timeCache[actor] = os.time()
end
--攻击怪物触发
GameEvent.add(EventCfg.onAttackMonster, _onAttackMonster, XunHangGuaJi)

--退出游戏触发
local function _onExitGame(actor)
    timeCache[actor] = nil
end
GameEvent.add(EventCfg.onExitGame, _onExitGame, XunHangGuaJi)

return XunHangGuaJi

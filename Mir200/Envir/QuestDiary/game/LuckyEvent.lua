LuckyEvent = {}
local LuckyMonCfg = include("QuestDiary/cfgcsv/cfg_QiYuMonster.lua")          --奇遇怪物
local LuckyEventCfg = include("QuestDiary/cfgcsv/cfg_LuckyEvent_BoxData.lua") --奇遇事件配置

--是否已经存在在盒子里面
local function InTheBox(actor, Event_Name)
    local bool = false
    local notes1 = getplaydef(actor, VarCfg["Z_奇遇盒子位置1"])
    local notes2 = getplaydef(actor, VarCfg["Z_奇遇盒子位置2"])
    local notes3 = getplaydef(actor, VarCfg["Z_奇遇盒子位置3"])
    local notes4 = getplaydef(actor, VarCfg["Z_奇遇盒子位置4"])
    local notes5 = getplaydef(actor, VarCfg["Z_奇遇盒子位置5"])
    local NewTbl = { notes1, notes2, notes3, notes4, notes5 }
    for _, value in ipairs(NewTbl) do
        if value == Event_Name then
            setplaydef(actor, VarCfg["S$奇遇验证"], "")
            bool = true
        end
    end
    return bool
end

--查重 如果buff存在  则重新取值
local function checkbuff(actor, Event_Name)
    local name = Event_Name
    local cfg = {}
    for k, v in ipairs(LuckyEventCfg) do
        if v.EnevtName == Event_Name then
            cfg = v
            break
        end
    end
    if cfg.BuffId ~= "nil" then
        local BuffTbl = cfg.BuffId
        for i = 1, #BuffTbl do
            local buffstate = hasbuff(actor, BuffTbl[i])
            if hasbuff(actor, BuffTbl[i]) then
                local NewTbl = {}
                for i = 17, 34 do
                    local info = LuckyEventCfg[i].EnevtName
                    if info ~= name then
                        table.insert(NewTbl, info)
                    end
                end
                name = NewTbl[math.random(1, #NewTbl)]
                return name
            end
        end
    end
    return name
end

--奇遇事件运行
local function EvevtRun(actor, Event_Name)
    if InTheBox(actor, Event_Name) then return end
    if QiYuHeZi.AddEvent(actor, Event_Name) then
        Message.sendmsg(actor, ssrNetMsgCfg.QiYuHeZi_OpenEventUI, 0, 0, 0, { Event_Name }) --打开前端事假UI
        GameEvent.push(EventCfg.LuckyEventinitVar, actor, Event_Name)                      --奇遇触发后设置变量
    end
end

--执行奇遇事件随机取事件
local event = {}
event["召唤类"] = function(actor, num)
    local Event_Name = LuckyEventCfg[num].EnevtName
    EvevtRun(actor, Event_Name)
    Message.sendmsg(actor, ssrNetMsgCfg.QiYuZhaoHuan_SyncResponse, 0, 0, 0, { Event_Name })
end
event["副本类"] = function(actor, num)
    local Event_Name = LuckyEventCfg[num + 8].EnevtName
    EvevtRun(actor, Event_Name)
    Message.sendmsg(actor, ssrNetMsgCfg.QiYuFuBen_SyncResponse, 0, 0, 0, { Event_Name })
end
event["事件类"] = function(actor, num)
    local _Event_Name = LuckyEventCfg[math.random(17, 34)].EnevtName --随机取值事件
    local Event_Name = checkbuff(actor, _Event_Name)                 --buff查重 重新取事件
    EvevtRun(actor, Event_Name)
end

--杀怪触发
local function _onKillMon(actor, monobj, monName)
    local MonName = monName
    local cfg = LuckyMonCfg[MonName]
    if cfg then
        if randomex(1, cfg.Random_num) then
            local times = getplaydef(actor, VarCfg["N$奇遇内置间隔"])
            local state = (times == 0) or ((os.time() - times) >= 300) --当前为300秒
            if state then
                local result1, result2 = ransjstr("召唤类#3000|副本类#4000|事件类#3000", 1, 3)
                local num = cfg.Map_num
                release_print(result1, num)
                event[result1](actor, num)
                setplaydef(actor, VarCfg["N$奇遇内置间隔"], os.time())
            end
        end
    end
end
GameEvent.add(EventCfg.onKillMon, _onKillMon, LuckyEvent)
return LuckyEvent

local HuoDongDaTing = {}
HuoDongDaTing.ID = "活动大厅"
local npcID = 0
--local config = include("QuestDiary/cfgcsv/cfg_HuoDongDaTing.lua") --配置
local executeEventFunction = include("QuestDiary/game/A/executeEventFunction.lua")     --活动执行函数
local cost = {{}}
local give = {{}}
--接收请求
function HuoDongDaTing.Request(actor)
    --local name, num = Player.checkItemNumByTable(actor, cost)
    --if name then
        --Player.sendmsgEx(actor, string.format("你的|%s#249|不足|%d#249", name, num))
        --return
    --end
end

local function _gameEventTimer(minutes)
    local func = executeEventFunction[minutes]
    if func then
        func()
    end
end
GameEvent.add(EventCfg.gameEventTimer, _gameEventTimer, HuoDongDaTing)

Message.RegisterNetMsg(ssrNetMsgCfg.HuoDongDaTing, HuoDongDaTing)
return HuoDongDaTing
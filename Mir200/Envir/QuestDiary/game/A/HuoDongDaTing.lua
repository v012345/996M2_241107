local HuoDongDaTing = {}
HuoDongDaTing.ID = "�����"
local npcID = 0
--local config = include("QuestDiary/cfgcsv/cfg_HuoDongDaTing.lua") --����
local executeEventFunction = include("QuestDiary/game/A/executeEventFunction.lua")     --�ִ�к���
local cost = {{}}
local give = {{}}
--��������
function HuoDongDaTing.Request(actor)
    --local name, num = Player.checkItemNumByTable(actor, cost)
    --if name then
        --Player.sendmsgEx(actor, string.format("���|%s#249|����|%d#249", name, num))
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
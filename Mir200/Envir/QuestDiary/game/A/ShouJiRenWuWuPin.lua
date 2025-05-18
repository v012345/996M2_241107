local ShouJiRenWuWuPin = {}
local config = include("QuestDiary/cfgcsv/cfg_ShouJiRenWuWuPin.lua")
function ren_wu_shou_ji(actor,itemName)
    local cfg = config[itemName]
    if cfg then
        local num = getplaydef(actor,cfg.var)
        -- release_print(num)
        if num < cfg.max then
            setplaydef(actor,cfg.var,num+1)
        elseif num == cfg.max then
            local taskPanelID = getplaydef(actor, VarCfg["U_主线任务面板进度"])
            if taskPanelID == cfg.taskProgress then
                FCheckTaskRedPoint(actor)
            end
            setplaydef(actor,cfg.var,num+1)
        end
    end
    return true
end
return ShouJiRenWuWuPin
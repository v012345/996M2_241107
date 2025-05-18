local EnterDaLu = {}
local config = include("QuestDiary/cfgcsv/cfg_EnterDaLu.lua") -- 配置信息
local function checkHaFaXiSiTitle(actor)
    return checktitle(actor, "哈法西斯挑战者Lv3") or checktitle(actor, "哈法西斯挑战者Lv4") or checktitle(actor, "哈法西斯挑战者Lv5")
end
--判断下大陆的条件
local function CheckEnter(actor, npcid)
    if npcid == 114 or npcid == 204 then
        local myLevel = getbaseinfo(actor, ConstCfg.gbase.level)
        if myLevel < 100 then
            Player.sendmsgEx(actor, "[系统提示]#251|你的等级不足|100级#249")
            return false
        end
    elseif npcid == 317 then
        local reLevel = getbaseinfo(actor,ConstCfg.gbase.renew_level)
        if reLevel < 1 then
            Player.sendmsgEx(actor, "[系统提示]#251|需要人物一转#249")
            return false
        end
    elseif npcid == 318 then
        local reLevel = getbaseinfo(actor,ConstCfg.gbase.renew_level)
        if reLevel < 3 then
            Player.sendmsgEx(actor, "[系统提示]#251|需要人物三转#249")
            return false
        end
    elseif npcid == 445 then
        local reLevel = getbaseinfo(actor,ConstCfg.gbase.renew_level)
        local shiLianLevel = getplaydef(actor,VarCfg["U_地藏王的试炼"])
        if reLevel < 4 then
            Player.sendmsgEx(actor, "[系统提示]#251|需要人物四转#249")
            return false
        elseif shiLianLevel < 2 then
            Player.sendmsgEx(actor, "[系统提示]#251|需要完成[地藏王的二重试炼]#249")
            return false
        elseif not checktitle(actor,"冥魂引渡人") then
            Player.sendmsgEx(actor, "[系统提示]#251|需要称号[冥魂引渡人]#249")
            return false
        end
    --六大陆太阳圣城
    elseif npcid == 500 then
        local reLevel = getbaseinfo(actor,ConstCfg.gbase.renew_level)
        if reLevel < 5 then
            Player.sendmsgEx(actor, "[系统提示]#251|需要人物五转#249")
            return false
        end
        local myLevel = getbaseinfo(actor, ConstCfg.gbase.level)
        if myLevel < 335 then
            Player.sendmsgEx(actor, "[系统提示]#251|你的等级不足|335级#249")
            return false
        end
    elseif npcid == 600 then
        local reLevel = getbaseinfo(actor,ConstCfg.gbase.renew_level)
        if reLevel < 6 then
            Player.sendmsgEx(actor, "[系统提示]#251|需要人物六转#249")
            return false
        end
        local myLevel = getbaseinfo(actor, ConstCfg.gbase.level)
        if myLevel < 345 then
            Player.sendmsgEx(actor, "[系统提示]#251|你的等级不足|345级#249")
            return false
        end
        if not checkHaFaXiSiTitle(actor) then
            Player.sendmsgEx(actor, "[系统提示]#251|需要称号[哈法西斯挑战者Lv3]#249")
            return false
        end
    elseif npcid == 800 then
        local reLevel = getbaseinfo(actor,ConstCfg.gbase.renew_level)
        if reLevel < 7 then
            Player.sendmsgEx(actor, "[系统提示]#251|需要人物七转#249")
            return false
        end
        local myLevel = getbaseinfo(actor, ConstCfg.gbase.level)
        if myLevel < 355 then
            Player.sendmsgEx(actor, "[系统提示]#251|你的等级不足|355级#249")
            return false
        end
    end
    return true
end
--显示进入条件
local function ShowEnterCondition(actor, npcid)
    local result = {}
    local myLevel = getbaseinfo(actor, ConstCfg.gbase.level)
    local reLevel = getbaseinfo(actor,ConstCfg.gbase.renew_level)
    if npcid == 114 or npcid == 204 then
        local checkMark = ""
        local color = FGetColor({myLevel,100})
        local condition1 = { string.format("人物等级100级     <font color='%s'>(%d/100级)</font>%s",color, myLevel, checkMark)}
        table.insert(result, condition1)
    elseif npcid == 317 then
        local checkMark = ""
        local color = FGetColor({reLevel,1})
        local condition1 = { string.format("人物一转     <font color='%s'>(%d/1转)</font>%s",color, reLevel, checkMark)}
        table.insert(result, condition1)
    --四大陆酆都鬼城
    elseif npcid == 318 then
        local checkMark = ""
        local color = FGetColor({reLevel,3})
        local condition1 = { string.format("人物三转     <font color='%s'>(%d/3转)</font>%s",color, reLevel, checkMark)}
        table.insert(result, condition1)
    --五大陆极恶大陆    
    elseif npcid == 445 then
        local shiLianLevel = getplaydef(actor,VarCfg["U_地藏王的试炼"])
        local checkMark = ""
        local color = FGetColor({reLevel,4})
        local condition1 = { string.format("人物四转     <font color='%s'>(%d/4转)</font>%s",color, reLevel, checkMark)}
        -- local isFinish = 
        color = FGetColor(shiLianLevel >= 2)
        local str = shiLianLevel >= 2 and "(已完成)" or "(未完成)"
        local condition2 = { string.format("完成地藏王的二重试炼   <font color='%s'>%s</font>%s",color, str, checkMark)}

        color = FGetColor(checktitle(actor, "冥魂引渡人"))
        str = checktitle(actor, "冥魂引渡人") and "(已获得)" or "(未获得)"
        local condition3 = { string.format("称号[冥魂引渡人]     <font color='%s'>%s</font>%s",color, str, checkMark)}
        table.insert(result, condition3)
        table.insert(result, condition2)
        table.insert(result, condition1)
    elseif npcid == 500 then
        local checkMark = ""
        local color = FGetColor({reLevel,5})
        local condition1 = { string.format("人物五转     <font color='%s'>(%d/5转)</font>%s",color, reLevel, checkMark)}
        color = FGetColor({myLevel,335})
        local condition2 = { string.format("人物等级335级     <font color='%s'>(%d/335级)</font>%s",color, myLevel, checkMark)}
        table.insert(result, condition2)
        table.insert(result, condition1)
    elseif npcid == 600 then
        local checkMark = ""
        local color = FGetColor({reLevel,6})
        local condition1 = { string.format("人物六转     <font color='%s'>(%d/6转)</font>%s",color, reLevel, checkMark)}
        color = FGetColor({myLevel,345})
        local condition2 = { string.format("人物等级345级     <font color='%s'>(%d/345级)</font>%s",color, myLevel, checkMark)}
        color = FGetColor(checkHaFaXiSiTitle(actor))
        local str = checkHaFaXiSiTitle(actor) and "(已获得)" or "(未获得)"
        local condition3 = { string.format("称号[哈法西斯挑战者Lv3]     <font color='%s'>%s</font>%s",color, str, checkMark)}
        table.insert(result, condition3)
        table.insert(result, condition2)
        table.insert(result, condition1)
    elseif npcid == 800 then
        local checkMark = ""
        local color = FGetColor({reLevel,7})
        local condition1 = { string.format("人物七转     <font color='%s'>(%d/7转)</font>%s",color, reLevel, checkMark)}
        color = FGetColor({myLevel,355})
        local condition2 = { string.format("人物等级355级     <font color='%s'>(%d/355级)</font>%s",color, myLevel, checkMark)}
        table.insert(result, condition2)
        table.insert(result, condition1)
    end
    return result
end

--同步条件信息
function EnterDaLu.OpenUI(actor, npcid)
    local cfg = config[npcid]
    if not cfg then
        Player.sendmsgEx(actor, "参数错误!")
        return
    end
    local isOk = FCheckNPCRange(actor, npcid, 15)
    if not isOk then
        Player.sendmsgEx(actor, "NPC距离太远")
        return
    end
    local data = ShowEnterCondition(actor, npcid)

    Message.sendmsg(actor, ssrNetMsgCfg.EnterDaLu_OpenUI, 0, 0, 0, data)
end

--进入大陆
function EnterDaLu.Request(actor, npcid)
    local cfg = config[npcid]
    if not cfg then
        Player.sendmsgEx(actor, "参数错误!")
        return
    end
    local isOk = FCheckNPCRange(actor, npcid, 15)
    if not isOk then
        Player.sendmsgEx(actor, "NPC距离太远")
        return
    end
    if npcid == 900 then
        Player.sendmsgEx(actor, "暂未开放此大陆!#249")
        return
    end
    local isMeetThenCondition = CheckEnter(actor, npcid)
    if not isMeetThenCondition then
        return
    else
    -- release_print(cfg.mapId, cfg.x, cfg.y)
    local num = getplaydef(actor, VarCfg["U_记录大陆"])
    if num < cfg.number then
        setplaydef(actor, VarCfg["U_记录大陆"], cfg.number)
    end
    mapmove(actor, cfg.mapId, cfg.x, cfg.y, 1)
    end
end

local function _onLoginEnd(actor)
    local currDaLu = getplaydef(actor, VarCfg["U_记录大陆"])
    if currDaLu == 0 then
        setplaydef(actor, VarCfg["U_记录大陆"], 1)
    end
end
--事件派发
GameEvent.add(EventCfg.onLoginEnd, _onLoginEnd, EnterDaLu)
--注册消息
Message.RegisterNetMsg(ssrNetMsgCfg.EnterDaLu, EnterDaLu)

return EnterDaLu

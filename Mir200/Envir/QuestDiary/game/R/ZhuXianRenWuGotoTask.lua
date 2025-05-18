local ZhuXianRenWuGotoTask = {}
ZhuXianRenWuGotoTask[1] = function(actor, taskID, way, cfg)
    local currDalu = getplaydef(actor, VarCfg["U_记录大陆"])
    if currDalu < cfg.dalu then
        local chinaNumber = formatNumberToChinese(cfg.dalu)
        Player.sendmsgEx(actor, string.format("你没有解锁|%s大陆#249", chinaNumber))
        return
    end
    local mapID = way[2] or ""
    if mapID == "亡魂塔" then
        FOpenNpcShowEx(actor, 413)
        return
    elseif mapID == "失落鬼域" then
        FOpenNpcShowEx(actor, 3064)
        return
    elseif mapID == "暗黑之地" then
        FOpenNpcShowEx(actor, 3456)
        return
    elseif mapID == "哥布林洞窟" then
        FOpenNpcShowEx(actor, 513)
        return
    elseif mapID == "永恒密道1层" then
        messagebox(actor,"请前往[永恒之城]寻找线索,进入永恒密道1层击杀怪物!")
        return
    elseif mapID == "幽冥沉船" then
        FOpenNpcShowEx(actor, 610)
        return
    elseif mapID == "死亡之堡底层" then
        FOpenNpcShowEx(actor, 706)
        return
    elseif mapID == "黑度通道" then
        FOpenNpcShowEx(actor, 708)
        return
    end
    FMapEx(actor, mapID, true)
end
ZhuXianRenWuGotoTask[2] = function(actor, taskID, way, cfg)
    local name = way[2] or ""
    --首次引导
    -- if name == "鸿蒙太初镜" then
    Message.sendmsg(actor, ssrNetMsgCfg.ZhuXianRenWu_UpdateGuideTask, ConstCfg.GuideTaskInfo["修仙"])
    local client = getconst(actor, "<$CLIENTFLAG>")
    if client == "1" then
        navigation(actor, 104, 1000, "点击")
    else
        navigation(actor, 107, 1000, "点击")
    end
    -- end
end
--等级
ZhuXianRenWuGotoTask[3] = function(actor, taskID, way)
    local level = way[2] or 0
    Player.sendmsgEx(actor, level .. "级完成任务#249")
end

--变量
ZhuXianRenWuGotoTask[4] = function(actor, taskID, way, cfg)
    local var   = way[2]
    local npcID = way[4]
    --边关奖励
    if var == "U10" then
        if not FCheckLevel(actor, 80) then
            Player.sendmsgEx(actor, "等级不足80,无法传送!")
            return
        end
        FOpenNpcShowEx(actor, npcID)
    elseif var == "U53" then
        if not FCheckLevel(actor, 80) then
            Player.sendmsgEx(actor, "等级不足80,无法传送!")
            return
        end
        FOpenNpcShowEx(actor, npcID)
    elseif var == "U46" then
        FMapEx(actor,"祭坛")
        Player.sendmsgEx(actor, "在祭坛(35,17),开启黑齿笔记")
    elseif var == "U129" then
        Player.sendmsgEx(actor, "同时穿戴6件专属即可完成任务")
    elseif var == "U177" then
        FMapEx(actor,"风之洞穴",true)
        Player.sendmsgEx(actor,"已经为你传送到任务地图")
    elseif var == "U178" then
        FMapEx(actor,"湿婆神殿二层",true)
        Player.sendmsgEx(actor,"已经为你传送到任务地图")
    elseif var == "U179" then
        FMapEx(actor,"放逐之域二层",true)
        Player.sendmsgEx(actor,"已经为你传送到任务地图")
    elseif var == "U185" then
        FMapEx(actor,"神庙内部",true)
        Player.sendmsgEx(actor,"已经为你传送到任务地图")
    elseif var == "U186" then
        FMapEx(actor,"神庙内部",true)
        Player.sendmsgEx(actor,"已经为你传送到任务地图")
    elseif var == "U181" then
        FMapEx(actor,"湖心岛",true)
        Player.sendmsgEx(actor,"已经为你传送到任务地图")
    elseif var == "U180" then
        FMapEx(actor,"湖心岛",true)
        Player.sendmsgEx(actor,"已经为你传送到任务地图")
    elseif var == "U182" then
        FMapEx(actor,"魔兽山脉",true)
        Player.sendmsgEx(actor,"已经为你传送到任务地图")
    else
        FOpenNpcShowEx(actor, npcID)
    end 
end
--标识
ZhuXianRenWuGotoTask[5] = function(actor, taskID, way, cfg)
    local flag = way[2]
    local npcID = way[4]
    --了解气运
    if flag == 186 then
        Message.sendmsg(actor, ssrNetMsgCfg.ZhuXianRenWu_UpdateGuideTask, ConstCfg.GuideTaskInfo["气运"])
        local client = getconst(actor, "<$CLIENTFLAG>")
        if client == "1" then
            navigation(actor, 104, 1000, "点击")
        else
            navigation(actor, 107, 1000, "点击")
        end
        --空间法师
    elseif flag == 9 then
        if not FCheckLevel(actor, 60) then
            Player.sendmsgEx(actor, "等级不足60,无法传送!")
            return
        end
        -- local cost = { { "破碎的魔法阵", 20 } }
        -- local name, num = Player.checkItemNumByTable(actor, cost)
        -- if name then
        --     Player.sendmsgEx(actor, string.format("你的|%s#249|不足|%d#249|,已经为你传送到任务地图!", name, num))
        --     local mapIDs = { "后山", "妖怪山谷", "仙木林", "风之洞穴" }
        --     local mapID = mapIDs[math.random(1, 4)]
        --     FMapEx(actor, mapID, true)
        --     return
        -- end
        -- FOpenNpcShowEx(actor, npcID)
    -- elseif flag == 8 then
    --     if not FCheckLevel(actor, 60) then
    --         Player.sendmsgEx(actor, "等级不足60,无法传送!")
    --         return
    --     end
    --     local cost = { { "小妖精魄", 88 } }
    --     local name, num = Player.checkItemNumByTable(actor, cost)
    --     if name then
    --         Player.sendmsgEx(actor, string.format("你的|%s#249|不足|%d#249|,已经为你传送到任务地图!", name, num))
    --         local mapIDs = { "后山", "妖怪山谷", "仙木林", "风之洞穴" }
    --         local mapID = mapIDs[math.random(1, 4)]
    --         FMapEx(actor, mapID, true)
    --         return
    --     end
        FOpenNpcShowEx(actor, npcID)
    elseif flag == 188 then
        if not FCheckLevel(actor, 120) then
            Player.sendmsgEx(actor, "等级不足120,无法传送!")
            return
        end
        FOpenNpcShowEx(actor, npcID)
    elseif flag == 189 then
        if not FCheckLevel(actor, 120) then
            Player.sendmsgEx(actor, "等级不足120,无法传送!")
            return
        end
        FOpenNpcShowEx(actor, npcID)
    elseif flag == 190 then
        if not FCheckLevel(actor, 120) then
            Player.sendmsgEx(actor, "等级不足120,无法传送!")
            return
        end
        FOpenNpcShowEx(actor, npcID)
    elseif flag == 199 then
        Message.sendmsg(actor, ssrNetMsgCfg.ZhuXianRenWu_UpdateGuideTask, ConstCfg.GuideTaskInfo["后天气运开启"])
        local client = getconst(actor, "<$CLIENTFLAG>")
        if client == "1" then
            navigation(actor, 104, 1000, "点击")
        else
            navigation(actor, 107, 1000, "点击")
        end
    else
        FOpenNpcShowEx(actor, npcID)
    end
end

ZhuXianRenWuGotoTask[6] = function(actor, taskID, way)
    local mapID = way[2] or 0
    FMapEx(actor, mapID, true)
end

--杀戮刻印Lv.5
ZhuXianRenWuGotoTask[7] = function(actor, taskID, way)
    local npcID = way[3]
    FOpenNpcShowEx(actor, npcID)
end

--疾风刻印Lv.5
ZhuXianRenWuGotoTask[8] = function(actor, taskID, way)
    local npcID = way[3]
    FOpenNpcShowEx(actor, npcID)
end
--称号
ZhuXianRenWuGotoTask[9] = function(actor, taskID, way)
    local npcID = way[3]
    FOpenNpcShowEx(actor, npcID)
end
--比较大小
ZhuXianRenWuGotoTask[10] = function(actor, taskID, way)
    local var = way[2]
    local npcID = way[4]
    if var == "U148" then
        local client = getconst(actor, "<$CLIENTFLAG>")
        if client == "1" then
            navigation(actor, 104, 1000, "点击")
        else
            navigation(actor, 107, 1000, "点击")
        end
        Message.sendmsg(actor, ssrNetMsgCfg.ZhuXianRenWu_UpdateGuideTask, ConstCfg.GuideTaskInfo["装扮"])
    else
        FOpenNpcShowEx(actor, npcID)
    end
end

ZhuXianRenWuGotoTask[11] = function(actor, taskID, way)
    local level = way[2] or 0
    local npcID = way[3]
    if npcID then
        FOpenNpcShowEx(actor, npcID)
    end
    
    -- Player.sendmsgEx(actor, level .. "转完成任务#249")
end

--气运
ZhuXianRenWuGotoTask[12] = function(actor, taskID, way)
    Message.sendmsg(actor, ssrNetMsgCfg.ZhuXianRenWu_UpdateGuideTask, ConstCfg.GuideTaskInfo["气运"])
    local client = getconst(actor, "<$CLIENTFLAG>")
    if client == "1" then
        navigation(actor, 104, 1000, "点击")
    else
        navigation(actor, 107, 1000, "点击")
    end
end

--装扮
ZhuXianRenWuGotoTask[13] = function(actor, taskID, way)
    local num = way[2]
    Player.sendmsgEx(actor, "收集" .. num .. "套装扮即可完成任务!")
end

--检测物品
ZhuXianRenWuGotoTask[14] = function(actor, taskID, way)
    local itemName = way[2]
    local itemNum = way[3]
    local mapID = way[4]
    local npcID = way[5]
    if mapID ~= "无" then
        Player.sendmsgEx(actor, string.format("你背包的|%s#249|不足|%d#249|,已经为你传送到任务地图!", itemName, itemNum))
        FMapEx(actor, mapID, true)
        return
    end
    if npcID > 0 then
        FOpenNpcShowEx(actor, npcID)
    end
end


return ZhuXianRenWuGotoTask

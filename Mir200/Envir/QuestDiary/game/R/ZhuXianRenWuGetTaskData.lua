local ZhuXianRenWuGetTaskData = {}

local getTypeFunc = {}
--杀怪任务
getTypeFunc[1] = function(actor, data)
    local mapID = data[2] or ""
    local monName = data[3] or ""
    local var = data[4]
    local max = data[5]
    local currNum = getplaydef(actor, var)
    return { currNum, max }
end
--修仙装备
getTypeFunc[2] = function(actor, data)
    local equipName = data[2]
    if not equipName then
        return false
    end
    local equipObj = linkbodyitem(actor, 43)
    if equipObj == "0" then
        return false
    end
    local currNum = getiteminfo(actor, equipObj, ConstCfg.iteminfo.idx)
    local max = getstditeminfo(equipName, ConstCfg.stditeminfo.idx)
    return currNum >= max
end
--人物等级
getTypeFunc[3] = function(actor, data)
    local currLevel = getbaseinfo(actor,ConstCfg.gbase.level)
    local maxLvel = data[2]
    if currLevel < maxLvel then
        return {currLevel, maxLvel}
    else
        return true
    end
    
end
--变量
getTypeFunc[4] = function(actor, data)
    local cuurnum = getplaydef(actor,data[2])
    local max = data[3]
    return {cuurnum, max}
end
--标识
getTypeFunc[5] = function(actor, data)
    local cuurnum = getflagstatus(actor,data[2])
    return {cuurnum, 1}
end
--收集物品
getTypeFunc[6] = function(actor, data)
    local cuurnum = getplaydef(actor,data[4])
    local max = data[5]
    return {cuurnum, max}
end
--杀戮刻印
getTypeFunc[7] = function(actor, data)
    local equipName = data[2]
    if not equipName then
        return false
    end
    local equipObj = linkbodyitem(actor, 12)
    if equipObj == "0" then
        return false
    end
    local currNum = getiteminfo(actor, equipObj, ConstCfg.iteminfo.idx)
    local max = getstditeminfo(equipName, ConstCfg.stditeminfo.idx)
    return currNum >= max
end
--疾风刻印
getTypeFunc[8] = function(actor, data)
    local equipName = data[2]
    if not equipName then
        return false
    end
    local equipObj = linkbodyitem(actor, 14)
    if equipObj == "0" then
        return false
    end
    local currNum = getiteminfo(actor, equipObj, ConstCfg.iteminfo.idx)
    local max = getstditeminfo(equipName, ConstCfg.stditeminfo.idx)
    return currNum >= max
end
--称号
getTypeFunc[9] = function(actor, data)
    local titleName = data[2]
    return checktitle(actor, titleName)
end
--江湖称号
getTypeFunc[10] = function(actor, data)
    local cuurnum = getplaydef(actor,data[2])
    local max = data[3]
    return cuurnum >= max
end
--转生
getTypeFunc[11] = function(actor, data)
    local reLevel = getbaseinfo(actor,ConstCfg.gbase.renew_level)
    local maxLvel = data[2]
    return {reLevel, maxLvel}
end
--气运数量
getTypeFunc[12] = function(actor, data)
    local num = TianMing.GetTianMingNum(actor, data[2])
    local max = data[3]
    return {num, max}
end
--装扮
getTypeFunc[13] = function(actor, data)
    local num = ZhuangBan.GetZhuangBanTotalNum(actor)
    local max = data[2]
    return {num, max}
end
--检测背包物品
getTypeFunc[14] = function(actor, data)
    local itemName = data[2]
    if not itemName then
        return
    end
    local num = getbagitemcount(actor, itemName)
    local max = data[3]
    return {num, max}
end
function ZhuXianRenWuGetTaskData.getTaskDatas(actor, taskID, way)
    if not way then
        return {}
    end
    local result = {}
    for _, value in ipairs(way) do
        local taskType = value[1]
        local func = getTypeFunc[taskType]
        if func then
            local tmpTbl = func(actor, value)
            table.insert(result, tmpTbl)
        end
    end
    return result
end
ZhuXianRenWuGetTaskData.GetData = function(actor, taskID, cfg)
    local data1 = {}
    local data2 = {}
    local data3 = {}
    local data4 = {}
    data1 = ZhuXianRenWuGetTaskData.getTaskDatas(actor, taskID, cfg.way1)
    data2 = ZhuXianRenWuGetTaskData.getTaskDatas(actor, taskID, cfg.way2)
    data3 = ZhuXianRenWuGetTaskData.getTaskDatas(actor, taskID, cfg.way3)
    data4 = ZhuXianRenWuGetTaskData.getTaskDatas(actor, taskID, cfg.way4)
    return { data1, data2, data3, data4 }
end



return ZhuXianRenWuGetTaskData

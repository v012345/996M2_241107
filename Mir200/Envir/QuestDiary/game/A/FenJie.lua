local FenJie = {}

local config = cfg_fen_jie

function FenJie.Request(actor, arg1, arg2, arg3, data)
    if #data == 0 then
        return
    end
    local isHuiShou = false
    local giveItems = {}
    local giveArray = {}
    for _, value in ipairs(data) do
        local config = config[value]
        if config then
            local itemName = config.equipName
            local itemNum = getbagitemcount(actor, config.equipName)
            if itemNum > 0 then
                local isSuccess = takeitemex(actor, itemName, itemNum, 0, "装备分解") --拿走物品
                if isSuccess then
                    for i, v in ipairs(config.give) do
                        if not giveItems[v[1]] then --如果key是空的，就创建一个key
                            giveItems[v[1]] = v[2] * itemNum
                        else
                            giveItems[v[1]] = giveItems[v[1]] + v[2] * itemNum --如果不是空的就在原有的奖励累加
                        end
                    end 
                end
                isHuiShou = true
            end
        end
    end
    if not isHuiShou then
        messagebox(actor, "[系统提示]：\n\n    你背包内没有可以分解的装备！")
    end
    --把奖励key转换成数组
    for key, value in pairs(giveItems) do
        local Array = { key, value }
        table.insert(giveArray, Array)
    end
    if isHuiShou then
        local gives = {}
        Player.giveItemByTable(actor, giveArray, "系统回收给予", 1)
        for index, value in ipairs(giveArray) do
            table.insert(gives, string.format("[%s*%d]", value[1], value[2]))
        end
        local finalStr = table.concat(gives, ",")
        messagebox(actor, "[系统提示]：\n\n    已分解装备成功,获得"..finalStr)
    end
end

Message.RegisterNetMsg(ssrNetMsgCfg.FenJie, FenJie)
return FenJie
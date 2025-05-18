TianMing = {}
TianMing.ID = "天命"
local TianMingList = {
    [1] = include("QuestDiary/cfgcsv/cfg_TianMing_Fan.lua"),   --天命凡
    [2] = include("QuestDiary/cfgcsv/cfg_TianMing_Ling.lua"),  --天命灵
    [3] = include("QuestDiary/cfgcsv/cfg_TianMing_Xian.lua"),  --天命仙
    [4] = include("QuestDiary/cfgcsv/cfg_TianMing_Sheng.lua"), --天命凡
    [5] = include("QuestDiary/cfgcsv/cfg_TianMing_Di.lua"),    --天命帝
}
--[[
凡 - 40%
灵 - 30%
仙 - 15%
凡 - 10%
帝 - 5%
]]
local weight = "1#40|2#30|3#15|4#10|5#5" --权重

--枚举消耗类型
local CostType = {
    [1] = { { "气运精魄", 1 } }, --1
    [2] = { { "转运金丹", 1 } }, --2
    [3] = { { "灵符", 200 } }, -- 3
}

--枚举品质名称
local enumeQualityName = {
    [1] = "凡品",
    [2] = "灵品",
    [3] = "仙品",
    [4] = "圣品",
    [5] = "帝品",
}

--枚举五种气运图鉴变量
local enumeTianMingVar = {
    [1] = VarCfg.T_TianMing_Fan,
    [2] = VarCfg.T_TianMing_Ling,
    [3] = VarCfg.T_TianMing_Xian,
    [4] = VarCfg.T_TianMing_Sheng,
    [5] = VarCfg.T_TianMing_Di,
}

--枚举激活图鉴后的提示文字颜色
local enumeTianMingColor = {
    [1] = "7",
    [2] = "168",
    [3] = "241",
    [4] = "58",
    [5] = "249",
}

--图鉴配置
local TianMingTuJianConfig = {
    [1] = { var = VarCfg.T_TianMing_Fan, max = 18, attr = { [1] = 10000, [4] = 5000 }, baoLvAddtion = { [218] = 5 } },
    [2] = { var = VarCfg.T_TianMing_Ling, max = 20, attr = { [75] = 1500, [200] = 30000 }, baoLvAddtion = { [218] = 10 } },
    [3] = { var = VarCfg.T_TianMing_Xian, max = 24, attr = { [21] = 15, [22] = 15 }, baoLvAddtion = { [218] = 20 } },
    [4] = { var = VarCfg.T_TianMing_Sheng, max = 28, attr = { [79] = 1500, [80] = 15 }, baoLvAddtion = { [218] = 30 } },
    [5] = { var = VarCfg.T_TianMing_Di, max = 34, attr = { [208] = 15, [209] = 15, [210] = 15, [211] = 15, [212] = 15, [213] = 15, [214] = 15, [221] = 15, [222] = 15, [223] = 15, [224] = 15, [225] = 15, [202] = 1 }, baoLvAddtion = { [218] = 30 } },
}
--枚举图鉴激活后首次提示标识
local enumeTianMingFirstTipFalg = {
    [1] = VarCfg["F_天命图鉴凡首次完成"],
    [2] = VarCfg["F_天命图鉴灵首次完成"],
    [3] = VarCfg["F_天命图鉴仙首次完成"],
    [4] = VarCfg["F_天命图鉴圣首次完成"],
    [5] = VarCfg["F_天命图鉴帝首次完成"],
}

--后天开启
local enumeOpenHouTian = {
    [1] = { { "后天造化箓", 10 } },
    [2] = { { "后天造化箓", 10 } },
    [3] = { { "后天造化箓", 10 } },
    [4] = { { "后天造化箓", 10 } },
    [5] = { { "后天造化箓", 10 } },
    [6] = { { "后天造化箓", 10 } },
    [7] = { { "后天造化箓", 10 } },
    [8] = { { "后天造化箓", 10 } },
    [9] = { { "后天造化箓", 10 } },
    [10] = { { "后天造化箓", 10 } },
}

--后天开启标识
local enumeOpenHouTianFlag = {
    [1] = VarCfg["F_后天气运开启_1"],
    [2] = VarCfg["F_后天气运开启_2"],
    [3] = VarCfg["F_后天气运开启_3"],
    [4] = VarCfg["F_后天气运开启_4"],
    [5] = VarCfg["F_后天气运开启_5"],
    [6] = VarCfg["F_后天气运开启_6"],
    [7] = VarCfg["F_后天气运开启_7"],
    [8] = VarCfg["F_后天气运开启_8"],
    [9] = VarCfg["F_后天气运开启_9"],
    [10] = VarCfg["F_后天气运开启_10"],
}
----------------天命缓存---------------------
local TianMingBuffList = include("QuestDiary/game/A/TianMingBuffList.lua")
local TianMingFunc = include("QuestDiary/game/A/TianMingFunc.lua")
--所有专属
TianMing.ZhuanShu = include("QuestDiary/cfgcsv/cfg_ZhuanShu.lua")
--获取所有天命列表---首次获取
local function GetTianMingList(actor)
    local result = {}
    --判断角色是否在跨服
    if checkkuafu(actor) then
        local arr1 = json2tbl(getplayvar(actor, "HUMAN", "KFZF1"))
        local arr2 = json2tbl(getplayvar(actor, "HUMAN", "KFZF2"))
        result = table.appendArray(arr1, arr2)
    else
        for i = 1, 24 do
            local Tvar = VarCfg["T_天命记录_" .. i]
            if Tvar then
                local value = Player.getJsonTableByVar(actor, Tvar)
                table.insert(result, value)
            end
        end
    end
    return result
end

--添加攻击被攻击等效果
local function AddAttackBuff(actor, cache, attackType, buffId)
    if type(attackType) == "number" then
        local tmpTbl = cache[attackType]
        table.insert(tmpTbl, buffId)
        table.uniqueArray(tmpTbl) --删除重复避免出现BUG
    elseif type(attackType) == "table" then
        for i, v in ipairs(attackType) do
            local tmpTbl = cache[v]
            table.insert(tmpTbl, buffId[i] or 0)
            table.uniqueArray(tmpTbl) --删除重复避免出现BUG
        end
    end
end

--添加攻击被攻击等效果
local function DelAttackBuff(actor, cache, attackType, buffId)
    if type(attackType) == "number" then
        local tmpTbl = cache[attackType]
        table.removebyvalue(tmpTbl, buffId)
        table.uniqueArray(tmpTbl) --删除重复避免出现BUG
    elseif type(attackType) == "table" then
        for i, v in ipairs(attackType) do
            local tmpTbl = cache[v]
            table.removebyvalue(tmpTbl, buffId[i] or 0)
            table.uniqueArray(tmpTbl) --删除重复避免出现BUG
        end
    end
end


local tianMingBuffCahce = {}
--初始化缓存
local function initCache(actor)
    tianMingBuffCahce[actor] = {
        ["攻击被攻击效果"] = {
            [1]  = {}, --全部攻击触发               （1000开头）
            [2]  = {}, --攻击人触发                 （2000开头）
            [3]  = {}, --攻击怪物触发               （3000开头）
            [4]  = {}, --全部攻击前触发（掉血前）    （4000开头）
            [5]  = {}, --攻击人前触发（掉血前）      （5000开头）
            [6]  = {}, --攻击怪物前触发（掉血前）    （6000开头）
            [7]  = {}, --被全部攻击触发             （7000开头）
            [8]  = {}, --被人攻击触发               （8000开头）
            [9]  = {}, --被怪物攻击触发             （9000开头）
            [10] = {}, --被全部攻击触发--前         （10000开头）
            [11] = {}, --被人攻击触发--前           （11000开头）
            [12] = {}, --被怪物攻击触发--前         （12000开头）
            [13] = {}, --其他效果                  （13000开头）
            [14] = {}, --杀怪                      （14000开头）
            [15] = {}, --杀人                      （15000开头）
            [16] = {}, --是死亡                    （16000开头）
        },
        ["天命缓存"] = {},
    }
    local tianMingList = GetTianMingList(actor)
    tianMingBuffCahce[actor]["天命缓存"] = tianMingList
    for index, value in ipairs(tianMingList) do
        if #value > 1 then
            local cfg = TianMingList[value[1]][value[2]]
            -- dump(cfg)
            if cfg then
                if type(cfg.TMtype) == "number" then
                    if cfg.TMtype == 1 and cfg.buffId ~= nil then
                        local tmpTbl = tianMingBuffCahce[actor]["攻击被攻击效果"]
                        AddAttackBuff(actor, tmpTbl, cfg.attackType, cfg.buffId)
                    end
                end
                --如果有多个
                if type(cfg.TMtype) == "table" then
                    for _, v in ipairs(cfg.TMtype) do
                        if v == 1 and cfg.buffId ~= nil then
                            local tmpTbl = tianMingBuffCahce[actor]["攻击被攻击效果"]
                            AddAttackBuff(actor, tmpTbl, cfg.attackType, cfg.buffId)
                        end
                    end
                end
            end
        end
    end
end
--重载给缓存
local function reloadInitCache()
    local playerList = getplayerlst(1)
    for _, actor in ipairs(playerList) do
        if not getbaseinfo(actor, ConstCfg.gbase.offline) then
            initCache(actor)
        end
    end
end

--重载给缓存
reloadInitCache()
-- dump(tianMingBuffCahce)

--清理天命的缓存
function TianMing.clearCache(actor)
    tianMingBuffCahce[actor] = nil
end
--设置缓存
function TianMing.setCache(actor)
    initCache(actor)
end
--获取所有天命列表
function TianMing.GetTianMingList(actor)
    if tianMingBuffCahce[actor] then
        if #tianMingBuffCahce[actor]["天命缓存"] > 0 then
            return tianMingBuffCahce[actor]["天命缓存"]
        end
    end
    local result = {}
    for i = 1, 24 do
        local Tvar = VarCfg["T_天命记录_" .. i]
        if Tvar then
            local value = Player.getJsonTableByVar(actor, Tvar)
            table.insert(result, value)
        end
    end
    return result
end

--根据品质获取天命数量
function TianMing.GetTianMingNum(actor, quality)
    local TianMingList = TianMing.GetTianMingList(actor)
    local num = 0
    for _, value in ipairs(TianMingList) do
        if value[1] == quality then
            num = num + 1
        end
    end
    return num
end

--获取已经存在的天命列表，主要用于重复检测
function TianMing.GetHasTianMingList(actor, quality)
    local result = TianMing.GetTianMingList(actor)
    local newResult = {}
    for index, value in ipairs(result) do
        if #value > 0 then
            if not newResult[value[1]] then
                newResult[value[1]] = { value[2] }
            else
                table.insert(newResult[value[1]], value[2])
            end
        end
    end
    return newResult[quality]
end

--判断天命的解锁状态
function TianMing.GetLockState(actor, pos)
    --初始化状态
    local unLockArr = {
        [1] = 0,
        [2] = 0,
        [3] = 0,
        [4] = 0,
        [5] = 0,
        [6] = 0,
        [7] = 0,
        [8] = 0,
        [9] = 0,
        [10] = 0,
        [11] = 0,
        [12] = 0,
        [13] = 0,
        [14] = 0,
        [15] = 0,
        [16] = 0,
        [17] = 0,
        [18] = 0,
        [19] = 0,
        [20] = 0,
        [21] = 0,
        [22] = 0,
        [23] = 0,
        [24] = 0,
    }
    local reLevel = getbaseinfo(actor, ConstCfg.gbase.renew_level) --转生等级
    local maxLevel = getplaydef(actor, VarCfg["U_最大升级过的等级"]) --曾经的最大等级
    local vipLevel = getplaydef(actor, VarCfg["U_VIP等级"])

    local fanNumTbl = Player.getJsonTableByVar(actor, VarCfg.T_TianMing_Fan)
    local fanNum = table.nums(fanNumTbl) or 0
    local lingNumTbl = Player.getJsonTableByVar(actor, VarCfg.T_TianMing_Sheng)
    local lingNum = table.nums(lingNumTbl) or 0

    --先天气运
    unLockArr[1] = maxLevel >= 60 and 1 or 0
    unLockArr[2] = maxLevel >= 80 and 1 or 0
    unLockArr[3] = maxLevel >= 100 and 1 or 0
    unLockArr[4] = maxLevel >= 120 and 1 or 0
    unLockArr[5] = maxLevel >= 180 and 1 or 0
    unLockArr[6] = maxLevel >= 240 and 1 or 0
    unLockArr[7] = reLevel >= 1 and 1 or 0
    unLockArr[8] = reLevel >= 2 and 1 or 0
    unLockArr[9] = reLevel >= 3 and 1 or 0
    unLockArr[10] = reLevel >= 4 and 1 or 0
    unLockArr[11] = reLevel >= 5 and 1 or 0
    unLockArr[12] = reLevel >= 6 and 1 or 0

    --后天气运
    unLockArr[13] = getflagstatus(actor, VarCfg["F_后天气运开启_1"])
    unLockArr[14] = getflagstatus(actor, VarCfg["F_后天气运开启_2"])
    unLockArr[15] = getflagstatus(actor, VarCfg["F_后天气运开启_3"])
    unLockArr[16] = getflagstatus(actor, VarCfg["F_后天气运开启_4"])
    unLockArr[17] = getflagstatus(actor, VarCfg["F_后天气运开启_5"])
    unLockArr[18] = getflagstatus(actor, VarCfg["F_后天气运开启_6"])
    unLockArr[19] = getflagstatus(actor, VarCfg["F_后天气运开启_7"])
    unLockArr[20] = getflagstatus(actor, VarCfg["F_后天气运开启_8"])
    unLockArr[21] = getflagstatus(actor, VarCfg["F_后天气运开启_9"])
    unLockArr[22] = getflagstatus(actor, VarCfg["F_后天气运开启_10"])
    unLockArr[23] = fanNum >= TianMingTuJianConfig[1].max and 1 or 0
    unLockArr[24] = lingNum >= TianMingTuJianConfig[4].max and 1 or 0
    if not pos then
        return unLockArr
    else
        return unLockArr[pos]
    end
end

--根据位置激活后天气运
function TianMing.OpenHouTian(actor, index)
    local cost = enumeOpenHouTian[index]
    if not cost then
        Player.sendmsgEx(actor, "参数错误!#249")
        return
    end
    local flag = enumeOpenHouTianFlag[index]
    if not flag then
        Player.sendmsgEx(actor, "参数错误2!#249")
        return
    end
    if getflagstatus(actor, flag) == 1 then
        Player.sendmsgEx(actor, "你已经激活过了!#249")
        return
    end
    local name, num = Player.checkItemNumByTable(actor, cost)
    if name then
        Player.sendmsgEx(actor, string.format("你的|%s#249|不足|%d#249|,完成|主线任务#249|和|剧情任务#249|可获得|%s#249", name, num, name))
        return
    end
    Player.takeItemByTable(actor, cost, "开启后天气运" .. index)
    setflagstatus(actor, VarCfg["F_激活任意后天气运"], 1)
    setflagstatus(actor, flag, 1)
    Player.sendmsgEx(actor, "开启成功后天气运成功!")
    Message.sendmsg(actor, ssrNetMsgCfg.TianMing_OpenHouTian, index)
end

--添加天命到变量中包括图鉴
---* actor：玩家
---* pos：天命位置
---* quality：天命品质
---* value：天命编号
function TianMing.AddTianMing(actor, pos, quality, value)
    --记录天命
    local Tvar = VarCfg["T_天命记录_" .. pos]
    if Tvar then
        local t = { quality, value }
        Player.setJsonVarByTable(actor, Tvar, t)
        tianMingBuffCahce[actor]["天命缓存"][pos] = t
    end
    --添加天命图鉴
    local tuJianVar = enumeTianMingVar[quality]
    if tuJianVar then
        --点亮图鉴
        local tbl = Player.getJsonTableByVar(actor, tuJianVar)
        if not tbl[tostring(value)] then
            tbl[tostring(value)] = 1
            local qualityName = enumeQualityName[quality]
            local tianMingName = TianMingList[quality][value].name or ""
            local color = enumeTianMingColor[quality]
            Player.setJsonVarByTable(actor, tuJianVar, tbl)
            Player.sendmsgEx(actor, string.format("恭喜你解锁新图鉴|%s·%s#%s", qualityName, tianMingName, color))
            Player.setAttList(actor, "属性附加")
            Player.setAttList(actor, "爆率附加")
        end
    end
end

--标识类buff处理
---* actor：玩家
---* flagVar：标识变量
---* flagValue：标识值
function TianMing.SetFlagBuffAndRunFunc(actor, flagVar, flagValue)
    setflagstatus(actor, flagVar, flagValue)
    local func = TianMingFunc[flagVar]
    if func then
        func(actor, 1)
    end
end

--添加buff和其他缓存
---* actor：玩家
---* cfg：天命配置
function TianMing.AddTianMingCahce(actor, TMtype, cfg)
    if TMtype == 1 and cfg.buffId ~= nil then
        local tmpTbl = tianMingBuffCahce[actor]["攻击被攻击效果"]
        AddAttackBuff(actor, tmpTbl, cfg.attackType, cfg.buffId)
    elseif TMtype == 2 then
        Player.setAttList(actor, "属性附加")
    elseif TMtype == 3 then
        TianMing.SetFlagBuffAndRunFunc(actor, cfg.value, 1)
    elseif TMtype == 4 and cfg.buffId ~= nil then
        addbuff(actor, cfg.buffId)
    elseif TMtype == 6 then
        local userId = getbaseinfo(actor, ConstCfg.gbase.id)
        Player.sendmsgEx(actor, "恭喜获得[一夜暴富],请到邮件领取3000W金币!")
        sendmail(userId, 1, "一夜暴富", "选择后直接获得3000W绑定金币,请领取", "绑定金币#30000000#0")
    elseif TMtype == 7 then
        local liveMax = getplaydef(actor, VarCfg["U_等级上限"])
        setplaydef(actor, VarCfg["U_等级上限"], liveMax + cfg.value)
        setlocklevel(actor, 1, getplaydef(actor, VarCfg["U_等级上限"]))
        -- changelevel(actor, "+", cfg.value)
    end
end

--清楚buff和其他缓存
---* actor：玩家
---* cfg：天命配置
function TianMing.DelTianMingCahce(actor, TMtype, lastCfg)
    if TMtype == 1 and lastCfg.buffId ~= nil then
        local tmpTbl = tianMingBuffCahce[actor]["攻击被攻击效果"] --读取缓存
        DelAttackBuff(actor, tmpTbl, lastCfg.attackType, lastCfg.buffId)
    elseif TMtype == 2 then
        Player.setAttList(actor, "属性附加")
    elseif TMtype == 3 then
        TianMing.SetFlagBuffAndRunFunc(actor, lastCfg.value, 0)
    elseif TMtype == 4 and lastCfg.buffId ~= nil then
        FkfDelBuff(actor, lastCfg.buffId)
    elseif TMtype == 7 then
        local liveMax = getplaydef(actor, VarCfg["U_等级上限"])
        setplaydef(actor, VarCfg["U_等级上限"], liveMax - lastCfg.value)
        setlocklevel(actor, 1, getplaydef(actor, VarCfg["U_等级上限"]))
        -- changelevel(actor, "-", lastCfg.value)
    end
end

--天命buff添加到缓存
---* actor：玩家
---* cfg：天命配置
---* lastTianMing:上次天命
function TianMing.AddTianMingBuff(actor, cfg, lastTianMing, value)
    local lastCfg = nil
    if #lastTianMing > 1 then
        lastCfg = TianMingList[lastTianMing[1]][lastTianMing[2]]
    end
    --对上次的BUFF进行移除
    if lastCfg then
        if type(lastCfg.TMtype) == "number" then
            --处理附加属性
            TianMing.DelTianMingCahce(actor, lastCfg.TMtype, lastCfg)
        end
        --多组
        if type(lastCfg.TMtype) == "table" then
            for _, v in ipairs(lastCfg.TMtype) do
                TianMing.DelTianMingCahce(actor, v, lastCfg)
            end
        end
    end
    --对当前进行添加
    if type(cfg.TMtype) == "number" then
        --处理附加属性
        TianMing.AddTianMingCahce(actor, cfg.TMtype, cfg)
    end
    --多组
    if type(cfg.TMtype) == "table" then
        for _, v in ipairs(cfg.TMtype) do
            --处理附加属性
            TianMing.AddTianMingCahce(actor, v, cfg)
        end
    end
end

local HYDTcost = { { "鸿运当头", 1 } }
---* 天命请求
--*  actor 玩家
--*  pos 天命位置
function TianMing.Request(actor, pos, costType, isHYDT)
    if not pos then
        Player.sendmsgEx(actor, "气运参数错误1")
        return
    end
    local isUnLock = TianMing.GetLockState(actor, pos)
    if not isUnLock then
        Player.sendmsgEx(actor, "气运参数错误2")
        return
    end
    if not costType then
        Player.sendmsgEx(actor, "气运参数错误3")
        return
    end
    if costType > 2 or costType == 0 then
        Player.sendmsgEx(actor, "气运参数错误4")
        return
    end
    local recordVar = VarCfg["T_天命记录_" .. pos] --当前记录的变量
    if not recordVar then
        Player.sendmsgEx(actor, "气运参数错误5")
        return
    end

    if isUnLock == 0 then
        Player.sendmsgEx(actor, "未解锁")
        return
    end
    local record = Player.getJsonTableByVar(actor, recordVar)
    local costIndex = 1 --判断消耗类型  1气运精魄 2转运金丹 3灵符
    local cost = {}
    if pos <= 12 and costType == 1 then
        costIndex = 1
    else
        costIndex = 2
    end
    if costType == 2 then
        costIndex = 3
    end
    --如果是鸿运当头请求
    if isHYDT == 1 then
        local name, num = Player.checkItemNumByTable(actor, HYDTcost)
        if name then
            Player.sendmsgEx(actor, string.format("你的#249|[%s]#250|不足#249|%d#250", name, num))
            return
        end
    end
    cost = CostType[costIndex]
    local name, num = Player.checkItemNumByTable(actor, cost)
    --如果当前位置是空的 则禁止物品检测
    if #record == 0 then
        name = nil
        num = nil
    end
    if name then
        Player.sendmsgEx(actor, string.format("你的#249|[%s]#250|不足#249|%d#250", name, num))
        return
    end
    --获取权重
    local quality = ransjstr(weight, 1, 3)
    quality = tonumber(quality)
    local baoDiCiShu = getplaydef(actor, VarCfg["U_天命保底次数"])
    -- release_print(baoDiCiShu)
    --触发5星保底
    if baoDiCiShu >= 25 then
        -- release_print("天命触发保底")
        quality = 5
    end
    --鸿运当头必出帝品！
    if isHYDT == 1 then
        quality = 5
    end
    if quality == 5 then
        setplaydef(actor, VarCfg["U_天命保底次数"], 0) --重置保底次数
    end

    -- quality = 4 --强制修改品质
    --读取配置
    local list = TianMingList[quality]
    if list then
        local hasList = TianMing.GetHasTianMingList(actor, quality)
        --如果凡品已经满了就抽取灵品
        if hasList then
            if quality == 1 and #hasList >= 18 then
                quality = 2
                list = TianMingList[quality]
                hasList = TianMing.GetHasTianMingList(actor, quality)
            end
        end
        --如果灵品已经满了就抽取仙品
        if hasList then
            if quality == 2 and #hasList >= 20 then
                quality = 3
                list = TianMingList[quality]
                hasList = TianMing.GetHasTianMingList(actor, quality)
            end
        end

        --其他的都超过24，因此不会满，不需要判断！
        local randomNum
        --如果已经存在了就抽一个不存在的编号
        if hasList then
            randomNum = generateRandomExclude(hasList, #list) --抽一个不存在的编号
            --如果已经满了，继续正常随机
            if not randomNum then
                randomNum = math.random(#list) -- 正常随机
            end
        else
            randomNum = math.random(#list) -- 正常随机
        end
        -- randomNum = 35  --强制修改
        -- release_print(tostring(randomNum),tostring(quality))
        local baoDiCiShu = getplaydef(actor, VarCfg["U_天命保底次数"])
        setplaydef(actor, VarCfg["U_天命保底次数"], baoDiCiShu + 1)
        if isHYDT == 1 then
            Player.takeItemByTable(actor, HYDTcost, "气运消耗")
            setplaydef(actor, VarCfg["U_天命保底次数"], 0)
        end
        --当前位置不是空的才扣材料
        if #record > 0 then
            Player.takeItemByTable(actor, cost, "气运消耗")
        end

        local Tvar = VarCfg["T_天命记录_" .. pos]
        local lastTianMing = {}
        if Tvar then
            lastTianMing = Player.getJsonTableByVar(actor, Tvar) --记录上次天命
        end
        TianMing.AddTianMing(actor, pos, quality, randomNum)     --储存到变量中
        --完成洗练的任务
        local shiFouQiYun = getflagstatus(actor, VarCfg["F_是否洗练过气运"])
        if shiFouQiYun == 0 then
            setflagstatus(actor, VarCfg["F_是否洗练过气运"], 1)
            local taskPanelID = getplaydef(actor, VarCfg["U_主线任务面板进度"])
            if taskPanelID == 2 then
                FCheckTaskRedPoint(actor)
            end
        end
        --完成洗练的任务结束
        Message.sendmsg(actor, ssrNetMsgCfg.TianMing_CQResponse, pos, quality, randomNum)
        if quality == 5 then
            local myName = getbaseinfo(actor, ConstCfg.gbase.name)
            FSendMsgNew(actor,
                string.format("恭喜玩家[{%s/FCOLOR=245}]运气爆棚,获得[{%s·%s/FCOLOR=249}]", myName, enumeQualityName[quality],
                    list[randomNum].name))
            if getflagstatus(actor, VarCfg["F_天命_洪福齐天标识"]) == 1 then
                Player.setAttList(actor, "属性附加")
            end
        end
        TianMing.AddTianMingBuff(actor, list[randomNum], lastTianMing, randomNum) --添加天命的buff
    end
end

--某个天命是否存在
---* actor 玩家
---* quality 品质
---* index 索引
function TianMing.GetIsTianMing(actor, quality, index)
    local tbl = TianMing.GetTianMingList(actor)
    for _, value in ipairs(tbl) do
        if #value > 1 then
            if value[1] == quality and value[2] == index then
                return true, value
            end
        end
    end
    return false, {}
end

--某个天命是否存在返回布尔类型
---* actor 玩家
---* quality 品质
---* index 索引
function TianMing.GetIsTianMingBool(actor, quality, index)
    local tbl = TianMing.GetTianMingList(actor)
    for _, value in ipairs(tbl) do
        if #value > 1 then
            if value[1] == quality and value[2] == index then
                return true
            end
        end
    end
    return false
end

--响应图鉴数据
function TianMing.TJResponse(actor)
    local data = {}
    for index, value in ipairs(enumeTianMingVar) do
        local t = Player.getJsonTableByVar(actor, value)
        table.insert(data, t)
    end
    Message.sendmsg(actor, ssrNetMsgCfg.TianMing_TJResponse, 0, 0, 0, data)
end

--请求打开UI
function TianMing.openUI(actor)
    local data = {}
    local unLockData = TianMing.GetLockState(actor)
    local myTianMingData = TianMing.GetTianMingList(actor)
    data.unLock = unLockData
    data.myTianMing = myTianMingData
    Message.sendmsg(actor, ssrNetMsgCfg.TianMing_openUI, 0, 0, 0, data)
end

--天命同步跨服变量
function TianMing.SyncKuaFu(actor)
    --获取天命列表
    local tianMingList = TianMing.GetTianMingList(actor)
    local split_index = math.ceil(#tianMingList / 2)
    local arr1 = {}
    local arr2 = {}
    for i = 1, split_index do
        arr1[i] = tianMingList[i]
    end
    for i = split_index + 1, #tianMingList do
        arr2[i - split_index] = tianMingList[i]
    end
    local str1 = tbl2json(arr1)
    local str2 = tbl2json(arr2)
    setplayvar(actor, "HUMAN", "KFZF1", str1, 1)
    setplayvar(actor, "HUMAN", "KFZF2", str2, 1)
end

--注册网络消息
Message.RegisterNetMsg(ssrNetMsgCfg.TianMing, TianMing)

--计算天命的属性
local function CalcTianMingAttr(actor, attrs)
    local tianMingData = TianMing.GetTianMingList(actor)
    for i, value in ipairs(tianMingData) do
        if #value > 1 then
            local cfg = TianMingList[value[1]][value[2]]
            if cfg then
                if type(cfg.TMtype) == "number" then
                    if cfg.TMtype == 2 then
                        for j, v1 in ipairs(cfg.attr) do
                            if not attrs[v1[1]] then
                                attrs[v1[1]] = v1[2]
                            else
                                attrs[v1[1]] = attrs[v1[1]] + v1[2]
                            end
                        end
                    end
                end

                if type(cfg.TMtype) == "table" then
                    for k, v2 in ipairs(cfg.TMtype) do
                        if v2 == 2 then
                            for l, v3 in ipairs(cfg.attr) do
                                if not attrs[v3[1]] then
                                    attrs[v3[1]] = v3[2]
                                else
                                    attrs[v3[1]] = attrs[v3[1]] + v3[2]
                                end
                            end
                        end
                    end
                end
            end
        end
    end
end

--属性触发
local function _onCalcAttr(actor, attrs)
    local shuxing = {}
    for i, value in ipairs(TianMingTuJianConfig) do
        local tuJianData = Player.getJsonTableByVar(actor, value.var)
        local tuJianCount = table.nums(tuJianData)
        if tuJianCount >= value.max then
            for k, v in pairs(value.attr) do
                if not shuxing[k] then
                    shuxing[k] = v
                else
                    shuxing[k] = shuxing[k] + v
                end
            end

            --首次激活提示
            local falg = getflagstatus(actor, enumeTianMingFirstTipFalg[i])
            if falg == 0 then
                messagebox(actor, string.format("恭喜你激活了全部[%s]图鉴,实力获得大幅提升!", enumeQualityName[i]))
                local myName = getbaseinfo(actor, ConstCfg.gbase.name)
                FSendMsgNew(actor,
                    string.format("恭喜玩家[{%s/FCOLOR=245}]激活全部[{%s/FCOLOR=249}]图鉴,实力获得大幅提升!", myName, enumeQualityName[i]))
                setflagstatus(actor, enumeTianMingFirstTipFalg[i], 1)
            end
        end
    end
    --天胡开局
    if getflagstatus(actor, VarCfg["F_天命_天胡开局标识"]) == 1 then
        local currentLevel = getbaseinfo(actor, ConstCfg.gbase.level)
        if not shuxing[200] then
            shuxing[200] = currentLevel * 150
        else
            shuxing[200] = shuxing[200] + currentLevel * 150
        end
    end
    --合区超人
    if getflagstatus(actor, VarCfg["F_天命_合区超人标识"]) == 1 then
        local heQuDay = tonumber(getconst(actor, "<$HFCOUNT>"))
        if heQuDay > 0 then
            if not shuxing[26] then
                shuxing[26] = 10
            else
                shuxing[26] = shuxing[26] + 10
            end

            if not shuxing[208] then
                shuxing[208] = 20
            else
                shuxing[208] = shuxing[208] + 20
            end

            if not shuxing[75] then
                shuxing[75] = 1000
            else
                shuxing[75] = shuxing[75] + 1000
            end
        end
    end
    if getflagstatus(actor, VarCfg["F_天命_洪福齐天标识"]) == 1 then
        local num = TianMing.GetTianMingNum(actor, 5)
        local addtion = 5 + num * 2
        local tmpshuxing = {
            [208] = addtion,
            [209] = addtion,
            [210] = addtion,
            [211] = addtion,
            [212] = addtion,
            [213] = addtion,
            [214] = addtion,
            [221] = addtion,
            [222] = addtion,
            [223] = addtion,
            [224] = addtion,
            [225] = addtion,
        }
        attsMerge(tmpshuxing, shuxing)
    end
    if getflagstatus(actor, VarCfg["F_天命_未来战士标识"]) == 1 then
        local level = getbaseinfo(actor, ConstCfg.gbase.level)
        if level > 100 then
            local attack = (level - 100) * 60
            local hp = (level - 100) * 1000
            local tmpshuxing = {
                [1] = hp,
                [4] = attack
            }
            attsMerge(tmpshuxing, shuxing)
        end
    end

    if getflagstatus(actor, VarCfg["F_天命_浴血狂魔标识"]) == 1 then
        local currHp = getplaydef(actor, VarCfg["U_天命_浴血狂魔_血量"])
        if currHp > 0 then
            local tmpshuxing = {
                [1] = currHp,
            }
            attsMerge(tmpshuxing, shuxing)
        end
    end

    CalcTianMingAttr(actor, shuxing)
    calcAtts(attrs, shuxing, "天命和天命图鉴")
end
--属性
GameEvent.add(EventCfg.onCalcAttr, _onCalcAttr, TianMing)

--倍攻触发
local function _onCalcBeiGong(actor, beiGongs)
    if getflagstatus(actor, VarCfg["F_天命_浴血狂魔标识"]) == 1 then
        beiGongs[1] = beiGongs[1] + 5
    end

    if getflagstatus(actor, VarCfg["F_力大无穷"]) == 1 then
        beiGongs[1] = beiGongs[1] + 5
    end

    if getflagstatus(actor, VarCfg["F_天命火力全开"]) == 1 then
        beiGongs[1] = beiGongs[1] + 5
    end
end
GameEvent.add(EventCfg.onCalcBeiGong, _onCalcBeiGong, TianMing)

--爆率属性
local function _onCalcBaoLv(actor, attrs)
    local shuxing = {}
    for i, value in ipairs(TianMingTuJianConfig) do
        local tuJianData = Player.getJsonTableByVar(actor, value.var)
        local tuJianCount = table.nums(tuJianData)
        if tuJianCount >= value.max then
            for k, v in pairs(value.baoLvAddtion) do
                if not shuxing[k] then
                    shuxing[k] = v
                else
                    shuxing[k] = shuxing[k] + v
                end
            end
        end
    end
    if getflagstatus(actor, VarCfg["F_天命_天选之人标识_仙"]) == 1 then
        if not shuxing[204] then
            shuxing[204] = 20
        else
            shuxing[204] = shuxing[204] + 20
        end
    end
    if getflagstatus(actor, VarCfg["F_天命_大罗转世标识"]) == 1 then
        if not shuxing[204] then
            shuxing[204] = 33
        else
            shuxing[204] = shuxing[204] + 33
        end
    end
    calcAtts(attrs, shuxing, "爆率附加:天命属性加成附加")
end
GameEvent.add(EventCfg.onCalcBaoLv, _onCalcBaoLv, TianMing)

--计算攻速
local function _onCalcAttackSpeed(actor, attackSpeeds)
    if getflagstatus(actor, VarCfg["F_天命_疾风迅雷标识"]) == 1 then
        attackSpeeds[1] = attackSpeeds[1] + 20
    end
    if getflagstatus(actor, VarCfg["F_天命攻速之王"]) == 1 then
        attackSpeeds[1] = attackSpeeds[1] + 66
    end
    if getflagstatus(actor, VarCfg["F_天命炙热双刀"]) == 1 then
        attackSpeeds[1] = attackSpeeds[1] + 38
    end
    if getflagstatus(actor, VarCfg["F_天命疾风之道"]) == 1 then
        attackSpeeds[1] = attackSpeeds[1] + 8
    end
end

GameEvent.add(EventCfg.onCalcAttackSpeed, _onCalcAttackSpeed, TianMing)

--大退小退触发--清理缓存
local function _onExitGame(actor)
    tianMingBuffCahce[actor] = nil
end
GameEvent.add(EventCfg.onExitGame, _onExitGame, TianMing)

--登陆触发
local function _onLoginEnd(actor)
    initCache(actor)
    --单独做一次登录触发，防止性能出现问题
    local tianMingList = TianMing.GetTianMingList(actor)
    for index, value in ipairs(tianMingList) do
        if #value > 1 then
            local cfg = TianMingList[value[1]][value[2]]
            -- dump(cfg)
            if cfg then
                if type(cfg.TMtype) == "number" then
                    if cfg.TMtype == 3 then
                        local Func = TianMingFunc[cfg.value]
                        if Func then
                            Func(actor)
                        end
                    end
                end
                --如果有多个
                if type(cfg.TMtype) == "table" then
                    for _, v in ipairs(cfg.TMtype) do
                        if v == 3 then
                            local Func = TianMingFunc[cfg.value]
                            if Func then
                                Func(actor)
                            end
                        end
                    end
                end
            end
        end
    end
    if not checkkuafu(actor) then
        if getflagstatus(actor, VarCfg["F_天命_永动机标识"]) == 1 then
            setontimer(actor, 10, 3, 0, 1)
        end
    end
end
GameEvent.add(EventCfg.onLoginEnd, _onLoginEnd, TianMing)
GameEvent.add(EventCfg.onKFLogin, _onLoginEnd, TianMing)
--获取缓存的攻击被攻击效果
local function onGetTianMingBuff(actor, index)
    if not tianMingBuffCahce[actor] then
        return {}
    end
    local result = tianMingBuffCahce[actor]["攻击被攻击效果"][index]
    if not result then
        return {}
    end
    return result
end

-----------------------------天命BUFF开始---------------------------------
--全部攻击触发（1000开头）
local function _onAttack(actor, Target, Hiter, MagicId)
    local BuffList = onGetTianMingBuff(actor, 1) -- {1000,1001}
    if #BuffList > 0 then
        for _, v in ipairs(BuffList) do
            local buffFunc = TianMingBuffList[v]
            if buffFunc then
                buffFunc(actor, Target, Hiter, MagicId)
            end
        end
    end
end
GameEvent.add(EventCfg.onAttack, _onAttack, TianMingBuffList)

--攻击人触发（2000开头）
local function _onAttackPlayer(actor, Target, Hiter, MagicId)
    local BuffList = onGetTianMingBuff(actor, 2)
    if #BuffList > 0 then
        for _, v in ipairs(BuffList) do
            local buffFunc = TianMingBuffList[v]
            if buffFunc then
                buffFunc(actor, Target, Hiter, MagicId)
            end
        end
    end
end
GameEvent.add(EventCfg.onAttackPlayer, _onAttackPlayer, TianMingBuffList)

--攻击怪物触发（3000开头）
local function _onAttackMonster(actor, Target, Hiter, MagicId, qieGe)
    local BuffList = onGetTianMingBuff(actor, 3)
    if #BuffList > 0 then
        for _, v in ipairs(BuffList) do
            local buffFunc = TianMingBuffList[v]
            if buffFunc then
                buffFunc(actor, Target, Hiter, MagicId, qieGe)
            end
        end
    end
end
GameEvent.add(EventCfg.onAttackMonster, _onAttackMonster, TianMingBuffList)

--全部攻击前触发（掉血前）（4000开头）
local function _onAttackDamage(actor, Target, Hiter, MagicId, Damage, Model, attackDamageData)
    local BuffList = onGetTianMingBuff(actor, 4)
    if #BuffList > 0 then
        for _, v in ipairs(BuffList) do
            local buffFunc = TianMingBuffList[v]
            if buffFunc then
                buffFunc(actor, Target, Hiter, MagicId, Damage, Model, attackDamageData)
            end
        end
    end
end
GameEvent.add(EventCfg.onAttackDamage, _onAttackDamage, TianMingBuffList)

--攻击人前触发（掉血前）（5000开头）
local function _onAttackDamagePlayer(actor, Target, Hiter, MagicId, Damage, Model, attackDamageData)
    local BuffList = onGetTianMingBuff(actor, 5)
    if #BuffList > 0 then
        for _, v in ipairs(BuffList) do
            local buffFunc = TianMingBuffList[v]
            if buffFunc then
                buffFunc(actor, Target, Hiter, MagicId, Damage, Model, attackDamageData)
            end
        end
    end
end
GameEvent.add(EventCfg.onAttackDamagePlayer, _onAttackDamagePlayer, TianMingBuffList)

--攻击怪物前触发（掉血前）（6000开头）
local function _onAttackDamageMonster(actor, Target, Hiter, MagicId, Damage, Model, attackDamageData)
    local BuffList = onGetTianMingBuff(actor, 6)
    if #BuffList > 0 then
        for _, v in ipairs(BuffList) do
            local buffFunc = TianMingBuffList[v]
            if buffFunc then
                buffFunc(actor, Target, Hiter, MagicId, Damage, Model, attackDamageData)
            end
        end
    end
end
GameEvent.add(EventCfg.onAttackDamageMonster, _onAttackDamageMonster, TianMingBuffList)


--被全部攻击触发（7000开头）-----------------------------------
local function _onStruck(actor, Target, Hiter, MagicId)
    local BuffList = onGetTianMingBuff(actor, 7)
    if #BuffList > 0 then
        for _, v in ipairs(BuffList) do
            local buffFunc = TianMingBuffList[v]
            if buffFunc then
                buffFunc(actor, Target, Hiter, MagicId)
            end
        end
    end
end
GameEvent.add(EventCfg.onStruck, _onStruck, TianMingBuffList)

--被人攻击触发（8000开头）
local function _onStruckPlayer(actor, Target, Hiter, MagicId)
    local BuffList = onGetTianMingBuff(actor, 8)
    if #BuffList > 0 then
        for _, v in ipairs(BuffList) do
            local buffFunc = TianMingBuffList[v]
            if buffFunc then
                buffFunc(actor, Target, Hiter, MagicId)
            end
        end
    end
end
GameEvent.add(EventCfg.onStruckPlayer, _onStruckPlayer, TianMingBuffList)

--被怪攻击触发（9000开头）
local function _onStruckMonster(actor, Target, Hiter, MagicId)
    local BuffList = onGetTianMingBuff(actor, 9)
    if #BuffList > 0 then
        for _, v in ipairs(BuffList) do
            local buffFunc = TianMingBuffList[v]
            if buffFunc then
                buffFunc(actor, Target, Hiter, MagicId)
            end
        end
    end
end
GameEvent.add(EventCfg.onStruckMonster, _onStruckMonster, TianMingBuffList)

--被全部攻击触发（10000开头）
local function _onStruckDamage(actor, Target, Hiter, MagicId, Damage, attackDamageData)
    local BuffList = onGetTianMingBuff(actor, 10)
    if #BuffList > 0 then
        for _, v in ipairs(BuffList) do
            local buffFunc = TianMingBuffList[v]
            if buffFunc then
                buffFunc(actor, Target, Hiter, MagicId, Damage, attackDamageData)
            end
        end
    end
end
GameEvent.add(EventCfg.onStruckDamage, _onStruckDamage, TianMingBuffList)

--被玩家攻击触发（11000开头）
local function _onStruckDamagePlayer(actor, Target, Hiter, MagicId, Damage, attackDamageData)
    local BuffList = onGetTianMingBuff(actor, 11)
    if #BuffList > 0 then
        for _, v in ipairs(BuffList) do
            local buffFunc = TianMingBuffList[v]
            if buffFunc then
                buffFunc(actor, Target, Hiter, MagicId, Damage, attackDamageData)
            end
        end
    end
end
GameEvent.add(EventCfg.onStruckDamagePlayer, _onStruckDamagePlayer, TianMingBuffList)

--被怪攻击触发（12000开头）
local function _onStruckDamageMonster(actor, Target, Hiter, MagicId, Damage, attackDamageData)
    local BuffList = onGetTianMingBuff(actor, 12)
    if #BuffList > 0 then
        for _, v in ipairs(BuffList) do
            local buffFunc = TianMingBuffList[v]
            if buffFunc then
                buffFunc(actor, Target, Hiter, MagicId, Damage, attackDamageData)
            end
        end
    end
end
GameEvent.add(EventCfg.onStruckDamageMonster, _onStruckDamageMonster, TianMingBuffList)

--复活触发（13000开头）
local function _onRevive(actor)
    local BuffList = onGetTianMingBuff(actor, 13)
    if #BuffList > 0 then
        for _, v in ipairs(BuffList) do
            local buffFunc = TianMingBuffList[v]
            if buffFunc then
                buffFunc(actor)
            end
        end
    end
end
GameEvent.add(EventCfg.onRevive, _onRevive, TianMingBuffList)

--杀怪触发（14000开头）
local function _onKillMon(actor, monobj)
    local BuffList = onGetTianMingBuff(actor, 14)
    if #BuffList > 0 then
        for _, v in ipairs(BuffList) do
            local buffFunc = TianMingBuffList[v]
            if buffFunc then
                buffFunc(actor, monobj)
            end
        end
    end
end
GameEvent.add(EventCfg.onKillMon, _onKillMon, TianMingBuffList)

--杀人触发（15000开头）
local function _onkillplay(actor, play)
    local BuffList = onGetTianMingBuff(actor, 15)
    if #BuffList > 0 then
        for _, v in ipairs(BuffList) do
            local buffFunc = TianMingBuffList[v]
            if buffFunc then
                buffFunc(actor, play)
            end
        end
    end
end
GameEvent.add(EventCfg.onkillplay, _onkillplay, TianMingBuffList)


--死亡触发（16000开头）
local function _onPlaydie(actor, hiter)
    local BuffList = onGetTianMingBuff(actor, 16)
    if #BuffList > 0 then
        for _, v in ipairs(BuffList) do
            local buffFunc = TianMingBuffList[v]
            if buffFunc then
                buffFunc(actor, hiter)
            end
        end
    end
end
GameEvent.add(EventCfg.onPlaydie, _onPlaydie, TianMingBuffList)

local wuShuZhiRenMap = {
    [27] = true,
    [82] = true,
    [114] = true,
    [2014] = true,
    [2018] = true,
    [2020] = true,
    [2023] = true,
}
--使用技能触发 巫术之刃
local function _onUseSkill(actor, MagicId)
    local BuffList = onGetTianMingBuff(actor, 1)
    if table.contains(BuffList, 1004) then
        -- 27  野蛮冲撞
        -- 82 十步一杀
        -- 2014 召唤分身
        -- 2018	黑水沼泽
        -- 114 倚天辟地
        -- 2020	燃烧法则
        -- 2023	寂灭归墟
        if wuShuZhiRenMap[MagicId] then
            setplaydef(actor, VarCfg["N$释放主动技能附加伤害"], 1)
        end
    end
end
GameEvent.add(EventCfg["使用技能通用派发"], _onUseSkill, TianMingBuffList)


local function _onEnterGroup(actor)
    -- local name = getbaseinfo(actor,ConstCfg.gbase.name)
    -- release_print(name.."进入队伍")
    TianMingFunc[29](actor)
end
GameEvent.add(EventCfg.onEnterGroup, _onEnterGroup, TianMingBuffList)

local function _onLeaveGroup(actor)
    -- local name = getbaseinfo(actor,ConstCfg.gbase.name)
    -- release_print(name.."离开队伍")
    TianMingFunc[29](actor)
end
GameEvent.add(EventCfg.onLeaveGroup, _onLeaveGroup, TianMingBuffList)

------------夜晚触发
local function _noStartingDark(actor)
    TianMingFunc[28](actor)
    TianMingFunc[50](actor)
    TianMingFunc[234](actor)
end
GameEvent.add(EventCfg.onStartingDark, _noStartingDark, TianMingBuffList)
-----------白天触发
local function _noStartingDay(actor)
    TianMingFunc[28](actor)
    TianMingFunc[50](actor)
    TianMingFunc[235](actor)
end
GameEvent.add(EventCfg.onStartingDay, _noStartingDay, TianMingBuffList)
--------------------------拾取触发---------------------------------------------
local function _goPickUpItemEx(actor, itemobj, itemidx, itemMakeIndex, ItemName)
    if TianMing.ZhuanShu[ItemName] then
        if getflagstatus(actor, VarCfg["F_天命超级加倍"]) == 1 then
            if hasbuff(actor, 31071) then
                delbuff(actor, 31071)
            end
        end
    end
end
GameEvent.add(EventCfg.goPickUpItemEx, _goPickUpItemEx, TianMing)
-----------------------------技能威力-------------------------------------
local function _onSkillPower(actor, skillrs)
    if getflagstatus(actor, VarCfg["F_天命疋杀地蔵"]) == 1 then
        local shuxing = {}
        shuxing["烈火剑法"] = 3
        shuxing["开天斩"] = 3
        shuxing["逐日剑法"] = 3
        calcAtts(skillrs, shuxing, "天命疋杀地蔵技能威力计算")
    end
end

GameEvent.add(EventCfg.onAddSkillPower, _onSkillPower, TianMingFunc)
-------------------------创建行会时触发---------------------------------
local function _onLoadGuild(actor, guildobj)
    TianMingFunc[VarCfg["F_天命独揽大权"]](actor)
    TianMingFunc[VarCfg["F_天命鹤立鸡群"]](actor)
end
GameEvent.add(EventCfg.onLoadGuild, _onLoadGuild, TianMing)
-------------------------------解散行会--------------------------------------
local function _onCloseGuild(actor)
    TianMingFunc[VarCfg["F_天命独揽大权"]](actor)
    TianMingFunc[VarCfg["F_天命鹤立鸡群"]](actor)
end
GameEvent.add(EventCfg.onCloseGuild, _onCloseGuild, TianMing)
--------------------------加入行会----------------------------
local function _onGuildAddMemberAfter(actor)
    TianMingFunc[VarCfg["F_天命鹤立鸡群"]](actor)
end
GameEvent.add(EventCfg.onGuildAddMemberAfter, _onGuildAddMemberAfter, TianMing)
------------------------退出行会-------------------------------
local function _onGuilddelMember(actor)
    TianMingFunc[VarCfg["F_天命鹤立鸡群"]](actor)
end
GameEvent.add(EventCfg.onGuilddelMember, _onGuilddelMember, TianMing)
-----------------------升级触发----------------------------------
local function _onPlayLevelUp(actor, cur_level, before_level)
    TianMingFunc[242](actor)
end

GameEvent.add(EventCfg.onPlayLevelUp, _onPlayLevelUp, TianMing)
----------------金币变化触发-------------------------------
local function _OverloadMoneyJinBi(actor, money)
    if getflagstatus(actor, VarCfg["F_天命省着点花"]) == 1 then
        TianMingFunc[243](actor)
    end
end
GameEvent.add(EventCfg.OverloadMoneyJinBi, _OverloadMoneyJinBi, TianMing)
----------------切换地图触发-------------------------------

local function _goSwitchMap(actor, cur_mapid, former_mapid, x, y)
    local myName = Player.GetName(actor)
    local newMapId = myName .. "y"
    if former_mapid == newMapId then
        if getplaydef(actor, "N$大罗洞观进入是否挂机") == 1 then
            startautoattack(actor)
            setplaydef(actor, "N$大罗洞观进入是否挂机", 0)
        end
    end
end
GameEvent.add(EventCfg.goSwitchMap, _goSwitchMap, TianMing)
-----------------------------天命BUFF结束---------------------------------
return TianMing

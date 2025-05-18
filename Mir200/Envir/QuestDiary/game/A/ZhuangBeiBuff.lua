local ZhuangBeiBuffMain = {}
local cfg_ZhuangBeiBuff = include("QuestDiary/cfgcsv/cfg_ZhuangBeiBuff.lua")
local ZhuangBeiBuff = include("QuestDiary/game/A/ZhuangBeiBuffList.lua")
ZhuangBeiBuffMain.ID = "装备BUFF"
local playerBuffCahce = {}
--初始化缓存
local function initCache(actor)
    playerBuffCahce[actor] = {
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
        }
    }

    for _, value in ipairs(ConstCfg.equipWhere) do
        local equipobj = linkbodyitem(actor, value)
        if equipobj ~= "0" then
            local equipName = getiteminfo(actor, equipobj, ConstCfg.iteminfo.name)
            local cfg = cfg_ZhuangBeiBuff[equipName]
            if cfg then
                if cfg.isAttack == 1 and cfg.buffId ~= nil then
                    local tmpTbl = playerBuffCahce[actor]["攻击被攻击效果"][cfg.attackType]
                    table.insert(tmpTbl, cfg.buffId)
                    table.uniqueArray(tmpTbl) --删除重复避免出现BUG
                end
            end
        end
    end
    local suitIds = Player.getJsonTableByVar(actor, VarCfg["T_记录套装ID"])
    if #suitIds > 0 then
        for _, value in ipairs(suitIds) do
            local cfg = cfg_ZhuangBeiBuff[value]
            if cfg then
                if cfg.otherType == 8 and cfg.buffId ~= nil then
                    local tmpTbl = playerBuffCahce[actor]["攻击被攻击效果"][cfg.attackType]
                    table.insert(tmpTbl, cfg.buffId)
                    table.uniqueArray(tmpTbl) --删除重复避免出现BUG
                end
            end
        end
    end
end

--重载给缓存
local function reloadInitCache()
    local playerList = getplayerlst()
    for _, actor in ipairs(playerList) do
        if not getbaseinfo(actor, ConstCfg.gbase.offline) then
            initCache(actor)
        end
    end
end

--重载给缓存
reloadInitCache()
-- dump(playerBuffCahce)

--获取缓存的攻击被攻击效果
local function onGetZhuangBeiBuff(actor, index)
    if not playerBuffCahce[actor] then
        return {}
    end
    local result = playerBuffCahce[actor]["攻击被攻击效果"][index]
    if not result then
        return {}
    end
    return result
end

--全部攻击触发（1000开头）
local function _onAttack(actor, Target, Hiter, MagicId)
    local BuffList = onGetZhuangBeiBuff(actor,1) -- {1000,1001}
    if #BuffList > 0 then
        for _, v in ipairs(BuffList) do
            local buffFunc = ZhuangBeiBuff[v]
            if buffFunc then
                buffFunc(actor, Target, Hiter, MagicId)
            end
        end
    end
end
GameEvent.add(EventCfg.onAttack, _onAttack, ZhuangBeiBuffMain)

--攻击人触发（2000开头）
local function _onAttackPlayer(actor, Target, Hiter, MagicId)
    local BuffList = onGetZhuangBeiBuff(actor,2)
    if #BuffList > 0 then
        for _, v in ipairs(BuffList) do
            local buffFunc = ZhuangBeiBuff[v]
            if buffFunc then
                buffFunc(actor, Target, Hiter, MagicId)
            end
        end
    end
end
GameEvent.add(EventCfg.onAttackPlayer, _onAttackPlayer, ZhuangBeiBuffMain)

--攻击怪物触发（3000开头）
local function _onAttackMonster(actor, Target, Hiter, MagicId)
    local BuffList = onGetZhuangBeiBuff(actor,3)
    if #BuffList > 0 then
        for _, v in ipairs(BuffList) do
            local buffFunc = ZhuangBeiBuff[v]
            if buffFunc then
                buffFunc(actor, Target, Hiter, MagicId)
            end
        end
    end
end
GameEvent.add(EventCfg.onAttackMonster, _onAttackMonster, ZhuangBeiBuffMain)

--全部攻击前触发（掉血前）（4000开头）
local function _onAttackDamage(actor, Target, Hiter, MagicId, Damage, Model, attackDamageData)
    local BuffList = onGetZhuangBeiBuff(actor,4)
    if #BuffList > 0 then
        for _, v in ipairs(BuffList) do
            local buffFunc = ZhuangBeiBuff[v]
            if buffFunc then
                buffFunc(actor, Target, Hiter, MagicId, Damage, Model, attackDamageData)
            end
        end
    end
end
GameEvent.add(EventCfg.onAttackDamage, _onAttackDamage, ZhuangBeiBuffMain)

--攻击人前触发（掉血前）（5000开头）
local function _onAttackDamagePlayer(actor, Target, Hiter, MagicId, Damage, Model, attackDamageData)
    local BuffList = onGetZhuangBeiBuff(actor,5)
    if #BuffList > 0 then
        for _, v in ipairs(BuffList) do
            local buffFunc = ZhuangBeiBuff[v]
            if buffFunc then
                buffFunc(actor, Target, Hiter, MagicId, Damage, Model, attackDamageData)
            end
        end
    end
end
GameEvent.add(EventCfg.onAttackDamagePlayer, _onAttackDamagePlayer, ZhuangBeiBuffMain)

--攻击怪物前触发（掉血前）（6000开头）
local function _onAttackDamageMonster(actor, Target, Hiter, MagicId, Damage, Model, attackDamageData)
    local BuffList = onGetZhuangBeiBuff(actor,6)
    if #BuffList > 0 then
        for _, v in ipairs(BuffList) do
            local buffFunc = ZhuangBeiBuff[v]
            if buffFunc then
                buffFunc(actor, Target, Hiter, MagicId, Damage, Model, attackDamageData)
            end
        end
    end
end
GameEvent.add(EventCfg.onAttackDamageMonster, _onAttackDamageMonster, ZhuangBeiBuffMain)

--被全部攻击触发（7000开头）-----------------------------------
local function _onStruck(actor, Target, Hiter, MagicId)
    local BuffList = onGetZhuangBeiBuff(actor,7)
    if #BuffList > 0 then
        for _, v in ipairs(BuffList) do
            local buffFunc = ZhuangBeiBuff[v]
            if buffFunc then
                buffFunc(actor, Target, Hiter, MagicId)
            end
        end
    end
end
GameEvent.add(EventCfg.onStruck, _onStruck, ZhuangBeiBuffMain)

--被人攻击触发（8000开头）
local function _onStruckPlayer(actor, Target, Hiter, MagicId)
    local BuffList = onGetZhuangBeiBuff(actor,8)
    if #BuffList > 0 then
        for _, v in ipairs(BuffList) do
            local buffFunc = ZhuangBeiBuff[v]
            if buffFunc then
                buffFunc(actor, Target, Hiter, MagicId)
            end
        end
    end
end
GameEvent.add(EventCfg.onStruckPlayer, _onStruckPlayer, ZhuangBeiBuffMain)

--被怪攻击触发（9000开头）
local function _onStruckMonster(actor, Target, Hiter, MagicId)
    local BuffList = onGetZhuangBeiBuff(actor,9)
    if #BuffList > 0 then
        for _, v in ipairs(BuffList) do
            local buffFunc = ZhuangBeiBuff[v]
            if buffFunc then
                buffFunc(actor, Target, Hiter, MagicId)
            end
        end
    end
end
GameEvent.add(EventCfg.onStruckMonster, _onStruckMonster, ZhuangBeiBuffMain)

--被全部攻击触发（10000开头）
local function _onStruckDamage(actor, Target, Hiter, MagicId, Damage, attackDamageData)
    local BuffList = onGetZhuangBeiBuff(actor,10)
    if #BuffList > 0 then
        for _, v in ipairs(BuffList) do
            local buffFunc = ZhuangBeiBuff[v]
            if buffFunc then
                buffFunc(actor, Target, Hiter, MagicId, Damage, attackDamageData)
            end
        end
    end
end
GameEvent.add(EventCfg.onStruckDamage, _onStruckDamage, ZhuangBeiBuffMain)

--被玩家攻击触发（11000开头）
local function _onStruckDamagePlayer(actor, Target, Hiter, MagicId, Damage, attackDamageData)
    local BuffList = onGetZhuangBeiBuff(actor,11)
    if #BuffList > 0 then
        for _, v in ipairs(BuffList) do
            local buffFunc = ZhuangBeiBuff[v]
            if buffFunc then
                buffFunc(actor, Target, Hiter, MagicId, Damage, attackDamageData)
            end
        end
    end
end
GameEvent.add(EventCfg.onStruckDamagePlayer, _onStruckDamagePlayer, ZhuangBeiBuffMain)

--被怪攻击触发（12000开头）
local function _onStruckDamageMonster(actor, Target, Hiter, MagicId, Damage, attackDamageData)
    local BuffList = onGetZhuangBeiBuff(actor,12)
    if #BuffList > 0 then
        for _, v in ipairs(BuffList) do
            local buffFunc = ZhuangBeiBuff[v]
            if buffFunc then
                buffFunc(actor, Target, Hiter, MagicId, Damage, attackDamageData)
            end
        end
    end
end
GameEvent.add(EventCfg.onStruckDamageMonster, _onStruckDamageMonster, ZhuangBeiBuffMain)
-------------------------------------------穿戴触发--------------------------------------------------
--人物穿装备触发
local function _onTakeOnEx(actor, itemobj, where, itemname, makeid)
    if itemname == "芭蕉扇" then
        addbuff(actor,31067)
        return
    end

    local cfg = cfg_ZhuangBeiBuff[itemname] --读取BUFF配置
    if cfg then
        if cfg.isAttack == 1 and cfg.buffId ~= nil then
            local tmpTbl = playerBuffCahce[actor]["攻击被攻击效果"][cfg.attackType] --读取当前分类的BUFF
            table.insert(tmpTbl, cfg.buffId) --把BUFFID
            table.uniqueArray(tmpTbl) --删除重复避免出现BUG
        elseif cfg.isAttack == 0 and cfg.otherType == 1 then
            Player.setAttList(actor, "属性附加")
        elseif cfg.otherType == 3 then
            Player.setAttList(actor, "倍攻附加")
        elseif cfg.isAttack == 0 and cfg.otherType == 4 then
            changelevel(actor, "+", cfg.otherValue)
        elseif cfg.otherType == 6 then
            setflagstatus(actor, cfg.otherValue, 1)
        elseif cfg.otherType == 7 then
            Player.setAttList(actor, "回血计算")
        end
    end
end
GameEvent.add(EventCfg.onTakeOnEx, _onTakeOnEx, ZhuangBeiBuffMain)

--人物脱装备触发
local function _onTakeOffEx(actor, itemobj, where, itemname, makeid)
    if itemname == "芭蕉扇" then
        FkfDelBuff(actor,31067)
        return
    end

    local cfg = cfg_ZhuangBeiBuff[itemname] --读取BUFF配置
    if cfg then
        local isKuaFu = checkkuafu(actor)
        --判断是否是攻击被攻击BUFF
        if cfg.isAttack == 1 and cfg.buffId ~= nil then
            local tmpTbl = playerBuffCahce[actor]["攻击被攻击效果"][cfg.attackType] --读取缓存
            table.removebyvalue(tmpTbl, cfg.buffId, true)
            table.uniqueArray(tmpTbl) --删除重复避免出现BUG
        elseif cfg.isAttack == 0 and cfg.otherType == 1 then
            local equipObj = linkbodyitem(actor, where)
            if equipObj == "0" then --没有装备才执行，避免重复执行！
                if isKuaFu then
                    FKuaFuToBenFuEvent(actor,EventCfg.onKTBzhuangBeiBUffShuXing,"")
                else
                    Player.setAttList(actor, "属性附加")
                end
            end
        elseif cfg.otherType == 3 then
            local equipObj = linkbodyitem(actor, where)
            if equipObj == "0" then --没有装备才执行，避免重复执行！
                if isKuaFu then
                    FKuaFuToBenFuEvent(actor,EventCfg.onKTBzhuangBeiBUffBeiGong,"")
                else
                    Player.setAttList(actor, "倍攻附加")
                end
            end
        elseif cfg.isAttack == 0 and cfg.otherType == 4 then --等级加减
            if isKuaFu then
                FKuaFuToBenFuEvent(actor,EventCfg.onKTBzhuangBeiBUffLevel,cfg.otherValue)
            else
                changelevel(actor, "-", cfg.otherValue)
            end
        elseif cfg.otherType == 6 then
            setflagstatus(actor, cfg.otherValue, 0)
        elseif cfg.otherType == 7 then
            if isKuaFu then
                FKuaFuToBenFuEvent(actor,EventCfg.onKTBzhuangBeiBUffHuiXue,"")
            else
                Player.setAttList(actor, "回血计算")
            end
        end
    end
end
GameEvent.add(EventCfg.onTakeOffEx, _onTakeOffEx, ZhuangBeiBuffMain)
local function _onKTBzhuangBeiBUffShuXing(actor)
    Player.setAttList(actor, "属性附加")
end
GameEvent.add(EventCfg.onKTBzhuangBeiBUffShuXing, _onKTBzhuangBeiBUffShuXing, ZhuangBeiBuffMain)
local function _onKTBzhuangBeiBUffBeiGong(actor)
    Player.setAttList(actor, "倍攻附加")
end
GameEvent.add(EventCfg.onKTBzhuangBeiBUffBeiGong, _onKTBzhuangBeiBUffBeiGong, ZhuangBeiBuffMain)

local function _onKTBzhuangBeiBUffHuiXue(actor)
    Player.setAttList(actor, "回血计算")
end
GameEvent.add(EventCfg.onKTBzhuangBeiBUffHuiXue, _onKTBzhuangBeiBUffHuiXue, ZhuangBeiBuffMain)
--去掉等级
local function _onKTBzhuangBeiBUffLevel(actor, arg1)
    local level = tonumber(arg1) or 0
    changelevel(actor, "-", level)
end
GameEvent.add(EventCfg.onKTBzhuangBeiBUffLevel, _onKTBzhuangBeiBUffLevel, ZhuangBeiBuffMain)
--删除buff
local function _onKTBzhuangBeiBUffDelBuff(actor, arg1)
    local buffid = tonumber(arg1) or 0
    delbuff(actor, buffid)
end
GameEvent.add(EventCfg.onKTBzhuangBeiBUffDelBuff, _onKTBzhuangBeiBUffDelBuff, ZhuangBeiBuffMain)

--穿套装触发
local function _onGroupItemOnex(actor, idx)
    local cfg = cfg_ZhuangBeiBuff[tostring(idx)] --读取BUFF配置
    if cfg then
        if cfg.otherType == 8 and cfg.buffId ~= nil then
            local tmpTbl = playerBuffCahce[actor]["攻击被攻击效果"][cfg.attackType] --读取当前分类的BUFF
            table.insert(tmpTbl, cfg.buffId) --把BUFFID
            table.uniqueArray(tmpTbl) --删除重复避免出现BUG
        elseif cfg.otherType == 8 and cfg.otherValue == 7 then
            Player.setAttList(actor, "回血计算")
        end
    end
end
GameEvent.add(EventCfg.onGroupItemOnEx, _onGroupItemOnex, ZhuangBeiBuffMain)

--脱套装触发
local function _onGroupItemOffEx(actor, idx)
    local cfg = cfg_ZhuangBeiBuff[tostring(idx)] --读取BUFF配置
    if cfg then
        if cfg.otherType == 8 and cfg.buffId ~= nil then
            local tmpTbl = playerBuffCahce[actor]["攻击被攻击效果"][cfg.attackType] --读取缓存
            table.removebyvalue(tmpTbl, cfg.buffId, true)
            table.uniqueArray(tmpTbl) --删除重复避免出现BUG
        elseif cfg.otherType == 8 and cfg.otherValue == 7 then
            Player.setAttList(actor, "回血计算")
        end
    end
end
GameEvent.add(EventCfg.onGroupItemOffEx, _onGroupItemOffEx, ZhuangBeiBuffMain)


--计算属性触发
local function _onCalcAttr(actor, attrs)
    --计算属性累加
    local function calcTable(t, id, num)
        if t[id] == nil then
            t[id] = num
        else
            t[id] = t[id] + num
        end
    end
    local shuxing = {}
    for i = 0, 41, 1 do
        local equipobj = linkbodyitem(actor, i)
        if equipobj ~= "0" then
            local equipName = getiteminfo(actor, equipobj, ConstCfg.iteminfo.name)
            local cfg = cfg_ZhuangBeiBuff[equipName]
            if cfg then
                if cfg.isAttack == 0 and cfg.otherType == 1 then
                    local level = getbaseinfo(actor, ConstCfg.gbase.level)
                    local value = level * cfg.otherValue
                    calcTable(shuxing, 4, value)
                end
            end
        end
    end
    calcAtts(attrs, shuxing, "装备BUFF")
end
GameEvent.add(EventCfg.onCalcAttr, _onCalcAttr, ZhuangBeiBuffMain)


--大退小退触发--清理缓存
local function _onExitGame(actor)
    playerBuffCahce[actor] = nil
end
GameEvent.add(EventCfg.onExitGame, _onExitGame, ZhuangBeiBuffMain)

--登陆触发
local function _onLoginEnd(actor)
    initCache(actor)
end
GameEvent.add(EventCfg.onLoginEnd, _onLoginEnd, ZhuangBeiBuffMain)
--跨服登陆
GameEvent.add(EventCfg.onKFLogin, _onLoginEnd, ZhuangBeiBuffMain)
--跨服返回
GameEvent.add(EventCfg.onKuaFuEnd, _onLoginEnd, ZhuangBeiBuffMain)

--刷新右戒指属性
local function _onRing_R_AttRefresh(actor, itemobj, number1, number2)
    local tbl1 = json2tbl(getcustomitemprogressbar(actor, itemobj, 0))            --吞噬之力信息
    local tbl2 = json2tbl(getcustomitemprogressbar(actor, itemobj, 1))            --吞噬倍攻信息
    local num1 = tbl1["cur"] * 20       --计算攻击力
    local num2 = tbl1["cur"] * 200      --计算血量
    local num3 = tbl2["cur"] * 100       --计算倍攻
    setaddnewabil(actor, -2, "=", "3#4#"..num1.."|3#1#"..num2.."|3#67#"..num3.."|", itemobj)
    refreshitem(actor, itemobj)
end

--杀怪触发
local function _onKillMon(actor, monobj)
    local array_6 = onGetZhuangBeiBuff(actor,6)
    if array_6 and #array_6 > 0 then
        if table.contains(array_6, 6004) then
            local onKillMonNum = getplaydef(actor, VarCfg["U_杀死怪物数量"])
            setplaydef(actor, VarCfg["U_杀死怪物数量"], onKillMonNum + 1)
        end
    end

    if getflagstatus(actor, VarCfg["F_暗黑之神宝藏"]) == 1 then
        local itemobj = linkbodyitem(actor, 26) --获取物品对象
        if itemobj ~= "0" then
            local nowexp = Player.progressbarEX(actor, itemobj, 0, "cur", "查询")
            if type(nowexp) == "number" then
                Player.progressbarEX(actor, itemobj, 0, "cur", "设置", nowexp + 1)
                local OpenNumber = getplaydef(actor, VarCfg["J_宝箱开启次数"])
                if OpenNumber == 2 then return end
                if nowexp + 1 >= 666 then
                    local num1 = math.random(3, 6)
                    local num2 = math.random(50, 188)
                    local num3 = math.random(10, 30)
                    local userid = getbaseinfo(actor, ConstCfg.gbase.id)
                    local equalid = getiteminfo(actor, monobj, 2)
                    local level = Player.progressbarEX(actor, itemobj, 0, "level", "查询")
                    Player.progressbarEX(actor, itemobj, 0, "cur", "设置", 0)
                    Player.progressbarEX(actor, itemobj, 0, "level", "设置", level + 1)
                    if level >= 3 then
                        sendmail(userid, equalid, "暗黑之神宝藏",
                            "第【" .. level + 1 .. "】开启暗黑之神宝藏\\暗黑之神宝藏该装备已破碎\\获得宝藏奖励：金条x" .. num1 .. "灵石x" .. num3 .. "幻灵水晶x" ..
                            num2, "金条#" .. num1 .. "&灵石#" .. num3 .. "&幻灵水晶#" .. num2)
                        setplaydef(actor, VarCfg["J_宝箱开启次数"], OpenNumber + 1)
                        local itemname = getconst(actor, "<$SRIGHTHAND>")
                        takew(actor, itemname, 1)
                    else
                        sendmail(userid, equalid, "暗黑之神宝藏",
                            "第【" .. level + 1 .. "】开启暗黑之神宝藏\\获得宝藏奖励：金条x" .. num1 .. "灵石x" .. num3 .. "幻灵水晶x" .. num2,
                            "金条#" .. num1 .. "&灵石#" .. num3 .. "&幻灵水晶#" .. num2)
                        setplaydef(actor, VarCfg["J_宝箱开启次数"], OpenNumber + 1)
                    end
                end
            end
        end
    end
    --毁灭·魔化天使[吞噬] 击杀怪物时有概率增加(1层)吞噬值  1/58概率 最大吞噬上限为[100]层 每层吞噬值：可附加200点生命值 10点攻击力
    if checkitemw(actor, "毁灭·魔化天使[吞噬]", 1) then
        if randomex(1, 58) then --概率 1/128
            local num = getplaydef(actor, VarCfg["J_毁灭吞噬次数"])
            if num < 100 then --今日吞噬次数小于100
                setplaydef(actor, VarCfg["J_毁灭吞噬次数"], num + 1) --吞噬次数加1
                local itemobj = linkbodyitem(actor, 16)
                local itemName = getiteminfo(actor, itemobj, 7)
                local iteminfo = json2tbl(getitemcustomabil(actor, itemobj))
                if iteminfo == "" then
                    local tbl = {
                        ["abil"] = {
                            {
                                ["i"] = 5,
                                ["t"] = "[吞噬属性]\\<IMG:3>\\",
                                ["c"] = 251,
                                ["v"] = {
                                    { 0, 1, 1,  0, 31, 0, 1 },
                                    { 0, 4, 20, 0, 32, 1, 2 },
                                },
                            },
                        },
                        ["name"] = itemName .. "[吞噬 + 1]",
                    }
                    setitemcustomabil(actor, itemobj, tbl2json(tbl))
                else
                    local level = iteminfo.abil[6].v[2][3] / 20
                    local maxNum = 999
                    --贪欲不止解封层数
                    if getflagstatus(actor,VarCfg["F_剧情_贪欲不止_解封1"]) == 1 then
                        maxNum = maxNum + 333
                    end
                    if getflagstatus(actor,VarCfg["F_剧情_贪欲不止_解封2"]) == 1 then
                        maxNum = maxNum + 666
                    end
                    if getflagstatus(actor,VarCfg["F_剧情_贪欲不止_解封3"]) == 1 then
                        maxNum = maxNum + 999
                    end
                    if level < maxNum then
                        level = level + 1
                        setplaydef(actor,VarCfg["U_魔化天使_吞噬_层数"],level)
                        local tbl = {
                            ["abil"] = {
                                {
                                    ["i"] = 5,
                                    ["t"] = "[吞噬属性]\\<IMG:3>\\",
                                    ["c"] = 251,
                                    ["v"] = {
                                        { 0, 4, 1 * level,  0, 31, 0, 1 },
                                        { 0, 1, 20 * level, 0, 32, 1, 2 },
                                    },
                                },
                            },
                            ["name"] = itemName .. "[吞噬 + " .. level .. "][上限:" .. maxNum .. "]",
                        }
                        clearitemcustomabil(actor, itemobj, 5)
                        setitemcustomabil(actor, itemobj, tbl2json(tbl))
                    end
                end
            end
        end
    end
    --【噬魂】王之孤影 击杀怪物有概率增加(1层)噬魂之力    上限100
    local itemname = getconst(actor, "<$RING_R>")
    if itemname == "【噬魂】王之孤影" then
        if randomex(1, 128) then --概率 1/128
            local itemobj = linkbodyitem(actor, 7)
            local tbl = json2tbl(getcustomitemprogressbar(actor, itemobj, 0))            --获取第一条进度条信息
            if tbl["open"] == 1 and tbl["cur"] < 100  then
                local num = tbl["cur"] + 1
                setcustomitemprogressbar(actor, itemobj, 0, tbl2json({["cur"] = num}))
                _onRing_R_AttRefresh(actor, itemobj)
            end
        end
    end
end
GameEvent.add(EventCfg.onKillMon, _onKillMon, ZhuangBeiBuffMain)

--杀人触发
local function _onkillplay(actor, play)
    -- --【噬魂】王之孤影 击杀怪物有概率增加(1层)噬魂之力    上限100
    if getflagstatus(play, VarCfg.F_is_open_kuangbao) == 1 then     --是否有狂暴
        local itemname = getconst(actor, "<$RING_R>")
        if itemname == "【噬魂】王之孤影" then
            local itemobj = linkbodyitem(actor, 7)
            local tbl1 = json2tbl(getcustomitemprogressbar(actor, itemobj, 0))            --获取第一条进度条信息
            local tbl2 = json2tbl(getcustomitemprogressbar(actor, itemobj, 1))            --获取第二条进度条信息
            if tbl1["open"] == 1 and tbl1["cur"] < 100  then
                local num = tbl1["cur"] + 1
                setcustomitemprogressbar(actor, itemobj, 0, tbl2json({["cur"] = num}))
            end
            if tbl2["open"] == 1 and tbl2["cur"] < 10  then
                local num = tbl2["cur"] + 1
                setcustomitemprogressbar(actor, itemobj, 1, tbl2json({["cur"] = num}))
                Player.setAttList(actor, "倍攻附加")
            end
         _onRing_R_AttRefresh(actor, itemobj)
        end
    end
end
GameEvent.add(EventCfg.onkillplay, _onkillplay, ZhuangBeiBuffMain)

--计算倍攻触发
local function _onCalcBeiGong(actor, beiGongs)
    for i = 0, 41, 1 do
        local equipobj = linkbodyitem(actor, i)
        if equipobj ~= "0" then
            local equipName = getiteminfo(actor, equipobj, ConstCfg.iteminfo.name)
            local cfg = cfg_ZhuangBeiBuff[equipName]
            if cfg then
                if cfg.otherType == 3 then
                    local value = cfg.otherValue
                    beiGongs[1] = beiGongs[1] + value
                end
            end
        end
    end
end
GameEvent.add(EventCfg.onCalcBeiGong, _onCalcBeiGong, ZhuangBeiBuffMain)

-- 复活触发
local function _onRevive(actor)
    -- 灵魂之逐 穿戴是触发 人物复活后必定获得[100%暴击几率] (暴击几率的BUFF持续时间为5秒)
    if getflagstatus(actor, VarCfg["F_灵魂之逐"]) == 1 then
        changehumnewvalue(actor, 21, 100, 5)
        Player.buffTipsMsg(actor, "[灵魂之逐]:获得暴击几率[{+100%/FCOLOR=243}]持续[{5/FCOLOR=243}]秒...")
    end

    --·破碎裂痕· 复活后触发增加[50%]的最大攻击力(BUFF效果持续5秒·无法重复触发)
    if getconst(actor, "<$BELT>") == "·破碎裂痕·" then
        local buff = hasbuff(actor, 30044)
        if not buff then
            addbuff(actor, 30044, 5, 1, actor)
            Player.buffTipsMsg(actor, "[·破碎裂痕·]:增加{50%/FCOLOR=243}攻击力上限持续{5/FCOLOR=243}秒...")
        end
    end

    --死亡假面 当人物复活后会进入隐身状态2秒 下次攻击会斩杀人物15%的生命值
    if getconst(actor, "<$HAT>") == "死亡假面" then
        if not Player.checkCd(actor, VarCfg["隐身CD"], 60, true) then return end

        changemode(actor, 2, 2) --隐身2秒钟
        setplaydef(actor, VarCfg["S$_死亡假面"], 1)
        Player.buffTipsMsg(actor, "[死亡假面]:触发隐身状态,持续[{1/FCOLOR=243}]秒...")
    end

    -- 悲鸣之焰  人物复活后触发隐身[2秒]下次攻击 必定造成[3.0]倍伤害[CD:30秒]
    if checkitemw(actor, "悲鸣之焰", 1) then
        if not Player.checkCd(actor, VarCfg["隐身CD"], 60, true) then return end

        local buffcd = hasbuff(actor, 30029)
        if not buffcd then
            changemode(actor, 2, 2) --隐身2秒钟
            Player.buffTipsMsg(actor, "[悲鸣之焰]:触发隐身状态,持续[{2/FCOLOR=243}]秒...")
            setplaydef(actor, VarCfg["S$_悲鸣之焰"], 1)
            addbuff(actor, 30029, 30, 1, actor)
        end
    end

    --■龙之叹息■      复活后触发人物进入[霸体状态10秒]伤害     吸收[+20%],最大生命值[+30%]之后进入无敌状态1秒(霸体CD180秒)  [{2/FCOLOR=243}]
    if checkitemw(actor, "■龙之叹息■", 1)  then
        local buffcd = hasbuff(actor, 30025)
        if not buffcd then
            changemode(actor, 1, 1) --无敌1秒
            addbuff(actor, 30034, 10, 1, actor)  --霸体buff  10秒
            addbuff(actor, 30035, 120, 1, actor)
            Player.buffTipsMsg(actor,"[■龙之叹息■]:无敌{1/FCOLOR=243}秒并激活[{霸体/FCOLOR=243}]状态,生命增加[{30%/FCOLOR=243}],伤害吸收增加[{20%/FCOLOR=243}],持续[{10/FCOLOR=243}]秒...")
        end
    end

    --异空：千年之光 人物复活后能进入[无敌状态]1秒钟 当死亡时有(50%)的概率可原地重生
    if getflagstatus(actor, VarCfg["F_千年之光"]) == 1 then
        changemode(actor, 1, 1, nil, nil) --无敌1秒
        Player.buffTipsMsg(actor, "[异空：千年之光]:无敌{1/FCOLOR=243}秒...")
    end

    --桓龙：另一个时空 人物复活触发增加(50%)的暴击伤害(BUFF持续10秒·每次复活都可触发)
    if getflagstatus(actor, VarCfg["F_桓龙：另一个时空"]) == 1 then
        changehumnewvalue(actor, 22, 50, 10) --增加50%暴击伤害 持续10秒
        Player.buffTipsMsg(actor, "[桓龙：另一个时空]:暴击伤害增加{50%/FCOLOR=243},持续{10/FCOLOR=243}秒...")
    end

    --忍者面具 复活后进入隐身状态[两秒]并且下次攻击造成[3.0]倍伤害。
    if checkitemw(actor, "忍者面具", 1) then
        changemode(actor, 2, 2) --隐身2秒钟
        setplaydef(actor, VarCfg["S$_忍者面具"], 1)
    end

    -- 狂兽之护  人物触发复活后每秒恢复人物[10%]的最大生命值，效果持续(5秒)
    if checkitemw(actor, "狂兽之护", 1) then
        addbuff(actor, 30064, 5, 1, actor)
        Player.buffTipsMsg(actor, "[狂兽之护]:每秒恢复10%生命,持续5秒...")
    end

    -- 时光的沙漏  当人物触发复活后会[无敌2秒],期间无法攻击无法移动!(攻城时不触发)
    if checkitemw(actor, "时光的沙漏", 1) then
        if not getbaseinfo(actor, ConstCfg.gbase.issbk) then --不在攻城区域
            changemode(actor, 1, 2, nil, nil)                --无敌2秒
            changemode(actor, 10, 2, nil, nil)               --锁定2秒
            Player.buffTipsMsg(actor, "[时光的沙漏]:无敌{2/FCOLOR=243}秒,且无法移动...")
        end
    end

    --矮人头盔 人物触发复活后每秒恢复人物[10%]的最大生命值，效果持续(5秒)
    if checkitemw(actor, "矮人头盔", 1) then
        addbuff(actor, 30088, 5, 1, actor)
        Player.buffTipsMsg(actor, "[矮人头盔]:每秒恢复{10%/FCOLOR=243}生命,持续{5/FCOLOR=243}秒...")
    end

    --御天机 复活后随机获得1~2秒无敌
    if checkitemw(actor, "御天机", 1) then
        local  times = math.random(1, 2)
        changemode(actor, 1, times, nil, nil) --无敌1秒
        Player.buffTipsMsg(actor, "[御天机]:无敌{".. times .."/FCOLOR=243}秒...")
    end

end


GameEvent.add(EventCfg.onRevive, _onRevive, ZhuangBeiBuffMain)

return ZhuangBeiBuffMain

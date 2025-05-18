XiuXian = {}
local MonData = include("QuestDiary/cfgcsv/cfg_MonNameData.lua")       --怪物名单
local itemdata = include("QuestDiary/cfgcsv/cfg_XiuXianFaBaoData.lua") --法宝名单
local BaiGuai = include("QuestDiary/cfgcsv/cfg_BaiGuai.lua")       --怪物名单
local cfg_Task = include("QuestDiary/cfgcsv/cfg_Task.lua") --任务配置
local where = 43
XiuXian.QiYunGaiLv = {
    {50,10},
    {100,3},
    {200,2},
    {99999999999,1},
}

local function _setIcon(actor, itemObj)
    local itemName = getiteminfo(actor, itemObj, ConstCfg.iteminfo.name)
    local level = tonumber(getstditeminfo(itemName, ConstCfg.stditeminfo.custom29) or 0) ----获取装备等级
    local cfg = itemdata[level]
    if not cfg then
        return
    end
    seticon(actor, ConstCfg.iconWhere.faBao, 1, cfg.iconId, 0, 0, 0)
end

function XiuXian.Request(actor)
    local itemObj = linkbodyitem(actor, where)
    if itemObj == "0" then
        Player.sendmsgEx(actor, "没有装备对于的装备!#249")
        return
    end
    local itemName = getiteminfo(actor, itemObj, ConstCfg.iteminfo.name)
    local level = tonumber(getstditeminfo(itemName, ConstCfg.stditeminfo.custom29)) ----获取装备等级
    if level >= 21 then
        Player.sendmsgEx(actor, "你的修仙已满级!#249")
        return
    end
    local cfg = itemdata[level]
    local nextCfg = itemdata[level + 1]
    if not nextCfg then
        Player.sendmsgEx(actor, "你的修仙已满级!#249")
        return
    end
    if not cfg then
        Player.sendmsgEx(actor, "配置错误,请联系客服!#249")
        return
    end
    local currFaBaoExp = getplaydef(actor, VarCfg["U_法宝当前经验"])
    if currFaBaoExp < cfg.itemlevel then
        Player.sendmsgEx(actor, string.format("你的修仙进度不满|%s#249", cfg.itemlevel))
        return
    end
    local name, num = Player.checkItemNumByTable(actor, cfg.cost)
    if name then
        Player.sendmsgEx(actor, string.format("你的|%s#249|不足%d#249", name, num))
        return
    end
    if not Bag.checkBagEmptyNum(actor, 5) then
        Player.sendmsgEx(actor, "你的背包格子不足!")
        return
    end
    Player.takeItemByTable(actor, cfg.cost, "修仙")
    takew(actor, itemName, 1, "修仙拿走")
    local isSuccess = giveonitem(actor, where, nextCfg.itemname, 1, 0, "修仙给予")
    GameEvent.push(EventCfg.onXiuXianUP, actor,nextCfg.itemname)

    --验证任务
    XiuXian.CheckTask(actor)
    --溢出的经验值给下一级
    local nextCur = currFaBaoExp - cfg.itemlevel
    setplaydef(actor, VarCfg["U_法宝当前经验"], nextCur)
    local newItemObj = linkbodyitem(actor, where)
    if nextCfg.itemname == "潜龙阴阳石" then
        nextCur = nextCfg.itemlevel
    end
    local tbl = {
        ["open"] = 1,
        ["show"] = 2,
        ["name"] = "修仙进度",
        ["color"] = 253,
        ["imgcount"] = 1,
        ["cur"] = nextCur,
        ["max"] = nextCfg.itemlevel,
        ["level"] = level + 1,
    }
    setcustomitemprogressbar(actor, newItemObj, 0, tbl2json(tbl))
    refreshitem(actor, newItemObj)
    setitemintparam(actor, where, 1, 123)
    reddel(actor, 104, 1000)
    setplaydef(actor, VarCfg["N$人物按钮是否添加红点"], 0)
    setflagstatus(actor, VarCfg["F_修仙红点标识"], 0)
    XiuXian.QiYun(actor,newItemObj)
    XiuXian.SyncResponse(actor)
end
----气运-日月不离
--function XiuXian.QiYun(player)
--
--end

--验证任务
function XiuXian.CheckTask(actor)
    local taskID = getplaydef(actor, VarCfg["U_主线任务进度"])
    local mainTaskStatus = getplaydef(actor, VarCfg["U_主线任务状态"])
    if taskID == 7 and mainTaskStatus == 2 then
        local cfg = cfg_Task[taskID]
        Player.nextTaskMain(actor, taskID, cfg)
        Task.SyncResponse(actor)
        Player.sendmsgEx(actor,"")
    end
end
--同步消息
function XiuXian.SyncResponse(actor, logindatas)
    local data = {}
    local _login_data = { ssrNetMsgCfg.XiuXian_SyncResponse, 0, 0, 0, data }
    if logindatas then
        table.insert(logindatas, _login_data)
    else
        Message.sendmsg(actor, ssrNetMsgCfg.XiuXian_SyncResponse, 0, 0, 0, data)
    end
end

--外部接口
--添加修仙值
function XiuXian.addXiuXian(actor, addNum)
    local itemobj = linkbodyitem(actor, where) ----关联装备+
    local itemName,level
    local cfg = nil
    if itemobj ~= "0" then                     ----判定未穿戴直接返回
        itemName = getiteminfo(actor, itemobj, ConstCfg.iteminfo.name)            ----获取装备名字
        level = tonumber(getstditeminfo(itemName, ConstCfg.stditeminfo.custom29)) ----获取装备等级
        cfg = itemdata[level]
    end
    local currFaBaoExp = getplaydef(actor, VarCfg["U_法宝当前经验"])
    if cfg then
        if currFaBaoExp >= cfg.itemlevel then ----法宝经验满了 给红点
            if getplaydef(actor, VarCfg["N$人物按钮是否添加红点"]) == 0 then
                local client_flag = getconst(actor, "<$CLIENTFLAG>")
                if client_flag == "1" then
                    reddot(actor, 104, 1000, 16, -10, 1, 20000)
                else
                    reddot(actor, 107, 1000, 40, 6, 1, 20000)
                end
                setflagstatus(actor, VarCfg["F_修仙红点标识"], 1)
                setplaydef(actor, VarCfg["N$人物按钮是否添加红点"], 1)
            end
        end
    end
    local addExp = currFaBaoExp + addNum
    setplaydef(actor, VarCfg["U_法宝当前经验"], addExp)
    if itemobj ~= "0" then
        local maxValue = 0
        if cfg then
            maxValue = cfg.itemlevel
        end
        local tbl = {
            ["open"] = 1,
            ["show"] = 2,
            ["name"] = "修仙进度",
            ["color"] = 253,
            ["imgcount"] = 1,
            ["cur"] = addExp,
            ["max"] =  maxValue,
            ["level"] = level,
        }
        setcustomitemprogressbar(actor, itemobj, 0, tbl2json(tbl))
        refreshitem(actor, itemobj)
    end
end

local function _setRiYueBuLi(actor, MonName, itemobj)
    if BaiGuai[MonName] then
        if getflagstatus(actor,VarCfg["F_日月不离"]) == 1 then
            local num = getplaydef(actor,VarCfg["U_日月不离进度"])
            local flag = 1
            for i=1,#XiuXian.QiYunGaiLv do
                if num < XiuXian.QiYunGaiLv[i][1] then
                    flag = i
                    break
                end
            end
            local random = math.random(1,100)
            if random <= XiuXian.QiYunGaiLv[flag][2] then
                setplaydef(actor,VarCfg["U_日月不离进度"],num+1)
                XiuXian.QiYun(actor,itemobj)
            end
        end
    end
end

function XiuXian.QiYun(actor,item)
    local num = getplaydef(actor, VarCfg["U_日月不离进度"])
    local tbl = {
        ["open"] = 1,
        ["show"] = 2,
        ["name"] = "日月不离",
        ["color"] = 253,
        ["imgcount"] = 1,
        ["cur"] = num,
        ["max"] = num,
        ["level"] = 0,
    }
    setplaydef(actor, VarCfg["U_日月不离进度"], num)
    setcustomitemprogressbar(actor,item,1,tbl2json(tbl))
    tbl = {key = {{254,1,100,0,0},{254,3,100,0,1},{254,4,100,0,2}},value = {300*num,10*num,10*num}}
    Player.AddCustomAttr(actor,item,"[日月不离属性]",tbl)
    refreshitem(actor,item)
    return ""
end

--任意杀怪触发
local function _XiuXianKillmon(actor, monobj, monName)
    local itemobj = linkbodyitem(actor, where) ----关联装备
    if itemobj == "0" then                     ----判定未穿戴直接返回
        return
    end
    local MonName = monName
    _setRiYueBuLi(actor, MonName, itemobj)
    local info = MonData[MonName]
    if info then
        local itemName = getiteminfo(actor, itemobj, ConstCfg.iteminfo.name)            ----获取装备名字
        local level = tonumber(getstditeminfo(itemName, ConstCfg.stditeminfo.custom29)) ----获取装备等级
        --如果满级
        if level >= 21 then
            return
        end
        local cfg = itemdata[level]
        if not cfg then
            return
        end
        if level < cfg.itemlevel then
            local currFaBaoExp = getplaydef(actor, VarCfg["U_法宝当前经验"])
            if currFaBaoExp >= cfg.itemlevel then ----法宝经验满了 给红点
                if getplaydef(actor, VarCfg["N$人物按钮是否添加红点"]) == 0 then
                    local client_flag = getconst(actor, "<$CLIENTFLAG>")
                    if client_flag == "1" then
                        reddot(actor, 104, 1000, 16, -10, 1, 20000)
                    else
                        reddot(actor, 107, 1000, 40, 6, 1, 20000)
                    end
                    setflagstatus(actor, VarCfg["F_修仙红点标识"], 1)
                    setplaydef(actor, VarCfg["N$人物按钮是否添加红点"], 1)
                end
                return
            end
            local rannum = math.random(info.random[1], info.random[2])
            local xiuXianZhiAddtion = getbaseinfo(actor, ConstCfg.gbase.custom_attr, 217)
            if xiuXianZhiAddtion > 0 then
                local addtionValue = math.floor(rannum * xiuXianZhiAddtion / 100)
                rannum = rannum + addtionValue
            end
            local addExp = currFaBaoExp + rannum
            setplaydef(actor, VarCfg["U_法宝当前经验"], addExp)
            local tbl = {
                ["open"] = 1,
                ["show"] = 2,
                ["name"] = "修仙进度",
                ["color"] = 253,
                ["imgcount"] = 1,
                ["cur"] = addExp,
                ["max"] = cfg.itemlevel,
                ["level"] = level,
            }
            setcustomitemprogressbar(actor, itemobj, 0, tbl2json(tbl))
            refreshitem(actor, itemobj)
        end
    end
    
end
GameEvent.add(EventCfg.onKillMon, _XiuXianKillmon, XiuXian)

local function _onTakeOn43(actor, itemobj)
    local itemName = getiteminfo(actor, itemobj, ConstCfg.iteminfo.name)            ----获取装备名字
    local level = tonumber(getstditeminfo(itemName, ConstCfg.stditeminfo.custom29)) ----获取装备等级
    setplaydef(actor, VarCfg["U_修仙等级"], level)
    -- local cfg = itemdata[level]
    -- if not cfg then
    --     return
    -- end
    -- local xiuXianExp = getplaydef(actor, VarCfg["U_法宝当前经验"])
    -- local tbl = {
    --     ["open"] = 1,
    --     ["show"] = 2,
    --     ["name"] = "修仙进度",
    --     ["color"] = 253,
    --     ["imgcount"] = 1,
    --     ["cur"] = xiuXianExp,
    --     ["max"] = cfg.itemlevel,
    --     ["level"] = level,
    -- }
    -- setcustomitemprogressbar(actor, itemobj, 0, tbl2json(tbl))
    -- refreshitem(actor, itemobj)

    _setIcon(actor, itemobj)
end
GameEvent.add(EventCfg.onTakeOn43, _onTakeOn43, XiuXian)

--登录触发
local function _onLoginEnd(actor, logindatas)
    XiuXian.SyncResponse(actor, logindatas)
    local itemobj = linkbodyitem(actor, where) ----关联装备
    if itemobj == "0" then
        return
    end
    _setIcon(actor, itemobj)
    if getflagstatus(actor, VarCfg["F_修仙红点标识"]) == 1 then
        local itemName = getiteminfo(actor, itemobj, ConstCfg.iteminfo.name)            ----获取装备名字
        local level = tonumber(getstditeminfo(itemName, ConstCfg.stditeminfo.custom29)) ----获取装备等级
        if level < 21 then
            local client_flag = getconst(actor, "<$CLIENTFLAG>")
            if client_flag == "1" then
                reddot(actor, 104, 1000, 16, -10, 1, 20000)
            else
                reddot(actor, 107, 1000, 40, 6, 1, 20000)
            end
        end
    end
end
--注册网络消息
Message.RegisterNetMsg(ssrNetMsgCfg.XiuXian, XiuXian)
--事件派发
GameEvent.add(EventCfg.onLoginEnd, _onLoginEnd, XiuXian)

--触发
GameEvent.add(EventCfg.onKFLogin, _onLoginEnd, XiuXian)

--攻击怪物触发
local function _onAttackMonster(actor, Target, Hiter, MagicId, qieGe)
    local level = getplaydef(actor, VarCfg["U_修仙等级"])
    local cfg = itemdata[level]
    if cfg then
        local qieGe = getbaseinfo(actor, ConstCfg.gbase.custom_attr, 200)
        if cfg.effect1 then
            if randomex(10) then
                local damage = math.floor(qieGe * (cfg.effect1 / 100))
                local x = getbaseinfo(Target, ConstCfg.gbase.x)
                local y = getbaseinfo(Target, ConstCfg.gbase.y)
                rangeharm(actor, x, y, 0, 0, 6, damage, 0, 2,16017, 1)
                return
            end
        end
        if cfg.effect2 then
            if randomex(2) then
                addbuff(actor, 31052)
                return
            end
        end
        if cfg.effect3 then
            if randomex(2) then
                local damage = math.floor(qieGe * (cfg.effect3 / 100))
                local x = getbaseinfo(actor, ConstCfg.gbase.x)
                local y = getbaseinfo(actor, ConstCfg.gbase.y)
                rangeharm(actor, x, y, 8, damage, 0, 0, 0, 2)
                playeffect(actor, 17524, 0, 0, 1, 0, 1)
                return
            end
        end
    end
end
GameEvent.add(EventCfg.onAttackMonster, _onAttackMonster, XiuXian)

return XiuXian

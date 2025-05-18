XingYunXiangLian = {}
local costDaMi2 = { { "灵符", 2888 } }

local config = include("QuestDiary/cfgcsv/cfg_XingYunXiangLian.lua") --幸运项链
function XingYunXiangLian.Request(actor)
    local itemobj = linkbodyitem(actor, 3)
    local xingYun = getplaydef(actor, VarCfg.U_xing_yun)
    local xingYunCount = getplaydef(actor, VarCfg.U_xing_yun_count)
    xingYun = xingYun + 1
    local cfg = config[xingYun]

    if itemobj == "0" then
        Player.sendmsgEx(actor, "提示#251|:#255|你未佩戴|项链#249|项链强化失败...")
        return
    end

    if xingYun == 13 then
        Player.sendmsgEx(actor, "提示#251|:#255|你|幸运#249|已强化到|12#249|无法继续强化...")
        GameEvent.push(EventCfg.onXingYunXiangLian,actor,12)
        return
    end
    local name, num = Player.checkItemNumByTable(actor, cfg.moneynum)
    if name then
        Player.sendmsgEx(actor, string.format("提示#251|:#255|你的|%s#249|,不足|%d枚#249|无法强化幸运...", name, num))
        return
    end

    Player.takeItemByTable(actor, cfg.moneynum, "幸运项链")

    setplaydef(actor, VarCfg.U_xing_yun_count, xingYunCount + 1)


    --判断天眷之人是否百分百成功
    local success = 0
    local tjzrFlag = getflagstatus(actor, VarCfg["F_天命_天眷之人标识"])
    local todayFirst = getplaydef(actor, VarCfg["J_天命天眷之人第一次"])
    if tjzrFlag == 1 and todayFirst == 0 then
        success = 100
        Player.sendmsgEx(actor, "[天眷之人]触发,您的幸运项链成功率百分之百!")
        setplaydef(actor, VarCfg["J_天命天眷之人第一次"], 1)
    else
        success = cfg.successRate
    end
    if randomex(success) then
        setplaydef(actor, VarCfg.U_xing_yun, xingYun)
        Player.sendmsgEx(actor, "提示#251|:#255|恭喜你,强化|成功#249|幸运增加|1#249|点...")
    else
        setplaydef(actor, VarCfg.U_xing_yun, xingYun - 2)
        Player.sendmsgEx(actor, "提示#251|:#255|对不起,强化|失败#249|幸运下降|1#249|点...")
    end

    if getplaydef(actor, VarCfg.U_xing_yun_count) >= 288 then
        setplaydef(actor, VarCfg.U_xing_yun, 12)
        Player.sendmsgEx(actor, "提示#251|:#255|恭喜你,强化次数|达到288次#249|幸运直接达到|12#249|点...")
    end
    GameEvent.push(EventCfg.onXingYunXiangLian,actor,getplaydef(actor, VarCfg.U_xing_yun))
    XingYunXiangLian.setNecklaceAttributes(actor) --设置项链属性
    XingYunXiangLian.SyncResponse(actor)          --同步一次消息
end

function XingYunXiangLian.Request2(actor)
    local itemobj = linkbodyitem(actor, 3)
    if itemobj == "0" then
        Player.sendmsgEx(actor, "强化幸运时请将项链佩戴在任务身上!#249")
        return
    end

    local xingYun = getplaydef(actor, VarCfg.U_xing_yun)
    if xingYun >= 12 then
        Player.sendmsgEx(actor, "提示#251|:#255|你|幸运#249|已强化到|12#249|无法继续强化...")
        return
    end

    local name, num = Player.checkItemNumByTable(actor, costDaMi2)
    if name then
        Player.sendmsgEx(actor, string.format("提示#251|:#255|,你的|%s#249|,不足|%d枚#249|无法强化幸运...", name, num))
        return
    end

    Player.takeItemByTable(actor, costDaMi2, "幸运项链+12")
    setplaydef(actor, VarCfg.U_xing_yun, 12)
    GameEvent.push(EventCfg.onXingYunXiangLian,actor,getplaydef(actor, VarCfg.U_xing_yun))
    messagebox(actor, "你的项链已经直接幸运强化+12!")
    XingYunXiangLian.setNecklaceAttributes(actor) --设置项链属性
    --同步一次消息
    XingYunXiangLian.SyncResponse(actor)
end

--响应消息同步
function XingYunXiangLian.RequestSync(actor)
    XingYunXiangLian.SyncResponse(actor)
end

--设置项链属性
function XingYunXiangLian.setNecklaceAttributes(actor, itemobj)
    local xingYun = getplaydef(actor, VarCfg.U_xing_yun)
    --如果没有传递就回去身上的
    if not itemobj then
        itemobj = linkbodyitem(actor, 3)
    end
    local cfg = config[xingYun] or {}
    if not cfg then
        xingYun = 0
        cfg.element1 = 0
        cfg.element2 = 0
    end
    setaddnewabil(actor, -2, "=",
        string.format("3#75#%d|3#22#%d|3#30#%d", cfg.element1 or 0, cfg.element2 or 0, cfg.element2 or 0), itemobj)
    setitemaddvalue(actor, itemobj, 1, 5, xingYun)
    refreshitem(actor, itemobj)
    recalcabilitys(actor)
end

------------引擎出发↓↓↓--------------------------
local function _onTakeOnNecklace(actor, itemobj)
    XingYunXiangLian.setNecklaceAttributes(actor, itemobj)
end
local function _onTakeOffNecklace(actor, itemobj)
    --清空属性
    local itemobj1 = linkbodyitem(actor, 3)
    -- release_print(itemobj1, itemobj)
    setitemaddvalue(actor, itemobj, 1, 5, 0)
    setitemaddvalue(actor, itemobj1, 1, 5, 0)
    setaddnewabil(actor, -2, "=", string.format("3#75#%d|3#22#%d|3#30#%d", 0, 0, 0), itemobj)
    refreshitem(actor, itemobj)
    recalcabilitys(actor)
end

--穿项链前出发
GameEvent.add(EventCfg.onTakeOnNecklace, _onTakeOnNecklace, XingYunXiangLian)

--脱下前项链出发
GameEvent.add(EventCfg.onTakeOffNecklace, _onTakeOffNecklace, XingYunXiangLian)


-------------网络消息↓↓↓--------------------------
Message.RegisterNetMsg(ssrNetMsgCfg.XingYunXiangLian, XingYunXiangLian)
--同步网络消息
function XingYunXiangLian.SyncResponse(actor, logindatas)
    local xingYun = getplaydef(actor, VarCfg.U_xing_yun)
    local xingYunCount = getplaydef(actor, VarCfg.U_xing_yun_count)
    local tjzrFlag = getflagstatus(actor, VarCfg["F_天命_天眷之人标识"]) --是否百分百成功
    local todayFirst = getplaydef(actor, VarCfg["J_天命天眷之人第一次"])
    local _login_data = { ssrNetMsgCfg.XingYunXiangLian_SyncResponse, xingYun, xingYunCount, tjzrFlag, { todayFirst } }
    if logindatas then
        table.insert(logindatas, _login_data)
    else
        Message.sendmsg(actor, ssrNetMsgCfg.XingYunXiangLian_SyncResponse, xingYun, xingYunCount, tjzrFlag, { todayFirst })
    end
end

--登录触发
local function _onLoginEnd(actor, logindatas)
    XingYunXiangLian.SyncResponse(actor, logindatas)
end
--事件派发
GameEvent.add(EventCfg.onLoginEnd, _onLoginEnd, XingYunXiangLian)



return XingYunXiangLian

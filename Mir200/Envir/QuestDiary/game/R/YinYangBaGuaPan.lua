local YinYangBaGuaPan = {}
YinYangBaGuaPan.ID = "阴阳八卦盘"
local npcID = 448
local cfg_ZhuangBan = include("QuestDiary/cfgcsv/cfg_ZhuangBan.lua")       --配置
--local config = include("QuestDiary/cfgcsv/cfg_YinYangBaGuaPan.lua") --配置
local cost1 = { { "阴", 1 }, { "元宝", 100000 } }
local cost2 = { { "阳", 1 }, { "元宝", 100000 } }
function YinYangBaGuaPan.checkTitle(actor)
    local yin = getplaydef(actor, VarCfg["U_剧情_阴阳八卦盘_阴"])
    local yang = getplaydef(actor, VarCfg["U_剧情_阴阳八卦盘_阳"])
    if yin >= 66 and yang >= 66 then
        confertitle(actor, "阴阳合一")
        messagebox(actor,"恭喜你获得称号[阴阳合一]")
    end
end
--接收请求
function YinYangBaGuaPan.Request1(actor)
    local cost = cost1
    local yin = getplaydef(actor, VarCfg["U_剧情_阴阳八卦盘_阴"])
    local yang = getplaydef(actor, VarCfg["U_剧情_阴阳八卦盘_阳"])
    if yin >= 66 then
        Player.sendmsgEx(actor, "阴最多只能提交66次")
        return
    end
    local name, num = Player.checkItemNumByTable(actor, cost)
    if name then
        Player.sendmsgEx(actor, string.format("你的|%s#249|不足|%d#249", name, num))
        return
    end
    Player.takeItemByTable(actor, cost, "阴阳八卦盘")
    setplaydef(actor, VarCfg["U_剧情_阴阳八卦盘_阴"], yin + 1)
    if yin + 1 == 1 then
        local taskPanelID = getplaydef(actor, VarCfg["U_主线任务面板进度"])
        if taskPanelID == 34 then
            FCheckTaskRedPoint(actor)
        end
    end
    Player.sendmsgEx(actor, string.format("提交成功当前提交次数为|%d#249", yin + 1))
    if yin + 1 ~= yang then
        if yin + 1 > yang then
            Player.sendmsgEx(actor, "注意!当前阴和阳不平衡,只有|[阴]#249|可以获得属性加成")
        else
            Player.sendmsgEx(actor, "注意!当前阴和阳不平衡,只有|[阳]#249|可以获得属性加成")
        end
    else
        Player.sendmsgEx(actor, "当前阴阳次数平衡,都可以获得属性加成")
    end
    YinYangBaGuaPan.checkTitle(actor)
    Player.setAttList(actor, "属性附加")
    YinYangBaGuaPan.SyncResponse(actor)
end

--接收请求
function YinYangBaGuaPan.Request2(actor)
    local cost = cost2
    local yin = getplaydef(actor, VarCfg["U_剧情_阴阳八卦盘_阴"])
    local yang = getplaydef(actor, VarCfg["U_剧情_阴阳八卦盘_阳"])
    if yang >= 66 then
        Player.sendmsgEx(actor, "阴最多只能提交66次")
        return
    end
    local name, num = Player.checkItemNumByTable(actor, cost)
    if name then
        Player.sendmsgEx(actor, string.format("你的|%s#249|不足|%d#249", name, num))
        return
    end
    Player.takeItemByTable(actor, cost, "阴阳八卦盘")
    setplaydef(actor, VarCfg["U_剧情_阴阳八卦盘_阳"], yang + 1)
    if yang + 1 == 1 then
        local taskPanelID = getplaydef(actor, VarCfg["U_主线任务面板进度"])
        if taskPanelID == 34 then
            FCheckTaskRedPoint(actor)
        end
    end
    Player.sendmsgEx(actor, string.format("提交成功当前提交次数为|%d#249", yang + 1))
    if yin ~= yang + 1 then
        if yin > yang + 1 then
            Player.sendmsgEx(actor, "注意!当前阴和阳不平衡,只有|[阴]#249|可以获得属性加成")
        else
            Player.sendmsgEx(actor, "注意!当前阴和阳不平衡,只有|[阳]#249|可以获得属性加成")
        end
    else
        Player.sendmsgEx(actor, "当前阴阳次数平衡,都可以获得属性加成")
    end
    YinYangBaGuaPan.checkTitle(actor)
    Player.setAttList(actor, "属性附加")
    YinYangBaGuaPan.SyncResponse(actor)
end

--同步消息
function YinYangBaGuaPan.SyncResponse(actor, logindatas)
    local data = {}
    local yin = getplaydef(actor, VarCfg["U_剧情_阴阳八卦盘_阴"])
    local yang = getplaydef(actor, VarCfg["U_剧情_阴阳八卦盘_阳"])
    local _login_data = { ssrNetMsgCfg.YinYangBaGuaPan_SyncResponse, yin, yang, 0, data }
    if logindatas then
        table.insert(logindatas, _login_data)
    else
        Message.sendmsg(actor, ssrNetMsgCfg.YinYangBaGuaPan_SyncResponse, yin, yang, 0, data)
    end
end

--登录触发
local function _onLoginEnd(actor, logindatas)
    YinYangBaGuaPan.SyncResponse(actor, logindatas)
end
--事件派发
GameEvent.add(EventCfg.onLoginEnd, _onLoginEnd, YinYangBaGuaPan)

local function _onCalcAttr(actor, attrs)
    local shuxing = {}
    if not checktitle(actor,"阴阳合一") then
        local yin = getplaydef(actor, VarCfg["U_剧情_阴阳八卦盘_阴"])
        local yang = getplaydef(actor, VarCfg["U_剧情_阴阳八卦盘_阳"])
        local isAllAttr
        --阴阳是否平衡
        if yin == yang then
            isAllAttr = true
        else
            isAllAttr = false
        end
        local attType
        if yin > yang then
            attType = true
        else
            attType = false
        end
        if yin > 0 and isAllAttr or attType then
            shuxing[68] = yin * 100
            local attackPer = math.floor(yin / 10)
            if attackPer > 0 then
                shuxing[206] = attackPer
            end
        end
        if yang > 0 and isAllAttr or not attType then
            shuxing[200] = yang * 100
            local hpPer = math.floor(yang / 10)
            if hpPer > 0 then
                shuxing[207] = hpPer
            end
        end
    else
        local number = getplaydef(actor, VarCfg["U_时装外观记录"])
        if number > 0 then
            local cfg = cfg_ZhuangBan[number]
            if cfg then
                if cfg.gender == 1 then
                    shuxing[208] = 10
                elseif cfg.gender == 2 then
                    shuxing[210] = 10
                    shuxing[221] = 10
                end
            end
        end
    end

    calcAtts(attrs, shuxing, "阴阳八卦境")
end
GameEvent.add(EventCfg.onCalcAttr, _onCalcAttr, YinYangBaGuaPan)

--注册网络消息
Message.RegisterNetMsg(ssrNetMsgCfg.YinYangBaGuaPan, YinYangBaGuaPan)
return YinYangBaGuaPan

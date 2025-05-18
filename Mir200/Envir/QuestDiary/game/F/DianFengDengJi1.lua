local DianFengDengJi1 = {}
DianFengDengJi1.ID = "巅峰等级"
local npcID = 422
local attGroup = "巅峰等级属性"
local config = include("QuestDiary/cfgcsv/cfg_DianFengDengJi1.lua") --配置
-- 你我山巅自相逢·入世
-- 你我山巅自相逢·出尘
-- 你我山巅自相逢·内敛
function dian_feng_deng_ji_one(actor)
    local level = getplaydef(actor, VarCfg["U_巅峰等级1"])
    local perAtt = 0
    if level > 0 then
        local cfg = config[level]
        if not cfg then
            return
        end
        perAtt = cfg.perNum or 0
        local qiegeStr = ""
        if checktitle(actor,"你我山巅自相逢·入世") then
            local gongJi = getbaseinfo(actor, ConstCfg.gbase.dc2)
            perAtt = 0.3
            qiegeStr = "|3#200#"..math.ceil(gongJi * 0.08)
        end
        local daoShu = getbaseinfo(actor, ConstCfg.gbase.sc2)
        local addGongJiStr = "3#4#"..math.ceil(daoShu * perAtt) .. qiegeStr
        addattlist(actor, attGroup, "=", addGongJiStr, 1)
        callscriptex(actor,"SENDMSG",5,"巅峰等级属性已经附加!")
    end
end
--接收请求
local function dianFengAddAtt(actor)
    delattlist(actor, attGroup)
    --如果已经有3级了，则不再计算
    local dfThree = getplaydef(actor, VarCfg["U_巅峰等级3"])
    if dfThree > 0 then
        return
    end
    if checktitle(actor,"你我山巅自相逢·出尘") then
        return
    end
    if checktitle(actor,"你我山巅自相逢·内敛") then
        return
    end
    delaygoto(actor,1500,"dian_feng_deng_ji_one")
end
function DianFengDengJi1.Request(actor, costType)
    if checktitle(actor,"你我山巅自相逢·入世") then
        Player.sendmsgEx(actor,"已经满级了#249")
        return
    end
    if checktitle(actor,"你我山巅自相逢·出尘") then
        Player.sendmsgEx(actor,"已经满级了#249")
        return
    end
    if checktitle(actor,"你我山巅自相逢·内敛") then
        Player.sendmsgEx(actor,"已经满级了#249")
        return
    end
    if costType ~= 1 and costType ~= 2 then
        Player.sendmsgEx(actor,"参数错误!")
        return
    end
    local level = getplaydef(actor, VarCfg["U_巅峰等级1"])
    local nextLevel = level + 1
    local cfg = config[nextLevel]
    if not cfg then
        Player.sendmsgEx(actor,"已经满级了#249")
        return
    end
    local cost
    if costType == 1 then
        cost = cfg.cost1
    else
        cost = cfg.cost2
    end
    local name, num = Player.checkItemNumByTable(actor, cost)
    if name then
        Player.sendmsgEx(actor, string.format("你的|%s#249|不足|%d#249", name, num))
        return
    end
    Player.takeItemByTable(actor, cost,"巅峰等级")
    setplaydef(actor, VarCfg["U_巅峰等级1"], nextLevel)
    local maxLevel = getplaydef(actor, VarCfg["U_等级上限"])
    maxLevel = maxLevel + 1
    setplaydef(actor,VarCfg["U_等级上限"], maxLevel)
    setlocklevel(actor, 1, maxLevel)
    Player.sendmsgEx(actor, "巅峰等级提升成功!")
    if nextLevel >= 10 then
        confertitle(actor, "你我山巅自相逢·入世")
        messagebox(actor,"恭喜你获得称号【你我山巅自相逢·入世】")
    end
    DianFengDengJi1.SyncResponse(actor)
end
--同步消息
function DianFengDengJi1.SyncResponse(actor, logindatas)
    local level = getplaydef(actor, VarCfg["U_巅峰等级1"])
    dianFengAddAtt(actor) --计算属性
    local data = {}
    local _login_data = {ssrNetMsgCfg.DianFengDengJi1_SyncResponse, level, 0, 0, data}
    if logindatas then
        table.insert(logindatas, _login_data)
    else
        Message.sendmsg(actor, ssrNetMsgCfg.DianFengDengJi1_SyncResponse, level, 0, 0, data)
    end
end
--登录触发
local function _onLoginEnd(actor, logindatas)
    DianFengDengJi1.SyncResponse(actor, logindatas)
end
--事件派发
GameEvent.add(EventCfg.onLoginEnd, _onLoginEnd, DianFengDengJi1)

local function _onTakeOnEx(actor, itemobj, where, itemname, makeid)
    dianFengAddAtt(actor)
end
GameEvent.add(EventCfg.onTakeOnEx, _onTakeOnEx, DianFengDengJi1)

local function _onTakeOffEx(actor, itemobj, where, itemname, makeid)
    dianFengAddAtt(actor)
end
GameEvent.add(EventCfg.onTakeOffEx, _onTakeOffEx, DianFengDengJi1)

--注册网络消息
Message.RegisterNetMsg(ssrNetMsgCfg.DianFengDengJi1, DianFengDengJi1)
return DianFengDengJi1
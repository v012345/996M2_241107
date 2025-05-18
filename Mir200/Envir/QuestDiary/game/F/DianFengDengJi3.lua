local DianFengDengJi3 = {}
DianFengDengJi3.ID = "巅峰等级3"
local npcID = 712
local config = include("QuestDiary/cfgcsv/cfg_DianFengDengJi3.lua") --配置
-- 你我山巅自相逢·入世
-- 你我山巅自相逢·出尘
-- 你我山巅自相逢·内敛

function dian_feng_deng_ji_three(actor)
    -- release_print(attrStr,"内敛")
    local level = getplaydef(actor, VarCfg["U_巅峰等级3"])
    --道术转攻击比例
    local perAtt1 = 0
    --魔法转生命比例
    local perAtt2 = 0
    if level > 0 then
        local cfg = config[level]
        perAtt1 = cfg.perNum1 or 0
        perAtt2 = cfg.perNum2 or 0
        --计算攻击转切割
        local qiegeStr = ""
        local gongJi = getbaseinfo(actor, ConstCfg.gbase.dc2)
        if checktitle(actor,"你我山巅自相逢·内敛") then
            qiegeStr = "3#200#"..math.ceil(gongJi * 0.30)
        else
            qiegeStr = "3#200#"..math.ceil(gongJi * 0.15)
        end
        local daoShu = getbaseinfo(actor, ConstCfg.gbase.sc2) --获取道术上限
        local moFa = getbaseinfo(actor, ConstCfg.gbase.mc2) --获取魔法上限
        local addGongJiStr = "3#4#"..math.ceil(daoShu * perAtt1)
        local moFaToHpStr = "3#1#"..math.ceil(moFa * perAtt2)
        local atts = {addGongJiStr,moFaToHpStr,qiegeStr}
        local attStr = table.concat(atts, "|")
        addattlist(actor, "巅峰等级3属性", "=", attStr, 1)
        callscriptex(actor,"SENDMSG",5,"巅峰等级属性已经附加!")
    end
end
local function dianFengAddAtt(actor)
    local level = getplaydef(actor, VarCfg["U_巅峰等级3"])
    if level > 0 then
        delattlist(actor,"巅峰等级3属性")
        delaygoto(actor,1500,"dian_feng_deng_ji_three")
    end
end
--接收请求
function DianFengDengJi3.Request(actor, costType)
    if checktitle(actor,"你我山巅自相逢·内敛") then
        Player.sendmsgEx(actor,"已经满级了#249")
        return
    end
    if not checktitle(actor,"你我山巅自相逢·出尘") then
        Player.sendmsgEx(actor,"点满巅峰等级·出尘才可以继续提升#249")
        return
    end
    if costType ~= 1 and costType ~= 2 then
        Player.sendmsgEx(actor,"参数错误!")
        return
    end
    local level = getplaydef(actor, VarCfg["U_巅峰等级3"])
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
    Player.takeItemByTable(actor, cost,"巅峰等级3")
    setplaydef(actor, VarCfg["U_巅峰等级3"], nextLevel)
    local maxLevel = getplaydef(actor, VarCfg["U_等级上限"])
    maxLevel = maxLevel + 1
    setplaydef(actor,VarCfg["U_等级上限"], maxLevel)
    setlocklevel(actor, 1, maxLevel)
    Player.sendmsgEx(actor, "巅峰等级提升成功!")
    delattlist(actor, "巅峰等级2属性")
    if nextLevel >= 10 then
        deprivetitle(actor, "你我山巅自相逢·出尘")
        confertitle(actor, "你我山巅自相逢·内敛")
        messagebox(actor,"恭喜你获得称号【你我山巅自相逢·内敛】")
    end
    DianFengDengJi3.SyncResponse(actor)
end
--同步消息
function DianFengDengJi3.SyncResponse(actor, logindatas)
    local level = getplaydef(actor, VarCfg["U_巅峰等级3"])
    dianFengAddAtt(actor) --计算属性
    local data = {}
    local _login_data = {ssrNetMsgCfg.DianFengDengJi3_SyncResponse, level, 0, 0, data}
    if logindatas then
        table.insert(logindatas, _login_data)
    else
        Message.sendmsg(actor, ssrNetMsgCfg.DianFengDengJi3_SyncResponse, level, 0, 0, data)
    end
end
--登录触发
local function _onLoginEnd(actor, logindatas)
    DianFengDengJi3.SyncResponse(actor, logindatas)
end
--事件派发
GameEvent.add(EventCfg.onLoginEnd, _onLoginEnd, DianFengDengJi3)

local function _onTakeOnEx(actor, itemobj, where, itemname, makeid)
    dianFengAddAtt(actor)
end
GameEvent.add(EventCfg.onTakeOnEx, _onTakeOnEx, DianFengDengJi3)

local function _onTakeOffEx(actor, itemobj, where, itemname, makeid)
    dianFengAddAtt(actor)
end
GameEvent.add(EventCfg.onTakeOffEx, _onTakeOffEx, DianFengDengJi3)

--注册网络消息
Message.RegisterNetMsg(ssrNetMsgCfg.DianFengDengJi3, DianFengDengJi3)
return DianFengDengJi3
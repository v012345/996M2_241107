local YiYeYiPuTi = {}
YiYeYiPuTi.ID = "一叶一菩提"
local npcID = 514
local config = include("QuestDiary/cfgcsv/cfg_YiYeYiPuTi.lua") --配置
local cost = { { "血菩提", 1 } }
local give = { {} }
function deng_ji_shang_xian_ti_shi(actor)
    if not FCheckNPCRange(actor, npcID, 15) then
        Player.sendmsgEx(actor, "距离PNC太远!#249")
        return
    end
    local name, num = Player.checkItemNumByTable(actor, cost)
    if name then
        Player.sendmsgEx(actor, string.format("你的|%s#249|不足|%d#249", name, num))
        return
    end
    Player.takeItemByTable(actor, cost, "一叶一菩提")
    local count = getplaydef(actor, VarCfg["U_剧情_一叶一菩提_次数"])
    if count < 10 then
        setplaydef(actor, VarCfg["U_剧情_一叶一菩提_次数"], count + 1)
    end
    Player.sendmsgEx(actor, "提交成功,属性大幅增加!")
    Player.setAttList(actor, "属性附加")
    YiYeYiPuTi.SyncResponse(actor)
end
--接收请求
function YiYeYiPuTi.Request(actor)
    if not FCheckNPCRange(actor, npcID, 15) then
        Player.sendmsgEx(actor, "距离PNC太远!#249")
        return
    end
    local name, num = Player.checkItemNumByTable(actor, cost)
    if name then
        Player.sendmsgEx(actor, string.format("你的|%s#249|不足|%d#249", name, num))
        return
    end
    local count = getplaydef(actor, VarCfg["U_剧情_一叶一菩提_次数"])
    local liveMax = getplaydef(actor,VarCfg["U_等级上限"])
    local myLevel = getbaseinfo(actor, ConstCfg.gbase.level)
    local currMaxExp = getbaseinfo(actor, ConstCfg.gbase.maxexp)
    local currMaxExpPer = calculatePercentageResult(currMaxExp, 30)
    if count >= 10  then
        if myLevel >= liveMax then
            Player.sendmsgEx(actor, "你已经达到等级上限,无法继续使用!#249")
            return
        end
        Player.sendmsgEx(actor, "提交成功,经验增加30%!")
        changeexp(actor, "+", currMaxExpPer, false)
        Player.takeItemByTable(actor, cost, "一叶一菩提")
    else
        if myLevel >= liveMax then
            messagebox(actor,"你的等级已经达到上限,继续使用将不会获得经验,是否继续?","@deng_ji_shang_xian_ti_shi","@deng_ji_shang_xian_ti_shi_qu_xiao")
        else
            setplaydef(actor, VarCfg["U_剧情_一叶一菩提_次数"], count + 1)
            Player.sendmsgEx(actor, "提交成功,属性大幅增加,经验增加30%!")
            changeexp(actor, "+", currMaxExpPer, false)
            Player.setAttList(actor, "属性附加")
            Player.takeItemByTable(actor, cost, "一叶一菩提")
            YiYeYiPuTi.SyncResponse(actor)
        end
        
    end
end

--同步消息
function YiYeYiPuTi.SyncResponse(actor, logindatas)
    local data = {}
    local count = getplaydef(actor, VarCfg["U_剧情_一叶一菩提_次数"])
    local _login_data = { ssrNetMsgCfg.YiYeYiPuTi_SyncResponse, count, 0, 0, data }
    if logindatas then
        table.insert(logindatas, _login_data)
    else
        Message.sendmsg(actor, ssrNetMsgCfg.YiYeYiPuTi_SyncResponse, count, 0, 0, data)
    end
end

--登录触发
local function _onLoginEnd(actor, logindatas)
    YiYeYiPuTi.SyncResponse(actor, logindatas)
end
--事件派发
GameEvent.add(EventCfg.onLoginEnd, _onLoginEnd, YiYeYiPuTi)

local function _onTakeOnEx(actor, itemobj, where, itemname, makeid)
    if itemname == "麒麟臂" then
        Player.setAttList(actor, "攻速附加")
    elseif itemname == "麒麟心" then
        Player.setAttList(actor, "技能威力")
        Player.setAttList(actor, "回血计算")
    end
end
GameEvent.add(EventCfg.onTakeOnEx, _onTakeOnEx, YiYeYiPuTi)

local function _onTakeOffEx(actor, itemobj, where, itemname, makeid)
    if itemname == "麒麟臂" then
        Player.setAttList(actor, "攻速附加")
    elseif itemname == "麒麟心" then
        Player.setAttList(actor, "技能威力")
        Player.setAttList(actor, "回血计算")
    end
end
GameEvent.add(EventCfg.onTakeOffEx, _onTakeOffEx, YiYeYiPuTi)

local function _onCalcAttackSpeed(actor, attackSpeeds)
    if checkitemw(actor, "麒麟臂", 1) then
        attackSpeeds[1] = attackSpeeds[1] + 4
    end
end
GameEvent.add(EventCfg.onCalcAttackSpeed, _onCalcAttackSpeed, YiYeYiPuTi)
--技能威力
local function _onAddSkillPower(actor, attrs)
    if checkitemw(actor, "麒麟心", 1) then
        local shuxing = {}
        shuxing["烈火剑法"] = -10
        shuxing["开天斩"] = -10
        shuxing["逐日剑法"] = -10
        calcAtts(attrs, shuxing, "麒麟心技能威力计算")
    end
end
GameEvent.add(EventCfg.onAddSkillPower, _onAddSkillPower, YiYeYiPuTi)

--计算属性
local function _onCalcAttr(actor, attrs)
    local count = getplaydef(actor, VarCfg["U_剧情_一叶一菩提_次数"])
    if count > 10 then
        count = 10 
    end
    if count > 0 then
        local shuxing = {}
        for _, value in ipairs(config) do
            for _, v in ipairs(value.attrs) do
                shuxing[v] = count * value.addNum
            end
        end
        calcAtts(attrs, shuxing, "一叶一菩提属性计算")
    end
end
GameEvent.add(EventCfg.onCalcAttr, _onCalcAttr, YiYeYiPuTi)
--注册网络消息
Message.RegisterNetMsg(ssrNetMsgCfg.YiYeYiPuTi, YiYeYiPuTi)
return YiYeYiPuTi

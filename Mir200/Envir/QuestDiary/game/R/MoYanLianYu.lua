local MoYanLianYu = {}
MoYanLianYu.ID = "魔焰炼狱"
local npcID = 456
local config = include("QuestDiary/cfgcsv/cfg_MoYanLianYu.lua") --配置

--接收请求
function MoYanLianYu.Request1(actor, index)
    if not FCheckNPCRange(actor, npcID, 15) then
        Player.sendmsgEx(actor, "距离PNC太远!#249")
        return
    end
    local cfg = config[index]
    if not cfg then
        Player.sendmsgEx(actor, "参数错误!#249")
        return
    end
    if getflagstatus(actor, cfg.flag) == 1 then
        Player.sendmsgEx(actor, "你已提交过了!#249")
        return
    end
    local cost = cfg.cost
    local name, num = Player.checkItemNumByTable(actor, cost)
    if name then
        Player.sendmsgEx(actor, string.format("你的|%s#249|不足|%d#249", name, num))
        return
    end
    Player.takeItemByTable(actor, cost, "魔焰炼狱")
    setflagstatus(actor, cfg.flag, 1)
    if cfg.flag == 117 then
        local taskPanelID = getplaydef(actor, VarCfg["U_主线任务面板进度"])
        if taskPanelID == 39 then
            FCheckTaskRedPoint(actor)
        end
    end
    Player.setAttList(actor, "技能威力")
    MoYanLianYu.SyncResponse(actor)
    Player.sendmsgEx(actor, string.format("%s#249|提交成功,你的|烈火剑法#249|威力|+2%%#249", cost[1][1]))
end

function MoYanLianYu.Request2(actor)
    if checktitle(actor, "魔焰掌控者") then
        Player.sendmsgEx(actor, "你已经拥有了改称号!#249")
        return
    end
    local result = true
    for index, value in ipairs(config) do
        if getflagstatus(actor, value.flag) == 0 then
            result = false
            break
        end
    end
    if result then
        confertitle(actor, "魔焰掌控者")
        Player.sendmsgEx(actor, "恭喜你获得称号:|魔焰掌控者#249")
    else
        Player.sendmsgEx(actor, "你没有提交全部!#249")
    end
end

--同步消息
function MoYanLianYu.SyncResponse(actor, logindatas)
    local data = {}
    for index, value in ipairs(config) do
        data[index] = getflagstatus(actor, value.flag)
    end
    local _login_data = { ssrNetMsgCfg.MoYanLianYu_SyncResponse, 0, 0, 0, data }
    if logindatas then
        table.insert(logindatas, _login_data)
    else
        Message.sendmsg(actor, ssrNetMsgCfg.MoYanLianYu_SyncResponse, 0, 0, 0, data)
    end
end

--登录触发
local function _onLoginEnd(actor, logindatas)
    MoYanLianYu.SyncResponse(actor, logindatas)
end
--事件派发
GameEvent.add(EventCfg.onLoginEnd, _onLoginEnd, MoYanLianYu)


--计算属性触发
local function _onAddSkillPower(actor, attrs)
    --计算属性累加
    local shuxing = {}
    local sum = 0
    for _, value in ipairs(config) do
        if getflagstatus(actor, value.flag) == 1 then
            sum = sum + value.addNum
        end
    end
    if sum > 0 then
        shuxing["烈火剑法"] = sum
        calcAtts(attrs, shuxing, "魔焰炼狱技能威力计算")
    end
end
GameEvent.add(EventCfg.onAddSkillPower, _onAddSkillPower, MoYanLianYu)
--被玩家攻击触发
local function _onStruckDamagePlayer(actor, Target, Hiter, MagicId, Damage, attackDamageData)
    if checktitle(actor, "魔焰掌控者") then
        if MagicId == 26 then
            attackDamageData.damage = attackDamageData.damage + math.ceil(Damage * 0.06)
        end
    end
end
GameEvent.add(EventCfg.onStruckDamagePlayer, _onStruckDamagePlayer, MoYanLianYu)
local function _onAttackPlayer(actor, Target, Hiter, MagicId)
    if MagicId == 26 then
        if randomex(5) then
            if checktitle(actor, "魔焰掌控者") then
                changemode(actor,18,1,1,1)
                Player.buffTipsMsg(actor, "[魔焰掌控者]:你麻痹了目标1秒...")
                Player.buffTipsMsg(Target, "[魔焰掌控者]:你被麻痹了一秒...")
            end
        end
    end
end
GameEvent.add(EventCfg.onAttackPlayer, _onAttackPlayer, MoYanLianYu)
--注册网络消息
Message.RegisterNetMsg(ssrNetMsgCfg.MoYanLianYu, MoYanLianYu)
return MoYanLianYu

local JiNengQiangHua = {}
local config = include("QuestDiary/cfgcsv/cfg_JiNengQiangHua.lua")
local maxLeve = 9

local function setSkillEff(actor)
    for key, value in pairs(config) do
        local levelUp = getskillinfo(actor, key, 2)
        if levelUp then
            if levelUp > 9 then
                setmagicskillefft(actor, value.skillName, value.effid)
            end
        end
    end
end

function JiNengQiangHua.Request(actor, skillId)
    local cfg = config[skillId]
    if not cfg then
        Player.sendmsgEx(actor, "[提示]:#251|错误信息1,没找到对应技能#249")
        return
    end
    local levelUp = getskillinfo(actor, skillId, 2)
    if not levelUp then
        Player.sendmsgEx(actor, "[提示]:#251|你没有学习这个技能!#249")
        return
    end
    if levelUp >= 10 then
        Player.sendmsgEx(actor, string.format("[提示]:#251|你的#250|%s#249|已经满级了!#250", cfg.skillName))
        return
    end
    local name, num = Player.checkItemNumByTable(actor, cfg.cost)
    if name then
        Player.sendmsgEx(actor, string.format("[提示]:#251|你的#250|%s#249|不足#251|%s#249|强化失败!#250", name, num))
        return
    end
    Player.takeItemByTable(actor, cfg.cost, "技能强化")
    local num = getplaydef(actor, VarCfg["U_技能强化总次数"])
    setplaydef(actor, VarCfg["U_技能强化总次数"], num + 1)
    if num + 1 == 3 then
        local taskPanelID = getplaydef(actor, VarCfg["U_主线任务面板进度"])
        if taskPanelID == 11 then
            FCheckTaskRedPoint(actor)
        end
    end
    setskillinfo(actor, skillId, 2, levelUp + 1)
    setplaydef(actor, cfg.var, levelUp + 1)
    Player.sendmsgEx(actor, string.format("[提示]:#251|你的#250|%s#249|强化成功!#250", cfg.skillName))
    setSkillEff(actor)
    GameEvent.push(EventCfg.onIntensifySkill, actor, cfg.skillName, levelUp + 1)
end

--------------事件派发-------------
--登录触发
local function _onLoginEnd(actor, logindatas)
    setSkillEff(actor)
end
--攻击前触发
local function _onAttackDamage(actor, Target, Hiter, MagicId, Damage, Model, attackDamageData)
    if MagicId == 12 then
        local levelUp = getskillinfo(actor, MagicId, 2)
        --刺杀剑术有5%的几率时目标受到的伤害翻倍
        if levelUp > 9 then
            if randomex(5) then
                attackDamageData.damage = attackDamageData.damage + Damage
            end
        end
    end
end

--攻击触发
local function _onAttack(actor, Target, Hiter, MagicId)
    if MagicId == 7 then
        local levelUp = getskillinfo(actor, MagicId, 2)
        --攻杀剑术额外附加自身攻击上限35%的真实伤害
        if levelUp > 9 then
            local attackLimit = getbaseinfo(actor, ConstCfg.gbase.custom_attr, 4)
            local damege = calculatePercentageResult(attackLimit, 35)
            humanhp(Target, "-", damege, 1, 0, actor)
        end
    elseif MagicId == 26 then
        local levelUp = getskillinfo(actor, MagicId, 2)
        --烈火剑法点燃被击中的目标3秒，没秒减少等同于释放者攻击上限20%的生命
        if levelUp > 9 then
            local attackLimit = getbaseinfo(actor, ConstCfg.gbase.custom_attr, 4)
            local damege = calculatePercentageResult(attackLimit, 20)
            humanhp(Target, "-", damege, 1, 1, actor)
            humanhp(Target, "-", damege, 1, 2, actor)
            humanhp(Target, "-", damege, 1, 3, actor)
        end
    elseif MagicId == 66 then
        if getbaseinfo(Target, -1) == true then
            local levelUp = getskillinfo(actor, MagicId, 2)
        --开天斩命中目标后，使目标5秒内降低20%的防御
            if levelUp > 9 then
                local fangYu1       = getbaseinfo(actor, ConstCfg.gbase.custom_attr, 9)
                local fangYu2       = getbaseinfo(actor, ConstCfg.gbase.custom_attr, 10)
                local changeFangYu1 = calculatePercentageResult(fangYu1, 20)
                local changeFangYu2 = calculatePercentageResult(fangYu2, 20)
                changehumability(Target, 1, -changeFangYu1, 5)
                changehumability(Target, 2, -changeFangYu2, 5)
            end
        end
    elseif MagicId == 56 then
        local levelUp = getskillinfo(actor, MagicId, 2)
        --逐日剑法击中的目标为玩家时，有35%的几率使其额外减少当前HP10%的生命
        if levelUp > 9 then
            if randomex(35) then
                local currentHP = getbaseinfo(Target, ConstCfg.gbase.curhp)
                local damage = calculatePercentageResult(currentHP, 10)
                humanhp(Target, "-", damage, 1, 0 , actor)
            end
        end
    end
end

--登录
GameEvent.add(EventCfg.onLoginEnd, _onLoginEnd, JiNengQiangHua)
--跨服登陆
GameEvent.add(EventCfg.onKFLogin, _onLoginEnd, JiNengQiangHua)

--被攻击触发
GameEvent.add(EventCfg.onAttackDamage, _onAttackDamage, JiNengQiangHua)

--攻击触发
GameEvent.add(EventCfg.onAttack, _onAttack, JiNengQiangHua)

--------------网络消息-------------
function JiNengQiangHua.SyncResponse(actor)
    Message.sendmsg(actor, ssrNetMsgCfg.JiNengQiangHua_SyncResponse)
end

--注册网络消息
Message.RegisterNetMsg(ssrNetMsgCfg.JiNengQiangHua, JiNengQiangHua)

return JiNengQiangHua

local KuaFutoBenFuBuffList = {}

--最后在皇宫给称号
KuaFutoBenFuBuffList[1] = function(actor)
    if not checktitle(actor, "宫殿守卫") then
        if randomex(50, 100) then
            confertitle(actor, "宫殿守卫")
            GameEvent.push(EventCfg.onAddAchievementTitle, actor, "宫殿守卫")
        end
    end
end

--怒斩三连 在狂暴状态下连续击杀三个目标（10s）
KuaFutoBenFuBuffList[2] = function(actor, KillNum)
    KillNum = tonumber(KillNum)
    if not checktitle(actor, "怒斩三连") then
        if getflagstatus(actor, VarCfg.F_is_open_kuangbao) == 1 then
            if KillNum >= 3 then
                confertitle(actor, "怒斩三连")
                GameEvent.push(EventCfg.onAddAchievementTitle, actor, "怒斩三连")
            end
        end
    end
end

--怒斩三连 在狂暴状态下连续击杀三个目标（10s）
local InTheCastleKillPlayerTitlb = { { var = 5, title = "五连斩" }, { var = 10, title = "沙城人屠" } }
KuaFutoBenFuBuffList[3] = function(actor, KillNum)
    KillNum = tonumber(KillNum)
    if not checktitle(actor, "沙城人屠") then
        local NewTitle, OldTitle = Player.getNewandOldTitle(actor, KillNum, InTheCastleKillPlayerTitlb)
        if NewTitle == "" then return end
        if not checktitle(actor, NewTitle) then
            if checktitle(actor, OldTitle) then
                deprivetitle(actor, OldTitle)
            end
            confertitle(actor, NewTitle) --添加新的称号
            GameEvent.push(EventCfg.onAddAchievementTitle, actor, NewTitle)
        end
    end
end

--攻沙中第一个击杀敌方玩家
KuaFutoBenFuBuffList[4] = function(actor)
    if not checktitle(actor, "第一滴血") then
        confertitle(actor, "第一滴血")
        GameEvent.push(EventCfg.onAddAchievementTitle, actor, "第一滴血")
        local name = getbaseinfo(actor, ConstCfg.gbase.name)
        local userID = getbaseinfo(actor, 2)
        bfbackcall(31, userID, name, "") --玩家对象发送
    end
end

--大罗洞观到本服执行的
KuaFutoBenFuBuffList[5] = function(actor)
    addbuff(actor, 30095)
    local oldMapId = Player.GetVarMap(actor)
    local myName = Player.GetName(actor)
    local newMapId = myName .. "y"
    local x = getbaseinfo(actor, ConstCfg.gbase.x)
    local y = getbaseinfo(actor, ConstCfg.gbase.y)
    addmirrormap("kfdb001", newMapId, "异次元空间" .. "(" .. myName .. ")", 3, oldMapId, 0, x, y)
    Player.buffTipsMsg(actor, "[大罗洞观]:进入异次元空间，3秒后满血回到原位置。")
    map(actor, newMapId)
end

KuaFutoBenFuBuffList[6] = function(actor, arg1)
    local itemName = arg1
    local mailTitle = StringCfg.get(1)
    local mailContent = StringCfg.get(2, itemName)
    local userId = Player.GetUUID(actor)
    sendmail(userId, 1, mailTitle, mailContent)
end

KuaFutoBenFuBuffList[7] = function(actor, arg1)
    local strs = string.split(arg1, "|")
    local fei_sheng_level = strs[1] or ""
    local itemName = strs[2] or ""
    local mailTitle = StringCfg.get(3)
    local mailContent = StringCfg.get(4, fei_sheng_level, itemName)
    local userId = Player.GetUUID(actor)
    sendmail(userId, 1, mailTitle, mailContent)
end

--血脉压制
KuaFutoBenFuBuffList[5001] = function(Target)
    if Player.GetAttr(Target,208) > 15 then
        changehumnewvalue(Target, 208, -15, 10)
    else
        local targetHp = Player.getHpValue(Target, 15)
        changehumnewvalue(Target, 1, -targetHp, 10)
    end
end

return KuaFutoBenFuBuffList

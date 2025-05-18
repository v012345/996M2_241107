local KuaFutoBenFuBuffList = {}

--����ڻʹ����ƺ�
KuaFutoBenFuBuffList[1] = function(actor)
    if not checktitle(actor, "��������") then
        if randomex(50, 100) then
            confertitle(actor, "��������")
            GameEvent.push(EventCfg.onAddAchievementTitle, actor, "��������")
        end
    end
end

--ŭն���� �ڿ�״̬��������ɱ����Ŀ�꣨10s��
KuaFutoBenFuBuffList[2] = function(actor, KillNum)
    KillNum = tonumber(KillNum)
    if not checktitle(actor, "ŭն����") then
        if getflagstatus(actor, VarCfg.F_is_open_kuangbao) == 1 then
            if KillNum >= 3 then
                confertitle(actor, "ŭն����")
                GameEvent.push(EventCfg.onAddAchievementTitle, actor, "ŭն����")
            end
        end
    end
end

--ŭն���� �ڿ�״̬��������ɱ����Ŀ�꣨10s��
local InTheCastleKillPlayerTitlb = { { var = 5, title = "����ն" }, { var = 10, title = "ɳ������" } }
KuaFutoBenFuBuffList[3] = function(actor, KillNum)
    KillNum = tonumber(KillNum)
    if not checktitle(actor, "ɳ������") then
        local NewTitle, OldTitle = Player.getNewandOldTitle(actor, KillNum, InTheCastleKillPlayerTitlb)
        if NewTitle == "" then return end
        if not checktitle(actor, NewTitle) then
            if checktitle(actor, OldTitle) then
                deprivetitle(actor, OldTitle)
            end
            confertitle(actor, NewTitle) --����µĳƺ�
            GameEvent.push(EventCfg.onAddAchievementTitle, actor, NewTitle)
        end
    end
end

--��ɳ�е�һ����ɱ�з����
KuaFutoBenFuBuffList[4] = function(actor)
    if not checktitle(actor, "��һ��Ѫ") then
        confertitle(actor, "��һ��Ѫ")
        GameEvent.push(EventCfg.onAddAchievementTitle, actor, "��һ��Ѫ")
        local name = getbaseinfo(actor, ConstCfg.gbase.name)
        local userID = getbaseinfo(actor, 2)
        bfbackcall(31, userID, name, "") --��Ҷ�����
    end
end

--���޶��۵�����ִ�е�
KuaFutoBenFuBuffList[5] = function(actor)
    addbuff(actor, 30095)
    local oldMapId = Player.GetVarMap(actor)
    local myName = Player.GetName(actor)
    local newMapId = myName .. "y"
    local x = getbaseinfo(actor, ConstCfg.gbase.x)
    local y = getbaseinfo(actor, ConstCfg.gbase.y)
    addmirrormap("kfdb001", newMapId, "���Ԫ�ռ�" .. "(" .. myName .. ")", 3, oldMapId, 0, x, y)
    Player.buffTipsMsg(actor, "[���޶���]:�������Ԫ�ռ䣬3�����Ѫ�ص�ԭλ�á�")
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

--Ѫ��ѹ��
KuaFutoBenFuBuffList[5001] = function(Target)
    if Player.GetAttr(Target,208) > 15 then
        changehumnewvalue(Target, 208, -15, 10)
    else
        local targetHp = Player.getHpValue(Target, 15)
        changehumnewvalue(Target, 1, -targetHp, 10)
    end
end

return KuaFutoBenFuBuffList

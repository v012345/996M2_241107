local EnterDaLu = {}
local config = include("QuestDiary/cfgcsv/cfg_EnterDaLu.lua") -- ������Ϣ
local function checkHaFaXiSiTitle(actor)
    return checktitle(actor, "������˹��ս��Lv3") or checktitle(actor, "������˹��ս��Lv4") or checktitle(actor, "������˹��ս��Lv5")
end
--�ж��´�½������
local function CheckEnter(actor, npcid)
    if npcid == 114 or npcid == 204 then
        local myLevel = getbaseinfo(actor, ConstCfg.gbase.level)
        if myLevel < 100 then
            Player.sendmsgEx(actor, "[ϵͳ��ʾ]#251|��ĵȼ�����|100��#249")
            return false
        end
    elseif npcid == 317 then
        local reLevel = getbaseinfo(actor,ConstCfg.gbase.renew_level)
        if reLevel < 1 then
            Player.sendmsgEx(actor, "[ϵͳ��ʾ]#251|��Ҫ����һת#249")
            return false
        end
    elseif npcid == 318 then
        local reLevel = getbaseinfo(actor,ConstCfg.gbase.renew_level)
        if reLevel < 3 then
            Player.sendmsgEx(actor, "[ϵͳ��ʾ]#251|��Ҫ������ת#249")
            return false
        end
    elseif npcid == 445 then
        local reLevel = getbaseinfo(actor,ConstCfg.gbase.renew_level)
        local shiLianLevel = getplaydef(actor,VarCfg["U_�ز���������"])
        if reLevel < 4 then
            Player.sendmsgEx(actor, "[ϵͳ��ʾ]#251|��Ҫ������ת#249")
            return false
        elseif shiLianLevel < 2 then
            Player.sendmsgEx(actor, "[ϵͳ��ʾ]#251|��Ҫ���[�ز����Ķ�������]#249")
            return false
        elseif not checktitle(actor,"ڤ��������") then
            Player.sendmsgEx(actor, "[ϵͳ��ʾ]#251|��Ҫ�ƺ�[ڤ��������]#249")
            return false
        end
    --����½̫��ʥ��
    elseif npcid == 500 then
        local reLevel = getbaseinfo(actor,ConstCfg.gbase.renew_level)
        if reLevel < 5 then
            Player.sendmsgEx(actor, "[ϵͳ��ʾ]#251|��Ҫ������ת#249")
            return false
        end
        local myLevel = getbaseinfo(actor, ConstCfg.gbase.level)
        if myLevel < 335 then
            Player.sendmsgEx(actor, "[ϵͳ��ʾ]#251|��ĵȼ�����|335��#249")
            return false
        end
    elseif npcid == 600 then
        local reLevel = getbaseinfo(actor,ConstCfg.gbase.renew_level)
        if reLevel < 6 then
            Player.sendmsgEx(actor, "[ϵͳ��ʾ]#251|��Ҫ������ת#249")
            return false
        end
        local myLevel = getbaseinfo(actor, ConstCfg.gbase.level)
        if myLevel < 345 then
            Player.sendmsgEx(actor, "[ϵͳ��ʾ]#251|��ĵȼ�����|345��#249")
            return false
        end
        if not checkHaFaXiSiTitle(actor) then
            Player.sendmsgEx(actor, "[ϵͳ��ʾ]#251|��Ҫ�ƺ�[������˹��ս��Lv3]#249")
            return false
        end
    elseif npcid == 800 then
        local reLevel = getbaseinfo(actor,ConstCfg.gbase.renew_level)
        if reLevel < 7 then
            Player.sendmsgEx(actor, "[ϵͳ��ʾ]#251|��Ҫ������ת#249")
            return false
        end
        local myLevel = getbaseinfo(actor, ConstCfg.gbase.level)
        if myLevel < 355 then
            Player.sendmsgEx(actor, "[ϵͳ��ʾ]#251|��ĵȼ�����|355��#249")
            return false
        end
    end
    return true
end
--��ʾ��������
local function ShowEnterCondition(actor, npcid)
    local result = {}
    local myLevel = getbaseinfo(actor, ConstCfg.gbase.level)
    local reLevel = getbaseinfo(actor,ConstCfg.gbase.renew_level)
    if npcid == 114 or npcid == 204 then
        local checkMark = ""
        local color = FGetColor({myLevel,100})
        local condition1 = { string.format("����ȼ�100��     <font color='%s'>(%d/100��)</font>%s",color, myLevel, checkMark)}
        table.insert(result, condition1)
    elseif npcid == 317 then
        local checkMark = ""
        local color = FGetColor({reLevel,1})
        local condition1 = { string.format("����һת     <font color='%s'>(%d/1ת)</font>%s",color, reLevel, checkMark)}
        table.insert(result, condition1)
    --�Ĵ�½ۺ�����
    elseif npcid == 318 then
        local checkMark = ""
        local color = FGetColor({reLevel,3})
        local condition1 = { string.format("������ת     <font color='%s'>(%d/3ת)</font>%s",color, reLevel, checkMark)}
        table.insert(result, condition1)
    --���½�����½    
    elseif npcid == 445 then
        local shiLianLevel = getplaydef(actor,VarCfg["U_�ز���������"])
        local checkMark = ""
        local color = FGetColor({reLevel,4})
        local condition1 = { string.format("������ת     <font color='%s'>(%d/4ת)</font>%s",color, reLevel, checkMark)}
        -- local isFinish = 
        color = FGetColor(shiLianLevel >= 2)
        local str = shiLianLevel >= 2 and "(�����)" or "(δ���)"
        local condition2 = { string.format("��ɵز����Ķ�������   <font color='%s'>%s</font>%s",color, str, checkMark)}

        color = FGetColor(checktitle(actor, "ڤ��������"))
        str = checktitle(actor, "ڤ��������") and "(�ѻ��)" or "(δ���)"
        local condition3 = { string.format("�ƺ�[ڤ��������]     <font color='%s'>%s</font>%s",color, str, checkMark)}
        table.insert(result, condition3)
        table.insert(result, condition2)
        table.insert(result, condition1)
    elseif npcid == 500 then
        local checkMark = ""
        local color = FGetColor({reLevel,5})
        local condition1 = { string.format("������ת     <font color='%s'>(%d/5ת)</font>%s",color, reLevel, checkMark)}
        color = FGetColor({myLevel,335})
        local condition2 = { string.format("����ȼ�335��     <font color='%s'>(%d/335��)</font>%s",color, myLevel, checkMark)}
        table.insert(result, condition2)
        table.insert(result, condition1)
    elseif npcid == 600 then
        local checkMark = ""
        local color = FGetColor({reLevel,6})
        local condition1 = { string.format("������ת     <font color='%s'>(%d/6ת)</font>%s",color, reLevel, checkMark)}
        color = FGetColor({myLevel,345})
        local condition2 = { string.format("����ȼ�345��     <font color='%s'>(%d/345��)</font>%s",color, myLevel, checkMark)}
        color = FGetColor(checkHaFaXiSiTitle(actor))
        local str = checkHaFaXiSiTitle(actor) and "(�ѻ��)" or "(δ���)"
        local condition3 = { string.format("�ƺ�[������˹��ս��Lv3]     <font color='%s'>%s</font>%s",color, str, checkMark)}
        table.insert(result, condition3)
        table.insert(result, condition2)
        table.insert(result, condition1)
    elseif npcid == 800 then
        local checkMark = ""
        local color = FGetColor({reLevel,7})
        local condition1 = { string.format("������ת     <font color='%s'>(%d/7ת)</font>%s",color, reLevel, checkMark)}
        color = FGetColor({myLevel,355})
        local condition2 = { string.format("����ȼ�355��     <font color='%s'>(%d/355��)</font>%s",color, myLevel, checkMark)}
        table.insert(result, condition2)
        table.insert(result, condition1)
    end
    return result
end

--ͬ��������Ϣ
function EnterDaLu.OpenUI(actor, npcid)
    local cfg = config[npcid]
    if not cfg then
        Player.sendmsgEx(actor, "��������!")
        return
    end
    local isOk = FCheckNPCRange(actor, npcid, 15)
    if not isOk then
        Player.sendmsgEx(actor, "NPC����̫Զ")
        return
    end
    local data = ShowEnterCondition(actor, npcid)

    Message.sendmsg(actor, ssrNetMsgCfg.EnterDaLu_OpenUI, 0, 0, 0, data)
end

--�����½
function EnterDaLu.Request(actor, npcid)
    local cfg = config[npcid]
    if not cfg then
        Player.sendmsgEx(actor, "��������!")
        return
    end
    local isOk = FCheckNPCRange(actor, npcid, 15)
    if not isOk then
        Player.sendmsgEx(actor, "NPC����̫Զ")
        return
    end
    if npcid == 900 then
        Player.sendmsgEx(actor, "��δ���Ŵ˴�½!#249")
        return
    end
    local isMeetThenCondition = CheckEnter(actor, npcid)
    if not isMeetThenCondition then
        return
    else
    -- release_print(cfg.mapId, cfg.x, cfg.y)
    local num = getplaydef(actor, VarCfg["U_��¼��½"])
    if num < cfg.number then
        setplaydef(actor, VarCfg["U_��¼��½"], cfg.number)
    end
    mapmove(actor, cfg.mapId, cfg.x, cfg.y, 1)
    end
end

local function _onLoginEnd(actor)
    local currDaLu = getplaydef(actor, VarCfg["U_��¼��½"])
    if currDaLu == 0 then
        setplaydef(actor, VarCfg["U_��¼��½"], 1)
    end
end
--�¼��ɷ�
GameEvent.add(EventCfg.onLoginEnd, _onLoginEnd, EnterDaLu)
--ע����Ϣ
Message.RegisterNetMsg(ssrNetMsgCfg.EnterDaLu, EnterDaLu)

return EnterDaLu

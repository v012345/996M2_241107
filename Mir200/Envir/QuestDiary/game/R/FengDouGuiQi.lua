local FengDouGuiQi = {}
FengDouGuiQi.ID = "ۺ������"
local npcID = 449
local config = include("QuestDiary/cfgcsv/cfg_FengDouGuiQi.lua") --����
local cost = { { "������", 1 }, { "��ħ��", 1 } }
local give = { { "�����", 1 } }
local abilGroup = 0
--��������
function FengDouGuiQi.Request(actor)
    local name, num = Player.checkItemNumByTable(actor, cost)
    if name then
        Player.sendmsgEx(actor, string.format("���|%s#249|����|%d#249", name, num))
        return
    end
    Player.takeItemByTable(actor, cost, "ۺ������")
    Player.giveItemByTable(actor, give, "ۺ������", 1, true)
    setflagstatus(actor, VarCfg["F_�����_���"], 1)
    Player.sendmsgEx(actor, "��ϲ��ɹ��ϳ�|�����#249")
end

--ͬ����Ϣ
-- function FengDouGuiQi.SyncResponse(actor, logindatas)
--     local data = {}
--     local _login_data = {ssrNetMsgCfg.FengDouGuiQi_SyncResponse, 0, 0, 0, data}
--     if logindatas then
--         table.insert(logindatas, _login_data)
--     else
--         Message.sendmsg(actor, ssrNetMsgCfg.FengDouGuiQi_SyncResponse, 0, 0, 0, data)
--     end
-- end
-- --��¼����
-- local function _onLoginEnd(actor, logindatas)
--     FengDouGuiQi.SyncResponse(actor, logindatas)
-- end
-- --�¼��ɷ�
-- GameEvent.add(EventCfg.onLoginEnd, _onLoginEnd, FengDouGuiQi)
--ɱ�ִ���
local function _onKillMon(actor, monobj, monName)
    if checkitemw(actor, "�����", 1) then
        local cfg = config[monName]
        if cfg then
            local itemobj = FFindEquipObj(actor, "�����")
            if not itemobj then
                return
            end
            changecustomitemtext(actor, itemobj, "<IMG:res/tips/5.png>", abilGroup)
            local atts = Player.getAllModifyCustomAttributes(actor, itemobj, abilGroup + 1)
            if cfg.type == 1 then
                local attrId = cfg.attr1[1]
                local currIndex = cfg.attr1[2]
                local currValue = atts[currIndex] or 0
                if currValue >= cfg.max then
                    return
                end
                local isPer = cfg.attr1[3]
                local attrValue = cfg.addNum + currValue
                Player.addModifyCustomAttributes(actor, itemobj, abilGroup, currIndex, 1, 250, attrId, 0, isPer,
                    attrValue)
                local attrId2 = cfg.attr2[1]
                local currIndex2 = cfg.attr2[2]
                local isPer2 = cfg.attr2[3]
                local attrValue2 = math.floor((currValue / cfg.ratio)) * cfg.ratioNum
                if attrValue2 > 0 then
                    Player.addModifyCustomAttributes(actor, itemobj, abilGroup, currIndex2, 1, 250, attrId2, 0, isPer2,
                        attrValue2)
                end
            else
                if randomex(cfg.random) then
                    local attrId = cfg.attr1[1]
                    local currIndex = cfg.attr1[2]
                    local currValue = atts[currIndex] or 0
                    if currValue >= cfg.max then
                        return
                    end
                    local isPer = cfg.attr1[3]
                    local attrValue = cfg.addNum + currValue
                    Player.addModifyCustomAttributes(actor, itemobj, abilGroup, currIndex, 0, 250, cfg.attrOther, attrId,
                        isPer, attrValue)
                    -- release_print("��ǰ����", attrValue)
                    setplaydef(actor, VarCfg["U_����_�����_����"], attrValue)
                    Player.setAttList(actor, "���ٸ���")
                end
            end
        end
    end
end
GameEvent.add(EventCfg.onKillMon, _onKillMon, FengDouGuiQi)

--��װ��
local function _onTakeOnEx(actor, itemobj, where, itemname, makeid)
    if itemname == "�����" then
        Player.setAttList(actor, "���ٸ���")
    end
end
GameEvent.add(EventCfg.onTakeOnEx, _onTakeOnEx, FengDouGuiQi)
--��װ��
local function _onTakeOffEx(actor, itemobj, where, itemname, makeid)
    if itemname == "�����" then
        Player.setAttList(actor, "���ٸ���")
    end
end
GameEvent.add(EventCfg.onTakeOffEx, _onTakeOffEx, FengDouGuiQi)

local function _onCalcAttackSpeed(actor, attackSpeeds)
    if checkitemw(actor, "�����", 1) then
        local count = getplaydef(actor, VarCfg["U_����_�����_����"])
        local gongSu = count
        attackSpeeds[1] = attackSpeeds[1] + gongSu
    end
end
--��������
GameEvent.add(EventCfg.onCalcAttackSpeed, _onCalcAttackSpeed, FengDouGuiQi)

--ע��������Ϣ
Message.RegisterNetMsg(ssrNetMsgCfg.FengDouGuiQi, FengDouGuiQi)
return FengDouGuiQi

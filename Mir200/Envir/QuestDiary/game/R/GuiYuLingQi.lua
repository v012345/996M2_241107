local GuiYuLingQi = {}
GuiYuLingQi.ID = "��������"
local npcID = 450
local config = include("QuestDiary/cfgcsv/cfg_GuiYuLingQi.lua") --����
local abilGroup = 1
--��������
function GuiYuLingQi.Request(actor, index)
    local cfg = config[index]
    if not cfg then
        Player.sendmsgEx(actor, "��������")
        return
    end
    local itemobj = linkbodyitem(actor, 43)
    if itemobj == "0" then
        Player.sendmsgEx(actor, "�ύʧ��,��û�д������ɷ���!")
        return
    end
    local cost = cfg.cost
    if getflagstatus(actor, cfg.flag) == 1 then
        Player.sendmsgEx(actor, "���Ѿ��ύ����!#249")
        return
    end
    local name, num = Player.checkItemNumByTable(actor, cost)
    if name then
        Player.sendmsgEx(actor, string.format("���|%s#249|����|%d#249", name, num))
        return
    end
    Player.takeItemByTable(actor, cost, "������������")
    setflagstatus(actor, cfg.flag, 1)
    if cfg.flag == 109 or cfg.flag == 111 then
        local taskPanelID = getplaydef(actor, VarCfg["U_��������������"])
        if taskPanelID == 33 then
            FCheckTaskRedPoint(actor)
        end
    end

    --�������
    changecustomitemtext(actor, itemobj, "<IMG:res/tips/5.png>", abilGroup)
    Player.addModifyCustomAttributes(actor, itemobj, abilGroup, index, 1, 250, cfg.attr[1], 0, cfg.attrIsPer, cfg.attr[2])

    Player.sendmsgEx(actor, "�ύ�ɹ�!")
    GuiYuLingQi.SyncResponse(actor)
end

--��װ��
local function _onTakeOn43(actor, itemobj)
    for index, cfg in ipairs(config) do
        if getflagstatus(actor,cfg.flag) == 1 then
            changecustomitemtext(actor, itemobj, "<IMG:res/tips/5.png>", abilGroup)
            Player.addModifyCustomAttributes(actor, itemobj, abilGroup, index, 1, 250, cfg.attr[1], 0, cfg.attrIsPer, cfg.attr[2])
        end
    end
end
GameEvent.add(EventCfg.onTakeOn43, _onTakeOn43, GuiYuLingQi)

--ͬ����Ϣ
function GuiYuLingQi.SyncResponse(actor, logindatas)
    local data = {}
    for index, value in ipairs(config) do
        data[index] = getflagstatus(actor, value.flag)
    end
    local _login_data = { ssrNetMsgCfg.GuiYuLingQi_SyncResponse, 0, 0, 0, data }
    if logindatas then
        table.insert(logindatas, _login_data)
    else
        Message.sendmsg(actor, ssrNetMsgCfg.GuiYuLingQi_SyncResponse, 0, 0, 0, data)
    end
end

--��¼����
local function _onLoginEnd(actor, logindatas)
    GuiYuLingQi.SyncResponse(actor, logindatas)
end
--�¼��ɷ�
GameEvent.add(EventCfg.onLoginEnd, _onLoginEnd, GuiYuLingQi)
--ע��������Ϣ
Message.RegisterNetMsg(ssrNetMsgCfg.GuiYuLingQi, GuiYuLingQi)
return GuiYuLingQi

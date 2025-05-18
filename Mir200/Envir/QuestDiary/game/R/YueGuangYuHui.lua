local YueGuangYuHui = {}
YueGuangYuHui.ID = "�¹�����"
local npcID = 515
local config = include("QuestDiary/cfgcsv/cfg_YueGuangYuHui.lua") --����
--�Ƿ�ȫ���ύ
local function IsAllSubmit(actor)
    local result = true
    for index, value in ipairs(config) do
        local count = getplaydef(actor, value.var)
        if count < value.max then
            result = false
            break
        end
    end
    return result
end 
--��������
function YueGuangYuHui.Request(actor, index)
    if not FCheckNPCRange(actor, npcID, 15) then
        Player.sendmsgEx(actor, "����PNC̫Զ!#249")
        return
    end
    local cfg = config[index]
    if not cfg then
        Player.sendmsgEx(actor, "��������#249")
        return
    end

    local count = getplaydef(actor, cfg.var)
    if count >= cfg.max then
        Player.sendmsgEx(actor, string.format("���ֻ���ύ%d��!#249", cfg.max))
        if not checktitle(actor,"�¹�����") then
            confertitle(actor, "�¹�����")
            GameEvent.push(EventCfg.onGetTaskTitle, actor, "�¹�����") --���񴥷�
        end
        return
    end
    local cost = cfg.cost
    local name, num = Player.checkItemNumByTable(actor, cost)
    if name then
        Player.sendmsgEx(actor, string.format("���|%s#249|����|%d#249", name, num))
        return
    end
    Player.takeItemByTable(actor, cost, "�¹�����")
    setplaydef(actor, cfg.var, count + 1)
    Player.setAttList(actor, "���Ը���")
    Player.sendmsgEx(actor, "�ύ�ɹ�!")
    if not checktitle(actor,"�¹�����") then
        if IsAllSubmit(actor) then
            confertitle(actor, "�¹�����")
            messagebox(actor, "��ϲ����ȫ���ύ,��óƺ�:[�¹�����]")
        end
    end
    YueGuangYuHui.SyncResponse(actor)
end

--ͬ����Ϣ
function YueGuangYuHui.SyncResponse(actor, logindatas)
    local data = {}
    for index, value in ipairs(config) do
        data[index] = getplaydef(actor, value.var)
    end
    local _login_data = { ssrNetMsgCfg.YueGuangYuHui_SyncResponse, 0, 0, 0, data }
    if logindatas then
        table.insert(logindatas, _login_data)
    else
        Message.sendmsg(actor, ssrNetMsgCfg.YueGuangYuHui_SyncResponse, 0, 0, 0, data)
    end
end

--��¼����
local function _onLoginEnd(actor, logindatas)
    YueGuangYuHui.SyncResponse(actor, logindatas)
end
--�¼��ɷ�
GameEvent.add(EventCfg.onLoginEnd, _onLoginEnd, YueGuangYuHui)

local function _onCalcAttr(actor, attrs)
    local shuxing = {}
    for _, value in ipairs(config) do
        local count = getplaydef(actor, value.var)
        if count > 0 then
            shuxing[value.attr] = value.addNum * count
        end
    end
    calcAtts(attrs, shuxing, "�¹�����")
end
--����
GameEvent.add(EventCfg.onCalcAttr, _onCalcAttr, YueGuangYuHui)

--ע��������Ϣ
Message.RegisterNetMsg(ssrNetMsgCfg.YueGuangYuHui, YueGuangYuHui)
return YueGuangYuHui

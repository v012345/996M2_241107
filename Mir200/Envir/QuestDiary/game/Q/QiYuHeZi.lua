QiYuHeZi = {}
local LuckyEventCfg = include("QuestDiary/cfgcsv/cfg_LuckyEvent_BoxData.lua") --�����¼�����


function QiYuHeZi.SetEventUIState(actor, var)
    if  var == 1 then
        setplaydef(actor,VarCfg["S$������֤"], "����������״̬")
    else
        setplaydef(actor,VarCfg["S$������֤"], "")
    end
end


--ɾ�������¼�
function QiYuHeZi.DelAllEvent(actor)
    local notes4 = getplaydef(actor, VarCfg["Z_��������λ��4"])
    local notes5 = getplaydef(actor, VarCfg["Z_��������λ��5"])
    setplaydef(actor, VarCfg["Z_��������λ��1"],"")
    setplaydef(actor, VarCfg["Z_��������λ��2"],"")
    setplaydef(actor, VarCfg["Z_��������λ��3"],"")

    if  notes4 ~= "δ����" then
        setplaydef(actor, VarCfg["Z_��������λ��4"],"")
    elseif  notes5 ~= "δ����" then
        setplaydef(actor, VarCfg["Z_��������λ��5"],"")
    end
    QiYuHeZi.SyncResponse(actor)
end


function QiYuHeZi.Request(actor, _, _, var, data)
    local EventName = getplaydef(actor, VarCfg["Z_��������λ��".. var ..""])
    if EventName == "δ����" then
        Player.sendmsgEx(actor, "��ʾ#251|:#255|�Բ���|λ��" ..var.. "#249|δ����...")
        return
    end
    if EventName == "" then
        Player.sendmsgEx(actor, "��ʾ#251|:#255|�Բ���|λ��" ..var.. "#249|δ��¼...")
        return
    end
    if EventName ~= data[1] then
        Player.sendmsgEx(actor, "��ʾ#251|:#255|�Ƿ�����#249|")
        return
    end

    if EventName == data[1] then
        local cfg = {}
        for k, v in ipairs(LuckyEventCfg) do
            if v.EnevtName == EventName then
                cfg = v
                break
            end
        end
        if cfg.Types == "�ٻ�" then
            Message.sendmsg(actor, ssrNetMsgCfg.QiYuHeZi_OpenEventUI, 0, 0, 0, {EventName})    --ǰ�˴򿪶�Ӧ����
            Message.sendmsg(actor, ssrNetMsgCfg.QiYuZhaoHuan_SyncResponse, 0, 0, 0, {EventName}) --���ٻ����洫������
            GameEvent.push(EventCfg.LuckyEventinitVar, actor, EventName)  --�������������ñ���
        elseif cfg.Types == "����" then
            Message.sendmsg(actor, ssrNetMsgCfg.QiYuHeZi_OpenEventUI, 0, 0, 0,{EventName}) --ǰ�˴򿪶�Ӧ����
            Message.sendmsg(actor, ssrNetMsgCfg.QiYuFuBen_SyncResponse, 0, 0, 0, {EventName}) --�򸱱����洫������
            GameEvent.push(EventCfg.LuckyEventinitVar, actor, EventName)  --�������������ñ���
        elseif cfg.Types == "�¼�" then
            local state = true
            if cfg.BuffId ~= "nil"  then
                local BuffTbl = cfg.BuffId
                for i = 1, #BuffTbl do
                    local buffstate = hasbuff(actor, BuffTbl[i])
                    if hasbuff(actor, BuffTbl[i]) then
                        state = false
                    end
                end
            end
            if state then
                Message.sendmsg(actor, ssrNetMsgCfg.QiYuHeZi_OpenEventUI, 0, 0, 0,{EventName})
                GameEvent.push(EventCfg.LuckyEventinitVar, actor, EventName, "���Ӵ�")  --�������������ñ���
            else
                Player.sendmsgEx(actor, "��ʾ#251|:#255|�㵱ǰ��|" ..EventName.. "#249|��Buff,��ȴ�����...")
            end
        end
    end
    setplaydef(actor, VarCfg["Z_��������λ��".. var ..""],"")
    QiYuHeZi.SyncResponse(actor)
end

--�ͻ���x���Ի����ս�����
function QiYuHeZi.ClientAddEvent(actor,Event_Name)
    local notes1 = getplaydef(actor, VarCfg["Z_��������λ��1"])
    local notes2 = getplaydef(actor, VarCfg["Z_��������λ��2"])
    local notes3 = getplaydef(actor, VarCfg["Z_��������λ��3"])
    local notes4 = getplaydef(actor, VarCfg["Z_��������λ��4"])
    local notes5 = getplaydef(actor, VarCfg["Z_��������λ��5"])
    local NewTbl = {notes1,notes2,notes3,notes4,notes5}

    for _, value in ipairs(NewTbl) do
        if value == Event_Name then
            setplaydef(actor, VarCfg["S$������֤"], "")
            return
        end
    end
    if notes1 == "" then
        setplaydef(actor, VarCfg["Z_��������λ��1"],Event_Name)
    elseif  notes2 == "" then
        setplaydef(actor, VarCfg["Z_��������λ��2"],Event_Name)
    elseif  notes3 == "" then
        setplaydef(actor, VarCfg["Z_��������λ��3"],Event_Name)
    elseif  notes4 ~= "δ����" then
        if notes4 == "" then
            setplaydef(actor, VarCfg["Z_��������λ��4"],Event_Name)
        end
    elseif  notes5 ~= "δ����" then
        if notes5 == "" then
            setplaydef(actor, VarCfg["Z_��������λ��5"],Event_Name)
        end
    end
    QiYuHeZi.SyncResponse(actor)
end

--�¼�������������
function QiYuHeZi.Switch(actor)
    if getflagstatus(actor, VarCfg["F_�����Զ���������"]) == 0 then
        setflagstatus(actor, VarCfg["F_�����Զ���������"], 1)
    else
        setflagstatus(actor, VarCfg["F_�����Զ���������"], 0)
    end
    QiYuHeZi.SyncResponse(actor)
end

function QiYuHeZi.AddEvent(actor,Event_Name)
    local bool = getflagstatus(actor, VarCfg["F_�����Զ���������"])
    if bool == 0 then
        return true
    else
        local notes1 = getplaydef(actor, VarCfg["Z_��������λ��1"])
        local notes2 = getplaydef(actor, VarCfg["Z_��������λ��2"])
        local notes3 = getplaydef(actor, VarCfg["Z_��������λ��3"])
        local notes4 = getplaydef(actor, VarCfg["Z_��������λ��4"])
        local notes5 = getplaydef(actor, VarCfg["Z_��������λ��5"])
        local NewTbl = {notes1,notes2,notes3,notes4,notes5}
        for _, value in ipairs(NewTbl) do
            if value == Event_Name then
                return
            end
        end
        if notes1 == "" then
            setplaydef(actor, VarCfg["Z_��������λ��1"],Event_Name)
        elseif  notes2 == "" then
            setplaydef(actor, VarCfg["Z_��������λ��2"],Event_Name)
        elseif  notes3 == "" then
            setplaydef(actor, VarCfg["Z_��������λ��3"],Event_Name)
        elseif  notes4 ~= "δ����" then
            if notes4 == "" then
                setplaydef(actor, VarCfg["Z_��������λ��4"],Event_Name)
            end
        elseif  notes5 ~= "δ����" then
            if notes5 == "" then
                setplaydef(actor, VarCfg["Z_��������λ��5"],Event_Name)
            end
        end
        QiYuHeZi.SyncResponse(actor)
        return false
    end
end

--ע��������Ϣ
function QiYuHeZi.SyncResponse(actor, logindatas)
    local bool = getflagstatus(actor, VarCfg["F_�����Զ���������"])
    local notes1 = getplaydef(actor, VarCfg["Z_��������λ��1"])
    local notes2 = getplaydef(actor, VarCfg["Z_��������λ��2"])
    local notes3 = getplaydef(actor, VarCfg["Z_��������λ��3"])
    local notes4 = getplaydef(actor, VarCfg["Z_��������λ��4"])
    local notes5 = getplaydef(actor, VarCfg["Z_��������λ��5"])
    local data = { notes1, notes2, notes3, notes4, notes5}
    local _login_data = { ssrNetMsgCfg.QiYuHeZi_SyncResponse, bool, 0, 0, data }
    if logindatas then
        table.insert(logindatas, _login_data)
    else
        Message.sendmsg(actor, ssrNetMsgCfg.QiYuHeZi_SyncResponse, bool, 0, 0, data)
    end
end
Message.RegisterNetMsg(ssrNetMsgCfg.QiYuHeZi, QiYuHeZi)

--0:0:10 �µ�һ�촥��
local function _onNewDay(actor)
    setplaydef(actor, VarCfg["Z_��������λ��4"],"δ����")
    setplaydef(actor, VarCfg["Z_��������λ��5"],"δ����")

    if checkitems(actor, "�þ�ͨ��֤#1", 0, 0) then
        setplaydef(actor, VarCfg["Z_��������λ��4"],"")
    end
    QiYuHeZi.SyncResponse(actor)
end
GameEvent.add(EventCfg.onNewDay, _onNewDay, QiYuHeZi)

--��¼����
local function _onLoginEnd(actor, logindatas)
    if not checkitems(actor, "�þ�ͨ��֤#1", 0, 0) then
        if getplaydef(actor, VarCfg["Z_��������λ��4"]) == "" then
            setplaydef(actor, VarCfg["Z_��������λ��4"],"δ����")
        end
    end

    setplaydef(actor, VarCfg["Z_��������λ��5"],"δ����")
    QiYuHeZi.SyncResponse(actor, logindatas)
end
GameEvent.add(EventCfg.onLoginEnd, _onLoginEnd, QiYuHeZi)

--ע��������Ϣ
Message.RegisterNetMsg(ssrNetMsgCfg.QiYuShiJian01, QiYuHeZi)

return QiYuHeZi



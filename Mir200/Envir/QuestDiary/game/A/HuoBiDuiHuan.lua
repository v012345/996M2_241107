local HuoBiDuiHuan = {}
local Cost = {{"���", 1000000},{"���", 10},{"���", 100},{"���", 1000}}
local MoneyNum = {10000,10000,100000,1000000}

--��������
function HuoBiDuiHuan.Request(actor,var)
    if var > 4 then return end

    local DuiHuanNum = getplaydef(actor, VarCfg["J_ÿ�ջ��Ҷһ�����"])
    local MaxUL = 20
    if getflagstatus(actor, VarCfg["F_�Ƿ��׳�"]) == 1 then
        MaxUL = MaxUL + 20
    end

    if getflagstatus(actor, VarCfg["F_���״̬"]) == 1 then
        MaxUL = MaxUL + 20
    end
    if checktitle(actor, "�򹤻ʵ�") then
        MaxUL = MaxUL + 40
    end

    if var ==  1 then
        if DuiHuanNum >= MaxUL then
            Player.sendmsgEx(actor, "��ʾ#251|:#255|������|��Ҷһ�Ԫ��#249|,�����Ѿ��ﵽ������...")
            return
        end
    end

    local name, num = Player.checkItemNumByTable(actor, {Cost[var]})
    if name then
        Player.sendmsgEx(actor, string.format("���|%s#249|����|%d#249|ö...", name, num))
        return
    end

    Player.takeItemByTable(actor, {Cost[var]}, "���Ҷһ��۳�")

    changemoney(actor, 2, "+", MoneyNum[var], "���Ҷһ����", true)

    if var ==  1 then
        setplaydef(actor, VarCfg["J_ÿ�ջ��Ҷһ�����"], DuiHuanNum + 1)
    end
    HuoBiDuiHuan.SyncResponse(actor)
end

--ͬ����Ϣ
function HuoBiDuiHuan.SyncResponse(actor, logindatas)

    local DuiHuanNum = getplaydef(actor, VarCfg["J_ÿ�ջ��Ҷһ�����"])
    local MaxUL = 20
    if getflagstatus(actor, VarCfg["F_�Ƿ��׳�"]) == 1 then
        MaxUL = MaxUL + 20
    end
    if getflagstatus(actor, VarCfg["F_���״̬"]) == 1 then
        MaxUL = MaxUL + 20
    end
    if checktitle(actor, "�򹤻ʵ�") then
        MaxUL = MaxUL + 40
    end
    local data = {DuiHuanNum, MaxUL}
    local _login_data = {ssrNetMsgCfg.HuoBiDuiHuan_SyncResponse, 0, 0, 0, data}
    if type(logindatas) == "table" then
        table.insert(logindatas, _login_data)
    else
        Message.sendmsg(actor, ssrNetMsgCfg.HuoBiDuiHuan_SyncResponse, 0, 0, 0, data)
    end
end


--��¼����
local function _onLoginEnd(actor, logindatas)
 HuoBiDuiHuan.SyncResponse(actor, logindatas)
end
GameEvent.add(EventCfg.onLoginEnd, _onLoginEnd, HuoBiDuiHuan)



--ע��������Ϣ
Message.RegisterNetMsg(ssrNetMsgCfg.HuoBiDuiHuan, HuoBiDuiHuan)
return HuoBiDuiHuan
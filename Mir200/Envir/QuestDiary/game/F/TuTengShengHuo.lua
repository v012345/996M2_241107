local TuTengShengHuo = {}
local cost = {{"ͼ����Ƭ", 1}}

function TuTengShengHuo.Request(actor)
    local _Num = getplaydef(actor, VarCfg["U_ͼ��ʥ���¼"])
    if _Num >= 10  then
        Player.sendmsgEx(actor, "��ʾ#251|:#255|���|ͼ����Ƭ#249|�Ѿ��ύ�ﵽ|".. _Num .."#249|����...")
        return
    end
    local name, num = Player.checkItemNumByTable(actor, cost)
    if name then
        Player.sendmsgEx(actor, string.format("��ʾ#251|:#255|���|%s#249|����|%d#249|ö,�ύʧ��...", name, num))
        return
    end
    Player.takeItemByTable(actor, cost, "��ͨ��ͼ����")
    setplaydef(actor, VarCfg["U_ͼ��ʥ���¼"], _Num + 1)
    Player.sendmsgEx(actor, "��ʾ#251|:#255|���|ͼ����Ƭ#249|�ύ����|+1#249|...")
    TuTengShengHuo.SyncResponse(actor)
    Player.setAttList(actor, "���Ը���")
end

--ע��������Ϣ
function TuTengShengHuo.SyncResponse(actor, logindatas)
    local Num = getplaydef(actor, VarCfg["U_ͼ��ʥ���¼"])
    local data ={Num}
    local _login_data = { ssrNetMsgCfg.TuTengShengHuo_SyncResponse, 0, 0, 0, data }
    if logindatas then
        table.insert(logindatas, _login_data)
    else
        Message.sendmsg(actor, ssrNetMsgCfg.TuTengShengHuo_SyncResponse, 0, 0, 0, data)
    end
end
Message.RegisterNetMsg(ssrNetMsgCfg.TuTengShengHuo, TuTengShengHuo)

local function _onCalcAttr(actor, attrs)
    local Num = getplaydef(actor, VarCfg["U_ͼ��ʥ���¼"])
    local shuxing = {}
    if Num > 0 and Num <= 10 then
        shuxing[75] = 100*Num
    end
    calcAtts(attrs, shuxing, "ͼ����Ƭ")
end
GameEvent.add(EventCfg.onCalcAttr, _onCalcAttr, TuTengShengHuo)

--��¼����
local function _onLoginEnd(actor, logindatas)
    TuTengShengHuo.SyncResponse(actor, logindatas)
end
GameEvent.add(EventCfg.onLoginEnd, _onLoginEnd, TuTengShengHuo)

return TuTengShengHuo

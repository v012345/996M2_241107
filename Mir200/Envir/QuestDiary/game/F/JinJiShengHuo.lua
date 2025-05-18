local JinJiShengHuo = {}
local cost = {{"���ɾ���", 1}}

function JinJiShengHuo.Request(actor)
    local _Num = getplaydef(actor, VarCfg["U_����ʥ���¼"])
    if _Num == 10  then
        Player.sendmsgEx(actor, "��ʾ#251|:#255|���|���ɾ���#249|�Ѿ��ύ�ﵽ|".. _Num .."#249|����...")
        return
    end
    local name, num = Player.checkItemNumByTable(actor, cost)
    if name then
        Player.sendmsgEx(actor, string.format("��ʾ#251|:#255|���|%s#249|����|%d#249|ö,�ύʧ��...", name, num))
        return
    end
    Player.takeItemByTable(actor, cost, "��ͨ��ͼ����")
    setplaydef(actor, VarCfg["U_����ʥ���¼"], _Num + 1)
    Player.sendmsgEx(actor, "��ʾ#251|:#255|���|���ɾ���#249|�ύ����|+1#249|...")
    JinJiShengHuo.SyncResponse(actor)
    Player.setAttList(actor, "���Ը���")
end

--ע��������Ϣ
function JinJiShengHuo.SyncResponse(actor, logindatas)
    local Num = getplaydef(actor, VarCfg["U_����ʥ���¼"])
    local data ={Num}
    local _login_data = { ssrNetMsgCfg.JinJiShengHuo_SyncResponse, 0, 0, 0, data }
    if logindatas then
        table.insert(logindatas, _login_data)
    else
        Message.sendmsg(actor, ssrNetMsgCfg.JinJiShengHuo_SyncResponse, 0, 0, 0, data)
    end
end
Message.RegisterNetMsg(ssrNetMsgCfg.JinJiShengHuo, JinJiShengHuo)

local function _onCalcAttr(actor, attrs)
    local Num = getplaydef(actor, VarCfg["U_����ʥ���¼"])
    local shuxing = {}
    if Num > 0 and Num <= 10 then
        shuxing[4] = 20*Num
    end
    calcAtts(attrs, shuxing, "���ɾ���")
end
GameEvent.add(EventCfg.onCalcAttr, _onCalcAttr, JinJiShengHuo)

--��¼����
local function _onLoginEnd(actor, logindatas)
    JinJiShengHuo.SyncResponse(actor, logindatas)
end
GameEvent.add(EventCfg.onLoginEnd, _onLoginEnd, JinJiShengHuo)

return JinJiShengHuo

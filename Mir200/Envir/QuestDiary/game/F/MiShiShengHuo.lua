local MiShiShengHuo = {}
local cost = {{"��ʧ���", 1}}

function MiShiShengHuo.Request(actor)
    local _Num = getplaydef(actor, VarCfg["U_��ʧʥ���¼"])
    if _Num == 10  then
        Player.sendmsgEx(actor, "��ʾ#251|:#255|���|��ʧ���#249|�Ѿ��ύ�ﵽ|".. _Num .."#249|����...")
        return
    end
    local name, num = Player.checkItemNumByTable(actor, cost)
    if name then
        Player.sendmsgEx(actor, string.format("��ʾ#251|:#255|���|%s#249|����|%d#249|ö,�ύʧ��...", name, num))
        return
    end
    Player.takeItemByTable(actor, cost, "��ͨ��ͼ����")
    setplaydef(actor, VarCfg["U_��ʧʥ���¼"], _Num + 1)
    Player.sendmsgEx(actor, "��ʾ#251|:#255|���|��ʧ���#249|�ύ����|+1#249|...")
    MiShiShengHuo.SyncResponse(actor)
    Player.setAttList(actor, "���Ը���")
end

--ע��������Ϣ
function MiShiShengHuo.SyncResponse(actor, logindatas)
    local Num = getplaydef(actor, VarCfg["U_��ʧʥ���¼"])
    local data ={Num}
    local _login_data = { ssrNetMsgCfg.MiShiShengHuo_SyncResponse, 0, 0, 0, data }
    if logindatas then
        table.insert(logindatas, _login_data)
    else
        Message.sendmsg(actor, ssrNetMsgCfg.MiShiShengHuo_SyncResponse, 0, 0, 0, data)
    end
end
Message.RegisterNetMsg(ssrNetMsgCfg.MiShiShengHuo, MiShiShengHuo)

local function _onCalcAttr(actor, attrs)
    local Num = getplaydef(actor, VarCfg["U_��ʧʥ���¼"])
    local shuxing = {}
    if Num > 0 and Num <= 10 then
        shuxing[208] = Num
    end
    calcAtts(attrs, shuxing, "��ʧ���")
end
GameEvent.add(EventCfg.onCalcAttr, _onCalcAttr, MiShiShengHuo)

--��¼����
local function _onLoginEnd(actor, logindatas)
    MiShiShengHuo.SyncResponse(actor, logindatas)
end
GameEvent.add(EventCfg.onLoginEnd, _onLoginEnd, MiShiShengHuo)

return MiShiShengHuo

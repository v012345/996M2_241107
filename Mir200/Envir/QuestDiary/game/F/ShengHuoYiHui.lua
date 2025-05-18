local ShengHuoYiHui = {}


function ShengHuoYiHui.Request(actor)
    local Num1 = getplaydef(actor, VarCfg["U_����ʥ���¼"])
    local Num2 = getplaydef(actor, VarCfg["U_ͼ��ʥ���¼"])
    local Num3 = getplaydef(actor, VarCfg["U_����ʥ���¼"])
    local Num4 = getplaydef(actor, VarCfg["U_��ʧʥ���¼"])
    local bool = getflagstatus(actor, VarCfg["F_ʥ���ż�_��ȡ״̬"])
    if Num1 ~= 10 then
        Player.sendmsgEx(actor, "��ʾ#251|:#255|���|����ʥ��#249|�ύ��������|10��#249|...")
        return
    elseif Num2 ~= 10 then
        Player.sendmsgEx(actor, "��ʾ#251|:#255|���|ͼ��ʥ��#249|�ύ��������|10��#249|...")
        return
    elseif Num3 ~= 10 then
        Player.sendmsgEx(actor, "��ʾ#251|:#255|���|����ʥ��#249|�ύ��������|10��#249|...")
        return
    elseif Num4 ~= 10 then
        Player.sendmsgEx(actor, "��ʾ#251|:#255|���|��ʧʥ��#249|�ύ��������|10��#249|...")
        return
    end
    if bool == 1 then
        Player.sendmsgEx(actor, "��ʾ#251|:#255|������ȡ��|ʥ���Ż�#249|�����ظ���ȡ...")
        return
    end
    giveitem(actor, "ʥ���Ż�", 1, 0)
    setflagstatus(actor, VarCfg["F_ʥ���ż�_��ȡ״̬"], 1)
    Player.sendmsgEx(actor, "��ʾ#251|:#255|��ϲ��,��ȡ|ʥ���Ż�#249|�ɹ�...")
    ShengHuoYiHui.SyncResponse(actor)

end

--ע��������Ϣ
function ShengHuoYiHui.SyncResponse(actor, logindatas)
    local Num1 = getplaydef(actor, VarCfg["U_����ʥ���¼"])
    local Num2 = getplaydef(actor, VarCfg["U_ͼ��ʥ���¼"])
    local Num3 = getplaydef(actor, VarCfg["U_����ʥ���¼"])
    local Num4 = getplaydef(actor, VarCfg["U_��ʧʥ���¼"])
    local bool = getflagstatus(actor, VarCfg["F_ʥ���ż�_��ȡ״̬"])
    local data ={Num1, Num2, Num3, Num4, bool}

    local _login_data = { ssrNetMsgCfg.ShengHuoYiHui_SyncResponse, 0, 0, 0, data }
    if logindatas then
        table.insert(logindatas, _login_data)
    else
        Message.sendmsg(actor, ssrNetMsgCfg.ShengHuoYiHui_SyncResponse, 0, 0, 0, data)
    end
end
Message.RegisterNetMsg(ssrNetMsgCfg.ShengHuoYiHui, ShengHuoYiHui)

--��¼����
local function _onLoginEnd(actor, logindatas)
    ShengHuoYiHui.SyncResponse(actor, logindatas)
end
GameEvent.add(EventCfg.onLoginEnd, _onLoginEnd, ShengHuoYiHui)

return ShengHuoYiHui

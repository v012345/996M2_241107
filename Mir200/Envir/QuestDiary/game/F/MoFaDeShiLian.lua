local MoFaDeShiLian = {}
local cost = {{"�޾���ŭ", 1},{"Ѫħ����MAX", 1}}

function MoFaDeShiLian.Request(actor,var)
    if var == 1 then
        local bool = getflagstatus(actor, VarCfg["F_���������_�޾���ŭ"])
        if bool == 1 then
            Player.sendmsgEx(actor, "��ʾ#251|:#255|�Բ���,�����ύ|�޾���ŭ#249|��,�����ظ��ύ...")
            return
        else
            local name, num = Player.checkItemNumByTable(actor, {cost[1]})
            if name then
                Player.sendmsgEx(actor, string.format("��ʾ#251|:#255|���|%s#249|����|%d#249|��,�ύʧ��...", name, num))
                return
            end
            Player.takeItemByTable(actor, {cost[1]}, "����۳�")
            if randomex(40, 100) then
                setflagstatus(actor, VarCfg["F_���������_�޾���ŭ"], 1)
                Player.setAttList(actor, "���Ը���")
            else
                Player.sendmsgEx(actor, "��ʾ#251|:#255|�Բ���,�ύ|ʧ��#249|���ٽ�����...")
            end
            MoFaDeShiLian.SyncResponse(actor)
        end
    end
    if var == 2 then
        local bool = getflagstatus(actor, VarCfg["F_���������_Ѫħ����MAX"])
        if bool == 1 then
            Player.sendmsgEx(actor, "��ʾ#251|:#255|�Բ���,�����ύ|Ѫħ����MAX#249|��,�����ظ��ύ...")
            return
        else
            local name, num = Player.checkItemNumByTable(actor, {cost[2]})
            if name then
                Player.sendmsgEx(actor, string.format("��ʾ#251|:#255|���|%s#249|����|%d#249|��,�ύʧ��...", name, num))
                return
            end
            Player.takeItemByTable(actor, {cost[2]}, "����۳�")
            if randomex(40, 100) then
                setflagstatus(actor, VarCfg["F_���������_Ѫħ����MAX"], 1)
                Player.setAttList(actor, "���Ը���")
            else
                Player.sendmsgEx(actor, "��ʾ#251|:#255|�Բ���,�ύ|ʧ��#249|���ٽ�����...")
            end
            MoFaDeShiLian.SyncResponse(actor)
        end
    end
end

--��������
local function _onCalcAttr(actor, attrs)
    local shuxing = {}
    local bool1 = getflagstatus(actor, VarCfg["F_���������_�޾���ŭ"])
    local bool2 = getflagstatus(actor, VarCfg["F_���������_Ѫħ����MAX"])
    if bool1 == 1 then
        shuxing[206] = 5  --��󹥻���
    end

    if  bool2 == 1 then
        shuxing[207] = 5  --�������ֵ
    end


    if  bool1 == 1 and bool2 == 1 then
        shuxing[200] = 2888  --�и�ֵ
    end
    calcAtts(attrs, shuxing, "���������")
end
GameEvent.add(EventCfg.onCalcAttr, _onCalcAttr, MoFaDeShiLian)






--ע��������Ϣ
function MoFaDeShiLian.SyncResponse(actor, logindatas)
    local bool1 = getflagstatus(actor, VarCfg["F_���������_�޾���ŭ"])
    local bool2 = getflagstatus(actor, VarCfg["F_���������_Ѫħ����MAX"])

    local data ={ bool1,bool2}
    local _login_data = { ssrNetMsgCfg.MoFaDeShiLian_SyncResponse, 0, 0, 0, data }
    if logindatas then
        table.insert(logindatas, _login_data)
    else
        Message.sendmsg(actor, ssrNetMsgCfg.MoFaDeShiLian_SyncResponse, 0, 0, 0, data)
    end
end
Message.RegisterNetMsg(ssrNetMsgCfg.MoFaDeShiLian, MoFaDeShiLian)

--��¼����
local function _onLoginEnd(actor, logindatas)
    MoFaDeShiLian.SyncResponse(actor, logindatas)
end
GameEvent.add(EventCfg.onLoginEnd, _onLoginEnd, MoFaDeShiLian)





return MoFaDeShiLian

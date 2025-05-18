local QiHunGuiPo = {}
QiHunGuiPo.ID = "�߻����"
local npcID = 469
local TypeData = {"ʬ��","��ʸ","ȸ��","����","�Ƕ�","����","����"}
local cost = {{}}
local give = {{}}

function QiHunGuiPo.getVariableState(actor)
    local IsTbl = Player.getJsonTableByVar(actor, VarCfg["T_�߻����"])
    local NewTbl = {}
    NewTbl["ʬ��"] = (IsTbl["ʬ��"] == nil and 0) or IsTbl["ʬ��"]
    NewTbl["��ʸ"] = (IsTbl["��ʸ"] == nil and 0) or IsTbl["��ʸ"]
    NewTbl["ȸ��"] = (IsTbl["ȸ��"] == nil and 0) or IsTbl["ȸ��"]
    NewTbl["����"] = (IsTbl["����"] == nil and 0) or IsTbl["����"]
    NewTbl["�Ƕ�"] = (IsTbl["�Ƕ�"] == nil and 0) or IsTbl["�Ƕ�"]
    NewTbl["����"] = (IsTbl["����"] == nil and 0) or IsTbl["����"]
    NewTbl["����"] = (IsTbl["����"] == nil and 0) or IsTbl["����"]
    return NewTbl
end


--��������
function QiHunGuiPo.Request(actor, var)
    if not TypeData[var] then return end --��Ч����
    local data = QiHunGuiPo.getVariableState(actor)
    local _type = TypeData[var]
    local costitem = "���ǡ�".._type

    if data[_type] >= 10 then
        Player.sendmsgEx(actor, "��ʾ#251|:#255|�Բ���,���|".. costitem .."#249|�Ѿ��ﵽ|10��#249|��...")
        return
    end

    local cost = {{costitem, 1},{"���", 200}}
    local name, num = Player.checkItemNumByTable(actor, cost)
    if name then
        Player.sendmsgEx(actor, string.format("��ʾ#251|:#255|���|%s#249|����|%d#249|ö,�ύʧ��...", name, num))
        return
    end
    Player.takeItemByTable(actor, cost, costitem.."�ύ")
    data[_type] = data[_type] + 1

    Player.setJsonVarByTable(actor, VarCfg["T_�߻����"], data)
    QiHunGuiPo.SyncResponse(actor)
    Player.setAttList(actor, "���Ը���")
end

--ͬ����Ϣ
function QiHunGuiPo.SyncResponse(actor, logindatas)
    local data = QiHunGuiPo.getVariableState(actor)
    local _login_data = {ssrNetMsgCfg.QiHunGuiPo_SyncResponse, 0, 0, 0, data}
    if logindatas then
        table.insert(logindatas, _login_data)
    else
        Message.sendmsg(actor, ssrNetMsgCfg.QiHunGuiPo_SyncResponse, 0, 0, 0, data)
    end
end

--���Ը���
local function _onCalcAttr(actor, attrs)
    local data = QiHunGuiPo.getVariableState(actor)
    local shuxing = {}

    if data["ʬ��"] > 0 then  --��������
        shuxing[208] = data["ʬ��"]
    end

    if data["��ʸ"] > 0 then  --��������
        shuxing[21] = data["��ʸ"]
    end

    if data["ȸ��"] > 0 then  --�����˺�
        shuxing[25] = data["ȸ��"]
    end

    if data["����"] > 0 then  --�����˺�
        shuxing[22] = data["����"]
    end

    if data["�Ƕ�"] > 0 then --�����ӳ�
        shuxing[213] = data["�Ƕ�"]
        shuxing[214] = data["�Ƕ�"]
    end

    if data["����"] > 0 then --�˺�����
        shuxing[26] = data["����"]
        shuxing[27] = data["����"]
    end

    if data["����"] > 0 then --�Թ�����
        shuxing[75] = data["����"] * 100
    end
    calcAtts(attrs, shuxing, "�߻����")
end
GameEvent.add(EventCfg.onCalcAttr, _onCalcAttr, QiHunGuiPo)


--��¼����
local function _onLoginEnd(actor, logindatas)
    QiHunGuiPo.SyncResponse(actor, logindatas)
end
--�¼��ɷ�
GameEvent.add(EventCfg.onLoginEnd, _onLoginEnd, QiHunGuiPo)
--ע��������Ϣ
Message.RegisterNetMsg(ssrNetMsgCfg.QiHunGuiPo, QiHunGuiPo)
return QiHunGuiPo
local WanHunDian = {}
WanHunDian.ID = "����"
local npcID = 468


--��ȡ������������
function WanHunDian.getVarU_Num(actor)
    local Num1 = getplaydef(actor, VarCfg["U_����Ĺɱ��1"])
    local Num2 = getplaydef(actor, VarCfg["U_����Ĺɱ��2"])
    local Num3 = getplaydef(actor, VarCfg["U_����Ĺɱ��3"])
    local  data = {Num1, Num2, Num3}
    return data
end

--��������
function WanHunDian.Request(actor)
    local data = WanHunDian.getVarU_Num(actor)

    if data[1] < 33 then
        Player.sendmsgEx(actor, "��ʾ#251|:#255|�Բ���,���|�졤Ԫ��#249|��ɱ����|33#249|�޷�����...")
        return
    end

    if data[2] < 33 then
        Player.sendmsgEx(actor, "��ʾ#251|:#255|�Բ���,���|�ˡ�����#249|��ɱ����|33#249|�޷�����...")
        return
    end

    if data[3] < 33 then
        Player.sendmsgEx(actor, "��ʾ#251|:#255|�Բ���,���|�ء�����#249|��ɱ����|33#249|�޷�����...")
        return
    end

    setplaydef(actor, VarCfg["U_����Ĺɱ��1"], data[1] - 33)
    setplaydef(actor, VarCfg["U_����Ĺɱ��2"], data[2] - 33)
    setplaydef(actor, VarCfg["U_����Ĺɱ��3"], data[3] - 33)
    WanHunDian.SyncResponse(actor)

    local NowMapID = getbaseinfo(actor, ConstCfg.gbase.mapid)
    local NowX,NowY = getbaseinfo(actor, ConstCfg.gbase.x),getbaseinfo(actor, ConstCfg.gbase.y)

    local HuiChenginfo = {["NowMapID"] = NowMapID,["NowX"] = NowX,["NowY"] = NowY}
    Player.setJsonVarByTable(actor, VarCfg["T_���븱����¼�˳���Ϣ"] , HuiChenginfo)



    local UserName = getbaseinfo(actor, ConstCfg.gbase.name)
    local NewMapId = "youmingshenyuan"..UserName --����ԭʼ��ͼid  �����µ�ͼID
    local NewMapName = "����".."[����]"

    if checkmirrormap(NewMapId) then
        killmonsters(NewMapId, "*", 0, false)   --ɱ����ǰ��ͼ���й���
        delmirrormap(NewMapId)              --ɾ�������ͼ
        addmirrormap("youmingshenyuan", NewMapId, NewMapName, 600, NowMapID, nil, NowX, NowY)
    else
        addmirrormap("youmingshenyuan", NewMapId, NewMapName, 600, NowMapID, nil, NowX, NowY)
    end

    --ˢBoss
    genmon(NewMapId, 24, 25,"����������֮�������", 100, 100, 249)

    map(actor, NewMapId)
end

-- ͬ����Ϣ
function WanHunDian.SyncResponse(actor, logindatas)
    local data = WanHunDian.getVarU_Num(actor)
    local _login_data = {ssrNetMsgCfg.WanHunDian_SyncResponse, 0, 0, 0, data}
    if type(logindatas) == "table" then
        table.insert(logindatas, _login_data)
    else
        Message.sendmsg(actor, ssrNetMsgCfg.WanHunDian_SyncResponse, 0, 0, 0, data)
    end
end

--��¼����
local function _onLoginEnd(actor, logindatas)
    WanHunDian.SyncResponse(actor, logindatas)
end
GameEvent.add(EventCfg.onLoginEnd, _onLoginEnd, WanHunDian)



--ע��������Ϣ
Message.RegisterNetMsg(ssrNetMsgCfg.WanHunDian, WanHunDian)
return WanHunDian
local TuFuJie = {}
TuFuJie.ID = "������"
local cost = {{"�����Ƭ",44},{"���籾Դ",88},{"Ԫ��",4444444}}

-- ĺɫ����	28	29
--��������
function TuFuJie.Request(actor)
    local name, num = Player.checkItemNumByTable(actor, cost)
    if name then
        Player.sendmsgEx(actor, string.format("���|%s#249|��������|%d#249|,��սʧ��...", name, num))
        return
    end
    Player.takeItemByTable(actor, cost, "���������ٿ۳�")

    local NowMapID = getbaseinfo(actor, ConstCfg.gbase.mapid)
    local NowX,NowY = getbaseinfo(actor, ConstCfg.gbase.x),getbaseinfo(actor, ConstCfg.gbase.y)

    local HuiChenginfo = {["NowMapID"] = NowMapID,["NowX"] = NowX,["NowY"] = NowY}
    Player.setJsonVarByTable(actor, VarCfg["T_���븱����¼�˳���Ϣ"] , HuiChenginfo)

    -- lytzg1 ������
    local UserName = getbaseinfo(actor, ConstCfg.gbase.name)
    local NewMapId = "lytzg1"..UserName --����ԭʼ��ͼid  �����µ�ͼID
    local NewMapName = "������".."[����]"

    if checkmirrormap(NewMapId) then
        killmonsters(NewMapId, "*", 0, false)   --ɱ����ǰ��ͼ���й���
        delmirrormap(NewMapId)              --ɾ�������ͼ
        addmirrormap("lytzg1", NewMapId, NewMapName, 300, NowMapID, nil, NowX, NowY)
    else
        addmirrormap("lytzg1", NewMapId, NewMapName, 300, NowMapID, nil, NowX, NowY)
    end
    map(actor, NewMapId)
    --ˢBoss
    genmon(NewMapId, 24, 25,"[��֮����]ʯĸ��ɪ������", 1, 1, 249)
    --ͬ��ǰ����Ϣ
    TuFuJie.SyncResponse(actor)
end

--�����ͼ��ɱ���ﴥ��
local function _onKillMon(actor, monobj, monName)
    if monName ~= "[��֮����]ʯĸ��ɪ������" then return end
    local Bool = getflagstatus(actor,VarCfg["F_�����ٻ�ɱ��ʶ"] )
    if Bool == 1 then return end
    setflagstatus(actor,VarCfg["F_�����ٻ�ɱ��ʶ"],1)
    TuFuJie.SyncResponse(actor)
end
GameEvent.add(EventCfg.onKillMon, _onKillMon, TuFuJie)


--ͬ����Ϣ
function TuFuJie.SyncResponse(actor, logindatas)
    local Bool = getflagstatus(actor,VarCfg["F_�����ٻ�ɱ��ʶ"])
    local data = {Bool}
    local _login_data = {ssrNetMsgCfg.TuFuJie_SyncResponse, 0, 0, 0, data}
    if logindatas then
        table.insert(logindatas, _login_data)
    else
        Message.sendmsg(actor, ssrNetMsgCfg.TuFuJie_SyncResponse, 0, 0, 0, data)
    end
end
--ע��������Ϣ
Message.RegisterNetMsg(ssrNetMsgCfg.TuFuJie, TuFuJie)

--��¼����
local function _onLoginEnd(actor, logindatas)
    TuFuJie.SyncResponse(actor, logindatas)
end
GameEvent.add(EventCfg.onLoginEnd, _onLoginEnd, TuFuJie)

return TuFuJie
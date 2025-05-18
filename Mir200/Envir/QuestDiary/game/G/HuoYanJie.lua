local HuoYanJie = {}
HuoYanJie.ID = "�����"
local cost = {{"�����Ƭ",44},{"���籾Դ",88},{"Ԫ��",4444444}}

-- ��Ѫ֮��	69	73

--��������
function HuoYanJie.Request(actor)
    local name, num = Player.checkItemNumByTable(actor, cost)
    if name then
        Player.sendmsgEx(actor, string.format("���|%s#249|��������|%d#249|,��սʧ��...", name, num))
        return
    end
    Player.takeItemByTable(actor, cost, "�������ٿ۳�")

    local NowMapID = getbaseinfo(actor, ConstCfg.gbase.mapid)
    local NowX,NowY = getbaseinfo(actor, ConstCfg.gbase.x),getbaseinfo(actor, ConstCfg.gbase.y)

    local HuiChenginfo = {["NowMapID"] = NowMapID,["NowX"] = NowX,["NowY"] = NowY}
    Player.setJsonVarByTable(actor, VarCfg["T_���븱����¼�˳���Ϣ"] , HuiChenginfo)

    -- zytzg1 �����
    local UserName = getbaseinfo(actor, ConstCfg.gbase.name)
    local NewMapId = "zytzg1"..UserName --����ԭʼ��ͼid  �����µ�ͼID
    local NewMapName = "�����".."[����]"

    if checkmirrormap(NewMapId) then
        killmonsters(NewMapId, "*", 0, false)   --ɱ����ǰ��ͼ���й���
        delmirrormap(NewMapId)              --ɾ�������ͼ
        addmirrormap("zytzg1", NewMapId, NewMapName, 300, NowMapID, nil, NowX, NowY)
    else
        addmirrormap("zytzg1", NewMapId, NewMapName, 300, NowMapID, nil, NowX, NowY)
    end
    map(actor, NewMapId)
    --ˢBoss
    genmon(NewMapId, 24, 25,"[��֮����]��ħ����������˹", 1, 1, 249)
    --ͬ��ǰ����Ϣ
    HuoYanJie.SyncResponse(actor)
end

--�����ͼ��ɱ���ﴥ��
local function _onKillMon(actor, monobj, monName)
    if monName ~= "[��֮����]��ħ����������˹" then return end
    local Bool = getflagstatus(actor,VarCfg["F_����ٻ�ɱ��ʶ"] )
    if Bool == 1 then return end
    setflagstatus(actor,VarCfg["F_����ٻ�ɱ��ʶ"],1)
    HuoYanJie.SyncResponse(actor)
    release_print(actor, "���������Boss��ɱ")
end
GameEvent.add(EventCfg.onKillMon, _onKillMon, HuoYanJie)

-- ͬ����Ϣ
function HuoYanJie.SyncResponse(actor, logindatas)
    local Bool = getflagstatus(actor,VarCfg["F_����ٻ�ɱ��ʶ"])
    local data = {Bool}
    local _login_data = {ssrNetMsgCfg.HuoYanJie_SyncResponse, 0, 0, 0, data}
    if logindatas then
        table.insert(logindatas, _login_data)
    else
        Message.sendmsg(actor, ssrNetMsgCfg.HuoYanJie_SyncResponse, 0, 0, 0, data)
    end
end
-- ע��������Ϣ
Message.RegisterNetMsg(ssrNetMsgCfg.HuoYanJie, HuoYanJie)

--��¼����
local function _onLoginEnd(actor, logindatas)
    HuoYanJie.SyncResponse(actor, logindatas)
end
GameEvent.add(EventCfg.onLoginEnd, _onLoginEnd, HuoYanJie)

return HuoYanJie
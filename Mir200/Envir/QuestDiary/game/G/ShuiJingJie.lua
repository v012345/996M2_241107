local ShuiJingJie = {}
ShuiJingJie.ID = "ˮ����"
local cost = {{"�����Ƭ",44},{"���籾Դ",88},{"Ԫ��",4444444}}

-- ��������	435	367
--��������
function ShuiJingJie.Request(actor)
    local name, num = Player.checkItemNumByTable(actor, cost)
    if name then
        Player.sendmsgEx(actor, string.format("���|%s#249|��������|%d#249|,��սʧ��...", name, num))
        return
    end
    Player.takeItemByTable(actor, cost, "����ˮ���ٿ۳�")

    local NowMapID = getbaseinfo(actor, ConstCfg.gbase.mapid)
    local NowX,NowY = getbaseinfo(actor, ConstCfg.gbase.x),getbaseinfo(actor, ConstCfg.gbase.y)

    local HuiChenginfo = {["NowMapID"] = NowMapID,["NowX"] = NowX,["NowY"] = NowY}
    Player.setJsonVarByTable(actor, VarCfg["T_���븱����¼�˳���Ϣ"] , HuiChenginfo)

    -- bbtzg1 ˮ����
    local UserName = getbaseinfo(actor, ConstCfg.gbase.name)
    local NewMapId = "bbtzg1"..UserName --����ԭʼ��ͼid  �����µ�ͼID
    local NewMapName = "ˮ����".."[����]"

    if checkmirrormap(NewMapId) then
        killmonsters(NewMapId, "*", 0, false)   --ɱ����ǰ��ͼ���й���
        delmirrormap(NewMapId)              --ɾ�������ͼ
        addmirrormap("bbtzg1", NewMapId, NewMapName, 300, NowMapID, nil, NowX, NowY)
    else
        addmirrormap("bbtzg1", NewMapId, NewMapName, 300, NowMapID, nil, NowX, NowY)
    end
    map(actor, NewMapId)
    --ˢBoss
    genmon(NewMapId, 24, 25,"[ˮ֮����]�Գ��ߡ�����ͼ¡", 1, 1, 249)
    --ͬ��ǰ����Ϣ
    ShuiJingJie.SyncResponse(actor)
end
--�����ͼ��ɱ���ﴥ��
local function _onKillMon(actor, monobj, monName)
    if monName ~= "[ˮ֮����]�Գ��ߡ�����ͼ¡" then return end
    local Bool = getflagstatus(actor,VarCfg["F_ˮ���ٻ�ɱ��ʶ"] )
    if Bool == 1 then return end
    setflagstatus(actor,VarCfg["F_ˮ���ٻ�ɱ��ʶ"],1)
    ShuiJingJie.SyncResponse(actor)
end
GameEvent.add(EventCfg.onKillMon, _onKillMon, ShuiJingJie)

-- ͬ����Ϣ
function ShuiJingJie.SyncResponse(actor, logindatas)
    local Bool = getflagstatus(actor,VarCfg["F_ˮ���ٻ�ɱ��ʶ"])
    local data = {Bool}
    local _login_data = {ssrNetMsgCfg.ShuiJingJie_SyncResponse, 0, 0, 0, data}
    if logindatas then
        table.insert(logindatas, _login_data)
    else
        Message.sendmsg(actor, ssrNetMsgCfg.ShuiJingJie_SyncResponse, 0, 0, 0, data)
    end
end
--ע��������Ϣ
Message.RegisterNetMsg(ssrNetMsgCfg.ShuiJingJie, ShuiJingJie)



--��¼����
local function _onLoginEnd(actor, logindatas)
    ShuiJingJie.SyncResponse(actor, logindatas)
end
GameEvent.add(EventCfg.onLoginEnd, _onLoginEnd, ShuiJingJie)

return ShuiJingJie
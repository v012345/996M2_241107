local ShenPanZhiMen = {}
local cost = { { "ʱ����Ʊ", 1 }}

function ShenPanZhiMen.Request(actor)
    local bout = getplaydef(actor, VarCfg["J_���д���"])

    if bout == 5 then
        Player.sendmsgEx(actor, "��ʾ#251|:#255|��������|����֮��#249|�Ѿ��ﵽ|5#249|��...")
        return
    end

    local name, num = Player.checkItemNumByTable(actor, cost)
    if name then
        Player.sendmsgEx(actor, string.format("��ʾ#251|:#255|���|%s#249|����|%d#249|��,����ʧ��...", name, num))
        return
    end
    Player.takeItemByTable(actor, cost, "�۳�����")
    setplaydef(actor, VarCfg["J_���д���"], bout + 1)

    local UserName = getconst(actor, "<$USERNAME>")
    -- local UserId = getconst(actor, "<$USERID>")
    local FormerMapId = "shenmi"
    local NewMapId = "shenmi"..UserName
    local NewMapName = UserName.."�����и���"
    killmonsters("shenmi", "*", 0, false)   --ɱ����ǰ��ͼ���й���

    if checkmirrormap(NewMapId) then
        delmirrormap(NewMapId)
        addmirrormap(FormerMapId, NewMapId, NewMapName, 300, "ʱ���Թ�", 10059, 43, 41)
    else
        addmirrormap(FormerMapId, NewMapId, NewMapName, 300, "ʱ���Թ�", 10059, 43, 41)
    end
    FSetTaskRedPoint(actor, VarCfg["F_ʱ���Թ����"], 14)
    map(actor, NewMapId)
    genmon(NewMapId, 24, 33 , "����ڳ��ռ������֮��", 0, 1, 249)
    delaygoto(actor, 500, "jin_ru_fu_ben_ti_shi,300")
    ShenPanZhiMen.SyncResponse(actor)
end

--ע��������Ϣ
function ShenPanZhiMen.SyncResponse(actor, logindatas)
    local data = { getplaydef(actor, VarCfg["J_���д���"]) }
    local _login_data = { ssrNetMsgCfg.ShenPanZhiMen_SyncResponse, 0, 0, 0, data }
    if logindatas then
        table.insert(logindatas, _login_data)
    else
        Message.sendmsg(actor, ssrNetMsgCfg.ShenPanZhiMen_SyncResponse, 0, 0, 0, data)
    end
end



--��¼����
local function _onLoginEnd(actor, logindatas)
    ShenPanZhiMen.SyncResponse(actor, logindatas)
end
GameEvent.add(EventCfg.onLoginEnd, _onLoginEnd, ShenPanZhiMen)

Message.RegisterNetMsg(ssrNetMsgCfg.ShenPanZhiMen, ShenPanZhiMen)
return ShenPanZhiMen

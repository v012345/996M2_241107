local JingTuZhiMen = {}
local cost = { { "ʱ����Ʊ", 1 }}

function JingTuZhiMen.Request(actor)
    local bout = getplaydef(actor, VarCfg["J_��������"])

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
    setplaydef(actor, VarCfg["J_��������"], bout + 1)

    local UserName = getconst(actor, "<$USERNAME>")
    -- local UserId = getconst(actor, "<$USERID>")
    local FormerMapId = "jingtu"
    local NewMapId = "jingtu"..UserName
    local NewMapName = UserName.."�ľ�������"
    killmonsters("jingtu", "*", 0, false)   --ɱ����ǰ��ͼ���й���

    if checkmirrormap(NewMapId) then
        delmirrormap(NewMapId)
        addmirrormap(FormerMapId, NewMapId, NewMapName, 300, "ʱ���Թ�", 10059, 43, 41)
    else
        addmirrormap(FormerMapId, NewMapId, NewMapName, 300, "ʱ���Թ�", 10059, 43, 41)
    end
    FSetTaskRedPoint(actor, VarCfg["F_ʱ���Թ����"], 14)
    map(actor, NewMapId)
    genmon(NewMapId, 33, 34 , "�����ҹ��Ů��[��˹]", 0, 1, 249)
    delaygoto(actor, 500, "jin_ru_fu_ben_ti_shi,300")
    JingTuZhiMen.SyncResponse(actor)
end

--ע��������Ϣ
function JingTuZhiMen.SyncResponse(actor, logindatas)
    local data = { getplaydef(actor, VarCfg["J_��������"]) }
    local _login_data = { ssrNetMsgCfg.JingTuZhiMen_SyncResponse, 0, 0, 0, data }
    if logindatas then
        table.insert(logindatas, _login_data)
    else
        Message.sendmsg(actor, ssrNetMsgCfg.JingTuZhiMen_SyncResponse, 0, 0, 0, data)
    end
end

-- VarCfg["J_���д���"] 
-- VarCfg["J_�������"] 

--��¼����
local function _onLoginEnd(actor, logindatas)
    JingTuZhiMen.SyncResponse(actor, logindatas)
end
GameEvent.add(EventCfg.onLoginEnd, _onLoginEnd, JingTuZhiMen)

Message.RegisterNetMsg(ssrNetMsgCfg.JingTuZhiMen, JingTuZhiMen)
return JingTuZhiMen

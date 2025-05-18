local ZhiXuZhiMen = {}
local cost = { { "ʱ����Ʊ", 1 }}

function ZhiXuZhiMen.Request(actor)
    local bout = getplaydef(actor, VarCfg["J_�������"])

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
    setplaydef(actor, VarCfg["J_�������"], bout + 1)

    local UserName = getconst(actor, "<$USERNAME>")
    local FormerMapId = "zhixu"
    local NewMapId = "zhixu"..UserName
    local NewMapName = UserName.."�����򸱱�"
    killmonsters("zhixu", "*", 0, false)   --ɱ����ǰ��ͼ���й���
    if checkmirrormap(NewMapId) then
        delmirrormap(NewMapId)
        addmirrormap(FormerMapId, NewMapId, NewMapName, 300, "ʱ���Թ�", 10059, 43, 41)
    else
        addmirrormap(FormerMapId, NewMapId, NewMapName, 300, "ʱ���Թ�", 10059, 43, 41)
    end
    FSetTaskRedPoint(actor, VarCfg["F_ʱ���Թ����"], 14)
    map(actor, NewMapId)
    genmon(NewMapId, 33, 40 , "�����һֻ��󡡤��̫", 0, 1, 249)
    delaygoto(actor, 500, "jin_ru_fu_ben_ti_shi,300")
    ZhiXuZhiMen.SyncResponse(actor)
end

--ע��������Ϣ
function ZhiXuZhiMen.SyncResponse(actor, logindatas)
    local data = { getplaydef(actor, VarCfg["J_�������"]) }
    local _login_data = { ssrNetMsgCfg.ZhiXuZhiMen_SyncResponse, 0, 0, 0, data }
    if logindatas then
        table.insert(logindatas, _login_data)
    else
        Message.sendmsg(actor, ssrNetMsgCfg.ZhiXuZhiMen_SyncResponse, 0, 0, 0, data)
    end
end

--��¼����
local function _onLoginEnd(actor, logindatas)
    ZhiXuZhiMen.SyncResponse(actor, logindatas)
end
GameEvent.add(EventCfg.onLoginEnd, _onLoginEnd, ZhiXuZhiMen)

Message.RegisterNetMsg(ssrNetMsgCfg.ZhiXuZhiMen, ZhiXuZhiMen)
return ZhiXuZhiMen

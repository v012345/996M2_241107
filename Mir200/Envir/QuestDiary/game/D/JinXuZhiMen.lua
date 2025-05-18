local JinXuZhiMen = {}
local cost = { { "ʱ����Ʊ", 1 }}

function JinXuZhiMen.Request(actor)
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
    -- local UserId = getconst(actor, "<$USERID>")
    local FormerMapId = "jinxu"
    local NewMapId = "jinxu"..UserName
    local NewMapName = UserName.."�Ľ��渱��"
    killmonsters("jinxu", "*", 0, false)   --ɱ����ǰ��ͼ���й���

    if checkmirrormap(NewMapId) then
        delmirrormap(NewMapId)
        addmirrormap(FormerMapId, NewMapId, NewMapName, 300, "ʱ���Թ�", 10059, 45, 40)
    else
        addmirrormap(FormerMapId, NewMapId, NewMapName, 300, "ʱ���Թ�", 10059, 45, 40)
    end
    FSetTaskRedPoint(actor, VarCfg["F_ʱ���Թ����"], 14)
    map(actor, NewMapId)
    genmon(NewMapId, 35, 36, "�����Ļ��ҹ��[ʽ��]", 0, 1, 249)
    delaygoto(actor, 500, "jin_ru_fu_ben_ti_shi,300")
    JinXuZhiMen.SyncResponse(actor)
end



--ע��������Ϣ
function JinXuZhiMen.SyncResponse(actor, logindatas)
    local data = { getplaydef(actor, VarCfg["J_�������"]) }
    local _login_data = { ssrNetMsgCfg.JinXuZhiMen_SyncResponse, 0, 0, 0, data }
    if logindatas then
        table.insert(logindatas, _login_data)
    else
        Message.sendmsg(actor, ssrNetMsgCfg.JinXuZhiMen_SyncResponse, 0, 0, 0, data)
    end
end

-- VarCfg["J_�������"] 
-- VarCfg["J_��������"] 
-- VarCfg["J_���д���"] 
-- VarCfg["J_�������"] 



--��¼����
local function _onLoginEnd(actor, logindatas)
    JinXuZhiMen.SyncResponse(actor, logindatas)
end
GameEvent.add(EventCfg.onLoginEnd, _onLoginEnd, JinXuZhiMen)



Message.RegisterNetMsg(ssrNetMsgCfg.JinXuZhiMen, JinXuZhiMen)
return JinXuZhiMen

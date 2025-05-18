local LiuDaoMoYu = {}
local cost = { { "ħ��Կ��", 1 }, { "�����ʯ", 388 }, { "���", 20000000 } }

function LiuDaoMoYu.Request1(actor)
    local mapbool = getflagstatus(actor, VarCfg["F_����ħ��_�����ʶ"])
    if mapbool == 1 then return end
    local name, num = Player.checkItemNumByTable(actor, cost)
    if name then
        Player.sendmsgEx(actor, string.format("��ʾ#251|:#255|���|%s#249|����|%d#249|...", name, num))
        return
    end
    Player.takeItemByTable(actor, cost, "��ͨ��ͼ����")
    FSetTaskRedPoint(actor, VarCfg["F_����ħ��_�����ʶ"], 56)
    setflagstatus(actor, VarCfg["F_����ħ��_�����ʶ"], 1)
    Player.sendmsgEx(actor, "��ʾ#251|:#255|��ϲ�㿪ͨ|����ħ��#249|�ɹ�...")
    LiuDaoMoYu.SyncResponse(actor)
end

function LiuDaoMoYu.Request2(actor)
    local mapbool = getflagstatus(actor, VarCfg["F_����ħ��_�����ʶ"])
    if mapbool == 0 then
        Player.sendmsgEx(actor, "��ʾ#251|:#255|�Բ���,��|δ��ͨ#249|����ħ��,����ʧ��...")
        return
    else
        mapmove(actor, "����ħ��", 57, 65, 1)
    end
end

--ע��������Ϣ
function LiuDaoMoYu.SyncResponse(actor, logindatas)
    local mapbool = getflagstatus(actor, VarCfg["F_����ħ��_�����ʶ"])
    local _login_data = { ssrNetMsgCfg.LiuDaoMoYu_SyncResponse, mapbool, 0, 0, nil }
    if logindatas then
        table.insert(logindatas, _login_data)
    else
        Message.sendmsg(actor, ssrNetMsgCfg.LiuDaoMoYu_SyncResponse, mapbool, 0, 0, nil)
    end
end

Message.RegisterNetMsg(ssrNetMsgCfg.LiuDaoMoYu, LiuDaoMoYu)
local function _onKillMon(actor, monobj, monName)
    if monName == "��Ͳľ���¡��������ˡ�" then
        local count = getplaydef(actor, VarCfg["B_�����ֻس�_����"])
        if count >= 50 then
            additemtodroplist(actor, monobj, "�����ֻس�")
        end
        setplaydef(actor, VarCfg["B_�����ֻس�_����"], count + 1)
    end
end
GameEvent.add(EventCfg.onKillMon, _onKillMon, LiuDaoMoYu)
--��¼����
local function _onLoginEnd(actor, logindatas)
    LiuDaoMoYu.SyncResponse(actor, logindatas)
end
GameEvent.add(EventCfg.onLoginEnd, _onLoginEnd, LiuDaoMoYu)

return LiuDaoMoYu

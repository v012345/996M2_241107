local BianJingCunZhang = {}
local cost = {{"С������", 88}}
local give = {{"�ϴ峤�Ļ���", 1}}
function BianJingCunZhang.Request(actor)
    if getflagstatus(actor, VarCfg["F_�ϴ峤�Ļ���"]) == 1 then
        Player.sendmsgEx(actor, "���Ѿ�����˸�����!#250")
        return
    end
    local name, num = Player.checkItemNumByTable(actor,cost)
    if name then
        Player.sendmsgEx(actor, string.format("���|%s#249|����|%d#249|��,�޷��������!", name, num))
        return
    end
    Player.takeItemByTable(actor,cost,"�߾��峤")
    Player.giveItemByTable(actor,give,"�߾��峤")
    Player.sendmsgEx(actor, "��ϲ���������,���|[�ϴ峤�Ļ���]#250")
    FSetTaskRedPoint(actor, VarCfg["F_�ϴ峤�Ļ���"], 4)
    BianJingCunZhang.SyncResponse(actor)
end

Message.RegisterNetMsg(ssrNetMsgCfg.BianJingCunZhang, BianJingCunZhang)

function BianJingCunZhang.SyncResponse(actor, logindatas)
    local flag = getflagstatus(actor, VarCfg["F_�ϴ峤�Ļ���"])
    local _login_data = {ssrNetMsgCfg.BianJingCunZhang_SyncResponse, flag}
    if logindatas then
        table.insert(logindatas, _login_data)
    else
        Message.sendmsg(actor, ssrNetMsgCfg.BianJingCunZhang_SyncResponse, flag)
    end

end

--��¼����
local function _onLoginEnd(actor, logindatas)
    BianJingCunZhang.SyncResponse(actor, logindatas)
end
--�¼��ɷ�
GameEvent.add(EventCfg.onLoginEnd, _onLoginEnd, BianJingCunZhang)

return BianJingCunZhang
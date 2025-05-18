local QiXingGongYueZhen = {}
local cost = {{"�����ʯ", 588},{"���籾Դ", 88}}

function QiXingGongYueZhen.Request(actor,var)
    local Verify = (var ~= 1) and (var ~= 2)
    if Verify then return end

    -- ������ͼ
    if var == 1 then
        if getflagstatus(actor, VarCfg["F_���ǹ��µ�ͼ��ʶ"]) == 1 then return end

        local name, num = Player.checkItemNumByTable(actor, cost)
        if name then
            Player.sendmsgEx(actor, string.format("��ʾ#251|:#255|���|%s#249|����|%d#249|ö,����ʧ��...", name, num))
            return
        end
        Player.takeItemByTable(actor, cost, "�������ǹ��µ�ͼ�۳�")
        setflagstatus(actor, VarCfg["F_���ǹ��µ�ͼ��ʶ"], 1)
        QiXingGongYueZhen.SyncResponse(actor)
    end

    --�����ͼ
    if var == 2 then
        if getflagstatus(actor, VarCfg["F_���ǹ��µ�ͼ��ʶ"]) == 0 then return end
        mapmove(actor, "���ǹ�����", 100, 120, 2)
    end
end


--ע��������Ϣ
function QiXingGongYueZhen.SyncResponse(actor, logindatas)
    local mapbool = getflagstatus(actor, VarCfg["F_���ǹ��µ�ͼ��ʶ"])

    local _login_data = { ssrNetMsgCfg.QiXingGongYueZhen_SyncResponse, 0, 0, 0, {mapbool} }
    if logindatas then
        table.insert(logindatas, _login_data)
    else
        Message.sendmsg(actor, ssrNetMsgCfg.QiXingGongYueZhen_SyncResponse, 0, 0, 0, {mapbool})
    end
end
Message.RegisterNetMsg(ssrNetMsgCfg.QiXingGongYueZhen, QiXingGongYueZhen)


--��¼����
local function _onLoginEnd(actor, logindatas)
    QiXingGongYueZhen.SyncResponse(actor, logindatas)
end
GameEvent.add(EventCfg.onLoginEnd, _onLoginEnd, QiXingGongYueZhen)

return QiXingGongYueZhen

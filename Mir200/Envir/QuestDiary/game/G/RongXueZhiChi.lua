local RongXueZhiChi = {}
RongXueZhiChi.ID = "��Ѫ֮��"
local npcID = 824
local config = {
    {
        ["cost"] = { { "Ѫɫ����", 1 } },
        ["attr"] = 200,
        ["value"] = 50,
        ["var"] = VarCfg["B_��Ѫ֮��_����1"],
        ["max"] = 100
    },
    {
        ["cost"] = { { "����ӡ��", 1 } },
        ["attr"] = 25,
        ["value"] = 1,
        ["var"] = VarCfg["B_��Ѫ֮��_����2"],
        ["max"] = 5
    }
}
--��������
function RongXueZhiChi.Request(actor, index)
    local cfg = config[index]
    if not cfg then
        Player.sendmsgEx(actor, "��������!#249")
        return
    end
    local cost = cfg.cost
    local max = cfg.max
    local name = cfg["cost"][1][1]
    local count = getplaydef(actor, cfg.var)
    if count >= max then
        Player.sendmsgEx(actor, string.format("%s#249|���ֻ���ύ|%d#249|��!", name, count))
        return
    end
    local name, num = Player.checkItemNumByTable(actor, cost)
    if name then
        Player.sendmsgEx(actor, string.format("�ύʧ��,���|%s#249|����|%d#249", name, num))
        return
    end
    setplaydef(actor, cfg.var, count + 1)
    Player.takeItemByTable(actor, cost, "��Ѫ֮���ύ")
    Player.setAttList(actor, "���Ը���")
    Player.sendmsgEx(actor,"�ύ�ɹ�!")
    RongXueZhiChi.SyncResponse(actor)
end

function RongXueZhiChi.EnterMap(actor)
    for _, value in ipairs(config) do
        local name = value["cost"][1][1]
        local max = value.max
        local count = getplaydef(actor, value.var)
        if count < max then
            Player.sendmsgEx(actor, string.format("����ʧ��,���|%s#249|�ύ��������|%d#249", name, max))
            return
        end
    end
    mapmove(actor, "��Ѫ֮��", 18, 100, 1)
end

local function _onCalcAttr(actor, attrs)
    local shuxing = {}
    for _, value in ipairs(config) do
        local count = getplaydef(actor, value.var)
        if count > 0 then
            shuxing[value["attr"]] = value.value * count
        end
    end
    calcAtts(attrs, shuxing, "��Ѫ֮��")
end
GameEvent.add(EventCfg.onCalcAttr, _onCalcAttr, RongXueZhiChi)
--ͬ����Ϣ
function RongXueZhiChi.SyncResponse(actor, logindatas)
    local data = {}
    local count1 = getplaydef(actor, VarCfg["B_��Ѫ֮��_����1"])
    local count2 = getplaydef(actor, VarCfg["B_��Ѫ֮��_����2"])
    local _login_data = { ssrNetMsgCfg.RongXueZhiChi_SyncResponse, count1, count2, 0, data }
    if logindatas then
        table.insert(logindatas, _login_data)
    else
        Message.sendmsg(actor, ssrNetMsgCfg.RongXueZhiChi_SyncResponse, count1, count2, 0, data)
    end
end

--��¼����
local function _onLoginEnd(actor, logindatas)
    RongXueZhiChi.SyncResponse(actor, logindatas)
end
--�¼��ɷ�
GameEvent.add(EventCfg.onLoginEnd, _onLoginEnd, RongXueZhiChi)
--ע��������Ϣ
Message.RegisterNetMsg(ssrNetMsgCfg.RongXueZhiChi, RongXueZhiChi)
return RongXueZhiChi

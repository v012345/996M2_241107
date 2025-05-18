local GeBuLinDeRuoDian = {}
GeBuLinDeRuoDian.ID = "�粼�ֵ�����"
local npcID = 512
local config = include("QuestDiary/cfgcsv/cfg_GeBuLinDeRuoDian.lua") --����
local give = { { "��ѩ���[װ��ʱװ]", 1 } }
--��������
function GeBuLinDeRuoDian.Request1(actor, index)
    local cfg = config[index]
    if not cfg then
        Player.sendmsgEx(actor, "��������!#249")
        return
    end
    if getflagstatus(actor, cfg.flag) == 1 then
        Player.sendmsgEx(actor, "���Ѿ��ύ����!#249")
        return
    end
    local cost = cfg.cost
    local name, num = Player.checkItemNumByTable(actor, cost)
    if name then
        Player.sendmsgEx(actor, string.format("���|%s#249|����|%d#249", name, num))
        return
    end
    Player.takeItemByTable(actor, cost, "�粼�ֵ�����")
    Player.sendmsgEx(actor, "�ύ�ɹ�!")
    setflagstatus(actor, cfg.flag, 1)
    GeBuLinDeRuoDian.SyncResponse(actor)
end

--��������
function GeBuLinDeRuoDian.Request2(actor)
    if getflagstatus(actor,VarCfg["F_����_�粼�ֵ�����_�Ƿ�ȫ���ύ"]) == 1 then
        Player.sendmsgEx(actor, "���Ѿ���ȡ����!#249")
        return
    end
    local result = true
    for index, value in ipairs(config) do
        if getflagstatus(actor, value.flag) == 0 then
            result = false
            break
        end
    end
    if result then
        Player.giveItemByTable(actor, give, "�粼�ֵ�����", 1, true)
        -- setflagstatus(actor,VarCfg["F_����_�粼�ֵ�����_�Ƿ�ȫ���ύ"],1)
        FSetTaskRedPoint(actor, VarCfg["F_����_�粼�ֵ�����_�Ƿ�ȫ���ύ"], 47)
        Player.sendmsgEx(actor, "��ϲ����:|��ѩ���[װ��ʱװ]#249|��˫��ʹ��")
    else
        Player.sendmsgEx(actor, "��û���ύȫ��!#249")
    end
end

--ͬ����Ϣ
function GeBuLinDeRuoDian.SyncResponse(actor, logindatas)
    local data = {}
    local flag = getflagstatus(actor,VarCfg["F_����_�粼�ֵ�����_�Ƿ�ȫ���ύ"])
    for index, value in ipairs(config) do
        data[index] = getflagstatus(actor, value.flag)
    end
    local _login_data = { ssrNetMsgCfg.GeBuLinDeRuoDian_SyncResponse, flag, 0, 0, data }
    if logindatas then
        table.insert(logindatas, _login_data)
    else
        Message.sendmsg(actor, ssrNetMsgCfg.GeBuLinDeRuoDian_SyncResponse, flag, 0, 0, data)
    end
end

--��¼����
local function _onLoginEnd(actor, logindatas)
    GeBuLinDeRuoDian.SyncResponse(actor, logindatas)
end
--�¼��ɷ�
GameEvent.add(EventCfg.onLoginEnd, _onLoginEnd, GeBuLinDeRuoDian)
--ע��������Ϣ
Message.RegisterNetMsg(ssrNetMsgCfg.GeBuLinDeRuoDian, GeBuLinDeRuoDian)
return GeBuLinDeRuoDian

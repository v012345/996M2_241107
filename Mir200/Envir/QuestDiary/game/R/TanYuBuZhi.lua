local TanYuBuZhi = {}
TanYuBuZhi.ID = "̰����ֹ"
local npcID = 505
local config = include("QuestDiary/cfgcsv/cfg_TanYuBuZhi.lua") --����
local cost = {{}}
local give = {{}}
local equipName = "����ħ����ʹ[����]"
--��������
function TanYuBuZhi.Request(actor,index)
    if not FCheckNPCRange(actor, npcID, 15) then
        Player.sendmsgEx(actor, "����PNC̫Զ!#249")
        return
    end
    local cfg = config[index]
    if not cfg then
        Player.sendmsgEx(actor, "��������!#249")
        return
    end

    local obj = linkbodyitem(actor,16)
    local name = getiteminfo(actor,obj,ConstCfg.iteminfo.name)
    if equipName ~= name then
        Player.sendmsgEx(actor, "�ύʧ��,��û�д���"..equipName.."!#249")
        return
    end
    if getflagstatus(actor, cfg.flag) == 1 then
        Player.sendmsgEx(actor, "�����ύ����!#249")
        return
    end
    local cost = cfg.cost
    local name, num = Player.checkItemNumByTable(actor, cost)
    if name then
        Player.sendmsgEx(actor, string.format("���|%s#249|����|%d#249", name, num))
        return
    end
    Player.takeItemByTable(actor, cost, "ħ������")
    setflagstatus(actor, cfg.flag, 1)
    Player.sendmsgEx(actor,"���ɹ�!")
    TanYuBuZhi.SyncResponse(actor)
end
--ͬ����Ϣ
function TanYuBuZhi.SyncResponse(actor, logindatas)
    local data = {}
    local _login_data = {ssrNetMsgCfg.TanYuBuZhi_SyncResponse, 0, 0, 0, data}
    if logindatas then
        table.insert(logindatas, _login_data)
    else
        Message.sendmsg(actor, ssrNetMsgCfg.TanYuBuZhi_SyncResponse, 0, 0, 0, data)
    end
end
--��¼����
local function _onLoginEnd(actor, logindatas)
    TanYuBuZhi.SyncResponse(actor, logindatas)
end
--�¼��ɷ�
GameEvent.add(EventCfg.onLoginEnd, _onLoginEnd, TanYuBuZhi)
--ע��������Ϣ
Message.RegisterNetMsg(ssrNetMsgCfg.TanYuBuZhi, TanYuBuZhi)
return TanYuBuZhi
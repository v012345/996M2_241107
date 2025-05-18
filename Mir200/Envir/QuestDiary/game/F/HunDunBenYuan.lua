local HunDunBenYuan = {}
local config = include("QuestDiary/cfgcsv/cfg_HunDunBenYuan.lua") --����
-- ��ȡ����״̬
function HunDunBenYuan.CheckSwitchState(actor)
    local State1 = getplaydef(actor, VarCfg["N$���籾Դ����1"])
    local State2 = getplaydef(actor, VarCfg["N$���籾Դ����2"])
    local State3 = getplaydef(actor, VarCfg["N$���籾Դ����3"])
    local data = { State1, State2, State3 }
    return data
end
--�л�ѡȡ״̬��ť
function HunDunBenYuan.Switch(actor,var)
    local Switch = (var ~= 1) and (var ~= 2) and (var ~= 3)
    if Switch then return end
    local data = HunDunBenYuan.CheckSwitchState(actor)
    if data[var] == 0 then
        setplaydef(actor, VarCfg["N$���籾Դ����".. var ..""], 1)
    else
        setplaydef(actor, VarCfg["N$���籾Դ����".. var ..""], 0)
    end
    HunDunBenYuan.SyncResponse(actor)
end
--ִ�л���
function HunDunBenYuan.Request(actor)
    local data = HunDunBenYuan.CheckSwitchState(actor)
    local CheckData = (data[1] ~= 1) and (data[2] ~= 1) and (data[3] ~= 1)
    if CheckData then
        Player.sendmsgEx(actor, "��ʾ#251|:#255|�빴ѡ����������ֽ�...")
        return
    end
    local HunDunNum = 0
    local BagList = getbagitems(actor)                       --��ȡ��ұ�����������Ʒ����
    for _, v in ipairs(BagList) do                           --��������������Ʒ
        local ItemName = getiteminfo(actor, v, 7)            --��ȡ��Ʒ����
        if config[ItemName] then                             --��ѯ�Ƿ��ڱ���
            local cfg = config[ItemName]
            if data[cfg.Type] == 1 then
                HunDunNum = HunDunNum + cfg.AwardNum
                takeitem(actor, ItemName, 1, 0, "���籾Դ���տ۳�")
            end
        end
    end
    if HunDunNum > 0 then
        giveitem(actor, "���籾Դ", HunDunNum, 0, "���籾Դ���ս���")
        Player.sendmsgEx(actor, "��ʾ#251|:#255|�ֽ���|".. HunDunNum .."ö#249|���籾Դ...")
    else
        Player.sendmsgEx(actor, "��ʾ#251|:#255|������|û�пɻ���#249|����Ʒ...")
    end
end

--ע��������Ϣ
function HunDunBenYuan.SyncResponse(actor, logindatas)
    local data = HunDunBenYuan.CheckSwitchState(actor)
    local _login_data = { ssrNetMsgCfg.HunDunBenYuan_SyncResponse, 0, 0, 0, data }
    if logindatas then
        table.insert(logindatas, _login_data)
    else
        Message.sendmsg(actor, ssrNetMsgCfg.HunDunBenYuan_SyncResponse, 0, 0, 0, data)
    end
end
Message.RegisterNetMsg(ssrNetMsgCfg.HunDunBenYuan, HunDunBenYuan)

--��¼����
local function _onLoginEnd(actor, logindatas)
    HunDunBenYuan.SyncResponse(actor, logindatas)
end
GameEvent.add(EventCfg.onLoginEnd, _onLoginEnd, HunDunBenYuan)

return HunDunBenYuan

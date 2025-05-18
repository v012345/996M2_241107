local BeiFengYinDeFengYinGuanGuo = {}
BeiFengYinDeFengYinGuanGuo.ID = "����ӡ�ķ�ӡ���"
local npcID = 233
local config = include("QuestDiary/cfgcsv/cfg_BeiFengYinDeFengYinGuanGuo.lua") --������϶
local gives = {{"����ӡ�Ĺײ�", 1}}
--��ȡ1
function BeiFengYinDeFengYinGuanGuo.Request1(actor)
    local flag1 = getflagstatus(actor, VarCfg["F_����_����ӡ�ķ�ӡ���_�Ƿ���ȡ1"])
    if flag1 == 1 then
        FSetTaskRedPoint(actor, VarCfg["F_����ӡ�Ĺײ�ʹ��_���"], 12)
        Player.sendmsgEx(actor,"���Ѿ��������ȡ���ˣ������ظ���ȡ��#249")
        return
    end
    local skillMon1 = getplaydef(actor, VarCfg["U_����_����ӡ�ķ�ӡ���_ɱ��1"])
    if skillMon1 >= 400 then
        Player.giveItemByTable(actor, gives, "����ӡ�ķ�ӡ���", 1, true)
        setflagstatus(actor, VarCfg["F_����_����ӡ�ķ�ӡ���_�Ƿ���ȡ1"],1)
        Player.sendmsgEx(actor,"��ȡ�ɹ���")
        FSetTaskRedPoint(actor, VarCfg["F_����ӡ�Ĺײ�ʹ��_���"], 12)
        BeiFengYinDeFengYinGuanGuo.SyncResponse(actor)
    else
        Player.sendmsgEx(actor,"��ɱ���ﲻ��|400#249|��ȡʧ��!")
        return
    end

end
--��ȡ2
function BeiFengYinDeFengYinGuanGuo.Request2(actor)
    local flag2 = getflagstatus(actor, VarCfg["F_����_����ӡ�ķ�ӡ���_�Ƿ���ȡ2"])
    if flag2 == 1 then
        FSetTaskRedPoint(actor, VarCfg["F_����ӡ�Ĺײ�ʹ��_���"], 12)
        Player.sendmsgEx(actor,"���Ѿ��������ȡ���ˣ������ظ���ȡ��#249")
        return
    end
    local skillMon2 = getplaydef(actor, VarCfg["U_����_����ӡ�ķ�ӡ���_ɱ��2"])
    if skillMon2 >= 10 then
        Player.giveItemByTable(actor, gives, "����ӡ�ķ�ӡ���", 1, true)
        setflagstatus(actor, VarCfg["F_����_����ӡ�ķ�ӡ���_�Ƿ���ȡ2"],1)
        Player.sendmsgEx(actor,"��ȡ�ɹ���")
        FSetTaskRedPoint(actor, VarCfg["F_����ӡ�Ĺײ�ʹ��_���"], 12)
        BeiFengYinDeFengYinGuanGuo.SyncResponse(actor)
    else
        Player.sendmsgEx(actor,"��ɱ���ﲻ��|10#249|��ȡʧ��!")
        return
    end
end
--ͬ����Ϣ
function BeiFengYinDeFengYinGuanGuo.SyncResponse(actor)
    local skillMon1 = getplaydef(actor, VarCfg["U_����_����ӡ�ķ�ӡ���_ɱ��1"])
    local skillMon2 = getplaydef(actor, VarCfg["U_����_����ӡ�ķ�ӡ���_ɱ��2"])
    local flag1 = getflagstatus(actor, VarCfg["F_����_����ӡ�ķ�ӡ���_�Ƿ���ȡ1"])
    local flag2 = getflagstatus(actor, VarCfg["F_����_����ӡ�ķ�ӡ���_�Ƿ���ȡ2"])
    local data = {skillMon1, skillMon2}
    Message.sendmsg(actor, ssrNetMsgCfg.BeiFengYinDeFengYinGuanGuo_SyncResponse, flag1, flag2, 0, data)
end
-- --��¼����
-- local function _onLoginEnd(actor, logindatas)
--     BeiFengYinDeFengYinGuanGuo.SyncResponse(actor, logindatas)
-- end
-- --�¼��ɷ�
-- GameEvent.add(EventCfg.onLoginEnd, _onLoginEnd, BeiFengYinDeFengYinGuanGuo)
--ɱ�ִ���
local function _onKillMon(actor, monobj, monName)
    local cfg = config[monName]
    if cfg then
        local num = getplaydef(actor, cfg.var)
        if num < cfg.maxNum then
            setplaydef(actor, cfg.var, num + 1)
        end
    end
end
GameEvent.add(EventCfg.onKillMon, _onKillMon, BeiFengYinDeFengYinGuanGuo)
--ע��������Ϣ
Message.RegisterNetMsg(ssrNetMsgCfg.BeiFengYinDeFengYinGuanGuo, BeiFengYinDeFengYinGuanGuo)
return BeiFengYinDeFengYinGuanGuo

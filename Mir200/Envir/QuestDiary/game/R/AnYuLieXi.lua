local AnYuLieXi = {}
local npcID = 230
AnYuLieXi.ID = "������϶"
local config = include("QuestDiary/cfgcsv/cfg_AnYuLieXi.lua") --������϶
local varList = { [VarCfg["U_����_������϶_ɱ��1"]]=100, [VarCfg["U_����_������϶_ɱ��2"]]=100, [VarCfg["U_����_������϶_ɱ��3"]]=100, [VarCfg["U_����_������϶_ɱ��4"]]=5 }
--�ж��Ƿ���������ͼ����
function AnYuLieXi.CheckEnterMap(actor)
    local result = true
    for key, value in pairs(varList) do
        local num = getplaydef(actor,key)
        if num < value then
            result = false
            break
        end
    end
    return result
end
--����
function AnYuLieXi.Request1(actor)
    local flag = getflagstatus(actor, VarCfg["F_����_������϶"])
    if flag == 1 then
        Player.sendmsgEx(actor,"������϶��ͼ�Ѽ���!#249")
        return
    end
    local result = AnYuLieXi.CheckEnterMap(actor)
    if not result then
        Player.sendmsgEx(actor,"�㲻���㼤������!#249")
        return
    else
        setflagstatus(actor, VarCfg["F_����_������϶"],1)
        Player.sendmsgEx(actor,"��ϲ��ɹ��������϶��ͼ,��������ͼ���ɽ���!")
    end
end

--����
function AnYuLieXi.Request2(actor)
    local flag = getflagstatus(actor, VarCfg["F_����_������϶"])
    if flag == 0 then
        Player.sendmsgEx(actor,"��û�п�ͨ�����ͼȨ��,��ɾ�������󼴿ɽ���!#249")
        return
    end
    map(actor, "������϶")
end

function AnYuLieXi.SyncResponse(actor, logindatas)
    local skillMon1 = getplaydef(actor, VarCfg["U_����_������϶_ɱ��1"])
    local skillMon2 = getplaydef(actor, VarCfg["U_����_������϶_ɱ��2"])
    local skillMon3 = getplaydef(actor, VarCfg["U_����_������϶_ɱ��3"])
    local skillMon4 = getplaydef(actor, VarCfg["U_����_������϶_ɱ��4"])
    local data = { skillMon1, skillMon2, skillMon3, skillMon4 }
    local _login_data = { ssrNetMsgCfg.AnYuLieXi_SyncResponse, 0, 0, 0, data }
    if logindatas and type(logindatas) == "table" then
        table.insert(logindatas, _login_data)
    else
        Message.sendmsg(actor, ssrNetMsgCfg.AnYuLieXi_SyncResponse, 0, 0, 0, data)
    end
end

--��¼����
local function _onLoginEnd(actor, logindatas)
    AnYuLieXi.SyncResponse(actor, logindatas)
end
--�¼��ɷ�
GameEvent.add(EventCfg.onLoginEnd, _onLoginEnd, AnYuLieXi)

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
GameEvent.add(EventCfg.onKillMon, _onKillMon, AnYuLieXi)
--ע������
Message.RegisterNetMsg(ssrNetMsgCfg.AnYuLieXi, AnYuLieXi)
return AnYuLieXi

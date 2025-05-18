local JiFenDuiHuan = {}
JiFenDuiHuan.ID = "���ֶһ�"
local npcID = 127
local config = include("QuestDiary/cfgcsv/cfg_JiFenDuiHuan.lua") --����
local cost = { {} }
local give = { {} }
--��������
function JiFenDuiHuan.Request(actor, index)
    if not checkkuafu(actor) then
        return
    end
    local cfg = config[index]
    if not cfg then
        return
    end
    local itemName = cfg.item[1][1]
    local itemNum = cfg.item[1][2]
    local data = Player.getJsonTableByPlayVar(actor, "������ֶһ�")
    local obtainedCount = data[itemName] or 0 --��ȡ�Ѷһ�����
    local RemainingCount = cfg.max - obtainedCount
    if RemainingCount <= 0 then
        Player.sendmsgEx(actor, "�һ�ʧ��,���Ķһ���������!#249")
        return
    end
    local myPoint = getplaydef(actor, VarCfg["U_�������"])
    if myPoint < cfg.point then
        Player.sendmsgEx(actor, string.format("�һ�ʧ��,��Ļ��ֲ���|%d#249", cfg.point))
        return
    end

    Player.sendmsgEx(actor, string.format("�һ��ɹ�,���|%s*%d#249|�뵽�ʼ�����!", itemName, itemNum))
    local uid = Player.GetUUID(actor)
    Player.giveMailByTable(uid, 1, "������ֶһ�", "����ȡ���Ŀ�����ֶһ�����!", cfg.item, 1, true)
    setplaydef(actor, VarCfg["U_�������"], myPoint - cfg.point)
    --�ɹ�֮�� ���Ӵ���
    if data[itemName] then
        data[itemName] = data[itemName] + 1
    else
        data[itemName] = 1
    end
    Player.setJsonPlayVarByTable(actor, "������ֶһ�", data)
    JiFenDuiHuan.SyncResponse(actor)
end

function JiFenDuiHuan.OpenUI(actor)
    local data = Player.getJsonTableByPlayVar(actor, "������ֶһ�")
    local toDayPoint = getplaydef(actor, VarCfg["U_�����ʱ����"])
    local kuaFuPiont = getplaydef(actor, VarCfg["U_�������"])
    Message.sendmsg(actor, ssrNetMsgCfg.JiFenDuiHuan_OpenUI, toDayPoint, kuaFuPiont, 0, data)
end

--ͬ����Ϣ
function JiFenDuiHuan.SyncResponse(actor)
    local data = Player.getJsonTableByPlayVar(actor, "������ֶһ�")
    local toDayPoint = getplaydef(actor, VarCfg["U_�����ʱ����"])
    local kuaFuPiont = getplaydef(actor, VarCfg["U_�������"])
    Message.sendmsg(actor, ssrNetMsgCfg.JiFenDuiHuan_SyncResponse, toDayPoint, kuaFuPiont, 0, data)
end

--��������
local function _goPlayerVar(actor)
    FIniPlayVar(actor, "������ֶһ�", true)
end
GameEvent.add(EventCfg.goPlayerVar, _goPlayerVar, JiFenDuiHuan)

--ÿ��00��ִ��
local function _roBeforedawn(openday)
    local weekDayNumber = tonumber(os.date("%w"))
    if weekDayNumber == 1 then
        clearhumcustvar("*", "������ֶһ�")
    end
end
GameEvent.add(EventCfg.roBeforedawn, _roBeforedawn, JiFenDuiHuan)

local mobMap = {
    ["��������[����]"] = 10,
    ["˫������[����]"] = 20,
    ["��������[����]"] = 30,
    ["��������[����]"] = 40,
    ["��������[����]"] = 50,
    ["��������[����]"] = 80,
    ["��������[����]"] = 120,
    ["�˻�����[����]"] = 160,
    ["��������[����]"] = 200,
    ["ʮ������[����]"] = 240,
    ["��������[����]"] = 280,
    ["ǧɷ����[����]"] = 320,
    ["��������[����]"] = 360,
    ["��ڤ����[����]"] = 400,
    ["��������ۻ���������"] = 300,
    ["�������˵ۻ���������"] = 300,
    ["�������صۻ���������"] = 300,
    ["�������������������"] = 450,
}

local function _onKillMon(actor, monobj, monName)
    local point = mobMap[monName]
    if point then
        local toDayPoint = getplaydef(actor, VarCfg["U_�����ʱ����"])
        if toDayPoint < 1500 then
            local kuaFuPiont = getplaydef(actor, VarCfg["U_�������"])
            setplaydef(actor, VarCfg["U_�������"], kuaFuPiont + point)
            setplaydef(actor, VarCfg["U_�����ʱ����"], toDayPoint + point)
            Player.sendmsgEx(actor, "��ϲ��,��û��֣�"..point)
        else
            Player.sendmsgEx(actor, "������Ѿ��ﵽ1500��,�޷��ٻ�û���#249")
        end
    end
end

GameEvent.add(EventCfg.onKillMon, _onKillMon, JiFenDuiHuan)
--ע��������Ϣ
Message.RegisterNetMsg(ssrNetMsgCfg.JiFenDuiHuan, JiFenDuiHuan)
return JiFenDuiHuan

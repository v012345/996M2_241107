local DanChen = {}
DanChen.ID = "����"
local npcID = 504
local config = include("QuestDiary/cfgcsv/cfg_DanChen.lua") --����
local itemNames = {
    ["����Ҷ"] = 1,
    ["�����Ի�"] = 1,
    ["������֥"] = 1,
}
--������buff
local taskBuffId = 31036
--��������
function DanChen.OpenUI(actor)
    local flag1 = getflagstatus(actor, VarCfg["F_����_����_�ɼ������ȡ"])
    local flag2 = getflagstatus(actor, VarCfg["F_����_����_�ɼ��������"])
    local flag3 = getflagstatus(actor, VarCfg["F_����_����_��������"])
    local state = 1
    if flag1 == 1 and hasbuff(actor, taskBuffId) then
        state = 2 --��ȡ������ �� ������
    end
    if flag1 == 1 and not hasbuff(actor, taskBuffId) then
        state = 3 --����ʧ��
    end
    if flag2 == 1 then
        state = 4
    end
    if flag3 == 1 then
        state = 5
    end
    Message.sendmsg(actor, ssrNetMsgCfg.DanChen_OpenUI, state)
end

function DanChen.Request(actor, index)
    local cfg = config[index]
    if not cfg then
        Player.sendmsgEx(actor, "��������!#249")
        return
    end
    local cost = cfg.cost
    local name, num = Player.checkItemNumByTable(actor, cost)
    if name then
        Player.sendmsgEx(actor, string.format("���|%s#249|����|%d#249", name, num))
        return
    end
    Player.takeItemByTable(actor, cost, "��������")

    local quanzhong = table.concat(cfg.quanzhong, "|")
    local result1 = ransjstr(quanzhong, 1, 3)
    local give = { { result1, 1 } }
    Player.giveItemByTable(actor, give, "����", 1, true)
    Message.sendmsg(actor, ssrNetMsgCfg.DanChen_Success, 0, 0, 0, give)
    local num = getplaydef(actor, VarCfg["U_������������"])
    if num < 10 then
        setplaydef(actor, VarCfg["U_������������"], num + 1)
    end
    DanChen.SyncResponse(actor)
end

function dan_chen_cai_ji_jie_shu(actor)
    newdeletetask(actor, 201)
    messagebox(actor,"��Ǹ,���Ĳɼ�����ʧ����,���Ե������½(75,111)�ҵ�����,�ٴ���ȡ�ɼ�����")
end

local function receiveTask(actor)
    if hasbuff(actor, taskBuffId) then
        Player.sendmsgEx(actor, "���Ѿ���ȡ����,ץ��ʱ��ȥ��ɰ�")
        return
    end
    addbuff(actor, taskBuffId)
    local buffTime = getbuffinfo(actor, taskBuffId, 2)
    -- local buffNum = getbuffinfo(actor, taskBuffId, 1) - 1
    newchangetask(actor, 201, 0)
    sendcentermsg(actor, 250, 0, "����: {%d��/FCOLOR=249}����ɲɼ�����...", 0, buffTime, "@dan_chen_cai_ji_jie_shu")
    setflagstatus(actor, VarCfg["F_����_����_�ɼ������ȡ"], 1)
end
--��ȡ
function DanChen.ColleTask(actor)
    receiveTask(actor)
end

--����
function DanChen.Retry(actor)
    receiveTask(actor)
end

--����
function DanChen.GiveUp(actor)
    setflagstatus(actor, VarCfg["F_����_����_�ɼ������ȡ"], 0)
    Player.sendmsgEx(actor, "�����������!")
end

function DanChen.FinishTask(actor)
    if getflagstatus(actor, VarCfg["F_����_����_�ɼ��������"]) == 1 then
        setflagstatus(actor, VarCfg["F_����_����_��������"], 1)
        newdeletetask(actor, 201)
        DanChen.OpenUI(actor)
    else
        -- Player.sendmsgEx(actor, "??")
    end
end

--ͬ����Ϣ
function DanChen.SyncResponse(actor, logindatas)
    local data = {}
    local _login_data = { ssrNetMsgCfg.DanChen_SyncResponse, 0, 0, 0, data }
    if logindatas then
        table.insert(logindatas, _login_data)
    else
        Message.sendmsg(actor, ssrNetMsgCfg.DanChen_SyncResponse, 0, 0, 0, data)
    end
end

--��¼����
local function _onLoginEnd(actor, logindatas)
    if hasbuff(actor, taskBuffId) then
        local buffTime = getbuffinfo(actor, taskBuffId, 2)
        local buffNum = getbuffinfo(actor, taskBuffId, 1) - 1
        newchangetask(actor, 201, buffNum)
        sendcentermsg(actor, 250, 0, "����: {%d��/FCOLOR=249}����ɲɼ�����...", 0, buffTime)
    end
    if getflagstatus(actor, VarCfg["F_����_����_�ɼ��������"]) == 1 and getflagstatus(actor, VarCfg["F_����_����_��������"]) ~= 1 then
        newcompletetask(actor, 201)
    end
    DanChen.SyncResponse(actor, logindatas)
end
--�¼��ɷ�
GameEvent.add(EventCfg.onLoginEnd, _onLoginEnd, DanChen)

--�ɼ�����
local function _onCollectTask(actor, monName, monMakeIndex, itemName)
    if itemNames[itemName] then
        if hasbuff(actor, taskBuffId) then
            addbuff(actor, taskBuffId)
            local buffNum = getbuffinfo(actor, taskBuffId, 1) - 1
            newchangetask(actor, 201, buffNum)
            if buffNum >= 30 then
                setflagstatus(actor, VarCfg["F_����_����_�ɼ��������"], 1)
                FkfDelBuff(actor, taskBuffId)
                newcompletetask(actor, 201)
                confertitle(actor, "����ѧͽ")
                cleardelaygoto(actor, 1)
                messagebox(actor, "��ϲ���������,��óƺ�[����ѧͽ]")
            end
        end
    end
end

GameEvent.add(EventCfg.onCollectTask, _onCollectTask, DanChen)

--ע��������Ϣ
Message.RegisterNetMsg(ssrNetMsgCfg.DanChen, DanChen)
return DanChen

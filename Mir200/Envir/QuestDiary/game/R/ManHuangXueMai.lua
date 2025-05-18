local ManHuangXueMai = {}
ManHuangXueMai.ID = "����Ѫ��"
local npcID = 321
local config = include("QuestDiary/cfgcsv/cfg_ManHuangXueMai.lua") --����
local cost1 = { { "����ˮ��", 100 }, { "���", 100 } }
local cost2 = { { "����ͼ��", 66 }, { "���", 18880000 } }
-- ��װһ����������1�����鳤��֮���������һ�����������ų�ָ��������
local function randomIndexExclude(maxIndex, excludeIndex)
    local randomIdx = math.random(1, maxIndex)
    while randomIdx == excludeIndex do
        randomIdx = math.random(1, maxIndex)
    end
    return randomIdx
end
--�����ֵ
local function initializeAndIncrement(actor, exclude)
    local data = Player.getJsonTableByVar(actor, VarCfg["T_����Ѫ��ϴ��"])
    --��ʼ��
    if #data == 0 then
        data = { 0, 0, 0, 0, 0, 0, 0, 0 }
    end
    local randomIndex
    if exclude == 0 or not exclude then
        randomIndex = math.random(1, #data)
        data[randomIndex] = data[randomIndex] + 1
        local cfg = config[randomIndex] or {}
        local name = cfg.name or ""
        Player.sendmsgEx(actor, string.format("���ѳɹ�|%s%s#249", name, "+1%"))
    else
        randomIndex = randomIndexExclude(#data, exclude)
        data[randomIndex] = data[randomIndex] + 1
        data[exclude] = data[exclude] - 1
        local cfg = config[randomIndex] or {}
        local name = cfg.name or ""
        local currCfg = config[exclude] or {}
        local currName = currCfg.name or ""
        Player.sendmsgEx(actor, string.format("ϴ���ɹ�|%s%s#249|��|%s%s#249", name, "+1%",currName,"-1%"))
    end
    Player.setJsonVarByTable(actor, VarCfg["T_����Ѫ��ϴ��"], data)
    Player.setAttList(actor, "���Ը���")
end
--��������
function ManHuangXueMai.Request1(actor, arg1)
    if not FCheckNPCRange(actor, npcID, 15) then
        Player.sendmsgEx(actor, "����PNC̫Զ!#249")
        return
    end
    if arg1 > 8 or type(arg1) ~= "number" then
        Player.sendmsgEx(actor, "��������!#249")
        return
    end
    if arg1 == 0 then
        Player.sendmsgEx(actor, "�빴ѡҪϴ��������!#249")
        return
    end
    local cfg = config[arg1] or {}
    if arg1 ~= 0 then
        local data = Player.getJsonTableByVar(actor, VarCfg["T_����Ѫ��ϴ��"])
        if data[arg1] == 0 or not data[arg1] then
            local name = cfg.name or ""
            Player.sendmsgEx(actor,name .. "#249|����Ϊ0,�޷�ϴ��!#250")
            return
        end
    end
    
    local name, num = Player.checkItemNumByTable(actor, cost1)
    if name then
        Player.sendmsgEx(actor, string.format("���|%s#249|����|%d#249", name, num))
        return
    end
    Player.takeItemByTable(actor, cost1, "����Ѫ������")
    initializeAndIncrement(actor, arg1)
    ManHuangXueMai.SyncResponse(actor)
end

function ManHuangXueMai.Request2(actor)
    if not FCheckNPCRange(actor, npcID, 15) then
        Player.sendmsgEx(actor, "����PNC̫Զ!#249")
        return
    end
    local count = getplaydef(actor, VarCfg["U_����_����Ѫ��_���Ѵ���"])
    if count >= 10 then
        Player.sendmsgEx(actor, "���ֻ�ܾ���10��!#249")
        return
    end
    local name, num = Player.checkItemNumByTable(actor, cost2)
    if name then
        Player.sendmsgEx(actor, string.format("���|%s#249|����|%d#249", name, num))
        return
    end
    Player.takeItemByTable(actor, cost2, "����Ѫ������")
    setplaydef(actor, VarCfg["U_����_����Ѫ��_���Ѵ���"], count + 1)
    if count + 1 == 1 then
        local taskPanelID = getplaydef(actor, VarCfg["U_��������������"])
        if taskPanelID == 21 then
            FCheckTaskRedPoint(actor)
        end
    end
    --�����
    initializeAndIncrement(actor)
    ManHuangXueMai.SyncResponse(actor)
end

--ͬ����Ϣ
function ManHuangXueMai.SyncResponse(actor, logindatas)
    local count = getplaydef(actor, VarCfg["U_����_����Ѫ��_���Ѵ���"])
    local data = Player.getJsonTableByVar(actor, VarCfg["T_����Ѫ��ϴ��"])
    local _login_data = { ssrNetMsgCfg.ManHuangXueMai_SyncResponse, count, 0, 0, data }
    if logindatas then
        table.insert(logindatas, _login_data)
    else
        Message.sendmsg(actor, ssrNetMsgCfg.ManHuangXueMai_SyncResponse, count, 0, 0, data)
    end
end

--��������
local function _onCalcAttr(actor, attrs)
    local data = Player.getJsonTableByVar(actor, VarCfg["T_����Ѫ��ϴ��"])
    if #data == 0 then
        return
    end
    local shuxing = {}
    for index, value in ipairs(config) do
        local attValue = 0
        if value.type == 2 then
            attValue = (data[index] or 0) * 100
        else
            attValue = data[index] or 0
        end
        shuxing[value.attrId] = attValue
    end
    calcAtts(attrs, shuxing, "����_����Ѫ��")
end
--����
GameEvent.add(EventCfg.onCalcAttr, _onCalcAttr, ManHuangXueMai)

--��¼����
local function _onLoginEnd(actor, logindatas)
    ManHuangXueMai.SyncResponse(actor, logindatas)
end
--�¼��ɷ�
GameEvent.add(EventCfg.onLoginEnd, _onLoginEnd, ManHuangXueMai)
--ע��������Ϣ
Message.RegisterNetMsg(ssrNetMsgCfg.ManHuangXueMai, ManHuangXueMai)
return ManHuangXueMai

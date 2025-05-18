local ShenMoZhiTi = {}
local config = include("QuestDiary/cfgcsv/cfg_ShenMoZhiTi.lua") --����ħ����
local success = 50
local allMaxCost = { { "���", 2888 } }

--ȫ��������
local function steMaxLevel(actor)
    for _, value in ipairs(config) do
        setplaydef(actor, value.bindVar, value.maxLevel)
    end
    Player.sendmsgEx(actor, "��ϲ,�����ħ֮��ȫ��������!")
    Player.setAttList(actor, "���Ը���")
    ShenMoZhiTi.giveTitle(actor)
    ShenMoZhiTi.SyncResponse(actor)
end

--������������
local function checkMaxLevel(actor)
    local  isCanAllMax, name = ShenMoZhiTi.IsCanAllMax(actor)
    if not isCanAllMax then
        messagebox(actor,"������������Ѿ�����1000��,�����["..name.."]������������10,�޷�ȫ��,��������10���Ժ�,�ٴ���������ȫ��!")
        return
    end
    Player.sendmsgEx(actor, "��ϲ,������������Ѿ�����1000��,�����ħȫ��!")
    steMaxLevel(actor)
end

function ShenMoZhiTi.Request(actor, arg1)
    local cfg = config[arg1]
    if not cfg then
        Player.sendmsgEx(actor, "��������1!")
        return
    end
    --��ǰ�ȼ�
    local currLevel = getplaydef(actor, cfg.bindVar)
    if currLevel < 10 then
        Player.sendmsgEx(actor, "��ǰ����С��10��,�޷�����,�뵽һ��½[��������]������10��")
        return
    end
    if currLevel >= cfg.maxLevel then
        Player.sendmsgEx(actor, string.format("���|%s#249|�Ѿ��ﵽ|%d��#249|��...", cfg.name, cfg.maxLevel))
        return
    end
    local currCount = getplaydef(actor, VarCfg["U_��ħ_��������"])
    if currCount >= 999 then
        checkMaxLevel(actor)
        return
    end
    
    local name, num = Player.checkItemNumByTable(actor, cfg.cost)
    if name then
        Player.sendmsgEx(actor, string.format("�㱳����|%s#249|����|%d#249|...", name, num))
        return
    end
    if randomex(success) then
        Player.takeItemByTable(actor, cfg.cost, "������������ħ�ɹ�")
        setplaydef(actor, cfg.bindVar, currLevel + 1)
        Player.sendmsgEx(actor, "#255|��ϲ,���|" .. cfg.name .. "#249|�ﵽ��|" .. getplaydef(actor, cfg.bindVar) .. "��#249|ʵ������һ��...")
        ShenMoZhiTi.giveTitle(actor)
        ShenMoZhiTi.SyncResponse(actor)
        Player.setAttList(actor, "���Ը���")
    else
        Player.takeItemByTable(actor, cfg.cost, "������������ħʧ��")
        if currLevel <= 10 then
            Player.sendmsgEx(actor, "���|" .. cfg.name .. "#249|����|ʧ��#249|���Ͽ۳�,�ɴ˵�ǰ��������Ϊ10,���۴���...")
        else
            setplaydef(actor, cfg.bindVar, currLevel - 1)
            Player.sendmsgEx(actor, "���|" .. cfg.name .. "#249|����|ʧ��#249|���Ͽ۳�,�ȼ�-1...")
        end
    end
    setplaydef(actor, VarCfg["U_��ħ_��������"], getplaydef(actor, VarCfg["U_��ħ_��������"]) + 1)
    ShenMoZhiTi.SyncResponse(actor)
end

function ShenMoZhiTi.ButtonLink1(actor)
    local  isCanAllMax, name = ShenMoZhiTi.IsCanAllMax(actor)
    if not isCanAllMax then
        Player.sendmsgEx(actor, "ȫ������10�����ϲſ���һ��ȫ��...")
        return
    end
    -- if not checktitle(actor,"��ħ�����") then
    --     Player.sendmsgEx(actor, "ȫ������|10#249|������,����ӵ��|��ħ�����#249|�ƺŲſ���һ��ȫ��...")
    --     return
    -- end
    local isMax = ShenMoZhiTi.CheckAllMaxLevel(actor)
    if isMax then
        Player.sendmsgEx(actor, "�����ħ֮���Ѿ�ȫ��������...")
        return
    end
    local name, num = Player.checkItemNumByTable(actor, allMaxCost)
    if name then
        Player.sendmsgEx(actor, string.format("���|%s#249|����|%d#249|...", name, num))
        return
    end
    Player.takeItemByTable(actor, allMaxCost, "��ħ֮�����ħһ��ȫ��")
    steMaxLevel(actor)
end


--ȫ���������������ƺţ�
function ShenMoZhiTi.giveTitle(actor)
    if checktitle(actor, "��ħ������") then
        return
    end
    local isMax = ShenMoZhiTi.CheckAllMaxLevel(actor)
    if isMax then
        deprivetitle(actor, "��ħ�����")
        confertitle(actor, "��ħ������", 1)
        Player.setAttList(actor, "���ٸ���")
        messagebox(actor, "��ϲ,�����ħ֮��ȫ��������,��óƺ�[��ħ������]")
        return
    end
end


--�����ħ�Ƿ��Ѿ�ȫ������
function ShenMoZhiTi.CheckAllMaxLevel(actor)
    for _, value in ipairs(config) do
        if getplaydef(actor, value.bindVar) < value.maxLevel then
            return false
        end
    end
    return true
end

--����Ƿ����һ��ȫ��
--���Է���true
function ShenMoZhiTi.IsCanAllMax(actor)
    for _, value in ipairs(config) do
        if getplaydef(actor, value.bindVar) < 10 then
            return false,value.name
        end
    end
    return true,""
end


local function _onCalcAttackSpeed(actor, attackSpeeds)
    if checktitle(actor,"��ħ������") then
        attackSpeeds[1] = attackSpeeds[1] + 20
    end
end
GameEvent.add(EventCfg.onCalcAttackSpeed, _onCalcAttackSpeed, ShenMoZhiTi)




--ע��������Ϣ
Message.RegisterNetMsg(ssrNetMsgCfg.ShenMoZhiTi, ShenMoZhiTi)

function ShenMoZhiTi.SyncResponse(actor, logindatas)
    local U101 = getplaydef(actor,VarCfg["U_��ħ_����һ��"])
    local U102 = getplaydef(actor,VarCfg["U_��ħ_�˺�����"])
    local U103 = getplaydef(actor,VarCfg["U_��ħ_����֮��"])
    local U104 = getplaydef(actor,VarCfg["U_��ħ_��������"])
    local U105 = getplaydef(actor,VarCfg["U_��ħ_Ѫţ����"])
    local U100 = getplaydef(actor,VarCfg["U_��ħ_��������"])

    local data = {U101,U102,U103,U104,U105}

    local _login_data = {ssrNetMsgCfg.ShenMoZhiTi_SyncResponse, U100, 0, 0, data}
    if logindatas then
        table.insert(logindatas, _login_data)
    else
        Message.sendmsg(actor, ssrNetMsgCfg.ShenMoZhiTi_SyncResponse, U100, 0, 0, data)
    end
end

--��¼����
local function _onLoginEnd(actor, logindatas)
    ShenMoZhiTi.SyncResponse(actor, logindatas)
end
GameEvent.add(EventCfg.onLoginEnd, _onLoginEnd, ShenMoZhiTi)

return ShenMoZhiTi

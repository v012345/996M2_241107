local TiZhiXiuLian = {}
local randomdata = { 100, 30, 30, 30, 30, 30, 30, 30, 20, 20 }
local config = include("QuestDiary/cfgcsv/cfg_TiZhiXiuLian.lua") --С��ħ����
local allMaxCost = { { "Ԫ��", 1000000 } }

function TiZhiXiuLian.Request(actor, arg1)
    local cfg = config[arg1]
    if not cfg then
        Player.sendmsgEx(actor, "��������1!")
        return
    end
    --��ǰ�ȼ�
    local currLevel = getplaydef(actor, cfg.bindVar)
    if currLevel >= cfg.maxLevel then
        Player.sendmsgEx(actor, string.format("���|%s#249|�Ѿ��ﵽ|%d��#249|��...", cfg.name, cfg.maxLevel))
        return
    end
    local name, num = Player.checkItemNumByTable(actor, cfg.cost)
    if name then
        Player.sendmsgEx(actor, string.format("�㱳����|%s#249|����|%d#249|...", name, num))
        return
    end
    local success = randomdata[currLevel + 1]
    if randomex(success) then
        Player.takeItemByTable(actor, cfg.cost, "��������С��ħ�ɹ�")
        setplaydef(actor, cfg.bindVar, currLevel + 1)
        Player.sendmsgEx(actor, "#255|��ϲ,���|" .. cfg.name .. "#249|�ﵽ��|" .. getplaydef(actor, cfg.bindVar) .. "��#249|ʵ������һ��...")
        TiZhiXiuLian.giveTitle(actor)
        TiZhiXiuLian.SyncResponse(actor)
        Player.setAttList(actor, "���Ը���")
    else
        Player.takeItemByTable(actor, cfg.cost, "��������С��ħʧ��")
        Player.sendmsgEx(actor, "���|" .. cfg.name .. "#249|����|ʧ��#249|���Ͽ۳�...")
    end
end

function TiZhiXiuLian.ButtonLink1(actor)
    local isMax = TiZhiXiuLian.CheckAllMaxLevel(actor)
    if isMax then
        Player.sendmsgEx(actor, "������������Ѿ�ȫ��������...")
        return
    end
    local name, num = Player.checkItemNumByTable(actor, allMaxCost)
    if name then
        Player.sendmsgEx(actor, string.format("���|%s#249|����|%d#249|...", name, num))
        return
    end
    Player.takeItemByTable(actor, allMaxCost, "��������С��ħһ��ȫ��")
    for _, value in ipairs(config) do
        local currLevel = getplaydef(actor, value.bindVar)
        --С�����ȼ����ȫ������ñ����ã�
        if currLevel < value.maxLevel then
            setplaydef(actor, value.bindVar, value.maxLevel)
        end
    end
    Player.sendmsgEx(actor, "��ϲ,�����������ȫ��������!")
    Player.setAttList(actor, "���Ը���")
    TiZhiXiuLian.giveTitle(actor)
    TiZhiXiuLian.SyncResponse(actor)
end

--ȫ���������������ƺţ�
function TiZhiXiuLian.giveTitle(actor)
    if checktitle(actor, "��ħ�����") then
        return
    end
    local isMax = TiZhiXiuLian.CheckAllMaxLevel(actor)
    if isMax then
        confertitle(actor, "��ħ�����", 1)
        messagebox(actor, "��ϲ,�����������ȫ��������,��óƺ�[��ħ�����]")
        Player.setAttList(actor, "���Ը���")
        Player.setAttList(actor, "���ʸ���")
        GameEvent.push(EventCfg.onTiZhiXiuLianUP, actor)
        return
    end
end

--�����ħ�Ƿ��Ѿ�ȫ������
function TiZhiXiuLian.CheckAllMaxLevel(actor)
    for _, value in ipairs(config) do
        if getplaydef(actor, value.bindVar) < value.maxLevel then
            return false
        end
    end
    return true
end

--ע��������Ϣ
function TiZhiXiuLian.SyncResponse(actor, logindatas)
    local U101 = getplaydef(actor, VarCfg["U_��ħ_����һ��"])
    local U102 = getplaydef(actor, VarCfg["U_��ħ_�˺�����"])
    local U103 = getplaydef(actor, VarCfg["U_��ħ_����֮��"])
    local U104 = getplaydef(actor, VarCfg["U_��ħ_��������"])
    local U105 = getplaydef(actor, VarCfg["U_��ħ_Ѫţ����"])
    local data = { U101, U102, U103, U104, U105 }
    local _login_data = { ssrNetMsgCfg.TiZhiXiuLian_SyncResponse, 0, 0, 0, data }
    if logindatas then
        table.insert(logindatas, _login_data)
    else
        Message.sendmsg(actor, ssrNetMsgCfg.TiZhiXiuLian_SyncResponse, 0, 0, 0, data)
    end
end
Message.RegisterNetMsg(ssrNetMsgCfg.TiZhiXiuLian, TiZhiXiuLian)

--��������
local function _onCalcAttr(actor, attrs)
    local shuxing = {}
    for _, value in ipairs(config) do
        local currLevel = getplaydef(actor, value.bindVar)
        if currLevel > 0 then
            shuxing[value.attrID] = currLevel
        end
    end
    calcAtts(attrs, shuxing, "С��ħ����")
end
--����
GameEvent.add(EventCfg.onCalcAttr, _onCalcAttr, TiZhiXiuLian)

--��¼����
local function _onLoginEnd(actor, logindatas)
    TiZhiXiuLian.SyncResponse(actor, logindatas)
end
GameEvent.add(EventCfg.onLoginEnd, _onLoginEnd, TiZhiXiuLian)

return TiZhiXiuLian

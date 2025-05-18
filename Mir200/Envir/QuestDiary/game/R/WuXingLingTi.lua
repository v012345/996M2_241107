local WuXingLingTi = {}
WuXingLingTi.ID = "��������"
local npcID = 502
local config = include("QuestDiary/cfgcsv/cfg_WuXingLingTi.lua") --����
local give = { { "���о��鵤", 1 } }
--Ԫ������
function WuXingLingTi.Request1(actor, index)
    local cfg = config[index]
    if not cfg then
        Player.sendmsgEx(actor, "��������#249")
        return
    end
    local count = getplaydef(actor, cfg.var)
    if count >= 10 then
        Player.sendmsgEx(actor, string.format("���|%s����#249|�Ѿ�������", cfg.name))
        return
    end
    local cost = cfg.ybcost
    local name, num = Player.checkItemNumByTable(actor, cost)
    if name then
        Player.sendmsgEx(actor, string.format("���|%s#249|����|%d#249", name, num))
        return
    end
    Player.takeItemByTable(actor, cost, "��������")
    if randomex(30) then
        setplaydef(actor, cfg.var, count + 1)
        Player.sendmsgEx(actor, string.format("%s����#249|�����ɹ�|%s#249", cfg.name, cfg.attrName))
        setflagstatus(actor,VarCfg["F_������������һ��"],1)
        Player.setAttList(actor, "���Ը���")
    else
        Player.sendmsgEx(actor, "����ʧ��#249")
    end
    WuXingLingTi.SyncResponse(actor)
end

--�������
function WuXingLingTi.Request2(actor, index)
    local cfg = config[index]
    if not cfg then
        Player.sendmsgEx(actor, "��������#249")
        return
    end
    local count = getplaydef(actor, cfg.var)
    if count >= 10 then
        Player.sendmsgEx(actor, string.format("���|%s����#249|�Ѿ�������", cfg.name))
        return
    end
    local cost = cfg.lfcost
    local name, num = Player.checkItemNumByTable(actor, cost)
    if name then
        Player.sendmsgEx(actor, string.format("���|%s#249|����|%d#249", name, num))
        return
    end
    Player.takeItemByTable(actor, cost, "��������")
    setplaydef(actor, cfg.var, count + 1)
    -- setflagstatus(actor,VarCfg["F_������������һ��"],1)
    FSetTaskRedPoint(actor, VarCfg["F_������������һ��"], 46)
    Player.sendmsgEx(actor, string.format("%s����#249|�����ɹ�|%s#249", cfg.name, cfg.attrName))
    Player.setAttList(actor, "���Ը���")
    WuXingLingTi.SyncResponse(actor)
end

function WuXingLingTi.Request3(actor)
    if checktitle(actor, "��������") then
        Player.sendmsgEx(actor, "���Ѿ���ȡ����!#249")
        return
    end
    local result = true
    for _, value in ipairs(config) do
        if getplaydef(actor, value.var) < 10 then
            result = false
            break
        end
    end
    if result then
        if not Bag.checkBagEmptyNum(actor, 5) then
            Player.sendmsgEx(actor, "��ı������Ӳ���,��������5���ո�!#249")
            return
        end
        confertitle(actor, "��������")
        Player.giveItemByTable(actor, give, "������������", 1, true)
        Player.sendmsgEx(actor, "��ȡ�ɹ�!")
        WuXingLingTi.SyncResponse(actor)
    else
        Player.sendmsgEx(actor, "�㻹û��ȫ��������10��!#249")
    end
end

--ͬ����Ϣ
function WuXingLingTi.SyncResponse(actor, logindatas)
    local data = {}
    for index, value in ipairs(config) do
        data[index] = getplaydef(actor, value.var)
    end
    local _login_data = { ssrNetMsgCfg.WuXingLingTi_SyncResponse, 0, 0, 0, data }
    if logindatas then
        table.insert(logindatas, _login_data)
    else
        Message.sendmsg(actor, ssrNetMsgCfg.WuXingLingTi_SyncResponse, 0, 0, 0, data)
    end
end

local function _onCalcAttr(actor, attrs)
    local shuxing = {}
    for _, value in ipairs(config) do
        local count = getplaydef(actor, value.var)
        if count > 0 then
            for _, v in ipairs(value.attrs or {}) do
                shuxing[v] = count * value.num
            end
        end
    end
    calcAtts(attrs, shuxing, "��������")
end
--����
GameEvent.add(EventCfg.onCalcAttr, _onCalcAttr, WuXingLingTi)

--��¼����
local function _onLoginEnd(actor, logindatas)
    WuXingLingTi.SyncResponse(actor, logindatas)
end
--�¼��ɷ�
GameEvent.add(EventCfg.onLoginEnd, _onLoginEnd, WuXingLingTi)
--ע��������Ϣ
Message.RegisterNetMsg(ssrNetMsgCfg.WuXingLingTi, WuXingLingTi)
return WuXingLingTi

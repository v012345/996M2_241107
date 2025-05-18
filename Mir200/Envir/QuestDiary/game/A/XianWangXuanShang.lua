local XianWangXuanShang = {}
XianWangXuanShang.ID = "��������"
local npcID = 3473
local mapID = "xianwang"
local config = include("QuestDiary/cfgcsv/cfg_XianWangXuanShang.lua") --����
local MmonCfg = {}
for _, value in ipairs(config) do
    MmonCfg[value.monName] = value
end
-- dump(MmonCfg)
local cost = { {} }
local give = { {} }
local function getJvar(actor, var)
    local result = 0
    --����ǵ�һ������
    if var == "J25" and getplaydef(actor, var) == 0 then
        result = 1
    else
        result = getplaydef(actor, var)
    end
    return result
end

--��ȡ����
local function GetData(actor)
    local data = {}
    for _, value in ipairs(config) do
        local numVar = getplaydef(actor, value.numVar) or 0
        local stateVar = getJvar(actor, value.stateVar)
        local tmp = { num = numVar, state = stateVar, max = value.max }
        table.insert(data, tmp)
    end
    return data
end
--��������
function XianWangXuanShang.Request(actor, index)
    local cfg = config[index]
    if not cfg then
        Player.sendmsgEx(actor, "��������1��#249")
        return
    end
    local stat = getJvar(actor, cfg.stateVar)

    if stat == 0 then
        local cost = cfg.cost
        if not cost then
            Player.sendmsgEx(actor, "��������2��#249")
            return
        end
        local name, num = Player.checkItemNumByTable(actor, cost)
        if name then
            Player.sendmsgEx(actor, string.format("��ȡ����ʧ�ܣ����|%s#249|����|%d#249", name, num))
            return
        end
        Player.takeItemByTable(actor, cost, "��ȡ��������")
        setplaydef(actor, cfg.stateVar, 1)
        XianWangXuanShang.SyncResponse(actor)
        Player.sendmsgEx(actor, string.format("��ȡ��ɱ|%s#249|����ɹ�", cfg.monName))
    elseif stat == 2 then
        local mailTitle = "���������������"
        local mailContent = "��ϲ�����������������������ȡ���Ľ���"
        local usetId = getbaseinfo(actor, ConstCfg.gbase.id)
        Player.giveMailByTable(usetId,1, mailTitle, mailContent,cfg.give,1,true)
        setplaydef(actor, cfg.stateVar, 3)
        Player.sendmsgEx(actor, "�����ѷ��ͣ��뵽����鿴!")
        XianWangXuanShang.SyncResponse(actor)
    elseif stat == 3 then
        Player.sendmsgEx(actor, "���Ѿ���ȡ����!")
    end
end

function XianWangXuanShang.OpenUI(actor)
    local data = GetData(actor)
    Message.sendmsg(actor, ssrNetMsgCfg.XianWangXuanShang_OpenUI, 0, 0, 0, data)
end

--ͬ����Ϣ
function XianWangXuanShang.SyncResponse(actor)
    local data = GetData(actor)
    Message.sendmsg(actor, ssrNetMsgCfg.XianWangXuanShang_SyncResponse, 0, 0, 0, data)
end

-- --��¼����
-- local function _onLoginEnd(actor, logindatas)
--     XianWangXuanShang.SyncResponse(actor, logindatas)
-- end
-- --�¼��ɷ�
-- GameEvent.add(EventCfg.onLoginEnd, _onLoginEnd, XianWangXuanShang)

local function _onKillMon(actor, monobj, monName)
    if FCheckMap(actor, mapID) then
        local renYiNum = getplaydef(actor, "J24") --�������
        if (renYiNum + 1) < 51 then
            setplaydef(actor, "J24", renYiNum + 1)
        elseif getJvar(actor, "J25") == 1 then
            setplaydef(actor, "J25", 2)
        end
        local cfg = MmonCfg[monName]
        if cfg then
            if getplaydef(actor, cfg.stateVar) == 1 then
                local num = getplaydef(actor, cfg.numVar) --ָ������
                setplaydef(actor, cfg.numVar, num + 1)    --����
                if (num + 1) >= cfg.max then
                    setplaydef(actor, cfg.stateVar, 2)
                end
            end
        end
    end
end
GameEvent.add(EventCfg.onKillMon, _onKillMon, XianWangXuanShang)

--ע��������Ϣ
Message.RegisterNetMsg(ssrNetMsgCfg.XianWangXuanShang, XianWangXuanShang)
return XianWangXuanShang

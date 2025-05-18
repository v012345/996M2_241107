local LongHaiYiJi = {}
LongHaiYiJi.ID = "�����ż�"
local npcID = 154
--local config = include("QuestDiary/cfgcsv/cfg_LongHaiYiJi.lua") --����
local cost = { {} }
local give = { {} }
local mapID1 = "����Ĺ"
local mapID2 = "�����ż�"
local mons = {
    "��������ۻ���������",
    "�������˵ۻ���������",
    "�������صۻ���������",
}

local bibao = {
    "�����Ƭ",
    "�����Ƭ",
    "�����Ƭ",
    "�����Ƭ",
    "�����Ƭ",
    "�����Ƭ",
    "�����Ƭ",
    "�����Ƭ",
    "�����Ƭ",
    "�����Ƭ",
    "���籾Դ",
    "���籾Դ",
    "���籾Դ",
    "1Ԫ��ֵ���",
    "1Ԫ��ֵ���",
    "1Ԫ��ֵ���",
    "1Ԫ��ֵ���",
    "1Ԫ��ֵ���",
    "1Ԫ��ֵ���",
    "1Ԫ��ֵ���",
    "1Ԫ��ֵ���",
    "1Ԫ��ֵ���",
    "1Ԫ��ֵ���",
    "10000Ԫ��",
    "10000Ԫ��",
    "10000Ԫ��",
    "10000Ԫ��",
    "10000Ԫ��",
    "10000Ԫ��",
    "10000Ԫ��",
    "10000Ԫ��",
    "10000Ԫ��",
}

local suiji = {
    "���°Գ�",
    "����",
    "���˳�",
    "ǧ���",
    "��ڤ֮��",
    "����ӻ�",
    "ڤ��֮��",
    "���Կ־�",
    "��Ӱ֮��",
    "���˹�",
    "��Ȫ֮��",
    "��ҫ�����֮Ӱ",
    "ҹħ֮��",
    "ҹ����ߡ���",
    "��������",
    "�����ֻ�",
    "��ľ֮ͫ",
    "��ɷѪ�",
    "����֮��",
    "���֮ѥ",
    "�������",
    "����֮��",
    "����֮��",
    "��������",
    "����õ��",
    "��ͷ̨",
    "��˪֮��",
    "ҹ��֮��",
    "�����׹",
    "����֮��",
    "��յ���·��",
    "����֮��",
    "˺�������",
    "��Դ֮��",
    "Ԫ������",
    "����ͷ��",
    "Ѫɫ֮��",
    "ʱ���ɳ©",
    "����ӡ�Ľ���",
    "�����ߵ��ؼ�",
    "����֮�񱦲�",
    "����ʹ������",
    "�ֻؾ�",
    "�ƿذ���"
}

local function _getBossCount()
    local idx1 = tonumber(getdbmonfieldvalue("��������ۻ���������", "idx")) or 0
    local idx2 = tonumber(getdbmonfieldvalue("�������˵ۻ���������", "idx")) or 0
    local idx3 = tonumber(getdbmonfieldvalue("�������صۻ���������", "idx")) or 0
    local data = {}
    data[1] = getmoncount(mapID1,idx1,true)
    data[2] = getmoncount(mapID1,idx2,true)
    data[3] = getmoncount(mapID1,idx3,true)
    return data
end

local function _onLongHaiYiJiEnter(actor)
    local data = _getBossCount()
    for index, value in ipairs(data) do
        if value == 1 then
            Player.sendmsgEx(actor, string.format("�����ͼʧ��|%s#249|û�б���ɱ!",mons[index]))
            return
        end
    end
    local name = getbaseinfo(actor, ConstCfg.gbase.name)
    sendmsg("0", 2, '{"Msg":"[' .. name .. ']���������ż�","FColor":251,"BColor":0,"Type":6,"Time":6,"SendName":"ϵͳ��","SendId":"123","X":"-300"}')
    map(actor, "�����ż�")
end
GameEvent.add(EventCfg.onLongHaiYiJiEnter, _onLongHaiYiJiEnter, LongHaiYiJi)
--��������
function LongHaiYiJi.Request(actor)
    local isKangBao = getflagstatus(actor, VarCfg.F_is_open_kuangbao) --�Ƿ�����֮��
    if isKangBao == 0 then
        Player.sendmsgEx(actor, "�����ͼʧ�ܣ���û�п�����֮����#249")
        return
    end
    local power = Player.GetPower(actor)
    if power < 50000000 then
        Player.sendmsgEx(actor, "�����ͼʧ�ܣ����ս������5000W��#249")
        return
    end
    local isTime1 = isTimeInRange(10, 15, 14, 16)
    local isTime2 = isTimeInRange(22, 15, 23, 16)
    if not isTime1 and not isTime2 then
        Player.sendmsgEx(actor, "���ڿ���ʱ��,��ֹ���룡#249")
        return
    end
    FBenFuToKuaFuEvent(actor, EventCfg.onLongHaiYiJiEnter, "")
end

local function _onLongHaiYiJiSync(actor)
    local data = _getBossCount()
    Message.sendmsg(actor, ssrNetMsgCfg.LongHaiYiJi_Sync, 0, 0, 0, data)
end
GameEvent.add(EventCfg.onLongHaiYiJiSync, _onLongHaiYiJiSync, LongHaiYiJi)
function LongHaiYiJi.Sync(actor)
    FBenFuToKuaFuEvent(actor, EventCfg.onLongHaiYiJiSync, "")
end

--ͬ����Ϣ
-- function LongHaiYiJi.SyncResponse(actor, logindatas)
--     local data = {}
--     local _login_data = {ssrNetMsgCfg.LongHaiYiJi_SyncResponse, 0, 0, 0, data}
--     if logindatas then
--         table.insert(logindatas, _login_data)
--     else
--         Message.sendmsg(actor, ssrNetMsgCfg.LongHaiYiJi_SyncResponse, 0, 0, 0, data)
--     end
-- end
-- --��¼����
-- local function _onLoginEnd(actor, logindatas)
--     LongHaiYiJi.SyncResponse(actor, logindatas)
-- end
-- --�¼��ɷ�
-- GameEvent.add(EventCfg.onLoginEnd, _onLoginEnd, LongHaiYiJi)
local function _onKillMon(actor, monobj, monName)
    if monName == "�������������������" then
        local x = Player.GetX(monobj)
        local y = Player.GetY(monobj)
        -- mapID1
        for _, value in ipairs(bibao) do
            throwitem(actor, mapID2, x, y, 10, value, 1, 60, true, false, false, false, 1, false)
        end
        local value = suiji[math.random(1, #suiji)]
        throwitem(actor, mapID2, x, y, 10, value, 1, 60, true, false, false, false, 1, false)
    end
end
GameEvent.add(EventCfg.onKillMon, _onKillMon, LongHaiYiJi)

--ע��������Ϣ
Message.RegisterNetMsg(ssrNetMsgCfg.LongHaiYiJi, LongHaiYiJi)
return LongHaiYiJi

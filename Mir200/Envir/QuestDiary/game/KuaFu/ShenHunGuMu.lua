local ShenHunGuMu = {}
ShenHunGuMu.ID = "����Ĺ"
local npcID = 153
local config = include("QuestDiary/cfgcsv/cfg_ShenHunGuMu.lua") --����
local cost = { {} }
local give = { {} }
local mapID1 = "����Ĺ"
local mapID2 = "�����ż�"
local monVar = {
    ["�졤Ԫ��"] = VarCfg["U_����Ĺɱ��1"],
    ["�ˡ�����"] = VarCfg["U_����Ĺɱ��2"],
    ["�ء�����"] = VarCfg["U_����Ĺɱ��3"],
}
local mons = {
    ["��������ۻ���������"] = true,
    ["�������˵ۻ���������"] = true,
    ["�������صۻ���������"] = true,
}
local bibao = {
    "�����Ƭ",
    "�����Ƭ",
    "�����Ƭ",
    "�����Ƭ",
    "�����Ƭ",
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
    "�ƿذ���",
}

--��ʼˢ��
function shen_hun_gu_mu_shua_guai()
    FsendHuoDongGongGao("����Ĺ��ͼ�ڹ�����ˢ��!")
    killmonsters(mapID1, "*", 0, false)
    killmonsters(mapID2, "*", 0, false)
    for _, value in ipairs(config) do
        genmon(value.mapID, value.x, value.y, value.value, value.range, value.num, value.color)
    end
end

--�������
function shen_hun_gu_mu_end()
    FsendHuoDongGongGao("����Ĺ��ͼ�ѹر�!")
    FMoveMapPlay(mapID1, "kuafu2", 132, 164, 3)
    FMoveMapPlay(mapID2, "kuafu2", 132, 164, 3)
end

--��������
function ShenHunGuMu.Request(actor)
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
    local isTime1 = isTimeInRange(10, 15, 11, 16)
    local isTime2 = isTimeInRange(22, 15, 23, 16)
    if not isTime1 and not isTime2 then
        Player.sendmsgEx(actor, "���ڿ���ʱ��,��ֹ���룡#249")
        return
    end
    local name = getbaseinfo(actor, ConstCfg.gbase.name)
    sendmsg("0", 2, '{"Msg":"[' .. name .. ']��������Ĺ","FColor":251,"BColor":0,"Type":6,"Time":6,"SendName":"ϵͳ��","SendId":"123","X":"-300"}')
    map(actor, "����Ĺ")
end

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
local function _isBossAllDie()
    local data = _getBossCount()
    for index, value in ipairs(data) do
        if value == 1 then
            return false
        end
    end
    return true
end
local function _onKillMon(actor, monobj, monName)
    if mons[monName] then
        local x = Player.GetX(monobj)
        local y = Player.GetY(monobj)
        -- mapID1
        for _, value in ipairs(bibao) do
            throwitem(actor, mapID1, x, y, 10, value, 1, 60, true, false, false, false, 1, false)
        end
        local value = suiji[math.random(1, #suiji)]
        throwitem(actor, mapID1, x, y, 10, value, 1, 60, true, false, false, false, 1, false)
        local bool = _isBossAllDie()
        if bool then
            FsendHuoDongGongGao("����ĹBOSS��ȫ������ɱ,�����ż���ͼ����!")
        end
    end
    local var = monVar[monName]
    if var then
        local num = getplaydef(actor, var)
        setplaydef(actor, var, num + 1)
    end
end
GameEvent.add(EventCfg.onKillMon, _onKillMon, ShenHunGuMu)

--ͬ����Ϣ
-- function ShenHunGuMu.SyncResponse(actor, logindatas)
--     local data = {}
--     local _login_data = {ssrNetMsgCfg.ShenHunGuMu_SyncResponse, 0, 0, 0, data}
--     if logindatas then
--         table.insert(logindatas, _login_data)
--     else
--         Message.sendmsg(actor, ssrNetMsgCfg.ShenHunGuMu_SyncResponse, 0, 0, 0, data)
--     end
-- end
-- --��¼����
-- local function _onLoginEnd(actor, logindatas)
--     ShenHunGuMu.SyncResponse(actor, logindatas)
-- end
-- --�¼��ɷ�
-- GameEvent.add(EventCfg.onLoginEnd, _onLoginEnd, ShenHunGuMu)
--ע��������Ϣ
Message.RegisterNetMsg(ssrNetMsgCfg.ShenHunGuMu, ShenHunGuMu)
return ShenHunGuMu

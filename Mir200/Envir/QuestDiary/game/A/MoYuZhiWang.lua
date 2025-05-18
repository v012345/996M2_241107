local MoYuZhiWang = {}
MoYuZhiWang.ID = "����֮��"
local config = include("QuestDiary/cfgcsv/cfg_MoYuZhiWang.lua") --����
local mapID = "moyu"
local pointMap = {
    ["������Ⱥ��ʮ���֡�"] = 10,
    ["ɳ����Ⱥ����ʮ���֡�"] = 30,
    ["����Ⱥ����ʮ���֡�"] = 50,
    ["������Ⱥ����ʮ���֡�"] = 80,
    ["�ƽ𾨡�һ�ٶ�ʮ���֡�"] = 120,
    ["��ʯ����һ�ٶ�ʮ���֡�"] = 120,
    ["����𡾶��ٻ��֡�"] = 200,
}

local monNum = {
    { name = "������Ⱥ��ʮ���֡�", num = 500 },
    { name = "ɳ����Ⱥ����ʮ���֡�", num = 200 },
    { name = "����Ⱥ����ʮ���֡�", num = 120 },
    { name = "������Ⱥ����ʮ���֡�", num = 60 },
    { name = "�ƽ𾨡�һ�ٶ�ʮ���֡�", num = 60 },
    { name = "��ʯ����һ�ٶ�ʮ���֡�", num = 60 },
    { name = "����𡾶��ٻ��֡�", num = 10 },
}

--��������
function MoYuZhiWang.Request(actor)
    --local name, num = Player.checkItemNumByTable(actor, cost)
    --if name then
    --Player.sendmsgEx(actor, string.format("���|%s#249|����|%d#249", name, num))
    --return
    --end
end

function MoYuZhiWang.EnterMap(actor)
    local min = getsysvar(VarCfg["G_�������Ӽ�ʱ��"])
    if min >= 105 and min < 115 then
        FMapEx(actor, mapID)
        local name = getbaseinfo(actor, ConstCfg.gbase.name)
        sendmsg("0", 2,
            '{"Msg":"[' ..
            name .. ']�μ�������֮���","FColor":251,"BColor":0,"Type":6,"Time":6,"SendName":"ϵͳ��","SendId":"123","X":"-300"}')
    else
        Player.sendmsgEx(actor, "��ǰ���ڿ���ʱ����ڣ��޷�����#249")
    end
end

--����֪ͨ
local function _onMYZWTongZhi()
    FsendHuoDongGongGao("����֮���1���Ӻ��������λ��Һ�����ʱ�䣬���û׼��������")
end
GameEvent.add(EventCfg.onMYZWTongZhi, _onMYZWTongZhi, MoYuZhiWang)

local function _onMYZWStart()
    for index, value in ipairs(monNum) do
        genmon(mapID, 148, 144, value.name, 150, value.num, 250)
    end
end
--���ʼ
GameEvent.add(EventCfg.onMYZWStart, _onMYZWStart, MoYuZhiWang)

--�����
local function _onMYZWEnd()
    killmonsters(mapID, "*", 0, false)
    for i = 1, 5, 1 do
        sendmsg("0", 2,
            '{"Msg":"����֮����ѽ���������","FColor":250,"BColor":0,"Type":6,"Time":6,"SendName":"ϵͳ��","SendId":"123","Y":"0"}')
    end
    local list = getplaycount(mapID, 0, 0)
    if list ~= "0" then
        for _, actor in ipairs(list) do
            mapmove(actor, "n3", 330, 330, 3)
        end
    end
end
GameEvent.add(EventCfg.onMYZWEnd, _onMYZWEnd, MoYuZhiWang)

local function addPoints(actor, points)
    local currPoint = getplaydef(actor, VarCfg["U_�������"])
    local userPoints = currPoint + points
    setplaydef(actor, VarCfg["U_�������"], userPoints)
    Player.sendmsgEx(actor, string.format("�������|+%d#249", points))
    local claimedRewards = Player.getJsonTableByVar(actor, VarCfg["T_�����¼"])
    for i, info in ipairs(config) do
        if userPoints >= info.points and not claimedRewards[tostring(i)] then
            claimedRewards[tostring(i)] = true
            Player.setJsonVarByTable(actor, VarCfg["T_�����¼"], claimedRewards)
            Player.sendmsgEx(actor, "�����|" .. i .. "#249|�ѷ��͵�����")
            local mailTitle = "�������"
            local mailContent = "����ȡ���ĵ� " .. i .. " �����㽱��"
            local userID = getbaseinfo(actor, ConstCfg.gbase.id)
            Player.giveMailByTable(userID, 1, mailTitle, mailContent, info.rewards, 1, true)
        end
    end
    Message.sendmsg(actor, ssrNetMsgCfg.MoYuZhiWang_UpdateUI, userPoints, 0, 0, claimedRewards)
end

local function _onCollectTask(actor, monName, monMakeIndex, itemName)
    if FCheckMap(actor, mapID) then
        local points = pointMap[monName] or 0
        addPoints(actor, points)
    end
end
GameEvent.add(EventCfg.onCollectTask, _onCollectTask, MoYuZhiWang)

local function _goSwitchMap(actor, cur_mapid, former_mapid)
    if cur_mapid == mapID then
        setontimer(actor, 8, 2, 0)
        addbuff(actor, 31053)
        local points = getplaydef(actor, VarCfg["U_�������"])
        local claimedRewards = Player.getJsonTableByVar(actor, VarCfg["T_�����¼"])
        Message.sendmsg(actor, ssrNetMsgCfg.MoYuZhiWang_Enter, points, 0, 0, claimedRewards)
    end
    if former_mapid == mapID then
        FkfDelBuff(actor, 31053)
        setofftimer(actor, 8)
        Message.sendmsg(actor, ssrNetMsgCfg.MoYuZhiWang_Leave)
    end
end
GameEvent.add(EventCfg.goSwitchMap, _goSwitchMap, MoYuZhiWang)

--��ʱ��
local function _onMYZWimer(actor)
    changemoney(actor, 3, "+", 2000, "����֮��", true)
end
GameEvent.add(EventCfg.onMYZWimer, _onMYZWimer, MoYuZhiWang)


--ͬ����Ϣ
-- function MoYuZhiWang.SyncResponse(actor, logindatas)
--     local data = {}
--     local _login_data = {ssrNetMsgCfg.MoYuZhiWang_SyncResponse, 0, 0, 0, data}
--     if logindatas then
--         table.insert(logindatas, _login_data)
--     else
--         Message.sendmsg(actor, ssrNetMsgCfg.MoYuZhiWang_SyncResponse, 0, 0, 0, data)
--     end
-- end
-- --��¼����
-- local function _onLoginEnd(actor, logindatas)
--     MoYuZhiWang.SyncResponse(actor, logindatas)
-- end
-- --�¼��ɷ�
-- GameEvent.add(EventCfg.onLoginEnd, _onLoginEnd, MoYuZhiWang)
--ע��������Ϣ
Message.RegisterNetMsg(ssrNetMsgCfg.MoYuZhiWang, MoYuZhiWang)
return MoYuZhiWang

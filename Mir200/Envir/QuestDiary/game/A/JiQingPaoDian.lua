local JiQingPaoDian = {}
JiQingPaoDian.ID = "�����ݵ�"
--local config = include("QuestDiary/cfgcsv/cfg_JiQingPaoDian.lua") --����
local mapID = "�����ݵ�"
--��������
function JiQingPaoDian.Request(actor)
    --local name, num = Player.checkItemNumByTable(actor, cost)
    --if name then
    --Player.sendmsgEx(actor, string.format("���|%s#249|����|%d#249", name, num))
    --return
    --end
end

function JiQingPaoDian.EnterMap(actor)
    local min = getsysvar(VarCfg["G_�������Ӽ�ʱ��"])
    if min >= 75 and min < 85 then
        FMapMoveEx(actor, mapID, 27, 26, 5)
        local name = getbaseinfo(actor, ConstCfg.gbase.name)
        sendmsg("0", 2, '{"Msg":"['..name..']�μ��˼����ݵ�","FColor":251,"BColor":0,"Type":6,"Time":6,"SendName":"ϵͳ��","SendId":"123","X":"-300"}')
    else
        Player.sendmsgEx(actor, "��ǰ���ڿ���ʱ����ڣ��޷�����#249")
    end
end

--�л���ͼ
local function _goSwitchMap(actor, cur_mapid, former_mapid)
    if cur_mapid == mapID then
        setontimer(actor, 9, 2, 0)
    end
    if former_mapid == mapID then
        setofftimer(actor, 9)
    end
end
GameEvent.add(EventCfg.goSwitchMap, _goSwitchMap, JiQingPaoDian)

--��ʱ��
local function _onJQPDimer(actor)
    if FCheckMap(actor, mapID) then
        local min = getsysvar(VarCfg["G_�������Ӽ�ʱ��"])
        local bool = min >= 75 and min < 85
        if not bool then
            return
        end
        local x = getbaseinfo(actor, ConstCfg.gbase.x)
        local y = getbaseinfo(actor, ConstCfg.gbase.y)
        if FisInRange(x, y, 40, 28, 1) or
            FisInRange(x, y, 29, 36, 1) or
            FisInRange(x, y, 14, 31, 1) or
            FisInRange(x, y, 33, 17, 1) or
            FisInRange(x, y, 17, 19, 1)
        then
            changeexp(actor, "+", 200000, false)
            changemoney(actor, 3, "+", 5000, "�����ݵ�", true)
        elseif FisInRange(x, y, 27, 26, 5) then
            changeexp(actor, "+", 500000, false)
            changemoney(actor, 3, "+", 10000, "�����ݵ�", true)
        else
            changeexp(actor, "+", 100000, false)
            changemoney(actor, 3, "+", 1000, "�����ݵ�", true)
        end
    end
end
GameEvent.add(EventCfg.onJQPDimer, _onJQPDimer, JiQingPaoDian)

--ö�ٵ�ͼ��Ч
local emunMapEffect = {
    { x = 17, y = 19, effID = 63031 },
    { x = 33, y = 17, effID = 63031 },
    { x = 40, y = 28, effID = 63031 },
    { x = 29, y = 36, effID = 63031 },
    { x = 14, y = 31, effID = 63031 },
    { x = 27, y = 26, effID = 63032 },
}
--��ʼ
local function _onJQPDStart()
    for index, value in ipairs(emunMapEffect) do
        mapeffect(index, mapID, value.x, value.y, value.effID, 600, nil, 0)
    end
end
GameEvent.add(EventCfg.onJQPDStart, _onJQPDStart, JiQingPaoDian)
--�����
local function _onJQPDEnd()
    for i = 1, 5, 1 do
        sendmsg("0", 2, '{"Msg":"�����ݵ��ѽ���������","FColor":250,"BColor":0,"Type":6,"Time":6,"SendName":"ϵͳ��","SendId":"123","Y":"0"}')
    end
    local list = getplaycount(mapID, 0, 0)
    if list ~= "0" then
        for _, actor in ipairs(list) do
            mapmove(actor, "n3", 330, 330, 3)
        end
    end
end
GameEvent.add(EventCfg.onJQPDEnd, _onJQPDEnd, JiQingPaoDian)
--֪ͨ
local function _onJQPDTongZhi()
    FsendHuoDongGongGao("�����ݵ�1���Ӻ��������λ��Һ�����ʱ�䣬���û׼��������")
end
GameEvent.add(EventCfg.onJQPDTongZhi, _onJQPDTongZhi, JiQingPaoDian)
--ͬ����Ϣ
-- function JiQingPaoDian.SyncResponse(actor, logindatas)
--     local data = {}
--     local _login_data = {ssrNetMsgCfg.JiQingPaoDian_SyncResponse, 0, 0, 0, data}
--     if logindatas then
--         table.insert(logindatas, _login_data)
--     else
--         Message.sendmsg(actor, ssrNetMsgCfg.JiQingPaoDian_SyncResponse, 0, 0, 0, data)
--     end
-- end
-- --��¼����
-- local function _onLoginEnd(actor, logindatas)
--     JiQingPaoDian.SyncResponse(actor, logindatas)
-- end
-- --�¼��ɷ�
-- GameEvent.add(EventCfg.onLoginEnd, _onLoginEnd, JiQingPaoDian)
--ע��������Ϣ

Message.RegisterNetMsg(ssrNetMsgCfg.JiQingPaoDian, JiQingPaoDian)
return JiQingPaoDian

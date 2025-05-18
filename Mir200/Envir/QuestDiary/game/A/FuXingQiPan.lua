local FuXingQiPan = {}
FuXingQiPan.ID = "��������"
local config = include("QuestDiary/cfgcsv/cfg_FuXingQiPan.lua") --����
local cost = { {} }
local give = { {} }
local mapID = "��������"
--��������
function FuXingQiPan.Request(actor)
    --local name, num = Player.checkItemNumByTable(actor, cost)
    --if name then
    --Player.sendmsgEx(actor, string.format("���|%s#249|����|%d#249", name, num))
    --return
    --end
end

function FuXingQiPan.EnterMap(actor)
    local min = getsysvar(VarCfg["G_�������Ӽ�ʱ��"])
    --(G1>=15&G1<35)#(G1>=135&G1<155)
    if (min>=15 and min<35) or (min>=135 and min<155) then
        FMapEx(actor, mapID)
        local name = getbaseinfo(actor, ConstCfg.gbase.name)
        sendmsg("0", 2, '{"Msg":"['..name..']�μ��˸������̻","FColor":251,"BColor":0,"Type":6,"Time":6,"SendName":"ϵͳ��","SendId":"123","X":"-300"}')
    else
        Player.sendmsgEx(actor, "��ǰ���ڿ���ʱ����ڣ��޷�����#249")
    end
end

--����֪ͨ

local function _onFXQPSendTongZhi()
    FsendHuoDongGongGao("�������̻1���Ӻ��������λ��Һ�����ʱ�䣬���û׼��������")
end

GameEvent.add(EventCfg.onFXQPSendTongZhi, _onFXQPSendTongZhi, FuXingQiPan)

--���ʼ
local function _onFXQPStart()
    for index, value in ipairs(config) do
        genmon(mapID, value.x, value.y, value.name, 0, value.num, value.color)
    end
end
GameEvent.add(EventCfg.onFXQPStart, _onFXQPStart, FuXingQiPan)

--ˢ���м��boss
local function _onFXQPResreshBoss()
    FsendHuoDongGongGao("�������̻���ͼ�м�ˢ���ˡ�ţ������������ɱ��ɻ�ô�������������")
    genmon(mapID, 113, 127, "ţ������", 0, 1, 251)
end
GameEvent.add(EventCfg.onFXQPResreshBoss, _onFXQPResreshBoss, FuXingQiPan)

--�����
local function _onFXQPEnd()
    killmonsters(mapID, "*", 0, false)
    for i = 1, 5, 1 do
        sendmsg("0", 2, '{"Msg":"�������̻�ѽ���������","FColor":250,"BColor":0,"Type":6,"Time":6,"SendName":"ϵͳ��","SendId":"123","Y":"0"}')
    end
    local list = getplaycount(mapID, 0, 0)
    if list ~= "0" then
        for _, actor in ipairs(list) do
            mapmove(actor, "n3", 330, 330, 3)
        end
    end
end
GameEvent.add(EventCfg.onFXQPEnd, _onFXQPEnd, FuXingQiPan)

--ɱ�ִ���
local function _onKillMon(actor, monobj, monName)
    if FCheckMap(actor, mapID) and monName == "ţ������" then
        throwitem(actor, "��������", 113, 128, 10, "5Ԫ��ֵ���", 40, 30, true, false, false, false, 1, false)
        throwitem(actor, "��������", 113, 128, 10, "1Ԫ��ֵ���", 20, 30, true, false, false, false, 1, false)
        throwitem(actor, "��������", 113, 128, 10, "����ר��ä��", 1, 30, true, false, false, false, 1, false)
        throwitem(actor, "��������", 113, 128, 10, "�߼�����ä��", 1, 30, true, false, false, false, 1, false)
        throwitem(actor, "��������", 113, 128, 10, "����", 2, 30, true, false, false, false, 1, false)
        throwitem(actor, "��������", 113, 128, 10, "���絤", 4, 30, true, false, false, false, 1, false)
        throwitem(actor, "��������", 113, 128, 10, "������Ƭ", 3, 30, true, false, false, false, 1, false)
        throwitem(actor, "��������", 113, 128, 10, "ת��֮��", 3, 30, true, false, false, false, 1, false)
        throwitem(actor, "��������", 113, 128, 10, "1000Ԫ��", 10, 30, true, false, false, false, 1, false)
    end
end
GameEvent.add(EventCfg.onKillMon, _onKillMon, FuXingQiPan)

local function _goSwitchMap(actor, cur_mapid, former_mapid)
    if cur_mapid == mapID then
        setontimer(actor, 6, 2, 0)
    end
    if former_mapid == mapID then
        setofftimer(actor, 6)
    end
end
--�л���ͼ����
GameEvent.add(EventCfg.goSwitchMap, _goSwitchMap, FuXingQiPan)

--ÿ��
local function _onFXQPReward(actor)
    changemoney(actor, 3 , "+", 1000, "��������", true)
end
GameEvent.add(EventCfg.onFXQPReward, _onFXQPReward, FuXingQiPan)
--ͬ����Ϣ
-- function FuXingQiPan.SyncResponse(actor, logindatas)
--     local data = {}
--     local _login_data = {ssrNetMsgCfg.FuXingQiPan_SyncResponse, 0, 0, 0, data}
--     if logindatas then
--         table.insert(logindatas, _login_data)
--     else
--         Message.sendmsg(actor, ssrNetMsgCfg.FuXingQiPan_SyncResponse, 0, 0, 0, data)
--     end
-- end
-- --��¼����
-- local function _onLoginEnd(actor, logindatas)
--     FuXingQiPan.SyncResponse(actor, logindatas)
-- end
-- --�¼��ɷ�
-- GameEvent.add(EventCfg.onLoginEnd, _onLoginEnd, FuXingQiPan)
--ע��������Ϣ
Message.RegisterNetMsg(ssrNetMsgCfg.FuXingQiPan, FuXingQiPan)
return FuXingQiPan

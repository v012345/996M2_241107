local QuanMinHuaShui = {}
QuanMinHuaShui.ID = "ȫ��ˮ"
local config = include("QuestDiary/cfgcsv/cfg_QuanMinHuaShui.lua") --����
local mapID = "quanminghuashui"
local HuaShuiY = 100
--������ȡ����
function QuanMinHuaShui.Request(actor)
    if not FCheckNPCRange(actor, 124, 5) then
        Player.sendmsgEx(actor, "�����ҽ�һ�㣡")
        return
    end
    local falg = getflagstatus(actor, VarCfg["F_ȫ��ˮ��ȡ"])
    if falg == 1 then
        Player.sendmsgEx(actor, "���Ѿ���ȡ��������")
        return
    end
    setflagstatus(actor, VarCfg["F_ȫ��ˮ��ȡ"], 1)
    local Gglobal = getsysvar(VarCfg["G_ȫ��ˮ����"]) + 1
    if Gglobal <= 10 then
        local cfg         = config[Gglobal]
        local rankFont    = formatNumberToChinese(Gglobal)
        local mailTitle   = "ȫ��ˮ��" .. rankFont .. "������"
        local mailContent = "��ϲ����ȫ��ˮ��" .. rankFont .. "��������ȡ���Ľ�����"
        local userID      = getbaseinfo(actor, ConstCfg.gbase.id)
        -- release_print(userID)
        Player.giveMailByTable(userID, 1, mailTitle, mailContent, cfg.reward, 1, true)
        setsysvar(VarCfg["G_ȫ��ˮ����"], Gglobal)
        local rankList = Player.getJsonTableByVar(nil, VarCfg["A_ȫ��ˮ����"])
        local myName = getbaseinfo(actor, ConstCfg.gbase.name)
        table.insert(rankList, myName)
        Player.setJsonVarByTable(nil, VarCfg["A_ȫ��ˮ����"], rankList)
        Player.sendmsgEx(actor,"��ϲ����ȫ��ˮ��" .. rankFont .. "��,�����ѷ��͵��ʼ�!")
        mapmove(actor,"n3", 330, 330, 3)
        local rewardStr = getItemArrToStr(cfg.reward)
        local str = string.format("{����ϲ��/FCOLOR=249}��{%s/FCOLOR=250} {�ڻ�ˮ��л�õ�%s��������/FCOLOR=249}{%s/FCOLOR=250} ", Player.GetName(actor),rankFont, rewardStr)
        sendmovemsg(actor, 1,249, 0,HuaShuiY,1,str)
        HuaShuiY = HuaShuiY + 40
    else
        local cost        = { { "5Ԫ��ֵ���", 1 } }
        local mailTitle   = "ȫ��ˮ���뽱����"
        local mailContent = "��ϲ����ȫ��ˮ���뽱������ȡ���Ľ�����"
        local userID      = getbaseinfo(actor, ConstCfg.gbase.id)
        Player.giveMailByTable(userID, 1, mailTitle, mailContent, cost, 1, true)
        setsysvar(VarCfg["G_ȫ��ˮ����"], Gglobal)
        Player.sendmsgEx(actor,"��ϲ����ȫ��ˮ���뽱,�����ѷ��͵��ʼ�!")
        mapmove(actor,"n3", 330, 330, 3)
    end
end

function QuanMinHuaShui.EnterMap(actor)
    local falg = getflagstatus(actor, VarCfg["F_ȫ��ˮ��ȡ"])
    if falg == 1 then
        Player.sendmsgEx(actor, "���Ѿ���ȡ��������,�޷�������!#249")
        return
    end
    local min = getsysvar(VarCfg["G_�������Ӽ�ʱ��"])
    --(G1>=15&G1<35)#(G1>=135&G1<155)
    if min >= 45 and min < 55 then
        FMapMoveEx(actor, mapID, 147, 188, 0)
        local name = getbaseinfo(actor, ConstCfg.gbase.name)
        sendmsg("0", 2, '{"Msg":"['..name..']�μ���ȫ��ˮ�","FColor":251,"BColor":0,"Type":6,"Time":6,"SendName":"ϵͳ��","SendId":"123","X":"-300"}')
    else
        Player.sendmsgEx(actor, "��ǰ���ڿ���ʱ����ڣ��޷�����#249")
        return
    end
end

--����֪ͨ
local function _onQMHSSendTongZhi()
    FsendHuoDongGongGao("ȫ��ˮ�1���Ӻ��������λ��Һ�����ʱ�䣬���û׼��������")
end
GameEvent.add(EventCfg.onQMHSSendTongZhi, _onQMHSSendTongZhi, QuanMinHuaShui)


--�����
local function _onQMHSEnd()
    for i = 1, 5, 1 do
        sendmsg("0", 2, '{"Msg":"ȫ��ˮ��ѽ���������","FColor":250,"BColor":0,"Type":6,"Time":6,"SendName":"ϵͳ��","SendId":"123","Y":"0"}')
    end
    local list = getplaycount(mapID, 0, 0)
    if list ~= "0" then
        for _, actor in ipairs(list) do
            mapmove(actor, "n3", 330, 330, 3)
        end
    end
end
GameEvent.add(EventCfg.onQMHSEnd, _onQMHSEnd, QuanMinHuaShui)

--�л���ͼ����
local function _goSwitchMap(actor, cur_mapid, former_mapid)
    if cur_mapid == mapID then
        setontimer(actor, 7, 1, 0)
        addbuff(actor, 31053)
    end
    if former_mapid == mapID then
        FkfDelBuff(actor, 31053)
        setofftimer(actor, 7)
    end
end
GameEvent.add(EventCfg.goSwitchMap, _goSwitchMap, QuanMinHuaShui)
local randomState = {}
randomState[1] = function(actor)
    --���
    makeposion(actor, 5, 3)
end
randomState[2] = function(actor)
    --����
    makeposion(actor, 12, 3)
end
randomState[3] = function(actor)
    --����
    makeposion(actor, 13, 3)
end

local function _onQMHTimer(actor)
    if randomex(10) then
        local randomIndex = math.random(3)
        local func = randomState[randomIndex]
        func(actor)
    end
end
GameEvent.add(EventCfg.onQMHTimer, _onQMHTimer, QuanMinHuaShui)

--���NPC����
local function _onClicknpc(actor, npcid, npcobj)
    if npcid == 124 then
        if not FCheckNPCRange(actor, 124, 5) then
            Player.sendmsgEx(actor, "�����ҽ�һ�㣡")
            return
        end
        local rankList = Player.getJsonTableByVar(nil, VarCfg["A_ȫ��ˮ����"])
        Message.sendmsg(actor, ssrNetMsgCfg.QuanMinHuaShui_OpenUI, 0, 0, 0, rankList)
    end
    
end
GameEvent.add(EventCfg.onClicknpc, _onClicknpc, QuanMinHuaShui)

--ͬ����Ϣ
-- function QuanMinHuaShui.SyncResponse(actor, logindatas)
--     local data = {}
--     local _login_data = {ssrNetMsgCfg.QuanMinHuaShui_SyncResponse, 0, 0, 0, data}
--     if logindatas then
--         table.insert(logindatas, _login_data)
--     else
--         Message.sendmsg(actor, ssrNetMsgCfg.QuanMinHuaShui_SyncResponse, 0, 0, 0, data)
--     end
-- end
-- --��¼����
-- local function _onLoginEnd(actor, logindatas)
--     QuanMinHuaShui.SyncResponse(actor, logindatas)
-- end
-- --�¼��ɷ�
-- GameEvent.add(EventCfg.onLoginEnd, _onLoginEnd, QuanMinHuaShui)
--ע��������Ϣ
Message.RegisterNetMsg(ssrNetMsgCfg.QuanMinHuaShui, QuanMinHuaShui)
return QuanMinHuaShui

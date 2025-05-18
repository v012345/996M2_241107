XunHangGuaJi = {}

local cfg_JinZhiJiLuDiTu = include("QuestDiary/cfgcsv/cfg_JinZhiJiLuDiTu.lua") --��ֹ��¼�ĵ�ͼ

local flag = { VarCfg["F_Ѳ������1"], VarCfg["F_Ѳ������2"], VarCfg["F_Ѳ������3"] }

local record = { VarCfg["T_Ѳ����¼��ͼ1"], VarCfg["T_Ѳ����¼��ͼ2"], VarCfg["T_Ѳ����¼��ͼ3"] }

--��ֹ��¼�ĵ�ͼ�����׺
-- local mapSuffix = { "�˺�����", "��������", "��ħ����", "�׼�����", "��������" }

function xunhang_start_auto_attack(actor)
    setplaydef(actor, VarCfg["M_�Ƿ���Ѳ����ͼ"], 1)
    startautoattack(actor)
end

local timeCache = {}

--��ȡѲ����Ϣ
function XunHangGuaJi.GetXunHangInfo(actor)
    local arrData = {
        flag = {},
        record = {},
        status = 0
    }
    for _, value in ipairs(flag) do
        table.insert(arrData.flag, getflagstatus(actor, value))
    end
    for _, value in ipairs(record) do
        table.insert(arrData.record, Player.getJsonTableByVar(actor, value))
    end
    arrData.status = getplaydef(actor, VarCfg["N$Ѳ���һ�����״̬"])
    return arrData
end

function XunHangGuaJi.OpenUI(actor)
    local data = XunHangGuaJi.GetXunHangInfo(actor)
    Message.sendmsg(actor, ssrNetMsgCfg.XunHangGuaJi_OpenUI, 0, 0, 0, data)
end

--�жϵ�ͼ�Ƿ����Ѳ��
function XunHangGuaJi.CheckMap(actor, mapId)
    if cfg_JinZhiJiLuDiTu[mapId] then
        return false
    end
    local myName = getbaseinfo(actor, ConstCfg.gbase.name)
    local findSting = string.find(mapId, myName)
    if findSting then
        return false
    end
    return true
end

function XunHangGuaJi.RecordXunHang(actor, arg1)
    local var = record[arg1]
    if not var then
        Player.sendmsgEx(actor, "��������!#249")
        return
    end
    local mapInfo = getplaydef(actor, var)
    if mapInfo ~= "" then
        setplaydef(actor, var, "")
        Player.sendmsgEx(actor, "ɾ���ɹ�!")
        XunHangGuaJi.SyncResponse(actor)
    else
        local mapId = getbaseinfo(actor, ConstCfg.gbase.mapid)
        local myName = getbaseinfo(actor, ConstCfg.gbase.name)
        if string.find(mapId, myName) then
            Player.sendmsgEx(actor,"������ͼ��ֹ��¼#249")
            return
        end
        local checkMap = XunHangGuaJi.CheckMap(actor, mapId)
        if not checkMap then
            Player.sendmsgEx(actor, "��ǰ��ͼ��ֹѲ��!#249")
            return
        end
        local mapName = getbaseinfo(actor, ConstCfg.gbase.map_title)
        local mapInfo = { mapId, mapName }
        Player.setJsonVarByTable(actor, var, mapInfo)
        Player.sendmsgEx(actor, "��ӳɹ�!")
        XunHangGuaJi.SyncResponse(actor)
    end
end

--����һ���ͼ
function XunHangGuaJi.EnterGuaJiMap(actor)
    local mapList = {}
    for _, value in ipairs(record) do
        local arr = Player.getJsonTableByVar(actor, value)
        if arr[1] then
            table.insert(mapList, arr[1])
        end
    end
    if #mapList > 0 then
        local mapId = mapList[math.random(1, #mapList)]
        map(actor, mapId)
        delaygoto(actor, 1000, "xunhang_start_auto_attack")
        return true
    else
        return false
    end
end

function XunHangGuaJi.StartGuaJi(actor)
    local isGuaJi = getplaydef(actor, VarCfg["N$Ѳ���һ�����״̬"])
    if isGuaJi == 0 then
        local isJiLu = XunHangGuaJi.EnterGuaJiMap(actor)
        if not isJiLu then
            Player.sendmsgEx(actor, "��û�м�¼�κε�ͼ!#249")
            return
        end
        setplaydef(actor, VarCfg["N$Ѳ���һ�����״̬"], 1)
        setplaydef(actor, VarCfg["N$�һ���������"], 0)
        setontimer(actor, 4, 15, 0, 0)
        Player.sendmsgEx(actor, "�����ɹ�!")
    else
        setplaydef(actor, VarCfg["N$Ѳ���һ�����״̬"], 0)
        setofftimer(actor, 4)
        Player.sendmsgEx(actor, "Ѳ���һ��ѹر�!#249")
    end
    XunHangGuaJi.SyncResponse(actor)
end

--�ر�Ѳ���һ� --�ⲿ�ӿ�
function XunHangGuaJi.CloseGuaJi(actor)
    if getplaydef(actor, VarCfg["N$Ѳ���һ�����״̬"]) == 1 then
        setplaydef(actor, VarCfg["N$Ѳ���һ�����״̬"], 0)
        setofftimer(actor, 4)
        Player.sendmsgEx(actor, "Ѳ���һ��ѹر�!#249")
        XunHangGuaJi.SyncResponse(actor)
    end 
end

function XunHangGuaJi.OnAndOff(actor, arg1)
    local var = flag[arg1]
    if not var then
        Player.sendmsgEx(actor, "��������!#249")
        return
    end
    if getflagstatus(actor,VarCfg["F_�Ƿ��׳�"]) == 0 then
        messagebox(actor,"��û�н����׳䣬�޷��������Ƿ�ǰ���׳䣿","@open_shou_chong","@quxiao")
        return
    end
    local status = getflagstatus(actor, var)
    if status == 0 then
        setflagstatus(actor, var, 1)
    else
        setflagstatus(actor, var, 0)
        --�رյ�����ʱ ���ô���
        if arg1 == 3 then
            setplaydef(actor, VarCfg["N$�һ���������"], 0)
        end
    end
    XunHangGuaJi.SyncResponse(actor)
end

--ͬ����Ϣ
function XunHangGuaJi.SyncResponse(actor)
    local data = XunHangGuaJi.GetXunHangInfo(actor)
    Message.sendmsg(actor, ssrNetMsgCfg.XunHangGuaJi_SyncResponse, 0, 0, 0, data)
end

Message.RegisterNetMsg(ssrNetMsgCfg.XunHangGuaJi, XunHangGuaJi)

--�����﹥������
local function _onStruckPlayer(actor, Target, Hiter, MagicId)
    if not hasbuff(actor, 30104) then
        if getplaydef(actor, VarCfg["N$Ѳ���һ�����״̬"]) == 1 then
            if getflagstatus(actor, VarCfg["F_Ѳ������1"]) == 1 then
                local mapId = getbaseinfo(actor, ConstCfg.gbase.mapid)
                map(actor, mapId)
                delaygoto(actor, 1000, "xunhang_start_auto_attack")
                addbuff(actor, 30104, 30)
            end
        end
    end
end
GameEvent.add(EventCfg.onStruckPlayer, _onStruckPlayer, XunHangGuaJi)
--�����﹥������
local function _onStruckMonster(actor, Target, Hiter, MagicId)
    if getplaydef(actor, VarCfg["N$Ѳ���һ�����״̬"]) == 1 then
        if getflagstatus(actor, VarCfg["F_Ѳ������2"]) == 1 then
            local hpPer = Player.getHpPercentage(actor)
            if hpPer <= 50 then
                mapmove(actor, ConstCfg.main_city, 330, 330, 5)
                addhpper(actor, "=", 100)
            end
        end
    end
end
GameEvent.add(EventCfg.onStruckMonster, _onStruckMonster, XunHangGuaJi)

--��������
local function _onPlaydie(actor, hiter)
    if getplaydef(actor, VarCfg["N$Ѳ���һ�����״̬"]) == 1 then
        if getflagstatus(actor, VarCfg["F_Ѳ������3"]) == 1 then
            local dieNum = getplaydef(actor, VarCfg["N$�һ���������"])
            setplaydef(actor, VarCfg["N$�һ���������"], dieNum + 1)
            --��������ʮ�ιر�Ѳ���һ�
            if dieNum + 1 >= 10 then
                setplaydef(actor, VarCfg["N$Ѳ���һ�����״̬"], 0)
                setofftimer(actor, 4) --�رն�ʱ��
                XunHangGuaJi.SyncResponse(actor)
            end
        end
    end
end

GameEvent.add(EventCfg.onPlaydie, _onPlaydie, XunHangGuaJi)

--Ѳ���һ���ʱ������
local function _onXunHangOnTime(actor)
    if getplaydef(actor, VarCfg["M_�Ƿ���Ѳ����ͼ"]) == 0 or FCheckMap(actor,"n3") then
        local result = XunHangGuaJi.EnterGuaJiMap(actor)
        if not result then
            setplaydef(actor, VarCfg["N$Ѳ���һ�����״̬"], 0)
            setofftimer(actor, 4)
            Player.sendmsgEx(actor, "Ѳ����ͼ������,�ѹر�Ѳ��!")
            XunHangGuaJi.SyncResponse(actor)
            return
        end
    end
    -- if getflagstatus(actor, VarCfg.F_isGuaJi) == 0 then
    --     startautoattack(actor)
    -- end
    local lastTime = timeCache[actor] or os.time()
    local timeDifference = os.time() - lastTime
    -- release_print("��ʱ��",timeDifference)
    --30�벻����Զ����
    if timeDifference > 30 then
        local result = XunHangGuaJi.EnterGuaJiMap(actor)
        if not result then
            setplaydef(actor, VarCfg["N$Ѳ���һ�����״̬"], 0)
            setofftimer(actor, 4)
            Player.sendmsgEx(actor, "Ѳ����ͼ������,�ѹر�Ѳ��!")
            XunHangGuaJi.SyncResponse(actor)
            return
        end
    end
end
GameEvent.add(EventCfg.onXunHangOnTime, _onXunHangOnTime, XunHangGuaJi)

--�������ﴥ��
local function _onAttackMonster(actor, Target, Hiter, MagicId, qieGe)
    timeCache[actor] = os.time()
end
--�������ﴥ��
GameEvent.add(EventCfg.onAttackMonster, _onAttackMonster, XunHangGuaJi)

--�˳���Ϸ����
local function _onExitGame(actor)
    timeCache[actor] = nil
end
GameEvent.add(EventCfg.onExitGame, _onExitGame, XunHangGuaJi)

return XunHangGuaJi

LuckyEvent = {}
local LuckyMonCfg = include("QuestDiary/cfgcsv/cfg_QiYuMonster.lua")          --��������
local LuckyEventCfg = include("QuestDiary/cfgcsv/cfg_LuckyEvent_BoxData.lua") --�����¼�����

--�Ƿ��Ѿ������ں�������
local function InTheBox(actor, Event_Name)
    local bool = false
    local notes1 = getplaydef(actor, VarCfg["Z_��������λ��1"])
    local notes2 = getplaydef(actor, VarCfg["Z_��������λ��2"])
    local notes3 = getplaydef(actor, VarCfg["Z_��������λ��3"])
    local notes4 = getplaydef(actor, VarCfg["Z_��������λ��4"])
    local notes5 = getplaydef(actor, VarCfg["Z_��������λ��5"])
    local NewTbl = { notes1, notes2, notes3, notes4, notes5 }
    for _, value in ipairs(NewTbl) do
        if value == Event_Name then
            setplaydef(actor, VarCfg["S$������֤"], "")
            bool = true
        end
    end
    return bool
end

--���� ���buff����  ������ȡֵ
local function checkbuff(actor, Event_Name)
    local name = Event_Name
    local cfg = {}
    for k, v in ipairs(LuckyEventCfg) do
        if v.EnevtName == Event_Name then
            cfg = v
            break
        end
    end
    if cfg.BuffId ~= "nil" then
        local BuffTbl = cfg.BuffId
        for i = 1, #BuffTbl do
            local buffstate = hasbuff(actor, BuffTbl[i])
            if hasbuff(actor, BuffTbl[i]) then
                local NewTbl = {}
                for i = 17, 34 do
                    local info = LuckyEventCfg[i].EnevtName
                    if info ~= name then
                        table.insert(NewTbl, info)
                    end
                end
                name = NewTbl[math.random(1, #NewTbl)]
                return name
            end
        end
    end
    return name
end

--�����¼�����
local function EvevtRun(actor, Event_Name)
    if InTheBox(actor, Event_Name) then return end
    if QiYuHeZi.AddEvent(actor, Event_Name) then
        Message.sendmsg(actor, ssrNetMsgCfg.QiYuHeZi_OpenEventUI, 0, 0, 0, { Event_Name }) --��ǰ���¼�UI
        GameEvent.push(EventCfg.LuckyEventinitVar, actor, Event_Name)                      --�������������ñ���
    end
end

--ִ�������¼����ȡ�¼�
local event = {}
event["�ٻ���"] = function(actor, num)
    local Event_Name = LuckyEventCfg[num].EnevtName
    EvevtRun(actor, Event_Name)
    Message.sendmsg(actor, ssrNetMsgCfg.QiYuZhaoHuan_SyncResponse, 0, 0, 0, { Event_Name })
end
event["������"] = function(actor, num)
    local Event_Name = LuckyEventCfg[num + 8].EnevtName
    EvevtRun(actor, Event_Name)
    Message.sendmsg(actor, ssrNetMsgCfg.QiYuFuBen_SyncResponse, 0, 0, 0, { Event_Name })
end
event["�¼���"] = function(actor, num)
    local _Event_Name = LuckyEventCfg[math.random(17, 34)].EnevtName --���ȡֵ�¼�
    local Event_Name = checkbuff(actor, _Event_Name)                 --buff���� ����ȡ�¼�
    EvevtRun(actor, Event_Name)
end

--ɱ�ִ���
local function _onKillMon(actor, monobj, monName)
    local MonName = monName
    local cfg = LuckyMonCfg[MonName]
    if cfg then
        if randomex(1, cfg.Random_num) then
            local times = getplaydef(actor, VarCfg["N$�������ü��"])
            local state = (times == 0) or ((os.time() - times) >= 300) --��ǰΪ300��
            if state then
                local result1, result2 = ransjstr("�ٻ���#3000|������#4000|�¼���#3000", 1, 3)
                local num = cfg.Map_num
                release_print(result1, num)
                event[result1](actor, num)
                setplaydef(actor, VarCfg["N$�������ü��"], os.time())
            end
        end
    end
end
GameEvent.add(EventCfg.onKillMon, _onKillMon, LuckyEvent)
return LuckyEvent

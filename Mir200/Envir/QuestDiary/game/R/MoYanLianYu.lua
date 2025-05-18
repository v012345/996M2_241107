local MoYanLianYu = {}
MoYanLianYu.ID = "ħ������"
local npcID = 456
local config = include("QuestDiary/cfgcsv/cfg_MoYanLianYu.lua") --����

--��������
function MoYanLianYu.Request1(actor, index)
    if not FCheckNPCRange(actor, npcID, 15) then
        Player.sendmsgEx(actor, "����PNC̫Զ!#249")
        return
    end
    local cfg = config[index]
    if not cfg then
        Player.sendmsgEx(actor, "��������!#249")
        return
    end
    if getflagstatus(actor, cfg.flag) == 1 then
        Player.sendmsgEx(actor, "�����ύ����!#249")
        return
    end
    local cost = cfg.cost
    local name, num = Player.checkItemNumByTable(actor, cost)
    if name then
        Player.sendmsgEx(actor, string.format("���|%s#249|����|%d#249", name, num))
        return
    end
    Player.takeItemByTable(actor, cost, "ħ������")
    setflagstatus(actor, cfg.flag, 1)
    if cfg.flag == 117 then
        local taskPanelID = getplaydef(actor, VarCfg["U_��������������"])
        if taskPanelID == 39 then
            FCheckTaskRedPoint(actor)
        end
    end
    Player.setAttList(actor, "��������")
    MoYanLianYu.SyncResponse(actor)
    Player.sendmsgEx(actor, string.format("%s#249|�ύ�ɹ�,���|�һ𽣷�#249|����|+2%%#249", cost[1][1]))
end

function MoYanLianYu.Request2(actor)
    if checktitle(actor, "ħ���ƿ���") then
        Player.sendmsgEx(actor, "���Ѿ�ӵ���˸ĳƺ�!#249")
        return
    end
    local result = true
    for index, value in ipairs(config) do
        if getflagstatus(actor, value.flag) == 0 then
            result = false
            break
        end
    end
    if result then
        confertitle(actor, "ħ���ƿ���")
        Player.sendmsgEx(actor, "��ϲ���óƺ�:|ħ���ƿ���#249")
    else
        Player.sendmsgEx(actor, "��û���ύȫ��!#249")
    end
end

--ͬ����Ϣ
function MoYanLianYu.SyncResponse(actor, logindatas)
    local data = {}
    for index, value in ipairs(config) do
        data[index] = getflagstatus(actor, value.flag)
    end
    local _login_data = { ssrNetMsgCfg.MoYanLianYu_SyncResponse, 0, 0, 0, data }
    if logindatas then
        table.insert(logindatas, _login_data)
    else
        Message.sendmsg(actor, ssrNetMsgCfg.MoYanLianYu_SyncResponse, 0, 0, 0, data)
    end
end

--��¼����
local function _onLoginEnd(actor, logindatas)
    MoYanLianYu.SyncResponse(actor, logindatas)
end
--�¼��ɷ�
GameEvent.add(EventCfg.onLoginEnd, _onLoginEnd, MoYanLianYu)


--�������Դ���
local function _onAddSkillPower(actor, attrs)
    --���������ۼ�
    local shuxing = {}
    local sum = 0
    for _, value in ipairs(config) do
        if getflagstatus(actor, value.flag) == 1 then
            sum = sum + value.addNum
        end
    end
    if sum > 0 then
        shuxing["�һ𽣷�"] = sum
        calcAtts(attrs, shuxing, "ħ������������������")
    end
end
GameEvent.add(EventCfg.onAddSkillPower, _onAddSkillPower, MoYanLianYu)
--����ҹ�������
local function _onStruckDamagePlayer(actor, Target, Hiter, MagicId, Damage, attackDamageData)
    if checktitle(actor, "ħ���ƿ���") then
        if MagicId == 26 then
            attackDamageData.damage = attackDamageData.damage + math.ceil(Damage * 0.06)
        end
    end
end
GameEvent.add(EventCfg.onStruckDamagePlayer, _onStruckDamagePlayer, MoYanLianYu)
local function _onAttackPlayer(actor, Target, Hiter, MagicId)
    if MagicId == 26 then
        if randomex(5) then
            if checktitle(actor, "ħ���ƿ���") then
                changemode(actor,18,1,1,1)
                Player.buffTipsMsg(actor, "[ħ���ƿ���]:�������Ŀ��1��...")
                Player.buffTipsMsg(Target, "[ħ���ƿ���]:�㱻�����һ��...")
            end
        end
    end
end
GameEvent.add(EventCfg.onAttackPlayer, _onAttackPlayer, MoYanLianYu)
--ע��������Ϣ
Message.RegisterNetMsg(ssrNetMsgCfg.MoYanLianYu, MoYanLianYu)
return MoYanLianYu

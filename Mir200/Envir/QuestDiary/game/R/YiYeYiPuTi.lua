local YiYeYiPuTi = {}
YiYeYiPuTi.ID = "һҶһ����"
local npcID = 514
local config = include("QuestDiary/cfgcsv/cfg_YiYeYiPuTi.lua") --����
local cost = { { "Ѫ����", 1 } }
local give = { {} }
function deng_ji_shang_xian_ti_shi(actor)
    if not FCheckNPCRange(actor, npcID, 15) then
        Player.sendmsgEx(actor, "����PNC̫Զ!#249")
        return
    end
    local name, num = Player.checkItemNumByTable(actor, cost)
    if name then
        Player.sendmsgEx(actor, string.format("���|%s#249|����|%d#249", name, num))
        return
    end
    Player.takeItemByTable(actor, cost, "һҶһ����")
    local count = getplaydef(actor, VarCfg["U_����_һҶһ����_����"])
    if count < 10 then
        setplaydef(actor, VarCfg["U_����_һҶһ����_����"], count + 1)
    end
    Player.sendmsgEx(actor, "�ύ�ɹ�,���Դ������!")
    Player.setAttList(actor, "���Ը���")
    YiYeYiPuTi.SyncResponse(actor)
end
--��������
function YiYeYiPuTi.Request(actor)
    if not FCheckNPCRange(actor, npcID, 15) then
        Player.sendmsgEx(actor, "����PNC̫Զ!#249")
        return
    end
    local name, num = Player.checkItemNumByTable(actor, cost)
    if name then
        Player.sendmsgEx(actor, string.format("���|%s#249|����|%d#249", name, num))
        return
    end
    local count = getplaydef(actor, VarCfg["U_����_һҶһ����_����"])
    local liveMax = getplaydef(actor,VarCfg["U_�ȼ�����"])
    local myLevel = getbaseinfo(actor, ConstCfg.gbase.level)
    local currMaxExp = getbaseinfo(actor, ConstCfg.gbase.maxexp)
    local currMaxExpPer = calculatePercentageResult(currMaxExp, 30)
    if count >= 10  then
        if myLevel >= liveMax then
            Player.sendmsgEx(actor, "���Ѿ��ﵽ�ȼ�����,�޷�����ʹ��!#249")
            return
        end
        Player.sendmsgEx(actor, "�ύ�ɹ�,��������30%!")
        changeexp(actor, "+", currMaxExpPer, false)
        Player.takeItemByTable(actor, cost, "һҶһ����")
    else
        if myLevel >= liveMax then
            messagebox(actor,"��ĵȼ��Ѿ��ﵽ����,����ʹ�ý������þ���,�Ƿ����?","@deng_ji_shang_xian_ti_shi","@deng_ji_shang_xian_ti_shi_qu_xiao")
        else
            setplaydef(actor, VarCfg["U_����_һҶһ����_����"], count + 1)
            Player.sendmsgEx(actor, "�ύ�ɹ�,���Դ������,��������30%!")
            changeexp(actor, "+", currMaxExpPer, false)
            Player.setAttList(actor, "���Ը���")
            Player.takeItemByTable(actor, cost, "һҶһ����")
            YiYeYiPuTi.SyncResponse(actor)
        end
        
    end
end

--ͬ����Ϣ
function YiYeYiPuTi.SyncResponse(actor, logindatas)
    local data = {}
    local count = getplaydef(actor, VarCfg["U_����_һҶһ����_����"])
    local _login_data = { ssrNetMsgCfg.YiYeYiPuTi_SyncResponse, count, 0, 0, data }
    if logindatas then
        table.insert(logindatas, _login_data)
    else
        Message.sendmsg(actor, ssrNetMsgCfg.YiYeYiPuTi_SyncResponse, count, 0, 0, data)
    end
end

--��¼����
local function _onLoginEnd(actor, logindatas)
    YiYeYiPuTi.SyncResponse(actor, logindatas)
end
--�¼��ɷ�
GameEvent.add(EventCfg.onLoginEnd, _onLoginEnd, YiYeYiPuTi)

local function _onTakeOnEx(actor, itemobj, where, itemname, makeid)
    if itemname == "�����" then
        Player.setAttList(actor, "���ٸ���")
    elseif itemname == "������" then
        Player.setAttList(actor, "��������")
        Player.setAttList(actor, "��Ѫ����")
    end
end
GameEvent.add(EventCfg.onTakeOnEx, _onTakeOnEx, YiYeYiPuTi)

local function _onTakeOffEx(actor, itemobj, where, itemname, makeid)
    if itemname == "�����" then
        Player.setAttList(actor, "���ٸ���")
    elseif itemname == "������" then
        Player.setAttList(actor, "��������")
        Player.setAttList(actor, "��Ѫ����")
    end
end
GameEvent.add(EventCfg.onTakeOffEx, _onTakeOffEx, YiYeYiPuTi)

local function _onCalcAttackSpeed(actor, attackSpeeds)
    if checkitemw(actor, "�����", 1) then
        attackSpeeds[1] = attackSpeeds[1] + 4
    end
end
GameEvent.add(EventCfg.onCalcAttackSpeed, _onCalcAttackSpeed, YiYeYiPuTi)
--��������
local function _onAddSkillPower(actor, attrs)
    if checkitemw(actor, "������", 1) then
        local shuxing = {}
        shuxing["�һ𽣷�"] = -10
        shuxing["����ն"] = -10
        shuxing["���ս���"] = -10
        calcAtts(attrs, shuxing, "�����ļ�����������")
    end
end
GameEvent.add(EventCfg.onAddSkillPower, _onAddSkillPower, YiYeYiPuTi)

--��������
local function _onCalcAttr(actor, attrs)
    local count = getplaydef(actor, VarCfg["U_����_һҶһ����_����"])
    if count > 10 then
        count = 10 
    end
    if count > 0 then
        local shuxing = {}
        for _, value in ipairs(config) do
            for _, v in ipairs(value.attrs) do
                shuxing[v] = count * value.addNum
            end
        end
        calcAtts(attrs, shuxing, "һҶһ�������Լ���")
    end
end
GameEvent.add(EventCfg.onCalcAttr, _onCalcAttr, YiYeYiPuTi)
--ע��������Ϣ
Message.RegisterNetMsg(ssrNetMsgCfg.YiYeYiPuTi, YiYeYiPuTi)
return YiYeYiPuTi

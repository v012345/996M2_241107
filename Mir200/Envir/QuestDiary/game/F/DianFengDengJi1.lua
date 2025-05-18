local DianFengDengJi1 = {}
DianFengDengJi1.ID = "�۷�ȼ�"
local npcID = 422
local attGroup = "�۷�ȼ�����"
local config = include("QuestDiary/cfgcsv/cfg_DianFengDengJi1.lua") --����
-- ����ɽ������ꡤ����
-- ����ɽ������ꡤ����
-- ����ɽ������ꡤ����
function dian_feng_deng_ji_one(actor)
    local level = getplaydef(actor, VarCfg["U_�۷�ȼ�1"])
    local perAtt = 0
    if level > 0 then
        local cfg = config[level]
        if not cfg then
            return
        end
        perAtt = cfg.perNum or 0
        local qiegeStr = ""
        if checktitle(actor,"����ɽ������ꡤ����") then
            local gongJi = getbaseinfo(actor, ConstCfg.gbase.dc2)
            perAtt = 0.3
            qiegeStr = "|3#200#"..math.ceil(gongJi * 0.08)
        end
        local daoShu = getbaseinfo(actor, ConstCfg.gbase.sc2)
        local addGongJiStr = "3#4#"..math.ceil(daoShu * perAtt) .. qiegeStr
        addattlist(actor, attGroup, "=", addGongJiStr, 1)
        callscriptex(actor,"SENDMSG",5,"�۷�ȼ������Ѿ�����!")
    end
end
--��������
local function dianFengAddAtt(actor)
    delattlist(actor, attGroup)
    --����Ѿ���3���ˣ����ټ���
    local dfThree = getplaydef(actor, VarCfg["U_�۷�ȼ�3"])
    if dfThree > 0 then
        return
    end
    if checktitle(actor,"����ɽ������ꡤ����") then
        return
    end
    if checktitle(actor,"����ɽ������ꡤ����") then
        return
    end
    delaygoto(actor,1500,"dian_feng_deng_ji_one")
end
function DianFengDengJi1.Request(actor, costType)
    if checktitle(actor,"����ɽ������ꡤ����") then
        Player.sendmsgEx(actor,"�Ѿ�������#249")
        return
    end
    if checktitle(actor,"����ɽ������ꡤ����") then
        Player.sendmsgEx(actor,"�Ѿ�������#249")
        return
    end
    if checktitle(actor,"����ɽ������ꡤ����") then
        Player.sendmsgEx(actor,"�Ѿ�������#249")
        return
    end
    if costType ~= 1 and costType ~= 2 then
        Player.sendmsgEx(actor,"��������!")
        return
    end
    local level = getplaydef(actor, VarCfg["U_�۷�ȼ�1"])
    local nextLevel = level + 1
    local cfg = config[nextLevel]
    if not cfg then
        Player.sendmsgEx(actor,"�Ѿ�������#249")
        return
    end
    local cost
    if costType == 1 then
        cost = cfg.cost1
    else
        cost = cfg.cost2
    end
    local name, num = Player.checkItemNumByTable(actor, cost)
    if name then
        Player.sendmsgEx(actor, string.format("���|%s#249|����|%d#249", name, num))
        return
    end
    Player.takeItemByTable(actor, cost,"�۷�ȼ�")
    setplaydef(actor, VarCfg["U_�۷�ȼ�1"], nextLevel)
    local maxLevel = getplaydef(actor, VarCfg["U_�ȼ�����"])
    maxLevel = maxLevel + 1
    setplaydef(actor,VarCfg["U_�ȼ�����"], maxLevel)
    setlocklevel(actor, 1, maxLevel)
    Player.sendmsgEx(actor, "�۷�ȼ������ɹ�!")
    if nextLevel >= 10 then
        confertitle(actor, "����ɽ������ꡤ����")
        messagebox(actor,"��ϲ���óƺš�����ɽ������ꡤ������")
    end
    DianFengDengJi1.SyncResponse(actor)
end
--ͬ����Ϣ
function DianFengDengJi1.SyncResponse(actor, logindatas)
    local level = getplaydef(actor, VarCfg["U_�۷�ȼ�1"])
    dianFengAddAtt(actor) --��������
    local data = {}
    local _login_data = {ssrNetMsgCfg.DianFengDengJi1_SyncResponse, level, 0, 0, data}
    if logindatas then
        table.insert(logindatas, _login_data)
    else
        Message.sendmsg(actor, ssrNetMsgCfg.DianFengDengJi1_SyncResponse, level, 0, 0, data)
    end
end
--��¼����
local function _onLoginEnd(actor, logindatas)
    DianFengDengJi1.SyncResponse(actor, logindatas)
end
--�¼��ɷ�
GameEvent.add(EventCfg.onLoginEnd, _onLoginEnd, DianFengDengJi1)

local function _onTakeOnEx(actor, itemobj, where, itemname, makeid)
    dianFengAddAtt(actor)
end
GameEvent.add(EventCfg.onTakeOnEx, _onTakeOnEx, DianFengDengJi1)

local function _onTakeOffEx(actor, itemobj, where, itemname, makeid)
    dianFengAddAtt(actor)
end
GameEvent.add(EventCfg.onTakeOffEx, _onTakeOffEx, DianFengDengJi1)

--ע��������Ϣ
Message.RegisterNetMsg(ssrNetMsgCfg.DianFengDengJi1, DianFengDengJi1)
return DianFengDengJi1
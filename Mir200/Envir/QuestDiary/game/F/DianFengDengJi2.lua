local DianFengDengJi2 = {}
DianFengDengJi2.ID = "�۷�ȼ�"
local npcID = 626
local config = include("QuestDiary/cfgcsv/cfg_DianFengDengJi2.lua") --����
-- ����ɽ������ꡤ����
-- ����ɽ������ꡤ����
-- ����ɽ������ꡤ����
--��������
function dian_feng_deng_ji_tow(actor)
    -- release_print(attStr,"����")
    local level = getplaydef(actor, VarCfg["U_�۷�ȼ�2"])
    local perAtt = 0
    local mofaTOhp = 0
    if level > 0 then
        local cfg = config[level]
        mofaTOhp = cfg.perNum or 0
        local qiegeStr = ""
        if checktitle(actor,"����ɽ������ꡤ����") then
            local gongJi = getbaseinfo(actor, ConstCfg.gbase.dc2)
            perAtt = 0.3
            mofaTOhp = 8
            qiegeStr = "|3#200#"..math.ceil(gongJi * 0.15)
        end
        local daoShu = getbaseinfo(actor, ConstCfg.gbase.sc2)
        local moFa = getbaseinfo(actor, ConstCfg.gbase.mc2)
        local mofaTOhpStr = "|3#1#"..math.ceil(moFa * mofaTOhp)
        local addGongJiStr = "3#4#"..math.ceil(daoShu * perAtt) .. qiegeStr .. mofaTOhpStr
        addattlist(actor, "�۷�ȼ�2����", "=", addGongJiStr, 1)
        callscriptex(actor,"SENDMSG",5,"�۷�ȼ������Ѿ�����!")
    end
end
local function dianFengAddAtt(actor)
    delattlist(actor,"�۷�ȼ�2����")
    --����Ѿ���3���ˣ����ټ���
    local dfThree = getplaydef(actor, VarCfg["U_�۷�ȼ�3"])
    if dfThree > 0 then
        return
    end
    if checktitle(actor,"����ɽ������ꡤ����") then
        return
    end
    local level = getplaydef(actor, VarCfg["U_�۷�ȼ�2"])
    if level > 0 then
        delaygoto(actor,1500,"dian_feng_deng_ji_tow")
    end
end
function DianFengDengJi2.Request(actor, costType)
    
    if checktitle(actor,"����ɽ������ꡤ����") then
        Player.sendmsgEx(actor,"�Ѿ�������#249")
        return
    end
    if checktitle(actor,"����ɽ������ꡤ����") then
        Player.sendmsgEx(actor,"�Ѿ�������#249")
        return
    end
    if not checktitle(actor,"����ɽ������ꡤ����") then
        Player.sendmsgEx(actor,"�����۷�ȼ��������ſ��Լ�������#249")
        return
    end
    if costType ~= 1 and costType ~= 2 then
        Player.sendmsgEx(actor,"��������!")
        return
    end
    local level = getplaydef(actor, VarCfg["U_�۷�ȼ�2"])
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
    setplaydef(actor, VarCfg["U_�۷�ȼ�2"], nextLevel)
    local maxLevel = getplaydef(actor, VarCfg["U_�ȼ�����"])
    maxLevel = maxLevel + 1
    setplaydef(actor,VarCfg["U_�ȼ�����"], maxLevel)
    setlocklevel(actor, 1, maxLevel)
    Player.sendmsgEx(actor, "�۷�ȼ������ɹ�!")
    if nextLevel >= 10 then
        deprivetitle(actor, "����ɽ������ꡤ����")
        confertitle(actor, "����ɽ������ꡤ����")
        delattlist(actor, "�۷�ȼ�����")
        messagebox(actor,"��ϲ���óƺš�����ɽ������ꡤ������")
    end
    DianFengDengJi2.SyncResponse(actor)
end
--ͬ����Ϣ
function DianFengDengJi2.SyncResponse(actor, logindatas)
    local level = getplaydef(actor, VarCfg["U_�۷�ȼ�2"])
    dianFengAddAtt(actor) --��������
    local data = {}
    local _login_data = {ssrNetMsgCfg.DianFengDengJi2_SyncResponse, level, 0, 0, data}
    if logindatas then
        table.insert(logindatas, _login_data)
    else
        Message.sendmsg(actor, ssrNetMsgCfg.DianFengDengJi2_SyncResponse, level, 0, 0, data)
    end
end
--��¼����
local function _onLoginEnd(actor, logindatas)
    DianFengDengJi2.SyncResponse(actor, logindatas)
end
--�¼��ɷ�
GameEvent.add(EventCfg.onLoginEnd, _onLoginEnd, DianFengDengJi2)

local function _onTakeOnEx(actor, itemobj, where, itemname, makeid)
    dianFengAddAtt(actor)
end
GameEvent.add(EventCfg.onTakeOnEx, _onTakeOnEx, DianFengDengJi2)

local function _onTakeOffEx(actor, itemobj, where, itemname, makeid)
    dianFengAddAtt(actor)
end
GameEvent.add(EventCfg.onTakeOffEx, _onTakeOffEx, DianFengDengJi2)

--ע��������Ϣ
Message.RegisterNetMsg(ssrNetMsgCfg.DianFengDengJi2, DianFengDengJi2)
return DianFengDengJi2
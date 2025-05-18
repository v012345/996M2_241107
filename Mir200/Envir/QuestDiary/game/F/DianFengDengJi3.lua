local DianFengDengJi3 = {}
DianFengDengJi3.ID = "�۷�ȼ�3"
local npcID = 712
local config = include("QuestDiary/cfgcsv/cfg_DianFengDengJi3.lua") --����
-- ����ɽ������ꡤ����
-- ����ɽ������ꡤ����
-- ����ɽ������ꡤ����

function dian_feng_deng_ji_three(actor)
    -- release_print(attrStr,"����")
    local level = getplaydef(actor, VarCfg["U_�۷�ȼ�3"])
    --����ת��������
    local perAtt1 = 0
    --ħ��ת��������
    local perAtt2 = 0
    if level > 0 then
        local cfg = config[level]
        perAtt1 = cfg.perNum1 or 0
        perAtt2 = cfg.perNum2 or 0
        --���㹥��ת�и�
        local qiegeStr = ""
        local gongJi = getbaseinfo(actor, ConstCfg.gbase.dc2)
        if checktitle(actor,"����ɽ������ꡤ����") then
            qiegeStr = "3#200#"..math.ceil(gongJi * 0.30)
        else
            qiegeStr = "3#200#"..math.ceil(gongJi * 0.15)
        end
        local daoShu = getbaseinfo(actor, ConstCfg.gbase.sc2) --��ȡ��������
        local moFa = getbaseinfo(actor, ConstCfg.gbase.mc2) --��ȡħ������
        local addGongJiStr = "3#4#"..math.ceil(daoShu * perAtt1)
        local moFaToHpStr = "3#1#"..math.ceil(moFa * perAtt2)
        local atts = {addGongJiStr,moFaToHpStr,qiegeStr}
        local attStr = table.concat(atts, "|")
        addattlist(actor, "�۷�ȼ�3����", "=", attStr, 1)
        callscriptex(actor,"SENDMSG",5,"�۷�ȼ������Ѿ�����!")
    end
end
local function dianFengAddAtt(actor)
    local level = getplaydef(actor, VarCfg["U_�۷�ȼ�3"])
    if level > 0 then
        delattlist(actor,"�۷�ȼ�3����")
        delaygoto(actor,1500,"dian_feng_deng_ji_three")
    end
end
--��������
function DianFengDengJi3.Request(actor, costType)
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
    local level = getplaydef(actor, VarCfg["U_�۷�ȼ�3"])
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
    Player.takeItemByTable(actor, cost,"�۷�ȼ�3")
    setplaydef(actor, VarCfg["U_�۷�ȼ�3"], nextLevel)
    local maxLevel = getplaydef(actor, VarCfg["U_�ȼ�����"])
    maxLevel = maxLevel + 1
    setplaydef(actor,VarCfg["U_�ȼ�����"], maxLevel)
    setlocklevel(actor, 1, maxLevel)
    Player.sendmsgEx(actor, "�۷�ȼ������ɹ�!")
    delattlist(actor, "�۷�ȼ�2����")
    if nextLevel >= 10 then
        deprivetitle(actor, "����ɽ������ꡤ����")
        confertitle(actor, "����ɽ������ꡤ����")
        messagebox(actor,"��ϲ���óƺš�����ɽ������ꡤ������")
    end
    DianFengDengJi3.SyncResponse(actor)
end
--ͬ����Ϣ
function DianFengDengJi3.SyncResponse(actor, logindatas)
    local level = getplaydef(actor, VarCfg["U_�۷�ȼ�3"])
    dianFengAddAtt(actor) --��������
    local data = {}
    local _login_data = {ssrNetMsgCfg.DianFengDengJi3_SyncResponse, level, 0, 0, data}
    if logindatas then
        table.insert(logindatas, _login_data)
    else
        Message.sendmsg(actor, ssrNetMsgCfg.DianFengDengJi3_SyncResponse, level, 0, 0, data)
    end
end
--��¼����
local function _onLoginEnd(actor, logindatas)
    DianFengDengJi3.SyncResponse(actor, logindatas)
end
--�¼��ɷ�
GameEvent.add(EventCfg.onLoginEnd, _onLoginEnd, DianFengDengJi3)

local function _onTakeOnEx(actor, itemobj, where, itemname, makeid)
    dianFengAddAtt(actor)
end
GameEvent.add(EventCfg.onTakeOnEx, _onTakeOnEx, DianFengDengJi3)

local function _onTakeOffEx(actor, itemobj, where, itemname, makeid)
    dianFengAddAtt(actor)
end
GameEvent.add(EventCfg.onTakeOffEx, _onTakeOffEx, DianFengDengJi3)

--ע��������Ϣ
Message.RegisterNetMsg(ssrNetMsgCfg.DianFengDengJi3, DianFengDengJi3)
return DianFengDengJi3
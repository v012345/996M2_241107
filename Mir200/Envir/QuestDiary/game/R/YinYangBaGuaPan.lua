local YinYangBaGuaPan = {}
YinYangBaGuaPan.ID = "����������"
local npcID = 448
local cfg_ZhuangBan = include("QuestDiary/cfgcsv/cfg_ZhuangBan.lua")       --����
--local config = include("QuestDiary/cfgcsv/cfg_YinYangBaGuaPan.lua") --����
local cost1 = { { "��", 1 }, { "Ԫ��", 100000 } }
local cost2 = { { "��", 1 }, { "Ԫ��", 100000 } }
function YinYangBaGuaPan.checkTitle(actor)
    local yin = getplaydef(actor, VarCfg["U_����_����������_��"])
    local yang = getplaydef(actor, VarCfg["U_����_����������_��"])
    if yin >= 66 and yang >= 66 then
        confertitle(actor, "������һ")
        messagebox(actor,"��ϲ���óƺ�[������һ]")
    end
end
--��������
function YinYangBaGuaPan.Request1(actor)
    local cost = cost1
    local yin = getplaydef(actor, VarCfg["U_����_����������_��"])
    local yang = getplaydef(actor, VarCfg["U_����_����������_��"])
    if yin >= 66 then
        Player.sendmsgEx(actor, "�����ֻ���ύ66��")
        return
    end
    local name, num = Player.checkItemNumByTable(actor, cost)
    if name then
        Player.sendmsgEx(actor, string.format("���|%s#249|����|%d#249", name, num))
        return
    end
    Player.takeItemByTable(actor, cost, "����������")
    setplaydef(actor, VarCfg["U_����_����������_��"], yin + 1)
    if yin + 1 == 1 then
        local taskPanelID = getplaydef(actor, VarCfg["U_��������������"])
        if taskPanelID == 34 then
            FCheckTaskRedPoint(actor)
        end
    end
    Player.sendmsgEx(actor, string.format("�ύ�ɹ���ǰ�ύ����Ϊ|%d#249", yin + 1))
    if yin + 1 ~= yang then
        if yin + 1 > yang then
            Player.sendmsgEx(actor, "ע��!��ǰ��������ƽ��,ֻ��|[��]#249|���Ի�����Լӳ�")
        else
            Player.sendmsgEx(actor, "ע��!��ǰ��������ƽ��,ֻ��|[��]#249|���Ի�����Լӳ�")
        end
    else
        Player.sendmsgEx(actor, "��ǰ��������ƽ��,�����Ի�����Լӳ�")
    end
    YinYangBaGuaPan.checkTitle(actor)
    Player.setAttList(actor, "���Ը���")
    YinYangBaGuaPan.SyncResponse(actor)
end

--��������
function YinYangBaGuaPan.Request2(actor)
    local cost = cost2
    local yin = getplaydef(actor, VarCfg["U_����_����������_��"])
    local yang = getplaydef(actor, VarCfg["U_����_����������_��"])
    if yang >= 66 then
        Player.sendmsgEx(actor, "�����ֻ���ύ66��")
        return
    end
    local name, num = Player.checkItemNumByTable(actor, cost)
    if name then
        Player.sendmsgEx(actor, string.format("���|%s#249|����|%d#249", name, num))
        return
    end
    Player.takeItemByTable(actor, cost, "����������")
    setplaydef(actor, VarCfg["U_����_����������_��"], yang + 1)
    if yang + 1 == 1 then
        local taskPanelID = getplaydef(actor, VarCfg["U_��������������"])
        if taskPanelID == 34 then
            FCheckTaskRedPoint(actor)
        end
    end
    Player.sendmsgEx(actor, string.format("�ύ�ɹ���ǰ�ύ����Ϊ|%d#249", yang + 1))
    if yin ~= yang + 1 then
        if yin > yang + 1 then
            Player.sendmsgEx(actor, "ע��!��ǰ��������ƽ��,ֻ��|[��]#249|���Ի�����Լӳ�")
        else
            Player.sendmsgEx(actor, "ע��!��ǰ��������ƽ��,ֻ��|[��]#249|���Ի�����Լӳ�")
        end
    else
        Player.sendmsgEx(actor, "��ǰ��������ƽ��,�����Ի�����Լӳ�")
    end
    YinYangBaGuaPan.checkTitle(actor)
    Player.setAttList(actor, "���Ը���")
    YinYangBaGuaPan.SyncResponse(actor)
end

--ͬ����Ϣ
function YinYangBaGuaPan.SyncResponse(actor, logindatas)
    local data = {}
    local yin = getplaydef(actor, VarCfg["U_����_����������_��"])
    local yang = getplaydef(actor, VarCfg["U_����_����������_��"])
    local _login_data = { ssrNetMsgCfg.YinYangBaGuaPan_SyncResponse, yin, yang, 0, data }
    if logindatas then
        table.insert(logindatas, _login_data)
    else
        Message.sendmsg(actor, ssrNetMsgCfg.YinYangBaGuaPan_SyncResponse, yin, yang, 0, data)
    end
end

--��¼����
local function _onLoginEnd(actor, logindatas)
    YinYangBaGuaPan.SyncResponse(actor, logindatas)
end
--�¼��ɷ�
GameEvent.add(EventCfg.onLoginEnd, _onLoginEnd, YinYangBaGuaPan)

local function _onCalcAttr(actor, attrs)
    local shuxing = {}
    if not checktitle(actor,"������һ") then
        local yin = getplaydef(actor, VarCfg["U_����_����������_��"])
        local yang = getplaydef(actor, VarCfg["U_����_����������_��"])
        local isAllAttr
        --�����Ƿ�ƽ��
        if yin == yang then
            isAllAttr = true
        else
            isAllAttr = false
        end
        local attType
        if yin > yang then
            attType = true
        else
            attType = false
        end
        if yin > 0 and isAllAttr or attType then
            shuxing[68] = yin * 100
            local attackPer = math.floor(yin / 10)
            if attackPer > 0 then
                shuxing[206] = attackPer
            end
        end
        if yang > 0 and isAllAttr or not attType then
            shuxing[200] = yang * 100
            local hpPer = math.floor(yang / 10)
            if hpPer > 0 then
                shuxing[207] = hpPer
            end
        end
    else
        local number = getplaydef(actor, VarCfg["U_ʱװ��ۼ�¼"])
        if number > 0 then
            local cfg = cfg_ZhuangBan[number]
            if cfg then
                if cfg.gender == 1 then
                    shuxing[208] = 10
                elseif cfg.gender == 2 then
                    shuxing[210] = 10
                    shuxing[221] = 10
                end
            end
        end
    end

    calcAtts(attrs, shuxing, "�������Ծ�")
end
GameEvent.add(EventCfg.onCalcAttr, _onCalcAttr, YinYangBaGuaPan)

--ע��������Ϣ
Message.RegisterNetMsg(ssrNetMsgCfg.YinYangBaGuaPan, YinYangBaGuaPan)
return YinYangBaGuaPan

local KuangFengXiLian = {}
local config = include("QuestDiary/cfgcsv/cfg_KuangFengXiLian.lua") --ϴ��
local where = 14
KuangFengXiLian.ID = "���ϴ��"
function KuangFengXiLian.Request(actor, arg1, arg2, arg3, locks)
    local itemobj = linkbodyitem(actor, where)
    if itemobj == "0" then
        Player.sendmsgEx(actor, "������û�п��װ��!#249")
        return
    end

    local name = getiteminfo(actor,itemobj,ConstCfg.iteminfo.name)
    if name ~= "�����ӡLv.10" then
        Player.sendmsgEx(actor, "�����ӡLv.10�ſ���ϴ��!#249")
        return
    end

    if type(locks) ~= "table" then
        Player.sendmsgEx(actor, "���ݴ���1")
        return
    end
    if #locks ~= 5 then
        Player.sendmsgEx(actor, "���ݴ���2")
        return
    end

    local abilDataStr = getitemcustomabil(actor, itemobj)
    local isMaxLevel = KuangFengXiLian.IsMaxLevel(abilDataStr)
    if isMaxLevel then
        Player.sendmsgEx(actor, "����ϴ���Ѿ�������!#249")
        return
    end
    --�ۼ�Ԫ��
    local costYuanBao = { { "Ԫ��", 100000 } }
    for i, v in ipairs(locks) do
        if v ~= 0 then
            costYuanBao[1][2] = costYuanBao[1][2] + 200000
        end
    end

    local count = getplaydef(actor, VarCfg["U_ϴ��Ԫ������"])
    local name,mum = Player.checkItemNumByTable(actor,costYuanBao)
    if name then
        Player.sendmsgEx(actor, string.format("ϴ��ʧ��,���|%s#249|����|%d#249|", name, mum))
        return
    end

    Player.takeItemByTable(actor,costYuanBao,"���ϴ��")

    setplaydef(actor, VarCfg["U_ϴ��Ԫ������"], count + costYuanBao[1][2])

    GameEvent.push(EventCfg.onKuangFengXiLian,actor,count + costYuanBao[1][2])

    changecustomitemtext(actor, itemobj, "[ϴ������]:", 0)
    changecustomitemtextcolor(actor, itemobj, 250, 0)
    for index, value in ipairs(config) do
        if locks[index] == 0 then
            local attrValue = 0
            if index == 5 then
                attrValue = math.random(1, value.ransjstr)
                setplaydef(actor, VarCfg["U_��¼�����ӡ���ʱ���"], tonumber(attrValue) or 0)
            else
                local str = table.concat(value.ransjstr, "|")
                attrValue = ransjstr(str,1,3)
            end
            attrValue = tonumber(attrValue) or 0
            Player.addModifyCustomAttributes(actor, itemobj, 0, index, value.attrType, value.attrColor, value.realAttrId, value.attrId, value.isAttrPercent, attrValue)
        end
    end

    local costCount = getplaydef(actor, VarCfg["U_ϴ��Ԫ������"])
    if costCount >= 9990000 then
        for index, value in ipairs(config) do
            if index == 5 then
                setplaydef(actor, VarCfg["U_��¼�����ӡ���ʱ���"], value.max)
            end
            Player.addModifyCustomAttributes(actor, itemobj, 0, index, value.attrType, value.attrColor, value.realAttrId, value.attrId, value.isAttrPercent, value.max)
        end

        changecustomitemtext(actor, itemobj, "[��������]", 1)
        changecustomitemtextcolor(actor, itemobj, 254, 1)
        --��־���
        Player.addModifyCustomAttributes(actor, itemobj, 1, 6, 2, 255, 203, 6 , 1, 100)
        --�������ֵ
        Player.addModifyCustomAttributes(actor, itemobj, 1, 7, 2, 255, 217, 7 , 1, 100)
        -- Player.addModifyCustomAttributes(actor, itemobj, 1, 8, 2, 255, 204, 8 , 0, 1)
        messagebox(actor,"�������׻���,��������Ѿ��ﵽ999wԪ��,������ȫ��!")
    end
    --ͬ��һ����Ϣ
    Player.setAttList(actor, "���ʸ���")
    KuangFengXiLian.SyncResponse(actor)
end
--�ж�ϴ���Ƿ�����
function KuangFengXiLian.IsMaxLevel(abilDataStr)
    local maxLevel = 0
    if abilDataStr == "" then
        return false
    end
    local abilData = json2tbl(abilDataStr)
    local abilList1 = abilData["abil"][1].v
    local abilList2 = abilData["abil"][2].v
    if abilList1 then
        for i, v in ipairs(config) do
            if abilList1[i] then
                if abilList1[i][3] >= v.max then
                    maxLevel = maxLevel + 1
                end
            end
        end
    end

    if maxLevel >= 5 and abilList2 ~= nil then
        return true
    else
        return false
    end
end


--��������
local function _onCalcBaoLv(actor, attrs)
    local shuxing = {}
    local equipObj = linkbodyitem(actor, where)
    local baolv = 0
    if equipObj ~= "0" then
        baolv = getplaydef(actor, VarCfg["U_��¼�����ӡ���ʱ���"])
    end
    if baolv > 0 then
        shuxing[204] = baolv
    end
    calcAtts(attrs, shuxing, "���ʸ���:���ϴ��")
end
GameEvent.add(EventCfg.onCalcBaoLv, _onCalcBaoLv, KuangFengXiLian)

-------------������Ϣ������--------------------------
Message.RegisterNetMsg(ssrNetMsgCfg.KuangFengXiLian, KuangFengXiLian)
function KuangFengXiLian.SyncResponse(actor, logindatas)
    local count = getplaydef(actor, VarCfg["U_ϴ��Ԫ������"])
    local _login_data = { ssrNetMsgCfg.KuangFengXiLian_SyncResponse, count }
    if logindatas then
        table.insert(logindatas, _login_data)
    else
        Message.sendmsg(actor, ssrNetMsgCfg.KuangFengXiLian_SyncResponse, count)
    end
end

--��¼����
local function _onLoginEnd(actor, logindatas)
    KuangFengXiLian.SyncResponse(actor, logindatas)
end
--�¼��ɷ�
GameEvent.add(EventCfg.onLoginEnd, _onLoginEnd, KuangFengXiLian)

--��װ��
local function _onTakeOn14(actor, itemobj)
    Player.setAttList(actor, "���ʸ���")
end
GameEvent.add(EventCfg.onTakeOn14, _onTakeOn14, KuangFengXiLian)

--��װ��Ŷ
local function _onTakeOff14(actor, itemobj)
    Player.setAttList(actor, "���ʸ���")
end
GameEvent.add(EventCfg.onTakeOff14, _onTakeOff14, KuangFengXiLian)

return KuangFengXiLian

local ShenHunJianJia = {}
ShenHunJianJia.ID = "��꽣��"
local npcID = 802
local config = include("QuestDiary/cfgcsv/cfg_ShenHunJianJia.lua") --����
local abilGroup = 3                                                      --�Զ�������λ��
function ShenHunJianJia.Request(actor, where, arg2)
    local isInRange = FCheckNPCRange(actor, npcID, 15)
    if not isInRange then
        Player.sendmsgEx(actor, "����̫Զ#249")
        return
    end
    if where ~= 1 and where ~= 0 then
        Player.sendmsgEx(actor, "[��ʾ]:#251|������·���������!#249")
        return
    end

    local itemobj = linkbodyitem(actor, where)
    if itemobj == "0" then
        if where == 1 then
            Player.sendmsgEx(actor, "��ʾ��#251|���#250|����#249|��λ#250|û��װ��#249|ǿ��ʧ��...#250")
        else
            Player.sendmsgEx(actor, "��ʾ��#251|���#250|�·�#249|��λ#250|û��װ��#249|ǿ��ʧ��...#250")
        end
        return
    end

    local B_var
    local equipName = ""
    local realAttrId
    local attrId

    if where == 1 then
        B_var = VarCfg["B_�������"]
        equipName = "����"
        realAttrId = 229
        attrId = 81
    else
        B_var = VarCfg["B_����·�"]
        equipName = "�·�"
        realAttrId = 230
        attrId = 82
    end

    local qianghualevel = getplaydef(actor, B_var)
    local cfg = config[qianghualevel]

    if qianghualevel >= 10 then
        Player.sendmsgEx(actor, "��ʾ#251|:#255|�Բ���,���|" .. equipName .. "#249|�Ѿ�ǿ����|10#249|����,�޷�����ǿ��...")
        return
    end

    if arg2 == 1 then
        local name, mum = Player.checkItemNumByTable(actor, cfg.cost1)
        if name then
            Player.sendmsgEx(actor, string.format("[��ʾ]:#251|���|%s#249|����|%d#249|,ǿ��ʧ��...", name, mum))
            return
        end
        Player.takeItemByTable(actor, cfg.cost1, "��꽣��")
        local percentage = cfg.percentage1 --����
        local minimum = cfg.minimum        --���ٴ���
        local currNum = getplaydef(actor, VarCfg["B_�������_����"])
        if minimum > currNum then          --������ٴ����ȱ��״����� ����0
            percentage = 0
        end
        if currNum >= 9 then --10�α��� ����100%   ��Ϊ��Ҫ���ʮ��,��Ϊ��ʼֵ��0��9���ǵ��10��
            percentage = 100
        end
        if randomex(percentage, 100) then
            setplaydef(actor, B_var, qianghualevel + 1)
            local attrValue = config[qianghualevel + 1].attr
            clearitemcustomabil(actor, itemobj, abilGroup)
            changecustomitemtext(actor, itemobj, "[�������]:", abilGroup)
            changecustomitemtextcolor(actor, itemobj, 252, abilGroup)
            Player.addModifyCustomAttributes(actor, itemobj, abilGroup, 1, 0, 0, realAttrId, attrId, 1, attrValue) --��������
            Player.sendmsgEx(actor, "[��ʾ]:��ϲ,���" .. equipName .. "ǿ���ɹ�#250")
            setplaydef(actor, VarCfg["B_�������_����"], 0)
        else
            Player.sendmsgEx(actor, "[��ʾ]:��Ǹ,���" .. equipName .. "ǿ��ʧ��#249")
            setplaydef(actor, VarCfg["B_�������_����"], currNum + 1)
            ShenHunJianJia.SyncResponse(actor)
        end
    elseif arg2 == 2 then
        -- B_����·�_����
        local name, mum = Player.checkItemNumByTable(actor, cfg.cost2)
        if name then
            Player.sendmsgEx(actor, string.format("[��ʾ]:#251|���|%s#249|����|%d#249|,ǿ��ʧ��...", name, mum))
            return
        end
        Player.takeItemByTable(actor, cfg.cost2, "��꽣��")
        local percentage = cfg.percentage3 --����
        local minimum = cfg.minimum        --���ٴ���
        local currNum = getplaydef(actor, VarCfg["B_����·�_����"])
        if minimum > currNum then          --������ٴ����ȱ��״����� ����0
            percentage = 0
        end
        if currNum >= 10 then --10�α��� ����100%
            percentage = 100
        end
        if randomex(percentage, 100) then
            setplaydef(actor, B_var, qianghualevel + 1)
            local attrValue = config[qianghualevel + 1].attr
            clearitemcustomabil(actor, itemobj, abilGroup)
            changecustomitemtext(actor, itemobj, "[��������]:", abilGroup)
            changecustomitemtextcolor(actor, itemobj, 252, abilGroup)
            Player.addModifyCustomAttributes(actor, itemobj, abilGroup, 1, 0, 0, realAttrId, 0, 1, attrValue) --��������
            Player.sendmsgEx(actor, "[��ʾ]:��ϲ,���" .. equipName .. "ǿ���ɹ�#250")
            setplaydef(actor, VarCfg["B_����·�_����"], 0)
        else
            Player.sendmsgEx(actor, "[��ʾ]:��Ǹ,���" .. equipName .. "ǿ��ʧ��#249")
            setplaydef(actor, VarCfg["B_����·�_����"], currNum + 1)
            ShenHunJianJia.SyncResponse(actor)
        end
    end


    local WuQiNum = getplaydef(actor, VarCfg["B_�������"])
    local YiFuNum = getplaydef(actor, VarCfg["B_����·�"])
    setplaydef(actor, VarCfg["B_��꽣���ܴ���"], WuQiNum + YiFuNum)
    setflagstatus(actor, VarCfg["F_�˽⽣�״������"], 1)
    --ͬ��һ����Ϣ
    ShenHunJianJia.SyncResponse(actor)
end

-- function ShenHunJianJia.Open(actor)
--     local flag = getflagstatus(actor,VarCfg["F_�˽⽣�״������"])
--     if  flag == 0 then
--         setflagstatus(actor,VarCfg["F_�˽⽣�״������"],1)
--         local taskPanelID = getplaydef(actor, VarCfg["U_��������������"])
--         if taskPanelID == 10 then
--             FCheckTaskRedPoint(actor)
--         end
--     end
-- end

------------�������������--------------------------
--��װ������
local function _onTakeOn(actor, itemobj)
    local itemidx = getiteminfo(actor, itemobj, ConstCfg.iteminfo.idx)
    local stdmode = getstditeminfo(itemidx, ConstCfg.stditeminfo.stdmode)
    local where = ConstCfg.stdmodewheremap[stdmode]
    local B_var
    local realAttrId
    local attrId
    clearitemcustomabil(actor, itemobj, abilGroup)
    if where[1] == 1 then
        B_var = VarCfg["B_�������"]
        realAttrId = 229
        attrId = 81
    else
        B_var = VarCfg["B_����·�"]
        realAttrId = 230
        attrId = 82
    end
    local index = getplaydef(actor, B_var)
    if index == 0 then
        return
    end
    local cfg = config[index]
    if cfg == nil then
        return
    end
    changecustomitemtext(actor, itemobj, "[�������]:", abilGroup)
    changecustomitemtextcolor(actor, itemobj, 252, abilGroup)
    Player.addModifyCustomAttributes(actor, itemobj, abilGroup, 1, 0, 0, realAttrId, attrId, 1, cfg.attr)
    refreshitem(actor, itemobj)
end
--��װ������
local function _onTakeOff(actor, itemobj)
    local itemidx = getiteminfo(actor, itemobj, ConstCfg.iteminfo.idx)
    local stdmode = getstditeminfo(itemidx, ConstCfg.stditeminfo.stdmode)
    local where = ConstCfg.stdmodewheremap[stdmode]

    --�������
    local itemobj1 = linkbodyitem(actor, where[1])
    clearitemcustomabil(actor, itemobj, abilGroup)
    refreshitem(actor, itemobj)
    -- recalcabilitys(actor)
end

local function _onLoginEnd(actor, logindatas)
    ShenHunJianJia.SyncResponse(actor, logindatas)
end

GameEvent.add(EventCfg.onLoginEnd, _onLoginEnd, ShenHunJianJia)

--��������ǰ
GameEvent.add(EventCfg.onTakeOnWeapon, _onTakeOn, ShenHunJianJia)
--��������ǰ
GameEvent.add(EventCfg.onTakeOffWeapon, _onTakeOff, ShenHunJianJia)

--�����·�ǰ
GameEvent.add(EventCfg.onTakeOnDress, _onTakeOn, ShenHunJianJia)
--�����·�ǰ
GameEvent.add(EventCfg.onTakeOffDress, _onTakeOff, ShenHunJianJia)

-------------������Ϣ������--------------------------
Message.RegisterNetMsg(ssrNetMsgCfg.ShenHunJianJia, ShenHunJianJia)

function ShenHunJianJia.SyncResponse(actor, logindatas)
    local B9 = getplaydef(actor, VarCfg["B_�������"])
    local B10 = getplaydef(actor, VarCfg["B_����·�"])
    local data = { B9, B10 }
    local _login_data = { ssrNetMsgCfg.ShenHunJianJia_SyncResponse, 0, 0, 0, data }
    if logindatas then
        table.insert(logindatas, _login_data)
    else
        Message.sendmsg(actor, ssrNetMsgCfg.ShenHunJianJia_SyncResponse, 0, 0, 0, data)
    end
end

return ShenHunJianJia

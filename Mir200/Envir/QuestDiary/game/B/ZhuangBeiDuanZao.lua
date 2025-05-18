local ZhuangBeiDuanZao = {}
local config = include("QuestDiary/cfgcsv/cfg_ZhuangBeiDuanZao.lua") --ϴ��
local abilGroup = 0 --�Զ�������λ��

function ZhuangBeiDuanZao.Request(actor, where, arg2)

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

    local U_var
    local equipName = ""
    local realAttrId
    local attrId

    if where == 1 then
        U_var = VarCfg["U_��������"]
        equipName = "����"
        realAttrId = 206
        attrId = 4
    else
        U_var = VarCfg["U_�·�����"]
        equipName = "�·�"
        realAttrId = 207
        attrId = 5
    end

    local qianghualevel = getplaydef(actor, U_var)
    local cfg = config[qianghualevel]

    if qianghualevel >= 15 then
        Player.sendmsgEx(actor, "��ʾ#251|:#255|�Բ���,���|"..equipName.."#249|�Ѿ�ǿ����|15#249|����,�޷�����ǿ��...")
        return
    end

    if arg2 == 1 then

        local name, mum = Player.checkItemNumByTable(actor, cfg.cost1)
        if name then
            Player.sendmsgEx(actor, string.format("[��ʾ]:#251|���|%s#249|����|%d#249|ö,����ʧ��...", name, mum))
            return
        end
            Player.takeItemByTable(actor,cfg.cost1,"����������ϼ������")

        if randomex(cfg.percentage1,100) then
            setplaydef(actor, U_var, qianghualevel+1)
            local attrValue = config[qianghualevel+1].attr
            clearitemcustomabil(actor, itemobj,abilGroup)
            changecustomitemtext(actor, itemobj, "[��������]:", abilGroup)
            changecustomitemtextcolor(actor, itemobj, 252, abilGroup)
            Player.addModifyCustomAttributes(actor, itemobj, abilGroup, 1, 0, 0, realAttrId, attrId, 1, attrValue) --��������
            Player.sendmsgEx(actor, "[��ʾ]:��ϲ,���"..equipName.."����ɹ�#250")
        else
            Player.sendmsgEx(actor, "[��ʾ]:��Ǹ,���"..equipName.."����ʧ��#249")
            ZhuangBeiDuanZao.SyncResponse(actor)
        end

    elseif arg2 == 2 then
        local name, mum = Player.checkItemNumByTable(actor, cfg.cost2)
        if name then
            Player.sendmsgEx(actor, string.format("[��ʾ]:#251|���|%s#249|����|%d#249|ö,����ʧ��...", name, mum))
            return
        end
            Player.takeItemByTable(actor,cfg.cost2,"����������ϼ������")
            setplaydef(actor, U_var, qianghualevel+1)
            local attrValue = config[qianghualevel+1].attr
            clearitemcustomabil(actor, itemobj,abilGroup)
            changecustomitemtext(actor, itemobj, "[��������]:", abilGroup)
            changecustomitemtextcolor(actor, itemobj, 252, abilGroup)
            Player.addModifyCustomAttributes(actor, itemobj, abilGroup, 1, 0, 0, realAttrId, attrId, 1, attrValue) --��������
            Player.sendmsgEx(actor, "[��ʾ]:��ϲ,���"..equipName.."����ɹ�#250")
    end


    local  WuQiNum = getplaydef(actor,VarCfg["U_��������"])
    local  YiFuNum = getplaydef(actor,VarCfg["U_�·�����"])
    setplaydef(actor,VarCfg["U_���״����ܴ���"],WuQiNum+YiFuNum)
    setflagstatus(actor,VarCfg["F_�˽⽣�״������"],1)
    --������
    -- if WuQiNum+YiFuNum == 1 then
    --     local taskPanelID = getplaydef(actor, VarCfg["U_��������������"])
    --     if taskPanelID == 10 then
    --         FCheckTaskRedPoint(actor)
    --     end
    -- end

    GameEvent.push(EventCfg.onJianJiaCuLian, actor, WuQiNum+YiFuNum)
    --ͬ��һ����Ϣ
    ZhuangBeiDuanZao.SyncResponse(actor)
end

function ZhuangBeiDuanZao.Open(actor)
    local flag = getflagstatus(actor,VarCfg["F_�˽⽣�״������"])
    if  flag == 0 then
        setflagstatus(actor,VarCfg["F_�˽⽣�״������"],1)
        local taskPanelID = getplaydef(actor, VarCfg["U_��������������"])
        if taskPanelID == 10 then
            FCheckTaskRedPoint(actor)
        end
    end
end

------------�������������--------------------------
--��װ������
local function _onTakeOn(actor, itemobj)
    local itemidx = getiteminfo(actor, itemobj ,ConstCfg.iteminfo.idx)
    local stdmode = getstditeminfo(itemidx, ConstCfg.stditeminfo.stdmode)
    local where = ConstCfg.stdmodewheremap[stdmode]
    local U_var
    local realAttrId
    local attrId
    clearitemcustomabil(actor, itemobj,abilGroup)
    if where[1] == 1 then
        U_var = VarCfg["U_��������"]
        realAttrId = 206
        attrId = 4
    else
        U_var = VarCfg["U_�·�����"]
        realAttrId = 207
        attrId = 5
    end
    local index = getplaydef(actor, U_var)
    if index == 0 then
        return
    end
    local cfg = config[index]
    if cfg == nil then
        return
    end
    changecustomitemtext(actor, itemobj, "[��������]:", abilGroup)
    changecustomitemtextcolor(actor, itemobj, 252, abilGroup)
    Player.addModifyCustomAttributes(actor, itemobj, abilGroup, 1, 0, 0, realAttrId, attrId, 1, cfg.attr)
    refreshitem(actor, itemobj)
end
--��װ������
local function _onTakeOff(actor, itemobj)
    local itemidx = getiteminfo(actor, itemobj ,ConstCfg.iteminfo.idx)
    local stdmode = getstditeminfo(itemidx, ConstCfg.stditeminfo.stdmode)
    local where = ConstCfg.stdmodewheremap[stdmode]

    -- release_print(where[1])
    --�������
    local itemobj1 = linkbodyitem(actor, where[1])
    -- release_print(itemobj1, itemobj)
    clearitemcustomabil(actor,itemobj,abilGroup)
    refreshitem(actor, itemobj)
    -- recalcabilitys(actor)

end

local function _onLoginEnd(actor, logindatas)
    ZhuangBeiDuanZao.SyncResponse(actor, logindatas)
end

GameEvent.add(EventCfg.onLoginEnd, _onLoginEnd, ZhuangBeiDuanZao)

--��������ǰ
GameEvent.add(EventCfg.onTakeOnWeapon, _onTakeOn, ZhuangBeiDuanZao)
--��������ǰ
GameEvent.add(EventCfg.onTakeOffWeapon, _onTakeOff, ZhuangBeiDuanZao)

--�����·�ǰ
GameEvent.add(EventCfg.onTakeOnDress, _onTakeOn, ZhuangBeiDuanZao)
--�����·�ǰ
GameEvent.add(EventCfg.onTakeOffDress, _onTakeOff, ZhuangBeiDuanZao)

-------------������Ϣ������--------------------------
Message.RegisterNetMsg(ssrNetMsgCfg.ZhuangBeiDuanZao, ZhuangBeiDuanZao)

function ZhuangBeiDuanZao.SyncResponse(actor, logindatas)
    local U14 = getplaydef(actor,VarCfg["U_��������"])
    local U15 = getplaydef(actor,VarCfg["U_�·�����"])
    local data = {U14,U15}
    local _login_data = {ssrNetMsgCfg.ZhuangBeiDuanZao_SyncResponse, 0, 0, 0, data}
    if logindatas then
        table.insert(logindatas, _login_data)
    else
        Message.sendmsg(actor, ssrNetMsgCfg.ZhuangBeiDuanZao_SyncResponse, 0, 0, 0, data)
    end
end

return ZhuangBeiDuanZao

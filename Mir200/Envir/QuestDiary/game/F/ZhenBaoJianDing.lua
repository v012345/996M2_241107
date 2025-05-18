local ZhenBaoJianDing = {}
local cost1 = { { "��ʯ", 2 }, { "Ԫ��", 60000 }}       --��������
local cost2 = { { "����ˮ��", 50 }, { "���", 660000 }}  --��������
local config = include("QuestDiary/cfgcsv/cfg_ZhenBaoJianDing.lua") --����
---* ��ȡװ����������������
---* ����1 ��Ҷ���
---* ����2 ��Ʒ����
function ZhenBaoJianDing.Attributelocation(actor, itemobj)
    local WeiZhiNum = 0
    local _data = getitemcustomabil(actor,itemobj)
    if _data == "" then
        return 0
    else
        local _data = json2tbl(_data)
        local data = _data.abil[1].v
        for _, v in ipairs(data) do
            if v then
                WeiZhiNum = WeiZhiNum + 1
            end
        end
    end
    return WeiZhiNum
end
---* ��ʼ��������
---* ����1 ��Ҷ���
---* ����2 ��Ʒ����
---* ����3 ��������
function ZhenBaoJianDing.setItemAttr(actor,itemobj,TypeName)
    local AttrNum = ZhenBaoJianDing.Attributelocation(actor, itemobj)
    local cfg = config[TypeName]
    if AttrNum == 0 then
        changecustomitemtext(actor, itemobj, "[�䱦����]��", 0)
        changecustomitemtextcolor(actor, itemobj, 253, 0)
    end
    local weizhi = AttrNum --λ��
    local realAttrId = cfg.realAttrId
    local attrId = cfg.attrId
    local attrValue = math.random(1, cfg.max)
    local isAttrPercent = cfg.isAttrPercent
    changecustomitemabil(actor,itemobj,weizhi,1,realAttrId,0) --��ʵ����
    changecustomitemabil(actor,itemobj,weizhi,2,attrId,0) --��ʾ����
    changecustomitemabil(actor,itemobj,weizhi,3,isAttrPercent,0) --�Ƿ�ٷֱ�
    changecustomitemabil(actor,itemobj,weizhi,4,weizhi,0)   --��ʾλ��(0~9)
    changecustomitemvalue(actor,itemobj,weizhi,"=",attrValue,0)
end

--�������
function ZhenBaoJianDing.Request1(actor,var)
    local itemobj = linkbodyitem(actor, var) --��ȡ��Ʒ����
    if itemobj == "0" then return end  --����Ϊ�� ����
    local itemname = getiteminfo(actor, itemobj, 7) --��ȡ��Ʒ����
    local AttrNum = ZhenBaoJianDing.Attributelocation(actor, itemobj)
    if AttrNum == 0 then
        Player.sendmsgEx(actor, "��ʾ#251|:#255|���|".. itemname .."#249|û�м�����,����ʧ��...")
        return
    end
    local name, num = Player.checkItemNumByTable(actor, cost1)
    if name then
        Player.sendmsgEx(actor, string.format("���|%s#249|����|%d#249|ö,��������ʧ��...", name, num))
        return
    end

    Player.takeItemByTable(actor, cost1,"�䱦��������")
    clearitemcustomabil(actor,itemobj,-1)
    Player.sendmsgEx(actor, "��ʾ#251|:#255|���|".. itemname .."#249|���óɹ�...")
    refreshitem(actor,itemobj)
    ZhenBaoJianDing.SyncResponse(actor)
    delaygoto(actor,1000,"yan_chi_shua_xin_gong_su")

end
--��������
function ZhenBaoJianDing.Request2(actor,var)
    local itemobj = linkbodyitem(actor, var) --��ȡ��Ʒ����
    if itemobj == "0" then return end  --����Ϊ�� ����
    local itemname = getiteminfo(actor, itemobj, 7) --��ȡ��Ʒ����

    local AttrNum = ZhenBaoJianDing.Attributelocation(actor, itemobj)
    if AttrNum == 5 then
        Player.sendmsgEx(actor, "��ʾ#251|:#255|���|".. itemname .."#249|���������Ѵﵽ5��...")
        return
    end

    -- ���۳�����
    local name, num = Player.checkItemNumByTable(actor, cost2)
    if name then
        Player.sendmsgEx(actor, string.format("���|%s#249|����|%d#249|ö,����ʧ��...", name, num))
        return
    end
    Player.takeItemByTable(actor, cost2,"�䱦����")
    local num = getplaydef(actor,VarCfg["B_�䱦��������"])
    setplaydef(actor,VarCfg["B_�䱦��������"],num+1)
    if randomex(config[AttrNum+1].randomNum,100) then
    -- if randomex(1,1) then
        local _str = config[AttrNum+1].ransjstr
        local str = table.concat(_str, "|")
        local TypeName, _ = ransjstr(str, 1, 3)
        ZhenBaoJianDing.setItemAttr(actor,itemobj,TypeName)
        delaygoto(actor,1000,"yan_chi_shua_xin_gong_su")
    else
        Player.sendmsgEx(actor, "��ʾ#251|:#255|�Բ���,���|".. itemname .."#249|����ʧ��,���Ͽ۳�...")
    end

    refreshitem(actor,itemobj)
    ZhenBaoJianDing.SyncResponse(actor)
end

--�ӳ����Ը���
function yan_chi_shua_xin_gong_su(actor)
    Player.setAttList(actor, "���ٸ���")
end

-- ���ٸ���
local function _onCalcAttackSpeed(actor, attackSpeeds)
    local gongSu = getbaseinfo(actor, 51, 232) --��������
    attackSpeeds[1] = attackSpeeds[1] + gongSu
end
GameEvent.add(EventCfg.onCalcAttackSpeed, _onCalcAttackSpeed, ZhenBaoJianDing)

--��װ������
local function _onTakeOnEx(actor, itemobj, where, itemname, makeid)
    if getplaydef(actor,VarCfg["U_��¼��½"]) < 7 then return end
    if where >= 30 and where <= 37 then
        delaygoto(actor,1000,"yan_chi_shua_xin_gong_su")
    end
end
GameEvent.add(EventCfg.onTakeOnEx, _onTakeOnEx, ZhenBaoJianDing)

--��װ������
local function _onTakeOffEx(actor, itemobj, where, itemname, makeid)
    if getplaydef(actor,VarCfg["U_��¼��½"]) < 7 then return end
    if where >= 30 and where <= 37 then
        delaygoto(actor,1000,"yan_chi_shua_xin_gong_su")
    end
end
GameEvent.add(EventCfg.onTakeOffEx, _onTakeOffEx, ZhenBaoJianDing)


--ע��������Ϣ
function ZhenBaoJianDing.SyncResponse(actor, logindatas)
    Message.sendmsg(actor, ssrNetMsgCfg.ZhenBaoJianDing_SyncResponse, 0, 0, 0, nil)
end
Message.RegisterNetMsg(ssrNetMsgCfg.ZhenBaoJianDing, ZhenBaoJianDing)

return ZhenBaoJianDing

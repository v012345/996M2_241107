local LongHunLaoYin = {}
local cost ={{{"Х֮��ָ", 1},{"���籾Դ", 66},{"���", 8888}},{{"����֮��", 1},{"���籾Դ", 66},{"���", 8888}},{{"����֮ӡ", 1},{"���籾Դ", 66},{"���", 8888}}} 
local LaoYinName = {"����","����","����"}

--��ȡ����״̬
function LongHunLaoYin.getFlagstate(actor)
    local state1 = getflagstatus(actor,VarCfg["F_������ӡ1"])
    local state2 = getflagstatus(actor,VarCfg["F_������ӡ2"])
    local state3 = getflagstatus(actor,VarCfg["F_������ӡ3"])
    local flagTbl = {state1,state2,state3}
    return flagTbl
end
-- ʥ����֮�궥��	52	47
function LongHunLaoYin.Request(actor,var)
    local flagTbl = LongHunLaoYin.getFlagstate(actor) --��ȡ����״̬
    if flagTbl[var] == 1 then 
        Player.sendmsgEx(actor, "[��ʾ]:#251|��������ʯ�ѽ�|".. LaoYinName[var] .."#249|��ӡ����!")
        return
    end

    local name, num = Player.checkItemNumByTable(actor, cost[var])
    if name then
        Player.sendmsgEx(actor, string.format("��ʾ#251|:#255|���|%s#249|��������|%d#249|,��ӡʧ��...", name, num))
        return
    end
    Player.takeItemByTable(actor, cost[var], "�����ֻ�"..var.. "")
    setflagstatus(actor,VarCfg["F_�������������ӡ"],1)
    --���ȫ����ӡ
    setflagstatus(actor,VarCfg["F_������ӡ1"],0)
    setflagstatus(actor,VarCfg["F_������ӡ2"],0)
    setflagstatus(actor,VarCfg["F_������ӡ3"],0)
    --�����µ���ӡ
    setflagstatus(actor,VarCfg["F_������ӡ".. var ..""], 1)
    local itemobj = linkbodyitem(actor, 89)
    clearitemcustomabil(actor, itemobj,0)
    changecustomitemtext(actor, itemobj, "[������ӡ]", 0)
    changecustomitemtextcolor(actor, itemobj, 253, 0)
    changecustomitemabil(actor,itemobj,0,1,174,0) --��ʵ����
    changecustomitemabil(actor,itemobj,0,2,36+var,0) --��ʾ����
    changecustomitemabil(actor,itemobj,0,4,0,0)   --��ʾλ��(0~9)
    changecustomitemvalue(actor,itemobj,0,"=",1,0)
    refreshitem(actor,itemobj)
    Player.setAttList(actor, "���Ը���")
    --ˢ��ǰ��
    LongHunLaoYin.SyncResponse(actor)
end

--����ˢ��
local function _onCalcAttr(actor, attrs)
    local flagTbl = LongHunLaoYin.getFlagstate(actor) --��ȡ����״̬
    local attrtbl = {    }
    if flagTbl[1] == 1 then
        attrtbl[200] = 25555
    end

    if flagTbl[3] == 1 then
        attrtbl[25] = 10
        attrtbl[81] = 500
    end
    calcAtts(attrs, attrtbl, "������ӡ")
end
GameEvent.add(EventCfg.onCalcAttr, _onCalcAttr, LongHunLaoYin)


--��������
local function _onAttackDamagePlayer(actor, Target, Hiter, MagicId, Damage, Model, attackDamageData)
    if getflagstatus(actor,VarCfg["F_������ӡ2"]) == 1 then
        if randomex(1,128) then
            local _ac  = getbaseinfo(Target, ConstCfg.gbase.ac)
            local _ac2  = getbaseinfo(Target, ConstCfg.gbase.ac2)
            local _mac  = getbaseinfo(Target, ConstCfg.gbase.mac)
            local _mac2  = getbaseinfo(Target, ConstCfg.gbase.mac2)
            changehumability(Target, 1, -_ac, 2)
            changehumability(Target, 2, -_ac2, 2)
            changehumability(Target, 3, -_mac, 2)
            changehumability(Target, 4, -_mac2, 2)
            humanhp(Target, "-", Player.getHpValue(Target, 10), 106, 0, actor) --նɱ10%����
            local myName = Player.GetNameEx(actor)
            local targetName = Player.GetNameEx(Target)
            Player.buffTipsMsg(actor, "[������ӡ]:�����[{" .. targetName .. "/FCOLOR=243}]�ķ���{2/FCOLOR=243}��,��նɱ10%�������...")
            Player.buffTipsMsg(Target, "[������ӡ]:�㱻[{" .. myName .. "/FCOLOR=243}]��շ���{2/FCOLOR=243}��,��նɱ10%�������...")
        end
    end
end
GameEvent.add(EventCfg.onAttackDamagePlayer, _onAttackDamagePlayer, LongHunLaoYin)



--ע��������Ϣ
function LongHunLaoYin.SyncResponse(actor, logindatas)
    local data = LongHunLaoYin.getFlagstate(actor) --��ȡ����״̬
    local _login_data = { ssrNetMsgCfg.LongHunLaoYin_SyncResponse, 0, 0, 0, data }
    if logindatas then
        table.insert(logindatas, _login_data)
    else
        Message.sendmsg(actor, ssrNetMsgCfg.LongHunLaoYin_SyncResponse, 0, 0, 0, data)
    end
end
Message.RegisterNetMsg(ssrNetMsgCfg.LongHunLaoYin, LongHunLaoYin)

--��¼����
local function _onLoginEnd(actor, logindatas)
    LongHunLaoYin.SyncResponse(actor, logindatas)
end
GameEvent.add(EventCfg.onLoginEnd, _onLoginEnd, LongHunLaoYin)

return LongHunLaoYin


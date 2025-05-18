local ShiKongLunPan = {}
local cont = { { { "ʱ����", 1 }, { "���籾Դ", 10 } }, { { "�ֻ�ɳ©", 1 }, { "���籾Դ", 10 } }, { { "ʧ��ռ�", 1 }, { "���籾Դ", 10 } }, { { "���", 333 }, { "�컯�ᾧ", 10 } } }
local AttrData = { "�����ӳ�", "ħ���ӳ�", "�����ӳ�", "��������", "�����ӳ�", "�����˺�", "�˺�����", "��ֱ���" }

--��ȡ���̽���״̬������һ��tbl
function ShiKongLunPan.getFlagstate(actor)
    local state1 = getflagstatus(actor, VarCfg["F_ʱ������λ��1"])
    local state2 = getflagstatus(actor, VarCfg["F_ʱ������λ��2"])
    local state3 = getflagstatus(actor, VarCfg["F_ʱ������λ��3"])
    local flagTbl = { state1, state2, state3 }
    return flagTbl
end

--��ȡ�������Բ�����һ��tbl
function ShiKongLunPan.getVariableState(actor)
    local IsTbl = Player.getJsonTableByVar(actor, VarCfg["T_ʱ����������"])
    local NewTbl = {}
    for i = 1, 3 do
        local State = (IsTbl[i] == nil and "��������") or IsTbl[i]
        NewTbl[i] = State
    end
    return NewTbl
end

--ˢ��ǰ������
function shua_xin_qian_duan_xian_shi(actor)
    Player.setAttList(actor, "���Ը���")
    Player.setAttList(actor, "���ʸ���")
    setplaydef(actor, VarCfg["S$ʱ��������ʱ��¼"], "")
    ShiKongLunPan.SyncResponse(actor)
end

--ת������ȡֵ
function ShiKongLunPan.LuoPanQuZhi(actor)
    local attrTbl = ShiKongLunPan.getVariableState(actor)
    local NewTbl = {}
    for _, k in ipairs(AttrData) do
        local GaiLv = 3
        for _, v in ipairs(attrTbl) do
            if k == v then
                GaiLv = GaiLv - 1
            end
        end
        if GaiLv == 3 then
            table.insert(NewTbl, k)
        else
            if randomex(GaiLv * 2, 100) then
                -- release_print("��ʾ",GaiLv*2,k)
                return k
            end
        end
    end
    return NewTbl[math.random(1, #NewTbl)]
end

--��������
function ShiKongLunPan.Request1(actor, var)
    local flagTbl = ShiKongLunPan.getFlagstate(actor) --��ȡ���̿���״̬
    if flagTbl[var] == 1 then return end
    local name, num = Player.checkItemNumByTable(actor, cont[var])
    if name then
        Player.sendmsgEx(actor, string.format("��ʾ#251|:#255|���|%s#249|��������|%d#249|,����ʧ��...", name, num))
        return
    end
    Player.takeItemByTable(actor, cont[var], "��������" .. var .. "")
    setflagstatus(actor, VarCfg["F_ʱ������λ��" .. var .. ""], 1)
    --ˢ��ǰ��
    ShiKongLunPan.SyncResponse(actor)
end

--ת������
function ShiKongLunPan.Request2(actor, var)
    local flagTbl = ShiKongLunPan.getFlagstate(actor)
    if flagTbl[var] == 0 then
        Player.sendmsgEx(actor, "[��ʾ]:#251|�ұ�����!")
        return
    end

    if getplaydef(actor, VarCfg["S$ʱ��������ʱ��¼"]) ~= "" then
        Player.sendmsgEx(actor, "[��ʾ]:#251|��ǰ����|[ת����]#249|���Ժ�!")
        return
    end
    local name, num = Player.checkItemNumByTable(actor, cont[4])
    if name then
        Player.sendmsgEx(actor, string.format("��ʾ#251|:#255|���|%s#249|��������|%d#249|,ת������ʧ��...", name, num))
        return
    end
    Player.takeItemByTable(actor, cont[4], "ת������" .. var .. "")
    setflagstatus(actor, VarCfg["F_ת��ʱ������"], 1)
    local AttrTbl = ShiKongLunPan.getVariableState(actor)
    local QiShiWeiZhi = (AttrTbl[var] == "��������" and 0) or AttrData[AttrTbl[var]]
    local FistrSite = AttrTbl[var] == "��������" or AttrTbl[var] --��ʼλ��
    local EndSite = ShiKongLunPan.LuoPanQuZhi(actor)
    setplaydef(actor, VarCfg["S$ʱ��������ʱ��¼"], EndSite)
    AttrTbl[var] = EndSite
    Player.setJsonVarByTable(actor, VarCfg["T_ʱ����������"], AttrTbl)
    --����ǰ�˶���
    local EffectsData = { FistrSite, EndSite }
    Message.sendmsg(actor, ssrNetMsgCfg.ShiKongLunPan_PlayEffects, 0, 0, var, EffectsData)
    delaygoto(actor, 2000, "shua_xin_qian_duan_xian_shi")
end

function ShiKongLunPan.LiaoJie(actor)
    setflagstatus(actor, VarCfg["F_�˽�ʱ������"], 1)
end

--����Ƿ�˫��
function ShiKongLunPan.CheckIsDouble(actor, _type)
    local attrTbl = ShiKongLunPan.getVariableState(actor)
    local multiple = 0
    for _, v in ipairs(attrTbl) do
        if _type == v then
            multiple = multiple + 1
        end
    end
    return multiple * multiple
end

--����ˢ��
local function _onCalcAttr(actor, attrs)
    local attrTbl = ShiKongLunPan.getVariableState(actor)
    local attrtbl = {
        [210] = 6 * ShiKongLunPan.CheckIsDouble(actor, "�����ӳ�"), --�������ްٷֱ�
        [211] = 6 * ShiKongLunPan.CheckIsDouble(actor, "ħ���ӳ�"), --ħ�����ްٷֱ�
        [212] = 6 * ShiKongLunPan.CheckIsDouble(actor, "�����ӳ�"), --�������ްٷֱ�
        [208] = 6 * ShiKongLunPan.CheckIsDouble(actor, "��������"), --����ֵ�ٷֱ�
        [213] = 6 * ShiKongLunPan.CheckIsDouble(actor, "�����ӳ�"), --������ްٷֱ�
        [25]  = 6 * ShiKongLunPan.CheckIsDouble(actor, "�����˺�"), --���ӹ����˺�Ԫ��
        [26]  = 6 * ShiKongLunPan.CheckIsDouble(actor, "�˺�����"), --�����˺����� Ԫ��
    }
    calcAtts(attrs, attrtbl, "ʱ������")
end
GameEvent.add(EventCfg.onCalcAttr, _onCalcAttr, ShiKongLunPan)

--����ˢ��
local function _onCalcBaoLv(actor, attrs)
    local attrtbl = {
        [204] = 6 * ShiKongLunPan.CheckIsDouble(actor, "��ֱ���"), --���ʱ���
    }
    calcAtts(attrs, attrtbl, "ʱ������")
end
GameEvent.add(EventCfg.onCalcBaoLv, _onCalcBaoLv, ShiKongLunPan)

--ע��������Ϣ
function ShiKongLunPan.SyncResponse(actor, logindatas)
    local flagTbl = ShiKongLunPan.getFlagstate(actor)
    local attrTbl = ShiKongLunPan.getVariableState(actor)
    local data = { flagTbl, attrTbl }
    local _login_data = { ssrNetMsgCfg.ShiKongLunPan_SyncResponse, 0, 0, 0, data }
    if logindatas then
        table.insert(logindatas, _login_data)
    else
        Message.sendmsg(actor, ssrNetMsgCfg.ShiKongLunPan_SyncResponse, 0, 0, 0, data)
    end
end

Message.RegisterNetMsg(ssrNetMsgCfg.ShiKongLunPan, ShiKongLunPan)

--��¼����
local function _onLoginEnd(actor, logindatas)
    ShiKongLunPan.SyncResponse(actor, logindatas)
end
GameEvent.add(EventCfg.onLoginEnd, _onLoginEnd, ShiKongLunPan)

return ShiKongLunPan

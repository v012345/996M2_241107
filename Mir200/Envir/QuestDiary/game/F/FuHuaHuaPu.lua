local FuHuaHuaPu = {}
local cost = {{"����֮��", 1}}

-- ����֮Դ	112	104

--��ȡ���н�������ֵ
function FuHuaHuaPu.getFlagstate(actor)
    local state1 = getplaydef(actor,VarCfg["B_��������_�־�"])
    local state2 = getplaydef(actor,VarCfg["B_��������_��թ"])
    local state3 = getplaydef(actor,VarCfg["B_��������_�б�"])
    local state4 = getplaydef(actor,VarCfg["B_��������_��α"])
    local NumTbl = {state1,state2,state3,state4}
    return NumTbl
end

function FuHuaHuaPu.Request(actor,var)
    local bool = getflagstatus(actor,VarCfg["F_����֮�ֿ���״̬"])
    --������԰
    if  var == 1  then 
        if bool == 1 then return end

        local name, num = Player.checkItemNumByTable(actor, cost)
        if name then
            Player.sendmsgEx(actor, string.format("��ʾ#251|:#255|���|%s#249|��������|%d#249|ö,��ֲʧ��...", name, num))
            return
        end
        Player.takeItemByTable(actor, cost, "��ֲ�շ�")
        setflagstatus(actor,VarCfg["F_����֮�ֿ���״̬"],1)
        FuHuaHuaPu.SyncResponse(actor)
    end
    --�콱
    if  var == 2  then
        if bool == 0 then return end
        local data = FuHuaHuaPu.getFlagstate(actor)
        for k, v in ipairs(data) do
            if v < 1000 then
                Player.sendmsgEx(actor, "��ʾ#251|:#255|�Բ���,���|��".. k .."������#249|����|1000#249|�ջ�ʧ��...")
                return
            end
        end
        local AwardData = "��������α#15|������־�#20|������б�#40|�������թ#25"
        local AwardItem, _ = ransjstr(AwardData, 1, 3)
        local UserId = getconst(actor, "<$USERID>")
        sendmail(UserId, 5001, "��������", "��ϲ��ɹ��ջ�"..AwardItem,AwardItem.."#1")
        setflagstatus(actor,VarCfg["F_����֮���ջ�һ��"],1)
        Player.sendmsgEx(actor, "��ʾ#251|:#255|��ϲ��,��ϲ��ɹ��ջ�|".. AwardItem .."#249|��ͨ���ʼ�����...")
        setplaydef(actor,VarCfg["B_��������_�־�"],0)
        setplaydef(actor,VarCfg["B_��������_��թ"],0)
        setplaydef(actor,VarCfg["B_��������_�б�"],0)
        setplaydef(actor,VarCfg["B_��������_��α"],0)
        FuHuaHuaPu.SyncResponse(actor)
    end

    --�û�
    FuHuaHuaPu.gives = { "��������α", "������־�", "������б�", "�������թ"}
    if  var == 3 then
        local hasEquip = {}
        for _, v in ipairs(FuHuaHuaPu.gives) do
            local num = getbagitemcount(actor, v)
            if num > 0 then
                table.insert(hasEquip,v)
            end
        end
        if #hasEquip == 0 then
            Player.sendmsgEx(actor, "[��ʾ]:#251|�㱳��û�и���װ��#249")
            return
        end

        if querymoney(actor, 7) < 888 then
            Player.sendmsgEx(actor,"[��ʾ]:#251|�û�ʧ��,���|���#249|����|888#249")
            return
        end

        local itemname = hasEquip[math.random(1, #hasEquip)]
        takeitem(actor, itemname, 1, 0, "����װ���û�")
        changemoney(actor, 7, "-", 888, "����װ���û�", true)

        local randomNum = math.random(1,4)
        local give = FuHuaHuaPu.gives[randomNum]
        giveitem(actor,give,1)
        messagebox(actor,string.format("ʹ�á�%s���������������װ������%s��",hasEquip[1],give))
    end
end


--ɱ�����ﴥ��
local Mon_B_data={["ʴ��Ů������α"]= "B_��������_��α",["������Գ��־�"]= "B_��������_�־�",["̫�ſ�ħ��б�"]= "B_��������_�б�",["�Ϲ�ħ�����թ"]= "B_��������_��թ"}
local function _onKillMon(actor, monobj, monName)
    if getflagstatus(actor,VarCfg["F_����֮�ֿ���״̬"]) == 0 then return end
        if Mon_B_data[monName] then
            local VarName = Mon_B_data[monName]
            local num = getplaydef(actor,VarCfg[VarName])
            num = num + 1
            setplaydef(actor,VarCfg[VarName],num)
        end
    end
GameEvent.add(EventCfg.onKillMon, _onKillMon, FuHuaHuaPu)

-- �������թ ���ٸ��� +15%
local function _onCalcAttackSpeed(actor, attackSpeeds)
    if checkitemw(actor, "�������թ", 1) then
        attackSpeeds[1] = attackSpeeds[1] + 12
    end
end
GameEvent.add(EventCfg.onCalcAttackSpeed, _onCalcAttackSpeed, FuHuaHuaPu)

--�������� ��������α +6%
local function _onCalcBeiGong(actor, beiGongs)
    if checkitemw(actor, "��������α", 1) then
        beiGongs[1] = beiGongs[1] + 6
    end
end
GameEvent.add(EventCfg.onCalcBeiGong, _onCalcBeiGong, FuHuaHuaPu)

--���ﴩװ��----���ﴩ������װ������
local function _onTakeOnEx(actor, itemobj, where, itemname, makeid)
    if itemname == "�������թ" then
        Player.setAttList(actor, "���ٸ���")
    end
    if itemname == "��������α" then
        Player.setAttList(actor, "��������")
    end
end
GameEvent.add(EventCfg.onTakeOnEx, _onTakeOnEx, FuHuaHuaPu)

--������װ��---������������װ������
local function _onTakeOffEx(actor, itemobj, where, itemname, makeid)
    if itemname == "�������թ" then
        Player.setAttList(actor, "���ٸ���")
    end
    if itemname == "��������α" then
        Player.setAttList(actor, "��������")
    end
end
GameEvent.add(EventCfg.onTakeOffEx, _onTakeOffEx, FuHuaHuaPu)

--ע��������Ϣ
function FuHuaHuaPu.SyncResponse(actor, logindatas)
    local bool = getflagstatus(actor,VarCfg["F_����֮�ֿ���״̬"])
    local data = FuHuaHuaPu.getFlagstate(actor)
    local _login_data = { ssrNetMsgCfg.FuHuaHuaPu_SyncResponse, bool, 0, 0, data }
    if type(logindatas) == "table" then
        table.insert(logindatas, _login_data)
    else
        Message.sendmsg(actor, ssrNetMsgCfg.FuHuaHuaPu_SyncResponse, bool, 0, 0, data)
    end
end
Message.RegisterNetMsg(ssrNetMsgCfg.FuHuaHuaPu, FuHuaHuaPu)

--��¼����
local function _onLoginEnd(actor, logindatas)
    FuHuaHuaPu.SyncResponse(actor, logindatas)
end
GameEvent.add(EventCfg.onLoginEnd, _onLoginEnd, FuHuaHuaPu)

return FuHuaHuaPu

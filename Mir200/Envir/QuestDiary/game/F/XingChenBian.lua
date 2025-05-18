local XingChenBian = {}
local cost = {{"�ǻ���Ƭ", 1},{"���籾Դ", 2}}
local TypeData = {"̰��","����","»��","����","�ƾ�","����","����"}

--���T����������һ��Tbl
function CheckLevelIsTbl(actor)
    local IsTbl = Player.getJsonTableByVar(actor, VarCfg["T_�ǳ�����ȼ�¼"])
    local NewTbl = {}
    for _, v in ipairs(TypeData) do
        local Num = (IsTbl[v] == "" and 0) or IsTbl[v]  or 0
        NewTbl[v] = Num
    end
    return NewTbl
end

--��ȡ����
function XingChenBian.Request1(actor)
    local state = true
    local data = CheckLevelIsTbl(actor)
    for k, v in pairs(data) do
        if v < 50 then
            state = false
            break
        end
    end
    if not state then
        Player.sendmsgEx(actor, "��ʾ#251|:#255|�Բ���,����ǳ���|δ����#249|��ȡʧ��...")
        return
    end
    local lingqu = getflagstatus(actor,VarCfg["F_�ǳ�����ȡ״̬"])
    if lingqu == 1 then
        Player.sendmsgEx(actor, "��ʾ#251|:#255|������ȡ���ǳ���|��������#249|�����ظ���ȡ...")
        return
    end
    local UserId = getconst(actor, "<$USERID>")
    sendmail(UserId, 5001, "�ǳ���", "��ϲ�����ǳ��佱��","���������#1&����̫���Ǿ�����[ʱװ]#1")
    Player.sendmsgEx(actor, "��ʾ#251|:#255|��ϲ��,��ȡ|�ǳ���#249|��������,��ͨ��|�ʼ�#249|����...")
    setflagstatus(actor,VarCfg["F_�ǳ�����ȡ״̬"],1)
end

-- ���ǹ�����	100	117

--ע���ǻ�֮��
function XingChenBian.Request2(actor)
    local data = CheckLevelIsTbl(actor)
    local NewTbl = {}
    --ɸѡ�Ƿ��Ѿ�����
    for _, v in ipairs(TypeData) do
        if data[v] ~= 50 then
            table.insert(NewTbl, v)
        end
    end
    if #NewTbl == 0 then
        Player.sendmsgEx(actor, "��ʾ#251|:#255|�ǳ���|������#249|�޷�����������...")
        return
    end

    local name, num = Player.checkItemNumByTable(actor, cost)
    if name then
        Player.sendmsgEx(actor, string.format("��ʾ#251|:#255|���|%s#249|����|%d#249|ö,ע��ʧ��...", name, num))
        return
    end
    Player.takeItemByTable(actor, cost, "�ǳ���۳�")
    local TypeName = NewTbl[math.random(1, #NewTbl)]                    --���ȡֵ
    data[TypeName] = data[TypeName] + 1                                 --����1��
    Player.sendmsgEx(actor, "��ʾ#251|:#255|�ǳ�|".. TypeName .."��#249|����|+1#249|...")
    Player.setJsonVarByTable(actor, VarCfg["T_�ǳ�����ȼ�¼"], data)    --�������
    XingChenBian.SyncResponse(actor)
    Player.setAttList(actor, "���Ը���")
end


--����ˢ��
local function _onCalcAttr(actor, attrs)
    local data = CheckLevelIsTbl(actor)

    local IsDouble = true
    local multiple = 1
    for _, v in ipairs(TypeData) do
        if data[v] < 50 then
            IsDouble = false
        end
    end
    if IsDouble then
        multiple = 2
    end

    local attrtbl = {}
    if data["̰��"] > 0 then
        attrtbl[4] =  10 * data["̰��"] * multiple          --����
    end
    if data["����"] > 0 then
        attrtbl[6] =  10 * data["����"] * multiple          --����
    end
    if data["»��"] > 0 then
        attrtbl[8] =  10 * data["»��"] * multiple          --����
    end
    if data["����"] > 0 then
        attrtbl[10] =  10 * data["����"] * multiple         --����
    end
    if data["�ƾ�"] > 0 then
        attrtbl[12] =  10 * data["�ƾ�"] * multiple         --����
    end
    if data["����"] > 0 then
        attrtbl[1] =  200 * data["����"] * multiple          --����
    end
    if data["����"] > 0 then
        attrtbl[2] =  200 * data["����"] * multiple          --����
    end
    calcAtts(attrs, attrtbl, "�ǳ���")
end
GameEvent.add(EventCfg.onCalcAttr, _onCalcAttr, XingChenBian)

--ע��������Ϣ
function XingChenBian.SyncResponse(actor, logindatas)
    local data = CheckLevelIsTbl(actor)
    local lingqu = getflagstatus(actor,VarCfg["F_�ǳ�����ȡ״̬"])
    local _login_data = { ssrNetMsgCfg.XingChenBian_SyncResponse, lingqu, 0, 0, data }
    if logindatas then
        table.insert(logindatas, _login_data)
    else
        Message.sendmsg(actor, ssrNetMsgCfg.XingChenBian_SyncResponse, lingqu, 0, 0, data)
    end
end
Message.RegisterNetMsg(ssrNetMsgCfg.XingChenBian, XingChenBian)


--��¼����
local function _onLoginEnd(actor, logindatas)
    XingChenBian.SyncResponse(actor, logindatas)
end
GameEvent.add(EventCfg.onLoginEnd, _onLoginEnd, XingChenBian)

return XingChenBian

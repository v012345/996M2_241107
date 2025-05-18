ZhuangBeiQiangHua = {}
ZhuangBeiQiangHua.ID = "װ��ǿ��"
local config = include("QuestDiary/cfgcsv/cfg_ZhuangBeiQiangHua.lua")
--λ��ӳ�����
local varConfig = {
    [1] = VarCfg["U_װ��ǿ��_�·�"], --����
    [0] = VarCfg["U_װ��ǿ��_����"], --�·�
    [6] = VarCfg["U_װ��ǿ��_����"], --����
    [8] = VarCfg["U_װ��ǿ��_���"], --�ҽ�ָ
    [10] = VarCfg["U_װ��ǿ��_����"], --����
    [4] = VarCfg["U_װ��ǿ��_ͷ��"], --ͷ��
    [3] = VarCfg["U_װ��ǿ��_����"], --����
    [5] = VarCfg["U_װ��ǿ��_����"], --����
    [7] = VarCfg["U_װ��ǿ��_�ҽ�"], --�ҽ�
    [11] = VarCfg["U_װ��ǿ��_ѥ��"], --ѥ��
}
function ZhuangBeiQiangHua.Request(actor, arg1, arg2, arg3, data)
    local var = varConfig[arg1]
    if not var then
        Player.sendmsgEx(actor, "��������!!#249")
        return
    end

    -- for key, value in pairs(varConfig) do
    --     setplaydef(actor,value,0)
    -- end

    local itemObj = linkbodyitem(actor, arg1)
    if itemObj == "0" then
        Player.sendmsgEx(actor, "��ǰλ��û�д���װ��!!#249")
        return
    end
    local level = getplaydef(actor, var)
    if level > 14 then
        Player.sendmsgEx(actor, "��װ���Ѿ�ǿ������߼�!#249")
        return
    end
    local cfg = config[level]
    if not cfg then
        Player.sendmsgEx(actor, "��װ���Ѿ�ǿ������߼�!#249")
        return
    end
    local name, num = Player.checkItemNumByTable(actor, cfg.cost)
    if name then
        Player.sendmsgEx(actor, string.format("���|%s#249|����|%d#249|!", name, num))
        return
    end
    Player.takeItemByTable(actor, cfg.cost, "װ��ǿ��")

    if checkitemw(actor,"ǿ��+9999",1) then
        local itemobj = linkbodyitem(actor, 38)
        local usenum = getitemaddvalue(actor, itemobj, 2, 19) --��ȡ��Ϣ�����Ϣ QF �������� ���ñ�� 13
        if usenum > 10 then --����13�� ִ��
            usenum = usenum - 1
            changeitemname(actor, 38, "ǿ��+999[��ʹ��:" .. usenum - 10 .. "��]") --�޸�װ����ʾ����
            setitemaddvalue(actor, itemobj, 2, 19, usenum) --����װ����Ǵ���13��ʹ��һ�μ���һ�� װ����ʧ��
            if randomex(1, 128) then
                setplaydef(actor, var, 15)
                ZhuangBeiQiangHua.SetItemCustomAbilEx(actor, itemObj, 15, arg1, cfg)
                Player.sendmsgEx(actor, "[ǿ��+999]:#251|��ϲ�㴥��|ǿ��+999#249|ר��BUFF|ǿ��ֱ�Ӵﵽ+15#249|...")
                Player.setAttList(actor, "���Ը���")
                if level > 12 then
                    Player.setAttList(actor, "��������")
                end
                ZhuangBeiQiangHua.SyncResponse(actor)
                return
            end
        end
    end
    
    if randomex(cfg.Success) then
        setplaydef(actor, var, level + 1)
        ZhuangBeiQiangHua.SetItemCustomAbilEx(actor, itemObj, level + 1, arg1, cfg)
        Player.sendmsgEx(actor, "ǿ���ɹ�!")
    else
        Player.sendmsgEx(actor, "��Ǹ,ǿ��ʧ����...#249")
    end

    Player.setAttList(actor, "���Ը���")

    if level > 12 then
        Player.setAttList(actor, "��������")
    end
    ZhuangBeiQiangHua.SyncResponse(actor)
end

--��װ������
function ZhuangBeiQiangHua.SetItemCustomAbilEx(actor, itemObj, level, where, cfg)
    setitemaddvalue(actor, itemObj, 2, 3, level) --����
    local equipAttr = {}
    if where == 1 then
        equipAttr = cfg.weaponAttr
    elseif where == 0 then
        equipAttr = cfg.clothAttr
    else
        equipAttr = cfg.ornamentsAttr
    end
    local JianLingChuanShuoNum = 0
    local JiHanHuJiaPian = 0
    for _, value in ipairs(equipAttr) do
        if where == 1 then
            local numCount = getplaydef(actor, VarCfg["U_����_���鴫˵"])
            JianLingChuanShuoNum = numCount * 50
        end
        if where == 0 then
            local numCount = getplaydef(actor, VarCfg["U_��������Ƭ_ʹ�ô���"])
            JiHanHuJiaPian = numCount * 20
        end
        setitemaddvalue(actor, itemObj, 1, value[1], value[2] + JianLingChuanShuoNum + JiHanHuJiaPian)
        JianLingChuanShuoNum = 0
        JiHanHuJiaPian = 0
    end
    refreshitem(actor, itemObj)
    local itemBody = linkbodyitem(actor, where)
    refreshitem(actor, itemBody)
    recalcabilitys(actor)
end

function ZhuangBeiQiangHua.SyncResponse(actor, logindatas)
    local data = {
        [1] = getplaydef(actor, VarCfg["U_װ��ǿ��_�·�"]), --����
        [0] = getplaydef(actor, VarCfg["U_װ��ǿ��_����"]), --�·�
        [6] = getplaydef(actor, VarCfg["U_װ��ǿ��_����"]), --����
        [8] = getplaydef(actor, VarCfg["U_װ��ǿ��_���"]), --�ҽ�ָ
        [10] = getplaydef(actor, VarCfg["U_װ��ǿ��_����"]), --����
        [4] = getplaydef(actor, VarCfg["U_װ��ǿ��_ͷ��"]), --ͷ��
        [3] = getplaydef(actor, VarCfg["U_װ��ǿ��_����"]), --����
        [5] = getplaydef(actor, VarCfg["U_װ��ǿ��_����"]), --����
        [7] = getplaydef(actor, VarCfg["U_װ��ǿ��_�ҽ�"]), --�ҽ�
        [11] = getplaydef(actor, VarCfg["U_װ��ǿ��_ѥ��"]), --ѥ��
    }
    local qhdsFlag = getflagstatus(actor, VarCfg["F_����_ǿ����ʦ��ʶ"])
    local allLevel = getplaydef(actor,VarCfg["U_ȫ��ǿ���ȼ�"])
    local _login_data = { ssrNetMsgCfg.ZhuangBeiQiangHua_SyncResponse, qhdsFlag, allLevel, 0, data }
    if logindatas then
        table.insert(logindatas, _login_data)
    else
        Message.sendmsg(actor, ssrNetMsgCfg.ZhuangBeiQiangHua_SyncResponse, qhdsFlag, allLevel, 0, data)
    end
end

--��¼����
local function _onLoginEnd(actor, logindatas)
    ZhuangBeiQiangHua.SyncResponse(actor, logindatas)
end

--��װ��
local function _onTakeOnEx(actor, itemobj, where, itemname, makeid)
    local var = varConfig[where]
    if var then
        local level = getplaydef(actor, var)
        setitemaddvalue(actor, itemobj, 2, 3, level)
        local tmpLevel = level
        tmpLevel = tmpLevel - 1
        if tmpLevel > 0 then
            local cfg = config[tmpLevel]
            ZhuangBeiQiangHua.SetItemCustomAbilEx(actor, itemobj, level, where, cfg)
        end
    end
end

--��װ��
local function _onTakeOffEx(actor, itemobj, where, itemname, makeid)
    local var = varConfig[where]
    if var then
        setitemaddvalue(actor, itemobj, 2, 3, 0)
        setitemaddvalue(actor, itemobj, 1, 0, 0)
        setitemaddvalue(actor, itemobj, 1, 1, 0)
        setitemaddvalue(actor, itemobj, 1, 2, 0)
        setitemaddvalue(actor, itemobj, 1, 3, 0)
        setitemaddvalue(actor, itemobj, 1, 4, 0)
        refreshitem(actor, itemobj)
    end
end

--��������
local function _onCalcBeiGong(actor, beiGongs)
    local array = {
        getplaydef(actor, VarCfg["U_װ��ǿ��_�·�"]), --����
        getplaydef(actor, VarCfg["U_װ��ǿ��_����"]), --�·�
        getplaydef(actor, VarCfg["U_װ��ǿ��_����"]), --����
        getplaydef(actor, VarCfg["U_װ��ǿ��_���"]), --�ҽ�ָ
        getplaydef(actor, VarCfg["U_װ��ǿ��_����"]), --����
        getplaydef(actor, VarCfg["U_װ��ǿ��_ͷ��"]), --ͷ��
        getplaydef(actor, VarCfg["U_װ��ǿ��_����"]), --����
        getplaydef(actor, VarCfg["U_װ��ǿ��_����"]), --����
        getplaydef(actor, VarCfg["U_װ��ǿ��_�ҽ�"]), --�ҽ�
        getplaydef(actor, VarCfg["U_װ��ǿ��_ѥ��"]), --ѥ��
    }
    local level = findMinValue(array)
    level = level - 1
    if level > 0 then
        if level > 15 then
            level = 15
        end
        local cfg = config[level]
        local beigong = {
            [1] = cfg.shenLi
        }
        calcAtts(beiGongs, beigong, "װ��ǿ������")
    end
end

local function _onCalcAttr(actor, attrs)
    local array = {
        getplaydef(actor, VarCfg["U_װ��ǿ��_�·�"]), --����
        getplaydef(actor, VarCfg["U_װ��ǿ��_����"]), --�·�
        getplaydef(actor, VarCfg["U_װ��ǿ��_����"]), --����
        getplaydef(actor, VarCfg["U_װ��ǿ��_���"]), --�ҽ�ָ
        getplaydef(actor, VarCfg["U_װ��ǿ��_����"]), --����
        getplaydef(actor, VarCfg["U_װ��ǿ��_ͷ��"]), --ͷ��
        getplaydef(actor, VarCfg["U_װ��ǿ��_����"]), --����
        getplaydef(actor, VarCfg["U_װ��ǿ��_����"]), --����
        getplaydef(actor, VarCfg["U_װ��ǿ��_�ҽ�"]), --�ҽ�
        getplaydef(actor, VarCfg["U_װ��ǿ��_ѥ��"]), --ѥ��
    }
    local level = findMinValue(array)
    setplaydef(actor,VarCfg["U_ȫ��ǿ���ȼ�"],level)
    level = level - 1
    --ȫ��װ��ǿ����5���¼��ɷ�
    if level == 4  then
        GameEvent.push(EventCfg.onZhuangBeiQiangHua, actor, level)
        local taskPanelID = getplaydef(actor, VarCfg["U_��������������"])
        if taskPanelID == 18 then
            FCheckTaskRedPoint(actor)
        end
    end
    if level == 6 then
        local taskPanelID = getplaydef(actor, VarCfg["U_��������������"])
        if taskPanelID == 26 then
            FCheckTaskRedPoint(actor)
        end
    end
    if level > 0 then
        if level >= 14 then
            level = 14
        end
        local cfg = config[level]
        local attr = {}
        for _, value in ipairs(cfg.allAttr or {}) do
            attr[value[1]] = value[2]
        end
        calcAtts(attrs, attr, "װ��ǿ��")
    end
end

--���㱶��
GameEvent.add(EventCfg.onCalcBeiGong, _onCalcBeiGong, ZhuangBeiQiangHua)

--��������
GameEvent.add(EventCfg.onCalcAttr, _onCalcAttr, ZhuangBeiQiangHua)

--��¼����
GameEvent.add(EventCfg.onLoginEnd, _onLoginEnd, ZhuangBeiQiangHua)

--��װ������
GameEvent.add(EventCfg.onTakeOnEx, _onTakeOnEx, ZhuangBeiQiangHua)

--��װ������
GameEvent.add(EventCfg.onTakeOffEx, _onTakeOffEx, ZhuangBeiQiangHua)

---ע��������Ϣ
Message.RegisterNetMsg(ssrNetMsgCfg.ZhuangBeiQiangHua, ZhuangBeiQiangHua)
return ZhuangBeiQiangHua

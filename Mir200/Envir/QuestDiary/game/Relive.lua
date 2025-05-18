ReliveMain = {}
local equaldata = include("QuestDiary/cfgcsv/cfg_FuHuoZhuangBei.lua")
--����ɾ������
local function findPosition(tbl, key)
    for i, item in ipairs(tbl) do
        if item.value == equaldata[key].Priority then
            return i
        end
    end
    return nil -- ���û���ҵ������� nil
end

--��ȡ��������
function ReliveMain.GetReliveTable(actor)
    -- return Player.getJsonTableByVar(actor, VarCfg["T_����״̬"])
    return Player.getJsonTableByPlayVar(actor, "KFZF3")
end

--���ø�������
function ReliveMain.SetReliveTable(actor, ReliveQueue)
    Player.setJsonVarByTable(actor, VarCfg["T_����״̬"], ReliveQueue)
    Player.setJsonPlayVarByTable(actor, "KFZF3", ReliveQueue)
end

-- ��Ӳ���
local function AddQueue(actor, itemname)
    local ReliveQueue = ReliveMain.GetReliveTable(actor)
    local state = findPosition(ReliveQueue, itemname)
    if state == nil then                                                                    -- ����
        table.insert(ReliveQueue, { key = itemname, value = equaldata[itemname].Priority }) --��������
    end
    table.sort(ReliveQueue, function(a, b)
        return a.value < b.value
    end)
    ReliveMain.SetReliveTable(actor, ReliveQueue) --���ø�������
    ReliveMain.SyncResponse(actor)
end

-- ���Ӳ���
local function DelQueue(actor, ReliveQueue, num)
    if #ReliveQueue > 0 then                          --������д���0
        table.remove(ReliveQueue, num)
        ReliveMain.SetReliveTable(actor, ReliveQueue) --���ø�������
        -- ReliveMain.SyncResponse(actor)
    end
end
--------------------------------------------------------------�·�--------------------------------------------------------------
-- �·�λ�� --��
local function _onTakeOn0(actor, itemobj)
    local ItemName = getiteminfo(actor, itemobj, 7)
    if equaldata[ItemName] then
        setplaydef(actor, VarCfg["U_�������1"], equaldata[ItemName].times)
        setontimer(actor, 101, 1, 0, 1) --���101�Ŷ�ʱ��
        ReliveMain.SyncResponse(actor)
    end
end
GameEvent.add(EventCfg.onTakeOn0, _onTakeOn0, ReliveMain)

-- �·�λ�� --��
local function _onTakeOff0(actor, itemobj)
    local ReliveQueue = ReliveMain.GetReliveTable(actor)
    local ItemName = getiteminfo(actor, itemobj, 7)
    if equaldata[ItemName] then
        local number = findPosition(ReliveQueue, ItemName)
        if number ~= nil then
            DelQueue(actor, ReliveQueue, number)
        end
        setofftimer(actor, 101) --�ر�101��ʱ��
        setplaydef(actor, VarCfg["U_�������1"], 0)
        ReliveMain.SyncResponse(actor)
    end
end
GameEvent.add(EventCfg.onTakeOff0, _onTakeOff0, ReliveMain)

--------------------------------------------------------------��֮��--------------------------------------------------------------
--������֮��λ��
local function _onTakeOn9(actor, itemobj)
    local ItemName = getiteminfo(actor, itemobj, 7)
    if equaldata[ItemName] then
        setplaydef(actor, VarCfg["U_�������2"], equaldata[ItemName].times)
        setontimer(actor, 102, 1, 0, 1) --���102�Ŷ�ʱ��
        ReliveMain.SyncResponse(actor)
    end
end
GameEvent.add(EventCfg.onTakeOn9, _onTakeOn9, ReliveMain)

-- ��֮�� --��
local function _onTakeOff9(actor, itemobj)
    local ReliveQueue = ReliveMain.GetReliveTable(actor)
    local ItemName = getiteminfo(actor, itemobj, 7)
    if equaldata[ItemName] then
        local number = findPosition(ReliveQueue, ItemName)
        if number ~= nil then
            DelQueue(actor, ReliveQueue, number)
        end
        setofftimer(actor, 102) --�ر�102��ʱ��
        setplaydef(actor, VarCfg["U_�������2"], 0)
        ReliveMain.SyncResponse(actor)
    end
end
GameEvent.add(EventCfg.onTakeOff9, _onTakeOff9, ReliveMain)

--������֮�ĵ�ʱ�� ����һ�����²���
local function _LongZhiXinUp(actor, ItemName)
    local ReliveQueue = ReliveMain.GetReliveTable(actor)
    if equaldata[ItemName] then
        local number = findPosition(ReliveQueue, ItemName)
        if number ~= nil then
            DelQueue(actor, ReliveQueue, number)
        end
        setofftimer(actor, 102) --�ر�102��ʱ��
        setplaydef(actor, VarCfg["U_�������2"], 0)
        ReliveMain.SyncResponse(actor)
    end
end
GameEvent.add(EventCfg.LongZhiXinUp, _LongZhiXinUp, ReliveMain)

--�����ֻ���
local function _onTakeOnEx(actor, itemobj, where, itemname, makeid)
    if itemname == "�����ֻ���" then
        if equaldata[itemname] then
            setplaydef(actor, VarCfg["U_�������3"], equaldata[itemname].times)
            setontimer(actor, 103, 1, 0, 1) --���103�Ŷ�ʱ��
            ReliveMain.SyncResponse(actor)
        end
    end
end

GameEvent.add(EventCfg.onTakeOnEx, _onTakeOnEx, ReliveMain)

--�����ֻ���
local function _onTakeOffEx(actor, itemobj, where, itemname, makeid)
    if itemname == "�����ֻ���" then
        local ReliveQueue = ReliveMain.GetReliveTable(actor)
        if equaldata[itemname] then
            local number = findPosition(ReliveQueue, itemname)
            if number ~= nil then
                DelQueue(actor, ReliveQueue, number)
            end
            setofftimer(actor, 103) --�ر�103��ʱ��
            setplaydef(actor, VarCfg["U_�������3"], 0)
            ReliveMain.SyncResponse(actor)
        end
    end
end
GameEvent.add(EventCfg.onTakeOffEx, _onTakeOffEx, ReliveMain)


--��ʱ��    101��
local function _ReliveCountdown_1(actor)
    local item_num = getplaydef(actor, VarCfg["U_�������1"])
    -- release_print("1�ŵ���ʱ" .. item_num)
    if item_num > 0 then
        setplaydef(actor, VarCfg["U_�������1"], item_num - 1)
    elseif item_num == 0 then
        local ItemName = getconst(actor, "<$DRESS>")
        setofftimer(actor, 101) --�ر�101��ʱ��
        if equaldata[ItemName] then
            AddQueue(actor, ItemName)
        end
    end
end
GameEvent.add(EventCfg.ReliveCountdown_1, _ReliveCountdown_1, ReliveMain)


--��ʱ��    102��
local function _ReliveCountdown_2(actor)
    local item_num = getplaydef(actor, VarCfg["U_�������2"])
    -- release_print("���2�ŵ���ʱ" .. item_num)
    if item_num > 0 then
        setplaydef(actor, VarCfg["U_�������2"], item_num - 1)
    elseif item_num == 0 then
        local ItemName = getconst(actor, "<$BUJUK>")
        setofftimer(actor, 102) --�ر�102��ʱ��
        if equaldata[ItemName] then
            AddQueue(actor, ItemName)
        end
    end
end
GameEvent.add(EventCfg.ReliveCountdown_2, _ReliveCountdown_2, ReliveMain)

--��ʱ��    103��
local function _ReliveCountdown_3(actor)
    local item_num = getplaydef(actor, VarCfg["U_�������3"])
    -- release_print("���3�ŵ���ʱ" .. item_num)
    if item_num > 0 then
        setplaydef(actor, VarCfg["U_�������3"], item_num - 1)
    elseif item_num == 0 then
        local ItemName = "�����ֻ���"
        if checkitemw(actor, ItemName, 1) then
            setofftimer(actor, 103) --�ر�103��ʱ��
            if equaldata[ItemName] then
                AddQueue(actor, ItemName)
            end
        end
    end
end
GameEvent.add(EventCfg.ReliveCountdown_3, _ReliveCountdown_3, ReliveMain)



-- ����ǰ����
local function _onNextDie(actor, hiter, isplay)
    local ReliveQueue = ReliveMain.GetReliveTable(actor)
    if ReliveQueue[1] ~= nil then --�ɸ�����в�Ϊ��
        setplaydef(actor, VarCfg.Die_Flag, 1)
        setplaydef(actor, VarCfg["N$�Ƿ��Ƹ���"], 1)
        changemode(actor, 23, 1, 1, 1) --��Ӹ���״̬
        if checkitemw(actor, ReliveQueue[1].key, 1) then
            if equaldata[ReliveQueue[1].key] then
                setplaydef(actor, VarCfg["U_�������" .. equaldata[ReliveQueue[1].key].Priority .. ""],
                    equaldata[ReliveQueue[1].key].times)
                setontimer(actor, "10" .. equaldata[ReliveQueue[1].key].Priority, 1, 0, 1) --���10X�Ŷ�ʱ��
            end
        end
        -- release_print("����װ��-------" .. ReliveQueue[1].key)
        DelQueue(actor, ReliveQueue, 1) --ִ�г��Ӳ���
        ReliveMain.SyncResponse(actor)
    else
        --û�и���
        setplaydef(actor, VarCfg.Die_Flag, 1)
        setplaydef(actor, VarCfg["N$�Ƿ��Ƹ���"], 0)
    end
end
GameEvent.add(EventCfg.onNextDie, _onNextDie, ReliveMain)

--�Ƹ���
function ReliveMain.DelRelive(actor, target)
    local ReliveQueue = ReliveMain.GetReliveTable(actor)
    if ReliveQueue[1] ~= nil then --�ɸ�����в�Ϊ��
        if checkitemw(actor, ReliveQueue[1].key, 1) then
            if equaldata[ReliveQueue[1].key] then
                setplaydef(actor, VarCfg["U_�������" .. equaldata[ReliveQueue[1].key].Priority .. ""],
                    equaldata[ReliveQueue[1].key].times)
                setontimer(actor, "10" .. equaldata[ReliveQueue[1].key].Priority, 1, 0, 1) --���10X�Ŷ�ʱ��
            end
        end
        DelQueue(actor, ReliveQueue, 1) --ִ�г��Ӳ���
        ReliveMain.SyncResponse(actor)
    end
end

--��ȡ��ǰ�����Ƿ�ɸ���
function ReliveMain.GetReliveState(actor)
    local ReliveQueue = ReliveMain.GetReliveTable(actor)
    if ReliveQueue[1] ~= nil then
        return true
    else
        return false
    end
end

--������С�ĸ���CD
local function findMinCd(equipments)
    local min_cd = nil
    -- ��������װ��
    for _, equipment in ipairs(equipments) do
        local name = ""
        if equipment.name == "" or not equipment.name then
            name = "��"
        else
            name = equipment.name
        end
        if equaldata[name] then
            if equipment.cd then
                if not min_cd or equipment.cd < min_cd then
                    min_cd = equipment.cd
                end
            end
        end
    end
    return min_cd
    --�������nil����û����
end

--����������Ϣ
function ReliveMain.SyncResponse(actor, logindatas)
    local ItemName1 = getconst(actor, "<$DRESS>") --�·�λ��
    local ItemName2 = getconst(actor, "<$BUJUK>") --����λ��
    local ItemName3 = "��"
    if checkitemw(actor, "�����ֻ���", 1) then
        ItemName3 = "�����ֻ���" --�����ֻ���
    end
    local time1 = getplaydef(actor, VarCfg["U_�������1"])
    local time2 = getplaydef(actor, VarCfg["U_�������2"])
    local time3 = getplaydef(actor, VarCfg["U_�������3"])
    local ReliveQueue = ReliveMain.GetReliveTable(actor)
    local equipments = {
        { name = ItemName1, cd = time1 },
        { name = ItemName2, cd = time2 },
        { name = ItemName3, cd = time3 },
    }
    local state = nil
    local reliveState = "1"
    if #ReliveQueue > 0 then
        state = "�ɸ���+" .. #ReliveQueue
        reliveState = "1"
    else
        local min_cd = findMinCd(equipments)
        if not min_cd then
            state = "δ����"
        else
            state = min_cd
        end
        reliveState = "0"
    end
    --����ı�״̬����
    if checkkuafu(actor) then
        FKuaFuToBenFuEvent(actor, EventCfg.onRliveNotice, reliveState)
    else
        GameEvent.push(EventCfg.onRliveNotice, actor, reliveState)
    end
    local _login_data = { ssrNetMsgCfg.LeftAttr_FuHuo, 0, 0, 0, { state } }
    if logindatas then
        table.insert(logindatas, _login_data)
    else
        Message.sendmsg(actor, ssrNetMsgCfg.LeftAttr_FuHuo, 0, 0, 0, { state })
    end
end

--��¼����
local function _onLoginEnd(actor, logindatas)
    local item_num1 = getplaydef(actor, VarCfg["U_�������1"])
    local item_num2 = getplaydef(actor, VarCfg["U_�������2"])
    local item_num3 = getplaydef(actor, VarCfg["U_�������3"])
    if item_num1 > 0 then
        setontimer(actor, 101, 1, 0, 1) --���101�Ŷ�ʱ��
    end
    if item_num2 > 0 then
        setontimer(actor, 102, 1, 0, 1) --���102�Ŷ�ʱ��
    end
    if item_num3 > 0 then
        setontimer(actor, 103, 1, 0, 1) --���103�Ŷ�ʱ��
    end
    ReliveMain.SyncResponse(actor, logindatas)
end
GameEvent.add(EventCfg.onLoginEnd, _onLoginEnd, ReliveMain)

GameEvent.add(EventCfg.onKuaFuEnd, _onLoginEnd, ReliveMain)

local function _onRliveNotice(actor, reliveState)
    -- release_print(actor, reliveState,Player.GetNameEx(actor))
    local Tbl = {31083, 31089, 31090, 31091}
    for _, v in ipairs(Tbl) do
        if hasbuff(actor, v) then
            delbuff(actor, v)
        end
    end
    if reliveState == "0" then
        if checkitemw(actor, "�����а��", 1) then
            addbuff(actor, 31083)
        end

        --���ػꨕ �����,���ɸ���״̬�£�����100%����
        if checkitemw(actor, "���ػꨕ", 1) then
            addbuff(actor, 31089)
        end
 
        --�o����둡������ ������ʱ����15%���Ѫ��
        if checkitemw(actor, "�o����둡������", 1) then
            addbuff(actor, 31091)
        end
    else
        if checkitemw(actor, "�o����둡������", 1) then
            addbuff(actor, 31090)
        end
    end
end
--����״̬�ı䴥��
GameEvent.add(EventCfg.onRliveNotice, _onRliveNotice, ReliveMain)

--ע��������Ϣ
Message.RegisterNetMsg(ssrNetMsgCfg.LeftAttr, ReliveMain)

return ReliveMain

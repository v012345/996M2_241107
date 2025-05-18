local CuiPanGuan = {}
CuiPanGuan.ID = "���й�"
local npcID = 452
local config = include("QuestDiary/cfgcsv/cfg_CuiPanGuan.lua") --����
local config2 = include("QuestDiary/cfgcsv/cfg_CuiPanGuan_config.lua") --����
local cost = {{"���",200}}
local give = {{}}
local function generateString(config, excludeLast)
    local result = {}
    
    -- �������� config
    for i = 1, #config do
        -- ��� excludeLast Ϊ true�����ҵ�ǰԪ�������һ����������
        if i ~= #config or not excludeLast then
            -- ���� ����#weight �ַ���
            table.insert(result, i .. "#" .. config[i].weight)
        end
    end
    
    -- ���������Ϊһ���ַ���
    return table.concat(result, "|")
end
--����������������
local function getTwoUniqueElements(arr)
    if #arr < 2 then
        return
    end

    -- �����ȡ��һ������
    local index1 = math.random(1, #arr)

    -- �����ȡ�ڶ���������ȷ�������һ���ظ�
    local index2
    repeat
        index2 = math.random(1, #arr)
    until index2 ~= index1

    -- ���ض�Ӧ���������ظ���Ԫ��
    return arr[index1], arr[index2]
end

--��������
function CuiPanGuan.Request(actor)
    if not FCheckNPCRange(actor, npcID, 15) then
        Player.sendmsgEx(actor, "����PNC̫Զ!#249")
        return
    end
    if not checkitemw(actor,"������",1) then
        Player.sendmsgEx(actor, "������û�д���װ��:|������#249|�޷���������!")
        return
    end
    local name, num = Player.checkItemNumByTable(actor, cost)
    if name then
        Player.sendmsgEx(actor, string.format("���|%s#249|����|%d#249", name, num))
        return
    end
    Player.takeItemByTable(actor, cost, "���йپ���")
    --��ȡ��Ʒ����
    local diNum = TianMing.GetTianMingNum(actor, 5)
    local weightString = generateString(config2, diNum >= 10)
    local result = ransjstr(weightString, 1, 3)
    local cfg2 = config2[tonumber(result)]
    local attrs1, attrs2 = getTwoUniqueElements(config)
    local shuxing = {}
    --��ֵ��һ������ID������
    if attrs1 then
        for _, value in ipairs(attrs1.attrs) do
            if value == 75 then
                shuxing[value] = tonumber(cfg2.attrValue1) * 100
            else
                shuxing[value] = tonumber(cfg2.attrValue1)
            end
        end
    end
    --��ֵ�ڶ�������ID������
    if attrs2 then
        for _, value in ipairs(attrs2.attrs) do
            if value == 75 then
                shuxing[value] = tonumber(cfg2.attrValue2) * 100
            else
                shuxing[value] = tonumber(cfg2.attrValue2)
            end
        end
    end
    --�����Ե�buff
    if hasbuff(actor,31031) then
        FkfDelBuff(actor,31031)
    end
    addbuff(actor, 31031, 0, 1, actor, shuxing)

    --����һ���µı�ͬ������
    local newTable = {}
    if attrs1 and attrs2 then
        newTable = {
            tonumber(result),
            attrs1.idx,
            attrs2.idx,
        }
    end
    Player.setJsonVarByTable(actor,VarCfg["T_��¼�йٸ���"],newTable)
    local num = getplaydef(actor, VarCfg["U_�йٸ�������"])
    if num < 3 then
        setplaydef(actor, VarCfg["U_�йٸ�������"], num + 1)
        if num + 1 == 1 then
            local taskPanelID = getplaydef(actor, VarCfg["U_��������������"])
            if taskPanelID == 36 then
                FCheckTaskRedPoint(actor)
            end
        end
    end
    CuiPanGuan.SyncResponse(actor)
end
--ͬ����Ϣ
function CuiPanGuan.SyncResponse(actor, logindatas)
    local data = Player.getJsonTableByVar(actor, VarCfg["T_��¼�йٸ���"])
    local _login_data = {ssrNetMsgCfg.CuiPanGuan_SyncResponse, 0, 0, 0, data}
    if logindatas then
        table.insert(logindatas, _login_data)
    else
        Message.sendmsg(actor, ssrNetMsgCfg.CuiPanGuan_SyncResponse, 0, 0, 0, data)
    end
end
--��¼����
local function _onLoginEnd(actor, logindatas)
    CuiPanGuan.SyncResponse(actor, logindatas)
end
--�¼��ɷ�
GameEvent.add(EventCfg.onLoginEnd, _onLoginEnd, CuiPanGuan)
--ע��������Ϣ
Message.RegisterNetMsg(ssrNetMsgCfg.CuiPanGuan, CuiPanGuan)
return CuiPanGuan
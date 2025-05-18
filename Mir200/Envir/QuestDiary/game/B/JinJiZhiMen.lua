JinJiZhiMen = {}
local config = include("QuestDiary/cfgcsv/cfg_JinJiZhiMen.lua") --������Ϣ
local group_sizes = { 9, 9, 9, 9 }
local tuJianCache = {}
JinJiZhiMen.ID = "����֮��"
--ö�ٵ�ͼ���
local mapIds = { "����֮��һ��", "����֮�Ŷ���", "����֮������", "����֮���Ĳ�" }
--��������
local function calculateNumber(group, index, group_sizes)
    if group < 1 or group > #group_sizes then
        return false
    end
    if index < 1 or index > group_sizes[group] then
        return false
    end
    local number = 0
    for i = 1, group - 1 do
        number = number + group_sizes[i]
    end
    number = number + index
    return number
end

--������������
local function GetInterval(segment)
    -- ��鴫��Ķκ��Ƿ���Ч������Ч��Χ�ڣ�
    if segment < 1 or segment > #group_sizes then
        return false
    end
    -- ���㵱ǰ�ε���ʼ����
    -- ��ʼ����ʼ����Ϊ1
    local start_index = 1
    -- ͨ���ۼ�֮ǰ�εĳ�����������ʼ����
    for i = 1, segment - 1 do
        start_index = start_index + group_sizes[i]
    end

    -- ���㵱ǰ�εĽ�������
    local end_index = start_index + group_sizes[segment] - 1

    -- ��ȡ��ǰ�ε�Ԫ��
    local result = {}
    for i = start_index, end_index do
        table.insert(result, config[i])
    end

    return result
end

--����ͼ������
local function SetTuJianCache(actor, data)
    tuJianCache[actor] = data
end

--ɾ��ͼ������
local function DelTuJianCache(actor)
    tuJianCache[actor] = nil
end

--��ȡͼ���б�
local function GetTuJianList(actor)
    if tuJianCache[actor] then
        return tuJianCache[actor]
    end
    local result = Player.getJsonTableByVar(actor, VarCfg.T_tujian)
    tuJianCache[actor] = result
    return result
end

--����ͼ��
local function ActivateTuJian(actor, tuJianName)
    local tuJianList = GetTuJianList(actor)
    if tuJianList[tuJianName] then
        Player.sendmsgEx(actor, tuJianName .. "�Ѽ���!#249")
        return
    end
    tuJianList[tuJianName] = 1
    SetTuJianCache(actor, tuJianList)
    Player.setJsonVarByTable(actor, VarCfg.T_tujian, tuJianList)
    Player.sendmsgEx(actor,"��ϲ����ɹ���!")
    JinJiZhiMen.SyncResponse(actor, nil, tuJianList)
end

--�жϵ�ǰͼ���Ƿ�ȫ������
local function IsAllTuJianActivate(actor, index)
    local tuJianList = GetTuJianList(actor)
    local currTuJianList = GetInterval(index)
    if not currTuJianList then
        return false
    end
    for _, v in pairs(currTuJianList) do
        if not tuJianList[v.name] then
            return false
        end
    end
    return true
end

--��ȡͼ������
local function GetTuJianAttr(actor)
    local tuJianList = GetTuJianList(actor)
    local shuxing = {}
    for _, value in ipairs(config) do
        if tuJianList[value.name] then
            for i, v in ipairs(value.attr) do
                if not shuxing[v[1]] then
                    shuxing[v[1]] = v[2]
                else
                    shuxing[v[1]] = shuxing[v[1]] + v[2]
                end
            end
        end
    end
    return shuxing
end

--��ͼ������ת���������ַ���
local function GetTuJianAttrStr(actor)
    local shuxing = GetTuJianAttr(actor)
    local str = ""
    local attrList = {}
    for key, value in pairs(shuxing) do
        table.insert(attrList, "3#" .. key .. "#" .. value)
    end
    str = table.concat(attrList, "|")
    return str
end

function JinJiZhiMen.GetAttrStr(actor)
    return GetTuJianAttrStr(actor)
end

--��װ����������
local function AddEquipTuJianAttr(actor)
    local attrStr = GetTuJianAttrStr(actor)
    if attrStr ~= "" then
        setaddnewabil(actor, 43, "=", "3#171#0|3#172#0|3#1#0|3#4#0|3#75#0|3#173#0|3#170#0|3#3#0")
        setaddnewabil(actor, 43, "=", attrStr)
        local itemObj = linkbodyitem(actor, 43)
        refreshitem(actor, itemObj)
    end
end

--��ȡ�������Լ��������
local function GetTuJianAttrCalc(actor)
    local shuxing = GetTuJianAttr(actor)
    local result = {}
    if shuxing[171] then
        result[204] = shuxing[171]
    end
    if shuxing[172] then
        result[200] = shuxing[172]
    end
    local beigopng = 0
    if shuxing[173] then
        beigopng = shuxing[173]
    end
    return result, beigopng
end

function JinJiZhiMen.Request(actor, arg1, arg2)
    local itemObj = linkbodyitem(actor, 43)
    if itemObj == "0" then
        Player.sendmsgEx(actor, "��û��װ������װ��,�����Լ���!#249")
        return
    end
    local index = calculateNumber(arg1, arg2, group_sizes)
    if not index then
        Player.sendmsgEx(actor, "��������1!#249")
        return
    end
    local cfg = config[index]
    if not cfg then
        Player.sendmsgEx(actor, "��������2!#249")
        return
    end
    local tuJianList = GetTuJianList(actor)
    if tuJianList[cfg.name] then
        Player.sendmsgEx(actor, cfg.name .. "�Ѽ���!#249")
        return
    end
    local name, num = Player.checkItemNumByTable(actor, cfg.cost)
    if name then
        Player.sendmsgEx(actor, string.format("���|%s#249|����|%d#249", name, num))
        return
    end
    Player.takeItemByTable(actor, cfg.cost, "����֮��")
    if randomex(cfg.random) then
        ActivateTuJian(actor, cfg.name)
        AddEquipTuJianAttr(actor)
        FSetTaskRedPoint(actor, VarCfg["F_����֮�ż���"], 12)
        Player.setAttList(actor, "���Ը���")
        Player.setAttList(actor, "��������")
    else
        Player.sendmsgEx(actor, "����ʧ����!#249")
        local tuJianList = GetTuJianList(actor)
        JinJiZhiMen.SyncResponse(actor, nil, tuJianList)
    end
end

function JinJiZhiMen.EnterMap(actor, arg1)
    local isActivate = IsAllTuJianActivate(actor, arg1)
    if not isActivate then
        Player.sendmsgEx(actor, "��û�м���ȫ������,�޷�����!#249")
        return
    end
    local mapId = mapIds[arg1]
    if not mapId then
        Player.sendmsgEx(actor, "��������!#249")
        return
    end
    GameEvent.push(EventCfg.onJinRuJiJiZhiMen,actor)

    map(actor, mapId)
    delaygoto(actor, 10, "entermapmsg")
end

--ͬ������
function JinJiZhiMen.SyncResponse(actor, logindatas, data)
    if not data then
        data = GetTuJianList(actor)
    end
    local _login_data = { ssrNetMsgCfg.JinJiZhiMen_SyncResponse, 0, 0, 0, data }
    if logindatas then
        table.insert(logindatas, _login_data)
    else
        Message.sendmsg(actor, ssrNetMsgCfg.JinJiZhiMen_SyncResponse, 0, 0, 0, data)
    end
end

-----------������Ϣ-----------
--ע��������Ϣ
Message.RegisterNetMsg(ssrNetMsgCfg.JinJiZhiMen, JinJiZhiMen)

--�����¼�-----
--��װ����������
local function _onTakeOn43(actor, itemobj)
    AddEquipTuJianAttr(actor)
end
GameEvent.add(EventCfg.onTakeOn43, _onTakeOn43, JinJiZhiMen)

--���㱶������
local function _onCalcBeiGong(actor, beiGongs)
    local shuxing, beigong = GetTuJianAttrCalc(actor)
    if beigong then
        beiGongs[1] = beiGongs[1] + beigong
    end
end
--���㱶��
GameEvent.add(EventCfg.onCalcBeiGong, _onCalcBeiGong, JinJiZhiMen)

local function _onCalcAttr(actor, attrs)
    local shuxing, beigong = GetTuJianAttrCalc(actor)
    local num = table.nums(shuxing)
    if num > 0 then
        calcAtts(attrs, shuxing, "����֮��")
    end
end
--����
GameEvent.add(EventCfg.onCalcAttr, _onCalcAttr, JinJiZhiMen)


--��¼����
local function _onLoginEnd(actor, logindatas)
    JinJiZhiMen.SyncResponse(actor, logindatas)
end
--�¼��ɷ�
GameEvent.add(EventCfg.onLoginEnd, _onLoginEnd, JinJiZhiMen)

--����С�˴���--������
local function _onExitGame(actor)
    DelTuJianCache(actor)
end
GameEvent.add(EventCfg.onExitGame, _onExitGame, JinJiZhiMen)

--�л���ͼ����
local function _goSwitchMap(actor, cur_mapid, former_mapid)
    -- ����֮��һ��
    -- ����֮�Ŷ���
    -- ����֮������
    -- ����֮���Ĳ�
    if cur_mapid == "����֮��һ��" or cur_mapid == "����֮�Ŷ���" or cur_mapid == "����֮������" or cur_mapid == "����֮���Ĳ�" then
        setplaydef(actor, VarCfg["M_����֮�ű���"], 1)
        Player.setAttList(actor, "���ʸ���")
    elseif former_mapid == "����֮��һ��" or former_mapid == "����֮�Ŷ���" or former_mapid == "����֮������" or former_mapid == "����֮���Ĳ�" then
        setplaydef(actor, VarCfg["M_����֮�ű���"], 0)
        Player.setAttList(actor, "���ʸ���")
    end
end
GameEvent.add(EventCfg.goSwitchMap, _goSwitchMap, JinJiZhiMen)

local function _onCalcBaoLv(actor, attrs)
    if getplaydef(actor, VarCfg["M_����֮�ű���"]) == 1 then
        local shuxing = {
            [204] = 300
        }
        calcAtts(attrs, shuxing, "���ʸ���:����֮�Ž����ͼ")
    end
end
GameEvent.add(EventCfg.onCalcBaoLv, _onCalcBaoLv, JinJiZhiMen)


return JinJiZhiMen

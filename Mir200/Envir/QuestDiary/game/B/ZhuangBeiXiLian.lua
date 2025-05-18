--[[
--װ��ϴ��
]]
local ZhuangBeiXiLian = {}
local config = include("QuestDiary/cfgcsv/cfg_ZhuangBeiXiLian.lua") --ϴ��
local cost = { { "����ʯ", 66 }, { "�칤֮��", 66 }, { "���", 200000 } } --����1
local cost1 = { { "����ʯ", 33 }, { "�칤֮��", 33 }, { "���", 40 } } --����2
local abilGroup = 2
--ö��װ�����
local equipmentCategories = {
    [0] = { 2, "�·�" }, -- �·�
    [1] = { 1, "����" }, -- ����
    [3] = { 3, "����" }, -- ��������
    [4] = { 3, "ͷ��" }, -- ����ͷ��
    [5] = { 3, "������" }, -- ����������
    [6] = { 3, "������" }, -- ����������
    [7] = { 3, "�ҽ�ָ" }, -- �����ҽ�ָ
    [8] = { 3, "���ָ" }, -- �������ָ
    [10] = { 3, "����" }, -- ��������
    [11] = { 3, "ѥ��" } -- ����ѥ��
}
--ϴ���ȼ�
local xiLianLevel = { { "��ͨ", 254, 500 }, { "һ��", 251, 300 }, { "����", 253, 150 }, { "ϡ��", 215, 40 }, { "ʷʫ", 70, 10 } }
-- �ж������Ƿ���ڱ��������������ǵ������ֻ����飩
---* ��ǰ����
---* �Աȵ����ֻ�������
local function checkValue(value, variable)
    if type(variable) == "number" then
        return value == variable
    elseif type(variable) == "table" then
        for _, v in ipairs(variable) do
            if value == v then
                return true
            end
        end
    end
    return false
end
--����ٷֱ���ֵ
local function calculatePercentageResult(total, num)
    if total == 0 then
        return 0
    end
    local value = (num / 100) * total
    return math.floor(value + 0.5) -- ��������
end

---------------������Ϣ----------------
function ZhuangBeiXiLian.Request(actor, where, XiLianType)
    if not where then return end
    --��ȡ����
    local equipmentType = equipmentCategories[where]
    if equipmentType == nil then
        Player.sendmsgEx(actor, "[��ʾ]:#251|ֻ��ϴ�������·�����!#249")
        return
    end

    local itemobj = linkbodyitem(actor, where)
    if itemobj == "0" then
        Player.sendmsgEx(actor, "[��ʾ]:#251|������û�д���#250|" .. equipmentType[2] .. "#249")
        return
    end
    local equipName = getiteminfo(actor,itemobj,ConstCfg.iteminfo.name)
    if equipName == "���ɻ꡿��֮��Ӱ" then
        Player.sendmsgEx(actor, "[��ʾ]:#251|���ɻ꡿��֮��Ӱ#249|��ֹϴ����")
        return
    end
    local curCost = cost
    if XiLianType == 1 then
        curCost = cost
    elseif XiLianType == 2 then
        curCost = cost1
    else
        Player.sendmsgEx(actor, "��������!")
        return
    end

    local name, num = Player.checkItemNumByTable(actor, curCost)
    if name then
        Player.sendmsgEx(actor, string.format("[��ʾ]:#251|���#250|%s#249|����#250|%s#249|��", name, num))
        return
    end
    Player.takeItemByTable(actor, curCost, "װ��ϴ��")

    ---ϴ����ʼ
    local xiLianLevelQuanZhong = {}
    for i, v in ipairs(xiLianLevel) do
        table.insert(xiLianLevelQuanZhong, string.format("%d#%d", i, v[3]))
    end
    local setLevel = ransjstr(table.concat(xiLianLevelQuanZhong, "|"), 1, 3)
    setLevel = tonumber(setLevel) or 1
    local newConfig = {}
    local attrListWeight = {}
    for i, value in ipairs(config) do
        if checkValue(equipmentType[1], value.where) then
            table.insert(newConfig, value)
            table.insert(attrListWeight, i .. "#" .. value.weight)
        end
    end

    if XiLianType == 2 then
        setLevel = 5
    end

    
    --ϴ���¼��ɷ� 
    ---* actor:��Ҷ���
    ---* setLevel:ϴ�����Ե�����
    GameEvent.push(EventCfg.onZhuangBeiXiLian, actor, setLevel)
    -- release_print(table.concat(attrListWeight, "|"))
    --��ȡ�����б�
    local attrListWeightResult = {}
    for i = 1, setLevel do
        local id = ransjstr(table.concat(attrListWeight, "|"), 1, 3)
        id = tonumber(id)
        table.insert(attrListWeightResult, id)
    end

    ---������һ������
    clearitemcustomabil(actor, itemobj, abilGroup)
    ---�������
    local levelName = xiLianLevel[setLevel][1]
    local levelColor = xiLianLevel[setLevel][2]
    changecustomitemtext(actor, itemobj, "[".. levelName .."]:", abilGroup)
    changecustomitemtextcolor(actor, itemobj, levelColor, abilGroup)
    local extraAttributes = {} --��Ҫ�������������
    for i, v in ipairs(attrListWeightResult) do
        local value = config[v]
        local attrValue
        --���ε��������
        if equipmentType[1] == 3 then
            attrValue = math.random(value.random2[1], value.random2[2])
        else
        --���׵��������
            attrValue = math.random(value.random1[1], value.random1[2])
        end
        --ϵͳ�Ƿ���ֱ�
        if value.systmeIsAttrPercent == 1 then
            attrValue = attrValue * 100
        end
        -- release_print(value.realAttrId, value.attrId)
        Player.addModifyCustomAttributes(actor, itemobj, abilGroup, i, value.attrType, value.attrColor, value.realAttrId, value.attrId, value.isAttrPercent, attrValue)
        if v == 4 or v == 11 or v == 14 then
            if not extraAttributes[v] then
                extraAttributes[v] = attrValue
            else
                extraAttributes[v] = extraAttributes[v] + attrValue
            end
        end
    end
    --3#3#123|3#4#456|3#1#789|3#9#111|3#10#222
    setaddnewabil(actor,-2,"=","3#3#0|3#4#0|3#1#0|3#9#0|3#10#0",itemobj)
    --�������Ҫ���������
    local itemid = getiteminfo(actor,itemobj,ConstCfg.iteminfo.idx)
    if table.nums(extraAttributes) > 0 then
        local attackMin = 0 --��������
        local attackMax = 0 --��������
        local hp = 0 --Ѫ
        local defenseMin = 0 --��������
        local defenseMax = 0 --��������
        for key, value in pairs(extraAttributes) do
            if key == 4 then
                attackMin = getstditematt(itemid, 3)
                attackMax = getstditematt(itemid, 4)
                attackMin = calculatePercentageResult(attackMin, value)
                attackMax = calculatePercentageResult(attackMax, value)

            end
            if key == 11 then
                hp = getstditematt(itemid, 1)
                hp = calculatePercentageResult(hp, value)
            end
            if key == 14 then
                defenseMin = getstditematt(itemid, 9)
                defenseMax = getstditematt(itemid, 10)
                defenseMin = calculatePercentageResult(defenseMin, value)
                defenseMax = calculatePercentageResult(defenseMax, value)
            end
        end
        --��ʼ������������
        setaddnewabil(actor,-2,"=",string.format("3#3#%d|3#4#%d|3#1#%d|3#9#%d|3#10#%d", attackMin, attackMax, hp, defenseMin, defenseMax),itemobj)
    end
    local num = getplaydef(actor,VarCfg["U_װ��ϴ���ܴ���"])
    setplaydef(actor,VarCfg["U_װ��ϴ���ܴ���"], num + 1)
    if num + 1 == 3 then
       local taskPanelID = getplaydef(actor, VarCfg["U_��������������"])
        if taskPanelID == 10 then
            FCheckTaskRedPoint(actor)
        end
    end
    -- --ͬ��һ����Ϣ
    ZhuangBeiXiLian.SyncResponse(actor)
end

-------------������Ϣ������--------------------------
Message.RegisterNetMsg(ssrNetMsgCfg.ZhuangBeiXiLian, ZhuangBeiXiLian)
--ͬ��������Ϣ
function ZhuangBeiXiLian.SyncResponse(actor)
    Message.sendmsg(actor, ssrNetMsgCfg.ZhuangBeiXiLian_SyncResponse)
end

return ZhuangBeiXiLian

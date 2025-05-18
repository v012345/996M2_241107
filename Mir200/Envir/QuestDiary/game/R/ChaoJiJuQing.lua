ChaoJiJuQing = {}
ChaoJiJuQing.ID = "��������"
local config = include("QuestDiary/cfgcsv/cfg_JuQingCategories.lua")          --����
local config2 = include("QuestDiary/cfgcsv/cfg_JuQing.lua")                   --����
local MainConditions = include("QuestDiary/game/R/GetJQMainConditions.lua")   --����
local ChildConditions = include("QuestDiary/game/R/GetJQChildConditions.lua") --����
local function allTrue(array)
    for i = 1, #array do
        local element = array[i]
        if type(element) == "table" then
            if #element == 2 then
                if element[1] < element[2] then
                    return false
                end
            else
                return false
            end
        elseif type(element) == "boolean" then
            if not element then
                return false
            end
        else
            return false
        end
    end
    return true
end
--��ȡ����1
function ChaoJiJuQing.Request1(actor, parentIndex, childIndex)
    local cfg = config[parentIndex]
    if not cfg then
        Player.sendmsgEx(actor, "��������#249")
        return
    end
    local flag = getplayvar(actor, "HUMAN", cfg.var)
    if flag == "1" or flag == 1 then
        Player.sendmsgEx(actor, "�Ѿ���ȡ����#249")
        return
    end
    local data = MainConditions[parentIndex](actor)
    if not data then
        Player.sendmsgEx(actor, "��������#249")
        return
    end
    local bool = allTrue(data)
    if not bool then
        Player.sendmsgEx(actor, "��û�����ȫ����������,�޷���ȡ#249")
        return
    end
    if not Bag.checkBagEmptyNum(actor, 5) then
        Player.sendmsgEx(actor, "��ı������Ӳ���,��������5���ո�!#249")
        stop(actor)
        return
    end
    FSetPlayVar(actor, cfg.var, 1, 1)
    Player.giveItemByTable(actor, cfg.reward, "���" .. cfg.name .. "����",1, true)
    local msgStr = getItemArrToStr(cfg.reward)
    Player.sendmsgEx(actor, string.format("[ϵͳ��ʾ]�� ��ȡ�ɹ���|[%s]#249", msgStr))
    Message.sendmsg(actor, ssrNetMsgCfg.ChaoJiJuQing_SyncLingQu1, 1)
end

--��ȡ����2
function ChaoJiJuQing.Request2(actor, parentIndex, childIndex)
    local cfg = config2[childIndex]
    if not cfg then
        Player.sendmsgEx(actor, "��������#249")
        return
    end
    local flag = getplayvar(actor, "HUMAN", cfg.var)
    if flag == "1" or flag == 1 then
        Player.sendmsgEx(actor, "�Ѿ���ȡ����#249")
        return
    end
    local data = ChildConditions[childIndex](actor)
    if not data then
        Player.sendmsgEx(actor, "��������#249")
        return
    end
    local bool = allTrue(data)
    if not bool then
        Player.sendmsgEx(actor, "��û����ɸþ�������,�޷���ȡ#249")
        return
    end
    if not Bag.checkBagEmptyNum(actor, 5) then
        Player.sendmsgEx(actor, "��ı������Ӳ���,��������5���ո�!#249")
        stop(actor)
        return
    end
    FSetPlayVar(actor, cfg.var, 1, 1)
    Player.giveItemByTable(actor, cfg.reward, "���" .. cfg.name .. "����",1, true)
    local msgStr = getItemArrToStr(cfg.reward)
    Player.sendmsgEx(actor, string.format("[ϵͳ��ʾ]�� ��ȡ�ɹ���|[%s]#249", msgStr))
    Message.sendmsg(actor, ssrNetMsgCfg.ChaoJiJuQing_SyncLingQu2, 1)
end

--�������˵�
function ChaoJiJuQing.Sync1(actor, parentIndex, arg1, arg2, data)
    if not parentIndex or type(parentIndex) ~= "number" then
        Player.sendmsgEx(actor, "��������1#249")
        return
    end
    local func = MainConditions[parentIndex]
    if not func then
        Player.sendmsgEx(actor, "��������2#249")
        return
    end
    local data = func(actor)
    if not data then
        Player.sendmsgEx(actor, "��������3#249")
        return
    end
    local cfg =  config[parentIndex]
    local flag = getplayvar(actor, "HUMAN", cfg.var)
    Message.sendmsg(actor, ssrNetMsgCfg.ChaoJiJuQing_Sync1, flag, 0, 0, data)
end

--�����Ӳ˵�
function ChaoJiJuQing.Sync2(actor, childIndex, arg2, arg2, data)
    if not childIndex or type(childIndex) ~= "number" then
        Player.sendmsgEx(actor, "��������#249")
        return
    end
    local data = ChildConditions[childIndex](actor)
    if not data then
        Player.sendmsgEx(actor, "��������#249")
        return
    end
    local cfg = config2[childIndex]
    local flag = getplayvar(actor, "HUMAN", cfg.var)
    Message.sendmsg(actor, ssrNetMsgCfg.ChaoJiJuQing_Sync2, flag, 0, 0, data)
end

--ͬ����Ϣ
-- function ChaoJiJuQing.SyncResponse(actor, logindatas)
--     local data = {}
--     local _login_data = {ssrNetMsgCfg.ChaoJiJuQing_SyncResponse, 0, 0, 0, data}
--     if logindatas then
--         table.insert(logindatas, _login_data)
--     else
--         Message.sendmsg(actor, ssrNetMsgCfg.ChaoJiJuQing_SyncResponse, 0, 0, 0, data)
--     end
-- end
-- --��¼����
-- local function _onLoginEnd(actor, logindatas)
--     ChaoJiJuQing.SyncResponse(actor, logindatas)
-- end
-- --�¼��ɷ�
-- GameEvent.add(EventCfg.onLoginEnd, _onLoginEnd, ChaoJiJuQing)
--ע��������Ϣ
--���˱�������
local function _goPlayerVar(actor)
    for _, value in ipairs(config) do
        FIniPlayVar(actor, value.var)
    end
    for _, value in ipairs(config2) do
        FIniPlayVar(actor, value.var)
    end
end
GameEvent.add(EventCfg.goPlayerVar, _goPlayerVar, ChaoJiJuQing)

Message.RegisterNetMsg(ssrNetMsgCfg.ChaoJiJuQing, ChaoJiJuQing)
return ChaoJiJuQing

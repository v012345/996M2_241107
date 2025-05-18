local DiaoYuDaShi = {}
DiaoYuDaShi.ID = "�����ʦ"
local npcID = 160
local config = include("QuestDiary/cfgcsv/cfg_DiaoYuDaShi.lua") --����
--����һ����λ
local cost = { { "Ԫ��", 2000000 } }
local give = { {} }
--��Ѵ���
local freeCount = 10
--�������
local buyCount = 30
function diao_yu_shou_huo(actor)
    if getplaydef(actor, "N$����״̬") == 1 then
        local fishingRodNum = getplaydef(actor, VarCfg["B_�������"]) + 1
        local weight1 = {}
        local weight2 = {}
        local weight3 = {}
        for index, value in ipairs(config) do
            if fishingRodNum > 0 then
                table.insert(weight1, string.format("%s#%s", index, value.weight1))
            end
            if fishingRodNum > 1 then
                table.insert(weight2, string.format("%s#%s", index, value.weight2))
            end
            if fishingRodNum > 2 then
                table.insert(weight3, string.format("%s#%s", index, value.weight3))
            end
        end
        local resultIndex1
        local resultIndex2
        local resultIndex3
        if #weight1 > 0 then
            resultIndex1 = ransjstr(table.concat(weight1, "|"), 1, 3)
        end
        if #weight2 > 0 then
            resultIndex2 = ransjstr(table.concat(weight2, "|"), 1, 3)
        end
        if #weight3 > 0 then
            resultIndex3 = ransjstr(table.concat(weight3, "|"), 1, 3)
        end
        local gives = {}
        if resultIndex1 then
            local cfg = config[tonumber(resultIndex1)]
            table.insert(gives, cfg.give[1])
        end
        if resultIndex2 then
            local cfg = config[tonumber(resultIndex2)]
            table.insert(gives, cfg.give[1])
        end
        if resultIndex3 then
            local cfg = config[tonumber(resultIndex3)]
            table.insert(gives, cfg.give[1])
        end
        -- dump(gives)
        --���͵�����������
        local uid = Player.GetUUID(actor)
        Player.giveMailByTable(uid, 1, "�����", "����ȡ���������", gives, 1, true)
        Player.sendmsgEx(actor, "������ѷ��͵�����")
        Message.sendmsg(actor, ssrNetMsgCfg.DiaoYuDaShi_ShouHuo, 0, 0, 0, gives)
        setplaydef(actor, "N$����״̬", 0)
        DiaoYuDaShi.SyncResponse(actor)
    end
end

--�������� ��ʼ����
function DiaoYuDaShi.Request(actor)
    if getplaydef(actor, "N$����״̬") == 1 then
        Player.sendmsgEx(actor, "���Ѿ��ڵ�����#249")
        return
    end
    --����Ĵ���
    local buyFishingNum = getplaydef(actor, VarCfg["B_����Ĵ���"])
    --���յ������
    local toDayFishingCount = getplaydef(actor, VarCfg["J_���յ������"])
    --ʣ����Ѵ���
    local _freeCount = freeCount - toDayFishingCount
    --ʣ���ܴ���
    local totalCount = _freeCount + buyFishingNum
    if totalCount <= 0 then
        Player.sendmsgEx(actor, "���Ѿ�û�д�����#249")
        return
    end
    if _freeCount > 0 then
        setplaydef(actor, VarCfg["J_���յ������"], toDayFishingCount + 1)
    else
        setplaydef(actor, VarCfg["B_����Ĵ���"], buyFishingNum - 1)
    end
    setplaydef(actor, VarCfg["J_���յ����ܴ���"], getplaydef(actor, VarCfg["J_���յ����ܴ���"]) + 1)
    DiaoYuDaShi.SyncResponse(actor)
    Message.sendmsg(actor, ssrNetMsgCfg.DiaoYuDaShi_StartFishing)
    setplaydef(actor, "N$����״̬", 1)
    delaygoto(actor, 6000, "diao_yu_shou_huo")
end

--����λ��
function DiaoYuDaShi.BuyPos(actor)
    local name, num = Player.checkItemNumByTable(actor, cost)
    if name then
        Player.sendmsgEx(actor, string.format("������ʧ�ܣ����|%s#249|����|%d#249", name, num))
        return
    end

    local fishingRodNum = getplaydef(actor, VarCfg["B_�������"])
    if fishingRodNum >= 2 then
        Player.sendmsgEx(actor, "���ֻ�����2�����#249")
        return
    end
    Player.takeItemByTable(actor, cost, "�������")
    setplaydef(actor, VarCfg["B_�������"], fishingRodNum + 1)
    Player.sendmsgEx(actor, "�����ͳɹ�")
    DiaoYuDaShi.SyncResponse(actor)
end

--����������
function DiaoYuDaShi.BuyCount(actor)
    if querymoney(actor, 7) < 100 then
        Player.sendmsgEx(actor, "���|�ǰ����#249|����|100#249")
        return
    end
    --���չ������
    local toDayBuyCount = getplaydef(actor, VarCfg["J_���յ��㹺�����"])
    if toDayBuyCount >= buyCount then
        Player.sendmsgEx(actor, "ÿ�����ֻ�ܹ���30��#249")
        return
    end
    local fishingNum = getplaydef(actor, VarCfg["B_����Ĵ���"])
    changemoney(actor, 7, "-", 100, "����������", true)
    setplaydef(actor, VarCfg["B_����Ĵ���"], fishingNum + 1)
    setplaydef(actor, VarCfg["J_���յ��㹺�����"], toDayBuyCount + 1)
    Player.sendmsgEx(actor, "�����������ɹ�")
    DiaoYuDaShi.SyncResponse(actor)
end

--ͬ����Ϣ
function DiaoYuDaShi.SyncResponse(actor, logindatas)
    local fishingNum = getplaydef(actor, VarCfg["J_���յ��㹺�����"])
    local data = {fishingNum}
    local fishingRodNum = getplaydef(actor, VarCfg["B_�������"])
    local toDayFishingCount = getplaydef(actor, VarCfg["J_���յ����ܴ���"])
    local buyFishingNum = getplaydef(actor, VarCfg["B_����Ĵ���"])
    local _login_data = { ssrNetMsgCfg.DiaoYuDaShi_SyncResponse, fishingRodNum, toDayFishingCount, buyFishingNum, data }
    if logindatas then
        table.insert(logindatas, _login_data)
    else
        Message.sendmsg(actor, ssrNetMsgCfg.DiaoYuDaShi_SyncResponse, fishingRodNum, toDayFishingCount, buyFishingNum,
            data)
    end
end

--��¼����
local function _onLoginEnd(actor, logindatas)
    DiaoYuDaShi.SyncResponse(actor, logindatas)
end
--�¼��ɷ�
GameEvent.add(EventCfg.onLoginEnd, _onLoginEnd, DiaoYuDaShi)
local function _onNewDay(actor)
    DiaoYuDaShi.SyncResponse(actor)
end
GameEvent.add(EventCfg.onNewDay, _onNewDay, DiaoYuDaShi)
--ע��������Ϣ
Message.RegisterNetMsg(ssrNetMsgCfg.DiaoYuDaShi, DiaoYuDaShi)
return DiaoYuDaShi


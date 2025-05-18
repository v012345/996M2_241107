local LongShenZhiLi = {}
local config = include("QuestDiary/cfgcsv/cfg_LongShenZhiLi.lua") --����

--ɾ��ȫ������֮���ƺ�
local function DeleteAllTitle(actor)
    for index, value in ipairs(config) do
        deprivetitle(actor, value.titleName)
    end
end

--�����ɹ�
local function UpgradeSuccess(actor, cfg, currLevel)
    DeleteAllTitle(actor)
    confertitle(actor, cfg.titleName)
    Player.sendmsgEx(actor, "��ϲ���ɹ�����[" .. cfg.titleName .. "]")
    setplaydef(actor, VarCfg["U_����֮���ȼ�"], currLevel + 1)
    if currLevel + 1 == 2 then
        local taskPanelID = getplaydef(actor, VarCfg["U_��������������"])
        if taskPanelID == 24 then
            FCheckTaskRedPoint(actor)
        end
    end
    if currLevel + 1 == 5 then
        local taskPanelID = getplaydef(actor, VarCfg["U_��������������"])
        if taskPanelID == 29 then
            FCheckTaskRedPoint(actor)
        end
    end
    GameEvent.push(EventCfg.onLongShenZhiLiUP, actor, currLevel + 1)
    setplaydef(actor, VarCfg["U_����֮����ǰ����"], 0)
    LongShenZhiLi.SyncResponse(actor)
end

--����ʧ��
local function UpgradeFailed(actor, currCount)
    Player.sendmsgEx(actor, "��Ǹ����ʧ����!#249")
    setplaydef(actor, VarCfg["U_����֮����ǰ����"], currCount + 1)
    LongShenZhiLi.SyncResponse(actor)
end

function LongShenZhiLi.Request(actor, arg1)
    local myLevel = getbaseinfo(actor, ConstCfg.gbase.level)
    if myLevel < 230 then
        Player.sendmsgEx(actor, "�㻹û�дﵽ230���أ��޷����м��޾��ѣ�#249")
        return
    end
    local longShenZhiLiLevel = getplaydef(actor, VarCfg["U_����֮���ȼ�"])
    if longShenZhiLiLevel > 8 then
        Player.sendmsgEx(actor, "�������֮��������!")
        return
    end
    if arg1 ~= 1 and arg1 ~= 2 then
        Player.sendmsgEx(actor, "��������!")
        return
    end
    local cfg = config[longShenZhiLiLevel + 1]
    local cost = {}
    local probability = {}
    if arg1 == 1 then
        cost = cfg.YBcost
        probability = cfg.YBprobability
    elseif arg1 == 2 then
        cost = cfg.LFcost
        probability = cfg.LFprobability
    end
    if #cost == 0 then
        Player.sendmsgEx(actor, "��������!")
        return
    end
    local name, num = Player.checkItemNumByTable(actor, cost)
    if name then
        Player.sendmsgEx(actor, string.format("���|%s#249|����|%d#249", name, num))
        return
    end
    local currCount = getplaydef(actor, VarCfg["U_����֮����ǰ����"])
    Player.takeItemByTable(actor, cost, "����֮��")
    local baoDi, random = probability[1], probability[2]
    if currCount >= baoDi and currCount < 10 then
        if randomex(random) then
            UpgradeSuccess(actor, cfg, longShenZhiLiLevel)
        else
            UpgradeFailed(actor, currCount)
        end
    elseif currCount >= 10 then
        UpgradeSuccess(actor, cfg, longShenZhiLiLevel)
    else
        UpgradeFailed(actor, currCount)
    end
end

--ͬ������
function LongShenZhiLi.SyncResponse(actor, logindatas)
    local data = {}
    local longShenZhiLiLevel = getplaydef(actor, VarCfg["U_����֮���ȼ�"])
    local currCount = getplaydef(actor, VarCfg["U_����֮����ǰ����"])
    local _login_data = { ssrNetMsgCfg.LongShenZhiLi_SyncResponse, longShenZhiLiLevel, currCount, 0, data }
    if logindatas then
        table.insert(logindatas, _login_data)
    else
        Message.sendmsg(actor, ssrNetMsgCfg.LongShenZhiLi_SyncResponse, longShenZhiLiLevel, currCount, 0, data)
    end
end

Message.RegisterNetMsg(ssrNetMsgCfg.LongShenZhiLi, LongShenZhiLi)

--��¼����
local function _onLoginEnd(actor, logindatas)
    LongShenZhiLi.SyncResponse(actor, logindatas)
end
--�¼��ɷ�
GameEvent.add(EventCfg.onLoginEnd, _onLoginEnd, LongShenZhiLi)
--��������ǰ���� --  նɱ����Ѫ
local function _onAttackDamageMonster(actor, Target, Hiter, MagicId, Damage, Model, attackDamageData)
    local longShenZhiLiLevel = getplaydef(actor, VarCfg["U_����֮���ȼ�"])
    if longShenZhiLiLevel > 0 then
        if longShenZhiLiLevel >= 9 then
            longShenZhiLiLevel = 9
        end
        local zhanXue = config[longShenZhiLiLevel].zhanXue
        if zhanXue then
            local purHp = Player.getHpPercentage(Target)
            if purHp == 100 then
                local subHp = math.floor(Player.getHpValue(Target, zhanXue))
                humanhp(Target, "-", subHp, 106, 0, actor)
            end
        end
    end
end
GameEvent.add(EventCfg.onAttackDamageMonster, _onAttackDamageMonster, LongShenZhiLi)
return LongShenZhiLi

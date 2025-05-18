local GuaXiangZhanBu = {}
local config = { "�������", "ͨ������", "�������", "�����ƿ�", "������ʦ" }
local cost = { { "���", 100 } }
local function DeleteAllTitle(actor)
    for index, value in ipairs(config) do
        deprivetitle(actor, value)
    end
end

function GuaXiangZhanBu.Request(actor)
    -- deprivetitle(actor, "������ʦ")
    if checktitle(actor, "������ʦ") then
        Player.sendmsgEx(actor, "���Ѿ�ӵ����ߵȼ���[������ʦ]�ƺ�,�޷�����ռ��!#249")
        return
    end
    local buGuaCount = getplaydef(actor, VarCfg["U_ռ������"])
    local weight = ""
    --20�����²���5
    if buGuaCount < 20 then
        weight = "1#30|2#30|3#20|4#15"
    else
        weight = "1#30|2#30|3#20|4#20|5#5"
    end
    local randomNum = ransjstr(weight, 1, 3)
    randomNum = tonumber(randomNum)
    if buGuaCount >= 65 then
        randomNum = 5
    end
    local cfg = config[randomNum]
    if not cfg then
        Player.sendmsgEx(actor, "��������!#249")
        return
    end
    local name, num = Player.checkItemNumByTable(actor, cost)
    if name then
        Player.sendmsgEx(actor, string.format("���|%s#249|����|%d#249", name, num))
        return
    end
    Player.takeItemByTable(actor, cost, "ռ��")
    DeleteAllTitle(actor)
    local titileName = cfg
    confertitle(actor, titileName)
    Player.setAttList(actor, "���Ը���")
    Player.setAttList(actor, "���ʸ���")
    Player.setAttList(actor, "���ٸ���")
    setplaydef(actor, VarCfg["U_ռ������"], buGuaCount + 1)
    Player.sendmsgEx(actor, string.format("������|%s#249", titileName))

    GuaXiangZhanBu.SyncResponse(actor)
end

--ͬ����Ϣ
function GuaXiangZhanBu.SyncResponse(actor, logindatas)
    local buGuaCount = getplaydef(actor, VarCfg["U_ռ������"])
    local _login_data = { ssrNetMsgCfg.GuaXiangZhanBu_SyncResponse, buGuaCount, 0, 0, {} }
    if logindatas then
        table.insert(logindatas, _login_data)
    else
        Message.sendmsg(actor, ssrNetMsgCfg.GuaXiangZhanBu_SyncResponse, buGuaCount, 0, 0, {})
    end
end

local function _onCalcAttackSpeed(actor, attackSpeeds)
    if checktitle(actor, "�����ƿ�") then
        attackSpeeds[1] = attackSpeeds[1] + 25
    elseif checktitle(actor, "������ʦ") then
        attackSpeeds[1] = attackSpeeds[1] + 50
    end
end

GameEvent.add(EventCfg.onCalcAttackSpeed, _onCalcAttackSpeed, GuaXiangZhanBu)


local function _onLoginEnd(actor, logindatas)
    GuaXiangZhanBu.SyncResponse(actor, logindatas)
end
--�¼��ɷ�
GameEvent.add(EventCfg.onLoginEnd, _onLoginEnd, GuaXiangZhanBu)


-- VarCfg["F_����_ף��֮���ʶ"]
local function _onCalcAttr(actor, attrs)
    if getflagstatus(actor, VarCfg["F_����_ף��֮���ʶ"]) == 1 then
        local shuxing = {}
        local buGuaCount = getplaydef(actor, VarCfg["U_ռ������"])
        if buGuaCount > 0 then
            if buGuaCount > 10 then
                buGuaCount = 10
            end
            local addtion = buGuaCount * 20
            shuxing[3] = addtion
            shuxing[4] = addtion
            shuxing[5] = addtion
            shuxing[6] = addtion
            shuxing[7] = addtion
            shuxing[8] = addtion
            calcAtts(attrs, shuxing, "ռ��ף��֮��")
        end
    end
end

--����
GameEvent.add(EventCfg.onCalcAttr, _onCalcAttr, GuaXiangZhanBu)

--ע��
Message.RegisterNetMsg(ssrNetMsgCfg.GuaXiangZhanBu, GuaXiangZhanBu)
return GuaXiangZhanBu

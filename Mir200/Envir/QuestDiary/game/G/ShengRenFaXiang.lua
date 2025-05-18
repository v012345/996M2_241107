local ShengRenFaXiang = {}
ShengRenFaXiang.ID = "ʥ�˷���"
local cost = { { "Ԫ��", 8880000 } }

local buffFlagMaps = {
    [31095] = VarCfg["F_��֮����"],
    [31096] = VarCfg["F_��֮����"],
    [31097] = VarCfg["F_ˮ֮����"],
    [31098] = VarCfg["F_��֮����"],
}

--��ȡ����״̬
function getFlagVar(actor)
    local Bool1 = getflagstatus(actor, VarCfg["F_��϶�ٻ�ɱ��ʶ"])
    local Bool2 = getflagstatus(actor, VarCfg["F_����ٻ�ɱ��ʶ"])
    local Bool3 = getflagstatus(actor, VarCfg["F_ˮ���ٻ�ɱ��ʶ"])
    local Bool4 = getflagstatus(actor, VarCfg["F_�����ٻ�ɱ��ʶ"])
    local data = { Bool1, Bool2, Bool3, Bool4 }
    return data
end

--��������
function ShengRenFaXiang.Request(actor)
    if not checktitle(actor, "�ɷ��б�") then
        Player.sendmsgEx(actor, "��ʾ#251|:#255|�㻹δ����|�ɷ��б�#249|�ƺ�,����ʧ��...")
        return
    end

    if checktitle(actor, "ʥ��֮��") then
        Player.sendmsgEx(actor, "��ʾ#251|:#255|���Ѽ���|ʥ��֮��#249|�ƺ�,�����ظ�����...")
        return
    end

    local data = getFlagVar(actor)
    local FuBenName = { "��϶��", "�����", "ˮ����", "������" }
    for k, v in ipairs(data) do
        if v == 0 then
            Player.sendmsgEx(actor, "��ʾ#251|:#255|�㻹δͨ��|" .. FuBenName[k] .. "#249|����,����ʧ��...")
            return
        end
    end

    local name, num = Player.checkItemNumByTable(actor, cost)
    if name then
        Player.sendmsgEx(actor, string.format("��ʾ#251|:#255|���|%s#249|����|%d#249|ö,����ʧ��...", name, num))
        return
    end
    Player.takeItemByTable(actor, cost, "�������ؿ۳�")

    --�������ƺ�
    confertitle(actor, "ʥ��֮��", 1)
    setflagstatus(actor, VarCfg["F_ʥ��֮��"], 1)
    -- Player.setAttList(actor, "���ٸ���")
    Player.setAttList(actor, "���Ը���")
    giveitem(actor, "�Ʒ�����ئ�", 1, ConstCfg.binding, "������ؼ���")
end

-- ͬ����Ϣ
function ShengRenFaXiang.SyncResponse(actor, logindatas)
    local data = getFlagVar(actor)
    local _login_data = { ssrNetMsgCfg.ShengRenFaXiang_SyncResponse, 0, 0, 0, data }
    if type(logindatas) == "table" then
        table.insert(logindatas, _login_data)
    else
        Message.sendmsg(actor, ssrNetMsgCfg.ShengRenFaXiang_SyncResponse, 0, 0, 0, data)
    end
end

Message.RegisterNetMsg(ssrNetMsgCfg.ShengRenFaXiang, ShengRenFaXiang)

local function _onCalcAttackSpeed(actor, attackSpeeds)
    if checktitle(actor, "ʥ��֮��") then
        attackSpeeds[1] = attackSpeeds[1] + 30
    end
end
--��������
GameEvent.add(EventCfg.onCalcAttackSpeed, _onCalcAttackSpeed, ShengRenFaXiang)

--��������ǰ����  �����ɵȼ����Լ��͵��������15%�˺�
local function _onAttackDamagePlayer(actor, Target, Hiter, MagicId, Damage, Model, attackDamageData)
    if not getflagstatus(actor, VarCfg["F_ʥ��֮��"]) == 0 then return end
    local MyLevelx = getplaydef(actor, VarCfg["U_���ɵȼ�"])
    local TgtLevelx = getplaydef(Target, VarCfg["U_���ɵȼ�"])
    if MyLevelx > TgtLevelx then
        attackDamageData.damage = attackDamageData.damage + (Damage * 0.15)
    end

    -- [ҵ�����]��������5%�����ͷ�ҵ�����������Χ3X3��Χ��������10%��������˺���������Ŀ��5�룬ÿ����ʧ2%�������ֵ�� CD:8S
    if getflagstatus(actor, buffFlagMaps[31096]) == 1 then
        if randomex(100, 100) then
            if Player.checkCd(actor, VarCfg["ҵ�����CD"], 8, true) then
                playeffect(actor, 63121, 0, 0, 1, 1, 0)  --��Ч
                local MapID = Player.MapKey(actor)
                if checkkuafu(actor) then
                    MapID = Player.GetVarMap(actor)
                end
                local x, y = Player.GetX(actor), Player.GetY(actor)
                local playList = getobjectinmap(MapID, x, y, 3, 1)                --����������Χ3���ڵ����
                for _, play in ipairs(playList) do
                    if actor ~= play then --�ų��Լ�
                        humanhp(play, "-", Player.getHpValue(play, 10), 1)
                        humanhp(play, "-", Player.getHpValue(play, 2), 112, 0, actor) --����
                        humanhp(play, "-", Player.getHpValue(play, 2), 112, 1, actor) --����
                        humanhp(play, "-", Player.getHpValue(play, 2), 112, 2, actor) --����
                        humanhp(play, "-", Player.getHpValue(play, 2), 112, 4, actor) --����
                    end
                end
            end
        end
    end
end
GameEvent.add(EventCfg.onAttackDamagePlayer, _onAttackDamagePlayer, ShengRenFaXiang)

local function _onJuFengZhiYanKF(actor)
    local acMax = getbaseinfo(actor, 51, 213)
    if acMax > 20 then
        changehumnewvalue(actor, 213, -20, 3)
    else
        changehumnewvalue(actor, 213, -acMax, 3)
    end
end
GameEvent.add(EventCfg.onJuFengZhiYanKF, _onJuFengZhiYanKF, ShengRenFaXiang)

--�������󴥷�
local function _onStruckPlayer(actor, Target, Hiter, MagicId)
    -- [쫷�֮��]���ܵ����﹥����10%�ĸ��ʻ����ܱ�����Ŀ�꣬������Ŀ��20%����������3S. CD:8S
    if getflagstatus(actor, buffFlagMaps[31095]) == 1 then
        if randomex(1, 10) then
            if Player.checkCd(actor, VarCfg["쫷�֮��CD"], 8, true) then --�鿴����buff
                local MapID = Player.MapKey(actor)
                if checkkuafu(actor) then
                    MapID = Player.GetVarMap(actor)
                end
                local x, y = Player.GetX(actor), Player.GetY(actor)
                rangeharm(actor, x, y, 3, 0, 1, 1, 0, 0)           --���˶���1��
                local playList = getobjectinmap(MapID, x, y, 3, 1) --����������Χ3���ڵ����
                for _, play in ipairs(playList) do
                    if actor ~= play then
                        if checkkuafu(actor) then
                            FKuaFuToBenFuEvent(play, EventCfg.onJuFengZhiYanKF)
                        else
                            _onJuFengZhiYanKF(play)
                        end
                    end
                end
            end
        end
    end
end
GameEvent.add(EventCfg.onStruckPlayer, _onStruckPlayer, ShengRenFaXiang)

local function _onShanYueBiLeiKF(actor)
    changehumnewvalue(actor, 63, 2000, 5) --�񵲸���
end
GameEvent.add(EventCfg.onShanYueBiLeiKF, _onShanYueBiLeiKF, ShengRenFaXiang)
-- ʹ��ʮ��һɱ  [ɽ������]���ͷ�ʮ��һɱ���޵�1�룬�񵲸���+20%������5S.
local function UseSkill_shi_bu_yi_sha(actor, Target)
    if getflagstatus(actor, buffFlagMaps[31098]) == 1 then
        -- changemode(actor, 1, 1)                 --�޵�1��
        addbuff(actor, 31101, 1) --�޵�1��
        if checkkuafu(actor) then
            FKuaFuToBenFuEvent(actor, EventCfg.onShanYueBiLeiKF)
        else
            _onShanYueBiLeiKF(actor)
        end
    end
end
GameEvent.add(EventCfg["ʹ��ʮ��һɱ"], UseSkill_shi_bu_yi_sha, ShengRenFaXiang)

-- --���ٸ���
-- local function _onCalcAttackSpeed(actor, attackSpeeds)
--     if checktitle(actor,"ʥ��֮��") then
--         attackSpeeds[1] = attackSpeeds[1] + 30
--     end

--     if hasbuff(actor,31095) then
--         attackSpeeds[1] = attackSpeeds[1] + 10
--     end
-- end
-- GameEvent.add(EventCfg.onCalcAttackSpeed, _onCalcAttackSpeed, ShengRenFaXiang)

function fa_xiang_gong_su(actor)
    Player.setAttList(actor, "���ٸ���")
end

--ʥ��֮��  buff 120��CD  ����20��
function buff_sheng_ren_zhi_zi(actor, buffId, buffGroup)
    local BuffIdx = math.random(31095, 31098)
    local flag = buffFlagMaps[BuffIdx]
    if flag then
        setflagstatus(actor, flag, 1) --���ñ�ʶ
    end
    -- ��֮���� 31095 �����ٶ�+10%,���ӷ���+10%
    if BuffIdx == 31095 then
        addbuff(actor, BuffIdx, 20, 1, actor) --��ӷ���buff
        setfeature(actor, 2, 10000, 20, 1, 0) --��ӷ�����
        delaygoto(actor,1000,"fa_xiang_gong_su")
    end

    -- ��֮���� 31096 �����˺�+10%,��������+10%
    if BuffIdx == 31096 then
        addbuff(actor, BuffIdx, 20, 1, actor) --��ӷ���buff
        setfeature(actor, 2, 10001, 20, 1, 0) --��ӷ�����
    end

    -- ˮ֮���� 31097 ��������+10%,ħ������+10%
    if BuffIdx == 31097 then
        addbuff(actor, BuffIdx, 20, 1, actor)                --��ӷ���buff
        setfeature(actor, 2, 10002, 20, 1, 0)                --��ӷ�����
        -- [ˮĻ�컪]�����������ͷ�ˮĻ�컪�������������и���״̬�����ָ�����30%�������ֵ��
        humanhp(actor, "+", Player.getHpValue(actor, 30), 4) --�ָ�30%����
        changehumnewvalue(actor, 51, 10000, 5)               --��ֹ����
        changehumnewvalue(actor, 52, 10000, 5)               --��ֹ����
        changehumnewvalue(actor, 45, 10000, 5)               --��ֹ���
        changehumnewvalue(actor, 48, 10000, 5)               --��ֹȫ��
        playeffect(actor, 63138, 0, 0, 1, 1, 0)
    end

    -- ��֮���� 31098 �˺�����+10%,�����ӳ�+10%
    if BuffIdx == 31098 then
        addbuff(actor, BuffIdx, 20, 1, actor) --��ӷ���buff
        setfeature(actor, 2, 10003, 20, 1, 0) --��ӷ�����
    end
end

--��Ԫ����
function buff_hun_yuan_fa_xiang(actor, buffId, buffGroup)
    addbuff(actor, 31104, 20, 1, actor) --��ӻ�Ԫ����buff
    setfeature(actor, 2, 10005, 20, 1, 0) --��ӷ�����
    delaygoto(actor,1000,"fa_xiang_gong_su")
end
-- --buff����
local function _onBuffChange(actor, buffid, groupid, model)
    if model == 4 then
        --��֮���� ɾ����buff�� ˢ�¹���
        if buffid == 31095 then
            delaygoto(actor,1000,"fa_xiang_gong_su")
        end
        local flag = buffFlagMaps[buffid]
        if flag then
            setflagstatus(actor, flag, 0)
        end
    end
end
GameEvent.add(EventCfg.onBuffChange, _onBuffChange, ShengRenFaXiang)


--��¼����
local function _onLoginEnd(actor, logindatas)
    if checkitemw(actor, "���}������ئ�", 1) then
        for key, value in pairs(buffFlagMaps) do
            setflagstatus(actor, value, 1)
        end
    else
        for key, value in pairs(buffFlagMaps) do
            setflagstatus(actor, value, 0)
        end
    end
    ShengRenFaXiang.SyncResponse(actor, logindatas)
end
GameEvent.add(EventCfg.onLoginEnd, _onLoginEnd, ShengRenFaXiang)

--��װ��
local function _onTakeOn21(actor, itemobj)
    local itemname = getiteminfo(actor, itemobj, 7)
    if itemname == "�Ʒ�����ئ�" then
        addbuff(actor,31094)
        Player.setAttList(actor, "���ٸ���")
    elseif itemname == "���}������ئ�" then
        for key, value in pairs(buffFlagMaps) do
            setflagstatus(actor, value, 1)
        end
        addbuff(actor,31103)
        Player.setAttList(actor, "���ٸ���")
    end
end
GameEvent.add(EventCfg.onTakeOn21, _onTakeOn21, ShengRenFaXiang)

--��װ��
local function _onTakeOff21(actor, itemobj)
    local itemname = getiteminfo(actor, itemobj, 7)
    if itemname == "�Ʒ�����ئ�" then
        --ɾ��һ��buff
        delbuff(actor,31094)
        for key, value in pairs(buffFlagMaps) do
            delbuff(actor,key)
        end
        Player.setAttList(actor, "���ٸ���")
    elseif itemname == "���}������ئ�" then
        for key, value in pairs(buffFlagMaps) do
            setflagstatus(actor, value, 0)
        end
        delbuff(actor, 31103)
        delbuff(actor, 31104)
        Player.setAttList(actor, "���ٸ���")
    end
end
GameEvent.add(EventCfg.onTakeOff21, _onTakeOff21, ShengRenFaXiang)

return ShengRenFaXiang

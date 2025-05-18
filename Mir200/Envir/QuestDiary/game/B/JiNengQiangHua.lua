local JiNengQiangHua = {}
local config = include("QuestDiary/cfgcsv/cfg_JiNengQiangHua.lua")
local maxLeve = 9

local function setSkillEff(actor)
    for key, value in pairs(config) do
        local levelUp = getskillinfo(actor, key, 2)
        if levelUp then
            if levelUp > 9 then
                setmagicskillefft(actor, value.skillName, value.effid)
            end
        end
    end
end

function JiNengQiangHua.Request(actor, skillId)
    local cfg = config[skillId]
    if not cfg then
        Player.sendmsgEx(actor, "[��ʾ]:#251|������Ϣ1,û�ҵ���Ӧ����#249")
        return
    end
    local levelUp = getskillinfo(actor, skillId, 2)
    if not levelUp then
        Player.sendmsgEx(actor, "[��ʾ]:#251|��û��ѧϰ�������!#249")
        return
    end
    if levelUp >= 10 then
        Player.sendmsgEx(actor, string.format("[��ʾ]:#251|���#250|%s#249|�Ѿ�������!#250", cfg.skillName))
        return
    end
    local name, num = Player.checkItemNumByTable(actor, cfg.cost)
    if name then
        Player.sendmsgEx(actor, string.format("[��ʾ]:#251|���#250|%s#249|����#251|%s#249|ǿ��ʧ��!#250", name, num))
        return
    end
    Player.takeItemByTable(actor, cfg.cost, "����ǿ��")
    local num = getplaydef(actor, VarCfg["U_����ǿ���ܴ���"])
    setplaydef(actor, VarCfg["U_����ǿ���ܴ���"], num + 1)
    if num + 1 == 3 then
        local taskPanelID = getplaydef(actor, VarCfg["U_��������������"])
        if taskPanelID == 11 then
            FCheckTaskRedPoint(actor)
        end
    end
    setskillinfo(actor, skillId, 2, levelUp + 1)
    setplaydef(actor, cfg.var, levelUp + 1)
    Player.sendmsgEx(actor, string.format("[��ʾ]:#251|���#250|%s#249|ǿ���ɹ�!#250", cfg.skillName))
    setSkillEff(actor)
    GameEvent.push(EventCfg.onIntensifySkill, actor, cfg.skillName, levelUp + 1)
end

--------------�¼��ɷ�-------------
--��¼����
local function _onLoginEnd(actor, logindatas)
    setSkillEff(actor)
end
--����ǰ����
local function _onAttackDamage(actor, Target, Hiter, MagicId, Damage, Model, attackDamageData)
    if MagicId == 12 then
        local levelUp = getskillinfo(actor, MagicId, 2)
        --��ɱ������5%�ļ���ʱĿ���ܵ����˺�����
        if levelUp > 9 then
            if randomex(5) then
                attackDamageData.damage = attackDamageData.damage + Damage
            end
        end
    end
end

--��������
local function _onAttack(actor, Target, Hiter, MagicId)
    if MagicId == 7 then
        local levelUp = getskillinfo(actor, MagicId, 2)
        --��ɱ�������⸽������������35%����ʵ�˺�
        if levelUp > 9 then
            local attackLimit = getbaseinfo(actor, ConstCfg.gbase.custom_attr, 4)
            local damege = calculatePercentageResult(attackLimit, 35)
            humanhp(Target, "-", damege, 1, 0, actor)
        end
    elseif MagicId == 26 then
        local levelUp = getskillinfo(actor, MagicId, 2)
        --�һ𽣷���ȼ�����е�Ŀ��3�룬û����ٵ�ͬ���ͷ��߹�������20%������
        if levelUp > 9 then
            local attackLimit = getbaseinfo(actor, ConstCfg.gbase.custom_attr, 4)
            local damege = calculatePercentageResult(attackLimit, 20)
            humanhp(Target, "-", damege, 1, 1, actor)
            humanhp(Target, "-", damege, 1, 2, actor)
            humanhp(Target, "-", damege, 1, 3, actor)
        end
    elseif MagicId == 66 then
        if getbaseinfo(Target, -1) == true then
            local levelUp = getskillinfo(actor, MagicId, 2)
        --����ն����Ŀ���ʹĿ��5���ڽ���20%�ķ���
            if levelUp > 9 then
                local fangYu1       = getbaseinfo(actor, ConstCfg.gbase.custom_attr, 9)
                local fangYu2       = getbaseinfo(actor, ConstCfg.gbase.custom_attr, 10)
                local changeFangYu1 = calculatePercentageResult(fangYu1, 20)
                local changeFangYu2 = calculatePercentageResult(fangYu2, 20)
                changehumability(Target, 1, -changeFangYu1, 5)
                changehumability(Target, 2, -changeFangYu2, 5)
            end
        end
    elseif MagicId == 56 then
        local levelUp = getskillinfo(actor, MagicId, 2)
        --���ս������е�Ŀ��Ϊ���ʱ����35%�ļ���ʹ�������ٵ�ǰHP10%������
        if levelUp > 9 then
            if randomex(35) then
                local currentHP = getbaseinfo(Target, ConstCfg.gbase.curhp)
                local damage = calculatePercentageResult(currentHP, 10)
                humanhp(Target, "-", damage, 1, 0 , actor)
            end
        end
    end
end

--��¼
GameEvent.add(EventCfg.onLoginEnd, _onLoginEnd, JiNengQiangHua)
--�����½
GameEvent.add(EventCfg.onKFLogin, _onLoginEnd, JiNengQiangHua)

--����������
GameEvent.add(EventCfg.onAttackDamage, _onAttackDamage, JiNengQiangHua)

--��������
GameEvent.add(EventCfg.onAttack, _onAttack, JiNengQiangHua)

--------------������Ϣ-------------
function JiNengQiangHua.SyncResponse(actor)
    Message.sendmsg(actor, ssrNetMsgCfg.JiNengQiangHua_SyncResponse)
end

--ע��������Ϣ
Message.RegisterNetMsg(ssrNetMsgCfg.JiNengQiangHua, JiNengQiangHua)

return JiNengQiangHua

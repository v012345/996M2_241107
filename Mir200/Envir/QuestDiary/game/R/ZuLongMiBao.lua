local ZuLongMiBao = {}
ZuLongMiBao.ID = "�����ر�"
local npcID = 328
--local config = include("QuestDiary/cfgcsv/cfg_ZuLongMiBao.lua") --����
local cost = { { "��֮����", 88 }, { "Ԫ��", 3000000 } }
local give = { { "[����]����̖��", 1 } }
--��������
function ZuLongMiBao.Request(actor)
    if not FCheckNPCRange(actor, npcID, 15) then
        Player.sendmsgEx(actor, "����PNC̫Զ!#249")
        return
    end
    local name, num = Player.checkItemNumByTable(actor, cost)
    if name then
        Player.sendmsgEx(actor, string.format("���|%s#249|����|%d#249", name, num))
        return
    end
    Player.takeItemByTable(actor, cost, "�����ر�����")
    Player.giveItemByTable(actor, give, "�����ر�����")
    setflagstatus(actor,VarCfg["F_[����]����̖��_���"],1)
    Player.sendmsgEx(actor, "��ɹ�������|[����]����̖��#249|")
end

--ͬ����Ϣ
-- function ZuLongMiBao.SyncResponse(actor, logindatas)
--     local data = {}
--     local _login_data = {ssrNetMsgCfg.ZuLongMiBao_SyncResponse, 0, 0, 0, data}
--     if logindatas then
--         table.insert(logindatas, _login_data)
--     else
--         Message.sendmsg(actor, ssrNetMsgCfg.ZuLongMiBao_SyncResponse, 0, 0, 0, data)
--     end
-- end
-- --��¼����
-- local function _onLoginEnd(actor, logindatas)
--     ZuLongMiBao.SyncResponse(actor, logindatas)
-- end
-- --�¼��ɷ�
-- GameEvent.add(EventCfg.onLoginEnd, _onLoginEnd, ZuLongMiBao)
--ע��������Ϣ

-- [����]����̖��

--��������
local function _onAttack(actor, Target, Hiter, MagicId)
    if not checkitemw(actor, "[����]����̖��", 1) then
        return
    end
    --��������
    if getbaseinfo(Target, -1) == false then
        if Player.canLifesteal(actor) then
            local perHp = Player.getHpValue(actor, 1)
            humanhp(actor, "+", perHp, 4)
        end
        --������
    else
        local perHp = Player.getHpValue(Target, 1)
        humanhp(Target, "-", perHp, 1, 0, actor)
    end
    if randomex(5,1000) then
        recallmob(actor,"��֮�ػ�",1,1)
    end
end
GameEvent.add(EventCfg.onAttack, _onAttack, ZuLongMiBao)
local function _onKillMon(actor, monobj, monName)
    local num = getplaydef(actor, VarCfg["U_��֮�ػ���ɱ_����"])
    if num < 10 then
        local name = monName
        if name == "��֮�ػ�" then
            setplaydef(actor, VarCfg["U_��֮�ػ���ɱ_����"],num+1)
        end
    end
end

GameEvent.add(EventCfg.onKillMon, _onKillMon, ZuLongMiBao)
Message.RegisterNetMsg(ssrNetMsgCfg.ZuLongMiBao, ZuLongMiBao)
return ZuLongMiBao

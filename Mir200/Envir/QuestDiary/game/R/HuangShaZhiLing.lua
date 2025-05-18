local HuangShaZhiLing = {}
HuangShaZhiLing.ID = "��ɳ֮��"
local npcID = 322
--local config = include("QuestDiary/cfgcsv/cfg_HuangShaZhiLing.lua") --����
local cost = { { "����ɳ��", 10 }, { "�칤֮��", 1888 } }
local give = { { "[�L��]�Sɳ֮�`", 1 } }
--��������
function HuangShaZhiLing.Request(actor)
    if not FCheckNPCRange(actor, npcID, 15) then
        Player.sendmsgEx(actor, "����PNC̫Զ!#249")
        return
    end
    local name, num = Player.checkItemNumByTable(actor, cost)
    if name then
        Player.sendmsgEx(actor, string.format("����ʧ��,���|%s#249|����|%d#249", name, num))
        return
    end
    if not Bag.checkBagEmptyNum(actor, 5) then
        Player.sendmsgEx(actor, "��ı������Ӳ���,��������5���ո�!#249")
        stop(actor)
    end
    Player.takeItemByTable(actor, cost, "��ɳ֮��")
    Player.giveItemByTable(actor, give, "��ɳ֮��", 1, true)
    FSetTaskRedPoint(actor, VarCfg["F_��ɳ֮��_���"], 22)
    Player.sendmsgEx(actor, "��ʾ��#251|��ɹ�������|[�L��]�Sɳ֮�`#249")
    HuangShaZhiLing.SyncResponse(actor)
end

--ͬ����Ϣ
function HuangShaZhiLing.SyncResponse(actor)
    local data = {}
    Message.sendmsg(actor, ssrNetMsgCfg.HuangShaZhiLing_SyncResponse, 0, 0, 0, data)
end

-- --��¼����
-- local function _onLoginEnd(actor, logindatas)
--     HuangShaZhiLing.SyncResponse(actor, logindatas)
-- end
-- --�¼��ɷ�
-- GameEvent.add(EventCfg.onLoginEnd, _onLoginEnd, HuangShaZhiLing)
--ɱ�ִ���
local function _onKillMon(actor, monobj, monName)
    if monName == "Թ��֮��" then
        if randomex(10) then
            local mapID = getbaseinfo(actor, ConstCfg.gbase.mapid)
            local x, y = getbaseinfo(monobj, ConstCfg.gbase.x), getbaseinfo(monobj, ConstCfg.gbase.y)
            genmon(mapID, x, y, "��ɳ֮��", 0, 1, 249)
            Player.sendmsgEx(actor, "��ɱ����|Թ��֮��#255|���ٻ���|��ɳ֮��#249")
        end
    end
end
GameEvent.add(EventCfg.onKillMon, _onKillMon, HuangShaZhiLing)
--�������ﴥ��
local function _onAttackMonster(actor, Target, Hiter, MagicId, qieGe)
    if randomex(5) then
        if checkitemw(actor, "[�L��]�Sɳ֮�`", 1) or checkitemw(actor, "쫷�֮��", 1) then
            local attackNum = getbaseinfo(actor, ConstCfg.gbase.custom_attr, 4)
            local damage = math.floor(attackNum * 1.2)
            local cfg_posM = {}
            cfg_posM[1] = getbaseinfo(Target, 2)
            local mapID = getbaseinfo(actor, 3)
            local x = getbaseinfo(actor, 4)
            local y = getbaseinfo(actor, 5)
            local mons = getobjectinmap(mapID, x, y, 3, 2)
            if #mons < 1 then return end
            for i, mon in ipairs(mons or {}) do
                if i >= 10 then
                    break
                end
                if Target ~= mon then
                    cfg_posM[#cfg_posM + 1] = getbaseinfo(mon, 2)
                    local mobName = getbaseinfo(mon, ConstCfg.gbase.name)
                    local race = getdbmonfieldvalue(mobName, "race")
                    if race ~= 250 then
                        humanhp(mon, "-", damage, 1, 0.3 * i, actor)
                    end
                end
            end
            Message.sendmsg(actor, ssrNetMsgCfg.HuangShaZhiLing_ScenePlayEffectEx, 0, 0, 0, cfg_posM)
        end
    end
end
GameEvent.add(EventCfg.onAttackMonster, _onAttackMonster, HuangShaZhiLing)
--ע��������Ϣ
Message.RegisterNetMsg(ssrNetMsgCfg.HuangShaZhiLing, HuangShaZhiLing)
return HuangShaZhiLing

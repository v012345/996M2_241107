local FoFaWuBian = {}
FoFaWuBian.ID = "���ޱ�"
local npcID = 506
--local config = include("QuestDiary/cfgcsv/cfg_FoFaWuBian.lua") --����
local cost = { { "�컯�ᾧ", 88 }, { "��ҳ", 2222 } }
local give = { {} }
local skillID1 = 2017
local skillID2 = 2019
--��������
function FoFaWuBian.Request(actor)
    if not FCheckNPCRange(actor, npcID, 15) then
        Player.sendmsgEx(actor, "����PNC̫Զ!#249")
        return
    end
    if getskillinfo(actor, skillID2, 1) then
        Player.sendmsgEx(actor, "���Ѿ�ѧϰ�˴�����������#249")
        return
    end
    if not getskillinfo(actor, skillID1, 1) then
        Player.sendmsgEx(actor, "��û��ѧϰ|��������#249|�޷�ѧϰ|������������#249|,�������ƿ���|�����¼�#249|ѧϰ")
        return
    end
    local name, num = Player.checkItemNumByTable(actor, cost)
    if name then
        Player.sendmsgEx(actor, string.format("���|%s#249|����|%d#249", name, num))
        return
    end
    Player.takeItemByTable(actor, cost, "���ޱ�")
    delskill(actor, skillID1)
    addskill(actor, skillID2, 3)
    setflagstatus(actor, VarCfg["F_������������_ѧϰ"], 1)
    Player.sendmsgEx(actor, "��ϲ��ѧϰ����:|������������#249")
end

--ע��������Ϣ
local function _onAttack(actor, Target, Hiter, MagicId)
    if randomex(3, 100) then
        if getskillinfo(actor, skillID2, 1) then
            local x = getbaseinfo(Target, ConstCfg.gbase.x)
            local y = getbaseinfo(Target, ConstCfg.gbase.y)
            rangeharm(actor, x, y, 0, 0, 6, Player.getHpValue(Target, 2), 0, 2,63105)
        end
    end
end
GameEvent.add(EventCfg.onAttack, _onAttack, FoFaWuBian)
Message.RegisterNetMsg(ssrNetMsgCfg.FoFaWuBian, FoFaWuBian)
return FoFaWuBian

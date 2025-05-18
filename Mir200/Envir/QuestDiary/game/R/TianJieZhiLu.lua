local TianJieZhiLu = {}
TianJieZhiLu.ID = "���֮·"
local npcID = 503
--local config = include("QuestDiary/cfgcsv/cfg_TianJieZhiLu.lua") --����
local cost = { { "Ԫ��", 500000 } }
local give = { {} }
--��������
function TianJieZhiLu.Request(actor)
    if checktitle(actor, "�ɷ��б�") then
        Player.sendmsgEx(actor, "���Ѿ�ͨ�������֮·#249")
        return
    end
    if not checkitemw(actor, "Ǳ������ʯ", 1) then
        Player.sendmsgEx(actor, "���|���ɵȼ�#249|û�дﵽ|Ǳ����#249|�޷���ս")
        return
    end
    local name, num = Player.checkItemNumByTable(actor, cost)
    if name then
        Player.sendmsgEx(actor, string.format("���|%s#249|����|%d#249", name, num))
        return
    end
    Player.takeItemByTable(actor, cost, "���֮·")
    local myName = getbaseinfo(actor, ConstCfg.gbase.name)
    local oldMapId = getbaseinfo(actor, ConstCfg.gbase.mapid)
    local x = getbaseinfo(actor, ConstCfg.gbase.x)
    local y = getbaseinfo(actor, ConstCfg.gbase.y)
    local newMapId = myName .. "���֮·"
    if checkmirrormap(newMapId) then
        delmirrormap(newMapId)
    end
    addmirrormap("05570", newMapId, "���֮·", 600, oldMapId, 010088, x, y)
    --�������ӵ�
    mapeffect(1001, newMapId, 235, 14, 17009, 600, 1, actor)
    addmapgate(newMapId, newMapId, 235, 14, 2, oldMapId, 66, 20, 600)
    mapmove(actor, newMapId, 13, 236, 0)
    setontimer(actor, 5, 1)
    setplaydef(actor, VarCfg["M_���֮·"],1)
end

local function _onDuJieOnTiemr(actor)
    local num = getplaydef(actor, VarCfg["U_��ٲ��𵤱���"])
    if num >= 25 then
        addbuff(actor, 31032)
    end
    if not hasbuff(actor, 31032) then
        local hpper = Player.getHpValue(actor, 40)
        humanhp(actor, "-", hpper)
    end
    Player.screffects(actor, 17534, 0, 100)
end

GameEvent.add(EventCfg.onDuJieOnTiemr, _onDuJieOnTiemr, TianJieZhiLu)

local function _goSwitchMap(actor, cur_mapid, former_mapid, x, y)
    if string.find(former_mapid, "���֮·") then
        setofftimer(actor, 5)
        delmirrormap(former_mapid)
    end
end

GameEvent.add(EventCfg.goSwitchMap, _goSwitchMap, TianJieZhiLu)

local function _onBeforerOute(actor, mapid, x, y)
    if mapid == "�����½" and x == 66 and y == 20 then
        confertitle(actor, "�ɷ��б�")
        setplaydef(actor, VarCfg["U_���ɾ���_�˺�ѹ��"], 1)
        local myName = getbaseinfo(actor, ConstCfg.gbase.name)
        Player.sendmsgnewEx(actor, 0, 0, string.format("���|%s#253|ͨ����|[���֮·]#249|��óƺ�|[%s]#249|ʵ����ô������", myName, "�ɷ��б�"))
        messagebox(actor, "��ϲ��ɹ�ͨ��[���֮·],��óƺ�:[�ɷ��б�]")
        Player.setAttList(actor, "���ʸ���")
        Player.setAttList(actor, "���ٸ���")
        Player.setAttList(actor, "���Ը���")
    end
end
GameEvent.add(EventCfg.onBeforerOute, _onBeforerOute, TianJieZhiLu)

local function _onCalcAttackSpeed(actor, attackSpeeds)
    if checktitle(actor, "�ɷ��б�") then
        attackSpeeds[1] = attackSpeeds[1] + 20
    end
end
--��������
GameEvent.add(EventCfg.onCalcAttackSpeed, _onCalcAttackSpeed, TianJieZhiLu)

-- VarCfg["U_���ɾ���_�˺�ѹ��"]
--����ǰ����
local function _onAttackDamagePlayer(actor, Target, Hiter, MagicId, Damage, Model, attackDamageData)
    local myXXLevel = getplaydef(actor, VarCfg["U_���ɾ���_�˺�ѹ��"])
    local targetXXLevel = getplaydef(Target, VarCfg["U_���ɾ���_�˺�ѹ��"])
    if myXXLevel > targetXXLevel then
        attackDamageData.damage = attackDamageData.damage + math.ceil(Damage * 0.1)
    end
end
GameEvent.add(EventCfg.onAttackDamagePlayer, _onAttackDamagePlayer, TianJieZhiLu)

--ע��������Ϣ
Message.RegisterNetMsg(ssrNetMsgCfg.TianJieZhiLu, TianJieZhiLu)
return TianJieZhiLu

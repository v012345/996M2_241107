local SiShenJiTan = {}
local cost = {{"��Ӱɱ���", 1},{"�컯�ᾧ", 22}}

function SiShenJiTan.Request(actor)
    if checktitle(actor,"�������") then
        Player.sendmsgEx(actor, "����#251|:#255|��?�㻹û������...")
        return
    end

    local name, num = Player.checkItemNumByTable(actor, cost)
    if name then
        Player.sendmsgEx(actor, string.format("��ʾ#251|:#255|���|%s#249|����|%d#249|ö,�޷��׼�...", name, num))
        return
    end
    Player.takeItemByTable(actor, cost, "�׼��۳�����")

    local NowHp = getbaseinfo(actor,ConstCfg.gbase.curhp)
    local KillNum = math.random(1, 110)
    humanhp(actor, "-", NowHp*(KillNum/100), 1)
    if KillNum < 100 then
        Player.sendmsgEx(actor, "��ʾ#251|:#255|�Բ���|�׼�ʧ��#249|���Ͽ۳�...")
    elseif  KillNum >= 100 then
        confertitle(actor,"�������")
        giveitem(actor, "��֮ʥ��", 1, 0)
        Player.sendmsgEx(actor, "��ʾ#251|:#255|��ϲ��|�׼��ɹ�#249|,���|�������[�ƺ�]#249|��|��֮ʥ��#249|����...")
        kill(actor, nil)
    end
    --ͬ��һ��ǰ����Ϣ
    Message.sendmsg(actor, ssrNetMsgCfg.SiShenJiTan_SyncResponse, 0, 0, 0, nil)
end
--���Ը���
local function _onCalcAttr(actor, attrs)
    local DieNum = getplaydef(actor, VarCfg["U_�������_��������"])
    local shuxing = {}
    if DieNum > 0 and DieNum <= 66 then
        shuxing[1] = 100*DieNum
    end
    calcAtts(attrs, shuxing, "�������")
end
GameEvent.add(EventCfg.onCalcAttr, _onCalcAttr, SiShenJiTan)

--��������
local function _onPlaydie(actor, hiter)
    if checktitle(actor,"�������") then
        local DieNum = getplaydef(actor, VarCfg["U_�������_��������"])
        if DieNum < 66 then
            setplaydef(actor, VarCfg["U_�������_��������"], DieNum + 1)
            Player.setAttList(actor, "���Ը���")
        end
    end
end
GameEvent.add(EventCfg.onPlaydie, _onPlaydie, SiShenJiTan)

Message.RegisterNetMsg(ssrNetMsgCfg.SiShenJiTan, SiShenJiTan)
return SiShenJiTan

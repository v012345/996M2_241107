local TeQuan = {}

function TeQuan.Request(actor)
    local ZhiGouMoney = querymoney(actor, 24)
    local ZhiGouBoll = getflagstatus(actor, VarCfg["F_���״̬"])
    if ZhiGouBoll == 1 then return end -- �Ƿ��Ѿ�ֱ��

    if ZhiGouMoney >= 98 then
        changemoney(actor, 24, "-", 98, "�۳�ֱ����")
        confertitle(actor, "ţ����Ȩ")
        Player.setAttList(actor, "���Ը���")
        Player.setAttList(actor, "���ٸ���")
        setflagstatus(actor, VarCfg["F_���״̬"] , 1)
        Player.sendmsgEx(actor, "��ʾ#251|:#255|��ϲ��,����|ţ����Ȩ#249|�ɹ�,ף����Ϸ���...")
        GameEvent.push(EventCfg.onTeQuankaiTong, actor)
    else
        -----------------------����������ǰ�˳�ֵ������-----------------------
        Message.sendmsg(actor, ssrNetMsgCfg.TeQuan_TopUp, 98, 0, 0, nil)
        -----------------------����������ǰ�˳�ֵ������-----------------------
    end
end

function TeQuan.PickType(actor,var)
    pullpay(actor, 98, var, 24)
end

--��ֵ�ص�
local function _onRecharge(actor, gold, productid, moneyid)
    if moneyid == 24 then
        if gold == 98 then
            local Num = getplaydef(actor,VarCfg["U_ֱ����¼"])
            setplaydef(actor,VarCfg["U_ֱ����¼"], Num + gold)
            changemoney(actor, 24, "-", 98, "�۳�ֱ����")
            confertitle(actor, "ţ����Ȩ")
            Player.setAttList(actor, "���Ը���")
            Player.setAttList(actor, "���ٸ���")
            setflagstatus(actor, VarCfg["F_���״̬"] , 1)
            Player.sendmsgEx(actor, "��ʾ#251|:#255|��ϲ��,����|ţ����Ȩ#249|�ɹ�,ף����Ϸ���...")
            GameEvent.push(EventCfg.onTeQuankaiTong, actor)
        end
    end
end
GameEvent.add(EventCfg.onRecharge, _onRecharge, TeQuan)

--���ٸ���
local function _onCalcAttackSpeed(actor, attackSpeeds)
    if checktitle(actor,"ţ����Ȩ") then
        attackSpeeds[1] = attackSpeeds[1] + 20
    end
end
GameEvent.add(EventCfg.onCalcAttackSpeed, _onCalcAttackSpeed, TeQuan)


--û�н����Ȩ��� ����Ʒ
local function _onMondropItemex(actor, item)
    if getflagstatus(actor, VarCfg["F_���״̬"]) == 0 then
        setitemaddvalue(actor, item, 2, 1, ConstCfg.binding)
    end
end
GameEvent.add(EventCfg.onMondropItemex, _onMondropItemex, TeQuan)



Message.RegisterNetMsg(ssrNetMsgCfg.TeQuan, TeQuan)
return TeQuan
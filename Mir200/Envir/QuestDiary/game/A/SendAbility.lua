local SendAbility = {}
local function _onSendAbility(actor)
    --�Ա��Ʊ�
    if getflagstatus(actor, VarCfg["F_����_�Ա��Ʊ���ʶ"]) == 1 then
        local baoJi = getbaseinfo(actor, ConstCfg.gbase.custom_attr, 21)
        if baoJi ~= getplaydef(actor, VarCfg["N$��¼�ϴεı�����"]) then
            -- release_print("�����ı���!!!")
            local renXing = 0
            if baoJi > 0 then
                renXing = math.floor(baoJi / 5)
            end
            addattlist(actor, "�Ա��Ʊ��ӳ�", "=", "3#23#" .. renXing, 1)
            setplaydef(actor, VarCfg["N$��¼�ϴεı�����"], baoJi)
        end
    end
end
--�ı����Դ���
GameEvent.add(EventCfg.onSendAbility, _onSendAbility, SendAbility)


return SendAbility

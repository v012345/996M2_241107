local KongJianFaShi = {}

local cost = {{"�����ħ����", 20}}
local give = {{"��ת����[��]", 1}}


function KongJianFaShi.Request(actor)
    local name, num = Player.checkItemNumByTable(actor,cost)

    if getflagstatus(actor, VarCfg["F_�ռ䷨ʦ"]) == 1 then
        Player.sendmsgEx(actor, "��ʾ#251|:#255|���|�ռ䷨ʦ#249|����|�����#249|�����ظ��ύ...")
        return
    end

    if name then
        Player.sendmsgEx(actor, "��ʾ#251|:#255|���|�����ħ����#249|����|20��#249|��ȡʧ��...")
        return
    end
    Player.takeItemByTable(actor,cost,"���������ħ����")
    Player.giveItemByTable(actor,give,"���붷ת����[��]")
    Player.sendmsgEx(actor, "��ʾ#251|:#255|��ϲ�����|�ռ䷨ʦ#249|���|��ת����[��]#249|x1...")
    setflagstatus(actor,VarCfg["F_�ռ䷨ʦ"],1)
    -- FSetTaskRedPoint(actor, VarCfg["F_�ռ䷨ʦ"], 3)
end

--ע��������Ϣ���ر�
Message.RegisterNetMsg(ssrNetMsgCfg.KongJianFaShi, KongJianFaShi)

return KongJianFaShi
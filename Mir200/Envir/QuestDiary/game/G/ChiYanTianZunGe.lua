local ChiYanTianZunGe = {}
ChiYanTianZunGe.ID = "���������"

--��������
function ChiYanTianZunGe.Request(actor)
    local Bool = getflagstatus(actor,VarCfg["F_����ٻ�ɱ��ʶ"])
    if Bool == 1 then
        map(actor, "���������")
    else
        Player.sendmsgEx(actor, "��ʾ#251|:#255|�Բ���,��δͨ��|�����#249|�޷�����...")
    end
end

--ע��������Ϣ
Message.RegisterNetMsg(ssrNetMsgCfg.ChiYanTianZunGe, ChiYanTianZunGe)
return ChiYanTianZunGe
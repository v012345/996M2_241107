local BiBoTianZunGe = {}
BiBoTianZunGe.ID = "�̲������"

--��������
function BiBoTianZunGe.Request(actor)
    local Bool = getflagstatus(actor,VarCfg["F_ˮ���ٻ�ɱ��ʶ"])
    if Bool == 1 then
        map(actor, "�̲������")
    else
        Player.sendmsgEx(actor, "��ʾ#251|:#255|�Բ���,��δͨ��|ˮ����#249|�޷�����...")
    end
end

--ע��������Ϣ
Message.RegisterNetMsg(ssrNetMsgCfg.BiBoTianZunGe, BiBoTianZunGe)
return BiBoTianZunGe
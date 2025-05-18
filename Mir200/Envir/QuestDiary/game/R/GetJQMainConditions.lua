local GetJQMainConditions = {}

GetJQMainConditions[1] = function(actor)
    local Condition1 = getplaydef(actor, VarCfg["U_�����������"]) > 6
    local Condition2 = getflagstatus(actor, VarCfg["F_�ϴ峤�Ļ���"]) == 1
    local Condition3 = getplaydef(actor, VarCfg.U_bian_guan_title) >= 9
    local Condition4 = getflagstatus(actor, VarCfg["F_�ռ䷨ʦ"]) == 1
    return { Condition1, Condition2, Condition3, Condition4 }
end
-- �ƾɳ�
-- VarCfg["F_����_����"] == 1
-- ʪ������
-- VarCfg["U_����_ʪ������_����"] >= 100
-- Ԫ��֮϶
-- VarCfg["F_����_Ԫ��֮϶"]
-- �ڳݱ���
-- VarCfg["U_����_�ڳݱ���_��������"] >= 1
-- ������϶
-- VarCfg["F_����_������϶"]
-- ��ӡ��̳
-- VarCfg["F_��ӡ��̳_���"]
-- ������
-- VarCfg["F_����_����ӡ�ķ�ӡ���_�Ƿ���ȡ1"] or VarCfg["F_����_����ӡ�ķ�ӡ���_�Ƿ���ȡ2"]
-- VarCfg["F_����ӡ�Ĺײ�ʹ��_���"]
--���±���
-- getflagstatus(actor, VarCfg["F_���±���_���"]) == 1
-- Ӣ����˵��
-- VarCfg["U_����_Ӣ���̳_�ƺ�"] >= 10
-- �����Ĵ���
-- VarCfg["U_����_�����Ĵ���"] >= 4
-- ����֮��(��˵)
-- VarCfg["U_����_���鴫˵"] >= 10
-- 12. �������򣨴�˵��
-- VarCfg["F_�ϳ�̫���������"] == 1
--��Ԫͨ��
GetJQMainConditions[2] = function(actor)
    local Condition1 = getflagstatus(actor, VarCfg["F_����_����"]) == 1
    local Condition2 = checktitle(actor,"ʪ����ͽ")
    local Condition3 = getflagstatus(actor, VarCfg["F_����_Ԫ��֮϶"]) == 1
    local Condition4 = getplaydef(actor, VarCfg["U_����_�ڳݱ���_��������"]) > 0
    local Condition5 = getflagstatus(actor, VarCfg["F_����_������϶"]) == 1
    local Condition6 = getflagstatus(actor, VarCfg["F_��ӡ��̳_���"]) == 1
    local Condition7 = (getflagstatus(actor, VarCfg["F_����_����ӡ�ķ�ӡ���_�Ƿ���ȡ1"]) == 1 or getflagstatus(actor, VarCfg["F_����_����ӡ�ķ�ӡ���_�Ƿ���ȡ2"]) == 1) and
    getflagstatus(actor, VarCfg["F_����ӡ�Ĺײ�ʹ��_���"]) == 1
    local Condition8 = getflagstatus(actor, VarCfg["F_���±���_���"]) == 1
    -- local Condition9 = { getplaydef(actor, VarCfg["U_����_Ӣ���̳_�ƺ�"]), 10 }
    -- local Condition10 = { getplaydef(actor, VarCfg["U_����_�����Ĵ���"]), 5 }
    -- local Condition11 = { getplaydef(actor, VarCfg["U_����_���鴫˵"]), 10 }
    -- local Condition12 = getflagstatus(actor, VarCfg["F_�ϳ�̫���������"]) == 1
    return { Condition1, Condition2, Condition3, Condition4, Condition5, Condition6, Condition7, Condition8 }
end

GetJQMainConditions[3] = function(actor)
    --1.��ħ����
    local Condition1 = getplaydef(actor, VarCfg["U_��ħ������ս����"]) >= 3
    --2.������
    local Condition2 = getplaydef(actor, VarCfg["U_��Ԫ������_����"]) >= 2 and getplaydef(actor, VarCfg["U_�Ϲ�ħ���ٻ�_����"]) >= 3
    --3.����֮��
    local Condition3 = getflagstatus(actor, VarCfg["F_����_����֮��_1"]) == 1 and getflagstatus(actor, VarCfg["F_����_����֮��_2"]) == 1 and getflagstatus(actor, VarCfg["F_����_����֮��_3"]) == 1 and getflagstatus(actor, VarCfg["F_����_����֮��_4"]) == 1
    -- 4.����Ѫ��
    local Condition4 = getplaydef(actor, VarCfg["U_����_����Ѫ��_���Ѵ���"]) >= 10
    --5.ɳ����˵
    local Condition5 = getflagstatus(actor, VarCfg["F_��ɳ֮��_���"]) == 1
    --6.����ս��
    local Condition6 = getplaydef(actor, VarCfg["U_����_��������_����"]) >= 100
    -- 7.�������
    local Condition7 = getplaydef(actor,VarCfg["U_����_�������_����"]) >= 10 and getflagstatus(actor,VarCfg["F_����_��������_��ͼ����"]) == 1
    --8.�ݹ�֮��
    local Condition8 = (getflagstatus(actor, VarCfg["F_����_һ��������ſ�1"]) == 1 and getflagstatus(actor, VarCfg["F_����_һ��������ſ�2"]) == 1 and getflagstatus(actor, VarCfg["F_����_һ��������ſ�3"]) == 1) or getflagstatus(actor,VarCfg["F_����_ʱװ�Ƿ���ȡ"]) == 1
    --9.����֮��
    local Condition9 = getplaydef(actor, VarCfg["U_������ʽ�ٻ�_����"])  >= 10 and getflagstatus(actor,VarCfg["F_���¾�β������ɱ_���"]) == 1
    --10.����֮��
    local Condition10 = getplaydef(actor, VarCfg["U_����_����ǰ��_ɱ������"]) >= 1000 and getplaydef(actor, VarCfg["U_����_��������_��������"]) >= 100 and checktitle(actor,"����֮��")
    return { Condition1, Condition2, Condition3, Condition4, Condition5, Condition6, Condition7, Condition8, Condition9, Condition10 }
end

GetJQMainConditions[4] = function(actor)
    local Condition1 = getflagstatus(actor, VarCfg["F_����_��������Ƿ���"]) == 1
    local Condition2 = getplaydef(actor, VarCfg["U_�йٸ�������"]) >= 3
    local Condition3 = getflagstatus(actor,VarCfg["F_����_��ڤ��ʹ_��ͼ����"]) == 1
    local Condition4 = getplaydef(actor, VarCfg["U_����_����������_��"]) >= 66 and getplaydef(actor, VarCfg["U_����_����������_��"]) >= 66
    local Condition5 = checktitle(actor,"ڤ��������")
    local Condition6 = getflagstatus(actor, VarCfg["F_����_��������_��ʶ1"]) == 1 and getflagstatus(actor, VarCfg["F_����_��������_��ʶ2"]) == 1 and getflagstatus(actor, VarCfg["F_����_��������_��ʶ3"]) == 1
    local Condition7 = getflagstatus(actor, VarCfg["F_����_����֮��1"]) == 1 and getflagstatus(actor, VarCfg["F_����_����֮��2"]) == 1
    local Condition8 = getflagstatus(actor, VarCfg["F_�߳�����_���"]) == 1
    local Condition9 = getflagstatus(actor, VarCfg["F_��ˮ�ؼ�_���"]) == 1
    local Condition10 = checktitle(actor, "ħ���ƿ���")
    return { Condition1, Condition2, Condition3, Condition4, Condition5, Condition6, Condition7, Condition8, Condition9, Condition10 }
end

GetJQMainConditions[5] = function(actor)
    local Condition1 = getflagstatus(actor, VarCfg["F_����_����_��������"]) == 1 and getplaydef(actor, VarCfg["U_������������"]) >= 10
    local Condition2 = getflagstatus(actor, VarCfg["F_����_������_���1"]) == 1 and getflagstatus(actor, VarCfg["F_����_������_���2"]) == 1
    local Condition3 = getflagstatus(actor, VarCfg["F_�ٻ���˪����������"]) == 1
    local Condition4 = getflagstatus(actor, VarCfg["F_����_���֮��1"]) == 1 and getflagstatus(actor, VarCfg["F_����_���֮��2"]) == 1 and getflagstatus(actor, VarCfg["F_����_���֮��3"]) == 1
    local Condition5 = getflagstatus(actor, VarCfg["F_����_���֮�ſ���"]) == 1 and checktitle(actor, "��������")
    local Condition6 = getflagstatus(actor, VarCfg["F_����_�粼�ֵ�����1"]) == 1 and getflagstatus(actor, VarCfg["F_����_�粼�ֵ�����2"]) == 1 and getflagstatus(actor, VarCfg["F_����_�粼�ֵ�����3"]) == 1 and getflagstatus(actor, VarCfg["F_����_�粼�ֵ�����4"]) == 1 and getflagstatus(actor, VarCfg["F_����_�粼�ֵ�����5"]) == 1
    local Condition7 = getplaydef(actor, VarCfg["U_�����Ů_����"]) >= 3
    local Condition8 = getplaydef(actor,VarCfg["U_����_�¹�֮��_����"]) >= 30 and getplaydef(actor,VarCfg["U_����_��ҹ����_����"]) >= 10
    local Condition9 = getplaydef(actor,VarCfg["U_����_һҶһ����_����"]) >= 10
    local Condition10 = getflagstatus(actor,VarCfg["F_����_��������_����ͼ"]) == 1 and getflagstatus(actor, VarCfg["F_������������"]) == 1
    return { Condition1, Condition2, Condition3, Condition4, Condition5, Condition6, Condition7, Condition8, Condition9, Condition10 }
end

GetJQMainConditions[6] = function(actor)
    --�Ƴ���ҫ
    local Condition_1 = getflagstatus(actor, VarCfg["F_�Ƴ���ҫ_�����ʶ1"]) == 1 and getflagstatus(actor, VarCfg["F_�Ƴ���ҫ_�����ʶ2"]) == 1 and getflagstatus(actor, VarCfg["F_�Ƴ���ҫ_�����ʶ3"]) == 1 and getflagstatus(actor, VarCfg["F_�Ƴ���ҫ_�����ʶ4"]) == 1 and getflagstatus(actor, VarCfg["F_�Ƴ���ҫ_�����ʶ5"]) == 1
    --����ɽ��
    local Condition_2 = getplaydef(actor, VarCfg["U_�׻���Ƭ_�ύ����"]) >= 10
    local Condition_3 = getflagstatus(actor, VarCfg["F_�����ܵ�_����״̬"]) == 1
    local Condition_4 = getflagstatus(actor, VarCfg["F_��Ӱ��ì�ϳ�"]) == 1 and getflagstatus(actor, VarCfg["F_�������_����״̬"]) == 1 and getplaydef(actor, VarCfg["U_����֮���ȡ"]) >= 1
    local Condition_5 = getflagstatus(actor, VarCfg["F_����ᾧ�ɹ�"]) == 1
    local Condition_6 = getplaydef(actor, VarCfg["U_����ʥ���¼"]) >= 10 and getplaydef(actor, VarCfg["U_ͼ��ʥ���¼"]) >= 10 and getplaydef(actor, VarCfg["U_����ʥ���¼"]) >= 10 and getplaydef(actor, VarCfg["U_��ʧʥ���¼"]) >= 10 and getflagstatus(actor, VarCfg["F_ʥ���ż�_��ȡ״̬"]) == 1
    local Condition_7 = getflagstatus(actor, VarCfg["F_����ħ��_�����ʶ"]) == 1 and getflagstatus(actor, VarCfg["F_�������˻���"]) == 1
    local Condition_8 = getflagstatus(actor, VarCfg["F_���������_�޾���ŭ"]) == 1 and getflagstatus(actor, VarCfg["F_���������_Ѫħ����MAX"]) == 1
    local Condition_9 = getflagstatus(actor, VarCfg["F_������˹֮Ĺ���һ��"]) == 1
    local Condition_10 = checktitle(actor,"�������")
    return { Condition_1, Condition_2, Condition_3, Condition_4, Condition_5, Condition_6, Condition_7, Condition_8, Condition_9, Condition_10 }
end

GetJQMainConditions[7] = function(actor)
    local Condition_1 = getflagstatus(actor, VarCfg["F_Ѫɫ��ŭ1"]) == 1 and getflagstatus(actor, VarCfg["F_Ѫɫ��ŭ2"]) == 1
    local Condition_2 = getflagstatus(actor, VarCfg["F_ʱ������λ��1"]) == 1 and getflagstatus(actor, VarCfg["F_ʱ������λ��2"]) == 1 and getflagstatus(actor, VarCfg["F_ʱ������λ��3"]) == 1
    local Condition_3 = getflagstatus(actor, VarCfg["F_�����ֻ�1"]) == 1 and getflagstatus(actor, VarCfg["F_�����ֻ�2"]) == 1 and getflagstatus(actor, VarCfg["F_�����ֻ�3"]) == 1
    local Condition_4 = getflagstatus(actor, VarCfg["F_�������������ӡ"]) == 1
    local Condition_5 = getflagstatus(actor, VarCfg["F_����֮���ײ㿪��״̬"]) == 1 and getflagstatus(actor, VarCfg["F_ѧϰ��į����"]) == 1
    local Condition_6 = getflagstatus(actor, VarCfg["F_����֮�ֿ���״̬"]) == 1 and getflagstatus(actor, VarCfg["F_����֮���ջ�һ��"]) == 1
    local Condition_7 = getplaydef(actor, VarCfg["B_������������"]) >= 20
    local data = CheckLevelIsTbl(actor)
    local Condition_8 = data["̰��"] >= 50 and data["����"] >= 50 and data["»��"] >= 50 and data["����"] >= 50 and data["�ƾ�"] >= 50 and data["����"] >= 50 and data["����"] >= 50 and getflagstatus(actor,VarCfg["F_�ǳ�����ȡ״̬"]) == 1
    return { Condition_1, Condition_2, Condition_3, Condition_4, Condition_5, Condition_6, Condition_7, Condition_8}
end

return GetJQMainConditions

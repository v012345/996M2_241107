local GetJQChildConditions = {}

--��Դ��
GetJQChildConditions[1] = function(actor)
    local Condition1 = getplaydef(actor, VarCfg["U_�����������"]) > 6
    return { Condition1 }
end
--�ϴ峤�Ļ���
GetJQChildConditions[2] = function(actor)
    local Condition1 = getflagstatus(actor, VarCfg["F_�ϴ峤�Ļ���"]) == 1
    return { Condition1 }
end
--�߹ؽ���
GetJQChildConditions[3] = function(actor)
    local Condition1 = { getplaydef(actor, VarCfg.U_bian_guan_title), 10 }
    return { Condition1 }
end
--��ת����
GetJQChildConditions[4] = function(actor)
    local Condition1 = getflagstatus(actor, VarCfg["F_�ռ䷨ʦ"]) == 1
    return { Condition1 }
end
-- local Condition1 = getflagstatus(actor, VarCfg["F_����_����"]) == 1
-- local Condition2 = { getplaydef(actor, VarCfg["U_����_ʪ������_����"]), 100 }
-- local Condition3 = getflagstatus(actor, VarCfg["F_����_Ԫ��֮϶"]) == 1
-- local Condition4 = { getplaydef(actor, VarCfg["U_����_�ڳݱ���_��������"]), 1 }
-- local Condition5 = getflagstatus(actor, VarCfg["F_����_������϶"]) == 1
-- local Condition6 = getflagstatus(actor, VarCfg["F_��ӡ��̳_���"]) == 1
-- local Condition7 = (getflagstatus(actor, VarCfg["F_����_����ӡ�ķ�ӡ���_�Ƿ���ȡ1"]) == 1 or getflagstatus(actor, VarCfg["F_����_����ӡ�ķ�ӡ���_�Ƿ���ȡ2"])) and
-- getflagstatus(actor, VarCfg["F_����ӡ�Ĺײ�ʹ��_���"]) == 1
-- local Condition8 = getflagstatus(actor, VarCfg["F_���±���_���"]) == 1
-- local Condition9 = { getplaydef(actor, VarCfg["U_����_Ӣ���̳_�ƺ�"]), 10 }
-- local Condition10 = { getplaydef(actor, VarCfg["U_����_�����Ĵ���"]), 5 }
-- local Condition11 = { getplaydef(actor, VarCfg["U_����_���鴫˵"]), 10 }
-- local Condition12 = getflagstatus(actor, VarCfg["F_�ϳ�̫���������"]) == 1
-- return { Condition1, Condition2, Condition3, Condition4, Condition5, Condition6, Condition7, Condition8, Condition9,
--     Condition10, Condition11, Condition12 }
GetJQChildConditions[5] = function(actor)
    local Condition1 = getflagstatus(actor, VarCfg["F_����_����"]) == 1
    return { Condition1 }
end
GetJQChildConditions[6] = function(actor)
    local Condition2 = checktitle(actor, "ʪ����ͽ")
    return { Condition2 }
end
GetJQChildConditions[7] = function(actor)
    local Condition3 = getflagstatus(actor, VarCfg["F_����_Ԫ��֮϶"]) == 1
    return { Condition3 }
end
GetJQChildConditions[8] = function(actor)
    local Condition4 = { getplaydef(actor, VarCfg["U_����_�ڳݱ���_��������"]), 1 }
    return { Condition4 }
end
GetJQChildConditions[9] = function(actor)
    local Condition5 = getflagstatus(actor, VarCfg["F_����_������϶"]) == 1
    return { Condition5 }
end
GetJQChildConditions[10] = function(actor)
    local Condition6 = getflagstatus(actor, VarCfg["F_��ӡ��̳_���"]) == 1
    return { Condition6 }
end
GetJQChildConditions[11] = function(actor)
    local Condition7_1 = (getflagstatus(actor, VarCfg["F_����_����ӡ�ķ�ӡ���_�Ƿ���ȡ1"]) == 1 or getflagstatus(actor, VarCfg["F_����_����ӡ�ķ�ӡ���_�Ƿ���ȡ2"]) == 1)
    local Condition7_2 = getflagstatus(actor, VarCfg["F_����ӡ�Ĺײ�ʹ��_���"]) == 1
    return { Condition7_1, Condition7_2 }
end
GetJQChildConditions[12] = function(actor)
    local Condition8 = getflagstatus(actor, VarCfg["F_���±���_���"]) == 1
    return { Condition8 }
end
GetJQChildConditions[13] = function(actor)
    local Condition9 = { getplaydef(actor, VarCfg["U_����_Ӣ���̳_�ƺ�"]), 10 }
    return { Condition9 }
end
GetJQChildConditions[14] = function(actor)
    local Condition10 = { getplaydef(actor, VarCfg["U_����_�����Ĵ���"]), 5 }
    return { Condition10 }
end
GetJQChildConditions[15] = function(actor)
    local Condition11 = { getplaydef(actor, VarCfg["U_����_���鴫˵"]), 10 }
    return { Condition11 }
end
GetJQChildConditions[16] = function(actor)
    local Condition12 = getflagstatus(actor, VarCfg["F_�ϳ�̫���������"]) == 1
    return { Condition12 }
end
-- --1.��ħ����
-- local Condition1 = getplaydef(actor, VarCfg["U_��ħ������ս����"]) >= 3
-- --2.������
-- local Condition2 = getplaydef(actor, VarCfg["U_��Ԫ������_����"]) >= 2 and getplaydef(actor, VarCfg["U_�Ϲ�ħ���ٻ�_����"]) >= 3
-- --3.����֮��
-- local Condition3 = getflagstatus(actor, VarCfg["F_����_����֮��_1"]) == 1 and getflagstatus(actor, VarCfg["F_����_����֮��_2"]) == 1 and getflagstatus(actor, VarCfg["F_����_����֮��_3"]) == 1 and getflagstatus(actor, VarCfg["F_����_����֮��_4"]) == 1
-- -- 4.����Ѫ��
-- local Condition4 = getplaydef(actor, VarCfg["U_����_����Ѫ��_���Ѵ���"]) >= 10
-- --5.ɳ����˵
-- local Condition5 = getflagstatus(actor, VarCfg["F_��ɳ֮��_���"]) == 1
-- --6.����ս��
-- local Condition6 = getplaydef(actor, VarCfg["U_����_��������_����"]) >= 100
-- -- 7.�������
-- local Condition7 = getplaydef(actor,VarCfg["U_����_�������_����"]) >= 10 and getflagstatus(actor,VarCfg["F_����_��������_��ͼ����"]) == 1
-- --8.�ݹ�֮��
-- local Condition8 = (getflagstatus(actor, VarCfg["F_����_һ��������ſ�1"]) == 1 and getflagstatus(actor, VarCfg["F_����_һ��������ſ�2"]) == 1 and getflagstatus(actor, VarCfg["F_����_һ��������ſ�3"]) == 1) or getflagstatus(actor,VarCfg["F_����_ʱװ�Ƿ���ȡ"]) == 1
-- --9.����֮��
-- local Condition9 = getplaydef(actor, VarCfg["U_������ʽ�ٻ�_����"])  >= 10 and getflagstatus(actor,VarCfg["F_���¾�β������ɱ_���"]) == 1
-- --10.����֮��
-- local Condition10 = getplaydef(actor, VarCfg["U_����_����ǰ��_ɱ������"]) >= 1000 and getplaydef(actor, VarCfg["U_����_��������_��������"]) >= 100

GetJQChildConditions[17] = function(actor)
    local Condition1_1 = getplaydef(actor, VarCfg["U_��ħ������ս����"]) >= 1
    local Condition1_2 = getplaydef(actor, VarCfg["U_��ħ������ս����"]) >= 2
    local Condition1_3 = getplaydef(actor, VarCfg["U_��ħ������ս����"]) >= 3
    return { Condition1_1, Condition1_2, Condition1_3 }
end
GetJQChildConditions[18] = function(actor)
    local Condition2_1 = { getplaydef(actor, VarCfg["U_�Ϲ�ħ���ٻ�_����"]), 3 }
    local Condition2_2 = { getplaydef(actor, VarCfg["U_��Ԫ������_����"]), 2 }
    return { Condition2_1, Condition2_2 }
end
GetJQChildConditions[19] = function(actor)
    local Condition3_1 = { getflagstatus(actor, VarCfg["F_����_����֮��_1"]), 1 }
    local Condition3_2 = { getflagstatus(actor, VarCfg["F_����_����֮��_2"]), 1 }
    local Condition3_3 = { getflagstatus(actor, VarCfg["F_����_����֮��_4"]), 1 }
    local Condition3_4 = { getflagstatus(actor, VarCfg["F_����_����֮��_3"]), 1 }
    return { Condition3_1, Condition3_2, Condition3_3, Condition3_4 }
end
GetJQChildConditions[20] = function(actor)
    local Condition4 = { getplaydef(actor, VarCfg["U_����_����Ѫ��_���Ѵ���"]), 10 }
    return { Condition4 }
end
GetJQChildConditions[21] = function(actor)
    local Condition5 = getflagstatus(actor, VarCfg["F_��ɳ֮��_���"]) == 1
    return { Condition5 }
end
GetJQChildConditions[22] = function(actor)
    local Condition6 = { getplaydef(actor, VarCfg["U_����_��������_����"]), 100 }
    return { Condition6 }
end
GetJQChildConditions[23] = function(actor)
    local Condition7_1 = { getplaydef(actor, VarCfg["U_����_�������_����"]), 10 }
    local Condition7_2 = getflagstatus(actor, VarCfg["F_����_��������_��ͼ����"]) == 1
    return { Condition7_1, Condition7_2 }
end
GetJQChildConditions[24] = function(actor)
    local Condition8_1 = { getflagstatus(actor, VarCfg["F_����_һ��������ſ�1"]), 1 }
    local Condition8_2 = { getflagstatus(actor, VarCfg["F_����_һ��������ſ�2"]), 1 }
    local Condition8_3 = { getflagstatus(actor, VarCfg["F_����_һ��������ſ�3"]), 1 }
    local Condition8_4 = { getflagstatus(actor, VarCfg["F_����_ʱװ�Ƿ���ȡ"]), 1 }
    return { Condition8_1, Condition8_2, Condition8_3, Condition8_4 }
end
GetJQChildConditions[25] = function(actor)
    local Condition9_1 = {getplaydef(actor, VarCfg["U_������ʽ�ٻ�_����"]),10}
    local Condition9_2 = getflagstatus(actor,VarCfg["F_���¾�β������ɱ_���"]) == 1
    return {Condition9_1,Condition9_2}
end
GetJQChildConditions[26] = function(actor)
    -- local Condition10 = getplaydef(actor, VarCfg["U_����_����ǰ��_ɱ������"]) >= 1000 and getplaydef(actor, VarCfg["U_����_��������_��������"]) >= 100
    local Condition10_1 = { getplaydef(actor, VarCfg["U_����_����ǰ��_ɱ������"]), 1000 }
    local Condition10_2 = getplaydef(actor, VarCfg["U_����_��������_��������"]) >= 100 
    local Condition10_3 = checktitle(actor,"����֮��")
    return { Condition10_1, Condition10_2, Condition10_3 }
end
GetJQChildConditions[27] = function(actor)
    local Condition11_1 = { getplaydef(actor, VarCfg["U_��֮�ػ���ɱ_����"]), 10 }
    local Condition11_2 = getflagstatus(actor,VarCfg["F_[����]����̖��_���"]) == 1
    return { Condition11_1, Condition11_2 }
end
GetJQChildConditions[28] = function(actor)
    local Condition12 = getflagstatus(actor,VarCfg["F_����ħ����ʹ[����]_���"]) == 1
    return {Condition12}
end
GetJQChildConditions[29] = function(actor)
    local Condition13_1 = { getplaydef(actor, VarCfg["U_����_����ռ�_��¼1"]), 3 }
    local Condition13_2 = { getplaydef(actor, VarCfg["U_����_����ռ�_��¼2"]), 3 }
    local Condition13_3 = { getplaydef(actor, VarCfg["U_����_����ռ�_��¼3"]), 3 }
    local Condition13_4 = { getplaydef(actor, VarCfg["U_����_����ռ�_��¼4"]), 3 }
    local Condition13_5 = checktitle(actor,"׷������֮·")
    return { Condition13_1, Condition13_2, Condition13_3, Condition13_4, Condition13_5 }
end
--С���Ѳ�
GetJQChildConditions[30] = function(actor)
    local Condition1 = getflagstatus(actor, VarCfg["F_����_��������Ƿ���"]) == 1
    return { Condition1 }
end
GetJQChildConditions[31] = function(actor)
    local Condition2 = {getplaydef(actor, VarCfg["U_�йٸ�������"]), 3}
    return { Condition2 }
end
GetJQChildConditions[32] = function(actor)
    local Condition3 = getflagstatus(actor,VarCfg["F_����_��ڤ��ʹ_��ͼ����"]) == 1
    return { Condition3 }
end
GetJQChildConditions[33] = function(actor)
    local Condition4_1 = {getplaydef(actor, VarCfg["U_����_����������_��"]),66} 
    local Condition4_2 = {getplaydef(actor, VarCfg["U_����_����������_��"]),66}
    return { Condition4_1, Condition4_2 }
end
GetJQChildConditions[34] = function(actor)
    local Condition5_1 = checktitle(actor,"��ʱ�ɻ��")
    local Condition5_2 = checktitle(actor,"��ʱ�ǻ��")
    local Condition5_3 = checktitle(actor,"��ʱ�ƻ��")
    local Condition5_4 = checktitle(actor,"îʱ����")
    local Condition5_5 = checktitle(actor,"��ʱȪ���")
    local Condition5_6 = checktitle(actor,"��ʱ�Ż��")
    local Condition5_7 = checktitle(actor,"��ʱ����")
    local Condition5_8 = checktitle(actor,"δʱ����")
    local Condition5_9 = checktitle(actor,"��ʱ�����")
    local Condition5_10 = checktitle(actor,"��ʱ����")
    local Condition5_11 = checktitle(actor,"��ʱᦻ��")
    local Condition5_12 = checktitle(actor,"��ʱ�Ի��")
    if checktitle(actor, "ڤ��������") then
        Condition5_1 =  true
        Condition5_2 =  true
        Condition5_3 =  true
        Condition5_4 =  true
        Condition5_5 =  true
        Condition5_6 =  true
        Condition5_7 =  true
        Condition5_8 =  true
        Condition5_9 =  true
        Condition5_10 =  true
        Condition5_11 =  true
        Condition5_12 =  true
    end
    return { Condition5_1, Condition5_2, Condition5_3, Condition5_4, Condition5_5, Condition5_6, Condition5_7, Condition5_8, Condition5_9, Condition5_10, Condition5_11, Condition5_12 }
end
GetJQChildConditions[35] = function(actor)
    local Condition6_1 = getflagstatus(actor, VarCfg["F_����_��������_��ʶ1"]) == 1
    local Condition6_2 = getflagstatus(actor, VarCfg["F_����_��������_��ʶ2"]) == 1
    local Condition6_3 = getflagstatus(actor, VarCfg["F_����_��������_��ʶ3"]) == 1
    return {Condition6_1, Condition6_2, Condition6_3}
end
GetJQChildConditions[36] = function(actor)
    local Condition7_1 = getflagstatus(actor, VarCfg["F_����_����֮��1"]) == 1
    local Condition7_2 = getflagstatus(actor, VarCfg["F_����_����֮��2"]) == 1
    return {Condition7_1, Condition7_2}
end
GetJQChildConditions[37] = function(actor)
    local Condition8 = getflagstatus(actor, VarCfg["F_�߳�����_���"]) == 1
    return {Condition8}
end
GetJQChildConditions[38] = function(actor)
    local Condition9 = getflagstatus(actor, VarCfg["F_��ˮ�ؼ�_���"]) == 1
    return {Condition9}
end
GetJQChildConditions[39] = function(actor)
    local Condition10_1 = getflagstatus(actor, VarCfg["F_����_ħ������1"]) == 1
    local Condition10_2 = getflagstatus(actor, VarCfg["F_����_ħ������2"]) == 1
    local Condition10_3 = getflagstatus(actor, VarCfg["F_����_ħ������3"]) == 1
    local Condition10_4 = checktitle(actor, "ħ���ƿ���")
    return {Condition10_1,Condition10_2,Condition10_3,Condition10_4}
end
GetJQChildConditions[40] = function(actor)
    local Condition11_1 = getplaydef(actor, VarCfg["U_�ز���������"]) >= 1
    local Condition11_2 = getplaydef(actor, VarCfg["U_�ز���������"]) >= 2
    local Condition11_3 = getplaydef(actor, VarCfg["U_�ز���������"]) >= 3
    local Condition11_4 = getplaydef(actor, VarCfg["U_�ز���������"]) >= 4
    local Condition11_5 = getplaydef(actor, VarCfg["U_�ز���������"]) >= 5
    return {Condition11_1,Condition11_2,Condition11_3,Condition11_4,Condition11_5}
end
GetJQChildConditions[41] = function(actor)
    local Condition11 = getflagstatus(actor,VarCfg["F_�����_���"]) == 1
    return {Condition11}
end
GetJQChildConditions[42] = function(actor)
    local Condition12 = getflagstatus(actor,VarCfg["F_�����ֻ���_���"]) == 1
    return {Condition12}
end
--����
GetJQChildConditions[43] = function(actor)
    local Condition1_1 = getflagstatus(actor, VarCfg["F_����_����_��������"]) == 1
    local Condition1_2 = {getplaydef(actor, VarCfg["U_������������"]), 10}
    return { Condition1_1, Condition1_2 }
end
GetJQChildConditions[44] = function(actor)
    local Condition2_1 = getflagstatus(actor, VarCfg["F_����_������_���1"]) == 1
    local Condition2_2 = getflagstatus(actor, VarCfg["F_����_������_���2"]) == 1
    return { Condition2_1, Condition2_2 }
end
GetJQChildConditions[45] = function(actor)
    local Condition3 = getflagstatus(actor, VarCfg["F_�ٻ���˪����������"]) == 1
    return { Condition3 }
end
GetJQChildConditions[46] = function(actor)
    local Condition4_1 = getflagstatus(actor, VarCfg["F_����_���֮��1"]) == 1
    local Condition4_2 = getflagstatus(actor, VarCfg["F_����_���֮��2"]) == 1
    local Condition4_3 = getflagstatus(actor, VarCfg["F_����_���֮��3"]) == 1
    return { Condition4_1, Condition4_2, Condition4_3 }
end
GetJQChildConditions[47] = function(actor)
    local Condition5_1 = getflagstatus(actor, VarCfg["F_����_���֮�ſ���"]) == 1
    local Condition5_2 = checktitle(actor, "��������")
    return {Condition5_1, Condition5_2}
end
GetJQChildConditions[48] = function(actor)
    local Condition6_1 = getflagstatus(actor, VarCfg["F_����_�粼�ֵ�����1"]) == 1
    local Condition6_2 = getflagstatus(actor, VarCfg["F_����_�粼�ֵ�����2"]) == 1
    local Condition6_3 = getflagstatus(actor, VarCfg["F_����_�粼�ֵ�����3"]) == 1
    local Condition6_4 = getflagstatus(actor, VarCfg["F_����_�粼�ֵ�����4"]) == 1
    local Condition6_5 = getflagstatus(actor, VarCfg["F_����_�粼�ֵ�����5"]) == 1
    return { Condition6_1, Condition6_2, Condition6_3, Condition6_4, Condition6_5}
end
GetJQChildConditions[49] = function(actor)
    local Condition7 = {getplaydef(actor, VarCfg["U_�����Ů_����"]) ,3}
    return {Condition7}
end
GetJQChildConditions[50] = function(actor)
    local Condition8_1 = {getplaydef(actor,VarCfg["U_����_�¹�֮��_����"]), 30}
    local Condition8_2 = {getplaydef(actor,VarCfg["U_����_��ҹ����_����"]) ,10}
    return {Condition8_1, Condition8_2}
end
GetJQChildConditions[51] = function(actor)
    local Condition9 = {getplaydef(actor,VarCfg["U_����_һҶһ����_����"]),10}
    return {Condition9}
end
GetJQChildConditions[52] = function(actor)
    local Condition10_1 = getflagstatus(actor,VarCfg["F_����_��������_����ͼ"]) == 1
    local Condition10_2 = getflagstatus(actor,VarCfg["F_������������"]) == 1
    return {Condition10_1, Condition10_2}
end
GetJQChildConditions[53] = function(actor)
    local Condition11 = {getplaydef(actor,VarCfg["U_ħ����ʹ_����_����"]), 2997}
    return {Condition11}
end
GetJQChildConditions[54] = function(actor)
    local Condition12 = getflagstatus(actor,VarCfg["F_������������_ѧϰ"]) == 1
    return {Condition12}
end
--��ҫ�ռ���
GetJQChildConditions[55] = function(actor)
    local Condition1_1 = getflagstatus(actor, VarCfg["F_�Ƴ���ҫ_�����ʶ1"]) == 1
    local Condition1_2 = getflagstatus(actor, VarCfg["F_�Ƴ���ҫ_�����ʶ2"]) == 1
    local Condition1_3 = getflagstatus(actor, VarCfg["F_�Ƴ���ҫ_�����ʶ3"]) == 1
    local Condition1_4 = getflagstatus(actor, VarCfg["F_�Ƴ���ҫ_�����ʶ4"]) == 1
    local Condition1_5 = getflagstatus(actor, VarCfg["F_�Ƴ���ҫ_�����ʶ5"]) == 1
    return { Condition1_1, Condition1_2, Condition1_3, Condition1_4, Condition1_5 }
end
GetJQChildConditions[56] = function(actor)
    local Condition2 = {getplaydef(actor, VarCfg["U_�׻���Ƭ_�ύ����"]), 10}
    return {Condition2}
end
GetJQChildConditions[57] = function(actor)
    local Condition3_1 = getflagstatus(actor, VarCfg["F_��Ӱ��ì�ϳ�"]) == 1
    local Condition3_2 = getflagstatus(actor, VarCfg["F_�������_����״̬"]) == 1
    local Condition3_3 = getplaydef(actor, VarCfg["U_����֮���ȡ"]) >= 1
    return { Condition3_1, Condition3_2, Condition3_3 }
end
GetJQChildConditions[58] = function(actor)
    local Condition4 = getflagstatus(actor, VarCfg["F_����ᾧ�ɹ�"]) == 1
    return {Condition4}
end
GetJQChildConditions[59] = function(actor)
    local Condition5_1 = {getplaydef(actor, VarCfg["U_����ʥ���¼"]),10}
    local Condition5_2 = {getplaydef(actor, VarCfg["U_ͼ��ʥ���¼"]),10}
    local Condition5_3 = {getplaydef(actor, VarCfg["U_����ʥ���¼"]),10}
    local Condition5_4 = {getplaydef(actor, VarCfg["U_��ʧʥ���¼"]),10}
    local Condition5_5 = getflagstatus(actor, VarCfg["F_ʥ���ż�_��ȡ״̬"]) == 1
    return { Condition5_1, Condition5_2, Condition5_3, Condition5_4, Condition5_5 }
end
GetJQChildConditions[60] = function(actor)
    local Condition6_1 = getflagstatus(actor, VarCfg["F_����ħ��_�����ʶ"]) == 1
    local Condition6_2 = getflagstatus(actor, VarCfg["F_�������˻���"]) == 1
    -- local Condition6_3 = getflagstatus(actor, VarCfg["F_�����ֻس�����"]) == 1
    return { Condition6_1, Condition6_2 }
end
GetJQChildConditions[61] = function(actor)
    local Condition7_1 = getflagstatus(actor, VarCfg["F_���������_�޾���ŭ"]) == 1
    local Condition7_2 = getflagstatus(actor, VarCfg["F_���������_Ѫħ����MAX"]) == 1
    return { Condition7_1, Condition7_2 }
end
GetJQChildConditions[62] = function(actor)
    local Condition8_1 = getflagstatus(actor, VarCfg["F_������˹֮Ĺ_����"]) == 1
    local Condition8_2 = getflagstatus(actor, VarCfg["F_������˹֮Ĺ���һ��"]) == 1
    return { Condition8_1, Condition8_2 }
end
GetJQChildConditions[63] = function(actor)
    local Condition9_1 = checktitle(actor,"�������")
    local Condition9_2 = checktitle(actor,"�������")
    return { Condition9_1, Condition9_2 }
    
end
GetJQChildConditions[64] = function(actor)
    local Condition10 = getflagstatus(actor, VarCfg["F_�ŵ����ż�_����״̬"]) == 1
    return {Condition10}
end
GetJQChildConditions[65] = function(actor)
    local Condition11_1 = getflagstatus(actor,VarCfg["F_��־塤������_��ɱ"]) == 1
    local Condition11_2 = getflagstatus(actor,VarCfg["F_����������̡��_��ȡ"]) == 1
    return {Condition11_1, Condition11_2}
end
GetJQChildConditions[66] = function(actor)
    local Condition12 = getflagstatus(actor, VarCfg["F_����֮��_�ϳ�"]) == 1
    return {Condition12}
end
GetJQChildConditions[67] = function(actor)
    local t = Player.getJsonTableByVar(actor, VarCfg["T_�����յ�״̬"])
    local Condition13_1 = getflagstatus(actor, VarCfg["F_�����ܵ�_����״̬"]) == 1
    local Condition13_2 = t["����"] == 1
    local Condition13_3 = t["ʱ��"] == 1
    local Condition13_4 = t["���"] == 1
    return { Condition13_1, Condition13_2, Condition13_3 , Condition13_4}
end

GetJQChildConditions[68] = function(actor)
    local Condition1_1 = getflagstatus(actor,VarCfg["F_Ѫɫ��ŭ1"]) == 1
    local Condition1_2 = getflagstatus(actor,VarCfg["F_Ѫɫ��ŭ2"]) == 1
    return {Condition1_1, Condition1_2}
end
GetJQChildConditions[69] = function(actor)
    local Condition2_1 = getflagstatus(actor,VarCfg["F_ʱ������λ��1"]) == 1
    local Condition2_2 = getflagstatus(actor,VarCfg["F_ʱ������λ��2"]) == 1
    local Condition2_3 = getflagstatus(actor,VarCfg["F_ʱ������λ��3"]) == 1
    return {Condition2_1, Condition2_2, Condition2_3}
end
GetJQChildConditions[70] = function(actor)
    local Condition3_1 = getflagstatus(actor,VarCfg["F_�����ֻ�1"]) == 1
    local Condition3_2 = getflagstatus(actor,VarCfg["F_�����ֻ�2"]) == 1
    local Condition3_3 = getflagstatus(actor,VarCfg["F_�����ֻ�3"]) == 1
    return {Condition3_1, Condition3_2, Condition3_3}
end
GetJQChildConditions[71] = function(actor)
    local Condition4_1 = getflagstatus(actor, VarCfg["F_�������������ӡ"]) == 1
    return {Condition4_1}
end
GetJQChildConditions[72] = function(actor)
    local Condition5_1 = getflagstatus(actor,VarCfg["F_����֮���ײ㿪��״̬"]) == 1
    local Condition5_2 = getflagstatus(actor,VarCfg["F_ѧϰ��į����"]) == 1
    return {Condition5_1, Condition5_2}
end
GetJQChildConditions[73] = function(actor)
    local Condition6_1 = getflagstatus(actor,VarCfg["F_����֮�ֿ���״̬"]) == 1
    local Condition6_2 = getflagstatus(actor,VarCfg["F_����֮���ջ�һ��"]) == 1
    return {Condition6_1, Condition6_2}
end
GetJQChildConditions[74] = function(actor)
    local Condition7_1 = {getplaydef(actor, VarCfg["B_������������"]), 20}
    return {Condition7_1}
end
GetJQChildConditions[75] = function(actor)
    local data = CheckLevelIsTbl(actor)
    local Condition8_1 = {data["̰��"], 50}
    local Condition8_2 = {data["����"], 50}
    local Condition8_3 = {data["»��"], 50}
    local Condition8_4 = {data["����"], 50}
    local Condition8_5 = {data["�ƾ�"], 50}
    local Condition8_6 = {data["����"], 50}
    local Condition8_7 = {data["����"], 50}
    local Condition8_8 = getflagstatus(actor,VarCfg["F_�ǳ�����ȡ״̬"]) == 1
    return { Condition8_1, Condition8_2, Condition8_3, Condition8_4, Condition8_5, Condition8_6, Condition8_7, Condition8_8}
end
return GetJQChildConditions

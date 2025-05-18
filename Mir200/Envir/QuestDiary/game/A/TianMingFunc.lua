local TianMingFunc = {}
--�и�֮��
TianMingFunc[18] = function(actor, ...)
    if getflagstatus(actor, VarCfg["F_����_�и�֮�˱�ʶ"]) == 1 then
        local isReceive = getplaydef(actor, VarCfg["J_�����и�֮���Ƿ���ȡ"])
        if isReceive == 0 then
            local gold = math.random(10000, 1000000)
            local usreID = getbaseinfo(actor, ConstCfg.gbase.id)
            sendmail(usreID, 1, "�и�֮��", "ÿ���״ε�¼ʱ,�Զ����1-100W���,����ȡ���Ľ��!", "�󶨽��#" .. gold .. "#0")
            setplaydef(actor, VarCfg["J_�����и�֮���Ƿ���ȡ"], 1)
        end
    end
end

--���ݴ���
TianMingFunc[19] = function(actor, ...)
    delattlist(actor, "���ݴ���")
    if getflagstatus(actor, VarCfg["F_����_���ݴ��ͱ�ʶ"]) == 1 then
        local serverOpenDay = getsysvar(VarCfg["G_��������"])
        local attrValue = serverOpenDay * 5
        if attrValue >= 200 then
            attrValue = 200
        end
        addattlist(actor, "���ݴ���", "=", string.format("3#9#%d|3#10#%d", attrValue, attrValue), 1)
    end
end

--��ҹ��˵
TianMingFunc[28] = function(actor, ...)
    delattlist(actor, "��ҹ��˵")
    if getflagstatus(actor, VarCfg["F_����_��ҹ��˵��ʶ"]) == 1 then
        if checktimeInPeriod(22, 59, 7, 59) then
            addattlist(actor, "��ҹ��˵", "=",
                "3#3#160|3#4#160|3#5#160|3#6#160|3#7#160|3#8#160|3#9#160|3#10#160|3#11#160|3#12#160", 1)
        end
    end
end

--������
TianMingFunc[29] = function(actor, ...)
    delattlist(actor, "������")
    if getflagstatus(actor, VarCfg["F_����_��������ʶ"]) == 1 then
        local groupNum = getbaseinfo(actor, ConstCfg.gbase.team_num)
        if groupNum > 0 then
            addattlist(actor, "������", "=", "3#1#200|3#3#200|3#4#200|3#9#200|3#10#200", 1)
        end
    end
end

TianMingFunc[36] = function(actor, ...)
    delattlist(actor, "Խ��Խ��")
    if getflagstatus(actor, VarCfg["F_����_Խ��Խ�±�ʶ"]) == 1 then
        local tatol = getplaydef(actor, VarCfg["U_����_Խ��Խ�¹����ۼ�"])
        if tatol > 0 then
            addattlist(actor, "Խ��Խ��", "=", "3#4#" .. tatol, 1)
        end
    end
end

--ף��֮��
TianMingFunc[39] = function(actor, ...)
    local args = { ... }
    local flag = args[1]
    if flag == 1 then
        Player.setAttList(actor, "���Ը���")
    end
end

--ǿ����ʦ
TianMingFunc[40] = function(actor, ...)
    local args = { ... }
    local flag = args[1]
    if flag == 1 then
        ZhuangBeiQiangHua.SyncResponse(actor)
    end
end

--�߻���ħ
TianMingFunc[41] = function(actor, ...)
    -- release_print(getflagstatus(actor, VarCfg["F_����_�߻���ħ��ʶ"]))
    if getflagstatus(actor, VarCfg["F_����_�߻���ħ��ʶ"]) == 1 then
        local acLow = getbaseinfo(actor, ConstCfg.gbase.ac)
        local acMax = getbaseinfo(actor, ConstCfg.gbase.ac2)
        changehumability(actor, 1, -acLow, 655350)
        changehumability(actor, 2, -acMax, 655350)
    else
        local args = { ... }
        local flag = args[1]
        if flag == 1 then
            local acLow = gethumability(actor, 1)
            local acMax = gethumability(actor, 2)
            if acLow < 0 and acMax < 0 then
                changehumability(actor, 1, math.abs(acLow), 655350)
                changehumability(actor, 2, math.abs(acMax), 655350)
            end
        end
    end
end

--��������
TianMingFunc[42] = function(actor, ...)
    local args = { ... }
    local flag = args[1]
    if flag == 1 then
        Player.setAttList(actor, "���Ը���")
    end
end

--����ѧԺ
TianMingFunc[43] = function(actor, ...)
    local args = { ... }
    local flag = args[1]
    if flag == 1 then
        Player.setAttList(actor, "���Ը���")
    end
end

--̩̹֮��
TianMingFunc[44] = function(actor, ...)
    delattlist(actor, "̩̹֮��")
    if getflagstatus(actor, VarCfg["F_����_̩̹֮����ʶ"]) == 1 then
        local maxHp = getbaseinfo(actor, ConstCfg.gbase.maxhp)
        local attackNum = math.ceil(maxHp * 0.01)
        if attackNum > 10000 then
            attackNum = 10000
        end
        addattlist(actor, "̩̹֮��", "=", "3#4#" .. attackNum, 1)
    end
end

--�Ա��Ʊ�
TianMingFunc[45] = function(actor, ...)
    local args = { ... }
    local flag = args[1]
    if flag == 1 then
        Player.setAttList(actor, "���Ը���")
    end
end

--��ѡ֮��
TianMingFunc[47] = function(actor, ...)
    local args = { ... }
    local flag = args[1]
    if flag == 1 then
        clearhumcustvar(actor,VarCfg["��ѡ֮���Ƿ����"])
    end
end

--���֮��
TianMingFunc[48] = function(actor, ...)
    local args = { ... }
    local flag = args[1]
    if flag == 1 then
        setplaydef(actor, VarCfg["J_�������֮�˵�һ��"], 0)
        XingYunXiangLian.SyncResponse(actor) --��������ͬ��һ��������Ϣ
    end
end

--��Ԫ֮��
TianMingFunc[49] = function(actor, ...)
    local args = { ... }
    local flag = args[1]
    if getflagstatus(actor, VarCfg["F_����_��Ԫ֮���ʶ"]) == 1 then
        local huyuanlevel = getplaydef(actor, VarCfg["U_��Ԫ�����ȼ�"])
        if huyuanlevel >= 60 then
            if flag == 1 then
                addskill(actor, 114, 3)
                messagebox(actor, "��Ļ�Ԫ����������,��ü���[����ٵ�]!")
            end
        end
    else
        delskill(actor, 114)
        if flag == 1 then
            messagebox(actor, "����ʧ�˼���[����ٵ�]!")
        end
    end
end

--�¹�֮��
TianMingFunc[50] = function(actor, ...)
    delattlist(actor, "�¹�֮��")
    if getflagstatus(actor, VarCfg["F_����_�¹�֮����ʶ"]) == 1 then
        if checktimeInPeriod(22, 59, 7, 59) then
            addattlist(actor, "�¹�֮��", "=", "3#3#80|3#4#80|3#5#80|3#6#80|3#7#80|3#8#80|3#9#80|3#10#80|3#11#80|3#12#80", 1)
        end
    end
end

--�������
TianMingFunc[52] = function(actor, ...)
    local args = { ... }
    local flag = args[1]
    if flag == 1 then
        Player.setAttList(actor, "���Ը���")
        HunYuanGongFa.SyncResponse(actor)
    end
end
--�������
TianMingFunc[53] = function(actor, ...)
    local args = { ... }
    local flag = args[1]
    if flag == 1 then
        Player.setAttList(actor, "���Ը���")
    end
end

--Ӱ��֮��
TianMingFunc[54] = function(actor, ...)
    local args = { ... }
    local flag = args[1]
    if getflagstatus(actor, VarCfg["F_����_Ӱ��֮����ʶ"]) == 1 then
        changemode(actor, 22, 65535)
    else
        --�ֶ������ʱ�� ��ȡ������½����Ҫִ��
        if flag == 1 then
            changemode(actor, 22, 0)
        end
    end
end

--��������
TianMingFunc[55] = function(actor, ...)
    local args = { ... }
    local flag = args[1]
    if flag == 1 then
        if getflagstatus(actor, VarCfg["F_����_���������ʶ"]) == 0 then
            delattlist(actor, "��������")
        end
    end
end

--Ѫ������
TianMingFunc[56] = function(actor, ...)
    local args = { ... }
    local flag = args[1]
    if flag == 1 then
        delaygoto(actor, 2200, "xuedaolaozusubhp,1")
    else
        delaygoto(actor, 2200, "xuedaolaozusubhp,0")
    end
end

--��ѡ֮��
TianMingFunc[57] = function(actor, ...)
    local args = { ... }
    local flag = args[1]
    if flag == 1 then
        Player.setAttList(actor, "���ʸ���")
    end
end

--�鸣����
TianMingFunc[58] = function(actor, ...)
    local args = { ... }
    local flag = args[1]
    if flag == 1 then
        Player.setAttList(actor, "���Ը���")
    end
end
--δ��սʿ
TianMingFunc[59] = function(actor, ...)
    local args = { ... }
    local flag = args[1]
    if flag == 1 then
        Player.setAttList(actor, "���Ը���")
    end
end

--������
TianMingFunc[60] = function(actor, ...)
    local args = { ... }
    local flag = args[1]
    if flag == 1 then
        if getflagstatus(actor, VarCfg["F_����_��������ʶ"]) == 1 then
            -- addbuff(actor, 30083)
            Player.setAttList(actor, "��Ѫ����")
            setontimer(actor, 10, 3, 0, 1)
        else
            -- delbuff(actor, 30083)
            Player.setAttList(actor, "��Ѫ����")
            setofftimer(actor, 10)
        end
    end
end


--ԡѪ��ħ
TianMingFunc[61] = function(actor, ...)
    local args = { ... }
    local flag = args[1]
    if flag == 1 then
        Player.setAttList(actor, "���Ը���")
        Player.setAttList(actor, "��������")
    end
end

--������ɽ
TianMingFunc[62] = function(actor, ...)
    local args = { ... }
    local flag = args[1]
    if flag == 1 then
        delaygoto(actor, 1000, "budongrushangongji,1")
    else
        delaygoto(actor, 1000, "budongrushangongji,0")
    end
end

--����ת��
TianMingFunc[64] = function(actor, ...)
    local args = { ... }
    local flag = args[1]
    if flag == 1 then
        Player.setAttList(actor, "���ʸ���")
    end
end

--����Ѹ��
TianMingFunc[65] = function(actor, ...)
    local args = { ... }
    local flag = args[1]
    if flag == 1 then
        Player.setAttList(actor, "���ٸ���")
    end
end

--����ר��
TianMingFunc[66] = function(actor, ...)
    if getflagstatus(actor, VarCfg["F_����_����ר����ʶ"]) == 1 then
        setontimer(actor, 3, 8, 0, 1)
    else
        setofftimer(actor, 3)
        changehumnewvalue(actor, 21, 0, 1)
    end
end

--Ѫħ֮��
TianMingFunc[67] = function(actor, ...)
    delattlist(actor, "Ѫħ֮��")
    if getflagstatus(actor, VarCfg["F_����_Ѫħ֮����ʶ"]) == 1 then
        delaygoto(actor, 1000, "xiemozhiqufangyu")
    end
    Player.setAttList(actor, "��Ѫ����")
end

--Ѫħ֮��
TianMingFunc[227] = function(actor, ...)
    local args = { ... }
    local flag = args[1]
    if flag == 1 then
        Player.setAttList(actor, "���ٸ���")
    end
end


--��֮��
TianMingFunc[230] = function(actor, ...)
    local args = { ... }
    local flag = args[1]
    if flag == 1 then
        Player.setAttList(actor, "��������")
    end
end
--����˫��
TianMingFunc[232] = function(actor, ...)
    local args = { ... }
    local flag = args[1]
    if flag == 1 then
        Player.setAttList(actor, "���ٸ���")
    end
end

--��֮��
TianMingFunc[233] = function(actor, ...)
    if getflagstatus(actor,VarCfg["F_������֮��"]) == 1 then
        local isKangBao = getflagstatus(actor, VarCfg.F_is_open_kuangbao) --�Ƿ�����֮��
        if isKangBao == 1 then
            addattlist(actor,"��֮��","=","3#3#50|3#4#50|3#5#50|3#6#50|3#7#50|3#8#50",1)
        end
    else
        delattlist(actor,"��֮��")
    end
end
--����
TianMingFunc[234] = function(actor,...)
    if getflagstatus(actor,VarCfg["F_��������"]) == 1 then
        local h = tonumber(os.date("%H"))
        if h >= 23 and h < 9 then
            addattlist(actor,"����","=","3#207#8",1)
        else
            delattlist(actor,"����")
        end
    else
        delattlist(actor,"����")
    end
end
--����
TianMingFunc[235] = function(actor,...)
    if getflagstatus(actor,VarCfg["F_��������"]) == 1 then
        local h = tonumber(os.date("%H"))
        if h < 23 and h >= 9 then
            addattlist(actor,"����","=","3#206#8",1)
        else
            delattlist(actor,"����")
        end
    else
        delattlist(actor,"����")
    end
end
--��ɱ���i
TianMingFunc[236] = function(actor,...)
    Player.setAttList(actor, "��������")
end
--������Ȩ
TianMingFunc[237] = function(actor,...)
    if getflagstatus(actor,VarCfg["F_����������Ȩ"]) == 1 then
        if getplayguildlevel(actor) == 1 then
            addattlist(actor,"������Ȩ","=","3#221#15|3#222#15|3#223#15|3#210#15|3#211#15|3#212#15",1)
        else
            delattlist(actor,"������Ȩ")
        end
    else
        delattlist(actor,"������Ȩ")
    end
end

--������Ⱥ
TianMingFunc[239] = function(actor,...)
    if getflagstatus(actor,VarCfg["F_����������Ⱥ"]) == 1 then
        --release_print("getmyguild(actor)   " .. getmyguild(actor))
        if getmyguild(actor) == "0" then
            addattlist(actor,"������Ⱥ","=","3#28#20",1)
        else
            delattlist(actor,"������Ⱥ")
        end
    else
        delattlist(actor,"������Ⱥ")
    end
end

--����֮��
TianMingFunc[240] = function(actor,...)
    local args = { ... }
    local flag = args[1]
    if flag == 1 then
        Player.setAttList(actor, "���ٸ���")
    end
end

--��ȥ����
TianMingFunc[241] = function(actor,...)

end

--���踺��
TianMingFunc[242] = function(actor,...)
    if getflagstatus(actor,VarCfg["F_�������踺��"]) == 1 then
        if Player.GetLevel(actor) >= 160 then
            addattlist(actor,"���踺��","=","3#4#1888|3#3#1888|3#1#20000",1)
        else
            delattlist(actor,"���踺��")
        end
    else
        delattlist(actor,"���踺��")
    end
end
--ʡ�ŵ㻨
TianMingFunc[243] = function(actor,...)
    if getflagstatus(actor,VarCfg["F_����ʡ�ŵ㻨"]) == 1 then
        if querymoney(actor,1) + querymoney(actor,3) < 50000000 then
            addattlist(actor,"ʡ�ŵ㻨","=","3#28#20",1)
        else
            delattlist(actor,"ʡ�ŵ㻨")
        end
    else
        delattlist(actor,"ʡ�ŵ㻨")
    end
end

--��ȥ����
TianMingFunc[244] = function(actor,...)
    Player.setAttList(actor, "��������")
end

--�۱���
TianMingFunc[245] = function(actor,...)
    if getflagstatus(actor,VarCfg["F_�����۱���"]) == 0 then
        delattlist(actor,"�۱���")
    end
end


return TianMingFunc

AchievementTitle = {}

--�������ҷ� --�����ֹʹ��
function AchievementTitle.wonangfeifafang(actor)
    local data = {
        ["�ϸ�ţ��"] ={{Money = "�󶨽��", LL = 100000, LR = 1000000},{Money = "Ԫ��", LL = 10000, LR = 100000},{Money = "�����", LL = 10, LR = 100}},
        ["����ţ��"] ={{Money = "�󶨽��", LL = 200000, LR = 2000000},{Money = "Ԫ��", LL = 20000, LR = 200000},{Money = "�����", LL = 50, LR = 500}},
        ["��Ϯţ��"] ={{Money = "�󶨽��", LL = 300000, LR = 3000000},{Money = "Ԫ��", LL = 30000, LR = 300000},{Money = "�����", LL = 100, LR = 1000}},
        ["ţ��֮��"] ={{Money = "�󶨽��", LL = 500000, LR = 5000000},{Money = "Ԫ��", LL = 50000, LR = 500000},{Money = "�����", LL = 200, LR = 2000}},
    }
    local state = getplaydef(actor, VarCfg["Z_���ҷ���ȡ״̬"])
    if state ~= "����ȡ" then
        local DataTbl = {}
        local TitleName = ""
        for k, v in pairs(data) do
            if checktitle(actor, k) then
                DataTbl = v
                TitleName = k
                break
            end
        end
        if #DataTbl == 3 then
            local sort =  math.random(1, 3)
            local _DataTbl = DataTbl[sort]
            local MoneyNnm = math.random(_DataTbl.LL, _DataTbl.LR)
            local UserId = getconst(actor, "<$USERID>")
            sendmail(UserId, 20000, TitleName, "��ϲ��,��ȡ����ļ�Ч����[".. _DataTbl.Money.."]x".. MoneyNnm .."ö","".. _DataTbl.Money.. "#".. MoneyNnm .."")
            setplaydef(actor, VarCfg["Z_���ҷ���ȡ״̬"], "����ȡ")
        end
    end
end

local killplayTitle = {{var=1,title="��¶��â"},{var=10,title="ʮս֮��"},{var=100,title="��ս����"},{var=1000,title="ǧɱս��"}}
local killkuangbaoplayTitle = {{var=1,title="ŭն����"},{var=10,title="ʮ�ƿ���"},{var=50,title="�����糱"},{var=100,title="���ƿ�ɷ"}}
--��ɳ�������� ��ɳ����ʱ�ڻʹ��� 50/100 --���ͬ�����
local function _goCastlewarend()
    --������ڿ��
    if not checkkuafuserver() then
        local On_the_map_list = getplaycount("new0150", 0, 0)
        if On_the_map_list ~= "0" and type(On_the_map_list) == "table" then
            for _, actor in ipairs(On_the_map_list or {}) do
                if not checktitle(actor, "��������") then
                    if randomex(50,100) then
                        confertitle(actor,"��������")
                        GameEvent.push(EventCfg.onAddAchievementTitle, actor, "��������")
                    end
                end
            end
        end
    else
        local On_the_map_list = getplaycount("kuafu0150", 0, 0)
        if On_the_map_list ~= "0" and type(On_the_map_list) == "table" then
            for _, actor in ipairs(On_the_map_list or {}) do
                FKuaFuToBenFuRunScript(actor,1,"")
            end
        end
    end
end
GameEvent.add(EventCfg.goCastlewarend, _goCastlewarend, AchievementTitle)

--��������Ҵ��� -- ���Ok
local InTheCastleKillPlayerTitlb = {{var=5,title="����ն"},{var=10,title="ɳ������"}}
local function _onContinuousKillPlayer(actor, KillNum)
    --ŭն���� �ڿ�״̬��������ɱ����Ŀ�꣨10s�� 
    if checkkuafu(actor) then
        FKuaFuToBenFuRunScript(actor, 2, KillNum)
    else
        if not checktitle(actor, "ŭն����") then
            if getflagstatus(actor, VarCfg.F_is_open_kuangbao) == 1 then
                if KillNum >= 3 then
                    confertitle(actor,"ŭն����")
                    GameEvent.push(EventCfg.onAddAchievementTitle, actor, "ŭն����")
                end
            end
        end
    end
    -- ��ɳ�ڼ����� �ڻʹ��� 
    if castleinfo(5) then
        if checkkuafu(actor) then
            if FCheckMap(actor, "kuafu0150") then
                FKuaFuToBenFuRunScript(actor, 3, KillNum)
            end
        else
            if not checktitle(actor, "ɳ������") then
                if FCheckMap(actor, "new0150") then
                    local NewTitle,OldTitle = Player.getNewandOldTitle(actor,KillNum, InTheCastleKillPlayerTitlb)
                    if NewTitle == "" then return end
                    if not checktitle(actor, NewTitle) then
                        if checktitle(actor, OldTitle) then
                            deprivetitle(actor,OldTitle)
                        end
                        confertitle(actor,NewTitle) --����µĳƺ�
                        GameEvent.push(EventCfg.onAddAchievementTitle, actor, NewTitle)
                    end
                end
            end
        end
    end
end
GameEvent.add(EventCfg.onContinuousKillPlayer, _onContinuousKillPlayer, AchievementTitle)

--ɱ�˴���
local function _onkillplayQiYu(actor, hiter)
    local killplaynum1 = getplaydef(actor,VarCfg["U_��ɱ����"])
    local killplaynum2 = getplaydef(actor,VarCfg["U_��ɱ���������"])

    if not checktitle(actor, "ǧɱս��") then
        local KillNum = getplaydef(actor,VarCfg["U_ɱ����"])
        local NewTitle,OldTitle = Player.getNewandOldTitle(actor,KillNum, killplayTitle)
        if NewTitle == "" then return end
        if not checktitle(actor, NewTitle) then
            if checktitle(actor, OldTitle) then
                deprivetitle(actor,OldTitle)
            end
            confertitle(actor,NewTitle) --����µĳƺ�
            GameEvent.push(EventCfg.onAddAchievementTitle, actor, NewTitle)
        end
    end

    if killplaynum2 < 100 then
        setplaydef(actor,VarCfg["U_��ɱ���������"], killplaynum2 + 1 )
        local NewTitle,OldTitle = Player.getNewandOldTitle(actor,killplaynum2 + 1, killkuangbaoplayTitle)
        if NewTitle == "" then return end
        if not checktitle(actor, NewTitle) then
            if checktitle(actor, OldTitle) then
                deprivetitle(actor,OldTitle)
                setplaydef(actor,VarCfg["U_�񱩳ɾ�����"], 0)
            end
            confertitle(actor,NewTitle) --����µĳƺ�
            GameEvent.push(EventCfg.onAddAchievementTitle, actor, NewTitle)
        end
        if VarCfg == "ŭն����" then
            setplaydef(actor,VarCfg["U_�񱩳ɾ�����"], 1)
        elseif VarCfg == "ʮ�ƿ���" then
            setplaydef(actor,VarCfg["U_�񱩳ɾ�����"], 2)
        elseif VarCfg == "�����糱" then
            setplaydef(actor,VarCfg["U_�񱩳ɾ�����"], 3)
        elseif VarCfg == "���ƿ�ɷ" then
            setplaydef(actor,VarCfg["U_�񱩳ɾ�����"], 5)
        end
    end
end
GameEvent.add(EventCfg.onkillplayQiYu, _onkillplayQiYu, AchievementTitle)

--�������ǰ����   --�񱩳ɾ�����
local function _onAttackDamageMonster(actor, Target, Hiter, MagicId, Damage, Model, attackDamageData)
    local attnum = getplaydef(actor,VarCfg["U_�񱩳ɾ�����"])
    if attnum > 0 then
        if getflagstatus(Target, VarCfg.F_is_open_kuangbao) == 1 then
            attackDamageData.damage = attackDamageData.damage + Damage*(attnum/100)
        else
            attackDamageData.damage = attackDamageData.damage + Damage*(attnum/50)
        end
    end
    if checktitle(actor, "Ǳ����Ԩ") then
        local boolean = MagicId ~= 26 and MagicId ~= 66 and MagicId ~= 56
        if not boolean then
            attackDamageData.damage = attackDamageData.damage + Damage*0.05
        end
    end
end
GameEvent.add(EventCfg.onAttackDamageMonster, _onAttackDamageMonster, AchievementTitle)

--�������� --��Ҫ��� -- OK
local PlaydieTitle = {{var=10,title="ʮ�ٳ���"},{var=100,title="��������"},{var=300,title="���ٽ���"},{var=500,title="������˵"}}
local function _onPlaydieQiYu(actor)
    if not checktitle(actor, "������˵") then
        local dienum = getplaydef(actor,VarCfg["U_��ɱ��"])
        local NewTitle,OldTitle = Player.getNewandOldTitle(actor,dienum, PlaydieTitle)
        if NewTitle == "" then return end
        if not checktitle(actor, NewTitle) then
            if checktitle(actor, OldTitle) then
                deprivetitle(actor,OldTitle)
            end
            confertitle(actor,NewTitle) --����µĳƺ�
            GameEvent.push(EventCfg.onAddAchievementTitle, actor, NewTitle)
        end
    end
end
GameEvent.add(EventCfg.onPlaydieQiYu, _onPlaydieQiYu, AchievementTitle)

--ɳ�Ϳ���ȡʤ�������� --��Ҫ���
local CastleRewardsTitle = {{var=1,title="��ս���"},{var=5,title="��ս��ʤ"},{var=10,title="��ҫ����"}}
local function _GetCastleRewards(actor)
    local winnum = getplaydef(actor,VarCfg["U_ɳ�Ϳ�ʤ��������"])
    if winnum < 10 then
        setplaydef(actor,VarCfg["U_ɳ�Ϳ�ʤ��������"], winnum + 1 )
        local NewTitle,OldTitle = Player.getNewandOldTitle(actor,winnum + 1, CastleRewardsTitle)
        if NewTitle == "" then return end
        if not checktitle(actor, NewTitle) then
            if checktitle(actor, OldTitle) then
                deprivetitle(actor,OldTitle)
            end
            confertitle(actor,NewTitle) --����µĳƺ�
            GameEvent.push(EventCfg.onAddAchievementTitle, actor, NewTitle)
        end
    end
end
GameEvent.add(EventCfg.GetCastleRewards, _GetCastleRewards, AchievementTitle)

--�ۼƿ���10�ο�
local function _OpenKuangBao(actor)
    local opennum = getplaydef(actor,VarCfg["U_�ۼƿ�����"])
    if opennum < 10 then
        setplaydef(actor,VarCfg["U_�ۼƿ�����"], opennum + 1 )
        if opennum + 1 == 10 then
            confertitle(actor,"ŭ������")
            GameEvent.push(EventCfg.onAddAchievementTitle, actor, "ŭ������")
        end
    end
end
GameEvent.add(EventCfg.OpenKuangBao, _OpenKuangBao, AchievementTitle)

-- ɱ�ִ���   
local killMonTitle_BaiMing = {{var=100,title="׷����LV.1"},{var=300,title="׷����LV.2"},{var=500,title="׷����LV.3"},{var=1000,title="׷����LV.4"}}
local killMonTitle_HunDun = {{var=10,title="���紫˵LV.1"},{var=30,title="���紫˵LV.2"},{var=50,title="���紫˵LV.3"},{var=100,title="���紫˵LV.4"}}

local AchievementTitleMonData = include("QuestDiary/cfgcsv/cfg_AchievementTitleMonData.lua")
local function _onKillMon(actor, monobj, monName)
    if checkkuafu(actor) then
        return
    end
    --����ս 10���ڻ�ɱ10ֻ���Ϲ�����ʴ��� 1/88
    if not checktitle(actor, "����ս") then
        local buff = hasbuff(actor, 31021)
        if buff then
            local killMonNum = getplaydef(actor,VarCfg["N$����ս����"])
            setplaydef(actor,VarCfg["N$����ս����"], killMonNum+1)
            if killMonNum+1 >= 10 then
                if randomex(1, 88) then
                    confertitle(actor,"����ս")
                    Player.setAttList(actor, "���ʸ���")
                    GameEvent.push(EventCfg.onAddAchievementTitle, actor, "����ս")
                end
            end
        else
            addbuff(actor,31021,10,1,actor)
        end
    end

    --���ջ�ɱ����1800ֻ
    if not checktitle(actor, "��ݻ�") then
        local KillMonNum = getplaydef(actor,VarCfg["J_��������ɱ������"])
        if KillMonNum < 1800 then
            setplaydef(actor,VarCfg["J_��������ɱ������"], KillMonNum+1)
            if KillMonNum + 1 == 1800 then
                confertitle(actor,"��ݻ�")
                Player.setAttList(actor, "���ʸ���")
                Player.setAttList(actor, "���Ը���")
                GameEvent.push(EventCfg.onAddAchievementTitle, actor, "��ݻ�")
            end
        end
    end
    local MonName = monName
    local cfg = AchievementTitleMonData[MonName]
    if cfg then
        if cfg.Types == "��Ӣ��" then
            --��ɱ��Ӣ������ʴ���   1/1000
            if randomex(1, 1000) then
                if not checktitle(actor, "��þ��Ǿ�Ӣ") then
                    confertitle(actor,"��þ��Ǿ�Ӣ")
                    Player.setAttList(actor, "���Ը���")
                    GameEvent.push(EventCfg.onAddAchievementTitle, actor, "��þ��Ǿ�Ӣ")
                end
            end
        elseif cfg.Types == "�׹�BOSS" then
            local KillMonNum1 = getplaydef(actor,VarCfg["J_�������ջ�ɱ�׹�"])
            local KillMonNum2 = getplaydef(actor,VarCfg["U_������ɱ����BOSS"])
            --��ɱ����BOSS���ʴ��� 1/200
            if randomex(1, 200) then
                if not checktitle(actor, "���Ͼͱ�") then
                    confertitle(actor,"���Ͼͱ�")
                    Player.setAttList(actor, "���ʸ���")
                    Player.setAttList(actor, "���Ը���")
                    GameEvent.push(EventCfg.onAddAchievementTitle, actor, "���Ͼͱ�")
                end
            end
            --���ջ�ɱ�׹�500ֻ
            if not checktitle(actor, "�۹ֿ�ħ") then
                if KillMonNum1 < 500 then
                    setplaydef(actor,VarCfg["J_�������ջ�ɱ�׹�"], KillMonNum1+1)
                    if KillMonNum1 + 1 == 500 then
                        confertitle(actor,"�۹ֿ�ħ")
                        Player.setAttList(actor, "���ʸ���")
                        Player.setAttList(actor, "���Ը���")
                        GameEvent.push(EventCfg.onAddAchievementTitle, actor, "�۹ֿ�ħ")
                    end
                end
            end
            if KillMonNum2 < 1000 then
                setplaydef(actor,VarCfg["U_������ɱ����BOSS"], KillMonNum2 + 1 )
                if not checktitle(actor, "׷����LV.4") then
                    local NewTitle,OldTitle = Player.getNewandOldTitle(actor,KillMonNum2 + 1, killMonTitle_BaiMing)
                    if NewTitle == "" then return end
                    if not checktitle(actor, NewTitle) then
                        if checktitle(actor, OldTitle) then
                            deprivetitle(actor,OldTitle)
                        end
                        confertitle(actor,NewTitle) --����µĳƺ�
                        Player.setAttList(actor, "���ʸ���")
                        Player.setAttList(actor, "���Ը���")
                        GameEvent.push(EventCfg.onAddAchievementTitle, actor, NewTitle)
                    end
                end
            end
        elseif cfg.Types == "����BOSS" then
            local KillMonNum = getplaydef(actor,VarCfg["U_������ɱ����BOSS"])
            if KillMonNum < 100 then
                setplaydef(actor,VarCfg["U_������ɱ����BOSS"], KillMonNum + 1 )
                if not checktitle(actor, "���紫˵LV.4") then
                    local NewTitle,OldTitle = Player.getNewandOldTitle(actor,KillMonNum + 1, killMonTitle_HunDun)
                    if NewTitle == "" then return end
                    if not checktitle(actor, NewTitle) then
                        if checktitle(actor, OldTitle) then
                            deprivetitle(actor,OldTitle)
                        end
                        confertitle(actor,NewTitle) --����µĳƺ�
                        GameEvent.push(EventCfg.onAddAchievementTitle, actor, NewTitle)
                    end
                end
            end
            if not checktitle(actor, "��ɱ֮��") then
                local tbl =  Player.getJsonTableByVar(actor, VarCfg["T_��ɱ����BOSS"])
                local function ipairsMonTbl()
                    local _bool = true
                    for _, value in ipairs(tbl) do
                        if value == MonName then
                            _bool = false
                            break
                        end
                    end
                    return _bool
                end
                if #tbl == 0 then
                    table.insert(tbl,MonName)
                    Player.setJsonVarByTable(actor, VarCfg["T_��ɱ����BOSS"],tbl)
                elseif #tbl < 7 then
                    if ipairsMonTbl() then
                        table.insert(tbl,MonName)
                        Player.setJsonVarByTable(actor, VarCfg["T_��ɱ����BOSS"],tbl)
                    end
                end
                if #tbl == 7 then
                    confertitle(actor,"��ɱ֮��")
                    GameEvent.push(EventCfg.onAddAchievementTitle, actor, "��ɱ֮��")
                end
            end
        end
    end
end
GameEvent.add(EventCfg.onKillMon, _onKillMon, AchievementTitle)

--��ɱ��ʱbuff�����ɱ����
local function _onBuffChange(actor, buffid, groupid, model)
    if buffid == 31021 then
        if model == 4 then
            setplaydef(actor,VarCfg["N$����ս����"], 0)
        end
    end
    if buffid == 31020 then
        if model == 4 then
            setplaydef(actor,VarCfg["N$ŭն��������"], 0)
        end
    end
end
GameEvent.add(EventCfg.onBuffChange, _onBuffChange, AchievementTitle)

--ս��������ɺ󴥷�
local PowerTitle ={{var=100000,title="ս������"},{var=500000,title="ս����ʢ"},{var=1000000,title="ս��׿Ȼ"},{var=5000000,title="ս���Ƿ�"},{var=10000000,title="ս���۷�"}}
local function _OverloadPower(actor, power)
    if checkkuafu(actor) then return end
    local _power = tonumber (power)
    if not checktitle(actor, "ս���۷�") then
        local NewTitle,OldTitle = Player.getNewandOldTitle(actor,_power, PowerTitle)
        if NewTitle == "" then return end
        if not checktitle(actor, NewTitle) then
            if checktitle(actor, OldTitle) then
                deprivetitle(actor,OldTitle)
            end
            confertitle(actor,NewTitle) --����µĳƺ�
            GameEvent.push(EventCfg.onAddAchievementTitle, actor, NewTitle)
        end
    end
end
GameEvent.add(EventCfg.OverloadPower, _OverloadPower, AchievementTitle)


--�����ٶ�ˢ��
local AttackSpeedTitle = {{var=200,title="����֮ӰLV.1"},{var=300,title="����֮ӰLV.2"},{var=400,title="����֮ӰLV.3"},{var=500,title="����֮ӰLV.4"},{var=600,title="����֮ӰLV.5"}}
function qi_yu_cheng_hao_gong_su_calc(actor,attSpeed)
    attSpeed = tonumber(attSpeed) or 0
    if not checktitle(actor, "����֮ӰLV.5") then
        local NewTitle,OldTitle = Player.getNewandOldTitle(actor,attSpeed, AttackSpeedTitle)
        if NewTitle == "" then return end
        if not checktitle(actor, NewTitle) then
            if checktitle(actor, OldTitle) then
                deprivetitle(actor,OldTitle)
            end
            confertitle(actor,NewTitle) --����µĳƺ�
            GameEvent.push(EventCfg.onAddAchievementTitle, actor, NewTitle)
        end
    end
end
local function _OverloadGongSu(actor, attSpeed)
    if checkkuafu(actor) then
        return
    end
    -- release_print("�����ٶ�ˢ��",attSpeed)
    delaygoto(actor,10600,"qi_yu_cheng_hao_gong_su_calc,"..attSpeed)
    
end
GameEvent.add(EventCfg.OverloadGongSu, _OverloadGongSu, AchievementTitle)

--����ˢ��
local BaoLvTitle = {{var=200,title="������LV.1"},{var=400,title="������LV.2"},{var=800,title="������LV.3"},{var=1000,title="������LV.4"},{var=2000,title="������LV.5"}}
function qi_yu_cheng_hao_bao_lv(actor,var)
    var = tonumber(var)
    if not checktitle(actor, "������LV.5") then
        local NewTitle,OldTitle = Player.getNewandOldTitle(actor,var, BaoLvTitle)
        if NewTitle == "" then return end
        if not checktitle(actor, NewTitle) then
            if checktitle(actor, OldTitle) then
                deprivetitle(actor,OldTitle)
            end
            confertitle(actor,NewTitle) --����µĳƺ�
            Player.setAttList(actor, "���Ը���")
            GameEvent.push(EventCfg.onAddAchievementTitle, actor, NewTitle)
        end
    end
end
local function _OverloadBaoLv(actor, var)
    if checkkuafu(actor) then
        return
    end
    delaygoto(actor,10200,"qi_yu_cheng_hao_bao_lv,"..var)
end
GameEvent.add(EventCfg.OverloadBaoLv, _OverloadBaoLv, AchievementTitle)

--�ռ�װ��
local UPSkinTitle = {{var=3,title="ʱ�г���"},{var=10,title="ʱ�д���"},{var=30,title="ʱ������"},{var=50,title="ʱ�н���"}}
local function _onUPSkin(actor,var)
    if not checktitle(actor, "ʱ�н���") then
        local NewTitle,OldTitle = Player.getNewandOldTitle(actor,var, UPSkinTitle)
        if NewTitle == "" then return end
        if not checktitle(actor, NewTitle) then
            if checktitle(actor, OldTitle) then
                deprivetitle(actor,OldTitle)
            end
            confertitle(actor,NewTitle) --����µĳƺ�
            GameEvent.push(EventCfg.onAddAchievementTitle, actor, NewTitle)
        end
    end
end
GameEvent.add(EventCfg.onUPSkin, _onUPSkin, AchievementTitle)

-- ͬʱ���X��ϡ��ר��װ��
local ZhuanShuZhuangBeiTitle = {{var=3,title="ר������"},{var=5,title="ר���ղ�"},{var=10,title="ר����ʦ"},{var=20,title="ר��ר��"},{var=30,title="ר����ʦ"}}
local function SetZhuanShuZhuangBeiTitle(actor, var)
    if not checktitle(actor, "ר����ʦ") then
        local NewTitle,OldTitle = Player.getNewandOldTitle(actor,var, ZhuanShuZhuangBeiTitle)
        if NewTitle == "" then return end
        if not checktitle(actor, NewTitle) then
            if checktitle(actor, OldTitle) then
                deprivetitle(actor,OldTitle)
            end
            confertitle(actor,NewTitle) --����µĳƺ�
            GameEvent.push(EventCfg.onAddAchievementTitle, actor, NewTitle)
        end
    end
end

-- ͬʱ���X��������װ��
local ChaoShenQiZhuangBeiTitle = {{var=1,title="������ʾ"},{var=3,title="�������"},{var=6,title="�����Ժ�"},{var=10,title="�����۷�"}}
local function SetChaoShenQiZhuangBeiTitle(actor, var)
    if not checktitle(actor, "�����۷�") then
        local NewTitle,OldTitle = Player.getNewandOldTitle(actor,var, ChaoShenQiZhuangBeiTitle)
        if NewTitle == "" then return end
        if not checktitle(actor, NewTitle) then
            if checktitle(actor, OldTitle) then
                deprivetitle(actor,OldTitle)
            end
            confertitle(actor,NewTitle) --����µĳƺ�
            GameEvent.push(EventCfg.onAddAchievementTitle, actor, NewTitle)
        end
    end
end

local ZhuShuCfg = include("QuestDiary/cfgcsv/cfg_ZhuanShuZhuangBei.lua")       --ר��װ������
local ChaoShenQiCfg = include("QuestDiary/cfgcsv/cfg_ChaoShenQiZhuangBei.lua") --������װ��
--��������
local function _onTakeOnEx(actor, itemobj, where, itemname, makeid)
    local itemcfg1 = ZhuShuCfg[itemname]
    local itemcfg2 = ChaoShenQiCfg[itemname]
    if itemcfg1 then
        local num = getplaydef(actor,VarCfg["U_����ר��װ������"])
        setplaydef(actor,VarCfg["U_����ר��װ������"], num + 1)
        SetZhuanShuZhuangBeiTitle(actor, getplaydef(actor,VarCfg["U_����ר��װ������"]))
    end
    if itemcfg2 then
        local num = getplaydef(actor,VarCfg["U_����������װ������"])
        setplaydef(actor,VarCfg["U_����������װ������"], num + 1)
        SetChaoShenQiZhuangBeiTitle(actor, getplaydef(actor,VarCfg["U_����������װ������"]))
    end
end
GameEvent.add(EventCfg.onTakeOnEx, _onTakeOnEx, AchievementTitle)
--�ѵ�����
local function _onTakeOffEx(actor, itemobj, where, itemname, makeid)
    local itemcfg1 = ZhuShuCfg[itemname]
    local itemcfg2 = ChaoShenQiCfg[itemname]
    if itemcfg1 then
        local num = getplaydef(actor,VarCfg["U_����ר��װ������"])
        if num > 0 then
            setplaydef(actor,VarCfg["U_����ר��װ������"], num - 1)
        end
        SetZhuanShuZhuangBeiTitle(actor, getplaydef(actor,VarCfg["U_����ר��װ������"]))
    end
    if itemcfg2 then
        local num = getplaydef(actor,VarCfg["U_����������װ������"])
        if num > 0 then
            setplaydef(actor,VarCfg["U_����������װ������"], num - 1)
        end
        SetChaoShenQiZhuangBeiTitle(actor, getplaydef(actor,VarCfg["U_����������װ������"]))
    end
end
GameEvent.add(EventCfg.onTakeOffEx, _onTakeOffEx, AchievementTitle)

--����ۼ�
local MoneyJinBiTitle = {{var = 999999, title = "����С��"},{var = 9999999, title = "��������"},{var = 99999999, title = "��������"}}
local function _OverloadMoneyJinBi(actor, MoneyNum)
    if not checktitle(actor, "��������") then
        local NewTitle,OldTitle = Player.getNewandOldTitle(actor,MoneyNum, MoneyJinBiTitle)
        if NewTitle == "" then return end
        if not checktitle(actor, NewTitle) then
            if checktitle(actor, OldTitle) then
                deprivetitle(actor,OldTitle)
            end
            confertitle(actor,NewTitle) --����µĳƺ�
            GameEvent.push(EventCfg.onAddAchievementTitle, actor, NewTitle)
        end
    end
end
GameEvent.add(EventCfg.OverloadMoneyJinBi, _OverloadMoneyJinBi, AchievementTitle)

--Ԫ���ۼ�
local MoneyYuanBaoTitle = {{var = 99999, title = "Ԫ����Դ"},{var = 999999, title = "Ԫʢ�Ʒ�"},{var = 9999999, title = "Ԫ������"}}
local function _OverloadMoneyYuanBao(actor, MoneyNum)
    if not checktitle(actor, "Ԫ������") then
        local NewTitle,OldTitle = Player.getNewandOldTitle(actor,MoneyNum, MoneyYuanBaoTitle)
        if NewTitle == "" then return end
        if not checktitle(actor, NewTitle) then
            if checktitle(actor, OldTitle) then
                deprivetitle(actor,OldTitle)
            end
            confertitle(actor,NewTitle) --����µĳƺ�
            GameEvent.push(EventCfg.onAddAchievementTitle, actor, NewTitle)
        end
    end
end
GameEvent.add(EventCfg.OverloadMoneyYuanBao, _OverloadMoneyYuanBao, AchievementTitle)

-- ����ۼ�
local MoneyLingFuTitle = {{var = 99, title = "Ǯ;����"},{var = 999, title = "���˺�ͨ"},{var = 9999, title = "��������"}}
local function _OverloadMoneyLingFu(actor, MoneyNum)
    if not checktitle(actor, "��������") then
        local NewTitle,OldTitle = Player.getNewandOldTitle(actor,MoneyNum, MoneyLingFuTitle)
        if NewTitle == "" then return end
        if not checktitle(actor, NewTitle) then
            if checktitle(actor, OldTitle) then
                deprivetitle(actor,OldTitle)
            end
            confertitle(actor,NewTitle) --����µĳƺ�
            GameEvent.push(EventCfg.onAddAchievementTitle, actor, NewTitle)
        end
    end
end
GameEvent.add(EventCfg.OverloadMoneyLingFu, _OverloadMoneyLingFu, AchievementTitle)

--�ۼ�����
local XiaoHaoJinBiTitle = {{var = 1000000, title = "ǧ��ɢ��"},{var = 10000000, title = "�ӽ�����"},{var = 100000000, title = "һ��ǧ��"},{var = 1000000000, title = "�����ޱ�"}}
local XiaoHaoYuanBaoTitle = {{var = 100000, title = "��������"},{var = 1000000, title = "��������"},{var = 10000000, title = "�Ӻ����"}}
local XiaoHaoLingFuTitle = {{var = 1000, title = "����Ǭ��"},{var = 3000, title = "��ҫ����"},{var = 5000, title = "���Ʋ��"}}
local function _onCostMoney( actor, MoneyName, MoneyNum)
    if MoneyName == "���" then
        if not checktitle(actor, "�����ޱ�") then
            local num = getplaydef(actor,VarCfg["B_�ۼ�����_���"])
            setplaydef(actor,VarCfg["B_�ۼ�����_���"], num + MoneyNum)
            local NewTitle,OldTitle = Player.getNewandOldTitle(actor,num + MoneyNum, XiaoHaoJinBiTitle)
            if NewTitle == "" then return end
            if not checktitle(actor, NewTitle) then
                if checktitle(actor, OldTitle) then
                    deprivetitle(actor,OldTitle)
                end
                confertitle(actor,NewTitle) --����µĳƺ�
                GameEvent.push(EventCfg.onAddAchievementTitle, actor, NewTitle)
            end
        end
    elseif MoneyName == "Ԫ��" then
        if not checktitle(actor, "�Ӻ����") then
            local num = getplaydef(actor,VarCfg["B_�ۼ�����_Ԫ��"])
            setplaydef(actor,VarCfg["B_�ۼ�����_Ԫ��"],num + MoneyNum)
            local NewTitle,OldTitle = Player.getNewandOldTitle(actor,num + MoneyNum, XiaoHaoYuanBaoTitle)
            if NewTitle == "" then return end
            if not checktitle(actor, NewTitle) then
                if checktitle(actor, OldTitle) then
                    deprivetitle(actor,OldTitle)
                end
                confertitle(actor,NewTitle) --����µĳƺ�
                GameEvent.push(EventCfg.onAddAchievementTitle, actor, NewTitle)
            end
        end
    elseif MoneyName == "���" then
        if not checktitle(actor, "���Ʋ��") then
            local num = getplaydef(actor,VarCfg["B_�ۼ�����_���"])
            setplaydef(actor,VarCfg["B_�ۼ�����_���"],num + MoneyNum)
            local NewTitle,OldTitle = Player.getNewandOldTitle(actor,num + MoneyNum, XiaoHaoLingFuTitle)
            if NewTitle == "" then return end
            if not checktitle(actor, NewTitle) then
                if checktitle(actor, OldTitle) then
                    deprivetitle(actor,OldTitle)
                end
                confertitle(actor,NewTitle) --����µĳƺ�
                GameEvent.push(EventCfg.onAddAchievementTitle, actor, NewTitle)
            end
        end
    end
end
GameEvent.add(EventCfg.onCostMoney, _onCostMoney, AchievementTitle)

--�������
local HuiShouJinBiTitle = {{var = 100000, title = "ʰ���е�"},{var = 1000000, title = "�۲Ƴ�ɽ"},{var = 10000000, title = "���վ��"}}
local HuiShouLingShiTitle = {{var = 50, title = "��ʯʰ��"},{var = 500, title = "��ʯ�۲�"},{var = 2000, title = "��ʯ��ʦ"},{var = 5000, title = "��ʯ�޽�"}}
local HuiShouShuiJingTitle = {{var = 50, title = "��������"},{var = 500, title = "�����ۻ�"},{var = 5000, title = "����ǧ��"},{var = 10000, title = "������"}}
local function _onHuiShouFinish(actor, giveArray)
    for _, Item in ipairs(giveArray) do
        local ItemName, ItemNumber = Item[1], Item[2]
        if ItemName == "���" then
            if not checktitle(actor, "���վ��") then
                local num = getplaydef(actor,VarCfg["B_�ۼƻ���_���"])
                setplaydef(actor,VarCfg["B_�ۼƻ���_���"],num + ItemNumber)
                local NewTitle,OldTitle = Player.getNewandOldTitle(actor,num + ItemNumber,HuiShouJinBiTitle)
                if NewTitle == "" then return end
                if not checktitle(actor, NewTitle) then
                    if checktitle(actor, OldTitle) then
                        deprivetitle(actor,OldTitle)
                    end
                    confertitle(actor,NewTitle) --����µĳƺ�
                    GameEvent.push(EventCfg.onAddAchievementTitle, actor, NewTitle)
                end
            end
        elseif ItemName == "��ʯ" then
            if not checktitle(actor, "��ʯ�޽�") then
                local num = getplaydef(actor,VarCfg["B_�ۼƻ���_��ʯ"])
                setplaydef(actor,VarCfg["B_�ۼƻ���_��ʯ"],num + ItemNumber)
                local NewTitle,OldTitle = Player.getNewandOldTitle(actor,num + ItemNumber,HuiShouLingShiTitle)
                if NewTitle == "" then return end
                if not checktitle(actor, NewTitle) then
                    if checktitle(actor, OldTitle) then
                        deprivetitle(actor,OldTitle)
                    end
                    confertitle(actor,NewTitle) --����µĳƺ�
                    GameEvent.push(EventCfg.onAddAchievementTitle, actor, NewTitle)
                end
            end
        elseif ItemName == "����ˮ��" then
            if not checktitle(actor, "������") then
                local num = getplaydef(actor,VarCfg["B_�ۼƻ���_����ˮ��"])
                setplaydef(actor,VarCfg["B_�ۼƻ���_����ˮ��"],num + ItemNumber)
                local NewTitle,OldTitle = Player.getNewandOldTitle(actor,num + ItemNumber,HuiShouShuiJingTitle)
                if NewTitle == "" then return end
                if not checktitle(actor, NewTitle) then
                    if checktitle(actor, OldTitle) then
                        deprivetitle(actor,OldTitle)
                    end
                    confertitle(actor,NewTitle) --����µĳƺ�
                    GameEvent.push(EventCfg.onAddAchievementTitle, actor, NewTitle)
                end
            end
        end
    end
end
GameEvent.add(EventCfg.onHuiShouFinish, _onHuiShouFinish, AchievementTitle)

--��������Ǳ�ܴ���
local JiXianQianNengTitle = {{var = 10, title = "Ǳ�ܳ���"},{var = 30, title = "Ǳ��ӿ��"},{var = 50, title = "Ǳ�ܾ���"},{var = 100, title = "Ǳ�ܼ���"}}
local function _onOpenJiXianQianNeng(actor, num)
    -- release_print("��������Ǳ�ܴ���", num)
    if not checktitle(actor, "Ǳ�ܼ���") then
        local NewTitle,OldTitle = Player.getNewandOldTitle(actor,num,JiXianQianNengTitle)
        if NewTitle == "" then return end
        if not checktitle(actor, NewTitle) then
            if checktitle(actor, OldTitle) then
                deprivetitle(actor,OldTitle)
            end
            confertitle(actor,NewTitle) --����µĳƺ�
            GameEvent.push(EventCfg.onAddAchievementTitle, actor, NewTitle)
        end
    end
end
GameEvent.add(EventCfg.onOpenJiXianQianNeng, _onOpenJiXianQianNeng, AchievementTitle)

--ʹ�ü���ʯ���ʴ���
local function _onUseJiLuShi(actor)
    if not checktitle(actor, "����ʶ;") then
        if randomex(1, 100) then
            confertitle(actor,"����ʶ;")
            Player.setAttList(actor, "���ʸ���")
            GameEvent.push(EventCfg.onAddAchievementTitle, actor, "����ʶ;")
        end
    end
end
GameEvent.add(EventCfg.onUseJiLuShi, _onUseJiLuShi, AchievementTitle)

--�����ͼ���ʴ���
local function _goEnterMap(actor, cur_mapid)
    --�ڿ�������������ĺ�
    if checkkuafu(actor) then
        return
    end
    if not checktitle(actor, "�����ĺ�") then
        if randomex(1, 100) then
            confertitle(actor,"�����ĺ�")
            Player.setAttList(actor, "���ʸ���")
            GameEvent.push(EventCfg.onAddAchievementTitle, actor, "�����ĺ�")
        end
    end
end
GameEvent.add(EventCfg.goEnterMap, _goEnterMap, AchievementTitle)

--�ۼƽ��븱������
local JinRuFuBenTitle = {{var = 10, title = "������϶"},{var = 20, title = "��϶̽����"},{var = 30, title = "��϶������"}}
local function _onEntetMirrorMap(actor)
    if not checktitle(actor, "��϶������") then
        local num = getplaydef(actor,VarCfg["U_�ۼƽ��븱��"])
        setplaydef(actor,VarCfg["U_�ۼƽ��븱��"],num + 1)
        local NewTitle,OldTitle = Player.getNewandOldTitle(actor,num + 1,JinRuFuBenTitle)
        if NewTitle == "" then return end
        if not checktitle(actor, NewTitle) then
            if checktitle(actor, OldTitle) then
                deprivetitle(actor,OldTitle)
            end
            confertitle(actor,NewTitle) --����µĳƺ�
            GameEvent.push(EventCfg.onAddAchievementTitle, actor, NewTitle)
        end
    end
end
GameEvent.add(EventCfg.onEntetMirrorMap, _onEntetMirrorMap, AchievementTitle)

--���������˹��������ʴ���
local function _onYunYouShangRneBuy(actor)
    if not checktitle(actor, "·��̯") then
        if randomex(1, 100) then
            confertitle(actor,"·��̯")
            GameEvent.push(EventCfg.onAddAchievementTitle, actor, "·��̯")
        end
    end
end
GameEvent.add(EventCfg.onYunYouShangRneBuy, _onYunYouShangRneBuy, AchievementTitle)

--�ں������˹��������ʴ���
local function _onHeiShiShangRneBuy(actor)
    if not checktitle(actor, "������Ե") then
        if randomex(1, 100) then
            confertitle(actor,"������Ե")
            GameEvent.push(EventCfg.onAddAchievementTitle, actor, "������Ե")
        end
    end
end
GameEvent.add(EventCfg.onHeiShiShangRneBuy, _onHeiShiShangRneBuy, AchievementTitle)

--��Ǯׯ�ϰ幺�������ʴ���
local function _onQianZhuangLaoBanBuy(actor)
    if not checktitle(actor, "��������") then
        if randomex(1, 100) then
            confertitle(actor,"��������")
            GameEvent.push(EventCfg.onAddAchievementTitle, actor, "��������")
        end
    end
end
GameEvent.add(EventCfg.onQianZhuangLaoBanBuy, _onQianZhuangLaoBanBuy, AchievementTitle)

--����װ��ϴ����������
local function _onZhuangBeiXiLian(actor,setLevel)
    if setLevel ~= 5 then return end
    if not checktitle(actor, "�������") then
        confertitle(actor,"�������")
        GameEvent.push(EventCfg.onAddAchievementTitle, actor, "�������")
    end
end
GameEvent.add(EventCfg.onZhuangBeiXiLian, _onZhuangBeiXiLian, AchievementTitle)

--���ɾ���ﵽǱ���� 
local function _onXiuXianUP(actor,itemname)
    if itemname ~= "Ǳ������ʯ" then return end
    if not checktitle(actor, "Ǳ����Ԩ") then
        confertitle(actor,"Ǳ����Ԩ")
        GameEvent.push(EventCfg.onAddAchievementTitle, actor, "Ǳ����Ԩ")
    end
end
GameEvent.add(EventCfg.onXiuXianUP, _onXiuXianUP, AchievementTitle)

--ɱ¾��ӡ�ﵽ����
local function _onShaLuKeYinMax(actor)
    if not checktitle(actor, "ɱ¾֮��") then
        confertitle(actor,"ɱ¾֮��")
        GameEvent.push(EventCfg.onAddAchievementTitle, actor, "ɱ¾֮��")
    end
end
GameEvent.add(EventCfg.onShaLuKeYinMax, _onShaLuKeYinMax, AchievementTitle)

--������
local function _onTeQuankaiTong(actor)
    if not checktitle(actor, "������") then
        confertitle(actor,"������")
        GameEvent.push(EventCfg.onAddAchievementTitle, actor, "������")
    end
end
GameEvent.add(EventCfg.onTeQuankaiTong, _onTeQuankaiTong, AchievementTitle)

--ɱ¾��ӡ�ﵽ����
local function _onJiFengKeYinMax(actor)
    if not checktitle(actor, "����֮��") then
        confertitle(actor,"����֮��")
        Player.setAttList(actor, "���ٸ���")
        GameEvent.push(EventCfg.onAddAchievementTitle, actor, "����֮��")
    end
end
GameEvent.add(EventCfg.onJiFengKeYinMax, _onJiFengKeYinMax, AchievementTitle)

-- ��ֵ��ɴ���
local ChongZhiTitle = {{var = 2000, title = "С�ֱ��ռ�"},{var = 5000, title = "������̽����"}}
local function _onRechargeEnd(actor, gold, productid, moneyid)
    if not checktitle(actor, "������̽����") then
        local LeiJiChongZhi = getplaydef(actor, VarCfg["U_��ʵ��ֵ"])
        -- release_print("��ֵ��",LeiJiChongZhi)
        local NewTitle,OldTitle = Player.getNewandOldTitle(actor,LeiJiChongZhi, ChongZhiTitle)
        if NewTitle == "" then return end
        if not checktitle(actor, NewTitle) then
            if checktitle(actor, OldTitle) then
                deprivetitle(actor,OldTitle)
            end
            confertitle(actor,NewTitle) --����µĳƺ�
            GameEvent.push(EventCfg.onAddAchievementTitle, actor, NewTitle)
        end
    end
end
GameEvent.add(EventCfg.onRechargeEnd, _onRechargeEnd, AchievementTitle)

--���繥���ٶ�
local function _onCalcAttackSpeed(actor, attackSpeeds)
    if checktitle(actor,"����֮��") then
        attackSpeeds[1] = attackSpeeds[1] + 10
    end
end
GameEvent.add(EventCfg.onCalcAttackSpeed, _onCalcAttackSpeed, AchievementTitle)

--������¼����
local LogDayNumTitle = {{var = 3, title = "�½�����"},{var = 5, title = "�������"},{var = 10, title = "��ү��������"}}
function qi_yu_cheng_hao_login_delay(actor)
    -------------------------------------------���ҷϷ���-------------------------------------------
    AchievementTitle.wonangfeifafang(actor)
    -------------------------------------------���ҷϷ���-------------------------------------------

    local T_PlayerDayNum = (getplaydef(actor,VarCfg["T_������¼��֤"]) == "" and 0) or getplaydef(actor,VarCfg["T_������¼��֤"])
    T_PlayerDayNum = tonumber(T_PlayerDayNum)
    local U_PlayerDayNum = getplaydef(actor,VarCfg["U_������¼����"])
    local SystemDayNum = getsysvar(VarCfg["G_��������"])
    if T_PlayerDayNum == SystemDayNum then  return end
    if T_PlayerDayNum+1 == SystemDayNum then
        setplaydef(actor,VarCfg["U_������¼����"], U_PlayerDayNum + 1)
        setplaydef(actor,VarCfg["T_������¼��֤"],SystemDayNum)
    else
        setplaydef(actor,VarCfg["U_������¼����"], 1)
        setplaydef(actor,VarCfg["T_������¼��֤"],SystemDayNum)
    end

    local PlayerDayNum = getplaydef(actor,VarCfg["U_������¼����"])
    -- release_print("������¼��"..PlayerDayNum.."��")

    if not checktitle(actor, "��ү��������") then
        local NewTitle,OldTitle = Player.getNewandOldTitle(actor,PlayerDayNum,LogDayNumTitle)
        if NewTitle == "" then return end
        if not checktitle(actor, NewTitle) then
            if checktitle(actor, OldTitle) then
                deprivetitle(actor,OldTitle)
            end
            confertitle(actor,NewTitle) --����µĳƺ�
            GameEvent.push(EventCfg.onAddAchievementTitle, actor, NewTitle)
        end
    end
end

local function _onLoginEnd(actor)
    delaygoto(actor,10400,"qi_yu_cheng_hao_login_delay")
end
GameEvent.add(EventCfg.onLoginEnd, _onLoginEnd, AchievementTitle)

--�鿴����װ��
local MyLookTitle = {{var = 10, title = "װ���۲�Ա"},{var = 50, title = "װ������ʦ"}}
local function _Myonlookhuminfo(actor, Target)
    if actor == nil or Target == nil then return end
    if not checktitle(actor, "װ������ʦ") then
        local TgtObj = getplaydef(actor, VarCfg["T_�鿴����BOJ"])
        if TgtObj ~= Target then
            local PlayerNum = getplaydef(actor,VarCfg["U_�鿴���˴���"])
            setplaydef(actor,VarCfg["U_�鿴���˴���"], PlayerNum + 1)
            local NewTitle,OldTitle = Player.getNewandOldTitle(actor,PlayerNum + 1 ,MyLookTitle)
            if NewTitle == "" then return end
            if not checktitle(actor, NewTitle) then
                if checktitle(actor, OldTitle) then
                    deprivetitle(actor,OldTitle)
                end
                confertitle(actor,NewTitle) --����µĳƺ�
                GameEvent.push(EventCfg.onAddAchievementTitle, actor, NewTitle)
            end
        end
    end
end
GameEvent.add(EventCfg.Myonlookhuminfo, _Myonlookhuminfo, AchievementTitle)

--�����˲鿴װ��
local TgtLookTitle = {{var = 10, title = "����֮��"},{var = 50, title = "������Ŀ"},{var = 100, title = "����ż��"}}
local function _Tgtonlookhuminfo(actor, Target)
    if actor == nil or Target == nil then return end
    local _TgtInfo = getplaydef(Target,VarCfg["T_�鿴װ�������"])
    --ͬʱ�����˲鿴װ�� 
    if Target ~= _TgtInfo then
        if not checktitle(actor, "��Χ��") then
            local buff = hasbuff(actor, 31029)
            if buff then
                setplaydef(actor,VarCfg["T_�鿴װ�������"], Target)
                local PlayerNum = getplaydef(actor,VarCfg["N$�����鿴װ������"])
                setplaydef(actor,VarCfg["N$�����鿴װ������"], PlayerNum + 1)
                if PlayerNum + 1 >= 3 then
                    confertitle(actor,"��Χ��")
                    GameEvent.push(EventCfg.onAddAchievementTitle, actor, "��Χ��")
                end
            else
                addbuff(actor,31029,10)
                setplaydef(actor,VarCfg["N$�����鿴װ������"], 1)
            end
        end
    end

    if not checktitle(actor, "����ż��") then
        local TgtObj = getplaydef(actor, VarCfg["T_���˲鿴BOJ"])
        if TgtObj ~= Target then
            local PlayerNum = getplaydef(actor,VarCfg["U_���˲鿴����"])
            setplaydef(actor,VarCfg["U_���˲鿴����"], PlayerNum + 1)
            local NewTitle,OldTitle = Player.getNewandOldTitle(actor,PlayerNum + 1 ,TgtLookTitle)
            if NewTitle == "" then return end
            if not checktitle(actor, NewTitle) then
                if checktitle(actor, OldTitle) then
                    deprivetitle(actor,OldTitle)
                end
                confertitle(actor,NewTitle) --����µĳƺ�
                GameEvent.push(EventCfg.onAddAchievementTitle, actor, NewTitle)
            end
        end
    end
end
GameEvent.add(EventCfg.Tgtonlookhuminfo, _Tgtonlookhuminfo, AchievementTitle)

--ʹ�ø������󴥷�
local function _onUseGaiMingKa(actor)
    if not checktitle(actor, "��������") then
        if randomex(1,3) then
            confertitle(actor,"��������")
            GameEvent.push(EventCfg.onAddAchievementTitle, actor, "��������")
        end
    end
end
GameEvent.add(EventCfg.onUseGaiMingKa, _onUseGaiMingKa, AchievementTitle)

--ʹ�ú�����ϴ����ʴ���
local function _onUseHongMingQingXiKa(actor)
    if not checktitle(actor, "ϴ�ĸ���") then
        if randomex(1,10) then
            confertitle(actor,"ϴ�ĸ���")
            GameEvent.push(EventCfg.onAddAchievementTitle, actor, "ϴ�ĸ���")
        end
    end
end
GameEvent.add(EventCfg.onUseHongMingQingXiKa, _onUseHongMingQingXiKa, AchievementTitle)

--������װ��������
local DropUseItemsTitle = {{var = 3, title = "��װ����"},{var = 10, title = "ɢ�ƴ���"},{var = 30, title = "�ܼ���ʦ"}}
local function _onCheckDropUseItems(actor, arg1)
    if not checktitle(actor, "�ܼ���ʦ") then
        local num = getplaydef(actor,VarCfg["U_������װ����"])
        setplaydef(actor,VarCfg["U_������װ����"], num + 1)
        -- release_print("������װ����"..num+1)
        local NewTitle,OldTitle = Player.getNewandOldTitle(actor,num + 1 ,DropUseItemsTitle)
        if NewTitle == "" then return end
        if not checktitle(actor, NewTitle) then
            if checktitle(actor, OldTitle) then
                deprivetitle(actor,OldTitle)
            end
            confertitle(actor,NewTitle) --����µĳƺ�
            GameEvent.push(EventCfg.onAddAchievementTitle, actor, NewTitle)
        end
    end
end
GameEvent.add(EventCfg.onCheckDropUseItems, _onCheckDropUseItems, AchievementTitle)


--��������ƺŴ���
local JiHuoTitleNum = {{var = 10, title = "�ϸ�ţ��"},{var = 30, title = "����ţ��"},{var = 80, title = "��Ϯţ��"},{var = 120, title = "ţ��֮��"}}
local Title_Data = include("QuestDiary/cfgcsv/cfg_TitleNumData.lua") --�ɾ�����
local function _onAddAchievementTitle(actor, TitleName)
    ------------------------------------------------------����µĳƺ�------------------------------------------------------
    local PlayerName = getbaseinfo(actor, ConstCfg.gbase.name)
    sendmsgnew(actor,250,0,"{�����ɾ�:/FCOLOR=251}��ϲ���{".. PlayerName .."/FCOLOR=254}������������,���{".. TitleName .."/FCOLOR=254}�ƺ�...",0,1)
    sendmsgnew(actor,250,0,"{�����ɾ�:/FCOLOR=251}��ϲ���{".. PlayerName .."/FCOLOR=254}������������,���{".. TitleName .."/FCOLOR=254}�ƺ�...",0,1)
    scenevibration(actor,0,2,2)
    messagebox(actor,"�����ɾ�\\��ϲ����[".. TitleName .."]�ƺ�..")
    ------------------------------------------------------����µĳƺ�------------------------------------------------------
    local TitleNum = 0
    for k, v in pairs(Title_Data) do
        if checktitle(actor, k) then
            TitleNum = TitleNum + v.Num
        end
    end
    local NewTitle,OldTitle = Player.getNewandOldTitle(actor,TitleNum,JiHuoTitleNum)
    if NewTitle == "" then return end
    if not checktitle(actor, NewTitle) then
        if checktitle(actor, OldTitle) then
            deprivetitle(actor,OldTitle)
        end
        confertitle(actor,NewTitle) --����µĳƺ�
        Player.setAttList(actor, "���ʸ���")
        -------------------------------------------���ҷϷ���-------------------------------------------
        if NewTitle == "�ϸ�ţ��" then AchievementTitle.wonangfeifafang(actor) end
        -------------------------------------------���ҷϷ���-------------------------------------------
        GameEvent.push(EventCfg.onAddAchievementTitle, actor, NewTitle)
    end
end
GameEvent.add(EventCfg.onAddAchievementTitle, _onAddAchievementTitle, AchievementTitle)

--�µ�һ��  ţ��ƺŷ������ҷ�
local function _onNewDay(actor)
    AchievementTitle.wonangfeifafang(actor)
end
GameEvent.add(EventCfg.onNewDay, _onNewDay, AchievementTitle)

return AchievementTitle

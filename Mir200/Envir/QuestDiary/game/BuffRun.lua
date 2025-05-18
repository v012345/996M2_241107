--���з籩
function buff_lirenfengbao(actor, buffId, buffGroup)
    local x = getbaseinfo(actor, ConstCfg.gbase.x)
    local y = getbaseinfo(actor, ConstCfg.gbase.y)
    local myMaxAttackNum = getbaseinfo(actor, ConstCfg.gbase.dc2)
    rangeharm(actor, x, y, 3, myMaxAttackNum, 0, 0, 0, 2)
end

--����ξ�
function buff_mengjingfeicui(actor, buffId, buffGroup)
    local x = getbaseinfo(actor, ConstCfg.gbase.x)
    local y = getbaseinfo(actor, ConstCfg.gbase.y)
    local mapId = getbaseinfo(actor, ConstCfg.gbase.mapid)
    local obj = getobjectinmap(mapId, x, y, 3, 1)
    for _, value in ipairs(obj) do
        local isGuild = getIsGuildMember(actor, value)
        local isGroup = getIsGroupMember(actor, value)
        if isGroup or isGuild then
            humanhp(value, "+", Player.getHpValue(value, 3), 4)
            -- Player.buffTipsMsg(value, "[�ξ����]:�л��Ա����ӳ�Ա�������ξ����,�ָ�3%������ֵ!")
        end
    end
end

function buff_yongshenglingti(actor, buffId, buffGroup)
    local hpPer = Player.getHpPercentage(actor)
    if hpPer > 30 then
        FkfDelBuff(actor, 30079)
    end
end

--�׵������
function buff_leidianbalianji(actor, buffId, buffGroup)
    local num = getplaydef(actor, VarCfg["N$�׵������"])
    local dcmax = getbaseinfo(actor, ConstCfg.gbase.dc2)
    local Damage = dcmax * (0.2 + 0.1 * num)
    humanhp(actor, "-", Damage, 4)
    playeffect(actor, 56, 0, 0, 1, 0, 0)
    setplaydef(actor, VarCfg["N$�׵������"], num + 1)
end
--����Դ��
--����ԪӤ״̬
function buff_qitiliuyuan(actor, buffId, buffGroup)
    if getflagstatus(actor, VarCfg["F_����_����Դ����ʶ"]) == 1 then
        -- Player.buffTipsMsg(actor, "�����ԪӤ״̬!!!!!")
        if checkkuafu(actor) then
            FAddBuffBF(actor, 30099, 5)
        else
            addbuff(actor, 30099)
        end
    else
        FkfDelBuff(actor, 30098)
    end
end

--������  ÿ��(60S)����[10%]����󹥻���(Ч������20��)
function buff_sishenjianglin(actor, buffId, buffGroup)
    changehumnewvalue(actor, 210, 10, 20)
end

--���Ľ���  ÿ3���ܵ�1���׻�\ÿ���׻��۳�20%����\�׷�Ч������9��
function buff_tianjiedejiangfa(actor, buffId, buffGroup)
    humanhp(actor, "-", Player.getHpValue(actor, 20), 1) --����նѪ20%
    playeffect(actor, 56, 0, 0, 1, 0, 0)
end

--����Ǳ�� 1s���� 100 Ԫ��
function buff_julongjuexing1(actor, buffId, buffGroup)
    local falg = getflagstatus(actor,VarCfg["F_�ռ�ʱװ��ʶ"])
    local falg2 = getflagstatus(actor,VarCfg["F_�ռ�ʱװ��ʶ1"])
    local falg3 = getflagstatus(actor,VarCfg["F_�ռ�ʱװ��ʶ2"])
    local money = 100
    if falg == 1 or falg2 == 1 or falg3 == 1 then
        money = 50
    else
        money = 100
    end
    if querymoney(actor, 2) >= money then
        changemoney(actor, 2, "-", money, "�۳�Ԫ��", true)
    else
        FkfDelBuff(actor, 31023)
        delattlist(actor, "����Ǳ��") --������
        setplaydef(actor, VarCfg["N$����Ǳ�ܿ���"], 0)
        local data = { getplaydef(actor, VarCfg["N$����Ǳ�ܿ���"]) }
        Message.sendmsg(actor, ssrNetMsgCfg.TopIcon_UpdateIcon, 0, 0, 0, data)
    end
end

--����Ǳ�� 1s���� 300 Ԫ��
function buff_julongjuexing2(actor, buffId, buffGroup)
    local falg = getflagstatus(actor,VarCfg["F_�ռ�ʱװ��ʶ"])
    local falg2 = getflagstatus(actor,VarCfg["F_�ռ�ʱװ��ʶ1"])
    local falg3 = getflagstatus(actor,VarCfg["F_�ռ�ʱװ��ʶ2"])
    local money = 300
    if falg == 1 or falg2 == 1 or falg3 == 1 then
        money = 150
    else
        money = 300
    end
    if querymoney(actor, 2) >= money then
        changemoney(actor, 2, "-", money, "�۳�Ԫ��", true)
    else
        FkfDelBuff(actor, 31024)
        delattlist(actor, "����Ǳ��") --������
        setplaydef(actor, VarCfg["N$����Ǳ�ܿ���"], 0)
        local data = { getplaydef(actor, VarCfg["N$����Ǳ�ܿ���"]) }
        Message.sendmsg(actor, ssrNetMsgCfg.TopIcon_UpdateIcon, 0, 0, 0, data)
    end
end

--����Ǳ�� 1s���� 600 Ԫ��
function buff_julongjuexing3(actor, buffId, buffGroup)
    local falg = getflagstatus(actor,VarCfg["F_�ռ�ʱװ��ʶ"])
    local falg2 = getflagstatus(actor,VarCfg["F_�ռ�ʱװ��ʶ1"])
    local falg3 = getflagstatus(actor,VarCfg["F_�ռ�ʱװ��ʶ2"])
    local money = 600
    if falg == 1 or falg2 == 1 or falg3 == 1 then
        money = 300
    else
        money = 600
    end
    if querymoney(actor, 2) >= money then
        changemoney(actor, 2, "-", money, "�۳�Ԫ��", true)
    else
        FkfDelBuff(actor, 31025)
        delattlist(actor, "����Ǳ��") --������
        setplaydef(actor, VarCfg["N$����Ǳ�ܿ���"], 0)
        local data = { getplaydef(actor, VarCfg["N$����Ǳ�ܿ���"]) }
        Message.sendmsg(actor, ssrNetMsgCfg.TopIcon_UpdateIcon, 0, 0, 0, data)
    end
end

--����Ǳ�� 1s���� 900 Ԫ��
function buff_julongjuexing4(actor, buffId, buffGroup)
    local falg = getflagstatus(actor,VarCfg["F_�ռ�ʱװ��ʶ"])
    local falg2 = getflagstatus(actor,VarCfg["F_�ռ�ʱװ��ʶ1"])
    local falg3 = getflagstatus(actor,VarCfg["F_�ռ�ʱװ��ʶ2"])
    local money = 900
    if falg == 1 or falg2 == 1 or falg3 == 1 then
        money = 450
    else
        money = 900
    end
    if querymoney(actor, 2) >= money then
        changemoney(actor, 2, "-", money, "�۳�Ԫ��", true)
    else
        FkfDelBuff(actor, 31026)
        delattlist(actor, "����Ǳ��") --������
        setplaydef(actor, VarCfg["N$����Ǳ�ܿ���"], 0)
        local data = { getplaydef(actor, VarCfg["N$����Ǳ�ܿ���"]) }
        Message.sendmsg(actor, ssrNetMsgCfg.TopIcon_UpdateIcon, 0, 0, 0, data)
    end
end

--����Ǳ�� 1s���� 1200 Ԫ��
function buff_julongjuexing5(actor, buffId, buffGroup)
    local falg = getflagstatus(actor,VarCfg["F_�ռ�ʱװ��ʶ"])
    local falg2 = getflagstatus(actor,VarCfg["F_�ռ�ʱװ��ʶ1"])
    local falg3 = getflagstatus(actor,VarCfg["F_�ռ�ʱװ��ʶ2"])
    local money = 1200
    if falg == 1 or falg2 == 1 or falg3 == 1 then
        money = 600
    else
        money = 1200
    end
    if querymoney(actor, 2) >= money then
        changemoney(actor, 2, "-", money, "�۳�Ԫ��", true)
    else
        FkfDelBuff(actor, 31027)
        delattlist(actor, "����Ǳ��") --������
        setplaydef(actor, VarCfg["N$����Ǳ�ܿ���"], 0)
        local data = { getplaydef(actor, VarCfg["N$����Ǳ�ܿ���"]) }
        Message.sendmsg(actor, ssrNetMsgCfg.TopIcon_UpdateIcon, 0, 0, 0, data)
    end
end

--������
function buff_fengxingzhe(actor, buffId, buffGroup)
    throughhum(actor, 3, 5, 0) --���˴���
    changespeedex(actor,1,5,5) --�ƶ��ٶ�
end

-- ����������
local itemdata = include("QuestDiary/cfgcsv/cfg_XiuXianFaBaoData.lua") --��������
function buff_wan_xiang_lei_ting_jie(actor, buffId, buffGroup)
    local level = getplaydef(actor, VarCfg["U_���ɵȼ�"])
    local cfg = itemdata[level]
    local qieGe = getbaseinfo(actor, ConstCfg.gbase.custom_attr, 200)
    local damage = math.floor(qieGe * (cfg.effect2 / 100))
    local x = getbaseinfo(actor, ConstCfg.gbase.x)
    local y = getbaseinfo(actor, ConstCfg.gbase.y)
    playeffect(actor, 55022, 0, 0, 1, 0, 0)
    playeffect(actor, 55024, 0, 0, 1, 0, 0)
    rangeharm(actor, x, y, 3, damage, 0, 0, 0, 2)
end

--�ٻ������ʹ�
function buff_shu_chong_pu_cong_zhao_huan(actor, buffId, buffGroup)
    local MapID = getbaseinfo(actor, ConstCfg.gbase.mapid)
    local CheckMap = MapID ~= "n3" and  MapID ~= "new0150"
    if CheckMap then
        local ncount  =getbaseinfo(actor,38)
        if ncount < 5 then
            recallmob(actor,"�����ʹ�",7,30,0,0,0)
        end
    end
end

--�ս��� ÿ9������һ���ػ�״̬
function buff_an_hei_zhong_ji(actor, buffId, buffGroup)
    if getplaydef(actor, VarCfg["S$_�ս���"]) == "" then
        setplaydef(actor, VarCfg["S$_�ս���"],"���ͷ�")
    end
end

--��������  ÿ������2��
function buff_yun_you_tian_xia(actor, buffId, buffGroup)
    local BuffNum = getbuffinfo(actor, 31065, 1)
    if BuffNum == 99 then
        buffstack(actor, 31065,"=", 100, false)
    elseif BuffNum < 100 then
        buffstack(actor, 31065,"+", 2, false)
    end

    -- local Num = getplaydef(actor, VarCfg["N$��������"])
    -- Num = Num + 2
    -- setplaydef(actor, VarCfg["N$��������"], Num)
end

--������ ÿ��30��ָ���������10%�����Ѫ��
function buff_wu_dao_shen_dai(actor, buffId, buffGroup)
    local nowHp = Player.getHpPercentage(actor)
    if nowHp < 100 then
        humanhp(actor, "+", Player.getHpValue(actor, 10), 4) --�ָ�10%������ֵ
    end
end

--�ڵ���ҹ ÿ30�봥��2��ڵ�״̬ ��״̬�µ���������
function buff_hei_dao_de_ye(actor, buffId, buffGroup)
    addbuff(actor, 31106, 2, 1, actor, nil)
end


-- --�Ž��� ÿ60��ظ�����100%����
-- function buff_ba_jiao_shan_addmp(actor, buffId, buffGroup)
--     release_print(actor, "buff_ba_jiao_shan_addmp")
--     addmpper(actor, "=", 100)
-- end

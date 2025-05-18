Global = {}
--�ڶ������ñ���
local function resetVar(actor)
    local currentDate = GetCurrentDateAsNumber()
    setplaydef(actor, VarCfg["U_�ϴα����״ε�¼ʱ��"], currentDate) --���ý��յ���Ϣ
    setplaydef(actor, VarCfg["U_��ɳ����"], 0)
    setplaydef(actor, VarCfg["U_��ɳ���ֿ��"], 0)
    setflagstatus(actor, VarCfg["F_�����ɳ�Ƿ���ȡ"], 0)
    setflagstatus(actor, VarCfg["F_ն�������Ƿ���ȡ"], 0)
    setflagstatus(actor, VarCfg["F_���µ�һ�Ƿ���ȡ"], 0)
    setflagstatus(actor, VarCfg["F_��ѡ֮���Ƿ����"], 0)
    setflagstatus(actor, VarCfg["F_��������Ƿ����"], 0)
    setplaydef(actor, VarCfg["U_�����ʱ����"], 0)
    delattlist(actor, "�۱���")
end

-------------------------------������ִ��-------------------------------------
--ÿ��ִ��
function beforedawn()
    --ÿ��+1
    local openday = getsysvar(VarCfg["G_��������"])
    setsysvar(VarCfg["G_��������"], openday + 1)
    GameEvent.push(EventCfg.roBeforedawn, openday + 1)
    setsysvar(VarCfg["G_�Ƿ�����ɳ"], 0)
    --�µ�һ�� ȫ�������ʾ
    local player_list = getplayerlst()
    for _, actor in ipairs(player_list) do
        GameEvent.push(EventCfg.onNewDay, actor)
        resetVar(actor)
    end
    --�����˻ر���
    if checkkuafuserver() then
        kuafuusergohome()
        FsendHuoDongGongGao("����������ѹر�,�����˴��ر���!")
    end
    --�����Զ������ KFZF5 = ��ѡ֮�˷�ֹ��װ��  KFZF6 = ���������ֹ��װ��
    -- clearhumcustvar("*","KFZF5|KFZF6")
end

--ÿ���һСʱ�޸�һ������
function settianqi()
    setweathereffect("n3", math.random(3), 600)
end

--ɳ�Ϳ˼��빥ɳ
function sbk_join()
    --���빥ɳ������л�Ļ��ּ�¼����ɳ�Ϳ˳�����ȡ��¼
    setsysvar(VarCfg["A_�л���ּ�¼"], "")
    setsysvar(VarCfg["A_ɳ������ȡ"], "")
    setsysvar(VarCfg["A_ʤ�����л��Ա��ȡ��¼"], "")
    setsysvar(VarCfg["A_���а���ȡ��¼"], "")
    local isKF = checkkuafuconnect()
    FSendGongShaTips1(isKF)
    --���Ϊ��ʼ��ɳ
    if checkkuafuserver() then
        setsysvar(VarCfg["G_�Ƿ�����ɳ"], 1)
    end
    --���û�������������������������ɳ
    if not checkkuafuconnect() then
        setsysvar(VarCfg["G_�Ƿ�����ɳ"], 1)
    end
    --�޸�����
    repaircastle()
end

function set_richong_state_on()
    setsysvar(VarCfg["A_�þ���ͼ����"], "��")
    FsendHuoDongGongGao("�þ���ͼ�Ѿ���������ӭ��λ��ʿǰ��̽�ա�")
end

function set_richong_state_off()
    setsysvar(VarCfg["A_�þ���ͼ����"], "")
    FsendHuoDongGongGao("�þ���ͼ�Ѿ��رգ������ڴ��´ο�����")
    local RiChongDiTu = { "�����þ�1", "�����þ�2", "ۺ���þ�1", "ۺ���þ�2", "����þ�1", "����þ�2", "�����þ�1", "�����þ�2", "�����ر���1", "�����ر���2",
        "ʥ�ǻþ�1", "ʥ�ǻþ�2", "ʥ���ر���1", "ʥ���ر���2", "���»þ�1", "���»þ�2", "�����ر���1", "�����ر���2" }

    local player_list = getplayerlst()
    for _, actor in ipairs(player_list) do
        local InTheMap = getbaseinfo(actor, ConstCfg.gbase.mapid)
        for _, v in ipairs(RiChongDiTu) do
            if v == InTheMap then
                mapmove(actor, ConstCfg.main_city, 330, 330, 5)
                break
            end
        end
    end
end

function sbk_tip()
    local isKF = checkkuafuconnect()
    --��ɳ��ʾ
    if isKF then
        local weekDayNumber = tonumber(os.date("%w"))
        if weekDayNumber == 2 or weekDayNumber == 6 then
            sbk_join()
        end
        return
    end
    --��ȡ��������
    local heQuDay = tonumber(getconst("0", "<$HFCOUNT>"))
    --��ȡ��ɳ����
    local gongShaConunt = getsysvar(VarCfg["G_��ɳ����"])
    --����ɳ��Ǵ���0��ʱ�򣬿���������ɳ��Ҫ���ж�
    if gongShaConunt > 0 then
        --��ȡ�������ڼ�
        local weekDayNumber = tonumber(os.date("%w"))
        --�ж�����2��������6�Ź�ɳ
        if weekDayNumber == 2 or weekDayNumber == 6 then
            setsysvar(VarCfg["G_��ɳ����"], gongShaConunt + 1)
            sbk_join()
        end
    end
    --�״κ���������ɳ
    --������������1Ϊ�״κ����������ж��Ƿ��״ι�ɳ���
    -- heQuDay = 1
    if heQuDay == 1 and getsysvar(VarCfg["G_��ɳ����"]) == 0 then
        sbk_join()
        --����״ι�ɳ
        setsysvar(VarCfg["G_��ɳ����"], 1)
    end
end

--ɳ�Ϳ˿�ʼ
function start_sbk()
    if getsysvar(VarCfg["G_�Ƿ�����ɳ"]) > 0 then
        -- �����л���빥��ս
        addtocastlewarlistex("*")
        gmexecute("0", "ForcedWallConQuestwar")
    end
end

--ɳ�Ϳ˽���
function end_sbk()
    if getsysvar(VarCfg["G_�Ƿ�����ɳ"]) > 0 then
        gmexecute("0", "ForcedWallConQuestwar")
    end
end

--ҹ��ʼ
function starting_dark()
    sendmsg("0", 2,
        '{"Msg":"�ºڷ��ҹ��ɱ������ʱ���Ӿཱུ�ͣ�������װ����+10%","FColor":0,"BColor":255,"Type":5,"Time":3,"SendId":"123","Y":"100"}')
    sendmsg("0", 2,
        '{"Msg":"�ºڷ��ҹ��ɱ������ʱ���Ӿཱུ�ͣ�������װ����+10%","FColor":0,"BColor":255,"Type":5,"Time":3,"SendId":"123","Y":"140"}')
    sendmsg("0", 2,
        '{"Msg":"�ºڷ��ҹ��ɱ������ʱ���Ӿཱུ�ͣ�������װ����+10%","FColor":0,"BColor":255,"Type":5,"Time":3,"SendId":"123","Y":"180"}')
    local t = getplayerlst(1)
    for _, actor in ipairs(t) do
        if not getbaseinfo(actor, ConstCfg.gbase.offline) then
            GameEvent.push(EventCfg.onStartingDark, actor)
        end
    end
end

--���쿪ʼ
function starting_day()
    sendmsg("0", 2,
        '{"Msg":"�簲��ÿ���糿����ȫ��һ��Ŀ�ʼ��Ը������и������顣","FColor":255,"BColor":0,"Type":5,"Time":3,"SendId":"123","Y":"100"}')
    sendmsg("0", 2,
        '{"Msg":"�簲��ÿ���糿����ȫ��һ��Ŀ�ʼ��Ը������и������顣","FColor":255,"BColor":0,"Type":5,"Time":3,"SendId":"123","Y":"140"}')
    sendmsg("0", 2,
        '{"Msg":"�簲��ÿ���糿����ȫ��һ��Ŀ�ʼ��Ը������и������顣","FColor":255,"BColor":0,"Type":5,"Time":3,"SendId":"123","Y":"180"}')
    local t = getplayerlst(1)
    for _, actor in ipairs(t) do
        if not getbaseinfo(actor, ConstCfg.gbase.offline) then
            GameEvent.push(EventCfg.onStartingDay, actor)
        end
    end
end

--������������

function Global.onStartUp()
    --����ȫ�ַ��Ӷ�ʱ��
    if getsysvar(VarCfg["G_�������Ӽ�ʱ��"]) <= 300 then
        setontimerex(1, 60)
    end
    mapeffect(63067, "n3", 348, 327, 63067, -1, 0, "0", 0)
    --˫������Ч��
    setweathereffect("��С��", 3, 6553500)
end

--����֮������  ����
function attributeson()
    local t = getplayerlst(1)
    for _, actor in ipairs(t) do
        if Player.Checkonline(getbaseinfo(actor, ConstCfg.gbase.name)) then --����Ƿ�������ң������߹һ���ң�
            if getconst(actor, ConstCfg.equipconst["����"]) == "���¡�֮��" then
                Player.setAttList(actor, "��������")
            end
        end
    end
end

--����֮������  �ر�
function attributesoff()
    local t = getplayerlst(1)
    for _, actor in ipairs(t) do
        if Player.Checkonline(getbaseinfo(actor, ConstCfg.gbase.name)) then --����Ƿ�������ң������߹һ���ң�
            Player.setAttList(actor, "��������")
        end
    end
end

--Ѫ�������ӳٿ�Ѫ
function xuedaolaozusubhp(actor, state)
    state = tonumber(state)
    if getflagstatus(actor, VarCfg["F_����_Ѫ�������ʶ"]) == 1 then
        changehumnewvalue(actor, 208, -20, 655350)
        Player.buffTipsMsg(actor, "[Ѫ������]��Ч,�۳�20%�������ֵ")
    else
        if state == 1 then
            changehumnewvalue(actor, 208, 0, 1)
        end
    end
end

--������ɽ������
function budongrushangongji(actor, state)
    state = tonumber(state)
    if getflagstatus(actor, VarCfg["F_����_������ɽ��ʶ"]) == 1 then
        -- local attack = getbaseinfo(actor, ConstCfg.gbase.custom_attr, 4)
        -- local subAttack = math.ceil(attack * 0.1)
        -- changehumability(actor, 6, -subAttack, 655350)
        local attackAddtion = getbaseinfo(actor, ConstCfg.gbase.custom_attr, 210)
        local subAttack = 0
        if attackAddtion >= 10 then
            subAttack = 10
        else
            subAttack = attackAddtion
        end
        changehumnewvalue(actor, 210, -subAttack, 655350)
        Player.buffTipsMsg(actor, "[������ɽ]��Ч,�۳�10%��󹥻���")
    else
        --�ǵ�¼�Ŵ���
        if state == 1 then
            changehumnewvalue(actor, 210, 0, 1)
        end
    end
end

-- function xiemozhiqufangyu(actor)
--     local hp = getbaseinfo(actor, ConstCfg.gbase.custom_attr, 1)
--     local fangYu = math.floor(hp / 1000)
--     fangYu = fangYu * 10
--     if fangYu then
--         addattlist(actor, "Ѫħ֮��", "=", string.format("3#9#%s|3#10#%s|3#11#%s|3#12#%s", fangYu, fangYu, fangYu, fangYu), 1)
--     end
-- end

function xiemozhiqufangyu(actor)
    local hp = getbaseinfo(actor, ConstCfg.gbase.custom_attr, 1)
    local fangYuHer = math.floor(hp / 10000)
    if fangYuHer > 200 then
        fangYuHer = 200
    end
    fangYuHer = math.ceil(fangYuHer / 2)
    if fangYuHer then
        addattlist(actor, "Ѫħ֮��", "=",
            string.format("3#213#%s|3#214#%s|3#224#%s|3#225#%s", fangYuHer, fangYuHer, fangYuHer, fangYuHer), 1)
    end
end

function jielidali_beigonghuifu(actor)
    Player.setAttList(actor, "��������")
end

-------------------------------��UIȫ�ֺ���---------------------------------------
function openbag(actor)
    openhyperlink(actor, ConstCfg.openlink.Bag)
end

function openplayer(actor)
    local client_flag = getconst(actor, "<$CLIENTFLAG>")
    if client_flag == "1" then
        reddel(actor, 104, 1000)
    else
        reddel(actor, 107, 1000)
    end
    setplaydef(actor, VarCfg["N$���ﰴť�Ƿ���Ӻ��"], 0)
    openhyperlink(actor, ConstCfg.openlink.Equip)
end

--���׳�
function open_shou_chong(actor)
    Message.sendmsg(actor, ssrNetMsgCfg.ShouChong_OpenUI)
end

--ȫ�ֺ���---
function entermapmsg(actor, isAuto)
    local userName = getbaseinfo(actor, ConstCfg.gbase.name)
    local mapName = getbaseinfo(actor, ConstCfg.gbase.map_title)
    local msg = string.format("��ʿ{��%s��|254:0:1}������{��%s��|250:0:1}��ʼ����֮��!", Player.GetNameEx(actor), mapName)

    sendmsg(actor, 2, '{"Msg":"' .. msg .. '","FColor":249,"BColor":151,"Type":0}')
    if isAuto == "1" then
        startautoattack(actor)
    end
end

function sui_ji_start_auto_attack(actor)
    startautoattack(actor)
end

function jin_ru_fu_ben_ti_shi(actor, timer)
    timer = tonumber(timer) or 0
    senddelaymsg(actor, "ϵͳ��ʾ��������%s���������...", timer, 250, 1)
end

-------------------------------�߼�����---------------------------------------
--���ģ�鿪��
function Global.checkModuleOpen(actor)
    -- openmoduleid = 100
    -- GameEvent.push(EventCfg.goOpenModule, actor, openmoduleid)
    --ͨ�� openmoduleid ��ȡģ����� ͬ��ģ������
    -- Message.sendmsg(actor, ssrNetMsgCfg.Global_OpenModuleRun, openmoduleid)
end

--��������
local zhuligive = { { "����ʯ", 20 }, { "�칤֮��", 20 }, { "�󶨽��", 880000 }, { "��G���ı�", 1 }, { "����ţ��[�ƺ�]", 1 }, { "����һͷСë¿[ʱװ]", 1 } }
function fa_song_zhu_li(actor)
    local accountID = getconst(actor, "<$USERACCOUNT>")
    local isLive = checktextlist('..\\QuestDiary\\accountid\\liveuserid.txt', accountID)
    if isLive then
        local targetName = getconst(actor, "<$NPCINPUT(2)>")
        local targetPlayer = getplayerbyname(targetName)
        if not targetPlayer or targetPlayer == "" or targetPlayer == "0" or not isnotnull(targetPlayer) then
            Player.sendmsgEx(actor, targetName .. "#249|�����ߣ�")
            return
        end

        local flag = getflagstatus(targetPlayer, VarCfg["F_ֱ��������ȡ"])
        if flag == 1 then
            Player.sendmsgEx(actor, targetName .. "#249|�Ѿ���ȡ���ˣ�")
            return
        end
        local mailTitle = "ֱ������"
        local mailContent = "����ȡ����ֱ������"
        local userID = getbaseinfo(targetPlayer, ConstCfg.gbase.id)
        Player.giveMailByTable(userID, 20, mailTitle, mailContent, zhuligive, 1, true)
        setflagstatus(targetPlayer, VarCfg["F_ֱ��������ȡ"], 1)
        delbutton(targetPlayer, 105, 12345)
        Player.sendmsgEx(actor, targetName .. "#249|�����������ͳɹ���")
    end
end

function zi_dong_fa_song_zhu_li(actor)
    local flag = getflagstatus(actor, VarCfg["F_ֱ��������ȡ"])
    if flag == 0 then
        local mailTitle = "ֱ������"
        local mailContent = "����ȡ����ֱ������"
        local userID = getbaseinfo(actor, ConstCfg.gbase.id)
        Player.giveMailByTable(userID, 20, mailTitle, mailContent, zhuligive, 1, true)
        setflagstatus(actor, VarCfg["F_ֱ��������ȡ"], 1)
        delbutton(actor, 105, 12345)
    end
end

--����
function zhi_bo_zhu_li_zhu_bo(actor)
    say(actor, [[
        <Img|x=6.0|y=0.0|bg=1|move=1|show=4|loadDelay=1|esc=1|img=custom/ZhiBoZhuLi/bg2.png|reset=1>
        <Layout|x=732.0|y=24.0|width=80|height=81|link=@exit>
        <Button|x=759.0|y=45.0|nimg=public/1900000510.png|pimg=public/1900000511.png|link=@exit>
        <ItemShow|x=108.0|y=206.0|width=70|height=70|itemid=10044|itemcount=20|showtips=1|bgtype=0>
        <ItemShow|x=218.0|y=205.0|width=70|height=70|itemid=10045|itemcount=20|showtips=1|bgtype=0>
        <ItemShow|x=330.0|y=206.0|width=70|height=70|itemid=3|itemcount=880000|showtips=1|bgtype=0>
        <ItemShow|x=441.0|y=206.0|width=70|height=70|itemid=51118|itemcount=1|showtips=1|bgtype=0>
        <ItemShow|x=553.0|y=206.0|width=70|height=70|itemid=10512|itemcount=1|showtips=1|bgtype=0>
        <ItemShow|x=665.0|y=206.0|width=70|height=70|itemid=10507|itemcount=1|showtips=1|bgtype=0>
        <Input|x=284.0|y=439.0|width=240|isChatInput=0|height=26|size=16|color=255|inputid=2|type=0>
        <Button|x=549.0|y=428.0|nimg=custom/ZhiBoZhuLi/sendbtn.png|color=255|submitInput=2|size=18|link=@fa_song_zhu_li>
    ]])
end

--��ͨ
function zhi_bo_zhu_li(actor)
    say(actor, [[
        <Img|x=6.0|y=0.0|esc=1|loadDelay=1|img=custom/ZhiBoZhuLi/bg1.png|reset=1|show=4|bg=1|move=1>
        <Layout|x=732.0|y=24.0|width=80|height=81|link=@exit>
        <Button|x=759.0|y=45.0|nimg=public/1900000510.png|pimg=public/1900000511.png|link=@exit>
        <ItemShow|x=108.0|y=206.0|width=70|height=70|itemid=10044|itemcount=20|showtips=1|bgtype=0>
        <ItemShow|x=218.0|y=205.0|width=70|height=70|itemid=10045|itemcount=20|showtips=1|bgtype=0>
        <ItemShow|x=330.0|y=206.0|width=70|height=70|itemid=3|itemcount=880000|showtips=1|bgtype=0>
        <ItemShow|x=441.0|y=206.0|width=70|height=70|itemid=51118|itemcount=1|showtips=1|bgtype=0>
        <ItemShow|x=553.0|y=206.0|width=70|height=70|itemid=10512|itemcount=1|showtips=1|bgtype=0>
        <ItemShow|x=665.0|y=206.0|width=70|height=70|itemid=10507|itemcount=1|showtips=1|bgtype=0>
    ]])
end

--ֱ������
function Global.zhiBoZhuLi(actor)
    local client_flag = getconst(actor, "<$CLIENTFLAG>")
    local accountID = getconst(actor, "<$USERACCOUNT>")
    local isLive = checktextlist('..\\QuestDiary\\accountid\\liveuserid.txt', accountID)
    if isLive then
        if client_flag == "1" then
            addbutton(actor, 105, 54321,
                "<Button|id=54321|x=190.0|y=-130.0|nimg=custom/ZhiBoZhuLi/btn.png|size=16|color=251|link=@zhi_bo_zhu_li_zhu_bo>")
        else
            addbutton(actor, 105, 54321,
                "<Button|id=54321|x=190.0|y=-70.0|nimg=custom/ZhiBoZhuLi/btn.png|size=16|color=251|link=@zhi_bo_zhu_li_zhu_bo>")
        end
    else
        local flag = getflagstatus(actor, VarCfg["F_ֱ��������ȡ"])
        if flag == 0 then
            if client_flag == "1" then
                addbutton(actor, 105, 12345,
                    "<Button|id=12345|x=190.0|y=-130.0|nimg=custom/ZhiBoZhuLi/btn.png|size=16|color=251|link=@zhi_bo_zhu_li>")
            else
                addbutton(actor, 105, 12345,
                    "<Button|id=12345|x=190.0|y=-70.0|nimg=custom/ZhiBoZhuLi/btn.png|size=16|color=251|link=@zhi_bo_zhu_li>")
            end
            delaygoto(actor, 900000, "zi_dong_fa_song_zhu_li", 0)
        end
    end
end


function fang_zhi_diao_zhuang_flag(actor)
    setplaydef(actor,"N$��ֹ��װ�����",0)
end

-------------------------------�begin----------------------------------
---�������ؿ�ʼ
--11:30
--18:30
function xian_wang_bao_zang_start()
    setsysvar(VarCfg["G_�������ؿ�����ʶ"], 1)
    GameEvent.push(EventCfg.onXianWangBaoZangStart)
end

---�������ؽ���
--12:00
--19:00
function xian_wang_bao_zang_end()
    setsysvar(VarCfg["G_�������ؿ�����ʶ"], 0)
    GameEvent.push(EventCfg.onXianWangBaoZangEnd)
end

---����Գ���ʼ
--13:00
--19:00
function yi_jie_lie_chang_start()
    setsysvar(VarCfg["G_����Գ�������ʶ"], 1)
    GameEvent.push(EventCfg.onYiJieLieChangStart)
end

---����Գ�����
--13:30
--19:30
function yi_jie_lie_chang_end()
    setsysvar(VarCfg["G_����Գ�������ʶ"], 0)
    GameEvent.push(EventCfg.onYiJieLieChangEnd)
end

-- ---ţ�������ʼ
-- --ÿ��1��5 21:00-22:00
-- function niu_ma_kuang_gong_start()
--     local weekDayNumber = tonumber(os.date("%w"))
--     if weekDayNumber == 1 or weekDayNumber == 5 then
--         setsysvar(VarCfg["G_ţ�����������ʶ"], 1)
--         GameEvent.push(EventCfg.onNiuMaKuangGongStart)
--     end
-- end

-- ---ţ���������
-- function niu_ma_kuang_gong_end()
--     local weekDayNumber = tonumber(os.date("%w"))
--     if weekDayNumber == 1 or weekDayNumber == 5 then
--         setsysvar(VarCfg["G_ţ�����������ʶ"], 0)
--         GameEvent.push(EventCfg.onNiuMaKuangGongEnd)
--     end
-- end

---����Գǿ�ʼ
--ÿ��1��5 21:00-22:00
function yi_jie_mi_cheng_start()
    setsysvar(VarCfg["G_����Գǿ�����ʶ"], 1)
    GameEvent.push(EventCfg.onYiJieMiChengStart)
end

---����Գǽ���
function yi_jie_mi_cheng_end()
    setsysvar(VarCfg["G_����Գǿ�����ʶ"], 0)
    GameEvent.push(EventCfg.onYiJieMiChengEnd)
end

--ն��������ʼ
function zhan_jiang_duo_qi_start()
    local weekDayNumber = tonumber(os.date("%w"))
    if weekDayNumber == 1 or weekDayNumber == 5 then
        if checkkuafuconnect() then
            setsysvar(VarCfg["G_ն������"], 1)
            GameEvent.push(EventCfg.onKFZhanJiangDuoQiStart)
            if checkkuafuserver() then
                setontimerex(3, 1)
            end
        end
    end
end

--ն����������
function zhan_jiang_duo_qi_end()
    local weekDayNumber = tonumber(os.date("%w"))
    if weekDayNumber == 1 or weekDayNumber == 5 then
        if checkkuafuconnect() then
            setsysvar(VarCfg["G_ն������"], 0)
            GameEvent.push(EventCfg.onKFZhanJiangDuoQiEnd)
            if checkkuafuserver() then
                setofftimerex(3)
            end
        end
    end
end

--���µ�һ�����
function tian_xia_di_yi_start()
    local weekDayNumber = tonumber(os.date("%w"))
    if weekDayNumber == 1 or weekDayNumber == 3 or weekDayNumber == 5 then
        if checkkuafuconnect() then
            setsysvar(VarCfg["G_���µ�һ"], 1)
            GameEvent.push(EventCfg.onKFTianXiaDiYiStart)
            if checkkuafuserver() then
                setontimerex(4, 3)
            end
        end
    end
end

--���µ�һ�����
function tian_xia_di_yi_end()
    local weekDayNumber = tonumber(os.date("%w"))
    if weekDayNumber == 1 or weekDayNumber == 3 or weekDayNumber == 5 then
        if checkkuafuconnect() then
            setsysvar(VarCfg["G_���µ�һ"], 0)
            GameEvent.push(EventCfg.onKFTianXiaDiYiEnd)
            if checkkuafuserver() then
                setofftimerex(4)
            end
        end
    end
end

--˫�ڻ��ͼ����
function shuang_jie_huo_dong_map_start()
    GameEvent.push(EventCfg.onShuangJieHuoDongStart)
end

--˫�ڻ��ͼ�ر�
function shuang_jie_huo_dong_map_end()
    GameEvent.push(EventCfg.onShuangJieHuoDongEnd)
end

--��С��ˢ��
function kuang_huan_xiao_zhen_shua_guai()
    GameEvent.push(EventCfg.onKuangHuanXiaoZhenShuaGuai)
end
-------------------------------�end-----------------------------------


-------------------------------�¼�---------------------------------------
--��¼���
function Global.LoginEnd(actor, logindatas)
    --gmȨ�޵ȼ�
    -- if ConstCfg.DEBUG then
    --     setgmlevel(actor, 10)
    -- end
    setflagstatus(actor, VarCfg["F_��������"], 0)
    table.insert(logindatas, { ssrNetMsgCfg.Global_SyncAdmini, getgmlevel(actor) })
    --����ħ����Ѫ��
    local client_flag = tonumber(getconst(actor, "<$CLIENTFLAG>"))
    if client_flag == 2 then
        callscriptex(actor, "PLAYMAGICBALLEFFECT", 0, 12, 150, -1, 0, 1, 3, 6, 101)
        callscriptex(actor, "PLAYMAGICBALLEFFECT", 0, 12, 150, -1, 1, 1, -7, 6, 101)
        callscriptex(actor, "PLAYMAGICBALLEFFECT", 0, 12, 150, -1, 2, 1, 3, 6, 100)
    else
        callscriptex(actor, "PLAYMAGICBALLEFFECT", 0, 12, 150, -1, 0, 1, 14, -10, 111)
        callscriptex(actor, "PLAYMAGICBALLEFFECT", 0, 12, 150, -1, 1, 1, -8, -10, 111)
        callscriptex(actor, "PLAYMAGICBALLEFFECT", 0, 12, 150, -1, 2, 1, 12, -10, 110)
    end
    --��¼��ǰ��ͼid
    local cur_mapid = getbaseinfo(actor, ConstCfg.gbase.mapid)
    setplaydef(actor, VarCfg.S_cur_mapid, cur_mapid)
    local jiShaNum = getplaydef(actor, VarCfg["U_ɱ����"])
    local beiShanum = getplaydef(actor, VarCfg["U_��ɱ��"])
    setranklevelname(actor, "%s\\��ɱ[" .. jiShaNum .. "]�Ρ�����[" .. beiShanum .. "]��")
    --ֱ������
    Global.zhiBoZhuLi(actor)
    -- if checkitemw(actor, "ҹ����", 1) or checkitemw(actor, "���±���", 1) or checkitemw(actor, "�����ڵ�", 1) then
    --     setcandlevalue(actor, 100)
    -- end
    --�ڶ����¼��������
    if Player.isNextDayLogin(actor) then
        resetVar(actor)
    end

    --���ݵ�һ����ҽ��룬��¼����������
    -- local serverDate = getsysvar(VarCfg["G_��������"])
    -- if serverDate == 0 then
    --     setsysvar(VarCfg["G_��������"], GetCurrentDateAsNumber())
    -- end
end

--���ĳNPC
function Global.ClickNpcResponse(actor, npcid)
    --Message.sendmsg(actor, ssrNetMsgCfg.Global_ClickNpcResponse, npcid)
end

--�������������ͱ仯
function Global._onBagChange(actor)
    --��������
    local openDay = grobalinfo(ConstCfg.global.openday)
    --����������
    local bagNum = ConstCfg.bagcellnum + getplaydef(actor, VarCfg.U_Bag_OpenNum)
    Message.sendmsg(actor, ssrNetMsgCfg.Global_SyncOpenDay, openDay, bagNum)
end

local function _onPlaydie(actor, hiter)
    local jiShaNum = getplaydef(actor, VarCfg["U_ɱ����"])
    local beiShanum = getplaydef(actor, VarCfg["U_��ɱ��"])
    setplaydef(actor, VarCfg["U_��ɱ��"], beiShanum + 1)
    setranklevelname(actor, "%s\\��ɱ[" .. jiShaNum .. "]�Ρ�����[" .. beiShanum + 1 .. "]��")
    local x = getbaseinfo(actor, ConstCfg.gbase.x)
    local y = getbaseinfo(actor, ConstCfg.gbase.y)
    local mapName = getbaseinfo(actor, ConstCfg.gbase.map_title)
    local killer = Player.GetNameEx(hiter)
    local myName = Player.GetNameEx(actor)
    if getbaseinfo(hiter, -1) == true then
        local msgStr = string.format("���[%s]��[%s(%d:%d)]�����[%s]�ɵ��ˣ�", killer, mapName, x, y, myName)
        sendmsg("0", 2, '{"Msg":"' ..
        msgStr .. '","FColor":255,"BColor":0,"Type":1,"Time":3,"SendName":"��ʾ","SendId":"123"}')
    else
        local msgStr = string.format("�׺��Ĺ���[%s]��[%s(%d:%d)]�����[%s]����ʬ�ˣ�", killer, mapName, x, y, myName)
        sendmsg("0", 2, '{"Msg":"' ..
        msgStr .. '","FColor":255,"BColor":0,"Type":1,"Time":3,"SendName":"��ʾ","SendId":"123"}')
    end
end
GameEvent.add(EventCfg.onPlaydie, _onPlaydie, Global)
local function _onkillplay(actor, play)
    local jiShaNum = getplaydef(actor, VarCfg["U_ɱ����"])
    local beiShanum = getplaydef(actor, VarCfg["U_��ɱ��"])
    setplaydef(actor, VarCfg["U_ɱ����"], jiShaNum + 1)
    setranklevelname(actor, "%s\\��ɱ[" .. jiShaNum + 1 .. "]�Ρ�����[" .. beiShanum .. "]��")
end
GameEvent.add(EventCfg.onkillplay, _onkillplay, Global)

-------------------------------�����¼�---------------------------------------
GameEvent.add(EventCfg.onStartUp, Global.onStartUp, Global, 1)
GameEvent.add(EventCfg.onBagChange, Global._onBagChange, Global, 1)
GameEvent.add(EventCfg.onLoginEnd, Global.LoginEnd, Global, 1)
GameEvent.add(EventCfg.onKFLogin, Global.LoginEnd, Global, 1) --�����½
GameEvent.add(EventCfg.goBeforedawn, Global.Beforedawn, Global, 1)
GameEvent.add(EventCfg.onClicknpc, Global.ClickNpcResponse, Global, 1)
-- GameEvent.add(EventCfg.onRecharge, Global.Recharge, Global, 1)
-- GameEvent.add(EventCfg.onVirtualRecharge, Global.onVirtualRecharge, Global, 1)

--�������߹һ�
local function _onExitGame(actor)
    local serverName = getconst(actor, "<$SERVERNAME>")
    if serverName ~= "" then
        local taskID = getplaydef(actor, VarCfg["U_�����������"])
        local level = getbaseinfo(actor, ConstCfg.gbase.level)
        if taskID > 7 and level >= 150 then
            mapmove(actor, "n3", 330, 330, 9)
            setofftimer(actor, 1)
            setofftimer(actor, 2)
            setofftimer(actor, 3)
            setofftimer(actor, 4)
            setofftimer(actor, 5)
            setofftimer(actor, 101)
            setofftimer(actor, 102)
            setofftimer(actor, 103)
            setofftimer(actor, 104)
            setofftimer(actor, 105)
            offlineplay(actor, 65535) --���߹һ�
        end
    end
end
GameEvent.add(EventCfg.onExitGame, _onExitGame, Global)
local cfg_KuaFuVal = include("QuestDiary/cfgcsv/cfg_KuaFuVal.lua")
--�����������
local function _goPlayerVar(actor)
    for _, value in ipairs(cfg_KuaFuVal) do
        FIniPlayVar(actor, value.String, true)
        FIniPlayVar(actor, value.Integer, false)
    end
end
GameEvent.add(EventCfg.goPlayerVar, _goPlayerVar, Global)

local function _onKFLogin(actor)
    if getflagstatus(actor, VarCfg["F_�Ƿ��������"]) == 0 then
        setflagstatus(actor, VarCfg["F_�Ƿ��������"], 1)
    end
end
GameEvent.add(EventCfg.onKFLogin, _onKFLogin, Global)

--�л���ͼ����Ҫ�Ƿ���ѵ�ͼID��¼���Զ�������У�������ʹ��
local function _goSwitchMap(actor, cur_mapid, former_mapid, x, y)
    Player.SetVarMap(actor, cur_mapid)
end
GameEvent.add(EventCfg.goSwitchMap, _goSwitchMap, Global)

-------------------------------��������---------------------------------------
Message.RegisterNetMsg(ssrNetMsgCfg.Global, Global)

return Global

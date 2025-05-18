--��������
local cfg_MapEffectData = include("QuestDiary/cfgcsv/cfg_MapEffectData.lua") --��ͼ���ӵ������ļ�
function startup()
    for _, v in ipairs(cfg_MapEffectData) do
        mapeffect(10001, v.mapid, v.x, v.y, 17009, -1, 0, nil, 0)
    end

    if getsysvar(VarCfg["G_��������"]) == 0 then
        setsysvar(VarCfg["G_��������"], 1)
    end
    GameEvent.push(EventCfg.onStartUp)
end

--��½�ӳټ�������
function login_delay_calculation(actor)
    --��������
    addhpper(actor, "=", 100)
    addmpper(actor, "=", 100)
end

--��¼
function login(actor)
    setcandlevalue(actor, 10)
    local level = getbaseinfo(actor, ConstCfg.gbase.level)  --�ȼ�
    local HFcount = tonumber(getconst(actor, "<$HFCOUNT>")) --�Ƿ����
    local accountID = getconst(actor, "<$USERACCOUNT>")
    local isAdmin = checktextlist('..\\QuestDiary\\accountid\\adminuserid.txt', accountID)
    local isLive = checktextlist('..\\QuestDiary\\accountid\\liveuserid.txt', accountID)
    if not isAdmin and not isLive and level < 30 and HFcount > 0 then
        messagebox(actor, "�������ֹ�����½�ɫ������ȥ����������������")
        kick(actor)
        return
    end

    -- ţ����Ϯ����
    -- local  Num =   getplaydef(actor, VarCfg["U_ϴ��Ԫ������"])
    -- if Num >= 300000 then
    --     local Tbl= Player.getJsonTableByVar(actor, "T74")
    --     if not Tbl["2"] then
    --         Tbl["2"]   = "����ȡ"
    --     end
    --     Player.setJsonVarByTable(actor, "T74", Tbl)
    -- end

    --������������
    -- local num = getplaydef(actor, VarCfg.U_xing_yun)
    -- if num >= 5 then
    --     local Tbl= Player.getJsonTableByVar(actor, "T76")
    --     if not Tbl["5"] then
    --         Tbl["5"]   = "����ȡ"
    --     end
    --     Player.setJsonVarByTable(actor, "T76", Tbl)
    -- end

    -- local JieBangZhuangTai = getflagstatus(actor, VarCfg["F_���״̬"])
    -- if JieBangZhuangTai == 1 and  not checktitle(actor, "������") then
    --     GameEvent.push(EventCfg.onTeQuankaiTong, actor)
    -- end


    --�������
    local receive = getflagstatus(actor, VarCfg["F_������ȡ"])
    if receive == 1 then
        sendmsgnew(globalinfo(0), 251, 0,
            "{ ���¶��������ƾ��ף�������硾/FCOLOR=250}{" .. getbaseinfo(actor, 1) .. "/FCOLOR=251}{�������ǳ���ȫ����Ŀ���������/FCOLOR=250}", 1, 5)
    end

    setplaydef(actor, VarCfg.N_cur_level, level)
    --���˱�������
    GameEvent.push(EventCfg.goPlayerVar, actor)
    --��һ�ε�¼
    -- local isnewhuman = getbaseinfo(actor, ConstCfg.gbase.isnewhuman)
    local isnewhumanFlag = getflagstatus(actor, VarCfg.F_is_first_login)
    if isnewhumanFlag == 0 then
        setflagstatus(actor, VarCfg.F_is_first_login, 1)
        GameEvent.push(EventCfg.onNewHuman, actor)
        --�������κ�
        setsndaitembox(actor, 1)
        --��ɫ����ʱ��
        setplaydef(actor, VarCfg.U_create_actor_time, os.time())
        --��ɫ����ʱ�ѿ���������
        local openday = grobalinfo(ConstCfg.global.openday)
        setplaydef(actor, VarCfg.U_create_actor_openday, openday)
        --��������
        setbagcount(actor, ConstCfg.bagcellnum)

        --���ε�½��Ӽ���
        for _, skill_id in ipairs(ConstCfg.first_login_addskill) do
            addskill(actor, skill_id, 3)
        end
        sendmsgnew(actor, 250, 0,
            "<��ʾ/FCOLOR=251>:��ӭ�½�ţ��<[" .. getbaseinfo(actor, ConstCfg.gbase.name) .. "]/FCOLOR=254>����ţ���Ĭ����ţ������...", 0, 1)
        --����װ��
        for _, equip in ipairs(ConstCfg.first_give_equip) do
            giveonitem(actor, equip[1], equip[2], 1, ConstCfg.binding)
        end
        --������Ʒ
        for _, item in ipairs(ConstCfg.first_give_item) do
            giveitem(actor, item, 1, ConstCfg.binding, "���˸���")
        end
        addhpper(actor, "=", 100)

        --��Ҽ���
        local playerCount = getsysvar(VarCfg["G_��һ����ҽ���"])
        if playerCount < 5 then
            setsysvar(VarCfg["G_��һ����ҽ���"], playerCount + 1)
        end

        --���ø���״̬
        local Relivetbl = {}
        setplaydef(actor, VarCfg["T_����״̬"], tbl2json(Relivetbl))

        --��������
        giveonitem(actor, 89, "�����ʯ[δ����]", 1, 0, "�״δ�npc����װ��")
        local str = {
            ["cur"] = 0,
            ["max"] = 3888,
            ["name"] = "�����ʯ[δ����]",
        }
        setplaydef(actor, VarCfg["T_�����ʯ����"], tbl2json(str))
    end
    --��ʼ���ȼ����ȼ�
    local liveMax = getplaydef(actor, VarCfg["U_�ȼ�����"])
    if liveMax == 0 then
        setplaydef(actor, VarCfg["U_�ȼ�����"], 320)
    end
    --���õȼ���
    setlocklevel(actor, 1, getplaydef(actor, VarCfg["U_�ȼ�����"]))
    --�ֿ����
    changestorage(actor, ConstCfg.warehousecellnum)
    --�����ݵ�
    setautogetexp(actor, 1, 50000, 0, "*", 0, 655350, 100)
    --����һ����ʱ��
    setontimer(actor, 1, 1, 0, 1)
    setontimer(actor, 104, 60)
    -- ontimer105(actor)
    ontimer105(actor)
    setontimer(actor, 105, 60 * 5)
    --�Զ�ʰȡ
    pickupitems(actor, 0, 10, 500)
    --��¼
    GameEvent.push(EventCfg.onLogin, actor)
    --��¼��������
    -- local loginattrs = {}
    -- GameEvent.push(EventCfg.onLoginAttr, actor, loginattrs)
    -- Player.updateAddr(actor, loginattrs)
    --�������Լ���
    -- GameEvent.push(EventCfg.onOtherAttr, actor)
    --��¼���
    local logindatas = {}
    GameEvent.push(EventCfg.onLoginEnd, actor, logindatas)
    --ͬ����Ϣ
    Message.sendmsg(actor, ssrNetMsgCfg.sync, nil, nil, nil, logindatas)

    setplaydef(actor, VarCfg["N$�Ƿ��¼���"], 1)

    -- delaygoto(actor, 1000, "login_delay_calculation")

    -- ����Ա����
    -- if isAdmin then
    --     setgmlevel(actor, 10)
    -- else
    --     setgmlevel(actor, 0)
    -- end
    
    Player.setAttList(actor, "��������")
    Player.setAttList(actor, "���Ը���")
    Player.setAttList(actor, "���ʸ���")
    Player.setAttList(actor, "��������")
    Player.setAttList(actor, "���ٸ���")
    Player.setAttList(actor, "��Ѫ����")
    -----------------------------��ʽ�������ڲ⽱��-----------------------------
    -- local Myid = getconst(actor,"$USERACCOUNT")
    -- local list = {"�ȼ���¼1","�ȼ���¼2","�ȼ���¼3","��Ԫ��½","�����۹�","��Ʒ����","��������1","��������2","��������3","�ϸ�ţ��","����ţ��","��Ϯţ��"}
    -- local jilu_num = 0
    -- local hongbao_num = 0
    -- for k, v in ipairs(list) do
    --     local _value = readini("QuestDiary/���Խ�����¼.ini",Myid,v)
    --     local value = _value == "" and 0 or tonumber(_value)
    --     if value >= 10 then
    --         jilu_num = jilu_num + 1
    --     end
    --     hongbao_num = hongbao_num + value
    -- end

    -- if hongbao_num == 0  then return end

    -- local UserId = getconst(actor, "<$USERID>")
    -- if jilu_num >= 8 then
    --     sendmail(UserId, 666888, "���⽱��", "�𾴵��ڲ����,������...","�á�����ħͯ����߸[ʱװ]#1#".. ConstCfg.iteminfo.bind .."&���ߺ������#1#".. ConstCfg.iteminfo.bind .."&���絤#5&10Ԫ��ֵ���#".. hongbao_num / 10 .."#".. ConstCfg.iteminfo.bind .."")
    -- else
    --     sendmail(UserId, 666888, "���⽱��", "�𾴵��ڲ����,������...","10Ԫ��ֵ���#".. hongbao_num / 10 .."#".. ConstCfg.iteminfo.bind .."")
    -- end
    -- delinisection("QuestDiary/���Խ�����¼.ini",Myid)
    -- updatetongfile('..\\QuestDiary\\���Խ�����¼.ini')   --�ϴ�ͨ��
    -----------------------------��ʽ�������ڲ⽱��-----------------------------
end

-- Ѱ·����
local cfg_JinZhiChuanSong = include("QuestDiary/cfgcsv/cfg_JinZhiChuanSong.lua") --��ֹ���͵ĵ�ͼ
function findpathbegin(actor)
    if getplaydef(actor, VarCfg["N$�Զ�Ѱ·��ֹQF����"]) == 1 then
        setplaydef(actor, VarCfg["N$�Զ�Ѱ·��ֹQF����"], 0)
        return
    end
    local mapid = getbaseinfo(actor, ConstCfg.gbase.mapid)
    -----------------------------------������������GM���С��ͼ���͡�����������-----------------------------------
    if getgmlevel(actor) >= 10 then
        local x = tonumber(getconst(actor, "<$ToPointX>")) or 0
        local y = tonumber(getconst(actor, "<$ToPointY>")) or 0
        if checkkuafu(actor) then
            FBenFuToKuaFuChuanSong(actor, getconst(actor, "<$ToPointX>"), getconst(actor, "<$ToPointY>"))
        else
            mapmove(actor, mapid, x, y)
        end
    end
    -----------------------------------������������GM���С��ͼ���͡�����������-----------------------------------
    local ChuanSongBuff = hasbuff(actor, 31049)
    if ChuanSongBuff then
        local buffTime = getbuffinfo(actor, 31049, 2)
        Player.sendmsgEx(actor, "������ʾ#251|:#255|����|" .. buffTime .. "��#249|����ʹ��...")
    else
        local str = getconst(actor, "<$SCHARM>")
        if str ~= "" then
            local myName = getbaseinfo(actor, ConstCfg.gbase.name)
            if string.find(mapid, myName) then
                Player.sendmsgEx(actor, "������ͼ��ֹ����#249")
                return
            end
            local isBanChuanSong = cfg_JinZhiChuanSong[mapid]
            if isBanChuanSong then
                Player.sendmsgEx(actor, "��ǰ��ͼ��ֹ����#249")
                return
            end
            local x = tonumber(getconst(actor, "<$ToPointX>")) or 0
            local y = tonumber(getconst(actor, "<$ToPointY>")) or 0
            if checkkuafu(actor) then
                FBenFuToKuaFuChuanSong(actor, getconst(actor, "<$ToPointX>"), getconst(actor, "<$ToPointY>"))
            else
                mapmove(actor, mapid, x, y)
            end
            local buffTime = 10
            if checktitle(actor, "��������") then
                buffTime = buffTime - 5
            end
            addbuff(actor, 31049, buffTime)
            if checkitemw(actor, "����", 1) then --���� ʹ�ô��͹�������[30%]����3S
                changespeedex(actor, 1, 30, 3)
            end
        end
    end
end

--Ѱ·�ж�
function findpathstop(actor)
    setplaydef(actor, VarCfg["N$�Զ�Ѱ·�����Զ�ս��"], 0)
end

--Ѱ·����
function findpathend(actor)
    if getplaydef(actor, VarCfg["N$�Զ�Ѱ·�����Զ�ս��"]) == 1 then
        setplaydef(actor, VarCfg["N$�Զ�Ѱ·�����Զ�ս��"], 0)
        startautoattack(actor)
        return
    end
end

---�л��ʼ��
function loadguild(actor, guildobj)
    guildobj = guildobj or getmyguild(actor)
    if guildobj == "0" then return end
    GameEvent.push(EventCfg.onLoadGuild, actor, guildobj)
end

---��ɢ�л�
function guildclose(actor)
    GameEvent.push(EventCfg.onCloseGuild, actor)
end

---�˳��л�ʱ
function guilddelmember(actor)
    GameEvent.push(EventCfg.onGuilddelMember, actor)
end

local preventFrequentRequestsCache = {}
--��Ϣ�Ű�����
local filterOutMsgid = {
    [11009] = true, --����
    [11001] = true  --�Ի���
}
local cfg_KuaFuJinZhi = include("QuestDiary/cfgcsv/cfg_KuaFuJinZhi.lua")
--���з��͸�����˵�������Ϣ����
function handlerequest(actor, msgid, arg1, arg2, arg3, sMsg)
    -- LOGPrint("handlerequest", type(msgid),msgid, arg1, arg2, arg3, sMsg)
    --�����ֹʹ��
    if cfg_KuaFuJinZhi[msgid] then
        local isKuaFu = checkkuafu(actor)
        if isKuaFu then
            Player.sendmsgEx(actor, "�����,��ֹʹ�øù���!#249")
            return
        end
    end
    local lastRequestTime = preventFrequentRequestsCache[actor] or 0
    local currentRequestTime = os.clock()
    if currentRequestTime - lastRequestTime <= 0.2 then
        if not filterOutMsgid[msgid] then
            -- Player.sendmsgEx(actor, "����Ƶ��#249")
            return
        end
    else
        preventFrequentRequestsCache[actor] = os.clock()
    end

    if msgid == ssrNetMsgCfg.sync then
        login(actor)
        return
    end
    --�ɷ�
    local result, errinfo = pcall(Message.dispatch, actor, msgid, arg1, arg2, arg3, sMsg)
    if not result then
        local name = getbaseinfo(actor, ConstCfg.gbase.name)
        local msgName = ssrNetMsgCfg[msgid]
        local err = "������Ϣ�ɷ�������ϢID=" .. msgid .. "  ��ϢName=" .. msgName .. "   "
        release_print(name, err, errinfo, arg1, arg2, arg3, sMsg)
    end
end

--�����ͼɱ������
---*actor ����������
---*monobj����ɱ�������
function killmon(actor, monobj)
    ----------------------------------------��ʬ----------------------------------------
    local _BianShiGaiLv = getbaseinfo(actor, 51, 201) --��ʬ����
    local BianShiGaiLv = (300 - _BianShiGaiLv <= 200 and 200) or (300 - _BianShiGaiLv)
    if randomex(1, BianShiGaiLv) then
        monitems(actor, 1)
        Player.sendmsgEx(actor, "��ʾ#251|:#255|������ʬ��|1��#249|...")
        local _LianbaoGaiLv = getbaseinfo(actor, 51, 226) --��������
        local LianbaoGaiLv = (300 - _LianbaoGaiLv <= 200 and 200) or (300 - _LianbaoGaiLv)
        if randomex(1, LianbaoGaiLv) then
            monitems(actor, 1)
            Player.sendmsgEx(actor, "��ʾ#251|:#255|���������ٱ�|1��#249|...")
        end
        if checkitemw(actor, "����֮�ڡ���ɷ���", 1) then
            if randomex(20, 100) then
                monitems(actor, 1)
                Player.sendmsgEx(actor, "��ʾ#251|:#255|���������ٱ�|1��#249|...")
            end
        end
    end
    ----------------------------------------��ʬ----------------------------------------
    local monName = getbaseinfo(monobj, ConstCfg.gbase.name)
    GameEvent.push(EventCfg.onKillMon, actor, monobj, monName)
end

--ɱ�����ﴥ��
---*actor����������
---*play����ɱ���
function killplay(actor, play)
    --͸������ ɱ������󴥷�����[2��]���һָ� (10%)���������ֵ��[CD:30S]
    if checkitemw(actor, "͸������", 1) then
        if not Player.checkCd(actor, VarCfg["����CD"], 60, true) then return end

        local buffcd = hasbuff(actor, 30009)
        if not buffcd then
            changemode(actor, 2, 2)                              --����2����
            humanhp(actor, "+", Player.getHpValue(actor, 10), 4) --�ָ�10%������ֵ
            addbuff(actor, 30009, 30, 1, actor)
            Player.buffTipsMsg(actor, "[͸������]:����2�벢�ָ�����10%Ѫ��...")
        end
    end

    --��Ӱ֮�� ɱ������󴥷�����[2��]���һָ�(10%)���������ֵ��[CD��30��]
    if getflagstatus(actor, VarCfg["F_��Ӱ֮��"]) == 1 then
        if not Player.checkCd(actor, VarCfg["����CD"], 60, true) then return end
        local buffcd = hasbuff(actor, 30017)
        if not buffcd then
            changemode(actor, 2, 2)                              --����2����
            humanhp(actor, "+", Player.getHpValue(actor, 10), 4) --�ָ�10%������ֵ
            Player.buffTipsMsg(actor, "[��Ӱ֮��]:����[{2��/FCOLOR=243}]ͬʱ�ָ�����[{10%/FCOLOR=243}]����ֵ...")
            addbuff(actor, 30017, 30, 1, actor)
        end
    end

    --����ħ����ʹ[����] ɱ�������ָ�[10%]������ֵ
    if getconst(actor, "<$SHIELD>") == "����ħ����ʹ[����]" then
        humanhp(actor, "+", Player.getHpValue(actor, 10), 4)
    end

    -- �����С��������� ���� ��Դ֮��   �������ý���[ɱ�˲�����]״̬
    if checkitemw(actor, "�����С���������", 1) or checkitemw(actor, "��Դ֮��", 1) then
        setbaseinfo(actor, 46, 100)
    end

    GameEvent.push(EventCfg.onkillplay, actor, play)
    --ɱ����������
    if checkkuafu(actor) then
        FKuaFuToBenFuQiYuTitle(actor, EventCfg.onkillplayQiYu, "")
    else
        GameEvent.push(EventCfg.onkillplayQiYu, actor)
    end
end

--��������ӳ���¿���װ������
local newShenQiWhereMaps = {
    [90] = 1,
    [91] = 2,
    [92] = 3,
    [93] = 4,
    [94] = 5,
    [95] = 6,
    [96] = 7,
    [97] = 8,
    [98] = 9,
    [99] = 10,
}
--��ɫ��װ��ǰ
function takeonbeforeex(actor, itemobj, where, makeIndex)
    if checkkuafu(actor) then
        if not getbaseinfo(actor, ConstCfg.gbase.isdie) then
            Player.sendmsgEx(actor, "����У��������Ѵ�װ��!#249")
            return false
        end
    end
    local layer1Flag = getplaydef(actor, VarCfg["M_�ز�����ʶ"])
    if layer1Flag > 0 then
        Player.sendmsgEx(actor, "������,�������Ѵ�װ��!#249")
        return false
    end
    --���������ж�
    local guGuanmap = {
        ["����Ź�"] = true,
        ["ǧ��Ź�"] = true,
        ["����Ź�"] = true,
        ["ʮ����Ź�"] = true,
    }
    --��ɳ
    local fengMap = {
        ["쫷�֮��"] = true,
        ["[�L��]�Sɳ֮�`"] = true,
    }
    local function isSameTypeExisting(map, equipName)
        setmetatable(map, {
            __index = function()
                return false
            end
        })
        return map[equipName]
    end
    if where >= 77 and where <= 99 then
        local equipName = getiteminfo(actor, itemobj, ConstCfg.iteminfo.name)
        if FCheckBagEquip(actor, equipName) then
            Player.sendmsgEx(actor, "�Ѵ�����ͬ���͵ı�������,�޷�����,�����º��ٴη���!#249")
            return false
        end
        --�жϹŹ�
        if isSameTypeExisting(guGuanmap, equipName) then
            for key, value in pairs(guGuanmap) do
                if FCheckBagEquip(actor, key) then
                    Player.sendmsgEx(actor, "�Ѵ�����ͬ���͵ı�������,�޷�����,�����º��ٴη���!#249")
                    return false
                end
            end
        end
        --�жϻ�ɳ
        if isSameTypeExisting(fengMap, equipName) then
            for key, value in pairs(fengMap) do
                if FCheckBagEquip(actor, key) then
                    Player.sendmsgEx(actor, "�Ѵ�����ͬ���͵ı�������,�޷�����,�����º��ٴη���!#249")
                    return false
                end
            end
        end
        --�ж��Ƿ���ϵ��¸���
        local currExtend = getplaydef(actor, VarCfg["U_�¼ӱ�������������"])
        local extend = newShenQiWhereMaps[where]
        if extend then
            if currExtend < extend then
                messagebox(actor, "��ı������������Ѿ�����,�����滻����װ��,����ȡ��")
                return false
            end
        end
    end
end

--��ɫ��װ��ǰ
function takeoffbeforeex(actor, itemobj, where, makeIndex)
    if checkkuafu(actor) then
        if not getbaseinfo(actor, ConstCfg.gbase.isdie) then
            Player.sendmsgEx(actor, "����У��������Ѵ�װ��!#249")
            return false
        end
    end
    local layer1Flag = getplaydef(actor, VarCfg["M_�ز�����ʶ"])
    if layer1Flag > 0 then
        Player.sendmsgEx(actor, "������,�������Ѵ�װ��!#249")
        return false
    end
end

--������װ��ǰ
function takeonbefore3(actor, itemobj)
    GameEvent.push(EventCfg.onTakeOnNecklace, actor, itemobj)
end

--������װ��ǰ
function takeoffbefore3(actor, itemobj)
    GameEvent.push(EventCfg.onTakeOffNecklace, actor, itemobj)
end

--������װ��ǰ
function takeonbefore1(actor, itemobj)
    local buff = hasbuff(actor, 30041) --��еbuff �������ˡ���Ԩ֮��
    if buff then
        Player.sendmsgEx(actor, "��ʾ#251|:#255|��ǰ��|��е״̬#249|����ʧ��...")
        return false
    end
    GameEvent.push(EventCfg.onTakeOnWeapon, actor, itemobj)
end

--������װ��ǰ
function takeoffbefore1(actor, itemobj)
    GameEvent.push(EventCfg.onTakeOffWeapon, actor, itemobj)
end

--�·���װ��ǰ
function takeonbefore0(actor, itemobj)
    GameEvent.push(EventCfg.onTakeOnDress, actor, itemobj)
end

--�·���װ��ǰ
function takeoffbefore0(actor, itemobj)
    GameEvent.push(EventCfg.onTakeOffDress, actor, itemobj)
end

--��ȡ������Ʒ�󴥷�
function pickupitemex(actor, itemobj, itemidx, itemMakeIndex)
    local ItemName = getstditeminfo(itemidx, 1)
    GameEvent.push(EventCfg.goPickUpItemEx, actor, itemobj, itemidx, itemMakeIndex, ItemName)
end

--�ӵ�������Ʒ�󴥷�
function dropitemex(actor, itemobj, itemName)
    GameEvent.push(EventCfg.goDropItemEx, actor, itemobj, itemName)
end

--NPC�������
local clickNpcCSD = include("QuestDiary/cfgcsv/cfg_ChuanSongDian.lua")
--NPC�������
local cfg_NpcDianJiShengYin = include("QuestDiary/cfgcsv/cfg_NpcDianJiShengYin.lua")
function clicknpc(actor, npcid)
    local npcobj = getnpcbyindex(npcid)
    GameEvent.push(EventCfg.onClicknpc, actor, npcid, npcobj)

    --ħ��������ɼ��
    if npcid == 3305 then
        local bool1 = getflagstatus(actor, VarCfg["F_���������_�޾���ŭ"])
        local bool2 = getflagstatus(actor, VarCfg["F_���������_Ѫħ����MAX"])
        if bool1 == 0 or bool2 == 0 then
            messagebox(actor, "���������δ��ɣ��޷�����!")
            return
        end
    elseif npcid == 804 then
        if not checktitle(actor, "ʥ��֮��") then
            messagebox(actor, "��û�л��[ʥ��֮��],�޷�����!")
            return
        end
        local mapID = "ʥ�˸�"
        FMapMoveEx(actor, mapID, 45, 30, 0)
    end
    -- Player.sendmsgEx(actor, npcid)
    if npcid > 2999 then
        local cfg = clickNpcCSD[npcid]
        if cfg then
            mapmove(actor, cfg.mapid, cfg.x, cfg.y, cfg.range)
        end
    end
    --��������
    local shengYinCfg = cfg_NpcDianJiShengYin[npcid]
    if shengYinCfg then
        playsound(actor, shengYinCfg.soundId, 1, 0)
    end
end

--����
function playlevelup(actor, level)
    local before_level = getplaydef(actor, VarCfg["U_����������ĵȼ�"])
    local cur_level = getbaseinfo(actor, ConstCfg.gbase.level)
    if cur_level > before_level then
        setplaydef(actor, VarCfg["U_����������ĵȼ�"], cur_level)
    end
    GameEvent.push(EventCfg.onPlayLevelUp, actor, cur_level, before_level)
end

--С�˴���
function playreconnection(actor)
    preventFrequentRequestsCache[actor] = nil --�����ֹ����Ļ���
    GameEvent.push(EventCfg.onExitGame, actor)
end

--������رտͻ��˴���
function playoffline(actor)
    preventFrequentRequestsCache[actor] = nil --�����ֹ����Ļ���
    GameEvent.push(EventCfg.onExitGame, actor)
end

--����
function triggerchat(actor, sMsg, chat)
    GameEvent.push(EventCfg.onTriggerChat, actor, sMsg, chat)
end

--��ֵ
function recharge(actor, gold, productid, moneyid)
    -- local name = getbaseinfo(actor, ConstCfg.gbase.name)
    -- sendmsg(actor, 1, '{"Msg":"<font color=\'#ff0000\'>���'.. name ..'������</font>","Type":0}')
    -- sendmsg(actor, 1, '{"Msg":"<font color=\'#ff0000\'>����'.. moneyid ..'������</font>","Type":0}')
    -- sendmsg(actor, 1, '{"Msg":"<font color=\'#ff0000\'>����'.. gold ..'������</font>","Type":0}')
    -- sendmsg(actor, 1, '{"Msg":"<font color=\'#ff0000\'>NPC'.. productid ..'������</font>","Type":0}')

    GameEvent.push(EventCfg.onRecharge, actor, gold, productid, moneyid)
end

--���ﴩװ��----���ﴩ������װ������
function takeonex(actor, itemobj, where, itemname, makeid)
    GameEvent.push(EventCfg.onTakeOnEx, actor, itemobj, where, itemname, makeid)
    if itemname == "ҹ����" then
        local level = getbaseinfo(actor, ConstCfg.gbase.level)
        if level >= 320 then
            changelevel(actor, "+", 1)
        end
    elseif itemname == "Ԥ����" then
        setskillinfo(actor, 2013, 2, 1)
    end
end

--������װ��---������������װ������
function takeoffex(actor, itemobj, where, itemname, makeid)
    if getplaydef(actor, VarCfg.Die_Flag) == 1 then --������װ��
        local dropinfo = getplaydef(actor, VarCfg.Die_Drop_item)
        if dropinfo == "" then
            dropinfo = itemname .. "[����]"
        else
            dropinfo = dropinfo .. "��" .. itemname .. "[����]"
        end
        setplaydef(actor, VarCfg.Die_Drop_item, dropinfo)
    end
    if itemname == "ҹ����" then
        local level = getbaseinfo(actor, ConstCfg.gbase.level)
        if level >= 321 then
            changelevel(actor, "-", 1)
        end
    elseif itemname == "Ԥ����" then
        setskillinfo(actor, 2013, 2, 0)
    end
    GameEvent.push(EventCfg.onTakeOffEx, actor, itemobj, where, itemname, makeid)
end

--�������ӡ
function takeon14(actor, itemobj)
    GameEvent.push(EventCfg.onTakeOn14, actor, itemobj)
end

--�Ѽ����ӡ
function takeoff14(actor, itemobj)
    GameEvent.push(EventCfg.onTakeOff14, actor, itemobj)
end

--�·�  0  <$DRESS>
function takeon0(actor, itemobj)
    local itemname = getconst(actor, "<$DRESS>")
    if itemname == "���}�������֮��" then -- ���}�������֮�� ����ʱ������[1%-5%]������Ԫ��
        local addvar = getnewitemaddvalue(itemobj, 7)
        if addvar == 0 then
            local num = math.random(1, 5)
            setnewitemvalue(actor, -2, 7, "+", num, itemobj)
            refreshitem(actor, itemobj)
        end
    end
    GameEvent.push(EventCfg.onTakeOn0, actor, itemobj)
end

--�·�  0  <$DRESS>
function takeoff0(actor, itemobj)
    GameEvent.push(EventCfg.onTakeOff0, actor, itemobj)
end

--����  1
function takeon1(actor, itemobj)
    local itemname = getiteminfo(actor, itemobj, 7)
    if itemname == "����֮�С�����" or itemname == "������֮��" then
        Player.setAttList(actor, "��������")
    end
end

--����  1
function takeoff1(actor, itemobj)
    local itemname = getiteminfo(actor, itemobj, 7)
    if itemname == "����֮�С�����" or itemname == "������֮��" then
        Player.setAttList(actor, "��������")
    end
end

--ѫ�´�������---��
function takeon2(actor, itemobj)
    local itemname = getconst(actor, ConstCfg.equipconst["ѫ��"])

    -- �������� ����ʱ������[1%-10%]������Ԫ��
    if itemname == "������" then
        addbuff(actor, 30066)
    end

    -- ��ҫ�����֮Ӱ �����󼤻�����[ȫ��ڻ�]��״̬�ڻ�״̬������(5%)����󹥻���
    if itemname == "��ҫ�����֮Ӱ" then
        addbuff(actor, 30074)
    end

    Player.setAttList(actor, "��Ѫ����")
end

--ѫ���ѵ�����---��
function takeoff2(actor, itemobj)
    local itemname = getiteminfo(actor, itemobj, 7)

    -- ������ ÿ��(60S)����[10%]����󹥻���(Ч������20��)
    if itemname == "������" then
        FkfDelBuff(actor, 30066)
    end

    -- ��ҫ�����֮Ӱ �����󼤻�����[ȫ��ڻ�]��״̬�ڻ�״̬������(5%)����󹥻���
    if itemname == "��ҫ�����֮Ӱ" then
        FkfDelBuff(actor, 30074)
    end
    Player.setAttList(actor, "��Ѫ����")
end

--ͷ����������---��
function takeon4(actor, itemobj)
    local itemname = getiteminfo(actor, itemobj, 7)
    -- �������� ����ʱ������[1%-10%]������Ԫ��
    if itemname == "��������" then
        local addvar = getnewitemaddvalue(itemobj, 7)
        if addvar == 0 then
            local num = math.random(1, 10)
            setnewitemvalue(actor, 4, 7, "+", num, itemobj)
        end
    end

    if itemname == "����ͷ��" then
        addskill(actor, 85, 3)
    end
end

--ͷ���ѵ�����---��
function takeoff4(actor, itemobj)
    local itemname = getiteminfo(actor, itemobj, 7)
    if itemname == "����ͷ��" then
        delskill(actor, 85)
    end
end

--------------------------------------------------------------------�ҽ�ָ---------------------------------------------------------------------------------
--�ҽ�ָ--��������---ǰ
function takeonbefore7(actor, itemobj)
    local itemname = getiteminfo(actor, itemobj, 7)
    if itemname == "�������ǡ�Ԫ�ء�" then
        Player.sendmsgEx(actor, "��ʾ#251|:#255|װ��|�������ǡ�Ԫ�ء�#249|,ֻ�ܴ�����|����#249|λ��...")
        return false
    end

    if itemname == "����ǻ���ȼ���" then
        local attr = getbaseinfo(actor, 51, 30)
        if attr < 15 then
            Player.sendmsgEx(actor, "����ǻ���ȼ���#251|:#255|������������Ԫ��|����15%#249|,����ʧ��...")
            return false
        end
    end
end

--�ҽ�ָ--��������---��
function takeon7(actor, itemobj)
    local itemname = getiteminfo(actor, itemobj, 7)
    if itemname == "���ɻ꡿��֮��Ӱ" then
        local _table = json2tbl(getcustomitemprogressbar(actor, itemobj, 0)) --��ȡ��һ����������Ϣ
        if _table.open == 0 then                                             --�жϵ�һ���������Ƿ���
            local tbl1 = {
                ["open"] = 1,
                ["show"] = 2,
                ["name"] = "�ɻ�֮��",
                ["color"] = 253,
                ["imgcount"] = 1,
                ["cur"] = 0,
                ["max"] = 100,
                ["level"] = 1,
            }
            local tbl2 = {
                ["open"] = 1,
                ["show"] = 2,
                ["name"] = "�ɻ걶��",
                ["color"] = 253,
                ["imgcount"] = 1,
                ["cur"] = 0,
                ["max"] = 10,
                ["level"] = 1,
            }
            setcustomitemprogressbar(actor, itemobj, 0, tbl2json(tbl1))
            setcustomitemprogressbar(actor, itemobj, 1, tbl2json(tbl2))
            refreshitem(actor, itemobj)
        end
    end

    if itemname == "�ս���" then
        addbuff(actor, 31062)
    end
end

function takeoff7(actor, itemobj)
    local itemname = getiteminfo(actor, itemobj, 7)
    if itemname == "�ս���" then
        FkfDelBuff(actor, 31062)
    end
end

--------------------------------------------------------------------���ָ---------------------------------------------------------------------------------
--���ָ--��������---ǰ
function takeonbefore8(actor, itemobj)
    local itemname = getiteminfo(actor, itemobj, 7)
    if itemname == "���ɻ꡿��֮��Ӱ" then
        Player.sendmsgEx(actor, "��ʾ#251|:#255|װ��|���ɻ꡿��֮��Ӱ#249|,ֻ�ܴ�����|����#249|λ��...")
        return false
    end
    if itemname == "����ǻ���ȼ���" then
        local attr = getbaseinfo(actor, 51, 30)
        if attr < 15 then
            Player.sendmsgEx(actor, "����ǻ���ȼ���#251|:#255|������������Ԫ��|����15%#249|,����ʧ��...")
            return false
        end
    end
end

--���ָ--��������---��
function takeon8(actor, itemobj)
    local itemname = getiteminfo(actor, itemobj, 7)
    -- �������ǡ�Ԫ�ء� ����ʱ������[1%-5%]������Ԫ��
    if itemname == "�������ǡ�Ԫ�ء�" then
        local addvar = getnewitemaddvalue(itemobj, 0)
        if addvar == 0 then
            local num1 = math.random(1, 5)
            local num2 = math.random(1, 5)
            local num3 = math.random(1, 5)
            local num4 = math.random(1, 5)
            local num5 = math.random(1, 5)
            local num6 = math.random(1, 5)
            setnewitemvalue(actor, 8, 0, "+", num1, itemobj)
            setnewitemvalue(actor, 8, 1, "+", num2, itemobj)
            setnewitemvalue(actor, 8, 2, "+", num3, itemobj)
            setnewitemvalue(actor, 8, 3, "+", num4, itemobj)
            setnewitemvalue(actor, 8, 7, "+", num5, itemobj)
            setnewitemvalue(actor, 8, 8, "+", num6, itemobj)
        end
    end

    if itemname == "�ս���" then
        addbuff(actor, 31062)
    end
end

--���ָ-- ��װ������---��
function takeoff8(actor, itemobj)
    local itemname = getiteminfo(actor, itemobj, 7)
    if itemname == "�ս���" then
        FkfDelBuff(actor, 31062)
    end
end

--����--��������---��
function takeon9(actor, itemobj)
    local itemname = getconst(actor, "<$BUJUK>")
    -- ���¡�֮�� ÿ��19:00-07:00ʱ��μ������ԣ�����������+ 15%
    if itemname == "���¡�֮��" then
        if checktimeInPeriod(18, 59, 6, 59) then
            Player.setAttList(actor, "��������")
        end
    end
    GameEvent.push(EventCfg.onTakeOn9, actor, itemobj)
end

--����--�ѵ�����---��
function takeoff9(actor, itemobj)
    local itemname = getiteminfo(actor, itemobj, 7)

    -- ���¡�֮�� ÿ��19:00-07:00ʱ��μ������ԣ�����������+ 15%
    if itemname == "���¡�֮��" then
        if checktimeInPeriod(18, 59, 6, 59) then
            Player.setAttList(actor, "��������")
        end
    end


    GameEvent.push(EventCfg.onTakeOff9, actor, itemobj)
end

--����--��������---��
function takeon10(actor, itemobj)
    local itemname = getconst(actor, "<$BELT>")

    -- �����ǻ� ʮ��һɱCD��- 2��
    -- if itemname == "�����ǻ�" then
    --     setskilldeccd(actor, "ʮ��һɱ", "-", 4)
    -- end
end

--����--�ѵ�����---��
function takeoff10(actor, itemobj)
    local itemname = getiteminfo(actor, itemobj, 7)

    -- �����ǻ� ʮ��һɱCD��- 2��
    -- if itemname == "�����ǻ�" then
    --     setskilldeccd(actor, "ʮ��һɱ", "=", 0)
    -- end
end

--ѥ�Ӵ�������---��
function takeon11(actor, itemobj)
    local itemname = getiteminfo(actor, itemobj, 7)
    -- ����սѥ ����ʱ������[1%-5%]������Ԫ��
    if itemname == "����սѥ" then
        local addvar = getnewitemaddvalue(itemobj, 0)
        if addvar == 0 then
            local num1 = math.random(1, 5)
            local num2 = math.random(1, 5)
            local num3 = math.random(1, 5)
            local num4 = math.random(1, 5)
            local num5 = math.random(1, 5)
            local num6 = math.random(1, 5)
            setnewitemvalue(actor, 11, 0, "+", num1, itemobj)
            setnewitemvalue(actor, 11, 1, "+", num2, itemobj)
            setnewitemvalue(actor, 11, 2, "+", num3, itemobj)
            setnewitemvalue(actor, 11, 3, "+", num4, itemobj)
            setnewitemvalue(actor, 11, 7, "+", num5, itemobj)
            setnewitemvalue(actor, 11, 8, "+", num6, itemobj)
        end
    end

    -- ����ĺ���սѥ ��������������������(��������ֵ) ����+30%
    if itemname == "����ĺ���սѥ" then
        addbuff(actor, 30070)
    end
    GameEvent.push(EventCfg.onTakeOn11, actor, itemobj, itemname)
end

--ѥ�����´���---��
function takeoff11(actor, itemobj)
    local itemname = getiteminfo(actor, itemobj, 7)
    if itemname == "����ĺ���սѥ" then
        FkfDelBuff(actor, 30070)
    end
    GameEvent.push(EventCfg.onTakeOff11, actor, itemobj, itemname)
end

--��������----��
function takeon43(actor, itemobj)
    GameEvent.push(EventCfg.onTakeOn43, actor, itemobj)
end

--��������----ǰ
function takeoffbefore43(actor, itemobj)
    Player.sendmsgEx(actor, "��λ�ò���������!")
    return false
end

--ʱװͷ����
function takeon21(actor, itemobj)
    GameEvent.push(EventCfg.onTakeOn21, actor, itemobj)
end

--ʱװͷ������
function takeoff21(actor, itemobj)
    GameEvent.push(EventCfg.onTakeOff21, actor, itemobj)
end

--ʱװͷ����������---��
function takeon26(actor, itemobj)
    local itemname = getconst(actor, "<$SRIGHTHAND>")
    if not itemname then return end
    if itemname == "�ź��䡤���������" then
        local usenum = getitemaddvalue(actor, itemobj, 2, 19, nil) --��ȡ��Ϣ
        if usenum == 0 then                                        --�Ѿ�ʹ�õ���δ��ʧ��װ��
            local color = { 254, 242, 249, 116, 251 }
            local number = { "��", "��", "��", "��", "��" }
            local attnum = math.random(1, 5)
            changeitemname(actor, 26, "�ź��䡤���������[����" .. number[attnum] .. "]") --�޸�װ����ʾ����
            changeitemnamecolor(actor, itemobj, color[attnum]) --�޸�װ��������ɫ
            setitemaddvalue(actor, itemobj, 2, 19, attnum) --����װ����Ǵ���13����������=10ʱ װ����ʧ��
        elseif usenum == 1 then --��������10%����
            addbuff(actor, 30096)
        elseif usenum == 2 then --ȫ������ȴCD-2��
            setskilldeccd(actor, "�һ𽣷�", "-", 2)
            setskilldeccd(actor, "����ն", "-", 2)
            setskilldeccd(actor, "���ս���", "-", 2)
        elseif usenum == 3 then --����������������10%����
            addbuff(actor, 30097)
        end
    end

    if itemname == "�����ߵ��ؼ�" then
        local usenum = getitemaddvalue(actor, itemobj, 2, 19, nil) --��ȡ��Ϣ
        if usenum <= 10 and usenum ~= 0 then --�Ѿ�ʹ�õ���δ��ʧ��װ��
            return
        elseif usenum == 0 then --��һ�δ���
            changeitemname(actor, 26, "�����ߵ��ؼ�[��ʹ��:3��]") --�޸�װ����ʾ����
            changeitemnamecolor(actor, itemobj, 70) --�޸�װ��������ɫ
            setitemaddvalue(actor, itemobj, 2, 19, 13) --����װ����Ǵ���13����������=10ʱ װ����ʧ��
        end
        if Player.Checkskill(actor, "ħ����") then
            local magiclvevl = getskillinfo(actor, 31, 1)
            setskillinfo(actor, 31, 1, magiclvevl + 1)
        end
    end

    if itemname == "����֮�񱦲�" then
        local bool = Player.progressbarEX(actor, itemobj, 0, "open", "��ѯ")
        if not bool then
            local tbl = {
                ["open"] = 1, --/0-�رգ�1-��
                ["show"] = 2, --//0-����ʾ��ֵ��1-�ٷֱȣ�2-����
                ["name"] = "����֮��:", --//�������ı�
                ["color"] = 250, --//��������ɫ��0~255
                ["imgcount"] = 1, --//ͼƬ��������1����
                ["cur"] = 0, --//��ǰֵ
                ["max"] = 666, --//���ֵ
                ["level"] = 0, --//����(0~65535)
            }
            setcustomitemprogressbar(actor, itemobj, 0, tbl2json(tbl))
            refreshitem(actor, itemobj)
        end
    end
end

--ʱװͷ����������---��
function takeoff26(actor, itemobj)
    local itemname = getiteminfo(actor, itemobj, 7)
    if not itemname then return end

    if itemname == "�ź��䡤���������" then
        local usenum = getitemaddvalue(actor, itemobj, 2, 19, nil) --��ȡ��Ϣ
        if usenum == 1 then                                        --��������10%����
            FkfDelBuff(actor, 30096)
        elseif usenum == 2 then                                    --ȫ������ȴCD-2��
            setskilldeccd(actor, "�һ𽣷�", "+", 2)
            setskilldeccd(actor, "����ն", "+", 2)
            setskilldeccd(actor, "���ս���", "+", 2)
        elseif usenum == 3 then --����������������10%����
            FkfDelBuff(actor, 30097)
        end
    end
end

--���κ�λ��9
function takeon38(actor, itemobj)
    local itemname = getconst(actor, "<$GODBLESSITEM9>")
    if not itemname then return end

    if itemname == "ǿ��+9999" then
        local usenum = getitemaddvalue(actor, itemobj, 2, 19, nil) --��ȡ��Ϣ
        if usenum <= 10 and usenum ~= 0 then --�Ѿ�ʹ�õ���δ��ʧ��װ��
            return
        elseif usenum == 0 then --��һ�δ���
            changeitemname(actor, 38, "ǿ��+9999[��ʹ��:3��]") --�޸�װ����ʾ����
            changeitemnamecolor(actor, itemobj, 70) --�޸�װ��������ɫ
            setitemaddvalue(actor, itemobj, 2, 19, 13) --����װ����Ǵ���13����������=10ʱ װ����ʧ��
        end
    end
end

--ʱװ����  42  <$SHORSE>  <$SHORSEID>
function takeon42(actor, itemobj)
    local itemname = getconst(actor, "<$SHORSE>")
    if itemname == "����֮��" then -- ����֮�� ��һ�δ���ʱ������[1%-15%]������Ԫ��
        local addvar = getnewitemaddvalue(itemobj, 7)
        if addvar == 0 then
            local num = math.random(1, 15)
            setnewitemvalue(actor, 42, 7, "+", num, itemobj)
        end
    end
end

--���κ�λ��11 40  <$SHORSE>  <$SHORSEID>
function takeon40(actor, itemobj)
    GameEvent.push(EventCfg.onTakeOn40, actor, itemobj)
end

--���κ�λ��11 40  <$SHORSE>  <$SHORSEID>
function takeoff40(actor, itemobj)
    GameEvent.push(EventCfg.onTakeOff40, actor, itemobj)
end

--�Զ���װ���ڶ���λ��  72  <$SHORSE>  <$SHORSEID>
function takeon72(actor, itemobj)
    local itemname = getiteminfo(actor, itemobj, 7)
    --�صؤξ۹⽣ �״δ���ʱ������[1-88]�㹥����
    if itemname == "�صؤξ۹⽣" then
        local attnum = getitemaddvalue(actor, itemobj, 1, 2, 0)
        if attnum == 0 then
            local num = math.random(1, 88)
            setitemaddvalue(actor, itemobj, 1, 2, num)
            refreshitem(actor, itemobj) --ˢ����Ʒ��ǰ��
        end
    end
    GameEvent.push(EventCfg.onTakeOn72, actor, itemobj, itemname)
end

--�Զ���װ���ڶ���λ��  72  <$SHORSE>  <$SHORSEID>
function takeoff72(actor, itemobj)
    local itemname = getiteminfo(actor, itemobj, 7)
    GameEvent.push(EventCfg.onTakeOff72, actor, itemobj, itemname)
end

--ʱװͷ���ѵ�����---ǰ
function takeoffbefore26(actor, itemobj)
    local itemname = getconst(actor, "<$SRIGHTHAND>")
    if itemname == "�����ߵ��ؼ�" then
        if Player.Checkskill(actor, "ħ����") then
            local magiclvevl = getskillinfo(actor, 31, 1)
            setskillinfo(actor, 31, 1, magiclvevl - 1)
        end
    end
end

--������Ʒǰ����
function dropitemfrontex(actor, dropItem, itemName)
    if getplaydef(actor, VarCfg.Die_Flag) == 1 then --������װ��
        local dropinfo = getplaydef(actor, VarCfg.Die_Drop_item)
        if dropinfo == "" then
            dropinfo = itemName .. "[����]"
        else
            dropinfo = dropinfo .. "��" .. itemName .. "[����]"
        end
        setplaydef(actor, VarCfg.Die_Drop_item, dropinfo)
    end
end

--��������
-- function crittrigger(actor, attack, damage)
--     --�����ܵ����Թ���Ĺ̶��˺�
--     -- if getbaseinfo(attack,-1) then  --�������������ʱ
--     --     if not getbaseinfo(actor,-1) then  --�������ǹ���ʱʱ
--     --         local dec_value = getbaseinfo(attack, ConstCfg.gbase.custom_attr, ConstCfg.custom_attr.attr200) or 0
--     --         damage = damage - dec_value
--     --     end
--     -- end
--     -- return damage
-- end

--����ǰ����
--Target	object	�ܻ�����
--Hiter	    object	��������
--MagicId	int	    ����ID
--Damage	int	    �˺�
--result	int	    ����ֵ���޸ĺ���˺�
local cfg_monYaZhi = include("QuestDiary/cfgcsv/cfg_TaiYangShengCheng_Mon.lua")                                           -- ������Ϣ
local cfg_QiXingDamage = { [8] = 7, [7] = 77, [6] = 777, [5] = 7777, [4] = 77777, [3] = 777777, [2] = 7777777, [1] = 77777777 } --���ǹ������˺�
function attackdamage(actor, Target, Hiter, MagicId, Damage, Model)
    if actor == Target then return end
    if hasbuff(actor, 30020) then return end                                                                                    --��������buff ������д���
    local attackDamageData = { damage = 0 }
    --��������
    local monName
    local attackType = true
    if getbaseinfo(Target, -1) == false then
        attackType = false
        monName = getbaseinfo(Target, ConstCfg.gbase.name)
        if monName == "������" then
            if not checktitle(actor, "��������") then
                Player.sendmsgEx(actor, "��û��|��������#249|�ƺţ��޷���|������#249|����˺�")
                return 0
            end
        elseif monName == "��������" then
            if checkitemw(actor, "��Ӱ��ì", 1) then
                return 20000
            else
                return 100
            end
        elseif monName == "��������̫�����Ǿ���������" then
            local MonNum = getmoncount("���ǹ�����", -1, true)
            local QiXingDamage = cfg_QiXingDamage[MonNum]
            return QiXingDamage
        end
        local BuZaoChengEWaiShangHai = cfg_BuZaoChengEWaiShangHai[monName]
        if not BuZaoChengEWaiShangHai then
            GameEvent.push(EventCfg.onAttackDamageMonster, actor, Target, Hiter, MagicId, Damage, Model, attackDamageData)
        end
        --������
    else
        local BuffState = hasbuff(actor, 31065)
        if BuffState then
            local BuffNum = getbuffinfo(actor, 31065, 1)
            if BuffNum == 100 then
                humanhp(Target, "-", Player.getHpValue(Target, 15), 106, 0, actor)
                buffstack(actor, 31065, "=", 1, false)
            end
        end
        attackType = true
        GameEvent.push(EventCfg.onAttackDamagePlayer, actor, Target, Hiter, MagicId, Damage, Model, attackDamageData)
    end
    GameEvent.push(EventCfg.onAttackDamage, actor, Target, Hiter, MagicId, Damage, Model, attackDamageData)
    local currDamage = Damage + attackDamageData.damage
    if attackType then
        currDamage = currDamage * 0.5
    end
    -- �˺�ѹ��
    local cfg = cfg_monYaZhi[monName]
    if cfg then
        local AttNum = getplaydef(actor, VarCfg["U_��ҫ���_�˺�ѹ��"])
        AttNum = AttNum / 100
        currDamage = currDamage - (currDamage * (0.9 - AttNum))
    end
    return math.ceil(currDamage)
end

--��������������ӳ�亯��
local attackMonFunc = {
    ["������"] = function(actor)
        if not checktitle(actor, "��������") then
            return false
        end
    end,
    ["ţ������"] = function(actor)
        changemoney(actor, 2, "+", 100, "100", true)
        return false
    end
}
local cfg_BuBeiQieGeMon = include("QuestDiary/cfgcsv/cfg_BuBeiQieGeMon.lua")   --�����и�Ĺ���
local cfg_GuaiWuFanShang = include("QuestDiary/cfgcsv/cfg_GuaiWuFanShang.lua") --���˵Ĺ���
--��ͨ��������
---* actor:��Ҷ���
---* Target���ܻ�����
---* Hiter����������
---* MagicId������ID
function attack(actor, Target, Hiter, MagicId)
    if actor == Target then return end
    -- FAddBuffKF(actor, 10001, 3)       --���ս��״̬
    addbuff(actor, 10001, 3)                 --����ս��״̬
    if MagicId == 2013 then return end
    if hasbuff(actor, 30020) then return end --��������buff ������д���
    --��������
    if getbaseinfo(Target, -1) == false then
        local monName = getbaseinfo(Target, ConstCfg.gbase.name)
        local myName = getbaseinfo(actor, ConstCfg.gbase.name)
        if ismob(Target) then return end
        if monName:find(myName) then
            return
        end
        local attackFunc = attackMonFunc[monName]
        if attackFunc then
            return attackFunc(actor)
        end
        local BuZaoChengEWaiShangHai = cfg_BuZaoChengEWaiShangHai[monName]
        if BuZaoChengEWaiShangHai then
            return
        end
        local qieGe = { damage = 0 }
        qieGe.damage = getbaseinfo(actor, ConstCfg.gbase.custom_attr, 200)
        if MagicId ~= 25 and MagicId ~= 114 then
            GameEvent.push(EventCfg.onAttackMonster, actor, Target, Hiter, MagicId, qieGe, monName)
        end
        if not cfg_BuBeiQieGeMon[monName] then
            humanhp(Target, "-", qieGe.damage, 106, 0, actor)
        end
        --������
        --���˹�
        local fsMon = cfg_GuaiWuFanShang[monName]
        if fsMon then
            local FanShangDiKang = getbaseinfo(actor, ConstCfg.gbase.custom_attr, 231)
            local fanShang = fsMon.value - FanShangDiKang
            local fanShangResult = 0
            if fanShang <= 0 then
                fanShangResult = 0
            else
                fanShangResult = fanShang
            end
            local damageValue = tonumber(getconst(actor, "<$DAMAGEVALUE>")) or 0
            local damage = math.floor(damageValue * fanShangResult / 100)
            humanhp(actor, "-", damage, 111, 0, Target) --����
        end
    else
        GameEvent.push(EventCfg.onAttackPlayer, actor, Target, Hiter, MagicId)
    end
    GameEvent.push(EventCfg.onAttack, actor, Target, Hiter, MagicId)
end

--����ʹ�����⼼��ǰ����
function beginmagic(actor, MagicId, maigicName, target, x, y)
    if MagicId == 2013 then
        if getbaseinfo(target, -1) then
            return false
        end
    end
    -- local isFengYin = (os.time() - getplaydef(actor, "N$����Ұ������CD")) <= 2
    -- if isFengYin then
    --     Player.sendmsgEx(actor, "��ʾ#251|:#255|�㵱ǰ����|���ܷ�ӡ#249|״̬��...")
    --     return false
    -- end --��������buff ������д���

    -- local isFengYinLieHuo = (os.time() - getplaydef(actor, VarCfg["N$�һ��ӡCD"])) <= 2
    -- if isFengYinLieHuo then
    --     if MagicId == 26 then
    --         Player.sendmsgEx(actor, "��ʾ#251|:#255|�㵱ǰ����|���ܷ�ӡ#249|״̬��...")
    --         return false
    --     end
    -- end
    -- GameEvent.push(EventCfg.onBeginMagic, actor, MagicId, maigicName, target, x, y)
end

--ħ����������
-- function magicattack(actor, Target, Hiter, MagicId)
--     if hasbuff(actor, 30020) then return end --��������buff ������д���
--     --��������
--     if getbaseinfo(Target, -1) == false then
--         local monName = getbaseinfo(Target, ConstCfg.gbase.name)
--         local BuZaoChengEWaiShangHai = cfg_BuZaoChengEWaiShangHai[monName]
--         if BuZaoChengEWaiShangHai then
--             return
--         end
--         GameEvent.push(EventCfg.onAttackMonster, actor, Target, Hiter, MagicId)
--     end
-- end

--ʹ�ü������
function magtagfunc2023(actor, Target)
    GameEvent.push(EventCfg["ʹ�ü������"], actor, Target)
    GameEvent.push(EventCfg["ʹ�ü���ͨ���ɷ�"], actor, 2023)
end

--ʹ��ʮ��һɱ
function magtagfunc82(actor, Target)
    GameEvent.push(EventCfg["ʹ��ʮ��һɱ"], actor, Target)
    GameEvent.push(EventCfg["ʹ�ü���ͨ���ɷ�"], actor, 82)
end

--ʹ��Ұ������
function magtagfunc27(actor, Target)
    GameEvent.push(EventCfg["ʹ��Ұ������"], actor, Target)
    GameEvent.push(EventCfg["ʹ�ü���ͨ���ɷ�"], actor, 27)
end

--ʹ��Ұ���շ�
function magselffunc27(actor)
    GameEvent.push(EventCfg["ʹ�ü���ͨ���ɷ�"], actor, 27)
end

--�ͷ�����ٵ�
function magselffunc114(actor)
    GameEvent.push(EventCfg["ʹ�ü���ͨ���ɷ�"], actor, 114)
end
--ʹ�÷�����
function magselffunc2014(actor)
    releasemagic(actor, 74, 1, 3, 2, 0)
    GameEvent.push(EventCfg["ʹ�ü���ͨ���ɷ�"], actor, 2014)
end

--ʹ��ȼ�շ���
function magselffunc2020(actor)
    GameEvent.push(EventCfg["ʹ��ȼ�շ���"], actor)
    GameEvent.push(EventCfg["ʹ�ü���ͨ���ɷ�"], actor, 2020)
end

--��������ͨ
function struck(actor, Target, Hiter, MagicId)
    if hasbuff(actor, 30020) then return end --��������buff ������д���
    --�����﹥��
    if getbaseinfo(Target, -1) == false then
        local monName = getbaseinfo(Target, ConstCfg.gbase.name)
        local BuZaoChengEWaiShangHai = cfg_BuZaoChengEWaiShangHai[monName]
        if BuZaoChengEWaiShangHai then
            return
        end
        GameEvent.push(EventCfg.onStruckMonster, actor, Target, Hiter, MagicId)
        --���˹���
    else
        GameEvent.push(EventCfg.onStruckPlayer, actor, Target, Hiter, MagicId)
    end
    GameEvent.push(EventCfg.onStruck, actor, Target, Hiter, MagicId)
end

--������ħ��
function magicstruck(actor, Target, Hiter, MagicId)
    if hasbuff(actor, 30020) then return end --��������buff ������д���
    --��������
    if getbaseinfo(Target, -1) == false then
        --������
    else
        addbuff(actor, 10001, 3) --ս��״̬
    end
end

--ö��ԪӤ״̬���ߵļ���
local immunityMagicId = {
    [26] = 1,
    [56] = 1,
    [66] = 1,
    [82] = 1,
    [114] = 1,
}
--������ǰ����
function struckdamage(actor, Target, Hiter, MagicId, Damage)
    if hasbuff(actor, 30020) then return end --��������buff ������д���
    -- +������
    -- -�����˺�
    local attackDamageData = { damage = 0 }
    local isPlayer = getbaseinfo(Target, -1)
    --�����﹥��
    if isPlayer == false then
        GameEvent.push(EventCfg.onStruckDamageMonster, actor, Target, Hiter, MagicId, Damage, attackDamageData)
        --���˹���
    else
        GameEvent.push(EventCfg.onStruckDamagePlayer, actor, Target, Hiter, MagicId, Damage, attackDamageData)
        if checkkuafu(actor) then
            FAddBuffKF(actor, 10001, 3)
        else
            addbuff(actor, 10001, 3) --ս��״̬
        end
    end
    GameEvent.push(EventCfg.onStruckDamage, actor, Target, Hiter, MagicId, Damage, attackDamageData)
    local finalDamage = Damage - attackDamageData.damage
    --ԪӤ״̬
    if immunityMagicId[MagicId] then
        if hasbuff(actor, 30099) then
            finalDamage = 0
        end
    end
    if getflagstatus(actor, VarCfg["F_����_����ת����ʶ"]) == 1 then
        local myMaxHp = getbaseinfo(actor, ConstCfg.gbase.maxhp)
        local percentage = calculatePercentage(finalDamage, myMaxHp)
        if percentage >= 33 then
            local currDame = math.ceil(Player.getHpValue(actor, 33))
            Player.buffTipsMsg(actor, "[����ת��]:Ϊ��ֵ���{" .. finalDamage - currDame .. "/FCOLOR=249}���˺�!")
            finalDamage = currDame
        end
    end
    if isPlayer then
        local targetHunZhuangLevel = getplaydef(Target, VarCfg["U_��װ�ȼ�"]) --�����߻�װ�ȼ�
        if targetHunZhuangLevel > 0 then
            local myHunZhuangLevel = getplaydef(actor, VarCfg["U_��װ�ȼ�"]) --�ҵĻ�װ�ȼ�
            local percentage = 0
            if myHunZhuangLevel == targetHunZhuangLevel then
                percentage = 0.1
            elseif myHunZhuangLevel > targetHunZhuangLevel then
                percentage = 0.25
            end
            if percentage > 0 then
                finalDamage = finalDamage - math.floor(finalDamage * percentage)
            end
        end
    end
    if finalDamage < 0 then
        finalDamage = 0
    end
    --�ǻԵĵ���T  8%���ʸ�һ���˺�
    if getplaydef(actor, VarCfg["S$�ǻԵĵ���"]) == "��" then
        finalDamage = 0
        setplaydef(actor, VarCfg["S$�ǻԵĵ���"], "")
    end
    if hasbuff(actor, 31101) then
        finalDamage = 0
    end
    return finalDamage
end

--����װ
function groupitemonex(actor, idx)
    --��½ʱ����ͳ������Ч��װ
    local longinTmpIdx = Player.getJsonTableByVar(actor, "S$��װ��¼")
    table.insert(longinTmpIdx, idx)
    Player.setJsonVarByTable(actor, "S$��װ��¼", longinTmpIdx)
    if getplaydef(actor, VarCfg["N$�Ƿ��¼���"]) == 1 then
        local suitIds = Player.getJsonTableByVar(actor, VarCfg["T_��¼��װID"])
        table.insert(suitIds, idx)
        table.uniqueArray(suitIds)
        Player.setJsonVarByTable(actor, VarCfg["T_��¼��װID"], suitIds)
        GameEvent.push(EventCfg.onGroupItemOnEx, actor, idx)
    end
end

--����װ
function groupitemoffex(actor, idx)
    if getplaydef(actor, VarCfg["N$�Ƿ��¼���"]) == 1 then
        local suitIds = Player.getJsonTableByVar(actor, VarCfg["T_��¼��װID"])
        table.removebyvalue(suitIds, idx)
        table.uniqueArray(suitIds)
        Player.setJsonVarByTable(actor, VarCfg["T_��¼��װID"], suitIds)
        GameEvent.push(EventCfg.onGroupItemOffEx, actor, idx)
    end
end

-- --ת����װ ����
function groupitemon398(actor, idx)
    local hpmax = getbaseinfo(actor, ConstCfg.gbase.maxhp)
    local dcnum = hpmax / 100
    if dcnum > 2000 then
        dcnum = 2000
    end
    addattlist(actor, "ת����װ", "+", "3#4#" .. math.floor(dcnum) .. "", 1)
end

-- --ת����װ �ѵ�
function groupitemoff398(actor, idx)
    delattlist(actor, "ת����װ")
end

-- �����װ ����
function groupitemon480(actor, idx)
    addbuff(actor, 30080)
end

-- �����װ �ѵ�
function groupitemoff480(actor, idx)
    delbuff(actor, 30080)
    setplaydef(actor, VarCfg["S$_���״̬"], "") --�����´��˺�����
    clearplayeffect(actor, 16016)
end

-- �����ǻ� ����
function groupitemon782(actor, idx)
    setskilldeccd(actor, "ʮ��һɱ", "-", 2)
end

-- �����ǻ� �ѵ�
function groupitemoff782(actor, idx)
    setskilldeccd(actor, "ʮ��һɱ", "=", 0)
end

--�ӳ�����
function yan_chi_zhao_ming(actor)
    setcandlevalue(actor, 100)
end

-- ҹ���� ����
function groupitemon814(actor, idx)
    delaygoto(actor, 100, "yan_chi_zhao_ming")
end

--ҹ���� �ѵ�
function groupitemoff814(actor, idx)
    if not checkitemw(actor, "ҹ����", 1) and not checkitemw(actor, "���±���", 1) and not checkitemw(actor, "�����ڵ�", 1) then
        setcandlevalue(actor, 10)
    end
end

-- ���±��� ����
function groupitemon837(actor, idx)
    delaygoto(actor, 500, "yan_chi_zhao_ming")
end

--���±��� �ѵ�
function groupitemoff837(actor, idx)
    if not checkitemw(actor, "ҹ����", 1) and not checkitemw(actor, "���±���", 1) and not checkitemw(actor, "�����ڵ�", 1) then
        setcandlevalue(actor, 10)
    end
end

-- �����ڵ� ����
function groupitemon838(actor, idx)
    delaygoto(actor, 500, "yan_chi_zhao_ming")
end

--�����ڵ� �ѵ�
function groupitemoff838(actor, idx)
    if not checkitemw(actor, "ҹ����", 1) and not checkitemw(actor, "���±���", 1) and not checkitemw(actor, "�����ڵ�", 1) then
        setcandlevalue(actor, 10)
    end
end

-- ����ǻ���ȼ��� ����
function groupitemon930(actor, idx)
    addbuff(actor, 31082)
end

--����ǻ���ȼ��� �ѵ�
function groupitemoff930(actor, idx)
    delbuff(actor, 31082)
end

-- ������ ����
function groupitemon936(actor, idx)
    addbuff(actor, 31088)
end

-- ������ �ѵ�
function groupitemoff936(actor, idx)
    delbuff(actor, 31088)
end

-- �ڵ���ҹ ����
function groupitemon964(actor, idx)
    addbuff(actor, 31105)
end

-- �ڵ���ҹ �ѵ�
function groupitemoff964(actor, idx)
    delbuff(actor, 31105)
end

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- �e�e�����R�e�e  �e�e������e�e  ÿ3�㱩�����ʿɶ�������1�㹥���˺�Ԫ�� 2������
function groupitemon959(actor, idx)
    local baoji = getbaseinfo(actor, 51, 21) --��ȡ����
    local tmpBaoJi = gethumnewvalue(actor, 21) --��ȡ��ʱ����
    if tmpBaoJi > 0 then --�����ʱ��������0 ���ȥ��ʱ����
        baoji = baoji - tmpBaoJi
    end
    if baoji <= 0 then --�������С�ڵ���0 �򲻴���
        return
    end
    delattlist(actor, "����������") --������
    local att = math.floor(baoji / 3)
    if att >= 1 then
        addattlist(actor, "����������", "=", "3#25#" .. att .. "", 1)
    end
end

-- �e�e�����R�e�e  �e�e������e�e  ÿ3�㱩�����ʿɶ�������1�㹥���˺�Ԫ�� 2������
function groupitemoff959(actor, idx)
    delattlist(actor, "����������") --������
end

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- �����׵�������|�������������   "�Թ��˺���ֵ�������֮һ �������100% 10%�����и����1%Ѫ�� ����Ѫ������40%ʱʧЧ"
function groupitemon960(actor, idx)
    delattlist(actor, "�׵�������") --������
    local AttrNum75 = getbaseinfo(actor, 51, 75) --75������ �Թ�����
    local _att = math.floor(AttrNum75 * 0.333)
    local att = (_att >= 100 and 100) or _att
    if att >= 1 then
        addattlist(actor, "�׵�������", "=", "3#75#" .. att .. "", 1)
    end
end

-- �����׵�������|�������������   "�Թ��˺���ֵ�������֮һ �������100% 10%�����и����1%Ѫ�� ����Ѫ������40%ʱʧЧ"
function groupitemoff960(actor, idx)
    delattlist(actor, "�׵�������") --������
end

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- ��������潛����|����ˮ�R̫�O���� ����2%������������2%�˺�����
function groupitemon961(actor, idx)
    delattlist(actor, "���������") --������
    local RenewLevel = getbaseinfo(actor, ConstCfg.gbase.renew_level)
    addattlist(actor, "���������", "=", "3#26#" .. RenewLevel * 2 .. "", 1) --�����˺�����
    Player.setAttList(actor, "��������")
end

-- ��������潛����|����ˮ�R̫�O���� ����2%������������2%�˺�����
function groupitemoff961(actor, idx)
    delattlist(actor, "���������") --������
    Player.setAttList(actor, "��������")
end

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- ��֮���ӻ�  ������Ϊ ʥ��֮��  ���������10%ȫ����
function groupitemon963(actor, idx)
    delattlist(actor, "��֮���ӻ�����") --������
    if checktitle(actor, "ʥ��֮��") then
        addattlist(actor, "��֮���ӻ�����", "=", "3#207#10|3#208#10|3#209#10|3#210#10|3#211#10|3#212#10|3#213#10|3#214#10", 1)
    end
end

-- ��֮���ӻ�  ������Ϊ ʥ��֮��  ���������10%ȫ����
function groupitemoff963(actor, idx)
    delattlist(actor, "��֮���ӻ�����") --������
end

--�л���ͼ
function entermap(actor, mapId, x, y)
    local former_mapid = getplaydef(actor, VarCfg.S_cur_mapid)
    local cur_mapid = mapId
    if cur_mapid ~= former_mapid then --�л��˵�ͼ
        setplaydef(actor, VarCfg.S_cur_mapid, cur_mapid)
        GameEvent.push(EventCfg.goSwitchMap, actor, cur_mapid, former_mapid, x, y)
    else
        GameEvent.push(EventCfg.goEnterMap, actor, cur_mapid, x, y)
    end
end

--�����뿪��ͼ����
function leavemap(actor, mapId, x, y)
    GameEvent.push(EventCfg.goLeaveMap, actor, mapId, x, y)
end

--��������֮ǰ����
function nextdie(actor, hiter, isplay)
    --��������� ����״̬������ʱ�ɻ��һ��ԭ�������Ļ��ᣡ(300��ֻ����һ��BUFF)
    if checkitemw(actor, "���������", 1) then
        if not ReliveMain.GetReliveState(actor) then --�ж�����״̬
            if randomex(20, 100) then
                if Player.checkCd(actor, VarCfg["���������CD"], 300, true) then
                    changemode(actor, 23, 1, 1, 1) --��Ӹ���״̬
                    Player.buffTipsMsg(actor, "[���������]:���{ԭ������/FCOLOR=243}Ч��,{300/FCOLOR=243}����ֻ�ܴ���һ��...")
                    return
                end
            end
        end
    end

    --��EX��������֮�� ����������ʱ����[ԭ�ظ���]��Ч�����Ҽ���(�޵�״̬)1�룡(CD500��)
    if getflagstatus(actor, VarCfg["F_��EX��������֮��"]) == 1 then
        if randomex(20, 100) then
            if Player.checkCd(actor, VarCfg["����֮��CD"], 500, true) then
                changemode(actor, 23, 1, 1, 1)    --��Ӹ���״̬
                changemode(actor, 1, 1, nil, nil) --�޵�1��
                Player.buffTipsMsg(actor, "[��EX��������֮��]:{����/FCOLOR=243}���ﲢ�޵�{1/FCOLOR=243}��...")
                return
            end
        end
    end

    --������ ��������[33%]�ĸ�����Ѫԭ�ظ�����ÿ��ָ�[33%]���������ֵ(��ѪЧ������3S��BUFF��ȴ��180S)
    if checkitemw(actor, "������", 1) then
        if randomex(1, 3) then
            if Player.checkCd(actor, VarCfg["������CD"], 180, true) then
                changemode(actor, 23, 1, 1, 1)     --��Ӹ���״̬
                addbuff(actor, 30068, 3, 1, actor) --��Ѫbuff
                Player.buffTipsMsg(actor, "[������]:����֮��������ÿ��ָ�[{33%/FCOLOR=243}]������ֵ,����[{3/FCOLOR=243}]��...")
                return
            end
        end
    end

    --��գ�ǧ��֮�� ���︴����ܽ���[�޵�״̬]1���� ������ʱ��(50%)�ĸ��ʿ�ԭ����������ȴʱ��90��
    if getflagstatus(actor, VarCfg["F_ǧ��֮��"]) == 1 then
        if randomex(1, 2) then
            if Player.checkCd(actor, VarCfg["ǧ��֮��CD"], 90, true) then
                changemode(actor, 23, 1, 1, 1) --��Ӹ���״̬
                changemode(actor, 1, 1)
                playeffect(actor, 16022, -10, -10, 1, 0, 0) --����޵���Ч
                Player.buffTipsMsg(actor, "[��գ�ǧ��֮��]:����֮�������޵�[{1/FCOLOR=243}]��...") --�޵�1��
                return
            end
        end
    end

    --���ˣ������������� ����50%����ԭ�ظ����ȴʱ��90��
    if getflagstatus(actor, VarCfg["F_����������������"]) == 1 then
        if randomex(1, 2) then
            if Player.checkCd(actor, VarCfg["������������CD"], 90, true) then
                changemode(actor, 23, 1, 1, 1) --��Ӹ���״̬
                Player.buffTipsMsg(actor, "[������������]:���˴���ԭ��վ������...")
                return
            end
        end
    end

    --�¼��ɷ�
    GameEvent.push(EventCfg.onNextDie, actor)
end

--��������
---* actor����ɱ�������
---* hiter��ɱ�˵����
function playdie(actor, hiter)
    local suitIds = Player.getJsonTableByVar(actor, VarCfg["T_��¼��װID"])
    local isdie = getbaseinfo(actor, ConstCfg.gbase.isdie)
    --LOGPrint("����״̬",isdie)
    -- Die.OpenUI(actor, hiter)
    --�ʼ���ʾ
    local uid = getbaseinfo(actor, ConstCfg.gbase.id)
    local time = os.date("%Y-%m-%d %H:%M:%S", os.time())
    local map_title = getbaseinfo(actor, ConstCfg.gbase.map_title)
    local map_id = getbaseinfo(actor, ConstCfg.gbase.mapid)

    local x, y = getbaseinfo(actor, ConstCfg.gbase.x), getbaseinfo(actor, ConstCfg.gbase.y)
    local hitername = Player.GetNameEx(hiter)
    local dropinfo = getplaydef(actor, VarCfg.Die_Drop_item)
    setplaydef(actor, VarCfg.Die_Drop_item, "")
    setplaydef(actor, VarCfg.Die_Flag, 0)

    if getplaydef(actor, VarCfg["N$�Ƿ��Ƹ���"]) == 1 then
        sendcentermsg(actor, 250, 0, string.format("ϵͳ��ʾ���㱻���{[%s]/FCOLOR=249}�Ƹ�����!!!", hitername), 0, 8)
        sendcentermsg(actor, 250, 0, string.format("ϵͳ��ʾ���㱻���{[%s]/FCOLOR=249}�Ƹ�����!!!", hitername), 0, 8)
        setplaydef(actor, VarCfg["N$�Ƿ��Ƹ���"], 0)
    end

    if dropinfo == "" then --û����Ʒ
        FSendmail(uid, 91, time, map_title, x, y, hitername)
    else
        local dropinfoTable = string.split(dropinfo, "��")
        --�����ظ�
        local i = 1
        while i < #dropinfoTable do
            local strTmp = string.gsub(dropinfoTable[i + 1], "%[����%]", "")
            if string.find(dropinfoTable[i], strTmp, 1, true) then
                table.remove(dropinfoTable, i)
                i = i + 1
            else
                i = i + 2
            end
        end
        dropinfo = table.concat(dropinfoTable, "��")
        FSendmail(uid, 89, time, map_title, x, y, hitername, dropinfo)
    end

    if getconst(actor, "<$SRIGHTHAND>") == "�����ߵ��ؼ�" then
        local itemobj = linkbodyitem(actor, 26)
        local usenum = getitemaddvalue(actor, itemobj, 2, 19) --��ȡ��Ϣ
        usenum = usenum - 1
        if usenum >= 11 then
            local _usenum = usenum - 10
            changeitemname(actor, 26, "�����ߵ��ؼ�[��ʹ��:" .. _usenum .. "��]") --�޸�װ����ʾ����
            setitemaddvalue(actor, itemobj, 2, 19, usenum) --����װ����Ǵ���13����������=10ʱ װ����ʧ��
        else
            takew(actor, "�����ߵ��ؼ�", 1)
            sendmail(getbaseinfo(actor, 2), 20000, "�����ߵ��ؼ�", "��ġ������ߵ��ؼ����Ѿ�ʹ��3�κ�������...", nil)
        end
    end

    --Զ�е��ٻ�  ����������ʱ���3*3��Χ�ڵ�ȫ��Ŀ����ɹ�����[333%]���˺�!
    if getflagstatus(actor, VarCfg["F_Զ�е��ٻ�"]) == 1 then
        local selfdc = getbaseinfo(actor, ConstCfg.gbase.dc2)
        local x, y = getbaseinfo(actor, ConstCfg.gbase.x), getbaseinfo(actor, ConstCfg.gbase.y)
        rangeharm(actor, x, y, 3, selfdc * 3.33, 0, nil, nil, 0, nil)
    end


    if table.contains(suitIds, tostring(602)) then
        local tgtname = getbaseinfo(hiter, ConstCfg.gbase.name)
        setplaydef(actor, VarCfg["S$_�����ʼǱ��"], tgtname)
    end

    --����
    Die.RequestRevive(actor, time, map_title, map_id, x, y, hitername)

    --�¼��ɷ�
    GameEvent.push(EventCfg.onPlaydie, actor, hiter)
    --������������
    if checkkuafu(actor) then
        FKuaFuToBenFuQiYuTitle(actor, EventCfg.onPlaydieQiYu, "")
    else
        GameEvent.push(EventCfg.onPlaydieQiYu, actor)
    end
end

--�����
function revival(actor)
    ---- ������ʾ ----
    setflagstatus(actor, VarCfg["F_��������"], 0) --����������
    setplaydef(actor, VarCfg.Die_Flag, 0) --����������
    setplaydef(actor, VarCfg["N$�Ƿ��Ƹ���"], 0) --�����˾�û���Ƹ���
    sendmsg(actor, 1, '{"Msg":"<font color=\'#ff0000\'>����������...</font>","Type":0}')
    playeffect(actor, 63059, 0, 0, 1, 1, 0)
    GameEvent.push(EventCfg.onRevive, actor)
end

--��ɫ��ȡ����ǰ����
function getexp(actor, exp)
    local expAddition = (getbaseinfo(actor, ConstCfg.gbase.custom_attr, 203) + 100) / 100
    exp = exp * expAddition
    return exp
end

--���Ըı䴥��
function sendability(actor)
    GameEvent.push(EventCfg.onSendAbility, actor)
end

--���ǿ�ʼ����
function castlewarstart()
    sendmsg("0", 2,
        '{"Msg":"���²��ĵ��꼤�飡�ֵ�Я�ֹ�սɳ�ǣ���ɳ�ѿ���������л�ӻԾ���룡����","FColor":249,"BColor":0,"Type":5,"Time":3,"SendName":"xxx","SendId":"123","Y":"30"}')
    sendmsg("0", 2,
        '{"Msg":"���²��ĵ��꼤�飡�ֵ�Я�ֹ�սɳ�ǣ���ɳ�ѿ���������л�ӻԾ���룡����","FColor":249,"BColor":0,"Type":5,"Time":3,"SendName":"xxx","SendId":"123","Y":"60"}')
    sendmsg("0", 2,
        '{"Msg":"���²��ĵ��꼤�飡�ֵ�Я�ֹ�սɳ�ǣ���ɳ�ѿ���������л�ӻԾ���룡����","FColor":249,"BColor":0,"Type":5,"Time":3,"SendName":"xxx","SendId":"123","Y":"90"}')
    GameEvent.push(EventCfg.gocastlewarstart)
end

--���ǽ�������
function castlewarend()
    setontimerex(24, 2)
    sendmsg("0", 2,
        '{"Msg":"ɳ�Ϳ˹���ս�ѽ���������","FColor":249,"BColor":0,"Type":5,"Time":3,"SendName":"xxx","SendId":"123","Y":"30"}')
    sendmsg("0", 2,
        '{"Msg":"ɳ�Ϳ˹���ս�ѽ���������","FColor":249,"BColor":0,"Type":5,"Time":3,"SendName":"xxx","SendId":"123","Y":"60"}')
    sendmsg("0", 2,
        '{"Msg":"ɳ�Ϳ˹���ս�ѽ�����������","FColor":249,"BColor":0,"Type":5,"Time":3,"SendName":"xxx","SendId":"123","Y":"90"}')
    setsysvar(VarCfg["G_�Ƿ�����ɳ"], 0)
    GameEvent.push(EventCfg.goCastlewarend)
end

--ɳ�Ϳ˽��ʹ��߲�����
-- function mapeventwalk(actor) --���ǿ��� �ڹ����������ƶ�����
--     GameEvent.push(EventCfg.gomapeventwalk, actor)
-- end

--���ӳƺŴ���
function titlechangedex(actor, titleIdx)
    local custom = getstditeminfo(titleIdx, ConstCfg.stditeminfo.custom29)
    if custom ~= "" then
        local customArr = string.split(custom, "#")
        local where = tonumber(customArr[1])
        local resName = tonumber(customArr[2])
        seticon(actor, where, 1, resName)
    end
end

--ȡ�³ƺŴ���
function untitledex(actor, titleIdx)
    local custom = getstditeminfo(titleIdx, ConstCfg.stditeminfo.custom29)
    if custom ~= "" then
        local customArr = string.split(custom, "#")
        local where = tonumber(customArr[1])
        seticon(actor, where, -1)
    end
end

--�鿴����װ������
function lookhuminfo(actor, name)
    local Target = getplayerbyname(name)
    -- if getconst(Target, "<$HAT>") == "�����˶���" then
    --     openhyperlink(Target, 1, 2)
    --     Player.sendmsgEx(actor, "��ʾ#251|:#255|�Է���|������#249|�޷��鿴װ����Ϣ...")
    --     return
    -- end
    if checkkuafu(actor) then
        return
    end
    GameEvent.push(EventCfg.Myonlookhuminfo, actor, Target)  --�Լ�����
    GameEvent.push(EventCfg.Tgtonlookhuminfo, Target, actor) --���˴���
end

--��ʱ��Ʒ���ڴ���
---* actor:	��Ҷ���
---* item:	��Ʒ����
---* name:	��Ʒ����
function itemexpired(actor, item, name)
    local TitleName = getconst(actor, "<$ExpiredItemName>")

    local puTongIndexMax = 59    --��ͨ����������
    local shenShengIndexMax = 18 --��ʥ��������
    local chuanShiIndexMax = 18  --������������
    local cfg = include("QuestDiary/cfgcsv/cfg_JieFengJianLingJiangLi.lua")
    if name == "����ӡ�Ľ���(A)" then
        local item1 = cfg[math.random(1, puTongIndexMax)].putong
        sendmail(getbaseinfo(actor, 2), 10000, "����ӡ�Ľ���(A)", "��ϲ��,��⡾����ӡ�Ľ���(A)�����" .. item1 .. "x1", item1 .. "#1#0")
        return
    end

    if name == "����ӡ�Ľ���(S)" then
        local item1 = cfg[math.random(1, puTongIndexMax)].putong
        local item2 = cfg[math.random(1, puTongIndexMax)].putong
        sendmail(getbaseinfo(actor, 2), 10000, "����ӡ�Ľ���(S)", "��ϲ��,��⡾����ӡ�Ľ���(S)�����" .. item1 .. "x1" .. item2 .. "x1",
            item1 .. "#1#0&" .. item2 .. "#1#0")
        return
    end

    if name == "����ӡ�Ľ���(SR)" then
        local item1 = cfg[math.random(1, puTongIndexMax)].putong
        local item2 = cfg[math.random(1, puTongIndexMax)].putong
        local item3 = cfg[math.random(1, puTongIndexMax)].putong
        sendmail(getbaseinfo(actor, 2), 10000, "����ӡ�Ľ���(SR)",
            "��ϲ��,��⡾����ӡ�Ľ���(SR)�����" .. item1 .. "x1," .. item2 .. "x1," .. item3 .. "x1",
            item1 .. "#1#0&" .. item2 .. "#1#0&" .. item3 .. "#1#0")
        return
    end

    if name == "����ӡ�Ľ���(SSR)" then
        local item1 = cfg[math.random(1, shenShengIndexMax)].shensheng
        sendmail(getbaseinfo(actor, 2), 10000, "����ӡ�Ľ���(SSR)", "��ϲ��,��⡾����ӡ�Ľ���(SSR)�����" .. item1 .. "x1", item1 .. "#1#0")
        return
    end

    if name == "����ӡ�Ľ���(SSSR)" then
        local item1 = cfg[math.random(1, chuanShiIndexMax)].chuanshi
        sendmail(getbaseinfo(actor, 2), 10000, "����ӡ�Ľ���(SSSR)", "��ϲ��,��⡾����ӡ�Ľ���(SSSR)�����" .. item1 .. "x1", item1 .. "#1#0")
        return
    end
    local constName = getconst(actor, "<$ExpiredItemName>")
    local stdMode = getdbitemfieldvalue(constName, "StdMode")
    if stdMode == 70 then
        Player.setAttList(actor, "���ʸ���")
        Player.setAttList(actor, "���Ը���")
    end
    GameEvent.push(EventCfg.onPlayItemExpired, actor, item, name, TitleName)
end

-- �Զ�������1����ǡ�
function usercmd7(actor)
    if checkitemw(actor, "��ɷ��", 1) then --��ɷ��
        local marktgtname = getconst(actor, "<$PARAM(1)>")
        local marktgtidx  = getplayerbyname(marktgtname)

        if not marktgtidx then
            Player.sendmsgEx(actor, "��ɷ��#251|:#255|���|" .. marktgtname .. "#249|������...")
            return
        else
            setplaydef(actor, VarCfg["S$_׷ɱ���"], marktgtname)
            Player.sendmsgEx(actor, "��ɷ��#251|:#255|���ѽ�|" .. marktgtname .. "#249|���,�����������|15%#249|�˺�,װ���ѵ���Ч...")
        end

        if Player.Checkonline(marktgtname) then
            local myname = getbaseinfo(actor, ConstCfg.gbase.name)
            Player.sendmsgEx(marktgtidx, "��ɷ��#251|:#255|���ѱ�|" .. myname .. "#249|���,����������|15%#249|�˺�...")
        end
        return
    end

    if checkitemw(actor, "ج��֮�ס��", 1) then --ج��֮�ס��
        local marktgtname = getconst(actor, "<$PARAM(1)>")
        local marktgtidx  = getplayerbyname(marktgtname)

        if not marktgtidx then
            Player.sendmsgEx(actor, "ج��֮�ס��#251|:#255|���|" .. marktgtname .. "#249|������...")
            return
        else
            setplaydef(actor, VarCfg["S$_׷ɱ���"], marktgtname)
            Player.sendmsgEx(actor, "ج��֮�ס��#251|:#255|���ѽ�|" .. marktgtname .. "#249|���,�����������|15%#249|�˺�,װ���ѵ���Ч...")
        end

        if Player.Checkonline(marktgtname) then
            local myname = getbaseinfo(actor, ConstCfg.gbase.name)
            Player.sendmsgEx(marktgtidx, "ج��֮�ס��#251|:#255|���ѱ�|" .. myname .. "#249|���,����������|15%#249|�˺�...")
        end
        return
    end
    Player.sendmsgEx(actor, "��ʾ#251|:#255|��δ���|���װ��#249|����|��Ч#249|...")
end

-- �Զ�������2��������
function usercmd9(actor)
    if checkitemw(actor, "���꾻ƿ", 1) then --���꾻ƿ
        local marktgtname = getconst(actor, "<$PARAM(1)>")
        local marktgtidx  = getplayerbyname(marktgtname)
        if not marktgtidx then
            Player.sendmsgEx(actor, "���꾻ƿ#251|:#255|���|" .. marktgtname .. "#249|������...")
            return
        else
            setplaydef(actor, VarCfg["S$_���꾻ƿ���"], marktgtname)
            Player.sendmsgEx(actor, "���꾻ƿ#251|:#255|���ѵ���|" .. marktgtname .. "#249|,��������ʱ�и��ʽ�������ƿ������...")
        end

        if Player.Checkonline(marktgtname) then
            local myname = getbaseinfo(actor, ConstCfg.gbase.name)
            Player.sendmsgEx(marktgtidx, "���꾻ƿ#251|:#255|���ѱ�|" .. myname .. "#249|����,�����㹥��ʱ�и��ʽ�������ƿ������...")
        end
        return
    end
    Player.sendmsgEx(actor, "��ʾ#251|:#255|��δ���|���װ��#249|����|��Ч#249|...")
end

--buff����
---* actor: ���
---* buffid: buffID
---* groupid: ��ID
---* model: ���ͣ�1=������2=���£�3=ɾ����
function buffchange(actor, buffid, groupid, model)
    --���buff
    -- ["����ն�µ�"]	31048

    if model == 1 then
        --���˵�
        if buffid == 31040 then
            Player.setAttList(actor, "���ʸ���")
            --����
        elseif buffid == 31041 then
            Player.setAttList(actor, "��������")
            --����ն�µ�
        elseif buffid == 31048 then
            Player.setAttList(actor, "���ٸ���")
        end
    end

    --����buff
    if model == 3 then
    end

    --ɾ��buff
    if model == 4 then
        if buffid == 30043 then
            local pkvalue = getbaseinfo(actor, ConstCfg.gbase.pkvalue)
            if pkvalue > 200 then
                setbaseinfo(actor, ConstCfg.sbase.pkvalue, 160)
            end
        end
        -- ǧɽ�� ������ʱbuff��ʧ
        if buffid == 30046 then
            Player.setAttList(actor, "��������")
        end


        if buffid == 30064 then
            if getconst(actor, ConstCfg.equipconst["ѫ��"]) == "������" then
                addbuff(actor, 30064, 60, 1, actor)
            end
        end

        if buffid == 30080 then
            if checkitemw(actor, "���", 1) then
                setplaydef(actor, VarCfg["S$_���״̬"], 1) --�����´��˺�����
                playeffect(actor, 16016, 0, 0, 0, 0, 0) --���ﲥ����Ч
            end
        end

        -- ��ɱ��������
        if buffid == 31030 then
            setplaydef(actor, VarCfg["N$��ɱ����"], 0)
            -- release_print("��ɱ����--------------------------------------")
        end

        --���˵�
        if buffid == 31040 then
            Player.setAttList(actor, "���ʸ���")
        end
        --����
        if buffid == 31041 then
            Player.setAttList(actor, "��������")
        end
        --����ն�µ�
        if buffid == 31048 then
            Player.setAttList(actor, "���ٸ���")
        end

        --���������
        if buffid == 31085 then
            Player.setAttList(actor, "��������")
        end

        -- �̡�����֮������Buff
        if buffid == 31086 then
            Player.setAttList(actor, "���ٸ���")
        end
    end
    GameEvent.push(EventCfg.onBuffChange, actor, buffid, groupid, model)
end

--��ʼ�һ�����
function startautoplaygame(actor)
    setflagstatus(actor, VarCfg.F_isGuaJi, 1)
end

--�����һ�����
function stopautoplaygame(actor)
    setflagstatus(actor, VarCfg.F_isGuaJi, 0)
end

--��������ʱ����(���)
function groupcreate(actor)
    GameEvent.push(EventCfg.onEnterGroup, actor)
end

--�뿪����ʱ����(����)
function leavegroup(actor)
    GameEvent.push(EventCfg.onLeaveGroup, actor)
end

--��ҽ������
function groupaddmember(actor)
    local playerName = getplaydef(actor, "S0")
    local player = getplayerbyname(playerName)
    if player then
        GameEvent.push(EventCfg.onEnterGroup, player)
    end
end

--��ɫpkֵ�仯����
function pkpointchanged(actor, pkpoint)
end

--�����ѱ䴥��
function mobtreachery(actor, monObj)
    killmonbyobj(actor, monObj, false, false, false)
    local monName = getbaseinfo(monObj, ConstCfg.gbase.name)
    -- ѩ������ʱ�ͷ�ѩ������3X3��Χ��Ŀ�����5000��̶��˺�������50%�ĸ��ʱ���1S.
    if monName == "ʥ��ѩ��" then
        local x, y = getbaseinfo(monObj, ConstCfg.gbase.x), getbaseinfo(monObj, ConstCfg.gbase.y)
        rangeharm(actor, x, y, 3, 0, 6, 5000, 0, 0)         -- ����2*2��Χ�ڵ���1��
        if randomex(1, 2) then
            rangeharm(actor, x, y, 3, 0, 2, 1, 1, 0, 20500) -- ����2*2��Χ�ڵ���1��
        end
    end
end

--��������װ������ǰ����
function checkdropuseitems(actor, where, itemIdx)
    if getplaydef(actor, "N$��ֹ��װ�����") == 1 then
        return false
    end
    local fei_sheng_level = getplaydef(actor, VarCfg["U_������װ�ȼ�"])
    if fei_sheng_level >= 3 then
        local isUse = getflagstatus(actor, VarCfg["F_��������Ƿ����"])
        if isUse == 0 then
            local userId = getbaseinfo(actor, ConstCfg.gbase.id)
            local itemName = getstditeminfo(itemIdx, ConstCfg.stditeminfo.name)
            if checkkuafu(actor) then
                FKuaFuToBenFuRunScript(actor, 7, fei_sheng_level .. "|" .. itemName)
            else
                local mailTitle = StringCfg.get(3)
                local mailContent = StringCfg.get(4, fei_sheng_level, itemName)
                sendmail(userId, 1, mailTitle, mailContent)
            end
            setflagstatus(actor, VarCfg["F_��������Ƿ����"], 1)
            setplaydef(actor, "N$��ֹ��װ�����", 1)
            delaygoto(actor, 5000, "fang_zhi_diao_zhuang_flag")
            return false
        end
    end

    if getflagstatus(actor, VarCfg["F_����_��ѡ֮�˱�ʶ"]) == 1 then
        local isUse = getflagstatus(actor, VarCfg["F_��ѡ֮���Ƿ����"])
        if isUse == 0 then
            local userId = getbaseinfo(actor, ConstCfg.gbase.id)
            local itemName = getstditeminfo(itemIdx, ConstCfg.stditeminfo.name)
            if checkkuafu(actor) then
                FKuaFuToBenFuRunScript(actor, 6, itemName)
            else
                local mailTitle = StringCfg.get(1)
                local mailContent = StringCfg.get(2, itemName)
                sendmail(userId, 1, mailTitle, mailContent)
            end
            setflagstatus(actor, VarCfg["F_��ѡ֮���Ƿ����"], 1)
            setplaydef(actor, "N$��ֹ��װ�����", 1)
            delaygoto(actor, 5000, "fang_zhi_diao_zhuang_flag")
            return false
        end
    end

    if checkkuafu(actor) then
        FKuaFuToBenFuQiYuTitle(actor, EventCfg.onCheckDropUseItems, where .. "|" .. itemIdx)
    else
        GameEvent.push(EventCfg.onCheckDropUseItems, actor, where, itemIdx)
    end
end

--���񴥷�
--��ȡ���񴥷�
function picktask(actor, taskID)

end

--������񴥷�
function clicknewtask(actor, taskID)
    GameEvent.push(EventCfg.onClickNewTask, actor, taskID)
end

-- --ˢ�����񴥷�
-- function changetask(actor, taskID)

-- end

-- --������񴥷�
-- function completetask(actor, taskID)

-- end

-- --ɾ�����񴥷�
-- function deletetask(actor, taskID)

-- end
--ȡ���ɼ�
function collecting_monsters_cancel(actor)
    setplaydef(actor, VarCfg["S$��ǰ�ɼ�����"], "")
end

--��ʼ�ɼ�
local collectGiveItem = {
    ["�嶾��"] = { { "�嶾��", 1 } },
    ["��������"] = { { "��������", 1 } },
    ["����Ҷ"] = { { "����Ҷ", 1 } },
    ["�����Ի�"] = { { "�����Ի�", 1 } },
    ["������֥"] = { { "������֥", 1 } },
    ["Ѫ������"] = { { "Ѫ����", 1 } },
    ["ʪ���ż�"] = { { "ʪ������", 1 } },
}
function collecting_monsters(actor)
    local monName = getplaydef(actor, VarCfg["S$��ǰ�ɼ���������"])
    local monMakeIndex = getplaydef(actor, VarCfg["S$��ǰ�ɼ�����"])
    local mapid = getbaseinfo(actor, ConstCfg.gbase.mapid)
    local monobj = getmonbyuserid(mapid, monMakeIndex)
    killmonbyobj(actor, monobj, false, false, false)
    local gives = collectGiveItem[monName]
    local itemName = ""
    if gives then
        itemName = gives[1][1] or ""
    end
    if itemName == "ʪ������" then
        local num = getplaydef(actor, VarCfg["U_�ռ�ʪ������"])
        if num < 20 then
            setplaydef(actor, VarCfg["U_�ռ�ʪ������"], num + 1)
        end
    end
    GameEvent.push(EventCfg.onCollectTask, actor, monName, monMakeIndex, itemName)
    setplaydef(actor, VarCfg["S$��ǰ�ɼ�����"], "")
    setplaydef(actor, VarCfg["S$��ǰ�ɼ���������"], "")
    if gives then
        Player.giveItemByTable(actor, gives)
        -- Player.sendmsgEx(actor, string.format("���|[%s*1]#249",gives[1][1]))
    end
end

local danChenColleMob = {
    ["����Ҷ"] = 1,
    ["�����Ի�"] = 1,
    ["������֥"] = 1,
}
local MoYuMap = {
    ["������Ⱥ��ʮ���֡�"] = 1,
    ["ɳ����Ⱥ����ʮ���֡�"] = 3,
    ["����Ⱥ����ʮ���֡�"] = 5,
    ["������Ⱥ����ʮ���֡�"] = 8,
    ["�ƽ𾨡�һ�ٶ�ʮ���֡�"] = 10,
    ["��ʯ����һ�ٶ�ʮ���֡�"] = 10,
    ["����𡾶��ٻ��֡�"] = 10,
}

--�ɼ��ִ���
function collectmonex(actor, monIDX, monName, monMakeIndex)
    if not Bag.checkBagEmptyNum(actor, 5) then
        Player.sendmsgEx(actor, "�ɼ�ʧ��,��ı������Ӳ���!")
        return
    end
    if monName == "Ѫ������" then
        local mobIdx = getdbmonfieldvalue("������", "idx")
        local mobNum = getmoncount("����������", mobIdx, true)
        -- release_print(mobNum)
        if mobNum > 0 then
            Player.sendmsgEx(actor, "��Ҫ��ɱ|������#249|���ܲɼ�")
            return
        end
    end
    setplaydef(actor, VarCfg["S$��ǰ�ɼ�����"], monMakeIndex)
    setplaydef(actor, VarCfg["S$��ǰ�ɼ���������"], monName)
    if danChenColleMob[monName] then
        local colleTime = 5
        if checktitle(actor, "����ѧͽ") then
            colleTime = 4
        end
        showprogressbardlg(actor, colleTime, "@collecting_monsters", "���ڲɼ�%s...", 1, "@collecting_monsters_cancel")
    elseif monName == "Ѫ������" then
        local myName = getbaseinfo(actor, ConstCfg.gbase.name)
        Player.sendMoveMsgEx(actor, 200, 1, string.format("���|%s#249|����|����������(71,33)#253|�ɼ�|Ѫ����...#249", myName))
        Player.sendMoveMsgEx(actor, 250, 1, string.format("���|%s#249|����|����������(71,33)#253|�ɼ�|Ѫ����...#249", myName))
        showprogressbardlg(actor, 30, "@collecting_monsters", "���ڲɼ�Ѫ������(30��)%s...", 1, "@collecting_monsters_cancel")
    elseif MoYuMap[monName] then
        showprogressbardlg(actor, MoYuMap[monName], "@collecting_monsters", "��������%s...", 1, "@collecting_monsters_cancel")
    else
        showprogressbardlg(actor, 1, "@collecting_monsters", "���ڲɼ�%s...", 1, "@collecting_monsters_cancel")
    end
end

--���񱬳����
function task_item_need(actor, itemName)
    GameEvent.push(EventCfg.onCollectTask, actor, itemName, 1)
    return true
end

--�Ϲ�ħ���������
function shang_gu_mo_long_item_need(actor, itemName)
    local num = getplaydef(actor, VarCfg["U_��Ԫ������_����"])
    if num < 2 then
        setplaydef(actor, VarCfg["U_��Ԫ������_����"], num + 1)
    end
    return true
end

--�������ӵ�(��ת��)ǰ����
function beforeroute(actor, mapid, x, y)
    if mapid == "�����ܵ�2��" then
        if getflagstatus(actor, VarCfg["F_�����ܵ�_����״̬"]) == 0 then
            return false
        end
    end
    if mapid == "�Ѿ��ϳ�" and x == 33 and y == 38 then
        local num = getplaydef(actor, VarCfg["U_����_��������_��������"])
        if num < 100 then
            return false
        end
    end
    GameEvent.push(EventCfg.onBeforerOute, actor, mapid, x, y)
end

-- --���
function moneychange1(actor)
    local MoneyNum = getbindmoney(actor, "���")
    GameEvent.push(EventCfg.OverloadMoneyJinBi, actor, MoneyNum)
end

--�󶨽��
function moneychange3(actor)
    local MoneyNum = getbindmoney(actor, "���")
    GameEvent.push(EventCfg.OverloadMoneyJinBi, actor, MoneyNum)
end

--Ԫ��
function moneychange2(actor)
    local MoneyNum = getbindmoney(actor, "Ԫ��")
    GameEvent.push(EventCfg.OverloadMoneyYuanBao, actor, MoneyNum)
end

--��Ԫ��
function moneychange4(actor)
    local MoneyNum = getbindmoney(actor, "Ԫ��")
    GameEvent.push(EventCfg.OverloadMoneyYuanBao, actor, MoneyNum)
end

--���
function moneychange7(actor)
    local MoneyNum = getbindmoney(actor, "���")
    GameEvent.push(EventCfg.OverloadMoneyLingFu, actor, MoneyNum)
end

--�����
function moneychange20(actor)
    local MoneyNum = getbindmoney(actor, "���")
    GameEvent.push(EventCfg.OverloadMoneyLingFu, actor, MoneyNum)
end

--��ֵ����
function moneychange11(actor)
    local MoneyNum = querymoney(actor, 11)
    GameEvent.push(EventCfg.OverloadMoneyJiFen, actor, MoneyNum)
end

--����ǰ����
-- function dealbefore(actor, target)
--     stop(actor)
--     stop(target)
-- end

--������������
function selfkillslave(actor, mon)
    GameEvent.push(EventCfg.onSelfKillSlave, actor, mon)
end

function showfashion(actor)
    GameEvent.push(EventCfg.onShowFashion, actor)
end

function notshowfashion(actor)
    GameEvent.push(EventCfg.onNotShowFashion, actor)
end

-- ���ﱬ��װ������
function mondropitemex(actor, DropItem, mon, nX, nY)
    GameEvent.push(EventCfg.onMondropItemex, actor, DropItem, mon, nX, nY)
end

-- --ʰȡǰ����
-- function pickupitemfrontex(actor, item)
--     if checkkuafu(actor) then
--         return
--     end
--     local itemID = getiteminfo(actor, item, 2)
--     local ItemName = getstditeminfo(itemID, 1)
--     GameEvent.push(EventCfg.onPickUpItemfrontex, actor, item, ItemName, itemID)
-- end

--������Ʒ�󴥷�
function buyshopitem(actor, itemobj, itemname, itemnum, moneyid, moneynum)
    --��������
    if getflagstatus(actor, VarCfg["F_���״̬"]) == 0 then
        setitemaddvalue(actor, itemobj, 2, 1, ConstCfg.binding)
    end
end

--�����л�󴥷�
function guildaddmemberafter(actor, guild, name)
    GameEvent.push(EventCfg.onGuildAddMemberAfter, actor, guild, name)
end

function attackdamagebb(actor, Target, Hiter, MagicId, Damage)
    GameEvent.push(EventCfg.onAttackDamageBB, actor, Target, Hiter, MagicId, Damage)
end

--���Դ���
function triggerchat(actor, sMsg, chat, msgType)
    local flag = getflagstatus(actor, VarCfg["F_���״̬"])
    if flag == 0 then
        sendmsg(actor, 1, '{"Msg":"<font color=\'#ff0000\'>��ͨ�����Ȩ�ſ��Է���!</font>","Type":9}')
        return false
    end
    return true
end

--��������
function makeweaponunluck(actor, item)
    return false
end

--�̳ǹ��򺰻�����ǰ����
function canbuyshopitem200(actor)
    if getflagstatus(actor, VarCfg["F_���״̬"]) == 0 then
        sendmsg(actor, 1, '{"Msg":"<font color=\'#ff0000\'>��û�н����Ȩ,�޷�����˲�Ʒ!</font>","Type":9}')
        notallowbuy(actor, 1)
    end
end

function checkbuildguild(actor)
    if getflagstatus(actor, VarCfg["F_�Ƿ��׳�"]) == 0 then
        Player.sendmsgEx(actor, "Ϊ�˷�ֹС������,�׳�֮����ܴ����л�#249")
        return false
    end
end

function updateguildnotice(actor)
    Player.sendmsgEx(actor, "��ֹ�༭�лṫ��!#249")
    stop(actor)
end

function itemdropfrombagbefore(actor, itemobj)
    --������ڰ�ȫ��������װ��
    if getbaseinfo(actor, ConstCfg.gbase.issaferect) then
        return false
    end
end

function xie_ru_zuo(actor)
    local x = Player.GetX(actor)
    local y = Player.GetY(actor)
    local mapID = Player.MapKey(actor)
    local file = io.open("UserFile/map.txt", "a") -- "a" ��ʾ׷��ģʽ
    if not file then
        release_print("�޷����ļ�!")
        return
    end
    file:write(string.format("%s %s,%s -> ", mapID, x, y))
    Player.sendmsgEx(string.format("%s %s,%s -> ", mapID, x, y))
    file:close()
    release_print("������׷�ӵ��ļ�!")
end

function xie_ru_you(actor)
    local x = Player.GetX(actor)
    local y = Player.GetY(actor)
    local mapID = Player.MapKey(actor)
    local file = io.open("UserFile/map.txt", "a") -- "a" ��ʾ׷��ģʽ
    if not file then
        release_print("�޷����ļ�!")
        return
    end
    file:write(string.format("%s %s,%s\n", mapID, x, y))
    Player.sendmsgEx(string.format("%s %s,%s", mapID, x, y))
    file:close()
    release_print("������׷�ӵ��ļ�!")
end

--���ӵ�ɼ�
function usercmd10(actor)
    local gmLv = getgmlevel(actor)
    if gmLv < 10 then
        sendmsg(actor, 1, '{"Msg":"<font color=\'#ff0000\'>GMȨ�޲���</font>","Type":9}')
        return
    end
    local str = [[
        <Img|img=public_win32/bg_npc_01.png|loadDelay=1|esc=1|show=4|reset=1|move=0|bg=1>
        <Layout|x=545|y=0|width=80|height=80|link=@exit>
        <Button|x=546|y=0|pimg=public/1900000511.png|nimg=public/1900000510.png|link=@exit>
        <Button|ay=1|x=80.0|y=63|size=18|color=255|nimg=public/1900000660.png|pimg=public/1900000661.png|text=д����|link=@xie_ru_zuo>
        <Button|ay=1|x=341.0|y=63|size=18|color=255|nimg=public/1900000660.png|pimg=public/1900000661.png|text=д����|link=@xie_ru_you>
    ]]
    say(actor, str)
end

--װ��Ͷ�����䴥��Start
function dropuseitems71(actor, item)
    FEquipDropuseNotice(actor, item)
end

function dropuseitems72(actor, item)
    FEquipDropuseNotice(actor, item)
end

function dropuseitems73(actor, item)
    FEquipDropuseNotice(actor, item)
end

function dropuseitems74(actor, item)
    FEquipDropuseNotice(actor, item)
end

function dropuseitems75(actor, item)
    FEquipDropuseNotice(actor, item)
end

function dropuseitems76(actor, item)
    FEquipDropuseNotice(actor, item)
end

function dropuseitems42(actor, item)
    FEquipDropuseNotice(actor, item)
end

function dropuseitems20(actor, item)
    FEquipDropuseNotice(actor, item)
end

function dropuseitems22(actor, item)
    FEquipDropuseNotice(actor, item)
end

function dropuseitems24(actor, item)
    FEquipDropuseNotice(actor, item)
end

function dropuseitems28(actor, item)
    FEquipDropuseNotice(actor, item)
end

function dropuseitems27(actor, item)
    FEquipDropuseNotice(actor, item)
end

function dropuseitems25(actor, item)
    FEquipDropuseNotice(actor, item)
end

function dropuseitems23(actor, item)
    FEquipDropuseNotice(actor, item)
end

--װ��Ͷ�����䴥��End

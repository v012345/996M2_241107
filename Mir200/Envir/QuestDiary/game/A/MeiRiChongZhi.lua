local MeiRiChongZhi = {}
local config = include("QuestDiary/cfgcsv/cfg_RiChongBoss.lua") --ɱ������
local maps = {
    ["�����þ�1"] = true,
    ["�����þ�2"] = true,
    ["ۺ���þ�1"] = true,
    ["ۺ���þ�2"] = true,
    ["����þ�1"] = true,
    ["����þ�2"] = true,
    ["ʥ�ǻþ�1"] = true,
    ["ʥ�ǻþ�2"] = true,
    ["ʥ���ر���1"] = true,
    ["ʥ���ر���2"] = true,
    ["�����þ�1"] = true,
    ["�����þ�2"] = true,
    ["�����ر���1"] = true,
    ["�����ر���2"] = true,
    ["���»þ�1"] = true,
    ["���»þ�2"] = true,
    ["�����ر���1"] = true,
    ["�����ر���2"] = true,
    
}

--��ȡ��Ʒ����
function getitemobj(actor,name)
    local  baglist = getbagitems(actor,name) --��ȡ����������Ʒ
    local  itemobj = "0"
    if name == "�����˶���" then
        if getconst(actor, "<$HAT>") == "�����˶���" then
            itemobj = linkbodyitem(actor, 13)
        else
            for _, obj in ipairs(baglist) do
                local itemname = getiteminfo(actor, obj, 7)
                if itemname == name then
                    itemobj = obj
                    break
                end
            end
        end
    else
        for _, obj in ipairs(baglist) do
            local itemname = getiteminfo(actor, obj, 7)
            if itemname == name then
                itemobj = obj
                break
            end
        end
    end
    return itemobj
end

--��ȡ��Сʱ��
function getsmallitmes(time1,time2,time3)
    local min_time = math.huge  -- ��ʼ��Ϊ�������
    if time1 > 0 and time1 < min_time then
        min_time = time1
    end

    if time2 > 0 and time2 < min_time then
        min_time = time2
    end

    if time3 > 0 and time3 < min_time then
        min_time = time3
    end
    return min_time
end
--ɾ��һ��
function delitems(actor)
    local ShenMiRen = Bag.getItemNum(actor, "�����˶���")
    local BianShenQi = Bag.getItemNum(actor, "����һֻС��è[������]")
    local TongXingZheng = Bag.getItemNum(actor, "�þ�ͨ��֤")
    if getconst(actor, "<$HAT>") == "�����˶���" then
        takew(actor, "�����˶���", 1, "�ճ�ɾ��")
    end
    if ShenMiRen > 0 then
        takeitem(actor,"�����˶���", ShenMiRen, 0, "�ճ�ɾ��")
    end
    if BianShenQi > 0 then
        takeitem(actor,"����һֻС��è[������]", BianShenQi, 0, "�ճ�ɾ��")
    end
    if TongXingZheng > 0 then
        takeitem(actor,"�þ�ͨ��֤", TongXingZheng, 0, "�ճ�ɾ��")
    end
end

function MeiRiChongZhi.Request(actor, avr1)
    local heQuDay = tonumber(getconst("0", "<$HFCOUNT>"))
    if heQuDay == 0 then
        Player.sendmsgEx(actor, "��ʾ#251|:#255|�������̸���...")
        return
    end

    if getplaydef(actor, VarCfg["J_�ճ���ȡ״̬"]) == 1 then
        Player.sendmsgEx(actor, "��ʾ#251|:#255|�Բ���,������ȡ��|�þ�ͨ��֤#249|�����ظ���ȡ...")
        return
    end

    local RiChongNum = getplaydef(actor, VarCfg["J_�ճ��¼"])
    if RiChongNum < 38 then
        Player.sendmsgEx(actor, "��ʾ#251|:#255|�Բ���,����ճ�ֵ|����38Ԫ#249|��ȡʧ��...")
        return
    end

    local BeiBaoNum = getbagblank(actor)
    if BeiBaoNum < 10 then
        Player.sendmsgEx(actor, "��ʾ#251|:#255|�Բ���,��ı���|����#249|��ȡʧ��...")
        return
    end

    local ItemObj1 = getitemobj(actor,"�þ�ͨ��֤")
    local ItemObj2 = getitemobj(actor,"�����˶���")
    local ItemObj3 = getitemobj(actor,"����һֻС��è[������]")
    local time1 = (ItemObj1 == "0" and 0) or getitemaddvalue(actor, ItemObj1, 2, 0)
    local time2 = (ItemObj2 == "0" and 0) or getitemaddvalue(actor, ItemObj2, 2, 0)
    local time3 = (ItemObj3 == "0" and 0) or getitemaddvalue(actor, ItemObj3, 2, 0)
    local NewTime = getsmallitmes(time1,time2,time3) --��ȡ��Сʱ��

    if NewTime == math.huge then
        delitems(actor)
        giveitem(actor, "�þ�ͨ��֤", 1, 0, "ÿ�ճ�ֵ��ȡ")
        giveitem(actor, "�����˶���", 1, 0, "ÿ�ճ�ֵ��ȡ")
        giveitem(actor, "����һֻС��è[������]", 1, 0, "ÿ�ճ�ֵ��ȡ")
        changemoney(actor, 20, "+", 380, "ÿ�ճ�ֵ��ȡ", true)
        Player.sendmsgEx(actor, "��ʾ#251|:#255|��ϲ��,�ɹ���ȡ|�þ�ͨ��֤#249|�Ѿ����ŵ�����...")
    else
        setitemaddvalue(actor,ItemObj1, 2, 0, NewTime + 86400)
        setitemaddvalue(actor,ItemObj2, 2, 0, NewTime + 86400)
        setitemaddvalue(actor,ItemObj3, 2, 0, NewTime + 86400)
        changemoney(actor, 20, "+", 380, "ÿ�ճ�ֵ��ȡ", true)
        Player.sendmsgEx(actor, "��ʾ#251|:#255|��ϲ��,�ɹ���ȡ|�þ�ͨ��֤#249|ʱ���ѵ���24Сʱ...")
    end

    --ˢ�º���
    setplaydef(actor, VarCfg["Z_��������λ��4"], "")
    QiYuHeZi.SyncResponse(actor)

    --ˢ��ǰ��
    setplaydef(actor, VarCfg["J_�ճ���ȡ״̬"], 1)
    MeiRiChongZhi.SyncResponse(actor)

    --ˢ������
    Player.setAttList(actor, "���Ը���")
    Player.setAttList(actor, "���ʸ���")
end

--����ˢ��
local function _onCalcAttr(actor, attrs)
    if checkitems(actor, "�þ�ͨ��֤#1", 0, 0) then
        local shuxingMap = {
            [208] = 10,
            [205] = 20,
            [216] = 50,
        }
        calcAtts(attrs, shuxingMap, "�þ�ͨ��֤")
    end
end
GameEvent.add(EventCfg.onCalcAttr, _onCalcAttr, MeiRiChongZhi)

--���ʸ���
local function _onCalcBaoLv(actor, attrs)
    if checkitems(actor, "�þ�ͨ��֤#1", 0, 0) then
        local shuxing = {
            [204] = 300
        }
        calcAtts(attrs, shuxing, "�þ�ͨ��֤")
    end
end
GameEvent.add(EventCfg.onCalcBaoLv, _onCalcBaoLv, MeiRiChongZhi)

--�����ʱװ�����ڴ���
local function _onPlayItemExpired(actor, itemobj, itemname)
    if itemname == "�þ�ͨ��֤" then
        local buff = hasbuff(actor, 31066)
        if buff then
            FkfDelBuff(actor, 31066)
        end
        Player.setAttList(actor, "���Ը���")
        Player.setAttList(actor, "���ʸ���")
        TopIcon.addico(actor)
        local InTheMap = getbaseinfo(actor, ConstCfg.gbase.mapid)
        if maps[InTheMap] then
            mapmove(actor, "n3", 330, 330, 5)
        end
    end

    if itemname == "�߼��þ�ͨ��֤" then
        local InTheMap = getbaseinfo(actor, ConstCfg.gbase.mapid)
        if maps[InTheMap] then
            mapmove(actor, "n3", 330, 330, 5)
        end
    end
end
GameEvent.add(EventCfg.onPlayItemExpired, _onPlayItemExpired, MeiRiChongZhi)

--�л���ͼ����
local function _goSwitchMap(actor, cur_mapid)
    if not checkitems(actor, "�þ�ͨ��֤#1", 0, 0) or getsysvar(VarCfg["A_�þ���ͼ����"]) ~= "��" then
        if maps[cur_mapid] then
            mapmove(actor, "n3", 330, 330, 5)
        end
    end
end
GameEvent.add(EventCfg.goSwitchMap, _goSwitchMap, MeiRiChongZhi)


--ɱ�ִ���
local function _onKillMon(actor, monobj, monName)
    local mapId = getbaseinfo(actor, ConstCfg.gbase.mapid)
    if maps[mapId] then
        local cfg = config[monName]
        if config[monName] then
            if randomex(1, cfg.random) then
                additemtodroplist(actor, monobj, "�����ʯ")
            end
        end
    end
end
GameEvent.add(EventCfg.onKillMon, _onKillMon, MeiRiChongZhi)

--��Ϣͬ��
function MeiRiChongZhi.SyncResponse(actor,logindatas)
    local LingQuState = getplaydef(actor, VarCfg["J_�ճ���ȡ״̬"])
    local _login_data = { ssrNetMsgCfg.MeiRiChongZhi_SyncResponse, 0, 0, 0, {LingQuState}}
    if logindatas then
        table.insert(logindatas, _login_data)
    else
        Message.sendmsg(actor, ssrNetMsgCfg.MeiRiChongZhi_SyncResponse, 0, 0, 0, {LingQuState})
    end
end
--ע��������Ϣ
Message.RegisterNetMsg(ssrNetMsgCfg.MeiRiChongZhi, MeiRiChongZhi)

--�µ�һ��
local MiBaoGeMap = {"�����ر���1", "�����ر���2", "ʥ���ر���1", "ʥ���ر���2", "�����ر���1", "�����ر���2" }
local function _onNewDay(actor)
    MeiRiChongZhi.SyncResponse(actor)
    local RiChongNum = getplaydef(actor, VarCfg["J_�ճ��¼"])
    if RiChongNum < 68 then
        if maps[MiBaoGeMap] then
            mapmove(actor, "n3", 330, 330, 5)
        end
    end
end
GameEvent.add(EventCfg.onNewDay, _onNewDay, MeiRiChongZhi)

--��¼����
local function _onLoginEnd(actor, logindatas)
    MeiRiChongZhi.SyncResponse(actor, logindatas)
end
GameEvent.add(EventCfg.onLoginEnd, _onLoginEnd, MeiRiChongZhi)



return MeiRiChongZhi

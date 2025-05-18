ShuangJieHuoDongMain = {}
ShuangJieHuoDongMain.ID = "˫�ڻMain"
local config = {
    [1] = { { "ʥ������", 10 }, { "��ʯ", 10 }, { "�����", 100 }, { "Ԫ��", 100000 }, { "���籾Դ", 1 } },
    [2] = include("QuestDiary/cfgcsv/cfg_ShuangJieFuLi.lua"),
    [3] = include("QuestDiary/cfgcsv/cfg_ShuangJieKuangHuan.lua"),
    [4] = include("QuestDiary/cfgcsv/cfg_ShuangJieShangCheng.lua"),
    [5] = { mapID = "��С��", x = 61, y = 80, range = 1 },
}
--����
function shuang_jie_bu_ling(actor, index)
    index = tonumber(index)
    local cfg = config[2][index]
    if not cfg then
        Player.sendmsgEx(actor, "��������#249")
        return
    end
    local isLingQu = getflagstatus(actor, cfg.flag)
    local dayChinese = formatNumberToChinese(index)
    if isLingQu == 1 then
        Player.sendmsgEx(actor, "���Ѿ���ȡ����" .. dayChinese .. "��Ľ�����#249")
        return
    end
    local RiChongNum = getplaydef(actor, VarCfg["J_�ճ��¼"])
    if RiChongNum < 1 then
        Player.sendmsgEx(actor, "��ȡʧ�ܣ������û�г�ֵ��#249")
        return
    end
    local day = ShuangJieHuoDongMain.getStartDays()
    if index > day then
        Player.sendmsgEx(actor, "��û����ȡʱ����#249")
        return
    end
    if querymoney(actor, 7) < 500 then
        Player.sendmsgEx(actor, "��ȡʧ�ܣ����|���#249|����|500#249")
        return
    end
    changemoney(actor, 7, "-", 500, "˫�ڻ����", true)
    local uid = Player.GetUUID(actor)
    Player.giveMailByTable(uid, 1, "˫�ڸ�����" .. dayChinese .. "�콱��", "����ȡ����˫�ڸ�����" .. dayChinese .. "�콱��", cfg.give, 1, true)
    Player.sendmsgEx(actor, "��ȡ�����ɹ����뵽�������")
    setflagstatus(actor, cfg.flag, 1)
    local data = ShuangJieHuoDongMain.getShuangJieFuLidata(actor)
    ShuangJieHuoDongMain.SyncResponse(actor)
end

--˫�ڻ��ʼ����
local startDate = 20241225
--˫�ڻ��������
local openDays = 8
--��ȡ���������
function ShuangJieHuoDongMain.getOpenDate()
    return startDate
end

--��ȡ˫�ڻ��ʼ������
function ShuangJieHuoDongMain.getStartDays()
    local today = GetCurrentDateAsNumber()
    --��������������
    local serverStartDate = getsysvar(VarCfg["G_��������"])
    local _startDate = serverStartDate
    if serverStartDate < startDate then
        _startDate = startDate
    end
    local diff = getDaysDiff(_startDate, today)
    return diff + 1 -- +1 ����Ϊ����Ҳ��һ��
end

--��ȡ˫�ڻʣ������
function ShuangJieHuoDongMain.getLeftDays()
    local days = ShuangJieHuoDongMain.getStartDays()
    return openDays - days
end

--�ж�˫�ڻ�Ƿ���
function ShuangJieHuoDongMain.isOpen()
    local days = ShuangJieHuoDongMain.getStartDays()
    if days <= 0 then
        return false
    end
    --ʣ������
    local getLeftDays = ShuangJieHuoDongMain.getLeftDays()
    if getLeftDays < 0 then
        return false
    end
    return true
end

--��������
function ShuangJieHuoDongMain.Request(actor)
    release_print(ShuangJieHuoDongMain.getStartDays())
end

--��ȡ����ҳ������
function ShuangJieHuoDongMain.GetAllData(actor)
    local data = {}
    data.data = {}
    local leftDays = ShuangJieHuoDongMain.getLeftDays()
    data.data[1] = { getplaydef(actor, VarCfg["J_˫�ڻ�Ƿ���ȡ"]) }
    data.data[2] = ShuangJieHuoDongMain.getShuangJieFuLidata(actor)
    data.data[3] = ShuangJieHuoDongMain.getShuangJieLeiChong(actor)
    data.data[4] = ShuangJieHuoDongMain.getShuangJieShangChengData(actor)
    data.leftDays = leftDays
    return data
end

function ShuangJieHuoDongMain.OpenUI(actor)
    local data = ShuangJieHuoDongMain.GetAllData(actor)
    Message.sendmsg(actor, ssrNetMsgCfg.ShuangJieHuoDongMain_OpenUI, 0, 0, 0, data)
end

--��ȡ����
function ShuangJieHuoDongMain.LingQuReward(actor)
    --˫�ڻʣ������
    local isOpen = ShuangJieHuoDongMain.isOpen()
    if not isOpen then
        Player.sendmsgEx(actor, "˫�ڻ�ѽ���#249")
        return
    end
    local isLingQu = getplaydef(actor, VarCfg["J_˫�ڻ�Ƿ���ȡ"])
    if isLingQu == 1 then
        Player.sendmsgEx(actor, "���Ѿ���ȡ��������#249")
        return
    end
    local cfg = config[1]
    local dayChinese = formatNumberToChinese(ShuangJieHuoDongMain.getStartDays())
    local mailTitle = "˫�ڻ��" .. dayChinese .. "���½����"
    local mailContent = "����ȡ����˫�ڻ��" .. dayChinese .. "���½����"
    local uid = Player.GetUUID(actor)
    Player.giveMailByTable(uid, 1, mailTitle, mailContent, cfg, 1, true)
    setplaydef(actor, VarCfg["J_˫�ڻ�Ƿ���ȡ"], 1)
    Player.sendmsgEx(actor, "��ȡ�����ɹ����뵽�������")
    ShuangJieHuoDongMain.SyncResponse(actor)
end

function ShuangJieHuoDongMain.ShuangJieFuLi(actor, index)
    --˫�ڻʣ������
    local isOpen = ShuangJieHuoDongMain.isOpen()
    if not isOpen then
        Player.sendmsgEx(actor, "˫�ڻ�ѽ���#249")
        return
    end
    local RiChongNum = getplaydef(actor, VarCfg["J_�ճ��¼"])
    if RiChongNum < 1 then
        Player.sendmsgEx(actor, "��ȡʧ�ܣ������û�г�ֵ��#249")
        return
    end
    local cfg = config[2][index]
    if not cfg then
        Player.sendmsgEx(actor, "��������#249")
        return
    end
    local day = ShuangJieHuoDongMain.getStartDays()
    if index > day then
        Player.sendmsgEx(actor, "��û����ȡʱ����#249")
        return
    end
    local currDayChinese = formatNumberToChinese(index)
    local isLingQu = getflagstatus(actor, cfg.flag)
    if isLingQu == 1 then
        Player.sendmsgEx(actor, "���Ѿ���ȡ����" .. currDayChinese .. "��Ľ�����#249")
        return
    end
    --�������
    if index < day then
        messagebox(actor, "������Ҫ��500�ǰ���������Ƿ��죿", "@shuang_jie_bu_ling," .. index, "@quxiao")
        return
    end
    if index == day then
        local dayChinese = formatNumberToChinese(day)
        local mailTitle = "˫�ڸ�����" .. dayChinese .. "�콱��"
        local mailContent = "����ȡ����˫�ڸ�����" .. dayChinese .. "�콱��"
        local uid = Player.GetUUID(actor)
        Player.giveMailByTable(uid, 1, mailTitle, mailContent, cfg.give, 1, true)
        Player.sendmsgEx(actor, "��ȡ�����ɹ����뵽�������")
        setflagstatus(actor, cfg.flag, 1)
        local data = ShuangJieHuoDongMain.getShuangJieFuLidata(actor)
        ShuangJieHuoDongMain.SyncResponse(actor)
    end
end

--��ȡ˫�����ս���
function ShuangJieHuoDongMain.ShuangJieFuLiLingQu(actor)
    local cfg = config[2]
    local flag = 0
    for _, value in ipairs(cfg) do
        if getflagstatus(actor, value.flag) == 1 then
            flag = flag + 1
        end
    end
    if flag < 8 then
        Player.sendmsgEx(actor, "��ȡʧ�ܣ��㻹�н���δ��ȡ#249")
        return
    end
    if getflagstatus(actor, VarCfg["F_˫�ڸ����ܽ����Ƿ���ȡ"]) == 1 then
        Player.sendmsgEx(actor, "��ȡʧ�ܣ����Ѿ���ȡ����#249")
        return
    end
    local totalGive = { { "������ʮ���ף��", 1 } }
    local uid = Player.GetUUID(actor)
    Player.giveMailByTable(uid, 1, "˫�ڸ������ս���", "����ȡ����˫�ڸ������ս���", totalGive, 1, true)
    setflagstatus(actor, VarCfg["F_˫�ڸ����ܽ����Ƿ���ȡ"], 1)
    Player.sendmsgEx(actor, "��ȡ�����ɹ����뵽�������")
end

--˫�ڿ�
function ShuangJieHuoDongMain.ShuangJieKuangHuan(actor, index)
    local cfg = config[3][index]
    if not cfg then
        Player.sendmsgEx(actor, "��������#249")
        return
    end
    --дһ������������Ƿ�ȫ����ȡ
    local function isAllLingQu()
        local _cfg = config[3]
        local flag = 0
        for _, value in ipairs(_cfg) do
            if getflagstatus(actor, value.flag) == 1 then
                flag = flag + 1
            end
        end
        return flag >= 4
    end
    local isOpen = ShuangJieHuoDongMain.isOpen()
    if not isOpen then
        Player.sendmsgEx(actor, "˫�ڻ�ѽ���#249")
        return
    end
    local leiChong = getplaydef(actor, VarCfg["B_˫�ڻ�۳�ֵ"])
    local lingQuNum = getplaydef(actor, VarCfg["B_˫�ڻ��ȡ����"])
    if lingQuNum >= 5 then
        Player.sendmsgEx(actor, "���ֻ����ȡ5��#249")
        return
    end
    if leiChong < cfg.money then
        Player.sendmsgEx(actor, "��ȡʧ�ܣ�����۳�ֵ����" .. cfg.money .. "#249")
        return
    end
    if getflagstatus(actor, cfg.flag) == 1 then
        Player.sendmsgEx(actor, "��ȡʧ�ܣ����Ѿ���ȡ����#249")
        return
    end
    setflagstatus(actor, cfg.flag, 1)
    --���ͽ�������
    local uid = Player.GetUUID(actor)
    Player.giveMailByTable(uid, 1, "˫�ڿ��۳�" .. cfg.money .. "Ԫ����", "����ȡ����˫�ڿ��۳�" .. cfg.money .. "Ԫ����", cfg.give, 1, true)
    Player.sendmsgEx(actor, "��ȡ�����ɹ����뵽�������")
    local isAllLingQuBool = isAllLingQu()
    --���ȫ����ȡ�������������ȡ״̬��������һ��
    if isAllLingQuBool then
        local __cfg = config[3]
        for _, value in ipairs(__cfg) do
            setflagstatus(actor, value.flag, 0)
        end
        setplaydef(actor, VarCfg["B_˫�ڻ��ȡ����"], lingQuNum + 1) --��ȡ����+1
        setplaydef(actor, VarCfg["B_˫�ڻ�۳�ֵ"], leiChong - 1000) --��ȥ1000Ԫ�۳�
        messagebox(actor, "���Ѿ���ȡ�����н������������۳��-1000����������һ�֡�")
    end
    ShuangJieHuoDongMain.SyncResponse(actor)
end

--˫���̳�
function ShuangJieHuoDongMain.ShuangJieShangCheng(actor, index)
    local cfg = config[4][index]
    if not cfg then
        Player.sendmsgEx(actor, "��������#249")
        return
    end
    local itemName = cfg.item[1][1]
    local itemNum = cfg.item[1][2]
    local data = Player.getJsonTableByVar(actor, VarCfg["T_˫�ڶԻ�����"])
    local obtainedCount = data[itemName] or 0 --��ȡ�Ѷһ�����
    local RemainingCount = cfg.max - obtainedCount
    if RemainingCount <= 0 then
        Player.sendmsgEx(actor, "�һ�ʧ��,���Ķһ���������!#249")
        return
    end
    local cost = cfg.cost
    local name, num = Player.checkItemNumByTable(actor, cost)
    if name then
        Player.sendmsgEx(actor, string.format("���|%s#249|����|%d#249", name, num))
        return
    end
    if not Bag.checkBagEmptyNum(actor, 5) then
        Player.sendmsgEx(actor, "��ı������Ӳ���,��������5���ո�!#249")
        stop(actor)
        return
    end
    Player.takeItemByTable(actor, cost, "˫���̳Ƕһ�")
    Player.sendmsgEx(actor, string.format("�һ��ɹ�,���|%s*%d#249", itemName, itemNum))
    -- local uid = Player.GetUUID(actor)
    -- Player.giveMailByTable(uid, 1, "˫�ڻ�̳Ƕһ�", "����ȡ����˫�ڻ�̳Ƕһ�����!", cfg.item, 1, true)
    Player.giveItemByTable(actor, cfg.item, "˫���̳Ƕһ�", 1, true)
    --�ɹ�֮�� ���Ӵ���
    if data[itemName] then
        data[itemName] = data[itemName] + 1
    else
        data[itemName] = 1
    end
    Player.setJsonVarByTable(actor, VarCfg["T_˫�ڶԻ�����"], data)
    ShuangJieHuoDongMain.SyncResponse(actor)
end

--˫�ڿ�С��
function ShuangJieHuoDongMain.KuangHuanXiaoZhen(actor)
    --�Ƿ��ǿ���ʱ��
    local isOpen = ShuangJieHuoDongMain.isOpen()
    if not isOpen then
        Player.sendmsgEx(actor, "�δ������#249")
        return
    end
    local isTime = isTimeInRange(18, 00, 21, 00)
    if not isTime then
        Player.sendmsgEx(actor, "��ͼδ��������ͼ����ʱ�䣺18:00-21:00#249")
        return
    end
    local cfg = config[5]
    local map = cfg.mapID
    local x = cfg.x
    local y = cfg.y
    local range = cfg.range
    FMapMoveEx(actor, map, x, y, range)
    Player.screffects(actor, 63150, -600, 600)
end

--��ȡ˫�ڸ�������
function ShuangJieHuoDongMain.getShuangJieFuLidata(actor)
    local data = {} --״̬ 0��������ȡ 1�������ȡ 2��������ȡ 3�����ѹ��ڿɲ���
    local day = ShuangJieHuoDongMain.getStartDays()
    local cfg = config[2]
    for index, value in ipairs(cfg) do
        local flag = getflagstatus(actor, value.flag)
        --state
        --0��������ȡ
        --1�������ȡ
        --2��������ȡ
        --3�����ѹ��ڿɲ���
        local state = 0
        if index > day then
            state = 0
        elseif index == day then
            state = 1
        else
            state = 3
        end
        if flag == 1 then
            state = 2
        end
        table.insert(data, state)
    end
    return data
end

--��ȡ˫�ڻ�۳�ֵ
function ShuangJieHuoDongMain.getShuangJieLeiChong(actor)
    local data = {}
    data.leiChong = getplaydef(actor, VarCfg["B_˫�ڻ�۳�ֵ"])
    data.lingQuNum = getplaydef(actor, VarCfg["B_˫�ڻ��ȡ����"])
    data.flags = {}
    for _, value in ipairs(config[3]) do
        table.insert(data.flags, getflagstatus(actor, value.flag))
    end
    return data
end

--��ȡ˫�ڶԻ�����
function ShuangJieHuoDongMain.getShuangJieShangChengData(actor)
    local data = Player.getJsonTableByVar(actor, VarCfg["T_˫�ڶԻ�����"])
    return data
end

--ͬ����Ϣ
function ShuangJieHuoDongMain.SyncResponse(actor)
    local data = ShuangJieHuoDongMain.GetAllData(actor)
    Message.sendmsg(actor, ssrNetMsgCfg.ShuangJieHuoDongMain_SyncResponse, 0, 0, 0, data)
end

--��¼����
local function _onLoginEnd(actor)
    if checkitems(actor, "������ʮ���ף��#1", 0, 0) then
        local state = getplaydef(actor, VarCfg["Z_���콻������ȡ״̬"])
        if state ~= "�Ѹ���" then
            setplaydef(actor, VarCfg["Z_���콻������ȡ״̬"], "�Ѹ���")
            local BaoLv = getplaydef(actor, VarCfg["B_���콻���˱���"])
            BaoLv = BaoLv + 1
            setplaydef(actor, VarCfg["B_���콻���˱���"], BaoLv)
        end
    end
end
GameEvent.add(EventCfg.onLoginEnd, _onLoginEnd, ShuangJieHuoDongMain)

--��ֵ����
local function _onRecharge(actor, gold, productid, moneyid)
    if not ShuangJieHuoDongMain.isOpen() then
        return
    end
    if getplaydef(actor, "N$������˫���۳�") == 1 then
        setplaydef(actor, "N$������˫���۳�", 0)
        return
    end
    local currLeiChong = getplaydef(actor, VarCfg["B_˫�ڻ�۳�ֵ"])
    currLeiChong = currLeiChong + gold
    setplaydef(actor, VarCfg["B_˫�ڻ�۳�ֵ"], currLeiChong)
end
GameEvent.add(EventCfg.onRecharge, _onRecharge, ShuangJieHuoDongMain)

-- --˫�ڻ����
-- local function _checkShuangJieHuoDong()
--     local startDate = ShuangJieHuoDongMain.getOpenDate()
--     local currDate = GetCurrentDateAsNumber()
--     local isOpen = ShuangJieHuoDongMain.isOpen()
--     if currDate >= startDate and isOpen then
--         setsysvar(VarCfg["G_˫�ڻ�Ƿ���"], 1)
--     else
--         setsysvar(VarCfg["G_˫�ڻ�Ƿ���"], 0)
--     end
-- end
-- --ÿ���賿ִ��
-- local function _onBeforedawn(openday)
--     _checkShuangJieHuoDong()
-- end
-- GameEvent.add(EventCfg.roBeforedawn, _onBeforedawn, ShuangJieHuoDongMain)

--������������
-- local function _onStartUp()
--     _checkShuangJieHuoDong()
-- end
-- GameEvent.add(EventCfg.onStartUp, _onStartUp, ShuangJieHuoDongMain)

--˫�ڻ��ʼ
local function _onShuangJieHuoDongStart()
    FsendHuoDongGongGao("��С���ͼ�ѿ�������ӭ���ǰ����")
    local isOpen = ShuangJieHuoDongMain.isOpen()
    if isOpen then
        setsysvar(VarCfg["G_˫�ڻ��ͼ�Ƿ���"], 1)
    end
end
--˫�ڻ����
local function _onShuangJieHuoDongEnd()
    local isOpen = ShuangJieHuoDongMain.isOpen()
    if isOpen then
        setsysvar(VarCfg["G_˫�ڻ��ͼ�Ƿ���"], 0)
        FsendHuoDongGongGao("��С���ͼ�ѹرգ�")
    end
    FMoveMapPlay("��С��", "n3", 330, 330, 3)
end

GameEvent.add(EventCfg.onShuangJieHuoDongStart, _onShuangJieHuoDongStart, ShuangJieHuoDongMain)
GameEvent.add(EventCfg.onShuangJieHuoDongEnd, _onShuangJieHuoDongEnd, ShuangJieHuoDongMain)

local _shuaGuai = {
    {
        mobName = "ʥ������",
        x = 64,
        y = 82,
        range = 60,
        color = 250,
        num = 150
    },
    {
        mobName = "ʥ������",
        x = 64,
        y = 82,
        range = 60,
        color = 250,
        num = 10
    }
}
--��С��ˢ��
local function _onKuangHuanXiaoZhenShuaGuai()
    local isOpen = ShuangJieHuoDongMain.isOpen()
    if isOpen then
        FsendHuoDongGongGao("ʥ�����˺�ʥ����������ڿ�С��")
        for _, value in ipairs(_shuaGuai) do
            genmon("��С��", value.x, value.y, value.mobName, value.range, value.num, value.color)
        end
    end
end
GameEvent.add(EventCfg.onKuangHuanXiaoZhenShuaGuai, _onKuangHuanXiaoZhenShuaGuai, ShuangJieHuoDongMain)
local _caiJiItems = { "ʥ�����˵�ѥ��", "��¹������", "ʥ��������", "ʥ������", "ʥ�����˻���", "ʥ������" }
local function _onCollectTask(actor, monName, monMakeIndex, itemName)
    if monName == "ʥ������" then
        --�������Ʒ
        local itemName = _caiJiItems[math.random(1, #_caiJiItems)]
        Player.giveItemByTable(actor, { { itemName, 1 } }, "ʥ������", 1, true)
        Player.sendmsgEx(actor, string.format("��ϲ����|%s#249", itemName))
    end
end
GameEvent.add(EventCfg.onCollectTask, _onCollectTask, ShuangJieHuoDongMain)

--����������ѩ��
local function _onAttackDamagePlayer(actor, Target, Hiter, MagicId, Damage, Model, attackDamageData)
    if getplaydef(actor, VarCfg["U_ʱװ��ۼ�¼"]) == 40181 then
        if randomex(1, 150) then
            addbuff(Target, 31108, 30)
        end
    end
end
GameEvent.add(EventCfg.onAttackDamagePlayer, _onAttackDamagePlayer, ShuangJieHuoDongMain)

--ע��������Ϣ
Message.RegisterNetMsg(ssrNetMsgCfg.ShuangJieHuoDongMain, ShuangJieHuoDongMain)
return ShuangJieHuoDongMain

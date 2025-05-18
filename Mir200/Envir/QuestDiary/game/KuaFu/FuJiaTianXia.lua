local FuJiaTianXia = {}
FuJiaTianXia.ID = "��������"
local npcID = 130
--local config = include("QuestDiary/cfgcsv/cfg_FuJiaTianXia.lua") --����
local cost = {
    { { "���", 1000000 } },
    { { "���", 5000000 } },
    { { "���", 10000000 } },
}

local var1 = VarCfg["A_������������"]

local titles = {
    "�������µ�һ��",
    "�������µڶ���",
    "�������µ�����",
    "�������µ�����",
    "�������µ�����",
    "�������µ�����",
}
local txtPath = '..\\..\\������а�\\������.txt'
local rankData
--д���ļ�
local function _writeText(data)
    clearnamelist(txtPath)
    local txt = tbl2json(data)
    addtextlist(txtPath, txt, 0)
end

--��ȡ�ļ�����table
local function _readText()
    local content1, content2 = getliststring(txtPath, 0)
    if content1 == "" or not content1 then
        return {}
    end
    local str = content1 .. ":" .. content2
    return json2tbl(str)
end
--��������
local function _setData(data)
    rankData = data
    _writeText(data)
end
--��ȡ����
local function _getData()
    if not rankData then
        rankData = _readText()
    end
    return rankData
end

--��ȡ����֮���ǰ�������ݣ����ҽ�������
local function _getRankData(isGetUid)
    local dataList = {}
    local inputData = _getData()
    for key, value in pairs(inputData) do
        if isGetUid then
            table.insert(dataList, { key = key, money = value.money, name = value.name })
        else
            table.insert(dataList, { money = value.money, name = value.name })
        end
    end
    -- ���� money ֵ��������
    table.sort(dataList, function(a, b)
        return a.money > b.money
    end)

    -- �����������6����ֻ����ǰ����
    if #dataList > 6 then
        for i = #dataList, 7, -1 do
            table.remove(dataList, i)
        end
    end
    return dataList
end

--��ȡǰ�����ľ���uid
local function getFuJiaTianXiaUidList()
    local dataList = _getRankData(true)
    -- ��ʼ��һ���ձ����ڴ洢��
    local keys = {}
    -- �������ݣ���ȡ������˳������
    for _, item in ipairs(dataList) do
        table.insert(keys, item.key)
    end
    return keys
end

--��ȡ�ҵ�����
local function _getMyRank(actor, ranks)
    local uid = Player.GetUUID(actor)
    for index, value in ipairs(ranks) do
        if uid == value then
            return index
        end
    end
    return nil
end

--��ȡ�ҵľ�����
local function _getMyDonate(actor)
    local uid = Player.GetUUID(actor)
    local data = _getData()
    local myDonate = 0
    if data[uid] then
        myDonate = data[uid].money or 0
    end
    return myDonate
end

--ѭ��ɾ���ƺ� �� ��ʶ
local function _delAllTitle(actor)
    for _, value in ipairs(titles) do
        if checktitle(actor, value) then
            deprivetitle(actor, value)
            Player.setAttList(actor, "���Ը���")
        end
    end
end

--ˢ�¸������а�
local function _refreshPlayerRanking(actor, uuidList)
    local lastRank = getplaydef(actor, VarCfg["U_���������ϴ�����"])
    --����ϴ���������0��������
    if lastRank > 0 then
        setflagstatus(actor, VarCfg["F_�������µ�һ��"], 0)
        _delAllTitle(actor)
    end
    local playerRank = _getMyRank(actor, uuidList)
    if playerRank then
        local title = titles[playerRank]
        if title then
            confertitle(actor, title)
            Player.setAttList(actor, "���Ը���")
        end
        setplaydef(actor, VarCfg["U_���������ϴ�����"],playerRank)
        --��һ����һ����ʶ
        if playerRank == 1 then
            setflagstatus(actor, VarCfg["F_�������µ�һ��"], 1)
        end
    else
        --������ڰ��� �͸�0
        setplaydef(actor, VarCfg["U_���������ϴ�����"], 0)
    end
end

--ˢ�������˵����а�
local function _refreshAllRanking()
    local uuids = getsysvar(var1) or ""
    local uuidList = string.split(uuids, "|") or {}
    local list = getplayerlst(1)
    for _, actor in ipairs(list or {}) do
        if getplaydef(actor, "N$�������µ�½���") == 1 then
            _refreshPlayerRanking(actor, uuidList)
        end
    end
end

--�ر���ˢ������
local function _onFuJiaTianXiaToBenFu(arg1)
    setsysvar(var1, arg1)
    _refreshAllRanking()
end
GameEvent.add(EventCfg.onFuJiaTianXiaToBenFu, _onFuJiaTianXiaToBenFu, FuJiaTianXia)
--�ڿ��ִ�� ��ʼ����
local function _onFuJiaTianXiaToKuaFu(actor, num)
    local num = tonumber(num) or 0
    if num == 0 then
        Player.sendmsgEx(actor, "��������#249")
        return
    end
    local currData = _getData()
    local id = Player.GetUUID(actor)
    local name = Player.GetName(actor)
    local myData = currData[id]
    --����Ѿ����ھ��ۼ�   ���򴴽�����
    if myData then
        -- �ۼ� money ֵ
        myData.money = (myData.money or 0) + num
    else
        -- �����µ����ݱ�����ӵ� currData ��
        myData = {
            money = num,
            name = name
        }
        currData[id] = myData
    end
    _setData(currData)
    local ranks = getFuJiaTianXiaUidList()
    local myRank = _getMyRank(actor, ranks)
    local lastRank = getplaydef(actor, VarCfg["U_���������ϴ�����"])
    if myRank then
        if myRank ~= lastRank then
            setplaydef(actor, VarCfg["U_���������ϴ�����"], myRank)
            FG_KuaFuToBenFuEvent(EventCfg.onFuJiaTianXiaToBenFu, table.concat(ranks, "|"))
            local title = titles[myRank]
            if title then
                messagebox(actor, "��ϲ���ϰ�ɹ�,��õ�" .. myRank .. "��,��óƺ�[" .. title .. "]")
                local msgStr = "��ϲ���[" .. name .. "]�ٵǸ����������а��" .. myRank .. "������þ�������������"
                sendmsg("0", 2, '{"Msg":"' .. msgStr .. '","FColor":249,"BColor":0,"Type":5,"Time":3,"Y":"100"}')
            end
        end
    end
    FuJiaTianXia.SyncResponse(actor)
end
GameEvent.add(EventCfg.onFuJiaTianXiaToKuaFu, _onFuJiaTianXiaToKuaFu, FuJiaTianXia)
--��������
function FuJiaTianXia.Request(actor, arg1)
    if not checkkuafu(actor) then
        return
    end
    local currCost = cost[arg1]
    if not currCost then
        return
    end
    local name, num = Player.checkItemNumByTable(actor, currCost)
    if name then
        Player.sendmsgEx(actor, string.format("���|%s#249|����|%d#249", name, num))
        return
    end
    local moneyNum = currCost[1][2]
    Player.takeItemByTable(actor, currCost, "�������")
    FBenFuToKuaFuEvent(actor, EventCfg.onFuJiaTianXiaToKuaFu, moneyNum)
end

--���������ִ��
local function _onFuJiaTianXiaSyncResponse(actor)
    FuJiaTianXia.SyncResponse(actor)
end
GameEvent.add(EventCfg.onFuJiaTianXiaSyncResponse, _onFuJiaTianXiaSyncResponse, FuJiaTianXia)
function FuJiaTianXia.RequestSync(actor)
    FBenFuToKuaFuEvent(actor, EventCfg.onFuJiaTianXiaSyncResponse, "")
end

--��ɳ������������а�
local function _goCastlewarend()
    rankData = nil
    clearnamelist(txtPath)
end
GameEvent.add(EventCfg.goCastlewarend,_goCastlewarend,FuJiaTianXia)

--ͬ����Ϣ
function FuJiaTianXia.SyncResponse(actor, logindatas)
    local data = _getRankData()
    local MyDonate = _getMyDonate(actor)
    Message.sendmsg(actor, ssrNetMsgCfg.FuJiaTianXia_SyncResponse, 0, 0, 0, {data=data,MyDonate=MyDonate})
end

--��һ������buff
local function _onAttackPlayer(actor, Target, Hiter, MagicId)
    if randomex(1,128) then
        if getflagstatus(actor, VarCfg["F_�������µ�һ��"]) == 1 then
            setplayvar(Target, "HUMAN", VarCfg["����CD"], os.time(), 1) --ֱ�Ӵ��浱ǰʱ��
            local myName = Player.GetNameEx(actor)
            local targetName = Player.GetNameEx(Target)
            Player.buffTipsMsg(actor, "[��������]:{" .. targetName .. "/FCOLOR=243}{30��/FCOLOR=243}���޷�����...")
            Player.buffTipsMsg(Target, "[��������]:�㱻[{" .. myName .. "/FCOLOR=243}]ʩ����buff{30��/FCOLOR=243}���޷�����...")
        end
    end
end
GameEvent.add(EventCfg.onAttackPlayer, _onAttackPlayer, FuJiaTianXia)

--��½ˢ�����а�
local function _loginRefreshRanking(actor)
    local uuids = getsysvar(var1) or ""
    if uuids ~= "" then
        local uuidList = string.split(uuids, "|") or {}
        _refreshPlayerRanking(actor, uuidList)
    else
        setplaydef(actor, VarCfg["U_��¼�ϴ�ȫ������"], 0)
    end
end
--��½��ʱ��������
function kua_fu_fu_jia_tian_xia(actor)
    _loginRefreshRanking(actor)
    setplaydef(actor, "N$�������µ�½���", 1)
end
--��½����
local function _onLoginEnd(actor, logindatas)
    delaygoto(actor, 8000, "kua_fu_fu_jia_tian_xia")
end
--�¼��ɷ�
GameEvent.add(EventCfg.onLoginEnd, _onLoginEnd, FuJiaTianXia)
--ע��������Ϣ
Message.RegisterNetMsg(ssrNetMsgCfg.FuJiaTianXia, FuJiaTianXia)
return FuJiaTianXia

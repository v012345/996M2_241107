local YiJieMiCheng = {}
YiJieMiCheng.ID = "����Գ�"
local config = include("QuestDiary/cfgcsv/cfg_YiJieMiCheng.lua") --����
local configRank = include("QuestDiary/cfgcsv/cfg_YiJieMiChengRank.lua") --����
local configMap = {}
for _, value in ipairs(config) do
    configMap[value.mapID] = value
end
--��ͼλ������ �� �� �� ��
local directions = {
    { x = 20, y = 18 },
    { x = 75, y = 18 },
    { x = 75, y = 74 },
    { x = 20, y = 74 }
}
--����ײ㽱��
local enterBottomReward = { { "Ԫ��", 100000 }, { "�󶨽��", 1000000 }, { "����ʯ", 333 }, { "�칤֮��", 333 } }
--��������
function YiJieMiCheng.Request(actor)
    local isOpen = getsysvar(VarCfg["G_����Գǿ�����ʶ"])
    if isOpen == 0 then
        Player.sendmsgEx(actor, "��ǰû�п�������Գǻ#249")
        return
    end
    FMapMoveEx(actor, "����Գ�1", 47, 40, 3)
    local name = Player.GetName(actor)
    sendmsg("0", 2,
        '{"Msg":"[' ..
        name .. ']�μ�������Գǻ","FColor":251,"BColor":0,"Type":6,"Time":6,"SendName":"ϵͳ��","SendId":"123","X":"-300"}')
    local mapPosition = Player.getJsonTableByVar(actor, VarCfg["S$����ԳǼ�¼��ͼλ��"])
    Message.sendmsg(actor, ssrNetMsgCfg.YiJieMiCheng_EnterMap, 0, 0, 0, mapPosition)
    openhyperlink(actor, 110, 1)
end

--ͬ����Ϣ
-- function YiJieMiCheng.SyncResponse(actor, logindatas)
--     local data = {}
--     local _login_data = {ssrNetMsgCfg.YiJieMiCheng_SyncResponse, 0, 0, 0, data}
--     if logindatas then
--         table.insert(logindatas, _login_data)
--     else
--         Message.sendmsg(actor, ssrNetMsgCfg.YiJieMiCheng_SyncResponse, 0, 0, 0, data)
--     end
-- end
-- --��¼����
-- local function _onLoginEnd(actor, logindatas)
--     YiJieMiCheng.SyncResponse(actor, logindatas)
-- end
-- --�¼��ɷ�
-- GameEvent.add(EventCfg.onLoginEnd, _onLoginEnd, YiJieMiCheng)

--������Ҽ�¼�ı���
local function clearActorVar()
    local Players = getplayerlst(1)
    for _, actor in pairs(Players) do
        setplaydef(actor,VarCfg["S$����Գ�ȥ���ĵ�ͼ"],"")
        setplaydef(actor,VarCfg["S$����ԳǼ�¼��ͼλ��"],"")
    end
end

--����Գǿ�ʼ
local function _onYiJieMiChengStart()
    FsendHuoDongGongGao("����Գǻ�ѿ���")
    clearActorVar() --������ұ���
    setsysvar(VarCfg["A_����Գǵײ��¼"],"") --�������ײ�ļ�¼
    setsysvar(VarCfg["G_����Գ�����"],0) --�������а�
    for index, value in ipairs(config) do
        local tmpTbl = {
            value.linkPoint1,
            value.linkPoint2,
            value.linkPoint3,
            value.linkPoint4,
        }
        if #tmpTbl > 0 then
            table.shuffle(tmpTbl)
            -- dump(tmpTbl)
            for i, v in ipairs(directions) do
                local linkPoint = {
                    ["����x"] = v.x,
                    ["����y"] = v.y,
                    ["��ǰ��ͼ"] = value.mapID,
                    ["�²��ͼ"] = tmpTbl[i][1],
                    ["�²��ͼx"] = value.x,
                    ["�²��ͼy"] = value.y,
                }
                addmapgate(linkPoint["��ǰ��ͼ"] .. i, linkPoint["��ǰ��ͼ"], linkPoint["����x"], linkPoint["����y"], 2,
                    linkPoint["�²��ͼ"], linkPoint["�²��ͼx"], linkPoint["�²��ͼy"], 1200)
                mapeffect(2000 + index + i, linkPoint["��ǰ��ͼ"], linkPoint["����x"], linkPoint["����y"], 17009, 1200, 0, actor)
            end
        end
        --��֣� ˢ��
        killmonsters(value.mapID, "*", 0, false)
        genmon(value.mapID, value.x, value.y, value.monName, 0, 1, 251)
    end
end
GameEvent.add(EventCfg.onYiJieMiChengStart, _onYiJieMiChengStart, YiJieMiCheng)

--�ж���ͼλ��
local function getMapPositionIndex(actor, x, y)
    for index, value in ipairs(directions) do
        if FisInRange(x, y, value.x, value.y, 3) then
            return index
        end
    end
end

--�ж��Ƿ��Ѿ��¹���ͼ
--�Ѿ��¹�����true��û�¹�����false
local function isHasVisitedMap(actor, mapID)
    local maps = Player.getJsonTableByVar(actor, VarCfg["S$����Գ�ȥ���ĵ�ͼ"])
    local result = false
    for _, value in ipairs(maps) do
        if value == mapID then
            result = true
            break
        end
    end
    return result
end

--��¼��ͼ
local function setRecordMap(actor, mapID)
    local maps = Player.getJsonTableByVar(actor, VarCfg["S$����Գ�ȥ���ĵ�ͼ"])
    table.insert(maps, mapID)
    Player.setJsonVarByTable(actor, VarCfg["S$����Գ�ȥ���ĵ�ͼ"], maps)
end

--��¼��ͼλ��
local function recordMapPosition(actor, mapID, index)
    local mapPosition = Player.getJsonTableByVar(actor, VarCfg["S$����ԳǼ�¼��ͼλ��"])
    mapPosition[mapID] = index
    Player.setJsonVarByTable(actor, VarCfg["S$����ԳǼ�¼��ͼλ��"], mapPosition)
end

--��¼����ײ�
local function recordEnterUnderground(actor)
    local playerList = Player.getJsonTableByVar(nil, VarCfg["A_����Գǵײ��¼"])
    local name = getbaseinfo(actor, ConstCfg.gbase.name)
    table.insert(playerList, name)
    Player.setJsonVarByTable(nil, VarCfg["A_����Գǵײ��¼"], playerList)
end

--�ж��Ƿ������ײ�
local function isEnterUnderground(actor)
    local playerList = Player.getJsonTableByVar(nil, VarCfg["A_����Գǵײ��¼"])
    local name = getbaseinfo(actor, ConstCfg.gbase.name)
    for i, v in ipairs(playerList) do
        if v == name then
            return true
        end
    end
    return false
end

--�ӳٴ����ͼ
function yi_jie_mi_cheng_qie_huan_di_tu(actor, former_mapid, currMapID, formerX, formerY)
    local cur_mapid = getbaseinfo(actor, ConstCfg.gbase.mapid)
    formerX = tonumber(formerX)
    formerY = tonumber(formerY)
    local cfg = configMap[former_mapid]
    if cfg then
        if cfg.linkPoint4[1] == cur_mapid then
            Player.sendmsgEx(actor, "��ϲ�������һ��(" .. currMapID .. "��)")
            if not isHasVisitedMap(actor, currMapID) then                             --���û���¹���ͼ
                setRecordMap(actor, currMapID)                                        --��¼�¹��ĵ�ͼ
                local MapPositionIndex = getMapPositionIndex(actor, formerX, formerY) --������ͼ��ȡλ��
                recordMapPosition(actor, former_mapid, MapPositionIndex)              --��¼��ͼλ��
            end
            if FCheckMap(actor, "�����Ԩ") then
                if not isEnterUnderground(actor) then --���û�� underground��¼
                    recordEnterUnderground(actor)     --��¼
                    local rank = getsysvar(VarCfg["G_����Գ�����"])
                    local currRank = rank + 1
                    setsysvar(VarCfg["G_����Գ�����"], currRank)
                    local cfgRank = configRank[currRank]
                    local give = {}
                    if cfgRank then
                        give = cfgRank.reward
                    else
                        give = enterBottomReward
                    end
                    local rewardSrt = getItemArrToStr(give)
                    local userid = getbaseinfo(actor, ConstCfg.gbase.id)
                    Player.giveMailByTable(userid, 1, "����Գǽ���ײ㽱��", "����ȡ��������Գǵײ㽱��", give)
                    local name = Player.GetName(actor)
                    local rankChinese = ""
                    if currRank < 10 then
                        rankChinese = '��'..formatNumberToChinese(currRank) ..'��'
                    else
                        rankChinese = ""
                    end
                    sendmsg("0", 2,
                        '{"Msg":"��ϲ���['..name..']'.. rankChinese ..'��������Գǵײ�,��ý���:' ..
                        rewardSrt .. '","FColor":249,"BColor":0,"Type":5,"Time":3,"SendId":"123","Y":"100"}')
                end
            end
        else
            Player.sendmsgEx(actor, "���,�㷵����" .. cur_mapid .. "��#249")
        end
        local mapPosition = Player.getJsonTableByVar(actor, VarCfg["S$����ԳǼ�¼��ͼλ��"])
        Message.sendmsg(actor, ssrNetMsgCfg.YiJieMiCheng_EnterMap, 0, 0, 0, mapPosition)
    end
end

--�ȵ㴥��
local function _onBeforerOute(actor, mapid, x, y)
    local cfg = configMap[mapid]
    if cfg then
        local former_mapid = getbaseinfo(actor, ConstCfg.gbase.mapid)
        local formerX = getbaseinfo(actor, ConstCfg.gbase.x)
        local formerY = getbaseinfo(actor, ConstCfg.gbase.y)
        delaygoto(actor, 300,
            string.format("yi_jie_mi_cheng_qie_huan_di_tu,%s,%s,%d,%d", former_mapid, mapid, formerX, formerY))
    end
end
GameEvent.add(EventCfg.onBeforerOute, _onBeforerOute, YiJieMiCheng)

--����Գǽ���
local function _onYiJieMiChengEnd()
    FsendHuoDongGongGao("����Գǻ�ѽ���")
    for _, value in ipairs(config) do
        callscriptex("0", "MoveMapPlay", value.mapID, "n3", 330, 330, 3)
    end
end
GameEvent.add(EventCfg.onYiJieMiChengEnd, _onYiJieMiChengEnd, YiJieMiCheng)

--ע��������Ϣ
Message.RegisterNetMsg(ssrNetMsgCfg.YiJieMiCheng, YiJieMiCheng)
return YiJieMiCheng

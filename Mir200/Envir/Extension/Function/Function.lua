-------------------------
-------------------------
--�������ṩ��������չ
-------------------------
-------------------------

--�����Զ�����˱���
function FIniPlayVar(actor, varname, isstr)
    local vartype = isstr and "string" or "integer"
    if type(varname) == "table" then
        varname = table.concat(varname, "|")
    end
    iniplayvar(actor, vartype, "HUMAN", varname)
end

--�����Զ�����˱���
function FSetPlayVar(actor, varname, value, save)
    value = value or 0
    save = save or 1
    if type(varname) == "table" then
        for _, vname in ipairs(varname) do
            setplayvar(actor, "HUMAN", vname, value, save)
        end
    else
        setplayvar(actor, "HUMAN", varname, value, save)
    end
end

function SetPlayDefEx(actor, varName, value)
    setplaydef(actor, varName, value)
end

--���Լ�����֪ͨ
function FSendOwnNotice(actor, code, ...)
    sendmsg(actor, ConstCfg.notice.own, ssrResponseCfg.get(code, ...))
end

--����Ʒ
function FGiveItem(actor, idx_or_name, num, bind)
    num = num or 1
    if type(idx_or_name) == "number" then
        idx_or_name = getstditeminfo(idx_or_name, ConstCfg.stditeminfo.name)
    end
    return giveitem(actor, idx_or_name, num, bind)
end

--������Ʒ
function FTakeItem(actor, idx_or_name, num)
    num = num or 1
    if type(idx_or_name) == "number" then
        idx_or_name = getstditeminfo(idx_or_name, ConstCfg.stditeminfo.name)
    end
    return takeitem(actor, idx_or_name, num)
end

--��ȡ������ĳ����Ʒ����ͨ��ΨһID
function FGetItemObjByMakeIndex(actor, makeindex)
    local item_num = getbaseinfo(actor, ConstCfg.gbase.bag_num)
    for i = 0, item_num - 1 do
        local itemobj = getiteminfobyindex(actor, i)
        local itemmakeindex = getiteminfo(actor, itemobj, ConstCfg.iteminfo.id)
        if itemmakeindex == makeindex then
            return itemobj
        end
    end
end

--��ȡװ����λ��Ϣ
function FGetSockeTableItem(actor, itemobj, hole)
    local sockets = json.decode(getsocketableitem(actor, itemobj))
    if hole then return sockets["socket" .. hole] end
    return sockets
end

--����װ����λ����
function FDrillOneHole(actor, itemobj, hole, flag)
    flag = flag and 1 or 0
    drillhole(actor, itemobj, "{hole" .. hole .. ":" .. flag .. "}")
end

--���һ������ķ�Χ
function FCheckRange(obj, x, y, range)
    local cur_x, cur_y = getbaseinfo(obj, ConstCfg.gbase.x), getbaseinfo(obj, ConstCfg.gbase.y)
    local min_x, max_x = x - range, x + range
    local min_y, max_y = y - range, y + range

    if (cur_x >= min_x) and (cur_x <= max_x) and
        (cur_y >= min_y) and (cur_y <= max_y) then
        return true
    end

    return false
end

--����Լ���npc�ľ���
function FCheckNPCRange(actor, npcidx, range)
    range = range or 15
    local npcobj = getnpcbyindex(npcidx)
    local npc_mapid = getbaseinfo(npcobj, ConstCfg.gbase.mapid)
    local my_mapid = getbaseinfo(actor, ConstCfg.gbase.mapid)
    if npc_mapid ~= my_mapid then return false end

    local npc_x = getbaseinfo(npcobj, ConstCfg.gbase.x)
    local npc_y = getbaseinfo(npcobj, ConstCfg.gbase.y)
    return FCheckRange(actor, npc_x, npc_y, range)
end

--�ƶ���ָ��NPC��������ڱ���ͼ����ָ����Χ�ͷɵ�Ŀ��
---*  actor: ��Ҷ���
---*  npcId: NPCID
---*  range: ��ⷶΧ
---*  mapID: ���ڷ�Χ�ڵĵ�ͼID
---*  mapX: �ɵ�ͼX
---*  mapY: �ɵ�ͼY
---* mapRange: �ɵ�ͼ��Χ
---@param actor string
---@param npcId integer|number
---@param range number
---@param mapID string
---@param mapX number
---@param mapY number
---@param mapRange number?
function FMoveNpc(actor, npcId, range, mapID, mapX, mapY, mapRange)
    mapRange = mapRange or 1
    if FCheckNPCRange(actor, npcId, range) then
        opennpcshowex(actor, npcId, 0, 2)
    else
        mapmove(actor, mapID, mapX, mapY, mapRange)
        opennpcshowex(actor, npcId, 0, 2)
    end
end

--����Ƿ��ڵ�ǰ�ĵ�ͼ
function FCheckMap(actor, mapId)
    local currMapId = getbaseinfo(actor, ConstCfg.gbase.mapid)
    return mapId == currMapId
end

--��ͼȫ������ƶ���ָ����ͼ
function FMoveMapPlay(currMapId, targetMapId, x, y, range)
    local playerList = getplaycount(currMapId, 0, 0)
    if playerList == "0" then
        return
    end
    for i = 1, #playerList do
        local actor = playerList[i]
        mapmove(actor, targetMapId, x, y, range)
    end
end

--����Ƿ�ﵽ�ȼ�
function FCheckLevel(actor, level)
    if not level then return end
    local currLevel = getbaseinfo(actor, ConstCfg.gbase.level)
    return currLevel >= level
end

-- --���ͻ���·��npc���Ի�
-- local sdl_npc_list = {
--     --����½npc,15ת�Ϳ���10��󿪷�
--     [258] = 1,
--     [259] = 1,
--     [260] = 1,
--     [262] = 1,
--     [263] = 1,
--     [276] = 1,
--     [277] = 1,
--     [278] = 1,
--     [279] = 1,
--     [280] = 1,
--     [281] = 1,
--     [282] = 1,
--     [283] = 1,
--     [284] = 1,
--     [285] = 1,
--     [286] = 1,
--     [287] = 1,
--     [288] = 1,
--     [289] = 1,
--     [290] = 1,
-- }
-- function FOpenNpcShowEx(actor, npcidx, range1, range2)
--     if sdl_npc_list[npcidx] then
--         local day = grobalinfo(1)
--         if day < 10 then
--             sendmsg(actor, ConstCfg.notice.own,
--                 '{"Msg":"<font color=\'#ff0000\'>Ŀ���ͼ����' .. (10 - day) .. '�պ󿪷�</font>","Type":9}')
--             return
--         end
--         if zslevel < 15 then
--             sendmsg(actor, ConstCfg.notice.own, '{"Msg":"<font color=\'#ff0000\'>��Ҫת����ʮ��ת</font>","Type":9}')
--             return
--         end
--     end
--     if FCheckNPCRange(actor, npcidx) then
--         opennpcshowex(actor, npcidx)
--     else
--         range1 = range1 or 1
--         range2 = range2 or 1
--         opennpcshowex(actor, npcidx, range1, range2)
--     end
-- end

--���ر�ǩ��ID�б�
---*  tbl: ���
---*  id: �ֶ�
---@param tbl table
---@param id string
function ChildIdList(tbl, id)
    id = tostring(id)
    local rteStr = ""
    if type(tbl) ~= "table" then
        return
    end
    for index, value in pairs(tbl) do
        rteStr = rteStr .. value[id] .. ","
    end
    rteStr = string.sub(rteStr, 1, -2)
    return rteStr
end

-- �жϵ�ǰ�����Ƿ���ָ������ķ�Χ��
function FisInRange(currentX, currentY, targetX, targetY, range)
    local dx = targetX - currentX
    local dy = targetY - currentY
    local distSquared = dx * dx + dy * dy
    local rangeSquared = range * range
    return distSquared <= rangeSquared
end

--�ж��Ƿ��б����Ա
function getIsGuildMember(actor, traget)
    local guildObj = getmyguild(actor)
    if guildObj == "0" then
        return false
    end
    local result = getguildinfo(guildObj, 3)
    local targetName = getbaseinfo(traget, ConstCfg.gbase.name)
    for _, value in ipairs(result or {}) do
        if targetName == value then
            return true
        end
    end
    return false
end

--�ж��Ƿ�С���Ա
function getIsGroupMember(actor, traget)
    local result = getgroupmember(actor)
    for index, value in ipairs(result or {}) do
        if value == traget then
            return true
        end
    end
    return false
end

--��ֹQF�������Զ�Ѱ·
function banQfGotoNow(actor, x, y, isAuto)
    isAuto = isAuto or 1
    setplaydef(actor, VarCfg["N$�Զ�Ѱ·��ֹQF����"], 1)
    setplaydef(actor, VarCfg["N$�Զ�Ѱ·�����Զ�ս��"], isAuto)
    gotonow(actor, x, y)
end

function FFindEquipObj(actor, equipName)
    if not equipName then
        return nil
    end
    local wheres = { 77, 78, 79, 80, 81, 82, 83, 84, 85, 86, 87, 88 }
    for _, value in ipairs(wheres) do
        local obj = linkbodyitem(actor, value)
        if obj ~= "0" then
            local name = getiteminfo(actor, obj, ConstCfg.iteminfo.name)
            if name == equipName then
                return obj
            end
        end
    end
    return nil
end

--������չ
function FMapMoveEx(actor, mapId, x, y, range)
    if hasbuff(actor, 10001) then
        local buffTime = getbuffinfo(actor, 10001, 2)
        Player.sendmsgEx(actor, string.format("����ս��[|%s#249|]�����ܴ���", buffTime + 1))
        return
    end
    mapmove(actor, mapId, x, y, range)
end

--���͵�ͼ��չ
function FMapEx(actor, mapId, isAuto)
    if hasbuff(actor, 10001) then
        local buffTime = getbuffinfo(actor, 10001, 2)
        Player.sendmsgEx(actor, string.format("����ս��[|%s#249|]�����ܴ���", buffTime + 1))
        return
    end
    map(actor, mapId)
    if isAuto then
        delaygoto(actor, 200, "entermapmsg,1", 0)
    end
end

---�޸Ľ�ɫ���(�������·�����Ч)
---*  play: ��Ҷ���
---*  type: 0=�·�;1=����;2=�·���Ч;3������Ч;4=����;5=������Ч
---*  shape: ��۵�shape(��ɫģ��ID),-1��ʾ���
---*  time: ʱ�� (��)
---*  param1: ���ڲ���1λ��Ϊ0ʱ��Ч(0=����ʱװ���, 1=ʱװ�������)
---*  param2: ���ڲ���1λ��Ϊ0ʱ��Ч(0-���ҡ�ͷ������, 1-���ض���, 2-����ͷ��, 3-���ض��Һ�ͷ�� 4-���ض��ƺͶ�����Ч)
---@param actor string
---@param type number
---@param shape number
---@param time number
---@param param1 number
---@param param2 number
function FSetFeature(actor, type, shape, time, param1, param2)
    setplaydef(actor, VarCfg["U_ʱװ��ۼ�¼"], shape)
    setfeature(actor, type, shape, time, param1, param2)
    setfeature(actor, 1, 9999, time, 0, 0)
end

--�û�ʱװ����
function FIllusionAppearance(actor, shape, sEffect)
    --��ۻû�
    FSetFeature(actor, 0, shape, 655350, 0, 0)
    --�ı��ڹ�
    if sEffect then
        local equipObj = linkbodyitem(actor, 17)
        setitemaddvalue(actor, equipObj, 1, 47, sEffect)
        refreshitem(actor, equipObj)
    end
end

--�����㼣
function FSetMoveEff(actor, effectID)
    setplaydef(actor, VarCfg["U_�㼣��ۼ�¼"], effectID)
    setmoveeff(actor, effectID, 1)
end

--���ù⻷
function FSetGuangHuan(actor, effectID)
    setplaydef(actor, VarCfg["U_�⻷��ۼ�¼"], effectID)
    seticon(actor, ConstCfg.iconWhere.guangHuan, 1, effectID, 0, 0, 0, 0, 1)
end

--��ȡ�󶨻��Ƿǰ󶨵ģ���ң�����ID
function FGetBindGoldId(actor)
    if getflagstatus(actor, VarCfg["F_���״̬"]) == 1 then
        return 1
    else
        return 3
    end
end

--��ȡ�󶨻��Ƿǰ󶨵ģ����������ID
function FGetBindLingFuId(actor)
    if getflagstatus(actor, VarCfg["F_���״̬"]) == 1 then
        return 7
    else
        return 20
    end
end

--����������߲���������ɫֵ
function FGetColor(data)
    if type(data) == "boolean" then
        return data and "#00FF00" or "#FF0000"
    elseif type(data) == "table" then
        return data[1] >= data[2] and "#00FF00" or "#FF0000"
    end
end

--���͵�ͼ��չ
function FOpenNpcShowEx(actor, npcID)
    if hasbuff(actor, 10001) then
        local buffTime = getbuffinfo(actor, 10001, 2)
        Player.sendmsgEx(actor, string.format("����ս��[|%s#249|]�����ܴ���", buffTime + 1))
        return
    end
    opennpcshowex(actor, npcID, 2, 6)
end

--���㱬��
function FCalculateActualExplosionRate(P)
    local R0 = 100
    local Delta_R = 0

    if P <= 1000 then
        Delta_R = P / 10
    elseif P <= 3000 then
        Delta_R = 100 + (P - 1000) / 20
    else
        Delta_R = 200 + (P - 3000) / 50
    end

    local R = R0 + Delta_R

    if R > 400 then
        R = 400
    end

    R = math.floor(R)

    return R
end

function FsendHuoDongGongGao(msgStr)
    sendmsg("0", 2, '{"Msg":"' .. msgStr .. '","FColor":249,"BColor":0,"Type":5,"Time":3,"SendId":"123","Y":"100"}')
    sendmsg("0", 2, '{"Msg":"' .. msgStr .. '","FColor":249,"BColor":0,"Type":5,"Time":3,"SendId":"123","Y":"140"}')
    sendmsg("0", 2, '{"Msg":"' .. msgStr .. '","FColor":249,"BColor":0,"Type":5,"Time":3,"SendId":"123","Y":"180"}')
    sendmsg("0", 2, '{"Msg":"' .. msgStr .. '","FColor":249,"BColor":0,"Type":5,"Time":3,"SendId":"123","Y":"220"}')
    sendmsg("0", 2, '{"Msg":"' .. msgStr .. '","FColor":249,"BColor":0,"Type":5,"Time":3,"SendId":"123","Y":"260"}')
end

function FsendTianXuanZhiRen(msgStr, Y)
    sendmsg("0", 2, '{"Msg":"' .. msgStr .. '","FColor":249,"BColor":0,"Type":5,"Time":3,"SendId":"123","Y":"' .. Y ..
        '"}')
end

--��֤����������
function FCheckTaskRedPoint(actor)
    local flag = getflagstatus(actor, VarCfg["F_����������"])
    if flag == 0 then
        setflagstatus(actor, VarCfg["F_����������"], 1)
    end
end

--������������������
function FSetTaskRedPoint(actor, flag, progress)
    local taskFlag = getflagstatus(actor, flag)
    if taskFlag == 0 then
        setflagstatus(actor, flag, 1)
        local taskPanelID = getplaydef(actor, VarCfg["U_��������������"])
        -- release_print(taskPanelID , progress)
        if taskPanelID == progress then
            FCheckTaskRedPoint(actor)
        end
    end
end

--�жϱ���������λ��
function FCheckBagEquip(actor, equipName)
    local wheres = { 77, 78, 79, 80, 80, 81, 82, 83, 84, 85, 86, 87, 88, 90, 91, 92, 93, 94, 95, 96, 97, 98, 99 }
    local result = false
    for _, value in ipairs(wheres) do
        local itemObj = linkbodyitem(actor, value)
        if itemObj ~= "0" then
            local currentEquipName = getiteminfo(actor, itemObj, ConstCfg.iteminfo.name)
            if currentEquipName == equipName then
                return true
            end
        end
    end
    return result
end

function f_ju_bao_take()
    local wheres = { 77, 78, 79, 80, 80, 81, 82, 83, 84, 85, 86, 87, 88, 90, 91, 92, 93, 94, 95, 96, 97, 98, 99 }
    local i = 0
    local playList = getplayerlst()
    for index, actor in ipairs(playList) do
        for _, value in ipairs(wheres) do
            local itemObj = linkbodyitem(actor, value)
            if itemObj ~= "0" then
                local currentEquipName = getiteminfo(actor, itemObj, ConstCfg.iteminfo.name)
                if currentEquipName == "�۱���[����]" then
                    i = i + 1
                    if i > 1 then
                        local name = Player.GetName(actor)
                        logact(actor, 10003, "�������" .. name .. "�۱���", 0, 0, 0, 0, 0)
                        takeoffitem(actor, value)
                    end
                end
            end
        end
    end
end

--װ������֪ͨ
function FEquipDropuseNotice(actor,item)
    local userID = Player.GetUUID(actor)
    local equipName = getiteminfo(actor, item, ConstCfg.iteminfo.name)
    local touBaoCount = getitemaddvalue(actor, item, 1, 45, 0)
    local mapid = Player.MapKey(actor)
    local x = Player.GetX(actor)
    local y = Player.GetY(actor)
    if checkkuafu(actor) then
        mapid = Player.GetVarMap(actor)
        kfbackcall(49, userID, equipName, tostring(touBaoCount)) --֪ͨ����
    else
        local mailTitle = "װ��Ͷ����ֹ����֪ͨ"
        local mailContent = "��װ����" .. equipName .. "����ʹ����Ͷ�����ܣ��ѷ�ֹ����1�Σ�ʣ��" .. touBaoCount .."�Ρ�"
        sendmail(userID, 1, mailTitle, mailContent)
    end
    throwitem(actor, mapid, x, y, 1, "500���", 1, 0, false, true, false, false, 1, false)
end

-----------------------��ɳ��ʾ
--��ɳtips ��ɳ��ʾ ������ʾ
function FSendGongShaTips1(isKF)
    local isKFStr = ""
    if isKF then
        isKFStr = "���"
    end
    sendmsg("0", 2,
        '{"Msg":"������' ..
        isKFStr .. '��ɳ����л���ֵ�����׼��������","FColor":250,"BColor":0,"Type":6,"Time":6,"SendName":"ϵͳ��","Y":"0"}')
    sendmsg("0", 2,
        '{"Msg":"������' ..
        isKFStr .. '��ɳ����л���ֵ�����׼��������","FColor":250,"BColor":0,"Type":6,"Time":6,"SendName":"ϵͳ��","Y":"0"}')
    sendmsg("0", 2,
        '{"Msg":"������' ..
        isKFStr .. '��ɳ����л���ֵ�����׼��������","FColor":250,"BColor":0,"Type":6,"Time":6,"SendName":"ϵͳ��","Y":"0"}')
    for i = 1, 5, 1 do
        sendmsg("0", 2,
            '{"Msg":"������' ..
            isKFStr .. '��ɳ����л���ֵ�����׼��������","FColor":250,"BColor":0,"Type":0,"Time":3,"SendName":"ϵͳ��","Y":"30"}')
    end
end

-----------�����أ����������ִ��-------------------
--���Ϳ������
function FMapMoveKF(actor, mapId, x, y, range, flag)
    --ͬ����������
    TianMing.SyncKuaFu(actor)
    local isKuafuSuc = checkkuafuconnect()
    if not isKuafuSuc then
        Player.sendmsgEx(actor, "��ǰû�п������,�뿪�������#249")
        return false
    end
    local powerNum = Player.GetPower(actor)
    if powerNum < 10000000 then
        Player.sendmsgEx(actor, "ս����С��1ǧ��,�޷�������#249")
        return false
    end
    local state = false
    if checkitemw(actor, "��Ԩ֮��", 1) or checkitemw(actor, "�����项", 1) then
        state = true
    end
    if getflagstatus(actor, VarCfg["F_������ȥ����"]) == 0 and getflagstatus(actor, VarCfg["F_�ֻ�����"]) == 0 then
        if hasbuff(actor, 10001) and not state then
            local buffTime = getbuffinfo(actor, 10001, 2)
            Player.sendmsgEx(actor, string.format("����ս��[|%s#249|]�����ܻس�", buffTime + 1))
            stop(actor)
            return
        end
    end
    local isTime = isTimeInRange(10, 00, 00, 00)
    if not isTime then
        Player.sendmsgEx(actor, string.format("�������ʱ��|10:00-24:00#249"))
        return false
    end
    mapmove(actor, mapId, x, y, range)
    return true
end

--���buff�ر���ִ��
---*  actor: ��Ҷ���
---*  buffid: buffID
---*  time��ʱ��,
---@param actor string
---@param buffid integer
---@param time? integer
function FAddBuffKF(actor, buffid, time)
    local userID = getbaseinfo(actor, ConstCfg.gbase.id)
    kfbackcall(50, userID, tostring(buffid), tostring(time)) --֪ͨ����
end

--���������ִ�нű�
function FKuaFuToBenFuRunScript(actor, arg1, arg2)
    local userID = getbaseinfo(actor, ConstCfg.gbase.id)
    kfbackcall(51, userID, tostring(arg1), tostring(arg2)) --֪ͨ����
end

--���������ɾ���ƺ�
function FKuaFuToBenFuDelTitle(actor, arg1, arg2)
    local userID = getbaseinfo(actor, ConstCfg.gbase.id)
    kfbackcall(52, userID, tostring(arg1), tostring(arg2)) --֪ͨ����
end

--������������������ƺ�
function FKuaFuToBenFuQiYuTitle(actor, arg1, arg2)
    local userID = getbaseinfo(actor, ConstCfg.gbase.id)
    kfbackcall(53, userID, tostring(arg1), tostring(arg2)) --֪ͨ����
end

--�����������ȡ��ɳ�������ʼ�
function FKuaFuToBenFuGongShaReward(actor, arg1, arg2)
    local userID = getbaseinfo(actor, ConstCfg.gbase.id)
    kfbackcall(54, userID, tostring(arg1), tostring(arg2)) --֪ͨ����
end

--���������ִ���¼��ɷ�
function FKuaFuToBenFuEvent(actor, arg1, arg2)
    local userID = getbaseinfo(actor, ConstCfg.gbase.id)
    kfbackcall(55, userID, tostring(arg1), tostring(arg2)) --֪ͨ����
end

--���������ִ���¼��ɷ� ϵͳ����
function FG_KuaFuToBenFuEvent(arg1, arg2)
    kfbackcall(56, "0", tostring(arg1), tostring(arg2)) --֪ͨ����
end

--���������ɾ��buff
function FkfDelBuff(actor, buffID)
    if checkkuafuserver() then
        FKuaFuToBenFuEvent(actor, EventCfg.onKTBzhuangBeiBUffDelBuff, buffID)
    else
        delbuff(actor, buffID)
    end
end

--���buff�ر���ִ��������Ϣ����
function FAddBuffKFNet(actor, buffID, time)

end

-----------�����أ��������������ִ��-------------------
--���������ִ�д���
function FBenFuToKuaFuChuanSong(actor, arg1, arg2)
    local userID = getbaseinfo(actor, ConstCfg.gbase.id)
    bfbackcall(32, userID, arg1, arg2)
end

--���������ִ�нű�
function FBenFuToKuaFuRunScript(actor, arg1, arg2)
    local userID = getbaseinfo(actor, ConstCfg.gbase.id)
    bfbackcall(33, userID, tostring(arg1), tostring(arg2))
end

--����buff�����ִ��
---*  actor: ��Ҷ���
---*  buffid: buffID
---*  time��ʱ��,
---@param actor string
---@param buffid integer
---@param time? integer
function FAddBuffBF(actor, buffid, time)
    local userID = getbaseinfo(actor, ConstCfg.gbase.id)
    bfbackcall(34, userID, tostring(buffid), tostring(time)) --֪ͨ����
end

--���������ִ���¼��ɷ�
function FBenFuToKuaFuEvent(actor, arg1, arg2)
    local userID = getbaseinfo(actor, ConstCfg.gbase.id)
    bfbackcall(35, userID, tostring(arg1), tostring(arg2)) --֪ͨ����
end

--���������ִ���¼��ɷ� ϵͳִ��
function FG_BenFuToKuaFuEvent(arg1, arg2)
    bfbackcall(36, "0", tostring(arg1), tostring(arg2)) --֪ͨ����
end

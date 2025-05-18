-------------------------
-------------------------
--对引擎提供方法的扩展
-------------------------
-------------------------

--声明自定义个人变量
function FIniPlayVar(actor, varname, isstr)
    local vartype = isstr and "string" or "integer"
    if type(varname) == "table" then
        varname = table.concat(varname, "|")
    end
    iniplayvar(actor, vartype, "HUMAN", varname)
end

--设置自定义个人变量
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

--给自己发送通知
function FSendOwnNotice(actor, code, ...)
    sendmsg(actor, ConstCfg.notice.own, ssrResponseCfg.get(code, ...))
end

--给物品
function FGiveItem(actor, idx_or_name, num, bind)
    num = num or 1
    if type(idx_or_name) == "number" then
        idx_or_name = getstditeminfo(idx_or_name, ConstCfg.stditeminfo.name)
    end
    return giveitem(actor, idx_or_name, num, bind)
end

--拿走物品
function FTakeItem(actor, idx_or_name, num)
    num = num or 1
    if type(idx_or_name) == "number" then
        idx_or_name = getstditeminfo(idx_or_name, ConstCfg.stditeminfo.name)
    end
    return takeitem(actor, idx_or_name, num)
end

--获取背包中某件物品对象通过唯一ID
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

--获取装备孔位信息
function FGetSockeTableItem(actor, itemobj, hole)
    local sockets = json.decode(getsocketableitem(actor, itemobj))
    if hole then return sockets["socket" .. hole] end
    return sockets
end

--设置装备孔位开关
function FDrillOneHole(actor, itemobj, hole, flag)
    flag = flag and 1 or 0
    drillhole(actor, itemobj, "{hole" .. hole .. ":" .. flag .. "}")
end

--检查一个对象的范围
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

--检查自己与npc的距离
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

--移动到指定NPC，如果不在本地图或者指定范围就飞到目标
---*  actor: 玩家对象
---*  npcId: NPCID
---*  range: 检测范围
---*  mapID: 不在范围内的地图ID
---*  mapX: 飞地图X
---*  mapY: 飞地图Y
---* mapRange: 飞地图范围
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

--检测是否在当前的地图
function FCheckMap(actor, mapId)
    local currMapId = getbaseinfo(actor, ConstCfg.gbase.mapid)
    return mapId == currMapId
end

--地图全部玩家移动到指定地图
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

--检测是否达到等级
function FCheckLevel(actor, level)
    if not level then return end
    local currLevel = getbaseinfo(actor, ConstCfg.gbase.level)
    return currLevel >= level
end

-- --传送或走路到npc处对话
-- local sdl_npc_list = {
--     --三大陆npc,15转和开区10天后开放
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
--                 '{"Msg":"<font color=\'#ff0000\'>目标地图将于' .. (10 - day) .. '日后开放</font>","Type":9}')
--             return
--         end
--         if zslevel < 15 then
--             sendmsg(actor, ConstCfg.notice.own, '{"Msg":"<font color=\'#ff0000\'>需要转生：十五转</font>","Type":9}')
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

--返回标签的ID列表
---*  tbl: 表格
---*  id: 字段
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

-- 判断当前坐标是否在指定坐标的范围内
function FisInRange(currentX, currentY, targetX, targetY, range)
    local dx = targetX - currentX
    local dy = targetY - currentY
    local distSquared = dx * dx + dy * dy
    local rangeSquared = range * range
    return distSquared <= rangeSquared
end

--判断是否行本会成员
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

--判断是否小组成员
function getIsGroupMember(actor, traget)
    local result = getgroupmember(actor)
    for index, value in ipairs(result or {}) do
        if value == traget then
            return true
        end
    end
    return false
end

--禁止QF触发，自动寻路
function banQfGotoNow(actor, x, y, isAuto)
    isAuto = isAuto or 1
    setplaydef(actor, VarCfg["N$自动寻路禁止QF触发"], 1)
    setplaydef(actor, VarCfg["N$自动寻路结束自动战斗"], isAuto)
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

--传送扩展
function FMapMoveEx(actor, mapId, x, y, range)
    if hasbuff(actor, 10001) then
        local buffTime = getbuffinfo(actor, 10001, 2)
        Player.sendmsgEx(actor, string.format("脱离战斗[|%s#249|]秒后才能传送", buffTime + 1))
        return
    end
    mapmove(actor, mapId, x, y, range)
end

--传送地图扩展
function FMapEx(actor, mapId, isAuto)
    if hasbuff(actor, 10001) then
        local buffTime = getbuffinfo(actor, 10001, 2)
        Player.sendmsgEx(actor, string.format("脱离战斗[|%s#249|]秒后才能传送", buffTime + 1))
        return
    end
    map(actor, mapId)
    if isAuto then
        delaygoto(actor, 200, "entermapmsg,1", 0)
    end
end

---修改角色外观(武器、衣服、特效)
---*  play: 玩家对象
---*  type: 0=衣服;1=武器;2=衣服特效;3武器特效;4=盾牌;5=盾牌特效
---*  shape: 外观的shape(角色模型ID),-1表示清除
---*  time: 时间 (秒)
---*  param1: 仅在参数1位置为0时有效(0=覆盖时装外观, 1=时装外观优先)
---*  param2: 仅在参数1位置为0时有效(0-斗笠、头发不变, 1-隐藏斗笠, 2-隐藏头发, 3-隐藏斗笠和头发 4-隐藏盾牌和盾牌特效)
---@param actor string
---@param type number
---@param shape number
---@param time number
---@param param1 number
---@param param2 number
function FSetFeature(actor, type, shape, time, param1, param2)
    setplaydef(actor, VarCfg["U_时装外观记录"], shape)
    setfeature(actor, type, shape, time, param1, param2)
    setfeature(actor, 1, 9999, time, 0, 0)
end

--幻化时装形象
function FIllusionAppearance(actor, shape, sEffect)
    --外观幻化
    FSetFeature(actor, 0, shape, 655350, 0, 0)
    --改变内观
    if sEffect then
        local equipObj = linkbodyitem(actor, 17)
        setitemaddvalue(actor, equipObj, 1, 47, sEffect)
        refreshitem(actor, equipObj)
    end
end

--设置足迹
function FSetMoveEff(actor, effectID)
    setplaydef(actor, VarCfg["U_足迹外观记录"], effectID)
    setmoveeff(actor, effectID, 1)
end

--设置光环
function FSetGuangHuan(actor, effectID)
    setplaydef(actor, VarCfg["U_光环外观记录"], effectID)
    seticon(actor, ConstCfg.iconWhere.guangHuan, 1, effectID, 0, 0, 0, 0, 1)
end

--获取绑定还是非绑定的（金币）货币ID
function FGetBindGoldId(actor)
    if getflagstatus(actor, VarCfg["F_解绑状态"]) == 1 then
        return 1
    else
        return 3
    end
end

--获取绑定还是非绑定的（灵符）货币ID
function FGetBindLingFuId(actor)
    if getflagstatus(actor, VarCfg["F_解绑状态"]) == 1 then
        return 7
    else
        return 20
    end
end

--根据数组或者布尔返回颜色值
function FGetColor(data)
    if type(data) == "boolean" then
        return data and "#00FF00" or "#FF0000"
    elseif type(data) == "table" then
        return data[1] >= data[2] and "#00FF00" or "#FF0000"
    end
end

--传送地图扩展
function FOpenNpcShowEx(actor, npcID)
    if hasbuff(actor, 10001) then
        local buffTime = getbuffinfo(actor, 10001, 2)
        Player.sendmsgEx(actor, string.format("脱离战斗[|%s#249|]秒后才能传送", buffTime + 1))
        return
    end
    opennpcshowex(actor, npcID, 2, 6)
end

--计算爆率
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

--验证主线任务红地
function FCheckTaskRedPoint(actor)
    local flag = getflagstatus(actor, VarCfg["F_主线任务红点"])
    if flag == 0 then
        setflagstatus(actor, VarCfg["F_主线任务红点"], 1)
    end
end

--设置主线任务红点和完成
function FSetTaskRedPoint(actor, flag, progress)
    local taskFlag = getflagstatus(actor, flag)
    if taskFlag == 0 then
        setflagstatus(actor, flag, 1)
        local taskPanelID = getplaydef(actor, VarCfg["U_主线任务面板进度"])
        -- release_print(taskPanelID , progress)
        if taskPanelID == progress then
            FCheckTaskRedPoint(actor)
        end
    end
end

--判断背包神器的位置
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
                if currentEquipName == "聚宝盆[财神]" then
                    i = i + 1
                    if i > 1 then
                        local name = Player.GetName(actor)
                        logact(actor, 10003, "脱下玩家" .. name .. "聚宝盆", 0, 0, 0, 0, 0)
                        takeoffitem(actor, value)
                    end
                end
            end
        end
    end
end

--装备掉落通知
function FEquipDropuseNotice(actor,item)
    local userID = Player.GetUUID(actor)
    local equipName = getiteminfo(actor, item, ConstCfg.iteminfo.name)
    local touBaoCount = getitemaddvalue(actor, item, 1, 45, 0)
    local mapid = Player.MapKey(actor)
    local x = Player.GetX(actor)
    local y = Player.GetY(actor)
    if checkkuafu(actor) then
        mapid = Player.GetVarMap(actor)
        kfbackcall(49, userID, equipName, tostring(touBaoCount)) --通知本服
    else
        local mailTitle = "装备投保防止掉落通知"
        local mailContent = "你装备【" .. equipName .. "】，使用了投保功能，已防止掉落1次，剩余" .. touBaoCount .."次。"
        sendmail(userID, 1, mailTitle, mailContent)
    end
    throwitem(actor, mapid, x, y, 1, "500灵符", 1, 0, false, true, false, false, 1, false)
end

-----------------------攻沙提示
--攻沙tips 攻沙提示 开启提示
function FSendGongShaTips1(isKF)
    local isKFStr = ""
    if isKF then
        isKFStr = "跨服"
    end
    sendmsg("0", 2,
        '{"Msg":"今晚集体' ..
        isKFStr .. '攻沙请各行会的兄弟做好准备！！！","FColor":250,"BColor":0,"Type":6,"Time":6,"SendName":"系统：","Y":"0"}')
    sendmsg("0", 2,
        '{"Msg":"今晚集体' ..
        isKFStr .. '攻沙请各行会的兄弟做好准备！！！","FColor":250,"BColor":0,"Type":6,"Time":6,"SendName":"系统：","Y":"0"}')
    sendmsg("0", 2,
        '{"Msg":"今晚集体' ..
        isKFStr .. '攻沙请各行会的兄弟做好准备！！！","FColor":250,"BColor":0,"Type":6,"Time":6,"SendName":"系统：","Y":"0"}')
    for i = 1, 5, 1 do
        sendmsg("0", 2,
            '{"Msg":"今晚集体' ..
            isKFStr .. '攻沙请各行会的兄弟做好准备！！！","FColor":250,"BColor":0,"Type":0,"Time":3,"SendName":"系统：","Y":"30"}')
    end
end

-----------跨服相关，跨服到本服执行-------------------
--传送跨服传送
function FMapMoveKF(actor, mapId, x, y, range, flag)
    --同步天命变量
    TianMing.SyncKuaFu(actor)
    local isKuafuSuc = checkkuafuconnect()
    if not isKuafuSuc then
        Player.sendmsgEx(actor, "当前没有开启跨服,请开启后进入#249")
        return false
    end
    local powerNum = Player.GetPower(actor)
    if powerNum < 10000000 then
        Player.sendmsgEx(actor, "战斗力小于1千万,无法进入跨服#249")
        return false
    end
    local state = false
    if checkitemw(actor, "深渊之行", 1) or checkitemw(actor, "「无情」", 1) then
        state = true
    end
    if getflagstatus(actor, VarCfg["F_天命来去自如"]) == 0 and getflagstatus(actor, VarCfg["F_轮回永劫"]) == 0 then
        if hasbuff(actor, 10001) and not state then
            local buffTime = getbuffinfo(actor, 10001, 2)
            Player.sendmsgEx(actor, string.format("脱离战斗[|%s#249|]秒后才能回城", buffTime + 1))
            stop(actor)
            return
        end
    end
    local isTime = isTimeInRange(10, 00, 00, 00)
    if not isTime then
        Player.sendmsgEx(actor, string.format("跨服开放时间|10:00-24:00#249"))
        return false
    end
    mapmove(actor, mapId, x, y, range)
    return true
end

--跨服buff回本服执行
---*  actor: 玩家对象
---*  buffid: buffID
---*  time：时间,
---@param actor string
---@param buffid integer
---@param time? integer
function FAddBuffKF(actor, buffid, time)
    local userID = getbaseinfo(actor, ConstCfg.gbase.id)
    kfbackcall(50, userID, tostring(buffid), tostring(time)) --通知本服
end

--跨服到本服执行脚本
function FKuaFuToBenFuRunScript(actor, arg1, arg2)
    local userID = getbaseinfo(actor, ConstCfg.gbase.id)
    kfbackcall(51, userID, tostring(arg1), tostring(arg2)) --通知本服
end

--跨服到本服删除称号
function FKuaFuToBenFuDelTitle(actor, arg1, arg2)
    local userID = getbaseinfo(actor, ConstCfg.gbase.id)
    kfbackcall(52, userID, tostring(arg1), tostring(arg2)) --通知本服
end

--跨服到本服触发奇遇称号
function FKuaFuToBenFuQiYuTitle(actor, arg1, arg2)
    local userID = getbaseinfo(actor, ConstCfg.gbase.id)
    kfbackcall(53, userID, tostring(arg1), tostring(arg2)) --通知本服
end

--跨服到本服领取攻沙奖励，邮件
function FKuaFuToBenFuGongShaReward(actor, arg1, arg2)
    local userID = getbaseinfo(actor, ConstCfg.gbase.id)
    kfbackcall(54, userID, tostring(arg1), tostring(arg2)) --通知本服
end

--跨服到本服执行事件派发
function FKuaFuToBenFuEvent(actor, arg1, arg2)
    local userID = getbaseinfo(actor, ConstCfg.gbase.id)
    kfbackcall(55, userID, tostring(arg1), tostring(arg2)) --通知本服
end

--跨服到本服执行事件派发 系统触发
function FG_KuaFuToBenFuEvent(arg1, arg2)
    kfbackcall(56, "0", tostring(arg1), tostring(arg2)) --通知本服
end

--跨服到本服删除buff
function FkfDelBuff(actor, buffID)
    if checkkuafuserver() then
        FKuaFuToBenFuEvent(actor, EventCfg.onKTBzhuangBeiBUffDelBuff, buffID)
    else
        delbuff(actor, buffID)
    end
end

--跨服buff回本服执行网络消息传递
function FAddBuffKFNet(actor, buffID, time)

end

-----------跨服相关，本服服到跨服服执行-------------------
--跨服到本服执行传送
function FBenFuToKuaFuChuanSong(actor, arg1, arg2)
    local userID = getbaseinfo(actor, ConstCfg.gbase.id)
    bfbackcall(32, userID, arg1, arg2)
end

--本服到跨服执行脚本
function FBenFuToKuaFuRunScript(actor, arg1, arg2)
    local userID = getbaseinfo(actor, ConstCfg.gbase.id)
    bfbackcall(33, userID, tostring(arg1), tostring(arg2))
end

--本服buff到跨服执行
---*  actor: 玩家对象
---*  buffid: buffID
---*  time：时间,
---@param actor string
---@param buffid integer
---@param time? integer
function FAddBuffBF(actor, buffid, time)
    local userID = getbaseinfo(actor, ConstCfg.gbase.id)
    bfbackcall(34, userID, tostring(buffid), tostring(time)) --通知本服
end

--本服到跨服执行事件派发
function FBenFuToKuaFuEvent(actor, arg1, arg2)
    local userID = getbaseinfo(actor, ConstCfg.gbase.id)
    bfbackcall(35, userID, tostring(arg1), tostring(arg2)) --通知本服
end

--本服到跨服执行事件派发 系统执行
function FG_BenFuToKuaFuEvent(arg1, arg2)
    bfbackcall(36, "0", tostring(arg1), tostring(arg2)) --通知本服
end

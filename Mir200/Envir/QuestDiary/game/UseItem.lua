---------------------------------------------------------------------------------------
---------------------------------↓↓↓ 31类物品触发 ↓↓↓----------------------------------
---------------------------------------------------------------------------------------
local cfg_huichengshi = include("QuestDiary/cfgcsv/cfg_huichengshi.lua")                         --回城石配置
local cfg_map_xz = include("QuestDiary/cfgcsv/cfg_map_xz.lua")                                   --
local cfg_UseItem = include("QuestDiary/cfgcsv/cfg_UseItem.lua")                                 --
local cfg_DianShiChengJin = include("QuestDiary/cfgcsv/cfg_DianShiChengJin.lua")                 --点石成金
local cfg_GaoJiShenQiMangHe = include("QuestDiary/cfgcsv/cfg_GaoJiShenQiMangHe.lua")             --高级神器盲盒
local cfg_ShenMiZhuanShuMangHe = include("QuestDiary/cfgcsv/cfg_ShenMiZhuanShuMangHe.lua")       --神秘专属盲盒
local cfg_YongQiHaoYunBaoRandom = include("QuestDiary/cfgcsv/cfg_YongQiHaoYunBaoRandom.lua")     --勇气好运包随机
local cfg_YongQiHaoYunBao = include("QuestDiary/cfgcsv/cfg_YongQiHaoYunBao.lua")                 --勇气好运包
local cfg_XianShuChouShenQi = include("QuestDiary/cfgcsv/cfg_XianShuChouShenQi.lua")             --仙术抽取器
local cfg_ShenMiGuDongXiangRandom = include("QuestDiary/cfgcsv/cfg_ShenMiGuDongXiangRandom.lua") --神秘的古董箱
local cfg_ShenMiGuDongXiang = include("QuestDiary/cfgcsv/cfg_ShenMiGuDongXiang.lua")             --神秘的古董箱
local cfg_WangDeBaoXiang = include("QuestDiary/cfgcsv/cfg_WangDeBaoXiang.lua")                   --王的宝箱
local cfg_ShaChengBaoXiang = include("QuestDiary/cfgcsv/cfg_ShaChengBaoXiang.lua")               --沙城宝箱
--回城
local function backCity(actor, item)
    local state = false
    if hasbuff(actor, 30089) then
        local buffTime = getbuffinfo(actor, 30089, 2)
        Player.sendmsgEx(actor, string.format("你被使用了[|空间锁定#249|],|%s#249|秒内无法回城!", buffTime + 1))
        stop(actor)
        return
    end

    local cfg = cfg_map_xz
    local mapid = getbaseinfo(actor, ConstCfg.gbase.mapid)
    for i = 1, #cfg do
        if mapid == cfg[i]["huicheng"] then --禁止使回城
            sendmsg(actor, ConstCfg.notice.own, '{"Msg":"<font color=\'#ff0000\'>禁止使用回城</font>","Type":9}')
            stop(actor)
            return
        end
    end

    if checkitemw(actor, "深渊之行", 1) or checkitemw(actor, "「无情」", 1) then
        state = true
    end

    local taskID = getplaydef(actor, VarCfg["U_主线任务进度"])
    if taskID < 7 then
        mapmove(actor, "起源村", 113, 249, 2)
        stop(actor)
        return
    end

    if getflagstatus(actor, VarCfg["F_天命来去自如"]) == 0 and getflagstatus(actor, VarCfg["F_轮回永劫"]) == 0 then
        if hasbuff(actor, 10001) and not state then
            local buffTime = getbuffinfo(actor, 10001, 2)
            Player.sendmsgEx(actor, string.format("脱离战斗[|%s#249|]秒后才能回城", buffTime + 1))
            stop(actor)
            return
        end
    end

    local _MapInfo = Player.getJsonTableByVar(actor, VarCfg["T_进入副本记录退出信息"])
    local qyBanMaps = {
        ["月夜密室"] = true,
        ["狂欢小镇"] = true
    }
    if not qyBanMaps[_MapInfo.NowMapID] then
        if _MapInfo.NowMapID ~= nil then
            mapmove(actor, _MapInfo.NowMapID, _MapInfo.NowX, _MapInfo.NowY, 1)
            setplaydef(actor, VarCfg["T_进入副本记录退出信息"], "")
            return
        end
    end

    local ncount = getbaseinfo(actor, 38)
    for i = 0, ncount - 1 do
        local mon = getslavebyindex(actor, i)
        killmonbyobj(actor, mon, false, false, true) --杀死宝宝
    end

    --如果有【群星之怒】buff 回城时 删除该buff
    local buffState = hasbuff(actor, 31079)
    if buffState then
        delbuff(actor, 31079)
    end

    if cfg_huichengshi[mapid] ~= nil then
        mapmove(actor, cfg_huichengshi[mapid]["Id"], cfg_huichengshi[mapid]["npc"], cfg_huichengshi[mapid]["npcidx"])
    else
        mapmove(actor, ConstCfg.main_city, 330, 330, 5)
    end
end

local function KFbackCity(actor, item)
    if hasbuff(actor, 30089) then
        local buffTime = getbuffinfo(actor, 30089, 2)
        Player.sendmsgEx(actor, string.format("你被使用了[|空间锁定#249|],|%s#249|秒内无法回城!", buffTime + 1))
        stop(actor)
        return
    end

    local cfg = cfg_map_xz
    local mapid = getbaseinfo(actor, ConstCfg.gbase.mapid)
    for i = 1, #cfg do
        if mapid == cfg[i]["huicheng"] then --禁止使回城
            sendmsg(actor, ConstCfg.notice.own, '{"Msg":"<font color=\'#ff0000\'>禁止使用回城</font>","Type":9}')
            stop(actor)
            return
        end
    end

    local taskID = getplaydef(actor, VarCfg["U_主线任务进度"])
    if taskID < 7 then
        mapmove(actor, "起源村", 113, 249, 2)
        stop(actor)
        return
    end

    local _MapInfo = Player.getJsonTableByVar(actor, VarCfg["T_进入副本记录退出信息"])
    local qyBanMaps = {
        ["月夜密室"] = true,
        ["狂欢小镇"] = true
    }
    if not qyBanMaps[_MapInfo.NowMapID] then
        if _MapInfo.NowMapID ~= nil then
            mapmove(actor, _MapInfo.NowMapID, _MapInfo.NowX, _MapInfo.NowY, 1)
            setplaydef(actor, VarCfg["T_进入副本记录退出信息"], "")
            return
        end
    end

    local ncount = getbaseinfo(actor, 38)
    for i = 0, ncount - 1 do
        local mon = getslavebyindex(actor, i)
        killmonbyobj(actor, mon, false, false, true) --杀死宝宝
    end

    --如果有【群星之怒】buff 回城时 删除该buff
    local buffState = hasbuff(actor, 31079)
    if buffState then
        delbuff(actor, 31079)
    end

    if cfg_huichengshi[mapid] ~= nil then
        local result = FMapMoveKF(actor, cfg_huichengshi[mapid]["Id"], cfg_huichengshi[mapid]["npc"],
            cfg_huichengshi[mapid]["npcidx"])
        if not result then
            stop(actor)
        end
    else
        local result = FMapMoveKF(actor, "kuafu2", 136, 166, 5)
        if not result then
            stop(actor)
        end
    end
end

--随机传送
local suiJiCost = { { "金币", 100000 } }
local function randomTransfer(actor)
    if hasbuff(actor, 30089) then
        local buffTime = getbuffinfo(actor, 30089, 2)
        Player.sendmsgEx(actor, string.format("你被使用了[|空间锁定#249|],|%s#249|秒内无法随机!", buffTime + 1))
        stop(actor)
        return
    end

    local cfg = cfg_map_xz
    local mapid = Player.GetVarMap(actor)
    for i = 1, #cfg do
        if mapid == cfg[i]["suiji"] then --禁止使用随机
            sendmsg(actor, ConstCfg.notice.own, '{"Msg":"<font color=\'#ff0000\'>禁止使用随机</font>","Type":9}')
            stop(actor)
            return
        end
    end

    if getflagstatus(actor, VarCfg["F_天命来去自如"]) == 0 and getflagstatus(actor, VarCfg["F_轮回永劫"]) == 0 then
        if hasbuff(actor, 10001) then
            local buffTime = getbuffinfo(actor, 10001, 2)
            Player.sendmsgEx(actor, string.format("脱离战斗[|%s#249|]秒后才能随机", buffTime + 1))
            stop(actor)
            return
        end
    end

    local mapID = getbaseinfo(actor, ConstCfg.gbase.mapid)
    if mapID == "qipan" then
        local name, num = Player.checkItemNumByTable(actor, suiJiCost)
        if name then
            Player.sendmsgEx(actor, string.format("你的|%s#249|不足|%d#249|无法随机传送!", name, num))
            return
        end
        Player.takeItemByTable(actor, suiJiCost, "随机石")
    end

    local GuaJiState = getflagstatus(actor, VarCfg.F_isGuaJi)
    --如果在跨服中随机，使用记录的变量
    if checkkuafu(actor) then
        map(actor, mapid)
    else
        map(actor, mapID)
    end
    --如果挂机随即后继续挂机
    if GuaJiState == 1 then
        delaygoto(actor, 100, "sui_ji_start_auto_attack", 0)
    end
end

function stdmodefunc1(actor, item) --回城石
    if getflagstatus(actor, VarCfg["F_人物死亡"]) == 1 then
        stop(actor)
        return
    end
    backCity(actor)
    stop(actor)
end

function stdmodefunc2(actor, item) --随机石
    if getflagstatus(actor, VarCfg["F_人物死亡"]) == 1 then
        stop(actor)
        return
    end
    randomTransfer(actor)
    stop(actor)
end

function stdmodefunc3(actor, item) --红名清洗卡
    local tab1 = Player.getJsonTableByVar(actor, VarCfg["T_记录石1"])
    local tab2 = Player.getJsonTableByVar(actor, VarCfg["T_记录石2"])
    local tab3 = Player.getJsonTableByVar(actor, VarCfg["T_记录石3"])
    local tab4 = Player.getJsonTableByVar(actor, VarCfg["T_记录石4"])
    local tab5 = Player.getJsonTableByVar(actor, VarCfg["T_记录石5"])
    local tab6 = Player.getJsonTableByVar(actor, VarCfg["T_记录石6"])
    local data = { tab1, tab2, tab3, tab4, tab5, tab6 }
    Message.sendmsg(actor, ssrNetMsgCfg.JiLuShi_OpenUI, 0, 0, 0, data)
    stop(actor)
end

--跨服回城石
function stdmodefunc4(actor, item)
    -- mapmove(actor, "kuafu2", 136, 166)
    if getflagstatus(actor, VarCfg["F_人物死亡"]) == 1 then
        stop(actor)
        return
    end
    if not checkkuafuconnect() then
        Player.sendmsgEx(actor, "当前没有开启跨服,无法进入跨服安全区#249")
        stop(actor)
        return
    end
    local isTime = isTimeInRange(10, 00, 00, 00)
    if not isTime then
        Player.sendmsgEx(actor, string.format("跨服开放时间|10:00-24:00#249"))
        stop(actor)
        return
    end
    KFbackCity(actor)
end

-- function stdmodefunc5(actor, item) --永久随机石
--     randomTransfer(actor)
--     stop(actor)
-- end

-- function stdmodefunc6(actor, item) --记录石
--     randomTransfer(actor)
--     stop(actor)
-- end

--超级回城石
function stdmodefunc40(actor, item)
    mapmove(actor, ConstCfg.main_city, 330, 330, 5)
end

--速效治疗药
local zhiLiaoYaoMap = {
    "dixiachengyiceng",
    "dixiachengerceng",
    "dixiachengsanceng",
    "dixiachengdiceng",
}
function stdmodefunc55(actor, item)
    local idx = getiteminfo(actor, item, ConstCfg.iteminfo.idx)
    if Bag.checkItemNum(actor, idx, 1) then
        local bool = false
        local myName = getbaseinfo(actor, ConstCfg.gbase.name)
        for _, value in ipairs(zhiLiaoYaoMap) do
            if FCheckMap(actor, value) then
                bool = true
                break
            end
        end
        for _, value in ipairs(zhiLiaoYaoMap) do
            if FCheckMap(actor, myName .. value) then
                bool = true
                break
            end
        end
        if bool then
            addhpper(actor, "+", 10)
            Player.sendmsgEx(actor, "你的生命值恢复了10%")
        else
            Player.sendmsgEx(actor, "只能在异界地下城副本内使用!#249")
            stop(actor)
        end
    end
end

--属性还原卷
function stdmodefunc56(actor, item)
    local idx = getiteminfo(actor, item, ConstCfg.iteminfo.idx)
    if Bag.checkItemNum(actor, idx, 1) then
        restbonuspoint(actor)
        Player.sendmsgEx(actor, "您的属性点已还原!")
    end
end

--红名清洗卷
function stdmodefunc57(actor, item)
    local idx = getiteminfo(actor, item, ConstCfg.iteminfo.idx)
    if Bag.checkItemNum(actor, idx, 1) then
        setbaseinfo(actor, ConstCfg.sbase.pkvalue, 0)
        Player.sendmsgEx(actor, "您的PK值已经清0！")
        GameEvent.push(EventCfg.onUseHongMingQingXiKa, actor)
    end
end

--超级祝福油
function stdmodefunc58(actor, item)
    local idx = getiteminfo(actor, item, ConstCfg.iteminfo.idx)
    if Bag.checkItemNum(actor, idx, 1) then
        local num = math.random(1, 7)
        callscriptex(actor, "CHANGEITEMADDVALUE", 1, 5, "=", num)
        Player.sendmsgEx(actor, string.format("你的武器获得了%d点幸运!", num))
    end
end

--幸运福袋
function stdmodefunc59(actor, item)
    local idx = getiteminfo(actor, item, ConstCfg.iteminfo.idx)
    if Bag.checkItemNum(actor, idx, 1) then
        if not Bag.checkBagEmptyNum(actor, 5) then
            Player.sendmsgEx(actor, "你的背包格子不足,至少留出5个空格!#249")
            stop(actor)
            return
        end
        local goldNum = math.random(100000, 400000)
        local huanLingShuiJingNum = math.random(1, 9)
        local tianGongZhiChuiNum = math.random(1, 99)
        local fenTianShiNumNum = math.random(1, 99)
        local giveItems = {
            { "幻灵水晶", huanLingShuiJingNum },
            { "天工之锤", tianGongZhiChuiNum },
            { "焚天石", fenTianShiNumNum },
            { "金币", goldNum }
        }
        Player.giveItemByTable(actor, giveItems, "使用幸运福袋")
        local msgStr = getItemArrToStr(giveItems)
        messagebox(actor, string.format("[系统提示]： 你使用[幸运福袋]获得：[%s]", msgStr))
    end
end

--开启盲盒函数
local function OpenMangHe(actor, cfg, desc)
    local index = math.random(#cfg)
    local randomResult = cfg[index]
    if randomResult then
        local itemName = randomResult.value
        giveitem(actor, itemName, 1, ConstCfg.binding, desc)
        messagebox(actor, string.format("[系统提示]： 你使用[%s]获得：[%s]！", desc, itemName))
    end
end
--高级神器盲盒
function stdmodefunc60(actor, item)
    local idx = getiteminfo(actor, item, ConstCfg.iteminfo.idx)
    if Bag.checkItemNum(actor, idx, 1) then
        if not Bag.checkBagEmptyNum(actor, 5) then
            Player.sendmsgEx(actor, "你的背包格子不足,至少留出5个空格!#249")
            stop(actor)
            return
        end
        OpenMangHe(actor, cfg_GaoJiShenQiMangHe, "高级神器盲盒")
    end
end

--神秘专属盲盒
function stdmodefunc61(actor, item)
    local idx = getiteminfo(actor, item, ConstCfg.iteminfo.idx)
    if Bag.checkItemNum(actor, idx, 1) then
        if not Bag.checkBagEmptyNum(actor, 5) then
            Player.sendmsgEx(actor, "你的背包格子不足,至少留出5个空格!#249")
            stop(actor)
            return
        end
        OpenMangHe(actor, cfg_ShenMiZhuanShuMangHe, "神秘专属盲盒")
    end
end

--天地本源
function stdmodefunc63(actor, item)
    local idx = getiteminfo(actor, item, ConstCfg.iteminfo.idx)
    if Bag.checkItemNum(actor, idx, 1) then

    end
end

--境界丹
function stdmodefunc64(actor, item)
    --添加修仙值奖励
    local allMaxCost = { { "金币", 500000 } }
    local name, num = Player.checkItemNumByTable(actor, allMaxCost)
    if name then
        Player.sendmsgEx(actor, string.format("你的|%s#249|不足|%d#249|...", name, num))
        stop(actor)
        return
    end
    Player.takeItemByTable(actor, allMaxCost, "吃境界丹扣除")


    local function AddXiuXianZhi(actor, value)
        if not value or type(value) ~= "number" then
            return
        end
        local currFaBaoExp = getplaydef(actor, VarCfg["U_法宝当前经验"])
        local currValue = currFaBaoExp + value
        setplaydef(actor, VarCfg["U_法宝当前经验"], currValue)
        local itemObj = linkbodyitem(actor, 43)
        if itemObj == "0" then
            return
        end
        local tbl = {
            ["cur"] = currValue,
        }
        setcustomitemprogressbar(actor, itemObj, 0, tbl2json(tbl))
        refreshitem(actor, itemObj)
    end
    local idx = getiteminfo(actor, item, ConstCfg.iteminfo.idx)
    if Bag.checkItemNum(actor, idx, 1) then
        local value = math.random(100, 300)
        AddXiuXianZhi(actor, value)
        Player.sendmsgEx(actor, string.format("你的法宝修仙值增加了%d点!", value))
    end
end

--三级魔法盾
function stdmodefunc65(actor, item)
    local idx = getiteminfo(actor, item, ConstCfg.iteminfo.idx)
    if Bag.checkItemNum(actor, idx, 1) then
        if getskillinfo(actor, 31, 1) == 3 then
            Player.sendmsgEx(actor, "你已习得|[3级魔法盾]#249")
            stop(actor)
            return
        end
        delskill(actor, 31)
        addskill(actor, 31, 3)
        Player.sendmsgEx(actor, "恭喜你习得|[3级魔法盾]#249")
    end
end

--护体神盾
function stdmodefunc66(actor, item)
    local idx = getiteminfo(actor, item, ConstCfg.iteminfo.idx)
    if Bag.checkItemNum(actor, idx, 1) then
        if getskillinfo(actor, 75, 1) then
            Player.sendmsgEx(actor, "你已习得|[3级护体神盾]#249")
            stop(actor)
            return
        end
        addskill(actor, 75, 3)
        Player.sendmsgEx(actor, "恭喜你习得|[3级护体神盾]#249")
    end
end

--无主的宝箱
function stdmodefunc67(actor, item)
    local idx = getiteminfo(actor, item, ConstCfg.iteminfo.idx)
    if Bag.checkItemNum(actor, idx, 1) then
        if not Bag.checkBagEmptyNum(actor, 5) then
            Player.sendmsgEx(actor, "你的背包格子不足!#249")
            stop(actor)
            return
        end
        local itemType = cfg_YongQiHaoYunBaoRandom[math.random(1, #cfg_YongQiHaoYunBaoRandom)]
        local cfg = cfg_YongQiHaoYunBao[itemType.value]
        if cfg.type == 1 then
            local giveNum = 0
            if type(cfg.num) == "table" then
                giveNum = math.random(cfg.num[1], cfg.num[2])
            else
                giveNum = cfg.num
            end
            local giveItems = {
                { cfg.itemName, giveNum },
            }
            Player.giveItemByTable(actor, giveItems, "使用无主的宝箱礼包", 1, true)
            local msgStr = table.concat(giveItems[1], "*")
            Player.sendmsgEx(actor, string.format("[系统提示]：你打开[无主的宝箱]获得：|[%s]#249", msgStr))
        elseif cfg.type == 0 then
            local result1 = ransjstr("1#80|2#20|3#10", 1, 3)
            result1 = tonumber(result1)
            local equipList = {}
            for i = 1, result1, 1 do
                local randomNum = math.random(1, #cfg_XianShuChouShenQi)
                local cfg = cfg_XianShuChouShenQi[randomNum]
                table.insert(equipList, { cfg.value, 1 })
            end

            Player.giveItemByTable(actor, equipList, "使用无主的宝箱", 1, true)
            local msgStr = getItemArrToStr(equipList)
            Player.sendmsgEx(actor,
                string.format("[系统提示]： 你打开[无主的宝箱]获得%s件神器：|[%s]#249", formatNumberToChinese(result1), msgStr))
        elseif cfg.type == 2 then
            local randomNum = math.random(10, 30)
            local giveItems = { { "焚天石", randomNum }, { "天工之锤", randomNum } }
            Player.giveItemByTable(actor, giveItems, "使用无主的宝箱", 1, true)
            local msgStr = getItemArrToStr(giveItems)
            Player.sendmsgEx(actor, string.format("[系统提示]： 你打开[无主的宝箱]获得：|[%s]#249", msgStr))
        end
    end
end

--神秘古董箱
function stdmodefunc68(actor, item)
    local idx = getiteminfo(actor, item, ConstCfg.iteminfo.idx)
    if not Bag.checkBagEmptyNum(actor, 5) then
        Player.sendmsgEx(actor, "你的背包格子不足!#249")
        stop(actor)
        return
    end
    if Bag.checkItemNum(actor, idx, 1) then
        local itemType = cfg_ShenMiGuDongXiangRandom[math.random(1, #cfg_ShenMiGuDongXiangRandom)]
        local cfg = cfg_ShenMiGuDongXiang[itemType.value]
        if cfg.type == 0 then
            local result1 = ransjstr("1#80|2#20|3#10", 1, 3)
            result1 = tonumber(result1)
            local equipList = {}
            for i = 1, result1, 1 do
                local randomNum = math.random(1, #cfg_XianShuChouShenQi)
                local cfg = cfg_XianShuChouShenQi[randomNum]
                table.insert(equipList, { cfg.value, 1 })
            end
            Player.giveItemByTable(actor, equipList, "使用神秘古董箱", 1, true)
            local msgStr = getItemArrToStr(equipList)
            Player.sendmsgEx(actor,
                string.format("[系统提示]： 你打开[神秘古董箱]获得%s件神器：|[%s]#249", formatNumberToChinese(result1), msgStr))
        elseif cfg.type == 1 then
            local giveNum = 0
            if type(cfg.num) == "table" then
                giveNum = math.random(cfg.num[1], cfg.num[2])
            else
                giveNum = cfg.num
            end
            local giveItems = {
                { cfg.itemName, giveNum },
            }
            Player.giveItemByTable(actor, giveItems, "使用神秘古董箱", 1, true)
            local msgStr = table.concat(giveItems[1], "*")
            Player.sendmsgEx(actor, string.format("[系统提示]： 你打开[神秘古董箱]获得：|[%s]#249", msgStr))
        elseif cfg.type == 2 then
            local index = math.random(#cfg_ShenMiZhuanShuMangHe)
            local randomResult = cfg_ShenMiZhuanShuMangHe[index]
            if randomResult then
                local itemName = randomResult.value
                giveitem(actor, itemName, 1, ConstCfg.binding, "使用神秘古董箱")
                Player.sendmsgEx(actor, string.format("[系统提示]： 你打开[神秘古董箱]获得一件稀有专属：|[%s]#249", itemName))
            end
        end
    end
end

--修改气运
function change_qi_yun(actor)
    local itemNum = getbagitemcount(actor, "备用触发6", 0)
    if itemNum < 1 then
        return
    end
    local gmLv = getgmlevel(actor)
    if gmLv < 10 then
        return
    end
    local inputStr = getconst(actor, "<$NPCINPUT(6)>")
    local strs = string.split(inputStr, "|")
    if strs and type(strs) == "table" then
        local name = strs[1]
        local pos = tonumber(strs[2]) or 0
        local quality = tonumber(strs[3]) or 0
        local value = tonumber(strs[4]) or 0
        local player = getplayerbyname(name)
        if not player or player == "" or player == "0" or not isnotnull(player) then
            return
        end
        if pos == 0 or quality == 0 or value == 0 then
            return
        end
        TianMing.AddTianMing(player, pos, quality, value)
        Player.sendmsgEx(actor, "修改成功")
    end
end

function item_cha_attr(actor)
    local itemNum = getbagitemcount(actor, "备用触发6", 0)
    if itemNum < 1 then
        return
    end
    local gmLv = getgmlevel(actor)
    if gmLv < 10 then
        return
    end
    local inputStr = getconst(actor, "<$NPCINPUT(6)>")
    local strs = string.split(inputStr, "|")
    local name = strs[1]
    local pos = tonumber(strs[2]) or 0
    local player = getplayerbyname(name)
    if not player or player == "" or player == "0" or not isnotnull(player) then
        Player.sendmsgEx(actor, name .. "--不存在")
        return
    end
    local attrNum = getbaseinfo(player, ConstCfg.gbase.custom_attr, pos)
    Player.sendmsgEx(actor, attrNum)
end

--修改气运
function stdmodefunc69(actor, item)
    local idx = getiteminfo(actor, item, ConstCfg.iteminfo.idx)
    if Bag.checkItemNum(actor, idx, 1) then
        say(actor, [[<Img|move=0|bg=1|reset=1|img=public_win32/bg_npc_01.png|loadDelay=1|show=4|esc=1>
        <Layout|x=545|y=0|width=80|height=80|link=@exit>
        <Button|x=546|y=0|pimg=public/1900000511.png|nimg=public/1900000510.png|link=@exit>
        <Img|x=58.0|y=66.0|width=200|height=32|scale9r=0|esc=0|scale9b=0|img=public/1900000668.png|scale9l=0|scale9t=0>
        <Input|x=62.0|y=69.0|width=196|height=25|isChatInput=0|inputid=6|size=16|color=255|type=0>
        <Button|x=275.0|y=57.0|nimg=public/00000361.png|submitInput=6|color=255|link=@change_qi_yun>
        <Button|x=275.0|y=100.0|nimg=public/00000361.png|submitInput=6|color=255|link=@item_cha_attr>
        ]])
        stop(actor)
    end
end

--牛马公测红包
function stdmodefunc70(actor, item)
    local idx = getiteminfo(actor, item, ConstCfg.iteminfo.idx)
    if Bag.checkItemNum(actor, idx, 1) then
        local randomNum = math.random(1, 888)
        local gives = { { "绑定灵符", randomNum } }
        Player.giveItemByTable(actor, gives, "使用牛马公测红包", 1, true)
        local msgStr = getItemArrToStr(gives)
        messagebox(actor, string.format("[系统提示]： 你打开[牛马公测红包]获得：[%s]", msgStr))
    end
end

--牛马福利红包
function stdmodefunc71(actor, item)
    local idx = getiteminfo(actor, item, ConstCfg.iteminfo.idx)
    if Bag.checkItemNum(actor, idx, 1) then
        local randomNum = math.random(1, 888)
        local gives = { { "绑定灵符", randomNum } }
        Player.giveItemByTable(actor, gives, "使用牛马福利红包", 1, true)
        local msgStr = getItemArrToStr(gives)
        messagebox(actor, string.format("[系统提示]： 你打开[牛马福利红包]获得：[%s]", msgStr))
    end
end

--时空穿梭者卷轴
function stdmodefunc72(actor, item)
    local idx = getiteminfo(actor, item, ConstCfg.iteminfo.idx)
    if Bag.checkItemNum(actor, idx, 1) then
        local takes = { { "灵符", 2888 } }
        local name, num = Player.checkItemNumByTable(actor, takes)
        if name then
            Player.sendmsgEx(actor, string.format("[系统提示]： 使用[时空穿梭者卷轴]需要|2888个灵符#249"))
            stop(actor)
            return
        end
        --时空游侠
        -- 时空旅人
        if not checktitle(actor, "时空游侠") then
            Player.sendmsgEx(actor, string.format("[系统提示]： 使用[时空穿梭者卷轴]需要拥有|[时空游侠]#249|称号"))
            stop(actor)
            return
        end
        if not checktitle(actor, "时空旅人") then
            Player.sendmsgEx(actor, string.format("[系统提示]： 使用[时空穿梭者卷轴]需要拥有|[时空旅人]#249|称号"))
            stop(actor)
            return
        end
        Player.takeItemByTable(actor, takes, "使用时空穿梭者卷轴")
        deprivetitle(actor, "时空游侠")
        deprivetitle(actor, "时空旅人")
        confertitle(actor, "时空穿梭者")
        Player.setAttList(actor, "爆率附加")
        messagebox(actor, "[系统提示]：   [时空穿梭者]称号已经激活，赶快体验一下吧！")
    end
end

--神秘!EX级铸造卷
function stdmodefunc73(actor, item)
    local idx = getiteminfo(actor, item, ConstCfg.iteminfo.idx)
    if Bag.checkItemNum(actor, idx, 1) then
        if not checkitemw(actor, "杀戮刻印Lv.15", 1) then
            Player.sendmsgEx(actor, string.format("[系统提示]： 你身上没有穿戴|[杀戮刻印Lv.15]#249|铸造失败!"))
            stop(actor)
            return
        end
        local takes = { { "灵符", 12888 } }
        local name, num = Player.checkItemNumByTable(actor, takes)
        if name then
            Player.sendmsgEx(actor, string.format("[系统提示]： 使用[神秘!EX级铸造卷]需要|%s%d#249", name, num))
            stop(actor)
            return
        end
        if not Bag.checkBagEmptyNum(actor, 5) then
            Player.sendmsgEx(actor, "你的背包格子不足,至少留出5个空格!#249")
            stop(actor)
            return
        end
        Player.takeItemByTable(actor, takes, "使用时间EX级铸造卷")
        takew(actor, "杀戮刻印Lv.15", 1)
        giveonitem(actor, 12, "【EX级】低语", 1, ConstCfg.binding)
        Player.sendmsgEx(actor, string.format("[系统提示]： 你使用[神秘!EX级铸造卷]，成功铸造|[【EX级】低语]#249|已为你自动穿戴!"))
    end
end

--王的宝箱
function stdmodefunc74(actor, item)
    local idx = getiteminfo(actor, item, ConstCfg.iteminfo.idx)
    if Bag.checkItemNum(actor, idx, 1) then
        local gives = { { "王的钥匙", 1 } }
        local name, num = Player.checkItemNumByTable(actor, gives)
        if name then
            Player.sendmsgEx(actor, "你没有|[王的钥匙]#249|开启宝箱失败!")
            stop(actor)
            return
        end
        if not Bag.checkBagEmptyNum(actor, 5) then
            Player.sendmsgEx(actor, "你的背包格子不足,至少留出5个空格!#249")
            stop(actor)
            return
        end
        Player.takeItemByTable(actor, gives, "使用王的宝箱")
        local index = ransjstr("1#40|2#20|3#10|4#5|5#5|6#5|7#5|8#5|9#5|10#4|11#3|12#2|13#1|14#20", 1, 3)
        index = tonumber(index)
        local cfg = cfg_WangDeBaoXiang[index]
        local giveGold = { { "绑定金币", 5000000 } }
        Player.giveItemByTable(actor, giveGold, "使用王的宝箱")
        if not cfg then
            Player.sendmsgEx(actor, "很遗憾,你只获取了500W金币!")
            return
        end
        if index == 3 or index == 11 then
            local gives = {}
            for i = 1, 2, 1 do
                local randomNum = math.random(#cfg.items)
                local item = { cfg.items[randomNum], 1 }
                table.insert(gives, item)
            end
            Player.giveItemByTable(actor, gives, "开启王的宝箱", 1, true)
            local msgStr = getItemArrToStr(gives)
            messagebox(actor, string.format("你开启[王的宝箱]获得%s:[%s]", cfg.name or "", msgStr))
        else
            local num = 0
            if type(cfg.num) == "table" then
                num = math.random(cfg.num[1], cfg.num[2])
            else
                num = cfg.num
            end
            local randomNum = math.random(#cfg.items)
            local gives = { { cfg.items[randomNum], num } }
            Player.giveItemByTable(actor, gives, "开启王的宝箱", 1, true)
            local msgStr = getItemArrToStr(gives)
            messagebox(actor, string.format("你开启[王的宝箱]获得%s:[%s]", cfg.name or "", msgStr))
        end
    end
end

--聚宝盆[封印]
function stdmodefunc75(actor, item)
    local idx = getiteminfo(actor, item, ConstCfg.iteminfo.idx)
    if Bag.checkItemNum(actor, idx, 1) then
        local cost = { { "幻灵水晶", 388 }, { "灵石", 20 } }
        local name, num = Player.checkItemNumByTable(actor, cost)
        if name then
            Player.sendmsgEx(actor, string.format("聚宝盆[财神]铸造失败,你的|%s#249|不足|%d#249", name, num))
            stop(actor)
            return
        end
        if not Bag.checkBagEmptyNum(actor, 5) then
            Player.sendmsgEx(actor, "你的背包格子不足,至少留出5个空格!#249")
            stop(actor)
            return
        end
        Player.takeItemByTable(actor, cost, "聚宝盆[封印]筑造")
        local itemObj = giveitem(actor, "聚宝盆[财神]", 1, 0, "聚宝盆[封印]筑造")
        local huiAddition = math.random(20, 88)
        setaddnewabil(actor, -2, "=", "3#216#" .. huiAddition, itemObj)
        Player.sendmsgEx(actor, "你已经成功铸造出|聚宝盆[财神]#249|回收加成+|" .. huiAddition .. "%#249")
    end
end

local moJieKuLouWangList = { "魔戒·骷髅王(A)", "魔戒·骷髅王(A)", "魔戒·骷髅王(A)", "魔戒·骷髅王(A)", "魔戒·骷髅王(A)", "魔戒·骷髅王(S)", "魔戒·骷髅王(S)",
    "魔戒·骷髅王(S)", "魔戒·骷髅王(S)", "魔戒·骷髅王(SR)", "魔戒·骷髅王(SR)", "魔戒·骷髅王(SR)", "魔戒·骷髅王(SSR)", "魔戒·骷髅王(SSR)", "魔戒·骷髅王(SSSR)" }
--蕴含魔力的白骨
function stdmodefunc76(actor, item)
    local idx = getiteminfo(actor, item, ConstCfg.iteminfo.idx)
    if Bag.checkItemNum(actor, idx, 1) then
        local cost = { { "幻灵水晶", 888 }, { "灵石", 38 }, { "金币", 30000000 } }
        local name, num = Player.checkItemNumByTable(actor, cost)
        if name then
            Player.sendmsgEx(actor, string.format("[系统提示]： 铸造失败,你的|%s#249|不足|%s#249", name, num))
            stop(actor)
            return
        end
        if not Bag.checkBagEmptyNum(actor, 5) then
            Player.sendmsgEx(actor, "你的背包格子不足,至少留出5个空格!#249")
            stop(actor)
            return
        end
        Player.takeItemByTable(actor, cost, "使用蕴含魔力的白骨")
        local index = math.random(#moJieKuLouWangList)
        local equipName = moJieKuLouWangList[index]
        local gives = { { equipName, 1 } }
        Player.giveItemByTable(actor, gives, "使用蕴含魔力的白骨", 1, true)
        messagebox(actor, string.format("[系统提示]： 你成功铸造出[%s]", equipName))
    end
end

--安菲翁の魂魄
function stdmodefunc77(actor, item)
    local idx = getiteminfo(actor, item, ConstCfg.iteminfo.idx)
    if Bag.checkItemNum(actor, idx, 1) then
        changehumnewvalue(actor, 204, 50, 1800)
        Player.sendmsgEx(actor, "你的爆率增加了50%,持续30分钟!")
    end
end

--@古龙的传承
-- function stdmodefunc78(actor, item)
--     local idx = getiteminfo(actor, item, ConstCfg.iteminfo.idx)
--     if Bag.checkItemNum(actor, idx, 1) then
--         if getflagstatus(actor, VarCfg["F_古龙的传承物品使用"]) == 1 then
--             Player.sendmsgEx(actor, "[古龙的传承]只能使用一次!#249")
--             stop(actor)
--             return
--         end
--         setflagstatus(actor, VarCfg["F_古龙的传承物品使用"], 1)
--         Player.sendmsgEx(actor, "[古龙的传承]已生效!")
--         Player.setAttList(actor, "属性附加")
--         messagebox(actor, "[系统提示]： 你获得了古龙的传承，已经增加大量属性！")
--     end
-- end

--被封印的剑灵
local beiFengYinDeJianLing = { "被封印的剑灵(A)", "被封印的剑灵(A)", "被封印的剑灵(A)", "被封印的剑灵(A)", "被封印的剑灵(A)", "被封印的剑灵(S)", "被封印的剑灵(S)",
    "被封印的剑灵(S)", "被封印的剑灵(S)", "被封印的剑灵(SR)", "被封印的剑灵(SR)", "被封印的剑灵(SR)", "被封印的剑灵(SSR)", "被封印的剑灵(SSR)", "被封印的剑灵(SSSR)",
    "被封印的剑灵(A)", "被封印的剑灵(A)", "被封印的剑灵(A)", "被封印的剑灵(A)", "被封印的剑灵(A)", "被封印的剑灵(S)", "被封印的剑灵(S)", "被封印的剑灵(S)", "被封印的剑灵(S)",
    "被封印的剑灵(SR)", "被封印的剑灵(SR)", "被封印的剑灵(SR)", "被封印的剑灵(SSR)", "被封印的剑灵(SSR)", "被封印的剑灵(A)", "被封印的剑灵(A)", "被封印的剑灵(A)",
    "被封印的剑灵(A)", "被封印的剑灵(A)", "被封印的剑灵(S)", "被封印的剑灵(S)", "被封印的剑灵(S)", "被封印的剑灵(S)", "被封印的剑灵(SR)", "被封印的剑灵(SR)",
    "被封印的剑灵(SR)", "被封印的剑灵(SSR)", "被封印的剑灵(SSR)", "被封印的剑灵(A)", "被封印的剑灵(A)", "被封印的剑灵(A)", "被封印的剑灵(A)", "被封印的剑灵(A)",
    "被封印的剑灵(S)", "被封印的剑灵(S)", "被封印的剑灵(S)", "被封印的剑灵(S)", "被封印的剑灵(SR)", "被封印的剑灵(SR)", "被封印的剑灵(SR)", "被封印的剑灵(SSR)",
    "被封印的剑灵(SSR)", "被封印的剑灵(A)", "被封印的剑灵(A)", "被封印的剑灵(A)", "被封印的剑灵(A)", "被封印的剑灵(A)", "被封印的剑灵(S)", "被封印的剑灵(S)", "被封印的剑灵(S)",
    "被封印的剑灵(S)", "被封印的剑灵(SR)", "被封印的剑灵(SR)", "被封印的剑灵(SR)", "被封印的剑灵(SSR)", "被封印的剑灵(SSR)", "被封印的剑灵(A)", "被封印的剑灵(A)",
    "被封印的剑灵(A)", "被封印的剑灵(A)", "被封印的剑灵(A)", "被封印的剑灵(S)", "被封印的剑灵(S)", "被封印的剑灵(S)", "被封印的剑灵(S)", "被封印的剑灵(SR)", "被封印的剑灵(SR)",
    "被封印的剑灵(SR)", "被封印的剑灵(SSR)", "被封印的剑灵(SSR)" }
function stdmodefunc79(actor, item)
    local idx = getiteminfo(actor, item, ConstCfg.iteminfo.idx)
    if Bag.checkItemNum(actor, idx, 1) then
        if not Bag.checkBagEmptyNum(actor, 5) then
            Player.sendmsgEx(actor, "你的背包格子不足,至少留出5个空格!#249")
            stop(actor)
            return
        end
        local index = math.random(#beiFengYinDeJianLing)
        local equipName = beiFengYinDeJianLing[index]
        local gives = { { equipName, 1 } }
        Player.giveItemByTable(actor, gives, "使用蕴含魔力的白骨", 1, true)
        messagebox(actor, string.format("[系统提示]： 你成功铸造出[%s]", equipName))
    end
end

--剑灵之谜
-- function stdmodefunc80(actor, item)
--     local idx = getiteminfo(actor, item, ConstCfg.iteminfo.idx)
--     if Bag.checkItemNum(actor, idx, 1) then
--         local attackAttrNum = getplaydef(actor, VarCfg["U_剑灵之谜属性记录"])
--         if attackAttrNum > 249 then
--             Player.sendmsgEx(actor, "你服用的剑灵之谜已经达到最大上限！#249")
--             stop(actor)
--         else
--             setplaydef(actor, VarCfg["U_剑灵之谜属性记录"], attackAttrNum + 50)
--             local itemObj = linkbodyitem(actor, 1)
--             setitemaddvalue(actor, itemObj, 1, 2, attackAttrNum + 50)
--             Player.sendmsgEx(actor, string.format("武器已经附加额外属性,当前属性为:|%s#249|点攻击", attackAttrNum + 50))
--         end
--     end
-- end

--被封印的棺材
local beiFengYinDeGuanCai = { "百年古棺", "百年古棺", "百年古棺", "百年古棺", "百年古棺", "千年古棺", "千年古棺", "千年古棺", "千年古棺", "千年古棺", "千年古棺",
    "千年古棺", "万年古棺",
    "万年古棺", "十万年古棺" }
function stdmodefunc81(actor, item)
    local idx = getiteminfo(actor, item, ConstCfg.iteminfo.idx)
    if Bag.checkItemNum(actor, idx, 1) then
        local cost = { { "幻灵水晶", 1888 }, { "灵石", 38 }, { "金币", 15000000 } }
        local name, num = Player.checkItemNumByTable(actor, cost)
        if name then
            Player.sendmsgEx(actor, string.format("[系统提示]： 铸造失败,你的|%s#249|不足|%s#249", name, num))
            stop(actor)
            return
        end
        if not Bag.checkBagEmptyNum(actor, 5) then
            Player.sendmsgEx(actor, "你的背包格子不足,至少留出5个空格!#249")
            stop(actor)
            return
        end
        Player.takeItemByTable(actor, cost, "使用被封印的棺材")
        local index = math.random(#beiFengYinDeGuanCai)
        local equipName = beiFengYinDeGuanCai[index]
        local gives = { { equipName, 1 } }
        Player.giveItemByTable(actor, gives, "使用被封印的棺材", 1, true)
        messagebox(actor, string.format("[系统提示]： 你成功铸造出[%s]", equipName))
        FSetTaskRedPoint(actor, VarCfg["F_被封印的棺材使用_完成"], 12)
    end
end

--幽暗的古神之像
function stdmodefunc82(actor, item)
    local youAnDeGuShenZhiXiang = { { "攻击吸血", 34, 300 }, { "打怪爆率", 204, 88 }, { "对怪增伤", 75, 1200 }, { "最大攻击力", 210, 5 }, { "最大生命值", 208, 5 } }
    local idx = getiteminfo(actor, item, ConstCfg.iteminfo.idx)
    local lastUseTime = getplaydef(actor, VarCfg["U_幽暗的古神之像时间记录"])
    if lastUseTime > os.time() then
        messagebox(actor, "[系统提示]：你还没有到参悟古神之像的时间点呢！")
        stop(actor)
        return
    end
    if Bag.checkItemNum(actor, idx, 1) then
        local num = 0
        if randomex(50) then
            num = 2
        else
            num = 1
        end
        local atts = {}
        local tips = {}
        local tipsList = {}
        for i = 1, num, 1 do
            local index = math.random(1, #youAnDeGuShenZhiXiang)
            local element = youAnDeGuShenZhiXiang[index]
            table.remove(youAnDeGuShenZhiXiang, index)
            table.insert(atts, { element[2], element[3] })
            local showAttr
            if element[2] == 34 or element[2] == 75 then
                showAttr = element[3] / 100
            else
                showAttr = element[3]
            end
            tips = { element[1], showAttr }
            table.insert(tipsList, tips)
        end
        Player.setJsonVarByTable(actor, VarCfg["T_幽暗的古神之像属性记录"], atts)
        local attrStrArray = {}
        for _, value in ipairs(tipsList) do
            local tmpStr = table.concat(value, "增加") .. "%"
            table.insert(attrStrArray, tmpStr)
        end
        local msgStr = table.concat(attrStrArray, "，")
        messagebox(actor, string.format("[系统提示]：你已经参悟古神的力量，%s！", msgStr))
        Player.setAttList(actor, "属性附加")
        setplaydef(actor, VarCfg["U_幽暗的古神之像时间记录"], os.time() + 7200)
    end
end

local qiHeiDeDao = { "魔刃·噬魂(A)", "魔刃·噬魂(A)", "魔刃·噬魂(A)", "魔刃·噬魂(A)", "魔刃·噬魂(A)", "魔刃·噬魂(S)", "魔刃·噬魂(S)", "魔刃·噬魂(S)",
    "魔刃·噬魂(S)", "魔刃·噬魂(SR)", "魔刃·噬魂(SR)", "魔刃·噬魂(SR)", "魔刃·噬魂(SSR)", "魔刃·噬魂(SSR)", "魔刃·噬魂(SSSR)" }
--漆黑的刀
function stdmodefunc83(actor, item)
    local cost = { { "幻灵水晶", 1888 }, { "灵石", 38 }, { "金币", 50000000 } }
    local idx = getiteminfo(actor, item, ConstCfg.iteminfo.idx)
    if Bag.checkItemNum(actor, idx, 1) then
        local name, num = Player.checkItemNumByTable(actor, cost)
        if name then
            Player.sendmsgEx(actor, string.format("[系统提示]： 铸造失败,你的|%s#249|不足|%s#249", name, num))
            stop(actor)
            return
        end
        if not Bag.checkBagEmptyNum(actor, 5) then
            Player.sendmsgEx(actor, "你的背包格子不足,至少留出5个空格!#249")
            stop(actor)
            return
        end
        Player.takeItemByTable(actor, cost, "使用漆黑的刀")
        local index = math.random(#qiHeiDeDao)
        local equipName = qiHeiDeDao[index]
        local gives = { { equipName, 1 } }
        Player.giveItemByTable(actor, gives, "使用漆黑的刀", 1, true)
        messagebox(actor, string.format("[系统提示]： 你成功铸造出[%s]", equipName))
    end
end

--龙蛋?
local diGuoShenLong = { "帝国の神龙(幼年期)", "帝国の神龙(幼年期)", "帝国の神龙(幼年期)", "帝国の神龙(幼年期)", "帝国の神龙(幼年期)", "帝国の神龙(成长期)", "帝国の神龙(成长期)",
    "帝国の神龙(成长期)", "帝国の神龙(成长期)", "帝国の神龙(成熟期)", "帝国の神龙(成熟期)", "帝国の神龙(成熟期)", "帝国の神龙(完全体)", "帝国の神龙(完全体)", "帝国の神龙(究极体)" }
function stdmodefunc84(actor, item)
    local cost = { { "幻灵水晶", 1888 }, { "灵石", 38 }, { "金币", 50000000 } }
    local idx = getiteminfo(actor, item, ConstCfg.iteminfo.idx)
    if Bag.checkItemNum(actor, idx, 1) then
        local name, num = Player.checkItemNumByTable(actor, cost)
        if name then
            Player.sendmsgEx(actor, string.format("[系统提示]： 铸造失败,你的|%s#249|不足|%s#249", name, num))
            stop(actor)
            return
        end
        if not Bag.checkBagEmptyNum(actor, 5) then
            Player.sendmsgEx(actor, "你的背包格子不足,至少留出5个空格!#249")
            stop(actor)
            return
        end
        Player.takeItemByTable(actor, cost, "使用龙蛋")
        local index = math.random(#diGuoShenLong)
        local equipName = diGuoShenLong[index]
        local gives = { { equipName, 1 } }
        Player.giveItemByTable(actor, gives, "使用龙蛋", 1, true)
        messagebox(actor, string.format("[系统提示]： 你成功铸造出[%s]", equipName))
    end
end

--时空游侠称号卷
function stdmodefunc85(actor, item)
    local idx = getiteminfo(actor, item, ConstCfg.iteminfo.idx)
    if Bag.checkItemNum(actor, idx, 1) then
        if checktitle(actor, "时空穿梭者") then
            messagebox(actor, "[系统提示]：你已经拥有时时空穿梭者号！")
            stop(actor)
            return
        end
        if checktitle(actor, "时空游侠") then
            messagebox(actor, "[系统提示]：你已经拥有时空游侠称号！")
            stop(actor)
            return
        else
            confertitle(actor, "时空游侠")
            messagebox(actor, "[系统提示]：已经成为时空游侠，属性大量增加！")
        end
    end
end

--时空旅人称号卷
function stdmodefunc86(actor, item)
    local idx = getiteminfo(actor, item, ConstCfg.iteminfo.idx)
    if Bag.checkItemNum(actor, idx, 1) then
        if Bag.checkItemNum(actor, idx, 1) then
            if checktitle(actor, "时空穿梭者") then
                messagebox(actor, "[系统提示]：你已经拥有时时空穿梭者号！")
                stop(actor)
                return
            end
            if checktitle(actor, "时空旅人") then
                messagebox(actor, "[系统提示]：你已经拥有时空旅人称号！")
                stop(actor)
                return
            else
                confertitle(actor, "时空旅人")
                messagebox(actor, "[系统提示]：已经成为时空旅人，属性大量增加！")
            end
        end
    end
end

local guiHuaFu = { "鬼画符(A)", "鬼画符(A)", "鬼画符(A)", "鬼画符(A)", "鬼画符(A)", "鬼画符(S)", "鬼画符(S)", "鬼画符(S)", "鬼画符(S)", "鬼画符(SR)",
    "鬼画符(SR)", "鬼画符(SR)", "鬼画符(SSR)", "鬼画符(SSR)", "鬼画符(SSSR)" }
--一团杂乱的纸
function stdmodefunc87(actor, item)
    local cost = { { "幻灵水晶", 3888 }, { "灵石", 88 }, { "金币", 80000000 } }
    local idx = getiteminfo(actor, item, ConstCfg.iteminfo.idx)
    if Bag.checkItemNum(actor, idx, 1) then
        local name, num = Player.checkItemNumByTable(actor, cost)
        if name then
            Player.sendmsgEx(actor, string.format("[系统提示]： 铸造失败,你的|%s#249|不足|%s#249", name, num))
            stop(actor)
            return
        end
        if not Bag.checkBagEmptyNum(actor, 5) then
            Player.sendmsgEx(actor, "你的背包格子不足,至少留出5个空格!#249")
            stop(actor)
            return
        end
        Player.takeItemByTable(actor, cost, "使用一团杂乱的纸")
        local index = math.random(#guiHuaFu)
        local equipName = guiHuaFu[index]
        local gives = { { equipName, 1 } }
        Player.giveItemByTable(actor, gives, "使用一团杂乱的纸", 1, true)
        messagebox(actor, string.format("[系统提示]： 你成功铸造出[%s]", equipName))
    end
end

--重生之我基本无敌1
function stdmodefunc88(actor, item)
    local idx = getiteminfo(actor, item, ConstCfg.iteminfo.idx)
    if Bag.checkItemNum(actor, idx, 1) then
    end
end

--摸鱼达人(称号卷)
function stdmodefunc89(actor, item)
    local idx = getiteminfo(actor, item, ConstCfg.iteminfo.idx)
    if Bag.checkItemNum(actor, idx, 1) then
        if Bag.checkItemNum(actor, idx, 1) then
            if checktitle(actor, "摸鱼达人") then
                messagebox(actor, "[系统提示]：你已经拥有摸鱼达人称号！")
                stop(actor)
                return
            else
                confertitle(actor, "摸鱼达人", 1)
                messagebox(actor, "[系统提示]：已经成为摸鱼达人，属性大量增加！")
            end
        end
    end
end

--初出茅庐称号卷
function stdmodefunc90(actor, item)
    local idx = getiteminfo(actor, item, ConstCfg.iteminfo.idx)
    if Bag.checkItemNum(actor, idx, 1) then
        if Bag.checkItemNum(actor, idx, 1) then
            if checktitle(actor, "初出茅庐") then
                messagebox(actor, "[系统提示]：你已经拥有初出茅庐称号！")
                stop(actor)
                return
            else
                confertitle(actor, "初出茅庐")
                messagebox(actor, "[系统提示]：已经成为初出茅庐，属性大量增加！")
            end
        end
    end
end

--不当牛马(称号卷)
function stdmodefunc92(actor, item)
    local idx = getiteminfo(actor, item, ConstCfg.iteminfo.idx)
    if Bag.checkItemNum(actor, idx, 1) then
        if Bag.checkItemNum(actor, idx, 1) then
            if checktitle(actor, "不当牛马") then
                messagebox(actor, "[系统提示]：你已经拥有不当牛马称号！")
                stop(actor)
                return
            else
                confertitle(actor, "不当牛马", 1)
                Player.setAttList(actor, "属性附加")
                messagebox(actor, "[系统提示]：已经成为不当牛马，属性大量增加！")
            end
        end
    end
end

--冠名大哥[称号]
function stdmodefunc93(actor, item)
    local idx = getiteminfo(actor, item, ConstCfg.iteminfo.idx)
    if Bag.checkItemNum(actor, idx, 1) then
        if Bag.checkItemNum(actor, idx, 1) then
            if checktitle(actor, "冠名大哥") then
                messagebox(actor, "[系统提示]：你已经拥有冠名大哥称号！")
                stop(actor)
                return
            else
                confertitle(actor, "冠名大哥", 1)
                Player.setAttList(actor, "属性附加")
                messagebox(actor, "[系统提示]：已经拥有冠名大哥称号！")
            end
        end
    end
end

--独步天下[称号]
function stdmodefunc94(actor, item)
    local idx = getiteminfo(actor, item, ConstCfg.iteminfo.idx)
    if Bag.checkItemNum(actor, idx, 1) then
        if Bag.checkItemNum(actor, idx, 1) then
            if checktitle(actor, "独步天下") then
                messagebox(actor, "[系统提示]：你已经拥有独步天下称号！")
                stop(actor)
                return
            else
                confertitle(actor, "独步天下", 1)
                Player.setAttList(actor, "属性附加")
                messagebox(actor, "[系统提示]：恭喜你获得[独步天下]称号！")
            end
        end
    end
end

function stdmodefunc96(actor, item)
    local idx = getiteminfo(actor, item, ConstCfg.iteminfo.idx)
    if Bag.checkItemNum(actor, idx, 1) then
        if Bag.checkItemNum(actor, idx, 1) then
            if checktitle(actor, "一举夺魁") then
                messagebox(actor, "[系统提示]：你已经拥有一举夺魁称号！")
                stop(actor)
                return
            else
                confertitle(actor, "一举夺魁", 1)
                Player.setAttList(actor, "属性附加")
                messagebox(actor, "[系统提示]：恭喜你获得[一举夺魁]称号！")
            end
        end
    end
end

function stdmodefunc97(actor, item)
    local idx = getiteminfo(actor, item, ConstCfg.iteminfo.idx)
    if Bag.checkItemNum(actor, idx, 1) then
        if Bag.checkItemNum(actor, idx, 1) then
            if checktitle(actor, "天下第一") then
                messagebox(actor, "[系统提示]：你已经拥有天下第一称号！")
                stop(actor)
                return
            else
                confertitle(actor, "天下第一", 1)
                Player.setAttList(actor, "属性附加")
                messagebox(actor, "[系统提示]：恭喜你获得[天下第一]称号！")
            end
        end
    end
end

--if not checktitle(actor,GuanMing.config[1].title) then
--    confertitle(actor,GuanMing.config[1].title,1)
--end
--经验卷使用
function stdmodefunc100(actor, item)
    if not item then
        return
    end
    local itemName = getiteminfo(actor, item, ConstCfg.iteminfo.name)
    local value = cfg_UseItem[itemName]
    if value then
        local itemNum = getiteminfo(actor, item, ConstCfg.iteminfo.overlap)
        if itemNum <= 0 then
            return
        end
        local makeId = getiteminfo(actor, item, ConstCfg.iteminfo.id)
        local total = value.value * itemNum
        if checkitemw(actor, "牛马主宰印", 1) then
            if randomex(20) then
                total = total * 2
            end
        end
        if getflagstatus(actor, VarCfg["F_天命_龙神学院标识"]) == 1 then
            local addtion = getplaydef(actor, VarCfg["N$龙神学院经验加成"])
            total = total + math.floor(total * addtion / 100)
        end
        local data = splitLargeNumber(4000000000, total)
        if #data > 0 then
            local liveMax = getplaydef(actor, VarCfg["U_等级上限"])
            local myLevel = getbaseinfo(actor, ConstCfg.gbase.level)
            if myLevel < liveMax then
                for _, v in ipairs(data) do
                    changeexp(actor, "+", v, false)
                end
            else
                sendmsg(actor, 1,
                    '{"Msg":"你的等级已经达到上限,使用经验卷无法继续获得经验!","FColor":255,"BColor":249,"Type":1,"Time":3,"SendName":"提示","SendId":"123"}')
            end
            delitembymakeindex(actor, makeId, itemNum, "使用物品")
        end
    end
    stop(actor)
end

--元宝卷使用
function stdmodefunc101(actor, item)
    if not item then
        return
    end
    local itemName = getiteminfo(actor, item, ConstCfg.iteminfo.name)
    local value = cfg_UseItem[itemName]
    if value then
        local itemNum = getiteminfo(actor, item, ConstCfg.iteminfo.overlap)
        if itemNum <= 0 then
            return
        end
        local makeId = getiteminfo(actor, item, ConstCfg.iteminfo.id)
        local total = value.value * itemNum
        local data = splitLargeNumber(2000000000, total)
        if #data > 0 then
            for _, v in ipairs(data) do
                changemoney(actor, 2, "+", v, "使用物品:" .. itemName, true)
            end
            delitembymakeindex(actor, makeId, itemNum, "使用物品")
        end
    end
    stop(actor)
end

--金币红包
function stdmodefunc102(actor, item)
    if not item then
        return
    end
    local itemName = getiteminfo(actor, item, ConstCfg.iteminfo.name)
    local value = cfg_UseItem[itemName]
    if value then
        local itemNum = getiteminfo(actor, item, ConstCfg.iteminfo.overlap)
        if itemNum <= 0 then
            return
        end
        local makeId = getiteminfo(actor, item, ConstCfg.iteminfo.id)
        local value = math.random(value.value[1], value.value[2])
        local total = value * itemNum
        if checkitemw(actor, "牛马主宰印", 1) then
            if randomex(20) then
                total = total * 2
            end
        end
        local data = splitLargeNumber(2000000000, total)
        local goldId = FGetBindGoldId(actor)
        if #data > 0 then
            for _, v in ipairs(data) do
                changemoney(actor, goldId, "+", v, "使用物品:" .. itemName, true)
            end
            delitembymakeindex(actor, makeId, itemNum, "使用物品")
        end
    end
    stop(actor)
end

--灵符红包
function stdmodefunc103(actor, item)
    if not item then
        return
    end
    local itemName = getiteminfo(actor, item, ConstCfg.iteminfo.name)
    local value = cfg_UseItem[itemName]
    if value then
        local itemNum = getiteminfo(actor, item, ConstCfg.iteminfo.overlap)
        if itemNum <= 0 then
            return
        end
        local makeId = getiteminfo(actor, item, ConstCfg.iteminfo.id)
        local randomValue = math.random(value.value[1], value.value[2])
        local total = randomValue * itemNum
        local data = splitLargeNumber(2000000000, total)
        if #data > 0 then
            for _, v in ipairs(data) do
                changemoney(actor, 20, "+", v, "使用物品:" .. itemName, true)
            end
            delitembymakeindex(actor, makeId, itemNum, "使用物品")
        end
    end
    stop(actor)
end

--金条
function stdmodefunc104(actor, item)
    if not item then
        return
    end
    local itemName = getiteminfo(actor, item, ConstCfg.iteminfo.name)
    local value = cfg_UseItem[itemName]
    if value then
        local itemNum = getiteminfo(actor, item, ConstCfg.iteminfo.overlap)
        if itemNum <= 0 then
            return
        end
        local makeId = getiteminfo(actor, item, ConstCfg.iteminfo.id)
        local total = value.value * itemNum
        local data = splitLargeNumber(2000000000, total)
        local goldId = FGetBindGoldId(actor)
        if #data > 0 then
            for _, v in ipairs(data) do
                changemoney(actor, goldId, "+", v, "使用物品:" .. itemName, true)
            end
            delitembymakeindex(actor, makeId, itemNum, "使用物品")
        end
    end
    stop(actor)
end

function stdmodefunc105(actor, item)
    local mapId = getbaseinfo(actor, ConstCfg.gbase.mapid)
    local x = getbaseinfo(actor, ConstCfg.gbase.x)
    local y = getbaseinfo(actor, ConstCfg.gbase.y)
    if mapId == "祭坛" and x == 35 and y == 17 then
        map(actor, "黑齿宝库")
    else
        Player.sendmsgEx(actor, "请在|[罡风谷]#249|最深处|[祭坛(35.17)]#249|使用笔记!")
    end
    stop(actor)
end

--不灭大蟒(称号卷)
function stdmodefunc106(actor, item)
    local idx = getiteminfo(actor, item, ConstCfg.iteminfo.idx)
    if Bag.checkItemNum(actor, idx, 1) then
        if Bag.checkItemNum(actor, idx, 1) then
            if checktitle(actor, "不灭大蟒") then
                messagebox(actor, "[系统提示]：你已经拥有不灭大蟒称号！")
                stop(actor)
                return
            else
                confertitle(actor, "不灭大蟒")
                messagebox(actor, "[系统提示]：成功获得不灭大蟒称号！")
            end
        end
    end
end

--渡劫丹 万劫不灭丹
function stdmodefunc107(actor, item)
    local idx = getiteminfo(actor, item, ConstCfg.iteminfo.idx)
    if Bag.checkItemNum(actor, idx, 1) then
        addbuff(actor, 31032)
        local remainingTime = getbuffinfo(actor, 31032, 2)
        local num = getplaydef(actor, VarCfg["U_万劫不灭丹保底"])
        setplaydef(actor, VarCfg["U_万劫不灭丹保底"], num + 1)
        Player.sendmsgEx(actor, string.format("你使用了|万劫不灭丹#249|不受天劫伤害,持续|%d#249|秒,当前已使用|%s#249|次", remainingTime, num + 1))
    end
end

--二级魔法盾
function stdmodefunc108(actor, item)
    local idx = getiteminfo(actor, item, ConstCfg.iteminfo.idx)
    if Bag.checkItemNum(actor, idx, 1) then
        if getskillinfo(actor, 31, 1) == 2 then
            Player.sendmsgEx(actor, "你已习得|[2级魔法盾]#249")
            stop(actor)
            return
        end
        if getskillinfo(actor, 31, 1) == 3 then
            Player.sendmsgEx(actor, "你已习得|[3级魔法盾]#249")
            stop(actor)
            return
        end
        delskill(actor, 31)
        addskill(actor, 31, 2)
        Player.sendmsgEx(actor, "恭喜你习得|[2级魔法盾]#249")
    end
end

--极寒护甲片
function stdmodefunc109(actor, item)
    local idx = getiteminfo(actor, item, ConstCfg.iteminfo.idx)
    if Bag.checkItemNum(actor, idx, 1) then
        local count = getplaydef(actor, VarCfg["U_极寒护甲片_使用次数"])
        if count >= 20 then
            Player.sendmsgEx(actor, "你已使用过20次，无法再使用！#249")
            stop(actor)
            return
        end
        local itemObj = linkbodyitem(actor, 0)
        if itemObj == "0" then
            Player.sendmsgEx(actor, "你没有穿戴衣服!#249")
            stop(actor)
            return
        end
        local gf = getitemaddvalue(actor, itemObj, 1, 0, 0)
        local mf = getitemaddvalue(actor, itemObj, 1, 1, 0)
        setitemaddvalue(actor, itemObj, 1, 0, gf + 20)
        setitemaddvalue(actor, itemObj, 1, 1, mf + 20)
        refreshitem(actor, itemObj)
        recalcabilitys(actor)
        setplaydef(actor, VarCfg["U_极寒护甲片_使用次数"], count + 1)
    end
end

--※雪舞※[装扮时装]
function stdmodefunc110(actor, item)
    local idx = getiteminfo(actor, item, ConstCfg.iteminfo.idx)
    if Bag.checkItemNum(actor, idx, 1) then
        ZhuangBan.AddFashionToVar(actor, 40090, VarCfg["T_时装记录"])
        ZhuangBan.SetCurrFashion(actor, 40090)
    end
end

-- 黑玉断续膏
function stdmodefunc111(actor, item)
    local idx = getiteminfo(actor, item, ConstCfg.iteminfo.idx)
    local name = getiteminfo(actor, item, ConstCfg.iteminfo.name)
    local buffId = 31037
    local hpmpper = 15
    if Bag.checkItemNum(actor, idx, 1) then
        if hasbuff(actor, buffId) then
            local remainder = getbuffinfo(actor, buffId, 2)
            Player.sendmsgEx(actor, string.format("%d秒#249|后才可以继续使用|%s#249", remainder, name))
            stop(actor)
            return
        else
            addbuff(actor, buffId)
            addhpper(actor, "+", hpmpper)
            addmpper(actor, "+", hpmpper)
            Player.sendmsgEx(actor, string.format("生命值,魔法值增加|%d%%#249", hpmpper))
        end
    end
end

-- 九花玉露丸
function stdmodefunc112(actor, item)
    local idx = getiteminfo(actor, item, ConstCfg.iteminfo.idx)
    local name = getiteminfo(actor, item, ConstCfg.iteminfo.name)
    local buffId = 31038
    local hpmpper = 30
    if Bag.checkItemNum(actor, idx, 1) then
        if hasbuff(actor, buffId) then
            local remainder = getbuffinfo(actor, buffId, 2)
            Player.sendmsgEx(actor, string.format("%d秒#249|后才可以继续使用|%s#249", remainder, name))
            stop(actor)
            return
        else
            addbuff(actor, buffId)
            addhpper(actor, "+", hpmpper)
            addmpper(actor, "+", hpmpper)
            Player.sendmsgEx(actor, string.format("生命值,魔法值增加|%d%%#249", hpmpper))
        end
    end
end

-- 十香返生丸
function stdmodefunc113(actor, item)
    local idx = getiteminfo(actor, item, ConstCfg.iteminfo.idx)
    local name = getiteminfo(actor, item, ConstCfg.iteminfo.name)
    local buffId = 31039
    local hpmpper = 50
    if Bag.checkItemNum(actor, idx, 1) then
        if hasbuff(actor, buffId) then
            local remainder = getbuffinfo(actor, buffId, 2)
            Player.sendmsgEx(actor, string.format("%d秒#249|后才可以继续使用|%s#249", remainder, name))
            stop(actor)
            return
        else
            addbuff(actor, buffId)
            addhpper(actor, "+", hpmpper)
            addmpper(actor, "+", hpmpper)
            Player.sendmsgEx(actor, string.format("生命值,魔法值增加|%d%%#249", hpmpper))
        end
    end
end

-- 天运丹
-- 破神丹
-- 阳神丹
-- 九幽丹
-- 后土丹
local cfg_UseXianYao = include("QuestDiary/cfgcsv/cfg_UseXianYao.lua") --配置
function stdmodefunc114(actor, item)
    local idx = getiteminfo(actor, item, ConstCfg.iteminfo.idx)
    local name = getiteminfo(actor, item, ConstCfg.iteminfo.name)
    if Bag.checkItemNum(actor, idx, 1) then
        local cfg = cfg_UseXianYao[name]
        if not cfg then
            stop(actor)
            return
        end
        local buffId = cfg.buffId
        if hasbuff(actor, buffId) then
            local remainder = getbuffinfo(actor, buffId, 2)
            Player.sendmsgEx(actor, string.format("%d秒#249|后才可以继续使用|%s#249", remainder, name))
            stop(actor)
            return
        else
            local shuxing = {}
            if cfg.attrs then
                for _, value in ipairs(cfg.attrs) do
                    shuxing[value[1]] = value[2]
                end
            end
            addbuff(actor, buffId, 0, 1, actor, shuxing)
            if buffId == 31040 then
                Player.setAttList(actor, "爆率附加")
            end
            Player.sendmsgEx(actor,
                string.format("你使用了|%s#249|,|%s+%d%%#249|,持续|%s#249|分钟", name, cfg.desc, cfg.addNum, cfg.time))
        end
    end
end

function stdmodefunc114(actor, item)
    local idx = getiteminfo(actor, item, ConstCfg.iteminfo.idx)
    local name = getiteminfo(actor, item, ConstCfg.iteminfo.name)
    if Bag.checkItemNum(actor, idx, 1) then
        local cfg = cfg_UseXianYao[name]
        if not cfg then
            stop(actor)
            return
        end
        local buffId = cfg.buffId
        if hasbuff(actor, buffId) then
            local remainder = getbuffinfo(actor, buffId, 2)
            Player.sendmsgEx(actor, string.format("%d秒#249|后才可以继续使用|%s#249", remainder, name))
            stop(actor)
            return
        else
            local shuxing = {}
            if cfg.attrs then
                for _, value in ipairs(cfg.attrs) do
                    shuxing[value[1]] = value[2]
                end
            end
            addbuff(actor, buffId, 0, 1, actor, shuxing)
            Player.sendmsgEx(actor,
                string.format("你使用了|%s#249|,|%s+%d%%#249|,持续|%s#249|分钟", name, cfg.desc, cfg.addNum, cfg.time))
        end
    end
end

-- 生命金莲丹
-- 洗净伐髓丹
-- 金刚不坏丹
-- 疾风斩月丹
local cfg_UseShengYao = include("QuestDiary/cfgcsv/cfg_UseShengYao.lua") --配置
function stdmodefunc115(actor, item)
    local idx = getiteminfo(actor, item, ConstCfg.iteminfo.idx)
    local name = getiteminfo(actor, item, ConstCfg.iteminfo.name)
    if Bag.checkItemNum(actor, idx, 1) then
        local cfg = cfg_UseShengYao[name]
        if not cfg then
            stop(actor)
            return
        end
        local buffId = cfg.buffId
        if hasbuff(actor, buffId) then
            local remainder = getbuffinfo(actor, buffId, 2)
            Player.sendmsgEx(actor, string.format("%d秒#249|后才可以继续使用|%s#249", remainder, name))
            stop(actor)
            return
        else
            local shuxing = {}
            if cfg.attrs then
                for _, value in ipairs(cfg.attrs) do
                    shuxing[value[1]] = value[2]
                end
            end
            local count = getplaydef(actor, cfg.var)
            if count < 10 then
                setplaydef(actor, cfg.var, count + 1)
                --重载属性，疾风斩月丹 重载攻速 重载属性
                if buffId == 31048 then
                    Player.setAttList(actor, "攻速附加")
                else
                    Player.setAttList(actor, "属性附加")
                end
            end
            addbuff(actor, buffId, 0, 1, actor, shuxing)
            Player.sendmsgEx(actor,
                string.format("你使用了|%s#249|,|%s+%d%%#249|,持续|%s#249|分钟", name, cfg.desc, cfg.addNum, cfg.time))
        end
    end
end

--精魄碎片
function stdmodefunc116(actor, item)
    local idx = getiteminfo(actor, item, ConstCfg.iteminfo.idx)
    if Bag.checkItemNum(actor, idx, 10) then
        local num = Bag.getItemNum(actor, idx)
        local num2 = math.floor(num / 10)
        takeitemex(actor, "精魄碎片", num2 * 10, 0, "气运精魄合成")
        giveitem(actor, "气运精魄", num2, ConstCfg.binding, "气运精魄碎片合成")
        Player.sendmsgEx(actor, string.format("你使用|%d#249|个|精魄碎片#249|成功合成|%d#249|个|气运精魄#249", num2 * 10, num2))
    else
        Player.sendmsgEx(actor, "精魄碎片#249|不足|10#249|无法合成")
    end
    stop(actor)
end

--转运之尘
function stdmodefunc117(actor, item)
    local idx = getiteminfo(actor, item, ConstCfg.iteminfo.idx)
    if Bag.checkItemNum(actor, idx, 10) then
        local num = Bag.getItemNum(actor, idx)
        local num2 = math.floor(num / 10)
        takeitemex(actor, "转运之尘", num2 * 10, 0, "转运金丹合成")
        giveitem(actor, "转运金丹", num2, ConstCfg.binding, "转运金丹碎片合成")
        Player.sendmsgEx(actor, string.format("你使用|%d#249|个|转运之尘#249|成功合成|%d#249|个|转运金丹#249", num2 * 10, num2))
    else
        Player.sendmsgEx(actor, "转运之尘#249|不足|10#249|无法合成")
    end
    stop(actor)
end

--骷髅将军[装扮时装]
function stdmodefunc118(actor, item)
    local idx = getiteminfo(actor, item, ConstCfg.iteminfo.idx)
    if Bag.checkItemNum(actor, idx, 1) then
        ZhuangBan.AddFashionToVar(actor, 26000, VarCfg["T_时装记录"])
        ZhuangBan.SetCurrFashion(actor, 26000)
    end
end

--充值卷使用
function stdmodefunc119(actor, item)
    if not item then
        return
    end
    local itemName = getiteminfo(actor, item, ConstCfg.iteminfo.name)
    local value = cfg_UseItem[itemName]
    if value then
        local itemNum = getiteminfo(actor, item, ConstCfg.iteminfo.overlap)
        if itemNum <= 0 then
            return
        end
        local makeId = getiteminfo(actor, item, ConstCfg.iteminfo.id)
        local total = value.value * itemNum
        local data = splitLargeNumber(2000000000, total)
        if #data > 0 then
            for _, v in ipairs(data) do
                local num = getplaydef(actor, VarCfg["U_虚拟充值"])
                setplaydef(actor, VarCfg["U_虚拟充值"], num + 1)
                changemoney(actor, 20, "+", v, "使用物品:" .. itemName, true)
                changemoney(actor, 11, "+", math.ceil(v / 10), "使用物品:" .. itemName, true)
            end
            delitembymakeindex(actor, makeId, itemNum, "使用物品")
        end
    end
    stop(actor)
end

--云游文牒
function stdmodefunc120(actor, item)
    stop(actor)
    if not item then
        return
    end
    local itemNum = getiteminfo(actor, item, ConstCfg.iteminfo.overlap)
    if itemNum <= 0 then
        return
    end
    if checktitle(actor, "云游天下") then
        Player.sendmsgEx(actor, "提示#251|:#255|对不起,你已激活|云游天下#249|请勿重复激活...")
        return
    end
    if itemNum < 10 then
        Player.sendmsgEx(actor, "提示#251|:#255|对不起,你的|云游文牒#249|不足|10枚#249|枚...")
        return
    else
        takeitem(actor, "云游文牒", 10, 0)
        confertitle(actor, "云游天下", 1)
        addbuff(actor, 31065)
        Player.sendmsgEx(actor, "提示#251|:#255|恭喜你,获得|云游天下#249|称号...")
    end
end

--黑市金币
function stdmodefunc121(actor, item)
    stop(actor)
    if not item then
        return
    end
    local itemNum = getiteminfo(actor, item, ConstCfg.iteminfo.overlap)
    if itemNum <= 0 then
        return
    end
    if checktitle(actor, "地下皇帝") then
        Player.sendmsgEx(actor, "提示#251|:#255|对不起,你已激活|地下皇帝#249|请勿重复激活...")
        return
    end
    if itemNum < 10 then
        Player.sendmsgEx(actor, "提示#251|:#255|对不起,你的|黑市金币#249|不足|10枚#249|枚...")
        return
    else
        takeitem(actor, "黑市金币", 10, 0)
        confertitle(actor, "地下皇帝", 1)
        moneychange7(actor)
        Player.sendmsgEx(actor, "提示#251|:#255|恭喜你,获得|地下皇帝#249|称号...")
    end
end

--黑丝小熊猫变身器
function stdmodefunc123(actor, item)
    stop(actor)
    local buff = hasbuff(actor, 31066)
    if buff then
        FkfDelBuff(actor, 31066)
    else
        addbuff(actor, 31066)
    end
end

--每日特权礼包
function stdmodefunc124(actor, item)
    local idx = getiteminfo(actor, item, ConstCfg.iteminfo.idx)
    if Bag.checkItemNum(actor, idx, 1) then
        Player.giveItemByTable(actor, { { "焚天石", 50 } }, "每日特权礼包", 1, true)
        Player.giveItemByTable(actor, { { "天工之锤", 50 } }, "每日特权礼包", 1, true)
        Player.giveItemByTable(actor, { { "幻灵水晶", 20 } }, "每日特权礼包", 1, true)
        Player.giveItemByTable(actor, { { "灵石", 5 } }, "每日特权礼包", 1, true)
    end
end


--奋进时装盒
function stdmodefunc125(actor, item)
    local data = {"火炎焱燚[时装]","暗影之行[时装]","幽鬼[时装]","蓝灵枪仙[时装]","企鹅村[时装]","赤金罗刹[时装]","银翼[时装]","瑶瑶[时装]",
                    "残魂凶灵[时装]","血杀之誓[时装]","恶鬼战神[时装]","敬天圣骑[时装]","炽热之魂[时装]","夜帝[时装]","剑仙[时装]","狩魂[时装]"}
    Message.sendmsg(actor, ssrNetMsgCfg.FenJinShiZhuangHe_OpenUI, 0, 0, 0, data)
    stop(actor)
end

--奋进好运礼包
local FenJinBaoXiangData = {["奋进时装盒"] = 1,["神魂碎片"] = 5,["混沌本源"] = 20,["神器格扩展卷"] = 1,["气运精魄"] = 1,["转运金丹"] = 1,["神魂宝箱(小)"] = 1}
function stdmodefunc126(actor, item)
    local idx = getiteminfo(actor, item, ConstCfg.iteminfo.idx)
    if Bag.checkItemNum(actor, idx, 1) then
        local Award, _ = ransjstr("奋进时装盒#2000|神魂碎片#1000|混沌本源#2500|神器格扩展卷#500|气运精魄#1500|转运金丹#1500|神魂宝箱(小)#1500", 1, 3)
        local Num = FenJinBaoXiangData[Award]
        local Name = Award
        giveitem(actor, Name, Num, ConstCfg.binding, "使用奋进好运礼包")
        local str = string.format("{【恭喜】/FCOLOR=249}：{%s/FCOLOR=250} {打开[奋进好运礼包]获得/FCOLOR=249}{%s/FCOLOR=250} ",
            Player.GetName(actor), Name)
        sendmovemsg(actor, 1, 249, 0, 100, 1, str)
    end
end




--500灵符   解包获得500灵符(绑定)
function stdmodefunc127(actor, item)
    local idx = getiteminfo(actor, item, ConstCfg.iteminfo.idx)
    if Bag.checkItemNum(actor, idx, 1) then
        changemoney(actor, 20, "+", 500, "使用500灵符获得", true)
    end
end

--祝福油
function stdmodefunc45(actor, item)
    callscriptex(actor, "CHANGEITEMADDVALUE", 1, 5, "=", 0)
    sendmsg(actor, ConstCfg.notice.own, '{"Msg":"<font color=\'#FFFFFF\'>武器诅咒已清洗！</font>","Type":9}')
end
local cfg_JingZhiXiaoHui = include("QuestDiary/cfgcsv/cfg_JingZhiXiaoHui.lua") --禁止销毁点化
--金手指点石成金
function stdmodeshow1(actor)
    local pointItemMakeId = getconst(actor, "<$BagItemMakeIndex>")
    local pointItemName = getconst(actor, "<$BagItemName>")
    if pointItemMakeId == "" then
        stop(actor)
        return
    end
    if cfg_JingZhiXiaoHui[pointItemName] then
        Player.sendmsgEx(actor,"【".. pointItemName .."】禁止点化!#249")
        stop(actor)
        return
    end
    local isSuccess = delitembymakeindex(actor, pointItemMakeId, 1, "金手指点石成金")
    if isSuccess then
        local index = math.random(#cfg_DianShiChengJin)
        local randomResult = cfg_DianShiChengJin[index]
        if randomResult then
            local itemName = randomResult.value
            giveitem(actor, itemName, 1, ConstCfg.binding, "金手指点石成金")
            messagebox(actor, string.format("[系统提示]： 你通过点石成金将[%s]重铸为：[%s]！", pointItemName, itemName))
        end
    end
end

--改名卡
function stdmodefunc200(actor, item)
    if checkkuafu(actor) then
        Player.sendmsgEx(actor, "跨服中,禁止改名!#249")
        stop(actor)
        return
    end
    say(actor, [[
        <Img|loadDelay=1|show=4|img=custom/public/gaimingjiemian.png|esc=1|move=0|reset=1|bg=1>
        <Layout|x=570.0|y=24.0|width=80|height=80|link=@exit>
        <Button|x=589.0|y=41.0|pimg=public/1900000511.png|nimg=public/1900000510.png|link=@exit>
        <Input|x=215.0|y=76.0|width=268|height=31|color=249|mincount=2|place="请输入新的名字"|type=0|inputid=1|size=18|maxcount=16|isNameInput=1|errortips=1>
        <Button|x=207.0|y=164.0|submitInput=1|nimg=custom/public/btn_quedingxiugai.png|link=@alterplayernameitem>
    ]])
    stop(actor)
end

function alterplayernameitem(actor)
    if checkkuafu(actor) then
        Player.sendmsgEx(actor, "跨服中,禁止改名!#249")
        stop(actor)
        return
    end
    if checkitems(actor, "改名卡#1", 0, 0) then
        local NewName = getconst(actor, "<$NPCINPUT(1)>")
        local _Type = changehumname(actor, NewName)
        if _Type == 0 then
            GameEvent.push(EventCfg.onUseGaiMingKa, actor)
            takeitem(actor, "改名卡", 1, 0)
            close(actor)
        end
    end
end

--正在查询玩家名称
function queryinghumname(actor)
    sendmsg(actor, 1, '{"Msg":"<font color=\'#ff0000\'>正在查询请稍后。。。</font>","Type":9}')
end

--名称被过滤
function humnamefilter(actor)
    sendmsg(actor, 1, '{"Msg":"<font color=\'#ff0000\'>名称被过滤。。。</font>","Type":9}')
end

--长度不符合要求
function namelengthfail(actor)
    sendmsg(actor, 1, '{"Msg":"<font color=\'#ff0000\'>长度不符合要求</font>","Type":9}')
end

--名称已经存在
function humnameexists(actor)
    sendmsg(actor, 1, '{"Msg":"<font color=\'#ff0000\'>名称已经存在</font>","Type":9}')
end

--正在执行改名操作
function changeinghumname(actor)
    sendmsg(actor, 1, '{"Msg":"<font color=\'#ff0000\'>正在修改请稍后。。。</font>","Type":9}')
end

--改名失败
function changehumnamefail(actor)
    sendmsg(actor, 1, '{"Msg":"<font color=\'#ff0000\'>修改名称失败</font>","Type":9}')
end

function gai_ming_xiao_tui_yan_chi(actor)
    openhyperlink(actor, 34)
end

--改名成功
function changehumnameok(actor)
    local OldName = getconst(actor, "<$USERNAME>")
    local NewName = getconst(actor, "<$USERNEWNAME>")
    sendmsgnew(actor, 250, 0,
        "{各位玩家: /FCOLOR=251}玩家{" ..
        OldName .. "/FCOLOR=249}成功改命,新名字【{" .. NewName .. "/FCOLOR=249}】请各位勇士 报仇不要找错人了！！！！！！！",
        0, 3)
    sendmsgnew(actor, 250, 0,
        "{各位玩家: /FCOLOR=251}玩家{" ..
        OldName .. "/FCOLOR=249}成功改命,新名字【{" .. NewName .. "/FCOLOR=249}】请各位勇士 报仇不要找错人了！！！！！！！",
        0, 3)
    sendmsgnew(actor, 250, 0,
        "{各位玩家: /FCOLOR=251}玩家{" ..
        OldName .. "/FCOLOR=249}成功改命,新名字【{" .. NewName .. "/FCOLOR=249}】请各位勇士 报仇不要找错人了！！！！！！！",
        0, 3)
    delaygoto(actor, 2000, "gai_ming_xiao_tui_yan_chi", 0)
end

--§§命运罗盘§§  占卜界面
function stdmodefunc300(actor, item)
    local ZhanBuTbl = Player.getJsonTableByVar(actor, VarCfg["T_罗盘占卜记录"])
    local Type = { "祝福", "速度", "武力", "体魄", "怒火", "暴力", "破坏", "绝杀", "穿透", "撕裂" }
    local NewTbl = {}
    for _, v in ipairs(Type) do
        local Num = (ZhanBuTbl[v] == "" and 0) or ZhanBuTbl[v] or 0
        table.insert(NewTbl, Num)
    end
    Message.sendmsg(actor, ssrNetMsgCfg.LuoPanZhanBu_OpenUI, 0, 0, 0, NewTbl)
    stop(actor)
end

--魔法盾[技能]
function stdmodefunc301(actor, item)
    addskill(actor, 31, 1)
end

--打工皇帝[称号]
function stdmodefunc302(actor, item)
    local idx = getiteminfo(actor, item, ConstCfg.iteminfo.idx)
    if Bag.checkItemNum(actor, idx, 1) then
        if Bag.checkItemNum(actor, idx, 1) then
            if checktitle(actor, "打工皇帝") then
                messagebox(actor, "[系统提示]：你已经拥有打工皇帝称号！")
                stop(actor)
                return
            else
                confertitle(actor, "打工皇帝")
                messagebox(actor, "[系统提示]：成功获得打工皇帝称号！")
            end
        end
    end
end

--怪物猎人[称号]
function stdmodefunc303(actor, item)
    local idx = getiteminfo(actor, item, ConstCfg.iteminfo.idx)
    if Bag.checkItemNum(actor, idx, 1) then
        if Bag.checkItemNum(actor, idx, 1) then
            if checktitle(actor, "怪物猎人") then
                messagebox(actor, "[系统提示]：你已经拥有怪物猎人称号！")
                stop(actor)
                return
            else
                confertitle(actor, "怪物猎人")
                messagebox(actor, "[系统提示]：成功获得怪物猎人称号！")
            end
        end
    end
end

--幻灵水晶箱
function stdmodefunc304(actor, item)
    local idx = getiteminfo(actor, item, ConstCfg.iteminfo.idx)
    if Bag.checkItemNum(actor, idx, 1) then
        if Bag.checkItemNum(actor, idx, 1) then
            giveitem(actor, "幻灵水晶", 100, ConstCfg.bangding, "QF使用幻灵水晶箱")
        end
    end
end

--灵石袋
function stdmodefunc305(actor, item)
    local idx = getiteminfo(actor, item, ConstCfg.iteminfo.idx)
    if Bag.checkItemNum(actor, idx, 1) then
        if Bag.checkItemNum(actor, idx, 1) then
            giveitem(actor, "灵石", 100, ConstCfg.bangding, "QF使用灵石袋")
        end
    end
end

local AwardList = {}
AwardList["背包专属"] = function(actor)
    local Tbl = { "老G画的饼", "领导甩的锅", "同事划的水", "自己摸的鱼", "策划挖的坑", "技术埋的雷" }
    local Num = math.random(1, #Tbl)
    local Name = Tbl[Num]
    giveitem(actor, Name, 1, ConstCfg.bangding, "QF使用背包专属")
    local str = string.format("{【恭喜】/FCOLOR=249}：{%s/FCOLOR=250} {打开[勇者好运礼包]获得/FCOLOR=249}{%s/FCOLOR=250} ",
        Player.GetName(actor), Name)
    sendmovemsg(actor, 1, 249, 0, 100, 1, str)
end
AwardList["神秘时装"] = function(actor)
    local Tbl = { "霓裳羽衣[时装]", "御剑飞行[时装]", "剧毒恶蛆[时装]", "烈焰蠕虫[时装]", "电击跳跳蜂[时装]", "旋风蜈蚣[时装]", "熔岩钳虫[时装]", "熊猫武僧[时装]",
        "熟透的大龙虾[时装]", "蛮荒力士[时装]", "蛮荒战士[时装]", "幻·胜利女神[时装]", "幻·九天玄女[时装]", "斗战胜佛[时装]", "净坛使者[时装]", "烈焰战车[时装]" }
    local Num = math.random(1, #Tbl)
    local Name = Tbl[Num]
    giveitem(actor, Name, 1, ConstCfg.bangding, "QF使用背包专属")
    local str = string.format("{【恭喜】/FCOLOR=249}：{%s/FCOLOR=250} {打开[勇者好运礼包]获得/FCOLOR=249}{%s/FCOLOR=250} ",
        Player.GetName(actor), Name)
    sendmovemsg(actor, 1, 249, 0, 100, 1, str)
end
AwardList["超级材料"] = function(actor)
    local Tbl = { "气运精魄", "转运金丹", "境界丹", "1亿经验卷", "金手指", "5000W经验卷" }
    local Num = math.random(1, #Tbl)
    local Name = Tbl[Num]
    if Name == "境界丹" then
        giveitem(actor, Name, 3, ConstCfg.bangding, "QF使用背包专属")
    else
        giveitem(actor, Name, 1, ConstCfg.bangding, "QF使用背包专属")
    end
    local str = string.format("{【恭喜】/FCOLOR=249}：{%s/FCOLOR=250} {打开[勇者好运礼包]获得/FCOLOR=249}{%s/FCOLOR=250} ",
        Player.GetName(actor), Name)
    sendmovemsg(actor, 1, 249, 0, 100, 1, str)
end


--沙城排行榜宝箱
function stdmodefunc91(actor, item)
    local idx = getiteminfo(actor, item, ConstCfg.iteminfo.idx)
    local name = getiteminfo(actor, item, ConstCfg.iteminfo.name)
    if Bag.checkItemNum(actor, idx, 1) then
        local cfg = cfg_ShaChengBaoXiang[name]
        local gives = {}
        for index, value in ipairs(cfg.reward) do
            if randomex(value[3]) then
                if value[1] == "隐藏时装" then
                    AwardList["神秘时装"](actor)
                    return
                end
                gives = { { value[1], value[2] } }
            end
        end
        if #gives < 1 then
            gives = cfg.baoDi
        end
        setmetatable(gives, {
            __tostring = function(t)
                return t[1][1] .. "*" .. t[1][2]
            end
        })
        Player.giveItemByTable(actor, gives, "使用" .. name, 1, true)
        messagebox(actor, string.format("[系统提示]： 你开启了%s成功获得[%s]", name, tostring(gives)))
    end
end

function stdmodefunc306(actor, item)
    local idx = getiteminfo(actor, item, ConstCfg.iteminfo.idx)
    if Bag.checkItemNum(actor, idx, 1) then
        if Bag.checkItemNum(actor, idx, 1) then
            local Award, _ = ransjstr("背包专属#500|神秘时装#1500|超级材料#7000", 1, 3)
            AwardList[Award](actor)
        end
    end
end

--半月弯刀
function stdmodefunc307(actor, item)
    local idx = getiteminfo(actor, item, ConstCfg.iteminfo.idx)
    if Bag.checkItemNum(actor, idx, 1) then
        addskill(actor, 25, 3)
        Player.sendmsgEx(actor, "恭喜你习得|[半月弯刀]#249")
    end
end

function stdmodefunc308(actor, item)
    say(actor, [[
    <Img|reset=1|show=4|img=custom/public/hanhuabg.png|esc=1|bg=1|loadDelay=1|move=0>
    <Layout|x=570.0|y=24.0|width=80|height=80|link=@exit>
    <Button|x=589.0|y=41.0|nimg=public/1900000510.png|pimg=public/1900000511.png|link=@exit>
    <Input|x=64.0|y=78.0|width=483|height=32|mincount=2|maxcount=16|size=18|color=249|place="请输入喊话内容"|errortips=1|type=0|inputid=2>
    <Button|x=207.0|y=164.0|submitInput=2|size=18|nimg=custom/public/btn_queding.png|color=255|link=@onbroadcast>
]])
    stop(actor)
end

function onbroadcast(actor)
    if checkitems(actor, "喊话喇叭#1", 0, 0) then
        local Strinfo = getconst(actor, "<$NPCINPUT(2)>")
        local name = getbaseinfo(actor, ConstCfg.gbase.name)


        local result1, result2 = exisitssensitiveword(Strinfo)
        if Strinfo == "" then
            messagebox(actor, string.format("[系统提示]：你还未输入任何内容..."))
            return
        end
        if result1 then
            messagebox(actor, string.format("[系统提示]：你输入的内容存在违禁词,请重新输入..."))
            return
        else
            sendmovemsg(actor, 1, 255, 0, 200, 1,
                "{[喇叭] /FCOLOR=251}{" .. name .. ": /FCOLOR=250}{" .. Strinfo .. " /FCOLOR=253}")
            takeitem(actor, "喊话喇叭", 1, 0)
        end
    else
        Player.sendmsgEx(actor, "提示#251|:#255|喊话喇叭不足1个...")
    end
end

-- 401  牛马工装[时装]
function stdmodefunc401(actor, item)
    local idx = getiteminfo(actor, item, ConstCfg.iteminfo.idx)
    if Bag.checkItemNum(actor, idx, 1) then
        ZhuangBan.AddFashionToVar(actor, 40167, VarCfg["T_时装记录"])
        ZhuangBan.SetCurrFashion(actor, 40167)
    end
end

-- 402  霓裳羽衣[时装]
function stdmodefunc402(actor, item)
    local idx = getiteminfo(actor, item, ConstCfg.iteminfo.idx)
    if Bag.checkItemNum(actor, idx, 1) then
        ZhuangBan.AddFashionToVar(actor, 40127, VarCfg["T_时装记录"])
        ZhuangBan.SetCurrFashion(actor, 40127)
    end
end

-- 403  御剑飞行[时装]
function stdmodefunc403(actor, item)
    local idx = getiteminfo(actor, item, ConstCfg.iteminfo.idx)
    if Bag.checkItemNum(actor, idx, 1) then
        ZhuangBan.AddFashionToVar(actor, 40122, VarCfg["T_时装记录"])
        ZhuangBan.SetCurrFashion(actor, 40122)
    end
end

-- 404  幻·火莲魔童·哪吒[时装]
function stdmodefunc404(actor, item)
    local idx = getiteminfo(actor, item, ConstCfg.iteminfo.idx)
    if Bag.checkItemNum(actor, idx, 1) then
        ZhuangBan.AddFashionToVar(actor, 1088, VarCfg["T_时装记录"])
        ZhuangBan.SetCurrFashion(actor, 1088)
    end
end

-- 405  魔龙·幻化[时装]
function stdmodefunc405(actor, item)
    local idx = getiteminfo(actor, item, ConstCfg.iteminfo.idx)
    if Bag.checkItemNum(actor, idx, 1) then
        ZhuangBan.AddFashionToVar(actor, 40166, VarCfg["T_时装记录"])
        ZhuangBan.SetCurrFashion(actor, 40166)
    end
end

-- 406  骷髅将军[时装]
function stdmodefunc406(actor, item)
    local idx = getiteminfo(actor, item, ConstCfg.iteminfo.idx)
    if Bag.checkItemNum(actor, idx, 1) then
        ZhuangBan.AddFashionToVar(actor, 26000, VarCfg["T_时装记录"])
        ZhuangBan.SetCurrFashion(actor, 26000)
    end
end

-- 407  〈〈太阴星君〉〉[时装]
function stdmodefunc407(actor, item)
    local idx = getiteminfo(actor, item, ConstCfg.iteminfo.idx)
    if Bag.checkItemNum(actor, idx, 1) then
        ZhuangBan.AddFashionToVar(actor, 40150, VarCfg["T_时装记录"])
        ZhuangBan.SetCurrFashion(actor, 40150)
    end
end

-- 408  40155 剧毒恶蛆[时装]
function stdmodefunc408(actor, item)
    local idx = getiteminfo(actor, item, ConstCfg.iteminfo.idx)
    if Bag.checkItemNum(actor, idx, 1) then
        ZhuangBan.AddFashionToVar(actor, 40155, VarCfg["T_时装记录"])
        ZhuangBan.SetCurrFashion(actor, 40155)
    end
end

-- 409   40158  烈焰蠕虫[时装]
function stdmodefunc409(actor, item)
    local idx = getiteminfo(actor, item, ConstCfg.iteminfo.idx)
    if Bag.checkItemNum(actor, idx, 1) then
        ZhuangBan.AddFashionToVar(actor, 40158, VarCfg["T_时装记录"])
        ZhuangBan.SetCurrFashion(actor, 40158)
    end
end

-- 410   40159  电击跳跳蜂[时装]
function stdmodefunc410(actor, item)
    local idx = getiteminfo(actor, item, ConstCfg.iteminfo.idx)
    if Bag.checkItemNum(actor, idx, 1) then
        ZhuangBan.AddFashionToVar(actor, 40159, VarCfg["T_时装记录"])
        ZhuangBan.SetCurrFashion(actor, 40159)
    end
end

-- 411   40153  旋风蜈蚣[时装]
function stdmodefunc411(actor, item)
    local idx = getiteminfo(actor, item, ConstCfg.iteminfo.idx)
    if Bag.checkItemNum(actor, idx, 1) then
        ZhuangBan.AddFashionToVar(actor, 40153, VarCfg["T_时装记录"])
        ZhuangBan.SetCurrFashion(actor, 40153)
    end
end

-- 412   40154  熔岩钳虫[时装]
function stdmodefunc412(actor, item)
    local idx = getiteminfo(actor, item, ConstCfg.iteminfo.idx)
    if Bag.checkItemNum(actor, idx, 1) then
        ZhuangBan.AddFashionToVar(actor, 40154, VarCfg["T_时装记录"])
        ZhuangBan.SetCurrFashion(actor, 40154)
    end
end

-- 413   40160  熊猫武僧[时装]
function stdmodefunc413(actor, item)
    local idx = getiteminfo(actor, item, ConstCfg.iteminfo.idx)
    if Bag.checkItemNum(actor, idx, 1) then
        ZhuangBan.AddFashionToVar(actor, 40160, VarCfg["T_时装记录"])
        ZhuangBan.SetCurrFashion(actor, 40160)
    end
end

-- 414   40157  熟透的大龙虾[时装]
function stdmodefunc414(actor, item)
    local idx = getiteminfo(actor, item, ConstCfg.iteminfo.idx)
    if Bag.checkItemNum(actor, idx, 1) then
        ZhuangBan.AddFashionToVar(actor, 40157, VarCfg["T_时装记录"])
        ZhuangBan.SetCurrFashion(actor, 40157)
    end
end

-- 415   40156  蛮荒力士[时装]
function stdmodefunc415(actor, item)
    local idx = getiteminfo(actor, item, ConstCfg.iteminfo.idx)
    if Bag.checkItemNum(actor, idx, 1) then
        ZhuangBan.AddFashionToVar(actor, 40156, VarCfg["T_时装记录"])
        ZhuangBan.SetCurrFashion(actor, 40156)
    end
end

-- 416   40161  蛮荒战士[时装]
function stdmodefunc416(actor, item)
    local idx = getiteminfo(actor, item, ConstCfg.iteminfo.idx)
    if Bag.checkItemNum(actor, idx, 1) then
        ZhuangBan.AddFashionToVar(actor, 40161, VarCfg["T_时装记录"])
        ZhuangBan.SetCurrFashion(actor, 40161)
    end
end

-- 417   40128  幻·胜利女神[时装]
function stdmodefunc417(actor, item)
    local idx = getiteminfo(actor, item, ConstCfg.iteminfo.idx)
    if Bag.checkItemNum(actor, idx, 1) then
        ZhuangBan.AddFashionToVar(actor, 40128, VarCfg["T_时装记录"])
        ZhuangBan.SetCurrFashion(actor, 40128)
    end
end

-- 418   40121  幻·九天玄女[时装]
function stdmodefunc418(actor, item)
    local idx = getiteminfo(actor, item, ConstCfg.iteminfo.idx)
    if Bag.checkItemNum(actor, idx, 1) then
        ZhuangBan.AddFashionToVar(actor, 40121, VarCfg["T_时装记录"])
        ZhuangBan.SetCurrFashion(actor, 40121)
    end
end

-- 419   40127  霓裳羽衣[时装]
function stdmodefunc419(actor, item)
    local idx = getiteminfo(actor, item, ConstCfg.iteminfo.idx)
    if Bag.checkItemNum(actor, idx, 1) then
        ZhuangBan.AddFashionToVar(actor, 40127, VarCfg["T_时装记录"])
        ZhuangBan.SetCurrFashion(actor, 40127)
    end
end

-- 420   40123  斗战胜佛[时装]
function stdmodefunc420(actor, item)
    local idx = getiteminfo(actor, item, ConstCfg.iteminfo.idx)
    if Bag.checkItemNum(actor, idx, 1) then
        ZhuangBan.AddFashionToVar(actor, 40123, VarCfg["T_时装记录"])
        ZhuangBan.SetCurrFashion(actor, 40123)
    end
end

-- 421   40151  净坛使者[时装]
function stdmodefunc421(actor, item)
    local idx = getiteminfo(actor, item, ConstCfg.iteminfo.idx)
    if Bag.checkItemNum(actor, idx, 1) then
        ZhuangBan.AddFashionToVar(actor, 40151, VarCfg["T_时装记录"])
        ZhuangBan.SetCurrFashion(actor, 40151)
    end
end

-- 422   40152  烈焰战车[时装]
function stdmodefunc422(actor, item)
    local idx = getiteminfo(actor, item, ConstCfg.iteminfo.idx)
    if Bag.checkItemNum(actor, idx, 1) then
        ZhuangBan.AddFashionToVar(actor, 40152, VarCfg["T_时装记录"])
        ZhuangBan.SetCurrFashion(actor, 40152)
    end
end

-- 423   40162  我有一头小毛驴[时装]
function stdmodefunc423(actor, item)
    local idx = getiteminfo(actor, item, ConstCfg.iteminfo.idx)
    if Bag.checkItemNum(actor, idx, 1) then
        ZhuangBan.AddFashionToVar(actor, 40162, VarCfg["T_时装记录"])
        ZhuangBan.SetCurrFashion(actor, 40162)
    end
end

-- 424   10508  泳装达人[时装]
function stdmodefunc424(actor, item)
    local idx = getiteminfo(actor, item, ConstCfg.iteminfo.idx)
    if Bag.checkItemNum(actor, idx, 1) then
        ZhuangBan.AddFashionToVar(actor, 1109, VarCfg["T_时装记录"])
        ZhuangBan.SetCurrFashion(actor, 1109)
    end
end

-- 424   10508  黑丝小喵喵[时装]
function stdmodefunc425(actor, item)
    local idx = getiteminfo(actor, item, ConstCfg.iteminfo.idx)
    if Bag.checkItemNum(actor, idx, 1) then

    end
end

-- 426   40183  龙行天下[时装]
function stdmodefunc426(actor, item)
    local idx = getiteminfo(actor, item, ConstCfg.iteminfo.idx)
    if Bag.checkItemNum(actor, idx, 1) then
        ZhuangBan.AddFashionToVar(actor, 40183, VarCfg["T_时装记录"])
        ZhuangBan.SetCurrFashion(actor, 40183)
    end
end

function stdmodefunc427(actor, item)
    local idx = getiteminfo(actor, item, ConstCfg.iteminfo.idx)
    if Bag.checkItemNum(actor, idx, 10) then
        if not Bag.checkBagEmptyNum(actor, 5) then
            Player.sendmsgEx(actor, "你的背包格子不足,至少留出5个空格!#249")
            stop(actor)
            return
        end
        local num = Bag.getItemNum(actor, idx)
        local num2 = math.floor(num / 10)
        takeitemex(actor, "魔龙幻化碎片", num2 * 10, 0, "魔龙幻化合成")
        giveitem(actor, "魔龙·幻化[时装]", num2, ConstCfg.binding, "魔龙·幻化合成")
        Player.sendmsgEx(actor, string.format("你使用|%d#249|个|魔龙幻化碎片#249|成功合成|%d#249|个|魔龙·幻化[时装]#249", num2 * 10, num2))
    else
        Player.sendmsgEx(actor, "精魄碎片#249|不足|10#249|无法合成")
    end
    stop(actor)
end

--幻灵水晶箱
function stdmodefunc428(actor, item)
    local idx = getiteminfo(actor, item, ConstCfg.iteminfo.idx)
    if Bag.checkItemNum(actor, idx, 1) then
        if Bag.checkItemNum(actor, idx, 1) then
            giveitem(actor, "幻灵水晶", 500, ConstCfg.bangding, "QF使用幻灵水晶箱大")
        end
    end
end

--灵石袋
function stdmodefunc429(actor, item)
    local idx = getiteminfo(actor, item, ConstCfg.iteminfo.idx)
    if Bag.checkItemNum(actor, idx, 1) then
        if Bag.checkItemNum(actor, idx, 1) then
            giveitem(actor, "灵石", 30, ConstCfg.bangding, "QF使用灵石袋小")
        end
    end
end

-- 430   40200  吾為天帝·镇杀世間一切敌[时装]
function stdmodefunc430(actor, item)
    local idx = getiteminfo(actor, item, ConstCfg.iteminfo.idx)
    if Bag.checkItemNum(actor, idx, 1) then
        setflagstatus(actor, VarCfg["F_终极时装标识"], 1)
        ZhuangBan.AddFashionToVar(actor, 40200, VarCfg["T_时装记录"])
        ZhuangBan.SetCurrFashion(actor, 40200)
    end
end

-- 431  神魂宝箱(小)
function stdmodefunc431(actor, item)
    if checkkuafu(actor) then
        Player.sendmsgEx(actor, "请回本服使用#249")
        stop(actor)
        return
    end
    local idx = getiteminfo(actor, item, ConstCfg.iteminfo.idx)
    if Bag.checkItemNum(actor, idx, 1) then
        local items = { { "三魂之刃[魂]", 1 }, { "三魂恺甲[魂]", 1 }, { "三魂头盔[魂]", 1 }, { "三魂项链[魂]", 1 }, { "三魂手镯[魂]", 1 }, { "三魂指环[魂]", 1 } }
        local giveItem = { table.random(items) }
        Player.giveItemByTable(actor, giveItem, "开启宝箱", 1, true)
        local msgStr = getItemArrToStr(giveItem)
        messagebox(actor, string.format("[系统提示]： 你使用[神魂宝箱(小)]获得：[%s]", msgStr))
    end
end

-- 432 神魂宝箱(中)
function stdmodefunc432(actor, item)
    if checkkuafu(actor) then
        Player.sendmsgEx(actor, "请回本服使用#249")
        stop(actor)
        return
    end
    local idx = getiteminfo(actor, item, ConstCfg.iteminfo.idx)
    if Bag.checkItemNum(actor, idx, 1) then
        local items = { { "五岳之刃[魂]", 1 }, { "五岳恺甲[魂]", 1 }, { "五岳头盔[魂]", 1 }, { "五岳项链[魂]", 1 }, { "五岳手镯[魂]", 1 }, { "五岳指环[魂]", 1 } }
        local giveItem = { table.random(items) }
        Player.giveItemByTable(actor, giveItem, "开启宝箱", 1, true)
        local msgStr = getItemArrToStr(giveItem)
        messagebox(actor, string.format("[系统提示]： 你使用[神魂宝箱(中)]获得：[%s]", msgStr))
    end
end

-- 433 神魂宝箱(大)
function stdmodefunc433(actor, item)
    if checkkuafu(actor) then
        Player.sendmsgEx(actor, "请回本服使用#249")
        stop(actor)
        return
    end
    local idx = getiteminfo(actor, item, ConstCfg.iteminfo.idx)
    if Bag.checkItemNum(actor, idx, 1) then
        local items = { { "七星之刃[魂]", 1 }, { "七星恺甲[魂]", 1 }, { "七星头盔[魂]", 1 }, { "七星项链[魂]", 1 }, { "七星手镯[魂]", 1 }, { "七星指环[魂]", 1 } }
        local giveItem = { table.random(items) }
        Player.giveItemByTable(actor, giveItem, "开启宝箱", 1, true)
        local msgStr = getItemArrToStr(giveItem)
        messagebox(actor, string.format("[系统提示]： 你使用[神魂宝箱(大)]获得：[%s]", msgStr))
    end
end

-- 434  擒龙手[技能]学习擒龙手
function stdmodefunc434(actor, item)
    if checkkuafu(actor) then
        Player.sendmsgEx(actor, "请回本服使用#249")
        stop(actor)
        return
    end
    local idx = getiteminfo(actor, item, ConstCfg.iteminfo.idx)
    if Bag.checkItemNum(actor, idx, 1) then
        if getskillinfo(actor, 71, 1) == 3 then
            Player.sendmsgEx(actor, "你已习得|[擒龙手]#249|无需重复学习")
            stop(actor)
            return
        end
        addskill(actor, 71, 3)
        Player.sendmsgEx(actor, "恭喜你习得|[擒龙手]#249")
    end
end

--月夜战神的认可[称号卷]
function stdmodefunc435(actor, item)
    local idx = getiteminfo(actor, item, ConstCfg.iteminfo.idx)
    if Bag.checkItemNum(actor, idx, 1) then
        if Bag.checkItemNum(actor, idx, 1) then
            if checktitle(actor, "月夜战神的认可") then
                messagebox(actor, "[系统提示]：你已经拥有月夜战神的认可称号！")
                stop(actor)
                return
            else
                confertitle(actor, "月夜战神的认可")
                messagebox(actor, "[系统提示]：成功获得月夜战神的认可称号！")
            end
        end
    end
end

--月影之痕[足迹]
function stdmodefunc436(actor, item)
    local idx = getiteminfo(actor, item, ConstCfg.iteminfo.idx)
    if Bag.checkItemNum(actor, idx, 1) then
        if getflagstatus(actor, VarCfg["F_月影之痕足迹获得"]) == 1 then
            Player.sendmsgEx(actor, "你已经拥有月影之痕足迹！")
            stop(actor)
            return
        end
        --给装扮
        ZhuangBan.AddFashionToVar(actor, 63135, VarCfg["T_足迹记录"])
        ZhuangBan.SetCurrFashion(actor, 63135)
        setflagstatus(actor, VarCfg["F_月影之痕足迹获得"], 1)
        Player.setAttList(actor, "属性附加")
    end
end

--千王之王[称号]
function stdmodefunc437(actor, item)
    local idx = getiteminfo(actor, item, ConstCfg.iteminfo.idx)
    if Bag.checkItemNum(actor, idx, 1) then
        if Bag.checkItemNum(actor, idx, 1) then
            if checktitle(actor, "千王之王") then
                messagebox(actor, "[系统提示]：你已经拥有千王之王称号！")
                stop(actor)
                return
            else
                confertitle(actor, "千王之王")
                messagebox(actor, "[系统提示]：成功获得千王之王称号！")
            end
        end
    end
end

-- 天下共主[称号卷]	31	0	0	438
-- 不灭之魂[称号卷]	31	0	0	439
-- 1500跨服积分	31	0	0	440
-- 500跨服积分	31	0	0	441
-- 天下共主宝箱	31	0	0	442
-- 不灭之魂宝箱	31	0	0	443

-- 天下共主[称号卷]
function stdmodefunc438(actor, item)
    if checkkuafu(actor) then
        Player.sendmsgEx(actor, "请回本服使用#249")
        stop(actor)
        return
    end
    local idx = getiteminfo(actor, item, ConstCfg.iteminfo.idx)
    if Bag.checkItemNum(actor, idx, 1) then
        if checktitle(actor, "天下共主") then
            messagebox(actor, "[系统提示]：你已经拥有天下共主称号！")
            stop(actor)
            return
        else
            confertitle(actor, "天下共主", 1)
            messagebox(actor, "[系统提示]：成功获得天下共主称号！,有效期48小时！")
        end
    end
end

-- 不灭之魂[称号卷]	31	0	0	439
function stdmodefunc439(actor, item)
    if checkkuafu(actor) then
        Player.sendmsgEx(actor, "请回本服使用#249")
        stop(actor)
        return
    end
    local idx = getiteminfo(actor, item, ConstCfg.iteminfo.idx)
    if Bag.checkItemNum(actor, idx, 1) then
        if checktitle(actor, "不灭之魂") then
            messagebox(actor, "[系统提示]：你已经拥有不灭之魂称号！")
            stop(actor)
            return
        else
            confertitle(actor, "不灭之魂", 1)
            messagebox(actor, "[系统提示]：成功获得不灭之魂称号,有效期48小时！")
        end
    end
end

-- 1500跨服积分	31	0	0	440
function stdmodefunc440(actor, item)
    local idx = getiteminfo(actor, item, ConstCfg.iteminfo.idx)
    if Bag.checkItemNum(actor, idx, 1) then
        local kuaFuPiont = getplaydef(actor, VarCfg["U_跨服积分"])
        setplaydef(actor, VarCfg["U_跨服积分"], kuaFuPiont + 1500)
        messagebox(actor, "恭喜你获得1500积分,当前积分:" .. kuaFuPiont + 1500)
    end
end

-- 500跨服积分	31	0	0	441
function stdmodefunc441(actor, item)
    local idx = getiteminfo(actor, item, ConstCfg.iteminfo.idx)
    if Bag.checkItemNum(actor, idx, 1) then
        local kuaFuPiont = getplaydef(actor, VarCfg["U_跨服积分"])
        setplaydef(actor, VarCfg["U_跨服积分"], kuaFuPiont + 500)
        messagebox(actor, "恭喜你获得500积分,当前积分:" .. kuaFuPiont + 500)
    end
end

-- 天下共主宝箱	31	0	0	442
function stdmodefunc442(actor, item)
    local idx = getiteminfo(actor, item, ConstCfg.iteminfo.idx)
    if Bag.checkItemNum(actor, idx, 1) then
        local uid = Player.GetUUID(actor)
        Player.giveMailByTable(uid, 1, "天下共主宝箱奖励", "请领取[天下共主宝箱]宝箱奖励",
            { { "天下共主[称号卷]", 1 }, { "1500跨服积分", 1 }, { "神魂碎片", 10 } }, 1, true)
        Player.sendmsgEx(actor, "奖励已发送到邮箱，请注意查收!")
    end
end

-- 不灭之魂宝箱	31	0	0	443
function stdmodefunc443(actor, item)
    local idx = getiteminfo(actor, item, ConstCfg.iteminfo.idx)
    if Bag.checkItemNum(actor, idx, 1) then
        local uid = Player.GetUUID(actor)
        Player.giveMailByTable(uid, 1, "不灭之魂宝箱奖励", "请领取[不灭之魂宝箱]宝箱奖励", { { "不灭之魂[称号卷]", 1 }, { "500跨服积分", 1 }, { "神魂碎片", 3 } }, 1, true)
        Player.sendmsgEx(actor, "奖励已发送到邮箱，请注意查收!")
    end
end

-- 火炎焱燚[时装] 1050
function stdmodefunc444(actor, item)
    local idx = getiteminfo(actor, item, ConstCfg.iteminfo.idx)
    if Bag.checkItemNum(actor, idx, 1) then
        ZhuangBan.AddFashionToVar(actor, 1050, VarCfg["T_时装记录"])
        ZhuangBan.SetCurrFashion(actor, 1050)
    end
end
-- 暗影之行[时装] 1054
function stdmodefunc445(actor, item)
    local idx = getiteminfo(actor, item, ConstCfg.iteminfo.idx)
    if Bag.checkItemNum(actor, idx, 1) then
        ZhuangBan.AddFashionToVar(actor, 1054, VarCfg["T_时装记录"])
        ZhuangBan.SetCurrFashion(actor, 1054)
    end
end
-- 幽鬼[时装] 1048
function stdmodefunc446(actor, item)
    local idx = getiteminfo(actor, item, ConstCfg.iteminfo.idx)
    if Bag.checkItemNum(actor, idx, 1) then
        ZhuangBan.AddFashionToVar(actor, 1048, VarCfg["T_时装记录"])
        ZhuangBan.SetCurrFashion(actor, 1048)
    end
end
-- 蓝灵枪仙[时装] 26001
function stdmodefunc447(actor, item)
    local idx = getiteminfo(actor, item, ConstCfg.iteminfo.idx)
    if Bag.checkItemNum(actor, idx, 1) then
        ZhuangBan.AddFashionToVar(actor, 26001, VarCfg["T_时装记录"])
        ZhuangBan.SetCurrFashion(actor, 26001)
    end
end
-- 企鹅村[时装] 26002
function stdmodefunc448(actor, item)
    local idx = getiteminfo(actor, item, ConstCfg.iteminfo.idx)
    if Bag.checkItemNum(actor, idx, 1) then
        ZhuangBan.AddFashionToVar(actor, 26002, VarCfg["T_时装记录"])
        ZhuangBan.SetCurrFashion(actor, 26002)
    end
end
-- 赤金罗刹[时装] 26003
function stdmodefunc449(actor, item)
    local idx = getiteminfo(actor, item, ConstCfg.iteminfo.idx)
    if Bag.checkItemNum(actor, idx, 1) then
        ZhuangBan.AddFashionToVar(actor, 26003, VarCfg["T_时装记录"])
        ZhuangBan.SetCurrFashion(actor, 26003)
    end
end
-- 银翼[时装] 26005
function stdmodefunc450(actor, item)
    local idx = getiteminfo(actor, item, ConstCfg.iteminfo.idx)
    if Bag.checkItemNum(actor, idx, 1) then
        ZhuangBan.AddFashionToVar(actor, 26005, VarCfg["T_时装记录"])
        ZhuangBan.SetCurrFashion(actor, 26005)
    end
end
-- 瑶瑶[时装] 26006
function stdmodefunc451(actor, item)
    local idx = getiteminfo(actor, item, ConstCfg.iteminfo.idx)
    if Bag.checkItemNum(actor, idx, 1) then
        ZhuangBan.AddFashionToVar(actor, 26006, VarCfg["T_时装记录"])
        ZhuangBan.SetCurrFashion(actor, 26006)
    end
end
-- 残魂凶灵[时装] 26008
function stdmodefunc452(actor, item)
    local idx = getiteminfo(actor, item, ConstCfg.iteminfo.idx)
    if Bag.checkItemNum(actor, idx, 1) then
        ZhuangBan.AddFashionToVar(actor, 26008, VarCfg["T_时装记录"])
        ZhuangBan.SetCurrFashion(actor, 26008)
    end
end
-- 血杀之誓[时装] 26010
function stdmodefunc453(actor, item)
    local idx = getiteminfo(actor, item, ConstCfg.iteminfo.idx)
    if Bag.checkItemNum(actor, idx, 1) then
        ZhuangBan.AddFashionToVar(actor, 26010, VarCfg["T_时装记录"])
        ZhuangBan.SetCurrFashion(actor, 26010)
    end
end
-- 恶鬼战神[时装] 26011
function stdmodefunc454(actor, item)
    local idx = getiteminfo(actor, item, ConstCfg.iteminfo.idx)
    if Bag.checkItemNum(actor, idx, 1) then
        ZhuangBan.AddFashionToVar(actor, 26011, VarCfg["T_时装记录"])
        ZhuangBan.SetCurrFashion(actor, 26011)
    end
end
-- 敬天圣骑[时装] 26013
function stdmodefunc455(actor, item)
    local idx = getiteminfo(actor, item, ConstCfg.iteminfo.idx)
    if Bag.checkItemNum(actor, idx, 1) then
        ZhuangBan.AddFashionToVar(actor, 26013, VarCfg["T_时装记录"])
        ZhuangBan.SetCurrFashion(actor, 26013)
    end
end
-- 炽热之魂[时装] 26021
function stdmodefunc456(actor, item)
    local idx = getiteminfo(actor, item, ConstCfg.iteminfo.idx)
    if Bag.checkItemNum(actor, idx, 1) then
        ZhuangBan.AddFashionToVar(actor, 26021, VarCfg["T_时装记录"])
        ZhuangBan.SetCurrFashion(actor, 26021)
    end
end

-- 夜帝[时装] 26022
function stdmodefunc457(actor, item)
    local idx = getiteminfo(actor, item, ConstCfg.iteminfo.idx)
    if Bag.checkItemNum(actor, idx, 1) then
        ZhuangBan.AddFashionToVar(actor, 26022, VarCfg["T_时装记录"])
        ZhuangBan.SetCurrFashion(actor, 26022)
    end
end

-- 剑仙[时装] 26023
function stdmodefunc458(actor, item)
    local idx = getiteminfo(actor, item, ConstCfg.iteminfo.idx)
    if Bag.checkItemNum(actor, idx, 1) then
        ZhuangBan.AddFashionToVar(actor, 26023, VarCfg["T_时装记录"])
        ZhuangBan.SetCurrFashion(actor, 26023)
    end
end

-- 狩魂[时装] 26020
function stdmodefunc459(actor, item)
    local idx = getiteminfo(actor, item, ConstCfg.iteminfo.idx)
    if Bag.checkItemNum(actor, idx, 1) then
        ZhuangBan.AddFashionToVar(actor, 26020, VarCfg["T_时装记录"])
        ZhuangBan.SetCurrFashion(actor, 26020)
    end
end

-- 狩魂[时装] 26020
function stdmodefunc459(actor, item)
    local idx = getiteminfo(actor, item, ConstCfg.iteminfo.idx)
    if Bag.checkItemNum(actor, idx, 1) then
        ZhuangBan.AddFashionToVar(actor, 26020, VarCfg["T_时装记录"])
        ZhuangBan.SetCurrFashion(actor, 26020)
    end
end

-- 圣诞雪宝[时装] 26028
function stdmodefunc460(actor, item)
    local idx = getiteminfo(actor, item, ConstCfg.iteminfo.idx)
    if Bag.checkItemNum(actor, idx, 1) then
        ZhuangBan.AddFashionToVar(actor, 26028, VarCfg["T_时装记录"])
        ZhuangBan.SetCurrFashion(actor, 26028)
    end
end

-- 暴走甜心[时装] 40181
function stdmodefunc461(actor, item)
    local idx = getiteminfo(actor, item, ConstCfg.iteminfo.idx)
    if Bag.checkItemNum(actor, idx, 1) then  
        ZhuangBan.AddFashionToVar(actor, 40181, VarCfg["T_时装记录"])
        ZhuangBan.SetCurrFashion(actor, 40181)
    end
end

--步步高升[足迹]
function stdmodefunc462(actor, item)
    local idx = getiteminfo(actor, item, ConstCfg.iteminfo.idx)
    if Bag.checkItemNum(actor, idx, 1) then
        ZhuangBan.AddFashionToVar(actor, 63148, VarCfg["T_足迹记录"])
        ZhuangBan.SetCurrFashion(actor, 63148)
    end
end

--圣诞时光[光环]
function stdmodefunc463(actor, item)
    local idx = getiteminfo(actor, item, ConstCfg.iteminfo.idx)
    if Bag.checkItemNum(actor, idx, 1) then
        ZhuangBan.AddFashionToVar(actor, 63151, VarCfg["T_光环记录"])
        ZhuangBan.SetCurrFashion(actor, 63151)
    end
end

-- 圣诞先生[时装] 26026
function stdmodefunc464(actor, item)
    local idx = getiteminfo(actor, item, ConstCfg.iteminfo.idx)
    if Bag.checkItemNum(actor, idx, 1) then  
        ZhuangBan.AddFashionToVar(actor, 26026, VarCfg["T_时装记录"])
        ZhuangBan.SetCurrFashion(actor, 26026)
    end
end

-- 圣诞小姐[时装] 26027
function stdmodefunc465(actor, item)
    local idx = getiteminfo(actor, item, ConstCfg.iteminfo.idx)
    if Bag.checkItemNum(actor, idx, 1) then
        ZhuangBan.AddFashionToVar(actor, 26027, VarCfg["T_时装记录"])
        ZhuangBan.SetCurrFashion(actor, 26027)
    end
end

--使用鱼
function stdmodefunc466(actor, item)
    if not item then
        return
    end
    local itemName = getiteminfo(actor, item, ConstCfg.iteminfo.name)
    local value = cfg_UseItem[itemName]
    if value then
        local itemNum = getiteminfo(actor, item, ConstCfg.iteminfo.overlap)
        if itemNum <= 0 then
            return
        end
        local makeId = getiteminfo(actor, item, ConstCfg.iteminfo.id)
        local total = value.value * itemNum
        local data = splitLargeNumber(2000000000, total)
        if #data > 0 then
            for _, v in ipairs(data) do
                changemoney(actor, 2, "+", v, "使用物品:" .. itemName, true)
            end
            delitembymakeindex(actor, makeId, itemNum, "使用物品")
        end
        Player.sendmsgEx(actor, string.format("[系统提示]：你使用[%s*%d]获得：|[元宝%d]#249", itemName, itemNum, total))
    end
    stop(actor)
end

-- 大富翁礼包
function stdmodefunc467(actor, item)
    local idx = getiteminfo(actor, item, ConstCfg.iteminfo.idx)
    if Bag.checkItemNum(actor, idx, 1) then
        giveitem(actor, "圣诞花环",30, ConstCfg.binding, "大富翁礼包")
        giveitem(actor, "圣诞幸运星",5, ConstCfg.binding, "大富翁礼包")
    end
end
--君临寰宇万古独尊[称号]
function stdmodefunc468(actor, item)
    if checkkuafu(actor) then
        Player.sendmsgEx(actor, "请回本服使用#249")
        stop(actor)
        return
    end
    local idx = getiteminfo(actor, item, ConstCfg.iteminfo.idx)
    if Bag.checkItemNum(actor, idx, 1) then
        if checktitle(actor, "君临寰宇万古独尊") then
            messagebox(actor, "[系统提示]：你已经拥有君临寰宇万古独尊称号！")
            stop(actor)
            return
        else
            confertitle(actor, "君临寰宇万古独尊", 1)
            messagebox(actor, "[系统提示]：成功获得君临寰宇万古独尊称号！")
        end
    end
end

--吾為霜帝·寒封世間众蒼生
function stdmodefunc469(actor, item)
    local idx = getiteminfo(actor, item, ConstCfg.iteminfo.idx)
    if Bag.checkItemNum(actor, idx, 1) then  
        ZhuangBan.AddFashionToVar(actor, 26030, VarCfg["T_时装记录"])
        ZhuangBan.SetCurrFashion(actor, 26030)
        setflagstatus(actor,VarCfg["F_终极时装标识1"],1)
    end
end

--吾為青丘妖帝·魅惑八荒六合
function stdmodefunc470(actor, item)
    local idx = getiteminfo(actor, item, ConstCfg.iteminfo.idx)
    if Bag.checkItemNum(actor, idx, 1) then  
        ZhuangBan.AddFashionToVar(actor, 26029, VarCfg["T_时装记录"])
        ZhuangBan.SetCurrFashion(actor, 26029)
        setflagstatus(actor,VarCfg["F_终极时装标识2"],1)
    end
end

--君临寰宇万古独尊[称号]
function stdmodefunc471(actor, item)
    if checkkuafu(actor) then
        Player.sendmsgEx(actor, "请回本服使用#249")
        stop(actor)
        return
    end
    local idx = getiteminfo(actor, item, ConstCfg.iteminfo.idx)
    if Bag.checkItemNum(actor, idx, 1) then
        if checktitle(actor, "天道酬勤·厚德载物") then
            messagebox(actor, "[系统提示]：你已经拥有天道酬勤·厚德载物称号！")
            stop(actor)
            return
        else
            confertitle(actor, "天道酬勤·厚德载物", 1)
            messagebox(actor, "[系统提示]：成功获得天道酬勤·厚德载物称号！")
        end
    end
end

--天书降临[称号]
function stdmodefunc472(actor, item)
    if checkkuafu(actor) then
        Player.sendmsgEx(actor, "请回本服使用#249")
        stop(actor)
        return
    end
    local titileName = "天书降临"
    local idx = getiteminfo(actor, item, ConstCfg.iteminfo.idx)
    if Bag.checkItemNum(actor, idx, 1) then
        if checktitle(actor, titileName) then
            messagebox(actor, "[系统提示]：你已经拥有" .. titileName .. "称号！")
            stop(actor)
            return
        else
            confertitle(actor, titileName, 1)
            messagebox(actor, "[系统提示]：成功获得" .. titileName .. "称号！")
        end
    end
end
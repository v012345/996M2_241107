--引擎启动
local cfg_MapEffectData = include("QuestDiary/cfgcsv/cfg_MapEffectData.lua") --地图链接点配置文件
function startup()
    for _, v in ipairs(cfg_MapEffectData) do
        mapeffect(10001, v.mapid, v.x, v.y, 17009, -1, 0, nil, 0)
    end

    if getsysvar(VarCfg["G_开区天数"]) == 0 then
        setsysvar(VarCfg["G_开区天数"], 1)
    end
    GameEvent.push(EventCfg.onStartUp)
end

--登陆延迟加载属性
function login_delay_calculation(actor)
    --附加属性
    addhpper(actor, "=", 100)
    addmpper(actor, "=", 100)
end

--登录
function login(actor)
    setcandlevalue(actor, 10)
    local level = getbaseinfo(actor, ConstCfg.gbase.level)  --等级
    local HFcount = tonumber(getconst(actor, "<$HFCOUNT>")) --是否合区
    local accountID = getconst(actor, "<$USERACCOUNT>")
    local isAdmin = checktextlist('..\\QuestDiary\\accountid\\adminuserid.txt', accountID)
    local isLive = checktextlist('..\\QuestDiary\\accountid\\liveuserid.txt', accountID)
    if not isAdmin and not isLive and level < 30 and HFcount > 0 then
        messagebox(actor, "合区后禁止创建新角色，建议去新区激情满满！！")
        kick(actor)
        return
    end

    -- 牛马逆袭修正
    -- local  Num =   getplaydef(actor, VarCfg["U_洗练元宝总数"])
    -- if Num >= 300000 then
    --     local Tbl= Player.getJsonTableByVar(actor, "T74")
    --     if not Tbl["2"] then
    --         Tbl["2"]   = "可领取"
    --     end
    --     Player.setJsonVarByTable(actor, "T74", Tbl)
    -- end

    --幸运项链触发
    -- local num = getplaydef(actor, VarCfg.U_xing_yun)
    -- if num >= 5 then
    --     local Tbl= Player.getJsonTableByVar(actor, "T76")
    --     if not Tbl["5"] then
    --         Tbl["5"]   = "可领取"
    --     end
    --     Player.setJsonVarByTable(actor, "T76", Tbl)
    -- end

    -- local JieBangZhuangTai = getflagstatus(actor, VarCfg["F_解绑状态"])
    -- if JieBangZhuangTai == 1 and  not checktitle(actor, "开括者") then
    --     GameEvent.push(EventCfg.onTeQuankaiTong, actor)
    -- end


    --冠名大哥
    local receive = getflagstatus(actor, VarCfg["F_冠名领取"])
    if receive == 1 then
        sendmsgnew(globalinfo(0), 251, 0,
            "{ 天下动荡，风云聚首！冠名大哥【/FCOLOR=250}{" .. getbaseinfo(actor, 1) .. "/FCOLOR=251}{】霸气登场，全服瞩目，敬请避让/FCOLOR=250}", 1, 5)
    end

    setplaydef(actor, VarCfg.N_cur_level, level)
    --个人变量声明
    GameEvent.push(EventCfg.goPlayerVar, actor)
    --第一次登录
    -- local isnewhuman = getbaseinfo(actor, ConstCfg.gbase.isnewhuman)
    local isnewhumanFlag = getflagstatus(actor, VarCfg.F_is_first_login)
    if isnewhumanFlag == 0 then
        setflagstatus(actor, VarCfg.F_is_first_login, 1)
        GameEvent.push(EventCfg.onNewHuman, actor)
        --开启首饰盒
        setsndaitembox(actor, 1)
        --角色创建时间
        setplaydef(actor, VarCfg.U_create_actor_time, os.time())
        --角色创建时已开服的天数
        local openday = grobalinfo(ConstCfg.global.openday)
        setplaydef(actor, VarCfg.U_create_actor_openday, openday)
        --背包格子
        setbagcount(actor, ConstCfg.bagcellnum)

        --初次登陆添加技能
        for _, skill_id in ipairs(ConstCfg.first_login_addskill) do
            addskill(actor, skill_id, 3)
        end
        sendmsgnew(actor, 250, 0,
            "<提示/FCOLOR=251>:欢迎新晋牛马<[" .. getbaseinfo(actor, ConstCfg.gbase.name) .. "]/FCOLOR=254>来到牛马沉默开启牛马人生...", 0, 1)
        --新人装备
        for _, equip in ipairs(ConstCfg.first_give_equip) do
            giveonitem(actor, equip[1], equip[2], 1, ConstCfg.binding)
        end
        --给予物品
        for _, item in ipairs(ConstCfg.first_give_item) do
            giveitem(actor, item, 1, ConstCfg.binding, "新人给的")
        end
        addhpper(actor, "=", 100)

        --玩家计数
        local playerCount = getsysvar(VarCfg["G_第一个玩家进入"])
        if playerCount < 5 then
            setsysvar(VarCfg["G_第一个玩家进入"], playerCount + 1)
        end

        --设置复活状态
        local Relivetbl = {}
        setplaydef(actor, VarCfg["T_复活状态"], tbl2json(Relivetbl))

        --巨龙觉醒
        giveonitem(actor, 89, "龙族雕石[未觉醒]", 1, 0, "首次打开npc穿戴装备")
        local str = {
            ["cur"] = 0,
            ["max"] = 3888,
            ["name"] = "龙族雕石[未觉醒]",
        }
        setplaydef(actor, VarCfg["T_龙族雕石经验"], tbl2json(str))
    end
    --初始化等级锁等级
    local liveMax = getplaydef(actor, VarCfg["U_等级上限"])
    if liveMax == 0 then
        setplaydef(actor, VarCfg["U_等级上限"], 320)
    end
    --设置等级锁
    setlocklevel(actor, 1, getplaydef(actor, VarCfg["U_等级上限"]))
    --仓库格子
    changestorage(actor, ConstCfg.warehousecellnum)
    --开启泡点
    setautogetexp(actor, 1, 50000, 0, "*", 0, 655350, 100)
    --开启一个定时器
    setontimer(actor, 1, 1, 0, 1)
    setontimer(actor, 104, 60)
    -- ontimer105(actor)
    ontimer105(actor)
    setontimer(actor, 105, 60 * 5)
    --自动拾取
    pickupitems(actor, 0, 10, 500)
    --登录
    GameEvent.push(EventCfg.onLogin, actor)
    --登录附加属性
    -- local loginattrs = {}
    -- GameEvent.push(EventCfg.onLoginAttr, actor, loginattrs)
    -- Player.updateAddr(actor, loginattrs)
    --其他属性加载
    -- GameEvent.push(EventCfg.onOtherAttr, actor)
    --登录完成
    local logindatas = {}
    GameEvent.push(EventCfg.onLoginEnd, actor, logindatas)
    --同步消息
    Message.sendmsg(actor, ssrNetMsgCfg.sync, nil, nil, nil, logindatas)

    setplaydef(actor, VarCfg["N$是否登录完成"], 1)

    -- delaygoto(actor, 1000, "login_delay_calculation")

    -- 管理员名单
    -- if isAdmin then
    --     setgmlevel(actor, 10)
    -- else
    --     setgmlevel(actor, 0)
    -- end
    
    Player.setAttList(actor, "技能威力")
    Player.setAttList(actor, "属性附加")
    Player.setAttList(actor, "爆率附加")
    Player.setAttList(actor, "倍攻附加")
    Player.setAttList(actor, "攻速附加")
    Player.setAttList(actor, "回血计算")
    -----------------------------正式区发刚内测奖励-----------------------------
    -- local Myid = getconst(actor,"$USERACCOUNT")
    -- local list = {"等级记录1","等级记录2","等级记录3","天元大陆","神龙帝国","帝品天命","后天气运1","后天气运2","后天气运3","合格牛马","勤劳牛马","逆袭牛马"}
    -- local jilu_num = 0
    -- local hongbao_num = 0
    -- for k, v in ipairs(list) do
    --     local _value = readini("QuestDiary/测试奖励记录.ini",Myid,v)
    --     local value = _value == "" and 0 or tonumber(_value)
    --     if value >= 10 then
    --         jilu_num = jilu_num + 1
    --     end
    --     hongbao_num = hongbao_num + value
    -- end

    -- if hongbao_num == 0  then return end

    -- local UserId = getconst(actor, "<$USERID>")
    -- if jilu_num >= 8 then
    --     sendmail(UserId, 666888, "公测奖励", "尊敬的内测玩家,辛苦了...","幻·火莲魔童·哪吒[时装]#1#".. ConstCfg.iteminfo.bind .."&勇者好运礼包#1#".. ConstCfg.iteminfo.bind .."&境界丹#5&10元充值红包#".. hongbao_num / 10 .."#".. ConstCfg.iteminfo.bind .."")
    -- else
    --     sendmail(UserId, 666888, "公测奖励", "尊敬的内测玩家,辛苦了...","10元充值红包#".. hongbao_num / 10 .."#".. ConstCfg.iteminfo.bind .."")
    -- end
    -- delinisection("QuestDiary/测试奖励记录.ini",Myid)
    -- updatetongfile('..\\QuestDiary\\测试奖励记录.ini')   --上传通区
    -----------------------------正式区发刚内测奖励-----------------------------
end

-- 寻路触发
local cfg_JinZhiChuanSong = include("QuestDiary/cfgcsv/cfg_JinZhiChuanSong.lua") --禁止传送的地图
function findpathbegin(actor)
    if getplaydef(actor, VarCfg["N$自动寻路禁止QF触发"]) == 1 then
        setplaydef(actor, VarCfg["N$自动寻路禁止QF触发"], 0)
        return
    end
    local mapid = getbaseinfo(actor, ConstCfg.gbase.mapid)
    -----------------------------------↓↓↓↓↓↓GM点击小地图传送↓↓↓↓↓↓-----------------------------------
    if getgmlevel(actor) >= 10 then
        local x = tonumber(getconst(actor, "<$ToPointX>")) or 0
        local y = tonumber(getconst(actor, "<$ToPointY>")) or 0
        if checkkuafu(actor) then
            FBenFuToKuaFuChuanSong(actor, getconst(actor, "<$ToPointX>"), getconst(actor, "<$ToPointY>"))
        else
            mapmove(actor, mapid, x, y)
        end
    end
    -----------------------------------↑↑↑↑↑↑GM点击小地图传送↑↑↑↑↑↑-----------------------------------
    local ChuanSongBuff = hasbuff(actor, 31049)
    if ChuanSongBuff then
        local buffTime = getbuffinfo(actor, 31049, 2)
        Player.sendmsgEx(actor, "传送提示#251|:#255|请在|" .. buffTime .. "秒#249|后再使用...")
    else
        local str = getconst(actor, "<$SCHARM>")
        if str ~= "" then
            local myName = getbaseinfo(actor, ConstCfg.gbase.name)
            if string.find(mapid, myName) then
                Player.sendmsgEx(actor, "副本地图禁止传送#249")
                return
            end
            local isBanChuanSong = cfg_JinZhiChuanSong[mapid]
            if isBanChuanSong then
                Player.sendmsgEx(actor, "当前地图禁止传送#249")
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
            if checktitle(actor, "至尊赞助") then
                buffTime = buffTime - 5
            end
            addbuff(actor, 31049, buffTime)
            if checkitemw(actor, "云履", 1) then --云履 使用传送功能增加[30%]移速3S
                changespeedex(actor, 1, 30, 3)
            end
        end
    end
end

--寻路中断
function findpathstop(actor)
    setplaydef(actor, VarCfg["N$自动寻路结束自动战斗"], 0)
end

--寻路结束
function findpathend(actor)
    if getplaydef(actor, VarCfg["N$自动寻路结束自动战斗"]) == 1 then
        setplaydef(actor, VarCfg["N$自动寻路结束自动战斗"], 0)
        startautoattack(actor)
        return
    end
end

---行会初始化
function loadguild(actor, guildobj)
    guildobj = guildobj or getmyguild(actor)
    if guildobj == "0" then return end
    GameEvent.push(EventCfg.onLoadGuild, actor, guildobj)
end

---解散行会
function guildclose(actor)
    GameEvent.push(EventCfg.onCloseGuild, actor)
end

---退出行会时
function guilddelmember(actor)
    GameEvent.push(EventCfg.onGuilddelMember, actor)
end

local preventFrequentRequestsCache = {}
--消息号白名单
local filterOutMsgid = {
    [11009] = true, --回收
    [11001] = true  --吃货币
}
local cfg_KuaFuJinZhi = include("QuestDiary/cfgcsv/cfg_KuaFuJinZhi.lua")
--所有发送给服务端的网络消息触发
function handlerequest(actor, msgid, arg1, arg2, arg3, sMsg)
    -- LOGPrint("handlerequest", type(msgid),msgid, arg1, arg2, arg3, sMsg)
    --跨服禁止使用
    if cfg_KuaFuJinZhi[msgid] then
        local isKuaFu = checkkuafu(actor)
        if isKuaFu then
            Player.sendmsgEx(actor, "跨服中,禁止使用该功能!#249")
            return
        end
    end
    local lastRequestTime = preventFrequentRequestsCache[actor] or 0
    local currentRequestTime = os.clock()
    if currentRequestTime - lastRequestTime <= 0.2 then
        if not filterOutMsgid[msgid] then
            -- Player.sendmsgEx(actor, "请求频繁#249")
            return
        end
    else
        preventFrequentRequestsCache[actor] = os.clock()
    end

    if msgid == ssrNetMsgCfg.sync then
        login(actor)
        return
    end
    --派发
    local result, errinfo = pcall(Message.dispatch, actor, msgid, arg1, arg2, arg3, sMsg)
    if not result then
        local name = getbaseinfo(actor, ConstCfg.gbase.name)
        local msgName = ssrNetMsgCfg[msgid]
        local err = "网络消息派发错误：消息ID=" .. msgid .. "  消息Name=" .. msgName .. "   "
        release_print(name, err, errinfo, arg1, arg2, arg3, sMsg)
    end
end

--任意地图杀死怪物
---*actor ：触发对象
---*monobj：被杀怪物对象
function killmon(actor, monobj)
    ----------------------------------------鞭尸----------------------------------------
    local _BianShiGaiLv = getbaseinfo(actor, 51, 201) --鞭尸概率
    local BianShiGaiLv = (300 - _BianShiGaiLv <= 200 and 200) or (300 - _BianShiGaiLv)
    if randomex(1, BianShiGaiLv) then
        monitems(actor, 1)
        Player.sendmsgEx(actor, "提示#251|:#255|触发鞭尸大爆|1次#249|...")
        local _LianbaoGaiLv = getbaseinfo(actor, 51, 226) --连爆概率
        local LianbaoGaiLv = (300 - _LianbaoGaiLv <= 200 and 200) or (300 - _LianbaoGaiLv)
        if randomex(1, LianbaoGaiLv) then
            monitems(actor, 1)
            Player.sendmsgEx(actor, "提示#251|:#255|触发连爆再爆|1次#249|...")
        end
        if checkitemw(actor, "鬼魅之宗·七煞灭魂", 1) then
            if randomex(20, 100) then
                monitems(actor, 1)
                Player.sendmsgEx(actor, "提示#251|:#255|触发连爆再爆|1次#249|...")
            end
        end
    end
    ----------------------------------------鞭尸----------------------------------------
    local monName = getbaseinfo(monobj, ConstCfg.gbase.name)
    GameEvent.push(EventCfg.onKillMon, actor, monobj, monName)
end

--杀死人物触发
---*actor：触发对象
---*play：被杀玩家
function killplay(actor, play)
    --透明手镯 杀死人物后触发隐身[2秒]并且恢复 (10%)的最大生命值！[CD:30S]
    if checkitemw(actor, "透明手镯", 1) then
        if not Player.checkCd(actor, VarCfg["隐身CD"], 60, true) then return end

        local buffcd = hasbuff(actor, 30009)
        if not buffcd then
            changemode(actor, 2, 2)                              --隐身2秒钟
            humanhp(actor, "+", Player.getHpValue(actor, 10), 4) --恢复10%最生命值
            addbuff(actor, 30009, 30, 1, actor)
            Player.buffTipsMsg(actor, "[透明手镯]:隐身2秒并恢复自身10%血量...")
        end
    end

    --暗影之缚 杀死人物后触发隐身[2秒]并且恢复(10%)的最大生命值！[CD：30秒]
    if getflagstatus(actor, VarCfg["F_暗影之缚"]) == 1 then
        if not Player.checkCd(actor, VarCfg["隐身CD"], 60, true) then return end
        local buffcd = hasbuff(actor, 30017)
        if not buffcd then
            changemode(actor, 2, 2)                              --隐身2秒钟
            humanhp(actor, "+", Player.getHpValue(actor, 10), 4) --恢复10%最生命值
            Player.buffTipsMsg(actor, "[暗影之缚]:隐身[{2秒/FCOLOR=243}]同时恢复自身[{10%/FCOLOR=243}]生命值...")
            addbuff(actor, 30017, 30, 1, actor)
        end
    end

    --毁灭·魔化天使[吞噬] 杀死人物后恢复[10%]的生命值
    if getconst(actor, "<$SHIELD>") == "毁灭·魔化天使[吞噬]" then
        humanhp(actor, "+", Player.getHpValue(actor, 10), 4)
    end

    -- 【传承】秩序腰带 或者 本源之力   人物永久进入[杀人不红名]状态
    if checkitemw(actor, "【传承】秩序腰带", 1) or checkitemw(actor, "本源之力", 1) then
        setbaseinfo(actor, 46, 100)
    end

    GameEvent.push(EventCfg.onkillplay, actor, play)
    --杀人奇遇触发
    if checkkuafu(actor) then
        FKuaFuToBenFuQiYuTitle(actor, EventCfg.onkillplayQiYu, "")
    else
        GameEvent.push(EventCfg.onkillplayQiYu, actor)
    end
end

--背包神器映射新开的装备格子
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
--角色穿装备前
function takeonbeforeex(actor, itemobj, where, makeIndex)
    if checkkuafu(actor) then
        if not getbaseinfo(actor, ConstCfg.gbase.isdie) then
            Player.sendmsgEx(actor, "跨服中，不允许脱穿装备!#249")
            return false
        end
    end
    local layer1Flag = getplaydef(actor, VarCfg["M_地藏王标识"])
    if layer1Flag > 0 then
        Player.sendmsgEx(actor, "试炼中,不允许脱穿装备!#249")
        return false
    end
    --背包神器判断
    local guGuanmap = {
        ["百年古棺"] = true,
        ["千年古棺"] = true,
        ["万年古棺"] = true,
        ["十万年古棺"] = true,
    }
    --黄沙
    local fengMap = {
        ["飓风之灵"] = true,
        ["[風魂]黃沙之靈"] = true,
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
            Player.sendmsgEx(actor, "已存在相同类型的背包神器,无法放入,请脱下后再次放入!#249")
            return false
        end
        --判断古棺
        if isSameTypeExisting(guGuanmap, equipName) then
            for key, value in pairs(guGuanmap) do
                if FCheckBagEquip(actor, key) then
                    Player.sendmsgEx(actor, "已存在相同类型的背包神器,无法放入,请脱下后再次放入!#249")
                    return false
                end
            end
        end
        --判断黄沙
        if isSameTypeExisting(fengMap, equipName) then
            for key, value in pairs(fengMap) do
                if FCheckBagEquip(actor, key) then
                    Player.sendmsgEx(actor, "已存在相同类型的背包神器,无法放入,请脱下后再次放入!#249")
                    return false
                end
            end
        end
        --判断是否符合到新格子
        local currExtend = getplaydef(actor, VarCfg["U_新加背包神器格子数"])
        local extend = newShenQiWhereMaps[where]
        if extend then
            if currExtend < extend then
                messagebox(actor, "你的背包神器格子已经满了,如需替换其他装备,请先取下")
                return false
            end
        end
    end
end

--角色脱装备前
function takeoffbeforeex(actor, itemobj, where, makeIndex)
    if checkkuafu(actor) then
        if not getbaseinfo(actor, ConstCfg.gbase.isdie) then
            Player.sendmsgEx(actor, "跨服中，不允许脱穿装备!#249")
            return false
        end
    end
    local layer1Flag = getplaydef(actor, VarCfg["M_地藏王标识"])
    if layer1Flag > 0 then
        Player.sendmsgEx(actor, "试炼中,不允许脱穿装备!#249")
        return false
    end
end

--项链穿装备前
function takeonbefore3(actor, itemobj)
    GameEvent.push(EventCfg.onTakeOnNecklace, actor, itemobj)
end

--项链脱装备前
function takeoffbefore3(actor, itemobj)
    GameEvent.push(EventCfg.onTakeOffNecklace, actor, itemobj)
end

--武器穿装备前
function takeonbefore1(actor, itemobj)
    local buff = hasbuff(actor, 30041) --缴械buff 格萨拉克·地渊之声
    if buff then
        Player.sendmsgEx(actor, "提示#251|:#255|当前在|缴械状态#249|穿戴失败...")
        return false
    end
    GameEvent.push(EventCfg.onTakeOnWeapon, actor, itemobj)
end

--武器脱装备前
function takeoffbefore1(actor, itemobj)
    GameEvent.push(EventCfg.onTakeOffWeapon, actor, itemobj)
end

--衣服穿装备前
function takeonbefore0(actor, itemobj)
    GameEvent.push(EventCfg.onTakeOnDress, actor, itemobj)
end

--衣服脱装备前
function takeoffbefore0(actor, itemobj)
    GameEvent.push(EventCfg.onTakeOffDress, actor, itemobj)
end

--捡取任意物品后触发
function pickupitemex(actor, itemobj, itemidx, itemMakeIndex)
    local ItemName = getstditeminfo(itemidx, 1)
    GameEvent.push(EventCfg.goPickUpItemEx, actor, itemobj, itemidx, itemMakeIndex, ItemName)
end

--扔掉任意物品后触发
function dropitemex(actor, itemobj, itemName)
    GameEvent.push(EventCfg.goDropItemEx, actor, itemobj, itemName)
end

--NPC点击触发
local clickNpcCSD = include("QuestDiary/cfgcsv/cfg_ChuanSongDian.lua")
--NPC点击声音
local cfg_NpcDianJiShengYin = include("QuestDiary/cfgcsv/cfg_NpcDianJiShengYin.lua")
function clicknpc(actor, npcid)
    local npcobj = getnpcbyindex(npcid)
    GameEvent.push(EventCfg.onClicknpc, actor, npcid, npcobj)

    --魔法试炼完成检测
    if npcid == 3305 then
        local bool1 = getflagstatus(actor, VarCfg["F_神语的试炼_无尽愤怒"])
        local bool2 = getflagstatus(actor, VarCfg["F_神语的试炼_血魔护臂MAX"])
        if bool1 == 0 or bool2 == 0 then
            messagebox(actor, "神语的试炼未完成，无法进入!")
            return
        end
    elseif npcid == 804 then
        if not checktitle(actor, "圣人之资") then
            messagebox(actor, "你没有获得[圣人之资],无法进入!")
            return
        end
        local mapID = "圣人阁"
        FMapMoveEx(actor, mapID, 45, 30, 0)
    end
    -- Player.sendmsgEx(actor, npcid)
    if npcid > 2999 then
        local cfg = clickNpcCSD[npcid]
        if cfg then
            mapmove(actor, cfg.mapid, cfg.x, cfg.y, cfg.range)
        end
    end
    --播放声音
    local shengYinCfg = cfg_NpcDianJiShengYin[npcid]
    if shengYinCfg then
        playsound(actor, shengYinCfg.soundId, 1, 0)
    end
end

--升级
function playlevelup(actor, level)
    local before_level = getplaydef(actor, VarCfg["U_最大升级过的等级"])
    local cur_level = getbaseinfo(actor, ConstCfg.gbase.level)
    if cur_level > before_level then
        setplaydef(actor, VarCfg["U_最大升级过的等级"], cur_level)
    end
    GameEvent.push(EventCfg.onPlayLevelUp, actor, cur_level, before_level)
end

--小退触发
function playreconnection(actor)
    preventFrequentRequestsCache[actor] = nil --清理防止连点的缓存
    GameEvent.push(EventCfg.onExitGame, actor)
end

--大退与关闭客户端触发
function playoffline(actor)
    preventFrequentRequestsCache[actor] = nil --清理防止连点的缓存
    GameEvent.push(EventCfg.onExitGame, actor)
end

--输入
function triggerchat(actor, sMsg, chat)
    GameEvent.push(EventCfg.onTriggerChat, actor, sMsg, chat)
end

--充值
function recharge(actor, gold, productid, moneyid)
    -- local name = getbaseinfo(actor, ConstCfg.gbase.name)
    -- sendmsg(actor, 1, '{"Msg":"<font color=\'#ff0000\'>玩家'.. name ..'。。。</font>","Type":0}')
    -- sendmsg(actor, 1, '{"Msg":"<font color=\'#ff0000\'>货币'.. moneyid ..'。。。</font>","Type":0}')
    -- sendmsg(actor, 1, '{"Msg":"<font color=\'#ff0000\'>数量'.. gold ..'。。。</font>","Type":0}')
    -- sendmsg(actor, 1, '{"Msg":"<font color=\'#ff0000\'>NPC'.. productid ..'。。。</font>","Type":0}')

    GameEvent.push(EventCfg.onRecharge, actor, gold, productid, moneyid)
end

--人物穿装备----人物穿戴任意装备触发
function takeonex(actor, itemobj, where, itemname, makeid)
    GameEvent.push(EventCfg.onTakeOnEx, actor, itemobj, where, itemname, makeid)
    if itemname == "夜明珠" then
        local level = getbaseinfo(actor, ConstCfg.gbase.level)
        if level >= 320 then
            changelevel(actor, "+", 1)
        end
    elseif itemname == "预言者" then
        setskillinfo(actor, 2013, 2, 1)
    end
end

--人物脱装备---人物脱下任意装备触发
function takeoffex(actor, itemobj, where, itemname, makeid)
    if getplaydef(actor, VarCfg.Die_Flag) == 1 then --死亡爆装备
        local dropinfo = getplaydef(actor, VarCfg.Die_Drop_item)
        if dropinfo == "" then
            dropinfo = itemname .. "[身上]"
        else
            dropinfo = dropinfo .. "，" .. itemname .. "[身上]"
        end
        setplaydef(actor, VarCfg.Die_Drop_item, dropinfo)
    end
    if itemname == "夜明珠" then
        local level = getbaseinfo(actor, ConstCfg.gbase.level)
        if level >= 321 then
            changelevel(actor, "-", 1)
        end
    elseif itemname == "预言者" then
        setskillinfo(actor, 2013, 2, 0)
    end
    GameEvent.push(EventCfg.onTakeOffEx, actor, itemobj, where, itemname, makeid)
end

--穿疾风刻印
function takeon14(actor, itemobj)
    GameEvent.push(EventCfg.onTakeOn14, actor, itemobj)
end

--脱疾风刻印
function takeoff14(actor, itemobj)
    GameEvent.push(EventCfg.onTakeOff14, actor, itemobj)
end

--衣服  0  <$DRESS>
function takeon0(actor, itemobj)
    local itemname = getconst(actor, "<$DRESS>")
    if itemname == "【聖】·天空之翼" then -- 【聖】·天空之翼 穿戴时随机获得[1%-5%]的体力元素
        local addvar = getnewitemaddvalue(itemobj, 7)
        if addvar == 0 then
            local num = math.random(1, 5)
            setnewitemvalue(actor, -2, 7, "+", num, itemobj)
            refreshitem(actor, itemobj)
        end
    end
    GameEvent.push(EventCfg.onTakeOn0, actor, itemobj)
end

--衣服  0  <$DRESS>
function takeoff0(actor, itemobj)
    GameEvent.push(EventCfg.onTakeOff0, actor, itemobj)
end

--武器  1
function takeon1(actor, itemobj)
    local itemname = getiteminfo(actor, itemobj, 7)
    if itemname == "鸣封之刃·永恒" or itemname == "屠龙者之刃" then
        Player.setAttList(actor, "倍攻附加")
    end
end

--武器  1
function takeoff1(actor, itemobj)
    local itemname = getiteminfo(actor, itemobj, 7)
    if itemname == "鸣封之刃·永恒" or itemname == "屠龙者之刃" then
        Player.setAttList(actor, "倍攻附加")
    end
end

--勋章穿戴触发---后
function takeon2(actor, itemobj)
    local itemname = getconst(actor, ConstCfg.equipconst["勋章"])

    -- 生命幻想 穿戴时随机获得[1%-10%]的体力元素
    if itemname == "死神降临" then
        addbuff(actor, 30066)
    end

    -- 闪耀·漆黑之影 穿戴后激活人物[全身黑化]的状态黑化状态下增加(5%)的最大攻击力
    if itemname == "闪耀·漆黑之影" then
        addbuff(actor, 30074)
    end

    Player.setAttList(actor, "回血计算")
end

--勋章脱掉触发---后
function takeoff2(actor, itemobj)
    local itemname = getiteminfo(actor, itemobj, 7)

    -- 死神降临 每隔(60S)增加[10%]的最大攻击力(效果持续20秒)
    if itemname == "死神降临" then
        FkfDelBuff(actor, 30066)
    end

    -- 闪耀·漆黑之影 穿戴后激活人物[全身黑化]的状态黑化状态下增加(5%)的最大攻击力
    if itemname == "闪耀·漆黑之影" then
        FkfDelBuff(actor, 30074)
    end
    Player.setAttList(actor, "回血计算")
end

--头盔穿戴触发---后
function takeon4(actor, itemobj)
    local itemname = getiteminfo(actor, itemobj, 7)
    -- 生命幻想 穿戴时随机获得[1%-10%]的体力元素
    if itemname == "生命幻想" then
        local addvar = getnewitemaddvalue(itemobj, 7)
        if addvar == 0 then
            local num = math.random(1, 10)
            setnewitemvalue(actor, 4, 7, "+", num, itemobj)
        end
    end

    if itemname == "梦魇头冠" then
        addskill(actor, 85, 3)
    end
end

--头盔脱掉触发---后
function takeoff4(actor, itemobj)
    local itemname = getiteminfo(actor, itemobj, 7)
    if itemname == "梦魇头冠" then
        delskill(actor, 85)
    end
end

--------------------------------------------------------------------右戒指---------------------------------------------------------------------------------
--右戒指--穿戴触发---前
function takeonbefore7(actor, itemobj)
    local itemname = getiteminfo(actor, itemobj, 7)
    if itemname == "三魂四魄「元素」" then
        Player.sendmsgEx(actor, "提示#251|:#255|装备|三魂四魄「元素」#249|,只能穿戴在|左手#249|位置...")
        return false
    end

    if itemname == "★★星魂永燃★★" then
        local attr = getbaseinfo(actor, 51, 30)
        if attr < 15 then
            Player.sendmsgEx(actor, "★★星魂永燃★★#251|:#255|人物体力增加元素|低于15%#249|,穿戴失败...")
            return false
        end
    end
end

--右戒指--穿戴触发---后
function takeon7(actor, itemobj)
    local itemname = getiteminfo(actor, itemobj, 7)
    if itemname == "【噬魂】王之孤影" then
        local _table = json2tbl(getcustomitemprogressbar(actor, itemobj, 0)) --获取第一条进度条信息
        if _table.open == 0 then                                             --判断第一条进度条是否开启
            local tbl1 = {
                ["open"] = 1,
                ["show"] = 2,
                ["name"] = "噬魂之力",
                ["color"] = 253,
                ["imgcount"] = 1,
                ["cur"] = 0,
                ["max"] = 100,
                ["level"] = 1,
            }
            local tbl2 = {
                ["open"] = 1,
                ["show"] = 2,
                ["name"] = "噬魂倍攻",
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

    if itemname == "终结者" then
        addbuff(actor, 31062)
    end
end

function takeoff7(actor, itemobj)
    local itemname = getiteminfo(actor, itemobj, 7)
    if itemname == "终结者" then
        FkfDelBuff(actor, 31062)
    end
end

--------------------------------------------------------------------左戒指---------------------------------------------------------------------------------
--左戒指--穿戴触发---前
function takeonbefore8(actor, itemobj)
    local itemname = getiteminfo(actor, itemobj, 7)
    if itemname == "【噬魂】王之孤影" then
        Player.sendmsgEx(actor, "提示#251|:#255|装备|【噬魂】王之孤影#249|,只能穿戴在|右手#249|位置...")
        return false
    end
    if itemname == "★★星魂永燃★★" then
        local attr = getbaseinfo(actor, 51, 30)
        if attr < 15 then
            Player.sendmsgEx(actor, "★★星魂永燃★★#251|:#255|人物体力增加元素|低于15%#249|,穿戴失败...")
            return false
        end
    end
end

--左戒指--穿戴触发---后
function takeon8(actor, itemobj)
    local itemname = getiteminfo(actor, itemobj, 7)
    -- 三魂四魄「元素」 穿戴时随机获得[1%-5%]的体力元素
    if itemname == "三魂四魄「元素」" then
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

    if itemname == "终结者" then
        addbuff(actor, 31062)
    end
end

--左戒指-- 脱装备触发---后
function takeoff8(actor, itemobj)
    local itemname = getiteminfo(actor, itemobj, 7)
    if itemname == "终结者" then
        FkfDelBuff(actor, 31062)
    end
end

--毒符--穿戴触发---后
function takeon9(actor, itemobj)
    local itemname = getconst(actor, "<$BUJUK>")
    -- 黑月·之泪 每天19:00-07:00时间段激活属性：攻击倍数：+ 15%
    if itemname == "黑月·之泪" then
        if checktimeInPeriod(18, 59, 6, 59) then
            Player.setAttList(actor, "倍攻附加")
        end
    end
    GameEvent.push(EventCfg.onTakeOn9, actor, itemobj)
end

--毒符--脱掉触发---后
function takeoff9(actor, itemobj)
    local itemname = getiteminfo(actor, itemobj, 7)

    -- 黑月·之泪 每天19:00-07:00时间段激活属性：攻击倍数：+ 15%
    if itemname == "黑月·之泪" then
        if checktimeInPeriod(18, 59, 6, 59) then
            Player.setAttList(actor, "倍攻附加")
        end
    end


    GameEvent.push(EventCfg.onTakeOff9, actor, itemobj)
end

--腰带--穿戴触发---后
function takeon10(actor, itemobj)
    local itemname = getconst(actor, "<$BELT>")

    -- 天启星魂 十步一杀CD：- 2秒
    -- if itemname == "天启星魂" then
    --     setskilldeccd(actor, "十步一杀", "-", 4)
    -- end
end

--腰带--脱掉触发---后
function takeoff10(actor, itemobj)
    local itemname = getiteminfo(actor, itemobj, 7)

    -- 天启星魂 十步一杀CD：- 2秒
    -- if itemname == "天启星魂" then
    --     setskilldeccd(actor, "十步一杀", "=", 0)
    -- end
end

--靴子穿戴触发---后
function takeon11(actor, itemobj)
    local itemname = getiteminfo(actor, itemobj, 7)
    -- 卧龙战靴 穿戴时随机获得[1%-5%]的体力元素
    if itemname == "卧龙战靴" then
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

    -- 堕落的黑曜战靴 穿戴后体型增大且增加(大量生命值) 生命+30%
    if itemname == "堕落的黑曜战靴" then
        addbuff(actor, 30070)
    end
    GameEvent.push(EventCfg.onTakeOn11, actor, itemobj, itemname)
end

--靴子脱下触发---后
function takeoff11(actor, itemobj)
    local itemname = getiteminfo(actor, itemobj, 7)
    if itemname == "堕落的黑曜战靴" then
        FkfDelBuff(actor, 30070)
    end
    GameEvent.push(EventCfg.onTakeOff11, actor, itemobj, itemname)
end

--法宝穿戴----后
function takeon43(actor, itemobj)
    GameEvent.push(EventCfg.onTakeOn43, actor, itemobj)
end

--法宝脱下----前
function takeoffbefore43(actor, itemobj)
    Player.sendmsgEx(actor, "该位置不允许脱下!")
    return false
end

--时装头盔穿
function takeon21(actor, itemobj)
    GameEvent.push(EventCfg.onTakeOn21, actor, itemobj)
end

--时装头盔脱下
function takeoff21(actor, itemobj)
    GameEvent.push(EventCfg.onTakeOff21, actor, itemobj)
end

--时装头盔穿戴触发---后
function takeon26(actor, itemobj)
    local itemname = getconst(actor, "<$SRIGHTHAND>")
    if not itemname then return end
    if itemname == "古核武·变异基因体" then
        local usenum = getitemaddvalue(actor, itemobj, 2, 19, nil) --获取信息
        if usenum == 0 then                                        --已经使用但是未消失的装备
            local color = { 254, 242, 249, 116, 251 }
            local number = { "①", "②", "③", "④", "⑤" }
            local attnum = math.random(1, 5)
            changeitemname(actor, 26, "古核武·变异基因体[变异" .. number[attnum] .. "]") --修改装备显示名字
            changeitemnamecolor(actor, itemobj, color[attnum]) --修改装备名字颜色
            setitemaddvalue(actor, itemobj, 2, 19, attnum) --设置装备标记次数13（死亡等于=10时 装备消失）
        elseif usenum == 1 then --攻击增加10%上限
            addbuff(actor, 30096)
        elseif usenum == 2 then --全技能冷却CD-2秒
            setskilldeccd(actor, "烈火剑法", "-", 2)
            setskilldeccd(actor, "开天斩", "-", 2)
            setskilldeccd(actor, "逐日剑法", "-", 2)
        elseif usenum == 3 then --人物体型增大增加10%体力
            addbuff(actor, 30097)
        end
    end

    if itemname == "苦修者的秘籍" then
        local usenum = getitemaddvalue(actor, itemobj, 2, 19, nil) --获取信息
        if usenum <= 10 and usenum ~= 0 then --已经使用但是未消失的装备
            return
        elseif usenum == 0 then --第一次穿戴
            changeitemname(actor, 26, "苦修者的秘籍[可使用:3次]") --修改装备显示名字
            changeitemnamecolor(actor, itemobj, 70) --修改装备名字颜色
            setitemaddvalue(actor, itemobj, 2, 19, 13) --设置装备标记次数13（死亡等于=10时 装备消失）
        end
        if Player.Checkskill(actor, "魔法盾") then
            local magiclvevl = getskillinfo(actor, 31, 1)
            setskillinfo(actor, 31, 1, magiclvevl + 1)
        end
    end

    if itemname == "暗黑之神宝藏" then
        local bool = Player.progressbarEX(actor, itemobj, 0, "open", "查询")
        if not bool then
            local tbl = {
                ["open"] = 1, --/0-关闭，1-打开
                ["show"] = 2, --//0-不显示数值，1-百分比，2-数字
                ["name"] = "暗黑之魂:", --//进度条文本
                ["color"] = 250, --//进度条颜色，0~255
                ["imgcount"] = 1, --//图片张数，填1即可
                ["cur"] = 0, --//当前值
                ["max"] = 666, --//最大值
                ["level"] = 0, --//级别(0~65535)
            }
            setcustomitemprogressbar(actor, itemobj, 0, tbl2json(tbl))
            refreshitem(actor, itemobj)
        end
    end
end

--时装头盔穿戴触发---后
function takeoff26(actor, itemobj)
    local itemname = getiteminfo(actor, itemobj, 7)
    if not itemname then return end

    if itemname == "古核武·变异基因体" then
        local usenum = getitemaddvalue(actor, itemobj, 2, 19, nil) --获取信息
        if usenum == 1 then                                        --攻击增加10%上限
            FkfDelBuff(actor, 30096)
        elseif usenum == 2 then                                    --全技能冷却CD-2秒
            setskilldeccd(actor, "烈火剑法", "+", 2)
            setskilldeccd(actor, "开天斩", "+", 2)
            setskilldeccd(actor, "逐日剑法", "+", 2)
        elseif usenum == 3 then --人物体型增大增加10%体力
            FkfDelBuff(actor, 30097)
        end
    end
end

--首饰盒位置9
function takeon38(actor, itemobj)
    local itemname = getconst(actor, "<$GODBLESSITEM9>")
    if not itemname then return end

    if itemname == "强化+9999" then
        local usenum = getitemaddvalue(actor, itemobj, 2, 19, nil) --获取信息
        if usenum <= 10 and usenum ~= 0 then --已经使用但是未消失的装备
            return
        elseif usenum == 0 then --第一次穿戴
            changeitemname(actor, 38, "强化+9999[可使用:3次]") --修改装备显示名字
            changeitemnamecolor(actor, itemobj, 70) --修改装备名字颜色
            setitemaddvalue(actor, itemobj, 2, 19, 13) --设置装备标记次数13（死亡等于=10时 装备消失）
        end
    end
end

--时装马牌  42  <$SHORSE>  <$SHORSEID>
function takeon42(actor, itemobj)
    local itemname = getconst(actor, "<$SHORSE>")
    if itemname == "纯阴之体" then -- 纯阴之体 第一次穿戴时随机获得[1%-15%]的体力元素
        local addvar = getnewitemaddvalue(itemobj, 7)
        if addvar == 0 then
            local num = math.random(1, 15)
            setnewitemvalue(actor, 42, 7, "+", num, itemobj)
        end
    end
end

--首饰盒位置11 40  <$SHORSE>  <$SHORSEID>
function takeon40(actor, itemobj)
    GameEvent.push(EventCfg.onTakeOn40, actor, itemobj)
end

--首饰盒位置11 40  <$SHORSE>  <$SHORSEID>
function takeoff40(actor, itemobj)
    GameEvent.push(EventCfg.onTakeOff40, actor, itemobj)
end

--自定义装备第二个位置  72  <$SHORSE>  <$SHORSEID>
function takeon72(actor, itemobj)
    local itemname = getiteminfo(actor, itemobj, 7)
    --藏地の聚光剑 首次穿戴时随机获得[1-88]点攻击力
    if itemname == "藏地の聚光剑" then
        local attnum = getitemaddvalue(actor, itemobj, 1, 2, 0)
        if attnum == 0 then
            local num = math.random(1, 88)
            setitemaddvalue(actor, itemobj, 1, 2, num)
            refreshitem(actor, itemobj) --刷新物品到前端
        end
    end
    GameEvent.push(EventCfg.onTakeOn72, actor, itemobj, itemname)
end

--自定义装备第二个位置  72  <$SHORSE>  <$SHORSEID>
function takeoff72(actor, itemobj)
    local itemname = getiteminfo(actor, itemobj, 7)
    GameEvent.push(EventCfg.onTakeOff72, actor, itemobj, itemname)
end

--时装头盔脱掉触发---前
function takeoffbefore26(actor, itemobj)
    local itemname = getconst(actor, "<$SRIGHTHAND>")
    if itemname == "苦修者的秘籍" then
        if Player.Checkskill(actor, "魔法盾") then
            local magiclvevl = getskillinfo(actor, 31, 1)
            setskillinfo(actor, 31, 1, magiclvevl - 1)
        end
    end
end

--丢弃物品前触发
function dropitemfrontex(actor, dropItem, itemName)
    if getplaydef(actor, VarCfg.Die_Flag) == 1 then --死亡爆装备
        local dropinfo = getplaydef(actor, VarCfg.Die_Drop_item)
        if dropinfo == "" then
            dropinfo = itemName .. "[背包]"
        else
            dropinfo = dropinfo .. "，" .. itemName .. "[背包]"
        end
        setplaydef(actor, VarCfg.Die_Drop_item, dropinfo)
    end
end

--暴击触发
-- function crittrigger(actor, attack, damage)
--     --减少受到来自怪物的固定伤害
--     -- if getbaseinfo(attack,-1) then  --被攻击的是玩家时
--     --     if not getbaseinfo(actor,-1) then  --攻击的是怪物时时
--     --         local dec_value = getbaseinfo(attack, ConstCfg.gbase.custom_attr, ConstCfg.custom_attr.attr200) or 0
--     --         damage = damage - dec_value
--     --     end
--     -- end
--     -- return damage
-- end

--攻击前触发
--Target	object	受击对象
--Hiter	    object	攻击对象
--MagicId	int	    技能ID
--Damage	int	    伤害
--result	int	    返回值，修改后的伤害
local cfg_monYaZhi = include("QuestDiary/cfgcsv/cfg_TaiYangShengCheng_Mon.lua")                                           -- 配置信息
local cfg_QiXingDamage = { [8] = 7, [7] = 77, [6] = 777, [5] = 7777, [4] = 77777, [3] = 777777, [2] = 7777777, [1] = 77777777 } --七星拱月阵伤害
function attackdamage(actor, Target, Hiter, MagicId, Damage, Model)
    if actor == Target then return end
    if hasbuff(actor, 30020) then return end                                                                                    --如果有这个buff 打断所有触发
    local attackDamageData = { damage = 0 }
    --攻击怪物
    local monName
    local attackType = true
    if getbaseinfo(Target, -1) == false then
        attackType = false
        monName = getbaseinfo(Target, ConstCfg.gbase.name)
        if monName == "火麒麟" then
            if not checktitle(actor, "五行灵体") then
                Player.sendmsgEx(actor, "你没有|五行灵体#249|称号，无法对|火麒麟#249|造成伤害")
                return 0
            end
        elseif monName == "沉船遗物" then
            if checkitemw(actor, "潮影钩矛", 1) then
                return 20000
            else
                return 100
            end
        elseif monName == "〈〈〈〈太阴·星君〉〉〉〉" then
            local MonNum = getmoncount("七星拱月阵", -1, true)
            local QiXingDamage = cfg_QiXingDamage[MonNum]
            return QiXingDamage
        end
        local BuZaoChengEWaiShangHai = cfg_BuZaoChengEWaiShangHai[monName]
        if not BuZaoChengEWaiShangHai then
            GameEvent.push(EventCfg.onAttackDamageMonster, actor, Target, Hiter, MagicId, Damage, Model, attackDamageData)
        end
        --攻击人
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
    -- 伤害压制
    local cfg = cfg_monYaZhi[monName]
    if cfg then
        local AttNum = getplaydef(actor, VarCfg["U_日耀结界_伤害压制"])
        AttNum = AttNum / 100
        currDamage = currDamage - (currDamage * (0.9 - AttNum))
    end
    return math.ceil(currDamage)
end

--攻击触发怪物名映射函数
local attackMonFunc = {
    ["火麒麟"] = function(actor)
        if not checktitle(actor, "五行灵体") then
            return false
        end
    end,
    ["牛马发财树"] = function(actor)
        changemoney(actor, 2, "+", 100, "100", true)
        return false
    end
}
local cfg_BuBeiQieGeMon = include("QuestDiary/cfgcsv/cfg_BuBeiQieGeMon.lua")   --不吃切割的怪物
local cfg_GuaiWuFanShang = include("QuestDiary/cfgcsv/cfg_GuaiWuFanShang.lua") --反伤的怪物
--普通攻击触发
---* actor:玩家对象
---* Target：受击对象
---* Hiter：攻击对象
---* MagicId：技能ID
function attack(actor, Target, Hiter, MagicId)
    if actor == Target then return end
    -- FAddBuffKF(actor, 10001, 3)       --跨服战斗状态
    addbuff(actor, 10001, 3)                 --本服战斗状态
    if MagicId == 2013 then return end
    if hasbuff(actor, 30020) then return end --如果有这个buff 打断所有触发
    --攻击怪物
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
        --攻击人
        --反伤怪
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
            humanhp(actor, "-", damage, 111, 0, Target) --反伤
        end
    else
        GameEvent.push(EventCfg.onAttackPlayer, actor, Target, Hiter, MagicId)
    end
    GameEvent.push(EventCfg.onAttack, actor, Target, Hiter, MagicId)
end

--自身使用任意技能前触发
function beginmagic(actor, MagicId, maigicName, target, x, y)
    if MagicId == 2013 then
        if getbaseinfo(target, -1) then
            return false
        end
    end
    -- local isFengYin = (os.time() - getplaydef(actor, "N$狂热野蛮锁定CD")) <= 2
    -- if isFengYin then
    --     Player.sendmsgEx(actor, "提示#251|:#255|你当前处于|技能封印#249|状态中...")
    --     return false
    -- end --如果有这个buff 打断所有触发

    -- local isFengYinLieHuo = (os.time() - getplaydef(actor, VarCfg["N$烈火封印CD"])) <= 2
    -- if isFengYinLieHuo then
    --     if MagicId == 26 then
    --         Player.sendmsgEx(actor, "提示#251|:#255|你当前处于|技能封印#249|状态中...")
    --         return false
    --     end
    -- end
    -- GameEvent.push(EventCfg.onBeginMagic, actor, MagicId, maigicName, target, x, y)
end

--魔法攻击触发
-- function magicattack(actor, Target, Hiter, MagicId)
--     if hasbuff(actor, 30020) then return end --如果有这个buff 打断所有触发
--     --攻击怪物
--     if getbaseinfo(Target, -1) == false then
--         local monName = getbaseinfo(Target, ConstCfg.gbase.name)
--         local BuZaoChengEWaiShangHai = cfg_BuZaoChengEWaiShangHai[monName]
--         if BuZaoChengEWaiShangHai then
--             return
--         end
--         GameEvent.push(EventCfg.onAttackMonster, actor, Target, Hiter, MagicId)
--     end
-- end

--使用寂灭归墟
function magtagfunc2023(actor, Target)
    GameEvent.push(EventCfg["使用寂灭归墟"], actor, Target)
    GameEvent.push(EventCfg["使用技能通用派发"], actor, 2023)
end

--使用十步一杀
function magtagfunc82(actor, Target)
    GameEvent.push(EventCfg["使用十步一杀"], actor, Target)
    GameEvent.push(EventCfg["使用技能通用派发"], actor, 82)
end

--使用野蛮对人
function magtagfunc27(actor, Target)
    GameEvent.push(EventCfg["使用野蛮对人"], actor, Target)
    GameEvent.push(EventCfg["使用技能通用派发"], actor, 27)
end

--使用野蛮空放
function magselffunc27(actor)
    GameEvent.push(EventCfg["使用技能通用派发"], actor, 27)
end

--释放倚天辟地
function magselffunc114(actor)
    GameEvent.push(EventCfg["使用技能通用派发"], actor, 114)
end
--使用分身术
function magselffunc2014(actor)
    releasemagic(actor, 74, 1, 3, 2, 0)
    GameEvent.push(EventCfg["使用技能通用派发"], actor, 2014)
end

--使用燃烧法则
function magselffunc2020(actor)
    GameEvent.push(EventCfg["使用燃烧法则"], actor)
    GameEvent.push(EventCfg["使用技能通用派发"], actor, 2020)
end

--被攻击普通
function struck(actor, Target, Hiter, MagicId)
    if hasbuff(actor, 30020) then return end --如果有这个buff 打断所有触发
    --被怪物攻击
    if getbaseinfo(Target, -1) == false then
        local monName = getbaseinfo(Target, ConstCfg.gbase.name)
        local BuZaoChengEWaiShangHai = cfg_BuZaoChengEWaiShangHai[monName]
        if BuZaoChengEWaiShangHai then
            return
        end
        GameEvent.push(EventCfg.onStruckMonster, actor, Target, Hiter, MagicId)
        --被人攻击
    else
        GameEvent.push(EventCfg.onStruckPlayer, actor, Target, Hiter, MagicId)
    end
    GameEvent.push(EventCfg.onStruck, actor, Target, Hiter, MagicId)
end

--被攻击魔法
function magicstruck(actor, Target, Hiter, MagicId)
    if hasbuff(actor, 30020) then return end --如果有这个buff 打断所有触发
    --攻击怪物
    if getbaseinfo(Target, -1) == false then
        --攻击人
    else
        addbuff(actor, 10001, 3) --战斗状态
    end
end

--枚举元婴状态免疫的技能
local immunityMagicId = {
    [26] = 1,
    [56] = 1,
    [66] = 1,
    [82] = 1,
    [114] = 1,
}
--被攻击前触发
function struckdamage(actor, Target, Hiter, MagicId, Damage)
    if hasbuff(actor, 30020) then return end --如果有这个buff 打断所有触发
    -- +是免伤
    -- -是增伤害
    local attackDamageData = { damage = 0 }
    local isPlayer = getbaseinfo(Target, -1)
    --被怪物攻击
    if isPlayer == false then
        GameEvent.push(EventCfg.onStruckDamageMonster, actor, Target, Hiter, MagicId, Damage, attackDamageData)
        --被人攻击
    else
        GameEvent.push(EventCfg.onStruckDamagePlayer, actor, Target, Hiter, MagicId, Damage, attackDamageData)
        if checkkuafu(actor) then
            FAddBuffKF(actor, 10001, 3)
        else
            addbuff(actor, 10001, 3) --战斗状态
        end
    end
    GameEvent.push(EventCfg.onStruckDamage, actor, Target, Hiter, MagicId, Damage, attackDamageData)
    local finalDamage = Damage - attackDamageData.damage
    --元婴状态
    if immunityMagicId[MagicId] then
        if hasbuff(actor, 30099) then
            finalDamage = 0
        end
    end
    if getflagstatus(actor, VarCfg["F_天命_天人转世标识"]) == 1 then
        local myMaxHp = getbaseinfo(actor, ConstCfg.gbase.maxhp)
        local percentage = calculatePercentage(finalDamage, myMaxHp)
        if percentage >= 33 then
            local currDame = math.ceil(Player.getHpValue(actor, 33))
            Player.buffTipsMsg(actor, "[天人转世]:为你抵挡了{" .. finalDamage - currDame .. "/FCOLOR=249}点伤害!")
            finalDamage = currDame
        end
    end
    if isPlayer then
        local targetHunZhuangLevel = getplaydef(Target, VarCfg["U_魂装等级"]) --攻击者魂装等级
        if targetHunZhuangLevel > 0 then
            local myHunZhuangLevel = getplaydef(actor, VarCfg["U_魂装等级"]) --我的魂装等级
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
    --星辉的祷告乀  8%概率格挡一切伤害
    if getplaydef(actor, VarCfg["S$星辉的祷告"]) == "格挡" then
        finalDamage = 0
        setplaydef(actor, VarCfg["S$星辉的祷告"], "")
    end
    if hasbuff(actor, 31101) then
        finalDamage = 0
    end
    return finalDamage
end

--穿套装
function groupitemonex(actor, idx)
    --登陆时重新统计下生效套装
    local longinTmpIdx = Player.getJsonTableByVar(actor, "S$套装记录")
    table.insert(longinTmpIdx, idx)
    Player.setJsonVarByTable(actor, "S$套装记录", longinTmpIdx)
    if getplaydef(actor, VarCfg["N$是否登录完成"]) == 1 then
        local suitIds = Player.getJsonTableByVar(actor, VarCfg["T_记录套装ID"])
        table.insert(suitIds, idx)
        table.uniqueArray(suitIds)
        Player.setJsonVarByTable(actor, VarCfg["T_记录套装ID"], suitIds)
        GameEvent.push(EventCfg.onGroupItemOnEx, actor, idx)
    end
end

--脱套装
function groupitemoffex(actor, idx)
    if getplaydef(actor, VarCfg["N$是否登录完成"]) == 1 then
        local suitIds = Player.getJsonTableByVar(actor, VarCfg["T_记录套装ID"])
        table.removebyvalue(suitIds, idx)
        table.uniqueArray(suitIds)
        Player.setJsonVarByTable(actor, VarCfg["T_记录套装ID"], suitIds)
        GameEvent.push(EventCfg.onGroupItemOffEx, actor, idx)
    end
end

-- --转换套装 穿戴
function groupitemon398(actor, idx)
    local hpmax = getbaseinfo(actor, ConstCfg.gbase.maxhp)
    local dcnum = hpmax / 100
    if dcnum > 2000 then
        dcnum = 2000
    end
    addattlist(actor, "转换套装", "+", "3#4#" .. math.floor(dcnum) .. "", 1)
end

-- --转换套装 脱掉
function groupitemoff398(actor, idx)
    delattlist(actor, "转换套装")
end

-- 天机套装 穿戴
function groupitemon480(actor, idx)
    addbuff(actor, 30080)
end

-- 天机套装 脱掉
function groupitemoff480(actor, idx)
    delbuff(actor, 30080)
    setplaydef(actor, VarCfg["S$_天机状态"], "") --设置下次伤害开关
    clearplayeffect(actor, 16016)
end

-- 天启星魂 穿戴
function groupitemon782(actor, idx)
    setskilldeccd(actor, "十步一杀", "-", 2)
end

-- 天启星魂 脱掉
function groupitemoff782(actor, idx)
    setskilldeccd(actor, "十步一杀", "=", 0)
end

--延迟照明
function yan_chi_zhao_ming(actor)
    setcandlevalue(actor, 100)
end

-- 夜明珠 穿戴
function groupitemon814(actor, idx)
    delaygoto(actor, 100, "yan_chi_zhao_ming")
end

--夜明珠 脱掉
function groupitemoff814(actor, idx)
    if not checkitemw(actor, "夜明珠", 1) and not checkitemw(actor, "新月宝珠", 1) and not checkitemw(actor, "妖月内胆", 1) then
        setcandlevalue(actor, 10)
    end
end

-- 新月宝珠 穿戴
function groupitemon837(actor, idx)
    delaygoto(actor, 500, "yan_chi_zhao_ming")
end

--新月宝珠 脱掉
function groupitemoff837(actor, idx)
    if not checkitemw(actor, "夜明珠", 1) and not checkitemw(actor, "新月宝珠", 1) and not checkitemw(actor, "妖月内胆", 1) then
        setcandlevalue(actor, 10)
    end
end

-- 妖月内丹 穿戴
function groupitemon838(actor, idx)
    delaygoto(actor, 500, "yan_chi_zhao_ming")
end

--妖月内丹 脱掉
function groupitemoff838(actor, idx)
    if not checkitemw(actor, "夜明珠", 1) and not checkitemw(actor, "新月宝珠", 1) and not checkitemw(actor, "妖月内胆", 1) then
        setcandlevalue(actor, 10)
    end
end

-- ★★星魂永燃★★ 穿戴
function groupitemon930(actor, idx)
    addbuff(actor, 31082)
end

--★★星魂永燃★★ 脱掉
function groupitemoff930(actor, idx)
    delbuff(actor, 31082)
end

-- 悟道神带 穿戴
function groupitemon936(actor, idx)
    addbuff(actor, 31088)
end

-- 悟道神带 脱掉
function groupitemoff936(actor, idx)
    delbuff(actor, 31088)
end

-- 黑刀·夜 穿戴
function groupitemon964(actor, idx)
    addbuff(actor, 31105)
end

-- 黑刀·夜 脱掉
function groupitemoff964(actor, idx)
    delbuff(actor, 31105)
end

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- 卐卐正道鏡卐卐  卐卐提魂锁卐卐  每3点暴击概率可额外增加1点攻击伤害元素 2件触发
function groupitemon959(actor, idx)
    local baoji = getbaseinfo(actor, 51, 21) --获取暴击
    local tmpBaoJi = gethumnewvalue(actor, 21) --获取临时暴击
    if tmpBaoJi > 0 then --如果临时暴击大于0 则减去临时暴击
        baoji = baoji - tmpBaoJi
    end
    if baoji <= 0 then --如果暴击小于等于0 则不触发
        return
    end
    delattlist(actor, "正道套属性") --属性组
    local att = math.floor(baoji / 3)
    if att >= 1 then
        addattlist(actor, "正道套属性", "=", "3#25#" .. att .. "", 1)
    end
end

-- 卐卐正道鏡卐卐  卐卐提魂锁卐卐  每3点暴击概率可额外增加1点攻击伤害元素 2件触发
function groupitemoff959(actor, idx)
    delattlist(actor, "正道套属性") --属性组
end

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- △△雷道天卷△△|△△玄天令△△   "对怪伤害总值提高三分之一 至多提高100% 10%概率切割怪物1%血量 怪物血量低于40%时失效"
function groupitemon960(actor, idx)
    delattlist(actor, "雷道套属性") --属性组
    local AttrNum75 = getbaseinfo(actor, 51, 75) --75号属性 对怪增伤
    local _att = math.floor(AttrNum75 * 0.333)
    local att = (_att >= 100 and 100) or _att
    if att >= 1 then
        addattlist(actor, "雷道套属性", "=", "3#75#" .. att .. "", 1)
    end
end

-- △△雷道天卷△△|△△玄天令△△   "对怪伤害总值提高三分之一 至多提高100% 10%概率切割怪物1%血量 怪物血量低于40%时失效"
function groupitemoff960(actor, idx)
    delattlist(actor, "雷道套属性") --属性组
end

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- ▲▲火雲真經▲▲|▲▲水鏡太極▲▲ 增加2%神力倍功增加2%伤害吸收
function groupitemon961(actor, idx)
    delattlist(actor, "火雲套属性") --属性组
    local RenewLevel = getbaseinfo(actor, ConstCfg.gbase.renew_level)
    addattlist(actor, "火雲套属性", "=", "3#26#" .. RenewLevel * 2 .. "", 1) --物理伤害减少
    Player.setAttList(actor, "倍攻附加")
end

-- ▲▲火雲真經▲▲|▲▲水鏡太極▲▲ 增加2%神力倍功增加2%伤害吸收
function groupitemoff961(actor, idx)
    delattlist(actor, "火雲套属性") --属性组
    Player.setAttList(actor, "倍攻附加")
end

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- 神之■庇护  若人物为 圣人之姿  则额外增加10%全属性
function groupitemon963(actor, idx)
    delattlist(actor, "神之■庇护属性") --属性组
    if checktitle(actor, "圣人之资") then
        addattlist(actor, "神之■庇护属性", "=", "3#207#10|3#208#10|3#209#10|3#210#10|3#211#10|3#212#10|3#213#10|3#214#10", 1)
    end
end

-- 神之■庇护  若人物为 圣人之姿  则额外增加10%全属性
function groupitemoff963(actor, idx)
    delattlist(actor, "神之■庇护属性") --属性组
end

--切换地图
function entermap(actor, mapId, x, y)
    local former_mapid = getplaydef(actor, VarCfg.S_cur_mapid)
    local cur_mapid = mapId
    if cur_mapid ~= former_mapid then --切换了地图
        setplaydef(actor, VarCfg.S_cur_mapid, cur_mapid)
        GameEvent.push(EventCfg.goSwitchMap, actor, cur_mapid, former_mapid, x, y)
    else
        GameEvent.push(EventCfg.goEnterMap, actor, cur_mapid, x, y)
    end
end

--人物离开地图触发
function leavemap(actor, mapId, x, y)
    GameEvent.push(EventCfg.goLeaveMap, actor, mapId, x, y)
end

--人物死亡之前触发
function nextdie(actor, hiter, isplay)
    --死神代言人 复活状态不可用时可获得一次原地重生的机会！(300秒只触发一次BUFF)
    if checkitemw(actor, "死神代言人", 1) then
        if not ReliveMain.GetReliveState(actor) then --判定复活状态
            if randomex(20, 100) then
                if Player.checkCd(actor, VarCfg["死神代言人CD"], 300, true) then
                    changemode(actor, 23, 1, 1, 1) --添加复活状态
                    Player.buffTipsMsg(actor, "[死神代言人]:获得{原地重生/FCOLOR=243}效果,{300/FCOLOR=243}秒内只能触发一次...")
                    return
                end
            end
        end
    end

    --【EX级】冰火之羽 当人物死亡时激活[原地复活]的效果并且激活(无敌状态)1秒！(CD500秒)
    if getflagstatus(actor, VarCfg["F_【EX级】冰火之羽"]) == 1 then
        if randomex(20, 100) then
            if Player.checkCd(actor, VarCfg["冰火之羽CD"], 500, true) then
                changemode(actor, 23, 1, 1, 1)    --添加复活状态
                changemode(actor, 1, 1, nil, nil) --无敌1秒
                Player.buffTipsMsg(actor, "[【EX级】冰火之羽]:{复活/FCOLOR=243}人物并无敌{1/FCOLOR=243}秒...")
                return
            end
        end
    end

    --降星者 死亡后有[33%]的概率满血原地复活复活后每秒恢复[33%]的最大生命值(回血效果持续3S·BUFF冷却：180S)
    if checkitemw(actor, "降星者", 1) then
        if randomex(1, 3) then
            if Player.checkCd(actor, VarCfg["降星者CD"], 180, true) then
                changemode(actor, 23, 1, 1, 1)     --添加复活状态
                addbuff(actor, 30068, 3, 1, actor) --回血buff
                Player.buffTipsMsg(actor, "[降星者]:复活之力触发并每秒恢复[{33%/FCOLOR=243}]的生命值,持续[{3/FCOLOR=243}]秒...")
                return
            end
        end
    end

    --异空：千年之光 人物复活后能进入[无敌状态]1秒钟 当死亡时有(50%)的概率可原地重生，冷却时间90秒
    if getflagstatus(actor, VarCfg["F_千年之光"]) == 1 then
        if randomex(1, 2) then
            if Player.checkCd(actor, VarCfg["千年之光CD"], 90, true) then
                changemode(actor, 23, 1, 1, 1) --添加复活状态
                changemode(actor, 1, 1)
                playeffect(actor, 16022, -10, -10, 1, 0, 0) --添加无敌特效
                Player.buffTipsMsg(actor, "[异空：千年之光]:复活之力触发无敌[{1/FCOLOR=243}]秒...") --无敌1秒
                return
            end
        end
    end

    --气运：归来仍是少年 死亡50%概率原地复活，冷却时间90秒
    if getflagstatus(actor, VarCfg["F_天命归来仍是少年"]) == 1 then
        if randomex(1, 2) then
            if Player.checkCd(actor, VarCfg["归来仍是少年CD"], 90, true) then
                changemode(actor, 23, 1, 1, 1) --添加复活状态
                Player.buffTipsMsg(actor, "[归来仍是少年]:气运触发原地站起来了...")
                return
            end
        end
    end

    --事件派发
    GameEvent.push(EventCfg.onNextDie, actor)
end

--死亡触发
---* actor：被杀死的玩家
---* hiter：杀人的玩家
function playdie(actor, hiter)
    local suitIds = Player.getJsonTableByVar(actor, VarCfg["T_记录套装ID"])
    local isdie = getbaseinfo(actor, ConstCfg.gbase.isdie)
    --LOGPrint("死亡状态",isdie)
    -- Die.OpenUI(actor, hiter)
    --邮件提示
    local uid = getbaseinfo(actor, ConstCfg.gbase.id)
    local time = os.date("%Y-%m-%d %H:%M:%S", os.time())
    local map_title = getbaseinfo(actor, ConstCfg.gbase.map_title)
    local map_id = getbaseinfo(actor, ConstCfg.gbase.mapid)

    local x, y = getbaseinfo(actor, ConstCfg.gbase.x), getbaseinfo(actor, ConstCfg.gbase.y)
    local hitername = Player.GetNameEx(hiter)
    local dropinfo = getplaydef(actor, VarCfg.Die_Drop_item)
    setplaydef(actor, VarCfg.Die_Drop_item, "")
    setplaydef(actor, VarCfg.Die_Flag, 0)

    if getplaydef(actor, VarCfg["N$是否被破复活"]) == 1 then
        sendcentermsg(actor, 250, 0, string.format("系统提示：你被玩家{[%s]/FCOLOR=249}破复活了!!!", hitername), 0, 8)
        sendcentermsg(actor, 250, 0, string.format("系统提示：你被玩家{[%s]/FCOLOR=249}破复活了!!!", hitername), 0, 8)
        setplaydef(actor, VarCfg["N$是否被破复活"], 0)
    end

    if dropinfo == "" then --没爆物品
        FSendmail(uid, 91, time, map_title, x, y, hitername)
    else
        local dropinfoTable = string.split(dropinfo, "，")
        --处理重复
        local i = 1
        while i < #dropinfoTable do
            local strTmp = string.gsub(dropinfoTable[i + 1], "%[身上%]", "")
            if string.find(dropinfoTable[i], strTmp, 1, true) then
                table.remove(dropinfoTable, i)
                i = i + 1
            else
                i = i + 2
            end
        end
        dropinfo = table.concat(dropinfoTable, "，")
        FSendmail(uid, 89, time, map_title, x, y, hitername, dropinfo)
    end

    if getconst(actor, "<$SRIGHTHAND>") == "苦修者的秘籍" then
        local itemobj = linkbodyitem(actor, 26)
        local usenum = getitemaddvalue(actor, itemobj, 2, 19) --获取信息
        usenum = usenum - 1
        if usenum >= 11 then
            local _usenum = usenum - 10
            changeitemname(actor, 26, "苦修者的秘籍[可使用:" .. _usenum .. "次]") --修改装备显示名字
            setitemaddvalue(actor, itemobj, 2, 19, usenum) --设置装备标记次数13（死亡等于=10时 装备消失）
        else
            takew(actor, "苦修者的秘籍", 1)
            sendmail(getbaseinfo(actor, 2), 20000, "苦修者的秘籍", "你的【苦修者的秘籍】已经使用3次后破碎了...", nil)
        end
    end

    --远行的召唤  当人物死亡时会对3*3范围内的全部目标造成攻击力[333%]的伤害!
    if getflagstatus(actor, VarCfg["F_远行的召唤"]) == 1 then
        local selfdc = getbaseinfo(actor, ConstCfg.gbase.dc2)
        local x, y = getbaseinfo(actor, ConstCfg.gbase.x), getbaseinfo(actor, ConstCfg.gbase.y)
        rangeharm(actor, x, y, 3, selfdc * 3.33, 0, nil, nil, 0, nil)
    end


    if table.contains(suitIds, tostring(602)) then
        local tgtname = getbaseinfo(hiter, ConstCfg.gbase.name)
        setplaydef(actor, VarCfg["S$_死亡笔记标记"], tgtname)
    end

    --复活
    Die.RequestRevive(actor, time, map_title, map_id, x, y, hitername)

    --事件派发
    GameEvent.push(EventCfg.onPlaydie, actor, hiter)
    --死亡奇遇触发
    if checkkuafu(actor) then
        FKuaFuToBenFuQiYuTitle(actor, EventCfg.onPlaydieQiYu, "")
    else
        GameEvent.push(EventCfg.onPlaydieQiYu, actor)
    end
end

--复活触发
function revival(actor)
    ---- 复活提示 ----
    setflagstatus(actor, VarCfg["F_人物死亡"], 0) --清除死亡标记
    setplaydef(actor, VarCfg.Die_Flag, 0) --清除死亡标记
    setplaydef(actor, VarCfg["N$是否被破复活"], 0) --复活了就没有破复活
    sendmsg(actor, 1, '{"Msg":"<font color=\'#ff0000\'>复活了人物...</font>","Type":0}')
    playeffect(actor, 63059, 0, 0, 1, 1, 0)
    GameEvent.push(EventCfg.onRevive, actor)
end

--角色获取经验前触发
function getexp(actor, exp)
    local expAddition = (getbaseinfo(actor, ConstCfg.gbase.custom_attr, 203) + 100) / 100
    exp = exp * expAddition
    return exp
end

--属性改变触发
function sendability(actor)
    GameEvent.push(EventCfg.onSendAbility, actor)
end

--攻城开始触发
function castlewarstart()
    sendmsg("0", 2,
        '{"Msg":"岁月不改当年激情！兄弟携手共战沙城！攻沙已开启，请各行会踊跃参与！！！","FColor":249,"BColor":0,"Type":5,"Time":3,"SendName":"xxx","SendId":"123","Y":"30"}')
    sendmsg("0", 2,
        '{"Msg":"岁月不改当年激情！兄弟携手共战沙城！攻沙已开启，请各行会踊跃参与！！！","FColor":249,"BColor":0,"Type":5,"Time":3,"SendName":"xxx","SendId":"123","Y":"60"}')
    sendmsg("0", 2,
        '{"Msg":"岁月不改当年激情！兄弟携手共战沙城！攻沙已开启，请各行会踊跃参与！！！","FColor":249,"BColor":0,"Type":5,"Time":3,"SendName":"xxx","SendId":"123","Y":"90"}')
    GameEvent.push(EventCfg.gocastlewarstart)
end

--攻城结束触发
function castlewarend()
    setontimerex(24, 2)
    sendmsg("0", 2,
        '{"Msg":"沙巴克攻城战已结束！！！","FColor":249,"BColor":0,"Type":5,"Time":3,"SendName":"xxx","SendId":"123","Y":"30"}')
    sendmsg("0", 2,
        '{"Msg":"沙巴克攻城战已结束！！！","FColor":249,"BColor":0,"Type":5,"Time":3,"SendName":"xxx","SendId":"123","Y":"60"}')
    sendmsg("0", 2,
        '{"Msg":"沙巴克攻城战已结束！！！！","FColor":249,"BColor":0,"Type":5,"Time":3,"SendName":"xxx","SendId":"123","Y":"90"}')
    setsysvar(VarCfg["G_是否开启攻沙"], 0)
    GameEvent.push(EventCfg.goCastlewarend)
end

--沙巴克进皇宫走步触发
-- function mapeventwalk(actor) --攻城开启 在攻城区域内移动触发
--     GameEvent.push(EventCfg.gomapeventwalk, actor)
-- end

--增加称号触发
function titlechangedex(actor, titleIdx)
    local custom = getstditeminfo(titleIdx, ConstCfg.stditeminfo.custom29)
    if custom ~= "" then
        local customArr = string.split(custom, "#")
        local where = tonumber(customArr[1])
        local resName = tonumber(customArr[2])
        seticon(actor, where, 1, resName)
    end
end

--取下称号触发
function untitledex(actor, titleIdx)
    local custom = getstditeminfo(titleIdx, ConstCfg.stditeminfo.custom29)
    if custom ~= "" then
        local customArr = string.split(custom, "#")
        local where = tonumber(customArr[1])
        seticon(actor, where, -1)
    end
end

--查看他人装备触发
function lookhuminfo(actor, name)
    local Target = getplayerbyname(name)
    -- if getconst(Target, "<$HAT>") == "神秘人斗笠" then
    --     openhyperlink(Target, 1, 2)
    --     Player.sendmsgEx(actor, "提示#251|:#255|对方是|神秘人#249|无法查看装备信息...")
    --     return
    -- end
    if checkkuafu(actor) then
        return
    end
    GameEvent.push(EventCfg.Myonlookhuminfo, actor, Target)  --自己触发
    GameEvent.push(EventCfg.Tgtonlookhuminfo, Target, actor) --他人触发
end

--限时物品到期触发
---* actor:	玩家对象
---* item:	物品对象
---* name:	物品名字
function itemexpired(actor, item, name)
    local TitleName = getconst(actor, "<$ExpiredItemName>")

    local puTongIndexMax = 59    --普通的索引上限
    local shenShengIndexMax = 18 --神圣索引上限
    local chuanShiIndexMax = 18  --传世索引上限
    local cfg = include("QuestDiary/cfgcsv/cfg_JieFengJianLingJiangLi.lua")
    if name == "被封印的剑灵(A)" then
        local item1 = cfg[math.random(1, puTongIndexMax)].putong
        sendmail(getbaseinfo(actor, 2), 10000, "被封印的剑灵(A)", "恭喜你,解封【被封印的剑灵(A)】获得" .. item1 .. "x1", item1 .. "#1#0")
        return
    end

    if name == "被封印的剑灵(S)" then
        local item1 = cfg[math.random(1, puTongIndexMax)].putong
        local item2 = cfg[math.random(1, puTongIndexMax)].putong
        sendmail(getbaseinfo(actor, 2), 10000, "被封印的剑灵(S)", "恭喜你,解封【被封印的剑灵(S)】获得" .. item1 .. "x1" .. item2 .. "x1",
            item1 .. "#1#0&" .. item2 .. "#1#0")
        return
    end

    if name == "被封印的剑灵(SR)" then
        local item1 = cfg[math.random(1, puTongIndexMax)].putong
        local item2 = cfg[math.random(1, puTongIndexMax)].putong
        local item3 = cfg[math.random(1, puTongIndexMax)].putong
        sendmail(getbaseinfo(actor, 2), 10000, "被封印的剑灵(SR)",
            "恭喜你,解封【被封印的剑灵(SR)】获得" .. item1 .. "x1," .. item2 .. "x1," .. item3 .. "x1",
            item1 .. "#1#0&" .. item2 .. "#1#0&" .. item3 .. "#1#0")
        return
    end

    if name == "被封印的剑灵(SSR)" then
        local item1 = cfg[math.random(1, shenShengIndexMax)].shensheng
        sendmail(getbaseinfo(actor, 2), 10000, "被封印的剑灵(SSR)", "恭喜你,解封【被封印的剑灵(SSR)】获得" .. item1 .. "x1", item1 .. "#1#0")
        return
    end

    if name == "被封印的剑灵(SSSR)" then
        local item1 = cfg[math.random(1, chuanShiIndexMax)].chuanshi
        sendmail(getbaseinfo(actor, 2), 10000, "被封印的剑灵(SSSR)", "恭喜你,解封【被封印的剑灵(SSSR)】获得" .. item1 .. "x1", item1 .. "#1#0")
        return
    end
    local constName = getconst(actor, "<$ExpiredItemName>")
    local stdMode = getdbitemfieldvalue(constName, "StdMode")
    if stdMode == 70 then
        Player.setAttList(actor, "爆率附加")
        Player.setAttList(actor, "属性附加")
    end
    GameEvent.push(EventCfg.onPlayItemExpired, actor, item, name, TitleName)
end

-- 自定义命令1【标记】
function usercmd7(actor)
    if checkitemw(actor, "天煞符", 1) then --天煞符
        local marktgtname = getconst(actor, "<$PARAM(1)>")
        local marktgtidx  = getplayerbyname(marktgtname)

        if not marktgtidx then
            Player.sendmsgEx(actor, "天煞符#251|:#255|玩家|" .. marktgtname .. "#249|不存在...")
            return
        else
            setplaydef(actor, VarCfg["S$_追杀标记"], marktgtname)
            Player.sendmsgEx(actor, "天煞符#251|:#255|你已将|" .. marktgtname .. "#249|标记,对他额外造成|15%#249|伤害,装备脱掉无效...")
        end

        if Player.Checkonline(marktgtname) then
            local myname = getbaseinfo(actor, ConstCfg.gbase.name)
            Player.sendmsgEx(marktgtidx, "天煞符#251|:#255|你已被|" .. myname .. "#249|标记,他对你会加深|15%#249|伤害...")
        end
        return
    end

    if checkitemw(actor, "噩梦之首★★", 1) then --噩梦之首★★
        local marktgtname = getconst(actor, "<$PARAM(1)>")
        local marktgtidx  = getplayerbyname(marktgtname)

        if not marktgtidx then
            Player.sendmsgEx(actor, "噩梦之首★★#251|:#255|玩家|" .. marktgtname .. "#249|不存在...")
            return
        else
            setplaydef(actor, VarCfg["S$_追杀标记"], marktgtname)
            Player.sendmsgEx(actor, "噩梦之首★★#251|:#255|你已将|" .. marktgtname .. "#249|标记,对他额外造成|15%#249|伤害,装备脱掉无效...")
        end

        if Player.Checkonline(marktgtname) then
            local myname = getbaseinfo(actor, ConstCfg.gbase.name)
            Player.sendmsgEx(marktgtidx, "噩梦之首★★#251|:#255|你已被|" .. myname .. "#249|标记,他对你会加深|15%#249|伤害...")
        end
        return
    end
    Player.sendmsgEx(actor, "提示#251|:#255|你未佩戴|标记装备#249|输入|无效#249|...")
end

-- 自定义命令2【点名】
function usercmd9(actor)
    if checkitemw(actor, "琥珀净瓶", 1) then --琥珀净瓶
        local marktgtname = getconst(actor, "<$PARAM(1)>")
        local marktgtidx  = getplayerbyname(marktgtname)
        if not marktgtidx then
            Player.sendmsgEx(actor, "琥珀净瓶#251|:#255|玩家|" .. marktgtname .. "#249|不存在...")
            return
        else
            setplaydef(actor, VarCfg["S$_琥珀净瓶标记"], marktgtname)
            Player.sendmsgEx(actor, "琥珀净瓶#251|:#255|你已点名|" .. marktgtname .. "#249|,对他攻击时有概率将其收入瓶中世界...")
        end

        if Player.Checkonline(marktgtname) then
            local myname = getbaseinfo(actor, ConstCfg.gbase.name)
            Player.sendmsgEx(marktgtidx, "琥珀净瓶#251|:#255|你已被|" .. myname .. "#249|点名,他对你攻击时有概率将你收入瓶中世界...")
        end
        return
    end
    Player.sendmsgEx(actor, "提示#251|:#255|你未佩戴|标记装备#249|输入|无效#249|...")
end

--buff触发
---* actor: 玩家
---* buffid: buffID
---* groupid: 组ID
---* model: 类型（1=新增，2=更新，3=删除）
function buffchange(actor, buffid, groupid, model)
    --添加buff
    -- ["疾风斩月丹"]	31048

    if model == 1 then
        --天运丹
        if buffid == 31040 then
            Player.setAttList(actor, "爆率附加")
            --破神丹
        elseif buffid == 31041 then
            Player.setAttList(actor, "倍攻附加")
            --疾风斩月丹
        elseif buffid == 31048 then
            Player.setAttList(actor, "攻速附加")
        end
    end

    --更新buff
    if model == 3 then
    end

    --删除buff
    if model == 4 then
        if buffid == 30043 then
            local pkvalue = getbaseinfo(actor, ConstCfg.gbase.pkvalue)
            if pkvalue > 200 then
                setbaseinfo(actor, ConstCfg.sbase.pkvalue, 160)
            end
        end
        -- 千山破 倍功计时buff消失
        if buffid == 30046 then
            Player.setAttList(actor, "倍攻附加")
        end


        if buffid == 30064 then
            if getconst(actor, ConstCfg.equipconst["勋章"]) == "死神降临" then
                addbuff(actor, 30064, 60, 1, actor)
            end
        end

        if buffid == 30080 then
            if checkitemw(actor, "天机", 1) then
                setplaydef(actor, VarCfg["S$_天机状态"], 1) --设置下次伤害开关
                playeffect(actor, 16016, 0, 0, 0, 0, 0) --人物播放特效
            end
        end

        -- 连杀数量重置
        if buffid == 31030 then
            setplaydef(actor, VarCfg["N$连杀人数"], 0)
            -- release_print("连杀重置--------------------------------------")
        end

        --天运丹
        if buffid == 31040 then
            Player.setAttList(actor, "爆率附加")
        end
        --破神丹
        if buffid == 31041 then
            Player.setAttList(actor, "倍攻附加")
        end
        --疾风斩月丹
        if buffid == 31048 then
            Player.setAttList(actor, "攻速附加")
        end

        --无序的凝视
        if buffid == 31085 then
            Player.setAttList(actor, "倍攻附加")
        end

        -- 刺·束缚之隐减速Buff
        if buffid == 31086 then
            Player.setAttList(actor, "攻速附加")
        end
    end
    GameEvent.push(EventCfg.onBuffChange, actor, buffid, groupid, model)
end

--开始挂机触发
function startautoplaygame(actor)
    setflagstatus(actor, VarCfg.F_isGuaJi, 1)
end

--结束挂机触发
function stopautoplaygame(actor)
    setflagstatus(actor, VarCfg.F_isGuaJi, 0)
end

--创建队伍时触发(组队)
function groupcreate(actor)
    GameEvent.push(EventCfg.onEnterGroup, actor)
end

--离开队伍时触发(退组)
function leavegroup(actor)
    GameEvent.push(EventCfg.onLeaveGroup, actor)
end

--玩家进入队伍
function groupaddmember(actor)
    local playerName = getplaydef(actor, "S0")
    local player = getplayerbyname(playerName)
    if player then
        GameEvent.push(EventCfg.onEnterGroup, player)
    end
end

--角色pk值变化触发
function pkpointchanged(actor, pkpoint)
end

--宝宝叛变触发
function mobtreachery(actor, monObj)
    killmonbyobj(actor, monObj, false, false, false)
    local monName = getbaseinfo(monObj, ConstCfg.gbase.name)
    -- 雪人死亡时释放雪崩：对3X3范围内目标造成5000点固定伤害，并有50%的概率冰冻1S.
    if monName == "圣诞雪人" then
        local x, y = getbaseinfo(monObj, ConstCfg.gbase.x), getbaseinfo(monObj, ConstCfg.gbase.y)
        rangeharm(actor, x, y, 3, 0, 6, 5000, 0, 0)         -- 冰冻2*2范围内敌人1秒
        if randomex(1, 2) then
            rangeharm(actor, x, y, 3, 0, 2, 1, 1, 0, 20500) -- 冰冻2*2范围内敌人1秒
        end
    end
end

--人物死亡装备掉落前触发
function checkdropuseitems(actor, where, itemIdx)
    if getplaydef(actor, "N$防止掉装备标记") == 1 then
        return false
    end
    local fei_sheng_level = getplaydef(actor, VarCfg["U_超神套装等级"])
    if fei_sheng_level >= 3 then
        local isUse = getflagstatus(actor, VarCfg["F_超神飞升是否掉落"])
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
            setflagstatus(actor, VarCfg["F_超神飞升是否掉落"], 1)
            setplaydef(actor, "N$防止掉装备标记", 1)
            delaygoto(actor, 5000, "fang_zhi_diao_zhuang_flag")
            return false
        end
    end

    if getflagstatus(actor, VarCfg["F_天命_天选之人标识"]) == 1 then
        local isUse = getflagstatus(actor, VarCfg["F_天选之人是否掉落"])
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
            setflagstatus(actor, VarCfg["F_天选之人是否掉落"], 1)
            setplaydef(actor, "N$防止掉装备标记", 1)
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

--任务触发
--接取任务触发
function picktask(actor, taskID)

end

--点击任务触发
function clicknewtask(actor, taskID)
    GameEvent.push(EventCfg.onClickNewTask, actor, taskID)
end

-- --刷新任务触发
-- function changetask(actor, taskID)

-- end

-- --完成任务触发
-- function completetask(actor, taskID)

-- end

-- --删除任务触发
-- function deletetask(actor, taskID)

-- end
--取消采集
function collecting_monsters_cancel(actor)
    setplaydef(actor, VarCfg["S$当前采集怪物"], "")
end

--开始采集
local collectGiveItem = {
    ["清毒莲"] = { { "清毒莲", 1 } },
    ["净化晶矿"] = { { "净化晶矿", 1 } },
    ["风灵叶"] = { { "风灵叶", 1 } },
    ["天香迷花"] = { { "天香迷花", 1 } },
    ["地狱灵芝"] = { { "地狱灵芝", 1 } },
    ["血菩提藤"] = { { "血菩提", 1 } },
    ["湿婆遗迹"] = { { "湿婆神像", 1 } },
}
function collecting_monsters(actor)
    local monName = getplaydef(actor, VarCfg["S$当前采集怪物名字"])
    local monMakeIndex = getplaydef(actor, VarCfg["S$当前采集怪物"])
    local mapid = getbaseinfo(actor, ConstCfg.gbase.mapid)
    local monobj = getmonbyuserid(mapid, monMakeIndex)
    killmonbyobj(actor, monobj, false, false, false)
    local gives = collectGiveItem[monName]
    local itemName = ""
    if gives then
        itemName = gives[1][1] or ""
    end
    if itemName == "湿婆神像" then
        local num = getplaydef(actor, VarCfg["U_收集湿婆神像"])
        if num < 20 then
            setplaydef(actor, VarCfg["U_收集湿婆神像"], num + 1)
        end
    end
    GameEvent.push(EventCfg.onCollectTask, actor, monName, monMakeIndex, itemName)
    setplaydef(actor, VarCfg["S$当前采集怪物"], "")
    setplaydef(actor, VarCfg["S$当前采集怪物名字"], "")
    if gives then
        Player.giveItemByTable(actor, gives)
        -- Player.sendmsgEx(actor, string.format("获得|[%s*1]#249",gives[1][1]))
    end
end

local danChenColleMob = {
    ["风灵叶"] = 1,
    ["天香迷花"] = 1,
    ["地狱灵芝"] = 1,
}
local MoYuMap = {
    ["潮鲅鱼群【十积分】"] = 1,
    ["沙丁鱼群【三十积分】"] = 3,
    ["大鱼群【五十积分】"] = 5,
    ["超大鱼群【八十积分】"] = 8,
    ["黄金鲸【一百二十积分】"] = 10,
    ["宝石鲸【一百二十积分】"] = 10,
    ["红锦鲤【二百积分】"] = 10,
}

--采集怪触发
function collectmonex(actor, monIDX, monName, monMakeIndex)
    if not Bag.checkBagEmptyNum(actor, 5) then
        Player.sendmsgEx(actor, "采集失败,你的背包格子不足!")
        return
    end
    if monName == "血菩提藤" then
        local mobIdx = getdbmonfieldvalue("火麒麟", "idx")
        local mobNum = getmoncount("安其拉废墟", mobIdx, true)
        -- release_print(mobNum)
        if mobNum > 0 then
            Player.sendmsgEx(actor, "需要击杀|火麒麟#249|才能采集")
            return
        end
    end
    setplaydef(actor, VarCfg["S$当前采集怪物"], monMakeIndex)
    setplaydef(actor, VarCfg["S$当前采集怪物名字"], monName)
    if danChenColleMob[monName] then
        local colleTime = 5
        if checktitle(actor, "丹道学徒") then
            colleTime = 4
        end
        showprogressbardlg(actor, colleTime, "@collecting_monsters", "正在采集%s...", 1, "@collecting_monsters_cancel")
    elseif monName == "血菩提藤" then
        local myName = getbaseinfo(actor, ConstCfg.gbase.name)
        Player.sendMoveMsgEx(actor, 200, 1, string.format("玩家|%s#249|正在|安其拉废墟(71,33)#253|采集|血菩提...#249", myName))
        Player.sendMoveMsgEx(actor, 250, 1, string.format("玩家|%s#249|正在|安其拉废墟(71,33)#253|采集|血菩提...#249", myName))
        showprogressbardlg(actor, 30, "@collecting_monsters", "正在采集血菩提藤(30秒)%s...", 1, "@collecting_monsters_cancel")
    elseif MoYuMap[monName] then
        showprogressbardlg(actor, MoYuMap[monName], "@collecting_monsters", "正在摸鱼%s...", 1, "@collecting_monsters_cancel")
    else
        showprogressbardlg(actor, 1, "@collecting_monsters", "正在采集%s...", 1, "@collecting_monsters_cancel")
    end
end

--任务爆出检测
function task_item_need(actor, itemName)
    GameEvent.push(EventCfg.onCollectTask, actor, itemName, 1)
    return true
end

--上古魔龙爆出检测
function shang_gu_mo_long_item_need(actor, itemName)
    local num = getplaydef(actor, VarCfg["U_二元归灵珠_数量"])
    if num < 2 then
        setplaydef(actor, VarCfg["U_二元归灵珠_数量"], num + 1)
    end
    return true
end

--进入连接点(跳转点)前触发
function beforeroute(actor, mapid, x, y)
    if mapid == "永恒密道2层" then
        if getflagstatus(actor, VarCfg["F_永恒密道_开启状态"]) == 0 then
            return false
        end
    end
    if mapid == "叛军老巢" and x == 33 and y == 38 then
        local num = getplaydef(actor, VarCfg["U_剧情_悲鸣哨塔_线索数量"])
        if num < 100 then
            return false
        end
    end
    GameEvent.push(EventCfg.onBeforerOute, actor, mapid, x, y)
end

-- --金币
function moneychange1(actor)
    local MoneyNum = getbindmoney(actor, "金币")
    GameEvent.push(EventCfg.OverloadMoneyJinBi, actor, MoneyNum)
end

--绑定金币
function moneychange3(actor)
    local MoneyNum = getbindmoney(actor, "金币")
    GameEvent.push(EventCfg.OverloadMoneyJinBi, actor, MoneyNum)
end

--元宝
function moneychange2(actor)
    local MoneyNum = getbindmoney(actor, "元宝")
    GameEvent.push(EventCfg.OverloadMoneyYuanBao, actor, MoneyNum)
end

--绑定元宝
function moneychange4(actor)
    local MoneyNum = getbindmoney(actor, "元宝")
    GameEvent.push(EventCfg.OverloadMoneyYuanBao, actor, MoneyNum)
end

--灵符
function moneychange7(actor)
    local MoneyNum = getbindmoney(actor, "灵符")
    GameEvent.push(EventCfg.OverloadMoneyLingFu, actor, MoneyNum)
end

--绑定灵符
function moneychange20(actor)
    local MoneyNum = getbindmoney(actor, "灵符")
    GameEvent.push(EventCfg.OverloadMoneyLingFu, actor, MoneyNum)
end

--充值积分
function moneychange11(actor)
    local MoneyNum = querymoney(actor, 11)
    GameEvent.push(EventCfg.OverloadMoneyJiFen, actor, MoneyNum)
end

--交易前触发
-- function dealbefore(actor, target)
--     stop(actor)
--     stop(target)
-- end

--宝宝死亡触发
function selfkillslave(actor, mon)
    GameEvent.push(EventCfg.onSelfKillSlave, actor, mon)
end

function showfashion(actor)
    GameEvent.push(EventCfg.onShowFashion, actor)
end

function notshowfashion(actor)
    GameEvent.push(EventCfg.onNotShowFashion, actor)
end

-- 怪物爆出装备触发
function mondropitemex(actor, DropItem, mon, nX, nY)
    GameEvent.push(EventCfg.onMondropItemex, actor, DropItem, mon, nX, nY)
end

-- --拾取前触发
-- function pickupitemfrontex(actor, item)
--     if checkkuafu(actor) then
--         return
--     end
--     local itemID = getiteminfo(actor, item, 2)
--     local ItemName = getstditeminfo(itemID, 1)
--     GameEvent.push(EventCfg.onPickUpItemfrontex, actor, item, ItemName, itemID)
-- end

--购买物品后触发
function buyshopitem(actor, itemobj, itemname, itemnum, moneyid, moneynum)
    --后买后给绑定
    if getflagstatus(actor, VarCfg["F_解绑状态"]) == 0 then
        setitemaddvalue(actor, itemobj, 2, 1, ConstCfg.binding)
    end
end

--加入行会后触发
function guildaddmemberafter(actor, guild, name)
    GameEvent.push(EventCfg.onGuildAddMemberAfter, actor, guild, name)
end

function attackdamagebb(actor, Target, Hiter, MagicId, Damage)
    GameEvent.push(EventCfg.onAttackDamageBB, actor, Target, Hiter, MagicId, Damage)
end

--发言触发
function triggerchat(actor, sMsg, chat, msgType)
    local flag = getflagstatus(actor, VarCfg["F_解绑状态"])
    if flag == 0 then
        sendmsg(actor, 1, '{"Msg":"<font color=\'#ff0000\'>开通解绑特权才可以发言!</font>","Type":9}')
        return false
    end
    return true
end

--不掉诅咒
function makeweaponunluck(actor, item)
    return false
end

--商城购买喊话喇叭前触发
function canbuyshopitem200(actor)
    if getflagstatus(actor, VarCfg["F_解绑状态"]) == 0 then
        sendmsg(actor, 1, '{"Msg":"<font color=\'#ff0000\'>你没有解绑特权,无法购买此产品!</font>","Type":9}')
        notallowbuy(actor, 1)
    end
end

function checkbuildguild(actor)
    if getflagstatus(actor, VarCfg["F_是否首充"]) == 0 then
        Player.sendmsgEx(actor, "为了防止小号拉人,首充之后才能创建行会#249")
        return false
    end
end

function updateguildnotice(actor)
    Player.sendmsgEx(actor, "禁止编辑行会公告!#249")
    stop(actor)
end

function itemdropfrombagbefore(actor, itemobj)
    --如果死在安全区，不掉装备
    if getbaseinfo(actor, ConstCfg.gbase.issaferect) then
        return false
    end
end

function xie_ru_zuo(actor)
    local x = Player.GetX(actor)
    local y = Player.GetY(actor)
    local mapID = Player.MapKey(actor)
    local file = io.open("UserFile/map.txt", "a") -- "a" 表示追加模式
    if not file then
        release_print("无法打开文件!")
        return
    end
    file:write(string.format("%s %s,%s -> ", mapID, x, y))
    Player.sendmsgEx(string.format("%s %s,%s -> ", mapID, x, y))
    file:close()
    release_print("内容已追加到文件!")
end

function xie_ru_you(actor)
    local x = Player.GetX(actor)
    local y = Player.GetY(actor)
    local mapID = Player.MapKey(actor)
    local file = io.open("UserFile/map.txt", "a") -- "a" 表示追加模式
    if not file then
        release_print("无法打开文件!")
        return
    end
    file:write(string.format("%s %s,%s\n", mapID, x, y))
    Player.sendmsgEx(string.format("%s %s,%s", mapID, x, y))
    file:close()
    release_print("内容已追加到文件!")
end

--链接点采集
function usercmd10(actor)
    local gmLv = getgmlevel(actor)
    if gmLv < 10 then
        sendmsg(actor, 1, '{"Msg":"<font color=\'#ff0000\'>GM权限不足</font>","Type":9}')
        return
    end
    local str = [[
        <Img|img=public_win32/bg_npc_01.png|loadDelay=1|esc=1|show=4|reset=1|move=0|bg=1>
        <Layout|x=545|y=0|width=80|height=80|link=@exit>
        <Button|x=546|y=0|pimg=public/1900000511.png|nimg=public/1900000510.png|link=@exit>
        <Button|ay=1|x=80.0|y=63|size=18|color=255|nimg=public/1900000660.png|pimg=public/1900000661.png|text=写入左|link=@xie_ru_zuo>
        <Button|ay=1|x=341.0|y=63|size=18|color=255|nimg=public/1900000660.png|pimg=public/1900000661.png|text=写入右|link=@xie_ru_you>
    ]]
    say(actor, str)
end

--装备投保掉落触发Start
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

--装备投保掉落触发End

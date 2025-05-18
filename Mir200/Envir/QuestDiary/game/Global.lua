Global = {}
--第二天重置变量
local function resetVar(actor)
    local currentDate = GetCurrentDateAsNumber()
    setplaydef(actor, VarCfg["U_上次本日首次登录时间"], currentDate) --重置今日的信息
    setplaydef(actor, VarCfg["U_攻沙积分"], 0)
    setplaydef(actor, VarCfg["U_攻沙积分跨服"], 0)
    setflagstatus(actor, VarCfg["F_跨服攻沙是否领取"], 0)
    setflagstatus(actor, VarCfg["F_斩将夺旗是否领取"], 0)
    setflagstatus(actor, VarCfg["F_天下第一是否领取"], 0)
    setflagstatus(actor, VarCfg["F_天选之人是否掉落"], 0)
    setflagstatus(actor, VarCfg["F_超神飞升是否掉落"], 0)
    setplaydef(actor, VarCfg["U_跨服当时积分"], 0)
    delattlist(actor, "聚宝术")
end

-------------------------------机器人执行-------------------------------------
--每日执行
function beforedawn()
    --每日+1
    local openday = getsysvar(VarCfg["G_开区天数"])
    setsysvar(VarCfg["G_开区天数"], openday + 1)
    GameEvent.push(EventCfg.roBeforedawn, openday + 1)
    setsysvar(VarCfg["G_是否开启攻沙"], 0)
    --新的一天 全服玩家提示
    local player_list = getplayerlst()
    for _, actor in ipairs(player_list) do
        GameEvent.push(EventCfg.onNewDay, actor)
        resetVar(actor)
    end
    --所有人回本服
    if checkkuafuserver() then
        kuafuusergohome()
        FsendHuoDongGongGao("跨服服务器已关闭,所有人传回本服!")
    end
    --清理自定义变量 KFZF5 = 天选之人防止掉装备  KFZF6 = 超神飞升防止掉装备
    -- clearhumcustvar("*","KFZF5|KFZF6")
end

--每间隔一小时修改一次天气
function settianqi()
    setweathereffect("n3", math.random(3), 600)
end

--沙巴克加入攻沙
function sbk_join()
    --加入攻沙先清除行会的积分记录，和沙巴克城主领取记录
    setsysvar(VarCfg["A_行会积分记录"], "")
    setsysvar(VarCfg["A_沙城主领取"], "")
    setsysvar(VarCfg["A_胜利方行会成员领取记录"], "")
    setsysvar(VarCfg["A_排行榜领取记录"], "")
    local isKF = checkkuafuconnect()
    FSendGongShaTips1(isKF)
    --标记为开始攻沙
    if checkkuafuserver() then
        setsysvar(VarCfg["G_是否开启攻沙"], 1)
    end
    --如果没开启跨服服务器，则开启本服攻沙
    if not checkkuafuconnect() then
        setsysvar(VarCfg["G_是否开启攻沙"], 1)
    end
    --修复城门
    repaircastle()
end

function set_richong_state_on()
    setsysvar(VarCfg["A_幻境地图开关"], "开")
    FsendHuoDongGongGao("幻境地图已经开启，欢迎各位勇士前往探险。")
end

function set_richong_state_off()
    setsysvar(VarCfg["A_幻境地图开关"], "")
    FsendHuoDongGongGao("幻境地图已经关闭，敬请期待下次开启。")
    local RiChongDiTu = { "神龙幻境1", "神龙幻境2", "酆都幻境1", "酆都幻境2", "极恶幻境1", "极恶幻境2", "破晓幻境1", "破晓幻境2", "破晓秘宝阁1", "破晓秘宝阁2",
        "圣城幻境1", "圣城幻境2", "圣城秘宝阁1", "圣城秘宝阁2", "新月幻境1", "新月幻境2", "新月秘宝阁1", "新月秘宝阁2" }

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
    --攻沙提示
    if isKF then
        local weekDayNumber = tonumber(os.date("%w"))
        if weekDayNumber == 2 or weekDayNumber == 6 then
            sbk_join()
        end
        return
    end
    --获取合区次数
    local heQuDay = tonumber(getconst("0", "<$HFCOUNT>"))
    --获取攻沙次数
    local gongShaConunt = getsysvar(VarCfg["G_攻沙次数"])
    --当攻沙标记大于0的时候，开启后续攻沙，要先判断
    if gongShaConunt > 0 then
        --获取今天星期几
        local weekDayNumber = tonumber(os.date("%w"))
        --判断星期2或者星期6才攻沙
        if weekDayNumber == 2 or weekDayNumber == 6 then
            setsysvar(VarCfg["G_攻沙次数"], gongShaConunt + 1)
            sbk_join()
        end
    end
    --首次合区开启攻沙
    --合区次数等于1为首次合区，并且判断是否首次攻沙标记
    -- heQuDay = 1
    if heQuDay == 1 and getsysvar(VarCfg["G_攻沙次数"]) == 0 then
        sbk_join()
        --标记首次攻沙
        setsysvar(VarCfg["G_攻沙次数"], 1)
    end
end

--沙巴克开始
function start_sbk()
    if getsysvar(VarCfg["G_是否开启攻沙"]) > 0 then
        -- 所以行会加入攻城战
        addtocastlewarlistex("*")
        gmexecute("0", "ForcedWallConQuestwar")
    end
end

--沙巴克结束
function end_sbk()
    if getsysvar(VarCfg["G_是否开启攻沙"]) > 0 then
        gmexecute("0", "ForcedWallConQuestwar")
    end
end

--夜晚开始
function starting_dark()
    sendmsg("0", 2,
        '{"Msg":"月黑风高夜，杀人正当时，视距降低，死亡爆装概率+10%","FColor":0,"BColor":255,"Type":5,"Time":3,"SendId":"123","Y":"100"}')
    sendmsg("0", 2,
        '{"Msg":"月黑风高夜，杀人正当时，视距降低，死亡爆装概率+10%","FColor":0,"BColor":255,"Type":5,"Time":3,"SendId":"123","Y":"140"}')
    sendmsg("0", 2,
        '{"Msg":"月黑风高夜，杀人正当时，视距降低，死亡爆装概率+10%","FColor":0,"BColor":255,"Type":5,"Time":3,"SendId":"123","Y":"180"}')
    local t = getplayerlst(1)
    for _, actor in ipairs(t) do
        if not getbaseinfo(actor, ConstCfg.gbase.offline) then
            GameEvent.push(EventCfg.onStartingDark, actor)
        end
    end
end

--白天开始
function starting_day()
    sendmsg("0", 2,
        '{"Msg":"早安，每个早晨都是全新一天的开始，愿你今天有个好心情。","FColor":255,"BColor":0,"Type":5,"Time":3,"SendId":"123","Y":"100"}')
    sendmsg("0", 2,
        '{"Msg":"早安，每个早晨都是全新一天的开始，愿你今天有个好心情。","FColor":255,"BColor":0,"Type":5,"Time":3,"SendId":"123","Y":"140"}')
    sendmsg("0", 2,
        '{"Msg":"早安，每个早晨都是全新一天的开始，愿你今天有个好心情。","FColor":255,"BColor":0,"Type":5,"Time":3,"SendId":"123","Y":"180"}')
    local t = getplayerlst(1)
    for _, actor in ipairs(t) do
        if not getbaseinfo(actor, ConstCfg.gbase.offline) then
            GameEvent.push(EventCfg.onStartingDay, actor)
        end
    end
end

--引擎启动触发

function Global.onStartUp()
    --开启全局分钟定时器
    if getsysvar(VarCfg["G_开区分钟计时器"]) <= 300 then
        setontimerex(1, 60)
    end
    mapeffect(63067, "n3", 348, 327, 63067, -1, 0, "0", 0)
    --双节天气效果
    setweathereffect("狂欢小镇", 3, 6553500)
end

--黑月之泪属性  开启
function attributeson()
    local t = getplayerlst(1)
    for _, actor in ipairs(t) do
        if Player.Checkonline(getbaseinfo(actor, ConstCfg.gbase.name)) then --检测是否在线玩家（非离线挂机玩家）
            if getconst(actor, ConstCfg.equipconst["毒符"]) == "黑月·之泪" then
                Player.setAttList(actor, "倍攻附加")
            end
        end
    end
end

--黑月之泪属性  关闭
function attributesoff()
    local t = getplayerlst(1)
    for _, actor in ipairs(t) do
        if Player.Checkonline(getbaseinfo(actor, ConstCfg.gbase.name)) then --检测是否在线玩家（非离线挂机玩家）
            Player.setAttList(actor, "倍攻附加")
        end
    end
end

--血刀老祖延迟扣血
function xuedaolaozusubhp(actor, state)
    state = tonumber(state)
    if getflagstatus(actor, VarCfg["F_天命_血刀老祖标识"]) == 1 then
        changehumnewvalue(actor, 208, -20, 655350)
        Player.buffTipsMsg(actor, "[血刀老祖]生效,扣除20%最大生命值")
    else
        if state == 1 then
            changehumnewvalue(actor, 208, 0, 1)
        end
    end
end

--不动如山减攻击
function budongrushangongji(actor, state)
    state = tonumber(state)
    if getflagstatus(actor, VarCfg["F_天命_不动如山标识"]) == 1 then
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
        Player.buffTipsMsg(actor, "[不动如山]生效,扣除10%最大攻击力")
    else
        --非登录才触发
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
--         addattlist(actor, "血魔之躯", "=", string.format("3#9#%s|3#10#%s|3#11#%s|3#12#%s", fangYu, fangYu, fangYu, fangYu), 1)
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
        addattlist(actor, "血魔之躯", "=",
            string.format("3#213#%s|3#214#%s|3#224#%s|3#225#%s", fangYuHer, fangYuHer, fangYuHer, fangYuHer), 1)
    end
end

function jielidali_beigonghuifu(actor)
    Player.setAttList(actor, "倍攻附加")
end

-------------------------------打开UI全局函数---------------------------------------
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
    setplaydef(actor, VarCfg["N$人物按钮是否添加红点"], 0)
    openhyperlink(actor, ConstCfg.openlink.Equip)
end

--打开首充
function open_shou_chong(actor)
    Message.sendmsg(actor, ssrNetMsgCfg.ShouChong_OpenUI)
end

--全局函数---
function entermapmsg(actor, isAuto)
    local userName = getbaseinfo(actor, ConstCfg.gbase.name)
    local mapName = getbaseinfo(actor, ConstCfg.gbase.map_title)
    local msg = string.format("勇士{「%s」|254:0:1}闯入了{「%s」|250:0:1}开始传奇之旅!", Player.GetNameEx(actor), mapName)

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
    senddelaymsg(actor, "系统提示：您将在%s后结束副本...", timer, 250, 1)
end

-------------------------------逻辑处理---------------------------------------
--检查模块开启
function Global.checkModuleOpen(actor)
    -- openmoduleid = 100
    -- GameEvent.push(EventCfg.goOpenModule, actor, openmoduleid)
    --通过 openmoduleid 获取模块对象， 同步模块数据
    -- Message.sendmsg(actor, ssrNetMsgCfg.Global_OpenModuleRun, openmoduleid)
end

--发送助力
local zhuligive = { { "焚天石", 20 }, { "天工之锤", 20 }, { "绑定金币", 880000 }, { "老G画的饼", 1 }, { "不当牛马[称号]", 1 }, { "我有一头小毛驴[时装]", 1 } }
function fa_song_zhu_li(actor)
    local accountID = getconst(actor, "<$USERACCOUNT>")
    local isLive = checktextlist('..\\QuestDiary\\accountid\\liveuserid.txt', accountID)
    if isLive then
        local targetName = getconst(actor, "<$NPCINPUT(2)>")
        local targetPlayer = getplayerbyname(targetName)
        if not targetPlayer or targetPlayer == "" or targetPlayer == "0" or not isnotnull(targetPlayer) then
            Player.sendmsgEx(actor, targetName .. "#249|不在线！")
            return
        end

        local flag = getflagstatus(targetPlayer, VarCfg["F_直播助力领取"])
        if flag == 1 then
            Player.sendmsgEx(actor, targetName .. "#249|已经领取过了！")
            return
        end
        local mailTitle = "直播助力"
        local mailContent = "请领取您的直播助力"
        local userID = getbaseinfo(targetPlayer, ConstCfg.gbase.id)
        Player.giveMailByTable(userID, 20, mailTitle, mailContent, zhuligive, 1, true)
        setflagstatus(targetPlayer, VarCfg["F_直播助力领取"], 1)
        delbutton(targetPlayer, 105, 12345)
        Player.sendmsgEx(actor, targetName .. "#249|主播助力发送成功！")
    end
end

function zi_dong_fa_song_zhu_li(actor)
    local flag = getflagstatus(actor, VarCfg["F_直播助力领取"])
    if flag == 0 then
        local mailTitle = "直播助力"
        local mailContent = "请领取您的直播助力"
        local userID = getbaseinfo(actor, ConstCfg.gbase.id)
        Player.giveMailByTable(userID, 20, mailTitle, mailContent, zhuligive, 1, true)
        setflagstatus(actor, VarCfg["F_直播助力领取"], 1)
        delbutton(actor, 105, 12345)
    end
end

--主播
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

--普通
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

--直播助力
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
        local flag = getflagstatus(actor, VarCfg["F_直播助力领取"])
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
    setplaydef(actor,"N$防止掉装备标记",0)
end

-------------------------------活动begin----------------------------------
---仙王宝藏开始
--11:30
--18:30
function xian_wang_bao_zang_start()
    setsysvar(VarCfg["G_仙王宝藏开启标识"], 1)
    GameEvent.push(EventCfg.onXianWangBaoZangStart)
end

---仙王宝藏结束
--12:00
--19:00
function xian_wang_bao_zang_end()
    setsysvar(VarCfg["G_仙王宝藏开启标识"], 0)
    GameEvent.push(EventCfg.onXianWangBaoZangEnd)
end

---异界猎场开始
--13:00
--19:00
function yi_jie_lie_chang_start()
    setsysvar(VarCfg["G_异界猎场开启标识"], 1)
    GameEvent.push(EventCfg.onYiJieLieChangStart)
end

---异界猎场结束
--13:30
--19:30
function yi_jie_lie_chang_end()
    setsysvar(VarCfg["G_异界猎场开启标识"], 0)
    GameEvent.push(EventCfg.onYiJieLieChangEnd)
end

-- ---牛马旷工开始
-- --每周1周5 21:00-22:00
-- function niu_ma_kuang_gong_start()
--     local weekDayNumber = tonumber(os.date("%w"))
--     if weekDayNumber == 1 or weekDayNumber == 5 then
--         setsysvar(VarCfg["G_牛马旷工开启标识"], 1)
--         GameEvent.push(EventCfg.onNiuMaKuangGongStart)
--     end
-- end

-- ---牛马旷工结束
-- function niu_ma_kuang_gong_end()
--     local weekDayNumber = tonumber(os.date("%w"))
--     if weekDayNumber == 1 or weekDayNumber == 5 then
--         setsysvar(VarCfg["G_牛马旷工开启标识"], 0)
--         GameEvent.push(EventCfg.onNiuMaKuangGongEnd)
--     end
-- end

---异界迷城开始
--每周1周5 21:00-22:00
function yi_jie_mi_cheng_start()
    setsysvar(VarCfg["G_异界迷城开启标识"], 1)
    GameEvent.push(EventCfg.onYiJieMiChengStart)
end

---异界迷城结束
function yi_jie_mi_cheng_end()
    setsysvar(VarCfg["G_异界迷城开启标识"], 0)
    GameEvent.push(EventCfg.onYiJieMiChengEnd)
end

--斩将夺旗活动开始
function zhan_jiang_duo_qi_start()
    local weekDayNumber = tonumber(os.date("%w"))
    if weekDayNumber == 1 or weekDayNumber == 5 then
        if checkkuafuconnect() then
            setsysvar(VarCfg["G_斩将夺旗"], 1)
            GameEvent.push(EventCfg.onKFZhanJiangDuoQiStart)
            if checkkuafuserver() then
                setontimerex(3, 1)
            end
        end
    end
end

--斩将夺旗活动结束
function zhan_jiang_duo_qi_end()
    local weekDayNumber = tonumber(os.date("%w"))
    if weekDayNumber == 1 or weekDayNumber == 5 then
        if checkkuafuconnect() then
            setsysvar(VarCfg["G_斩将夺旗"], 0)
            GameEvent.push(EventCfg.onKFZhanJiangDuoQiEnd)
            if checkkuafuserver() then
                setofftimerex(3)
            end
        end
    end
end

--天下第一活动开启
function tian_xia_di_yi_start()
    local weekDayNumber = tonumber(os.date("%w"))
    if weekDayNumber == 1 or weekDayNumber == 3 or weekDayNumber == 5 then
        if checkkuafuconnect() then
            setsysvar(VarCfg["G_天下第一"], 1)
            GameEvent.push(EventCfg.onKFTianXiaDiYiStart)
            if checkkuafuserver() then
                setontimerex(4, 3)
            end
        end
    end
end

--天下第一活动结束
function tian_xia_di_yi_end()
    local weekDayNumber = tonumber(os.date("%w"))
    if weekDayNumber == 1 or weekDayNumber == 3 or weekDayNumber == 5 then
        if checkkuafuconnect() then
            setsysvar(VarCfg["G_天下第一"], 0)
            GameEvent.push(EventCfg.onKFTianXiaDiYiEnd)
            if checkkuafuserver() then
                setofftimerex(4)
            end
        end
    end
end

--双节活动地图开启
function shuang_jie_huo_dong_map_start()
    GameEvent.push(EventCfg.onShuangJieHuoDongStart)
end

--双节活动地图关闭
function shuang_jie_huo_dong_map_end()
    GameEvent.push(EventCfg.onShuangJieHuoDongEnd)
end

--狂欢小镇刷怪
function kuang_huan_xiao_zhen_shua_guai()
    GameEvent.push(EventCfg.onKuangHuanXiaoZhenShuaGuai)
end
-------------------------------活动end-----------------------------------


-------------------------------事件---------------------------------------
--登录完成
function Global.LoginEnd(actor, logindatas)
    --gm权限等级
    -- if ConstCfg.DEBUG then
    --     setgmlevel(actor, 10)
    -- end
    setflagstatus(actor, VarCfg["F_人物死亡"], 0)
    table.insert(logindatas, { ssrNetMsgCfg.Global_SyncAdmini, getgmlevel(actor) })
    --绘制魔法球血球
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
    --记录当前地图id
    local cur_mapid = getbaseinfo(actor, ConstCfg.gbase.mapid)
    setplaydef(actor, VarCfg.S_cur_mapid, cur_mapid)
    local jiShaNum = getplaydef(actor, VarCfg["U_杀人数"])
    local beiShanum = getplaydef(actor, VarCfg["U_被杀数"])
    setranklevelname(actor, "%s\\击杀[" .. jiShaNum .. "]次·死亡[" .. beiShanum .. "]次")
    --直播助力
    Global.zhiBoZhuLi(actor)
    -- if checkitemw(actor, "夜明珠", 1) or checkitemw(actor, "新月宝珠", 1) or checkitemw(actor, "妖月内丹", 1) then
    --     setcandlevalue(actor, 100)
    -- end
    --第二天登录变量重置
    if Player.isNextDayLogin(actor) then
        resetVar(actor)
    end

    --根据第一个玩家进入，记录服务器日期
    -- local serverDate = getsysvar(VarCfg["G_开区日期"])
    -- if serverDate == 0 then
    --     setsysvar(VarCfg["G_开区日期"], GetCurrentDateAsNumber())
    -- end
end

--点击某NPC
function Global.ClickNpcResponse(actor, npcid)
    --Message.sendmsg(actor, ssrNetMsgCfg.Global_ClickNpcResponse, npcid)
end

--背包格子数发送变化
function Global._onBagChange(actor)
    --开服天数
    local openDay = grobalinfo(ConstCfg.global.openday)
    --背包格子数
    local bagNum = ConstCfg.bagcellnum + getplaydef(actor, VarCfg.U_Bag_OpenNum)
    Message.sendmsg(actor, ssrNetMsgCfg.Global_SyncOpenDay, openDay, bagNum)
end

local function _onPlaydie(actor, hiter)
    local jiShaNum = getplaydef(actor, VarCfg["U_杀人数"])
    local beiShanum = getplaydef(actor, VarCfg["U_被杀数"])
    setplaydef(actor, VarCfg["U_被杀数"], beiShanum + 1)
    setranklevelname(actor, "%s\\击杀[" .. jiShaNum .. "]次·死亡[" .. beiShanum + 1 .. "]次")
    local x = getbaseinfo(actor, ConstCfg.gbase.x)
    local y = getbaseinfo(actor, ConstCfg.gbase.y)
    local mapName = getbaseinfo(actor, ConstCfg.gbase.map_title)
    local killer = Player.GetNameEx(hiter)
    local myName = Player.GetNameEx(actor)
    if getbaseinfo(hiter, -1) == true then
        local msgStr = string.format("玩家[%s]在[%s(%d:%d)]把玩家[%s]干掉了！", killer, mapName, x, y, myName)
        sendmsg("0", 2, '{"Msg":"' ..
        msgStr .. '","FColor":255,"BColor":0,"Type":1,"Time":3,"SendName":"提示","SendId":"123"}')
    else
        local msgStr = string.format("凶悍的怪物[%s]在[%s(%d:%d)]把玩家[%s]给分尸了！", killer, mapName, x, y, myName)
        sendmsg("0", 2, '{"Msg":"' ..
        msgStr .. '","FColor":255,"BColor":0,"Type":1,"Time":3,"SendName":"提示","SendId":"123"}')
    end
end
GameEvent.add(EventCfg.onPlaydie, _onPlaydie, Global)
local function _onkillplay(actor, play)
    local jiShaNum = getplaydef(actor, VarCfg["U_杀人数"])
    local beiShanum = getplaydef(actor, VarCfg["U_被杀数"])
    setplaydef(actor, VarCfg["U_杀人数"], jiShaNum + 1)
    setranklevelname(actor, "%s\\击杀[" .. jiShaNum + 1 .. "]次·死亡[" .. beiShanum .. "]次")
end
GameEvent.add(EventCfg.onkillplay, _onkillplay, Global)

-------------------------------监听事件---------------------------------------
GameEvent.add(EventCfg.onStartUp, Global.onStartUp, Global, 1)
GameEvent.add(EventCfg.onBagChange, Global._onBagChange, Global, 1)
GameEvent.add(EventCfg.onLoginEnd, Global.LoginEnd, Global, 1)
GameEvent.add(EventCfg.onKFLogin, Global.LoginEnd, Global, 1) --跨服登陆
GameEvent.add(EventCfg.goBeforedawn, Global.Beforedawn, Global, 1)
GameEvent.add(EventCfg.onClicknpc, Global.ClickNpcResponse, Global, 1)
-- GameEvent.add(EventCfg.onRecharge, Global.Recharge, Global, 1)
-- GameEvent.add(EventCfg.onVirtualRecharge, Global.onVirtualRecharge, Global, 1)

--开启离线挂机
local function _onExitGame(actor)
    local serverName = getconst(actor, "<$SERVERNAME>")
    if serverName ~= "" then
        local taskID = getplaydef(actor, VarCfg["U_主线任务进度"])
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
            offlineplay(actor, 65535) --离线挂机
        end
    end
end
GameEvent.add(EventCfg.onExitGame, _onExitGame, Global)
local cfg_KuaFuVal = include("QuestDiary/cfgcsv/cfg_KuaFuVal.lua")
--声明跨服变量
local function _goPlayerVar(actor)
    for _, value in ipairs(cfg_KuaFuVal) do
        FIniPlayVar(actor, value.String, true)
        FIniPlayVar(actor, value.Integer, false)
    end
end
GameEvent.add(EventCfg.goPlayerVar, _goPlayerVar, Global)

local function _onKFLogin(actor)
    if getflagstatus(actor, VarCfg["F_是否进入过跨服"]) == 0 then
        setflagstatus(actor, VarCfg["F_是否进入过跨服"], 1)
    end
end
GameEvent.add(EventCfg.onKFLogin, _onKFLogin, Global)

--切换地图，主要是方便把地图ID记录到自定义变量中，方便跨服使用
local function _goSwitchMap(actor, cur_mapid, former_mapid, x, y)
    Player.SetVarMap(actor, cur_mapid)
end
GameEvent.add(EventCfg.goSwitchMap, _goSwitchMap, Global)

-------------------------------监听网络---------------------------------------
Message.RegisterNetMsg(ssrNetMsgCfg.Global, Global)

return Global

KuangBao = {}
KuangBao.ID = 30900
local configKB = cfg_kuangbao[1]
--给与技能
function KuangBao.addsKill(actor)
    local skillId = getskillindex(configKB.skill)
    addskill(actor, skillId, 1)
end

--删除技能
function KuangBao.delsKill(actor)
    local skillId = getskillindex(configKB.skill)
    delskill(actor, skillId)
end

function KuangBao.Request(actor)
    local isKangBao = getflagstatus(actor, VarCfg.F_is_open_kuangbao) --是否开启狂暴之力
    if isKangBao == 1 then
        Player.sendmsgEx(actor, "你已开启狂暴之力！#249")
        local isShiBu = getskillinfo(actor,configKB.skill,1)
        if not isShiBu then
            KuangBao.addsKill(actor)
        end
        return
    end

    if not configKB.cost then
        Player.sendmsgEx(actor, "狂暴之力配置错误！#249")
        return
    end

    if querymoney(actor, 7) < 100 then
        Player.sendmsgEx(actor, "提示#251|:#255|你的灵符不足|100枚#249|激活失败...")
        return
    end
    changemoney(actor, 7, "-", 100, "狂暴扣除", true)
    --设置标识
    setflagstatus(actor, VarCfg.F_is_open_kuangbao, 1)
    --给称号
    confertitle(actor, configKB.title, 1)
    --给技能
    KuangBao.addsKill(actor)
    Player.sendmsgEx(actor, "开启狂暴之力成功！")
    local userName = Player.GetNameEx(actor)
    sendcentermsg(actor, 249, 0,
        string.format("【系统】：玩家[%s]开启了狂暴之力，杀死他可以获得%s%s奖励！", userName, configKB.diaoluo[1][1], configKB.diaoluo[1][2]), "1",
        8)
    --天命狂暴之子
    if getflagstatus(actor, VarCfg["F_天命狂暴之子"]) == 1 then
        addattlist(actor, "狂暴之子", "=", "3#3#50|3#4#50|3#5#50|3#6#50|3#7#50|3#8#50", 1)
        Player.buffTipsMsg(actor, "[狂暴之子]:获得天命狂暴之子属性！")
    end

    Player.setAttList(actor, "爆率附加")
    Player.setAttList(actor, "属性附加")
    GameEvent.push(EventCfg.OpenKuangBao, actor)
end

Message.RegisterNetMsg(ssrNetMsgCfg.KuangBao, KuangBao) --注册网络消息

------------------------------↓↓↓ 游戏事件 ↓↓↓---------------------------------------

--狂暴之力 检测删除
function kuang_bao_check_shan_chu(actor)
    --如果标识不存在  就删除一次狂暴
    if getflagstatus(actor, VarCfg.F_is_open_kuangbao) == 0 then
        if checktitle(actor, "狂暴之力") then
            deprivetitle(actor, "狂暴之力")
        end
        KuangBao.delsKill(actor)
    end
end

local function KuangBaoLongin(actor, logindatas)
    if getflagstatus(actor, VarCfg.F_is_open_kuangbao) == 1 then
        seticon(actor, ConstCfg.iconWhere.kuangbao, 1, 15000)
    end
    if not checkkuafu(actor) then
        delaygoto(actor, 9000, "kuang_bao_check_shan_chu")
    end
end

local function _onKuangBaoZhiLiBenFu(actor)
    Player.giveItemByTable(actor, configKB.diaoluo, "击杀拥有狂暴的玩家")
end
GameEvent.add(EventCfg.onKuangBaoZhiLiBenFu, _onKuangBaoZhiLiBenFu, KuangBao)

--1死亡者 2击杀者
local function _playerkillplay(play, actor)
    --判断是否攻沙时间，攻沙不掉狂暴
    local isGongSha = castleinfo(5)
    if isGongSha then
        return
    end
    if actor == "0" or play == "0" then
        return
    end
    local mapguid = 0
    if not getbaseinfo(actor, -1) then return end --如果是怪物不执行任何操作
    if not getbaseinfo(play, -1) then return end  --如果是怪物不执行任何操作

    local map = Player.GetVarMap(actor)
    --判断安全地图
    for _, value in ipairs(configKB.mapid) do
        if map == value then
            mapguid = 1
            break
        end
    end
    if mapguid == 1 then
        return
    end
    if getflagstatus(play, VarCfg.F_is_open_kuangbao) == 1 then
        --穿戴死亡之环   有20%概率 不掉狂暴
        if checkitemw(play, "死亡之环", 1) then
            if randomex(20) then
                messagebox(play, "恭喜:死亡之环触发了被杀不掉狂暴!")
                messagebox(actor, "被击杀玩家触发了[死亡之环]不掉狂暴BUFF,因此你没有获得奖励!")
                return
            end
        end
        if checkkuafu(actor) then
            FKuaFuToBenFuEvent(actor,EventCfg.onKuangBaoZhiLiBenFu, "")
        else
            Player.giveItemByTable(actor, configKB.diaoluo, "击杀拥有狂暴的玩家")
        end
        setflagstatus(play, VarCfg.F_is_open_kuangbao, 0)
        --release_print("聚宝术层数：1  "..getflagstatus(actor,VarCfg["F_天命聚宝术"]))
        --聚宝术
        if getflagstatus(actor, VarCfg["F_天命聚宝术"]) == 1 then
            local num = getplaydef(actor, VarCfg["J_聚宝术层数"])
            --release_print("聚宝术层数："..num)
            if num < 50 then
                setplaydef(actor, VarCfg["J_聚宝术层数"], num + 1)
                --release_print("聚宝术层数："..num+1)
                addattlist(actor, "聚宝术", "=", "3#216#" .. (num + 1), 1)
                Player.buffTipsMsg(actor, "[聚宝术]:击杀狂暴玩家获得1%回收比例...")
            end
        end
        --气运-狂暴之子
        delattlist(actor, "狂暴之子")
        --掉狂暴后在本服删除称号
        if checkkuafu(play) then
            FKuaFuToBenFuDelTitle(play, "狂暴之力", "")
        else
            deprivetitle(play, "狂暴之力")
        end
        --删技能
        KuangBao.delsKill(play)
        seticon(play, ConstCfg.iconWhere.kuangbao, -1)
        local msgData = {
            { "", "你杀死拥有" },
            { "FF0000", "狂暴之力" },
            { "", "的玩家，获得" },
            { "FF0000", configKB.diaoluo[1][2] .. configKB.diaoluo[1][1] },
        }
        Player.sendmsg(actor, msgData)
        sendcentermsg(play, 250, 249, "战报：【" ..
            Player.GetNameEx(actor) .. "】干掉了拥有【狂暴之力】的[" ..
            Player.GetNameEx(play) .. "]获得" .. configKB.diaoluo[1][2] .. configKB.diaoluo[1][1] .. "奖励！！", 1, 5)
        Player.setAttList(play, "爆率附加")
        Player.setAttList(play, "属性附加")
    end
end

--使用十步一杀 对低等级的百分百麻痹
local function _onShiBuYiShan(actor, target)
    local MyLevel = getbaseinfo(actor, ConstCfg.gbase.level)
    local TgtLevel = getbaseinfo(target, ConstCfg.gbase.level)
    if MyLevel > TgtLevel then
        addbuff(target, 31078)
    end
end
GameEvent.add(EventCfg["使用十步一杀"], _onShiBuYiShan, KuangBao)

--人物死亡触发
GameEvent.add(EventCfg.onPlaydie, _playerkillplay, KuangBao)

--人物登录完成触发
GameEvent.add(EventCfg.onLoginEnd, KuangBaoLongin, KuangBao)
--跨服登录触发
GameEvent.add(EventCfg.onKFLogin, KuangBaoLongin, KuangBao)

-- ----------------------------↓↓↓ 外部调用 ↓↓↓---------------------------------------
--获取当前是否开启狂暴
function KuangBao.isOpenKB(actor)
    local kbbiaoji = getflagstatus(actor, VarCfg.F_is_open_kuangbao)
    return kbbiaoji == 1
end

return KuangBao

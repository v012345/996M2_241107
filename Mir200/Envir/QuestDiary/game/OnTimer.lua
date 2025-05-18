--全局定时器


function ontimerex1()
    if getsysvar(VarCfg["G_第一个玩家进入"]) > 2 then
        setsysvar(VarCfg["G_开区分钟计时器"], getsysvar(VarCfg["G_开区分钟计时器"]) + 1)
    end
    local varG1 = getsysvar(VarCfg["G_开区分钟计时器"])
    -- release_print("分钟定时器,varG1", varG1)
    GameEvent.push(EventCfg.gameEventTimer, varG1)
    
    --发放天选之人奖励
    -- local func = funOntimerex1[varG1]
    -- if func then
    --     func()
    -- end
end

--跨服攻沙同步数据
function ontimerex2()
    GameEvent.push(EventCfg.goKFGongShaSync)
end

--斩杀将夺旗定时器
function ontimerex3()
    GameEvent.push(EventCfg.onKFZhanJiangDuoQiSync)
end

--天下第一定时器
function ontimerex4()
    GameEvent.push(EventCfg.onKFTianXiaDiYiSync)
end

--攻城结束延时触发
function ontimerex24()
    GameEvent.push(EventCfg.goCastlewarend)
    setofftimerex(24)
end

------------------------------------个人定时器begin---------------------------------
function ontimer1(actor)
    local currHpPer = Player.getHpPercentage(actor) or 0
    if currHpPer == 100 then
        return
    end
    --地藏王禁止回血
    local diZangWangDeShiLianFlag = getplaydef(actor, VarCfg["M_地藏王标识"])
    if diZangWangDeShiLianFlag > 0 and diZangWangDeShiLianFlag < 5 then
        return
    end
    --天劫之路不回血
    if getplaydef(actor, VarCfg["M_天劫之路"]) > 0 then
        return
    end
    --异界地下城不回血
    if FCheckMap(actor,"dixiachengerceng") then
        return
    end
    if not hasbuff(actor, 10001) then
        local tzAddHp = getplaydef(actor, VarCfg["N$脱战恢复血量"])
        if tzAddHp > 0 then
            humanhp(actor, "+", math.ceil(Player.getHpValue(actor, tzAddHp)), 4)
        end
    end

    local sAddHp = tonumber(getplaydef(actor, VarCfg["N$每秒恢复血量"])) or 0
    if sAddHp > 0 then
        humanhp(actor, "+", sAddHp, 4)
    end
    local sAddMp = tonumber(getplaydef(actor, VarCfg["N$每秒恢复蓝量"])) or 0
    if sAddMp > 0 then
        humanmp(actor, "+", sAddMp)
    end
    
    if getflagstatus(actor, VarCfg["F_天命铮铮铁骨"]) == 1 then
        local hp = Player.getHpPercentage(actor)
        if hp > 60 and getplaydef(actor,"N$铮铮铁骨") == 1  then
            delattlist(actor,"铮铮铁骨")
            setplaydef(actor,"N$铮铮铁骨",0)
        end
    else
        if  getplaydef(actor,"N$铮铮铁骨") == 1 then
            delattlist(actor,"铮铮铁骨")
            setplaydef(actor,"N$铮铮铁骨",0)
        end
    end
end

--攻沙个人定时器
function ontimer2(actor)
    GameEvent.push(EventCfg.gocastlewaring, actor)
end

--实时清空暴击概率
function ontimer3(actor)
    if getflagstatus(actor, VarCfg["F_天命_致命专精标识"]) == 1 then
        -- release_print("清空暴击率")
        local baoJi = getbaseinfo(actor, ConstCfg.gbase.custom_attr, 21)
        if baoJi > 0 then
            changehumnewvalue(actor, 21, -10000, 655350)
        end
    end
end

--巡航定时器
function ontimer4(actor)
    GameEvent.push(EventCfg.onXunHangOnTime, actor)
end

--渡劫定时器_天劫之路
function ontimer5(actor)
    GameEvent.push(EventCfg.onDuJieOnTiemr, actor)
end

--福星棋盘奖励
function ontimer6(actor)
    GameEvent.push(EventCfg.onFXQPReward, actor)
end

--划水定时器
function ontimer7(actor)
    GameEvent.push(EventCfg.onQMHTimer, actor)
end

--摸鱼之王定时器
function ontimer8(actor)
    GameEvent.push(EventCfg.onMYZWimer, actor)
end

--激情泡点定时器
function ontimer9(actor)
    GameEvent.push(EventCfg.onJQPDimer, actor)
end

--永动机定时器
function ontimer10(actor)
    local currHpPer = Player.getHpPercentage(actor) or 0
    if currHpPer == 100 then
        return
    end
    local addHp = tonumber(getplaydef(actor, "N$永动机回血")) or 0
    humanhp(actor, "+", addHp, 4)
end

--月亮井回血
function ontimer11(actor)
    local currHpPer = Player.getHpPercentage(actor) or 0
    if currHpPer == 100 then
        return
    end
    humanhp(actor, "+", math.ceil(Player.getHpValue(actor, 20)), 4)
end

--复活队列1 每秒1执行
function ontimer101(actor)
    GameEvent.push(EventCfg.ReliveCountdown_1, actor)
end

--复活队列2 每秒1执行
function ontimer102(actor)
    GameEvent.push(EventCfg.ReliveCountdown_2, actor)
end

--复活队列3 每秒1执行
function ontimer103(actor)
    GameEvent.push(EventCfg.ReliveCountdown_3, actor)
end

--360分钟在线时常   60S一执行
function ontimer104(actor)
    local Num = getplaydef(actor, VarCfg["J_在线时间"])
    Num = Num + 1
    setplaydef(actor, VarCfg["J_在线时间"], Num)
    if Num <= 360 then
        GameEvent.push(EventCfg.onTimer104, actor)
    end
    --天命超级加倍
    if getflagstatus(actor,VarCfg["F_天命超级加倍"]) == 1 then
        addbuff(actor,31071,0,1,actor,{})
    end
end

local tb = {
    "小提示/小技巧：特殊背包神器可以不受夜晚视野影响，如，新月宝珠，妖月内丹，夜明珠等。",
    "小提示/小技巧：优先提升光环可以极大提升你的生存能力哦。",
    "小提示/小技巧：转生属性是可以累加的，不覆盖的。",
    "小提示/小技巧：疾风刻印是前期提升攻速的重要途径。",
    "小提示/小技巧：遗忘古迹的经验老人可以使用灵石兑换经验哦",
    "小提示/小技巧：焚天石，天工之锤可以在极恶大陆合成高级材料。",
    "小提示/小技巧：背包中可以选择是否回收可提升装备，强化装备。",
    "小提示/小技巧：全服鞭尸次数上限是3.",
    "小提示/小技巧：装备层级：普通装备---神器--稀有专属---神圣史诗---龍之魂器---超神器",
}

function ontimer105(actor)
    local random = math.random(1,#tb)
    callscriptex(actor,"SENDMSG",5,tb[random])
end

--哈法西斯之墓
function ontimer172(actor)
    GameEvent.push(EventCfg.HaFaXiSiZhiMuOnTimer, actor)
end

--哈法西斯之墓
function ontimer173(actor)
    GameEvent.push(EventCfg.HaFaXiSiJiTanOnTimer, actor)
end

--哈法西斯之墓雷劈
function ontimer174(actor)
    local myName = getbaseinfo(actor, ConstCfg.gbase.name)
    if not FCheckMap(actor, myName .. "哈法西斯之墓(一层)") then
        setofftimer(actor, 174)
    end
    if randomex(50) then
        local hpper = Player.getHpValue(actor, 5)
        humanhp(actor, "-", hpper)
        playeffect(actor, 1079, 0, 0, 1, 1, 1)
    end
end

function ontimer170(actor)
    GameEvent.push(EventCfg.HaFaXiSiZhiMuOnTimer, actor)
end

------------------------------------个人定时器end---------------------------------

AchievementTitle = {}

--发放窝囊废 --跨服禁止使用
function AchievementTitle.wonangfeifafang(actor)
    local data = {
        ["合格牛马"] ={{Money = "绑定金币", LL = 100000, LR = 1000000},{Money = "元宝", LL = 10000, LR = 100000},{Money = "绑定灵符", LL = 10, LR = 100}},
        ["勤劳牛马"] ={{Money = "绑定金币", LL = 200000, LR = 2000000},{Money = "元宝", LL = 20000, LR = 200000},{Money = "绑定灵符", LL = 50, LR = 500}},
        ["逆袭牛马"] ={{Money = "绑定金币", LL = 300000, LR = 3000000},{Money = "元宝", LL = 30000, LR = 300000},{Money = "绑定灵符", LL = 100, LR = 1000}},
        ["牛马之王"] ={{Money = "绑定金币", LL = 500000, LR = 5000000},{Money = "元宝", LL = 50000, LR = 500000},{Money = "绑定灵符", LL = 200, LR = 2000}},
    }
    local state = getplaydef(actor, VarCfg["Z_窝囊废领取状态"])
    if state ~= "已领取" then
        local DataTbl = {}
        local TitleName = ""
        for k, v in pairs(data) do
            if checktitle(actor, k) then
                DataTbl = v
                TitleName = k
                break
            end
        end
        if #DataTbl == 3 then
            local sort =  math.random(1, 3)
            local _DataTbl = DataTbl[sort]
            local MoneyNnm = math.random(_DataTbl.LL, _DataTbl.LR)
            local UserId = getconst(actor, "<$USERID>")
            sendmail(UserId, 20000, TitleName, "恭喜你,领取今天的绩效奖金[".. _DataTbl.Money.."]x".. MoneyNnm .."枚","".. _DataTbl.Money.. "#".. MoneyNnm .."")
            setplaydef(actor, VarCfg["Z_窝囊废领取状态"], "已领取")
        end
    end
end

local killplayTitle = {{var=1,title="初露锋芒"},{var=10,title="十战之勇"},{var=100,title="百战豪杰"},{var=1000,title="千杀战神"}}
local killkuangbaoplayTitle = {{var=1,title="怒斩初心"},{var=10,title="十破狂者"},{var=50,title="狂势如潮"},{var=100,title="百破狂煞"}}
--攻沙结束触发 攻沙结束时在皇宫内 50/100 --跨服同步完成
local function _goCastlewarend()
    --如果不在跨服
    if not checkkuafuserver() then
        local On_the_map_list = getplaycount("new0150", 0, 0)
        if On_the_map_list ~= "0" and type(On_the_map_list) == "table" then
            for _, actor in ipairs(On_the_map_list or {}) do
                if not checktitle(actor, "宫殿守卫") then
                    if randomex(50,100) then
                        confertitle(actor,"宫殿守卫")
                        GameEvent.push(EventCfg.onAddAchievementTitle, actor, "宫殿守卫")
                    end
                end
            end
        end
    else
        local On_the_map_list = getplaycount("kuafu0150", 0, 0)
        if On_the_map_list ~= "0" and type(On_the_map_list) == "table" then
            for _, actor in ipairs(On_the_map_list or {}) do
                FKuaFuToBenFuRunScript(actor,1,"")
            end
        end
    end
end
GameEvent.add(EventCfg.goCastlewarend, _goCastlewarend, AchievementTitle)

--连续击玩家触发 -- 跨服Ok
local InTheCastleKillPlayerTitlb = {{var=5,title="五连斩"},{var=10,title="沙城人屠"}}
local function _onContinuousKillPlayer(actor, KillNum)
    --怒斩三连 在狂暴状态下连续击杀三个目标（10s） 
    if checkkuafu(actor) then
        FKuaFuToBenFuRunScript(actor, 2, KillNum)
    else
        if not checktitle(actor, "怒斩三连") then
            if getflagstatus(actor, VarCfg.F_is_open_kuangbao) == 1 then
                if KillNum >= 3 then
                    confertitle(actor,"怒斩三连")
                    GameEvent.push(EventCfg.onAddAchievementTitle, actor, "怒斩三连")
                end
            end
        end
    end
    -- 攻沙期间连续 在皇宫内 
    if castleinfo(5) then
        if checkkuafu(actor) then
            if FCheckMap(actor, "kuafu0150") then
                FKuaFuToBenFuRunScript(actor, 3, KillNum)
            end
        else
            if not checktitle(actor, "沙城人屠") then
                if FCheckMap(actor, "new0150") then
                    local NewTitle,OldTitle = Player.getNewandOldTitle(actor,KillNum, InTheCastleKillPlayerTitlb)
                    if NewTitle == "" then return end
                    if not checktitle(actor, NewTitle) then
                        if checktitle(actor, OldTitle) then
                            deprivetitle(actor,OldTitle)
                        end
                        confertitle(actor,NewTitle) --添加新的称号
                        GameEvent.push(EventCfg.onAddAchievementTitle, actor, NewTitle)
                    end
                end
            end
        end
    end
end
GameEvent.add(EventCfg.onContinuousKillPlayer, _onContinuousKillPlayer, AchievementTitle)

--杀人触发
local function _onkillplayQiYu(actor, hiter)
    local killplaynum1 = getplaydef(actor,VarCfg["U_击杀次数"])
    local killplaynum2 = getplaydef(actor,VarCfg["U_击杀狂暴玩家数量"])

    if not checktitle(actor, "千杀战神") then
        local KillNum = getplaydef(actor,VarCfg["U_杀人数"])
        local NewTitle,OldTitle = Player.getNewandOldTitle(actor,KillNum, killplayTitle)
        if NewTitle == "" then return end
        if not checktitle(actor, NewTitle) then
            if checktitle(actor, OldTitle) then
                deprivetitle(actor,OldTitle)
            end
            confertitle(actor,NewTitle) --添加新的称号
            GameEvent.push(EventCfg.onAddAchievementTitle, actor, NewTitle)
        end
    end

    if killplaynum2 < 100 then
        setplaydef(actor,VarCfg["U_击杀狂暴玩家数量"], killplaynum2 + 1 )
        local NewTitle,OldTitle = Player.getNewandOldTitle(actor,killplaynum2 + 1, killkuangbaoplayTitle)
        if NewTitle == "" then return end
        if not checktitle(actor, NewTitle) then
            if checktitle(actor, OldTitle) then
                deprivetitle(actor,OldTitle)
                setplaydef(actor,VarCfg["U_狂暴成就增伤"], 0)
            end
            confertitle(actor,NewTitle) --添加新的称号
            GameEvent.push(EventCfg.onAddAchievementTitle, actor, NewTitle)
        end
        if VarCfg == "怒斩初心" then
            setplaydef(actor,VarCfg["U_狂暴成就增伤"], 1)
        elseif VarCfg == "十破狂者" then
            setplaydef(actor,VarCfg["U_狂暴成就增伤"], 2)
        elseif VarCfg == "狂势如潮" then
            setplaydef(actor,VarCfg["U_狂暴成就增伤"], 3)
        elseif VarCfg == "百破狂煞" then
            setplaydef(actor,VarCfg["U_狂暴成就增伤"], 5)
        end
    end
end
GameEvent.add(EventCfg.onkillplayQiYu, _onkillplayQiYu, AchievementTitle)

--攻击玩家前触发   --狂暴成就增伤
local function _onAttackDamageMonster(actor, Target, Hiter, MagicId, Damage, Model, attackDamageData)
    local attnum = getplaydef(actor,VarCfg["U_狂暴成就增伤"])
    if attnum > 0 then
        if getflagstatus(Target, VarCfg.F_is_open_kuangbao) == 1 then
            attackDamageData.damage = attackDamageData.damage + Damage*(attnum/100)
        else
            attackDamageData.damage = attackDamageData.damage + Damage*(attnum/50)
        end
    end
    if checktitle(actor, "潜龙在渊") then
        local boolean = MagicId ~= 26 and MagicId ~= 66 and MagicId ~= 56
        if not boolean then
            attackDamageData.damage = attackDamageData.damage + Damage*0.05
        end
    end
end
GameEvent.add(EventCfg.onAttackDamageMonster, _onAttackDamageMonster, AchievementTitle)

--死亡触发 --需要跨服 -- OK
local PlaydieTitle = {{var=10,title="十劫初尝"},{var=100,title="百死不悔"},{var=300,title="三百劫数"},{var=500,title="不死传说"}}
local function _onPlaydieQiYu(actor)
    if not checktitle(actor, "不死传说") then
        local dienum = getplaydef(actor,VarCfg["U_被杀数"])
        local NewTitle,OldTitle = Player.getNewandOldTitle(actor,dienum, PlaydieTitle)
        if NewTitle == "" then return end
        if not checktitle(actor, NewTitle) then
            if checktitle(actor, OldTitle) then
                deprivetitle(actor,OldTitle)
            end
            confertitle(actor,NewTitle) --添加新的称号
            GameEvent.push(EventCfg.onAddAchievementTitle, actor, NewTitle)
        end
    end
end
GameEvent.add(EventCfg.onPlaydieQiYu, _onPlaydieQiYu, AchievementTitle)

--沙巴克领取胜利方奖励 --需要跨服
local CastleRewardsTitle = {{var=1,title="首战告捷"},{var=5,title="连战连胜"},{var=10,title="荣耀霸主"}}
local function _GetCastleRewards(actor)
    local winnum = getplaydef(actor,VarCfg["U_沙巴克胜利方次数"])
    if winnum < 10 then
        setplaydef(actor,VarCfg["U_沙巴克胜利方次数"], winnum + 1 )
        local NewTitle,OldTitle = Player.getNewandOldTitle(actor,winnum + 1, CastleRewardsTitle)
        if NewTitle == "" then return end
        if not checktitle(actor, NewTitle) then
            if checktitle(actor, OldTitle) then
                deprivetitle(actor,OldTitle)
            end
            confertitle(actor,NewTitle) --添加新的称号
            GameEvent.push(EventCfg.onAddAchievementTitle, actor, NewTitle)
        end
    end
end
GameEvent.add(EventCfg.GetCastleRewards, _GetCastleRewards, AchievementTitle)

--累计开启10次狂暴
local function _OpenKuangBao(actor)
    local opennum = getplaydef(actor,VarCfg["U_累计开启狂暴"])
    if opennum < 10 then
        setplaydef(actor,VarCfg["U_累计开启狂暴"], opennum + 1 )
        if opennum + 1 == 10 then
            confertitle(actor,"怒意滔天")
            GameEvent.push(EventCfg.onAddAchievementTitle, actor, "怒意滔天")
        end
    end
end
GameEvent.add(EventCfg.OpenKuangBao, _OpenKuangBao, AchievementTitle)

-- 杀怪触发   
local killMonTitle_BaiMing = {{var=100,title="追梦人LV.1"},{var=300,title="追梦人LV.2"},{var=500,title="追梦人LV.3"},{var=1000,title="追梦人LV.4"}}
local killMonTitle_HunDun = {{var=10,title="混沌传说LV.1"},{var=30,title="混沌传说LV.2"},{var=50,title="混沌传说LV.3"},{var=100,title="混沌传说LV.4"}}

local AchievementTitleMonData = include("QuestDiary/cfgcsv/cfg_AchievementTitleMonData.lua")
local function _onKillMon(actor, monobj, monName)
    if checkkuafu(actor) then
        return
    end
    --闪电战 10秒内击杀10只以上怪物概率触发 1/88
    if not checktitle(actor, "闪电战") then
        local buff = hasbuff(actor, 31021)
        if buff then
            local killMonNum = getplaydef(actor,VarCfg["N$闪电战计数"])
            setplaydef(actor,VarCfg["N$闪电战计数"], killMonNum+1)
            if killMonNum+1 >= 10 then
                if randomex(1, 88) then
                    confertitle(actor,"闪电战")
                    Player.setAttList(actor, "爆率附加")
                    GameEvent.push(EventCfg.onAddAchievementTitle, actor, "闪电战")
                end
            end
        else
            addbuff(actor,31021,10,1,actor)
        end
    end

    --单日击杀怪物1800只
    if not checktitle(actor, "割草机") then
        local KillMonNum = getplaydef(actor,VarCfg["J_奇遇单日杀怪总数"])
        if KillMonNum < 1800 then
            setplaydef(actor,VarCfg["J_奇遇单日杀怪总数"], KillMonNum+1)
            if KillMonNum + 1 == 1800 then
                confertitle(actor,"割草机")
                Player.setAttList(actor, "爆率附加")
                Player.setAttList(actor, "属性附加")
                GameEvent.push(EventCfg.onAddAchievementTitle, actor, "割草机")
            end
        end
    end
    local MonName = monName
    local cfg = AchievementTitleMonData[MonName]
    if cfg then
        if cfg.Types == "精英怪" then
            --击杀精英怪物概率触发   1/1000
            if randomex(1, 1000) then
                if not checktitle(actor, "打得就是精英") then
                    confertitle(actor,"打得就是精英")
                    Player.setAttList(actor, "属性附加")
                    GameEvent.push(EventCfg.onAddAchievementTitle, actor, "打得就是精英")
                end
            end
        elseif cfg.Types == "白怪BOSS" then
            local KillMonNum1 = getplaydef(actor,VarCfg["J_奇遇单日击杀白怪"])
            local KillMonNum2 = getplaydef(actor,VarCfg["U_奇遇击杀白名BOSS"])
            --击杀白名BOSS概率触发 1/200
            if randomex(1, 200) then
                if not checktitle(actor, "马上就爆") then
                    confertitle(actor,"马上就爆")
                    Player.setAttList(actor, "爆率附加")
                    Player.setAttList(actor, "属性附加")
                    GameEvent.push(EventCfg.onAddAchievementTitle, actor, "马上就爆")
                end
            end
            --单日击杀白怪500只
            if not checktitle(actor, "扣怪狂魔") then
                if KillMonNum1 < 500 then
                    setplaydef(actor,VarCfg["J_奇遇单日击杀白怪"], KillMonNum1+1)
                    if KillMonNum1 + 1 == 500 then
                        confertitle(actor,"扣怪狂魔")
                        Player.setAttList(actor, "爆率附加")
                        Player.setAttList(actor, "属性附加")
                        GameEvent.push(EventCfg.onAddAchievementTitle, actor, "扣怪狂魔")
                    end
                end
            end
            if KillMonNum2 < 1000 then
                setplaydef(actor,VarCfg["U_奇遇击杀白名BOSS"], KillMonNum2 + 1 )
                if not checktitle(actor, "追梦人LV.4") then
                    local NewTitle,OldTitle = Player.getNewandOldTitle(actor,KillMonNum2 + 1, killMonTitle_BaiMing)
                    if NewTitle == "" then return end
                    if not checktitle(actor, NewTitle) then
                        if checktitle(actor, OldTitle) then
                            deprivetitle(actor,OldTitle)
                        end
                        confertitle(actor,NewTitle) --添加新的称号
                        Player.setAttList(actor, "爆率附加")
                        Player.setAttList(actor, "属性附加")
                        GameEvent.push(EventCfg.onAddAchievementTitle, actor, NewTitle)
                    end
                end
            end
        elseif cfg.Types == "混沌BOSS" then
            local KillMonNum = getplaydef(actor,VarCfg["U_奇遇击杀混沌BOSS"])
            if KillMonNum < 100 then
                setplaydef(actor,VarCfg["U_奇遇击杀混沌BOSS"], KillMonNum + 1 )
                if not checktitle(actor, "混沌传说LV.4") then
                    local NewTitle,OldTitle = Player.getNewandOldTitle(actor,KillMonNum + 1, killMonTitle_HunDun)
                    if NewTitle == "" then return end
                    if not checktitle(actor, NewTitle) then
                        if checktitle(actor, OldTitle) then
                            deprivetitle(actor,OldTitle)
                        end
                        confertitle(actor,NewTitle) --添加新的称号
                        GameEvent.push(EventCfg.onAddAchievementTitle, actor, NewTitle)
                    end
                end
            end
            if not checktitle(actor, "七杀之主") then
                local tbl =  Player.getJsonTableByVar(actor, VarCfg["T_击杀混沌BOSS"])
                local function ipairsMonTbl()
                    local _bool = true
                    for _, value in ipairs(tbl) do
                        if value == MonName then
                            _bool = false
                            break
                        end
                    end
                    return _bool
                end
                if #tbl == 0 then
                    table.insert(tbl,MonName)
                    Player.setJsonVarByTable(actor, VarCfg["T_击杀混沌BOSS"],tbl)
                elseif #tbl < 7 then
                    if ipairsMonTbl() then
                        table.insert(tbl,MonName)
                        Player.setJsonVarByTable(actor, VarCfg["T_击杀混沌BOSS"],tbl)
                    end
                end
                if #tbl == 7 then
                    confertitle(actor,"七杀之主")
                    GameEvent.push(EventCfg.onAddAchievementTitle, actor, "七杀之主")
                end
            end
        end
    end
end
GameEvent.add(EventCfg.onKillMon, _onKillMon, AchievementTitle)

--连杀计时buff清空连杀计数
local function _onBuffChange(actor, buffid, groupid, model)
    if buffid == 31021 then
        if model == 4 then
            setplaydef(actor,VarCfg["N$闪电战计数"], 0)
        end
    end
    if buffid == 31020 then
        if model == 4 then
            setplaydef(actor,VarCfg["N$怒斩三连计数"], 0)
        end
    end
end
GameEvent.add(EventCfg.onBuffChange, _onBuffChange, AchievementTitle)

--战力计算完成后触发
local PowerTitle ={{var=100000,title="战力初显"},{var=500000,title="战力渐盛"},{var=1000000,title="战力卓然"},{var=5000000,title="战力非凡"},{var=10000000,title="战力巅峰"}}
local function _OverloadPower(actor, power)
    if checkkuafu(actor) then return end
    local _power = tonumber (power)
    if not checktitle(actor, "战力巅峰") then
        local NewTitle,OldTitle = Player.getNewandOldTitle(actor,_power, PowerTitle)
        if NewTitle == "" then return end
        if not checktitle(actor, NewTitle) then
            if checktitle(actor, OldTitle) then
                deprivetitle(actor,OldTitle)
            end
            confertitle(actor,NewTitle) --添加新的称号
            GameEvent.push(EventCfg.onAddAchievementTitle, actor, NewTitle)
        end
    end
end
GameEvent.add(EventCfg.OverloadPower, _OverloadPower, AchievementTitle)


--攻击速度刷新
local AttackSpeedTitle = {{var=200,title="极速之影LV.1"},{var=300,title="极速之影LV.2"},{var=400,title="极速之影LV.3"},{var=500,title="极速之影LV.4"},{var=600,title="极速之影LV.5"}}
function qi_yu_cheng_hao_gong_su_calc(actor,attSpeed)
    attSpeed = tonumber(attSpeed) or 0
    if not checktitle(actor, "极速之影LV.5") then
        local NewTitle,OldTitle = Player.getNewandOldTitle(actor,attSpeed, AttackSpeedTitle)
        if NewTitle == "" then return end
        if not checktitle(actor, NewTitle) then
            if checktitle(actor, OldTitle) then
                deprivetitle(actor,OldTitle)
            end
            confertitle(actor,NewTitle) --添加新的称号
            GameEvent.push(EventCfg.onAddAchievementTitle, actor, NewTitle)
        end
    end
end
local function _OverloadGongSu(actor, attSpeed)
    if checkkuafu(actor) then
        return
    end
    -- release_print("攻击速度刷新",attSpeed)
    delaygoto(actor,10600,"qi_yu_cheng_hao_gong_su_calc,"..attSpeed)
    
end
GameEvent.add(EventCfg.OverloadGongSu, _OverloadGongSu, AchievementTitle)

--爆率刷新
local BaoLvTitle = {{var=200,title="爆爆爆LV.1"},{var=400,title="爆爆爆LV.2"},{var=800,title="爆爆爆LV.3"},{var=1000,title="爆爆爆LV.4"},{var=2000,title="爆爆爆LV.5"}}
function qi_yu_cheng_hao_bao_lv(actor,var)
    var = tonumber(var)
    if not checktitle(actor, "爆爆爆LV.5") then
        local NewTitle,OldTitle = Player.getNewandOldTitle(actor,var, BaoLvTitle)
        if NewTitle == "" then return end
        if not checktitle(actor, NewTitle) then
            if checktitle(actor, OldTitle) then
                deprivetitle(actor,OldTitle)
            end
            confertitle(actor,NewTitle) --添加新的称号
            Player.setAttList(actor, "属性附加")
            GameEvent.push(EventCfg.onAddAchievementTitle, actor, NewTitle)
        end
    end
end
local function _OverloadBaoLv(actor, var)
    if checkkuafu(actor) then
        return
    end
    delaygoto(actor,10200,"qi_yu_cheng_hao_bao_lv,"..var)
end
GameEvent.add(EventCfg.OverloadBaoLv, _OverloadBaoLv, AchievementTitle)

--收集装扮
local UPSkinTitle = {{var=3,title="时尚潮人"},{var=10,title="时尚达人"},{var=30,title="时尚领袖"},{var=50,title="时尚教主"}}
local function _onUPSkin(actor,var)
    if not checktitle(actor, "时尚教主") then
        local NewTitle,OldTitle = Player.getNewandOldTitle(actor,var, UPSkinTitle)
        if NewTitle == "" then return end
        if not checktitle(actor, NewTitle) then
            if checktitle(actor, OldTitle) then
                deprivetitle(actor,OldTitle)
            end
            confertitle(actor,NewTitle) --添加新的称号
            GameEvent.push(EventCfg.onAddAchievementTitle, actor, NewTitle)
        end
    end
end
GameEvent.add(EventCfg.onUPSkin, _onUPSkin, AchievementTitle)

-- 同时佩戴X件稀有专属装备
local ZhuanShuZhuangBeiTitle = {{var=3,title="专属体验"},{var=5,title="专属收藏"},{var=10,title="专属大师"},{var=20,title="专属专家"},{var=30,title="专属宗师"}}
local function SetZhuanShuZhuangBeiTitle(actor, var)
    if not checktitle(actor, "专属宗师") then
        local NewTitle,OldTitle = Player.getNewandOldTitle(actor,var, ZhuanShuZhuangBeiTitle)
        if NewTitle == "" then return end
        if not checktitle(actor, NewTitle) then
            if checktitle(actor, OldTitle) then
                deprivetitle(actor,OldTitle)
            end
            confertitle(actor,NewTitle) --添加新的称号
            GameEvent.push(EventCfg.onAddAchievementTitle, actor, NewTitle)
        end
    end
end

-- 同时佩戴X件超神器装备
local ChaoShenQiZhuangBeiTitle = {{var=1,title="超神启示"},{var=3,title="超神觉醒"},{var=6,title="超神显赫"},{var=10,title="超神巅峰"}}
local function SetChaoShenQiZhuangBeiTitle(actor, var)
    if not checktitle(actor, "超神巅峰") then
        local NewTitle,OldTitle = Player.getNewandOldTitle(actor,var, ChaoShenQiZhuangBeiTitle)
        if NewTitle == "" then return end
        if not checktitle(actor, NewTitle) then
            if checktitle(actor, OldTitle) then
                deprivetitle(actor,OldTitle)
            end
            confertitle(actor,NewTitle) --添加新的称号
            GameEvent.push(EventCfg.onAddAchievementTitle, actor, NewTitle)
        end
    end
end

local ZhuShuCfg = include("QuestDiary/cfgcsv/cfg_ZhuanShuZhuangBei.lua")       --专属装备名单
local ChaoShenQiCfg = include("QuestDiary/cfgcsv/cfg_ChaoShenQiZhuangBei.lua") --超神器装备
--穿戴触发
local function _onTakeOnEx(actor, itemobj, where, itemname, makeid)
    local itemcfg1 = ZhuShuCfg[itemname]
    local itemcfg2 = ChaoShenQiCfg[itemname]
    if itemcfg1 then
        local num = getplaydef(actor,VarCfg["U_穿戴专属装备数量"])
        setplaydef(actor,VarCfg["U_穿戴专属装备数量"], num + 1)
        SetZhuanShuZhuangBeiTitle(actor, getplaydef(actor,VarCfg["U_穿戴专属装备数量"]))
    end
    if itemcfg2 then
        local num = getplaydef(actor,VarCfg["U_穿戴超神器装备数量"])
        setplaydef(actor,VarCfg["U_穿戴超神器装备数量"], num + 1)
        SetChaoShenQiZhuangBeiTitle(actor, getplaydef(actor,VarCfg["U_穿戴超神器装备数量"]))
    end
end
GameEvent.add(EventCfg.onTakeOnEx, _onTakeOnEx, AchievementTitle)
--脱掉触发
local function _onTakeOffEx(actor, itemobj, where, itemname, makeid)
    local itemcfg1 = ZhuShuCfg[itemname]
    local itemcfg2 = ChaoShenQiCfg[itemname]
    if itemcfg1 then
        local num = getplaydef(actor,VarCfg["U_穿戴专属装备数量"])
        if num > 0 then
            setplaydef(actor,VarCfg["U_穿戴专属装备数量"], num - 1)
        end
        SetZhuanShuZhuangBeiTitle(actor, getplaydef(actor,VarCfg["U_穿戴专属装备数量"]))
    end
    if itemcfg2 then
        local num = getplaydef(actor,VarCfg["U_穿戴超神器装备数量"])
        if num > 0 then
            setplaydef(actor,VarCfg["U_穿戴超神器装备数量"], num - 1)
        end
        SetChaoShenQiZhuangBeiTitle(actor, getplaydef(actor,VarCfg["U_穿戴超神器装备数量"]))
    end
end
GameEvent.add(EventCfg.onTakeOffEx, _onTakeOffEx, AchievementTitle)

--金币累计
local MoneyJinBiTitle = {{var = 999999, title = "金铃小响"},{var = 9999999, title = "金银满仓"},{var = 99999999, title = "金玉满堂"}}
local function _OverloadMoneyJinBi(actor, MoneyNum)
    if not checktitle(actor, "金玉满堂") then
        local NewTitle,OldTitle = Player.getNewandOldTitle(actor,MoneyNum, MoneyJinBiTitle)
        if NewTitle == "" then return end
        if not checktitle(actor, NewTitle) then
            if checktitle(actor, OldTitle) then
                deprivetitle(actor,OldTitle)
            end
            confertitle(actor,NewTitle) --添加新的称号
            GameEvent.push(EventCfg.onAddAchievementTitle, actor, NewTitle)
        end
    end
end
GameEvent.add(EventCfg.OverloadMoneyJinBi, _OverloadMoneyJinBi, AchievementTitle)

--元宝累计
local MoneyYuanBaoTitle = {{var = 99999, title = "元启富源"},{var = 999999, title = "元盛财阀"},{var = 9999999, title = "元宝至尊"}}
local function _OverloadMoneyYuanBao(actor, MoneyNum)
    if not checktitle(actor, "元宝至尊") then
        local NewTitle,OldTitle = Player.getNewandOldTitle(actor,MoneyNum, MoneyYuanBaoTitle)
        if NewTitle == "" then return end
        if not checktitle(actor, NewTitle) then
            if checktitle(actor, OldTitle) then
                deprivetitle(actor,OldTitle)
            end
            confertitle(actor,NewTitle) --添加新的称号
            GameEvent.push(EventCfg.onAddAchievementTitle, actor, NewTitle)
        end
    end
end
GameEvent.add(EventCfg.OverloadMoneyYuanBao, _OverloadMoneyYuanBao, AchievementTitle)

-- 灵符累计
local MoneyLingFuTitle = {{var = 99, title = "钱途无量"},{var = 999, title = "财运亨通"},{var = 9999, title = "富甲天下"}}
local function _OverloadMoneyLingFu(actor, MoneyNum)
    if not checktitle(actor, "富甲天下") then
        local NewTitle,OldTitle = Player.getNewandOldTitle(actor,MoneyNum, MoneyLingFuTitle)
        if NewTitle == "" then return end
        if not checktitle(actor, NewTitle) then
            if checktitle(actor, OldTitle) then
                deprivetitle(actor,OldTitle)
            end
            confertitle(actor,NewTitle) --添加新的称号
            GameEvent.push(EventCfg.onAddAchievementTitle, actor, NewTitle)
        end
    end
end
GameEvent.add(EventCfg.OverloadMoneyLingFu, _OverloadMoneyLingFu, AchievementTitle)

--累计消耗
local XiaoHaoJinBiTitle = {{var = 1000000, title = "千金散尽"},{var = 10000000, title = "挥金如土"},{var = 100000000, title = "一掷千金"},{var = 1000000000, title = "富贵无边"}}
local XiaoHaoYuanBaoTitle = {{var = 100000, title = "豪气冲天"},{var = 1000000, title = "财倾天下"},{var = 10000000, title = "挥毫万金"}}
local XiaoHaoLingFuTitle = {{var = 1000, title = "符动乾坤"},{var = 3000, title = "符耀九州"},{var = 5000, title = "符破苍穹"}}
local function _onCostMoney( actor, MoneyName, MoneyNum)
    if MoneyName == "金币" then
        if not checktitle(actor, "富贵无边") then
            local num = getplaydef(actor,VarCfg["B_累计消耗_金币"])
            setplaydef(actor,VarCfg["B_累计消耗_金币"], num + MoneyNum)
            local NewTitle,OldTitle = Player.getNewandOldTitle(actor,num + MoneyNum, XiaoHaoJinBiTitle)
            if NewTitle == "" then return end
            if not checktitle(actor, NewTitle) then
                if checktitle(actor, OldTitle) then
                    deprivetitle(actor,OldTitle)
                end
                confertitle(actor,NewTitle) --添加新的称号
                GameEvent.push(EventCfg.onAddAchievementTitle, actor, NewTitle)
            end
        end
    elseif MoneyName == "元宝" then
        if not checktitle(actor, "挥毫万金") then
            local num = getplaydef(actor,VarCfg["B_累计消耗_元宝"])
            setplaydef(actor,VarCfg["B_累计消耗_元宝"],num + MoneyNum)
            local NewTitle,OldTitle = Player.getNewandOldTitle(actor,num + MoneyNum, XiaoHaoYuanBaoTitle)
            if NewTitle == "" then return end
            if not checktitle(actor, NewTitle) then
                if checktitle(actor, OldTitle) then
                    deprivetitle(actor,OldTitle)
                end
                confertitle(actor,NewTitle) --添加新的称号
                GameEvent.push(EventCfg.onAddAchievementTitle, actor, NewTitle)
            end
        end
    elseif MoneyName == "灵符" then
        if not checktitle(actor, "符破苍穹") then
            local num = getplaydef(actor,VarCfg["B_累计消耗_灵符"])
            setplaydef(actor,VarCfg["B_累计消耗_灵符"],num + MoneyNum)
            local NewTitle,OldTitle = Player.getNewandOldTitle(actor,num + MoneyNum, XiaoHaoLingFuTitle)
            if NewTitle == "" then return end
            if not checktitle(actor, NewTitle) then
                if checktitle(actor, OldTitle) then
                    deprivetitle(actor,OldTitle)
                end
                confertitle(actor,NewTitle) --添加新的称号
                GameEvent.push(EventCfg.onAddAchievementTitle, actor, NewTitle)
            end
        end
    end
end
GameEvent.add(EventCfg.onCostMoney, _onCostMoney, AchievementTitle)

--回收完成
local HuiShouJinBiTitle = {{var = 100000, title = "拾金有道"},{var = 1000000, title = "聚财成山"},{var = 10000000, title = "回收巨擘"}}
local HuiShouLingShiTitle = {{var = 50, title = "灵石拾遗"},{var = 500, title = "灵石聚财"},{var = 2000, title = "灵石大师"},{var = 5000, title = "灵石巨匠"}}
local HuiShouShuiJingTitle = {{var = 50, title = "晶初回收"},{var = 500, title = "晶运累积"},{var = 5000, title = "晶聚千载"},{var = 10000, title = "晶界大成"}}
local function _onHuiShouFinish(actor, giveArray)
    for _, Item in ipairs(giveArray) do
        local ItemName, ItemNumber = Item[1], Item[2]
        if ItemName == "金币" then
            if not checktitle(actor, "回收巨擘") then
                local num = getplaydef(actor,VarCfg["B_累计回收_金币"])
                setplaydef(actor,VarCfg["B_累计回收_金币"],num + ItemNumber)
                local NewTitle,OldTitle = Player.getNewandOldTitle(actor,num + ItemNumber,HuiShouJinBiTitle)
                if NewTitle == "" then return end
                if not checktitle(actor, NewTitle) then
                    if checktitle(actor, OldTitle) then
                        deprivetitle(actor,OldTitle)
                    end
                    confertitle(actor,NewTitle) --添加新的称号
                    GameEvent.push(EventCfg.onAddAchievementTitle, actor, NewTitle)
                end
            end
        elseif ItemName == "灵石" then
            if not checktitle(actor, "灵石巨匠") then
                local num = getplaydef(actor,VarCfg["B_累计回收_灵石"])
                setplaydef(actor,VarCfg["B_累计回收_灵石"],num + ItemNumber)
                local NewTitle,OldTitle = Player.getNewandOldTitle(actor,num + ItemNumber,HuiShouLingShiTitle)
                if NewTitle == "" then return end
                if not checktitle(actor, NewTitle) then
                    if checktitle(actor, OldTitle) then
                        deprivetitle(actor,OldTitle)
                    end
                    confertitle(actor,NewTitle) --添加新的称号
                    GameEvent.push(EventCfg.onAddAchievementTitle, actor, NewTitle)
                end
            end
        elseif ItemName == "幻灵水晶" then
            if not checktitle(actor, "晶界大成") then
                local num = getplaydef(actor,VarCfg["B_累计回收_幻灵水晶"])
                setplaydef(actor,VarCfg["B_累计回收_幻灵水晶"],num + ItemNumber)
                local NewTitle,OldTitle = Player.getNewandOldTitle(actor,num + ItemNumber,HuiShouShuiJingTitle)
                if NewTitle == "" then return end
                if not checktitle(actor, NewTitle) then
                    if checktitle(actor, OldTitle) then
                        deprivetitle(actor,OldTitle)
                    end
                    confertitle(actor,NewTitle) --添加新的称号
                    GameEvent.push(EventCfg.onAddAchievementTitle, actor, NewTitle)
                end
            end
        end
    end
end
GameEvent.add(EventCfg.onHuiShouFinish, _onHuiShouFinish, AchievementTitle)

--开启极限潜能触发
local JiXianQianNengTitle = {{var = 10, title = "潜能初醒"},{var = 30, title = "潜能涌动"},{var = 50, title = "潜能觉醒"},{var = 100, title = "潜能极致"}}
local function _onOpenJiXianQianNeng(actor, num)
    -- release_print("开启极限潜能触发", num)
    if not checktitle(actor, "潜能极致") then
        local NewTitle,OldTitle = Player.getNewandOldTitle(actor,num,JiXianQianNengTitle)
        if NewTitle == "" then return end
        if not checktitle(actor, NewTitle) then
            if checktitle(actor, OldTitle) then
                deprivetitle(actor,OldTitle)
            end
            confertitle(actor,NewTitle) --添加新的称号
            GameEvent.push(EventCfg.onAddAchievementTitle, actor, NewTitle)
        end
    end
end
GameEvent.add(EventCfg.onOpenJiXianQianNeng, _onOpenJiXianQianNeng, AchievementTitle)

--使用记忆石概率触发
local function _onUseJiLuShi(actor)
    if not checktitle(actor, "老马识途") then
        if randomex(1, 100) then
            confertitle(actor,"老马识途")
            Player.setAttList(actor, "爆率附加")
            GameEvent.push(EventCfg.onAddAchievementTitle, actor, "老马识途")
        end
    end
end
GameEvent.add(EventCfg.onUseJiLuShi, _onUseJiLuShi, AchievementTitle)

--进入地图概率触发
local function _goEnterMap(actor, cur_mapid)
    --在跨服不触发云游四海
    if checkkuafu(actor) then
        return
    end
    if not checktitle(actor, "云游四海") then
        if randomex(1, 100) then
            confertitle(actor,"云游四海")
            Player.setAttList(actor, "爆率附加")
            GameEvent.push(EventCfg.onAddAchievementTitle, actor, "云游四海")
        end
    end
end
GameEvent.add(EventCfg.goEnterMap, _goEnterMap, AchievementTitle)

--累计进入副本触发
local JinRuFuBenTitle = {{var = 10, title = "初入裂隙"},{var = 20, title = "裂隙探索者"},{var = 30, title = "裂隙征服者"}}
local function _onEntetMirrorMap(actor)
    if not checktitle(actor, "裂隙征服者") then
        local num = getplaydef(actor,VarCfg["U_累计进入副本"])
        setplaydef(actor,VarCfg["U_累计进入副本"],num + 1)
        local NewTitle,OldTitle = Player.getNewandOldTitle(actor,num + 1,JinRuFuBenTitle)
        if NewTitle == "" then return end
        if not checktitle(actor, NewTitle) then
            if checktitle(actor, OldTitle) then
                deprivetitle(actor,OldTitle)
            end
            confertitle(actor,NewTitle) --添加新的称号
            GameEvent.push(EventCfg.onAddAchievementTitle, actor, NewTitle)
        end
    end
end
GameEvent.add(EventCfg.onEntetMirrorMap, _onEntetMirrorMap, AchievementTitle)

--在云游商人购买东西概率触发
local function _onYunYouShangRneBuy(actor)
    if not checktitle(actor, "路边摊") then
        if randomex(1, 100) then
            confertitle(actor,"路边摊")
            GameEvent.push(EventCfg.onAddAchievementTitle, actor, "路边摊")
        end
    end
end
GameEvent.add(EventCfg.onYunYouShangRneBuy, _onYunYouShangRneBuy, AchievementTitle)

--在黑市商人购买东西概率触发
local function _onHeiShiShangRneBuy(actor)
    if not checktitle(actor, "暗市奇缘") then
        if randomex(1, 100) then
            confertitle(actor,"暗市奇缘")
            GameEvent.push(EventCfg.onAddAchievementTitle, actor, "暗市奇缘")
        end
    end
end
GameEvent.add(EventCfg.onHeiShiShangRneBuy, _onHeiShiShangRneBuy, AchievementTitle)

--在钱庄老板购买东西概率触发
local function _onQianZhuangLaoBanBuy(actor)
    if not checktitle(actor, "富贵临门") then
        if randomex(1, 100) then
            confertitle(actor,"富贵临门")
            GameEvent.push(EventCfg.onAddAchievementTitle, actor, "富贵临门")
        end
    end
end
GameEvent.add(EventCfg.onQianZhuangLaoBanBuy, _onQianZhuangLaoBanBuy, AchievementTitle)

--单件装备洗炼五条属性
local function _onZhuangBeiXiLian(actor,setLevel)
    if setLevel ~= 5 then return end
    if not checktitle(actor, "五灵觉醒") then
        confertitle(actor,"五灵觉醒")
        GameEvent.push(EventCfg.onAddAchievementTitle, actor, "五灵觉醒")
    end
end
GameEvent.add(EventCfg.onZhuangBeiXiLian, _onZhuangBeiXiLian, AchievementTitle)

--修仙境界达到潜龙境 
local function _onXiuXianUP(actor,itemname)
    if itemname ~= "潜龙阴阳石" then return end
    if not checktitle(actor, "潜龙在渊") then
        confertitle(actor,"潜龙在渊")
        GameEvent.push(EventCfg.onAddAchievementTitle, actor, "潜龙在渊")
    end
end
GameEvent.add(EventCfg.onXiuXianUP, _onXiuXianUP, AchievementTitle)

--杀戮刻印达到满级
local function _onShaLuKeYinMax(actor)
    if not checktitle(actor, "杀戮之巅") then
        confertitle(actor,"杀戮之巅")
        GameEvent.push(EventCfg.onAddAchievementTitle, actor, "杀戮之巅")
    end
end
GameEvent.add(EventCfg.onShaLuKeYinMax, _onShaLuKeYinMax, AchievementTitle)

--开括者
local function _onTeQuankaiTong(actor)
    if not checktitle(actor, "开括者") then
        confertitle(actor,"开括者")
        GameEvent.push(EventCfg.onAddAchievementTitle, actor, "开括者")
    end
end
GameEvent.add(EventCfg.onTeQuankaiTong, _onTeQuankaiTong, AchievementTitle)

--杀戮刻印达到满级
local function _onJiFengKeYinMax(actor)
    if not checktitle(actor, "疾风之极") then
        confertitle(actor,"疾风之极")
        Player.setAttList(actor, "攻速附加")
        GameEvent.push(EventCfg.onAddAchievementTitle, actor, "疾风之极")
    end
end
GameEvent.add(EventCfg.onJiFengKeYinMax, _onJiFengKeYinMax, AchievementTitle)

-- 充值完成触发
local ChongZhiTitle = {{var = 2000, title = "小怪爆终极"},{var = 5000, title = "超神器探秘者"}}
local function _onRechargeEnd(actor, gold, productid, moneyid)
    if not checktitle(actor, "超神器探秘者") then
        local LeiJiChongZhi = getplaydef(actor, VarCfg["U_真实充值"])
        -- release_print("充值：",LeiJiChongZhi)
        local NewTitle,OldTitle = Player.getNewandOldTitle(actor,LeiJiChongZhi, ChongZhiTitle)
        if NewTitle == "" then return end
        if not checktitle(actor, NewTitle) then
            if checktitle(actor, OldTitle) then
                deprivetitle(actor,OldTitle)
            end
            confertitle(actor,NewTitle) --添加新的称号
            GameEvent.push(EventCfg.onAddAchievementTitle, actor, NewTitle)
        end
    end
end
GameEvent.add(EventCfg.onRechargeEnd, _onRechargeEnd, AchievementTitle)

--疾风攻击速度
local function _onCalcAttackSpeed(actor, attackSpeeds)
    if checktitle(actor,"疾风之极") then
        attackSpeeds[1] = attackSpeeds[1] + 10
    end
end
GameEvent.add(EventCfg.onCalcAttackSpeed, _onCalcAttackSpeed, AchievementTitle)

--连续登录触发
local LogDayNumTitle = {{var = 3, title = "新晋常客"},{var = 5, title = "铁杆熟客"},{var = 10, title = "大爷您又来了"}}
function qi_yu_cheng_hao_login_delay(actor)
    -------------------------------------------窝囊废发放-------------------------------------------
    AchievementTitle.wonangfeifafang(actor)
    -------------------------------------------窝囊废发放-------------------------------------------

    local T_PlayerDayNum = (getplaydef(actor,VarCfg["T_连续登录验证"]) == "" and 0) or getplaydef(actor,VarCfg["T_连续登录验证"])
    T_PlayerDayNum = tonumber(T_PlayerDayNum)
    local U_PlayerDayNum = getplaydef(actor,VarCfg["U_连续登录天数"])
    local SystemDayNum = getsysvar(VarCfg["G_开区天数"])
    if T_PlayerDayNum == SystemDayNum then  return end
    if T_PlayerDayNum+1 == SystemDayNum then
        setplaydef(actor,VarCfg["U_连续登录天数"], U_PlayerDayNum + 1)
        setplaydef(actor,VarCfg["T_连续登录验证"],SystemDayNum)
    else
        setplaydef(actor,VarCfg["U_连续登录天数"], 1)
        setplaydef(actor,VarCfg["T_连续登录验证"],SystemDayNum)
    end

    local PlayerDayNum = getplaydef(actor,VarCfg["U_连续登录天数"])
    -- release_print("连续登录第"..PlayerDayNum.."天")

    if not checktitle(actor, "大爷您又来了") then
        local NewTitle,OldTitle = Player.getNewandOldTitle(actor,PlayerDayNum,LogDayNumTitle)
        if NewTitle == "" then return end
        if not checktitle(actor, NewTitle) then
            if checktitle(actor, OldTitle) then
                deprivetitle(actor,OldTitle)
            end
            confertitle(actor,NewTitle) --添加新的称号
            GameEvent.push(EventCfg.onAddAchievementTitle, actor, NewTitle)
        end
    end
end

local function _onLoginEnd(actor)
    delaygoto(actor,10400,"qi_yu_cheng_hao_login_delay")
end
GameEvent.add(EventCfg.onLoginEnd, _onLoginEnd, AchievementTitle)

--查看他人装备
local MyLookTitle = {{var = 10, title = "装备观察员"},{var = 50, title = "装备鉴定师"}}
local function _Myonlookhuminfo(actor, Target)
    if actor == nil or Target == nil then return end
    if not checktitle(actor, "装备鉴定师") then
        local TgtObj = getplaydef(actor, VarCfg["T_查看他人BOJ"])
        if TgtObj ~= Target then
            local PlayerNum = getplaydef(actor,VarCfg["U_查看他人次数"])
            setplaydef(actor,VarCfg["U_查看他人次数"], PlayerNum + 1)
            local NewTitle,OldTitle = Player.getNewandOldTitle(actor,PlayerNum + 1 ,MyLookTitle)
            if NewTitle == "" then return end
            if not checktitle(actor, NewTitle) then
                if checktitle(actor, OldTitle) then
                    deprivetitle(actor,OldTitle)
                end
                confertitle(actor,NewTitle) --添加新的称号
                GameEvent.push(EventCfg.onAddAchievementTitle, actor, NewTitle)
            end
        end
    end
end
GameEvent.add(EventCfg.Myonlookhuminfo, _Myonlookhuminfo, AchievementTitle)

--被他人查看装备
local TgtLookTitle = {{var = 10, title = "焦点之星"},{var = 50, title = "万众瞩目"},{var = 100, title = "大众偶像"}}
local function _Tgtonlookhuminfo(actor, Target)
    if actor == nil or Target == nil then return end
    local _TgtInfo = getplaydef(Target,VarCfg["T_查看装备的玩家"])
    --同时被多人查看装备 
    if Target ~= _TgtInfo then
        if not checktitle(actor, "被围观") then
            local buff = hasbuff(actor, 31029)
            if buff then
                setplaydef(actor,VarCfg["T_查看装备的玩家"], Target)
                local PlayerNum = getplaydef(actor,VarCfg["N$连续查看装备人数"])
                setplaydef(actor,VarCfg["N$连续查看装备人数"], PlayerNum + 1)
                if PlayerNum + 1 >= 3 then
                    confertitle(actor,"被围观")
                    GameEvent.push(EventCfg.onAddAchievementTitle, actor, "被围观")
                end
            else
                addbuff(actor,31029,10)
                setplaydef(actor,VarCfg["N$连续查看装备人数"], 1)
            end
        end
    end

    if not checktitle(actor, "大众偶像") then
        local TgtObj = getplaydef(actor, VarCfg["T_被人查看BOJ"])
        if TgtObj ~= Target then
            local PlayerNum = getplaydef(actor,VarCfg["U_被人查看次数"])
            setplaydef(actor,VarCfg["U_被人查看次数"], PlayerNum + 1)
            local NewTitle,OldTitle = Player.getNewandOldTitle(actor,PlayerNum + 1 ,TgtLookTitle)
            if NewTitle == "" then return end
            if not checktitle(actor, NewTitle) then
                if checktitle(actor, OldTitle) then
                    deprivetitle(actor,OldTitle)
                end
                confertitle(actor,NewTitle) --添加新的称号
                GameEvent.push(EventCfg.onAddAchievementTitle, actor, NewTitle)
            end
        end
    end
end
GameEvent.add(EventCfg.Tgtonlookhuminfo, _Tgtonlookhuminfo, AchievementTitle)

--使用改名卡后触发
local function _onUseGaiMingKa(actor)
    if not checktitle(actor, "隐姓埋名") then
        if randomex(1,3) then
            confertitle(actor,"隐姓埋名")
            GameEvent.push(EventCfg.onAddAchievementTitle, actor, "隐姓埋名")
        end
    end
end
GameEvent.add(EventCfg.onUseGaiMingKa, _onUseGaiMingKa, AchievementTitle)

--使用红名清洗卷概率触发
local function _onUseHongMingQingXiKa(actor)
    if not checktitle(actor, "洗心革面") then
        if randomex(1,10) then
            confertitle(actor,"洗心革面")
            GameEvent.push(EventCfg.onAddAchievementTitle, actor, "洗心革面")
        end
    end
end
GameEvent.add(EventCfg.onUseHongMingQingXiKa, _onUseHongMingQingXiKa, AchievementTitle)

--死亡掉装次数触发
local DropUseItemsTitle = {{var = 3, title = "落装常客"},{var = 10, title = "散财大王"},{var = 30, title = "败家宗师"}}
local function _onCheckDropUseItems(actor, arg1)
    if not checktitle(actor, "败家宗师") then
        local num = getplaydef(actor,VarCfg["U_死亡掉装次数"])
        setplaydef(actor,VarCfg["U_死亡掉装次数"], num + 1)
        -- release_print("死亡掉装次数"..num+1)
        local NewTitle,OldTitle = Player.getNewandOldTitle(actor,num + 1 ,DropUseItemsTitle)
        if NewTitle == "" then return end
        if not checktitle(actor, NewTitle) then
            if checktitle(actor, OldTitle) then
                deprivetitle(actor,OldTitle)
            end
            confertitle(actor,NewTitle) --添加新的称号
            GameEvent.push(EventCfg.onAddAchievementTitle, actor, NewTitle)
        end
    end
end
GameEvent.add(EventCfg.onCheckDropUseItems, _onCheckDropUseItems, AchievementTitle)


--添加奇遇称号触发
local JiHuoTitleNum = {{var = 10, title = "合格牛马"},{var = 30, title = "勤劳牛马"},{var = 80, title = "逆袭牛马"},{var = 120, title = "牛马之王"}}
local Title_Data = include("QuestDiary/cfgcsv/cfg_TitleNumData.lua") --成就名单
local function _onAddAchievementTitle(actor, TitleName)
    ------------------------------------------------------添加新的称号------------------------------------------------------
    local PlayerName = getbaseinfo(actor, ConstCfg.gbase.name)
    sendmsgnew(actor,250,0,"{奇遇成就:/FCOLOR=251}恭喜玩家{".. PlayerName .."/FCOLOR=254}触发特殊奇遇,获得{".. TitleName .."/FCOLOR=254}称号...",0,1)
    sendmsgnew(actor,250,0,"{奇遇成就:/FCOLOR=251}恭喜玩家{".. PlayerName .."/FCOLOR=254}触发特殊奇遇,获得{".. TitleName .."/FCOLOR=254}称号...",0,1)
    scenevibration(actor,0,2,2)
    messagebox(actor,"奇遇成就\\恭喜你获得[".. TitleName .."]称号..")
    ------------------------------------------------------添加新的称号------------------------------------------------------
    local TitleNum = 0
    for k, v in pairs(Title_Data) do
        if checktitle(actor, k) then
            TitleNum = TitleNum + v.Num
        end
    end
    local NewTitle,OldTitle = Player.getNewandOldTitle(actor,TitleNum,JiHuoTitleNum)
    if NewTitle == "" then return end
    if not checktitle(actor, NewTitle) then
        if checktitle(actor, OldTitle) then
            deprivetitle(actor,OldTitle)
        end
        confertitle(actor,NewTitle) --添加新的称号
        Player.setAttList(actor, "爆率附加")
        -------------------------------------------窝囊废发放-------------------------------------------
        if NewTitle == "合格牛马" then AchievementTitle.wonangfeifafang(actor) end
        -------------------------------------------窝囊废发放-------------------------------------------
        GameEvent.push(EventCfg.onAddAchievementTitle, actor, NewTitle)
    end
end
GameEvent.add(EventCfg.onAddAchievementTitle, _onAddAchievementTitle, AchievementTitle)

--新的一天  牛马称号发放窝囊废
local function _onNewDay(actor)
    AchievementTitle.wonangfeifafang(actor)
end
GameEvent.add(EventCfg.onNewDay, _onNewDay, AchievementTitle)

return AchievementTitle

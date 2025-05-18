--剑刃风暴
function buff_lirenfengbao(actor, buffId, buffGroup)
    local x = getbaseinfo(actor, ConstCfg.gbase.x)
    local y = getbaseinfo(actor, ConstCfg.gbase.y)
    local myMaxAttackNum = getbaseinfo(actor, ConstCfg.gbase.dc2)
    rangeharm(actor, x, y, 3, myMaxAttackNum, 0, 0, 0, 2)
end

--翡翠梦境
function buff_mengjingfeicui(actor, buffId, buffGroup)
    local x = getbaseinfo(actor, ConstCfg.gbase.x)
    local y = getbaseinfo(actor, ConstCfg.gbase.y)
    local mapId = getbaseinfo(actor, ConstCfg.gbase.mapid)
    local obj = getobjectinmap(mapId, x, y, 3, 1)
    for _, value in ipairs(obj) do
        local isGuild = getIsGuildMember(actor, value)
        local isGroup = getIsGroupMember(actor, value)
        if isGroup or isGuild then
            humanhp(value, "+", Player.getHpValue(value, 3), 4)
            -- Player.buffTipsMsg(value, "[梦境翡翠]:行会成员或组队成员触发了梦境翡翠,恢复3%的生命值!")
        end
    end
end

function buff_yongshenglingti(actor, buffId, buffGroup)
    local hpPer = Player.getHpPercentage(actor)
    if hpPer > 30 then
        FkfDelBuff(actor, 30079)
    end
end

--雷电八连击
function buff_leidianbalianji(actor, buffId, buffGroup)
    local num = getplaydef(actor, VarCfg["N$雷电八连击"])
    local dcmax = getbaseinfo(actor, ConstCfg.gbase.dc2)
    local Damage = dcmax * (0.2 + 0.1 * num)
    humanhp(actor, "-", Damage, 4)
    playeffect(actor, 56, 0, 0, 1, 0, 0)
    setplaydef(actor, VarCfg["N$雷电八连击"], num + 1)
end
--炁体源流
--进入元婴状态
function buff_qitiliuyuan(actor, buffId, buffGroup)
    if getflagstatus(actor, VarCfg["F_天命_炁体源流标识"]) == 1 then
        -- Player.buffTipsMsg(actor, "你进入元婴状态!!!!!")
        if checkkuafu(actor) then
            FAddBuffBF(actor, 30099, 5)
        else
            addbuff(actor, 30099)
        end
    else
        FkfDelBuff(actor, 30098)
    end
end

--死神降临  每隔(60S)增加[10%]的最大攻击力(效果持续20秒)
function buff_sishenjianglin(actor, buffId, buffGroup)
    changehumnewvalue(actor, 210, 10, 20)
end

--天界的降罚  每3秒受到1次雷击\每次雷击扣除20%生命\雷罚效果持续9秒
function buff_tianjiedejiangfa(actor, buffId, buffGroup)
    humanhp(actor, "-", Player.getHpValue(actor, 20), 1) --刀刀斩血20%
    playeffect(actor, 56, 0, 0, 1, 0, 0)
end

--极限潜能 1s消耗 100 元宝
function buff_julongjuexing1(actor, buffId, buffGroup)
    local falg = getflagstatus(actor,VarCfg["F_终极时装标识"])
    local falg2 = getflagstatus(actor,VarCfg["F_终极时装标识1"])
    local falg3 = getflagstatus(actor,VarCfg["F_终极时装标识2"])
    local money = 100
    if falg == 1 or falg2 == 1 or falg3 == 1 then
        money = 50
    else
        money = 100
    end
    if querymoney(actor, 2) >= money then
        changemoney(actor, 2, "-", money, "扣除元宝", true)
    else
        FkfDelBuff(actor, 31023)
        delattlist(actor, "极限潜能") --属性组
        setplaydef(actor, VarCfg["N$极限潜能开关"], 0)
        local data = { getplaydef(actor, VarCfg["N$极限潜能开关"]) }
        Message.sendmsg(actor, ssrNetMsgCfg.TopIcon_UpdateIcon, 0, 0, 0, data)
    end
end

--极限潜能 1s消耗 300 元宝
function buff_julongjuexing2(actor, buffId, buffGroup)
    local falg = getflagstatus(actor,VarCfg["F_终极时装标识"])
    local falg2 = getflagstatus(actor,VarCfg["F_终极时装标识1"])
    local falg3 = getflagstatus(actor,VarCfg["F_终极时装标识2"])
    local money = 300
    if falg == 1 or falg2 == 1 or falg3 == 1 then
        money = 150
    else
        money = 300
    end
    if querymoney(actor, 2) >= money then
        changemoney(actor, 2, "-", money, "扣除元宝", true)
    else
        FkfDelBuff(actor, 31024)
        delattlist(actor, "极限潜能") --属性组
        setplaydef(actor, VarCfg["N$极限潜能开关"], 0)
        local data = { getplaydef(actor, VarCfg["N$极限潜能开关"]) }
        Message.sendmsg(actor, ssrNetMsgCfg.TopIcon_UpdateIcon, 0, 0, 0, data)
    end
end

--极限潜能 1s消耗 600 元宝
function buff_julongjuexing3(actor, buffId, buffGroup)
    local falg = getflagstatus(actor,VarCfg["F_终极时装标识"])
    local falg2 = getflagstatus(actor,VarCfg["F_终极时装标识1"])
    local falg3 = getflagstatus(actor,VarCfg["F_终极时装标识2"])
    local money = 600
    if falg == 1 or falg2 == 1 or falg3 == 1 then
        money = 300
    else
        money = 600
    end
    if querymoney(actor, 2) >= money then
        changemoney(actor, 2, "-", money, "扣除元宝", true)
    else
        FkfDelBuff(actor, 31025)
        delattlist(actor, "极限潜能") --属性组
        setplaydef(actor, VarCfg["N$极限潜能开关"], 0)
        local data = { getplaydef(actor, VarCfg["N$极限潜能开关"]) }
        Message.sendmsg(actor, ssrNetMsgCfg.TopIcon_UpdateIcon, 0, 0, 0, data)
    end
end

--极限潜能 1s消耗 900 元宝
function buff_julongjuexing4(actor, buffId, buffGroup)
    local falg = getflagstatus(actor,VarCfg["F_终极时装标识"])
    local falg2 = getflagstatus(actor,VarCfg["F_终极时装标识1"])
    local falg3 = getflagstatus(actor,VarCfg["F_终极时装标识2"])
    local money = 900
    if falg == 1 or falg2 == 1 or falg3 == 1 then
        money = 450
    else
        money = 900
    end
    if querymoney(actor, 2) >= money then
        changemoney(actor, 2, "-", money, "扣除元宝", true)
    else
        FkfDelBuff(actor, 31026)
        delattlist(actor, "极限潜能") --属性组
        setplaydef(actor, VarCfg["N$极限潜能开关"], 0)
        local data = { getplaydef(actor, VarCfg["N$极限潜能开关"]) }
        Message.sendmsg(actor, ssrNetMsgCfg.TopIcon_UpdateIcon, 0, 0, 0, data)
    end
end

--极限潜能 1s消耗 1200 元宝
function buff_julongjuexing5(actor, buffId, buffGroup)
    local falg = getflagstatus(actor,VarCfg["F_终极时装标识"])
    local falg2 = getflagstatus(actor,VarCfg["F_终极时装标识1"])
    local falg3 = getflagstatus(actor,VarCfg["F_终极时装标识2"])
    local money = 1200
    if falg == 1 or falg2 == 1 or falg3 == 1 then
        money = 600
    else
        money = 1200
    end
    if querymoney(actor, 2) >= money then
        changemoney(actor, 2, "-", money, "扣除元宝", true)
    else
        FkfDelBuff(actor, 31027)
        delattlist(actor, "极限潜能") --属性组
        setplaydef(actor, VarCfg["N$极限潜能开关"], 0)
        local data = { getplaydef(actor, VarCfg["N$极限潜能开关"]) }
        Message.sendmsg(actor, ssrNetMsgCfg.TopIcon_UpdateIcon, 0, 0, 0, data)
    end
end

--风行者
function buff_fengxingzhe(actor, buffId, buffGroup)
    throughhum(actor, 3, 5, 0) --穿人穿怪
    changespeedex(actor,1,5,5) --移动速度
end

-- 万象雷霆劫
local itemdata = include("QuestDiary/cfgcsv/cfg_XiuXianFaBaoData.lua") --法宝名单
function buff_wan_xiang_lei_ting_jie(actor, buffId, buffGroup)
    local level = getplaydef(actor, VarCfg["U_修仙等级"])
    local cfg = itemdata[level]
    local qieGe = getbaseinfo(actor, ConstCfg.gbase.custom_attr, 200)
    local damage = math.floor(qieGe * (cfg.effect2 / 100))
    local x = getbaseinfo(actor, ConstCfg.gbase.x)
    local y = getbaseinfo(actor, ConstCfg.gbase.y)
    playeffect(actor, 55022, 0, 0, 1, 0, 0)
    playeffect(actor, 55024, 0, 0, 1, 0, 0)
    rangeharm(actor, x, y, 3, damage, 0, 0, 0, 2)
end

--召唤树妖仆从
function buff_shu_chong_pu_cong_zhao_huan(actor, buffId, buffGroup)
    local MapID = getbaseinfo(actor, ConstCfg.gbase.mapid)
    local CheckMap = MapID ~= "n3" and  MapID ~= "new0150"
    if CheckMap then
        local ncount  =getbaseinfo(actor,38)
        if ncount < 5 then
            recallmob(actor,"树妖仆从",7,30,0,0,0)
        end
    end
end

--终结者 每9秒设置一次重击状态
function buff_an_hei_zhong_ji(actor, buffId, buffGroup)
    if getplaydef(actor, VarCfg["S$_终结者"]) == "" then
        setplaydef(actor, VarCfg["S$_终结者"],"可释放")
    end
end

--云游天下  每秒增加2层
function buff_yun_you_tian_xia(actor, buffId, buffGroup)
    local BuffNum = getbuffinfo(actor, 31065, 1)
    if BuffNum == 99 then
        buffstack(actor, 31065,"=", 100, false)
    elseif BuffNum < 100 then
        buffstack(actor, 31065,"+", 2, false)
    end

    -- local Num = getplaydef(actor, VarCfg["N$云游天下"])
    -- Num = Num + 2
    -- setplaydef(actor, VarCfg["N$云游天下"], Num)
end

--悟道神带 每隔30秒恢复人物自身10%的最大血量
function buff_wu_dao_shen_dai(actor, buffId, buffGroup)
    local nowHp = Player.getHpPercentage(actor)
    if nowHp < 100 then
        humanhp(actor, "+", Player.getHpValue(actor, 10), 4) --恢复10%最生命值
    end
end

--黑刀·夜 每30秒触发2秒黑刀状态 该状态下刀刀暴击　
function buff_hei_dao_de_ye(actor, buffId, buffGroup)
    addbuff(actor, 31106, 2, 1, actor, nil)
end


-- --芭蕉扇 每60秒回复自身100%蓝量
-- function buff_ba_jiao_shan_addmp(actor, buffId, buffGroup)
--     release_print(actor, "buff_ba_jiao_shan_addmp")
--     addmpper(actor, "=", 100)
-- end

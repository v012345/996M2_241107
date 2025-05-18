local NiuMaNiXi = {}
local config = include("QuestDiary/cfgcsv/cfg_NiuMaNiXi_Data.lua") --小神魔配置
local QiRiNiXiCahce = {}

function NiuMaNiXi.Request1(actor, FenLei, XiaoJie)
    local SystemDayNum = getsysvar(VarCfg["G_开区天数"])

    if SystemDayNum < FenLei then return end
    ---------------------↓↓↓↓ 验证前端数据 ↓↓↓↓---------------------
    local verify = config[FenLei].Show[XiaoJie]
    if not verify then
        Player.sendmsgEx(actor, "提示#251|:#255|非法请求#249|...")
        return
    end
    ---------------------↓↓↓↓ 验证前端数据 ↓↓↓↓---------------------
    local cfg = config[FenLei]
    local Cahce_Tbl = NiuMaNiXi.GetZhuangBanList(actor)
    local _XiaoJie = tostring(XiaoJie)

    if Cahce_Tbl[FenLei][_XiaoJie] == "可领取" then
        Cahce_Tbl[FenLei][_XiaoJie] = "已领取"
        local UserId = getconst(actor, "<$USERID>")
        sendmail(UserId, 5002, "牛马逆袭","恭喜你,完成第".. FenLei .."日["..verify.."]任务","".. cfg.AwardMoney[1] .."#".. cfg.AwardMoney[2] .."")
        Player.setJsonVarByTable(actor, VarCfg["T_牛马逆袭".. FenLei .."天"], Cahce_Tbl[FenLei])
        NiuMaNiXi.SyncResponse(actor)
    elseif Cahce_Tbl[FenLei][_XiaoJie] == "已领取" then
        Player.sendmsgEx(actor, "提示#251|:#255|对不起,你已经|领取#249|,该任务奖励了...")
        return
    else
        Player.sendmsgEx(actor, "提示#251|:#255|对不起,你还未|达成条件#249|,无法领取...")
        return
    end
end

function NiuMaNiXi.Request2(actor, FenLei)
    local title = { "牛马实习生","牛马老员工","牛马小组长","牛马总经理","牛马股东","牛马董事长"}
    ---------------------↓↓↓↓ 验证天数 ↓↓↓↓---------------------
    local SystemDayNum = getsysvar(VarCfg["G_开区天数"])
    local _Cahce_Tbl = NiuMaNiXi.GetZhuangBanList(actor)
    local Cahce_Tbl = _Cahce_Tbl[FenLei]
    local cfg = config[FenLei]
    local AwardNum = 0
    
    if SystemDayNum < FenLei then return end
    if not cfg then return end
    ---------------------↓↓↓↓ 验证是否可领取 ↓↓↓↓---------------------
    for i = 1, #cfg.Show do
        if Cahce_Tbl[tostring(i)] == "已领取" then
            AwardNum  = AwardNum + 1
        end
    end

    if Cahce_Tbl["总奖励"] == "已领取" then
        Player.sendmsgEx(actor, "提示#251|:#255|对不起,你已经|领取#249|,该奖励了...")
        -- Cahce_Tbl["总奖励"] = nil
        -- Player.setJsonVarByTable(actor, VarCfg["T_牛马逆袭".. FenLei .."天"], Cahce_Tbl)
        -- NiuMaNiXi.SyncResponse(actor)
        return
    end

    if FenLei >= 2 then
        if _Cahce_Tbl[FenLei-1]["总奖励"] ~= "已领取" then
            Player.sendmsgEx(actor, "提示#251|:#255|对不起,请先领取|第".. FenLei-1 .."日#249|奖励...")
            return
        end
    end

    if AwardNum == #cfg.Show then
        if FenLei == 1 then
            local UserId = getconst(actor, "<$USERID>")
            sendmail(UserId, 5002, "牛马逆袭","恭喜你,完成第".. FenLei .."日的全部任务","".. cfg.AwardItem[1] .."#".. cfg.AwardItem[2] .."")
            Cahce_Tbl["总奖励"] = "已领取"
            Player.setJsonVarByTable(actor, VarCfg["T_牛马逆袭".. FenLei .."天"], Cahce_Tbl)
            NiuMaNiXi.SyncResponse(actor)
            return
        elseif FenLei == 2 then
            local UserId = getconst(actor, "<$USERID>")
            sendmail(UserId, 5002, "牛马逆袭","恭喜你,完成第".. FenLei .."日的全部任务","".. cfg.AwardItem[1] .."#".. cfg.AwardItem[2] .."")
            Cahce_Tbl["总奖励"] = "已领取"
            Player.setJsonVarByTable(actor, VarCfg["T_牛马逆袭".. FenLei .."天"], Cahce_Tbl)
            NiuMaNiXi.SyncResponse(actor)
            return
        elseif FenLei >= 3 and FenLei <= 7 then
            for _, v in ipairs(title) do
                deprivetitle(actor, v)
            end
            local TitleName = cfg.AwardItem[1]:gsub("%[称号%]", "")
            confertitle(actor,TitleName)
            Player.setAttList(actor, "属性附加")



            Cahce_Tbl["总奖励"] = "已领取"
            Player.setJsonVarByTable(actor, VarCfg["T_牛马逆袭".. FenLei .."天"], Cahce_Tbl)
            NiuMaNiXi.SyncResponse(actor)
            return
        end
    else
        Player.sendmsgEx(actor, "提示#251|:#255|第".. FenLei .."日,进度|".. AwardNum .."/"..#cfg.Show .."#249|再接再厉...")
        return
    end
end

--获取牛马逆袭领取状态，缓存方式
function NiuMaNiXi.GetZhuangBanList(actor)
    if QiRiNiXiCahce[actor] then
        return QiRiNiXiCahce[actor]
    end
    local result = {}
    result[1] = Player.getJsonTableByVar(actor, VarCfg["T_牛马逆袭1天"])
    result[2] = Player.getJsonTableByVar(actor, VarCfg["T_牛马逆袭2天"])
    result[3] = Player.getJsonTableByVar(actor, VarCfg["T_牛马逆袭3天"])
    result[4] = Player.getJsonTableByVar(actor, VarCfg["T_牛马逆袭4天"])
    result[5] = Player.getJsonTableByVar(actor, VarCfg["T_牛马逆袭5天"])
    result[6] = Player.getJsonTableByVar(actor, VarCfg["T_牛马逆袭6天"])
    result[7] = Player.getJsonTableByVar(actor, VarCfg["T_牛马逆袭7天"])
    QiRiNiXiCahce[actor] = result
    -- dump(result)
    return result
end

--升级触发
local Level_Tbl = {[100]={Day=1,Num="1"},[120]={Day=2,Num="1"},[160]={Day=3,Num="1"},[180]={Day=4,Num="1"},[200]={Day=5,Num="1"},[220]={Day=6,Num="1"},[240]={Day=7,Num="1"}}
local function _onPlayLevelUp(actor, cur_level)
    --release_print("sssssss ")
    local Cahce_Tbl = NiuMaNiXi.GetZhuangBanList(actor)
    if Level_Tbl[cur_level] then
        local Day, Num = Level_Tbl[cur_level].Day, Level_Tbl[cur_level].Num
        if not Cahce_Tbl[Day][Num] then
            Cahce_Tbl[Day][Num] = "可领取"
        end
        Player.setJsonVarByTable(actor, VarCfg["T_牛马逆袭".. Day .."天"], Cahce_Tbl[Day])
        NiuMaNiXi.SyncResponse(actor)
    end
    --release_print("sssssss ")
end
GameEvent.add(EventCfg.onPlayLevelUp, _onPlayLevelUp, NiuMaNiXi)

--穿戴任意装备触发
local item_Tbl = {["破魔斗笠+5"]={Day=1,Num="2"},["恢复光环+5"]={Day=1,Num="3"},["龙·之心+5"]={Day=1,Num="4"},["神·守护+5"]={Day=1,Num="5"},["疾风刻印Lv.7"]={Day=2,Num="2"},["杀戮刻印Lv.7"]={Day=2,Num="3"}}
local function _onTakeOnEx(actor, itemobj, where, itemname, makeid)
    local Cahce_Tbl = NiuMaNiXi.GetZhuangBanList(actor)
    if item_Tbl[itemname] then
        local Day, Num = item_Tbl[itemname].Day, item_Tbl[itemname].Num
        if not Cahce_Tbl[Day][Num] then
            Cahce_Tbl[Day][Num] = "可领取"
        end
        Player.setJsonVarByTable(actor, VarCfg["T_牛马逆袭".. Day .."天"], Cahce_Tbl[Day])
        NiuMaNiXi.SyncResponse(actor)
    end
end
GameEvent.add(EventCfg.onTakeOnEx, _onTakeOnEx, NiuMaNiXi)

--收集装扮
local Skin_Tbl = {{Skin=4, Day=1,Num="6"}, {Skin=8, Day=3,Num="3"}}
local function _onUPSkin(actor,var)
    local Cahce_Tbl = NiuMaNiXi.GetZhuangBanList(actor)
    if var >= Skin_Tbl[1].Skin then
        local Day, Num = Skin_Tbl[1].Day, Skin_Tbl[1].Num
        if not Cahce_Tbl[Day][Num] then
            Cahce_Tbl[Day][Num] = "可领取"
        end
        Player.setJsonVarByTable(actor, VarCfg["T_牛马逆袭".. Day .."天"], Cahce_Tbl[Day])
        NiuMaNiXi.SyncResponse(actor)
    end

    if var >= Skin_Tbl[2].Skin then
        local Day, Num = Skin_Tbl[2].Day, Skin_Tbl[2].Num
        if not Cahce_Tbl[Day][Num] then
            Cahce_Tbl[Day][Num] = "可领取"
        end
        Player.setJsonVarByTable(actor, VarCfg["T_牛马逆袭".. Day .."天"], Cahce_Tbl[Day])
        NiuMaNiXi.SyncResponse(actor)
    end
end
GameEvent.add(EventCfg.onUPSkin, _onUPSkin, NiuMaNiXi)

--加入行会后触发
local function _onGuildAddMemberAfter(actor, guild, name)
    local Day, Num = 2, "4"
    local Cahce_Tbl = NiuMaNiXi.GetZhuangBanList(actor)
    if not Cahce_Tbl[Day][Num] then
        Cahce_Tbl[Day][Num] = "可领取"
        Player.setJsonVarByTable(actor, VarCfg["T_牛马逆袭".. Day .."天"], Cahce_Tbl[Day])
        NiuMaNiXi.SyncResponse(actor)
    end
end
GameEvent.add(EventCfg.onGuildAddMemberAfter, _onGuildAddMemberAfter, NiuMaNiXi)

--开启狂暴触发
local function _OpenKuangBao(actor)
    local Day, Num = 2, "5"
    local Cahce_Tbl = NiuMaNiXi.GetZhuangBanList(actor)
    if not Cahce_Tbl[Day][Num] then
        Cahce_Tbl[Day][Num] = "可领取"
        Player.setJsonVarByTable(actor, VarCfg["T_牛马逆袭".. Day .."天"], Cahce_Tbl[Day])
        NiuMaNiXi.SyncResponse(actor)
    end
end
GameEvent.add(EventCfg.OpenKuangBao,_OpenKuangBao, NiuMaNiXi)

--神魔大成触发
local function _onTiZhiXiuLianUP(actor)
    local Day, Num = 3, "2"
    local Cahce_Tbl = NiuMaNiXi.GetZhuangBanList(actor)
    if not Cahce_Tbl[Day][Num] then
        Cahce_Tbl[Day][Num] = "可领取"
        Player.setJsonVarByTable(actor, VarCfg["T_牛马逆袭".. Day .."天"], Cahce_Tbl[Day])
        NiuMaNiXi.SyncResponse(actor)
    end
end
GameEvent.add(EventCfg.onTiZhiXiuLianUP, _onTiZhiXiuLianUP, NiuMaNiXi)

--修仙境界达到六合天罡珠
local XiuXianTbl = {["六合天罡珠"]={Day=3,Num="4"},["七宝玲珑塔"]={Day=4,Num="4"},["乾坤八卦盘"]={Day=5,Num="4"},["九宫龙皇钟"]={Day=6,Num="4"},["十方天帝印"]={Day=7,Num="4"}}
local function _onXiuXianUP(actor,itemname)
    local Cahce_Tbl = NiuMaNiXi.GetZhuangBanList(actor)
    if XiuXianTbl[itemname] then
        local Day, Num = XiuXianTbl[itemname].Day, XiuXianTbl[itemname].Num
        if not Cahce_Tbl[Day][Num] then
            Cahce_Tbl[Day][Num] = "可领取"
        end
        Player.setJsonVarByTable(actor, VarCfg["T_牛马逆袭".. Day .."天"], Cahce_Tbl[Day])
        NiuMaNiXi.SyncResponse(actor)
    end
end
GameEvent.add(EventCfg.onXiuXianUP, _onXiuXianUP, NiuMaNiXi)

--洗练触发
local XiLianTbl = {[2]={Day=3,Num="5"},[3]={Day=5,Num="5"}}
local function _onZhuangBeiXiLian(actor,setLevel)
    local Cahce_Tbl = NiuMaNiXi.GetZhuangBanList(actor)
    if XiLianTbl[setLevel] then
        local Day, Num = XiLianTbl[setLevel].Day, XiLianTbl[setLevel].Num
        if not Cahce_Tbl[Day][Num] then
            Cahce_Tbl[Day][Num] = "可领取"
        end
        Player.setJsonVarByTable(actor, VarCfg["T_牛马逆袭".. Day .."天"], Cahce_Tbl[Day])
        NiuMaNiXi.SyncResponse(actor)
    end
end
GameEvent.add(EventCfg.onZhuangBeiXiLian, _onZhuangBeiXiLian, NiuMaNiXi)

--技能强化触发
local function _onIntensifySkill(actor, skillname, skillleve)
    if skillname ~= "刺杀剑术" then  return end
    if skillleve ~= 5 then  return end
    local Day, Num = 4, "3"
    local Cahce_Tbl = NiuMaNiXi.GetZhuangBanList(actor)
    if not Cahce_Tbl[Day][Num] then
        Cahce_Tbl[Day][Num] = "可领取"
        Player.setJsonVarByTable(actor, VarCfg["T_牛马逆袭".. Day .."天"], Cahce_Tbl[Day])
        NiuMaNiXi.SyncResponse(actor)
    end
end
GameEvent.add(EventCfg.onIntensifySkill,_onIntensifySkill, NiuMaNiXi)

--狂风洗练触发
local function _onKuangFengXiLian(actor,count)
    if count < 300000 then  return end
    local Day, Num = 4, "2"
    local Cahce_Tbl = NiuMaNiXi.GetZhuangBanList(actor)
    if not Cahce_Tbl[Day][Num] then
        Cahce_Tbl[Day][Num] = "可领取"
        Player.setJsonVarByTable(actor, VarCfg["T_牛马逆袭".. Day .."天"], Cahce_Tbl[Day])
        NiuMaNiXi.SyncResponse(actor)
    end
end
GameEvent.add(EventCfg.onKuangFengXiLian,_onKuangFengXiLian, NiuMaNiXi)

--升级江湖称号触发
local function _onJiangHuTitleUP(actor,title)

    if title ~= "风尘奇侠" then  return end
    local Day, Num = 4, "5"
    local Cahce_Tbl = NiuMaNiXi.GetZhuangBanList(actor)
    if not Cahce_Tbl[Day][Num] then
        Cahce_Tbl[Day][Num] = "可领取"
        Player.setJsonVarByTable(actor, VarCfg["T_牛马逆袭".. Day .."天"], Cahce_Tbl[Day])
        NiuMaNiXi.SyncResponse(actor)
    end
end
GameEvent.add(EventCfg.onJiangHuTitleUP, _onJiangHuTitleUP, NiuMaNiXi)

--转生触发
local function _onRenewlevelUP(actor, renewlevel)
    if renewlevel ~= 1 then return end
    local Day, Num = 5, "2"
    local Cahce_Tbl = NiuMaNiXi.GetZhuangBanList(actor)
    if not Cahce_Tbl[Day][Num] then
        Cahce_Tbl[Day][Num] = "可领取"
        Player.setJsonVarByTable(actor, VarCfg["T_牛马逆袭".. Day .."天"], Cahce_Tbl[Day])
        NiuMaNiXi.SyncResponse(actor)
    end
end
GameEvent.add(EventCfg.onRenewlevelUP, _onRenewlevelUP, NiuMaNiXi)

--剑甲淬炼触发
local function _onJianJiaCuLian(actor, Num)
    if Num ~= 5 then return end
    local Day, Num = 5, "3"
    local Cahce_Tbl = NiuMaNiXi.GetZhuangBanList(actor)
    if not Cahce_Tbl[Day][Num] then
        Cahce_Tbl[Day][Num] = "可领取"
        Player.setJsonVarByTable(actor, VarCfg["T_牛马逆袭".. Day .."天"], Cahce_Tbl[Day])
        NiuMaNiXi.SyncResponse(actor)
    end
end
GameEvent.add(EventCfg.onJianJiaCuLian, _onJianJiaCuLian, NiuMaNiXi)

--强化装备触发
local function _onZhuangBeiQiangHua(actor, level)
    if level ~= 4 then return end
    local Day, Num = 6, "2"
    local Cahce_Tbl = NiuMaNiXi.GetZhuangBanList(actor)
    if not Cahce_Tbl[Day][Num] then
        Cahce_Tbl[Day][Num] = "可领取"
        Player.setJsonVarByTable(actor, VarCfg["T_牛马逆袭".. Day .."天"], Cahce_Tbl[Day])
        NiuMaNiXi.SyncResponse(actor)
    end
end
GameEvent.add(EventCfg.onZhuangBeiQiangHua, _onZhuangBeiQiangHua, NiuMaNiXi)

--剑甲开光触发
local function _onJianJiaKaiGuan(actor, U_Num)
    if U_Num ~= 5 then return end
    local Day, Num = 6, "3"
    local Cahce_Tbl = NiuMaNiXi.GetZhuangBanList(actor)
    if not Cahce_Tbl[Day][Num] then
        Cahce_Tbl[Day][Num] = "可领取"
        Player.setJsonVarByTable(actor, VarCfg["T_牛马逆袭".. Day .."天"], Cahce_Tbl[Day])
        NiuMaNiXi.SyncResponse(actor)
    end
end
GameEvent.add(EventCfg.onJianJiaKaiGuan, _onJianJiaKaiGuan, NiuMaNiXi)

--幸运项链触发
local function _onXingYunXiangLian(actor, xingYunCount)
    -- release_print("幸运项链触发",xingYunCount)
    if xingYunCount < 4 then return end
    local Day, Num = 6, "5"
    local Cahce_Tbl = NiuMaNiXi.GetZhuangBanList(actor)
    if not Cahce_Tbl[Day][Num] then
        Cahce_Tbl[Day][Num] = "可领取"
        Player.setJsonVarByTable(actor, VarCfg["T_牛马逆袭".. Day .."天"], Cahce_Tbl[Day])
        NiuMaNiXi.SyncResponse(actor)
    end
end
GameEvent.add(EventCfg.onXingYunXiangLian, _onXingYunXiangLian, NiuMaNiXi)

--进入晋级之门副本
local function _onJinRuJiJiZhiMen(actor)
    local Day, Num = 7, "2"
    local Cahce_Tbl = NiuMaNiXi.GetZhuangBanList(actor)
    if not Cahce_Tbl[Day][Num] then
        Cahce_Tbl[Day][Num] = "可领取"
        Player.setJsonVarByTable(actor, VarCfg["T_牛马逆袭".. Day .."天"], Cahce_Tbl[Day])
        NiuMaNiXi.SyncResponse(actor)
    end
end
GameEvent.add(EventCfg.onJinRuJiJiZhiMen, _onJinRuJiJiZhiMen, NiuMaNiXi)

--开启极限潜能触发
local function _onOpenJiXianQianNeng(actor, qnnum)
    if qnnum ~= 3 then return end
    local Day, Num = 7, "3"
    local Cahce_Tbl = NiuMaNiXi.GetZhuangBanList(actor)
    if not Cahce_Tbl[Day][Num] then
        Cahce_Tbl[Day][Num] = "可领取"
        Player.setJsonVarByTable(actor, VarCfg["T_牛马逆袭".. Day .."天"], Cahce_Tbl[Day])
        NiuMaNiXi.SyncResponse(actor)
    end
end
GameEvent.add(EventCfg.onOpenJiXianQianNeng, _onOpenJiXianQianNeng, NiuMaNiXi)

--开启极限潜能触发
local function _onLongShenZhiLiUP(actor,currLevel)
    if currLevel ~= 3 then return end
    local Day, Num = 7, "5"
    local Cahce_Tbl = NiuMaNiXi.GetZhuangBanList(actor)
    if not Cahce_Tbl[Day][Num] then
        Cahce_Tbl[Day][Num] = "可领取"
        Player.setJsonVarByTable(actor, VarCfg["T_牛马逆袭".. Day .."天"], Cahce_Tbl[Day])
        NiuMaNiXi.SyncResponse(actor)
    end
end
GameEvent.add(EventCfg.onLongShenZhiLiUP, _onLongShenZhiLiUP, NiuMaNiXi)


--登录触发 发放牛马窝囊废
local DingDing_Title =  {
    {title="牛马实习生",LL=10000,UL=50000},
    {title="牛马老员工",LL=50000,UL=100000},
    {title="牛马小组长",LL=100000,UL=200000},
    {title="牛马总经理",LL=200000,UL=500000},
    {title="牛马股东",LL=500000,UL=1000000},
    {title="牛马董事长",LL=1000000,UL=2000000}  }

local function _onLogin(actor)
    local state = getplaydef (actor,VarCfg["Z_钉钉打卡状态"])
    if state == "已领取" then return end
    if state == "" then
        for _, v in ipairs(DingDing_Title) do
            if checktitle(actor, v.title) then
                local Num = math.random(v.LL, v.UL)
                setplaydef (actor,VarCfg["Z_钉钉打卡状态"], Num)
                break
            end
        end
        addbuff(actor, 31050, 30)
        return
    end

    if tonumber(state) > 10000 then
        addbuff(actor, 31050, 30)
        return
    end
end
GameEvent.add(EventCfg.onLogin, _onLogin, NiuMaNiXi)
--钉钉 buff 变化
local function _onBuffChange(actor, buffid, groupid, model)
    if checkkuafu(actor) then return end
    if model ~= 4 then return end
    if buffid == 31050 then
        local DingDing_Title =  {"牛马实习生","牛马老员工","牛马小组长","牛马总经理","牛马股东","牛马董事长"}
        local Name = getbaseinfo(actor, ConstCfg.gbase.name)
        local Number = getplaydef (actor,VarCfg["Z_钉钉打卡状态"])
        local TitleName = 0
        for k, v in ipairs(DingDing_Title) do
            if checktitle(actor, v) then
                TitleName = k
                break
            end
        end
    if TitleName == 0 then return end
    local ImageNum = math.random(1, 2)
    say(actor,
          [[<Img|x=0.0|y=-1.0|reset=1|esc=1|img=custom/DingDingDaKa/bg.png|show=4|loadDelay=1|move=0|bg=1>
            <Layout|x=648.0|y=22.0|width=80|height=81|link=@exit>
            <Button|x=662.0|y=41.0|nimg=custom/DingDingDaKa/close.png|link=@exit>
            <Img|x=122.0|y=9.0|img=custom/DingDingDaKa/nm]].. ImageNum ..[[.png>
            <Text|x=175.0|y=263.0|width=150|height=40|size=16|color=0|text=]].. Name ..[[>
            <Text|x=173.0|y=302.0|size=16|color=0|text=牛马集团亚太区>
            <Text|ax=0|ay=0.5|x=513.0|y=258.0|width=200|height=21|size=18|color=0|text=]].. Number ..[[金币>
            <Img|x=142.0|y=162.0|width=128|height=85|img=custom/DingDingDaKa/title_]].. TitleName ..[[.png|esc=0>
            <Button|x=411.0|y=286.0|width=192|height=70|nimg=custom/DingDingDaKa/lq.png|link=@lingqudingdingdakajiangli>]])
    end
end
GameEvent.add(EventCfg.onBuffChange, _onBuffChange, NiuMaNiXi)

function lingqudingdingdakajiangli(actor)
    local state = getplaydef (actor,VarCfg["Z_钉钉打卡状态"])
    if state == "已领取" then
        Player.sendmsgEx(actor, "提示#251|:#255|今日的窝囊废已经领取,请查看邮件...")
        return
    end
    if state == "" then return end
    if tonumber(state) > 10000 then
        local UserId = getconst(actor, "<$USERID>")
        sendmail(UserId, 20000, "叮叮打卡", "恭喜你,领今日【牛马集团】发放的窝囊费[金币]x".. state .."枚","绑定金币#".. state .."")
        setplaydef(actor, VarCfg["Z_钉钉打卡状态"], "已领取")
        Player.sendmsgEx(actor, "提示#251|:#255|恭喜你,领取今日窝囊废|金币x".. state .."#249|,祝您游戏愉快...")
    end
end

--注册网络消息
function NiuMaNiXi.SyncResponse(actor, logindatas)
    local data = NiuMaNiXi.GetZhuangBanList(actor)
    local _login_data = { ssrNetMsgCfg.NiuMaNiXi_SyncResponse, getsysvar(VarCfg["G_开区天数"]), 0, 0, data }
    if logindatas then
        table.insert(logindatas, _login_data)
    else
        Message.sendmsg(actor, ssrNetMsgCfg.NiuMaNiXi_SyncResponse, getsysvar(VarCfg["G_开区天数"]), 0, 0, data)
    end
end

Message.RegisterNetMsg(ssrNetMsgCfg.NiuMaNiXi, NiuMaNiXi)
--大退小退触发--清理缓存
local function _onExitGame(actor)
    if NiuMaNiXi[actor] then
        NiuMaNiXi[actor] = nil
    end
end
GameEvent.add(EventCfg.onExitGame, _onExitGame, NiuMaNiXi)

--登录触发
local function _onLoginEnd(actor, logindatas)
    NiuMaNiXi.SyncResponse(actor, logindatas)
end

GameEvent.add(EventCfg.onLoginEnd, _onLoginEnd, NiuMaNiXi)

return NiuMaNiXi

local FuHuaHuaPu = {}
local cost = {{"腐化之种", 1}}

-- 黑雾之源	112	104

--获取所有进度条数值
function FuHuaHuaPu.getFlagstate(actor)
    local state1 = getplaydef(actor,VarCfg["B_腐化花圃_恐惧"])
    local state2 = getplaydef(actor,VarCfg["B_腐化花圃_奸诈"])
    local state3 = getplaydef(actor,VarCfg["B_腐化花圃_残暴"])
    local state4 = getplaydef(actor,VarCfg["B_腐化花圃_虚伪"])
    local NumTbl = {state1,state2,state3,state4}
    return NumTbl
end

function FuHuaHuaPu.Request(actor,var)
    local bool = getflagstatus(actor,VarCfg["F_腐化之种开启状态"])
    --解锁花园
    if  var == 1  then 
        if bool == 1 then return end

        local name, num = Player.checkItemNumByTable(actor, cost)
        if name then
            Player.sendmsgEx(actor, string.format("提示#251|:#255|你的|%s#249|数量不足|%d#249|枚,种植失败...", name, num))
            return
        end
        Player.takeItemByTable(actor, cost, "种植收费")
        setflagstatus(actor,VarCfg["F_腐化之种开启状态"],1)
        FuHuaHuaPu.SyncResponse(actor)
    end
    --领奖
    if  var == 2  then
        if bool == 0 then return end
        local data = FuHuaHuaPu.getFlagstate(actor)
        for k, v in ipairs(data) do
            if v < 1000 then
                Player.sendmsgEx(actor, "提示#251|:#255|对不起,你的|第".. k .."进度条#249|不足|1000#249|收获失败...")
                return
            end
        end
        local AwardData = "腐化メ虚伪#15|腐化メ恐惧#20|腐化メ残暴#40|腐化メ奸诈#25"
        local AwardItem, _ = ransjstr(AwardData, 1, 3)
        local UserId = getconst(actor, "<$USERID>")
        sendmail(UserId, 5001, "腐化花圃", "恭喜你成功收获"..AwardItem,AwardItem.."#1")
        setflagstatus(actor,VarCfg["F_腐化之种收获一次"],1)
        Player.sendmsgEx(actor, "提示#251|:#255|恭喜你,恭喜你成功收获|".. AwardItem .."#249|已通过邮件发放...")
        setplaydef(actor,VarCfg["B_腐化花圃_恐惧"],0)
        setplaydef(actor,VarCfg["B_腐化花圃_奸诈"],0)
        setplaydef(actor,VarCfg["B_腐化花圃_残暴"],0)
        setplaydef(actor,VarCfg["B_腐化花圃_虚伪"],0)
        FuHuaHuaPu.SyncResponse(actor)
    end

    --置换
    FuHuaHuaPu.gives = { "腐化メ虚伪", "腐化メ恐惧", "腐化メ残暴", "腐化メ奸诈"}
    if  var == 3 then
        local hasEquip = {}
        for _, v in ipairs(FuHuaHuaPu.gives) do
            local num = getbagitemcount(actor, v)
            if num > 0 then
                table.insert(hasEquip,v)
            end
        end
        if #hasEquip == 0 then
            Player.sendmsgEx(actor, "[提示]:#251|你背包没有腐化装备#249")
            return
        end

        if querymoney(actor, 7) < 888 then
            Player.sendmsgEx(actor,"[提示]:#251|置换失败,你的|灵符#249|不足|888#249")
            return
        end

        local itemname = hasEquip[math.random(1, #hasEquip)]
        takeitem(actor, itemname, 1, 0, "腐化装备置换")
        changemoney(actor, 7, "-", 888, "腐化装备置换", true)

        local randomNum = math.random(1,4)
        local give = FuHuaHuaPu.gives[randomNum]
        giveitem(actor,give,1)
        messagebox(actor,string.format("使用【%s】，随机更换腐化装备：【%s】",hasEquip[1],give))
    end
end


--杀死怪物触发
local Mon_B_data={["蚀月女王メ虚伪"]= "B_腐化花圃_虚伪",["红眸狂猿メ恐惧"]= "B_腐化花圃_恐惧",["太古狂魔メ残暴"]= "B_腐化花圃_残暴",["上古魔王メ奸诈"]= "B_腐化花圃_奸诈"}
local function _onKillMon(actor, monobj, monName)
    if getflagstatus(actor,VarCfg["F_腐化之种开启状态"]) == 0 then return end
        if Mon_B_data[monName] then
            local VarName = Mon_B_data[monName]
            local num = getplaydef(actor,VarCfg[VarName])
            num = num + 1
            setplaydef(actor,VarCfg[VarName],num)
        end
    end
GameEvent.add(EventCfg.onKillMon, _onKillMon, FuHuaHuaPu)

-- 腐化メ奸诈 攻速附加 +15%
local function _onCalcAttackSpeed(actor, attackSpeeds)
    if checkitemw(actor, "腐化メ奸诈", 1) then
        attackSpeeds[1] = attackSpeeds[1] + 12
    end
end
GameEvent.add(EventCfg.onCalcAttackSpeed, _onCalcAttackSpeed, FuHuaHuaPu)

--倍攻触发 腐化メ虚伪 +6%
local function _onCalcBeiGong(actor, beiGongs)
    if checkitemw(actor, "腐化メ虚伪", 1) then
        beiGongs[1] = beiGongs[1] + 6
    end
end
GameEvent.add(EventCfg.onCalcBeiGong, _onCalcBeiGong, FuHuaHuaPu)

--人物穿装备----人物穿戴任意装备触发
local function _onTakeOnEx(actor, itemobj, where, itemname, makeid)
    if itemname == "腐化メ奸诈" then
        Player.setAttList(actor, "攻速附加")
    end
    if itemname == "腐化メ虚伪" then
        Player.setAttList(actor, "倍攻附加")
    end
end
GameEvent.add(EventCfg.onTakeOnEx, _onTakeOnEx, FuHuaHuaPu)

--人物脱装备---人物脱下任意装备触发
local function _onTakeOffEx(actor, itemobj, where, itemname, makeid)
    if itemname == "腐化メ奸诈" then
        Player.setAttList(actor, "攻速附加")
    end
    if itemname == "腐化メ虚伪" then
        Player.setAttList(actor, "倍攻附加")
    end
end
GameEvent.add(EventCfg.onTakeOffEx, _onTakeOffEx, FuHuaHuaPu)

--注册网络消息
function FuHuaHuaPu.SyncResponse(actor, logindatas)
    local bool = getflagstatus(actor,VarCfg["F_腐化之种开启状态"])
    local data = FuHuaHuaPu.getFlagstate(actor)
    local _login_data = { ssrNetMsgCfg.FuHuaHuaPu_SyncResponse, bool, 0, 0, data }
    if type(logindatas) == "table" then
        table.insert(logindatas, _login_data)
    else
        Message.sendmsg(actor, ssrNetMsgCfg.FuHuaHuaPu_SyncResponse, bool, 0, 0, data)
    end
end
Message.RegisterNetMsg(ssrNetMsgCfg.FuHuaHuaPu, FuHuaHuaPu)

--登录触发
local function _onLoginEnd(actor, logindatas)
    FuHuaHuaPu.SyncResponse(actor, logindatas)
end
GameEvent.add(EventCfg.onLoginEnd, _onLoginEnd, FuHuaHuaPu)

return FuHuaHuaPu

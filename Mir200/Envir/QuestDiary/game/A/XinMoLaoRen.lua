local XinMoLaoRen = {}

local XinMoAttrs = { 225, 275, 325 }
local msgbox = { "贪", "嗔", "痴" }
local rankFonts = { "一", "二", "三" }
local cost = { { { "绑定灵符", 588 } }, { { "神秘专属盲盒", 2 } }, { { "神秘专属盲盒", 1 } } }
local costXiuXianZhi = { 4000, 2000, 1000 }
local otherCost = { { "绑定灵符", 200 } }
local otherCostXiuXianZhi = 600
--心魔属性
function xin_mo_lao_ren_set_var(actor)
    setplaydef(actor, VarCfg["M_心魔老人标识"], 1)
end

--添加修仙值奖励
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

--发送奖励到邮件
local function SendRewardToMail(actor, reward)
    local userId = getbaseinfo(actor, ConstCfg.gbase.id)
    Player.giveMailByTable(userId, 1, "心魔老人", "恭喜你挑战所有心魔,请领取您的奖励,修仙值已自动发放,可到修仙界面查看!", reward, 1, 1)
end

--获取心魔挑战排名
function XinMoLaoRen.getXinMoRank(actor)
    local rank = Player.getJsonTableByVar(nil, VarCfg["A_心魔老人排名列表"])
    return #rank
end

--设置心魔挑战排名
function XinMoLaoRen.setXinMoRank(actor)
    local rank_list = Player.getJsonTableByVar(nil, VarCfg["A_心魔老人排名列表"])
    if #rank_list < 3 then
        local myName = getbaseinfo(actor, ConstCfg.gbase.name)
        local current_time = os.date("*t")
        local year = current_time.year
        local month = current_time.month
        local day = current_time.day
        local hour = current_time.hour
        local min = current_time.min
        local sec = current_time.sec
        local currTime = string.format("%d-%d-%d\n%s:%s:%s", year, month, day, hour, min, sec)
        local tmpTbl = { myName, currTime }
        table.insert(rank_list, tmpTbl)
        Player.setJsonVarByTable(nil, VarCfg["A_心魔老人排名列表"], rank_list)
    end
end

function XinMoLaoRen.Request(actor)
    local XinMoConut = getplaydef(actor, VarCfg["U_心魔老人挑战次数"]) + 1
    if XinMoConut > 3 then
        Player.sendmsgEx(actor, "你已经完成了所有心魔挑战!")
        return
    end
    --继承属性
    local attr = XinMoAttrs[XinMoConut]
    local time = 3000
    local myName = getbaseinfo(actor, ConstCfg.gbase.name)
    local oldMapId = getbaseinfo(actor, ConstCfg.gbase.mapid)
    local x = getbaseinfo(actor, ConstCfg.gbase.x)
    local y = getbaseinfo(actor, ConstCfg.gbase.y)
    local newMapId = myName .. "的心魔殿堂"
    delmirrormap(newMapId)
    addmirrormap("05385", newMapId, myName .. "的心魔殿堂", time, oldMapId, 010075, x, y)
    mapmove(actor, newMapId, 44, 51, 0)
    delaygoto(actor, 1000, "xin_mo_lao_ren_set_var")
    Player.cloneSelfToHumanoid(actor, newMapId, 46, 49, myName .. "的心魔", "心魔", 1, 249, attr)
    sendcentermsg(actor, 250, 0, "[心魔老人]：域外心魔已经潜伏在你的分身上,邪恶的力量正在滋生,即将开始挑战心魔！请玩家注意……", 0, 5)
    sendcentermsg(actor, 250, 0, "[心魔老人]：域外心魔已经潜伏在你的分身上,邪恶的力量正在滋生,即将开始挑战心魔！请玩家注意……", 0, 5)
    sendcentermsg(actor, 250, 0, "[心魔老人]：域外心魔已经潜伏在你的分身上,邪恶的力量正在滋生,即将开始挑战心魔！请玩家注意……", 0, 5)
end

--请求打开UI
function XinMoLaoRen.openUI(actor, arg1, arg2, arg3, data)
    local XinMoConut = getplaydef(actor, VarCfg["U_心魔老人挑战次数"])
    local data = {
        currTiaoZhan = XinMoConut,
        rankData = Player.getJsonTableByVar(nil, VarCfg["A_心魔老人排名列表"]),
    }
    Message.sendmsg(actor, ssrNetMsgCfg.XinMoLaoRen_openUI, 0, 0, 0, data)
end

--杀怪触发
local function _onKillMon(actor, monobj)
    local flag = getplaydef(actor, VarCfg["M_心魔老人标识"])
    if flag == 1 then
        local myName = getbaseinfo(actor, ConstCfg.gbase.name)
        local currMapID = myName .. "的心魔殿堂"
        if not FCheckMap(actor,currMapID) then
            return
        end
        local XinMoConut = getplaydef(actor, VarCfg["U_心魔老人挑战次数"])
        setplaydef(actor, VarCfg["U_心魔老人挑战次数"], XinMoConut + 1)
        local msgbox = msgbox[XinMoConut + 1]
        local currMapId = getbaseinfo(actor, ConstCfg.gbase.mapid)
        delmirrormap(currMapId)
        if XinMoConut + 1 >= 3 then
            local rank = XinMoLaoRen.getXinMoRank(actor)
            if rank <= 2 then
                XinMoLaoRen.setXinMoRank(actor)
                local reward = cost[rank + 1]
                local xiuXian = costXiuXianZhi[rank + 1]
                SendRewardToMail(actor, reward)
                AddXiuXianZhi(actor, xiuXian)
                messagebox(actor,
                    string.format("恭喜你完成心魔\"%s\"挑战,你是第%s位完成所有挑战,请到邮件领取您的奖励,修仙值已自动发放!", msgbox, rankFonts[rank + 1] or ""))
                addhpper(actor,"=",100)
            else
                messagebox(actor, string.format("恭喜你完成心魔\"%s\"挑战,你已经完成所有心魔挑战,请到邮件领取您的奖励,修仙值已自动发放!", msgbox))
                SendRewardToMail(actor, otherCost)
                AddXiuXianZhi(actor, otherCostXiuXianZhi)
                addhpper(actor,"=",100)
            end
        else
            messagebox(actor, string.format("恭喜你完成心魔\"%s\"挑战!", msgbox))
            addhpper(actor,"=",100)
        end
    end
end
GameEvent.add(EventCfg.onKillMon, _onKillMon, XinMoLaoRen)
Message.RegisterNetMsg(ssrNetMsgCfg.XinMoLaoRen, XinMoLaoRen)
return XinMoLaoRen

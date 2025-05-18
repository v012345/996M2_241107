local MeiRiChongZhi = {}
local config = include("QuestDiary/cfgcsv/cfg_RiChongBoss.lua") --杀怪配置
local maps = {
    ["神龙幻境1"] = true,
    ["神龙幻境2"] = true,
    ["酆都幻境1"] = true,
    ["酆都幻境2"] = true,
    ["极恶幻境1"] = true,
    ["极恶幻境2"] = true,
    ["圣城幻境1"] = true,
    ["圣城幻境2"] = true,
    ["圣城秘宝阁1"] = true,
    ["圣城秘宝阁2"] = true,
    ["破晓幻境1"] = true,
    ["破晓幻境2"] = true,
    ["破晓秘宝阁1"] = true,
    ["破晓秘宝阁2"] = true,
    ["新月幻境1"] = true,
    ["新月幻境2"] = true,
    ["新月秘宝阁1"] = true,
    ["新月秘宝阁2"] = true,
    
}

--获取物品对象
function getitemobj(actor,name)
    local  baglist = getbagitems(actor,name) --获取背包所有物品
    local  itemobj = "0"
    if name == "神秘人斗笠" then
        if getconst(actor, "<$HAT>") == "神秘人斗笠" then
            itemobj = linkbodyitem(actor, 13)
        else
            for _, obj in ipairs(baglist) do
                local itemname = getiteminfo(actor, obj, 7)
                if itemname == name then
                    itemobj = obj
                    break
                end
            end
        end
    else
        for _, obj in ipairs(baglist) do
            local itemname = getiteminfo(actor, obj, 7)
            if itemname == name then
                itemobj = obj
                break
            end
        end
    end
    return itemobj
end

--获取最小时间
function getsmallitmes(time1,time2,time3)
    local min_time = math.huge  -- 初始化为正无穷大
    if time1 > 0 and time1 < min_time then
        min_time = time1
    end

    if time2 > 0 and time2 < min_time then
        min_time = time2
    end

    if time3 > 0 and time3 < min_time then
        min_time = time3
    end
    return min_time
end
--删除一遍
function delitems(actor)
    local ShenMiRen = Bag.getItemNum(actor, "神秘人斗笠")
    local BianShenQi = Bag.getItemNum(actor, "我有一只小熊猫[变身器]")
    local TongXingZheng = Bag.getItemNum(actor, "幻境通行证")
    if getconst(actor, "<$HAT>") == "神秘人斗笠" then
        takew(actor, "神秘人斗笠", 1, "日冲删除")
    end
    if ShenMiRen > 0 then
        takeitem(actor,"神秘人斗笠", ShenMiRen, 0, "日冲删除")
    end
    if BianShenQi > 0 then
        takeitem(actor,"我有一只小熊猫[变身器]", BianShenQi, 0, "日冲删除")
    end
    if TongXingZheng > 0 then
        takeitem(actor,"幻境通行证", TongXingZheng, 0, "日冲删除")
    end
end

function MeiRiChongZhi.Request(actor, avr1)
    local heQuDay = tonumber(getconst("0", "<$HFCOUNT>"))
    if heQuDay == 0 then
        Player.sendmsgEx(actor, "提示#251|:#255|点你奶奶个腿...")
        return
    end

    if getplaydef(actor, VarCfg["J_日冲领取状态"]) == 1 then
        Player.sendmsgEx(actor, "提示#251|:#255|对不起,你已领取过|幻境通行证#249|请勿重复领取...")
        return
    end

    local RiChongNum = getplaydef(actor, VarCfg["J_日冲记录"])
    if RiChongNum < 38 then
        Player.sendmsgEx(actor, "提示#251|:#255|对不起,你今日充值|不足38元#249|领取失败...")
        return
    end

    local BeiBaoNum = getbagblank(actor)
    if BeiBaoNum < 10 then
        Player.sendmsgEx(actor, "提示#251|:#255|对不起,你的背包|不足#249|领取失败...")
        return
    end

    local ItemObj1 = getitemobj(actor,"幻境通行证")
    local ItemObj2 = getitemobj(actor,"神秘人斗笠")
    local ItemObj3 = getitemobj(actor,"我有一只小熊猫[变身器]")
    local time1 = (ItemObj1 == "0" and 0) or getitemaddvalue(actor, ItemObj1, 2, 0)
    local time2 = (ItemObj2 == "0" and 0) or getitemaddvalue(actor, ItemObj2, 2, 0)
    local time3 = (ItemObj3 == "0" and 0) or getitemaddvalue(actor, ItemObj3, 2, 0)
    local NewTime = getsmallitmes(time1,time2,time3) --获取最小时间

    if NewTime == math.huge then
        delitems(actor)
        giveitem(actor, "幻境通行证", 1, 0, "每日充值获取")
        giveitem(actor, "神秘人斗笠", 1, 0, "每日充值获取")
        giveitem(actor, "我有一只小熊猫[变身器]", 1, 0, "每日充值获取")
        changemoney(actor, 20, "+", 380, "每日充值获取", true)
        Player.sendmsgEx(actor, "提示#251|:#255|恭喜你,成功领取|幻境通行证#249|已经发放到背包...")
    else
        setitemaddvalue(actor,ItemObj1, 2, 0, NewTime + 86400)
        setitemaddvalue(actor,ItemObj2, 2, 0, NewTime + 86400)
        setitemaddvalue(actor,ItemObj3, 2, 0, NewTime + 86400)
        changemoney(actor, 20, "+", 380, "每日充值获取", true)
        Player.sendmsgEx(actor, "提示#251|:#255|恭喜你,成功领取|幻境通行证#249|时间已叠加24小时...")
    end

    --刷新盒子
    setplaydef(actor, VarCfg["Z_奇遇盒子位置4"], "")
    QiYuHeZi.SyncResponse(actor)

    --刷新前端
    setplaydef(actor, VarCfg["J_日冲领取状态"], 1)
    MeiRiChongZhi.SyncResponse(actor)

    --刷新属性
    Player.setAttList(actor, "属性附加")
    Player.setAttList(actor, "爆率附加")
end

--属性刷新
local function _onCalcAttr(actor, attrs)
    if checkitems(actor, "幻境通行证#1", 0, 0) then
        local shuxingMap = {
            [208] = 10,
            [205] = 20,
            [216] = 50,
        }
        calcAtts(attrs, shuxingMap, "幻境通行证")
    end
end
GameEvent.add(EventCfg.onCalcAttr, _onCalcAttr, MeiRiChongZhi)

--爆率附加
local function _onCalcBaoLv(actor, attrs)
    if checkitems(actor, "幻境通行证#1", 0, 0) then
        local shuxing = {
            [204] = 300
        }
        calcAtts(attrs, shuxing, "幻境通行证")
    end
end
GameEvent.add(EventCfg.onCalcBaoLv, _onCalcBaoLv, MeiRiChongZhi)

--玩家限时装备到期触发
local function _onPlayItemExpired(actor, itemobj, itemname)
    if itemname == "幻境通行证" then
        local buff = hasbuff(actor, 31066)
        if buff then
            FkfDelBuff(actor, 31066)
        end
        Player.setAttList(actor, "属性附加")
        Player.setAttList(actor, "爆率附加")
        TopIcon.addico(actor)
        local InTheMap = getbaseinfo(actor, ConstCfg.gbase.mapid)
        if maps[InTheMap] then
            mapmove(actor, "n3", 330, 330, 5)
        end
    end

    if itemname == "高级幻境通行证" then
        local InTheMap = getbaseinfo(actor, ConstCfg.gbase.mapid)
        if maps[InTheMap] then
            mapmove(actor, "n3", 330, 330, 5)
        end
    end
end
GameEvent.add(EventCfg.onPlayItemExpired, _onPlayItemExpired, MeiRiChongZhi)

--切换地图触发
local function _goSwitchMap(actor, cur_mapid)
    if not checkitems(actor, "幻境通行证#1", 0, 0) or getsysvar(VarCfg["A_幻境地图开关"]) ~= "开" then
        if maps[cur_mapid] then
            mapmove(actor, "n3", 330, 330, 5)
        end
    end
end
GameEvent.add(EventCfg.goSwitchMap, _goSwitchMap, MeiRiChongZhi)


--杀怪触发
local function _onKillMon(actor, monobj, monName)
    local mapId = getbaseinfo(actor, ConstCfg.gbase.mapid)
    if maps[mapId] then
        local cfg = config[monName]
        if config[monName] then
            if randomex(1, cfg.random) then
                additemtodroplist(actor, monobj, "异界神石")
            end
        end
    end
end
GameEvent.add(EventCfg.onKillMon, _onKillMon, MeiRiChongZhi)

--消息同步
function MeiRiChongZhi.SyncResponse(actor,logindatas)
    local LingQuState = getplaydef(actor, VarCfg["J_日冲领取状态"])
    local _login_data = { ssrNetMsgCfg.MeiRiChongZhi_SyncResponse, 0, 0, 0, {LingQuState}}
    if logindatas then
        table.insert(logindatas, _login_data)
    else
        Message.sendmsg(actor, ssrNetMsgCfg.MeiRiChongZhi_SyncResponse, 0, 0, 0, {LingQuState})
    end
end
--注册网络消息
Message.RegisterNetMsg(ssrNetMsgCfg.MeiRiChongZhi, MeiRiChongZhi)

--新的一天
local MiBaoGeMap = {"破晓秘宝阁1", "破晓秘宝阁2", "圣城秘宝阁1", "圣城秘宝阁2", "新月秘宝阁1", "新月秘宝阁2" }
local function _onNewDay(actor)
    MeiRiChongZhi.SyncResponse(actor)
    local RiChongNum = getplaydef(actor, VarCfg["J_日冲记录"])
    if RiChongNum < 68 then
        if maps[MiBaoGeMap] then
            mapmove(actor, "n3", 330, 330, 5)
        end
    end
end
GameEvent.add(EventCfg.onNewDay, _onNewDay, MeiRiChongZhi)

--登录触发
local function _onLoginEnd(actor, logindatas)
    MeiRiChongZhi.SyncResponse(actor, logindatas)
end
GameEvent.add(EventCfg.onLoginEnd, _onLoginEnd, MeiRiChongZhi)



return MeiRiChongZhi

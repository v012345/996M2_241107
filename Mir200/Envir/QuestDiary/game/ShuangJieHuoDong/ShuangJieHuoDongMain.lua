ShuangJieHuoDongMain = {}
ShuangJieHuoDongMain.ID = "双节活动Main"
local config = {
    [1] = { { "圣诞花环", 10 }, { "灵石", 10 }, { "绑定灵符", 100 }, { "元宝", 100000 }, { "混沌本源", 1 } },
    [2] = include("QuestDiary/cfgcsv/cfg_ShuangJieFuLi.lua"),
    [3] = include("QuestDiary/cfgcsv/cfg_ShuangJieKuangHuan.lua"),
    [4] = include("QuestDiary/cfgcsv/cfg_ShuangJieShangCheng.lua"),
    [5] = { mapID = "狂欢小镇", x = 61, y = 80, range = 1 },
}
--补领
function shuang_jie_bu_ling(actor, index)
    index = tonumber(index)
    local cfg = config[2][index]
    if not cfg then
        Player.sendmsgEx(actor, "参数错误#249")
        return
    end
    local isLingQu = getflagstatus(actor, cfg.flag)
    local dayChinese = formatNumberToChinese(index)
    if isLingQu == 1 then
        Player.sendmsgEx(actor, "你已经领取过第" .. dayChinese .. "天的奖励了#249")
        return
    end
    local RiChongNum = getplaydef(actor, VarCfg["J_日冲记录"])
    if RiChongNum < 1 then
        Player.sendmsgEx(actor, "领取失败，你今天没有充值！#249")
        return
    end
    local day = ShuangJieHuoDongMain.getStartDays()
    if index > day then
        Player.sendmsgEx(actor, "还没到领取时间呢#249")
        return
    end
    if querymoney(actor, 7) < 500 then
        Player.sendmsgEx(actor, "领取失败，你的|灵符#249|不足|500#249")
        return
    end
    changemoney(actor, 7, "-", 500, "双节活动补领", true)
    local uid = Player.GetUUID(actor)
    Player.giveMailByTable(uid, 1, "双节福利第" .. dayChinese .. "天奖励", "请领取您的双节福利第" .. dayChinese .. "天奖励", cfg.give, 1, true)
    Player.sendmsgEx(actor, "领取奖励成功，请到邮箱查收")
    setflagstatus(actor, cfg.flag, 1)
    local data = ShuangJieHuoDongMain.getShuangJieFuLidata(actor)
    ShuangJieHuoDongMain.SyncResponse(actor)
end

--双节活动开始日期
local startDate = 20241225
--双节活动开启天数
local openDays = 8
--获取活动开启日期
function ShuangJieHuoDongMain.getOpenDate()
    return startDate
end

--获取双节活动开始的天数
function ShuangJieHuoDongMain.getStartDays()
    local today = GetCurrentDateAsNumber()
    --服务器启动日期
    local serverStartDate = getsysvar(VarCfg["G_开区日期"])
    local _startDate = serverStartDate
    if serverStartDate < startDate then
        _startDate = startDate
    end
    local diff = getDaysDiff(_startDate, today)
    return diff + 1 -- +1 是因为当天也算一天
end

--获取双节活动剩余天数
function ShuangJieHuoDongMain.getLeftDays()
    local days = ShuangJieHuoDongMain.getStartDays()
    return openDays - days
end

--判断双节活动是否开启
function ShuangJieHuoDongMain.isOpen()
    local days = ShuangJieHuoDongMain.getStartDays()
    if days <= 0 then
        return false
    end
    --剩余天数
    local getLeftDays = ShuangJieHuoDongMain.getLeftDays()
    if getLeftDays < 0 then
        return false
    end
    return true
end

--接收请求
function ShuangJieHuoDongMain.Request(actor)
    release_print(ShuangJieHuoDongMain.getStartDays())
end

--获取所有页面数据
function ShuangJieHuoDongMain.GetAllData(actor)
    local data = {}
    data.data = {}
    local leftDays = ShuangJieHuoDongMain.getLeftDays()
    data.data[1] = { getplaydef(actor, VarCfg["J_双节活动是否领取"]) }
    data.data[2] = ShuangJieHuoDongMain.getShuangJieFuLidata(actor)
    data.data[3] = ShuangJieHuoDongMain.getShuangJieLeiChong(actor)
    data.data[4] = ShuangJieHuoDongMain.getShuangJieShangChengData(actor)
    data.leftDays = leftDays
    return data
end

function ShuangJieHuoDongMain.OpenUI(actor)
    local data = ShuangJieHuoDongMain.GetAllData(actor)
    Message.sendmsg(actor, ssrNetMsgCfg.ShuangJieHuoDongMain_OpenUI, 0, 0, 0, data)
end

--领取奖励
function ShuangJieHuoDongMain.LingQuReward(actor)
    --双节活动剩余天数
    local isOpen = ShuangJieHuoDongMain.isOpen()
    if not isOpen then
        Player.sendmsgEx(actor, "双节活动已结束#249")
        return
    end
    local isLingQu = getplaydef(actor, VarCfg["J_双节活动是否领取"])
    if isLingQu == 1 then
        Player.sendmsgEx(actor, "你已经领取过奖励了#249")
        return
    end
    local cfg = config[1]
    local dayChinese = formatNumberToChinese(ShuangJieHuoDongMain.getStartDays())
    local mailTitle = "双节活动第" .. dayChinese .. "天登陆奖励"
    local mailContent = "请领取您的双节活动第" .. dayChinese .. "天登陆奖励"
    local uid = Player.GetUUID(actor)
    Player.giveMailByTable(uid, 1, mailTitle, mailContent, cfg, 1, true)
    setplaydef(actor, VarCfg["J_双节活动是否领取"], 1)
    Player.sendmsgEx(actor, "领取奖励成功，请到邮箱查收")
    ShuangJieHuoDongMain.SyncResponse(actor)
end

function ShuangJieHuoDongMain.ShuangJieFuLi(actor, index)
    --双节活动剩余天数
    local isOpen = ShuangJieHuoDongMain.isOpen()
    if not isOpen then
        Player.sendmsgEx(actor, "双节活动已结束#249")
        return
    end
    local RiChongNum = getplaydef(actor, VarCfg["J_日冲记录"])
    if RiChongNum < 1 then
        Player.sendmsgEx(actor, "领取失败，你今天没有充值！#249")
        return
    end
    local cfg = config[2][index]
    if not cfg then
        Player.sendmsgEx(actor, "参数错误#249")
        return
    end
    local day = ShuangJieHuoDongMain.getStartDays()
    if index > day then
        Player.sendmsgEx(actor, "还没到领取时间呢#249")
        return
    end
    local currDayChinese = formatNumberToChinese(index)
    local isLingQu = getflagstatus(actor, cfg.flag)
    if isLingQu == 1 then
        Player.sendmsgEx(actor, "你已经领取过第" .. currDayChinese .. "天的奖励了#249")
        return
    end
    --补领货币
    if index < day then
        messagebox(actor, "补领需要【500非绑灵符】，是否补领？", "@shuang_jie_bu_ling," .. index, "@quxiao")
        return
    end
    if index == day then
        local dayChinese = formatNumberToChinese(day)
        local mailTitle = "双节福利第" .. dayChinese .. "天奖励"
        local mailContent = "请领取您的双节福利第" .. dayChinese .. "天奖励"
        local uid = Player.GetUUID(actor)
        Player.giveMailByTable(uid, 1, mailTitle, mailContent, cfg.give, 1, true)
        Player.sendmsgEx(actor, "领取奖励成功，请到邮箱查收")
        setflagstatus(actor, cfg.flag, 1)
        local data = ShuangJieHuoDongMain.getShuangJieFuLidata(actor)
        ShuangJieHuoDongMain.SyncResponse(actor)
    end
end

--领取双节最终奖励
function ShuangJieHuoDongMain.ShuangJieFuLiLingQu(actor)
    local cfg = config[2]
    local flag = 0
    for _, value in ipairs(cfg) do
        if getflagstatus(actor, value.flag) == 1 then
            flag = flag + 1
        end
    end
    if flag < 8 then
        Player.sendmsgEx(actor, "领取失败，你还有奖励未领取#249")
        return
    end
    if getflagstatus(actor, VarCfg["F_双节福利总奖励是否领取"]) == 1 then
        Player.sendmsgEx(actor, "领取失败，你已经领取过了#249")
        return
    end
    local totalGive = { { "三百六十五个祝福", 1 } }
    local uid = Player.GetUUID(actor)
    Player.giveMailByTable(uid, 1, "双节福利最终奖励", "请领取您的双节福利最终奖励", totalGive, 1, true)
    setflagstatus(actor, VarCfg["F_双节福利总奖励是否领取"], 1)
    Player.sendmsgEx(actor, "领取奖励成功，请到邮箱查收")
end

--双节狂欢
function ShuangJieHuoDongMain.ShuangJieKuangHuan(actor, index)
    local cfg = config[3][index]
    if not cfg then
        Player.sendmsgEx(actor, "参数错误#249")
        return
    end
    --写一个函数，检测是否全部领取
    local function isAllLingQu()
        local _cfg = config[3]
        local flag = 0
        for _, value in ipairs(_cfg) do
            if getflagstatus(actor, value.flag) == 1 then
                flag = flag + 1
            end
        end
        return flag >= 4
    end
    local isOpen = ShuangJieHuoDongMain.isOpen()
    if not isOpen then
        Player.sendmsgEx(actor, "双节活动已结束#249")
        return
    end
    local leiChong = getplaydef(actor, VarCfg["B_双节活动累充值"])
    local lingQuNum = getplaydef(actor, VarCfg["B_双节活动领取次数"])
    if lingQuNum >= 5 then
        Player.sendmsgEx(actor, "最多只能领取5轮#249")
        return
    end
    if leiChong < cfg.money then
        Player.sendmsgEx(actor, "领取失败，你的累充值不足" .. cfg.money .. "#249")
        return
    end
    if getflagstatus(actor, cfg.flag) == 1 then
        Player.sendmsgEx(actor, "领取失败，你已经领取过了#249")
        return
    end
    setflagstatus(actor, cfg.flag, 1)
    --发送奖励邮箱
    local uid = Player.GetUUID(actor)
    Player.giveMailByTable(uid, 1, "双节狂欢累充" .. cfg.money .. "元奖励", "请领取您的双节狂欢累充" .. cfg.money .. "元奖励", cfg.give, 1, true)
    Player.sendmsgEx(actor, "领取奖励成功，请到邮箱查收")
    local isAllLingQuBool = isAllLingQu()
    --如果全部领取，则清空所有领取状态，进入下一轮
    if isAllLingQuBool then
        local __cfg = config[3]
        for _, value in ipairs(__cfg) do
            setflagstatus(actor, value.flag, 0)
        end
        setplaydef(actor, VarCfg["B_双节活动领取次数"], lingQuNum + 1) --领取次数+1
        setplaydef(actor, VarCfg["B_双节活动累充值"], leiChong - 1000) --减去1000元累充
        messagebox(actor, "你已经领取了所有奖励，将重置累充金额（-1000），进入下一轮。")
    end
    ShuangJieHuoDongMain.SyncResponse(actor)
end

--双节商城
function ShuangJieHuoDongMain.ShuangJieShangCheng(actor, index)
    local cfg = config[4][index]
    if not cfg then
        Player.sendmsgEx(actor, "参数错误#249")
        return
    end
    local itemName = cfg.item[1][1]
    local itemNum = cfg.item[1][2]
    local data = Player.getJsonTableByVar(actor, VarCfg["T_双节对换数据"])
    local obtainedCount = data[itemName] or 0 --获取已兑换次数
    local RemainingCount = cfg.max - obtainedCount
    if RemainingCount <= 0 then
        Player.sendmsgEx(actor, "兑换失败,您的兑换次数不足!#249")
        return
    end
    local cost = cfg.cost
    local name, num = Player.checkItemNumByTable(actor, cost)
    if name then
        Player.sendmsgEx(actor, string.format("你的|%s#249|不足|%d#249", name, num))
        return
    end
    if not Bag.checkBagEmptyNum(actor, 5) then
        Player.sendmsgEx(actor, "你的背包格子不足,至少留出5个空格!#249")
        stop(actor)
        return
    end
    Player.takeItemByTable(actor, cost, "双节商城兑换")
    Player.sendmsgEx(actor, string.format("兑换成功,获得|%s*%d#249", itemName, itemNum))
    -- local uid = Player.GetUUID(actor)
    -- Player.giveMailByTable(uid, 1, "双节活动商城兑换", "请领取您的双节活动商城兑换奖励!", cfg.item, 1, true)
    Player.giveItemByTable(actor, cfg.item, "双节商城兑换", 1, true)
    --成功之后 增加次数
    if data[itemName] then
        data[itemName] = data[itemName] + 1
    else
        data[itemName] = 1
    end
    Player.setJsonVarByTable(actor, VarCfg["T_双节对换数据"], data)
    ShuangJieHuoDongMain.SyncResponse(actor)
end

--双节狂欢小镇
function ShuangJieHuoDongMain.KuangHuanXiaoZhen(actor)
    --是否是开启时间
    local isOpen = ShuangJieHuoDongMain.isOpen()
    if not isOpen then
        Player.sendmsgEx(actor, "活动未开启！#249")
        return
    end
    local isTime = isTimeInRange(18, 00, 21, 00)
    if not isTime then
        Player.sendmsgEx(actor, "地图未开启，地图开启时间：18:00-21:00#249")
        return
    end
    local cfg = config[5]
    local map = cfg.mapID
    local x = cfg.x
    local y = cfg.y
    local range = cfg.range
    FMapMoveEx(actor, map, x, y, range)
    Player.screffects(actor, 63150, -600, 600)
end

--获取双节福利数据
function ShuangJieHuoDongMain.getShuangJieFuLidata(actor)
    local data = {} --状态 0代表不可领取 1代表可领取 2代表已领取 3代表已过期可补领
    local day = ShuangJieHuoDongMain.getStartDays()
    local cfg = config[2]
    for index, value in ipairs(cfg) do
        local flag = getflagstatus(actor, value.flag)
        --state
        --0代表不可领取
        --1代表可领取
        --2代表已领取
        --3代表已过期可补领
        local state = 0
        if index > day then
            state = 0
        elseif index == day then
            state = 1
        else
            state = 3
        end
        if flag == 1 then
            state = 2
        end
        table.insert(data, state)
    end
    return data
end

--获取双节活动累充值
function ShuangJieHuoDongMain.getShuangJieLeiChong(actor)
    local data = {}
    data.leiChong = getplaydef(actor, VarCfg["B_双节活动累充值"])
    data.lingQuNum = getplaydef(actor, VarCfg["B_双节活动领取次数"])
    data.flags = {}
    for _, value in ipairs(config[3]) do
        table.insert(data.flags, getflagstatus(actor, value.flag))
    end
    return data
end

--获取双节对换数据
function ShuangJieHuoDongMain.getShuangJieShangChengData(actor)
    local data = Player.getJsonTableByVar(actor, VarCfg["T_双节对换数据"])
    return data
end

--同步消息
function ShuangJieHuoDongMain.SyncResponse(actor)
    local data = ShuangJieHuoDongMain.GetAllData(actor)
    Message.sendmsg(actor, ssrNetMsgCfg.ShuangJieHuoDongMain_SyncResponse, 0, 0, 0, data)
end

--登录触发
local function _onLoginEnd(actor)
    if checkitems(actor, "三百六十五个祝福#1", 0, 0) then
        local state = getplaydef(actor, VarCfg["Z_天天交好运领取状态"])
        if state ~= "已附加" then
            setplaydef(actor, VarCfg["Z_天天交好运领取状态"], "已附加")
            local BaoLv = getplaydef(actor, VarCfg["B_天天交好运爆率"])
            BaoLv = BaoLv + 1
            setplaydef(actor, VarCfg["B_天天交好运爆率"], BaoLv)
        end
    end
end
GameEvent.add(EventCfg.onLoginEnd, _onLoginEnd, ShuangJieHuoDongMain)

--充值触发
local function _onRecharge(actor, gold, productid, moneyid)
    if not ShuangJieHuoDongMain.isOpen() then
        return
    end
    if getplaydef(actor, "N$不计入双节累充") == 1 then
        setplaydef(actor, "N$不计入双节累充", 0)
        return
    end
    local currLeiChong = getplaydef(actor, VarCfg["B_双节活动累充值"])
    currLeiChong = currLeiChong + gold
    setplaydef(actor, VarCfg["B_双节活动累充值"], currLeiChong)
end
GameEvent.add(EventCfg.onRecharge, _onRecharge, ShuangJieHuoDongMain)

-- --双节活动开启
-- local function _checkShuangJieHuoDong()
--     local startDate = ShuangJieHuoDongMain.getOpenDate()
--     local currDate = GetCurrentDateAsNumber()
--     local isOpen = ShuangJieHuoDongMain.isOpen()
--     if currDate >= startDate and isOpen then
--         setsysvar(VarCfg["G_双节活动是否开启"], 1)
--     else
--         setsysvar(VarCfg["G_双节活动是否开启"], 0)
--     end
-- end
-- --每日凌晨执行
-- local function _onBeforedawn(openday)
--     _checkShuangJieHuoDong()
-- end
-- GameEvent.add(EventCfg.roBeforedawn, _onBeforedawn, ShuangJieHuoDongMain)

--引擎启动触发
-- local function _onStartUp()
--     _checkShuangJieHuoDong()
-- end
-- GameEvent.add(EventCfg.onStartUp, _onStartUp, ShuangJieHuoDongMain)

--双节活动开始
local function _onShuangJieHuoDongStart()
    FsendHuoDongGongGao("狂欢小镇地图已开启，欢迎大家前往！")
    local isOpen = ShuangJieHuoDongMain.isOpen()
    if isOpen then
        setsysvar(VarCfg["G_双节活动地图是否开启"], 1)
    end
end
--双节活动结束
local function _onShuangJieHuoDongEnd()
    local isOpen = ShuangJieHuoDongMain.isOpen()
    if isOpen then
        setsysvar(VarCfg["G_双节活动地图是否开启"], 0)
        FsendHuoDongGongGao("狂欢小镇地图已关闭！")
    end
    FMoveMapPlay("狂欢小镇", "n3", 330, 330, 3)
end

GameEvent.add(EventCfg.onShuangJieHuoDongStart, _onShuangJieHuoDongStart, ShuangJieHuoDongMain)
GameEvent.add(EventCfg.onShuangJieHuoDongEnd, _onShuangJieHuoDongEnd, ShuangJieHuoDongMain)

local _shuaGuai = {
    {
        mobName = "圣诞老人",
        x = 64,
        y = 82,
        range = 60,
        color = 250,
        num = 150
    },
    {
        mobName = "圣诞宝箱",
        x = 64,
        y = 82,
        range = 60,
        color = 250,
        num = 10
    }
}
--狂欢小镇刷怪
local function _onKuangHuanXiaoZhenShuaGuai()
    local isOpen = ShuangJieHuoDongMain.isOpen()
    if isOpen then
        FsendHuoDongGongGao("圣诞老人和圣诞宝箱出现在狂欢小镇！")
        for _, value in ipairs(_shuaGuai) do
            genmon("狂欢小镇", value.x, value.y, value.mobName, value.range, value.num, value.color)
        end
    end
end
GameEvent.add(EventCfg.onKuangHuanXiaoZhenShuaGuai, _onKuangHuanXiaoZhenShuaGuai, ShuangJieHuoDongMain)
local _caiJiItems = { "圣诞老人的靴子", "麋鹿金铃铛", "圣诞幸运星", "圣诞饼干", "圣诞老人徽章", "圣诞花环" }
local function _onCollectTask(actor, monName, monMakeIndex, itemName)
    if monName == "圣诞宝箱" then
        --随机给物品
        local itemName = _caiJiItems[math.random(1, #_caiJiItems)]
        Player.giveItemByTable(actor, { { itemName, 1 } }, "圣诞宝箱", 1, true)
        Player.sendmsgEx(actor, string.format("恭喜你获得|%s#249", itemName))
    end
end
GameEvent.add(EventCfg.onCollectTask, _onCollectTask, ShuangJieHuoDongMain)

--攻击人物变成雪人
local function _onAttackDamagePlayer(actor, Target, Hiter, MagicId, Damage, Model, attackDamageData)
    if getplaydef(actor, VarCfg["U_时装外观记录"]) == 40181 then
        if randomex(1, 150) then
            addbuff(Target, 31108, 30)
        end
    end
end
GameEvent.add(EventCfg.onAttackDamagePlayer, _onAttackDamagePlayer, ShuangJieHuoDongMain)

--注册网络消息
Message.RegisterNetMsg(ssrNetMsgCfg.ShuangJieHuoDongMain, ShuangJieHuoDongMain)
return ShuangJieHuoDongMain

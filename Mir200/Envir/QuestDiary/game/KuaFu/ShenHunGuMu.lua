local ShenHunGuMu = {}
ShenHunGuMu.ID = "神魂古墓"
local npcID = 153
local config = include("QuestDiary/cfgcsv/cfg_ShenHunGuMu.lua") --配置
local cost = { {} }
local give = { {} }
local mapID1 = "神魂古墓"
local mapID2 = "龙骸遗迹"
local monVar = {
    ["天·元神"] = VarCfg["U_神魂古墓杀怪1"],
    ["人·阳神"] = VarCfg["U_神魂古墓杀怪2"],
    ["地·阴神"] = VarCfg["U_神魂古墓杀怪3"],
}
local mons = {
    ["◆◆◆天帝魂主◆◆◆"] = true,
    ["◆◆◆人帝魂主◆◆◆"] = true,
    ["◆◆◆地帝魂主◆◆◆"] = true,
}
local bibao = {
    "神魂碎片",
    "神魂碎片",
    "神魂碎片",
    "神魂碎片",
    "神魂碎片",
    "混沌本源",
    "1元充值红包",
    "1元充值红包",
    "1元充值红包",
    "1元充值红包",
    "1元充值红包",
    "1元充值红包",
    "1元充值红包",
    "1元充值红包",
    "1元充值红包",
    "1元充值红包",
    "10000元宝",
    "10000元宝",
    "10000元宝",
    "10000元宝",
    "10000元宝",
    "10000元宝",
    "10000元宝",
    "10000元宝",
    "10000元宝",
}

local suiji = {
    "天下霸唱",
    "寂梦",
    "离人愁",
    "千年结",
    "幽冥之环",
    "亡灵庇护",
    "冥河之邀",
    "无言恐惧",
    "暗影之缚",
    "旧人归",
    "黄泉之风",
    "闪耀·漆黑之影",
    "夜魔之绕",
    "夜幽面具★★★",
    "归墟万物",
    "无名手环",
    "赤木之瞳",
    "阴煞血幡",
    "死亡之环",
    "天火之靴",
    "勾魂夺魄",
    "悲鸣之焰",
    "旅者之誓",
    "流光岁月",
    "罗盘玫瑰",
    "断头台",
    "寒霜之握",
    "夜幽之玉",
    "明昼吊坠",
    "龙魂之力",
    "天空的引路人",
    "神谕之盔",
    "撕裂者面具",
    "本源之力",
    "元素种子",
    "矮人头盔",
    "血色之眼",
    "时光的沙漏",
    "被封印的剑灵",
    "苦修者的秘籍",
    "暗黑之神宝藏",
    "大天使的神威",
    "轮回经",
    "掌控奥义",
}

--开始刷怪
function shen_hun_gu_mu_shua_guai()
    FsendHuoDongGongGao("神魂古墓地图内怪物已刷新!")
    killmonsters(mapID1, "*", 0, false)
    killmonsters(mapID2, "*", 0, false)
    for _, value in ipairs(config) do
        genmon(value.mapID, value.x, value.y, value.value, value.range, value.num, value.color)
    end
end

--活动结束了
function shen_hun_gu_mu_end()
    FsendHuoDongGongGao("神魂古墓地图已关闭!")
    FMoveMapPlay(mapID1, "kuafu2", 132, 164, 3)
    FMoveMapPlay(mapID2, "kuafu2", 132, 164, 3)
end

--接收请求
function ShenHunGuMu.Request(actor)
    local isKangBao = getflagstatus(actor, VarCfg.F_is_open_kuangbao) --是否开启狂暴之力
    if isKangBao == 0 then
        Player.sendmsgEx(actor, "进入地图失败，你没有开启狂暴之力！#249")
        return
    end
    local power = Player.GetPower(actor)
    if power < 50000000 then
        Player.sendmsgEx(actor, "进入地图失败，你的战力不足5000W！#249")
        return
    end
    local isTime1 = isTimeInRange(10, 15, 11, 16)
    local isTime2 = isTimeInRange(22, 15, 23, 16)
    if not isTime1 and not isTime2 then
        Player.sendmsgEx(actor, "不在开放时间,禁止进入！#249")
        return
    end
    local name = getbaseinfo(actor, ConstCfg.gbase.name)
    sendmsg("0", 2, '{"Msg":"[' .. name .. ']进入神魂古墓","FColor":251,"BColor":0,"Type":6,"Time":6,"SendName":"系统：","SendId":"123","X":"-300"}')
    map(actor, "神魂古墓")
end

local function _getBossCount()
    local idx1 = tonumber(getdbmonfieldvalue("◆◆◆天帝魂主◆◆◆", "idx")) or 0
    local idx2 = tonumber(getdbmonfieldvalue("◆◆◆人帝魂主◆◆◆", "idx")) or 0
    local idx3 = tonumber(getdbmonfieldvalue("◆◆◆地帝魂主◆◆◆", "idx")) or 0
    local data = {}
    data[1] = getmoncount(mapID1,idx1,true)
    data[2] = getmoncount(mapID1,idx2,true)
    data[3] = getmoncount(mapID1,idx3,true)
    return data
end
local function _isBossAllDie()
    local data = _getBossCount()
    for index, value in ipairs(data) do
        if value == 1 then
            return false
        end
    end
    return true
end
local function _onKillMon(actor, monobj, monName)
    if mons[monName] then
        local x = Player.GetX(monobj)
        local y = Player.GetY(monobj)
        -- mapID1
        for _, value in ipairs(bibao) do
            throwitem(actor, mapID1, x, y, 10, value, 1, 60, true, false, false, false, 1, false)
        end
        local value = suiji[math.random(1, #suiji)]
        throwitem(actor, mapID1, x, y, 10, value, 1, 60, true, false, false, false, 1, false)
        local bool = _isBossAllDie()
        if bool then
            FsendHuoDongGongGao("神魂古墓BOSS已全部被击杀,龙骸遗迹地图开启!")
        end
    end
    local var = monVar[monName]
    if var then
        local num = getplaydef(actor, var)
        setplaydef(actor, var, num + 1)
    end
end
GameEvent.add(EventCfg.onKillMon, _onKillMon, ShenHunGuMu)

--同步消息
-- function ShenHunGuMu.SyncResponse(actor, logindatas)
--     local data = {}
--     local _login_data = {ssrNetMsgCfg.ShenHunGuMu_SyncResponse, 0, 0, 0, data}
--     if logindatas then
--         table.insert(logindatas, _login_data)
--     else
--         Message.sendmsg(actor, ssrNetMsgCfg.ShenHunGuMu_SyncResponse, 0, 0, 0, data)
--     end
-- end
-- --登录触发
-- local function _onLoginEnd(actor, logindatas)
--     ShenHunGuMu.SyncResponse(actor, logindatas)
-- end
-- --事件派发
-- GameEvent.add(EventCfg.onLoginEnd, _onLoginEnd, ShenHunGuMu)
--注册网络消息
Message.RegisterNetMsg(ssrNetMsgCfg.ShenHunGuMu, ShenHunGuMu)
return ShenHunGuMu

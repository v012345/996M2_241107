local YingLingJiTan = {}
YingLingJiTan.ID = "英灵祭坛"
local npcID = 234
local config = include("QuestDiary/cfgcsv/cfg_YingLingJiTan.lua") --配置
local function delAllTitle(actor)
    for _, value in ipairs(config) do
        deprivetitle(actor, value.title)
    end
end
--接收请求
function YingLingJiTan.Request1(actor)
    local currIndex = getplaydef(actor, VarCfg["U_剧情_英灵祭坛_称号"])
    local index = currIndex + 1
    local cfg = config[index]
    if not cfg then
        Player.sendmsgEx(actor, "[提示]:#251|你的英灵殿称号已经满级了#249")
        return
    end
    local name, num = Player.checkItemNumByTable(actor, cfg.cost)
    if name then
        Player.sendmsgEx(actor, string.format("[提示]:#251|你的|%s#249|不足|%d#249", name, num))
        return
    end
    Player.takeItemByTable(actor, cfg.cost, "江湖称号升级")
    delAllTitle(actor) --全部删除一次防止删不掉
    confertitle(actor, cfg.title, 1)
    Player.sendmsgEx(actor, string.format("[提示]:#251|恭喜你获得称号|%s#249", cfg.title))
    setplaydef(actor, VarCfg["U_剧情_英灵祭坛_称号"], index)
    if index == 1 then
        local taskPanelID = getplaydef(actor, VarCfg["U_主线任务面板进度"])
        if taskPanelID == 15 then
            FCheckTaskRedPoint(actor)
        end
    end
    Player.setAttList(actor, "爆率附加")
    Player.setAttList(actor, "攻速附加")
    Player.setAttList(actor, "倍攻附加")
    --同步一次消息
    YingLingJiTan.SyncResponse(actor)
end

function YingLingJiTan.Request2(actor)
    local currIndex = getplaydef(actor, VarCfg["U_剧情_英灵祭坛_称号"])
    local index = currIndex + 1
    local cfg = config[index]
    if not cfg then
        Player.sendmsgEx(actor, "[提示]:#251|你的英灵殿称号已经满级了#249")
        return
    end
    local totalRecharge = getplaydef(actor, VarCfg["U_真实充值"])
    if totalRecharge < cfg.totalRecharge then
        Player.sendmsgEx(actor, string.format("[提示]:#251|你的|%s#249|不足|%d#249", "累计充值", cfg.totalRecharge))
        return
    end
    delAllTitle(actor) --全部删除一次防止删不掉
    setflagstatus(actor, cfg.tuihuan, 1)
    confertitle(actor, cfg.title, 1)
    Player.sendmsgEx(actor, string.format("[提示]:#251|恭喜你获得称号|%s#249", cfg.title))
    setplaydef(actor, VarCfg["U_剧情_英灵祭坛_称号"], index)
    Player.setAttList(actor, "爆率附加")
    Player.setAttList(actor, "攻速附加")
    Player.setAttList(actor, "倍攻附加")
    --同步一次消息
    YingLingJiTan.SyncResponse(actor)
end

--同步消息
function YingLingJiTan.SyncResponse(actor, logindatas)
    local count = getplaydef(actor, VarCfg["U_剧情_英灵祭坛_称号"])
    local totalRecharge = getplaydef(actor, VarCfg["U_真实充值"])
    local data = {}
    local _login_data = { ssrNetMsgCfg.YingLingJiTan_SyncResponse, count, totalRecharge, 0, data }
    if logindatas then
        table.insert(logindatas, _login_data)
    else
        Message.sendmsg(actor, ssrNetMsgCfg.YingLingJiTan_SyncResponse, count, totalRecharge, 0, data)
    end
end

--登录触发
local function _onLoginEnd(actor, logindatas)
    YingLingJiTan.SyncResponse(actor, logindatas)
end
--事件派发
GameEvent.add(EventCfg.onLoginEnd, _onLoginEnd, YingLingJiTan)
--注册网络消息

local function _onCalcAttackSpeed(actor, attackSpeeds)
    local count = getplaydef(actor, VarCfg["U_剧情_英灵祭坛_称号"])
    local cfg = config[count]
    if not cfg then
        return
    end

    local gongSu = cfg.gongsu
    attackSpeeds[1] = attackSpeeds[1] + gongSu
end
--攻速属性
GameEvent.add(EventCfg.onCalcAttackSpeed, _onCalcAttackSpeed, YingLingJiTan)

--倍攻触发
local function _onCalcBeiGong(actor, beiGongs)
    local count = getplaydef(actor, VarCfg["U_剧情_英灵祭坛_称号"])
    local cfg = config[count]
    if not cfg then
        return
    end
    local beigong = cfg.beigong
    beiGongs[1] = beiGongs[1] + beigong
end
GameEvent.add(EventCfg.onCalcBeiGong, _onCalcBeiGong, YingLingJiTan)

--攻击人触发
local function _onAttackPlayer(actor, Target, Hiter, MagicId)
    local count = getplaydef(actor, VarCfg["U_剧情_英灵祭坛_称号"])
    local cfg = config[count]
    if not cfg then
        return
    end
    if cfg.zhansha then
        local count = getplaydef(actor, VarCfg["N$英灵殿称号刀数计算"])
        setplaydef(actor, VarCfg["N$英灵殿称号刀数计算"], count + 1)
        if count >= 12 then
            setplaydef(actor, VarCfg["N$英灵殿称号刀数计算"], 0)
            local calcHp = Player.getHpValue(Target, cfg.zhansha)
            humanhp(Target, "-", calcHp, 1, 0, actor)
            local myName = getbaseinfo(actor, ConstCfg.gbase.name)
            local targetName = getbaseinfo(Target, ConstCfg.gbase.name)
            Player.buffTipsMsg(actor, "[英灵殿]:你斩杀了玩家[{" .. targetName .. "/FCOLOR=243}]{" .. cfg.zhansha .. "%/FCOLOR=243}的血量")
            Player.buffTipsMsg(Target, "[英灵殿]:你被玩家[{" .. myName .. "/FCOLOR=243}]斩杀了{" .. cfg.zhansha .. "%/FCOLOR=243}的血量")
        end
    end
end
GameEvent.add(EventCfg.onAttackPlayer, _onAttackPlayer, YingLingJiTan)

Message.RegisterNetMsg(ssrNetMsgCfg.YingLingJiTan, YingLingJiTan)
return YingLingJiTan
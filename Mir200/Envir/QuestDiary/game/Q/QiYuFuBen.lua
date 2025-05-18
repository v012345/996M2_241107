local QiYuFuBen = {}
local config = include("QuestDiary/cfgcsv/cfg_LuckyEvent_BoxData.lua")
local FuBenName = { "时之裂隙-古冥", "时之裂隙-幻境", "时之裂隙-烈焰", "时之裂隙-幽冥", "时之裂隙-恶狱", "时之裂隙-天穹", "时之裂隙-破晓", "时之裂隙-新月" }
local qyBanMaps = {
    ["月夜密室"] = true
}
function QiYuFuBen.Request(actor, arg1, arg2, arg3, arg4)
    local NowMapID = getbaseinfo(actor, ConstCfg.gbase.mapid)
    if qyBanMaps[NowMapID] then
        Player.sendmsgEx(actor, "提示#251|:#255|当前地图禁止进入奇遇副本!#249")
        return
    end
    local EventName = getplaydef(actor, VarCfg["S$奇遇副本"])
    ------------------验证奇遇------------------
    local NotInTheFuBen = true
    for _, v in ipairs(FuBenName) do
        if v == EventName then
            NotInTheFuBen = false
            break
        end
    end
    if NotInTheFuBen then return end
    ------------------验证奇遇------------------
    local cfg = {}
    for _, V in ipairs(config) do
        if V.EnevtName == EventName then
            cfg = V
            break
        end
    end

    local NowX, NowY = getbaseinfo(actor, ConstCfg.gbase.x), getbaseinfo(actor, ConstCfg.gbase.y)

    local HuiChenginfo = { ["NowMapID"] = NowMapID, ["NowX"] = NowX, ["NowY"] = NowY }
    Player.setJsonVarByTable(actor, VarCfg["T_进入副本记录退出信息"], HuiChenginfo)

    local UserName = getconst(actor, "<$USERID>")
    local FormerMapId = cfg.MapID                    --获取原始地图ID
    local NewMapId = FormerMapId .. UserName         --根据原始地图id  配置新地图ID

    local NameTbl = string.split(cfg.EnevtName, "-") --获取副本名称  NameTbl[2] --名字
    local NewMapName = NameTbl[2] .. "[副本]"
    local MonTbl = cfg.Mob_MonName
    if checkmirrormap(NewMapId) then
        killmonsters(NewMapId, "*", 0, false) --杀死当前地图所有怪物
        delmirrormap(NewMapId)                --删除镜像地图
        addmirrormap(FormerMapId, NewMapId, NewMapName, 1800, NowMapID, nil, NowX, NowY)
    else
        addmirrormap(FormerMapId, NewMapId, NewMapName, 1800, NowMapID, nil, NowX, NowY)
    end
    map(actor, NewMapId)

    --进入奇遇副本 关闭巡航挂机
    XunHangGuaJi.CloseGuaJi(actor)
    --镜像地图刷怪
    for i = 1, #MonTbl do
        genmon(NewMapId, 0, 0, MonTbl[i], 50, cfg.Mob_MonNum, 249)
    end
    setplaydef(actor, VarCfg["S$奇遇副本"], "")

    GameEvent.push(EventCfg.onEntetMirrorMap, actor)
end

GameEvent.add(EventCfg.onKillMon, _onKillMon, QiYuFuBen)

function QiYuFuBen.CloseUI(actor, arg1, arg2, arg3, _QDevent)
    ----------------验证奇遇----------------
    local verify = getplaydef(actor, VarCfg["S$奇遇副本"])
    if verify ~= _QDevent[1] then
        Player.sendmsgEx(actor, "提示#251|:#255|非法请求#249|")
        return
    end
    ----------------验证奇遇----------------
    QiYuHeZi.ClientAddEvent(actor, verify)
    setplaydef(actor, VarCfg["S$奇遇副本"], "")
end

--触发事件后 初始变量
local function _LuckyEventinitVar(actor, LuckyEventName)
    local IsFuBen = false
    for _, v in ipairs(FuBenName) do
        if v == LuckyEventName then
            IsFuBen = true
            break
        end
    end
    if IsFuBen then
        setplaydef(actor, VarCfg["S$奇遇副本"], LuckyEventName)
    end
end
GameEvent.add(EventCfg.LuckyEventinitVar, _LuckyEventinitVar, QiYuFuBen)

--注册网络消息
Message.RegisterNetMsg(ssrNetMsgCfg.QiYuFuBen, QiYuFuBen)
return QiYuFuBen

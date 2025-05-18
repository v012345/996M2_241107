local WangHunTa = {}
local config = include("QuestDiary/cfgcsv/cfg_FengDuChengMon.lua")     --配置
-- -- local config = include("QuestDiary/cfgcsv/cfg_WangHunTa.lua")     --配置
WangHunTa.ID = "亡魂塔"
function WangHunTa.Request(actor)
   if getflagstatus(actor,VarCfg.F_is_open_kuangbao) == 0 then
    Player.sendmsgEx(actor, "提示#251|:#255|你还未开启|狂暴之力#249|无法进入...")
    return
   end

   if not takeitem(actor, "阴阳魂石", 1, 0) then
    Player.sendmsgEx(actor, "提示#251|:#255|对不起,你的|阴阳魂石#249|不足|1枚#249|无法进入...")
    return
   end
   mapmove(actor, "亡魂塔", 100, 100, 100)
end

--注册网络消息
Message.RegisterNetMsg(ssrNetMsgCfg.WangHunTa, WangHunTa)

function WangHunTa.openUI(actor)
    local monnum = checkrangemoncount("亡魂塔", "*", 100, 100, 100)
    local data = {monnum}
    Message.sendmsg(actor, ssrNetMsgCfg.WangHunTa_openUI, 0, 0, 0, data)
end

--同步数据
function WangHunTa.SyncResponse(actor, num)
    local data
    Message.sendmsg(actor, ssrNetMsgCfg.WangHunTa_SyncResponse, 0, 0, 0, data)
end

--任意地图击杀怪物触发
function _onKillMon(actor, monobj, monName)
    local monname = monName
    if config[monname] then
        local monnum = checkrangemoncount("亡魂塔", "*", 100, 100, 100)
        if monnum < 100 then
            if randomex(5, 100) then
                genmon("亡魂塔", 100, 100, monname, 100, 1, 255)
                sendmsgnew(actor, 250,0, "<系统提示/FCOLOR=251>【<".. monname .."/FCOLOR=249>】的灵魂已在亡魂塔内重生...", 1, 1)
            end
        end
    end
end
GameEvent.add(EventCfg.onKillMon, _onKillMon, WangHunTa)

--切换地图触发
local function _goSwitchMap(actor, cur_mapid, former_mapid)
    if cur_mapid == "亡魂塔" then
        setplaydef(actor, VarCfg["M_亡魂塔爆率"], 1)
        Player.setAttList(actor, "爆率附加")
    elseif former_mapid == "亡魂塔" then
        setplaydef(actor, VarCfg["M_亡魂塔爆率"], 0)
        Player.setAttList(actor, "爆率附加")
    end
end
GameEvent.add(EventCfg.goSwitchMap, _goSwitchMap, WangHunTa)

local function _onCalcBaoLv(actor, attrs)
    if getplaydef(actor, VarCfg["M_亡魂塔爆率"]) == 1 then
        local shuxing = {
            [204] = 100
        }
        calcAtts(attrs, shuxing, "爆率附加:禁亡魂塔进入地图")
    end
end
GameEvent.add(EventCfg.onCalcBaoLv, _onCalcBaoLv, WangHunTa)


return WangHunTa

local QianXianXianFeng = {}
QianXianXianFeng.ID = "遗忘前线"
local mapID = "遗忘前线"
local npcID = 329
--local config = include("QuestDiary/cfgcsv/cfg_QianXianXianFeng.lua") --配置
local cost = {{}}
local give = {{}}
--接收请求
function QianXianXianFeng.Request(actor)
    if not FCheckNPCRange(actor, npcID, 15) then
        Player.sendmsgEx(actor, "距离PNC太远!#249")
        return
    end
    if getflagstatus(actor,VarCfg["F_剧情_遗忘前线_是否提交"]) == 1 then
        Player.sendmsgEx(actor, "你已经领取过奖励了!#249")
        return
    end
    local num = getplaydef(actor, VarCfg["U_剧情_遗忘前线_杀怪数量"])
    if num < 1000 then
        Player.sendmsgEx(actor, "杀怪数量不足1000!#249")
        return
    end
    setflagstatus(actor,VarCfg["F_剧情_遗忘前线_是否提交"],1)
    QianXianXianFeng.SyncResponse(actor)
    Player.setAttList(actor, "属性附加")
end
--同步消息
function QianXianXianFeng.SyncResponse(actor)
    local data = {}
    local num = getplaydef(actor, VarCfg["U_剧情_遗忘前线_杀怪数量"])
    Message.sendmsg(actor, ssrNetMsgCfg.QianXianXianFeng_SyncResponse, num, getflagstatus(actor,VarCfg["F_剧情_遗忘前线_是否提交"]), 0, data)
end
-- --登录触发
-- local function _onLoginEnd(actor, logindatas)
--     QianXianXianFeng.SyncResponse(actor, logindatas)
-- end
-- --事件派发
-- GameEvent.add(EventCfg.onLoginEnd, _onLoginEnd, QianXianXianFeng)
-- VarCfg["U_剧情_遗忘前线_杀怪数量"]

--附加属性
local function _onCalcAttr(actor, attrs)
    local shuxing = {}
    if getflagstatus(actor,VarCfg["F_剧情_遗忘前线_是否提交"]) == 1 then
        shuxing[200] = 1000
        calcAtts(attrs, shuxing, "先锋前线切割")
    end
end
--属性
GameEvent.add(EventCfg.onCalcAttr, _onCalcAttr, QianXianXianFeng)

--杀怪触发
local function _onKillMon(actor, monobj)
    local num = getplaydef(actor, VarCfg["U_剧情_遗忘前线_杀怪数量"])
    if num >= 1000 then
        return
    end
    local myMapID = getbaseinfo(actor, ConstCfg.gbase.mapid)
    if mapID == myMapID then
        setplaydef(actor,VarCfg["U_剧情_遗忘前线_杀怪数量"], num + 1)
    end
end
GameEvent.add(EventCfg.onKillMon, _onKillMon, QianXianXianFeng)
--注册网络消息
Message.RegisterNetMsg(ssrNetMsgCfg.QianXianXianFeng, QianXianXianFeng)
return QianXianXianFeng
local TanYuBuZhi = {}
TanYuBuZhi.ID = "贪欲不止"
local npcID = 505
local config = include("QuestDiary/cfgcsv/cfg_TanYuBuZhi.lua") --配置
local cost = {{}}
local give = {{}}
local equipName = "毁灭·魔化天使[吞噬]"
--接收请求
function TanYuBuZhi.Request(actor,index)
    if not FCheckNPCRange(actor, npcID, 15) then
        Player.sendmsgEx(actor, "距离PNC太远!#249")
        return
    end
    local cfg = config[index]
    if not cfg then
        Player.sendmsgEx(actor, "参数错误!#249")
        return
    end

    local obj = linkbodyitem(actor,16)
    local name = getiteminfo(actor,obj,ConstCfg.iteminfo.name)
    if equipName ~= name then
        Player.sendmsgEx(actor, "提交失败,你没有穿戴"..equipName.."!#249")
        return
    end
    if getflagstatus(actor, cfg.flag) == 1 then
        Player.sendmsgEx(actor, "你已提交过了!#249")
        return
    end
    local cost = cfg.cost
    local name, num = Player.checkItemNumByTable(actor, cost)
    if name then
        Player.sendmsgEx(actor, string.format("你的|%s#249|不足|%d#249", name, num))
        return
    end
    Player.takeItemByTable(actor, cost, "魔焰炼狱")
    setflagstatus(actor, cfg.flag, 1)
    Player.sendmsgEx(actor,"解封成功!")
    TanYuBuZhi.SyncResponse(actor)
end
--同步消息
function TanYuBuZhi.SyncResponse(actor, logindatas)
    local data = {}
    local _login_data = {ssrNetMsgCfg.TanYuBuZhi_SyncResponse, 0, 0, 0, data}
    if logindatas then
        table.insert(logindatas, _login_data)
    else
        Message.sendmsg(actor, ssrNetMsgCfg.TanYuBuZhi_SyncResponse, 0, 0, 0, data)
    end
end
--登录触发
local function _onLoginEnd(actor, logindatas)
    TanYuBuZhi.SyncResponse(actor, logindatas)
end
--事件派发
GameEvent.add(EventCfg.onLoginEnd, _onLoginEnd, TanYuBuZhi)
--注册网络消息
Message.RegisterNetMsg(ssrNetMsgCfg.TanYuBuZhi, TanYuBuZhi)
return TanYuBuZhi
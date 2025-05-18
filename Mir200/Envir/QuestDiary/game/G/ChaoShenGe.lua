local ChaoShenGe = {}
ChaoShenGe.ID = "超神阁"
local npcID = 152
local config = include("QuestDiary/cfgcsv/cfg_ChaoShenGe.lua") --配置
--接收请求
function ChaoShenGe.Request(actor, index)
    if not index then
        Player.sendmsgEx(actor, "参数错误1!")
        return
    end
    if "number" ~= type(index) then
        Player.sendmsgEx(actor, "参数错误2!")
        return
    end
    local cfg = config[index]
    if not cfg then
        Player.sendmsgEx(actor, "参数错误3!")
        return
    end
    local cost = cfg.equip
    local name, num = Player.checkItemNumByTable(actor, cost)
    if name then
        Player.sendmsgEx(actor, string.format("回收失败,你的背包内没有|%s#249", name))
        return
    end
    Player.takeItemByTable(actor, cost, "超神阁回收")
    local give = {}
    local lingFuName = "绑定灵符"
    if getflagstatus(actor, VarCfg["F_解绑状态"]) == 1 then
        lingFuName = "灵符"
    end
    give = { { lingFuName, cfg.lingfu } }
    local uid = Player.GetUUID(actor)
    local mailTitle = "超神器回收"
    local mailContent = string.format("你从%s回收了%s,获得%s:%s", ChaoShenGe.ID, cost[1][1], lingFuName, cfg.lingfu)
    Player.giveMailByTable(uid, 20, mailTitle, mailContent, give)
    Player.sendmsgEx(actor, "恭喜你回收成功,奖励已发送至邮箱,请查收!")
    ChaoShenGe.SyncResponse(actor)
end

--同步消息
function ChaoShenGe.SyncResponse(actor, logindatas)
    local data = {}
    Message.sendmsg(actor, ssrNetMsgCfg.ChaoShenGe_SyncResponse, 0, 0, 0, data)
end
-- --登录触发
-- local function _onLoginEnd(actor, logindatas)
--     ChaoShenGe.SyncResponse(actor, logindatas)
-- end
-- --事件派发
-- GameEvent.add(EventCfg.onLoginEnd, _onLoginEnd, ChaoShenGe)
--注册网络消息
Message.RegisterNetMsg(ssrNetMsgCfg.ChaoShenGe, ChaoShenGe)
return ChaoShenGe

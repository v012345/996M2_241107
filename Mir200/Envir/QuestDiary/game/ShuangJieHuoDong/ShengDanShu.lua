local ShengDanShu = {}
ShengDanShu.ID = "圣诞树"
local npcID = 159
local config = include("QuestDiary/cfgcsv/cfg_ShengDanShu.lua") --配置
local give = {{}}
--接收请求
function ShengDanShu.Request(actor,index)
    local cfg = config[index]
    if not cfg then
        Player.sendmsgEx(actor, "参数错误#249")
        return
    end
    local cost = cfg.cost
    local name, num = Player.checkItemNumByTable(actor, cost)
    if name then
        Player.sendmsgEx(actor, string.format("你的|%s#249|不足|%d#249", name, num))
        return
    end
    Player.takeItemByTable(actor, cost, "圣诞树")
    --发送奖励到邮件
    local reward = cfg.give
    local uid = Player.GetUUID(actor)
    local mailTitle = "圣诞树礼物"
    local mailContent = "请领取你的圣诞树礼物"
    Player.giveMailByTable(uid, 1, mailTitle, mailContent, reward,1,true)
    Player.sendmsgEx(actor, "奖励已发送至邮箱，请查收！")
    ShengDanShu.SyncResponse(actor)
end
--同步消息
function ShengDanShu.SyncResponse(actor)
    local data = {}
    Message.sendmsg(actor, ssrNetMsgCfg.ShengDanShu_SyncResponse, 0, 0, 0, data)
end
-- --登录触发
-- local function _onLoginEnd(actor, logindatas)
--     ShengDanShu.SyncResponse(actor, logindatas)
-- end
-- --事件派发
-- GameEvent.add(EventCfg.onLoginEnd, _onLoginEnd, ShengDanShu)
--注册网络消息
Message.RegisterNetMsg(ssrNetMsgCfg.ShengDanShu, ShengDanShu)
return ShengDanShu
local ShiKongChuanSuo = {}
local cost = { { "斗转星移[精]+10", 1 }, { "哈法西斯之心", 5 }, { "穿梭时空的秘密", 1 }, { "金币", 100000000 }, { "元宝", 5880000 }, { "灵石", 288 } }

function ShiKongChuanSuo.Request(actor)
    local name, num = Player.checkItemNumByTable(actor, cost)
    if name then
        Player.sendmsgEx(actor, string.format("提示#251|:#255|你的|%s#249|不足|%d#249|...", name, num))
        return
    end
    Player.takeItemByTable(actor, cost, "时空穿梭")
    giveitem(actor, "「穿梭」时间轮转", 1, 0)
    Player.sendmsgEx(actor, "提示#251|:#255|恭喜你合成|「穿梭」时间轮转#249|成功...")
    ShiKongChuanSuo.SyncResponse(actor)
end

-- 同步一次消息
function ShiKongChuanSuo.SyncResponse(actor)
    Message.sendmsg(actor, ssrNetMsgCfg.ShiKongChuanSuo_SyncResponse, 0, 0, 0, nil)
end

Message.RegisterNetMsg(ssrNetMsgCfg.ShiKongChuanSuo, ShiKongChuanSuo)

return ShiKongChuanSuo

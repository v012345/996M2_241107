local YeMuJiangLing = {}
YeMuJiangLing.ID = "夜幕将领"
-- 夜风深渊	142	96
local cost = {{"幕轮", 1},{"影幕之指", 1},{"造化结晶", 188}}

--接收请求
function YeMuJiangLing.Request(actor)
    local name, num = Player.checkItemNumByTable(actor, cost)
    if name then
        Player.sendmsgEx(actor, string.format("你的|%s#249|数量不足|%d#249|打造失败...", name, num))
        return
    end
    Player.takeItemByTable(actor, cost, "黑刀·夜扣除")
    giveitem(actor, "黑刀·夜", 1, ConstCfg.binding, "黑刀·夜")
    Message.sendmsg(actor, ssrNetMsgCfg.YeMuJiangLing_SyncResponse, 0, 0, 0, nil)
end

--注册网络消息
Message.RegisterNetMsg(ssrNetMsgCfg.YeMuJiangLing, YeMuJiangLing)
return YeMuJiangLing
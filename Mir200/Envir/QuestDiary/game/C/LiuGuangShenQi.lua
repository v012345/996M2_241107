local LiuGuangShenQi = {}
LiuGuangShenQi.cost = {
    {{ "流光淬火剣[戮兽]", 1 }, { "流光淬火剣[饮血]", 1 }, { "流光淬火剣[天殇]", 1 }, { "灵石", 18 }},
    {{ "流光淬火衣[男]", 1 }, { "流光锦绣衣[男]", 1 }, { "流光幻彩衣[男]", 1 }, { "灵石", 18 }}
}
LiuGuangShenQi.give = { "流光剣[综合之力]", "流光·庇护[男]" }
function LiuGuangShenQi.Request(actor, index)
    local cost = LiuGuangShenQi.cost[index]
    if not cost then
        return
    end
    local give = LiuGuangShenQi.give[index]
    if not give then
        return
    end

    local name, num = Player.checkItemNumByTable(actor, cost)
    if name then
        Player.sendmsgEx(actor, string.format("[提示]:#251|打造失败,你的|%s#249|数量不足|%d#249", name, num))
        return
    end
    Player.takeItemByTable(actor, cost, "剑甲打造")
    giveitem(actor, give, 1, 0, "剑甲打造")
    Player.sendmsgEx(actor, string.format("[提示]:#251|恭喜打造成功,获得|[%s]#249|,快去试试吧", give))
    Message.sendmsg(actor,ssrNetMsgCfg.LiuGuangShenQi_SyncResponse)
end

-----注册网络消息
Message.RegisterNetMsg(ssrNetMsgCfg.LiuGuangShenQi, LiuGuangShenQi)

return LiuGuangShenQi

local ShouYeRen = {}
ShouYeRen.cost = {{"老村长的怀表",1},{"天工之锤",1888},{"焚天石",1888}}
ShouYeRen.give = {{"守夜人之徽",1}}
function ShouYeRen.Request(actor)
    local name,num = Player.checkItemNumByTable(actor,ShouYeRen.cost)
    if name then
        Player.sendmsgEx(actor, string.format("[提示]:#251|你的背包没有|%s*%d#249", name, num))
        return
    end
    Player.takeItemByTable(actor,ShouYeRen.cost,"守夜人任务")
    Player.giveItemByTable(actor,ShouYeRen.give)
    FSetTaskRedPoint(actor, VarCfg["F_守夜人完成"], 14)
    Player.sendmsgEx(actor, string.format("[提示]:#251|恭喜你获得#250|%s#249", ShouYeRen.give[1][1]))
    Message.sendmsg(actor,ssrNetMsgCfg.ShouYeRen_SyncResponse)
end

-----注册网络消息
Message.RegisterNetMsg(ssrNetMsgCfg.ShouYeRen, ShouYeRen)

return ShouYeRen

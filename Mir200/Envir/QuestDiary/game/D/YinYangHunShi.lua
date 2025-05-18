local YinYangHunShi = {}
local cost = { { "阴", 1 }, { "幽冥残魂", 10 }, { "阳", 1 }, { "灵符", 200 } }
local showItme = { { "阴阳魂石", 1 } }
function YinYangHunShi.Request(actor)
    local name, num = Player.checkItemNumByTable(actor, cost)
    if name then
        Player.sendmsgEx(actor, string.format("[提示]:#251|你的|%s#249|数量不足|%d#249", name, num))
        return
    end
    Player.takeItemByTable(actor, cost, "阴阳魂石合成")
    Player.giveItemByTable(actor, showItme, "阴阳魂石合成")
    Player.sendmsgEx(actor, string.format("恭喜你成功合成|%s#249", "阴阳魂石"))
end

Message.RegisterNetMsg(ssrNetMsgCfg.YinYangHunShi, YinYangHunShi)
return YinYangHunShi

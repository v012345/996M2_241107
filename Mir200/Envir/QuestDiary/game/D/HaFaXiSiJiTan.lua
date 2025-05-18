local HaFaXiSiJiTan = {}
local cost = {{"骑士之心",4}}
local mirrorMapId2 = "哈法西斯之墓(二层)"
local monName1 = "哈法西斯之魂"
function HaFaXiSiJiTan.Request(actor)
    local myName = getbaseinfo(actor,ConstCfg.gbase.name)
    if not FCheckMap(actor, myName..mirrorMapId2) then
        -- Player.sendmsg(actor,"fuck you.")
        return
    end
    local name,num = Player.checkItemNumByTable(actor,cost)
    if name then
        Player.sendmsgEx(actor,string.format("[提示]:#251|你的|%s#249|不足|%d#249|,无法召唤!",name,num))
        return
    end
    setofftimer(actor, 173)
    Player.takeItemByTable(actor,cost,"哈法西斯之墓")
    local mapId = getbaseinfo(actor, ConstCfg.gbase.mapid)
    genmon(mapId, 49, 49, monName1, 0, 1, 249)
    sendcentermsg(actor, 250, 0, "[系统提示]：已经唤醒古老的哈法西斯之魂！击杀后可召唤出：暴君哈法西斯·恐惧之主！", 0, 5)
    sendcentermsg(actor, 250, 0, "[系统提示]：已经唤醒古老的哈法西斯之魂！击杀后可召唤出：暴君哈法西斯·恐惧之主！", 0, 5)
    sendcentermsg(actor, 250, 0, "[系统提示]：已经唤醒古老的哈法西斯之魂！击杀后可召唤出：暴君哈法西斯·恐惧之主！", 0, 5)
end
Message.RegisterNetMsg(ssrNetMsgCfg.HaFaXiSiJiTan, HaFaXiSiJiTan)
return HaFaXiSiJiTan

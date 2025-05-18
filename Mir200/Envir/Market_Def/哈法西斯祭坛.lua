local function FCheckMap(actor, mapId)
    local currMapId = getbaseinfo(actor, 3)
    return mapId == currMapId
end

function submit_hfxs_zhao_huan(actor)
    local mirrorMapId2 = "哈法西斯之墓(二层)"
    local monName1 = "哈法西斯之魂"
    local myName = getbaseinfo(actor, 1)
    if not FCheckMap(actor, myName .. mirrorMapId2) then
        -- Player.sendmsg(actor,"fuck you.")
        return
    end
    local itemCount = getbagitemcount(actor, "骑士之心")
    if itemCount < 4 then
        sendmsg(actor, 1,
            '{"Msg":"' ..
            string.format(
            "<font color=\'#FFFF00\'>[提示]:</font><font color=\'#00FF00\'>你的</font><font color=\'#FF0000\'>%s</font><font color=\'#00FF00\'>不足</font><font color=\'#FF0000\'>%d</font><font color=\'#00FF00\'>,无法召唤!</font>",
                "骑士之心", 4) .. '","Type":9}')
        return
    end
    takeitem(actor, "骑士之心", 4, 0, "哈法西斯召唤扣除")
    setofftimer(actor, 173)
    local mapId = getbaseinfo(actor, 3)
    genmon(mapId, 49, 49, monName1, 0, 1, 249)
    sendcentermsg(actor, 250, 0, "[系统提示]：已经唤醒古老的哈法西斯之魂！击杀后可召唤出：暴君哈法西斯·恐惧之主！", 0, 5)
    sendcentermsg(actor, 250, 0, "[系统提示]：已经唤醒古老的哈法西斯之魂！击杀后可召唤出：暴君哈法西斯·恐惧之主！", 0, 5)
    sendcentermsg(actor, 250, 0, "[系统提示]：已经唤醒古老的哈法西斯之魂！击杀后可召唤出：暴君哈法西斯·恐惧之主！", 0, 5)
    close(actor)
end

function main(actor)
    local color = "249"
    local itemCount = getbagitemcount(actor, "骑士之心")
    if itemCount >= 4 then
        color = "250"
    end
    local txtTag = [[
        <Img|loadDelay=1|reset=1|bg=1|img=custom/HaFaXiSiZhiMu/bg1.png|move=0|show=4|esc=1>
        <Layout|x=884.0|y=33.0|width=80|height=80|link=@exit>
        <Button|x=857.0|y=40.0|size=18|nimg=custom/public/btn_close.png|color=255|link=@exit>
        <Img|x=678.0|y=276.0|img=custom/public/itemBG.png|esc=0>
        <Button|x=610.0|y=373.0|size=18|color=255|nimg=custom/HaFaXiSiZhiMu/btn1.png|link=@submit_hfxs_zhao_huan>
        <ItemShow|x=678.0|y=276.0|width=70|height=70|itemid=10005|itemcount=1|showtips=1|bgtype=0>
        <Text|x=701.0|y=333.0|color=]] .. color .. [[|outline=1|size=16|text=]] .. itemCount .. [[/4>
    ]]
    say(actor, txtTag)
end

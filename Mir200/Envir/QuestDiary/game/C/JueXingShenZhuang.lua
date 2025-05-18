local JueXingShenZhuang = {}
JueXingShenZhuang.cost = { { "金币", 500000000 }, { "元宝", 14880000 }, { "灵石", 888 } }

JueXingShenZhuang.ShenZhuang = {
    { "鬼画符", { "鬼画符(SSSR)", "鬼画符(SSR)", "鬼画符(SR)", "鬼画符(S)", "鬼画符(A)" } },
    { "帝国神龙", { "帝国の神龙(究极体)", "帝国の神龙(完全体)", "帝国の神龙(成熟期)", "帝国の神龙(成长期)", "帝国の神龙(幼年期)" } },
    { "魔刃噬魂", { "魔刃·噬魂(SSSR)", "魔刃·噬魂(SSR)", "魔刃·噬魂(SR)", "魔刃·噬魂(S)", "魔刃·噬魂(A)" } },
    { "魔戒骷髅王", { "魔戒·骷髅王(SSSR)", "魔戒·骷髅王(SSR)", "魔戒·骷髅王(SR)", "魔戒·骷髅王(S)", "魔戒·骷髅王(A)" } }
}

JueXingShenZhuang.gives = { "【EX级】哀霜之触", "【EX级】超能战盔", "【EX级】圣之语", "【EX级】冰火之羽", "【EX级】埃兰宝典" }

function JueXingShenZhuang.Request(actor)
    local myLevel = getbaseinfo(actor,ConstCfg.gbase.level)
    if myLevel < 320 then
        Player.sendmsgEx(actor,"你的等级不足320级不可以觉醒神装!#249")
        return
    end
    local HasShenZhuang = {}
    for i, value in ipairs(JueXingShenZhuang.ShenZhuang) do
        local isHas = false
        for _, v in ipairs(value[2]) do
            local num = getbagitemcount(actor, v)
            if num > 0 then
                table.insert(HasShenZhuang, { v, 1 })
                isHas = true
            end
        end
        if not isHas then
            Player.sendmsgEx(actor, string.format("[提示]:#251|你没有任意等级的|%s#249", value[1]))
            return
        end
    end

    local cost = clone(JueXingShenZhuang.cost)
    for _, value in ipairs(HasShenZhuang) do
        table.insert(cost, value)
    end
    local name, num = Player.checkItemNumByTable(actor, cost)
    if name then
        Player.sendmsgEx(actor, string.format("[提示]:#251|觉醒失败,你的|%s#249|不足|%d#249", name, num))
        return
    end
    Player.takeItemByTable(actor, cost, "觉醒神装")
    local randomIndex = math.random(1, 5)
    local give = JueXingShenZhuang.gives[randomIndex]
    giveitem(actor, give, 1)
    messagebox(actor, "已经随机获得EX级神装：" .. give)
    Message.sendmsg(actor, ssrNetMsgCfg.JueXingShenZhuang_SyncResponse)
end

function JueXingShenZhuang.RequestReplace(actor)
    local cost = {{"灵符",1888}}
    local hasEquip = {}
    local isHas = false
    for index, value in ipairs(JueXingShenZhuang.gives) do
        local num = getbagitemcount(actor, value)
        if num > 0 then
            isHas = true
            hasEquip = {value,1}
            break
        end
    end
    if not isHas then
        Player.sendmsgEx(actor, "[提示]:#251|你背包没有EX级神装#249")
        return
    end
    table.insert(cost,hasEquip)
    local name, num = Player.checkItemNumByTable(actor,cost)
    if name then
        Player.sendmsgEx(actor, string.format("[提示]:#251|置换失败,你的|%s#249|不足|%d#249", name, num))
        return
    end
    Player.takeItemByTable(actor,cost,"神装置换")
    local randomNum = math.random(1,5)
    local give = JueXingShenZhuang.gives[randomNum]
    giveitem(actor,give,1)
    messagebox(actor,string.format("使用【%s】，随机更换EX级神装：【%s】",hasEquip[1],give))
    Message.sendmsg(actor, ssrNetMsgCfg.JueXingShenZhuang_SyncResponse)
end

-----注册网络消息
Message.RegisterNetMsg(ssrNetMsgCfg.JueXingShenZhuang, JueXingShenZhuang)

return JueXingShenZhuang

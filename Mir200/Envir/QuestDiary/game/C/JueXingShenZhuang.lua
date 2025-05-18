local JueXingShenZhuang = {}
JueXingShenZhuang.cost = { { "���", 500000000 }, { "Ԫ��", 14880000 }, { "��ʯ", 888 } }

JueXingShenZhuang.ShenZhuang = {
    { "����", { "����(SSSR)", "����(SSR)", "����(SR)", "����(S)", "����(A)" } },
    { "�۹�����", { "�۹�������(������)", "�۹�������(��ȫ��)", "�۹�������(������)", "�۹�������(�ɳ���)", "�۹�������(������)" } },
    { "ħ���ɻ�", { "ħ�С��ɻ�(SSSR)", "ħ�С��ɻ�(SSR)", "ħ�С��ɻ�(SR)", "ħ�С��ɻ�(S)", "ħ�С��ɻ�(A)" } },
    { "ħ��������", { "ħ�䡤������(SSSR)", "ħ�䡤������(SSR)", "ħ�䡤������(SR)", "ħ�䡤������(S)", "ħ�䡤������(A)" } }
}

JueXingShenZhuang.gives = { "��EX������˪֮��", "��EX��������ս��", "��EX����ʥ֮��", "��EX��������֮��", "��EX������������" }

function JueXingShenZhuang.Request(actor)
    local myLevel = getbaseinfo(actor,ConstCfg.gbase.level)
    if myLevel < 320 then
        Player.sendmsgEx(actor,"��ĵȼ�����320�������Ծ�����װ!#249")
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
            Player.sendmsgEx(actor, string.format("[��ʾ]:#251|��û������ȼ���|%s#249", value[1]))
            return
        end
    end

    local cost = clone(JueXingShenZhuang.cost)
    for _, value in ipairs(HasShenZhuang) do
        table.insert(cost, value)
    end
    local name, num = Player.checkItemNumByTable(actor, cost)
    if name then
        Player.sendmsgEx(actor, string.format("[��ʾ]:#251|����ʧ��,���|%s#249|����|%d#249", name, num))
        return
    end
    Player.takeItemByTable(actor, cost, "������װ")
    local randomIndex = math.random(1, 5)
    local give = JueXingShenZhuang.gives[randomIndex]
    giveitem(actor, give, 1)
    messagebox(actor, "�Ѿ�������EX����װ��" .. give)
    Message.sendmsg(actor, ssrNetMsgCfg.JueXingShenZhuang_SyncResponse)
end

function JueXingShenZhuang.RequestReplace(actor)
    local cost = {{"���",1888}}
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
        Player.sendmsgEx(actor, "[��ʾ]:#251|�㱳��û��EX����װ#249")
        return
    end
    table.insert(cost,hasEquip)
    local name, num = Player.checkItemNumByTable(actor,cost)
    if name then
        Player.sendmsgEx(actor, string.format("[��ʾ]:#251|�û�ʧ��,���|%s#249|����|%d#249", name, num))
        return
    end
    Player.takeItemByTable(actor,cost,"��װ�û�")
    local randomNum = math.random(1,5)
    local give = JueXingShenZhuang.gives[randomNum]
    giveitem(actor,give,1)
    messagebox(actor,string.format("ʹ�á�%s�����������EX����װ����%s��",hasEquip[1],give))
    Message.sendmsg(actor, ssrNetMsgCfg.JueXingShenZhuang_SyncResponse)
end

-----ע��������Ϣ
Message.RegisterNetMsg(ssrNetMsgCfg.JueXingShenZhuang, JueXingShenZhuang)

return JueXingShenZhuang

local TianMingFunc = {}
--有福之人
TianMingFunc[18] = function(actor, ...)
    if getflagstatus(actor, VarCfg["F_天命_有福之人标识"]) == 1 then
        local isReceive = getplaydef(actor, VarCfg["J_天命有福之人是否领取"])
        if isReceive == 0 then
            local gold = math.random(10000, 1000000)
            local usreID = getbaseinfo(actor, ConstCfg.gbase.id)
            sendmail(usreID, 1, "有福之人", "每日首次登录时,自动获得1-100W金币,请领取您的金币!", "绑定金币#" .. gold .. "#0")
            setplaydef(actor, VarCfg["J_天命有福之人是否领取"], 1)
        end
    end
end

--以逸待劳
TianMingFunc[19] = function(actor, ...)
    delattlist(actor, "以逸待劳")
    if getflagstatus(actor, VarCfg["F_天命_以逸待劳标识"]) == 1 then
        local serverOpenDay = getsysvar(VarCfg["G_开区天数"])
        local attrValue = serverOpenDay * 5
        if attrValue >= 200 then
            attrValue = 200
        end
        addattlist(actor, "以逸待劳", "=", string.format("3#9#%d|3#10#%d", attrValue, attrValue), 1)
    end
end

--黑夜传说
TianMingFunc[28] = function(actor, ...)
    delattlist(actor, "黑夜传说")
    if getflagstatus(actor, VarCfg["F_天命_黑夜传说标识"]) == 1 then
        if checktimeInPeriod(22, 59, 7, 59) then
            addattlist(actor, "黑夜传说", "=",
                "3#3#160|3#4#160|3#5#160|3#6#160|3#7#160|3#8#160|3#9#160|3#10#160|3#11#160|3#12#160", 1)
        end
    end
end

--共振共鸣
TianMingFunc[29] = function(actor, ...)
    delattlist(actor, "共振共鸣")
    if getflagstatus(actor, VarCfg["F_天命_共振共鸣标识"]) == 1 then
        local groupNum = getbaseinfo(actor, ConstCfg.gbase.team_num)
        if groupNum > 0 then
            addattlist(actor, "共振共鸣", "=", "3#1#200|3#3#200|3#4#200|3#9#200|3#10#200", 1)
        end
    end
end

TianMingFunc[36] = function(actor, ...)
    delattlist(actor, "越挫越勇")
    if getflagstatus(actor, VarCfg["F_天命_越挫越勇标识"]) == 1 then
        local tatol = getplaydef(actor, VarCfg["U_天命_越挫越勇攻击累加"])
        if tatol > 0 then
            addattlist(actor, "越挫越勇", "=", "3#4#" .. tatol, 1)
        end
    end
end

--祝福之体
TianMingFunc[39] = function(actor, ...)
    local args = { ... }
    local flag = args[1]
    if flag == 1 then
        Player.setAttList(actor, "属性附加")
    end
end

--强化大师
TianMingFunc[40] = function(actor, ...)
    local args = { ... }
    local flag = args[1]
    if flag == 1 then
        ZhuangBeiQiangHua.SyncResponse(actor)
    end
end

--走火入魔
TianMingFunc[41] = function(actor, ...)
    -- release_print(getflagstatus(actor, VarCfg["F_天命_走火入魔标识"]))
    if getflagstatus(actor, VarCfg["F_天命_走火入魔标识"]) == 1 then
        local acLow = getbaseinfo(actor, ConstCfg.gbase.ac)
        local acMax = getbaseinfo(actor, ConstCfg.gbase.ac2)
        changehumability(actor, 1, -acLow, 655350)
        changehumability(actor, 2, -acMax, 655350)
    else
        local args = { ... }
        local flag = args[1]
        if flag == 1 then
            local acLow = gethumability(actor, 1)
            local acMax = gethumability(actor, 2)
            if acLow < 0 and acMax < 0 then
                changehumability(actor, 1, math.abs(acLow), 655350)
                changehumability(actor, 2, math.abs(acMax), 655350)
            end
        end
    end
end

--合区超人
TianMingFunc[42] = function(actor, ...)
    local args = { ... }
    local flag = args[1]
    if flag == 1 then
        Player.setAttList(actor, "属性附加")
    end
end

--龙神学院
TianMingFunc[43] = function(actor, ...)
    local args = { ... }
    local flag = args[1]
    if flag == 1 then
        Player.setAttList(actor, "属性附加")
    end
end

--泰坦之力
TianMingFunc[44] = function(actor, ...)
    delattlist(actor, "泰坦之力")
    if getflagstatus(actor, VarCfg["F_天命_泰坦之力标识"]) == 1 then
        local maxHp = getbaseinfo(actor, ConstCfg.gbase.maxhp)
        local attackNum = math.ceil(maxHp * 0.01)
        if attackNum > 10000 then
            attackNum = 10000
        end
        addattlist(actor, "泰坦之力", "=", "3#4#" .. attackNum, 1)
    end
end

--以暴制暴
TianMingFunc[45] = function(actor, ...)
    local args = { ... }
    local flag = args[1]
    if flag == 1 then
        Player.setAttList(actor, "属性附加")
    end
end

--天选之人
TianMingFunc[47] = function(actor, ...)
    local args = { ... }
    local flag = args[1]
    if flag == 1 then
        clearhumcustvar(actor,VarCfg["天选之人是否掉落"])
    end
end

--天眷之人
TianMingFunc[48] = function(actor, ...)
    local args = { ... }
    local flag = args[1]
    if flag == 1 then
        setplaydef(actor, VarCfg["J_天命天眷之人第一次"], 0)
        XingYunXiangLian.SyncResponse(actor) --幸运项链同步一次网络消息
    end
end

--混元之祖
TianMingFunc[49] = function(actor, ...)
    local args = { ... }
    local flag = args[1]
    if getflagstatus(actor, VarCfg["F_天命_混元之祖标识"]) == 1 then
        local huyuanlevel = getplaydef(actor, VarCfg["U_混元功法等级"])
        if huyuanlevel >= 60 then
            if flag == 1 then
                addskill(actor, 114, 3)
                messagebox(actor, "你的混元功法已满级,获得技能[倚天辟地]!")
            end
        end
    else
        delskill(actor, 114)
        if flag == 1 then
            messagebox(actor, "你遗失了技能[倚天辟地]!")
        end
    end
end

--月光之力
TianMingFunc[50] = function(actor, ...)
    delattlist(actor, "月光之力")
    if getflagstatus(actor, VarCfg["F_天命_月光之力标识"]) == 1 then
        if checktimeInPeriod(22, 59, 7, 59) then
            addattlist(actor, "月光之力", "=", "3#3#80|3#4#80|3#5#80|3#6#80|3#7#80|3#8#80|3#9#80|3#10#80|3#11#80|3#12#80", 1)
        end
    end
end

--终身进修
TianMingFunc[52] = function(actor, ...)
    local args = { ... }
    local flag = args[1]
    if flag == 1 then
        Player.setAttList(actor, "属性附加")
        HunYuanGongFa.SyncResponse(actor)
    end
end
--天胡开局
TianMingFunc[53] = function(actor, ...)
    local args = { ... }
    local flag = args[1]
    if flag == 1 then
        Player.setAttList(actor, "属性附加")
    end
end

--影盾之术
TianMingFunc[54] = function(actor, ...)
    local args = { ... }
    local flag = args[1]
    if getflagstatus(actor, VarCfg["F_天命_影盾之术标识"]) == 1 then
        changemode(actor, 22, 65535)
    else
        --手动点击的时候 才取消，登陆不需要执行
        if flag == 1 then
            changemode(actor, 22, 0)
        end
    end
end

--势如破竹
TianMingFunc[55] = function(actor, ...)
    local args = { ... }
    local flag = args[1]
    if flag == 1 then
        if getflagstatus(actor, VarCfg["F_天命_势如破竹标识"]) == 0 then
            delattlist(actor, "势如破竹")
        end
    end
end

--血刀老祖
TianMingFunc[56] = function(actor, ...)
    local args = { ... }
    local flag = args[1]
    if flag == 1 then
        delaygoto(actor, 2200, "xuedaolaozusubhp,1")
    else
        delaygoto(actor, 2200, "xuedaolaozusubhp,0")
    end
end

--天选之人
TianMingFunc[57] = function(actor, ...)
    local args = { ... }
    local flag = args[1]
    if flag == 1 then
        Player.setAttList(actor, "爆率附加")
    end
end

--洪福齐天
TianMingFunc[58] = function(actor, ...)
    local args = { ... }
    local flag = args[1]
    if flag == 1 then
        Player.setAttList(actor, "属性附加")
    end
end
--未来战士
TianMingFunc[59] = function(actor, ...)
    local args = { ... }
    local flag = args[1]
    if flag == 1 then
        Player.setAttList(actor, "属性附加")
    end
end

--永动机
TianMingFunc[60] = function(actor, ...)
    local args = { ... }
    local flag = args[1]
    if flag == 1 then
        if getflagstatus(actor, VarCfg["F_天命_永动机标识"]) == 1 then
            -- addbuff(actor, 30083)
            Player.setAttList(actor, "回血计算")
            setontimer(actor, 10, 3, 0, 1)
        else
            -- delbuff(actor, 30083)
            Player.setAttList(actor, "回血计算")
            setofftimer(actor, 10)
        end
    end
end


--浴血狂魔
TianMingFunc[61] = function(actor, ...)
    local args = { ... }
    local flag = args[1]
    if flag == 1 then
        Player.setAttList(actor, "属性附加")
        Player.setAttList(actor, "倍攻附加")
    end
end

--不动如山
TianMingFunc[62] = function(actor, ...)
    local args = { ... }
    local flag = args[1]
    if flag == 1 then
        delaygoto(actor, 1000, "budongrushangongji,1")
    else
        delaygoto(actor, 1000, "budongrushangongji,0")
    end
end

--大罗转世
TianMingFunc[64] = function(actor, ...)
    local args = { ... }
    local flag = args[1]
    if flag == 1 then
        Player.setAttList(actor, "爆率附加")
    end
end

--疾风迅雷
TianMingFunc[65] = function(actor, ...)
    local args = { ... }
    local flag = args[1]
    if flag == 1 then
        Player.setAttList(actor, "攻速附加")
    end
end

--致命专精
TianMingFunc[66] = function(actor, ...)
    if getflagstatus(actor, VarCfg["F_天命_致命专精标识"]) == 1 then
        setontimer(actor, 3, 8, 0, 1)
    else
        setofftimer(actor, 3)
        changehumnewvalue(actor, 21, 0, 1)
    end
end

--血魔之躯
TianMingFunc[67] = function(actor, ...)
    delattlist(actor, "血魔之躯")
    if getflagstatus(actor, VarCfg["F_天命_血魔之躯标识"]) == 1 then
        delaygoto(actor, 1000, "xiemozhiqufangyu")
    end
    Player.setAttList(actor, "回血计算")
end

--血魔之躯
TianMingFunc[227] = function(actor, ...)
    local args = { ... }
    local flag = args[1]
    if flag == 1 then
        Player.setAttList(actor, "攻速附加")
    end
end


--狂暴之子
TianMingFunc[230] = function(actor, ...)
    local args = { ... }
    local flag = args[1]
    if flag == 1 then
        Player.setAttList(actor, "倍攻附加")
    end
end
--炙热双刀
TianMingFunc[232] = function(actor, ...)
    local args = { ... }
    local flag = args[1]
    if flag == 1 then
        Player.setAttList(actor, "攻速附加")
    end
end

--狂暴之子
TianMingFunc[233] = function(actor, ...)
    if getflagstatus(actor,VarCfg["F_天命狂暴之子"]) == 1 then
        local isKangBao = getflagstatus(actor, VarCfg.F_is_open_kuangbao) --是否开启狂暴之力
        if isKangBao == 1 then
            addattlist(actor,"狂暴之子","=","3#3#50|3#4#50|3#5#50|3#6#50|3#7#50|3#8#50",1)
        end
    else
        delattlist(actor,"狂暴之子")
    end
end
--暗黑
TianMingFunc[234] = function(actor,...)
    if getflagstatus(actor,VarCfg["F_天命暗黑"]) == 1 then
        local h = tonumber(os.date("%H"))
        if h >= 23 and h < 9 then
            addattlist(actor,"暗黑","=","3#207#8",1)
        else
            delattlist(actor,"暗黑")
        end
    else
        delattlist(actor,"暗黑")
    end
end
--黎明
TianMingFunc[235] = function(actor,...)
    if getflagstatus(actor,VarCfg["F_天命黎明"]) == 1 then
        local h = tonumber(os.date("%H"))
        if h < 23 and h >= 9 then
            addattlist(actor,"黎明","=","3#206#8",1)
        else
            delattlist(actor,"黎明")
        end
    else
        delattlist(actor,"黎明")
    end
end
--疋杀地蔵
TianMingFunc[236] = function(actor,...)
    Player.setAttList(actor, "技能威力")
end
--独揽大权
TianMingFunc[237] = function(actor,...)
    if getflagstatus(actor,VarCfg["F_天命独揽大权"]) == 1 then
        if getplayguildlevel(actor) == 1 then
            addattlist(actor,"独揽大权","=","3#221#15|3#222#15|3#223#15|3#210#15|3#211#15|3#212#15",1)
        else
            delattlist(actor,"独揽大权")
        end
    else
        delattlist(actor,"独揽大权")
    end
end

--鹤立鸡群
TianMingFunc[239] = function(actor,...)
    if getflagstatus(actor,VarCfg["F_天命鹤立鸡群"]) == 1 then
        --release_print("getmyguild(actor)   " .. getmyguild(actor))
        if getmyguild(actor) == "0" then
            addattlist(actor,"鹤立鸡群","=","3#28#20",1)
        else
            delattlist(actor,"鹤立鸡群")
        end
    else
        delattlist(actor,"鹤立鸡群")
    end
end

--疾风之道
TianMingFunc[240] = function(actor,...)
    local args = { ... }
    local flag = args[1]
    if flag == 1 then
        Player.setAttList(actor, "攻速附加")
    end
end

--来去自如
TianMingFunc[241] = function(actor,...)

end

--忍辱负重
TianMingFunc[242] = function(actor,...)
    if getflagstatus(actor,VarCfg["F_天命忍辱负重"]) == 1 then
        if Player.GetLevel(actor) >= 160 then
            addattlist(actor,"忍辱负重","=","3#4#1888|3#3#1888|3#1#20000",1)
        else
            delattlist(actor,"忍辱负重")
        end
    else
        delattlist(actor,"忍辱负重")
    end
end
--省着点花
TianMingFunc[243] = function(actor,...)
    if getflagstatus(actor,VarCfg["F_天命省着点花"]) == 1 then
        if querymoney(actor,1) + querymoney(actor,3) < 50000000 then
            addattlist(actor,"省着点花","=","3#28#20",1)
        else
            delattlist(actor,"省着点花")
        end
    else
        delattlist(actor,"省着点花")
    end
end

--来去自如
TianMingFunc[244] = function(actor,...)
    Player.setAttList(actor, "倍攻附加")
end

--聚宝术
TianMingFunc[245] = function(actor,...)
    if getflagstatus(actor,VarCfg["F_天命聚宝术"]) == 0 then
        delattlist(actor,"聚宝术")
    end
end


return TianMingFunc

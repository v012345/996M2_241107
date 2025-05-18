JiXianQianNeng = {}
local BuffCfg1 = {
    ["龙族雕石[一阶觉醒]"] = { buff = 31023, cost = 100, str = "3#34#300|3#26#3|3#27#3|3#76#300|3#200#10000|3#1#200000" },
    ["龙族雕石[二阶觉醒]"] = { buff = 31024, cost = 300, str = "3#34#500|3#26#5|3#27#5|3#76#500|3#200#20000|3#1#400000" },
    ["龙族雕石[三阶觉醒]"] = { buff = 31025, cost = 600, str = "3#34#700|3#26#7|3#27#7|3#76#700|3#200#30000|3#1#800000" },
    ["龙族雕石[四阶觉醒]"] = { buff = 31026, cost = 900, str = "3#34#700|3#26#10|3#27#10|3#76#1000|3#200#40000|3#1#1500000" },
    ["龙族雕石[五阶觉醒]"] = { buff = 31027, cost = 1200, str = "3#34#1200|3#26#15|3#27#15|3#76#1500|3#200#50000|3#1#3000000" }
}

local BuffCfg2 = {
    ["龙族雕石[一阶觉醒]"] = { buff = 31023, cost = 100, str = "3#34#360|3#26#4|3#27#4|3#76#300|3#200#12000|3#1#240000" },
    ["龙族雕石[二阶觉醒]"] = { buff = 31024, cost = 300, str = "3#34#600|3#26#6|3#27#6|3#76#500|3#200#24000|3#1#480000" },
    ["龙族雕石[三阶觉醒]"] = { buff = 31025, cost = 600, str = "3#34#840|3#26#8|3#27#8|3#76#700|3#200#36000|3#1#960000" },
    ["龙族雕石[四阶觉醒]"] = { buff = 31026, cost = 900, str = "3#34#840|3#26#12|3#27#12|3#76#1000|3#200#48000|3#1#1800000" },
    ["龙族雕石[五阶觉醒]"] = { buff = 31027, cost = 1200, str = "3#34#1440|3#26#18|3#27#18|3#76#1500|3#200#60000|3#1#3600000" }
}

local BuffCfg3 = {
    ["龙族雕石[一阶觉醒]"] = { buff = 31023, cost = 100, str = "3#34#375|3#26#4|3#27#4|3#76#375|3#200#12500|3#1#250000" },
    ["龙族雕石[二阶觉醒]"] = { buff = 31024, cost = 300, str = "3#34#625|3#26#7|3#27#7|3#76#625|3#200#25000|3#1#500000" },
    ["龙族雕石[三阶觉醒]"] = { buff = 31025, cost = 600, str = "3#34#875|3#26#9|3#27#9|3#76#875|3#200#37500|3#1#1000000" },
    ["龙族雕石[四阶觉醒]"] = { buff = 31026, cost = 900, str = "3#34#875|3#26#13|3#27#13|3#76#1250|3#200#50000|3#1#1875000" },
    ["龙族雕石[五阶觉醒]"] = { buff = 31027, cost = 1200, str = "3#34#1500|3#26#19|3#27#19|3#76#1875|3#200#62500|3#1#3750000" }
}


local BuffCfg4 = {
    ["龙族雕石[一阶觉醒]"] = { buff = 31023, cost = 100, str = "3#34#390|3#26#4|3#27#4|3#76#390|3#200#13000|3#1#260000" },
    ["龙族雕石[二阶觉醒]"] = { buff = 31024, cost = 300, str = "3#34#650|3#26#7|3#27#7|3#76#650|3#200#26000|3#1#520000" },
    ["龙族雕石[三阶觉醒]"] = { buff = 31025, cost = 600, str = "3#34#910|3#26#10|3#27#10|3#76#910|3#200#39000|3#1#1040000" },
    ["龙族雕石[四阶觉醒]"] = { buff = 31026, cost = 900, str = "3#34#910|3#26#13|3#27#13|3#76#1300|3#200#52000|3#1#1950000" },
    ["龙族雕石[五阶觉醒]"] = { buff = 31027, cost = 1200, str = "3#34#1560|3#26#20|3#27#20|3#76#1950|3#200#65000|3#1#3900000" }
}

function open_ji_xian_qian_neng(actor)
    local buff = hasbuff(actor, 31022)
    local ItemName = getconst(actor, "<$USEITEMNAME[89]>")
    --未觉醒 直接打断
    if ItemName == "" then
        Player.sendmsgEx(actor, "提示#251|:#255|前往遗忘古迹可开启功能#250|...")
        return
    end
    if ItemName == "龙族雕石[未觉醒]" then
        Player.sendmsgEx(actor, "提示#251|:#255|前往遗忘古迹可开启功能#250|...")
        return
    end --未觉醒 直接打断
    --切换CD中 直接打断
    if buff then
        Player.sendmsgEx(actor, "提示#251|:#255|请等待#250|冷却结束#249|再使用该功能#250|...")
        return
    end
    local falg = getflagstatus(actor,VarCfg["F_终极时装标识"])
    local falg1 = getflagstatus(actor,VarCfg["F_终极时装标识1"])
    local falg2 = getflagstatus(actor,VarCfg["F_终极时装标识2"])
    local BuffCfg = BuffCfg1
    -- 4W
    if falg == 1 then
         BuffCfg = BuffCfg2
    end
    --5W
    if falg1 == 1 then
        BuffCfg = BuffCfg3
    end
   --10W
    if falg2 == 1 then
        BuffCfg = BuffCfg4
    end
    --判断元宝
    if querymoney(actor, 2) < BuffCfg[ItemName].cost then
        Player.sendmsgEx(actor, "提示#251|:#255|对不起,你的|元宝#249|不足|" .. BuffCfg[ItemName].cost .. "#249|激活失败...")
        return
    end
    if getplaydef(actor, VarCfg["N$极限潜能开关"]) == 0 then
        addbuff(actor, 31022, 10, 1, actor) -- 切换CDbuff
        setplaydef(actor, VarCfg["N$极限潜能开关"], 1)
        addbuff(actor, BuffCfg[ItemName].buff, 999999, 1, actor)
        JiXianQianNeng.SyncResponse(actor)
        addattlist(actor, "极限潜能", "=", BuffCfg[ItemName].str, 1)
        playeffect(actor, 63077, 0, 0, 0, 1, 1)
        local num = getplaydef(actor, VarCfg["U_开启极限潜能次数"])
        setplaydef(actor, VarCfg["U_开启极限潜能次数"], num + 1)
        GameEvent.push(EventCfg.onOpenJiXianQianNeng, actor, num + 1)
    else
        addbuff(actor, 31022, 10, 1, actor) -- 切换CDbuff
        setplaydef(actor, VarCfg["N$极限潜能开关"], 0)
        FkfDelBuff(actor, BuffCfg[ItemName].buff)
        JiXianQianNeng.SyncResponse(actor)
        delattlist(actor, "极限潜能") --属性组
        clearplayeffect(actor, 63077)
    end
end

function JiXianQianNeng.Request(actor)
    if getplaydef(actor, VarCfg["N$极限潜能开关"]) == 0 then
        messagebox(actor, "确定开启极限潜能?", "@open_ji_xian_qian_neng", "@quxiao")
    else
        open_ji_xian_qian_neng(actor)
    end
end

function JiXianQianNeng.SyncResponse(actor)
    local data = { getplaydef(actor, VarCfg["N$极限潜能开关"]) }
    Message.sendmsg(actor, ssrNetMsgCfg.TopIcon_UpdateIcon, 0, 0, 0, data)
end

Message.RegisterNetMsg(ssrNetMsgCfg.JiXianQianNeng, JiXianQianNeng)

return JiXianQianNeng

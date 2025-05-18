local GetJQChildConditions = {}

--起源村
GetJQChildConditions[1] = function(actor)
    local Condition1 = getplaydef(actor, VarCfg["U_主线任务进度"]) > 6
    return { Condition1 }
end
--老村长的怀表
GetJQChildConditions[2] = function(actor)
    local Condition1 = getflagstatus(actor, VarCfg["F_老村长的怀表"]) == 1
    return { Condition1 }
end
--边关将领
GetJQChildConditions[3] = function(actor)
    local Condition1 = { getplaydef(actor, VarCfg.U_bian_guan_title), 10 }
    return { Condition1 }
end
--斗转星移
GetJQChildConditions[4] = function(actor)
    local Condition1 = getflagstatus(actor, VarCfg["F_空间法师"]) == 1
    return { Condition1 }
end
-- local Condition1 = getflagstatus(actor, VarCfg["F_剧情_玄幽"]) == 1
-- local Condition2 = { getplaydef(actor, VarCfg["U_剧情_湿婆神像_进度"]), 100 }
-- local Condition3 = getflagstatus(actor, VarCfg["F_剧情_元素之隙"]) == 1
-- local Condition4 = { getplaydef(actor, VarCfg["U_剧情_黑齿宝藏_开启次数"]), 1 }
-- local Condition5 = getflagstatus(actor, VarCfg["F_剧情_暗域裂隙"]) == 1
-- local Condition6 = getflagstatus(actor, VarCfg["F_封印祭坛_完成"]) == 1
-- local Condition7 = (getflagstatus(actor, VarCfg["F_剧情_被封印的封印棺椁_是否领取1"]) == 1 or getflagstatus(actor, VarCfg["F_剧情_被封印的封印棺椁_是否领取2"])) and
-- getflagstatus(actor, VarCfg["F_被封印的棺材使用_完成"]) == 1
-- local Condition8 = getflagstatus(actor, VarCfg["F_新月宝珠_完成"]) == 1
-- local Condition9 = { getplaydef(actor, VarCfg["U_剧情_英灵祭坛_称号"]), 10 }
-- local Condition10 = { getplaydef(actor, VarCfg["U_剧情_古龙的传承"]), 5 }
-- local Condition11 = { getplaydef(actor, VarCfg["U_剧情_剑灵传说"]), 10 }
-- local Condition12 = getflagstatus(actor, VarCfg["F_合成太虚古龙领域"]) == 1
-- return { Condition1, Condition2, Condition3, Condition4, Condition5, Condition6, Condition7, Condition8, Condition9,
--     Condition10, Condition11, Condition12 }
GetJQChildConditions[5] = function(actor)
    local Condition1 = getflagstatus(actor, VarCfg["F_剧情_玄幽"]) == 1
    return { Condition1 }
end
GetJQChildConditions[6] = function(actor)
    local Condition2 = checktitle(actor, "湿婆信徒")
    return { Condition2 }
end
GetJQChildConditions[7] = function(actor)
    local Condition3 = getflagstatus(actor, VarCfg["F_剧情_元素之隙"]) == 1
    return { Condition3 }
end
GetJQChildConditions[8] = function(actor)
    local Condition4 = { getplaydef(actor, VarCfg["U_剧情_黑齿宝藏_开启次数"]), 1 }
    return { Condition4 }
end
GetJQChildConditions[9] = function(actor)
    local Condition5 = getflagstatus(actor, VarCfg["F_剧情_暗域裂隙"]) == 1
    return { Condition5 }
end
GetJQChildConditions[10] = function(actor)
    local Condition6 = getflagstatus(actor, VarCfg["F_封印祭坛_完成"]) == 1
    return { Condition6 }
end
GetJQChildConditions[11] = function(actor)
    local Condition7_1 = (getflagstatus(actor, VarCfg["F_剧情_被封印的封印棺椁_是否领取1"]) == 1 or getflagstatus(actor, VarCfg["F_剧情_被封印的封印棺椁_是否领取2"]) == 1)
    local Condition7_2 = getflagstatus(actor, VarCfg["F_被封印的棺材使用_完成"]) == 1
    return { Condition7_1, Condition7_2 }
end
GetJQChildConditions[12] = function(actor)
    local Condition8 = getflagstatus(actor, VarCfg["F_新月宝珠_完成"]) == 1
    return { Condition8 }
end
GetJQChildConditions[13] = function(actor)
    local Condition9 = { getplaydef(actor, VarCfg["U_剧情_英灵祭坛_称号"]), 10 }
    return { Condition9 }
end
GetJQChildConditions[14] = function(actor)
    local Condition10 = { getplaydef(actor, VarCfg["U_剧情_古龙的传承"]), 5 }
    return { Condition10 }
end
GetJQChildConditions[15] = function(actor)
    local Condition11 = { getplaydef(actor, VarCfg["U_剧情_剑灵传说"]), 10 }
    return { Condition11 }
end
GetJQChildConditions[16] = function(actor)
    local Condition12 = getflagstatus(actor, VarCfg["F_合成太虚古龙领域"]) == 1
    return { Condition12 }
end
-- --1.心魔老人
-- local Condition1 = getplaydef(actor, VarCfg["U_心魔老人挑战次数"]) >= 3
-- --2.焚世祭
-- local Condition2 = getplaydef(actor, VarCfg["U_二元归灵珠_数量"]) >= 2 and getplaydef(actor, VarCfg["U_上古魔龙召唤_数量"]) >= 3
-- --3.雷鸣之力
-- local Condition3 = getflagstatus(actor, VarCfg["F_剧情_雷鸣之力_1"]) == 1 and getflagstatus(actor, VarCfg["F_剧情_雷鸣之力_2"]) == 1 and getflagstatus(actor, VarCfg["F_剧情_雷鸣之力_3"]) == 1 and getflagstatus(actor, VarCfg["F_剧情_雷鸣之力_4"]) == 1
-- -- 4.蛮荒血脉
-- local Condition4 = getplaydef(actor, VarCfg["U_剧情_蛮荒血脉_觉醒次数"]) >= 10
-- --5.沙暴传说
-- local Condition5 = getflagstatus(actor, VarCfg["F_黄沙之灵_完成"]) == 1
-- --6.域外战歌
-- local Condition6 = getplaydef(actor, VarCfg["U_剧情_神龙侍卫_进度"]) >= 100
-- -- 7.灵魂牢笼
-- local Condition7 = getplaydef(actor,VarCfg["U_剧情_灵魂牢笼_次数"]) >= 10 and getflagstatus(actor,VarCfg["F_剧情_生死境界_地图开启"]) == 1
-- --8.枯骨之魂
-- local Condition8 = (getflagstatus(actor, VarCfg["F_剧情_一将功成万古枯1"]) == 1 and getflagstatus(actor, VarCfg["F_剧情_一将功成万古枯2"]) == 1 and getflagstatus(actor, VarCfg["F_剧情_一将功成万古枯3"]) == 1) or getflagstatus(actor,VarCfg["F_剧情_时装是否领取"]) == 1
-- --9.妖月之灵
-- local Condition9 = getplaydef(actor, VarCfg["U_归灵仪式召唤_数量"])  >= 10 and getflagstatus(actor,VarCfg["F_妖月九尾狐王击杀_完成"]) == 1
-- --10.洞察之眼
-- local Condition10 = getplaydef(actor, VarCfg["U_剧情_遗忘前线_杀怪数量"]) >= 1000 and getplaydef(actor, VarCfg["U_剧情_悲鸣哨塔_线索数量"]) >= 100

GetJQChildConditions[17] = function(actor)
    local Condition1_1 = getplaydef(actor, VarCfg["U_心魔老人挑战次数"]) >= 1
    local Condition1_2 = getplaydef(actor, VarCfg["U_心魔老人挑战次数"]) >= 2
    local Condition1_3 = getplaydef(actor, VarCfg["U_心魔老人挑战次数"]) >= 3
    return { Condition1_1, Condition1_2, Condition1_3 }
end
GetJQChildConditions[18] = function(actor)
    local Condition2_1 = { getplaydef(actor, VarCfg["U_上古魔龙召唤_数量"]), 3 }
    local Condition2_2 = { getplaydef(actor, VarCfg["U_二元归灵珠_数量"]), 2 }
    return { Condition2_1, Condition2_2 }
end
GetJQChildConditions[19] = function(actor)
    local Condition3_1 = { getflagstatus(actor, VarCfg["F_剧情_雷鸣之力_1"]), 1 }
    local Condition3_2 = { getflagstatus(actor, VarCfg["F_剧情_雷鸣之力_2"]), 1 }
    local Condition3_3 = { getflagstatus(actor, VarCfg["F_剧情_雷鸣之力_4"]), 1 }
    local Condition3_4 = { getflagstatus(actor, VarCfg["F_剧情_雷鸣之力_3"]), 1 }
    return { Condition3_1, Condition3_2, Condition3_3, Condition3_4 }
end
GetJQChildConditions[20] = function(actor)
    local Condition4 = { getplaydef(actor, VarCfg["U_剧情_蛮荒血脉_觉醒次数"]), 10 }
    return { Condition4 }
end
GetJQChildConditions[21] = function(actor)
    local Condition5 = getflagstatus(actor, VarCfg["F_黄沙之灵_完成"]) == 1
    return { Condition5 }
end
GetJQChildConditions[22] = function(actor)
    local Condition6 = { getplaydef(actor, VarCfg["U_剧情_神龙侍卫_进度"]), 100 }
    return { Condition6 }
end
GetJQChildConditions[23] = function(actor)
    local Condition7_1 = { getplaydef(actor, VarCfg["U_剧情_灵魂牢笼_次数"]), 10 }
    local Condition7_2 = getflagstatus(actor, VarCfg["F_剧情_生死境界_地图开启"]) == 1
    return { Condition7_1, Condition7_2 }
end
GetJQChildConditions[24] = function(actor)
    local Condition8_1 = { getflagstatus(actor, VarCfg["F_剧情_一将功成万古枯1"]), 1 }
    local Condition8_2 = { getflagstatus(actor, VarCfg["F_剧情_一将功成万古枯2"]), 1 }
    local Condition8_3 = { getflagstatus(actor, VarCfg["F_剧情_一将功成万古枯3"]), 1 }
    local Condition8_4 = { getflagstatus(actor, VarCfg["F_剧情_时装是否领取"]), 1 }
    return { Condition8_1, Condition8_2, Condition8_3, Condition8_4 }
end
GetJQChildConditions[25] = function(actor)
    local Condition9_1 = {getplaydef(actor, VarCfg["U_归灵仪式召唤_数量"]),10}
    local Condition9_2 = getflagstatus(actor,VarCfg["F_妖月九尾狐王击杀_完成"]) == 1
    return {Condition9_1,Condition9_2}
end
GetJQChildConditions[26] = function(actor)
    -- local Condition10 = getplaydef(actor, VarCfg["U_剧情_遗忘前线_杀怪数量"]) >= 1000 and getplaydef(actor, VarCfg["U_剧情_悲鸣哨塔_线索数量"]) >= 100
    local Condition10_1 = { getplaydef(actor, VarCfg["U_剧情_遗忘前线_杀怪数量"]), 1000 }
    local Condition10_2 = getplaydef(actor, VarCfg["U_剧情_悲鸣哨塔_线索数量"]) >= 100 
    local Condition10_3 = checktitle(actor,"洞察之眼")
    return { Condition10_1, Condition10_2, Condition10_3 }
end
GetJQChildConditions[27] = function(actor)
    local Condition11_1 = { getplaydef(actor, VarCfg["U_龙之守护击杀_数量"]), 10 }
    local Condition11_2 = getflagstatus(actor,VarCfg["F_[龍器]祖龍號角_完成"]) == 1
    return { Condition11_1, Condition11_2 }
end
GetJQChildConditions[28] = function(actor)
    local Condition12 = getflagstatus(actor,VarCfg["F_毁灭·魔化天使[吞噬]_完成"]) == 1
    return {Condition12}
end
GetJQChildConditions[29] = function(actor)
    local Condition13_1 = { getplaydef(actor, VarCfg["U_剧情_永恒徽记_记录1"]), 3 }
    local Condition13_2 = { getplaydef(actor, VarCfg["U_剧情_永恒徽记_记录2"]), 3 }
    local Condition13_3 = { getplaydef(actor, VarCfg["U_剧情_永恒徽记_记录3"]), 3 }
    local Condition13_4 = { getplaydef(actor, VarCfg["U_剧情_永恒徽记_记录4"]), 3 }
    local Condition13_5 = checktitle(actor,"追逐永恒之路")
    return { Condition13_1, Condition13_2, Condition13_3, Condition13_4, Condition13_5 }
end
--小鬼难缠
GetJQChildConditions[30] = function(actor)
    local Condition1 = getflagstatus(actor, VarCfg["F_剧情_阎王大殿是否开启"]) == 1
    return { Condition1 }
end
GetJQChildConditions[31] = function(actor)
    local Condition2 = {getplaydef(actor, VarCfg["U_判官改名次数"]), 3}
    return { Condition2 }
end
GetJQChildConditions[32] = function(actor)
    local Condition3 = getflagstatus(actor,VarCfg["F_剧情_幽冥鬼使_地图开启"]) == 1
    return { Condition3 }
end
GetJQChildConditions[33] = function(actor)
    local Condition4_1 = {getplaydef(actor, VarCfg["U_剧情_阴阳八卦盘_阴"]),66} 
    local Condition4_2 = {getplaydef(actor, VarCfg["U_剧情_阴阳八卦盘_阳"]),66}
    return { Condition4_1, Condition4_2 }
end
GetJQChildConditions[34] = function(actor)
    local Condition5_1 = checktitle(actor,"子时旧魂灯")
    local Condition5_2 = checktitle(actor,"丑时魄魂灯")
    local Condition5_3 = checktitle(actor,"寅时绕魂灯")
    local Condition5_4 = checktitle(actor,"卯时天魂灯")
    local Condition5_5 = checktitle(actor,"辰时泉魂灯")
    local Condition5_6 = checktitle(actor,"巳时寂魂灯")
    local Condition5_7 = checktitle(actor,"午时离魂灯")
    local Condition5_8 = checktitle(actor,"未时灵魂灯")
    local Condition5_9 = checktitle(actor,"申时鸣魂灯")
    local Condition5_10 = checktitle(actor,"酉时万魂灯")
    local Condition5_11 = checktitle(actor,"戌时幡魂灯")
    local Condition5_12 = checktitle(actor,"亥时言魂灯")
    if checktitle(actor, "冥魂引渡人") then
        Condition5_1 =  true
        Condition5_2 =  true
        Condition5_3 =  true
        Condition5_4 =  true
        Condition5_5 =  true
        Condition5_6 =  true
        Condition5_7 =  true
        Condition5_8 =  true
        Condition5_9 =  true
        Condition5_10 =  true
        Condition5_11 =  true
        Condition5_12 =  true
    end
    return { Condition5_1, Condition5_2, Condition5_3, Condition5_4, Condition5_5, Condition5_6, Condition5_7, Condition5_8, Condition5_9, Condition5_10, Condition5_11, Condition5_12 }
end
GetJQChildConditions[35] = function(actor)
    local Condition6_1 = getflagstatus(actor, VarCfg["F_剧情_鬼域灵器_标识1"]) == 1
    local Condition6_2 = getflagstatus(actor, VarCfg["F_剧情_鬼域灵器_标识2"]) == 1
    local Condition6_3 = getflagstatus(actor, VarCfg["F_剧情_鬼域灵器_标识3"]) == 1
    return {Condition6_1, Condition6_2, Condition6_3}
end
GetJQChildConditions[36] = function(actor)
    local Condition7_1 = getflagstatus(actor, VarCfg["F_剧情_亡灵之书1"]) == 1
    local Condition7_2 = getflagstatus(actor, VarCfg["F_剧情_亡灵之书2"]) == 1
    return {Condition7_1, Condition7_2}
end
GetJQChildConditions[37] = function(actor)
    local Condition8 = getflagstatus(actor, VarCfg["F_蛇巢禁地_完成"]) == 1
    return {Condition8}
end
GetJQChildConditions[38] = function(actor)
    local Condition9 = getflagstatus(actor, VarCfg["F_黑水秘技_完成"]) == 1
    return {Condition9}
end
GetJQChildConditions[39] = function(actor)
    local Condition10_1 = getflagstatus(actor, VarCfg["F_剧情_魔焰炼狱1"]) == 1
    local Condition10_2 = getflagstatus(actor, VarCfg["F_剧情_魔焰炼狱2"]) == 1
    local Condition10_3 = getflagstatus(actor, VarCfg["F_剧情_魔焰炼狱3"]) == 1
    local Condition10_4 = checktitle(actor, "魔焰掌控者")
    return {Condition10_1,Condition10_2,Condition10_3,Condition10_4}
end
GetJQChildConditions[40] = function(actor)
    local Condition11_1 = getplaydef(actor, VarCfg["U_地藏王的试炼"]) >= 1
    local Condition11_2 = getplaydef(actor, VarCfg["U_地藏王的试炼"]) >= 2
    local Condition11_3 = getplaydef(actor, VarCfg["U_地藏王的试炼"]) >= 3
    local Condition11_4 = getplaydef(actor, VarCfg["U_地藏王的试炼"]) >= 4
    local Condition11_5 = getplaydef(actor, VarCfg["U_地藏王的试炼"]) >= 5
    return {Condition11_1,Condition11_2,Condition11_3,Condition11_4,Condition11_5}
end
GetJQChildConditions[41] = function(actor)
    local Condition11 = getflagstatus(actor,VarCfg["F_锁魂幡_完成"]) == 1
    return {Condition11}
end
GetJQChildConditions[42] = function(actor)
    local Condition12 = getflagstatus(actor,VarCfg["F_六道轮回盘_完成"]) == 1
    return {Condition12}
end
--丹尘
GetJQChildConditions[43] = function(actor)
    local Condition1_1 = getflagstatus(actor, VarCfg["F_剧情_丹尘_可以炼丹"]) == 1
    local Condition1_2 = {getplaydef(actor, VarCfg["U_丹尘炼丹次数"]), 10}
    return { Condition1_1, Condition1_2 }
end
GetJQChildConditions[44] = function(actor)
    local Condition2_1 = getflagstatus(actor, VarCfg["F_剧情_风行者_解封1"]) == 1
    local Condition2_2 = getflagstatus(actor, VarCfg["F_剧情_风行者_解封2"]) == 1
    return { Condition2_1, Condition2_2 }
end
GetJQChildConditions[45] = function(actor)
    local Condition3 = getflagstatus(actor, VarCfg["F_召唤寒霜君主·塞林"]) == 1
    return { Condition3 }
end
GetJQChildConditions[46] = function(actor)
    local Condition4_1 = getflagstatus(actor, VarCfg["F_剧情_洪荒之力1"]) == 1
    local Condition4_2 = getflagstatus(actor, VarCfg["F_剧情_洪荒之力2"]) == 1
    local Condition4_3 = getflagstatus(actor, VarCfg["F_剧情_洪荒之力3"]) == 1
    return { Condition4_1, Condition4_2, Condition4_3 }
end
GetJQChildConditions[47] = function(actor)
    local Condition5_1 = getflagstatus(actor, VarCfg["F_剧情_洪荒之门开启"]) == 1
    local Condition5_2 = checktitle(actor, "五行灵体")
    return {Condition5_1, Condition5_2}
end
GetJQChildConditions[48] = function(actor)
    local Condition6_1 = getflagstatus(actor, VarCfg["F_剧情_哥布林的弱点1"]) == 1
    local Condition6_2 = getflagstatus(actor, VarCfg["F_剧情_哥布林的弱点2"]) == 1
    local Condition6_3 = getflagstatus(actor, VarCfg["F_剧情_哥布林的弱点3"]) == 1
    local Condition6_4 = getflagstatus(actor, VarCfg["F_剧情_哥布林的弱点4"]) == 1
    local Condition6_5 = getflagstatus(actor, VarCfg["F_剧情_哥布林的弱点5"]) == 1
    return { Condition6_1, Condition6_2, Condition6_3, Condition6_4, Condition6_5}
end
GetJQChildConditions[49] = function(actor)
    local Condition7 = {getplaydef(actor, VarCfg["U_解救少女_次数"]) ,3}
    return {Condition7}
end
GetJQChildConditions[50] = function(actor)
    local Condition8_1 = {getplaydef(actor,VarCfg["U_剧情_月光之尘_次数"]), 30}
    local Condition8_2 = {getplaydef(actor,VarCfg["U_剧情_幽夜精华_次数"]) ,10}
    return {Condition8_1, Condition8_2}
end
GetJQChildConditions[51] = function(actor)
    local Condition9 = {getplaydef(actor,VarCfg["U_剧情_一叶一菩提_次数"]),10}
    return {Condition9}
end
GetJQChildConditions[52] = function(actor)
    local Condition10_1 = getflagstatus(actor,VarCfg["F_剧情_灭世牢笼_解封地图"]) == 1
    local Condition10_2 = getflagstatus(actor,VarCfg["F_龙器灭世骸骨"]) == 1
    return {Condition10_1, Condition10_2}
end
GetJQChildConditions[53] = function(actor)
    local Condition11 = {getplaydef(actor,VarCfg["U_魔化天使_吞噬_层数"]), 2997}
    return {Condition11}
end
GetJQChildConditions[54] = function(actor)
    local Condition12 = getflagstatus(actor,VarCfg["F_大日如来神掌_学习"]) == 1
    return {Condition12}
end
--日耀终极者
GetJQChildConditions[55] = function(actor)
    local Condition1_1 = getflagstatus(actor, VarCfg["F_破除日耀_激活标识1"]) == 1
    local Condition1_2 = getflagstatus(actor, VarCfg["F_破除日耀_激活标识2"]) == 1
    local Condition1_3 = getflagstatus(actor, VarCfg["F_破除日耀_激活标识3"]) == 1
    local Condition1_4 = getflagstatus(actor, VarCfg["F_破除日耀_激活标识4"]) == 1
    local Condition1_5 = getflagstatus(actor, VarCfg["F_破除日耀_激活标识5"]) == 1
    return { Condition1_1, Condition1_2, Condition1_3, Condition1_4, Condition1_5 }
end
GetJQChildConditions[56] = function(actor)
    local Condition2 = {getplaydef(actor, VarCfg["U_炎魂碎片_提交数量"]), 10}
    return {Condition2}
end
GetJQChildConditions[57] = function(actor)
    local Condition3_1 = getflagstatus(actor, VarCfg["F_潮影钩矛合成"]) == 1
    local Condition3_2 = getflagstatus(actor, VarCfg["F_幽灵沉船_开启状态"]) == 1
    local Condition3_3 = getplaydef(actor, VarCfg["U_海灵之泪获取"]) >= 1
    return { Condition3_1, Condition3_2, Condition3_3 }
end
GetJQChildConditions[58] = function(actor)
    local Condition4 = getflagstatus(actor, VarCfg["F_冰魂结晶成功"]) == 1
    return {Condition4}
end
GetJQChildConditions[59] = function(actor)
    local Condition5_1 = {getplaydef(actor, VarCfg["U_悲魂圣火记录"]),10}
    local Condition5_2 = {getplaydef(actor, VarCfg["U_图腾圣火记录"]),10}
    local Condition5_3 = {getplaydef(actor, VarCfg["U_禁忌圣火记录"]),10}
    local Condition5_4 = {getplaydef(actor, VarCfg["U_迷失圣火记录"]),10}
    local Condition5_5 = getflagstatus(actor, VarCfg["F_圣火遗迹_领取状态"]) == 1
    return { Condition5_1, Condition5_2, Condition5_3, Condition5_4, Condition5_5 }
end
GetJQChildConditions[60] = function(actor)
    local Condition6_1 = getflagstatus(actor, VarCfg["F_六道魔域_激活标识"]) == 1
    local Condition6_2 = getflagstatus(actor, VarCfg["F_六道仙人唤醒"]) == 1
    -- local Condition6_3 = getflagstatus(actor, VarCfg["F_六道轮回尘掉落"]) == 1
    return { Condition6_1, Condition6_2 }
end
GetJQChildConditions[61] = function(actor)
    local Condition7_1 = getflagstatus(actor, VarCfg["F_神语的试炼_无尽愤怒"]) == 1
    local Condition7_2 = getflagstatus(actor, VarCfg["F_神语的试炼_血魔护臂MAX"]) == 1
    return { Condition7_1, Condition7_2 }
end
GetJQChildConditions[62] = function(actor)
    local Condition8_1 = getflagstatus(actor, VarCfg["F_哈法西斯之墓_进入"]) == 1
    local Condition8_2 = getflagstatus(actor, VarCfg["F_哈法西斯之墓完成一次"]) == 1
    return { Condition8_1, Condition8_2 }
end
GetJQChildConditions[63] = function(actor)
    local Condition9_1 = checktitle(actor,"死亡如风")
    local Condition9_2 = checktitle(actor,"死亡如风")
    return { Condition9_1, Condition9_2 }
    
end
GetJQChildConditions[64] = function(actor)
    local Condition10 = getflagstatus(actor, VarCfg["F_古地下遗迹_开启状态"]) == 1
    return {Condition10}
end
GetJQChildConditions[65] = function(actor)
    local Condition11_1 = getflagstatus(actor,VarCfg["F_深海恐惧·克拉肯_击杀"]) == 1
    local Condition11_2 = getflagstatus(actor,VarCfg["F_§§命运罗盘§§_获取"]) == 1
    return {Condition11_1, Condition11_2}
end
GetJQChildConditions[66] = function(actor)
    local Condition12 = getflagstatus(actor, VarCfg["F_破晓之眼_合成"]) == 1
    return {Condition12}
end
GetJQChildConditions[67] = function(actor)
    local t = Player.getJsonTableByVar(actor, VarCfg["T_永恒终点状态"])
    local Condition13_1 = getflagstatus(actor, VarCfg["F_永恒密道_开启状态"]) == 1
    local Condition13_2 = t["永恒"] == 1
    local Condition13_3 = t["时光"] == 1
    local Condition13_4 = t["虚空"] == 1
    return { Condition13_1, Condition13_2, Condition13_3 , Condition13_4}
end

GetJQChildConditions[68] = function(actor)
    local Condition1_1 = getflagstatus(actor,VarCfg["F_血色狂怒1"]) == 1
    local Condition1_2 = getflagstatus(actor,VarCfg["F_血色狂怒2"]) == 1
    return {Condition1_1, Condition1_2}
end
GetJQChildConditions[69] = function(actor)
    local Condition2_1 = getflagstatus(actor,VarCfg["F_时空轮盘位置1"]) == 1
    local Condition2_2 = getflagstatus(actor,VarCfg["F_时空轮盘位置2"]) == 1
    local Condition2_3 = getflagstatus(actor,VarCfg["F_时空轮盘位置3"]) == 1
    return {Condition2_1, Condition2_2, Condition2_3}
end
GetJQChildConditions[70] = function(actor)
    local Condition3_1 = getflagstatus(actor,VarCfg["F_重塑轮回1"]) == 1
    local Condition3_2 = getflagstatus(actor,VarCfg["F_重塑轮回2"]) == 1
    local Condition3_3 = getflagstatus(actor,VarCfg["F_重塑轮回3"]) == 1
    return {Condition3_1, Condition3_2, Condition3_3}
end
GetJQChildConditions[71] = function(actor)
    local Condition4_1 = getflagstatus(actor, VarCfg["F_完成任意龙魂烙印"]) == 1
    return {Condition4_1}
end
GetJQChildConditions[72] = function(actor)
    local Condition5_1 = getflagstatus(actor,VarCfg["F_死亡之堡底层开启状态"]) == 1
    local Condition5_2 = getflagstatus(actor,VarCfg["F_学习寂寞归墟"]) == 1
    return {Condition5_1, Condition5_2}
end
GetJQChildConditions[73] = function(actor)
    local Condition6_1 = getflagstatus(actor,VarCfg["F_腐化之种开启状态"]) == 1
    local Condition6_2 = getflagstatus(actor,VarCfg["F_腐化之种收获一次"]) == 1
    return {Condition6_1, Condition6_2}
end
GetJQChildConditions[74] = function(actor)
    local Condition7_1 = {getplaydef(actor, VarCfg["B_基因升级次数"]), 20}
    return {Condition7_1}
end
GetJQChildConditions[75] = function(actor)
    local data = CheckLevelIsTbl(actor)
    local Condition8_1 = {data["贪狼"], 50}
    local Condition8_2 = {data["巨门"], 50}
    local Condition8_3 = {data["禄存"], 50}
    local Condition8_4 = {data["武曲"], 50}
    local Condition8_5 = {data["破军"], 50}
    local Condition8_6 = {data["文曲"], 50}
    local Condition8_7 = {data["廉贞"], 50}
    local Condition8_8 = getflagstatus(actor,VarCfg["F_星辰变领取状态"]) == 1
    return { Condition8_1, Condition8_2, Condition8_3, Condition8_4, Condition8_5, Condition8_6, Condition8_7, Condition8_8}
end
return GetJQChildConditions

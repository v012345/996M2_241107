local GetJQMainConditions = {}

GetJQMainConditions[1] = function(actor)
    local Condition1 = getplaydef(actor, VarCfg["U_主线任务进度"]) > 6
    local Condition2 = getflagstatus(actor, VarCfg["F_老村长的怀表"]) == 1
    local Condition3 = getplaydef(actor, VarCfg.U_bian_guan_title) >= 9
    local Condition4 = getflagstatus(actor, VarCfg["F_空间法师"]) == 1
    return { Condition1, Condition2, Condition3, Condition4 }
end
-- 破旧尘
-- VarCfg["F_剧情_玄幽"] == 1
-- 湿婆神像
-- VarCfg["U_剧情_湿婆神像_进度"] >= 100
-- 元素之隙
-- VarCfg["F_剧情_元素之隙"]
-- 黑齿宝藏
-- VarCfg["U_剧情_黑齿宝藏_开启次数"] >= 1
-- 暗域裂隙
-- VarCfg["F_剧情_暗域裂隙"]
-- 封印祭坛
-- VarCfg["F_封印祭坛_完成"]
-- 死神棺椁
-- VarCfg["F_剧情_被封印的封印棺椁_是否领取1"] or VarCfg["F_剧情_被封印的封印棺椁_是否领取2"]
-- VarCfg["F_被封印的棺材使用_完成"]
--新月宝珠
-- getflagstatus(actor, VarCfg["F_新月宝珠_完成"]) == 1
-- 英灵殿（传说）
-- VarCfg["U_剧情_英灵祭坛_称号"] >= 10
-- 古龙的传承
-- VarCfg["U_剧情_古龙的传承"] >= 4
-- 剑灵之谜(传说)
-- VarCfg["U_剧情_剑灵传说"] >= 10
-- 12. 灭世领域（传说）
-- VarCfg["F_合成太虚古龙领域"] == 1
--天元通灵
GetJQMainConditions[2] = function(actor)
    local Condition1 = getflagstatus(actor, VarCfg["F_剧情_玄幽"]) == 1
    local Condition2 = checktitle(actor,"湿婆信徒")
    local Condition3 = getflagstatus(actor, VarCfg["F_剧情_元素之隙"]) == 1
    local Condition4 = getplaydef(actor, VarCfg["U_剧情_黑齿宝藏_开启次数"]) > 0
    local Condition5 = getflagstatus(actor, VarCfg["F_剧情_暗域裂隙"]) == 1
    local Condition6 = getflagstatus(actor, VarCfg["F_封印祭坛_完成"]) == 1
    local Condition7 = (getflagstatus(actor, VarCfg["F_剧情_被封印的封印棺椁_是否领取1"]) == 1 or getflagstatus(actor, VarCfg["F_剧情_被封印的封印棺椁_是否领取2"]) == 1) and
    getflagstatus(actor, VarCfg["F_被封印的棺材使用_完成"]) == 1
    local Condition8 = getflagstatus(actor, VarCfg["F_新月宝珠_完成"]) == 1
    -- local Condition9 = { getplaydef(actor, VarCfg["U_剧情_英灵祭坛_称号"]), 10 }
    -- local Condition10 = { getplaydef(actor, VarCfg["U_剧情_古龙的传承"]), 5 }
    -- local Condition11 = { getplaydef(actor, VarCfg["U_剧情_剑灵传说"]), 10 }
    -- local Condition12 = getflagstatus(actor, VarCfg["F_合成太虚古龙领域"]) == 1
    return { Condition1, Condition2, Condition3, Condition4, Condition5, Condition6, Condition7, Condition8 }
end

GetJQMainConditions[3] = function(actor)
    --1.心魔老人
    local Condition1 = getplaydef(actor, VarCfg["U_心魔老人挑战次数"]) >= 3
    --2.焚世祭
    local Condition2 = getplaydef(actor, VarCfg["U_二元归灵珠_数量"]) >= 2 and getplaydef(actor, VarCfg["U_上古魔龙召唤_数量"]) >= 3
    --3.雷鸣之力
    local Condition3 = getflagstatus(actor, VarCfg["F_剧情_雷鸣之力_1"]) == 1 and getflagstatus(actor, VarCfg["F_剧情_雷鸣之力_2"]) == 1 and getflagstatus(actor, VarCfg["F_剧情_雷鸣之力_3"]) == 1 and getflagstatus(actor, VarCfg["F_剧情_雷鸣之力_4"]) == 1
    -- 4.蛮荒血脉
    local Condition4 = getplaydef(actor, VarCfg["U_剧情_蛮荒血脉_觉醒次数"]) >= 10
    --5.沙暴传说
    local Condition5 = getflagstatus(actor, VarCfg["F_黄沙之灵_完成"]) == 1
    --6.域外战歌
    local Condition6 = getplaydef(actor, VarCfg["U_剧情_神龙侍卫_进度"]) >= 100
    -- 7.灵魂牢笼
    local Condition7 = getplaydef(actor,VarCfg["U_剧情_灵魂牢笼_次数"]) >= 10 and getflagstatus(actor,VarCfg["F_剧情_生死境界_地图开启"]) == 1
    --8.枯骨之魂
    local Condition8 = (getflagstatus(actor, VarCfg["F_剧情_一将功成万古枯1"]) == 1 and getflagstatus(actor, VarCfg["F_剧情_一将功成万古枯2"]) == 1 and getflagstatus(actor, VarCfg["F_剧情_一将功成万古枯3"]) == 1) or getflagstatus(actor,VarCfg["F_剧情_时装是否领取"]) == 1
    --9.妖月之灵
    local Condition9 = getplaydef(actor, VarCfg["U_归灵仪式召唤_数量"])  >= 10 and getflagstatus(actor,VarCfg["F_妖月九尾狐王击杀_完成"]) == 1
    --10.洞察之眼
    local Condition10 = getplaydef(actor, VarCfg["U_剧情_遗忘前线_杀怪数量"]) >= 1000 and getplaydef(actor, VarCfg["U_剧情_悲鸣哨塔_线索数量"]) >= 100 and checktitle(actor,"洞察之眼")
    return { Condition1, Condition2, Condition3, Condition4, Condition5, Condition6, Condition7, Condition8, Condition9, Condition10 }
end

GetJQMainConditions[4] = function(actor)
    local Condition1 = getflagstatus(actor, VarCfg["F_剧情_阎王大殿是否开启"]) == 1
    local Condition2 = getplaydef(actor, VarCfg["U_判官改名次数"]) >= 3
    local Condition3 = getflagstatus(actor,VarCfg["F_剧情_幽冥鬼使_地图开启"]) == 1
    local Condition4 = getplaydef(actor, VarCfg["U_剧情_阴阳八卦盘_阴"]) >= 66 and getplaydef(actor, VarCfg["U_剧情_阴阳八卦盘_阳"]) >= 66
    local Condition5 = checktitle(actor,"冥魂引渡人")
    local Condition6 = getflagstatus(actor, VarCfg["F_剧情_鬼域灵器_标识1"]) == 1 and getflagstatus(actor, VarCfg["F_剧情_鬼域灵器_标识2"]) == 1 and getflagstatus(actor, VarCfg["F_剧情_鬼域灵器_标识3"]) == 1
    local Condition7 = getflagstatus(actor, VarCfg["F_剧情_亡灵之书1"]) == 1 and getflagstatus(actor, VarCfg["F_剧情_亡灵之书2"]) == 1
    local Condition8 = getflagstatus(actor, VarCfg["F_蛇巢禁地_完成"]) == 1
    local Condition9 = getflagstatus(actor, VarCfg["F_黑水秘技_完成"]) == 1
    local Condition10 = checktitle(actor, "魔焰掌控者")
    return { Condition1, Condition2, Condition3, Condition4, Condition5, Condition6, Condition7, Condition8, Condition9, Condition10 }
end

GetJQMainConditions[5] = function(actor)
    local Condition1 = getflagstatus(actor, VarCfg["F_剧情_丹尘_可以炼丹"]) == 1 and getplaydef(actor, VarCfg["U_丹尘炼丹次数"]) >= 10
    local Condition2 = getflagstatus(actor, VarCfg["F_剧情_风行者_解封1"]) == 1 and getflagstatus(actor, VarCfg["F_剧情_风行者_解封2"]) == 1
    local Condition3 = getflagstatus(actor, VarCfg["F_召唤寒霜君主·塞林"]) == 1
    local Condition4 = getflagstatus(actor, VarCfg["F_剧情_洪荒之力1"]) == 1 and getflagstatus(actor, VarCfg["F_剧情_洪荒之力2"]) == 1 and getflagstatus(actor, VarCfg["F_剧情_洪荒之力3"]) == 1
    local Condition5 = getflagstatus(actor, VarCfg["F_剧情_洪荒之门开启"]) == 1 and checktitle(actor, "五行灵体")
    local Condition6 = getflagstatus(actor, VarCfg["F_剧情_哥布林的弱点1"]) == 1 and getflagstatus(actor, VarCfg["F_剧情_哥布林的弱点2"]) == 1 and getflagstatus(actor, VarCfg["F_剧情_哥布林的弱点3"]) == 1 and getflagstatus(actor, VarCfg["F_剧情_哥布林的弱点4"]) == 1 and getflagstatus(actor, VarCfg["F_剧情_哥布林的弱点5"]) == 1
    local Condition7 = getplaydef(actor, VarCfg["U_解救少女_次数"]) >= 3
    local Condition8 = getplaydef(actor,VarCfg["U_剧情_月光之尘_次数"]) >= 30 and getplaydef(actor,VarCfg["U_剧情_幽夜精华_次数"]) >= 10
    local Condition9 = getplaydef(actor,VarCfg["U_剧情_一叶一菩提_次数"]) >= 10
    local Condition10 = getflagstatus(actor,VarCfg["F_剧情_灭世牢笼_解封地图"]) == 1 and getflagstatus(actor, VarCfg["F_龙器灭世骸骨"]) == 1
    return { Condition1, Condition2, Condition3, Condition4, Condition5, Condition6, Condition7, Condition8, Condition9, Condition10 }
end

GetJQMainConditions[6] = function(actor)
    --破除日耀
    local Condition_1 = getflagstatus(actor, VarCfg["F_破除日耀_激活标识1"]) == 1 and getflagstatus(actor, VarCfg["F_破除日耀_激活标识2"]) == 1 and getflagstatus(actor, VarCfg["F_破除日耀_激活标识3"]) == 1 and getflagstatus(actor, VarCfg["F_破除日耀_激活标识4"]) == 1 and getflagstatus(actor, VarCfg["F_破除日耀_激活标识5"]) == 1
    --炽热山谷
    local Condition_2 = getplaydef(actor, VarCfg["U_炎魂碎片_提交数量"]) >= 10
    local Condition_3 = getflagstatus(actor, VarCfg["F_永恒密道_开启状态"]) == 1
    local Condition_4 = getflagstatus(actor, VarCfg["F_潮影钩矛合成"]) == 1 and getflagstatus(actor, VarCfg["F_幽灵沉船_开启状态"]) == 1 and getplaydef(actor, VarCfg["U_海灵之泪获取"]) >= 1
    local Condition_5 = getflagstatus(actor, VarCfg["F_冰魂结晶成功"]) == 1
    local Condition_6 = getplaydef(actor, VarCfg["U_悲魂圣火记录"]) >= 10 and getplaydef(actor, VarCfg["U_图腾圣火记录"]) >= 10 and getplaydef(actor, VarCfg["U_禁忌圣火记录"]) >= 10 and getplaydef(actor, VarCfg["U_迷失圣火记录"]) >= 10 and getflagstatus(actor, VarCfg["F_圣火遗迹_领取状态"]) == 1
    local Condition_7 = getflagstatus(actor, VarCfg["F_六道魔域_激活标识"]) == 1 and getflagstatus(actor, VarCfg["F_六道仙人唤醒"]) == 1
    local Condition_8 = getflagstatus(actor, VarCfg["F_神语的试炼_无尽愤怒"]) == 1 and getflagstatus(actor, VarCfg["F_神语的试炼_血魔护臂MAX"]) == 1
    local Condition_9 = getflagstatus(actor, VarCfg["F_哈法西斯之墓完成一次"]) == 1
    local Condition_10 = checktitle(actor,"死亡如风")
    return { Condition_1, Condition_2, Condition_3, Condition_4, Condition_5, Condition_6, Condition_7, Condition_8, Condition_9, Condition_10 }
end

GetJQMainConditions[7] = function(actor)
    local Condition_1 = getflagstatus(actor, VarCfg["F_血色狂怒1"]) == 1 and getflagstatus(actor, VarCfg["F_血色狂怒2"]) == 1
    local Condition_2 = getflagstatus(actor, VarCfg["F_时空轮盘位置1"]) == 1 and getflagstatus(actor, VarCfg["F_时空轮盘位置2"]) == 1 and getflagstatus(actor, VarCfg["F_时空轮盘位置3"]) == 1
    local Condition_3 = getflagstatus(actor, VarCfg["F_重塑轮回1"]) == 1 and getflagstatus(actor, VarCfg["F_重塑轮回2"]) == 1 and getflagstatus(actor, VarCfg["F_重塑轮回3"]) == 1
    local Condition_4 = getflagstatus(actor, VarCfg["F_完成任意龙魂烙印"]) == 1
    local Condition_5 = getflagstatus(actor, VarCfg["F_死亡之堡底层开启状态"]) == 1 and getflagstatus(actor, VarCfg["F_学习寂寞归墟"]) == 1
    local Condition_6 = getflagstatus(actor, VarCfg["F_腐化之种开启状态"]) == 1 and getflagstatus(actor, VarCfg["F_腐化之种收获一次"]) == 1
    local Condition_7 = getplaydef(actor, VarCfg["B_基因升级次数"]) >= 20
    local data = CheckLevelIsTbl(actor)
    local Condition_8 = data["贪狼"] >= 50 and data["巨门"] >= 50 and data["禄存"] >= 50 and data["武曲"] >= 50 and data["破军"] >= 50 and data["文曲"] >= 50 and data["廉贞"] >= 50 and getflagstatus(actor,VarCfg["F_星辰变领取状态"]) == 1
    return { Condition_1, Condition_2, Condition_3, Condition_4, Condition_5, Condition_6, Condition_7, Condition_8}
end

return GetJQMainConditions

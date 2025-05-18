local ssrResponseCfg = {
    yes                                         = 0,
    no                                          = 1,

    type9                                       = 9,

    not_level                                   = 100,      --等级不足
    not_level2                                  = 101,      --等级不足%d
    not_item                                    = 102,      --%s不足
    not_money                                   = 103,      --货币不足
    not_bag_num                                 = 104,      --背包空间不足
    unmet                                       = 105,      --未满足领取条件
    repeat_receive                              = 106,      --重复领取
    not_open                                    = 107,      --xx未开启
    repeat_buy                                  = 108,      --重复购买

    not_open_activity                           = 138,      --活动未开启

    --Demo2
    Demo2_full_level                            = 10000,      --转生等级已满
    Demo2_not_level                             = 10001,      --等级不足%d,转生失败

    --GemInlay
    GemInlay_set_fail                           = 40000,      --低于当前已镶嵌宝石等级，镶嵌失败

    --BaoWu
    BaoWu_full_level                            = 40100,      --宝物等级已满


    --test
    usercmdinfo1                                = 100001,    --开启异域挑战
    usercmdinfo2                                = 100002,    --关闭异域大战
}

local Chinese = {
    [ssrResponseCfg.not_level]                  = '{"Msg":"<font color=\'#ff0000\'>等级不足</font>","Type":9}',
    [ssrResponseCfg.not_level2]                 = '{"Msg":"<font color=\'#ff0000\'>等级不足%d</font>","Type":9}',
    [ssrResponseCfg.not_item]                   = '{"Msg":"<font color=\'#ff0000\'>%s不足</font>","Type":9}',
    [ssrResponseCfg.not_money]                  = '{"Msg":"<font color=\'#ff0000\'>货币不足</font>","Type":9}',
    [ssrResponseCfg.not_bag_num]                = '{"Msg":"<font color=\'#ff0000\'>背包容量不足，请清理背包</font>","Type":9}',
    [ssrResponseCfg.unmet]                      = '{"Msg":"<font color=\'#ff0000\'>未满足领取条件</font>","Type":9}',
    [ssrResponseCfg.repeat_receive]             = '{"Msg":"<font color=\'#ff0000\'>您已领取过奖品</font>","Type":9}',
    [ssrResponseCfg.not_open]                   = '{"Msg":"<font color=\'#ff0000\'>%s未开启</font>","Type":9}',
    [ssrResponseCfg.repeat_buy]                 = '{"Msg":"<font color=\'#ff0000\'>已购买该物品</font>","Type":9}',
    [ssrResponseCfg.not_open_activity]          = '{"Msg":"<font color=\'#ff0000\'>活动未开启</font>","Type":9}',
    --Demo2
    [ssrResponseCfg.Demo2_full_level]           = '{"Msg":"<font color=\'#ff0000\'>转生等级已满</font>","Type":9}',
    [ssrResponseCfg.Demo2_not_level]            = '{"Msg":"<font color=\'#ff0000\'>等级不足%d，转生失败</font>","Type":9}',

    --GemInlay
    [ssrResponseCfg.GemInlay_set_fail]          = '{"Msg":"<font color=\'#ff0000\'>低于当前已镶嵌宝石等级，镶嵌失败</font>","Type":9}',

    --BaoWu
    [ssrResponseCfg.BaoWu_full_level]           = '{"Msg":"<font color=\'#ff0000\'>宝物等级已满</font>","Type":9}',

   --test
    [ssrResponseCfg.usercmdinfo1]              = '{"Msg":"<font color=\'#ff0000\'>异域大战活动正在进行，必须先关闭</font>","Type":9}',
    [ssrResponseCfg.usercmdinfo2]              = '{"Msg":"<font color=\'#ff0000\'>异域大战活动未开启，无需关闭</font>","Type":9}',
}

function ssrResponseCfg.get(code, ...)
    return string.format(Chinese[code], ...)
end

return ssrResponseCfg
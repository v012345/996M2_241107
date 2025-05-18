local HaFaXiSiChengHao = {}
local config = include("QuestDiary/cfgcsv/cfg_HaFaXiSiChengHao.lua")     --配置
local CheckTitle = {"哈法西斯挑战者Lv1","哈法西斯挑战者Lv2", "哈法西斯挑战者Lv3", "哈法西斯挑战者Lv4", "哈法西斯挑战者Lv5"}
function HaFaXiSiChengHao.Request(actor)
    local CheckNum = 0
    for k, v in ipairs(CheckTitle) do
        if checktitle(actor, v) then
            CheckNum = k
            break
        end
    end
    local cfg = {}
    if CheckNum == 5  then
        Player.sendmsgEx(actor, "提示#251|:#255|你的|哈法西斯挑战者#249|已经达到|满级#249|...")
        return
    else
        cfg = config[CheckNum+1]
    end

    -- dump(cfg)
    local name, num = Player.checkItemNumByTable(actor, cfg.Cost)
    if name then
        Player.sendmsgEx(actor, string.format("提示#251|:#255|你的|%s#249|不足|%d#249|...", name, num))
        return
    end
    Player.takeItemByTable(actor, cfg.Cost, "哈法西斯挑战者扣除材料")

    --删除一编哈法西斯称号后添加
    for _, v in ipairs(CheckTitle) do
        deprivetitle(actor, v)
    end
    confertitle(actor, cfg.Title, 1)

    --同步一次前端界面
    Message.sendmsg(actor, ssrNetMsgCfg.HaFaXiSiChengHao_SyncResponse, 0, 0, 0, {})
end
--注册网络消息
Message.RegisterNetMsg(ssrNetMsgCfg.HaFaXiSiChengHao, HaFaXiSiChengHao)
return HaFaXiSiChengHao

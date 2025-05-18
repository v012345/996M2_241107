local DianDengRen = {}
local config = include("QuestDiary/cfgcsv/cfg_DianDengRen.lua")     --配置
-- -- local config = include("QuestDiary/cfgcsv/cfg_DianDengRen.lua")     --配置

function DianDengRen.Request(actor,npcID)
    -- release_print(npcID)

    local cfg = config[npcID]

    if not cfg then
        Player.sendmsgEx(actor,"参数错误!")
        return
    end

    if checktitle(actor, "冥魂引渡人") then
        Player.sendmsgEx(actor, "提示#251|:#255|对不起,你|全部点亮#249|十二盏冥灯...")
        return
    end

    if checktitle(actor, cfg.titleNmae) then
        Player.sendmsgEx(actor, "提示#251|:#255|对不起,你已点亮|".. cfg.titleNmae .."#249|请勿重复点亮...")
        return
    end 

    local name, num = Player.checkItemNumByTable(actor, cfg.cost)
    if name then
        Player.sendmsgEx(actor, string.format("提示#251|:#255|你的|%s#249|不足|%d#249|...", name, num))
        return
    end

    Player.takeItemByTable(actor, cfg.cost, "点灯人扣除材料")
    confertitle(actor, cfg.titleNmae, 1)
    messagebox(actor,"恭喜你点亮了["..cfg.titleNmae.."]")
    Message.sendmsg(actor, ssrNetMsgCfg.DianDengRen_SyncResponse, 0, 0, 0, nil)

    local num = 401
    for i = 1 , table.nums(config) do   
        if checktitle(actor, config[num].titleNmae) then
            num = num + 1
        else
            num = 401
            break
        end
    end

    if num == 413 then
        num = 401
        for i = 1, table.nums(config) do
            deprivetitle(actor, config[num].titleNmae)
            num = num + 1
        end
        confertitle(actor, "冥魂引渡人", 1)
        Player.sendmsgEx(actor, "提示#251|:#255|恭喜你,你全部点亮|十二盏冥灯#249|获得|冥魂引渡人#249|称号...")
    end
    Player.setAttList(actor, "爆率附加")
end

--注册网络消息
Message.RegisterNetMsg(ssrNetMsgCfg.DianDengRen, DianDengRen)

return DianDengRen

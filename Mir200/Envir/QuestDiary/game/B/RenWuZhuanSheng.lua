local RenWuZhuanSheng = {}
local config = include("QuestDiary/cfgcsv/cfg_RenewLevelData.lua")
local RenewLevel_data = { [205]= 1, [310]= 2, [426]= 4, [518]= 5, [625]= 6, [711]= 7, [801]= 8}
local FaBaoNum = {["七宝玲珑塔"] = 1,["乾坤八卦盘"] = 2,["九宫龙皇钟"] = 3,["十方天帝印"] = 4,["神威破魔令"] = 5,["至尊仙王盾"] = 6,["超凡圣灵石"] = 7,["出尘穿云梭"] = 8,["凌绝天音铃"] = 9,["惊世霹雳环"] = 10,["御空翔云翎"] = 11,["混天八卦炉"] = 12,["雏凤呼风盏"] = 13,["潜龙阴阳石"] = 14}

function RenWuZhuanSheng.Request(actor, npcID)
    if not FCheckNPCRange(actor, npcID, 15) then
        Player.sendmsgEx(actor, "距离PNC太远!#249")
        return
    end
    local NowRenewLevel = getbaseinfo(actor,ConstCfg.gbase.renew_level)
    if npcID == 310 then
        if NowRenewLevel >= RenewLevel_data[npcID] + 1 then   --这是三大陆的转生
            Player.sendmsgEx(actor, "提示#251|:#255|对不起,转生|失败#249|,请前往更高等级大陆提升...")
            return
        end
    else
        if NowRenewLevel >= RenewLevel_data[npcID] then
            Player.sendmsgEx(actor, "提示#251|:#255|当前大陆|已升满#249|,请前往更高大陆...")
            return
        end
    end
    local cfg = config[NowRenewLevel+1]  --读取当前转生配置
    --检测是否达到等级
    local MyLevel = getbaseinfo(actor,ConstCfg.gbase.level)
    if MyLevel < cfg.Level then
        Player.sendmsgEx(actor, "提示#251|:#255|对不起,你的等级不足|".. cfg.Level .."级#249|,转生失败...")
        return
    end
    --检测法宝是否达到等级
    local FaBaoName = getconst(actor,"<$SBUJUK>")
    local MyFaBao = FaBaoNum[FaBaoName] == nil and 0 or FaBaoNum[FaBaoName]
    local CheckFaBao = FaBaoNum[cfg.Equip]
    if MyFaBao < CheckFaBao then
        Player.sendmsgEx(actor, "提示#251|:#255|对不起,你的法宝还未达到|".. cfg.Equip .."#249|,转生失败...")
        return
    end
    --检测攻击力是否达到要求
    local MyMaxDC = getbaseinfo(actor,ConstCfg.gbase.dc2)
    if MyMaxDC < cfg.MaxDC - 20000 then
        Player.sendmsgEx(actor, "提示#251|:#255|对不起,你的攻击力还未达到|".. cfg.MaxDC .."#249|,转生失败...")
        return
    end

    --检测血量是否达到要求
    local MyMaxHP = getbaseinfo(actor,ConstCfg.gbase.maxhp)
    if MyMaxHP < cfg.MaxHP - 1000000 then
        Player.sendmsgEx(actor, "提示#251|:#255|对不起,你的血量还未达到|".. cfg.MaxHP .."#249|,转生失败...")
        return
    end

    --检测气运是否达到数量
    local unLockData = TianMing.GetLockState(actor)
    local MyQiYunNum = 0
    for i = 13, #unLockData do
        if unLockData[i] == 1 then
            MyQiYunNum = MyQiYunNum + 1
        end
    end
    if MyQiYunNum < cfg.QiYun then
        Player.sendmsgEx(actor, "提示#251|:#255|对不起,你的后天气运开启不足|".. cfg.QiYun .."条#249|,转生失败...")
        return
    end
    --检测材料是否足够
    local name, num = Player.checkItemNumByTable(actor, cfg.Cost)
    if name then
        Player.sendmsgEx(actor, string.format("[提示]:#251|你的#250|%s#249|不足#250|%s#249|个", name, num))
        return
    end
    Player.takeItemByTable(actor, cfg.Cost, "转生扣除材料"..NowRenewLevel)

    --执行转生1次
    renewlevel(actor, 1, MyLevel - cfg.DecLevel, 0)

    local NewRenewLevel = getbaseinfo(actor,ConstCfg.gbase.renew_level)
    Player.sendmsgEx(actor, "提示#251|:#255|恭喜你,转生成功,当前|".. NewRenewLevel .."#249|转...")

    --增加修仙值
    if cfg.IncXiuxian > 0 then
        XiuXian.addXiuXian(actor, cfg.IncXiuxian)
    end

    --增加等级
    if cfg.IncLevel > 0 then
        changelevel(actor, "+", cfg.IncLevel)
    end

    if NewRenewLevel >= 4 then
        Player.setAttList(actor, "倍攻附加")
    end
    Player.setAttList(actor, "属性附加")

    -- 转生后事件派发
    GameEvent.push(EventCfg.onRenewlevelUP,actor,NewRenewLevel)
    RenWuZhuanSheng.SyncResponse(actor)
end

--属性附近
local function _onCalcAttr(actor, attrs)
    local shuxing = {}
    local RenewLevel = getbaseinfo(actor,ConstCfg.gbase.renew_level)
    if RenewLevel == 0  then return end
    local cfg = config[RenewLevel]
    if cfg then
        for _, v in ipairs(cfg.Attr) do
            shuxing[v[1]] = v[2]
        end
        calcAtts(attrs, shuxing, "转生属性附加")
    end
end
GameEvent.add(EventCfg.onCalcAttr, _onCalcAttr, RenWuZhuanSheng)


--------------网络消息-------------
function RenWuZhuanSheng.SyncResponse(actor)
    Message.sendmsg(actor, ssrNetMsgCfg.RenWuZhuanSheng_SyncResponse)
end

--注册网络消息
Message.RegisterNetMsg(ssrNetMsgCfg.RenWuZhuanSheng, RenWuZhuanSheng)

return RenWuZhuanSheng



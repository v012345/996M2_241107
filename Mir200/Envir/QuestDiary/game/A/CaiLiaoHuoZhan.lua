
local CaiLiaoHuoZhan = {}
local config = include("QuestDiary/cfgcsv/cfg_CaiLiaoHuoZhan.lua") --不可被记录地图
function CaiLiaoHuoZhan.Request(actor,var)
    local J104 = getplaydef(actor, VarCfg["J_材料货栈提取次数"] )
    local BuyNumUL = 0
    if checktitle(actor, "牛马特权") then BuyNumUL = BuyNumUL + 2 end
    if checktitle(actor, "打工皇帝") then BuyNumUL = BuyNumUL + 5 end
    if checktitle(actor, "至尊玩家") then BuyNumUL = BuyNumUL + 20 end

    if J104 >= BuyNumUL then
        Player.sendmsgEx(actor, "提示#251|:#255|对不起,你今天|没有提取次数#249|了,请明天再来...")
        return
    end

    local cfg = config[var]
    if not cfg then
        Player.sendmsgEx(actor, "提示#251|:#255|参数错误,请重试...")
        return
    end
    local cost = cfg.cost
    local name, num = Player.checkItemNumByTable(actor, cost)
    if name then
        Player.sendmsgEx(actor, string.format("提示#251|:#255|对不起,你的|%s#249|不足|%d#249|,提取失败...", name, num))
        return
    end
    Player.takeItemByTable(actor, cost, "材料货栈提取")
    Player.giveItemByTable(actor, cfg.give, "材料货栈提取")
    J104 = J104 + 1
    setplaydef(actor, VarCfg["J_材料货栈提取次数"], J104)
    CaiLiaoHuoZhan.SyncResponse(actor)
end


--注册网络消息
function CaiLiaoHuoZhan.SyncResponse(actor, logindatas)
    local J104 = getplaydef(actor, VarCfg["J_材料货栈提取次数"] )
    local BuyNumUL = 0
    if checktitle(actor, "牛马特权") then BuyNumUL = BuyNumUL + 2 end
    if checktitle(actor, "打工皇帝") then BuyNumUL = BuyNumUL + 5 end
    if checktitle(actor, "至尊玩家") then BuyNumUL = BuyNumUL + 20 end
    local data = { J104, BuyNumUL}
    local _login_data = { ssrNetMsgCfg.CaiLiaoHuoZhan_SyncResponse, 0, 0, 0, data }
    if logindatas then
        table.insert(logindatas, _login_data)
    else
        Message.sendmsg(actor, ssrNetMsgCfg.CaiLiaoHuoZhan_SyncResponse, 0, 0, 0, data)
    end
end
Message.RegisterNetMsg(ssrNetMsgCfg.CaiLiaoHuoZhan, CaiLiaoHuoZhan)

--登录触发
local function _onLoginEnd(actor, logindatas)
    CaiLiaoHuoZhan.SyncResponse(actor, logindatas)
end
GameEvent.add(EventCfg.onLoginEnd, _onLoginEnd, CaiLiaoHuoZhan)

return CaiLiaoHuoZhan

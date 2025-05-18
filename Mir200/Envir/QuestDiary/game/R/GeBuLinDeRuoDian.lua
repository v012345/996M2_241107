local GeBuLinDeRuoDian = {}
GeBuLinDeRuoDian.ID = "哥布林的弱点"
local npcID = 512
local config = include("QuestDiary/cfgcsv/cfg_GeBuLinDeRuoDian.lua") --配置
local give = { { "※雪舞※[装扮时装]", 1 } }
--接收请求
function GeBuLinDeRuoDian.Request1(actor, index)
    local cfg = config[index]
    if not cfg then
        Player.sendmsgEx(actor, "参数错误!#249")
        return
    end
    if getflagstatus(actor, cfg.flag) == 1 then
        Player.sendmsgEx(actor, "你已经提交过了!#249")
        return
    end
    local cost = cfg.cost
    local name, num = Player.checkItemNumByTable(actor, cost)
    if name then
        Player.sendmsgEx(actor, string.format("你的|%s#249|不足|%d#249", name, num))
        return
    end
    Player.takeItemByTable(actor, cost, "哥布林的弱点")
    Player.sendmsgEx(actor, "提交成功!")
    setflagstatus(actor, cfg.flag, 1)
    GeBuLinDeRuoDian.SyncResponse(actor)
end

--接收请求
function GeBuLinDeRuoDian.Request2(actor)
    if getflagstatus(actor,VarCfg["F_剧情_哥布林的弱点_是否全部提交"]) == 1 then
        Player.sendmsgEx(actor, "你已经领取过了!#249")
        return
    end
    local result = true
    for index, value in ipairs(config) do
        if getflagstatus(actor, value.flag) == 0 then
            result = false
            break
        end
    end
    if result then
        Player.giveItemByTable(actor, give, "哥布林的弱点", 1, true)
        -- setflagstatus(actor,VarCfg["F_剧情_哥布林的弱点_是否全部提交"],1)
        FSetTaskRedPoint(actor, VarCfg["F_剧情_哥布林的弱点_是否全部提交"], 47)
        Player.sendmsgEx(actor, "恭喜你获得:|※雪舞※[装扮时装]#249|请双击使用")
    else
        Player.sendmsgEx(actor, "你没有提交全部!#249")
    end
end

--同步消息
function GeBuLinDeRuoDian.SyncResponse(actor, logindatas)
    local data = {}
    local flag = getflagstatus(actor,VarCfg["F_剧情_哥布林的弱点_是否全部提交"])
    for index, value in ipairs(config) do
        data[index] = getflagstatus(actor, value.flag)
    end
    local _login_data = { ssrNetMsgCfg.GeBuLinDeRuoDian_SyncResponse, flag, 0, 0, data }
    if logindatas then
        table.insert(logindatas, _login_data)
    else
        Message.sendmsg(actor, ssrNetMsgCfg.GeBuLinDeRuoDian_SyncResponse, flag, 0, 0, data)
    end
end

--登录触发
local function _onLoginEnd(actor, logindatas)
    GeBuLinDeRuoDian.SyncResponse(actor, logindatas)
end
--事件派发
GameEvent.add(EventCfg.onLoginEnd, _onLoginEnd, GeBuLinDeRuoDian)
--注册网络消息
Message.RegisterNetMsg(ssrNetMsgCfg.GeBuLinDeRuoDian, GeBuLinDeRuoDian)
return GeBuLinDeRuoDian

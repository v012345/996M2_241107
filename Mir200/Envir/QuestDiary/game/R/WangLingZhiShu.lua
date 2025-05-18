local WangLingZhiShu = {}
WangLingZhiShu.ID = "亡灵之书"
local npcID = 454
local config = include("QuestDiary/cfgcsv/cfg_WangLingZhiShu.lua") --配置
--接收请求
function WangLingZhiShu.Request1(actor, index)
    local cfg = config[index]
    if not cfg then
        Player.sendmsgEx(actor,"参数错误!#249")
        return
    end
    if getflagstatus(actor,cfg.flag) == 1 then
        Player.sendmsgEx(actor,"你已经提交过了!#249")
        return
    end
    local cost = cfg.cost
    local name, num = Player.checkItemNumByTable(actor, cost)
    if name then
        Player.sendmsgEx(actor, string.format("你的|%s#249|不足|%d#249", name, num))
        return
    end
    Player.takeItemByTable(actor, cost, "亡灵之书")
    Player.sendmsgEx(actor,"提交成功!")
    setflagstatus(actor,cfg.flag,1)
    Player.setAttList(actor,"属性附加")
    WangLingZhiShu.SyncResponse(actor)
end
--接收请求
function WangLingZhiShu.Request2(actor)
    if checktitle(actor,"从小爱学习") then
        Player.sendmsgEx(actor,"你已经拥有了改称号!#249")
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
        confertitle(actor,"从小爱学习")
        Player.sendmsgEx(actor,"恭喜你获得称号:|从小爱学习#249")
    else
        Player.sendmsgEx(actor,"你没有提交全部!#249")
    end
end
--同步消息
function WangLingZhiShu.SyncResponse(actor, logindatas)
    local data = {}
    for index, value in ipairs(config) do
        data[index] = getflagstatus(actor, value.flag)
    end
    local _login_data = {ssrNetMsgCfg.WangLingZhiShu_SyncResponse, 0, 0, 0, data}
    if logindatas then
        table.insert(logindatas, _login_data)
    else
        Message.sendmsg(actor, ssrNetMsgCfg.WangLingZhiShu_SyncResponse, 0, 0, 0, data)
    end
end
--登录触发
local function _onLoginEnd(actor, logindatas)
    WangLingZhiShu.SyncResponse(actor, logindatas)
end
--事件派发
GameEvent.add(EventCfg.onLoginEnd, _onLoginEnd, WangLingZhiShu)


local function _onCalcAttr(actor, attrs)
    local shuxing = {}
    for index, value in ipairs(config) do
        if getflagstatus(actor, value.flag) == 1 then
            for _, v in ipairs(value.attrs or {}) do
                if shuxing[v[1]] then
                    shuxing[v[1]] = shuxing[v[1]] + v[2]
                else
                    shuxing[v[1]] = v[2]
                end
            end
        end
    end
    calcAtts(attrs, shuxing, "亡灵之书")
end
--属性
GameEvent.add(EventCfg.onCalcAttr, _onCalcAttr, WangLingZhiShu)

local function _onAttackDamagePlayer(actor, Target, Hiter, MagicId, Damage, Model, attackDamageData)
    if checktitle(actor,"从小爱学习") then
        if not checktitle(actor,"从小爱学习") then
            attackDamageData.damage = attackDamageData.damage + math.ceil(Damage * 0.5)
        end
    end
end
GameEvent.add(EventCfg.onAttackDamagePlayer, _onAttackDamagePlayer, WangLingZhiShu)

--注册网络消息
Message.RegisterNetMsg(ssrNetMsgCfg.WangLingZhiShu, WangLingZhiShu)
return WangLingZhiShu
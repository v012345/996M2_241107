local FengXingZhe = {}
FengXingZhe.ID = "风行者"
local npcID = 507
local config = include("QuestDiary/cfgcsv/cfg_FengXingZhe.lua") --配置
--接收请求
function FengXingZhe.Request1(actor,index)
    if not FCheckNPCRange(actor, npcID, 15) then
        Player.sendmsgEx(actor, "距离PNC太远!#249")
        return
    end
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
    Player.takeItemByTable(actor, cost, "风行者")
    Player.sendmsgEx(actor,"提交成功!")
    setflagstatus(actor,cfg.flag,1)
    Player.setAttList(actor,"属性附加")
    FengXingZhe.SyncResponse(actor)
end
--接收请求
function FengXingZhe.Request2(actor)
    if checktitle(actor,"风行者") then
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
        confertitle(actor,"风行者")
        GameEvent.push(EventCfg.onGetTaskTitle, actor, "风行者") --任务触发
        --给永久buff
        addbuff(actor,31033)
        Player.sendmsgEx(actor,"恭喜你获得称号:|风行者#249")
        --给装扮
        ZhuangBan.AddFashionToVar(actor, 12200, VarCfg["T_足迹记录"])
        ZhuangBan.SetCurrFashion(actor, 12200)
        Player.setAttList(actor,"属性附加")
    else
        Player.sendmsgEx(actor,"你没有提交全部!#249")
    end
    FengXingZhe.SyncResponse(actor)
end
--同步消息
function FengXingZhe.SyncResponse(actor, logindatas)
    local data = {}
    for index, value in ipairs(config) do
        data[index] = getflagstatus(actor, value.flag)
    end
    local _login_data = {ssrNetMsgCfg.FengXingZhe_SyncResponse, 0, 0, 0, data}
    if logindatas then
        table.insert(logindatas, _login_data)
    else
        Message.sendmsg(actor, ssrNetMsgCfg.FengXingZhe_SyncResponse, 0, 0, 0, data)
    end
end
--登录触发
local function _onLoginEnd(actor, logindatas)
    FengXingZhe.SyncResponse(actor, logindatas)
end
--事件派发
GameEvent.add(EventCfg.onLoginEnd, _onLoginEnd, FengXingZhe)

local function _onCalcAttr(actor, attrs)
    local shuxing = {}
    for _, value in ipairs(config) do
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
    calcAtts(attrs, shuxing, "风行者")
end
--属性
GameEvent.add(EventCfg.onCalcAttr, _onCalcAttr, FengXingZhe)

--注册网络消息
Message.RegisterNetMsg(ssrNetMsgCfg.FengXingZhe, FengXingZhe)
return FengXingZhe
local YongHengHuiJi = {}
YongHengHuiJi.ID = "永恒徽记"
local npcID = 332
local config = include("QuestDiary/cfgcsv/cfg_YongHengHuiJi.lua") --配置
--判断称号是否可以领取
local function isClaimable(actor)
    local result = true
    for index, value in ipairs(config) do
        local num = getplaydef(actor, value.var)
        if num < 3 then
            result = false
            break
        end
    end
    return result
end
--接收请求
function YongHengHuiJi.Request1(actor, index)
    local cfg = config[index]
    if not cfg then
        Player.sendmsgEx(actor, "参数错误!#249")
        return
    end
    if checktitle(actor,"追逐永恒之路") then
        Player.sendmsgEx(actor, "最多只能提交三次#249")
        return
    end
    local count = getplaydef(actor, cfg.var)
    if count >= 3 then
        Player.sendmsgEx(actor, "最多只能提交三次!#249")
        return
    end
    local cost = cfg.cost
    local name, num = Player.checkItemNumByTable(actor, cost)
    if name then
        Player.sendmsgEx(actor, string.format("提交失败,你的|%s#249|不足|%d#249", name, num))
        return
    end
    Player.takeItemByTable(actor, cost, "永恒徽记")
    setplaydef(actor, cfg.var, count + 1)
    Player.sendmsgEx(actor, string.format("成功提交[%s]#249", cfg.cost[1][1]))
    Player.setAttList(actor, "属性附加")
    YongHengHuiJi.SyncResponse(actor)

end

function YongHengHuiJi.Request2(actor)
    local boolean = isClaimable(actor)
    if not boolean then
        Player.sendmsgEx(actor, "每个徽记提交3次,才可以领取称号#249")
        return
    end
    if checktitle(actor,"追逐永恒之路") then
        Player.sendmsgEx(actor, "你已经拥有了改称号#249")
        return
    end
    confertitle(actor, "追逐永恒之路")
    Player.sendmsgEx(actor, "恭喜你获得称号|追逐永恒之路#249")
    YongHengHuiJi.SyncResponse(actor)
    Player.setAttList(actor, "属性附加")
    Player.setAttList(actor, "爆率附加")
end

--同步消息
function YongHengHuiJi.SyncResponse(actor, logindatas)
    local data = {}
    for index, value in ipairs(config) do
        table.insert(data, getplaydef(actor, value.var))
    end
    local _login_data = { ssrNetMsgCfg.YongHengHuiJi_SyncResponse, 0, 0, 0, data }
    if logindatas then
        table.insert(logindatas, _login_data)
    else
        Message.sendmsg(actor, ssrNetMsgCfg.YongHengHuiJi_SyncResponse, 0, 0, 0, data)
    end
end

--登录触发
local function _onLoginEnd(actor, logindatas)
    YongHengHuiJi.SyncResponse(actor, logindatas)
end
--事件派发
GameEvent.add(EventCfg.onLoginEnd, _onLoginEnd, YongHengHuiJi)

--属性附加
local function _onCalcAttr(actor, attrs)
    if checktitle(actor,"追逐永恒之路") then
        return
    end
    local shuxing = {
    }
    for index, value in ipairs(config) do
        local num = getplaydef(actor, value.var)
        if num > 0 then
            for i, v in ipairs(value.attrs) do
                shuxing[v[1]] = v[2] * num
            end
        end
    end
    calcAtts(attrs, shuxing, "永恒徽记")
end
GameEvent.add(EventCfg.onCalcAttr, _onCalcAttr, YongHengHuiJi)

--注册网络消息
Message.RegisterNetMsg(ssrNetMsgCfg.YongHengHuiJi, YongHengHuiJi)
return YongHengHuiJi

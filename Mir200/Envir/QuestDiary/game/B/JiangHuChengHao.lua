local JiangHuChengHao = {}
local config = include("QuestDiary/cfgcsv/cfg_JiangHuChengHao.lua") --洗练

local function delAllTitle(actor)
    for index, value in ipairs(config) do
        deprivetitle(actor, value.title)
    end
end

function JiangHuChengHao.Request(actor)
    local currIndex = getplaydef(actor, VarCfg["U_江湖称号"])
    local index = currIndex + 1
    local cfg = config[index]
    if not cfg then
        Player.sendmsgEx(actor, "[提示]:#251|你的称号已经满级了#249")
        return
    end
    local name, num = Player.checkItemNumByTable(actor, cfg.cost)
    if name then
        Player.sendmsgEx(actor, string.format("[提示]:#251|你的|%s#249|不足|%d#249", name, num))
        return
    end
    local currDaLu = getplaydef(actor,VarCfg["U_记录大陆"])
    if currDaLu < cfg.dalu then
        local chinaNumber = formatNumberToChinese(cfg.dalu)
        Player.sendmsgEx(actor, string.format("解锁|%s大陆#249|后才能继续提升!", chinaNumber))
        return
    end
    Player.takeItemByTable(actor, cfg.cost, "江湖称号升级")
    delAllTitle(actor) --全部删除一次防止删不掉
    confertitle(actor, cfg.title, 1)
    GameEvent.push(EventCfg.onGetTaskTitle, actor, cfg.title) --任务触发
    --升级称号触发
    GameEvent.push(EventCfg.onJiangHuTitleUP, actor, cfg.title)

    setplaydef(actor, VarCfg["U_江湖称号"], index)
    Player.setAttList(actor, "爆率附加")
    Player.setAttList(actor, "属性附加")
    --同步一次消息
    JiangHuChengHao.SyncResponse(actor)
end

-------------网络消息↓↓↓--------------------------
Message.RegisterNetMsg(ssrNetMsgCfg.JiangHuChengHao, JiangHuChengHao)
function JiangHuChengHao.SyncResponse(actor, logindatas)
    local count = getplaydef(actor, VarCfg["U_江湖称号"])
    local _login_data = { ssrNetMsgCfg.JiangHuChengHao_SyncResponse, count }
    if logindatas then
        table.insert(logindatas, _login_data)
    else
        Message.sendmsg(actor, ssrNetMsgCfg.JiangHuChengHao_SyncResponse, count)
    end
end

--登录触发
local function _onLoginEnd(actor, logindatas)
    JiangHuChengHao.SyncResponse(actor, logindatas)
end
--事件派发
GameEvent.add(EventCfg.onLoginEnd, _onLoginEnd, JiangHuChengHao)

return JiangHuChengHao

local GuiYuLingQi = {}
GuiYuLingQi.ID = "鬼域灵器"
local npcID = 450
local config = include("QuestDiary/cfgcsv/cfg_GuiYuLingQi.lua") --配置
local abilGroup = 1
--接收请求
function GuiYuLingQi.Request(actor, index)
    local cfg = config[index]
    if not cfg then
        Player.sendmsgEx(actor, "参数错误")
        return
    end
    local itemobj = linkbodyitem(actor, 43)
    if itemobj == "0" then
        Player.sendmsgEx(actor, "提交失败,你没有穿戴修仙法器!")
        return
    end
    local cost = cfg.cost
    if getflagstatus(actor, cfg.flag) == 1 then
        Player.sendmsgEx(actor, "你已经提交过了!#249")
        return
    end
    local name, num = Player.checkItemNumByTable(actor, cost)
    if name then
        Player.sendmsgEx(actor, string.format("你的|%s#249|不足|%d#249", name, num))
        return
    end
    Player.takeItemByTable(actor, cost, "鬼域灵器剧情")
    setflagstatus(actor, cfg.flag, 1)
    if cfg.flag == 109 or cfg.flag == 111 then
        local taskPanelID = getplaydef(actor, VarCfg["U_主线任务面板进度"])
        if taskPanelID == 33 then
            FCheckTaskRedPoint(actor)
        end
    end

    --添加属性
    changecustomitemtext(actor, itemobj, "<IMG:res/tips/5.png>", abilGroup)
    Player.addModifyCustomAttributes(actor, itemobj, abilGroup, index, 1, 250, cfg.attr[1], 0, cfg.attrIsPer, cfg.attr[2])

    Player.sendmsgEx(actor, "提交成功!")
    GuiYuLingQi.SyncResponse(actor)
end

--穿装备
local function _onTakeOn43(actor, itemobj)
    for index, cfg in ipairs(config) do
        if getflagstatus(actor,cfg.flag) == 1 then
            changecustomitemtext(actor, itemobj, "<IMG:res/tips/5.png>", abilGroup)
            Player.addModifyCustomAttributes(actor, itemobj, abilGroup, index, 1, 250, cfg.attr[1], 0, cfg.attrIsPer, cfg.attr[2])
        end
    end
end
GameEvent.add(EventCfg.onTakeOn43, _onTakeOn43, GuiYuLingQi)

--同步消息
function GuiYuLingQi.SyncResponse(actor, logindatas)
    local data = {}
    for index, value in ipairs(config) do
        data[index] = getflagstatus(actor, value.flag)
    end
    local _login_data = { ssrNetMsgCfg.GuiYuLingQi_SyncResponse, 0, 0, 0, data }
    if logindatas then
        table.insert(logindatas, _login_data)
    else
        Message.sendmsg(actor, ssrNetMsgCfg.GuiYuLingQi_SyncResponse, 0, 0, 0, data)
    end
end

--登录触发
local function _onLoginEnd(actor, logindatas)
    GuiYuLingQi.SyncResponse(actor, logindatas)
end
--事件派发
GameEvent.add(EventCfg.onLoginEnd, _onLoginEnd, GuiYuLingQi)
--注册网络消息
Message.RegisterNetMsg(ssrNetMsgCfg.GuiYuLingQi, GuiYuLingQi)
return GuiYuLingQi

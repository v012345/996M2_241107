TopIcon = {}
local IconTable = {}
local config = include("QuestDiary/cfgcsv/cfg_top_icon.lua") --图标配置
--添加头部图标
function TopIcon.addico(actor)
    IconTable = {}
    for index, value in ipairs(config) do
        if value.otherType == 1 then
            table.insert(IconTable, value.id)
        elseif value.otherType == 2 then --检测称号
            if not checktitle(actor,value.check) then
                table.insert(IconTable, value.id)
            end
        elseif value.otherType == 3 then --检测标识
            if getflagstatus(actor,value.check) == 0 then
                table.insert(IconTable, value.id)
            end
        elseif value.otherType == 4 then --检测标识
            -- table.insert(IconTable, value.id)
            local heQuDay = tonumber(getconst("0", "<$HFCOUNT>"))
            if heQuDay > 0 then
                table.insert(IconTable, value.id)
            end
        end
    end

    TopIcon.SyncResponse(actor)
    --添加背包
    local client_flag = getconst(actor, "<$CLIENTFLAG>")
    if client_flag == "1" then
        addbutton(actor, 104, 1,
            "<Button|tips=人物背包(F9)|id=10086|x=-122.0|y=-178.0|width=30|height=30|pimg=private/main-win32/00000061.png|nimg=private/main-win32/00000060.png|size=16|color=251|link=@openbag>")
        addbutton(actor, 104, 2,
            "<Button|tips=状态信息(F10)|id=1000|x=-167.0|y=-169.0|width=30|height=30|pimg=private/main-win32/00000059.png|nimg=private/main-win32/00000058.png|size=16|color=251|link=@openplayer>")
        setpickitemtobag(actor, 104, 10086)
    else
        setpickitemtobag(actor, 107, 10086)
    end
end

--------------------登录触发-----------------------------
local function _onLogin(actor)
    TopIcon.addico(actor)
end
GameEvent.add(EventCfg.onLogin, _onLogin, TopIcon)
-----------------------网络消息--------------------------
--注册网络消息
Message.RegisterNetMsg(ssrNetMsgCfg.TopIcon, TopIcon)

function TopIcon.SyncResponse(actor, logindatas)
    local data = {}
    table.insert(data, IconTable)
    -- dump(IconTable)
    local _login_data = {ssrNetMsgCfg.TopIcon_SyncResponse, 0, 0, 0, data}
    if logindatas then
        table.insert(logindatas, _login_data)
    else
        Message.sendmsg(actor, ssrNetMsgCfg.TopIcon_SyncResponse, 0, 0, 0, data)
    end

    delaygoto(actor,500,"top_redpoint_init")
end

function top_redpoint_init(actor)
    if getplaydef(actor, "N$首充红点") > 0 then
        Message.sendmsg(actor, ssrNetMsgCfg.ShouChong_AddRedPoint, 1, 0, 0, {})
    end

    if getplaydef(actor, "N$牛马赞助红点") > 0 then
        Message.sendmsg(actor, ssrNetMsgCfg.NiuMaZanZhu_AddRedPoint, 1, 0, 0, {})
    end
end

local function _onLoginEnd(actor, logindatas)
    TopIcon.SyncResponse(actor, logindatas)
end
GameEvent.add(EventCfg.onLoginEnd, _onLoginEnd, TopIcon)

return TopIcon

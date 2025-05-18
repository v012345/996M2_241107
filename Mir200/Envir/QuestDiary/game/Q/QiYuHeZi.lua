QiYuHeZi = {}
local LuckyEventCfg = include("QuestDiary/cfgcsv/cfg_LuckyEvent_BoxData.lua") --奇遇事件配置


function QiYuHeZi.SetEventUIState(actor, var)
    if  var == 1 then
        setplaydef(actor,VarCfg["S$奇遇验证"], "打开奇遇盒子状态")
    else
        setplaydef(actor,VarCfg["S$奇遇验证"], "")
    end
end


--删除奇遇事件
function QiYuHeZi.DelAllEvent(actor)
    local notes4 = getplaydef(actor, VarCfg["Z_奇遇盒子位置4"])
    local notes5 = getplaydef(actor, VarCfg["Z_奇遇盒子位置5"])
    setplaydef(actor, VarCfg["Z_奇遇盒子位置1"],"")
    setplaydef(actor, VarCfg["Z_奇遇盒子位置2"],"")
    setplaydef(actor, VarCfg["Z_奇遇盒子位置3"],"")

    if  notes4 ~= "未解锁" then
        setplaydef(actor, VarCfg["Z_奇遇盒子位置4"],"")
    elseif  notes5 ~= "未解锁" then
        setplaydef(actor, VarCfg["Z_奇遇盒子位置5"],"")
    end
    QiYuHeZi.SyncResponse(actor)
end


function QiYuHeZi.Request(actor, _, _, var, data)
    local EventName = getplaydef(actor, VarCfg["Z_奇遇盒子位置".. var ..""])
    if EventName == "未解锁" then
        Player.sendmsgEx(actor, "提示#251|:#255|对不起|位置" ..var.. "#249|未解锁...")
        return
    end
    if EventName == "" then
        Player.sendmsgEx(actor, "提示#251|:#255|对不起|位置" ..var.. "#249|未记录...")
        return
    end
    if EventName ~= data[1] then
        Player.sendmsgEx(actor, "提示#251|:#255|非法请求#249|")
        return
    end

    if EventName == data[1] then
        local cfg = {}
        for k, v in ipairs(LuckyEventCfg) do
            if v.EnevtName == EventName then
                cfg = v
                break
            end
        end
        if cfg.Types == "召唤" then
            Message.sendmsg(actor, ssrNetMsgCfg.QiYuHeZi_OpenEventUI, 0, 0, 0, {EventName})    --前端打开对应界面
            Message.sendmsg(actor, ssrNetMsgCfg.QiYuZhaoHuan_SyncResponse, 0, 0, 0, {EventName}) --向召唤界面传递数据
            GameEvent.push(EventCfg.LuckyEventinitVar, actor, EventName)  --奇遇触发后设置变量
        elseif cfg.Types == "副本" then
            Message.sendmsg(actor, ssrNetMsgCfg.QiYuHeZi_OpenEventUI, 0, 0, 0,{EventName}) --前端打开对应界面
            Message.sendmsg(actor, ssrNetMsgCfg.QiYuFuBen_SyncResponse, 0, 0, 0, {EventName}) --向副本界面传递数据
            GameEvent.push(EventCfg.LuckyEventinitVar, actor, EventName)  --奇遇触发后设置变量
        elseif cfg.Types == "事件" then
            local state = true
            if cfg.BuffId ~= "nil"  then
                local BuffTbl = cfg.BuffId
                for i = 1, #BuffTbl do
                    local buffstate = hasbuff(actor, BuffTbl[i])
                    if hasbuff(actor, BuffTbl[i]) then
                        state = false
                    end
                end
            end
            if state then
                Message.sendmsg(actor, ssrNetMsgCfg.QiYuHeZi_OpenEventUI, 0, 0, 0,{EventName})
                GameEvent.push(EventCfg.LuckyEventinitVar, actor, EventName, "盒子打开")  --奇遇触发后设置变量
            else
                Player.sendmsgEx(actor, "提示#251|:#255|你当前有|" ..EventName.. "#249|的Buff,请等待结束...")
            end
        end
    end
    setplaydef(actor, VarCfg["Z_奇遇盒子位置".. var ..""],"")
    QiYuHeZi.SyncResponse(actor)
end

--客户端x掉对话框，收进盒子
function QiYuHeZi.ClientAddEvent(actor,Event_Name)
    local notes1 = getplaydef(actor, VarCfg["Z_奇遇盒子位置1"])
    local notes2 = getplaydef(actor, VarCfg["Z_奇遇盒子位置2"])
    local notes3 = getplaydef(actor, VarCfg["Z_奇遇盒子位置3"])
    local notes4 = getplaydef(actor, VarCfg["Z_奇遇盒子位置4"])
    local notes5 = getplaydef(actor, VarCfg["Z_奇遇盒子位置5"])
    local NewTbl = {notes1,notes2,notes3,notes4,notes5}

    for _, value in ipairs(NewTbl) do
        if value == Event_Name then
            setplaydef(actor, VarCfg["S$奇遇验证"], "")
            return
        end
    end
    if notes1 == "" then
        setplaydef(actor, VarCfg["Z_奇遇盒子位置1"],Event_Name)
    elseif  notes2 == "" then
        setplaydef(actor, VarCfg["Z_奇遇盒子位置2"],Event_Name)
    elseif  notes3 == "" then
        setplaydef(actor, VarCfg["Z_奇遇盒子位置3"],Event_Name)
    elseif  notes4 ~= "未解锁" then
        if notes4 == "" then
            setplaydef(actor, VarCfg["Z_奇遇盒子位置4"],Event_Name)
        end
    elseif  notes5 ~= "未解锁" then
        if notes5 == "" then
            setplaydef(actor, VarCfg["Z_奇遇盒子位置5"],Event_Name)
        end
    end
    QiYuHeZi.SyncResponse(actor)
end

--事件奇遇弹窗开关
function QiYuHeZi.Switch(actor)
    if getflagstatus(actor, VarCfg["F_奇遇自动弹出开关"]) == 0 then
        setflagstatus(actor, VarCfg["F_奇遇自动弹出开关"], 1)
    else
        setflagstatus(actor, VarCfg["F_奇遇自动弹出开关"], 0)
    end
    QiYuHeZi.SyncResponse(actor)
end

function QiYuHeZi.AddEvent(actor,Event_Name)
    local bool = getflagstatus(actor, VarCfg["F_奇遇自动弹出开关"])
    if bool == 0 then
        return true
    else
        local notes1 = getplaydef(actor, VarCfg["Z_奇遇盒子位置1"])
        local notes2 = getplaydef(actor, VarCfg["Z_奇遇盒子位置2"])
        local notes3 = getplaydef(actor, VarCfg["Z_奇遇盒子位置3"])
        local notes4 = getplaydef(actor, VarCfg["Z_奇遇盒子位置4"])
        local notes5 = getplaydef(actor, VarCfg["Z_奇遇盒子位置5"])
        local NewTbl = {notes1,notes2,notes3,notes4,notes5}
        for _, value in ipairs(NewTbl) do
            if value == Event_Name then
                return
            end
        end
        if notes1 == "" then
            setplaydef(actor, VarCfg["Z_奇遇盒子位置1"],Event_Name)
        elseif  notes2 == "" then
            setplaydef(actor, VarCfg["Z_奇遇盒子位置2"],Event_Name)
        elseif  notes3 == "" then
            setplaydef(actor, VarCfg["Z_奇遇盒子位置3"],Event_Name)
        elseif  notes4 ~= "未解锁" then
            if notes4 == "" then
                setplaydef(actor, VarCfg["Z_奇遇盒子位置4"],Event_Name)
            end
        elseif  notes5 ~= "未解锁" then
            if notes5 == "" then
                setplaydef(actor, VarCfg["Z_奇遇盒子位置5"],Event_Name)
            end
        end
        QiYuHeZi.SyncResponse(actor)
        return false
    end
end

--注册网络消息
function QiYuHeZi.SyncResponse(actor, logindatas)
    local bool = getflagstatus(actor, VarCfg["F_奇遇自动弹出开关"])
    local notes1 = getplaydef(actor, VarCfg["Z_奇遇盒子位置1"])
    local notes2 = getplaydef(actor, VarCfg["Z_奇遇盒子位置2"])
    local notes3 = getplaydef(actor, VarCfg["Z_奇遇盒子位置3"])
    local notes4 = getplaydef(actor, VarCfg["Z_奇遇盒子位置4"])
    local notes5 = getplaydef(actor, VarCfg["Z_奇遇盒子位置5"])
    local data = { notes1, notes2, notes3, notes4, notes5}
    local _login_data = { ssrNetMsgCfg.QiYuHeZi_SyncResponse, bool, 0, 0, data }
    if logindatas then
        table.insert(logindatas, _login_data)
    else
        Message.sendmsg(actor, ssrNetMsgCfg.QiYuHeZi_SyncResponse, bool, 0, 0, data)
    end
end
Message.RegisterNetMsg(ssrNetMsgCfg.QiYuHeZi, QiYuHeZi)

--0:0:10 新的一天触发
local function _onNewDay(actor)
    setplaydef(actor, VarCfg["Z_奇遇盒子位置4"],"未解锁")
    setplaydef(actor, VarCfg["Z_奇遇盒子位置5"],"未解锁")

    if checkitems(actor, "幻境通行证#1", 0, 0) then
        setplaydef(actor, VarCfg["Z_奇遇盒子位置4"],"")
    end
    QiYuHeZi.SyncResponse(actor)
end
GameEvent.add(EventCfg.onNewDay, _onNewDay, QiYuHeZi)

--登录触发
local function _onLoginEnd(actor, logindatas)
    if not checkitems(actor, "幻境通行证#1", 0, 0) then
        if getplaydef(actor, VarCfg["Z_奇遇盒子位置4"]) == "" then
            setplaydef(actor, VarCfg["Z_奇遇盒子位置4"],"未解锁")
        end
    end

    setplaydef(actor, VarCfg["Z_奇遇盒子位置5"],"未解锁")
    QiYuHeZi.SyncResponse(actor, logindatas)
end
GameEvent.add(EventCfg.onLoginEnd, _onLoginEnd, QiYuHeZi)

--注册网络消息
Message.RegisterNetMsg(ssrNetMsgCfg.QiYuShiJian01, QiYuHeZi)

return QiYuHeZi



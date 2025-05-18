local AnYuLieXi = {}
local npcID = 230
AnYuLieXi.ID = "暗域裂隙"
local config = include("QuestDiary/cfgcsv/cfg_AnYuLieXi.lua") --暗域裂隙
local varList = { [VarCfg["U_剧情_暗域裂隙_杀怪1"]]=100, [VarCfg["U_剧情_暗域裂隙_杀怪2"]]=100, [VarCfg["U_剧情_暗域裂隙_杀怪3"]]=100, [VarCfg["U_剧情_暗域裂隙_杀怪4"]]=5 }
--判断是否满足进入地图条件
function AnYuLieXi.CheckEnterMap(actor)
    local result = true
    for key, value in pairs(varList) do
        local num = getplaydef(actor,key)
        if num < value then
            result = false
            break
        end
    end
    return result
end
--激活
function AnYuLieXi.Request1(actor)
    local flag = getflagstatus(actor, VarCfg["F_剧情_暗域裂隙"])
    if flag == 1 then
        Player.sendmsgEx(actor,"暗域裂隙地图已激活!#249")
        return
    end
    local result = AnYuLieXi.CheckEnterMap(actor)
    if not result then
        Player.sendmsgEx(actor,"你不满足激活条件!#249")
        return
    else
        setflagstatus(actor, VarCfg["F_剧情_暗域裂隙"],1)
        Player.sendmsgEx(actor,"恭喜你成功激活暗域裂隙地图,点击进入地图即可进入!")
    end
end

--进入
function AnYuLieXi.Request2(actor)
    local flag = getflagstatus(actor, VarCfg["F_剧情_暗域裂隙"])
    if flag == 0 then
        Player.sendmsgEx(actor,"你没有开通进入地图权限,完成剧情任务后即可进入!#249")
        return
    end
    map(actor, "暗域裂隙")
end

function AnYuLieXi.SyncResponse(actor, logindatas)
    local skillMon1 = getplaydef(actor, VarCfg["U_剧情_暗域裂隙_杀怪1"])
    local skillMon2 = getplaydef(actor, VarCfg["U_剧情_暗域裂隙_杀怪2"])
    local skillMon3 = getplaydef(actor, VarCfg["U_剧情_暗域裂隙_杀怪3"])
    local skillMon4 = getplaydef(actor, VarCfg["U_剧情_暗域裂隙_杀怪4"])
    local data = { skillMon1, skillMon2, skillMon3, skillMon4 }
    local _login_data = { ssrNetMsgCfg.AnYuLieXi_SyncResponse, 0, 0, 0, data }
    if logindatas and type(logindatas) == "table" then
        table.insert(logindatas, _login_data)
    else
        Message.sendmsg(actor, ssrNetMsgCfg.AnYuLieXi_SyncResponse, 0, 0, 0, data)
    end
end

--登录触发
local function _onLoginEnd(actor, logindatas)
    AnYuLieXi.SyncResponse(actor, logindatas)
end
--事件派发
GameEvent.add(EventCfg.onLoginEnd, _onLoginEnd, AnYuLieXi)

--杀怪触发
local function _onKillMon(actor, monobj, monName)
    local cfg = config[monName]
    if cfg then
        local num = getplaydef(actor, cfg.var)
        if num < cfg.maxNum then
            setplaydef(actor, cfg.var, num + 1)
        end
    end
end
GameEvent.add(EventCfg.onKillMon, _onKillMon, AnYuLieXi)
--注册网络
Message.RegisterNetMsg(ssrNetMsgCfg.AnYuLieXi, AnYuLieXi)
return AnYuLieXi

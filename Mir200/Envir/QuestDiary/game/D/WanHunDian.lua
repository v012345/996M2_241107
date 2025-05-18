local WanHunDian = {}
WanHunDian.ID = "万魂殿"
local npcID = 468


--获取三个变量数据
function WanHunDian.getVarU_Num(actor)
    local Num1 = getplaydef(actor, VarCfg["U_神魂古墓杀怪1"])
    local Num2 = getplaydef(actor, VarCfg["U_神魂古墓杀怪2"])
    local Num3 = getplaydef(actor, VarCfg["U_神魂古墓杀怪3"])
    local  data = {Num1, Num2, Num3}
    return data
end

--接收请求
function WanHunDian.Request(actor)
    local data = WanHunDian.getVarU_Num(actor)

    if data[1] < 33 then
        Player.sendmsgEx(actor, "提示#251|:#255|对不起,你的|天·元神#249|击杀不足|33#249|无法进入...")
        return
    end

    if data[2] < 33 then
        Player.sendmsgEx(actor, "提示#251|:#255|对不起,你的|人·阳神#249|击杀不足|33#249|无法进入...")
        return
    end

    if data[3] < 33 then
        Player.sendmsgEx(actor, "提示#251|:#255|对不起,你的|地·阴神#249|击杀不足|33#249|无法进入...")
        return
    end

    setplaydef(actor, VarCfg["U_神魂古墓杀怪1"], data[1] - 33)
    setplaydef(actor, VarCfg["U_神魂古墓杀怪2"], data[2] - 33)
    setplaydef(actor, VarCfg["U_神魂古墓杀怪3"], data[3] - 33)
    WanHunDian.SyncResponse(actor)

    local NowMapID = getbaseinfo(actor, ConstCfg.gbase.mapid)
    local NowX,NowY = getbaseinfo(actor, ConstCfg.gbase.x),getbaseinfo(actor, ConstCfg.gbase.y)

    local HuiChenginfo = {["NowMapID"] = NowMapID,["NowX"] = NowX,["NowY"] = NowY}
    Player.setJsonVarByTable(actor, VarCfg["T_进入副本记录退出信息"] , HuiChenginfo)



    local UserName = getbaseinfo(actor, ConstCfg.gbase.name)
    local NewMapId = "youmingshenyuan"..UserName --根据原始地图id  配置新地图ID
    local NewMapName = "万魂殿".."[副本]"

    if checkmirrormap(NewMapId) then
        killmonsters(NewMapId, "*", 0, false)   --杀死当前地图所有怪物
        delmirrormap(NewMapId)              --删除镜像地图
        addmirrormap("youmingshenyuan", NewMapId, NewMapName, 600, NowMapID, nil, NowX, NowY)
    else
        addmirrormap("youmingshenyuan", NewMapId, NewMapName, 600, NowMapID, nil, NowX, NowY)
    end

    --刷Boss
    genmon(NewMapId, 24, 25,"◆◆◆七魄之灵◆◆◆", 100, 100, 249)

    map(actor, NewMapId)
end

-- 同步消息
function WanHunDian.SyncResponse(actor, logindatas)
    local data = WanHunDian.getVarU_Num(actor)
    local _login_data = {ssrNetMsgCfg.WanHunDian_SyncResponse, 0, 0, 0, data}
    if type(logindatas) == "table" then
        table.insert(logindatas, _login_data)
    else
        Message.sendmsg(actor, ssrNetMsgCfg.WanHunDian_SyncResponse, 0, 0, 0, data)
    end
end

--登录触发
local function _onLoginEnd(actor, logindatas)
    WanHunDian.SyncResponse(actor, logindatas)
end
GameEvent.add(EventCfg.onLoginEnd, _onLoginEnd, WanHunDian)



--注册网络消息
Message.RegisterNetMsg(ssrNetMsgCfg.WanHunDian, WanHunDian)
return WanHunDian
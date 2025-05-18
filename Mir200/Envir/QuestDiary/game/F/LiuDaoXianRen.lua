local LiuDaoXianRen = {}
local cost = {{"天道灵玉", 1},{"修罗血晶", 1},{"人道魂石", 1},{"兽魂骨髓", 1},{"鬼泣之魄", 1},{"地狱业火石", 1},{"元宝", 888888}}

function liu_dao_lun_hui_chen_diaoluo(actor)
    setflagstatus(actor, VarCfg["F_六道轮回尘掉落"],1)
    return true
end

function LiuDaoXianRen.Request(actor)
    local name, num = Player.checkItemNumByTable(actor, cost)
    if name then
        Player.sendmsgEx(actor, string.format("提示#251|:#255|你的|%s#249|不足|%d#249|枚,进入失败...", name, num))
        return
    end
    Player.takeItemByTable(actor, cost, "进入副本材料")
    local NowMapID = getbaseinfo(actor, ConstCfg.gbase.mapid)
    local NowX,NowY = getbaseinfo(actor, ConstCfg.gbase.x),getbaseinfo(actor, ConstCfg.gbase.y)
    local UserName = getconst(actor, "<$USERID>")
    local FormerMapId = "liudaomoyu"  --获取原始地图ID
    local NewMapId = FormerMapId..UserName --根据原始地图id  配置新地图ID
    if checkmirrormap(NewMapId) then
        killmonsters(NewMapId, "*", 0, false)   --杀死当前地图所有怪物
        delmirrormap(NewMapId)              --删除镜像地图
        addmirrormap(FormerMapId, NewMapId, "六道仙人[副本]", 1800, NowMapID, nil, NowX, NowY)
    else
        addmirrormap(FormerMapId, NewMapId, "六道仙人[副本]", 1800, NowMapID, nil, NowX, NowY)
    end
    mapmove(actor, NewMapId, 60, 65, 5)
    --镜像地图刷怪
    genmon(NewMapId, 60, 65 ,"大筒木羽衣∷六道仙人∷", 0, 1, 249)
    setflagstatus(actor, VarCfg["F_六道仙人唤醒"],1)
    LiuDaoXianRen.SyncResponse(actor)
end

-- 同步一次消息
function LiuDaoXianRen.SyncResponse(actor)
    Message.sendmsg(actor, ssrNetMsgCfg.LiuDaoXianRen_SyncResponse, 0, 0, 0, nil)
end
Message.RegisterNetMsg(ssrNetMsgCfg.LiuDaoXianRen, LiuDaoXianRen)

return LiuDaoXianRen








local XianJiShiLian = {}
local cost = { { "灵符", 1888 } }
local subHp = { 2, 10 }
local addJinDu = { 1, 10 }
function XianJiShiLian.openUI(actor)
    local jinDu = getplaydef(actor, VarCfg["M_献祭进度"])
    Message.sendmsg(actor, ssrNetMsgCfg.XianJiShiLian_openUI, jinDu, 0, 0)
end

function xianjishixian_request(actor)
    local layerFlag = getplaydef(actor, VarCfg["M_地藏王标识"])
    if layerFlag ~= 4 then
        Player.sendmsgEx(actor, "没有检测到你在地图内!")
        return
    end
    local jinDu = getplaydef(actor, VarCfg["M_献祭进度"])
    local _subHp = math.random(subHp[1], subHp[2])
    local _addJinDu = math.random(addJinDu[1], addJinDu[2])
    local currJinDu = jinDu + _addJinDu
    setplaydef(actor, VarCfg["M_献祭进度"], currJinDu)
    XianJiShiLian.SyncResponse(actor, currJinDu)
    addhpper(actor, "-", _subHp)
    Player.sendmsgEx(actor, string.format("你的血量减少|%s%%#249|, 献祭进度增加|%s%%#249|", _subHp, _addJinDu))
    if currJinDu >= 100 then
        Player.sendmsgEx(actor, "恭喜您成功完成献祭试炼!")
        local mapId = getbaseinfo(actor, ConstCfg.gbase.mapid)
        delmirrormap(mapId)
        setplaydef(actor, VarCfg["U_地藏王的试炼"], 4)
        Message.sendmsg(actor, ssrNetMsgCfg.DiZangWangDeShiLian_SyncResponse, 4, 1)
        delmirrormap(mapId)
    end
end

function XianJiShiLian.Request(actor)
    local currHpPer = Player.getHpPercentage(actor)
    if currHpPer <= 10 then
        messagebox(actor, "你当前的血量低于10%,继续献祭将会暴毙而亡,确定继续?", "@xianjishixian_request", "@exit")
        return
    else
        xianjishixian_request(actor)
    end
end

function XianJiShiLian.RequestHp(actor)
    local layerFlag = getplaydef(actor, VarCfg["M_地藏王标识"])
    if layerFlag ~= 4 then
        Player.sendmsgEx(actor, "参数错误!")
        return
    end
    local name, num = Player.checkItemNumByTable(actor, cost)
    if name then
        Player.sendmsgEx(actor, string.format("你的|%s#249|不足|%s#249", name, num))
        return
    end
    Player.takeItemByTable(actor, cost, "献祭试炼")
    addhpper(actor, "=", 100)
    Player.sendmsgEx(actor, "恭喜你满血了!")
end

--同步一次消息
function XianJiShiLian.SyncResponse(actor, jinDu)
    Message.sendmsg(actor, ssrNetMsgCfg.XianJiShiLian_SyncResponse, jinDu, 0, 0)
end

Message.RegisterNetMsg(ssrNetMsgCfg.XianJiShiLian, XianJiShiLian)

return XianJiShiLian

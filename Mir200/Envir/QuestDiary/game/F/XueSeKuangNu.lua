local XueSeKuangNu = {}
local cost = {{"狂怒护手",1},{"狂意之怒",1}}

function XueSeKuangNu.Request(actor, var)
    local verify = (var == 1) or(var == 2)
    if not verify then  return end
    local bool = getflagstatus(actor, VarCfg["F_血色狂怒".. var ..""])
    if bool == 1 then
        Player.sendmsgEx(actor, "提示#251|:#255|你已提交该装备,请勿重复提交...")
    end

    local name, num = Player.checkItemNumByTable(actor, {cost[var]})
    if name then
        Player.sendmsgEx(actor, string.format("提示#251|:#255|你的|%s#249|不足|%d#249|件,提交失败...", name, num))
        return
    end
    Player.takeItemByTable(actor, {cost[var]}, "血色狂怒扣除")
    setflagstatus(actor, VarCfg["F_血色狂怒".. var ..""],1)
    Player.setAttList(actor, "属性附加")

    --添加称号
    if not checktitle(actor, "无尽狂怒") then
        local bool1 = getflagstatus(actor, VarCfg["F_血色狂怒1"])
        local bool2 = getflagstatus(actor, VarCfg["F_血色狂怒2"])
        if bool1 == 1 and bool2 == 1 then
            confertitle(actor, "无尽狂怒", 1)
            Player.setAttList(actor, "属性附加")
        end
    end
    XueSeKuangNu.SyncResponse(actor)
end

function XueSeKuangNu.LiaoJie(actor)
    setflagstatus(actor,VarCfg["F_了解血色狂怒"],1)
end

--属性刷新
local function _onCalcAttr(actor, attrs)
    local shuxingMap = {}
    if getflagstatus(actor, VarCfg["F_血色狂怒1"]) == 1 then
        shuxingMap[210] = 3 --攻击上限百分比
        shuxingMap[211] = 3 --魔法上限百分比
        shuxingMap[212] = 3 --道术上限百分比
    end
    
    if getflagstatus(actor, VarCfg["F_血色狂怒2"]) == 1 then
        shuxingMap[208] = 5 --生命值百分比
    end

    if getflagstatus(actor, VarCfg.F_is_open_kuangbao) and checktitle(actor, "无尽狂怒") then
        shuxingMap[79] = 500 --致命一击 万分比
        shuxingMap[81] = 400 --对怪吸血 万分比
    end
    calcAtts(attrs, shuxingMap, "血色狂怒")
end
GameEvent.add(EventCfg.onCalcAttr, _onCalcAttr, XueSeKuangNu)

--注册网络消息
function XueSeKuangNu.SyncResponse(actor, logindatas)
    local bool1 = getflagstatus(actor, VarCfg["F_血色狂怒1"])
    local bool2 = getflagstatus(actor, VarCfg["F_血色狂怒2"])
    local data = {bool1, bool2}

    local _login_data = { ssrNetMsgCfg.XueSeKuangNu_SyncResponse, 0, 0, 0, data} 
    if logindatas then
        table.insert(logindatas, _login_data)
    else
        Message.sendmsg(actor, ssrNetMsgCfg.XueSeKuangNu_SyncResponse, 0, 0, 0, data)
    end
end
Message.RegisterNetMsg(ssrNetMsgCfg.XueSeKuangNu, XueSeKuangNu)

--登录触发
local function _onLoginEnd(actor, logindatas)
    XueSeKuangNu.SyncResponse(actor, logindatas)
end
GameEvent.add(EventCfg.onLoginEnd, _onLoginEnd, XueSeKuangNu)

return XueSeKuangNu

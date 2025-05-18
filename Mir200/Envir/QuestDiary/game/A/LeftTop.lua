local LeftTop = {}
-----------------------网络消息--------------------------
--注册网络消息
Message.RegisterNetMsg(ssrNetMsgCfg.LeftTop, LeftTop)

--------------------登录触发-----------------------------

local function _onLogin(actor)
    FIniPlayVar(actor, "战斗力", "integer")
end
GameEvent.add(EventCfg.onLogin, _onLogin, LeftTop)

--属性改变触发
-- local function _onSendAbility(actor)
    
-- end

-- GameEvent.add(EventCfg.onSendAbility, _onSendAbility, LeftTop)

function updatazhanli(actor)
    local power = math.floor(Player.GetPower(actor)) or 0
    setplaydef(actor, VarCfg["B_记录战斗力"], tonumber(power))
    setplaydef(actor, VarCfg["U_战斗力"], tonumber(power))
    FSetPlayVar(actor, "战斗力", tonumber(power), 1)
    GameEvent.push(EventCfg.OverloadPower,actor,power)  --战力计算完成后触发
end

local function _onTakeOnEx(actor, itemobj, where, itemname, makeid)
    -- updataZhanLi(actor)
    cleardelaygoto(actor,"updatazhanli")
    delaygoto(actor,2000,"updatazhanli")
end


local function _onTakeOffEx(actor, itemobj, where, itemname, makeid)
    -- updataZhanLi(actor)
    cleardelaygoto(actor,"updatazhanli")
    delaygoto(actor,2000,"updatazhanli")
end

GameEvent.add(EventCfg.onTakeOnEx, _onTakeOnEx, LeftTop)
GameEvent.add(EventCfg.onTakeOffEx, _onTakeOffEx, LeftTop)


return LeftTop

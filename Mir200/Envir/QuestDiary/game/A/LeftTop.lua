local LeftTop = {}
-----------------------������Ϣ--------------------------
--ע��������Ϣ
Message.RegisterNetMsg(ssrNetMsgCfg.LeftTop, LeftTop)

--------------------��¼����-----------------------------

local function _onLogin(actor)
    FIniPlayVar(actor, "ս����", "integer")
end
GameEvent.add(EventCfg.onLogin, _onLogin, LeftTop)

--���Ըı䴥��
-- local function _onSendAbility(actor)
    
-- end

-- GameEvent.add(EventCfg.onSendAbility, _onSendAbility, LeftTop)

function updatazhanli(actor)
    local power = math.floor(Player.GetPower(actor)) or 0
    setplaydef(actor, VarCfg["B_��¼ս����"], tonumber(power))
    setplaydef(actor, VarCfg["U_ս����"], tonumber(power))
    FSetPlayVar(actor, "ս����", tonumber(power), 1)
    GameEvent.push(EventCfg.OverloadPower,actor,power)  --ս��������ɺ󴥷�
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

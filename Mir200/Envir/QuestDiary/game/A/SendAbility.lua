local SendAbility = {}
local function _onSendAbility(actor)
    --以暴制暴
    if getflagstatus(actor, VarCfg["F_天命_以暴制暴标识"]) == 1 then
        local baoJi = getbaseinfo(actor, ConstCfg.gbase.custom_attr, 21)
        if baoJi ~= getplaydef(actor, VarCfg["N$记录上次的暴击率"]) then
            -- release_print("暴击改变了!!!")
            local renXing = 0
            if baoJi > 0 then
                renXing = math.floor(baoJi / 5)
            end
            addattlist(actor, "以暴制暴加成", "=", "3#23#" .. renXing, 1)
            setplaydef(actor, VarCfg["N$记录上次的暴击率"], baoJi)
        end
    end
end
--改变属性触发
GameEvent.add(EventCfg.onSendAbility, _onSendAbility, SendAbility)


return SendAbility

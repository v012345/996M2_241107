local ChuangShiZhiHuo = {}



function ChuangShiZhiHuo.ButtonLink1(actor, arg1)
    -- release_print("创世之火...")
end




--注册网络消息
Message.RegisterNetMsg(ssrNetMsgCfg.ChuangShiZhiHuo, ChuangShiZhiHuo)

-- function ChuangShiZhiHuo.SyncResponse(actor, logindatas)
--     local U101 = getplaydef(actor,VarCfg["U_神魔_暴戾一击"])
--     local U102 = getplaydef(actor,VarCfg["U_神魔_伤害增幅"])
--     local U103 = getplaydef(actor,VarCfg["U_神魔_钢铁之躯"])
--     local U104 = getplaydef(actor,VarCfg["U_神魔_削铁如泥"])
--     local U105 = getplaydef(actor,VarCfg["U_神魔_血牛达人"])
--     local U100 = getplaydef(actor,VarCfg["U_神魔_升级次数"])

--     local data = {U101,U102,U103,U104,U105,U100}

--     local _login_data = {ssrNetMsgCfg.ChuangShiZhiHuo_SyncResponse, 0, 0, 0, data}
--     if logindatas then
--         table.insert(logindatas, _login_data)
--     else
--         Message.sendmsg(actor, ssrNetMsgCfg.ChuangShiZhiHuo_SyncResponse, 0, 0, 0, data)
--     end
-- end

--登录触发
-- local function _onLoginEnd(actor, logindatas)
--     ChuangShiZhiHuo.SyncResponse(actor, logindatas)
-- end
-- GameEvent.add(EventCfg.onLoginEnd, _onLoginEnd, ChuangShiZhiHuo)

return ChuangShiZhiHuo

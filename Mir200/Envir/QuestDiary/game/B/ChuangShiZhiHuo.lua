local ChuangShiZhiHuo = {}



function ChuangShiZhiHuo.ButtonLink1(actor, arg1)
    -- release_print("����֮��...")
end




--ע��������Ϣ
Message.RegisterNetMsg(ssrNetMsgCfg.ChuangShiZhiHuo, ChuangShiZhiHuo)

-- function ChuangShiZhiHuo.SyncResponse(actor, logindatas)
--     local U101 = getplaydef(actor,VarCfg["U_��ħ_����һ��"])
--     local U102 = getplaydef(actor,VarCfg["U_��ħ_�˺�����"])
--     local U103 = getplaydef(actor,VarCfg["U_��ħ_����֮��"])
--     local U104 = getplaydef(actor,VarCfg["U_��ħ_��������"])
--     local U105 = getplaydef(actor,VarCfg["U_��ħ_Ѫţ����"])
--     local U100 = getplaydef(actor,VarCfg["U_��ħ_��������"])

--     local data = {U101,U102,U103,U104,U105,U100}

--     local _login_data = {ssrNetMsgCfg.ChuangShiZhiHuo_SyncResponse, 0, 0, 0, data}
--     if logindatas then
--         table.insert(logindatas, _login_data)
--     else
--         Message.sendmsg(actor, ssrNetMsgCfg.ChuangShiZhiHuo_SyncResponse, 0, 0, 0, data)
--     end
-- end

--��¼����
-- local function _onLoginEnd(actor, logindatas)
--     ChuangShiZhiHuo.SyncResponse(actor, logindatas)
-- end
-- GameEvent.add(EventCfg.onLoginEnd, _onLoginEnd, ChuangShiZhiHuo)

return ChuangShiZhiHuo

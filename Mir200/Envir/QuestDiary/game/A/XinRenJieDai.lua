local XinRenJieDai = {}
function XinRenJieDai.Request(actor)
    --¸ø¶«Î÷
    for _, value in ipairs(ConstCfg.first_give_item) do
        giveitem(actor, value, 1, 0)
    end
    mapmove(actor,ConstCfg.main_city,333,333,3)
end
Message.RegisterNetMsg(ssrNetMsgCfg.XinRenJieDai, XinRenJieDai)

return XinRenJieDai
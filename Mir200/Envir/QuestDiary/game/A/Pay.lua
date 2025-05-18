generalappopenchargewnd = {
    ["直购"] = 24,
    ["充值"] = 7
}

--- 打开临时充值界面
--- 用法：generalappopenchargewnd.main(player, 8, 22, "此为直购礼包，其他充值以及货币均不赠送！", 20, "直购点充值","8直购")
--- @param player string 玩家id
--- @param coin number 充值金额
--- @param coinId number 充值货币id
--- @param backFunc function 返回回调
function generalappopenchargewnd.main(player, coin, iconName,tips)
    tips = tips or ""
    local str = [[
            <Layout|x=-1000|y=-1000|width=3000|height=3000|color=136|opacity=100|link=@exit>
            <Img|x=1.0|y=1.0|show=4|esc=1|move=0|img=custom/public/picktypeui.png|bg=1|reset=1|loadDelay=1>
            <Button|x=29.0|y=127.0|size=18|color=255|nimg=custom/public/type1.png|link=@general_app_open_charge_begin_charge_btn,]]..coin..[[,3,]]..iconName..[[>
            <Button|x=160.0|y=127.0|size=18|color=255|nimg=custom/public/type2.png|link=@general_app_open_charge_begin_charge_btn,]]..coin..[[,1,]]..iconName..[[>
            <Button|x=294.0|y=127.0|size=18|color=255|nimg=custom/public/type3.png|link=@general_app_open_charge_begin_charge_btn,]]..coin..[[,2,]]..iconName..[[>
            <Text|x=119.0|y=69.0|size=18|color=255|text=充值金额：                   元>
            <Text|ax=0.5|x=241.0|y=69.0|size=18|color=250|text=]]..coin..[[>
            <Text|ax=0.5|x=216.0|y=184.0|size=18|color=249|text=]]..tips..[[>
    ]]
    say(player,str)
end

-- 开始充值
function general_app_open_charge_begin_charge_btn(player, coinNum, chargeType,iconName)
    coinNum = tonumber(coinNum)
    chargeType = tonumber(chargeType)

    local coinId = generalappopenchargewnd["充值"]
    if generalappopenchargewnd[iconName] ~= nil then
        coinId = generalappopenchargewnd[iconName]
    end

    if coinNum < 10 then
        Player.sendmsgEx(player, "提示#251|:#255|至少充值10元#250")
        return
    end

    pullpay(player, coinNum, chargeType, coinId)
end

return generalappopenchargewnd
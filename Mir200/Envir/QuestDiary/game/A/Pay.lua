generalappopenchargewnd = {
    ["ֱ��"] = 24,
    ["��ֵ"] = 7
}

--- ����ʱ��ֵ����
--- �÷���generalappopenchargewnd.main(player, 8, 22, "��Ϊֱ�������������ֵ�Լ����Ҿ������ͣ�", 20, "ֱ�����ֵ","8ֱ��")
--- @param player string ���id
--- @param coin number ��ֵ���
--- @param coinId number ��ֵ����id
--- @param backFunc function ���ػص�
function generalappopenchargewnd.main(player, coin, iconName,tips)
    tips = tips or ""
    local str = [[
            <Layout|x=-1000|y=-1000|width=3000|height=3000|color=136|opacity=100|link=@exit>
            <Img|x=1.0|y=1.0|show=4|esc=1|move=0|img=custom/public/picktypeui.png|bg=1|reset=1|loadDelay=1>
            <Button|x=29.0|y=127.0|size=18|color=255|nimg=custom/public/type1.png|link=@general_app_open_charge_begin_charge_btn,]]..coin..[[,3,]]..iconName..[[>
            <Button|x=160.0|y=127.0|size=18|color=255|nimg=custom/public/type2.png|link=@general_app_open_charge_begin_charge_btn,]]..coin..[[,1,]]..iconName..[[>
            <Button|x=294.0|y=127.0|size=18|color=255|nimg=custom/public/type3.png|link=@general_app_open_charge_begin_charge_btn,]]..coin..[[,2,]]..iconName..[[>
            <Text|x=119.0|y=69.0|size=18|color=255|text=��ֵ��                   Ԫ>
            <Text|ax=0.5|x=241.0|y=69.0|size=18|color=250|text=]]..coin..[[>
            <Text|ax=0.5|x=216.0|y=184.0|size=18|color=249|text=]]..tips..[[>
    ]]
    say(player,str)
end

-- ��ʼ��ֵ
function general_app_open_charge_begin_charge_btn(player, coinNum, chargeType,iconName)
    coinNum = tonumber(coinNum)
    chargeType = tonumber(chargeType)

    local coinId = generalappopenchargewnd["��ֵ"]
    if generalappopenchargewnd[iconName] ~= nil then
        coinId = generalappopenchargewnd[iconName]
    end

    if coinNum < 10 then
        Player.sendmsgEx(player, "��ʾ#251|:#255|���ٳ�ֵ10Ԫ#250")
        return
    end

    pullpay(player, coinNum, chargeType, coinId)
end

return generalappopenchargewnd
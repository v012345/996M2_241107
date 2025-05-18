local CDKDuiHuan = {}
local config = {
    ["nmcm2636"] = {
        gives = { { "金手指", 1 }, { "绑定金币", 880000 }, { "灵石", 5 }, { "焚天石", 100 } }
    },
    ["nmcm6261"] = {
        gives = { { "绑定金币", 880000 }, { "金条", 1 }, { "灵石", 5 }, { "元宝", 100000 }, { "焚天石", 100 } }
    },
    ["nmcm8259"] = {
        gives = { { "转运金丹", 1 }, { "绑定金币", 880000 }, { "灵石", 5 }, { "焚天石", 100 } }
    },
    ["nmcm8361"] = {
        gives = { { "鸿运当头", 1 }, { "绑定金币", 880000 }, { "灵石", 5 }, { "焚天石", 100 } }
    },
}

local _isUseed = function(actor, cdk)
    local ckdRecard = Player.getJsonTableByVar(actor, VarCfg["T_CDK使用记录"])
    for _, v in ipairs(ckdRecard) do
        if v == cdk then
            return true
        end
    end
    return false
end

function start_c_d_k_dui_huan(actor)
    local ckdRecard = Player.getJsonTableByVar(actor, VarCfg["T_CDK使用记录"])
    local cdk = getconst(actor, "<$NPCINPUT(1)>")
    if _isUseed(actor, cdk) then
        Player.sendmsgEx(actor, "兑换失败,你已经使用过该CDK了!#249")
        return
    end
    local cfg = config[cdk]
    if cfg then
        local mailTitle = "CDK码兑换奖励"
        local mailContent = "请领取您的CDK兑换奖励！"
        local userid = Player.GetUUID(actor)
        Player.giveMailByTable(userid, 1, mailTitle, mailContent, cfg.gives, 1, true)
        Player.sendmsgEx(actor, "恭喜你兑换成功,请到邮件查收!")
        table.insert(ckdRecard, cdk)
        Player.setJsonVarByTable(actor, VarCfg["T_CDK使用记录"], ckdRecard)
    else
        Player.sendmsgEx(actor, "你输入的CDK不存在#249")
    end
end

function c_d_k_dui_huan_qf(actor)
    local str = [[
        <Img|loadDelay=1|bg=1|reset=1|show=4|img=public/1900000600.png|esc=1|move=0>
        <Layout|x=423.0|y=-31.0|width=80|height=80|link=@exit>
        <Button|x=450.0|y=-1.0|nimg=public/1900000510.png|pimg=public/1900000511.png|link=@exit>
        <Text|x=63.0|y=89.0|size=16|color=250|outline=1|text=请输入CDK：>
        <Img|x=160.0|y=83.0|width=200|height=31|scale9l=2|scale9b=2|scale9r=2|scale9t=2|esc=0|img=public/1900000668.png>
        <Input|x=163.0|y=86.0|width=196|height=25|size=16|type=0|inputid=1|color=255|isChatInput=0>
        <Button|x=202.0|y=121.0|width=106|height=41|submitInput=1|size=18|color=250|nimg=public/1900000660.png|text=兑换CD|link=@start_c_d_k_dui_huan>
        <Text|x=194.0|y=16.0|size=16|color=9|outline=1|text=直播限时CDK>
        <Text|x=134.0|y=37.0|size=16|color=9|outline=1|text=盒子搜索牛马沉默获取CDK>
        <Text|x=166.0|y=58.0|size=16|color=9|outline=1|text=四重礼包，免费领取>
                
    ]]
    say(actor, str)
end

return CDKDuiHuan

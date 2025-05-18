function main(actor)
    setplaydef(actor,"S$货币ID", "请输入货币ID")
    setplaydef(actor,"S$货币Num", "请输入货币数量")
    openui(actor)
end

function openui(actor)
    local MoenyID = getplaydef(actor,"S$货币ID")
    local MoenyNum = getplaydef(actor,"S$货币Num")
    say(actor, [[
        <Img|x=-53.0|y=0.0|move=0|show=4|reset=1|bg=1|loadDelay=1|scale9b=10|scale9t=10|img=custom/shenhe/shjm.png|scale9l=10|scale9r=10|esc=1>
        <Layout|x=952.0|y=49.0|width=80|height=80|link=@exit>
        <Button|x=952.0|y=49.0|nimg=custom/shenhe/close.png|size=18|color=255|link=@exit>
        <Img|x=131.0|y=93.0|width=200|height=368|scale9l=2|img=public/1900000668.png|scale9r=2|esc=0|scale9b=2|scale9t=2>
        <Input|x=131.0|y=93.0|width=200|height=368|type=0|color=255|size=16|place=将物品名字粘贴进去|isChatInput=0|inputid=2>
        <Button|x=143.0|y=465.0|width=165|height=55|rotate=0|color=250|nimg=custom/shenhe/an.png|submitInput=2|size=18|text=制造以上物品|link=@shuaitem>
        <Button|x=320.0|y=465.0|width=165|height=55|rotate=0|color=250|nimg=custom/shenhe/an.png|submitInput=2|size=18|text=批量刷怪|link=@shuaguai>
        <Button|x=500.0|y=465.0|width=165|height=55|rotate=0|color=250|nimg=custom/shenhe/an.png|submitInput=2|size=18|text=清理怪物|link=@clearmonster>
        <Button|x=345|y=115|nimg=custom/shenhe/an.png|color=250|size=18|text=进入管理模式|link=@jinrugm1>
        <Button|x=545|y=115|nimg=custom/shenhe/an.png|color=250|size=18|text=进入隐身模式|link=@jinrugm2>
        <Button|x=745|y=115|nimg=custom/shenhe/an.png|color=250|size=18|text=进入无敌模式|link=@jinrugm3>
        <Button|x=345|y=170|nimg=custom/shenhe/an.png|color=250|size=18|text=人物等级+1级|link=@rwinclevel>
        <Button|x=545|y=170|nimg=custom/shenhe/an.png|color=250|size=18|text=材料一键全满|link=@geiwupin>
        <Button|x=745|y=170|nimg=custom/shenhe/an.png|color=250|size=18|text=清空背包物品|link=@clearbag>
        <Button|x=345|y=225|nimg=custom/shenhe/an.png|color=250|size=18|text=金币一键全满|link=@moenyinc1>
        <Button|x=545|y=225|nimg=custom/shenhe/an.png|color=250|size=18|text=元宝一键全满|link=@moenyinc2>
        <Button|x=745|y=225|nimg=custom/shenhe/an.png|color=250|size=18|text=灵符一键全满|link=@moenyinc3>
        <Button|x=345|y=280|nimg=custom/shenhe/an.png|color=250|size=18|text=二大陆|link=@chuansong1>
        <Button|x=545|y=280|nimg=custom/shenhe/an.png|color=250|size=18|text=三大陆|link=@chuansong2>
        <Button|x=745|y=280|nimg=custom/shenhe/an.png|color=250|size=18|text=遗忘大陆|link=@chuansong3>
        <Input|x=357.0|y=347.0|width=151|height=35|type=0|color=255|size=16|place=货币ID|isChatInput=0|inputid=5>
        <Input|x=555.0|y=344.0|width=147|height=42|type=0|color=255|size=16|place=货币数量|isChatInput=0|inputid=6>
        <Button|x=749.0|y=335.0|width=165|height=55|color=250|nimg=custom/shenhe/an.png|size=18|submitInput=5,6|text=开始充值|link=@onchongzhi>

    ]])
end

function onchongzhi(actor)
    local _MoenyID, _MoenyNum = getconst(actor, "<$NPCINPUT(5)>") ,getconst(actor, "<$NPCINPUT(6)>")
    local MoenyID = (_MoenyID == "" and 0 ) or _MoenyID or 0
    local MoenyNum = (_MoenyNum == "" and 0 ) or _MoenyNum or 0
    if MoenyID == 0 then
        sendmsg(actor, 1, '{"Msg":"<font color=\'#ff0000\'>请输入货币id。。。</font>","Type":9}')
        return
    end
    if MoenyNum == 0 then
        sendmsg(actor, 1, '{"Msg":"<font color=\'#ff0000\'>请输入货币数量。。。</font>","Type":9}')
        return
    end
    changemoney(actor, MoenyID, "+", MoenyNum*10, "GM后台充值", true)
    recharge(actor, MoenyNum, nil, MoenyID)
end
-- <Layout|x=353.0|y=346.0|width=151|height=32|color=255|link=@@InPutString22>
-- <Layout|x=551.0|y=346.0|width=151|height=34|color=255|link=@@InPutString22>
-- <Text|x=425.0|y=352.0|width=120|height=21|color=0|size=16|text=]]..MoenyID..[[>
-- <Text|x=624.0|y=352.0|width=120|height=21|color=0|size=16|text=]]..MoenyNum..[[>
-- function InPutString21(actor)
--     local MoenyID =  getconst(actor, "<$STR(S21)>")
--     release_print(MoenyID)

--     setplaydef(actor,"S$货币ID",MoenyID)
--     openui(actor)
-- end


-- function InPutString22(actor)
--     local MoenyNum =   getconst(actor, "<$STR(S22)>")
--     setplaydef(actor,"S$货币Num",MoenyNum)
--     openui(actor)
-- end




function clearmonster(actor)
    local mapid = getbaseinfo(actor, 3)
    killmonsters(mapid,"*",0,false)
end

function chuansong1(actor)
    mapmove(actor, "天元边关", 97, 90, 5)
end

function chuansong2(actor)
    mapmove(actor, "天元大陆", 123, 154, 5)
end

function chuansong3(actor)
    mapmove(actor, "太阳圣城", 116, 94, 5)
end

function shuaitem(actor)
    local equiplist = getconst(actor, "<$NPCINPUT(2)>")
    -- release_print(equiplist)
    for line in string.gmatch(equiplist, "([^\r\n]+)") do
        if line ~= "" then
            giveitem(actor, line, 1)
        end
    end
end

function shuaguai(actor)
    local equiplist = getconst(actor, "<$NPCINPUT(2)>")
    for line in string.gmatch(equiplist, "([^\r\n]+)") do
        if line ~= "" then
            local mapid = getbaseinfo(actor, 3)
            local x = getbaseinfo(actor, 4)
            local y = getbaseinfo(actor, 5)
            genmon(mapid, x, y, line, 5, 1, 255)
        end
    end
end

function clearbag(actor)
    
    gmexecute(actor, "ClearBag")
    changemoney(actor, 1, "=", 0, "金币全满", true)
    changemoney(actor, 3, "=", 0, "金币全满", true)

    changemoney(actor, 2, "=", 0, "元宝全满", true)
    changemoney(actor, 4, "=", 0, "元宝全满", true)

    changemoney(actor, 7, "=", 0, "灵符全满", true)
    changemoney(actor, 20, "=", 0, "灵符全满", true)



    giveitem(actor, "主城传送石", 1, 0, "给回城石")
    giveitem(actor, "随机传送石", 1, 0, "给随机石")
end

function jinrugm1(actor)
    callscriptex(actor, "CHANGEMODE", "1", "1")
    sendmsg(actor, 1,
        '{"Msg":" <font color=\'#FFFF00\'>提示!</font><font color=\'#FFFFFF\'>:</font><font color=\'#00FF00\'>你已经进入管理模式...</font>","Type":9}')
end

function jinrugm2(actor)
    callscriptex(actor, "CHANGEMODE", "2", "1")
    sendmsg(actor, 1,
        '{"Msg":" <font color=\'#FFFF00\'>提示!</font><font color=\'#FFFFFF\'>:</font><font color=\'#00FF00\'>你已经进入隐身模式...</font>","Type":9}')
end

function jinrugm3(actor)
    setcandlevalue(actor, 10)
    callscriptex(actor, "CHANGEMODE", "3", "1")
    sendmsg(actor, 1,
        '{"Msg":" <font color=\'#FFFF00\'>提示!</font><font color=\'#FFFFFF\'>:</font><font color=\'#00FF00\'>你已经进入无敌模式...</font>","Type":9}')
end

function rwinclevel(actor)
    changelevel(actor, "+", 1)
    local LEVEL = getconst(actor, "<$LEVEL>")
    sendmsg(actor, 1,
        '{"Msg":" <font color=\'#FFFF00\'>提示!</font><font color=\'#FFFFFF\'>:</font><font color=\'#00FF00\'>当前' ..
        LEVEL .. '级...</font>","Type":9}')
end

function renewinclevel(actor)
    renewlevel(actor, 1, 0)
    local RELEVEL = getconst(actor, "<$RELEVEL>")
    sendmsg(actor, 1,
        '{"Msg":" <font color=\'#FFFF00\'>提示!</font><font color=\'#FFFFFF\'>:</font><font color=\'#00FF00\'>当前' ..
        RELEVEL .. '转...</font>","Type":9}')
end

function moenyinc1(actor) -- 1	金币
    changemoney(actor, 1, "=", 4200000000, "金币全满", true)
    sendmsg(actor, 1,
        '{"Msg":" <font color=\'#FFFF00\'>提示!</font><font color=\'#FFFFFF\'>:</font><font color=\'#00FF00\'>金币已经达到42E...</font>","Type":9}')
end

function moenyinc2(actor) -- 2	元宝
    changemoney(actor, 2, "=", 4200000000, "元宝全满", true)
    sendmsg(actor, 1,
        '{"Msg":" <font color=\'#FFFF00\'>提示!</font><font color=\'#FFFFFF\'>:</font><font color=\'#00FF00\'>元宝已经达到42E...</font>","Type":9}')
end

function moenyinc3(actor) -- 7	灵符
    -- setweathereffect("n3",3,60)
    -- sendmsg(actor, 1, '{"Msg":" <font color=\'#FFFF00\'>提示!</font><font color=\'#FFFFFF\'>:</font><font color=\'#00FF00\'>开启天气效果...</font>","Type":9}')


    changemoney(actor, 7, "=", 4200000000, "灵符全满", true)
    sendmsg(actor, 1,
        '{"Msg":" <font color=\'#FFFF00\'>提示!</font><font color=\'#FFFFFF\'>:</font><font color=\'#00FF00\'>灵符已经达到42E...</font>","Type":9}')
end

function geiwupin(actor)
    giveitem(actor, "书页", 9999, 0)
    giveitem(actor, "灵石", 9999, 0)
    giveitem(actor, "天宫之锤", 9999, 0)
    giveitem(actor, "焚天石", 9999, 0)
    giveitem(actor, "幻灵水晶", 9999, 0)
    sendmsg(actor, 1,
        '{"Msg":" <font color=\'#FFFF00\'>提示!</font><font color=\'#FFFFFF\'>:</font><font color=\'#00FF00\'>你的材料已经全部满了...</font>","Type":9}')
end

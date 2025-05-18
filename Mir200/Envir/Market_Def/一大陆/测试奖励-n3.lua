function main(actor)
    -- ling_qu_gong_ce_jiang_li(actor)
    local Myid = getconst(actor,"$USERACCOUNT")
    local list = {"�ȼ���¼1","�ȼ���¼2","�ȼ���¼3","��Ԫ��½","�����۹�","��Ʒ����","��������1","��������2","��������3","�ϸ�ţ��","����ţ��","��Ϯţ��"}
    local jilu_num = 0
    local hongbao_num = 0
    local Button = {}
    for k, v in ipairs(list) do
        local _value = readini("QuestDiary/���Խ�����¼.ini",Myid,v)
        local value = _value == "" and 0 or tonumber(_value)
        if value >= 10 then
            jilu_num = jilu_num + 1
            Button[k] = "<Img|id=".. 1001 + k*100 .."|x=440|y=0|img=custom/ZhuXianAndJuQing/finish.png"
            else
            Button[k] = "<Button|id=".. 1001 + k*100 .."|x=450|y=15|nimg=custom/ceshijilu/an_jl.png"
        end
        hongbao_num = hongbao_num + value
    end
    say(actor ,
    [[
        <Img|x=-21.0|y=-29.0|width=977|height=555|img=custom/ceshijilu/bg.png|bg=1|esc=1|show=4|move=0|reset=1|loadDelay=1>
        <Layout|x=918.0|y=20.0|width=80|height=83|link=@exit>
        <Button|x=942.0|y=18.0|width=26|height=48|pimg=public/1900000511.png|nimg=public/1900000510.png|link=@exit>
        <Effect|x=132.0|y=153.0|scale=0.7|speed=1|dir=5|effectid=20880|act=0|effecttype=0>
        <ItemShow|x=127.0|y=368.0|width=66|height=67|itemid=10489|itemcount=1|showtips=1|bgtype=0>
        <ItemShow|x=192.0|y=369.0|width=66|height=67|itemid=10480|itemcount=1|showtips=1|bgtype=0>
        <ItemShow|x=259.0|y=369.0|width=66|height=67|itemid=10017|itemcount=5|showtips=1|bgtype=0>
        <ListView|x=353.0|y=145.0|width=569|height=353|children={11,12,13,14,15,16,17,18,19,20,21,22}>
        <Img|id=11|children={1101}|x=0|y=0|img=custom/ceshijilu/list1.png>
        <Img|id=12|children={1201}|x=0|y=0|img=custom/ceshijilu/list2.png>
        <Img|id=13|children={1301}|x=0|y=0|img=custom/ceshijilu/list3.png>
        <Img|id=14|children={1401}|x=0|y=0|img=custom/ceshijilu/list4.png>
        <Img|id=15|children={1501}|x=0|y=0|img=custom/ceshijilu/list5.png>
        <Img|id=16|children={1601}|x=0|y=0|img=custom/ceshijilu/list6.png>
        <Img|id=17|children={1701}|x=0|y=0|img=custom/ceshijilu/list7.png>
        <Img|id=18|children={1801}|x=0|y=0|img=custom/ceshijilu/list8.png>
        <Img|id=19|children={1901}|x=0|y=0|img=custom/ceshijilu/list9.png>
        <Img|id=20|children={2001}|x=0|y=0|img=custom/ceshijilu/list10.png>
        <Img|id=21|children={2101}|x=0|y=0|img=custom/ceshijilu/list11.png>
        <Img|id=22|children={2201}|x=0|y=0|img=custom/ceshijilu/list12.png>
        ]].. Button[1] .. [[|link=@jiluleixing,�ȼ�,�ȼ���¼1,10>
        ]].. Button[2] .. [[|link=@jiluleixing,�ȼ�,�ȼ���¼2,20>
        ]].. Button[3] .. [[|link=@jiluleixing,�ȼ�,�ȼ���¼3,30>
        ]].. Button[4] .. [[|link=@jiluleixing,��½,��Ԫ��½,10>
        ]].. Button[5] .. [[|link=@jiluleixing,��½,�����۹�,20>
        ]].. Button[6] .. [[|link=@jiluleixing,����,��Ʒ����,30>
        ]].. Button[7] .. [[|link=@jiluleixing,����,��������1,10>
        ]].. Button[8] .. [[|link=@jiluleixing,����,��������2,20>
        ]].. Button[9] .. [[|link=@jiluleixing,����,��������3,30>
        ]].. Button[10] .. [[|link=@jiluleixing,�ƺ�,�ϸ�ţ��,10>
        ]].. Button[11] .. [[|link=@jiluleixing,�ƺ�,����ţ��,50>
        ]].. Button[12] .. [[|link=@jiluleixing,�ƺ�,��Ϯţ��,100>
        <Text|x=204.0|y=451.0|color=250|size=18|text=]].. jilu_num ..[[/8>
        <Text|x=535.0|y=115.0|color=250|size=18|text=]].. hongbao_num ..[[Ԫ>
    ]])
end
function jiluleixing(actor,sort	,Key,Num)
    local Myid = getconst(actor,"$USERACCOUNT")
    local value = readini("QuestDiary/���Խ�����¼.ini",Myid,Key)
    if value ~= "" then
        sendmsg(actor, 1, '{"Msg":"<font color=\'#FFFF00\'>���Ѿ���¼���ý�����</font>","Type":9}')
        return
    end
    ------------------------------------------------�ȼ�------------------------------------------------
    local  Level_Tbl  ={ ["�ȼ���¼1"] = 100, ["�ȼ���¼2"] = 120, ["�ȼ���¼3"] = 150 }
    if sort == "�ȼ�" then
        local MyLevel = getbaseinfo(actor,6)
        local CheckLevel = Level_Tbl[Key]
        if MyLevel >= CheckLevel then
            writeini("QuestDiary/���Խ�����¼.ini",Myid,Key,Num) 

            sendmsg(actor, 1, '{"Msg":"<font color=\'#00FF00\'>��ϲ��,��¼�ɹ�</font>","Type":9}')
        else
            sendmsg(actor, 1, '{"Msg":"<font color=\'#ff0000\'>�㻹δ�ﵽ��¼Ҫ��</font>","Type":9}')
            return
        end
    end
    ------------------------------------------------��½------------------------------------------------
    if sort == "��½" then
        local MyMapLevel = getplaydef(actor, "U54")
        local CheckMapLevel = (Key == "��Ԫ��½" and 2) or (Key == "�����۹�" and 3)
        if MyMapLevel >= CheckMapLevel then
            writeini("QuestDiary/���Խ�����¼.ini",Myid,Key,Num)
            sendmsg(actor, 1, '{"Msg":"<font color=\'#00FF00\'>��ϲ��,��¼�ɹ�</font>","Type":9}')
        else
            sendmsg(actor, 1, '{"Msg":"<font color=\'#ff0000\'>�㻹δ�ﵽ��¼Ҫ��</font>","Type":9}')
            return
        end
    end
    ------------------------------------------------����------------------------------------------------
    if sort == "����" then
        local MyTianMingNum = 0
        for i = 10, 33 do
            local Tvar = json2tbl(getplaydef(actor, "T"..i))
            local Num = Tvar[1] or 0
            if Num == 5 then
                MyTianMingNum = MyTianMingNum + 1
            end
        end
        if MyTianMingNum >= 2 then
            writeini("QuestDiary/���Խ�����¼.ini",Myid,Key,Num)
            sendmsg(actor, 1, '{"Msg":"<font color=\'#00FF00\'>��ϲ��,��¼�ɹ�</font>","Type":9}')
        else
            sendmsg(actor, 1, '{"Msg":"<font color=\'#ff0000\'>�㻹δ�ﵽ��¼Ҫ��</font>","Type":9}')
            return
        end
    end
    ------------------------------------------------����------------------------------------------------
    local F_list = {12,13,14,15,16,17,182,183,184,185}
    if sort == "����" then
        local CheckQiYun = (Key == "��������1" and 1) or (Key == "��������2" and 2) or (Key == "��������3" and 3)
        local MyQiYun = 0
        for k, v in ipairs(F_list) do
            local flag = getflagstatus(actor, v)
            MyQiYun = MyQiYun + flag
        end
        if MyQiYun >= CheckQiYun then
            writeini("QuestDiary/���Խ�����¼.ini",Myid,Key,Num) 
            sendmsg(actor, 1, '{"Msg":"<font color=\'#00FF00\'>��ϲ��,��¼�ɹ�</font>","Type":9}')
        else
            sendmsg(actor, 1, '{"Msg":"<font color=\'#ff0000\'>�㻹δ�ﵽ��¼Ҫ��</font>","Type":9}')
            return
        end
    end
    ------------------------------------------------�ƺ�------------------------------------------------
    if sort == "�ƺ�" then
        local CheckTitle = (Key == "�ϸ�ţ��" and 1) or (Key == "����ţ��" and 2) or (Key == "��Ϯţ��" and 3)
        local MyTitle = (checktitle(actor,"�ϸ�ţ��") and 1) or (checktitle(actor,"����ţ��") and 2) or (checktitle(actor,"��Ϯţ��") and 3) or 0

        if MyTitle >= CheckTitle then
            writeini("QuestDiary/���Խ�����¼.ini",Myid,Key,Num) 
            sendmsg(actor, 1, '{"Msg":"<font color=\'#00FF00\'>��ϲ��,��¼�ɹ�</font>","Type":9}')
        else
            sendmsg(actor, 1, '{"Msg":"<font color=\'#ff0000\'>�㻹δ�ﵽ��¼Ҫ��</font>","Type":9}')
            return
        end
    end
    updatetongfile('..\\QuestDiary\\���Խ�����¼.ini')   --�ϴ�ͨ��
    main(actor)
end

function ling_qu_gong_ce_jiang_li(actor)
    local Myid = getconst(actor,"$USERACCOUNT")
    local list = {"�ȼ���¼1","�ȼ���¼2","�ȼ���¼3","��Ԫ��½","�����۹�","��Ʒ����","��������1","��������2","��������3","�ϸ�ţ��","����ţ��","��Ϯţ��"}
    local jilu_num = 0
    local hongbao_num = 0
    for k, v in ipairs(list) do
        local _value = readini("QuestDiary/���Խ�����¼.ini",Myid,v)
        local value = _value == "" and 0 or tonumber(_value)
        if value >= 10 then
            jilu_num = jilu_num + 1
            else
        end
        hongbao_num = hongbao_num + value
    end
    if hongbao_num == 0  then return end
    local UserId = getconst(actor, "<$USERID>")
    if jilu_num >= 8 then
        sendmail(UserId, 666888, "���⽱��", "�𾴵��ڲ����,������...","�á�����ħͯ����߸[ʱװ]#1#".. ConstCfg.iteminfo.bind .."&���ߺ������#1#".. ConstCfg.iteminfo.bind .."&���絤#5&10Ԫ��ֵ���#".. hongbao_num / 10 .."#".. ConstCfg.iteminfo.bind .."")
    else
        sendmail(UserId, 666888, "���⽱��", "�𾴵��ڲ����,������...","10Ԫ��ֵ���#".. hongbao_num / 10 .."#".. ConstCfg.iteminfo.bind .."")
    end
    delinisection("QuestDiary/���Խ�����¼.ini",Myid)
    updatetongfile('..\\QuestDiary\\���Խ�����¼.ini')   --�ϴ�ͨ��
end




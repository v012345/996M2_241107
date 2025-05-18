XingYunXiangLian = {}
local costDaMi2 = { { "���", 2888 } }

local config = include("QuestDiary/cfgcsv/cfg_XingYunXiangLian.lua") --��������
function XingYunXiangLian.Request(actor)
    local itemobj = linkbodyitem(actor, 3)
    local xingYun = getplaydef(actor, VarCfg.U_xing_yun)
    local xingYunCount = getplaydef(actor, VarCfg.U_xing_yun_count)
    xingYun = xingYun + 1
    local cfg = config[xingYun]

    if itemobj == "0" then
        Player.sendmsgEx(actor, "��ʾ#251|:#255|��δ���|����#249|����ǿ��ʧ��...")
        return
    end

    if xingYun == 13 then
        Player.sendmsgEx(actor, "��ʾ#251|:#255|��|����#249|��ǿ����|12#249|�޷�����ǿ��...")
        GameEvent.push(EventCfg.onXingYunXiangLian,actor,12)
        return
    end
    local name, num = Player.checkItemNumByTable(actor, cfg.moneynum)
    if name then
        Player.sendmsgEx(actor, string.format("��ʾ#251|:#255|���|%s#249|,����|%dö#249|�޷�ǿ������...", name, num))
        return
    end

    Player.takeItemByTable(actor, cfg.moneynum, "��������")

    setplaydef(actor, VarCfg.U_xing_yun_count, xingYunCount + 1)


    --�ж����֮���Ƿ�ٷְٳɹ�
    local success = 0
    local tjzrFlag = getflagstatus(actor, VarCfg["F_����_���֮�˱�ʶ"])
    local todayFirst = getplaydef(actor, VarCfg["J_�������֮�˵�һ��"])
    if tjzrFlag == 1 and todayFirst == 0 then
        success = 100
        Player.sendmsgEx(actor, "[���֮��]����,�������������ɹ��ʰٷ�֮��!")
        setplaydef(actor, VarCfg["J_�������֮�˵�һ��"], 1)
    else
        success = cfg.successRate
    end
    if randomex(success) then
        setplaydef(actor, VarCfg.U_xing_yun, xingYun)
        Player.sendmsgEx(actor, "��ʾ#251|:#255|��ϲ��,ǿ��|�ɹ�#249|��������|1#249|��...")
    else
        setplaydef(actor, VarCfg.U_xing_yun, xingYun - 2)
        Player.sendmsgEx(actor, "��ʾ#251|:#255|�Բ���,ǿ��|ʧ��#249|�����½�|1#249|��...")
    end

    if getplaydef(actor, VarCfg.U_xing_yun_count) >= 288 then
        setplaydef(actor, VarCfg.U_xing_yun, 12)
        Player.sendmsgEx(actor, "��ʾ#251|:#255|��ϲ��,ǿ������|�ﵽ288��#249|����ֱ�Ӵﵽ|12#249|��...")
    end
    GameEvent.push(EventCfg.onXingYunXiangLian,actor,getplaydef(actor, VarCfg.U_xing_yun))
    XingYunXiangLian.setNecklaceAttributes(actor) --������������
    XingYunXiangLian.SyncResponse(actor)          --ͬ��һ����Ϣ
end

function XingYunXiangLian.Request2(actor)
    local itemobj = linkbodyitem(actor, 3)
    if itemobj == "0" then
        Player.sendmsgEx(actor, "ǿ������ʱ�뽫�����������������!#249")
        return
    end

    local xingYun = getplaydef(actor, VarCfg.U_xing_yun)
    if xingYun >= 12 then
        Player.sendmsgEx(actor, "��ʾ#251|:#255|��|����#249|��ǿ����|12#249|�޷�����ǿ��...")
        return
    end

    local name, num = Player.checkItemNumByTable(actor, costDaMi2)
    if name then
        Player.sendmsgEx(actor, string.format("��ʾ#251|:#255|,���|%s#249|,����|%dö#249|�޷�ǿ������...", name, num))
        return
    end

    Player.takeItemByTable(actor, costDaMi2, "��������+12")
    setplaydef(actor, VarCfg.U_xing_yun, 12)
    GameEvent.push(EventCfg.onXingYunXiangLian,actor,getplaydef(actor, VarCfg.U_xing_yun))
    messagebox(actor, "��������Ѿ�ֱ������ǿ��+12!")
    XingYunXiangLian.setNecklaceAttributes(actor) --������������
    --ͬ��һ����Ϣ
    XingYunXiangLian.SyncResponse(actor)
end

--��Ӧ��Ϣͬ��
function XingYunXiangLian.RequestSync(actor)
    XingYunXiangLian.SyncResponse(actor)
end

--������������
function XingYunXiangLian.setNecklaceAttributes(actor, itemobj)
    local xingYun = getplaydef(actor, VarCfg.U_xing_yun)
    --���û�д��ݾͻ�ȥ���ϵ�
    if not itemobj then
        itemobj = linkbodyitem(actor, 3)
    end
    local cfg = config[xingYun] or {}
    if not cfg then
        xingYun = 0
        cfg.element1 = 0
        cfg.element2 = 0
    end
    setaddnewabil(actor, -2, "=",
        string.format("3#75#%d|3#22#%d|3#30#%d", cfg.element1 or 0, cfg.element2 or 0, cfg.element2 or 0), itemobj)
    setitemaddvalue(actor, itemobj, 1, 5, xingYun)
    refreshitem(actor, itemobj)
    recalcabilitys(actor)
end

------------�������������--------------------------
local function _onTakeOnNecklace(actor, itemobj)
    XingYunXiangLian.setNecklaceAttributes(actor, itemobj)
end
local function _onTakeOffNecklace(actor, itemobj)
    --�������
    local itemobj1 = linkbodyitem(actor, 3)
    -- release_print(itemobj1, itemobj)
    setitemaddvalue(actor, itemobj, 1, 5, 0)
    setitemaddvalue(actor, itemobj1, 1, 5, 0)
    setaddnewabil(actor, -2, "=", string.format("3#75#%d|3#22#%d|3#30#%d", 0, 0, 0), itemobj)
    refreshitem(actor, itemobj)
    recalcabilitys(actor)
end

--������ǰ����
GameEvent.add(EventCfg.onTakeOnNecklace, _onTakeOnNecklace, XingYunXiangLian)

--����ǰ��������
GameEvent.add(EventCfg.onTakeOffNecklace, _onTakeOffNecklace, XingYunXiangLian)


-------------������Ϣ������--------------------------
Message.RegisterNetMsg(ssrNetMsgCfg.XingYunXiangLian, XingYunXiangLian)
--ͬ��������Ϣ
function XingYunXiangLian.SyncResponse(actor, logindatas)
    local xingYun = getplaydef(actor, VarCfg.U_xing_yun)
    local xingYunCount = getplaydef(actor, VarCfg.U_xing_yun_count)
    local tjzrFlag = getflagstatus(actor, VarCfg["F_����_���֮�˱�ʶ"]) --�Ƿ�ٷְٳɹ�
    local todayFirst = getplaydef(actor, VarCfg["J_�������֮�˵�һ��"])
    local _login_data = { ssrNetMsgCfg.XingYunXiangLian_SyncResponse, xingYun, xingYunCount, tjzrFlag, { todayFirst } }
    if logindatas then
        table.insert(logindatas, _login_data)
    else
        Message.sendmsg(actor, ssrNetMsgCfg.XingYunXiangLian_SyncResponse, xingYun, xingYunCount, tjzrFlag, { todayFirst })
    end
end

--��¼����
local function _onLoginEnd(actor, logindatas)
    XingYunXiangLian.SyncResponse(actor, logindatas)
end
--�¼��ɷ�
GameEvent.add(EventCfg.onLoginEnd, _onLoginEnd, XingYunXiangLian)



return XingYunXiangLian

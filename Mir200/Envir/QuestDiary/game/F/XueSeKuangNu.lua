local XueSeKuangNu = {}
local cost = {{"��ŭ����",1},{"����֮ŭ",1}}

function XueSeKuangNu.Request(actor, var)
    local verify = (var == 1) or(var == 2)
    if not verify then  return end
    local bool = getflagstatus(actor, VarCfg["F_Ѫɫ��ŭ".. var ..""])
    if bool == 1 then
        Player.sendmsgEx(actor, "��ʾ#251|:#255|�����ύ��װ��,�����ظ��ύ...")
    end

    local name, num = Player.checkItemNumByTable(actor, {cost[var]})
    if name then
        Player.sendmsgEx(actor, string.format("��ʾ#251|:#255|���|%s#249|����|%d#249|��,�ύʧ��...", name, num))
        return
    end
    Player.takeItemByTable(actor, {cost[var]}, "Ѫɫ��ŭ�۳�")
    setflagstatus(actor, VarCfg["F_Ѫɫ��ŭ".. var ..""],1)
    Player.setAttList(actor, "���Ը���")

    --��ӳƺ�
    if not checktitle(actor, "�޾���ŭ") then
        local bool1 = getflagstatus(actor, VarCfg["F_Ѫɫ��ŭ1"])
        local bool2 = getflagstatus(actor, VarCfg["F_Ѫɫ��ŭ2"])
        if bool1 == 1 and bool2 == 1 then
            confertitle(actor, "�޾���ŭ", 1)
            Player.setAttList(actor, "���Ը���")
        end
    end
    XueSeKuangNu.SyncResponse(actor)
end

function XueSeKuangNu.LiaoJie(actor)
    setflagstatus(actor,VarCfg["F_�˽�Ѫɫ��ŭ"],1)
end

--����ˢ��
local function _onCalcAttr(actor, attrs)
    local shuxingMap = {}
    if getflagstatus(actor, VarCfg["F_Ѫɫ��ŭ1"]) == 1 then
        shuxingMap[210] = 3 --�������ްٷֱ�
        shuxingMap[211] = 3 --ħ�����ްٷֱ�
        shuxingMap[212] = 3 --�������ްٷֱ�
    end
    
    if getflagstatus(actor, VarCfg["F_Ѫɫ��ŭ2"]) == 1 then
        shuxingMap[208] = 5 --����ֵ�ٷֱ�
    end

    if getflagstatus(actor, VarCfg.F_is_open_kuangbao) and checktitle(actor, "�޾���ŭ") then
        shuxingMap[79] = 500 --����һ�� ��ֱ�
        shuxingMap[81] = 400 --�Թ���Ѫ ��ֱ�
    end
    calcAtts(attrs, shuxingMap, "Ѫɫ��ŭ")
end
GameEvent.add(EventCfg.onCalcAttr, _onCalcAttr, XueSeKuangNu)

--ע��������Ϣ
function XueSeKuangNu.SyncResponse(actor, logindatas)
    local bool1 = getflagstatus(actor, VarCfg["F_Ѫɫ��ŭ1"])
    local bool2 = getflagstatus(actor, VarCfg["F_Ѫɫ��ŭ2"])
    local data = {bool1, bool2}

    local _login_data = { ssrNetMsgCfg.XueSeKuangNu_SyncResponse, 0, 0, 0, data} 
    if logindatas then
        table.insert(logindatas, _login_data)
    else
        Message.sendmsg(actor, ssrNetMsgCfg.XueSeKuangNu_SyncResponse, 0, 0, 0, data)
    end
end
Message.RegisterNetMsg(ssrNetMsgCfg.XueSeKuangNu, XueSeKuangNu)

--��¼����
local function _onLoginEnd(actor, logindatas)
    XueSeKuangNu.SyncResponse(actor, logindatas)
end
GameEvent.add(EventCfg.onLoginEnd, _onLoginEnd, XueSeKuangNu)

return XueSeKuangNu

local QiYuZhaoHuan = {}
local BoosName = {"���硤��������ͳ��","���硤��Ԫ��˪����","���硤������������","���硤ڤ˾ۺ�����","���硤������ħ��","���硤̫������ɳ��Ы","���硤������ա�������", "���硤���½���ʥ��"}

function QiYuZhaoHuan.Request(actor, arg1, arg2, arg3, arg4)
    local _InTheMap = getbaseinfo(actor,ConstCfg.gbase.mapid)
    local InTheMap = (_InTheMap ~= "n3") and (_InTheMap ~= "new0150")
    if InTheMap then
        local MonName = getplaydef(actor,VarCfg["S$�����ٻ�"])
        -- ----------------��֤����----------------
        local NotInTheZhaoHuan = true
        for _, v in ipairs(BoosName) do
            if v == MonName then
                NotInTheZhaoHuan = false
                break
            end
        end
        if NotInTheZhaoHuan then return  end
        ----------------��֤����----------------

        if MonName == arg4[1] then
            local MapId = getbaseinfo(actor, ConstCfg.gbase.mapid)
            local X,Y = getbaseinfo(actor, ConstCfg.gbase.x), getbaseinfo(actor, ConstCfg.gbase.y)
            genmon(MapId, X, Y, MonName, 3, 1, 255)
            setplaydef(actor, VarCfg["S$�����ٻ�"], "")
        end
    else
        if _InTheMap == "n3" then
            Player.sendmsgEx(actor, "��ʾ#251|:#255|�ٻ�ʧ��,|�����½#249|��Χ���޷��ٻ�...")
        end

        if _InTheMap == "new0150" then
            Player.sendmsgEx(actor, "��ʾ#251|:#255|�ٻ�ʧ��,|�ʹ�#249|��Χ���޷��ٻ�...")
        end
        setplaydef(actor, VarCfg["S$�����ٻ�"], "")
    end
end

function QiYuZhaoHuan.CloseUI(actor, arg1, arg2, arg3, _QDevent)
    ----------------��֤����----------------
    local verify = getplaydef(actor,VarCfg["S$�����ٻ�"])
    if verify ~= _QDevent[1] then
        Player.sendmsgEx(actor, "��ʾ#251|:#255|�Ƿ�����#249|")
        return
    end
    ----------------��֤����----------------
    QiYuHeZi.ClientAddEvent(actor,verify)
    setplaydef(actor,VarCfg["S$�����ٻ�"],"")
end

--�����¼��� ��ʼ����
local function _LuckyEventinitVar(actor, LuckyEventName)
    local IsZhaoHuan = false
    for _, v in ipairs(BoosName) do
        if v == LuckyEventName then
            IsZhaoHuan = true
            break
        end
    end

    if IsZhaoHuan then
        setplaydef(actor, VarCfg["S$�����ٻ�"], LuckyEventName)
    end
end
GameEvent.add(EventCfg.LuckyEventinitVar, _LuckyEventinitVar, QiYuZhaoHuan)

--ע��������Ϣ
Message.RegisterNetMsg(ssrNetMsgCfg.QiYuZhaoHuan, QiYuZhaoHuan)


return QiYuZhaoHuan

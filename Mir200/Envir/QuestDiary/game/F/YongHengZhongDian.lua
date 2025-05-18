local YongHengZhongDian = {}
local cost =  {
    {{"���֮��", 1},{"Ԫ��", 300000}},
    {{"ʱ����Ƭ", 1},{"Ԫ��", 300000}},
    {{"���㾫��", 1},{"Ԫ��", 300000}},
}


function YongHengZhongDian.Request(actor,var)
    -- if not checktitle(actor,"׷������֮·") then
    --     Player.sendmsgEx(actor, "��ʾ#251|:#255|�Բ���,�㻹δ����|׷������֮·#249|�޷�ʹ�øù���...")
    --     return
    -- end
    local _Type = {"���", "ʱ��", "����", "�ƺ�"}
    local CheckType = {}
    local NumTbl = {}
    local T_Table = Player.getJsonTableByVar(actor, VarCfg["T_�����յ�״̬"])
    local T_Num = Player.getJsonTableByVar(actor, VarCfg["T_�����յ����"])

    for _, k in ipairs(_Type) do
        local state = (T_Table[k] == "" and 0) or T_Table[k] or 0
        table.insert(CheckType, state)
        local Num = (T_Num[k] == nil and 0) or tonumber(T_Num[k]) or 0
        NumTbl[k] = Num
    end

    if var ~= 4 then
        if CheckType[var] == 1 then
           Player.sendmsgEx(actor, "��ʾ#251|:#255|�Բ���,����|".. cost[var][1][1] .."#249|��,�����ظ��ύ...")
           return
        end
        local name, num = Player.checkItemNumByTable(actor, cost[var])
        if name then
            Player.sendmsgEx(actor, string.format("��ʾ#251|:#255|���|%s#249|����|%d#249|ö,����ʧ��...", name, num))
            return
        end
        Player.takeItemByTable(actor, cost[var], "�۳�����")

        NumTbl[_Type[var]] = NumTbl[_Type[var]] + 1
        Player.setJsonVarByTable(actor, VarCfg["T_�����յ����"], NumTbl)
        if NumTbl[_Type[var]] >= 5 then
            Player.sendmsgEx(actor, "��ʾ#251|:#255|��ϲ��,�ɹ�����|".. cost[var][1][1] .."#249|,ս����ô������...")
            local data = { }
            for K, v in ipairs(_Type) do
                if K == var then
                    data[v] = 1
                else
                    data[v] =  CheckType[K]
                end
            end
            Player.setJsonVarByTable(actor, VarCfg["T_�����յ�״̬"], data)
            Player.setAttList(actor, "���Ը���")
        else
            if randomex(15, 100) then
                Player.sendmsgEx(actor, "��ʾ#251|:#255|��ϲ��,�ɹ�����|".. cost[var][1][1] .."#249|,ս����ô������...")
                local data = { }
                for K, v in ipairs(_Type) do
                    if K == var then
                        data[v] = 1
                    else
                        data[v] =  CheckType[K]
                    end
                end
                Player.setJsonVarByTable(actor, VarCfg["T_�����յ�״̬"], data)
                Player.setAttList(actor, "���Ը���")
            else
                Player.sendmsgEx(actor, "��ʾ#251|:#255|�Բ���,����|".. cost[var][1][1] .."#249|ʧ��,���Ͽ۳�...")
            end
        end
        YongHengZhongDian.SyncResponse(actor)
    end

    if var == 4 then
        if CheckType[var] == 1 then
            Player.sendmsgEx(actor, "��ʾ#251|:#255|�Բ���,���Ѿ���|����û���յ�#249|�ƺ���,�����ظ���ȡ...")
            return
        end

        if CheckType[1] == 0 then
            Player.sendmsgEx(actor, "��ʾ#251|:#255|�Բ���,�㻹δ�ύ|���֮��#249|�޷���ȡ...")
            return
        elseif CheckType[2] == 0 then
            Player.sendmsgEx(actor, "��ʾ#251|:#255|�Բ���,�㻹δ�ύ|ʱ����Ƭ#249|�޷���ȡ...")
            return
        elseif CheckType[3] == 0 then
            Player.sendmsgEx(actor, "��ʾ#251|:#255|�Բ���,�㻹δ�ύ|���㾫��#249|�޷���ȡ...")
            return
        else
            deprivetitle(actor,"׷������֮·")
            confertitle(actor,"����û���յ�")
            local data = { }
            for K, v in ipairs(_Type) do
                if K == var then
                    data[v] = 1
                else
                    data[v] =  CheckType[K]
                end
            end
            local liveMax = getplaydef(actor,VarCfg["U_�ȼ�����"])
            setplaydef(actor,VarCfg["U_�ȼ�����"],liveMax + 1)
            setlocklevel(actor, 1, getplaydef(actor, VarCfg["U_�ȼ�����"]))
            changelevel(actor, "+", 1)
            Player.setJsonVarByTable(actor, VarCfg["T_�����յ�״̬"], data)
            Player.sendmsgEx(actor, "��ʾ#251|:#255|��ϲ��,�ɹ�����|׷������֮·#249|,ս����ô������...")
        end
    end
end

local function _onCalcAttr(actor, attrs)
    local T_Table = Player.getJsonTableByVar(actor, VarCfg["T_�����յ�״̬"])
    local state1 = (T_Table["���"] == "" and 0) or T_Table["���"] or 0
    local state2 = (T_Table["ʱ��"] == "" and 0) or T_Table["ʱ��"] or 0
    local state3 = (T_Table["����"] == "" and 0) or T_Table["����"] or 0
    local state4 = (T_Table["�ƺ�"] == "" and 0) or T_Table["�ƺ�"] or 0
    local shuxing = {}
    local atts = {}
    if state1 == 1 then
        atts[4] = 144
    end
    if state2 == 1 then
        atts[1] = 5000
    end
    if state3 == 1 then
        atts[200] = 4444
    end
    attsMerge(atts, shuxing)
    calcAtts(attrs, shuxing, "�����յ�")
end
GameEvent.add(EventCfg.onCalcAttr, _onCalcAttr, YongHengZhongDian)




--ע��������Ϣ
function YongHengZhongDian.SyncResponse(actor, logindatas)
    local T_Table = Player.getJsonTableByVar(actor, VarCfg["T_�����յ�״̬"])
    local state1 = (T_Table["���"] == "" and 0) or T_Table["���"] or 0
    local state2 = (T_Table["ʱ��"] == "" and 0) or T_Table["ʱ��"] or 0
    local state3 = (T_Table["����"] == "" and 0) or T_Table["����"] or 0
    local state4 = (T_Table["�ƺ�"] == "" and 0) or T_Table["�ƺ�"] or 0
    local data = {state1, state2, state3, state4}
    local _login_data = { ssrNetMsgCfg.YongHengZhongDian_SyncResponse, 0, 0, 0, data }
    if logindatas then
        table.insert(logindatas, _login_data)
    else
        Message.sendmsg(actor, ssrNetMsgCfg.YongHengZhongDian_SyncResponse, 0, 0, 0, data)
    end
end
Message.RegisterNetMsg(ssrNetMsgCfg.YongHengZhongDian, YongHengZhongDian)

--��¼����
local function _onLoginEnd(actor, logindatas)
    YongHengZhongDian.SyncResponse(actor, logindatas)
end
GameEvent.add(EventCfg.onLoginEnd, _onLoginEnd, YongHengZhongDian)

Message.RegisterNetMsg(ssrNetMsgCfg.YongHengZhongDian, YongHengZhongDian)

return YongHengZhongDian

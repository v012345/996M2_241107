local QianMenBaJiang = {}
QianMenBaJiang.ID = "ǧ�Ű˽�"
local config = include("QuestDiary/cfgcsv/cfg_QianMenBaJiang.lua") --����

-- �»����	44	42

-- ����ӡ��
-- �Ὣӡ��
-- ����ӡ��
-- �ѽ�ӡ��
-- �罫ӡ��
-- ��ӡ��
-- ����ӡ��
-- ҥ��ӡ��

--��������
function QianMenBaJiang.Request(actor,var)
    --��ȡ�ƺ�
    if var == 9 then
        if checktitle(actor, "ǧ��֮��") then return end
        local data = Player.getJsonTableByVar(actor, VarCfg["T_ǧ�Ű˽�"])
        local state = true
        if table.nums(data) == 8 then
            for _, v in ipairs(data) do
                if not v.State then
                    state = false
                    break
                end
            end
        else
            state = false
        end

        if state then
            confertitle(actor, "ǧ��֮��", 1)
            local LevelMax = getplaydef(actor, VarCfg["U_�ȼ�����"])
            LevelMax = LevelMax + 1
            setplaydef(actor, VarCfg["U_�ȼ�����"], LevelMax)
            giveitem(actor, "�˽�������", 1, ConstCfg.binding, "ǧ�Ű˽���ȡ")
            Player.sendmsgEx(actor, "��ʾ#251|:#255|��ϲ����ȡ�ɹ�,�ƺ����Զ�����!")
            QianMenBaJiang.SyncResponse(actor)
        else
            Player.sendmsgEx(actor, "��ʾ#251|:#255|��û��ȫ������,��ȡʧ��!#249")
        end
    end
    if not config[var] then return end
    local Data = Player.getJsonTableByVar(actor, VarCfg["T_ǧ�Ű˽�"])
    local Type = config[var].name
    --��ȡ���������Լ�״̬
    local State = ""   --��ǰ״̬
    local Number = 0  --��ǰ����
    if Data[Type] then
        State = Data[Type].State or ""
        Number = Data[Type].Number
    end
    if State == "�Ѽ���" then return end
    local name, num = Player.checkItemNumByTable(actor, config[var].cost)
    if name then
        Player.sendmsgEx(actor, string.format("���|%s#249|��������|%d#249|,����ʧ��...", name, num))
        return
    end
    Player.takeItemByTable(actor, config[var].cost, "ǧ�Ű˽�"..Type.."�۳�")

    if Number >= 10 then
        Data[Type] = {State = "�Ѽ���", Number = Number + 1}
        Player.sendmsgEx(actor, "��ʾ#251|:#255|".. Type .."��#249|����ɹ�...")
        Player.setJsonVarByTable(actor, VarCfg["T_ǧ�Ű˽�"], Data)
        Player.setAttList(actor, "���Ը���")
        Player.setAttList(actor, "���ʸ���")
    else
        if randomex(config[var].value, 100) then
            Data[Type] = {State = "�Ѽ���", Number = Number + 1}
            Player.sendmsgEx(actor, "��ʾ#251|:#255|".. Type .."��#249|����ɹ�...")
            Player.setJsonVarByTable(actor, VarCfg["T_ǧ�Ű˽�"], Data)
            Player.setAttList(actor, "���Ը���")
            Player.setAttList(actor, "���ʸ���")
        else
            Data[Type] = {Number = Number + 1}
            Player.sendmsgEx(actor, "��ʾ#251|:#255|�Բ���,|".. Type .."��#249|����ʧ��...")
            Player.setJsonVarByTable(actor, VarCfg["T_ǧ�Ű˽�"], Data)
        end
    end
    QianMenBaJiang.SyncResponse(actor)
end

--����ˢ��
local function _onCalcAttr(actor, attrs)
    local data = Player.getJsonTableByVar(actor, VarCfg["T_ǧ�Ű˽�"])
    local shuxingMap = {}

    if data["��"] then
        if data["��"].State == "�Ѽ���" then
            shuxingMap[210] = 5 --��������5%
        end
    end

    if data["��"] then
        if data["��"].State == "�Ѽ���" then
            shuxingMap[208] = 5 --��������5%
        end
    end

    if data["��"] then
        if data["��"].State == "�Ѽ���" then
            shuxingMap[213] = 5 --��������5%
        end
    end

    if data["��"] then
        if data["��"].State == "�Ѽ���" then
            shuxingMap[25] = 5 --�����˺�����5%
        end
    end

    if data["��"] then
        if data["��"].State == "�Ѽ���" then
            shuxingMap[4] = 188 --������������188��
        end
    end

    if data["��"] then
        if data["��"].State == "�Ѽ���" then
            shuxingMap[1] = 2222 --������������2222��
        end
    end

    if data["��"] then
        if data["��"].State == "�Ѽ���" then
            shuxingMap[26] = 5  --�����˺���������5%
        end
    end
    calcAtts(attrs, shuxingMap, "ǧ�Ű˽�")
end
GameEvent.add(EventCfg.onCalcAttr, _onCalcAttr, QianMenBaJiang)

--����ˢ��
local function _onCalcBaoLv(actor, attrs)
    local data = Player.getJsonTableByVar(actor, VarCfg["T_ǧ�Ű˽�"])
    if data["ҥ"] then
        if data["ҥ"].State == "�Ѽ���" then
            local shuxing = {
                [204] = 30
            }
            calcAtts(attrs, shuxing, "ǧ�Ű˽�")
        end
    end
end
GameEvent.add(EventCfg.onCalcBaoLv, _onCalcBaoLv, QianMenBaJiang)

-- ͬ����Ϣ
function QianMenBaJiang.SyncResponse(actor, logindatas)
    local data= Player.getJsonTableByVar(actor, VarCfg["T_ǧ�Ű˽�"])
    local state = (checktitle(actor, "ǧ��֮��") and 1) or 0
    local _login_data = {ssrNetMsgCfg.QianMenBaJiang_SyncResponse, 0, 0, state, data}
    if logindatas then
        table.insert(logindatas, _login_data)
    else
        Message.sendmsg(actor, ssrNetMsgCfg.QianMenBaJiang_SyncResponse, 0, 0, state, data)
    end
end

--��¼����
local function _onLoginEnd(actor, logindatas)
    QianMenBaJiang.SyncResponse(actor, logindatas)
end
--�¼��ɷ�
GameEvent.add(EventCfg.onLoginEnd, _onLoginEnd, QianMenBaJiang)
--ע��������Ϣ
Message.RegisterNetMsg(ssrNetMsgCfg.QianMenBaJiang, QianMenBaJiang)
return QianMenBaJiang
local QiYuShiJian03 = {}

function QiYuShiJian03.Request(actor, arg1)
    ----------------��֤����----------------
    local verify = getplaydef(actor,VarCfg["S$�����¼�3"])
    if verify ~= "а���ؼ�" then
        Player.sendmsgEx(actor, "��ʾ#251|:#255|�Ƿ�����#249|")
        return
    end
    ----------------��֤����----------------
    if arg1 == 1 then
        if verify == "а���ؼ�" then
            local UserId = getconst(actor, "<$USERID>")
            sendmail(UserId, 5001, "а���ؼ�", "��ϲ������ҳx3","��ҳ#3")
            Player.sendmsgEx(actor, "��ʾ#251|:#255|��ϲ��,���|��ҳ#249|x3...")
            setplaydef(actor, VarCfg["S$�����¼�3"], "")
        end
    elseif arg1 == 2 then
        if verify == "а���ؼ�" then
            addbuff(actor, 31002, 1800, 1, actor)
            Player.setAttList(actor, "��������")
            Player.sendmsgEx(actor, "��ʾ#251|:#255|ȫ��������|+10%#249|��,����|1800#249|��...")
            setplaydef(actor, VarCfg["S$�����¼�3"], "")
        end
    end
end

--�������Դ���
local function _onAddSkillPower(actor, attrs)
    --���������ۼ�
    local shuxing = {}
    local buff = hasbuff(actor, 31002)
    if buff then
        shuxing["�һ𽣷�"] = 10
        shuxing["����ն"] = 10
        shuxing["���ս���"] = 10
    end
    calcAtts(attrs, shuxing, "����������������")
end
GameEvent.add(EventCfg.onAddSkillPower, _onAddSkillPower, QiYuShiJian03)

--buufɾ������
local function _onBuffChange(actor, buffid, groupid, model)
    if buffid ==  31002 then
        if model == 4 then
            Player.setAttList(actor, "��������")
        end
    end
end
GameEvent.add(EventCfg.onBuffChange, _onBuffChange, QiYuShiJian03)


function QiYuShiJian03.CloseUI(actor)
    ----------------��֤����----------------
    local verify = getplaydef(actor,VarCfg["S$�����¼�3"])
    if verify ~= "а���ؼ�" then
        Player.sendmsgEx(actor, "��ʾ#251|:#255|�Ƿ�����#249|")
        return
    end
    ----------------��֤����----------------
    QiYuHeZi.ClientAddEvent(actor,verify)
    setplaydef(actor,VarCfg["S$�����¼�3"],"")
end

--�����¼��� ��ʼ����
local function _LuckyEventinitVar(actor, LuckyEventName)
    if LuckyEventName == "а���ؼ�" then
        setplaydef(actor, VarCfg["S$�����¼�3"], "а���ؼ�" )
    end
end
GameEvent.add(EventCfg.LuckyEventinitVar, _LuckyEventinitVar, QiYuShiJian03)

--ע��������Ϣ
Message.RegisterNetMsg(ssrNetMsgCfg.QiYuShiJian03, QiYuShiJian03)

return QiYuShiJian03

local JiuXianLiBai = {}
JiuXianLiBai.ID = "�������"
local jiucfg = {"Ů����","��Ҷ��","��̶��","��¶","��¶��"}
local jiumnul = {750,750,550,200,200}
local varList = {VarCfg["U_Ů����"],VarCfg["U_��Ҷ��"],VarCfg["U_��̶��"],VarCfg["U_��¶"],VarCfg["U_��¶��"]}
local attdata = {"��������","Ѫ������","�и��","��������","���ʸ���"}

function JiuXianLiBai.ButtonLink1(actor ,arg1)
    if not jiucfg[arg1] then
        Player.sendmsgEx(actor, "��������!#249")
        return
    end
    
    if getplaydef(actor ,varList[arg1]) >= jiumnul[arg1]  then
        Player.sendmsgEx(actor, "��ʾ#251|:#255|���|"..jiucfg[arg1].."#249|�Ѿ��ȹ�|"..jiumnul[arg1].."ƿ#249|��...")
        return
    elseif not checkitems(actor,jiucfg[arg1].."#1",0,0)  then
        Player.sendmsgEx(actor, "��ʾ#251|:#255|���|"..jiucfg[arg1].."#249|����|1ƿ#249|����ʧ��...")
        return
    else
        takeitem(actor,jiucfg[arg1],1,0)
        setplaydef(actor,varList[arg1],getplaydef(actor ,varList[arg1])+1)
        if arg1 == 5 then
            Player.setAttList(actor, "���ʸ���")
        else
            Player.setAttList(actor, "���Ը���")
        end
    end
    JiuXianLiBai.SyncResponse(actor)
end


function JiuXianLiBai.ButtonLink2(actor)

    if getplaydef(actor,VarCfg["U_Ů����"]) < 750 then
        Player.sendmsgEx(actor, "��ʾ#251|:#255|���|Ů����#249|���Ʋ���|750ƿ#249|��ȡʧ��...")
    return
    end

    if getplaydef(actor,VarCfg["U_��Ҷ��"]) < 750 then
        Player.sendmsgEx(actor, "��ʾ#251|:#255|���|��Ҷ��#249|���Ʋ���|750ƿ#249|��ȡʧ��...")
    return
    end

    if getplaydef(actor,VarCfg["U_��̶��"]) < 550 then
        Player.sendmsgEx(actor, "��ʾ#251|:#255|���|��̶��#249|���Ʋ���|750ƿ#249|��ȡʧ��...")
    return
    end

    if getplaydef(actor,VarCfg["U_��¶"]) < 200 then
        Player.sendmsgEx(actor, "��ʾ#251|:#255|���|��¶#249|���Ʋ���|750ƿ#249|��ȡʧ��...")
    return
    end

    if getplaydef(actor,VarCfg["U_��¶��"]) < 200 then
        Player.sendmsgEx(actor, "��ʾ#251|:#255|���|��¶��#249|���Ʋ���|750ƿ#249|��ȡʧ��...")
    return
    end

    if checktitle(actor,"�Ҳ��Ǿ���")  then
        Player.sendmsgEx(actor, "��ʾ#251|:#255|������ȡ|�Ҳ��Ǿ���#249|�ƺ�...")
    return
    end
    confertitle(actor,"�Ҳ��Ǿ���",1)
    Player.sendmsgEx(actor,"��ϲ���ɹ���ȡ|�Ҳ��Ǿ���#249|�ƺ�...")
    Player.setAttList(actor, "���ʸ���")
    Player.setAttList(actor, "���Ը���")
    JiuXianLiBai.SyncResponse(actor)
end

   --ͬ����Ϣ
function JiuXianLiBai.SyncResponse(actor, logindatas)
    local U111 = getplaydef(actor,VarCfg["U_Ů����"])
    local U112 = getplaydef(actor,VarCfg["U_��Ҷ��"])
    local U113 = getplaydef(actor,VarCfg["U_��̶��"])
    local U114 = getplaydef(actor,VarCfg["U_��¶"])
    local U115 = getplaydef(actor,VarCfg["U_��¶��"])
    local data = {U111,U112,U113,U114,U115}

    local _login_data = {ssrNetMsgCfg.JiuXianLiBai_SyncResponse, 0, 0, 0, data}
    if logindatas then
        table.insert(logindatas, _login_data)
    else
        Message.sendmsg(actor, ssrNetMsgCfg.JiuXianLiBai_SyncResponse, 0, 0, 0, data)
    end
end

local function _onCalcAttr(actor,attrs)
    local GuDing_HP = 0
    local GuDing_GongJi = 0
    local qiege = 0
    local mianshang = 0
    local U111 = getplaydef(actor,VarCfg["U_Ů����"])
    local U112 = getplaydef(actor,VarCfg["U_��Ҷ��"])
    local U113 = getplaydef(actor,VarCfg["U_��̶��"])
    local U114 = getplaydef(actor,VarCfg["U_��¶"])

    if U111 > 0 then
        GuDing_GongJi = U111 * 1
    end

    if U112 > 0 then
        GuDing_HP = GuDing_HP + U112*20
    end

    if U113 > 0 then
        qiege = U113 * 8
    end

    if U114 > 0 then
        mianshang = U114 * 10
    end

    local shuxingMap = {
        [1] = GuDing_HP,
        [4] = GuDing_GongJi,
        [200] = qiege,
        [215] = mianshang
    }
    local shuxing = {}
    for key, value in pairs(shuxingMap) do
        if value > 0 then
            shuxing[key] = value
        end
    end
    calcAtts(attrs,shuxing,"С�ƹ�")
end

--����
GameEvent.add(EventCfg.onCalcAttr, _onCalcAttr, JiuXianLiBai)

--���ʸ��Ӽ���
local function _onCalcBaoLv(actor,attrs)
    local shuxing = {}
    local U115 = getplaydef(actor,VarCfg["U_��¶��"])
    if U115 > 0 then
        shuxing[204] = U115
    end
    calcAtts(attrs,shuxing,"���ʸ���:С�ƹ�")
end
--���ʼ���
GameEvent.add(EventCfg.onCalcBaoLv, _onCalcBaoLv, JiuXianLiBai)

--��¼����
local function _onLoginEnd(actor, logindatas)
    JiuXianLiBai.SyncResponse(actor, logindatas)
end
--�¼��ɷ�
GameEvent.add(EventCfg.onLoginEnd, _onLoginEnd, JiuXianLiBai)

--ע��������Ϣ
Message.RegisterNetMsg(ssrNetMsgCfg.JiuXianLiBai, JiuXianLiBai)
return JiuXianLiBai
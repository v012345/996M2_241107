local QiYuShiJian17 = {}
local config = include("QuestDiary/cfgcsv/cfg_LuckyEvent_QianZhuangLaoBan.lua")

function QiYuShiJian17.Request(actor, arg1)
    ------------------------------��֤����--------------------------------
    local verify = getplaydef(actor,VarCfg["S$�����¼�17"])
    if verify ~= "Ǯׯ�ϰ�" then
        Player.sendmsgEx(actor, "��ʾ#251|:#255|�Ƿ�����#249|")
        return
    end
    ------------------------------��֤����--------------------------------
    local cfg = config[arg1]
    local var1 = getplaydef(actor, VarCfg["J_".. cfg.varname ..""])

    if var1 >= 3 then
        Player.sendmsgEx(actor, "��ʾ#251|:#255|�Ѷһ�|3#249|��...")
        return
    end

    local name, num = Player.checkItemNumByTable(actor, cfg.price)
    if name then
        Player.sendmsgEx(actor, string.format("��ʾ#251|:#255|���|%s#249|����|%d#249|...", name, num))
        return
    end

    Player.takeItemByTable(actor, cfg.price, "����")
    Player.giveItemByTable(actor,cfg.item,"Ǯׯ�ϰ�")
    setplaydef(actor, VarCfg["J_".. cfg.varname ..""], var1 + 1)
    QiYuShiJian17.SyncResponse(actor)
    GameEvent.push(EventCfg.onQianZhuangLaoBanBuy, actor)
end


--ע��������Ϣ
function QiYuShiJian17.SyncResponse(actor)
    local num1 = getplaydef(actor, VarCfg["J_Ǯׯ�޹�1"])
    local num2 = getplaydef(actor, VarCfg["J_Ǯׯ�޹�2"])
    local num3 = getplaydef(actor, VarCfg["J_Ǯׯ�޹�3"])
    local num4 = getplaydef(actor, VarCfg["J_Ǯׯ�޹�4"])
    local num5 = getplaydef(actor, VarCfg["J_Ǯׯ�޹�5"])
    local num6 = getplaydef(actor, VarCfg["J_Ǯׯ�޹�6"])
    local data = {num1,num2,num3,num4,num5,num6}
    Message.sendmsg(actor, ssrNetMsgCfg.QiYuShiJian17_SyncResponse, 0, 0, 0, data)
end
Message.RegisterNetMsg(ssrNetMsgCfg.QiYuShiJian17, QiYuShiJian17)


function QiYuShiJian17.CloseUI(actor)
    ----------------��֤����----------------
    local verify = getplaydef(actor,VarCfg["S$�����¼�17"])
    if verify ~= "Ǯׯ�ϰ�" then
        Player.sendmsgEx(actor, "��ʾ#251|:#255|�Ƿ�����#249|")
        return
    end
    ----------------��֤����----------------
    QiYuHeZi.ClientAddEvent(actor,verify)
    setplaydef(actor,VarCfg["S$�����¼�17"],"")
end

--�����¼��� ��ʼ����
local function _LuckyEventinitVar(actor, LuckyEventName,hezi)
    if LuckyEventName == "Ǯׯ�ϰ�" then
        if hezi == "���Ӵ�" then
            setplaydef(actor, VarCfg["S$�����¼�17"], "Ǯׯ�ϰ�" )
            QiYuShiJian17.SyncResponse(actor)
        else
            setplaydef(actor, VarCfg["J_Ǯׯ�޹�1"], 0 )
            setplaydef(actor, VarCfg["J_Ǯׯ�޹�2"], 0 )
            setplaydef(actor, VarCfg["J_Ǯׯ�޹�3"], 0 )
            setplaydef(actor, VarCfg["J_Ǯׯ�޹�4"], 0 )
            setplaydef(actor, VarCfg["J_Ǯׯ�޹�5"], 0 )
            setplaydef(actor, VarCfg["J_Ǯׯ�޹�6"], 0 )
            setplaydef(actor, VarCfg["S$�����¼�17"], "Ǯׯ�ϰ�" )
        end
    end
end
GameEvent.add(EventCfg.LuckyEventinitVar, _LuckyEventinitVar, QiYuShiJian17)



return QiYuShiJian17

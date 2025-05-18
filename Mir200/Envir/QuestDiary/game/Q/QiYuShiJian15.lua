local QiYuShiJian15 = {}

local config = include("QuestDiary/cfgcsv/cfg_LuckyEvent_YunYouShangRen.lua")

function QiYuShiJian15.Request(actor, arg1)
        ------------------------------��֤����--------------------------------
    local verify = getplaydef(actor,VarCfg["S$�����¼�15"])
    if verify ~= "��������" then
        Player.sendmsgEx(actor, "��ʾ#251|:#255|�Ƿ�����#249|")
        return
    end
        ------------------------------��֤����--------------------------------
    local cfg = config[arg1]
    local var1 = getplaydef(actor, VarCfg["J_".. cfg.varname ..""])

    if var1 >= 3 then
        Player.sendmsgEx(actor, "��ʾ#251|:#255|�ѹ���|3#249|��...")
        return
    end

    local name, num = Player.checkItemNumByTable(actor, cfg.price)
    if name then
        Player.sendmsgEx(actor, string.format("��ʾ#251|:#255|���|%s#249|����|%d#249|...", name, num))
        return
    end
    Player.takeItemByTable(actor, cfg.price, "����")
    Player.giveItemByTable(actor,cfg.item,"��������", 1, true)
    setplaydef(actor, VarCfg["J_".. cfg.varname ..""], var1 + 1)
    QiYuShiJian15.SyncResponse(actor)
    GameEvent.push(EventCfg.onYunYouShangRneBuy, actor)
end


--ע��������Ϣ
function QiYuShiJian15.SyncResponse(actor)
    local num1 = getplaydef(actor, VarCfg["J_�����޹�1"])
    local num2 = getplaydef(actor, VarCfg["J_�����޹�2"])
    local num3 = getplaydef(actor, VarCfg["J_�����޹�3"])
    local num4 = getplaydef(actor, VarCfg["J_�����޹�4"])
    local num5 = getplaydef(actor, VarCfg["J_�����޹�5"])
    local num6 = getplaydef(actor, VarCfg["J_�����޹�6"])
    local num7 = getplaydef(actor, VarCfg["J_�����޹�7"])
    local num8 = getplaydef(actor, VarCfg["J_�����޹�8"])
    local data = {num1,num2,num3,num4,num5,num6,num7,num8}
    Message.sendmsg(actor, ssrNetMsgCfg.QiYuShiJian15_SyncResponse, 0, 0, 0, data)
end
Message.RegisterNetMsg(ssrNetMsgCfg.QiYuShiJian15, QiYuShiJian15)


function QiYuShiJian15.CloseUI(actor)
    ----------------��֤����----------------
    local verify = getplaydef(actor,VarCfg["S$�����¼�15"])
    if verify ~= "��������" then
        Player.sendmsgEx(actor, "��ʾ#251|:#255|�Ƿ�����#249|")
        return
    end
    ----------------��֤����----------------
    QiYuHeZi.ClientAddEvent(actor,verify)
    setplaydef(actor,VarCfg["S$�����¼�15"],"")
end

--�����¼��� ��ʼ����
local function _LuckyEventinitVar(actor, LuckyEventName,hezi)
    if LuckyEventName == "��������" then
        if hezi == "���Ӵ�" then
            setplaydef(actor, VarCfg["S$�����¼�15"], "��������" )
            QiYuShiJian15.SyncResponse(actor)
        else
            setplaydef(actor, VarCfg["J_�����޹�1"], 0 )
            setplaydef(actor, VarCfg["J_�����޹�2"], 0 )
            setplaydef(actor, VarCfg["J_�����޹�3"], 0 )
            setplaydef(actor, VarCfg["J_�����޹�4"], 0 )
            setplaydef(actor, VarCfg["J_�����޹�5"], 0 )
            setplaydef(actor, VarCfg["J_�����޹�6"], 0 )
            setplaydef(actor, VarCfg["J_�����޹�7"], 0 )
            setplaydef(actor, VarCfg["J_�����޹�8"], 0 )
            setplaydef(actor, VarCfg["S$�����¼�15"], "��������" )
        end
    end
end
GameEvent.add(EventCfg.LuckyEventinitVar, _LuckyEventinitVar, QiYuShiJian15)







return QiYuShiJian15

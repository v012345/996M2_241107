local ShouChong = {}
local give = { { "�󶨽��", 2000000 }, { "�����ħ����", 20 }, { "쫷�֮��", 1 }, { "�����䵶[����]", 1 } }
function ShouChong.Request(actor, arg1, arg2, arg3, data)
    if getflagstatus(actor, VarCfg["F_�Ƿ��׳�"]) == 1 then
        Player.sendmsgEx(actor, "���Ѿ���ȡ���׳���!")
        return
    end
 
    local ChongZhiNum = getplaydef(actor, VarCfg["U_��ʵ��ֵ"])
    if ChongZhiNum >= 10 then
        setplaydef(actor, VarCfg["U_�ռ������ħ����"], 20) --ħ��������
        local mailTitle = "��ȡ�����׳佱��!"
        local mailContent = "��л����ţ���Ĭ��֧�֣�����ȡ���Ľ�����\\�ƺ�[ţ������]���Զ�����\\��ù������ܹһ�\\�����ѡ֮���ʸ�"
        local userID = getbaseinfo(actor, ConstCfg.gbase.id)
        Player.giveMailByTable(userID, 1, mailTitle, mailContent, give, 1, true)
        addskill(actor, 25, 3)
        setflagstatus(actor, VarCfg["F_�Ƿ��׳�"], 1)
        if getplaydef(actor,"N$�׳���") == 1 then
            setplaydef(actor,"N$�׳���",0)
            Message.sendmsg(actor, ssrNetMsgCfg.ShouChong_AddRedPoint, 0, 0, 0, {})
        end
        Player.sendmsgEx(actor, "��ʾ#251|:#255|��ϲ��,���|�׳帣��#249|,�����ѷ������ʼ�,ף����Ϸ���...")
        TopIcon.addico(actor)
        Message.sendmsg(actor, ssrNetMsgCfg.ShouChong_CloseUI)
    else
        local cType = tonumber(getconst(actor,"<$CLIENTFLAG>"))
        if cType == 1 then
            generalappopenchargewnd.main(actor, 10, "��ֵ","��ǰ��ֵΪ��ͨ��ֵ���Ի�����г�ֵ����")
        else
            pullpay(actor, 10, 1, 7)
        end
        --Player.sendmsgEx(actor, "��ʾ#251|:#255|�Բ���,����׳岻��|10Ԫ#249|,��ȡʧ��...")
    end
end

local function _onRechargeEnd(actor)
    delaygoto(actor,500,"shouchong_init_redpoint")
end

function shouchong_init_redpoint(actor)
    if getflagstatus(actor, VarCfg["F_�Ƿ��׳�"]) == 0 then
        if getplaydef(actor, VarCfg["U_��ʵ��ֵ"]) >= 10 then
            setplaydef(actor,"N$�׳���",1)
            Message.sendmsg(actor, ssrNetMsgCfg.ShouChong_AddRedPoint, 1, 0, 0, {})
        end
    end
end

GameEvent.add(EventCfg.onLogin,_onRechargeEnd,ShouChong)
GameEvent.add(EventCfg.onRechargeEnd, _onRechargeEnd,ShouChong)
Message.RegisterNetMsg(ssrNetMsgCfg.ShouChong, ShouChong)
return ShouChong

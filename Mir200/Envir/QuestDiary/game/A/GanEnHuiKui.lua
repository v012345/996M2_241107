local GanEnHuiKui = {}

--��ǰ���ճ����

function GanEnHuiKui.Request(actor,  var)
    if var == 1 then
        local heQuDay = tonumber(getconst("0", "<$HFCOUNT>"))
        if heQuDay == 0 then
            Player.sendmsgEx(actor, "��ʾ#251|:#255|��ǰ����|��δ����#249|�������鿴...")
        else
            Message.sendmsg(actor, ssrNetMsgCfg.GanEnHuiKui_OpenClientUI, 0, 0, 0, nil)
        end
    end

    if var == 2 then
        local ZhiGouBoll = getflagstatus(actor, VarCfg["F_���״̬"])
        if ZhiGouBoll == 0 then
            Player.sendmsgEx(actor, "��ʾ#251|:#255|�Բ���,�㲻��|��Ȩ���#249|�޷���ȡ...")
            return
        end
        local LingQuState = getplaydef(actor, VarCfg["Z_ÿ����Ȩ�����ȡ״̬"])
        if LingQuState == "����ȡ" then
            Player.sendmsgEx(actor, "��ʾ#251|:#255|�Բ���,������Ѿ���ȡ��|��Ȩ���#249|��,�뵽��������...")
            return
        end
        giveitem(actor,"10Ԫ��ֵ���",1,ConstCfg.binding,"�ж��ÿ����ȡ")
        giveitem(actor,"ÿ����Ȩ���",1,ConstCfg.binding,"�ж��ÿ����ȡ")
        setplaydef(actor, VarCfg["Z_ÿ����Ȩ�����ȡ״̬"],"����ȡ")
        GanEnHuiKui.SyncResponse(actor)
    end

    if var == 3 then
        if checktitle(actor,"�ж�����") then
            Player.sendmsgEx(actor, "��ʾ#251|:#255|�Բ���,������ȡ��|�ж�����#249|�ƺ���...")
            return
        end
        confertitle(actor,"�ж�����",1)
        Player.sendmsgEx(actor, "��ʾ#251|:#255|��ϲ��,���|�ж�����#249|�ƺ�...")
        Player.setAttList(actor, "���Ը���")
    end

end

--ע��������Ϣ
function GanEnHuiKui.SyncResponse(actor)
    local LingQuBoll = getplaydef(actor, VarCfg["Z_ÿ����Ȩ�����ȡ״̬"])
    local data = {LingQuBoll}
    Message.sendmsg(actor, ssrNetMsgCfg.GanEnHuiKui_SyncResponse, 0, 0, 0, data)
end
Message.RegisterNetMsg(ssrNetMsgCfg.GanEnHuiKui, GanEnHuiKui)

return GanEnHuiKui

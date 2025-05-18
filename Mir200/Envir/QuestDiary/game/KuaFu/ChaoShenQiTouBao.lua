local ChaoShenQiTouBao = {}
ChaoShenQiTouBao.ID = "������Ͷ��"
local npcID = 714
--local config = include("QuestDiary/cfgcsv/cfg_ChaoShenQiTouBao.lua") --����
local cost = { {"���",1000} }
--��������
function ChaoShenQiTouBao.Request(actor, arg1, arg2, arg3, data)
    if not data then
        Player.sendmsgEx(actor, "��������1!#249")
        return
    end
    if not data.makeid then
        Player.sendmsgEx(actor, "��������2!#249")
        return
    end
    if data.makeid <= 0 then
        Player.sendmsgEx(actor, "��������3!#249")
        return
    end
    if not data.where then
        Player.sendmsgEx(actor, "��������3!#249")
        return
    end
    local itemObj
    if data.where > 0 then
        itemObj = linkbodyitem(actor, data.where)
    else
        itemObj = getitembymakeindex(actor, data.makeid)
    end
    if itemObj == "0" then
        Player.sendmsgEx(actor, "��ȡװ������ʧ��!#249")
        return
    end
    local touBaoCount = getitemaddvalue(actor, itemObj, 1, 45, 0)
    if touBaoCount >= 3 then
        Player.sendmsgEx(actor, "���ֻ��Ͷ������!#249")
        return
    end
    if querymoney(actor, 7) < 1000 then
        Player.sendmsgEx(actor, "����������|1000#249|ֻ��ʹ�÷ǰ����!")
        return
    end
    changemoney(actor, 7, "-", 1000, "������Ͷ��", true)
    setitemaddvalue(actor, itemObj, 1, 45, touBaoCount + 1)
    refreshitem(actor,itemObj)
    ChaoShenQiTouBao.SyncResponse(actor)
end

--ͬ����Ϣ
function ChaoShenQiTouBao.SyncResponse(actor)
    Message.sendmsg(actor, ssrNetMsgCfg.ChaoShenQiTouBao_SyncResponse, 0, 0, 0, {})
end
-- --��¼����
-- local function _onLoginEnd(actor, logindatas)
--     ChaoShenQiTouBao.SyncResponse(actor, logindatas)
-- end
-- --�¼��ɷ�
-- GameEvent.add(EventCfg.onLoginEnd, _onLoginEnd, ChaoShenQiTouBao)
--ע��������Ϣ
Message.RegisterNetMsg(ssrNetMsgCfg.ChaoShenQiTouBao, ChaoShenQiTouBao)
return ChaoShenQiTouBao

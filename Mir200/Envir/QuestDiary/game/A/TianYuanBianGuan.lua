local TianYuanBianGuan = {}
TianYuanBianGuan.ID = "��Ԫ�߹�"
local npcID = 118
--local config = include("QuestDiary/cfgcsv/cfg_TianYuanBianGuan.lua") --����
local mapID = "��Ԫ�߹�"
--��������
function TianYuanBianGuan.Request(actor)
    if not FCheckLevel(actor, 60) then
        Player.sendmsgEx(actor,"�ȼ�����60��,����ʧ��!#249")
        return
    end

    FSetTaskRedPoint(actor, VarCfg["F_������Ԫ�߹����"], 2)
    FMapMoveEx(actor, mapID, 98, 91, 3)
end
--ͬ����Ϣ
-- function TianYuanBianGuan.SyncResponse(actor, logindatas)
--     local data = {}
--     local _login_data = {ssrNetMsgCfg.TianYuanBianGuan_SyncResponse, 0, 0, 0, data}
--     if logindatas then
--         table.insert(logindatas, _login_data)
--     else
--         Message.sendmsg(actor, ssrNetMsgCfg.TianYuanBianGuan_SyncResponse, 0, 0, 0, data)
--     end
-- end
-- --��¼����
-- local function _onLoginEnd(actor, logindatas)
--     TianYuanBianGuan.SyncResponse(actor, logindatas)
-- end
-- --�¼��ɷ�
-- GameEvent.add(EventCfg.onLoginEnd, _onLoginEnd, TianYuanBianGuan)
--ע��������Ϣ
Message.RegisterNetMsg(ssrNetMsgCfg.TianYuanBianGuan, TianYuanBianGuan)
return TianYuanBianGuan
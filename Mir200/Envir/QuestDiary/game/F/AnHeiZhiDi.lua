local AnHeiZhiDi = {}
AnHeiZhiDi.ID = "����֮��"
local npcID = 3456
--local config = include("QuestDiary/cfgcsv/cfg_AnHeiZhiDi.lua") --����
local cost = {{}}
local give = {{}}
function chuansongdianfengdengji(actor)
    if getplaydef(actor,VarCfg["U_��¼��½"]) >= 5 then
        FOpenNpcShowEx(actor, 422)
    else
        Player.sendmsgEx(actor, "�ұ�����!#249")
    end
end

--��������
function AnHeiZhiDi.Request(actor)
    local var = getplaydef(actor,VarCfg["U_�۷�ȼ�1"])
    if var < 1 then
        messagebox(actor,"����۷塤��������1�أ��Ƿ�ǰ��������", "@chuansongdianfengdengji", "@quxiao")
        return
    end
    FMapMoveEx(actor, "����֮��", 207, 47, 0)
    --local name, num = Player.checkItemNumByTable(actor, cost)
    --if name then
        --Player.sendmsgEx(actor, string.format("���|%s#249|����|%d#249", name, num))
        --return
    --end
end
--ͬ����Ϣ
-- function AnHeiZhiDi.SyncResponse(actor, logindatas)
--     local data = {}
--     local _login_data = {ssrNetMsgCfg.AnHeiZhiDi_SyncResponse, 0, 0, 0, data}
--     if logindatas then
--         table.insert(logindatas, _login_data)
--     else
--         Message.sendmsg(actor, ssrNetMsgCfg.AnHeiZhiDi_SyncResponse, 0, 0, 0, data)
--     end
-- end
-- --��¼����
-- local function _onLoginEnd(actor, logindatas)
--     AnHeiZhiDi.SyncResponse(actor, logindatas)
-- end
-- --�¼��ɷ�
-- GameEvent.add(EventCfg.onLoginEnd, _onLoginEnd, AnHeiZhiDi)
--ע��������Ϣ
Message.RegisterNetMsg(ssrNetMsgCfg.AnHeiZhiDi, AnHeiZhiDi)
return AnHeiZhiDi
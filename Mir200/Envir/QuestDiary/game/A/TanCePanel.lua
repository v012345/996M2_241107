local TanCePanel = {}
TanCePanel.ID = "̽��Panel"
--local config = include("QuestDiary/cfgcsv/cfg_TanCePanel.lua") --����
local cost = {{"���",50}}
--��������
function TanCePanel.Request(actor,arg1,arg2,arg3,data)
    if not data then
        Player.sendmsgEx(actor, "��������!")
        return
    end
    if not checktitle(actor,"����֮��") then
        Player.sendmsgEx(actor, "���|ƽ�н���#249|�����������|̽�⹦��#249")
        return
    end    
    local name, num = Player.checkItemNumByTable(actor, cost)
    if name then
        Player.sendmsgEx(actor, string.format("̽��ʧ��,���|%s#249|����|%d#249", name, num))
        return
    end
    local userName = data[1]
    if userName == "" then
        Player.sendmsgEx(actor, "������ֲ����ǿ�#249")
        return
    end
    local userObj = getplayerbyname(userName)
    if not userObj then
        Player.sendmsgEx(actor, userName.."#249|������")
        return
    end
    Player.takeItemByTable(actor, cost, "̽��")
    local targetMapName = getbaseinfo(userObj, ConstCfg.gbase.map_title)
    local targetMapx = getbaseinfo(userObj, ConstCfg.gbase.x)
    local targetMapy = getbaseinfo(userObj, ConstCfg.gbase.y)
    local str = userName.." �� ".. targetMapName.."("..targetMapx..","..targetMapy..")"
    Message.sendmsg(actor, ssrNetMsgCfg.TanCePanel_SyncResponse, 0, 0, 0, {str})
end
-- --��¼����
-- local function _onLoginEnd(actor, logindatas)
--     TanCePanel.SyncResponse(actor, logindatas)
-- end
-- --�¼��ɷ�
-- GameEvent.add(EventCfg.onLoginEnd, _onLoginEnd, TanCePanel)
--ע��������Ϣ
Message.RegisterNetMsg(ssrNetMsgCfg.TanCePanel, TanCePanel)
return TanCePanel
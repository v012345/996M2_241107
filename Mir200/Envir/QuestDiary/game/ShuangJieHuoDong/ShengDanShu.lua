local ShengDanShu = {}
ShengDanShu.ID = "ʥ����"
local npcID = 159
local config = include("QuestDiary/cfgcsv/cfg_ShengDanShu.lua") --����
local give = {{}}
--��������
function ShengDanShu.Request(actor,index)
    local cfg = config[index]
    if not cfg then
        Player.sendmsgEx(actor, "��������#249")
        return
    end
    local cost = cfg.cost
    local name, num = Player.checkItemNumByTable(actor, cost)
    if name then
        Player.sendmsgEx(actor, string.format("���|%s#249|����|%d#249", name, num))
        return
    end
    Player.takeItemByTable(actor, cost, "ʥ����")
    --���ͽ������ʼ�
    local reward = cfg.give
    local uid = Player.GetUUID(actor)
    local mailTitle = "ʥ��������"
    local mailContent = "����ȡ���ʥ��������"
    Player.giveMailByTable(uid, 1, mailTitle, mailContent, reward,1,true)
    Player.sendmsgEx(actor, "�����ѷ��������䣬����գ�")
    ShengDanShu.SyncResponse(actor)
end
--ͬ����Ϣ
function ShengDanShu.SyncResponse(actor)
    local data = {}
    Message.sendmsg(actor, ssrNetMsgCfg.ShengDanShu_SyncResponse, 0, 0, 0, data)
end
-- --��¼����
-- local function _onLoginEnd(actor, logindatas)
--     ShengDanShu.SyncResponse(actor, logindatas)
-- end
-- --�¼��ɷ�
-- GameEvent.add(EventCfg.onLoginEnd, _onLoginEnd, ShengDanShu)
--ע��������Ϣ
Message.RegisterNetMsg(ssrNetMsgCfg.ShengDanShu, ShengDanShu)
return ShengDanShu
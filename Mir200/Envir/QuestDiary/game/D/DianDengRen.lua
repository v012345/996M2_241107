local DianDengRen = {}
local config = include("QuestDiary/cfgcsv/cfg_DianDengRen.lua")     --����
-- -- local config = include("QuestDiary/cfgcsv/cfg_DianDengRen.lua")     --����

function DianDengRen.Request(actor,npcID)
    -- release_print(npcID)

    local cfg = config[npcID]

    if not cfg then
        Player.sendmsgEx(actor,"��������!")
        return
    end

    if checktitle(actor, "ڤ��������") then
        Player.sendmsgEx(actor, "��ʾ#251|:#255|�Բ���,��|ȫ������#249|ʮ��յڤ��...")
        return
    end

    if checktitle(actor, cfg.titleNmae) then
        Player.sendmsgEx(actor, "��ʾ#251|:#255|�Բ���,���ѵ���|".. cfg.titleNmae .."#249|�����ظ�����...")
        return
    end 

    local name, num = Player.checkItemNumByTable(actor, cfg.cost)
    if name then
        Player.sendmsgEx(actor, string.format("��ʾ#251|:#255|���|%s#249|����|%d#249|...", name, num))
        return
    end

    Player.takeItemByTable(actor, cfg.cost, "����˿۳�����")
    confertitle(actor, cfg.titleNmae, 1)
    messagebox(actor,"��ϲ�������["..cfg.titleNmae.."]")
    Message.sendmsg(actor, ssrNetMsgCfg.DianDengRen_SyncResponse, 0, 0, 0, nil)

    local num = 401
    for i = 1 , table.nums(config) do   
        if checktitle(actor, config[num].titleNmae) then
            num = num + 1
        else
            num = 401
            break
        end
    end

    if num == 413 then
        num = 401
        for i = 1, table.nums(config) do
            deprivetitle(actor, config[num].titleNmae)
            num = num + 1
        end
        confertitle(actor, "ڤ��������", 1)
        Player.sendmsgEx(actor, "��ʾ#251|:#255|��ϲ��,��ȫ������|ʮ��յڤ��#249|���|ڤ��������#249|�ƺ�...")
    end
    Player.setAttList(actor, "���ʸ���")
end

--ע��������Ϣ
Message.RegisterNetMsg(ssrNetMsgCfg.DianDengRen, DianDengRen)

return DianDengRen

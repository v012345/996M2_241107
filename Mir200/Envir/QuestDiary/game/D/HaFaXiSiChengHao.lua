local HaFaXiSiChengHao = {}
local config = include("QuestDiary/cfgcsv/cfg_HaFaXiSiChengHao.lua")     --����
local CheckTitle = {"������˹��ս��Lv1","������˹��ս��Lv2", "������˹��ս��Lv3", "������˹��ս��Lv4", "������˹��ս��Lv5"}
function HaFaXiSiChengHao.Request(actor)
    local CheckNum = 0
    for k, v in ipairs(CheckTitle) do
        if checktitle(actor, v) then
            CheckNum = k
            break
        end
    end
    local cfg = {}
    if CheckNum == 5  then
        Player.sendmsgEx(actor, "��ʾ#251|:#255|���|������˹��ս��#249|�Ѿ��ﵽ|����#249|...")
        return
    else
        cfg = config[CheckNum+1]
    end

    -- dump(cfg)
    local name, num = Player.checkItemNumByTable(actor, cfg.Cost)
    if name then
        Player.sendmsgEx(actor, string.format("��ʾ#251|:#255|���|%s#249|����|%d#249|...", name, num))
        return
    end
    Player.takeItemByTable(actor, cfg.Cost, "������˹��ս�߿۳�����")

    --ɾ��һ�������˹�ƺź����
    for _, v in ipairs(CheckTitle) do
        deprivetitle(actor, v)
    end
    confertitle(actor, cfg.Title, 1)

    --ͬ��һ��ǰ�˽���
    Message.sendmsg(actor, ssrNetMsgCfg.HaFaXiSiChengHao_SyncResponse, 0, 0, 0, {})
end
--ע��������Ϣ
Message.RegisterNetMsg(ssrNetMsgCfg.HaFaXiSiChengHao, HaFaXiSiChengHao)
return HaFaXiSiChengHao

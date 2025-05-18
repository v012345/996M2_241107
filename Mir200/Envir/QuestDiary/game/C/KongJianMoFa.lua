local KongJianMoFa = {}
local config = include("QuestDiary/cfgcsv/cfg_KongJianMoFa.lua")     --�����ļ�
function KongJianMoFa.Request(actor)
    local posEquipName = getconst(actor,"<$SCHARM>")
    if posEquipName == "" or posEquipName == nil then
        Player.sendmsgEx(actor,"�봩���ö�ת�����������Ұ�!")
        return
    end
    if posEquipName == "��ת����[��]+10" then
        Player.sendmsgEx(actor,"�㵱ǰ�Ѿ�����ߵȼ��Ķ�ת������!#249")
        return
    end
    local cfg = config[posEquipName]
    local name,num = Player.checkItemNumByTable(actor,cfg.cost)
    if name then
        Player.sendmsgEx(actor, string.format("[��ʾ]:#251|����ʧ��,���|%s#249|����|%d#249", name, num))
        return
    end
    Player.takeItemByTable(actor,cfg.cost,"��ת��������")
    takew(actor,posEquipName,1)
    giveonitem(actor, 29, cfg.give, 1)
    FSetTaskRedPoint(actor, VarCfg["F_��ת�������"], 14)
    Player.sendmsgEx(actor, string.format("[��ʾ]:#251|��ϲ��,�����ɹ�,��ȥ����Ч����!#250", name, num))
end

-----ע��������Ϣ
Message.RegisterNetMsg(ssrNetMsgCfg.KongJianMoFa, KongJianMoFa)

return KongJianMoFa

local KongJianMoFa = {}
local config = include("QuestDiary/cfgcsv/cfg_KongJianMoFa.lua")     --配置文件
function KongJianMoFa.Request(actor)
    local posEquipName = getconst(actor,"<$SCHARM>")
    if posEquipName == "" or posEquipName == nil then
        Player.sendmsgEx(actor,"请穿戴好斗转星移在来找我吧!")
        return
    end
    if posEquipName == "斗转星移[精]+10" then
        Player.sendmsgEx(actor,"你当前已经是最高等级的斗转星移了!#249")
        return
    end
    local cfg = config[posEquipName]
    local name,num = Player.checkItemNumByTable(actor,cfg.cost)
    if name then
        Player.sendmsgEx(actor, string.format("[提示]:#251|晋级失败,你的|%s#249|不足|%d#249", name, num))
        return
    end
    Player.takeItemByTable(actor,cfg.cost,"斗转星移提升")
    takew(actor,posEquipName,1)
    giveonitem(actor, 29, cfg.give, 1)
    FSetTaskRedPoint(actor, VarCfg["F_斗转星移完成"], 14)
    Player.sendmsgEx(actor, string.format("[提示]:#251|恭喜你,晋升成功,快去看看效果吧!#250", name, num))
end

-----注册网络消息
Message.RegisterNetMsg(ssrNetMsgCfg.KongJianMoFa, KongJianMoFa)

return KongJianMoFa

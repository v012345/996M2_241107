local WuPinXiaoHui = {}
local config = include("QuestDiary/cfgcsv/cfg_JingZhiXiaoHui.lua") --����ħ����
function WuPinXiaoHui.Request(actor,arg1,arg2,arg3)
    if type(arg1) ~= "number" then
        Player.sendmsgEx(actor,"��������!")
        return
    end
    local itemName = Item.getNameMakeid(actor,arg1)
    if config[itemName] then
        Player.sendmsgEx(actor,"��".. itemName .."����ֹ����!")
        return
    end
    local isSuccess = delitembymakeindex(actor,tostring(arg1),0,"��Ʒ����")
    if not isSuccess then
        Player.sendmsgEx(actor,"��Ʒ����ʧ��,����!#249")
    else
        if itemName then
            Player.sendmsgEx(actor,"��".. itemName .."����Ʒ���ٳɹ�!")
        end
    end
end
--ע��������Ϣ
Message.RegisterNetMsg(ssrNetMsgCfg.WuPinXiaoHui, WuPinXiaoHui)
return WuPinXiaoHui

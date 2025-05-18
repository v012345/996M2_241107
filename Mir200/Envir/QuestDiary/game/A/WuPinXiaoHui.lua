local WuPinXiaoHui = {}
local config = include("QuestDiary/cfgcsv/cfg_JingZhiXiaoHui.lua") --大神魔配置
function WuPinXiaoHui.Request(actor,arg1,arg2,arg3)
    if type(arg1) ~= "number" then
        Player.sendmsgEx(actor,"参数错误!")
        return
    end
    local itemName = Item.getNameMakeid(actor,arg1)
    if config[itemName] then
        Player.sendmsgEx(actor,"【".. itemName .."】禁止销毁!")
        return
    end
    local isSuccess = delitembymakeindex(actor,tostring(arg1),0,"物品销毁")
    if not isSuccess then
        Player.sendmsgEx(actor,"物品销毁失败,请检查!#249")
    else
        if itemName then
            Player.sendmsgEx(actor,"【".. itemName .."】物品销毁成功!")
        end
    end
end
--注册网络消息
Message.RegisterNetMsg(ssrNetMsgCfg.WuPinXiaoHui, WuPinXiaoHui)
return WuPinXiaoHui

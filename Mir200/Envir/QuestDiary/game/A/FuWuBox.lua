local FuWuBox = {}
local config = include("QuestDiary/cfgcsv/cfg_JingZhiXiaoHui.lua") --禁止销毁


--物品销毁
function FuWuBox.XiaoHuiWuPin(actor,arg1,arg2,arg3)
    if type(arg1) ~= "number" then
        Player.sendmsgEx(actor,"参数错误!")
        return
    end
    local itemName = Item.getNameMakeid(actor,arg1)
    if config[itemName] then
        Player.sendmsgEx(actor,"【".. itemName .."】禁止销毁!#249")
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

--消息屏蔽
function FuWuBox.PingBiXiaoXi(actor)
    local state = getflagstatus(actor,VarCfg["F_过滤全服信息"])
    if state == 0 then
        filterglobalmsg(actor, 1)
        setflagstatus(actor,VarCfg["F_过滤全服信息"], 1)
        Player.sendmsgEx(actor,"开启过滤全服掉落提示信息。#249")
    else
        filterglobalmsg(actor, 0)
        setflagstatus(actor,VarCfg["F_过滤全服信息"], 0)
        Player.sendmsgEx(actor,"关闭过滤全服掉落提示信息。#249")
    end
end

--注册网络消息
Message.RegisterNetMsg(ssrNetMsgCfg.FuWuBox, FuWuBox)
return FuWuBox

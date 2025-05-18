local EquipMake3 = {}
EquipMake3.ID = 15200
EquipMake3.where = 14 --装备位置
function EquipMake3.Request(actor)
    local equipInfo = linkbodyitem(actor, EquipMake3.where)
    local equipIndex
    local heChengInfo
    if equipInfo == "0" then
        heChengInfo = cfg_zhangu.null
    else
        equipIndex = getiteminfo(actor, equipInfo, 2)
        heChengInfo = cfg_zhangu[equipIndex]
    end
    if heChengInfo == nil then
        Player.sendmsg(actor, "网络错误，请再次尝试")
        return
    end
    if equipIndex == heChengInfo.upleve then
        Player.sendmsg(actor, "合成失败，您的战鼓已经满级了！")
        return
    end
    local name, num = Player.checkItemNumByTable(actor, heChengInfo.consume)
    if name then
        Player.sendmsg(actor, "合成失败，您的" .. name .. "不足" .. num)
        return
    end
    if equipInfo ~= "0" then
        if Player.takeItemToBody(actor, EquipMake3.where) == false then
            Player.sendmsg(actor, "合成失败，身上装备不存在！")
            return
        end
    end
    Player.takeItemByTable(actor, heChengInfo.consume, "战鼓合成")
    local equipName = getstditeminfo(heChengInfo.upleve, ConstCfg.stditeminfo.name)
    giveonitem(actor, EquipMake3.where, equipName, 1, 0)
    local userName = getbaseinfo(actor, ConstCfg.gbase.name)
    local msgData = {}
    local priveatMsg = ""
    if equipName == "[二十阶]璀璨星河战鼓" then
        msgData = {
            { "", "恭喜玩家[" },
            { "242", userName },
            { "", "]成功合成满级战鼓[" },
            { "242", equipName },
            { "", "]，可喜可贺！" },
        }
        Player.sendcentermsg(actor, 250, 0, msgData)
    else
        msgData = {
            { "", "恭喜玩家[" },
            { "242", userName },
            { "", "]成功合成装备[" },
            { "242", equipName },
            { "", "]，可喜可贺！" },
        }
        Player.sendmsgnew(actor, 250, 0, msgData)
    end
    Player.sendmsg(actor, "恭喜您成功合成"..equipName)
    Player.screffects(actor, 60364,90)
    
end

--注册网络消息
Message.RegisterNetMsg(ssrNetMsgCfg.EquipMake3, EquipMake3)
return EquipMake3

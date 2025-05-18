local EquipMake4 = {}
EquipMake4.ID = 15300
EquipMake4.where = 9 --装备位置
function EquipMake4.Request(actor)
    local equipInfo = linkbodyitem(actor, EquipMake4.where)
    local equipIndex
    local heChengInfo
    if equipInfo == "0" then
        heChengInfo = cfg_hufu.null
    else
        equipIndex = getiteminfo(actor, equipInfo, 2)
        heChengInfo = cfg_hufu[equipIndex]
    end
    if heChengInfo == nil then
        Player.sendmsg(actor, "网络错误，请再次尝试")
        return
    end
    if equipIndex == heChengInfo.upleve then
        Player.sendmsg(actor, "合成失败，您的护符已经满级了！")
        return
    end
    local name, num = Player.checkItemNumByTable(actor, heChengInfo.consume)
    if name then
        Player.sendmsg(actor, "合成失败，您的" .. name .. "不足" .. num)
        return
    end
    if equipInfo ~= "0" then
        if Player.takeItemToBody(actor, EquipMake4.where) == false then
            Player.sendmsg(actor, "合成失败，身上装备不存在！")
            return
        end
    end
    Player.takeItemByTable(actor, heChengInfo.consume, "护符合成")
    local equipName = getstditeminfo(heChengInfo.upleve, ConstCfg.stditeminfo.name)
    giveonitem(actor, EquipMake4.where, equipName, 1, 0)
    local userName = getbaseinfo(actor, ConstCfg.gbase.name)
    local msgData = {}
    local priveatMsg = ""
    if equipName == "[二十阶]璀璨星河护符" then
        msgData = {
            { "", "恭喜玩家[" },
            { "242", userName },
            { "", "]成功合成满级护符[" },
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
Message.RegisterNetMsg(ssrNetMsgCfg.EquipMake4, EquipMake4)
return EquipMake4

local EquipMake2 = {}
EquipMake2.ID = 15100
EquipMake2.where = 15 --装备位置
function EquipMake2.Request(actor)
    local equipInfo = linkbodyitem(actor, EquipMake2.where)
    local equipIndex
    local heChengInfo
    if equipInfo == "0" then
        heChengInfo = cfg_shenyin.null
    else
        equipIndex = getiteminfo(actor, equipInfo, 2)
        heChengInfo = cfg_shenyin[equipIndex]
    end
    if heChengInfo == nil then
        Player.sendmsg(actor, "网络错误，请再次尝试")
        return
    end
    if equipIndex == heChengInfo.upleve then
        Player.sendmsg(actor, "合成失败，您的神印已经满级了！")
        return
    end
    local name, num = Player.checkItemNumByTable(actor, heChengInfo.consume)
    if name then
        Player.sendmsg(actor, "合成失败，您的" .. name .. "不足" .. num)
        return
    end
    if equipInfo ~= "0" then
        if Player.takeItemToBody(actor, EquipMake2.where) == false then
            Player.sendmsg(actor, "合成失败，身上装备不存在！")
            return
        end
    end
    Player.takeItemByTable(actor, heChengInfo.consume, "神印合成")
    local equipName = getstditeminfo(heChengInfo.upleve, ConstCfg.stditeminfo.name)
    giveonitem(actor, EquipMake2.where, equipName, 1, 0)
    local userName = getbaseinfo(actor, ConstCfg.gbase.name)
    local msgData = {}
    local priveatMsg = ""
    if equipName == "[二十阶]璀璨星河印鉴" then
        msgData = {
            { "", "恭喜玩家[" },
            { "242", userName },
            { "", "]成功合成满级神印[" },
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
Message.RegisterNetMsg(ssrNetMsgCfg.EquipMake2, EquipMake2)
return EquipMake2

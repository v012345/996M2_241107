local JiLuShi = {}
local config = include("QuestDiary/cfgcsv/cfg_BuKeJiLuDiTu.lua") --不可被记录地图
--记录坐标
function JiLuShi.Record(actor,avr1)
    local tab = {
        name = getbaseinfo(actor,ConstCfg.gbase.map_title),
        map = getbaseinfo(actor,ConstCfg.gbase.mapid),
        x = getbaseinfo(actor,ConstCfg.gbase.x),
        y = getbaseinfo(actor,ConstCfg.gbase.y)
    }
    local myName = getbaseinfo(actor, ConstCfg.gbase.name)
    if string.find(tab.map, myName) then
        Player.sendmsgEx(actor,"副本地图禁止记录#249")
        return
    end
    if config[tab.map] then
        Player.sendmsgEx(actor, "提示#251|:#255|地图|".. tab.name .."#249|无法被记录...")
        return
    end
    Player.setJsonVarByTable(actor, VarCfg["T_记录石".. avr1 ..""], tab)
    JiLuShi.SyncResponse(actor)
end

--传送坐标
function JiLuShi.Move(actor,avr1)
    local tab = Player.getJsonTableByVar(actor, VarCfg["T_记录石".. avr1 ..""])
    if tab.map then
        if getbindmoney(actor, "灵符") >= 1 then
            mapmove(actor, tab.map, tab.x, tab.y, 0)
            Player.takeItemByTable(actor,{{"灵符",1}},"使用记录石")
            GameEvent.push(EventCfg.onUseJiLuShi,actor)
        else
            Player.sendmsgEx(actor, "提示#251|:#255|你的|灵符#249不足|1枚#249|传送失败...")
        end
    else
        Player.sendmsgEx(actor, "提示#251|:#255|你未记录|地图信息#249|传送失败...")      
    end
    Message.sendmsg(actor, ssrNetMsgCfg.JiLuShi_Move, 0, 0, 0, nil)
end

function JiLuShi.SyncResponse(actor)
    local tab1 = Player.getJsonTableByVar(actor, VarCfg["T_记录石1"])
    local tab2 = Player.getJsonTableByVar(actor, VarCfg["T_记录石2"])
    local tab3 = Player.getJsonTableByVar(actor, VarCfg["T_记录石3"])
    local tab4 = Player.getJsonTableByVar(actor, VarCfg["T_记录石4"])
    local tab5 = Player.getJsonTableByVar(actor, VarCfg["T_记录石5"])
    local tab6 = Player.getJsonTableByVar(actor, VarCfg["T_记录石6"])
    local data = { tab1, tab2, tab3, tab4, tab5, tab6 }
    Message.sendmsg(actor, ssrNetMsgCfg.JiLuShi_SyncResponse, 0, 0, 0, data)
end
--注册网络消息
Message.RegisterNetMsg(ssrNetMsgCfg.JiLuShi, JiLuShi)


return JiLuShi
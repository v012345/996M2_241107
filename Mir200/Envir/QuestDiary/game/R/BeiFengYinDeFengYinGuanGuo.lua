local BeiFengYinDeFengYinGuanGuo = {}
BeiFengYinDeFengYinGuanGuo.ID = "被封印的封印棺椁"
local npcID = 233
local config = include("QuestDiary/cfgcsv/cfg_BeiFengYinDeFengYinGuanGuo.lua") --暗域裂隙
local gives = {{"被封印的棺材", 1}}
--领取1
function BeiFengYinDeFengYinGuanGuo.Request1(actor)
    local flag1 = getflagstatus(actor, VarCfg["F_剧情_被封印的封印棺椁_是否领取1"])
    if flag1 == 1 then
        FSetTaskRedPoint(actor, VarCfg["F_被封印的棺材使用_完成"], 12)
        Player.sendmsgEx(actor,"你已经完成了领取过了，请勿重复领取！#249")
        return
    end
    local skillMon1 = getplaydef(actor, VarCfg["U_剧情_被封印的封印棺椁_杀怪1"])
    if skillMon1 >= 400 then
        Player.giveItemByTable(actor, gives, "被封印的封印棺椁", 1, true)
        setflagstatus(actor, VarCfg["F_剧情_被封印的封印棺椁_是否领取1"],1)
        Player.sendmsgEx(actor,"领取成功！")
        FSetTaskRedPoint(actor, VarCfg["F_被封印的棺材使用_完成"], 12)
        BeiFengYinDeFengYinGuanGuo.SyncResponse(actor)
    else
        Player.sendmsgEx(actor,"击杀怪物不足|400#249|领取失败!")
        return
    end

end
--领取2
function BeiFengYinDeFengYinGuanGuo.Request2(actor)
    local flag2 = getflagstatus(actor, VarCfg["F_剧情_被封印的封印棺椁_是否领取2"])
    if flag2 == 1 then
        FSetTaskRedPoint(actor, VarCfg["F_被封印的棺材使用_完成"], 12)
        Player.sendmsgEx(actor,"你已经完成了领取过了，请勿重复领取！#249")
        return
    end
    local skillMon2 = getplaydef(actor, VarCfg["U_剧情_被封印的封印棺椁_杀怪2"])
    if skillMon2 >= 10 then
        Player.giveItemByTable(actor, gives, "被封印的封印棺椁", 1, true)
        setflagstatus(actor, VarCfg["F_剧情_被封印的封印棺椁_是否领取2"],1)
        Player.sendmsgEx(actor,"领取成功！")
        FSetTaskRedPoint(actor, VarCfg["F_被封印的棺材使用_完成"], 12)
        BeiFengYinDeFengYinGuanGuo.SyncResponse(actor)
    else
        Player.sendmsgEx(actor,"击杀怪物不足|10#249|领取失败!")
        return
    end
end
--同步消息
function BeiFengYinDeFengYinGuanGuo.SyncResponse(actor)
    local skillMon1 = getplaydef(actor, VarCfg["U_剧情_被封印的封印棺椁_杀怪1"])
    local skillMon2 = getplaydef(actor, VarCfg["U_剧情_被封印的封印棺椁_杀怪2"])
    local flag1 = getflagstatus(actor, VarCfg["F_剧情_被封印的封印棺椁_是否领取1"])
    local flag2 = getflagstatus(actor, VarCfg["F_剧情_被封印的封印棺椁_是否领取2"])
    local data = {skillMon1, skillMon2}
    Message.sendmsg(actor, ssrNetMsgCfg.BeiFengYinDeFengYinGuanGuo_SyncResponse, flag1, flag2, 0, data)
end
-- --登录触发
-- local function _onLoginEnd(actor, logindatas)
--     BeiFengYinDeFengYinGuanGuo.SyncResponse(actor, logindatas)
-- end
-- --事件派发
-- GameEvent.add(EventCfg.onLoginEnd, _onLoginEnd, BeiFengYinDeFengYinGuanGuo)
--杀怪触发
local function _onKillMon(actor, monobj, monName)
    local cfg = config[monName]
    if cfg then
        local num = getplaydef(actor, cfg.var)
        if num < cfg.maxNum then
            setplaydef(actor, cfg.var, num + 1)
        end
    end
end
GameEvent.add(EventCfg.onKillMon, _onKillMon, BeiFengYinDeFengYinGuanGuo)
--注册网络消息
Message.RegisterNetMsg(ssrNetMsgCfg.BeiFengYinDeFengYinGuanGuo, BeiFengYinDeFengYinGuanGuo)
return BeiFengYinDeFengYinGuanGuo

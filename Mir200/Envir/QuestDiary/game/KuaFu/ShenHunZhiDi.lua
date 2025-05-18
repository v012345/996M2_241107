local ShenHunZhiDi = {}
local config = include("QuestDiary/cfgcsv/cfg_ShenHunZhiDi.lua") --配置
local MonCfg = include("QuestDiary/cfgcsv/cfg_ShenHunShuaGuai_Data.lua") --刷怪配置

function ShenHunZhiDi.Request(actor, var)
    if not FCheckNPCRange(actor, var, 15) then
        Player.sendmsgEx(actor, "距离PNC太远!#249")
        return
    end
    local cfg = config[var]
    if not cfg then
        return
    end
    --检测攻击力
    local MyPower = Player.GetPower(actor)
    local CheckPower = cfg.Power
    if MyPower < CheckPower then
        Player.sendmsgEx(actor, "提示#251|:#255|你的战力不足|" .. cfg.Power .. "#249|进入失败...")
        return
    end
    --检测神魂等级
    local MyLevle = getplaydef(actor, VarCfg["U_魂装等级"])
    local CheckLevle = cfg.Level
    if MyLevle < CheckLevle then
        Player.sendmsgEx(actor, "提示#251|:#255|你的神魂等级不足|" .. cfg.Level .. "级#249|进入失败...")
        return
    end
    --检测是否在跨服里面
    if not checkkuafu(actor) then
        Player.sendmsgEx(actor, "提示#251|:#255|我报警了...")
        return
    end
    local name = getbaseinfo(actor, ConstCfg.gbase.name)
    sendmsg("0", 2, '{"Msg":"[' .. name .. ']进入' .. cfg.MapID .. '","FColor":251,"BColor":0,"Type":6,"Time":6,"SendName":"系统：","SendId":"123","X":"-300"}')
    map(actor, cfg.MapID)

    --同步一次前端消息
    -- Message.sendmsg(actor, ssrNetMsgCfg.ShenHunZhiDi_SyncResponse, 0, 0, 0, nil)
end

--神魂之地刷怪
function shen_hun_shua_guai()
    killmonsters("神魂蝶谷", "*", 0, false)
    killmonsters("神魂魔窟", "*", 0, false)
    killmonsters("神魂古庙", "*", 0, false)
    killmonsters("神魂暗殿", "*", 0, false)
    if checkkuafuserver() then
        for _, v in ipairs(MonCfg) do
            local CheckScope = 500
            if v.IsBoos == 1 then
                CheckScope = 1
            end
            genmon(v.MapID, v.X, v.Y, v.MonName, CheckScope, v.MonNum, v.Color)
        end
    end
end

Message.RegisterNetMsg(ssrNetMsgCfg.ShenHunZhiDi, ShenHunZhiDi)
return ShenHunZhiDi

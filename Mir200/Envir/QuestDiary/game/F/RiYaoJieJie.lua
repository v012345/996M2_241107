local RiYaoJieJie = {}
-- local config = include("QuestDiary/cfgcsv/cfg_TaiYangShengCheng_Mon.lua") -- 配置信息
local cost = {{"日耀精华", 1},{"风之圣纹", 1},{"海灵之泪", 1},{"冰魂结晶", 1},{"圣火遗灰", 1}}

function RiYaoJieJie.Request(actor,var1)
    




    local cfg = cost[var1]
    if not cfg then
        Player.sendmsgEx(actor, "提示#251|:#255|参数错误,提交失败...")
        return
    end
    local bool = getflagstatus(actor, VarCfg["F_破除日耀_激活标识".. var1 ..""])
    if bool == 1 then
        Player.sendmsgEx(actor, "提示#251|:#255|对不起,你已提交|".. cost[1][1] .."#249|了,请勿重复提交...")
        return
    end
    local name, num = Player.checkItemNumByTable(actor, {cost[var1]})
    if name then
        Player.sendmsgEx(actor, string.format("提示#251|:#255|你的|%s#249|不足|%d#249|枚,提交失败...", name, num))
        return
    end
    Player.takeItemByTable(actor, {cost[var1]}, "日耀激活扣除")
    local AttNum = getplaydef(actor, VarCfg["U_日耀结界_伤害压制"])
    setplaydef(actor, VarCfg["U_日耀结界_伤害压制"],  AttNum + 18)
    setflagstatus(actor, VarCfg["F_破除日耀_激活标识".. var1 ..""], 1)
    if not checktitle(actor, "日耀终结者") then
        local JiHuoNum = 0
        for i = 1, 5 do
            local _bool = getflagstatus(actor, VarCfg["F_破除日耀_激活标识".. i ..""])
            if _bool == 1 then
                JiHuoNum = JiHuoNum + 1
            end
        end
        if JiHuoNum == 5 then
            confertitle(actor, "日耀终结者", 1)
            Player.setAttList(actor, "属性附加")
        end
    end
    RiYaoJieJie.SyncResponse(actor)
end

-- 攻击怪物前触发
-- local function _onAttackDamageMonster(actor, Target, Hiter, MagicId, Damage, Model, attackDamageData)
--     local MonName = getbaseinfo(Target,ConstCfg.gbase.name)
--     local Mon = config[MonName]
--     if Mon then
--         local AttNum = getplaydef(actor, VarCfg["U_日耀结界_伤害压制"])
--         AttNum = AttNum / 100 
--         attackDamageData.damage = attackDamageData.damage - Damage * (0.9 - AttNum)
--     end
-- end
-- GameEvent.add(EventCfg.onAttackDamageMonster, _onAttackDamageMonster, RiYaoJieJie)

--注册网络消息
function RiYaoJieJie.SyncResponse(actor, logindatas)
    local bool1 = getflagstatus(actor, VarCfg["F_破除日耀_激活标识1"])
    local bool2 = getflagstatus(actor, VarCfg["F_破除日耀_激活标识2"])
    local bool3 = getflagstatus(actor, VarCfg["F_破除日耀_激活标识3"])
    local bool4 = getflagstatus(actor, VarCfg["F_破除日耀_激活标识4"])
    local bool5 = getflagstatus(actor, VarCfg["F_破除日耀_激活标识5"])
    local data ={ bool1,bool2,bool3,bool4,bool5 }

    local _login_data = { ssrNetMsgCfg.RiYaoJieJie_SyncResponse, 0, 0, 0, data }
    if logindatas then
        table.insert(logindatas, _login_data)
    else
        Message.sendmsg(actor, ssrNetMsgCfg.RiYaoJieJie_SyncResponse, 0, 0, 0, data)
    end
end
Message.RegisterNetMsg(ssrNetMsgCfg.RiYaoJieJie, RiYaoJieJie)


--登录触发
local function _onLoginEnd(actor, logindatas)
    RiYaoJieJie.SyncResponse(actor, logindatas)
end
GameEvent.add(EventCfg.onLoginEnd, _onLoginEnd, RiYaoJieJie)


return RiYaoJieJie


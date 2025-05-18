local TianJieZhiLu = {}
TianJieZhiLu.ID = "天劫之路"
local npcID = 503
--local config = include("QuestDiary/cfgcsv/cfg_TianJieZhiLu.lua") --配置
local cost = { { "元宝", 500000 } }
local give = { {} }
--接收请求
function TianJieZhiLu.Request(actor)
    if checktitle(actor, "仙凡有别") then
        Player.sendmsgEx(actor, "你已经通过了天劫之路#249")
        return
    end
    if not checkitemw(actor, "潜龙阴阳石", 1) then
        Player.sendmsgEx(actor, "你的|修仙等级#249|没有达到|潜龙境#249|无法挑战")
        return
    end
    local name, num = Player.checkItemNumByTable(actor, cost)
    if name then
        Player.sendmsgEx(actor, string.format("你的|%s#249|不足|%d#249", name, num))
        return
    end
    Player.takeItemByTable(actor, cost, "天劫之路")
    local myName = getbaseinfo(actor, ConstCfg.gbase.name)
    local oldMapId = getbaseinfo(actor, ConstCfg.gbase.mapid)
    local x = getbaseinfo(actor, ConstCfg.gbase.x)
    local y = getbaseinfo(actor, ConstCfg.gbase.y)
    local newMapId = myName .. "天劫之路"
    if checkmirrormap(newMapId) then
        delmirrormap(newMapId)
    end
    addmirrormap("05570", newMapId, "天劫之路", 600, oldMapId, 010088, x, y)
    --创建连接点
    mapeffect(1001, newMapId, 235, 14, 17009, 600, 1, actor)
    addmapgate(newMapId, newMapId, 235, 14, 2, oldMapId, 66, 20, 600)
    mapmove(actor, newMapId, 13, 236, 0)
    setontimer(actor, 5, 1)
    setplaydef(actor, VarCfg["M_天劫之路"],1)
end

local function _onDuJieOnTiemr(actor)
    local num = getplaydef(actor, VarCfg["U_万劫不灭丹保底"])
    if num >= 25 then
        addbuff(actor, 31032)
    end
    if not hasbuff(actor, 31032) then
        local hpper = Player.getHpValue(actor, 40)
        humanhp(actor, "-", hpper)
    end
    Player.screffects(actor, 17534, 0, 100)
end

GameEvent.add(EventCfg.onDuJieOnTiemr, _onDuJieOnTiemr, TianJieZhiLu)

local function _goSwitchMap(actor, cur_mapid, former_mapid, x, y)
    if string.find(former_mapid, "天劫之路") then
        setofftimer(actor, 5)
        delmirrormap(former_mapid)
    end
end

GameEvent.add(EventCfg.goSwitchMap, _goSwitchMap, TianJieZhiLu)

local function _onBeforerOute(actor, mapid, x, y)
    if mapid == "极恶大陆" and x == 66 and y == 20 then
        confertitle(actor, "仙凡有别")
        setplaydef(actor, VarCfg["U_修仙境界_伤害压制"], 1)
        local myName = getbaseinfo(actor, ConstCfg.gbase.name)
        Player.sendmsgnewEx(actor, 0, 0, string.format("玩家|%s#253|通过了|[天劫之路]#249|获得称号|[%s]#249|实力获得大幅提升", myName, "仙凡有别"))
        messagebox(actor, "恭喜你成功通过[天劫之路],获得称号:[仙凡有别]")
        Player.setAttList(actor, "爆率附加")
        Player.setAttList(actor, "攻速附加")
        Player.setAttList(actor, "属性附加")
    end
end
GameEvent.add(EventCfg.onBeforerOute, _onBeforerOute, TianJieZhiLu)

local function _onCalcAttackSpeed(actor, attackSpeeds)
    if checktitle(actor, "仙凡有别") then
        attackSpeeds[1] = attackSpeeds[1] + 20
    end
end
--攻速属性
GameEvent.add(EventCfg.onCalcAttackSpeed, _onCalcAttackSpeed, TianJieZhiLu)

-- VarCfg["U_修仙境界_伤害压制"]
--攻击前触发
local function _onAttackDamagePlayer(actor, Target, Hiter, MagicId, Damage, Model, attackDamageData)
    local myXXLevel = getplaydef(actor, VarCfg["U_修仙境界_伤害压制"])
    local targetXXLevel = getplaydef(Target, VarCfg["U_修仙境界_伤害压制"])
    if myXXLevel > targetXXLevel then
        attackDamageData.damage = attackDamageData.damage + math.ceil(Damage * 0.1)
    end
end
GameEvent.add(EventCfg.onAttackDamagePlayer, _onAttackDamagePlayer, TianJieZhiLu)

--注册网络消息
Message.RegisterNetMsg(ssrNetMsgCfg.TianJieZhiLu, TianJieZhiLu)
return TianJieZhiLu

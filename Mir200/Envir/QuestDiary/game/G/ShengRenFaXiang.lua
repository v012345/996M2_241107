local ShengRenFaXiang = {}
ShengRenFaXiang.ID = "圣人法相"
local cost = { { "元宝", 8880000 } }

local buffFlagMaps = {
    [31095] = VarCfg["F_风之法相"],
    [31096] = VarCfg["F_火之法相"],
    [31097] = VarCfg["F_水之法相"],
    [31098] = VarCfg["F_土之法相"],
}

--获取激活状态
function getFlagVar(actor)
    local Bool1 = getflagstatus(actor, VarCfg["F_风隙劫击杀标识"])
    local Bool2 = getflagstatus(actor, VarCfg["F_火焰劫击杀标识"])
    local Bool3 = getflagstatus(actor, VarCfg["F_水镜劫击杀标识"])
    local Bool4 = getflagstatus(actor, VarCfg["F_土缚劫击杀标识"])
    local data = { Bool1, Bool2, Bool3, Bool4 }
    return data
end

--接收请求
function ShengRenFaXiang.Request(actor)
    if not checktitle(actor, "仙凡有别") then
        Player.sendmsgEx(actor, "提示#251|:#255|你还未激活|仙凡有别#249|称号,激活失败...")
        return
    end

    if checktitle(actor, "圣人之资") then
        Player.sendmsgEx(actor, "提示#251|:#255|你已激活|圣人之资#249|称号,请勿重复激活...")
        return
    end

    local data = getFlagVar(actor)
    local FuBenName = { "风隙劫", "火焰劫", "水镜劫", "土缚劫" }
    for k, v in ipairs(data) do
        if v == 0 then
            Player.sendmsgEx(actor, "提示#251|:#255|你还未通过|" .. FuBenName[k] .. "#249|副本,激活失败...")
            return
        end
    end

    local name, num = Player.checkItemNumByTable(actor, cost)
    if name then
        Player.sendmsgEx(actor, string.format("提示#251|:#255|你的|%s#249|不足|%d#249|枚,激活失败...", name, num))
        return
    end
    Player.takeItemByTable(actor, cost, "激活法相天地扣除")

    --添加人物称号
    confertitle(actor, "圣人之资", 1)
    setflagstatus(actor, VarCfg["F_圣人之资"], 1)
    -- Player.setAttList(actor, "攻速附加")
    Player.setAttList(actor, "属性附加")
    giveitem(actor, "ζ法相天地ζ", 1, ConstCfg.binding, "法相天地激活")
end

-- 同步消息
function ShengRenFaXiang.SyncResponse(actor, logindatas)
    local data = getFlagVar(actor)
    local _login_data = { ssrNetMsgCfg.ShengRenFaXiang_SyncResponse, 0, 0, 0, data }
    if type(logindatas) == "table" then
        table.insert(logindatas, _login_data)
    else
        Message.sendmsg(actor, ssrNetMsgCfg.ShengRenFaXiang_SyncResponse, 0, 0, 0, data)
    end
end

Message.RegisterNetMsg(ssrNetMsgCfg.ShengRenFaXiang, ShengRenFaXiang)

local function _onCalcAttackSpeed(actor, attackSpeeds)
    if checktitle(actor, "圣人之资") then
        attackSpeeds[1] = attackSpeeds[1] + 30
    end
end
--攻速属性
GameEvent.add(EventCfg.onCalcAttackSpeed, _onCalcAttackSpeed, ShengRenFaXiang)

--攻击触发前触发  对修仙等级比自己低的玩家增加15%伤害
local function _onAttackDamagePlayer(actor, Target, Hiter, MagicId, Damage, Model, attackDamageData)
    if not getflagstatus(actor, VarCfg["F_圣人之资"]) == 0 then return end
    local MyLevelx = getplaydef(actor, VarCfg["U_修仙等级"])
    local TgtLevelx = getplaydef(Target, VarCfg["U_修仙等级"])
    if MyLevelx > TgtLevelx then
        attackDamageData.damage = attackDamageData.damage + (Damage * 0.15)
    end

    -- [业火红莲]：攻击有5%概率释放业火红莲，对周围3X3范围内玩家造成10%最大生命伤害，并灼烧目标5秒，每秒损失2%最大生命值。 CD:8S
    if getflagstatus(actor, buffFlagMaps[31096]) == 1 then
        if randomex(100, 100) then
            if Player.checkCd(actor, VarCfg["业火红莲CD"], 8, true) then
                playeffect(actor, 63121, 0, 0, 1, 1, 0)  --特效
                local MapID = Player.MapKey(actor)
                if checkkuafu(actor) then
                    MapID = Player.GetVarMap(actor)
                end
                local x, y = Player.GetX(actor), Player.GetY(actor)
                local playList = getobjectinmap(MapID, x, y, 3, 1)                --遍历自身周围3格内的玩家
                for _, play in ipairs(playList) do
                    if actor ~= play then --排除自己
                        humanhp(play, "-", Player.getHpValue(play, 10), 1)
                        humanhp(play, "-", Player.getHpValue(play, 2), 112, 0, actor) --灼烧
                        humanhp(play, "-", Player.getHpValue(play, 2), 112, 1, actor) --灼烧
                        humanhp(play, "-", Player.getHpValue(play, 2), 112, 2, actor) --灼烧
                        humanhp(play, "-", Player.getHpValue(play, 2), 112, 4, actor) --灼烧
                    end
                end
            end
        end
    end
end
GameEvent.add(EventCfg.onAttackDamagePlayer, _onAttackDamagePlayer, ShengRenFaXiang)

local function _onJuFengZhiYanKF(actor)
    local acMax = getbaseinfo(actor, 51, 213)
    if acMax > 20 then
        changehumnewvalue(actor, 213, -20, 3)
    else
        changehumnewvalue(actor, 213, -acMax, 3)
    end
end
GameEvent.add(EventCfg.onJuFengZhiYanKF, _onJuFengZhiYanKF, ShengRenFaXiang)

--被攻击后触发
local function _onStruckPlayer(actor, Target, Hiter, MagicId)
    -- [飓风之眼]：受到人物攻击有10%的概率击退周边所有目标，并降低目标20%防御，持续3S. CD:8S
    if getflagstatus(actor, buffFlagMaps[31095]) == 1 then
        if randomex(1, 10) then
            if Player.checkCd(actor, VarCfg["飓风之眼CD"], 8, true) then --查看内置buff
                local MapID = Player.MapKey(actor)
                if checkkuafu(actor) then
                    MapID = Player.GetVarMap(actor)
                end
                local x, y = Player.GetX(actor), Player.GetY(actor)
                rangeharm(actor, x, y, 3, 0, 1, 1, 0, 0)           --击退对手1格
                local playList = getobjectinmap(MapID, x, y, 3, 1) --遍历自身周围3格内的玩家
                for _, play in ipairs(playList) do
                    if actor ~= play then
                        if checkkuafu(actor) then
                            FKuaFuToBenFuEvent(play, EventCfg.onJuFengZhiYanKF)
                        else
                            _onJuFengZhiYanKF(play)
                        end
                    end
                end
            end
        end
    end
end
GameEvent.add(EventCfg.onStruckPlayer, _onStruckPlayer, ShengRenFaXiang)

local function _onShanYueBiLeiKF(actor)
    changehumnewvalue(actor, 63, 2000, 5) --格挡概率
end
GameEvent.add(EventCfg.onShanYueBiLeiKF, _onShanYueBiLeiKF, ShengRenFaXiang)
-- 使用十步一杀  [山岳壁垒]：释放十步一杀后无敌1秒，格挡概率+20%，持续5S.
local function UseSkill_shi_bu_yi_sha(actor, Target)
    if getflagstatus(actor, buffFlagMaps[31098]) == 1 then
        -- changemode(actor, 1, 1)                 --无敌1秒
        addbuff(actor, 31101, 1) --无敌1秒
        if checkkuafu(actor) then
            FKuaFuToBenFuEvent(actor, EventCfg.onShanYueBiLeiKF)
        else
            _onShanYueBiLeiKF(actor)
        end
    end
end
GameEvent.add(EventCfg["使用十步一杀"], UseSkill_shi_bu_yi_sha, ShengRenFaXiang)

-- --攻速附加
-- local function _onCalcAttackSpeed(actor, attackSpeeds)
--     if checktitle(actor,"圣人之资") then
--         attackSpeeds[1] = attackSpeeds[1] + 30
--     end

--     if hasbuff(actor,31095) then
--         attackSpeeds[1] = attackSpeeds[1] + 10
--     end
-- end
-- GameEvent.add(EventCfg.onCalcAttackSpeed, _onCalcAttackSpeed, ShengRenFaXiang)

function fa_xiang_gong_su(actor)
    Player.setAttList(actor, "攻速附加")
end

--圣人之资  buff 120秒CD  持续20秒
function buff_sheng_ren_zhi_zi(actor, buffId, buffGroup)
    local BuffIdx = math.random(31095, 31098)
    local flag = buffFlagMaps[BuffIdx]
    if flag then
        setflagstatus(actor, flag, 1) --设置标识
    end
    -- 风之法相 31095 攻击速度+10%,忽视防御+10%
    if BuffIdx == 31095 then
        addbuff(actor, BuffIdx, 20, 1, actor) --添加法相buff
        setfeature(actor, 2, 10000, 20, 1, 0) --添加法相翅膀
        delaygoto(actor,1000,"fa_xiang_gong_su")
    end

    -- 火之法相 31096 攻击伤害+10%,攻击上限+10%
    if BuffIdx == 31096 then
        addbuff(actor, BuffIdx, 20, 1, actor) --添加法相buff
        setfeature(actor, 2, 10001, 20, 1, 0) --添加法相翅膀
    end

    -- 水之法相 31097 生命上限+10%,魔法上限+10%
    if BuffIdx == 31097 then
        addbuff(actor, BuffIdx, 20, 1, actor)                --添加法相buff
        setfeature(actor, 2, 10002, 20, 1, 0)                --添加法相翅膀
        -- [水幕天华]：法相现身释放水幕天华，精华自身所有负面状态，并恢复自身30%最大生命值。
        humanhp(actor, "+", Player.getHpValue(actor, 30), 4) --恢复30%生命
        changehumnewvalue(actor, 51, 10000, 5)               --防止冰冻
        changehumnewvalue(actor, 52, 10000, 5)               --防止蛛网
        changehumnewvalue(actor, 45, 10000, 5)               --防止麻痹
        changehumnewvalue(actor, 48, 10000, 5)               --防止全毒
        playeffect(actor, 63138, 0, 0, 1, 1, 0)
    end

    -- 土之法相 31098 伤害吸收+10%,防御加成+10%
    if BuffIdx == 31098 then
        addbuff(actor, BuffIdx, 20, 1, actor) --添加法相buff
        setfeature(actor, 2, 10003, 20, 1, 0) --添加法相翅膀
    end
end

--混元法相
function buff_hun_yuan_fa_xiang(actor, buffId, buffGroup)
    addbuff(actor, 31104, 20, 1, actor) --添加混元法相buff
    setfeature(actor, 2, 10005, 20, 1, 0) --添加法相翅膀
    delaygoto(actor,1000,"fa_xiang_gong_su")
end
-- --buff触发
local function _onBuffChange(actor, buffid, groupid, model)
    if model == 4 then
        --风之法相 删除该buff后 刷新攻速
        if buffid == 31095 then
            delaygoto(actor,1000,"fa_xiang_gong_su")
        end
        local flag = buffFlagMaps[buffid]
        if flag then
            setflagstatus(actor, flag, 0)
        end
    end
end
GameEvent.add(EventCfg.onBuffChange, _onBuffChange, ShengRenFaXiang)


--登录触发
local function _onLoginEnd(actor, logindatas)
    if checkitemw(actor, "ζ聖●法相天地ζ", 1) then
        for key, value in pairs(buffFlagMaps) do
            setflagstatus(actor, value, 1)
        end
    else
        for key, value in pairs(buffFlagMaps) do
            setflagstatus(actor, value, 0)
        end
    end
    ShengRenFaXiang.SyncResponse(actor, logindatas)
end
GameEvent.add(EventCfg.onLoginEnd, _onLoginEnd, ShengRenFaXiang)

--穿装备
local function _onTakeOn21(actor, itemobj)
    local itemname = getiteminfo(actor, itemobj, 7)
    if itemname == "ζ法相天地ζ" then
        addbuff(actor,31094)
        Player.setAttList(actor, "攻速附加")
    elseif itemname == "ζ聖●法相天地ζ" then
        for key, value in pairs(buffFlagMaps) do
            setflagstatus(actor, value, 1)
        end
        addbuff(actor,31103)
        Player.setAttList(actor, "攻速附加")
    end
end
GameEvent.add(EventCfg.onTakeOn21, _onTakeOn21, ShengRenFaXiang)

--脱装备
local function _onTakeOff21(actor, itemobj)
    local itemname = getiteminfo(actor, itemobj, 7)
    if itemname == "ζ法相天地ζ" then
        --删除一遍buff
        delbuff(actor,31094)
        for key, value in pairs(buffFlagMaps) do
            delbuff(actor,key)
        end
        Player.setAttList(actor, "攻速附加")
    elseif itemname == "ζ聖●法相天地ζ" then
        for key, value in pairs(buffFlagMaps) do
            setflagstatus(actor, value, 0)
        end
        delbuff(actor, 31103)
        delbuff(actor, 31104)
        Player.setAttList(actor, "攻速附加")
    end
end
GameEvent.add(EventCfg.onTakeOff21, _onTakeOff21, ShengRenFaXiang)

return ShengRenFaXiang

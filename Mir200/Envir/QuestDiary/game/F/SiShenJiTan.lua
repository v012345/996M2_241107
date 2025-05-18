local SiShenJiTan = {}
local cost = {{"◆影杀阵◆", 1},{"造化结晶", 22}}

function SiShenJiTan.Request(actor)
    if checktitle(actor,"死亡如风") then
        Player.sendmsgEx(actor, "死神#251|:#255|咦?你还没死够吗？...")
        return
    end

    local name, num = Player.checkItemNumByTable(actor, cost)
    if name then
        Player.sendmsgEx(actor, string.format("提示#251|:#255|你的|%s#249|不足|%d#249|枚,无法献祭...", name, num))
        return
    end
    Player.takeItemByTable(actor, cost, "献祭扣除材料")

    local NowHp = getbaseinfo(actor,ConstCfg.gbase.curhp)
    local KillNum = math.random(1, 110)
    humanhp(actor, "-", NowHp*(KillNum/100), 1)
    if KillNum < 100 then
        Player.sendmsgEx(actor, "提示#251|:#255|对不起|献祭失败#249|材料扣除...")
    elseif  KillNum >= 100 then
        confertitle(actor,"死亡如风")
        giveitem(actor, "风之圣纹", 1, 0)
        Player.sendmsgEx(actor, "提示#251|:#255|恭喜你|献祭成功#249|,获得|死亡如风[称号]#249|与|风之圣纹#249|奖励...")
        kill(actor, nil)
    end
    --同步一次前端消息
    Message.sendmsg(actor, ssrNetMsgCfg.SiShenJiTan_SyncResponse, 0, 0, 0, nil)
end
--属性附加
local function _onCalcAttr(actor, attrs)
    local DieNum = getplaydef(actor, VarCfg["U_死亡如风_死亡次数"])
    local shuxing = {}
    if DieNum > 0 and DieNum <= 66 then
        shuxing[1] = 100*DieNum
    end
    calcAtts(attrs, shuxing, "死亡如风")
end
GameEvent.add(EventCfg.onCalcAttr, _onCalcAttr, SiShenJiTan)

--死亡触发
local function _onPlaydie(actor, hiter)
    if checktitle(actor,"死亡如风") then
        local DieNum = getplaydef(actor, VarCfg["U_死亡如风_死亡次数"])
        if DieNum < 66 then
            setplaydef(actor, VarCfg["U_死亡如风_死亡次数"], DieNum + 1)
            Player.setAttList(actor, "属性附加")
        end
    end
end
GameEvent.add(EventCfg.onPlaydie, _onPlaydie, SiShenJiTan)

Message.RegisterNetMsg(ssrNetMsgCfg.SiShenJiTan, SiShenJiTan)
return SiShenJiTan

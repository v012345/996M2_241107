local KuaFutoBenFuBuffList = include("QuestDiary/game/KuaFutoBenFuBuffList.lua") --跨服
local BenFutoKuaFuRunScript = include("QuestDiary/game/BenFutoKuaFuRunScript.lua") --跨服
local KuaFutoBenFuQiYuTitle = include("QuestDiary/game/KuaFutoBenFuQiYuTitle.lua") --跨服

--进入跨服触发
function kflogin(actor)
    --同步数据
    local logindatas = {}
    GameEvent.push(EventCfg.onKFLogin, actor, logindatas)
    Message.sendmsg(actor, ssrNetMsgCfg.sync, nil, nil, nil, logindatas)

    --跨服调整攻击速度
    local currSpeed = (getplaydef(actor, VarCfg["U_攻击速度"]) - 100) / 2
    if currSpeed > 0 then
        callscriptex(actor, "ChangeSpeedEX", 2, currSpeed)
    else
        callscriptex(actor, "ChangeSpeedEX", 2, 0)
    end
    --跨服开启拾取小精灵
    pickupitems(actor, 0, 10, 500)
    --设置倍攻
    local beigong = getplaydef(actor, VarCfg["U_跨服记录倍攻"])
    powerrate(actor, beigong, 655350)
    setflagstatus(actor,VarCfg["F_是否进入过跨服"],1)

end
--跨服回来需要清理的buff
local function kuafuendDelBuff(actor)
    local buffList = {30099,10001,30087,31056}
    for _, value in ipairs(buffList) do
        delbuff(actor,value)
    end
end
--返回本服触发
function kuafuend(actor)
    GameEvent.push(EventCfg.onKuaFuEnd, actor)
    kuafuendDelBuff(actor)
    Player.setAttList(actor,"属性附加")
end

--本服通知跨服
function bfsyscall1(actor, arg1, arg2)

end

function bfsyscall2(actor, arg1, arg2)

end

function bfsyscall3(actor, arg1, arg2)

end

function bfsyscall4(actor, arg1, arg2)

end

function bfsyscall5(actor, arg1, arg2)

end

function bfsyscall6(actor, arg1, arg2)

end

function bfsyscall7(actor, arg1, arg2)

end

function bfsyscall8(actor, arg1, arg2)

end

function bfsyscall9(actor, arg1, arg2)

end

function bfsyscall10(actor, arg1, arg2)

end

function bfsyscall11(actor, arg1, arg2)

end

function bfsyscall12(actor, arg1, arg2)

end

function bfsyscall13(actor, arg1, arg2)

end

function bfsyscall14(actor, arg1, arg2)

end

function bfsyscall15(actor, arg1, arg2)

end

function bfsyscall16(actor, arg1, arg2)

end

function bfsyscall17(actor, arg1, arg2)

end

function bfsyscall18(actor, arg1, arg2)

end

function bfsyscall19(actor, arg1, arg2)

end

function bfsyscall20(actor, arg1, arg2)

end

function bfsyscall21(actor, arg1, arg2)

end

function bfsyscall22(actor, arg1, arg2)

end

function bfsyscall23(actor, arg1, arg2)

end

function bfsyscall24(actor, arg1, arg2)

end

function bfsyscall25(actor, arg1, arg2)

end

function bfsyscall26(actor, arg1, arg2)

end

function bfsyscall27(actor, arg1, arg2)

end

function bfsyscall28(actor, arg1, arg2)

end

function bfsyscall29(actor, arg1, arg2)

end

--跨服通知本服更新战神榜
function bfsyscall30(actor, arg1, arg2)
    local rankStr = arg1
end

--设置第一滴血的变量
function bfsyscall31(actor, arg1, arg2)
    setsysvar(VarCfg["A_第一滴血玩家名字"], arg1)
end

--本服到跨服传送
local cfg_JinZhiChuanSong = include("QuestDiary/cfgcsv/cfg_JinZhiChuanSong.lua")     --禁止传送的地图
function bfsyscall32(actor, arg1, arg2)
    local mapid = getbaseinfo(actor,ConstCfg.gbase.mapid)
    if mapid == "斩将夺旗" then
        Player.sendmsgEx(actor,string.format("正在前往(%s,%s)",arg1,arg2))
        return
    end
    local isBanChuanSong = cfg_JinZhiChuanSong[mapid]
    if isBanChuanSong then
        Player.sendmsgEx(actor,"当前地图禁止传送#249")
        return
    end
    mapmove(actor, mapid, arg1, arg2)
end

--本服到执行脚本
function bfsyscall33(actor, arg1, arg2)
    local index = tonumber(arg1) or 0
    local func = BenFutoKuaFuRunScript[index]
    if func then
        func(actor, arg2)
    end
end

--本服BUFF到跨服执行
function bfsyscall34(actor, arg1, arg2)
    local buffid = tonumber(arg1) or 0
    local time = tonumber(arg2) or 0
    if not buffid or buffid == 0 then
        return
    end
    --如果时间不存在
    if not time or time == 0 then
        addbuff(actor, buffid)
    else
        addbuff(actor, buffid, time)
    end
end

--本服到跨服执行事件派发
function bfsyscall35(actor, arg1, arg2)
    GameEvent.push(arg1, actor, arg2)
end

--本服到跨服执行事件派发 系统执行
function bfsyscall36(arg1, arg2)
    GameEvent.push(arg1, arg2)
end


--跨服通知本服
function kfsyscall1(actor, arg1, arg2)

end

function kfsyscall2(actor, arg1, arg2)

end

function kfsyscall3(actor, arg1, arg2)

end

function kfsyscall4(actor, arg1, arg2)

end

function kfsyscall5(actor, arg1, arg2)

end

function kfsyscall6(actor, arg1, arg2)

end

function kfsyscall7(actor, arg1, arg2)

end

function kfsyscall8(actor, arg1, arg2)

end

function kfsyscall9(actor, arg1, arg2)

end

function kfsyscall10(actor, arg1, arg2)

end

function kfsyscall11(actor, arg1, arg2)

end

function kfsyscall12(actor, arg1, arg2)

end

function kfsyscall13(actor, arg1, arg2)

end

function kfsyscall14(actor, arg1, arg2)

end

function kfsyscall15(actor, arg1, arg2)

end

function kfsyscall16(actor, arg1, arg2)

end

function kfsyscall17(actor, arg1, arg2)

end

function kfsyscall18(actor, arg1, arg2)

end

function kfsyscall19(actor, arg1, arg2)

end

function kfsyscall20(actor, arg1, arg2)

end

function kfsyscall21(actor, arg1, arg2)

end

function kfsyscall22(actor, arg1, arg2)

end

function kfsyscall23(actor, arg1, arg2)

end

function kfsyscall24(actor, arg1, arg2)

end

function kfsyscall25(actor, arg1, arg2)

end

function kfsyscall26(actor, arg1, arg2)

end

function kfsyscall27(actor, arg1, arg2)

end

function kfsyscall28(actor, arg1, arg2)

end

function kfsyscall29(actor, arg1, arg2)

end

function kfsyscall30(actor, arg1, arg2)

end
--装备保价跨服提醒
function kfsyscall49(actor, arg1, arg2)
    local equipName = arg1
    local touBaoCount = arg2
    local mailTitle = "装备投保防止掉落通知"
    local mailContent = "你装备【" .. equipName .. "】，使用了投保功能，已防止掉落1次，剩余" .. touBaoCount .."次。"
    local uid = Player.GetUUID(actor)
    sendmail(uid, 1, mailTitle, mailContent)
end

--跨服buff回本服执行
--[[
    arg1 = buffID
    arg2 = time
]]
function kfsyscall50(actor, arg1, arg2)
    local buffid = tonumber(arg1) or 0
    local time = tonumber(arg2) or 0
    if not buffid or buffid == 0 then
        return
    end
    --如果时间不存在
    if not time or time == 0 then
        addbuff(actor, buffid)
    else
        addbuff(actor, buffid, time)
    end
end

--到本服执行脚本
function kfsyscall51(actor, arg1, arg2)
    local index = tonumber(arg1) or 0
    local func = KuaFutoBenFuBuffList[index]
    if func then
        func(actor, arg2)
    end
end

--跨服到本服执行删除称号 狂暴
function kfsyscall52(actor, arg1, arg2)
    local titleName = arg1
    if titleName == "" then
        return
    end
    --删除技能
    local skillId = getskillindex("十步一杀")
    delskill(actor, skillId)
    deprivetitle(actor, titleName)
end

--跨服到本服执行奇遇称号
function kfsyscall53(actor, arg1, arg2)
    local index = arg1
    local func = KuaFutoBenFuQiYuTitle[index]
    if func then
        func(actor,arg2)
    end
end
--发送邮件--沙巴克奖励
function kfsyscall54(actor, arg1, arg2)
    local baoXiang = ""
    if arg1 == "沙巴克胜利方奖励" then
        baoXiang = "&天下共主宝箱#1#371"
    else
        baoXiang = "&不灭之魂宝箱#1#371"
    end
    local userid = getbaseinfo(actor,ConstCfg.gbase.id)
    sendmail(userid, 1, arg1, "请领取您的沙巴克奖励", arg2..baoXiang)
    if arg1 == "沙巴克胜利方奖励" then
        GameEvent.push(EventCfg.GetCastleRewards, actor)
    end
end

--跨服到本服执行事件派发 
function kfsyscall55(actor, arg1, arg2)
    GameEvent.push(arg1, actor, arg2)
end

--跨服到本服执行事件派发 系统触发
function kfsyscall56(obj, arg1, arg2)
    GameEvent.push(arg1, arg2)
end

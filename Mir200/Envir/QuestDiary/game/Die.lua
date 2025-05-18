Die                  = {}
-- cfg_Fuhuo            = include("QuestDiary/cfgcsv/cfg_Fuhuo.lua") --复活配置
function die_fu_huo(actor)
    setflagstatus(actor,VarCfg["F_人物死亡"],0)
    realive(actor)
    FBackZone(actor)
    addhpper(actor,"=",100)
    local time = getplaydef(actor, "S$复活_time")
    local map_title = getplaydef(actor, "S$复活_map_title")
    local map_id = getplaydef(actor, "S$复活_map_id")
    local x = getplaydef(actor, "S$复活_x")
    local y = getplaydef(actor, "S$复活_y")
    local hitername = getplaydef(actor, "S$复活_hitername")
    -- release_print(map_id)
    if map_id == "n3" or map_id == "new0150" then
        return
    end
    if hasbuff(actor, 31064) then
        return
    end
    --跨服不可以使用生死簿
    if checkkuafu(actor) then
        return
    end
    --生死簿  人物死亡时自动记录(当前死亡坐标) 复活后可选择飞回案发现场[CD120S]
    if getflagstatus(actor, VarCfg["F_生死簿"]) == 1 then
        addbuff(actor, 31064)
        say(actor, [[
                <Img|loadDelay=0|move=0|bg=1|img=custom/shengsipu/jm_01.png|show=4|esc=1|reset=1>
                <Text|ax=0.5|x=405.0|y=170.0|rotate=0|color=255|size=16|text=]] .. time .. [[>
                <Text|ax=0.5|x=309.0|y=200.0|rotate=0|color=146|size=16|text=]] ..
            map_title .. [[[]] .. x .. [[,]] .. y .. [[]>
                <Text|ax=0.5|x=480.0|y=200.0|rotate=0|color=249|size=16|text=]] .. hitername .. [[>
                <COUNTDOWN|id=5|x=372.0|y=300.0|count=1|size=16|color=250|time=12|link=@guanbishengsipu>
                <Button|x=200.0|y=285.0|nimg=custom/shengsipu/an_1.png|link=@exit>
                <Button|x=419.0|y=285.0|nimg=custom/shengsipu/an_2.png|link=@shiyongshengsipu,]] ..
            map_id .. [[,]] .. x .. [[,]] .. y .. [[>
                ]])
    end
end

--请求复活
function Die.RequestRevive(actor, time, map_title, map_id, x, y, hitername)
    --判断当前是否死亡状态
    if checkkuafu(actor) then
        --如果是斩将夺取复活
        if FCheckMap(actor,"斩将夺旗") then
            GameEvent.push(EventCfg.onKFZhanJiangDuoQiRlive, actor)
            return
        end
    end
    if not getbaseinfo(actor, ConstCfg.gbase.isdie) then return end
    setplaydef(actor, "S$复活_time", time)
    setplaydef(actor, "S$复活_map_title", map_title)
    setplaydef(actor, "S$复活_map_id", map_id)
    setplaydef(actor, "S$复活_x", x)
    setplaydef(actor, "S$复活_y", y)
    setplaydef(actor, "S$复活_hitername", hitername)
    setflagstatus(actor,VarCfg["F_人物死亡"],1)
    showprogressbardlg(actor, 3, "@die_fu_huo", "正在复活%d...", 0)
end
--关闭生死簿界面
function guanbishengsipu(actor)
    close(actor)
end
--禁止使用生死簿
local ssbBan = {
    ["月夜密室"] = true,
    ["狂欢小镇"] = true
}
--使用生死簿
function shiyongshengsipu(actor, map_id, x, y)
    local myName = getbaseinfo(actor, ConstCfg.gbase.name)
    if string.find(map_id, myName) then
        Player.sendmsgEx(actor,"副本地图禁止使用!#249")
        return
    end
    if ssbBan[map_id] then
        local map_titile = getmapname(map_id)
        Player.sendmsgEx(actor,string.format("%s禁止使用生死簿#249",map_titile))
        return
    end
    mapmove(actor, map_id, x, y, 1)
end
Message.RegisterNetMsg(ssrNetMsgCfg.Die, Die)

return Die

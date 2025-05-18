local MiLuBaoZang = {}
MiLuBaoZang.ID = "麋鹿宝藏"
local npcID = 157
--local config = include("QuestDiary/cfgcsv/cfg_MiLuBaoZang.lua") --配置
local cost = {{}}
local give = {{}}

--获取数据
function MiLuBaoZang.getVariableState(actor)
    local Num1 = getplaydef(actor, VarCfg["J_麋鹿宝藏进入次数"])
    local _Num2 = getplaydef(actor, VarCfg["Z_麋鹿宝藏进入上限"])
    local Num2 = (_Num2 == "" and 3) or (_Num2 == nil and 3) or tonumber(_Num2)
    return Num1, Num2
end

--接收请求
function MiLuBaoZang.Request(actor, var)
    local Num1, Num2 = MiLuBaoZang.getVariableState(actor)
    if var == 1 then
        if Num1 >= Num2 then
            Player.sendmsgEx(actor, "提示#251|:#255|对不起,|次数不足#249|请增加次数...")
            return
        end
        setplaydef(actor, VarCfg["J_麋鹿宝藏进入次数"], Num1 + 1)
        MiLuBaoZang.SyncResponse(actor)

        local NowMapID = getbaseinfo(actor, ConstCfg.gbase.mapid)
        local NowX,NowY = getbaseinfo(actor, ConstCfg.gbase.x),getbaseinfo(actor, ConstCfg.gbase.y)
        local HuiChenginfo = {["NowMapID"] = NowMapID,["NowX"] = NowX,["NowY"] = NowY}
        Player.setJsonVarByTable(actor, VarCfg["T_进入副本记录退出信息"] , HuiChenginfo)

        local UserName = getbaseinfo(actor, ConstCfg.gbase.name)
        local NewMapId = "heicibaoku"..UserName --根据原始地图id  配置新地图ID
        local NewMapName = "麋鹿宝藏".."[副本]"
        if checkmirrormap(NewMapId) then
            killmonsters(NewMapId, "*", 0, false)   --杀死当前地图所有怪物
            delmirrormap(NewMapId)              --删除镜像地图
            addmirrormap("heicibaoku", NewMapId, NewMapName, 120, NowMapID, nil, NowX, NowY)
        else
            addmirrormap("heicibaoku", NewMapId, NewMapName, 120, NowMapID, nil, NowX, NowY)
        end

        killcopyself(actor) --杀死所有分身
        local ncount = getbaseinfo(actor, 38)
        for i = 0, ncount - 1 do
            local mon = getslavebyindex(actor, i)
            killmonbyobj(actor, mon, false, false, true) --杀死宝宝
        end
        mapmove(actor, NewMapId, 25, 36, 2)
        senddelaymsg(actor, "麋鹿宝藏剩余时间:%s", 120, 250, 1)
        --刷Boss
        genmon(NewMapId, 26, 35, "圣诞麋鹿", 1, 1, 249)
    end

    if var == 2 then
        if Num2 == 8 then
            Player.sendmsgEx(actor, "提示#251|:#255|你今天已经购买|5次#249|了,请明天再来...")
            return
        end
        if querymoney(actor, 7) < 200 then
            Player.sendmsgEx(actor,"[提示]:#251|置换失败,你的|灵符#249|不足|200枚#249|增加失败...")
            return
        end
        changemoney(actor, 7, "-", 200, "购买进入麋鹿宝藏次数", true)
        setplaydef(actor, VarCfg["Z_麋鹿宝藏进入上限"], Num2 + 1)
        MiLuBaoZang.SyncResponse(actor)
    end
end

--同步消息
function MiLuBaoZang.SyncResponse(actor, logindatas)
    local Num1, Num2 = MiLuBaoZang.getVariableState(actor)
    local data = {Num1, Num2}
    local _login_data = {ssrNetMsgCfg.MiLuBaoZang_SyncResponse, 0, 0, 0, data}
    if type(logindatas) == "table" then
        table.insert(logindatas, _login_data)
    else
        Message.sendmsg(actor, ssrNetMsgCfg.MiLuBaoZang_SyncResponse, 0, 0, 0, data)
    end
end

--登录触发
local function _onLoginEnd(actor, logindatas)
    MiLuBaoZang.SyncResponse(actor, logindatas)
end
GameEvent.add(EventCfg.onLoginEnd, _onLoginEnd, MiLuBaoZang)

--攻击触发
local function _onAttackMonster(actor, Target, Hiter, MagicId, qieGe, monName)
    if monName == "圣诞麋鹿" then
        local mapid = getbaseinfo(actor, ConstCfg.gbase.mapid)
        local x,y = getbaseinfo(Target, ConstCfg.gbase.x),getbaseinfo(Target, ConstCfg.gbase.y)
        local items = {
            ["500元宝"] = math.random(1, 3),
            ["金币红包(中)"] = math.random(1, 14),
        }

        if randomex(1, 80) then
            items["麋鹿金铃铛"] = 1
        end
        if randomex(1, 15) then
            items["圣诞花环"] = 1
        end
        gendropitem(mapid,actor,x,y,tbl2json(items),nil)
        -- throwitem(actor, mapid, x, y, 1, "灵石", 1, 1, false, false)
    end
end
GameEvent.add(EventCfg.onAttackMonster, _onAttackMonster, MiLuBaoZang)

--注册网络消息
Message.RegisterNetMsg(ssrNetMsgCfg.MiLuBaoZang, MiLuBaoZang)
return MiLuBaoZang
HunYuanGongFa = {}

local config = include("QuestDiary/cfgcsv/cfg_HunYuanGongFa.lua")     --混元功法
local TianMingFunc = include("QuestDiary/game/A/TianMingFunc.lua")
local skilldata = {[10] = "分身术", [20] = "圆弧之刃", [30] = "狂热野蛮", [40] = "双重施法", [50] = "神之开天", [60] = "灭神之逐"}

function HunYuanGongFa.checkskilllevel(actor)
    local state = false
    local QiangHua = {}
    QiangHua.GongSha = getskilllevelup(actor,7)
    QiangHua.CiSha   = getskilllevelup(actor,12)
    QiangHua.BanYue  = getskilllevelup(actor,25)
    QiangHua.LieHuo  = getskilllevelup(actor,26)
    QiangHua.KaiTian = getskilllevelup(actor,66)
    QiangHua.ZhuRi   = getskilllevelup(actor,56)
    for index, value in pairs(QiangHua) do
        if value < 10 then
            state = true
            break
        end
    end
    return state
end

function HunYuanGongFa.Request(actor, arg1)
    setflagstatus(actor,VarCfg["F_了解混元功法完成"],1)
    if HunYuanGongFa.checkskilllevel(actor) then
        Player.sendmsgEx(actor, "提示#251|:#255|对不起,你的|技能强化#249|没有全部到达|10#249|级,无法修炼...")
        return
    end

    local checklevel = getplaydef(actor,VarCfg["U_混元功法等级"])
    local cfg = config[arg1*10]

    if not cfg then
        Player.sendmsgEx(actor, "参数错误!")
        return
    end

    if checklevel >= arg1*10 then
        Player.sendmsgEx(actor, "提示#251|:#255|对不起,你的|"..cfg.namelooks.."#249|已经修炼到|10#249|级了,无法继续强化...")
        return
    end

    local name, num = Player.checkItemNumByTable(actor, cfg.cost)
    if name then
        Player.sendmsgEx(actor, string.format("[提示]:#251|你的|%s#249|不足|%d#249|枚,锻造失败...", name, num))
        return
    end
    
    Player.takeItemByTable(actor,cfg.cost,"拿走所需材料及其货币")
    setplaydef(actor,VarCfg["U_混元功法等级"],checklevel+1)

    if (checklevel+1) >= 60 then
        TianMingFunc[49](actor,1)
    end

    if skilldata[checklevel+1] then
        local skillName = skilldata[checklevel+1]
        local Skillid = getskillindex(skillName)
        addskill(actor, Skillid, 3)

        if skillName == "神之开天" or skillName == "灭神之逐"    then
            local Skillidxex = (skillName == "灭神之逐" and 56) or (skillName == "神之开天" and 66)
            setskillinfo(actor, Skillidxex, 2, 11)
        end
    end
    HunYuanGongFa.SyncResponse(actor)
    Player.setAttList(actor, "属性附加")
end

function HunYuanGongFa.Open(actor)
    local flag = getflagstatus(actor,VarCfg["F_了解混元功法"])
    if  flag == 0 then
        setflagstatus(actor,VarCfg["F_了解混元功法完成"],1)
        local taskPanelID = getplaydef(actor, VarCfg["U_主线任务面板进度"])
        if taskPanelID == 22 then
            FCheckTaskRedPoint(actor)
        end
    end
end
--注册网络消息
Message.RegisterNetMsg(ssrNetMsgCfg.HunYuanGongFa, HunYuanGongFa)

function HunYuanGongFa.SyncResponse(actor, logindatas)
    local zsjxFlag = getflagstatus(actor,VarCfg["F_天命_终身进修标识"])
    local huyuanlevel = getplaydef(actor,VarCfg["U_混元功法等级"])
    local data = {huyuanlevel}
    local _login_data = {ssrNetMsgCfg.HunYuanGongFa_SyncResponse, zsjxFlag, 0, 0, data}
    if logindatas then
        table.insert(logindatas, _login_data)
    else
        Message.sendmsg(actor, ssrNetMsgCfg.HunYuanGongFa_SyncResponse, zsjxFlag, 0, 0, data)
    end
end

local function _onCalcAttr(actor,attrs)
    local level = getplaydef(actor,VarCfg["U_混元功法等级"])
    local atts = {}
    local zsjxFlag = getflagstatus(actor,VarCfg["F_天命_终身进修标识"])
    if level > 0 then
        if zsjxFlag == 0 then
            for i = 1, level, 1 do                
                for j,v in ipairs(config[i].attr) do
                    if not atts[v[1]] then
                        atts[v[1]] = v[2]
                    else
                        atts[v[1]] = atts[v[1]] + v[2]
                    end
                end
            end
        else
            for i = 1, level, 1 do                
                for j,v in ipairs(config[i].attr2) do
                    if not atts[v[1]] then
                        atts[v[1]] = v[2]
                    else
                        atts[v[1]] = atts[v[1]] + v[2]
                    end
                end
            end
        end
    end
    calcAtts(attrs,atts,"混元功法")
end
GameEvent.add(EventCfg.onCalcAttr, _onCalcAttr, HunYuanGongFa)


--登录触发
local function _onLoginEnd(actor, logindatas)
    --如果有召唤分身
    if getskillinfo(actor,2014,1) == 3 then
        --删除分身
        delskill(actor,2014)
        --添加分身术
        addskill(actor, 74, 3)
    end

    --如果有灭神之逐 2021
    if getskillinfo(actor,2021,1) == 3 then
        --如果开天斩 等级为10
        if getskillinfo(actor,56,2) == 10  then
            setskillinfo(actor, 56, 2, 11)
        end
    end

    --如果有神之开天 2022
    if getskillinfo(actor,2022,1) == 3 then
        --如果逐日 等级为10
        if getskillinfo(actor,66,2) == 10  then
            setskillinfo(actor, 66, 2, 11)
        end
    end

    HunYuanGongFa.SyncResponse(actor, logindatas)
end
GameEvent.add(EventCfg.onLoginEnd, _onLoginEnd, HunYuanGongFa)

return HunYuanGongFa


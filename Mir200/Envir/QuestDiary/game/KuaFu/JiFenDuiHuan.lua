local JiFenDuiHuan = {}
JiFenDuiHuan.ID = "积分兑换"
local npcID = 127
local config = include("QuestDiary/cfgcsv/cfg_JiFenDuiHuan.lua") --配置
local cost = { {} }
local give = { {} }
--接收请求
function JiFenDuiHuan.Request(actor, index)
    if not checkkuafu(actor) then
        return
    end
    local cfg = config[index]
    if not cfg then
        return
    end
    local itemName = cfg.item[1][1]
    local itemNum = cfg.item[1][2]
    local data = Player.getJsonTableByPlayVar(actor, "跨服积分兑换")
    local obtainedCount = data[itemName] or 0 --获取已兑换次数
    local RemainingCount = cfg.max - obtainedCount
    if RemainingCount <= 0 then
        Player.sendmsgEx(actor, "兑换失败,您的兑换次数不足!#249")
        return
    end
    local myPoint = getplaydef(actor, VarCfg["U_跨服积分"])
    if myPoint < cfg.point then
        Player.sendmsgEx(actor, string.format("兑换失败,你的积分不足|%d#249", cfg.point))
        return
    end

    Player.sendmsgEx(actor, string.format("兑换成功,获得|%s*%d#249|请到邮件查收!", itemName, itemNum))
    local uid = Player.GetUUID(actor)
    Player.giveMailByTable(uid, 1, "跨服积分兑换", "请领取您的跨服积分兑换奖励!", cfg.item, 1, true)
    setplaydef(actor, VarCfg["U_跨服积分"], myPoint - cfg.point)
    --成功之后 增加次数
    if data[itemName] then
        data[itemName] = data[itemName] + 1
    else
        data[itemName] = 1
    end
    Player.setJsonPlayVarByTable(actor, "跨服积分兑换", data)
    JiFenDuiHuan.SyncResponse(actor)
end

function JiFenDuiHuan.OpenUI(actor)
    local data = Player.getJsonTableByPlayVar(actor, "跨服积分兑换")
    local toDayPoint = getplaydef(actor, VarCfg["U_跨服当时积分"])
    local kuaFuPiont = getplaydef(actor, VarCfg["U_跨服积分"])
    Message.sendmsg(actor, ssrNetMsgCfg.JiFenDuiHuan_OpenUI, toDayPoint, kuaFuPiont, 0, data)
end

--同步消息
function JiFenDuiHuan.SyncResponse(actor)
    local data = Player.getJsonTableByPlayVar(actor, "跨服积分兑换")
    local toDayPoint = getplaydef(actor, VarCfg["U_跨服当时积分"])
    local kuaFuPiont = getplaydef(actor, VarCfg["U_跨服积分"])
    Message.sendmsg(actor, ssrNetMsgCfg.JiFenDuiHuan_SyncResponse, toDayPoint, kuaFuPiont, 0, data)
end

--声明变量
local function _goPlayerVar(actor)
    FIniPlayVar(actor, "跨服积分兑换", true)
end
GameEvent.add(EventCfg.goPlayerVar, _goPlayerVar, JiFenDuiHuan)

--每天00点执行
local function _roBeforedawn(openday)
    local weekDayNumber = tonumber(os.date("%w"))
    if weekDayNumber == 1 then
        clearhumcustvar("*", "跨服积分兑换")
    end
end
GameEvent.add(EventCfg.roBeforedawn, _roBeforedawn, JiFenDuiHuan)

local mobMap = {
    ["天启至尊[炼狱]"] = 10,
    ["双星至尊[炼狱]"] = 20,
    ["三魂至尊[炼狱]"] = 30,
    ["四玄至尊[炼狱]"] = 40,
    ["五岳至尊[炼狱]"] = 50,
    ["六合至尊[炼狱]"] = 80,
    ["七星至尊[炼狱]"] = 120,
    ["八荒至尊[炼狱]"] = 160,
    ["九曜至尊[炼狱]"] = 200,
    ["十都至尊[炼狱]"] = 240,
    ["百威至尊[炼狱]"] = 280,
    ["千煞至尊[炼狱]"] = 320,
    ["万世至尊[炼狱]"] = 360,
    ["亿冥至尊[炼狱]"] = 400,
    ["◆◆◆天帝魂主◆◆◆"] = 300,
    ["◆◆◆人帝魂主◆◆◆"] = 300,
    ["◆◆◆地帝魂主◆◆◆"] = 300,
    ["◆◆◆神魂龙骸◆◆◆"] = 450,
}

local function _onKillMon(actor, monobj, monName)
    local point = mobMap[monName]
    if point then
        local toDayPoint = getplaydef(actor, VarCfg["U_跨服当时积分"])
        if toDayPoint < 1500 then
            local kuaFuPiont = getplaydef(actor, VarCfg["U_跨服积分"])
            setplaydef(actor, VarCfg["U_跨服积分"], kuaFuPiont + point)
            setplaydef(actor, VarCfg["U_跨服当时积分"], toDayPoint + point)
            Player.sendmsgEx(actor, "恭喜你,获得积分："..point)
        else
            Player.sendmsgEx(actor, "你今天已经达到1500分,无法再获得积分#249")
        end
    end
end

GameEvent.add(EventCfg.onKillMon, _onKillMon, JiFenDuiHuan)
--注册网络消息
Message.RegisterNetMsg(ssrNetMsgCfg.JiFenDuiHuan, JiFenDuiHuan)
return JiFenDuiHuan

local HongHuangZhiMen = {}
HongHuangZhiMen.ID = "洪荒之门"
local npcID = 501
--local config = include("QuestDiary/cfgcsv/cfg_HongHuangZhiMen.lua") --配置
local cost = { { "异界神石", 88 } }
--接收请求
function go_shen_mo_zhi_ti(actor)
    opennpcshowex(actor, 217, 2, 2)
end

function go_hong_huang_zhi_li(actor)
    opennpcshowex(actor, 511, 2, 2)
end

function HongHuangZhiMen.Request1(actor)
    if getflagstatus(actor, VarCfg["F_剧情_洪荒之门开启"]) == 1 then
        Player.sendmsgEx(actor, "已经开启了#249")
        return
    end
    if not checktitle(actor, "神魔·完美") then
        messagebox(actor, "开启失败,你没有[神魔·完美]称号,是否前往获取?", "@go_shen_mo_zhi_ti", "@quxiao")
        return
    end
    if not checktitle(actor, "洪荒之力") then
        messagebox(actor, "开启失败,你没有[洪荒之力]称号,是否前往获取?", "@go_hong_huang_zhi_li", "@quxiao")
        return
    end
    local name, num = Player.checkItemNumByTable(actor, cost)
    if name then
        Player.sendmsgEx(actor, string.format("你的|%s#249|不足|%d#249", name, num))
        return
    end
    Player.takeItemByTable(actor, cost, "洪荒之门")
    Player.sendmsgEx(actor,"成功开启地图[五行聚灵域]")
    -- setflagstatus(actor, VarCfg["F_剧情_洪荒之门开启"],1)
    FSetTaskRedPoint(actor, VarCfg["F_剧情_洪荒之门开启"], 46)
end

function HongHuangZhiMen.Request2(actor)
    if getflagstatus(actor, VarCfg["F_剧情_洪荒之门开启"]) == 1 then
        map(actor, "五行聚灵域")
    else
        Player.sendmsgEx(actor, "进入失败,你还没开启地图#249")
    end
end

--同步消息
function HongHuangZhiMen.SyncResponse(actor, logindatas)
    local data = {}
    local flag = getflagstatus(actor, VarCfg["F_剧情_洪荒之门开启"])
    local _login_data = { ssrNetMsgCfg.HongHuangZhiMen_SyncResponse, flag, 0, 0, data }
    if logindatas then
        table.insert(logindatas, _login_data)
    else
        Message.sendmsg(actor, ssrNetMsgCfg.HongHuangZhiMen_SyncResponse, flag, 0, 0, data)
    end
end

--登录触发
local function _onLoginEnd(actor, logindatas)
    HongHuangZhiMen.SyncResponse(actor, logindatas)
end
--事件派发
GameEvent.add(EventCfg.onLoginEnd, _onLoginEnd, HongHuangZhiMen)
--注册网络消息
Message.RegisterNetMsg(ssrNetMsgCfg.HongHuangZhiMen, HongHuangZhiMen)
return HongHuangZhiMen

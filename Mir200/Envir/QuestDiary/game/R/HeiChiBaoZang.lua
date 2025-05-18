local HeiChiBaoZang = {}
HeiChiBaoZang.ID = "黑齿宝藏"
local npcID = 230
local config = { "幽·踏青天", "炼狱", "天神指环", "卧龙战靴", "〈斩·浪〉", "御风·之力", "〈御·风〉", "天之剑·碎月", "天之剑·碎月", "圣之·毁灭", "风魔王冠", "暗·影之翼",
    "漩涡", "黑莲项坠", "撒旦の镯", "审判之魂", "龍族图腾ゞ", "忍者面具", "上忍之隐", "九冥赤炎", "断空之痕", "千年之光", "魔族指环", "夜色杀手披风", "新月之冠", "月光手环",
    "月光印记", "殇日剑·终结", "被封印的棺材" }
--接收请求
function open_hei_chi_bao_zang(actor)
    setplaydef(actor, VarCfg["J_黑齿宝藏"], 1)
    local openCount = getplaydef(actor, VarCfg["U_剧情_黑齿宝藏_开启次数"])
    if openCount >= 3 then
        Player.sendmsgEx(actor, "黑齿宝箱最多只能开启|3#249|次")
        return
    end
    if not Bag.checkBagEmptyNum(actor, 5) then
        Player.sendmsgEx(actor, "你的背包格子不足,至少留出5个空格!#249")
        stop(actor)
    end
    setplaydef(actor, VarCfg["U_剧情_黑齿宝藏_开启次数"], openCount + 1)
    local taskPanelID = getplaydef(actor, VarCfg["U_主线任务面板进度"])
    if taskPanelID == 9 then
        FCheckTaskRedPoint(actor)
    end
    local randomNum = math.random(#config)
    local itemName = config[randomNum]
    giveitem(actor, itemName, 1, ConstCfg.binding)
    messagebox(actor, string.format("你开启了[黑齿宝箱],获得[%s]", itemName))
    local myName = getbaseinfo(actor, ConstCfg.gbase.name)
    Player.sendmsgnewEx(actor, 0, 0, string.format("玩家|%s#253|开启了|[黑齿宝箱]#249|获得专属装备|[%s]#249", myName, itemName))
    HeiChiBaoZang.SyncResponse(actor)
end

function open_hei_chi_bao_zang_end(actor)
    Player.sendmsgEx(actor, "开启黑齿宝箱被打断了!")
end

function HeiChiBaoZang.Request(actor)
    if not FCheckNPCRange(actor, npcID, 15) then
        Player.sendmsgEx(actor, "距离PNC太远!#249")
        return
    end
    local openCount = getplaydef(actor, VarCfg["U_剧情_黑齿宝藏_开启次数"])
    if openCount >= 3 then
        Player.sendmsgEx(actor, "黑齿宝箱最多只能开启|3#249|次")
        return
    end
    local flag = getplaydef(actor, VarCfg["J_黑齿宝藏"])
    if flag > 0 then
        Player.sendmsgEx(actor, "今天你已经开启过了,请明天0点以后再来!")
        return
    end
    showprogressbardlg(actor, 5, "@open_hei_chi_bao_zang", "正在开启黑齿宝箱%d..", 1, "@open_hei_chi_bao_zang_end")
end

--同步消息
function HeiChiBaoZang.SyncResponse(actor)
    local data = {}
    local flag = getplaydef(actor, VarCfg["J_黑齿宝藏"])
    local openCount = getplaydef(actor, VarCfg["U_剧情_黑齿宝藏_开启次数"])
    Message.sendmsg(actor, ssrNetMsgCfg.HeiChiBaoZang_SyncResponse, flag, openCount, 0, data)
end
-- --登录触发
-- local function _onLoginEnd(actor, logindatas)
--     HeiChiBaoZang.SyncResponse(actor, logindatas)
-- end
-- --事件派发
-- GameEvent.add(EventCfg.onLoginEnd, _onLoginEnd, HeiChiBaoZang)
--注册网络消息
Message.RegisterNetMsg(ssrNetMsgCfg.HeiChiBaoZang, HeiChiBaoZang)
return HeiChiBaoZang

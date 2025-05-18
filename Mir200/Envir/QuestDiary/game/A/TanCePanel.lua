local TanCePanel = {}
TanCePanel.ID = "探测Panel"
--local config = include("QuestDiary/cfgcsv/cfg_TanCePanel.lua") --配置
local cost = {{"灵符",50}}
--接收请求
function TanCePanel.Request(actor,arg1,arg2,arg3,data)
    if not data then
        Player.sendmsgEx(actor, "参数错误!")
        return
    end
    if not checktitle(actor,"洞察之眼") then
        Player.sendmsgEx(actor, "完成|平判将领#249|剧情任务后获得|探测功能#249")
        return
    end    
    local name, num = Player.checkItemNumByTable(actor, cost)
    if name then
        Player.sendmsgEx(actor, string.format("探测失败,你的|%s#249|不足|%d#249", name, num))
        return
    end
    local userName = data[1]
    if userName == "" then
        Player.sendmsgEx(actor, "玩家名字不能是空#249")
        return
    end
    local userObj = getplayerbyname(userName)
    if not userObj then
        Player.sendmsgEx(actor, userName.."#249|不在线")
        return
    end
    Player.takeItemByTable(actor, cost, "探测")
    local targetMapName = getbaseinfo(userObj, ConstCfg.gbase.map_title)
    local targetMapx = getbaseinfo(userObj, ConstCfg.gbase.x)
    local targetMapy = getbaseinfo(userObj, ConstCfg.gbase.y)
    local str = userName.." 在 ".. targetMapName.."("..targetMapx..","..targetMapy..")"
    Message.sendmsg(actor, ssrNetMsgCfg.TanCePanel_SyncResponse, 0, 0, 0, {str})
end
-- --登录触发
-- local function _onLoginEnd(actor, logindatas)
--     TanCePanel.SyncResponse(actor, logindatas)
-- end
-- --事件派发
-- GameEvent.add(EventCfg.onLoginEnd, _onLoginEnd, TanCePanel)
--注册网络消息
Message.RegisterNetMsg(ssrNetMsgCfg.TanCePanel, TanCePanel)
return TanCePanel
local ChaoShenQiTouBao = {}
ChaoShenQiTouBao.ID = "超神器投保"
local npcID = 714
--local config = include("QuestDiary/cfgcsv/cfg_ChaoShenQiTouBao.lua") --配置
local cost = { {"灵符",1000} }
--接收请求
function ChaoShenQiTouBao.Request(actor, arg1, arg2, arg3, data)
    if not data then
        Player.sendmsgEx(actor, "参数错误1!#249")
        return
    end
    if not data.makeid then
        Player.sendmsgEx(actor, "参数错误2!#249")
        return
    end
    if data.makeid <= 0 then
        Player.sendmsgEx(actor, "参数错误3!#249")
        return
    end
    if not data.where then
        Player.sendmsgEx(actor, "参数错误3!#249")
        return
    end
    local itemObj
    if data.where > 0 then
        itemObj = linkbodyitem(actor, data.where)
    else
        itemObj = getitembymakeindex(actor, data.makeid)
    end
    if itemObj == "0" then
        Player.sendmsgEx(actor, "获取装备对象失败!#249")
        return
    end
    local touBaoCount = getitemaddvalue(actor, itemObj, 1, 45, 0)
    if touBaoCount >= 3 then
        Player.sendmsgEx(actor, "最多只能投保三次!#249")
        return
    end
    if querymoney(actor, 7) < 1000 then
        Player.sendmsgEx(actor, "你的灵符不足|1000#249|只能使用非绑灵符!")
        return
    end
    changemoney(actor, 7, "-", 1000, "超神器投保", true)
    setitemaddvalue(actor, itemObj, 1, 45, touBaoCount + 1)
    refreshitem(actor,itemObj)
    ChaoShenQiTouBao.SyncResponse(actor)
end

--同步消息
function ChaoShenQiTouBao.SyncResponse(actor)
    Message.sendmsg(actor, ssrNetMsgCfg.ChaoShenQiTouBao_SyncResponse, 0, 0, 0, {})
end
-- --登录触发
-- local function _onLoginEnd(actor, logindatas)
--     ChaoShenQiTouBao.SyncResponse(actor, logindatas)
-- end
-- --事件派发
-- GameEvent.add(EventCfg.onLoginEnd, _onLoginEnd, ChaoShenQiTouBao)
--注册网络消息
Message.RegisterNetMsg(ssrNetMsgCfg.ChaoShenQiTouBao, ChaoShenQiTouBao)
return ChaoShenQiTouBao

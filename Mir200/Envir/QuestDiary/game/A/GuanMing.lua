local GuanMing = {}
GuanMing.ID = "冠名"
local npcID = 117
GuanMing.config = include("QuestDiary/cfgcsv/cfg_GuanMing.lua") --配置
local cost = {{}}
local give = {{}}
--接收请求
function GuanMing.Request(actor)
    local receive = getflagstatus(actor,VarCfg["F_冠名领取"])
    if receive == 1 then
        Player.sendmsgEx(actor, "提示#251|:#255|你已经领取过冠名了!")
        return ""
    end

    if getplaydef(actor,VarCfg["U_真实充值"] ) < GuanMing.config[1].need then
        Player.sendmsgEx(actor, "提示#251|:#255|你的累计充值少于"..GuanMing.config[1].need.."元，无法领取!")
        return ""
    end

    if getbagblank(actor) < 10 then
        Player.sendmsgEx(actor, "提示#251|:#255|请给背包留足够的位置，在领取!")
        return ""
    end

    --if not checktitle(actor,GuanMing.config[1].title) then
    --    confertitle(actor,GuanMing.config[1].title,1)
    --end
    --release_print(tbl2json(GuanMing.config[1].give[2]))
    sendmail("#"..getbaseinfo(actor,1),1,"冠名奖励","恭喜获得冠名奖励，称号直接配带，此处只发放时装",GuanMing.config[1].give[1][1].."#"..GuanMing.config[1].give[1][2].."#307&"..GuanMing.config[1].give[2][1].."#"..GuanMing.config[1].give[2][2].."#307")
    --Player.giveItemByTable(actor, {GuanMing.config[1].give[2]}, "冠名奖励", 1, true)
    setflagstatus(actor,VarCfg["F_冠名领取"],1)
    Player.sendmsgEx(actor, "提示#251|:#255|领取冠名成功!")
    return ""
end
--同步消息
 function GuanMing.SyncResponse(actor, logindatas)
     local data = {}
     local _login_data = {ssrNetMsgCfg.GuanMing_SyncResponse, 0, 0, 0, data}
     if logindatas then
         table.insert(logindatas, _login_data)
     else
         Message.sendmsg(actor, ssrNetMsgCfg.GuanMing_SyncResponse, 0, 0, 0, data)
     end
 end
--登录触发
local function _onLoginEnd(actor, logindatas)
 GuanMing.SyncResponse(actor, logindatas)
end
-- --事件派发
GameEvent.add(EventCfg.onLoginEnd, _onLoginEnd, GuanMing)
--注册网络消息
Message.RegisterNetMsg(ssrNetMsgCfg.GuanMing, GuanMing)
return GuanMing
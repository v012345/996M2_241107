local ShouChong = {}
local give = { { "绑定金币", 2000000 }, { "破碎的魔法阵", 20 }, { "飓风之灵", 1 }, { "半月弯刀[技能]", 1 } }
function ShouChong.Request(actor, arg1, arg2, arg3, data)
    if getflagstatus(actor, VarCfg["F_是否首充"]) == 1 then
        Player.sendmsgEx(actor, "你已经领取过首充了!")
        return
    end
 
    local ChongZhiNum = getplaydef(actor, VarCfg["U_真实充值"])
    if ChongZhiNum >= 10 then
        setplaydef(actor, VarCfg["U_收集破碎的魔法阵"], 20) --魔法阵任务
        local mailTitle = "领取您的首充奖励!"
        local mailContent = "感谢您对牛马沉默的支持，请领取您的奖励：\\称号[牛马新星]已自动穿戴\\获得功能智能挂机\\获得天选之人资格"
        local userID = getbaseinfo(actor, ConstCfg.gbase.id)
        Player.giveMailByTable(userID, 1, mailTitle, mailContent, give, 1, true)
        addskill(actor, 25, 3)
        setflagstatus(actor, VarCfg["F_是否首充"], 1)
        if getplaydef(actor,"N$首充红点") == 1 then
            setplaydef(actor,"N$首充红点",0)
            Message.sendmsg(actor, ssrNetMsgCfg.ShouChong_AddRedPoint, 0, 0, 0, {})
        end
        Player.sendmsgEx(actor, "提示#251|:#255|恭喜你,获得|首冲福利#249|,奖励已发动到邮件,祝你游戏愉快...")
        TopIcon.addico(actor)
        Message.sendmsg(actor, ssrNetMsgCfg.ShouChong_CloseUI)
    else
        local cType = tonumber(getconst(actor,"<$CLIENTFLAG>"))
        if cType == 1 then
            generalappopenchargewnd.main(actor, 10, "充值","当前充值为普通充值可以获得所有充值奖励")
        else
            pullpay(actor, 10, 1, 7)
        end
        --Player.sendmsgEx(actor, "提示#251|:#255|对不起,你的首冲不足|10元#249|,领取失败...")
    end
end

local function _onRechargeEnd(actor)
    delaygoto(actor,500,"shouchong_init_redpoint")
end

function shouchong_init_redpoint(actor)
    if getflagstatus(actor, VarCfg["F_是否首充"]) == 0 then
        if getplaydef(actor, VarCfg["U_真实充值"]) >= 10 then
            setplaydef(actor,"N$首充红点",1)
            Message.sendmsg(actor, ssrNetMsgCfg.ShouChong_AddRedPoint, 1, 0, 0, {})
        end
    end
end

GameEvent.add(EventCfg.onLogin,_onRechargeEnd,ShouChong)
GameEvent.add(EventCfg.onRechargeEnd, _onRechargeEnd,ShouChong)
Message.RegisterNetMsg(ssrNetMsgCfg.ShouChong, ShouChong)
return ShouChong

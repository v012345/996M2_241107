local XinYueHuanJing = {}
XinYueHuanJing.ID = "新月幻境"
--接收请求
function XinYueHuanJing.Request(actor,var)
    if not checkitems(actor,"幻境通行证#1",0,0) then
        Player.sendmsgEx(actor, "提示#251|:#255|对不起,你背包内没有|幻境通行证#249|无法进入...")
        return
    end

    if getsysvar(VarCfg["A_幻境地图开关"]) ~= "开" then
        Player.sendmsgEx(actor, "提示#251|:#255|对不起,请在|22点05分--10点05分#249|之间进入...")
        return
    end
    
    if var == 1 then
        map(actor, "新月幻境1")
    end
    if var == 2 then
        map(actor, "新月幻境2")
    end
end

--注册网络消息
Message.RegisterNetMsg(ssrNetMsgCfg.XinYueHuanJing, XinYueHuanJing)
return XinYueHuanJing
local JiuXianLiBai = {}
JiuXianLiBai.ID = "酒仙李白"
local jiucfg = {"女儿红","竹叶青","寒潭香","金茎露","秋露白"}
local jiumnul = {750,750,550,200,200}
local varList = {VarCfg["U_女儿红"],VarCfg["U_竹叶青"],VarCfg["U_寒潭香"],VarCfg["U_金茎露"],VarCfg["U_秋露白"]}
local attdata = {"攻击附加","血量附加","切割附加","其他附加","爆率附加"}

function JiuXianLiBai.ButtonLink1(actor ,arg1)
    if not jiucfg[arg1] then
        Player.sendmsgEx(actor, "参数错误!#249")
        return
    end
    
    if getplaydef(actor ,varList[arg1]) >= jiumnul[arg1]  then
        Player.sendmsgEx(actor, "提示#251|:#255|你的|"..jiucfg[arg1].."#249|已经喝够|"..jiumnul[arg1].."瓶#249|了...")
        return
    elseif not checkitems(actor,jiucfg[arg1].."#1",0,0)  then
        Player.sendmsgEx(actor, "提示#251|:#255|你的|"..jiucfg[arg1].."#249|不足|1瓶#249|饮酒失败...")
        return
    else
        takeitem(actor,jiucfg[arg1],1,0)
        setplaydef(actor,varList[arg1],getplaydef(actor ,varList[arg1])+1)
        if arg1 == 5 then
            Player.setAttList(actor, "爆率附加")
        else
            Player.setAttList(actor, "属性附加")
        end
    end
    JiuXianLiBai.SyncResponse(actor)
end


function JiuXianLiBai.ButtonLink2(actor)

    if getplaydef(actor,VarCfg["U_女儿红"]) < 750 then
        Player.sendmsgEx(actor, "提示#251|:#255|你的|女儿红#249|饮酒不足|750瓶#249|领取失败...")
    return
    end

    if getplaydef(actor,VarCfg["U_竹叶青"]) < 750 then
        Player.sendmsgEx(actor, "提示#251|:#255|你的|竹叶青#249|饮酒不足|750瓶#249|领取失败...")
    return
    end

    if getplaydef(actor,VarCfg["U_寒潭香"]) < 550 then
        Player.sendmsgEx(actor, "提示#251|:#255|你的|寒潭香#249|饮酒不足|750瓶#249|领取失败...")
    return
    end

    if getplaydef(actor,VarCfg["U_金茎露"]) < 200 then
        Player.sendmsgEx(actor, "提示#251|:#255|你的|金茎露#249|饮酒不足|750瓶#249|领取失败...")
    return
    end

    if getplaydef(actor,VarCfg["U_秋露白"]) < 200 then
        Player.sendmsgEx(actor, "提示#251|:#255|你的|秋露白#249|饮酒不足|750瓶#249|领取失败...")
    return
    end

    if checktitle(actor,"我不是酒神")  then
        Player.sendmsgEx(actor, "提示#251|:#255|你已领取|我不是酒神#249|称号...")
    return
    end
    confertitle(actor,"我不是酒神",1)
    Player.sendmsgEx(actor,"恭喜您成功领取|我不是酒神#249|称号...")
    Player.setAttList(actor, "爆率附加")
    Player.setAttList(actor, "属性附加")
    JiuXianLiBai.SyncResponse(actor)
end

   --同步消息
function JiuXianLiBai.SyncResponse(actor, logindatas)
    local U111 = getplaydef(actor,VarCfg["U_女儿红"])
    local U112 = getplaydef(actor,VarCfg["U_竹叶青"])
    local U113 = getplaydef(actor,VarCfg["U_寒潭香"])
    local U114 = getplaydef(actor,VarCfg["U_金茎露"])
    local U115 = getplaydef(actor,VarCfg["U_秋露白"])
    local data = {U111,U112,U113,U114,U115}

    local _login_data = {ssrNetMsgCfg.JiuXianLiBai_SyncResponse, 0, 0, 0, data}
    if logindatas then
        table.insert(logindatas, _login_data)
    else
        Message.sendmsg(actor, ssrNetMsgCfg.JiuXianLiBai_SyncResponse, 0, 0, 0, data)
    end
end

local function _onCalcAttr(actor,attrs)
    local GuDing_HP = 0
    local GuDing_GongJi = 0
    local qiege = 0
    local mianshang = 0
    local U111 = getplaydef(actor,VarCfg["U_女儿红"])
    local U112 = getplaydef(actor,VarCfg["U_竹叶青"])
    local U113 = getplaydef(actor,VarCfg["U_寒潭香"])
    local U114 = getplaydef(actor,VarCfg["U_金茎露"])

    if U111 > 0 then
        GuDing_GongJi = U111 * 1
    end

    if U112 > 0 then
        GuDing_HP = GuDing_HP + U112*20
    end

    if U113 > 0 then
        qiege = U113 * 8
    end

    if U114 > 0 then
        mianshang = U114 * 10
    end

    local shuxingMap = {
        [1] = GuDing_HP,
        [4] = GuDing_GongJi,
        [200] = qiege,
        [215] = mianshang
    }
    local shuxing = {}
    for key, value in pairs(shuxingMap) do
        if value > 0 then
            shuxing[key] = value
        end
    end
    calcAtts(attrs,shuxing,"小酒馆")
end

--属性
GameEvent.add(EventCfg.onCalcAttr, _onCalcAttr, JiuXianLiBai)

--爆率附加计算
local function _onCalcBaoLv(actor,attrs)
    local shuxing = {}
    local U115 = getplaydef(actor,VarCfg["U_秋露白"])
    if U115 > 0 then
        shuxing[204] = U115
    end
    calcAtts(attrs,shuxing,"爆率附加:小酒馆")
end
--爆率计算
GameEvent.add(EventCfg.onCalcBaoLv, _onCalcBaoLv, JiuXianLiBai)

--登录触发
local function _onLoginEnd(actor, logindatas)
    JiuXianLiBai.SyncResponse(actor, logindatas)
end
--事件派发
GameEvent.add(EventCfg.onLoginEnd, _onLoginEnd, JiuXianLiBai)

--注册网络消息
Message.RegisterNetMsg(ssrNetMsgCfg.JiuXianLiBai, JiuXianLiBai)
return JiuXianLiBai
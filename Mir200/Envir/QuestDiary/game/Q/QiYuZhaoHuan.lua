local QiYuZhaoHuan = {}
local BoosName = {"混沌·蛮荒树妖统领","混沌·天元冰霜巨兽","混沌·神龙雷霆暴君","混沌·冥司酆都大帝","混沌·极恶大地魔王","混沌·太阳神炎沙巨蝎","混沌·破晓金刚·天妖傀", "混沌·新月金焱圣龙"}

function QiYuZhaoHuan.Request(actor, arg1, arg2, arg3, arg4)
    local _InTheMap = getbaseinfo(actor,ConstCfg.gbase.mapid)
    local InTheMap = (_InTheMap ~= "n3") and (_InTheMap ~= "new0150")
    if InTheMap then
        local MonName = getplaydef(actor,VarCfg["S$奇遇召唤"])
        -- ----------------验证奇遇----------------
        local NotInTheZhaoHuan = true
        for _, v in ipairs(BoosName) do
            if v == MonName then
                NotInTheZhaoHuan = false
                break
            end
        end
        if NotInTheZhaoHuan then return  end
        ----------------验证奇遇----------------

        if MonName == arg4[1] then
            local MapId = getbaseinfo(actor, ConstCfg.gbase.mapid)
            local X,Y = getbaseinfo(actor, ConstCfg.gbase.x), getbaseinfo(actor, ConstCfg.gbase.y)
            genmon(MapId, X, Y, MonName, 3, 1, 255)
            setplaydef(actor, VarCfg["S$奇遇召唤"], "")
        end
    else
        if _InTheMap == "n3" then
            Player.sendmsgEx(actor, "提示#251|:#255|召唤失败,|玄天大陆#249|范围内无法召唤...")
        end

        if _InTheMap == "new0150" then
            Player.sendmsgEx(actor, "提示#251|:#255|召唤失败,|皇宫#249|范围内无法召唤...")
        end
        setplaydef(actor, VarCfg["S$奇遇召唤"], "")
    end
end

function QiYuZhaoHuan.CloseUI(actor, arg1, arg2, arg3, _QDevent)
    ----------------验证奇遇----------------
    local verify = getplaydef(actor,VarCfg["S$奇遇召唤"])
    if verify ~= _QDevent[1] then
        Player.sendmsgEx(actor, "提示#251|:#255|非法请求#249|")
        return
    end
    ----------------验证奇遇----------------
    QiYuHeZi.ClientAddEvent(actor,verify)
    setplaydef(actor,VarCfg["S$奇遇召唤"],"")
end

--触发事件后 初始变量
local function _LuckyEventinitVar(actor, LuckyEventName)
    local IsZhaoHuan = false
    for _, v in ipairs(BoosName) do
        if v == LuckyEventName then
            IsZhaoHuan = true
            break
        end
    end

    if IsZhaoHuan then
        setplaydef(actor, VarCfg["S$奇遇召唤"], LuckyEventName)
    end
end
GameEvent.add(EventCfg.LuckyEventinitVar, _LuckyEventinitVar, QiYuZhaoHuan)

--注册网络消息
Message.RegisterNetMsg(ssrNetMsgCfg.QiYuZhaoHuan, QiYuZhaoHuan)


return QiYuZhaoHuan

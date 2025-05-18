local LuoPanZhanBu = {}
local cost = {{"灵符", 200}}
--取出称号进行添加
function AddATitleFunc(actor, ConferTitleName)
    if not checktitle(actor, ConferTitleName) then
        confertitle(actor, ConferTitleName)
        changetitletime(actor, ConferTitleName, "=", os.time() + 21600)
        if ConferTitleName ==  "命运罗盘·撕裂" then
            Player.setAttList(actor, "属性附加")
        elseif ConferTitleName ==  "命运罗盘·祝福" then
            Player.setAttList(actor, "爆率附加")
        elseif ConferTitleName ==  "命运罗盘·速度" then
            Player.setAttList(actor, "攻速附加")
        end
    end
    Player.sendmsgEx(actor, "提示#251|:#255|恭喜你,占卜到|".. ConferTitleName .."#249|了,进度|+1#249|...") 
    --------------------------------------检测是否全部满级了--------------------------------------
    if LuoPanZhanBu.CheckTitle(actor) then
        local Type = {"祝福","速度","武力","体魄","怒火","暴力","破坏","绝杀","穿透","撕裂"}
        for _, v in ipairs(Type) do
            deprivetitle(actor, "命运罗盘·"..v)
        end
        confertitle(actor, "命运罗盘·掌控者")
        Player.setAttList(actor, "属性附加")
        Player.setAttList(actor, "爆率附加")
        Player.setAttList(actor, "攻速附加")
    end
    --------------------------------------检测是否全部满级了--------------------------------------
    LuoPanZhanBu.SyncResponse(actor) --通信前端
end

function LuoPanZhanBu.Request(actor, var)
    if checktitle(actor, "命运罗盘·掌控者") then
        Player.sendmsgEx(actor, "提示#251|:#255|你已经是|命运掌控者#249|了,无需占卜了...")
        return
    end
    local CiShu = getplaydef(actor,VarCfg["J_命运罗盘每日免费1次"])
    if CiShu >= 1 then
        local name, num = Player.checkItemNumByTable(actor, cost)
        if name then
            Player.sendmsgEx(actor, string.format("提示#251|:#255|你的|%s#249|不足|%d#249|枚,占卜失败...", name, num))
            return
        end
        Player.takeItemByTable(actor, cost, "扣除占卜的费用")
    end
    setplaydef(actor,VarCfg["J_命运罗盘每日免费1次"],CiShu+1)

    local ZhanBuTbl = Player.getJsonTableByVar(actor, VarCfg["T_罗盘占卜记录"])
    local Type = {"祝福","速度","武力","体魄","怒火","暴力","破坏","绝杀","穿透","撕裂"}
    local FinalTypeTbl = {}
    local NewType = {}
    for _, v in ipairs(Type) do
        local TypeNum = (ZhanBuTbl[v] == "" and 0) or ZhanBuTbl[v]  or 0
        if TypeNum < 66 then
            table.insert(NewType, v)
        end
    end
    if #NewType == 0 then return end  --没有可遍历的为全部都已经达到66级
    if #NewType == 10 then --10个未达到66级
        local NewTbl = {}
        for _, v in pairs(Type) do
            if not checktitle(actor, "命运罗盘·".. v .."") then
                table.insert(NewTbl, v)
            end
        end
        if #NewTbl > 0 then
            FinalTypeTbl = NewTbl
        else
            FinalTypeTbl = NewType
        end
    else   --有达到66级
        FinalTypeTbl = NewType
    end

    local num = math.random(1, #FinalTypeTbl)
    local TypeName = FinalTypeTbl[num]
    local TypeNum = (ZhanBuTbl[TypeName] == "" and 0) or ZhanBuTbl[TypeName]  or 0
    ZhanBuTbl[TypeName] = TypeNum + 1
    Player.setJsonVarByTable(actor, VarCfg["T_罗盘占卜记录"],ZhanBuTbl)
    local ConferTitleName = "命运罗盘·"..FinalTypeTbl[num]
    AddATitleFunc(actor, ConferTitleName)  --执行添加称号函数
end

--攻击触发
local function _onCalcAttackSpeed(actor, attackSpeeds)
    if checktitle(actor,"命运罗盘·掌控者") or checktitle(actor,"命运罗盘·速度") then
        attackSpeeds[1] = attackSpeeds[1] + 50
    end
end
GameEvent.add(EventCfg.onCalcAttackSpeed, _onCalcAttackSpeed, LuoPanZhanBu)

function LuoPanZhanBu.CheckTitle(actor)
    local ZhanBuTbl = Player.getJsonTableByVar(actor, VarCfg["T_罗盘占卜记录"])
    local Type = {"祝福","速度","武力","体魄","怒火","暴力","破坏","绝杀","穿透","撕裂"}
    local TitleBool = true
    for _, v in ipairs(Type) do
        local TypeNum = (ZhanBuTbl[v] == "" and 0) or ZhanBuTbl[v]  or 0
        if TypeNum < 66 then
            TitleBool = false
        end
    end
    return TitleBool
end
--注册网络消息
function LuoPanZhanBu.SyncResponse(actor, logindatas)
    local ZhanBuTbl = Player.getJsonTableByVar(actor, VarCfg["T_罗盘占卜记录"])
    local Type = {"祝福","速度","武力","体魄","怒火","暴力","破坏","绝杀","穿透","撕裂"}
    local NewTbl = {}
    for _, v in ipairs(Type) do
        local Num = (ZhanBuTbl[v] == "" and 0) or ZhanBuTbl[v]  or 0
        table.insert(NewTbl, Num)
    end
    Message.sendmsg(actor, ssrNetMsgCfg.LuoPanZhanBu_SyncResponse, 0, 0, 0, NewTbl)
end
Message.RegisterNetMsg(ssrNetMsgCfg.LuoPanZhanBu, LuoPanZhanBu)

return LuoPanZhanBu



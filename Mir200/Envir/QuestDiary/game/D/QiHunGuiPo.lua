local QiHunGuiPo = {}
QiHunGuiPo.ID = "Æß»ì¹éÆÇ"
local npcID = 469
local TypeData = {"Ê¬¹·","·üÊ¸","È¸Òõ","ÍÌÔô","·Ç¶¾","³ı»à","³ô·Î"}
local cost = {{}}
local give = {{}}

function QiHunGuiPo.getVariableState(actor)
    local IsTbl = Player.getJsonTableByVar(actor, VarCfg["T_Æß»ê¹éÆÇ"])
    local NewTbl = {}
    NewTbl["Ê¬¹·"] = (IsTbl["Ê¬¹·"] == nil and 0) or IsTbl["Ê¬¹·"]
    NewTbl["·üÊ¸"] = (IsTbl["·üÊ¸"] == nil and 0) or IsTbl["·üÊ¸"]
    NewTbl["È¸Òõ"] = (IsTbl["È¸Òõ"] == nil and 0) or IsTbl["È¸Òõ"]
    NewTbl["ÍÌÔô"] = (IsTbl["ÍÌÔô"] == nil and 0) or IsTbl["ÍÌÔô"]
    NewTbl["·Ç¶¾"] = (IsTbl["·Ç¶¾"] == nil and 0) or IsTbl["·Ç¶¾"]
    NewTbl["³ı»à"] = (IsTbl["³ı»à"] == nil and 0) or IsTbl["³ı»à"]
    NewTbl["³ô·Î"] = (IsTbl["³ô·Î"] == nil and 0) or IsTbl["³ô·Î"]
    return NewTbl
end


--½ÓÊÕÇëÇó
function QiHunGuiPo.Request(actor, var)
    if not TypeData[var] then return end --ÎŞĞ§²ÎÊı
    local data = QiHunGuiPo.getVariableState(actor)
    local _type = TypeData[var]
    local costitem = "ÆßÆÇ¡¤".._type

    if data[_type] >= 10 then
        Player.sendmsgEx(actor, "ÌáÊ¾#251|:#255|¶Ô²»Æğ,ÄãµÄ|".. costitem .."#249|ÒÑ¾­´ïµ½|10¼¶#249|ÁË...")
        return
    end

    local cost = {{costitem, 1},{"Áé·û", 200}}
    local name, num = Player.checkItemNumByTable(actor, cost)
    if name then
        Player.sendmsgEx(actor, string.format("ÌáÊ¾#251|:#255|ÄãµÄ|%s#249|²»×ã|%d#249|Ã¶,Ìá½»Ê§°Ü...", name, num))
        return
    end
    Player.takeItemByTable(actor, cost, costitem.."Ìá½»")
    data[_type] = data[_type] + 1

    Player.setJsonVarByTable(actor, VarCfg["T_Æß»ê¹éÆÇ"], data)
    QiHunGuiPo.SyncResponse(actor)
    Player.setAttList(actor, "ÊôĞÔ¸½¼Ó")
end

--Í¬²½ÏûÏ¢
function QiHunGuiPo.SyncResponse(actor, logindatas)
    local data = QiHunGuiPo.getVariableState(actor)
    local _login_data = {ssrNetMsgCfg.QiHunGuiPo_SyncResponse, 0, 0, 0, data}
    if logindatas then
        table.insert(logindatas, _login_data)
    else
        Message.sendmsg(actor, ssrNetMsgCfg.QiHunGuiPo_SyncResponse, 0, 0, 0, data)
    end
end

--ÊôĞÔ¸½¼Ó
local function _onCalcAttr(actor, attrs)
    local data = QiHunGuiPo.getVariableState(actor)
    local shuxing = {}

    if data["Ê¬¹·"] > 0 then  --ÈËÎïÌåÁ¦
        shuxing[208] = data["Ê¬¹·"]
    end

    if data["·üÊ¸"] > 0 then  --±©»÷¼¸ÂÊ
        shuxing[21] = data["·üÊ¸"]
    end

    if data["È¸Òõ"] > 0 then  --¹¥»÷ÉËº¦
        shuxing[25] = data["È¸Òõ"]
    end

    if data["ÍÌÔô"] > 0 then  --±©»÷ÉËº¦
        shuxing[22] = data["ÍÌÔô"]
    end

    if data["·Ç¶¾"] > 0 then --·ÀÓù¼Ó³É
        shuxing[213] = data["·Ç¶¾"]
        shuxing[214] = data["·Ç¶¾"]
    end

    if data["³ı»à"] > 0 then --ÉËº¦ÎüÊÕ
        shuxing[26] = data["³ı»à"]
        shuxing[27] = data["³ı»à"]
    end

    if data["³ô·Î"] > 0 then --¶Ô¹ÖÔöÉË
        shuxing[75] = data["³ô·Î"] * 100
    end
    calcAtts(attrs, shuxing, "Æß»ê¹éÆÇ")
end
GameEvent.add(EventCfg.onCalcAttr, _onCalcAttr, QiHunGuiPo)


--µÇÂ¼´¥·¢
local function _onLoginEnd(actor, logindatas)
    QiHunGuiPo.SyncResponse(actor, logindatas)
end
--ÊÂ¼şÅÉ·¢
GameEvent.add(EventCfg.onLoginEnd, _onLoginEnd, QiHunGuiPo)
--×¢²áÍøÂçÏûÏ¢
Message.RegisterNetMsg(ssrNetMsgCfg.QiHunGuiPo, QiHunGuiPo)
return QiHunGuiPo
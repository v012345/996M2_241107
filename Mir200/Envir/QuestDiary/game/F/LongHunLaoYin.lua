local LongHunLaoYin = {}
local cost ={{{"啸之戒指", 1},{"混沌本源", 66},{"灵符", 8888}},{{"天殇之痕", 1},{"混沌本源", 66},{"灵符", 8888}},{{"巨龙之印", 1},{"混沌本源", 66},{"灵符", 8888}}} 
local LaoYinName = {"龙裂","龙灭","龙噬"}

--获取激活状态
function LongHunLaoYin.getFlagstate(actor)
    local state1 = getflagstatus(actor,VarCfg["F_龙魂烙印1"])
    local state2 = getflagstatus(actor,VarCfg["F_龙魂烙印2"])
    local state3 = getflagstatus(actor,VarCfg["F_龙魂烙印3"])
    local flagTbl = {state1,state2,state3}
    return flagTbl
end
-- 圣地龙之魂顶层	52	47
function LongHunLaoYin.Request(actor,var)
    local flagTbl = LongHunLaoYin.getFlagstate(actor) --获取激活状态
    if flagTbl[var] == 1 then 
        Player.sendmsgEx(actor, "[提示]:#251|你的龙族雕石已将|".. LaoYinName[var] .."#249|烙印过了!")
        return
    end

    local name, num = Player.checkItemNumByTable(actor, cost[var])
    if name then
        Player.sendmsgEx(actor, string.format("提示#251|:#255|你的|%s#249|数量不足|%d#249|,烙印失败...", name, num))
        return
    end
    Player.takeItemByTable(actor, cost[var], "重塑轮回"..var.. "")
    setflagstatus(actor,VarCfg["F_完成任意龙魂烙印"],1)
    --清空全部烙印
    setflagstatus(actor,VarCfg["F_龙魂烙印1"],0)
    setflagstatus(actor,VarCfg["F_龙魂烙印2"],0)
    setflagstatus(actor,VarCfg["F_龙魂烙印3"],0)
    --设置新的烙印
    setflagstatus(actor,VarCfg["F_龙魂烙印".. var ..""], 1)
    local itemobj = linkbodyitem(actor, 89)
    clearitemcustomabil(actor, itemobj,0)
    changecustomitemtext(actor, itemobj, "[龙魂烙印]", 0)
    changecustomitemtextcolor(actor, itemobj, 253, 0)
    changecustomitemabil(actor,itemobj,0,1,174,0) --真实属性
    changecustomitemabil(actor,itemobj,0,2,36+var,0) --显示属性
    changecustomitemabil(actor,itemobj,0,4,0,0)   --显示位置(0~9)
    changecustomitemvalue(actor,itemobj,0,"=",1,0)
    refreshitem(actor,itemobj)
    Player.setAttList(actor, "属性附加")
    --刷新前端
    LongHunLaoYin.SyncResponse(actor)
end

--属性刷新
local function _onCalcAttr(actor, attrs)
    local flagTbl = LongHunLaoYin.getFlagstate(actor) --获取激活状态
    local attrtbl = {    }
    if flagTbl[1] == 1 then
        attrtbl[200] = 25555
    end

    if flagTbl[3] == 1 then
        attrtbl[25] = 10
        attrtbl[81] = 500
    end
    calcAtts(attrs, attrtbl, "龙魂烙印")
end
GameEvent.add(EventCfg.onCalcAttr, _onCalcAttr, LongHunLaoYin)


--攻击触发
local function _onAttackDamagePlayer(actor, Target, Hiter, MagicId, Damage, Model, attackDamageData)
    if getflagstatus(actor,VarCfg["F_龙魂烙印2"]) == 1 then
        if randomex(1,128) then
            local _ac  = getbaseinfo(Target, ConstCfg.gbase.ac)
            local _ac2  = getbaseinfo(Target, ConstCfg.gbase.ac2)
            local _mac  = getbaseinfo(Target, ConstCfg.gbase.mac)
            local _mac2  = getbaseinfo(Target, ConstCfg.gbase.mac2)
            changehumability(Target, 1, -_ac, 2)
            changehumability(Target, 2, -_ac2, 2)
            changehumability(Target, 3, -_mac, 2)
            changehumability(Target, 4, -_mac2, 2)
            humanhp(Target, "-", Player.getHpValue(Target, 10), 106, 0, actor) --斩杀10%生命
            local myName = Player.GetNameEx(actor)
            local targetName = Player.GetNameEx(Target)
            Player.buffTipsMsg(actor, "[龙灭烙印]:你清空[{" .. targetName .. "/FCOLOR=243}]的防御{2/FCOLOR=243}秒,并斩杀10%最大生命...")
            Player.buffTipsMsg(Target, "[龙灭烙印]:你被[{" .. myName .. "/FCOLOR=243}]清空防御{2/FCOLOR=243}秒,并斩杀10%最大生命...")
        end
    end
end
GameEvent.add(EventCfg.onAttackDamagePlayer, _onAttackDamagePlayer, LongHunLaoYin)



--注册网络消息
function LongHunLaoYin.SyncResponse(actor, logindatas)
    local data = LongHunLaoYin.getFlagstate(actor) --获取激活状态
    local _login_data = { ssrNetMsgCfg.LongHunLaoYin_SyncResponse, 0, 0, 0, data }
    if logindatas then
        table.insert(logindatas, _login_data)
    else
        Message.sendmsg(actor, ssrNetMsgCfg.LongHunLaoYin_SyncResponse, 0, 0, 0, data)
    end
end
Message.RegisterNetMsg(ssrNetMsgCfg.LongHunLaoYin, LongHunLaoYin)

--登录触发
local function _onLoginEnd(actor, logindatas)
    LongHunLaoYin.SyncResponse(actor, logindatas)
end
GameEvent.add(EventCfg.onLoginEnd, _onLoginEnd, LongHunLaoYin)

return LongHunLaoYin


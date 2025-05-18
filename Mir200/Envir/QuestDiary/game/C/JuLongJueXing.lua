JuLongJueXing = {}
local config = include("QuestDiary/cfgcsv/cfg_JuLongJueXing.lua")
local itemdata = { "龙族雕石[未觉醒]", "龙族雕石[一阶觉醒]", "龙族雕石[二阶觉醒]", "龙族雕石[三阶觉醒]", "龙族雕石[四阶觉醒]", "龙族雕石[五阶觉醒]" }

local indexMap = {
    ["龙族雕石[一阶觉醒]"]=1,
    ["龙族雕石[二阶觉醒]"]=2,
    ["龙族雕石[三阶觉醒]"]=3,
    ["龙族雕石[四阶觉醒]"]=4,
    ["龙族雕石[五阶觉醒]"]=5 
}

--判定是否已经达到130级
function JuLongJueXing.checklevel(actor)
    local level = getbaseinfo(actor, ConstCfg.gbase.level)
    if level < 130 then
        return true
    else
        return false
    end
end

function JuLongJueXing.ButtonLink1(actor, arg1, arg2, arg3, data)
    if JuLongJueXing.checklevel(actor) then
        Player.sendmsgEx(actor, "提示#251|:#255|你的等级不足|130级#249|请达到等级后再来...")
        return
    end
    local data = json2tbl(getplaydef(actor, VarCfg["T_龙族雕石经验"]))
    if data["cur"] >= 39888 then
        Player.sendmsgEx(actor, "提示#251|:#255|你的|吞噬经验#249|已经|达到阈值#249|吞噬失败...")
        return
    end
    if takeitem(actor, "幻灵水晶", 5, 0) then
        local num = math.random(10, 15)
        local nownum
        if data["cur"] + num > 39888 then
            nownum = 39888
        else
            nownum = data["cur"] + num 
        end
        local str = {
            ["cur"] = nownum,
            ["max"] = data["max"],
            ["name"] = data["name"]
        }
        setplaydef(actor, VarCfg["T_龙族雕石经验"], tbl2json(str))
        FSetTaskRedPoint(actor, VarCfg["F_巨龙觉醒完成"], 15)
        JuLongJueXing.SyncResponse(actor) --发送网络消息
        return
    end
    Player.sendmsgEx(actor, "提示#251|:#255|你的|幻灵水晶#249|不足|5个#249|吞噬失败...")
end

function JuLongJueXing.ButtonLink2(actor, arg1, arg2, arg3, data)
    if JuLongJueXing.checklevel(actor) then
        Player.sendmsgEx(actor, "提示#251|:#255|你的等级不足|130级#249|请达到等级后再来...")
        return
    end
    local data = json2tbl(getplaydef(actor, VarCfg["T_龙族雕石经验"]))
    if data["cur"] >= 39888 then
        Player.sendmsgEx(actor, "提示#251|:#255|你的|吞噬经验#249|已经|达到阈值#249|吞噬失败...")
        return
    end
    if getbindmoney(actor, "元宝") >= 40000 then
        consumebindmoney(actor, "元宝", 40000, "扣除元宝")
        local num = math.random(38, 188)
        local nownum
        if data["cur"] + num > 39888 then
            nownum = 39888
        else
            nownum = data["cur"] + num
        end
        local str = {
            ["cur"] = nownum,
            ["max"] = data["max"],
            ["name"] = data["name"]
        }
        setplaydef(actor, VarCfg["T_龙族雕石经验"], tbl2json(str))
        FSetTaskRedPoint(actor, VarCfg["F_巨龙觉醒完成"], 15)
        JuLongJueXing.SyncResponse(actor) --发送网络消息
        return
    end
    Player.sendmsgEx(actor, "提示#251|:#255|你的|元宝#249|不足|40000枚#249|吞噬失败...")
end

function JuLongJueXing.ButtonLink3(actor, arg1, arg2, arg3, data)
    if JuLongJueXing.checklevel(actor) then
        Player.sendmsgEx(actor, "提示#251|:#255|你的等级不足|130级#249|请达到等级后再来...")
        return
    end
    local data = json2tbl(getplaydef(actor, VarCfg["T_龙族雕石经验"]))
    if data["cur"] > 39888 then
        Player.sendmsgEx(actor, "提示#251|:#255|你的|吞噬经验#249|已经|达到阈值#249|吞噬失败...")
        return
    end
    if data["cur"] >= data["max"] then
        local itemobj = linkbodyitem(actor, 89)
        local itemname = getiteminfo(actor, itemobj, 7)
        local _itemname
        local itemexp

        if itemobj == "0" then return end --装备位置为空 直接结束

        for i = 1, #itemdata do
            if itemdata[i] == itemname then
                _itemname = itemdata[i + 1] --下一届装备名字
                break
            end
        end
        -- local takestate = takeitem(actor, "灵石", 10, 0)

        -- if not takestate then
        --     Player.sendmsgEx(actor, "提示#251|:#255|你的|灵石#249|不足|20枚#249|吞噬失败...")
        --     return
        -- end

        local cfg = config[_itemname]
        if not cfg then
            Player.sendmsgEx(actor,"参数错误#249")
            return
        end
        local cost = cfg.cost
        local name, num = Player.checkItemNumByTable(actor, cost)
        if name then
            Player.sendmsgEx(actor, string.format("[提示]:#251|觉醒失败,你的|%s#249|不足|%d#249", name, num))
            return
        end
        local state1 = getflagstatus(actor,VarCfg["F_龙魂烙印1"])
        local state2 = getflagstatus(actor,VarCfg["F_龙魂烙印2"])
        local state3 = getflagstatus(actor,VarCfg["F_龙魂烙印3"])
        local flagTbl = {state1,state2,state3}
        local state = true
        for _, v in ipairs(flagTbl) do
            if v == 1 then
                state = false
                break
            end
        end

        if state then
            Player.takeItemByTable(actor, cost, "巨龙觉醒")
            giveonitem(actor, 89, _itemname, 1, 0, "穿戴下一级装备")
        else
            --清理自定义属性后删除装备
            local itemobj = linkbodyitem(actor, 89)
            clearitemcustomabil(actor, itemobj,0)
            Player.takeItemByTable(actor, cost, "巨龙觉醒")

            --穿戴装备
            giveonitem(actor, 89, _itemname, 1, 0, "穿戴下一级装备")
            local itemobj = linkbodyitem(actor, 89)
            local Attrnum = (flagTbl[1] == 1 and 37) or (flagTbl[2] == 1 and 38) or (flagTbl[3] == 1 and 39)
            changecustomitemtext(actor, itemobj, "[龙魂烙印]", 0)
            changecustomitemtextcolor(actor, itemobj, 253, 0)
            changecustomitemabil(actor,itemobj,0,1,174,0) --真实属性
            changecustomitemabil(actor,itemobj,0,2,Attrnum,0) --显示属性
            changecustomitemabil(actor,itemobj,0,4,0,0)   --显示位置(0~9)
            changecustomitemvalue(actor,itemobj,0,"=",1,0)
            refreshitem(actor,itemobj)
        end




        -- setflagstatus(actor,VarCfg["F_巨龙觉醒完成"],1)
        
        takeitem(actor, itemname, 1, 0)

        if _itemname ~= "龙族雕石[五阶觉醒]" then
            for i = 1, #itemdata do
                if itemdata[i] == _itemname then
                    itemexp = itemdata[i + 1] --下一届装备名字
                    local str = {
                        ["cur"] = data["cur"] - config[_itemname].leveliexp,
                        ["max"] = config[itemexp].leveliexp,
                        ["name"] = _itemname
                    }
                    setplaydef(actor, VarCfg["T_龙族雕石经验"], tbl2json(str))
                    JuLongJueXing.SyncResponse(actor) --发送网络消息
                    break
                end
            end
        end

        if _itemname == "龙族雕石[五阶觉醒]" then
            local str = {
                ["cur"] = 9999999,
                ["max"] = 9999999,
                ["name"] = "龙族雕石[五阶觉醒]"
            }
            setplaydef(actor, VarCfg["T_龙族雕石经验"], tbl2json(str))
            JuLongJueXing.SyncResponse(actor) --发送网络消息
        end
    end
end

--发送网络消息
function JuLongJueXing.SyncResponse(actor, logindatas)
    local data = json2tbl(getplaydef(actor, VarCfg["T_龙族雕石经验"]))
    local max = data["max"]
    local cur = data["cur"]
    local name = data["name"]
    local _data = { cur, max, name }

    local _login_data = { ssrNetMsgCfg.JuLongJueXing_SyncResponse, 0, 0, 0, _data }
    if logindatas then
        table.insert(logindatas, _login_data)
    else
        Message.sendmsg(actor, ssrNetMsgCfg.JuLongJueXing_SyncResponse, 0, 0, 0, _data)
    end
end

--穿戴触发
local function _onTakeOn40(actor, itemobj)
    -- local Clienttype = getconst(actor, "<$CLIENTFLAG>")
    -- local itemobj = linkbodyitem(actor, 40)
    -- local itemname = getiteminfo(actor, itemobj, 7)
    -- if itemobj == "0" then return end --装备位置为空 直接结束

    -- if getflagstatus(actor, VarCfg["F_天命_龙神学院标识"]) == 1 then
    --     local JingYan = 0
    --     for i = 1, #itemdata do
    --         if itemname == itemdata[i] then
    --             JingYan = 8 * (i - 1)
    --             addattlist(actor, "龙族经验", "=", "3#203#" .. JingYan .. "", 1)
    --             break
    --         end
    --     end
    -- end

end
GameEvent.add(EventCfg.onTakeOn40, _onTakeOn40, JuLongJueXing)

--脱掉触发
local function _onTakeOff40(actor, itemobj)
    -- delattlist(actor, "龙族经验")
end
GameEvent.add(EventCfg.onTakeOff40, _onTakeOff40, JuLongJueXing)

--登录触发
local function _onLoginEnd(actor, logindatas)
    JuLongJueXing.SyncResponse(actor, logindatas) --同步消息
end
GameEvent.add(EventCfg.onLoginEnd, _onLoginEnd, JuLongJueXing)

--属性附加
local function _onCalcAttr(actor,attrs)
    if getflagstatus(actor, VarCfg["F_天命_龙神学院标识"]) == 1 then
        local itemobj = linkbodyitem(actor, 89)
        if itemobj == "0" then return end --装备位置为空 直接结束
        local itemname = getiteminfo(actor, itemobj, 7)
        local shuxing = {}
        if indexMap[itemname] then
            shuxing[203] = 8 * indexMap[itemname]
            setplaydef(actor,VarCfg["N$龙神学院经验加成"], 8 * indexMap[itemname])
        end
        calcAtts(attrs,shuxing,"巨龙觉醒经验加成")
    end
end

--属性
GameEvent.add(EventCfg.onCalcAttr, _onCalcAttr, JuLongJueXing)
Message.RegisterNetMsg(ssrNetMsgCfg.JuLongJueXing, JuLongJueXing)
return JuLongJueXing

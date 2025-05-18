local JiYinGaiZao = {}
local config = include("QuestDiary/cfgcsv/cfg_JiYinGaiZao.lua") --配置
local cost = { { "灵符", 200 }, { "元宝", 200000 } }
local abilGroup1 = 1
local abilGroup2 = 2
-- 使徒实验室	21	22
--获取基因改造数据并返会一个tbl
function JiYinGaiZao.getVariableState(actor)
    local IsTbl = Player.getJsonTableByVar(actor, VarCfg["T_基因改造数据"])
    local NewTbl = {}
    NewTbl.level = (IsTbl.level == nil and 0) or IsTbl.level
    NewTbl.site1 = (IsTbl.site1 == nil and "暂无") or IsTbl.site1
    NewTbl.site2 = (IsTbl.site2 == nil and "暂无") or IsTbl.site2
    NewTbl.site3 = (IsTbl.site3 == nil and "暂无") or IsTbl.site3
    NewTbl.site4 = (IsTbl.site4 == nil and "暂无") or IsTbl.site4
    NewTbl.site5 = (IsTbl.site5 == nil and "暂无") or IsTbl.site5
    NewTbl.site6 = (IsTbl.site6 == nil and "暂无") or IsTbl.site6
    NewTbl.site7 = (IsTbl.site7 == nil and "暂无") or IsTbl.site7
    return NewTbl
end

--初始化基因位置前三位
function JiYinGaiZao.JiYin_PuTong(actor)
    local result = "攻转道#1|攻转魔#1|道转攻#1|道转魔#1|魔转攻#1|魔转道#1"
    local JiYinNum1, result = ransjstr(result, 1, 3)
    local JiYinNum2, _ = ransjstr(result, 1, 3)
    local JiYinNum3, _ = ransjstr("红转蓝#1|蓝转红#1", 1, 3)
    return JiYinNum1, JiYinNum2, JiYinNum3
end

local ChaoJiData = { "攻击元素", "魔法元素", "道术元素", "物防加成", "魔防加成", "血量加成", "蓝量加成", "攻击伤害", "物伤减免", "魔法减免", "连爆概率", "打怪増伤",
    "受怪减伤", "暴击概率", "暴击抵抗" }
--获取超级基因查重后 返回一个tbl
function JiYinGaiZao.JiYin_ChaoJi(actor)
    local NewTbl   = clone(ChaoJiData)
    local data     = JiYinGaiZao.getVariableState(actor)
    local CheckTbl = { data.site4, data.site5, data.site6, data.site7 }
    for _, j in ipairs(CheckTbl) do
        for k, v in ipairs(NewTbl) do
            if j == v then
                table.remove(NewTbl, k)
            end
        end
    end
    return NewTbl
end

function JiYinGaiZao.setUpdataAttr(actor)
    if not checkitemw(actor, "潜龙阴阳石", 1) then return end
    local itemobj = linkbodyitem(actor, 43)
    clearitemcustomabil(actor, itemobj, abilGroup1)
    clearitemcustomabil(actor, itemobj, abilGroup2)
    local data = JiYinGaiZao.getVariableState(actor)
    local cfg1 = config[data.site1]
    local cfg2 = config[data.site2]
    local cfg3 = config[data.site3]
    local cfg4 = (data.site4 ~= "暂无" and config[data.site4]) or data.site4
    local cfg5 = (data.site5 ~= "暂无" and config[data.site5]) or data.site5
    local cfg6 = (data.site6 ~= "暂无" and config[data.site6]) or data.site6
    local cfg7 = (data.site7 ~= "暂无" and config[data.site7]) or data.site7
    local level = data.level
    local tbl = {}
    if cfg4 ~= "暂无" then
        local _attrTbl = {}
        if cfg4 ~= "暂无" then
            local _Tbl = { 0, cfg4.AddNum, cfg4.AttrNum, 0, cfg4.LooksNum, 1, 1 }
            table.insert(_attrTbl, _Tbl)
        end

        if cfg5 ~= "暂无" then
            local _Tbl = { 0, cfg5.AddNum, cfg5.AttrNum, 0, cfg5.LooksNum, 2, 2 }
            table.insert(_attrTbl, _Tbl)
        end

        if cfg6 ~= "暂无" then
            local _Tbl = { 0, cfg6.AddNum, cfg6.AttrNum, 0, cfg6.LooksNum, 3, 3 }
            table.insert(_attrTbl, _Tbl)
        end

        if cfg7 ~= "暂无" then
            local _Tbl = { 0, cfg7.AddNum, cfg7.AttrNum, 0, cfg7.LooksNum, 4, 4 }
            table.insert(_attrTbl, _Tbl)
        end
        tbl = {
            ["abil"] = {
                {
                    ["i"] = 1,
                    ["t"] = "[普通基因]",
                    ["c"] = 250,
                    ["v"] = {
                        { 0, cfg1.DecNum, -cfg1.AttrNum * level, 0, cfg1.LooksNum, 1, 1 },
                        { 0, cfg1.AddNum, cfg1.AttrNum * level,  0, cfg1.LooksNum, 1, 2 },
                        { 0, cfg2.DecNum, -cfg2.AttrNum * level, 0, cfg2.LooksNum, 2, 3 },
                        { 0, cfg2.AddNum, cfg2.AttrNum * level,  0, cfg2.LooksNum, 2, 4 },
                        { 0, cfg3.DecNum, -cfg3.AttrNum * level, 0, cfg3.LooksNum, 3, 5 },
                        { 0, cfg3.AddNum, cfg3.AttrNum * level,  0, cfg3.LooksNum, 3, 6 },
                    },
                },
                {
                    ["i"] = 2,
                    ["t"] = "[超级基因]",
                    ["c"] = 146,
                    ["v"] = _attrTbl
                },
            },
            ["name"] = "潜龙阴阳石[基因改造" .. level .. "级]",
        }
    else
        tbl = {
            ["abil"] = {
                {
                    ["i"] = 1,
                    ["t"] = "[普通基因]",
                    ["c"] = 250,
                    ["v"] = {
                        { 0, cfg1.DecNum, -cfg1.AttrNum * level, 0, cfg1.LooksNum, 1, 1 },
                        { 0, cfg1.AddNum, cfg1.AttrNum * level,  0, cfg1.LooksNum, 1, 2 },
                        { 0, cfg2.DecNum, -cfg2.AttrNum * level, 0, cfg2.LooksNum, 2, 3 },
                        { 0, cfg2.AddNum, cfg2.AttrNum * level,  0, cfg2.LooksNum, 2, 4 },
                        { 0, cfg3.DecNum, -cfg3.AttrNum * level, 0, cfg3.LooksNum, 3, 5 },
                        { 0, cfg3.AddNum, cfg3.AttrNum * level,  0, cfg3.LooksNum, 3, 6 }
                    },
                },
            },
            ["name"] = "潜龙阴阳石[锻造 + " .. level .. "]",
        }
    end
    local getTbl = json2tbl(getitemcustomabil(actor, itemobj))
    local rybl1 = getTbl.abil[1] or {} --雷鸣之力
    local rybl4 = getTbl.abil[4] or {} --日月不离
    table.insert(tbl.abil, rybl1) --雷鸣之力
    table.insert(tbl.abil, rybl4) --日月不离
    setitemcustomabil(actor, itemobj, tbl2json(tbl))
    local attrStr = JinJiZhiMen.GetAttrStr(actor)
    if attrStr ~= "" then
        setaddnewabil(actor, 43, "=", "3#171#0|3#172#0|3#1#0|3#4#0|3#75#0|3#173#0|3#170#0|3#3#0")
        setaddnewabil(actor, 43, "=", attrStr)
    end
    refreshitem(actor, itemobj)
    JiYinGaiZao.SyncResponse(actor)
end

function JiYinGaiZao.Request(actor, var)
    if not checktitle(actor, "仙凡有别") then
        Player.sendmsgEx(actor, "提示#251|:#255|请先获得|仙凡有别#249|称号后,再来|改造基因#249|...")
        return
    end

    if not checkitemw(actor, "潜龙阴阳石", 1) then return end
    local data = JiYinGaiZao.getVariableState(actor)

    if var == 1 then
        local name, num = Player.checkItemNumByTable(actor, { cost[1] })
        if name then
            Player.sendmsgEx(actor, string.format("你的|%s#249|不足|%d#249", name, num))
            return
        end
        Player.takeItemByTable(actor, { cost[1] }, "基因重组")

        if data.level == 0 then
            Player.sendmsgEx(actor, "提示#251|:#255|你的法宝基因|未经过改造#249|无法重组...")
            return
        end
        setplaydef(actor, VarCfg["T_基因改造数据"], "")
        local Newdata = JiYinGaiZao.getVariableState(actor)
        Newdata.level = 1
        Newdata.site1, Newdata.site2, Newdata.site3 = JiYinGaiZao.JiYin_PuTong()
        Player.setJsonVarByTable(actor, VarCfg["T_基因改造数据"], Newdata)
        JiYinGaiZao.setUpdataAttr(actor)
    end
    if var == 2 then
        local name, num = Player.checkItemNumByTable(actor, { cost[2] })
        if name then
            Player.sendmsgEx(actor, string.format("你的|%s#249|不足|%d#249", name, num))
            return
        end
        Player.takeItemByTable(actor, { cost[2] }, "基因升级")
        local num = getplaydef(actor, VarCfg["B_基因升级次数"])
        setplaydef(actor, VarCfg["B_基因升级次数"], num + 1)
        if data.level == 20 then
            Player.sendmsgEx(actor, "提示#251|:#255|你的基因等级已经|达到20级#249|无法继续升级了...")
            return
        end

        if data.level == 0 then
            data.level = 1
            data.site1, data.site2, data.site3 = JiYinGaiZao.JiYin_PuTong()
            Player.setJsonVarByTable(actor, VarCfg["T_基因改造数据"], data)
            JiYinGaiZao.setUpdataAttr(actor)
        else
            data.level = data.level + 1
            if data.level % 5 == 0 then
                local site = data.level / 5 + 3
                if data["site" .. site] == "暂无" then
                    local Tbl = JiYinGaiZao.JiYin_ChaoJi(actor)
                    local AttrName = Tbl[math.random(1, #Tbl)]
                    data["site" .. site] = AttrName
                end
            end
            Player.setJsonVarByTable(actor, VarCfg["T_基因改造数据"], data)
            JiYinGaiZao.setUpdataAttr(actor)
        end
    end
end

--注册网络消息
function JiYinGaiZao.SyncResponse(actor, logindatas)
    local data = JiYinGaiZao.getVariableState(actor)
    local _login_data = { ssrNetMsgCfg.JiYinGaiZao_SyncResponse, 0, 0, 0, data }
    if type(logindatas) == "table" then
        table.insert(logindatas, _login_data)
    else
        Message.sendmsg(actor, ssrNetMsgCfg.JiYinGaiZao_SyncResponse, 0, 0, 0, data)
    end
end

Message.RegisterNetMsg(ssrNetMsgCfg.JiYinGaiZao, JiYinGaiZao)

--登录触发
local function _onLoginEnd(actor, logindatas)
    JiYinGaiZao.SyncResponse(actor, logindatas)
end
GameEvent.add(EventCfg.onLoginEnd, _onLoginEnd, JiYinGaiZao)

return JiYinGaiZao

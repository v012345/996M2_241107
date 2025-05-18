Player = {}
local HuiFuZhuangBei = include("QuestDiary/cfgcsv/cfg_HuiFuZhuangBei.lua") --小神魔配置

--获取创建角色天数
function Player.getCreateActorDay(actor)
    local openday = grobalinfo(ConstCfg.global.openday)
    local create_actor_openday = getplaydef(actor, VarCfg.U_create_actor_openday)
    local create_actor_day = openday - create_actor_openday + 1
    return create_actor_day
end

--检查货币数量
---* actor:人物对象
---* moneyIdx：货币idx
---* num：货币数量
---@param actor string
---@param moneyIdx integer
---@param num integer
function Player.checkMoneyNum(actor, moneyIdx, num, isBind)
    if type(isBind) ~= "boolean" then isBind = true end
    local moneyNum
    if isBind then
        local moneyName = getstditeminfo(moneyIdx, ConstCfg.stditeminfo.name)
        moneyNum = getbindmoney(actor, moneyName)
        if moneyNum == nil then
            moneyNum = querymoney(actor, moneyIdx)
        end
    else
        moneyNum = querymoney(actor, moneyIdx)
    end
    return moneyNum >= num
end

--扣除货币数量
---* actor：个人对象
---* moneyName：货币名称
---* num：数量
---* desc：描述
---* isBind：是否绑定, 默认扣除绑定货币
---@param actor any
---@param moneyName string
---@param num number
---@param desc string
---@param isBind boolean
function Player.takeMoney(actor, moneyName, num, desc, isBind)
    --非布尔值默认为真
    if type(isBind) ~= "boolean" then isBind = true end
    local result
    local moneyIdx = getstditeminfo(moneyName, ConstCfg.stditeminfo.idx)
    if isBind then
        result = consumebindmoney(actor, moneyName, num, desc) or changemoney(actor, moneyIdx, "-", num, desc, true)
    else
        result = changemoney(actor, moneyIdx, "-", num, desc, true)
    end
    return result
end

--检查 物品 货币 装备是否满足数量(数量不足返回不足物品的名字)
---* actor：个人对象
---* t：货币物品数组
---* multiple：倍数
---* isBind：是否检测绑定货币，默认包含绑定货币(只针对货币)
function Player.checkItemNumByTable(actor, t, multiple, isBind)
    for _, item in ipairs(t) do
        local name, num = item[1], item[2]
        if multiple then num = num * multiple end
        local idx = getstditeminfo(name, ConstCfg.stditeminfo.idx)
        if Item.isCurrency(idx) then --货币
            if type(isBind) ~= "boolean" then isBind = true end
            if not Player.checkMoneyNum(actor, idx, num, isBind) then
                -- Message.sendmsg(actor, ssrNetMsgCfg.HuoDeTuJing_Response,nil,nil,nil,{name})
                return name, num
            end
        else --物品 装备
            if not Bag.checkItemNum(actor, idx, num) then
                -- Message.sendmsg(actor, ssrNetMsgCfg.HuoDeTuJing_Response,nil,nil,nil,{name})
                return name, num
            end
        end
    end
end

---拿走物品
---* actor:人物对象
---* t:物品信息
---* desc:描述
---* multiple:倍数
---* isBind:是否扣除绑定，只针对货币，默认扣除绑定
function Player.takeItemByTable(actor, t, desc, multiple, isBind)
    --非布尔值默认为真
    if type(isBind) ~= "boolean" then isBind = true end
    for _, item in ipairs(t) do
        local name, num = item[1], item[2]
        if multiple then num = num * multiple end
        local idx = getstditeminfo(name, ConstCfg.stditeminfo.idx)
        local result
        if Item.isCurrency(idx) then --货币
            result = Player.takeMoney(actor, name, num, desc, isBind)
            GameEvent.push(EventCfg.onCostMoney, actor, name, num)
        else --物品 装备
            local name = getstditeminfo(idx, ConstCfg.stditeminfo.name)
            result = takeitemex(actor, name, num, 0, desc)
        end
    end
end

--如果是装备要检查身上(只供物品合成使用)
function Player.libcheckItemNumByTableEx(actor, t, multiple)
    for _, item in ipairs(t) do
        local idx, num = item[1], item[2]
        if multiple then num = num * multiple end
        local name = getstditeminfo(idx, ConstCfg.stditeminfo.name)
        if Item.isCurrency(idx) then --货币
            if not Player.checkMoneyNum(actor, idx, num) then
                return false, name, num
            end
        elseif Item.isItem(idx) then --物品
            if not Bag.checkItemNum(actor, idx, num) then
                return false, name, num
            end
        else --装备
            local count = Bag.getItemNum(actor, idx)
            if count < num then
                local wheres = Item.getWheresByIdx(idx)
                if wheres then
                    for _, where in ipairs(wheres) do
                        local equipobj = linkbodyitem(actor, where)
                        if equipobj ~= "0" then
                            local equipidx = getiteminfo(actor, equipobj, ConstCfg.iteminfo.idx)
                            if equipidx == idx then
                                count = count + 1
                            end
                        end
                    end
                end
            end
            if count < num then
                return false, name, num
            end
        end
    end
    return true
end

--优先拿走非绑定物品
function Player.takeItemByTableEx(actor, t, desc, multiple, isbind)
    --拆分物品和货币
    local t_gold = {}
    local t_item = {}
    local t_overlap_item = {}
    local iteminfos = {}
    local itemoverlapinfos = {}
    for _, item in ipairs(t) do
        local idx, num = item[1], item[2]
        if multiple then num = num * multiple end
        if Item.isCurrency(idx) then --货币
            t_gold[idx] = num
        else                         --物品 装备
            local overlap = getstditeminfo(idx, ConstCfg.stditeminfo.overlap)
            if overlap == 0 then     --不叠加
                t_item[idx] = num
                iteminfos[idx] = { bind = {}, notbind = {} }
            else --叠加物品
                t_overlap_item[idx] = num
                itemoverlapinfos[idx] = { bind = {}, notbind = {} }
            end
        end
    end
    --绑定与非绑定物品唯一id分开保存
    local item_num = getbaseinfo(actor, ConstCfg.gbase.bag_num)
    for i = 0, item_num - 1 do
        local itemobj = getiteminfobyindex(actor, i)
        local itemidx = getiteminfo(actor, itemobj, ConstCfg.iteminfo.idx)
        for idx, _ in pairs(t_item) do
            if idx == itemidx then
                local bind = getiteminfo(actor, itemobj, ConstCfg.iteminfo.bind)
                local t_bind = bind == 0 and iteminfos[idx].notbind or iteminfos[idx].bind
                local itemmakeindex = getiteminfo(actor, itemobj, ConstCfg.iteminfo.id)
                table.insert(t_bind, itemmakeindex)
            end
        end

        for idx, _ in pairs(t_overlap_item) do
            if idx == itemidx then
                local bind = getiteminfo(actor, itemobj, ConstCfg.iteminfo.bind)
                local t_bind = bind == 0 and itemoverlapinfos[idx].notbind or itemoverlapinfos[idx].bind
                local itemmakeindex = getiteminfo(actor, itemobj, ConstCfg.iteminfo.id)
                local itemnum = getiteminfo(actor, itemobj, ConstCfg.iteminfo.overlap)
                t_bind[itemmakeindex] = itemnum
            end
        end
    end

    --身上穿戴的物品也算在合成物品内
    for idx, _t in pairs(iteminfos) do
        if Item.isEquip(idx) then
            local wheres = Item.getWheresByIdx(idx)
            for _, where in ipairs(wheres) do
                local equipobj = linkbodyitem(actor, where)
                if equipobj ~= "0" then
                    local equipidx = getiteminfo(actor, equipobj, ConstCfg.iteminfo.idx)
                    if equipidx == idx then
                        local bind = getiteminfo(actor, equipobj, ConstCfg.iteminfo.bind)
                        local t_bind = bind == 0 and iteminfos[idx].notbind or iteminfos[idx].bind
                        local equipmakeindex = getiteminfo(actor, equipobj, ConstCfg.iteminfo.id)
                        table.insert(t_bind, equipmakeindex)
                    end
                end
            end
        end
    end

    --扣物品
    local t_take = {}
    for idx, need_num in pairs(t_item) do
        local t_bind, t_notbind = iteminfos[idx].bind, iteminfos[idx].notbind
        local t_first = isbind and { t_notbind } or { t_bind, t_notbind }
        for _, v in ipairs(t_first) do
            for _, makeindex in ipairs(v) do
                table.insert(t_take, makeindex)
                need_num = need_num - 1
                if need_num == 0 then break end
            end
            if need_num == 0 then break end
        end
    end
    if #t_take > 0 then
        local takestr = table.concat(t_take, ",")
        delitembymakeindex(actor, takestr)
    end

    for idx, need_num in pairs(t_overlap_item) do
        local temp_num = need_num
        local t_bind, t_notbind = itemoverlapinfos[idx].bind, itemoverlapinfos[idx].notbind
        local t_first = isbind and { t_notbind } or { t_bind, t_notbind }
        for _, v in ipairs(t_first) do
            if temp_num <= 0 then break end
            for makeindex, num in pairs(v) do
                temp_num = temp_num - num
                if temp_num > 0 then
                    delitembymakeindex(actor, tostring(makeindex), num)
                    need_num = need_num - num
                else
                    delitembymakeindex(actor, tostring(makeindex), need_num)
                    break
                end
            end
        end
    end

    --扣货币
    for idx, num in pairs(t_gold) do
        changemoney(actor, idx, "-", num, desc, true)
    end
    return isbind
    --如果有一个物品是固定绑定 其他物品优先扣除绑定物品
    --如果没有任何物品是固定绑定那么说明非绑定物品足够
    --判断物品是否叠加物品 如果是叠加物品要单独拿走
end

--拿走身上物品,通过位置拿走
function Player.takeItemToBody(actor, where)
    local equipobj = linkbodyitem(actor, where)
    local weiYiId
    if equipobj ~= "0" then
        weiYiId = getiteminfo(actor, equipobj, ConstCfg.iteminfo.id)
        return delitembymakeindex(actor, tostring(weiYiId), 1)
    else
        return false
    end
end

--根据名字给物品或者货币，绑定货币请给绑定货币名称
---* actor:人物对象
---* t:物品信息
---* desc:描述
---* multiple:倍数
---* isbind:是否绑定
--根据名字给物品或者货币
function Player.giveItemByTable(actor, t, desc, multiple, isbind)
    multiple = multiple or 1 --倍数
    for _, item in ipairs(t) do
        local name, num, bind = item[1], item[2], item[3]
        local idx = getstditeminfo(name, ConstCfg.stditeminfo.idx)
        if Item.isCurrency(idx) then --货币
            changemoney(actor, idx, "+", num * multiple, desc, true)
        else                         --物品 装备
            if bind or isbind then
                giveitem(actor, name, num * multiple, ConstCfg.binding)
            else
                giveitem(actor, name, num * multiple)
            end
        end
    end
end

--发送到邮件给物品或者货币，绑定货币请给绑定货币名称
---* userid:玩家UserId，如果是玩家名，需要在前面加#，如:#张三
---* mailId:邮件ID
---* title:邮件标题
---* content:邮件内容
---* t:物品信息
---* multiple:倍数
---* isbind:是否绑定
--根据名字给物品或者货币
function Player.giveMailByTable(userid, mailId, title, content, t, multiple, isbind)
    multiple = multiple or 1 --倍数
    mailId = mailId or 1
    title = title or ""
    content = content or ""
    local mailRewards = {}
    for _, item in ipairs(t) do
        local items = {}
        if item[3] or isbind then
            items = { item[1], item[2] * multiple, ConstCfg.binding }
        else
            items = { item[1], item[2] * multiple }
        end
        table.insert(mailRewards, table.concat(items, "#"))
    end
    local mailRewardStr = table.concat(mailRewards, "&")
    sendmail(userid, mailId, title, content, mailRewardStr)
end

--给物品盒子
function Player.giveItemBoxByIdx(actor, idx)
    local name = getstditeminfo(idx, ConstCfg.stditeminfo.name)
    giveitem(actor, name, 1)
end

--获取当前穿戴装备的唯一id数组通过idx
function Player.getEquipIdsByIdx(actor, idx)
    if not Item.isEquip(idx) then return {} end

    local equipids = {}
    local wheres = Item.getWheresByIdx(idx)
    for _, where in ipairs(wheres) do
        local equipobj = linkbodyitem(actor, where)
        if equipobj ~= "0" then
            local equipidx = getiteminfo(actor, equipobj, ConstCfg.iteminfo.idx)
            if equipidx == idx then
                local equipmakeindex = getiteminfo(actor, equipobj, ConstCfg.iteminfo.id)
                table.insert(equipids, equipmakeindex)
            end
        end
    end
    return equipids
end

--获取装备位idx
function Player.getEquipIdxByPos(actor, pos)
    local itemobj = linkbodyitem(actor, pos)
    if itemobj == "0" then return end
    local idx = getiteminfo(actor, itemobj, ConstCfg.iteminfo.idx)
    return idx
end

--通过位置获取装备名字
function Player.getEquipNameByPos(actor, pos)
    local itemobj = linkbodyitem(actor, pos)
    if itemobj == "0" then return end
    local name = getiteminfo(actor, itemobj, ConstCfg.iteminfo.name)
    return name
end

--通过位置获取字段
function Player.getEquipFieldByPos(actor, pos, type)
    local name = Player.getEquipNameByPos(actor, pos)
    if name then
        local field
        if type == 1 then
            field = getstditeminfo(name, ConstCfg.stditeminfo.custom29)
        elseif type == 2 then
            field = getstditeminfo(name, ConstCfg.stditeminfo.custom30)
        else
            field = getstditeminfo(name, ConstCfg.stditeminfo.custom29)
        end
        return field
    end
end

--更新属性
local _addrs = {}
function Player.updateAddr(actor, loginattrs)
    --引擎属性
    for attridx = 1, 250 do
        _addrs[attridx] = 0
    end

    for _, addr in ipairs(loginattrs) do
        for _, v in ipairs(addr) do
            local attridx = v[1]
            _addrs[attridx] = _addrs[attridx] + v[2]
        end
    end

    --附加引擎属性
    for attridx, value in ipairs(_addrs) do
        if value > 0 then
            changehumnewvalue(actor, attridx, _addrs[attridx], ConstCfg.attrtime)
        end
    end
end

--更新部分属性
function Player.updateSomeAddr(actor, cur_attr, next_attr)
    local newattr = {}
    if cur_attr then
        for _, attr in ipairs(cur_attr) do
            local attridx, attrvalue = attr[1], attr[2]
            newattr[attridx] = newattr[attridx] or gethumnewvalue(actor, attridx)
            newattr[attridx] = newattr[attridx] - attrvalue
            if newattr[attridx] < 0 then newattr[attridx] = 0 end
        end
    end

    -- LOGDump(newattr)

    if next_attr then
        for _, attr in ipairs(next_attr) do
            local attridx, attrvalue = attr[1], attr[2]
            newattr[attridx] = newattr[attridx] or gethumnewvalue(actor, attridx)
            newattr[attridx] = newattr[attridx] + attrvalue
        end
    end

    -- LOGDump(newattr)

    --cfg_att_score.xls 属性
    for attridx, attrvalue in pairs(newattr) do
        changehumnewvalue(actor, attridx, attrvalue, ConstCfg.attrtime)
    end
end

--使用物品给予货币
---* actor:个人对象
---* MoneyId:货币id
---* ItemName:物品名称
---* MoneyNum:货币数量
function Player.itemGiveMoney(actor, MoneyId, ItemOBJ, MoneyNum)
    local ItemName = getiteminfo(actor, ItemOBJ, 7)
    local name, num = Player.checkItemNumByTable(actor, { { ItemName, 1 } }, 1)
    if name then
        sendmsg(actor, ConstCfg.notice.own, '{"Msg":"<font color=\'#FFFFFF\'>缺少' .. name ..
            '*' .. num .. '</font>","Type":9}')
        return
    end
    changemoney(actor, MoneyId, "+", MoneyNum, "使用" .. ItemName, true)
end

--发送消息个人
function Player.sendmsg(actor, msg)
    if type(msg) == "string" then
        sendmsg(actor, ConstCfg.notice.own, '{"Msg":"' .. msg .. '","Type":9}')
    elseif type(msg) == "table" then
        local MsgStr = ""
        for _, v in ipairs(msg) do
            MsgStr = MsgStr .. "<font color='" .. v[1] .. "'>" .. v[2] .. "</font>"
        end
        sendmsg(actor, ConstCfg.notice.own, '{"Msg":"' .. MsgStr .. '","Type":9}')
    end
end

--发送个人消息9
--* actor：个人对象
--* str：消息内容 格式 文本#颜色|文本#颜色 (颜色值0-255)
--* defaultColor：默认颜色 默认为白色
function Player.sendmsgEx(actor, str, defaultColor)
    if str == nil or str == "" then
        return
    end
    defaultColor = defaultColor or 250
    local content = ""
    local part = string.split(str, "|")
    for _, v in ipairs(part) do
        local text = string.split(v, "#")
        local colorNum = tonumber(text[2])
        colorNum = colorNum or defaultColor
        local hexColor = ColorCfg[colorNum] ~= nil and ColorCfg[colorNum].hexColor or ColorCfg[defaultColor].hexColor
        content = content .. "<font color='" .. hexColor .. "'>" .. text[1] .. "</font>"
    end
    if content ~= "" then
        sendmsg(actor, ConstCfg.notice.own, '{"Msg":"' .. content .. '","Type":9}')
    else
        return
    end
end

function Player.buffTipsMsg(actor, msg)
    if getbaseinfo(actor, -1) then
        sendcentermsg(actor, 254, 0, msg, 0, 2)
    end
end

--发送聊天窗口消息个人
function Player.sendmsg0(actor, msg)
    if type(msg) == "string" then
        sendmsg(actor, ConstCfg.notice.own, '{"FColor":250,"BColor":249,"Msg":"' .. msg .. '","Type":0}')
    elseif type(msg) == "table" then
        local MsgStr = ""
        for _, v in ipairs(msg) do
            MsgStr = MsgStr .. "<font color='" .. v[1] .. "'>" .. v[2] .. "</font>"
        end
        sendmsg(actor, ConstCfg.notice.own, '{"FColor":250,"BColor":249,"Msg":"' .. MsgStr .. '","Type":0}')
    end
end

--发送公告消息
---* actor:个人对象
---* FColor：前色
---* BColor：后色
---* msg：消息内容，颜色为内置颜色
function Player.sendmsgnew(actor, FColor, BColor, msg)
    if type(msg) == "string" then
        sendmsgnew(actor, FColor, BColor, msg, 1, 5)
    elseif type(msg) == "table" then
        local MsgStr = ""
        for k, v in ipairs(msg) do
            if v[1] == "" then
                MsgStr = MsgStr .. v[2]
            else
                MsgStr = MsgStr .. "<" .. v[2] .. "/FCOLOR=" .. v[1] .. ">"
            end
        end
        sendmsgnew(actor, FColor, BColor, MsgStr, 1, 5)
    end
end

--发送公告消息
---* actor:个人对象
---* FColor：前色
---* BColor：后色
---* msg：消息内容，颜色为内置颜色
function Player.sendmsgnewEx(actor, FColor, BColor, msg, defaultColor)
    if msg == nil or msg == "" then
        return
    end
    defaultColor = defaultColor or 250
    local content = ""
    local part = string.split(msg, "|")
    for _, v in ipairs(part) do
        local text = string.split(v, "#")
        local colorNum = tonumber(text[2])
        colorNum = colorNum or defaultColor
        content = content .. "<" .. text[1] .. "/FCOLOR=" .. colorNum .. ">"
    end
    if content ~= "" then
        sendmsgnew(actor, FColor, BColor, content, 1, 5)
    else
        return
    end
end

--发送屏幕中间公告消息
---* actor:个人对象
---* FColor：前色
---* BColor：后色
---* msg：消息内容，颜色为内置颜色
function Player.sendcentermsg(actor, FColor, BColor, msg)
    if type(msg) == "string" then
        sendcentermsg(actor, FColor, BColor, msg, 1, 5)
    elseif type(msg) == "table" then
        local MsgStr = ""
        for k, v in ipairs(msg) do
            if v[1] == "" then
                MsgStr = MsgStr .. v[2]
            else
                MsgStr = MsgStr .. "<" .. v[2] .. "/FCOLOR=" .. v[1] .. ">"
            end
        end
        sendcentermsg(actor, FColor, BColor, MsgStr, 1, 5)
    end
end

--发送屏幕滚动信息
function Player.sendMoveMsgEx(actor, Y, scroll, msg, defaultColor)
    if msg == nil or msg == "" then
        return
    end
    defaultColor = defaultColor or 250
    local content = ""
    local part = string.split(msg, "|")
    for _, v in ipairs(part) do
        local text = string.split(v, "#")
        local colorNum = tonumber(text[2])
        colorNum = colorNum or defaultColor
        content = content .. "<" .. text[1] .. "/FCOLOR=" .. colorNum .. ">"
    end
    if content ~= "" then
        sendmovemsg(actor, 0, 0, 0, Y, scroll, content)
    else
        return
    end
end

--获取角色血量剩余百分比
function Player.getHpPercentage(actor)
    local currHp = getbaseinfo(actor, ConstCfg.gbase.curhp)
    local maxHp = getbaseinfo(actor, ConstCfg.gbase.maxhp)
    local calculate = calculatePercentage(currHp, maxHp)
    return math.floor(calculate)
end

--获取角色蓝量剩余百分比
function Player.getMpPercentage(actor)
    local currMp = getbaseinfo(actor, ConstCfg.gbase.curmp)
    local maxMp = getbaseinfo(actor, ConstCfg.gbase.maxmp)
    local calculate = calculatePercentage(currMp, maxMp)
    return math.floor(calculate)
end

--获取角色血量百分比的数值
---* object：对象
---* value：获取的百分比
function Player.getHpValue(object, value)
    local maxHp = getbaseinfo(object, ConstCfg.gbase.maxhp)
    if value == 0 then
        return 0 -- 避免除以0
    end
    return maxHp * (value / 100)
end

function Player.getMpValue(object, value)
    local maxMp = getbaseinfo(object, ConstCfg.gbase.maxmp)
    if value == 0 then
        return 0 -- 避免除以0
    end
    return maxMp * (value / 100)
end

--检测玩家是否在线
---* name:玩家名字（字符串）
function Player.Checkonline(name)
    local _object = getplayerbyname(name)
    if not _object then
        return false
    end
    local _objectstate = getbaseinfo(_object, ConstCfg.gbase.offline)
    if _objectstate then
        return false
    else
        return true
    end
end

--检测玩家是否有某个技能
---* actor:对象
---* name:技能名字（字符串）
function Player.Checkskill(actor, name)
    local skillidx = getskillindex(name)
    local skilllevel = getskilllevel(actor, skillidx)
    if skilllevel >= 1 then
        return true
    else
        return false
    end
end

--设置装备进度条（刀魂）
---* play：玩家对象
---* item：物品对象
---* num：进度条编号(0,1,2)
---* project：（字符串）刀魂属性类别(open=0关闭\1打开 show=0-不显示数值\1-百分比\2-数字 name=进度条名字（字符串）color=进度条颜色0-255 imgcount=图片张数填1即可 cur=当前值 max=最大值 level=级别(0~65535))
---* sort：字符串 （查询 设置）
---* var：值 （sort=查询，var可不填）
function Player.progressbarEX(play, item, num, project, sort, var)
    local itemtbl = json2tbl(getcustomitemprogressbar(play, item, num))
    if type(itemtbl) ~= "table" then
        return false
    end
    -- release_print(itemtbl)
    if itemtbl.open == 0 then
        -- release_print("该装备还未初始化")
        return false
    end

    if sort == "查询" then --获取信息
        return itemtbl[project]
    end

    if sort == "设置" then --获取信息
        local tbl = {
            [project] = var,
        }
        setcustomitemprogressbar(play, item, num, tbl2json(tbl))
        refreshitem(play, item)
    end
end

--在屏幕中间给自己播放特效
function Player.screffects(actor, effectId, offsetX, offsetY)
    offsetX = offsetX or 0
    offsetY = offsetY or 0
    local x = getconst(actor, "<$SCREENWIDTH>") / 2 + offsetX
    local y = getconst(actor, "<$SCREENHEIGHT>") / 2 + offsetY
    screffects(actor, 1, effectId, x, y, 1, 1, 0)
end

--判断角色是否在攻城区域
function Player.checkInWarArea(actor, range)
    if not castleinfo(5) then
        return false
    end
    if getmyguild(actor) == "0" then
        return false
    end

    if getbaseinfo(actor, ConstCfg.gbase.mapid) == "new0150" then
        return true
    end
    local myX = getbaseinfo(actor, ConstCfg.gbase.x)
    local myY = getbaseinfo(actor, ConstCfg.gbase.y)
    return FisInRange(myX, myY, 630, 283, range)
end

--使用变量检测CD
---* actor:人物对象
---* varName:变量名
---* cd:cd时间，单位秒
---* class:变量类型 true = 自定义变量 false = 默认变量
---@param actor any|nil
---@param varName string
---@param cd number
---@param class boolean?
---@return boolean
function Player.checkCd(actor, varName, cd, class)
    local nowTime = os.time()
    local recordTime = 0
    if class then
        recordTime = tonumber(getplayvar(actor, "HUMAN", varName)) or 0
    else
        recordTime = tonumber(getplaydef(actor, varName)) or 0
    end
    local timeDifference = nowTime - recordTime
    if timeDifference > cd then
        if class then
            setplayvar(actor, "HUMAN", varName, nowTime, 1)
        else
            setplaydef(actor, varName, nowTime)
        end
        return true
    else
        return false
    end
end

--设置json变量内容，返回table
---* actor:人物对象(填写nil获取全局变量)
---* varName:变量名
---* varValue:变量内容
---@param actor any|nil
---@param varName string
---@param varValue table
---@return table|nil
function Player.setJsonVarByTable(actor, varName, varValue)
    if not varValue then
        return
    end
    local varStr = tbl2json(varValue)
    if actor then
        setplaydef(actor, varName, varStr)
    else
        setsysvar(varName, varStr)
    end
end

--获取json变量内容，返回table
---* actor:人物对象(填写nil获取全局变量)
---* varName:变量名
---@param actor any|nil
---@param varName string
---@return table
function Player.getJsonTableByVar(actor, varName)
    local varStr = ""
    if actor then
        varStr = getplaydef(actor, varName)
    else
        varStr = getsysvar(varName)
    end
    local ret = json2tbl(varStr)
    if ret == "" or type(ret) ~= "table" then ret = {} end
    return ret
end

--设置自定义变量json变量内容
---* actor:人物对象(填写nil获取全局变量)
---* varName:变量名
---* varValue:变量内容
---@param actor any|nil
---@param varName string
---@param varValue table
---@return table|nil
function Player.setJsonPlayVarByTable(actor, varName, varValue)
    if not varValue then
        return
    end
    local varStr = tbl2json(varValue)
    setplayvar(actor, "HUMAN", varName, varStr, 1)
end

--获取自定义变量json变量内容，返回table
---* actor:人物对象(填写nil获取全局变量)
---* varName:变量名
---@param actor any|nil
---@param varName string
---@return table
function Player.getJsonTableByPlayVar(actor, varName)
    local varStr = getplayvar(actor, "HUMAN", varName)
    local ret = json2tbl(varStr)
    if ret == "" or type(ret) ~= "table" then ret = {} end
    return ret
end

--设置全局自定义临时int变量
function Player.SetGlobalTempInt(varName, value)
    setplaydef(0, "N$" .. varName, value)
end

--获取全局自定义临时int变量
function Player.GetGlobalTempInt(varName)
    return getplaydef(0, "N$" .. varName)
end

--设置全局自定义临时str变量table
function Player.SetGlobalTempTable2(varName, value)
    setplaydef(0, "S$" .. varName, tbl2json(value))
end

--获取全局自定义临时str变量table
function Player.GetGlobalTempTable2(varName)
    local ret = getplaydef(0, "S$" .. varName)
    if ret ~= "" then
        return json2tbl(ret)
    end
    return {}
end

-----------自定义属性相关---------

--增加修改自定义属性
---* actor：个人对象
---* itemobj：物品对象
---* group：属性分组
---* attrIndex：属性位置和索引
---* attrType：属性类型 1为cfg_att_score里面的属性 其他为cfg_custpro_caption属性
---* attrColor：属性颜色
---* realAttrId：真实属性
---* attrId：属性ID当attrType不为1时，为显示属性
---* isAttrPercent：属性是否为百分比（0不是百分比，1百分比）
---* attrValue：属性值
---@param actor any
---@param itemobj any
---@param group number?
---@param attrIndex number
---@param attrType number?
---@param attrColor number?
---@param realAttrId number
---@param attrId number
---@param isAttrPercent number
---@param attrValue number?
function Player.addModifyCustomAttributes(actor, itemobj, group, attrIndex, attrType, attrColor, realAttrId, attrId,
                                          isAttrPercent, attrValue)
    if itemobj == nil then return end
    attrColor = attrColor or 255
    if attrType == 1 then
        changecustomitemabil(actor, itemobj, attrIndex, 0, attrColor, group)
        changecustomitemabil(actor, itemobj, attrIndex, 1, realAttrId, group)
    else
        -- release_print(realAttrId, attrId)
        changecustomitemabil(actor, itemobj, attrIndex, 0, attrColor, group)
        changecustomitemabil(actor, itemobj, attrIndex, 1, realAttrId, group)
        changecustomitemabil(actor, itemobj, attrIndex, 2, attrId, group)
    end
    changecustomitemabil(actor, itemobj, attrIndex, 3, isAttrPercent, group)
    changecustomitemabil(actor, itemobj, attrIndex, 4, attrIndex, group)
    changecustomitemvalue(actor, itemobj, attrIndex, "=", attrValue, group)
    refreshitem(actor, itemobj)
end

--获取自定义属性值
function Player.getModifyCustomAttributes(actor, equipObj, index, childIndex)
    local t = json2tbl(getitemcustomabil(actor, equipObj))
    if not t then
        return 0
    end
    if not t["abil"] then
        return 0
    end
    if not t["abil"][index] then
        return 0
    end
    if not t["abil"][index]["v"] then
        return 0
    end

    if not t["abil"][index]["v"][childIndex] then
        return 0
    end

    return t["abil"][index]["v"][childIndex][3] or 0
end

--获取全部自定义属性值
function Player.getAllModifyCustomAttributes(actor, equipObj, index)
    local t = json2tbl(getitemcustomabil(actor, equipObj))
    if not t then
        return 0
    end
    if not t["abil"] then
        return 0
    end
    if not t["abil"][index] then
        return 0
    end
    local attrList = t["abil"][index]["v"]
    if not attrList then
        return 0
    end
    local result = {}
    for _, value in ipairs(attrList) do
        result[value[7]] = value[3]
    end
    return result
end

--获取数学组属性到字符串
function Player.getAttListToTable(actor, str)
    if not str or str == "" then
        return
    end
    local attStr = getattlist(actor, str)
    if not attStr or attStr == "" then
        return
    end
    local t = string.split(attStr, "|")
    local newt = {}
    for _, value in ipairs(t or {}) do
        local tmpT = string.split(value, "#")
        if #tmpT == 3 then
            newt[tonumber(tmpT[2])] = tonumber(tmpT[3])
        end
    end
    return newt
end

--召唤自己属性的人形怪
---* actor：个人对象
---* mapId：地图ID
---* x：坐标x
---* y：坐标y
---* name：名字
---* targetName：目标名字
---* number：数量
---* color：颜色
---* percentage：百分比
function Player.cloneSelfToHumanoid(actor, mapId, x, y, name, targetName, number, color, percentage)
    --克隆装备
    local function cloneEquip(actor, targetObj)
        for _, value in ipairs(ConstCfg.equipWhere) do
            local itemobj = linkbodyitem(actor, value)
            if itemobj ~= "0" then
                local itemName = getiteminfo(actor, itemobj, ConstCfg.iteminfo.name)
                giveonitem(targetObj, value, itemName, 1)
            end
        end
    end
    --克隆技能
    local function cloneSkill(actor, targetObj)
        for _, value in ipairs(ConstCfg.skillIdList) do
            local level = getskillinfo(actor, value, 1)
            if level then
                addskill(targetObj, value, level)
            end
        end
    end
    --克隆属性
    local function cloneAttr(actor, targetObj, percentage)
        percentage = percentage or 100
        for i = 9, 28, 1 do
            local value = math.ceil(getbaseinfo(actor, i) * (percentage / 100))
            setbaseinfo(targetObj, i, value)
        end
        local myLevel = getbaseinfo(actor, ConstCfg.gbase.level)
        setbaseinfo(targetObj, ConstCfg.gbase.level, myLevel)
    end

    local monList = genmonex(mapId, x, y, targetName, 1, number, 0, color, name)
    for _, monobj in ipairs(monList or {}) do
        cloneEquip(actor, monobj)
        cloneSkill(actor, monobj)
        cloneAttr(actor, monobj, percentage)
        addhpper(monobj, "+", 100)
    end
end

---任务相关---
--添加任务
function Player.addTask(actor, taskId, progress)
    taskId = tostring(taskId)
    local tasks = Player.getJsonTableByVar(actor, VarCfg["T_记录任务"]) or {}
    tasks[taskId] = {
        progress = progress
    }
    Player.setJsonVarByTable(actor, VarCfg["T_记录任务"], tasks)
end

--更新任务
function Player.updateProgress(actor, taskId, progress)
    taskId = tostring(taskId)
    local tasks = Player.getJsonTableByVar(actor, VarCfg["T_记录任务"]) or {}
    if tasks[taskId] then
        tasks[taskId].progress = progress
    end
    Player.setJsonVarByTable(actor, VarCfg["T_记录任务"], tasks)
end

--获取任务进度
function Player.getProgress(actor, taskId)
    taskId = tostring(taskId)
    local tasks = Player.getJsonTableByVar(actor, VarCfg["T_记录任务"]) or {}
    if tasks[taskId] then
        return tasks[taskId].progress
    end
end

--删除任务
function Player.removeTask(actor, taskId)
    taskId = tostring(taskId)
    local tasks = Player.getJsonTableByVar(actor, VarCfg["T_记录任务"]) or {}
    if tasks[taskId] then
        tasks[taskId] = nil
    end
    Player.setJsonVarByTable(actor, VarCfg["T_记录任务"], tasks)
end

--开始下一个任务主线
function Player.nextTaskMain(actor, taskId, cfg)
    newdeletetask(actor, taskId)
    setplaydef(actor, VarCfg["U_主线任务进度"], cfg.nextTask)
    setplaydef(actor, VarCfg["U_主线任务状态"], cfg.nextStartschedule or 0)
    setplaydef(actor, VarCfg["U_当前任务进度1"], 0)
    setplaydef(actor, VarCfg["U_当前任务进度2"], 0)
    setplaydef(actor, VarCfg["U_当前任务进度3"], 0)
    setplaydef(actor, VarCfg["U_当前任务进度4"], 0)
    Player.removeTask(actor, taskId)
    Player.addTask(actor, cfg.nextTask, cfg.nextStartschedule)
    Player.screffects(actor, 17530)
end

--开始下一个任务其他
function Player.nextTaskOther(actor, taskId, cfg)
    newdeletetask(actor, taskId)
    Player.removeTask(actor, taskId)
    if cfg.nextTask then
        Player.addTask(actor, cfg.nextTask, cfg.nextStartschedule)
    end
end

--根据Var获取Tbl中的值 返回lastTitle
---* actor:人物对象
---* var:传 入的值
---* tbl:tbl
function Player.getNewandOldTitle(actor, var, tbl)
    local OldTitle = ""
    local OldNum = 0
    --检测是否已经有该tbl中的称号
    for k, v in ipairs(tbl) do
        if checktitle(actor, v.title) then
            OldTitle = v.title
            OldNum = k
            break
        end
    end
    --检测传入对应的称号
    local NewTitle = ""
    local NewNum = 0
    for i = 1, #tbl do
        if var >= tbl[i].var then
            NewTitle = tbl[i].title
            NewNum = i
        else
            if OldNum > NewNum then
                NewTitle = OldTitle
                NewNum = OldNum
            end
            break
        end
    end

    return NewTitle, OldTitle
end

--是否符合吸血条件
function Player.canLifesteal(actor)
    local currHpPer = Player.getHpPercentage(actor)
    if currHpPer > 3 and currHpPer < 100 then
        return true
    else
        return false
    end
end

--设置属性字符串
---* actor:人物对象
---@param actor any|nil
---@param actType any|nil
function Player.setAttList(actor, actType)
    local attType = {}
    attType["技能威力"] = function()
        local skillrs = {}
        GameEvent.push(EventCfg.onAddSkillPower, actor, skillrs)
        -- dump(skillrs)
        for key, value in pairs(skillrs) do
            setmagicpower(actor, key, value, 1)
        end
    end

    attType["属性附加"] = function()
        delattlist(actor, "属性组") --属性组
        local attrs = {}
        GameEvent.push(EventCfg.onCalcAttr, actor, attrs)
        local attrStr = ""
        local attrList = {}
        --计算切割加成start
        local qieGeAddtion = attrs[205] or 0
        local qieGe = attrs[200] or 0
        -- local qieGeAddtion = 0
        -- local qieGe =  0

        if qieGe > 0 and qieGeAddtion > 0 then
            local QG = math.floor(qieGe * (qieGeAddtion / 100))
            attrs[200] = attrs[200] + QG
        end

        --计算切割加成
        for key, value in pairs(attrs) do
            table.insert(attrList, "3#" .. key .. "#" .. value)
        end
        attrStr = table.concat(attrList, "|")
        -- release_print(attrStr)
        -- callscriptex(actor, "ADDATTLIST", "属性组", "=", attrStr, 2)
        addattlist(actor, "属性组", "=", attrStr, 1)
    end

    attType["爆率附加"] = function()
        delattlist(actor, "爆率附加") --属性组
        local attrs = { [204] = 100 } --初始值100
        GameEvent.push(EventCfg.onCalcBaoLv, actor, attrs)
        --天运丹
        if hasbuff(actor, 31040) then
            attrs[218] = (attrs[218] or 0) + 5
        end
        if attrs[218] then
            if attrs[204] then
                attrs[204] = attrs[204] + math.floor(attrs[204] * (attrs[218] / 100))
            end
        end
        if getplaydef(actor, VarCfg["J_画个圈诅咒你_诅咒爆率"]) == 1 then
            if attrs[204] >= 100 then
                attrs[204] = attrs[204] - 100
            else
                attrs[204] = 0
            end
        end

        --奇遇12   神圣契约
        if hasbuff(actor, 31015) then
            attrs[204] = attrs[204] + 20
        end

        local tian_tian_bao_lv = getplaydef(actor, VarCfg["B_天天交好运爆率"])
        if tian_tian_bao_lv > 0 then
            attrs[204] = attrs[204] + tian_tian_bao_lv
        end

        --奇遇12   恶魔契约
        if hasbuff(actor, 31016) then
            if attrs[204] >= 20 then
                attrs[204] = attrs[204] - 20
            else
                attrs[204] = 0
            end
        end
        local zhenShiBaoLv = FCalculateActualExplosionRate(attrs[204] - 100)
        local attrStr = ""
        local attrList = {}
        for key, value in pairs(attrs) do
            table.insert(attrList, "3#" .. key .. "#" .. value)
            GameEvent.push(EventCfg.OverloadBaoLv, actor, value)
        end
        attrStr = table.concat(attrList, "|")
        addattlist(actor, "爆率附加", "=", attrStr, 1)
        --设置真实爆率
        setbaseinfo(actor, 43, zhenShiBaoLv)
    end

    attType["倍攻附加"] = function()
        local beiGongs = { 0 }
        GameEvent.push(EventCfg.onCalcBeiGong, actor, beiGongs)
        local beigong        = beiGongs[1]
        beigong              = beigong + 100

        --魔王领域·无异刀锋        刀锋之心 每天00:00 自动获得刀锋祝福：随机1%—10%的神力倍功。持续24H
        local DaoFengBeiGong = getplaydef(actor, VarCfg["N$J_刀锋之心_倍攻"])
        beigong              = beigong + DaoFengBeiGong

        --转生附加倍攻 4级开始 每一级增加 5%
        local RenewLevel     = getbaseinfo(actor, ConstCfg.gbase.renew_level)
        if RenewLevel >= 4 then
            local num = (RenewLevel - 3) * 5
            beigong = beigong + num
        end

        if checkitemw(actor,"▲▲火雲真經▲▲", 1) and checkitemw(actor,"▲▲水鏡太極▲▲", 1) then
            beigong = beigong + (RenewLevel * 2)
        end

        if checkitemw(actor, "【噬魂】王之孤影", 1) then
            local itemobj = linkbodyitem(actor, 7)
            local tbl2 = json2tbl(getcustomitemprogressbar(actor, itemobj, 1)) --获取第二条进度条信息
            if tbl2["open"] == 1 and tbl2["cur"] > 0 then
                beigong = beigong + tbl2["cur"]
            end
        end

        if checkitemw(actor, "黑月·之泪", 1) then
            if checktimeInPeriod(18, 59, 6, 59) then
                beigong = beigong + 15
            end
        end

        if checkitemw(actor, "鸣封之刃·永恒", 1) then
            beigong = beigong + 5
        end
        
        if checkitemw(actor, "自己摸的鱼", 1) then
            beigong = beigong + 5
        end

        if checkitemw(actor, "屠龙者之刃", 1) then
            beigong = beigong + 10
        end
        --破神丹
        if hasbuff(actor, 31041) then
            beigong = beigong + 10
        end

        if checktitle(actor,"圣光守护者") then
            beigong = beigong + 5
        end

        -- 攻击时概率使自身神力倍攻总数提高一半  持续5秒-冷却30秒  
        if hasbuff(actor, 31085) then
            local _buffbeigong = beigong - 100
            if _buffbeigong > 1 then
                beigong = beigong + math.floor(_buffbeigong / 2)
            end
        end

        if hasbuff(actor, 30046) then
            powerrate(actor, 1, 655350)
            setplaydef(actor, VarCfg["T_倍攻"], 1)
        else
            powerrate(actor, beigong, 655350)
            setplaydef(actor, VarCfg["U_跨服记录倍攻"], beigong)
            local currBeiGong = getconst(actor, "<$POWERRATE>")
            setplaydef(actor, VarCfg["T_倍攻"], currBeiGong)
            local bgAtt = (tonumber(currBeiGong) - 1) * 100
            changehumnewvalue(actor, 227, bgAtt, 655350)
        end
    end

    attType["攻速附加"] = function()
        if checkkuafu(actor) then
            return
        end
        local attackSpeeds = { 0 }
        GameEvent.push(EventCfg.onCalcAttackSpeed, actor, attackSpeeds)
        local attackSpeed = attackSpeeds[1]
        -- local currSpeed = math.ceil(attackSpeed / 2)

        -- 刺·束缚之隐减速Buff
        if hasbuff(actor, 31086) then
            attackSpeed = attackSpeed - (attackSpeed * 0.2)
        end

        local currSpeed = math.ceil(attackSpeed / 3)
        -- changespeedex(actor, 2, math.ceil(attackSpeed / 2)
        if currSpeed > 0 then
            callscriptex(actor, "ChangeSpeedEX", 2, currSpeed)
        else
            callscriptex(actor, "ChangeSpeedEX", 2, 0)
        end
        setplaydef(actor, VarCfg["U_攻击速度"], attackSpeed + 100)
        changehumnewvalue(actor, 228, attackSpeed, 655350)

        GameEvent.push(EventCfg.OverloadGongSu, actor, attackSpeed + 100)
        if hasbuff(actor, 31072) then
            delbuff(actor, 31072)
        end

        if getflagstatus(actor, VarCfg["F_天命炙热双刀"]) == 1 then
            addbuff(actor, 31072, 0, 1, actor, { [28] = math.floor((attackSpeed + 100) / 12) })
        end
    end

    attType["回血计算"] = function()
        local addHp = 0 --计算回血
        local addMp = 0 --计算回蓝
        local tuoZhanAddHpPer = 0  --脱离战斗后回血（都是百分比）
        local myLevel = getbaseinfo(actor, ConstCfg.gbase.level) --获取我的等级
        local suitIds = Player.getJsonTableByVar(actor, VarCfg["T_记录套装ID"]) --获取套装的ID
        local guangHuanEquipName = getconst(actor, "<$RIGHTHAND>") --恢复光环
        local jiFengEquipName = getconst(actor, "<$DRUM>") --疾风刻印回血
        local myMapHp = getbaseinfo(actor, ConstCfg.gbase.custom_attr, 1)
        --光环位置 每秒回血 玩家等级 x 1% - 10% 血量
        local guangHuanCfg = HuiFuZhuangBei[guangHuanEquipName]
        if guangHuanCfg then
            if guangHuanCfg.value then
                addHp = addHp + (myLevel * guangHuanCfg.value)
            end
        end
        --固定回血位置
        local jiFengCfg = HuiFuZhuangBei[jiFengEquipName]
        if jiFengCfg then
            if jiFengCfg.hpNum then
                addHp = addHp + jiFengCfg.hpNum
            end
        end
        --【聖】·天空之翼  每秒恢复[888]点生命值
        if checkitemw(actor, "【聖】·天空之翼", 1) then
            addHp = addHp + 888
        end
        -- 守夜人套装 人物每秒恢复[1%]的最大生命值  套装编号 508
        if table.contains(suitIds, tostring(508)) then
            addHp = addHp + math.ceil(myMapHp * 0.01)
        end
        -- 炽热套装 人物每秒恢复[1%]的最大生命值  套装编号 689
        if table.contains(suitIds, tostring(689)) then
            addHp = addHp + math.ceil(myMapHp * 0.01)
        end

        if checkitemw(actor, "麒麟心", 1) then
            addHp = addHp + 2000
            addMp = addMp + 2000
        end

        if checktitle(actor, "湿婆信徒") then
            addHp = addHp + 100
            addMp = addMp + 100
        end
        --血魔之躯加血
        if getflagstatus(actor, VarCfg["F_天命_血魔之躯标识"]) == 1 then
            addHp = addHp + math.ceil(myMapHp / 1000)
        end

        
    -----------------------------------------------------------------脱战状态下回血begin-------------------------------------------------------
        --水晶之恋 脱战状态下每秒[3%]的最大生命值。
        if checkitemw(actor, "水晶之恋", 1) then
            tuoZhanAddHpPer = tuoZhanAddHpPer + 3
        end
        -- 夜幽之玉 脱战状态下每秒[3%]的最大生命值。
        if checkitemw(actor, "夜幽之玉", 1) then
            tuoZhanAddHpPer = tuoZhanAddHpPer + 3
        end
        -- 贤者套装[二] 脱战后每秒恢复[1%]最大生命值 套装编号 586
        if table.contains(suitIds, tostring(586)) then
            tuoZhanAddHpPer = tuoZhanAddHpPer + 1
        end
    ---------------------------------------------------------------永动机生效---------------------------------------------------------------
    if getflagstatus(actor, VarCfg["F_天命_永动机标识"]) == 1 then
        setplaydef(actor,"N$永动机回血",math.ceil(myMapHp * 0.05))
    else
        setplaydef(actor,"N$永动机回血",0)
    end
    -----------------------------------------------------------------脱战状态下回血end-------------------------------------------------------
        setplaydef(actor, VarCfg["N$每秒恢复血量"], addHp)
        setplaydef(actor, VarCfg["N$每秒恢复蓝量"], addMp)
        setplaydef(actor, VarCfg["N$脱战恢复血量"], tuoZhanAddHpPer)
    end
    attType[actType]()
end

function Player.actionAttList(actor)
    Player.setAttList(actor, "属性附加")
    Player.setAttList(actor, "倍攻附加")
    Player.setAttList(actor, "回血计算")
end

---@param actor userdata 玩家对象
function Player.GetName(actor)
    return getbaseinfo(actor, 1)
end

---@param actor userdata 玩家对象
function Player.GetNameEx(actor)
    if getbaseinfo(actor, -1) == false then
        return getbaseinfo(actor, 1)
    end
    if getconst(actor, "<$HAT>") == "神秘人斗笠" then
        return "神秘人"
    else
        return getbaseinfo(actor, 1)
    end
end

--设置人物颜色
function Player.SetNameColor(actor, colorIndex)
    changenamecolor(actor, colorIndex)
end

--获取人物所在行会名 str
function Player.GetGuildName(actor)
    return getbaseinfo(actor, 36)
end

--获取人物/怪物当前地图代码
function Player.MapKey(actor)
    return getbaseinfo(actor, 3)
end

--获取目标坐标x
function Player.GetX(actor)
    return getbaseinfo(actor, ConstCfg.gbase.x)
end
--获取目标坐标y
function Player.GetY(actor)
    return getbaseinfo(actor, ConstCfg.gbase.y)
end

--获取记录变量的地图ID
function Player.GetVarMap(actor)
    return getplayvar(actor, "HUMAN", "KFZF4")
end

--根据属性ID获取属性值
function Player.GetAttr(actor, attrId)
    return getbaseinfo(actor, ConstCfg.gbase.custom_attr, attrId)
end

--设置记录变量的地图ID
function Player.SetVarMap(actor, mapID)
    local name = Player.GetName(actor)
    --如果是个人副本 不记录
    if mapID:find(name) then
        return
    end
    setplayvar(actor, "HUMAN", "KFZF4", mapID, 1)
end

--获取地图玩家
function Player.GetMapPlayerList(mapKey, x, y, range, ignoreGM)
    local x = x or 0
    local y = y or 0
    local range = range or 1000
    local ret = getobjectinmap(mapKey, x, y, range, 1) or {}
    return ret
end

--添加地图特效
function Player.DelMapEffect(idx)
    delmapeffect(idx)
end

--延迟调用
function Player.DelayCall(actor, msTime, funcStr)
    delaymsggoto(actor, msTime, funcStr)
end

--获取人物唯一ID str
function Player.GetUUID(actor)
    return getbaseinfo(actor, ConstCfg.gbase.id)
end

--获取人物/怪物是否是玩家
function Player.IsPlayer(actor)
    return getbaseinfo(actor, -1)
end

local cfg_AttToZhanLi = include("QuestDiary/cfgcsv/cfg_AttToZhanLi.lua") --配置
--获取战斗力
---@param actor string 玩家对象
function Player.GetPower(actor)
    local power = 0
    for key, value in pairs(cfg_AttToZhanLi) do
        local attNum = getbaseinfo(actor, ConstCfg.gbase.custom_attr, key)
        power = power + attNum * value.per
    end
    return power
end

--判断角色是不是第二天登录
function Player.isNextDayLogin(actor)
    local lastLoginDate = getplaydef(actor, VarCfg["U_上次本日首次登录时间"])
    -- 获取当前日期
    local currentDate = GetCurrentDateAsNumber()
    return currentDate > lastLoginDate
end

---添加自定义属性
---@param player object  --玩家对象
---@param item object  --装备对象
---@param name string  --附加属性标题名字
---@param data tabele --需要属性表 {key = {{254,220,31,1,0},{254,219,32,1,1},{254,203,33,1,2}},value = {5,5,10}}--{颜色,属性,属性名字,(0属性值,1百分比),显示位置}
---@param type string -- + - =
function Player.AddCustomAttr(player, item, name, data, type)
    type = type or "="
    changecustomitemtext(player, item, name, 3)
    changecustomitemtextcolor(player, item, 154, 3)
    for i = 1, #data.key do
        for j = 1, #data.key[i] do
            changecustomitemabil(player, item, data.key[i][5], (j - 1), data.key[i][j], 3)
        end
        changecustomitemvalue(player, item, data.key[i][5], type, data.value[i], 3)
    end
    refreshitem(player, item)
    recalcabilitys(player)
    return true
end

----获得角色等级
---@param actor object  --玩家对象
function Player.GetLevel(actor)
    return getbaseinfo(actor, 6)
end

return Player

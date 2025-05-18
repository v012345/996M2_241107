Player = {}
local HuiFuZhuangBei = include("QuestDiary/cfgcsv/cfg_HuiFuZhuangBei.lua") --С��ħ����

--��ȡ������ɫ����
function Player.getCreateActorDay(actor)
    local openday = grobalinfo(ConstCfg.global.openday)
    local create_actor_openday = getplaydef(actor, VarCfg.U_create_actor_openday)
    local create_actor_day = openday - create_actor_openday + 1
    return create_actor_day
end

--����������
---* actor:�������
---* moneyIdx������idx
---* num����������
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

--�۳���������
---* actor�����˶���
---* moneyName����������
---* num������
---* desc������
---* isBind���Ƿ��, Ĭ�Ͽ۳��󶨻���
---@param actor any
---@param moneyName string
---@param num number
---@param desc string
---@param isBind boolean
function Player.takeMoney(actor, moneyName, num, desc, isBind)
    --�ǲ���ֵĬ��Ϊ��
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

--��� ��Ʒ ���� װ���Ƿ���������(�������㷵�ز�����Ʒ������)
---* actor�����˶���
---* t��������Ʒ����
---* multiple������
---* isBind���Ƿ���󶨻��ң�Ĭ�ϰ����󶨻���(ֻ��Ի���)
function Player.checkItemNumByTable(actor, t, multiple, isBind)
    for _, item in ipairs(t) do
        local name, num = item[1], item[2]
        if multiple then num = num * multiple end
        local idx = getstditeminfo(name, ConstCfg.stditeminfo.idx)
        if Item.isCurrency(idx) then --����
            if type(isBind) ~= "boolean" then isBind = true end
            if not Player.checkMoneyNum(actor, idx, num, isBind) then
                -- Message.sendmsg(actor, ssrNetMsgCfg.HuoDeTuJing_Response,nil,nil,nil,{name})
                return name, num
            end
        else --��Ʒ װ��
            if not Bag.checkItemNum(actor, idx, num) then
                -- Message.sendmsg(actor, ssrNetMsgCfg.HuoDeTuJing_Response,nil,nil,nil,{name})
                return name, num
            end
        end
    end
end

---������Ʒ
---* actor:�������
---* t:��Ʒ��Ϣ
---* desc:����
---* multiple:����
---* isBind:�Ƿ�۳��󶨣�ֻ��Ի��ң�Ĭ�Ͽ۳���
function Player.takeItemByTable(actor, t, desc, multiple, isBind)
    --�ǲ���ֵĬ��Ϊ��
    if type(isBind) ~= "boolean" then isBind = true end
    for _, item in ipairs(t) do
        local name, num = item[1], item[2]
        if multiple then num = num * multiple end
        local idx = getstditeminfo(name, ConstCfg.stditeminfo.idx)
        local result
        if Item.isCurrency(idx) then --����
            result = Player.takeMoney(actor, name, num, desc, isBind)
            GameEvent.push(EventCfg.onCostMoney, actor, name, num)
        else --��Ʒ װ��
            local name = getstditeminfo(idx, ConstCfg.stditeminfo.name)
            result = takeitemex(actor, name, num, 0, desc)
        end
    end
end

--�����װ��Ҫ�������(ֻ����Ʒ�ϳ�ʹ��)
function Player.libcheckItemNumByTableEx(actor, t, multiple)
    for _, item in ipairs(t) do
        local idx, num = item[1], item[2]
        if multiple then num = num * multiple end
        local name = getstditeminfo(idx, ConstCfg.stditeminfo.name)
        if Item.isCurrency(idx) then --����
            if not Player.checkMoneyNum(actor, idx, num) then
                return false, name, num
            end
        elseif Item.isItem(idx) then --��Ʒ
            if not Bag.checkItemNum(actor, idx, num) then
                return false, name, num
            end
        else --װ��
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

--�������߷ǰ���Ʒ
function Player.takeItemByTableEx(actor, t, desc, multiple, isbind)
    --�����Ʒ�ͻ���
    local t_gold = {}
    local t_item = {}
    local t_overlap_item = {}
    local iteminfos = {}
    local itemoverlapinfos = {}
    for _, item in ipairs(t) do
        local idx, num = item[1], item[2]
        if multiple then num = num * multiple end
        if Item.isCurrency(idx) then --����
            t_gold[idx] = num
        else                         --��Ʒ װ��
            local overlap = getstditeminfo(idx, ConstCfg.stditeminfo.overlap)
            if overlap == 0 then     --������
                t_item[idx] = num
                iteminfos[idx] = { bind = {}, notbind = {} }
            else --������Ʒ
                t_overlap_item[idx] = num
                itemoverlapinfos[idx] = { bind = {}, notbind = {} }
            end
        end
    end
    --����ǰ���ƷΨһid�ֿ�����
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

    --���ϴ�������ƷҲ���ںϳ���Ʒ��
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

    --����Ʒ
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

    --�ۻ���
    for idx, num in pairs(t_gold) do
        changemoney(actor, idx, "-", num, desc, true)
    end
    return isbind
    --�����һ����Ʒ�ǹ̶��� ������Ʒ���ȿ۳�����Ʒ
    --���û���κ���Ʒ�ǹ̶�����ô˵���ǰ���Ʒ�㹻
    --�ж���Ʒ�Ƿ������Ʒ ����ǵ�����ƷҪ��������
end

--����������Ʒ,ͨ��λ������
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

--�������ָ���Ʒ���߻��ң��󶨻�������󶨻�������
---* actor:�������
---* t:��Ʒ��Ϣ
---* desc:����
---* multiple:����
---* isbind:�Ƿ��
--�������ָ���Ʒ���߻���
function Player.giveItemByTable(actor, t, desc, multiple, isbind)
    multiple = multiple or 1 --����
    for _, item in ipairs(t) do
        local name, num, bind = item[1], item[2], item[3]
        local idx = getstditeminfo(name, ConstCfg.stditeminfo.idx)
        if Item.isCurrency(idx) then --����
            changemoney(actor, idx, "+", num * multiple, desc, true)
        else                         --��Ʒ װ��
            if bind or isbind then
                giveitem(actor, name, num * multiple, ConstCfg.binding)
            else
                giveitem(actor, name, num * multiple)
            end
        end
    end
end

--���͵��ʼ�����Ʒ���߻��ң��󶨻�������󶨻�������
---* userid:���UserId����������������Ҫ��ǰ���#����:#����
---* mailId:�ʼ�ID
---* title:�ʼ�����
---* content:�ʼ�����
---* t:��Ʒ��Ϣ
---* multiple:����
---* isbind:�Ƿ��
--�������ָ���Ʒ���߻���
function Player.giveMailByTable(userid, mailId, title, content, t, multiple, isbind)
    multiple = multiple or 1 --����
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

--����Ʒ����
function Player.giveItemBoxByIdx(actor, idx)
    local name = getstditeminfo(idx, ConstCfg.stditeminfo.name)
    giveitem(actor, name, 1)
end

--��ȡ��ǰ����װ����Ψһid����ͨ��idx
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

--��ȡװ��λidx
function Player.getEquipIdxByPos(actor, pos)
    local itemobj = linkbodyitem(actor, pos)
    if itemobj == "0" then return end
    local idx = getiteminfo(actor, itemobj, ConstCfg.iteminfo.idx)
    return idx
end

--ͨ��λ�û�ȡװ������
function Player.getEquipNameByPos(actor, pos)
    local itemobj = linkbodyitem(actor, pos)
    if itemobj == "0" then return end
    local name = getiteminfo(actor, itemobj, ConstCfg.iteminfo.name)
    return name
end

--ͨ��λ�û�ȡ�ֶ�
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

--��������
local _addrs = {}
function Player.updateAddr(actor, loginattrs)
    --��������
    for attridx = 1, 250 do
        _addrs[attridx] = 0
    end

    for _, addr in ipairs(loginattrs) do
        for _, v in ipairs(addr) do
            local attridx = v[1]
            _addrs[attridx] = _addrs[attridx] + v[2]
        end
    end

    --������������
    for attridx, value in ipairs(_addrs) do
        if value > 0 then
            changehumnewvalue(actor, attridx, _addrs[attridx], ConstCfg.attrtime)
        end
    end
end

--���²�������
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

    --cfg_att_score.xls ����
    for attridx, attrvalue in pairs(newattr) do
        changehumnewvalue(actor, attridx, attrvalue, ConstCfg.attrtime)
    end
end

--ʹ����Ʒ�������
---* actor:���˶���
---* MoneyId:����id
---* ItemName:��Ʒ����
---* MoneyNum:��������
function Player.itemGiveMoney(actor, MoneyId, ItemOBJ, MoneyNum)
    local ItemName = getiteminfo(actor, ItemOBJ, 7)
    local name, num = Player.checkItemNumByTable(actor, { { ItemName, 1 } }, 1)
    if name then
        sendmsg(actor, ConstCfg.notice.own, '{"Msg":"<font color=\'#FFFFFF\'>ȱ��' .. name ..
            '*' .. num .. '</font>","Type":9}')
        return
    end
    changemoney(actor, MoneyId, "+", MoneyNum, "ʹ��" .. ItemName, true)
end

--������Ϣ����
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

--���͸�����Ϣ9
--* actor�����˶���
--* str����Ϣ���� ��ʽ �ı�#��ɫ|�ı�#��ɫ (��ɫֵ0-255)
--* defaultColor��Ĭ����ɫ Ĭ��Ϊ��ɫ
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

--�������촰����Ϣ����
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

--���͹�����Ϣ
---* actor:���˶���
---* FColor��ǰɫ
---* BColor����ɫ
---* msg����Ϣ���ݣ���ɫΪ������ɫ
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

--���͹�����Ϣ
---* actor:���˶���
---* FColor��ǰɫ
---* BColor����ɫ
---* msg����Ϣ���ݣ���ɫΪ������ɫ
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

--������Ļ�м乫����Ϣ
---* actor:���˶���
---* FColor��ǰɫ
---* BColor����ɫ
---* msg����Ϣ���ݣ���ɫΪ������ɫ
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

--������Ļ������Ϣ
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

--��ȡ��ɫѪ��ʣ��ٷֱ�
function Player.getHpPercentage(actor)
    local currHp = getbaseinfo(actor, ConstCfg.gbase.curhp)
    local maxHp = getbaseinfo(actor, ConstCfg.gbase.maxhp)
    local calculate = calculatePercentage(currHp, maxHp)
    return math.floor(calculate)
end

--��ȡ��ɫ����ʣ��ٷֱ�
function Player.getMpPercentage(actor)
    local currMp = getbaseinfo(actor, ConstCfg.gbase.curmp)
    local maxMp = getbaseinfo(actor, ConstCfg.gbase.maxmp)
    local calculate = calculatePercentage(currMp, maxMp)
    return math.floor(calculate)
end

--��ȡ��ɫѪ���ٷֱȵ���ֵ
---* object������
---* value����ȡ�İٷֱ�
function Player.getHpValue(object, value)
    local maxHp = getbaseinfo(object, ConstCfg.gbase.maxhp)
    if value == 0 then
        return 0 -- �������0
    end
    return maxHp * (value / 100)
end

function Player.getMpValue(object, value)
    local maxMp = getbaseinfo(object, ConstCfg.gbase.maxmp)
    if value == 0 then
        return 0 -- �������0
    end
    return maxMp * (value / 100)
end

--�������Ƿ�����
---* name:������֣��ַ�����
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

--�������Ƿ���ĳ������
---* actor:����
---* name:�������֣��ַ�����
function Player.Checkskill(actor, name)
    local skillidx = getskillindex(name)
    local skilllevel = getskilllevel(actor, skillidx)
    if skilllevel >= 1 then
        return true
    else
        return false
    end
end

--����װ�������������꣩
---* play����Ҷ���
---* item����Ʒ����
---* num�����������(0,1,2)
---* project�����ַ����������������(open=0�ر�\1�� show=0-����ʾ��ֵ\1-�ٷֱ�\2-���� name=���������֣��ַ�����color=��������ɫ0-255 imgcount=ͼƬ������1���� cur=��ǰֵ max=���ֵ level=����(0~65535))
---* sort���ַ��� ����ѯ ���ã�
---* var��ֵ ��sort=��ѯ��var�ɲ��
function Player.progressbarEX(play, item, num, project, sort, var)
    local itemtbl = json2tbl(getcustomitemprogressbar(play, item, num))
    if type(itemtbl) ~= "table" then
        return false
    end
    -- release_print(itemtbl)
    if itemtbl.open == 0 then
        -- release_print("��װ����δ��ʼ��")
        return false
    end

    if sort == "��ѯ" then --��ȡ��Ϣ
        return itemtbl[project]
    end

    if sort == "����" then --��ȡ��Ϣ
        local tbl = {
            [project] = var,
        }
        setcustomitemprogressbar(play, item, num, tbl2json(tbl))
        refreshitem(play, item)
    end
end

--����Ļ�м���Լ�������Ч
function Player.screffects(actor, effectId, offsetX, offsetY)
    offsetX = offsetX or 0
    offsetY = offsetY or 0
    local x = getconst(actor, "<$SCREENWIDTH>") / 2 + offsetX
    local y = getconst(actor, "<$SCREENHEIGHT>") / 2 + offsetY
    screffects(actor, 1, effectId, x, y, 1, 1, 0)
end

--�жϽ�ɫ�Ƿ��ڹ�������
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

--ʹ�ñ������CD
---* actor:�������
---* varName:������
---* cd:cdʱ�䣬��λ��
---* class:�������� true = �Զ������ false = Ĭ�ϱ���
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

--����json�������ݣ�����table
---* actor:�������(��дnil��ȡȫ�ֱ���)
---* varName:������
---* varValue:��������
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

--��ȡjson�������ݣ�����table
---* actor:�������(��дnil��ȡȫ�ֱ���)
---* varName:������
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

--�����Զ������json��������
---* actor:�������(��дnil��ȡȫ�ֱ���)
---* varName:������
---* varValue:��������
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

--��ȡ�Զ������json�������ݣ�����table
---* actor:�������(��дnil��ȡȫ�ֱ���)
---* varName:������
---@param actor any|nil
---@param varName string
---@return table
function Player.getJsonTableByPlayVar(actor, varName)
    local varStr = getplayvar(actor, "HUMAN", varName)
    local ret = json2tbl(varStr)
    if ret == "" or type(ret) ~= "table" then ret = {} end
    return ret
end

--����ȫ���Զ�����ʱint����
function Player.SetGlobalTempInt(varName, value)
    setplaydef(0, "N$" .. varName, value)
end

--��ȡȫ���Զ�����ʱint����
function Player.GetGlobalTempInt(varName)
    return getplaydef(0, "N$" .. varName)
end

--����ȫ���Զ�����ʱstr����table
function Player.SetGlobalTempTable2(varName, value)
    setplaydef(0, "S$" .. varName, tbl2json(value))
end

--��ȡȫ���Զ�����ʱstr����table
function Player.GetGlobalTempTable2(varName)
    local ret = getplaydef(0, "S$" .. varName)
    if ret ~= "" then
        return json2tbl(ret)
    end
    return {}
end

-----------�Զ����������---------

--�����޸��Զ�������
---* actor�����˶���
---* itemobj����Ʒ����
---* group�����Է���
---* attrIndex������λ�ú�����
---* attrType���������� 1Ϊcfg_att_score��������� ����Ϊcfg_custpro_caption����
---* attrColor��������ɫ
---* realAttrId����ʵ����
---* attrId������ID��attrType��Ϊ1ʱ��Ϊ��ʾ����
---* isAttrPercent�������Ƿ�Ϊ�ٷֱȣ�0���ǰٷֱȣ�1�ٷֱȣ�
---* attrValue������ֵ
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

--��ȡ�Զ�������ֵ
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

--��ȡȫ���Զ�������ֵ
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

--��ȡ��ѧ�����Ե��ַ���
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

--�ٻ��Լ����Ե����ι�
---* actor�����˶���
---* mapId����ͼID
---* x������x
---* y������y
---* name������
---* targetName��Ŀ������
---* number������
---* color����ɫ
---* percentage���ٷֱ�
function Player.cloneSelfToHumanoid(actor, mapId, x, y, name, targetName, number, color, percentage)
    --��¡װ��
    local function cloneEquip(actor, targetObj)
        for _, value in ipairs(ConstCfg.equipWhere) do
            local itemobj = linkbodyitem(actor, value)
            if itemobj ~= "0" then
                local itemName = getiteminfo(actor, itemobj, ConstCfg.iteminfo.name)
                giveonitem(targetObj, value, itemName, 1)
            end
        end
    end
    --��¡����
    local function cloneSkill(actor, targetObj)
        for _, value in ipairs(ConstCfg.skillIdList) do
            local level = getskillinfo(actor, value, 1)
            if level then
                addskill(targetObj, value, level)
            end
        end
    end
    --��¡����
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

---�������---
--�������
function Player.addTask(actor, taskId, progress)
    taskId = tostring(taskId)
    local tasks = Player.getJsonTableByVar(actor, VarCfg["T_��¼����"]) or {}
    tasks[taskId] = {
        progress = progress
    }
    Player.setJsonVarByTable(actor, VarCfg["T_��¼����"], tasks)
end

--��������
function Player.updateProgress(actor, taskId, progress)
    taskId = tostring(taskId)
    local tasks = Player.getJsonTableByVar(actor, VarCfg["T_��¼����"]) or {}
    if tasks[taskId] then
        tasks[taskId].progress = progress
    end
    Player.setJsonVarByTable(actor, VarCfg["T_��¼����"], tasks)
end

--��ȡ�������
function Player.getProgress(actor, taskId)
    taskId = tostring(taskId)
    local tasks = Player.getJsonTableByVar(actor, VarCfg["T_��¼����"]) or {}
    if tasks[taskId] then
        return tasks[taskId].progress
    end
end

--ɾ������
function Player.removeTask(actor, taskId)
    taskId = tostring(taskId)
    local tasks = Player.getJsonTableByVar(actor, VarCfg["T_��¼����"]) or {}
    if tasks[taskId] then
        tasks[taskId] = nil
    end
    Player.setJsonVarByTable(actor, VarCfg["T_��¼����"], tasks)
end

--��ʼ��һ����������
function Player.nextTaskMain(actor, taskId, cfg)
    newdeletetask(actor, taskId)
    setplaydef(actor, VarCfg["U_�����������"], cfg.nextTask)
    setplaydef(actor, VarCfg["U_��������״̬"], cfg.nextStartschedule or 0)
    setplaydef(actor, VarCfg["U_��ǰ�������1"], 0)
    setplaydef(actor, VarCfg["U_��ǰ�������2"], 0)
    setplaydef(actor, VarCfg["U_��ǰ�������3"], 0)
    setplaydef(actor, VarCfg["U_��ǰ�������4"], 0)
    Player.removeTask(actor, taskId)
    Player.addTask(actor, cfg.nextTask, cfg.nextStartschedule)
    Player.screffects(actor, 17530)
end

--��ʼ��һ����������
function Player.nextTaskOther(actor, taskId, cfg)
    newdeletetask(actor, taskId)
    Player.removeTask(actor, taskId)
    if cfg.nextTask then
        Player.addTask(actor, cfg.nextTask, cfg.nextStartschedule)
    end
end

--����Var��ȡTbl�е�ֵ ����lastTitle
---* actor:�������
---* var:�� ���ֵ
---* tbl:tbl
function Player.getNewandOldTitle(actor, var, tbl)
    local OldTitle = ""
    local OldNum = 0
    --����Ƿ��Ѿ��и�tbl�еĳƺ�
    for k, v in ipairs(tbl) do
        if checktitle(actor, v.title) then
            OldTitle = v.title
            OldNum = k
            break
        end
    end
    --��⴫���Ӧ�ĳƺ�
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

--�Ƿ������Ѫ����
function Player.canLifesteal(actor)
    local currHpPer = Player.getHpPercentage(actor)
    if currHpPer > 3 and currHpPer < 100 then
        return true
    else
        return false
    end
end

--���������ַ���
---* actor:�������
---@param actor any|nil
---@param actType any|nil
function Player.setAttList(actor, actType)
    local attType = {}
    attType["��������"] = function()
        local skillrs = {}
        GameEvent.push(EventCfg.onAddSkillPower, actor, skillrs)
        -- dump(skillrs)
        for key, value in pairs(skillrs) do
            setmagicpower(actor, key, value, 1)
        end
    end

    attType["���Ը���"] = function()
        delattlist(actor, "������") --������
        local attrs = {}
        GameEvent.push(EventCfg.onCalcAttr, actor, attrs)
        local attrStr = ""
        local attrList = {}
        --�����и�ӳ�start
        local qieGeAddtion = attrs[205] or 0
        local qieGe = attrs[200] or 0
        -- local qieGeAddtion = 0
        -- local qieGe =  0

        if qieGe > 0 and qieGeAddtion > 0 then
            local QG = math.floor(qieGe * (qieGeAddtion / 100))
            attrs[200] = attrs[200] + QG
        end

        --�����и�ӳ�
        for key, value in pairs(attrs) do
            table.insert(attrList, "3#" .. key .. "#" .. value)
        end
        attrStr = table.concat(attrList, "|")
        -- release_print(attrStr)
        -- callscriptex(actor, "ADDATTLIST", "������", "=", attrStr, 2)
        addattlist(actor, "������", "=", attrStr, 1)
    end

    attType["���ʸ���"] = function()
        delattlist(actor, "���ʸ���") --������
        local attrs = { [204] = 100 } --��ʼֵ100
        GameEvent.push(EventCfg.onCalcBaoLv, actor, attrs)
        --���˵�
        if hasbuff(actor, 31040) then
            attrs[218] = (attrs[218] or 0) + 5
        end
        if attrs[218] then
            if attrs[204] then
                attrs[204] = attrs[204] + math.floor(attrs[204] * (attrs[218] / 100))
            end
        end
        if getplaydef(actor, VarCfg["J_����Ȧ������_���䱬��"]) == 1 then
            if attrs[204] >= 100 then
                attrs[204] = attrs[204] - 100
            else
                attrs[204] = 0
            end
        end

        --����12   ��ʥ��Լ
        if hasbuff(actor, 31015) then
            attrs[204] = attrs[204] + 20
        end

        local tian_tian_bao_lv = getplaydef(actor, VarCfg["B_���콻���˱���"])
        if tian_tian_bao_lv > 0 then
            attrs[204] = attrs[204] + tian_tian_bao_lv
        end

        --����12   ��ħ��Լ
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
        addattlist(actor, "���ʸ���", "=", attrStr, 1)
        --������ʵ����
        setbaseinfo(actor, 43, zhenShiBaoLv)
    end

    attType["��������"] = function()
        local beiGongs = { 0 }
        GameEvent.push(EventCfg.onCalcBeiGong, actor, beiGongs)
        local beigong        = beiGongs[1]
        beigong              = beigong + 100

        --ħ���������쵶��        ����֮�� ÿ��00:00 �Զ���õ���ף�������1%��10%����������������24H
        local DaoFengBeiGong = getplaydef(actor, VarCfg["N$J_����֮��_����"])
        beigong              = beigong + DaoFengBeiGong

        --ת�����ӱ��� 4����ʼ ÿһ������ 5%
        local RenewLevel     = getbaseinfo(actor, ConstCfg.gbase.renew_level)
        if RenewLevel >= 4 then
            local num = (RenewLevel - 3) * 5
            beigong = beigong + num
        end

        if checkitemw(actor,"��������潛����", 1) and checkitemw(actor,"����ˮ�R̫�O����", 1) then
            beigong = beigong + (RenewLevel * 2)
        end

        if checkitemw(actor, "���ɻ꡿��֮��Ӱ", 1) then
            local itemobj = linkbodyitem(actor, 7)
            local tbl2 = json2tbl(getcustomitemprogressbar(actor, itemobj, 1)) --��ȡ�ڶ�����������Ϣ
            if tbl2["open"] == 1 and tbl2["cur"] > 0 then
                beigong = beigong + tbl2["cur"]
            end
        end

        if checkitemw(actor, "���¡�֮��", 1) then
            if checktimeInPeriod(18, 59, 6, 59) then
                beigong = beigong + 15
            end
        end

        if checkitemw(actor, "����֮�С�����", 1) then
            beigong = beigong + 5
        end
        
        if checkitemw(actor, "�Լ�������", 1) then
            beigong = beigong + 5
        end

        if checkitemw(actor, "������֮��", 1) then
            beigong = beigong + 10
        end
        --����
        if hasbuff(actor, 31041) then
            beigong = beigong + 10
        end

        if checktitle(actor,"ʥ���ػ���") then
            beigong = beigong + 5
        end

        -- ����ʱ����ʹ�������������������һ��  ����5��-��ȴ30��  
        if hasbuff(actor, 31085) then
            local _buffbeigong = beigong - 100
            if _buffbeigong > 1 then
                beigong = beigong + math.floor(_buffbeigong / 2)
            end
        end

        if hasbuff(actor, 30046) then
            powerrate(actor, 1, 655350)
            setplaydef(actor, VarCfg["T_����"], 1)
        else
            powerrate(actor, beigong, 655350)
            setplaydef(actor, VarCfg["U_�����¼����"], beigong)
            local currBeiGong = getconst(actor, "<$POWERRATE>")
            setplaydef(actor, VarCfg["T_����"], currBeiGong)
            local bgAtt = (tonumber(currBeiGong) - 1) * 100
            changehumnewvalue(actor, 227, bgAtt, 655350)
        end
    end

    attType["���ٸ���"] = function()
        if checkkuafu(actor) then
            return
        end
        local attackSpeeds = { 0 }
        GameEvent.push(EventCfg.onCalcAttackSpeed, actor, attackSpeeds)
        local attackSpeed = attackSpeeds[1]
        -- local currSpeed = math.ceil(attackSpeed / 2)

        -- �̡�����֮������Buff
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
        setplaydef(actor, VarCfg["U_�����ٶ�"], attackSpeed + 100)
        changehumnewvalue(actor, 228, attackSpeed, 655350)

        GameEvent.push(EventCfg.OverloadGongSu, actor, attackSpeed + 100)
        if hasbuff(actor, 31072) then
            delbuff(actor, 31072)
        end

        if getflagstatus(actor, VarCfg["F_��������˫��"]) == 1 then
            addbuff(actor, 31072, 0, 1, actor, { [28] = math.floor((attackSpeed + 100) / 12) })
        end
    end

    attType["��Ѫ����"] = function()
        local addHp = 0 --�����Ѫ
        local addMp = 0 --�������
        local tuoZhanAddHpPer = 0  --����ս�����Ѫ�����ǰٷֱȣ�
        local myLevel = getbaseinfo(actor, ConstCfg.gbase.level) --��ȡ�ҵĵȼ�
        local suitIds = Player.getJsonTableByVar(actor, VarCfg["T_��¼��װID"]) --��ȡ��װ��ID
        local guangHuanEquipName = getconst(actor, "<$RIGHTHAND>") --�ָ��⻷
        local jiFengEquipName = getconst(actor, "<$DRUM>") --�����ӡ��Ѫ
        local myMapHp = getbaseinfo(actor, ConstCfg.gbase.custom_attr, 1)
        --�⻷λ�� ÿ���Ѫ ��ҵȼ� x 1% - 10% Ѫ��
        local guangHuanCfg = HuiFuZhuangBei[guangHuanEquipName]
        if guangHuanCfg then
            if guangHuanCfg.value then
                addHp = addHp + (myLevel * guangHuanCfg.value)
            end
        end
        --�̶���Ѫλ��
        local jiFengCfg = HuiFuZhuangBei[jiFengEquipName]
        if jiFengCfg then
            if jiFengCfg.hpNum then
                addHp = addHp + jiFengCfg.hpNum
            end
        end
        --���}�������֮��  ÿ��ָ�[888]������ֵ
        if checkitemw(actor, "���}�������֮��", 1) then
            addHp = addHp + 888
        end
        -- ��ҹ����װ ����ÿ��ָ�[1%]���������ֵ  ��װ��� 508
        if table.contains(suitIds, tostring(508)) then
            addHp = addHp + math.ceil(myMapHp * 0.01)
        end
        -- ������װ ����ÿ��ָ�[1%]���������ֵ  ��װ��� 689
        if table.contains(suitIds, tostring(689)) then
            addHp = addHp + math.ceil(myMapHp * 0.01)
        end

        if checkitemw(actor, "������", 1) then
            addHp = addHp + 2000
            addMp = addMp + 2000
        end

        if checktitle(actor, "ʪ����ͽ") then
            addHp = addHp + 100
            addMp = addMp + 100
        end
        --Ѫħ֮����Ѫ
        if getflagstatus(actor, VarCfg["F_����_Ѫħ֮����ʶ"]) == 1 then
            addHp = addHp + math.ceil(myMapHp / 1000)
        end

        
    -----------------------------------------------------------------��ս״̬�»�Ѫbegin-------------------------------------------------------
        --ˮ��֮�� ��ս״̬��ÿ��[3%]���������ֵ��
        if checkitemw(actor, "ˮ��֮��", 1) then
            tuoZhanAddHpPer = tuoZhanAddHpPer + 3
        end
        -- ҹ��֮�� ��ս״̬��ÿ��[3%]���������ֵ��
        if checkitemw(actor, "ҹ��֮��", 1) then
            tuoZhanAddHpPer = tuoZhanAddHpPer + 3
        end
        -- ������װ[��] ��ս��ÿ��ָ�[1%]�������ֵ ��װ��� 586
        if table.contains(suitIds, tostring(586)) then
            tuoZhanAddHpPer = tuoZhanAddHpPer + 1
        end
    ---------------------------------------------------------------��������Ч---------------------------------------------------------------
    if getflagstatus(actor, VarCfg["F_����_��������ʶ"]) == 1 then
        setplaydef(actor,"N$��������Ѫ",math.ceil(myMapHp * 0.05))
    else
        setplaydef(actor,"N$��������Ѫ",0)
    end
    -----------------------------------------------------------------��ս״̬�»�Ѫend-------------------------------------------------------
        setplaydef(actor, VarCfg["N$ÿ��ָ�Ѫ��"], addHp)
        setplaydef(actor, VarCfg["N$ÿ��ָ�����"], addMp)
        setplaydef(actor, VarCfg["N$��ս�ָ�Ѫ��"], tuoZhanAddHpPer)
    end
    attType[actType]()
end

function Player.actionAttList(actor)
    Player.setAttList(actor, "���Ը���")
    Player.setAttList(actor, "��������")
    Player.setAttList(actor, "��Ѫ����")
end

---@param actor userdata ��Ҷ���
function Player.GetName(actor)
    return getbaseinfo(actor, 1)
end

---@param actor userdata ��Ҷ���
function Player.GetNameEx(actor)
    if getbaseinfo(actor, -1) == false then
        return getbaseinfo(actor, 1)
    end
    if getconst(actor, "<$HAT>") == "�����˶���" then
        return "������"
    else
        return getbaseinfo(actor, 1)
    end
end

--����������ɫ
function Player.SetNameColor(actor, colorIndex)
    changenamecolor(actor, colorIndex)
end

--��ȡ���������л��� str
function Player.GetGuildName(actor)
    return getbaseinfo(actor, 36)
end

--��ȡ����/���ﵱǰ��ͼ����
function Player.MapKey(actor)
    return getbaseinfo(actor, 3)
end

--��ȡĿ������x
function Player.GetX(actor)
    return getbaseinfo(actor, ConstCfg.gbase.x)
end
--��ȡĿ������y
function Player.GetY(actor)
    return getbaseinfo(actor, ConstCfg.gbase.y)
end

--��ȡ��¼�����ĵ�ͼID
function Player.GetVarMap(actor)
    return getplayvar(actor, "HUMAN", "KFZF4")
end

--��������ID��ȡ����ֵ
function Player.GetAttr(actor, attrId)
    return getbaseinfo(actor, ConstCfg.gbase.custom_attr, attrId)
end

--���ü�¼�����ĵ�ͼID
function Player.SetVarMap(actor, mapID)
    local name = Player.GetName(actor)
    --����Ǹ��˸��� ����¼
    if mapID:find(name) then
        return
    end
    setplayvar(actor, "HUMAN", "KFZF4", mapID, 1)
end

--��ȡ��ͼ���
function Player.GetMapPlayerList(mapKey, x, y, range, ignoreGM)
    local x = x or 0
    local y = y or 0
    local range = range or 1000
    local ret = getobjectinmap(mapKey, x, y, range, 1) or {}
    return ret
end

--��ӵ�ͼ��Ч
function Player.DelMapEffect(idx)
    delmapeffect(idx)
end

--�ӳٵ���
function Player.DelayCall(actor, msTime, funcStr)
    delaymsggoto(actor, msTime, funcStr)
end

--��ȡ����ΨһID str
function Player.GetUUID(actor)
    return getbaseinfo(actor, ConstCfg.gbase.id)
end

--��ȡ����/�����Ƿ������
function Player.IsPlayer(actor)
    return getbaseinfo(actor, -1)
end

local cfg_AttToZhanLi = include("QuestDiary/cfgcsv/cfg_AttToZhanLi.lua") --����
--��ȡս����
---@param actor string ��Ҷ���
function Player.GetPower(actor)
    local power = 0
    for key, value in pairs(cfg_AttToZhanLi) do
        local attNum = getbaseinfo(actor, ConstCfg.gbase.custom_attr, key)
        power = power + attNum * value.per
    end
    return power
end

--�жϽ�ɫ�ǲ��ǵڶ����¼
function Player.isNextDayLogin(actor)
    local lastLoginDate = getplaydef(actor, VarCfg["U_�ϴα����״ε�¼ʱ��"])
    -- ��ȡ��ǰ����
    local currentDate = GetCurrentDateAsNumber()
    return currentDate > lastLoginDate
end

---����Զ�������
---@param player object  --��Ҷ���
---@param item object  --װ������
---@param name string  --�������Ա�������
---@param data tabele --��Ҫ���Ա� {key = {{254,220,31,1,0},{254,219,32,1,1},{254,203,33,1,2}},value = {5,5,10}}--{��ɫ,����,��������,(0����ֵ,1�ٷֱ�),��ʾλ��}
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

----��ý�ɫ�ȼ�
---@param actor object  --��Ҷ���
function Player.GetLevel(actor)
    return getbaseinfo(actor, 6)
end

return Player

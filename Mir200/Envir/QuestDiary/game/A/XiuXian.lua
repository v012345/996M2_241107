XiuXian = {}
local MonData = include("QuestDiary/cfgcsv/cfg_MonNameData.lua")       --��������
local itemdata = include("QuestDiary/cfgcsv/cfg_XiuXianFaBaoData.lua") --��������
local BaiGuai = include("QuestDiary/cfgcsv/cfg_BaiGuai.lua")       --��������
local cfg_Task = include("QuestDiary/cfgcsv/cfg_Task.lua") --��������
local where = 43
XiuXian.QiYunGaiLv = {
    {50,10},
    {100,3},
    {200,2},
    {99999999999,1},
}

local function _setIcon(actor, itemObj)
    local itemName = getiteminfo(actor, itemObj, ConstCfg.iteminfo.name)
    local level = tonumber(getstditeminfo(itemName, ConstCfg.stditeminfo.custom29) or 0) ----��ȡװ���ȼ�
    local cfg = itemdata[level]
    if not cfg then
        return
    end
    seticon(actor, ConstCfg.iconWhere.faBao, 1, cfg.iconId, 0, 0, 0)
end

function XiuXian.Request(actor)
    local itemObj = linkbodyitem(actor, where)
    if itemObj == "0" then
        Player.sendmsgEx(actor, "û��װ�����ڵ�װ��!#249")
        return
    end
    local itemName = getiteminfo(actor, itemObj, ConstCfg.iteminfo.name)
    local level = tonumber(getstditeminfo(itemName, ConstCfg.stditeminfo.custom29)) ----��ȡװ���ȼ�
    if level >= 21 then
        Player.sendmsgEx(actor, "�������������!#249")
        return
    end
    local cfg = itemdata[level]
    local nextCfg = itemdata[level + 1]
    if not nextCfg then
        Player.sendmsgEx(actor, "�������������!#249")
        return
    end
    if not cfg then
        Player.sendmsgEx(actor, "���ô���,����ϵ�ͷ�!#249")
        return
    end
    local currFaBaoExp = getplaydef(actor, VarCfg["U_������ǰ����"])
    if currFaBaoExp < cfg.itemlevel then
        Player.sendmsgEx(actor, string.format("������ɽ��Ȳ���|%s#249", cfg.itemlevel))
        return
    end
    local name, num = Player.checkItemNumByTable(actor, cfg.cost)
    if name then
        Player.sendmsgEx(actor, string.format("���|%s#249|����%d#249", name, num))
        return
    end
    if not Bag.checkBagEmptyNum(actor, 5) then
        Player.sendmsgEx(actor, "��ı������Ӳ���!")
        return
    end
    Player.takeItemByTable(actor, cfg.cost, "����")
    takew(actor, itemName, 1, "��������")
    local isSuccess = giveonitem(actor, where, nextCfg.itemname, 1, 0, "���ɸ���")
    GameEvent.push(EventCfg.onXiuXianUP, actor,nextCfg.itemname)

    --��֤����
    XiuXian.CheckTask(actor)
    --����ľ���ֵ����һ��
    local nextCur = currFaBaoExp - cfg.itemlevel
    setplaydef(actor, VarCfg["U_������ǰ����"], nextCur)
    local newItemObj = linkbodyitem(actor, where)
    if nextCfg.itemname == "Ǳ������ʯ" then
        nextCur = nextCfg.itemlevel
    end
    local tbl = {
        ["open"] = 1,
        ["show"] = 2,
        ["name"] = "���ɽ���",
        ["color"] = 253,
        ["imgcount"] = 1,
        ["cur"] = nextCur,
        ["max"] = nextCfg.itemlevel,
        ["level"] = level + 1,
    }
    setcustomitemprogressbar(actor, newItemObj, 0, tbl2json(tbl))
    refreshitem(actor, newItemObj)
    setitemintparam(actor, where, 1, 123)
    reddel(actor, 104, 1000)
    setplaydef(actor, VarCfg["N$���ﰴť�Ƿ���Ӻ��"], 0)
    setflagstatus(actor, VarCfg["F_���ɺ���ʶ"], 0)
    XiuXian.QiYun(actor,newItemObj)
    XiuXian.SyncResponse(actor)
end
----����-���²���
--function XiuXian.QiYun(player)
--
--end

--��֤����
function XiuXian.CheckTask(actor)
    local taskID = getplaydef(actor, VarCfg["U_�����������"])
    local mainTaskStatus = getplaydef(actor, VarCfg["U_��������״̬"])
    if taskID == 7 and mainTaskStatus == 2 then
        local cfg = cfg_Task[taskID]
        Player.nextTaskMain(actor, taskID, cfg)
        Task.SyncResponse(actor)
        Player.sendmsgEx(actor,"")
    end
end
--ͬ����Ϣ
function XiuXian.SyncResponse(actor, logindatas)
    local data = {}
    local _login_data = { ssrNetMsgCfg.XiuXian_SyncResponse, 0, 0, 0, data }
    if logindatas then
        table.insert(logindatas, _login_data)
    else
        Message.sendmsg(actor, ssrNetMsgCfg.XiuXian_SyncResponse, 0, 0, 0, data)
    end
end

--�ⲿ�ӿ�
--�������ֵ
function XiuXian.addXiuXian(actor, addNum)
    local itemobj = linkbodyitem(actor, where) ----����װ��+
    local itemName,level
    local cfg = nil
    if itemobj ~= "0" then                     ----�ж�δ����ֱ�ӷ���
        itemName = getiteminfo(actor, itemobj, ConstCfg.iteminfo.name)            ----��ȡװ������
        level = tonumber(getstditeminfo(itemName, ConstCfg.stditeminfo.custom29)) ----��ȡװ���ȼ�
        cfg = itemdata[level]
    end
    local currFaBaoExp = getplaydef(actor, VarCfg["U_������ǰ����"])
    if cfg then
        if currFaBaoExp >= cfg.itemlevel then ----������������ �����
            if getplaydef(actor, VarCfg["N$���ﰴť�Ƿ���Ӻ��"]) == 0 then
                local client_flag = getconst(actor, "<$CLIENTFLAG>")
                if client_flag == "1" then
                    reddot(actor, 104, 1000, 16, -10, 1, 20000)
                else
                    reddot(actor, 107, 1000, 40, 6, 1, 20000)
                end
                setflagstatus(actor, VarCfg["F_���ɺ���ʶ"], 1)
                setplaydef(actor, VarCfg["N$���ﰴť�Ƿ���Ӻ��"], 1)
            end
        end
    end
    local addExp = currFaBaoExp + addNum
    setplaydef(actor, VarCfg["U_������ǰ����"], addExp)
    if itemobj ~= "0" then
        local maxValue = 0
        if cfg then
            maxValue = cfg.itemlevel
        end
        local tbl = {
            ["open"] = 1,
            ["show"] = 2,
            ["name"] = "���ɽ���",
            ["color"] = 253,
            ["imgcount"] = 1,
            ["cur"] = addExp,
            ["max"] =  maxValue,
            ["level"] = level,
        }
        setcustomitemprogressbar(actor, itemobj, 0, tbl2json(tbl))
        refreshitem(actor, itemobj)
    end
end

local function _setRiYueBuLi(actor, MonName, itemobj)
    if BaiGuai[MonName] then
        if getflagstatus(actor,VarCfg["F_���²���"]) == 1 then
            local num = getplaydef(actor,VarCfg["U_���²������"])
            local flag = 1
            for i=1,#XiuXian.QiYunGaiLv do
                if num < XiuXian.QiYunGaiLv[i][1] then
                    flag = i
                    break
                end
            end
            local random = math.random(1,100)
            if random <= XiuXian.QiYunGaiLv[flag][2] then
                setplaydef(actor,VarCfg["U_���²������"],num+1)
                XiuXian.QiYun(actor,itemobj)
            end
        end
    end
end

function XiuXian.QiYun(actor,item)
    local num = getplaydef(actor, VarCfg["U_���²������"])
    local tbl = {
        ["open"] = 1,
        ["show"] = 2,
        ["name"] = "���²���",
        ["color"] = 253,
        ["imgcount"] = 1,
        ["cur"] = num,
        ["max"] = num,
        ["level"] = 0,
    }
    setplaydef(actor, VarCfg["U_���²������"], num)
    setcustomitemprogressbar(actor,item,1,tbl2json(tbl))
    tbl = {key = {{254,1,100,0,0},{254,3,100,0,1},{254,4,100,0,2}},value = {300*num,10*num,10*num}}
    Player.AddCustomAttr(actor,item,"[���²�������]",tbl)
    refreshitem(actor,item)
    return ""
end

--����ɱ�ִ���
local function _XiuXianKillmon(actor, monobj, monName)
    local itemobj = linkbodyitem(actor, where) ----����װ��
    if itemobj == "0" then                     ----�ж�δ����ֱ�ӷ���
        return
    end
    local MonName = monName
    _setRiYueBuLi(actor, MonName, itemobj)
    local info = MonData[MonName]
    if info then
        local itemName = getiteminfo(actor, itemobj, ConstCfg.iteminfo.name)            ----��ȡװ������
        local level = tonumber(getstditeminfo(itemName, ConstCfg.stditeminfo.custom29)) ----��ȡװ���ȼ�
        --�������
        if level >= 21 then
            return
        end
        local cfg = itemdata[level]
        if not cfg then
            return
        end
        if level < cfg.itemlevel then
            local currFaBaoExp = getplaydef(actor, VarCfg["U_������ǰ����"])
            if currFaBaoExp >= cfg.itemlevel then ----������������ �����
                if getplaydef(actor, VarCfg["N$���ﰴť�Ƿ���Ӻ��"]) == 0 then
                    local client_flag = getconst(actor, "<$CLIENTFLAG>")
                    if client_flag == "1" then
                        reddot(actor, 104, 1000, 16, -10, 1, 20000)
                    else
                        reddot(actor, 107, 1000, 40, 6, 1, 20000)
                    end
                    setflagstatus(actor, VarCfg["F_���ɺ���ʶ"], 1)
                    setplaydef(actor, VarCfg["N$���ﰴť�Ƿ���Ӻ��"], 1)
                end
                return
            end
            local rannum = math.random(info.random[1], info.random[2])
            local xiuXianZhiAddtion = getbaseinfo(actor, ConstCfg.gbase.custom_attr, 217)
            if xiuXianZhiAddtion > 0 then
                local addtionValue = math.floor(rannum * xiuXianZhiAddtion / 100)
                rannum = rannum + addtionValue
            end
            local addExp = currFaBaoExp + rannum
            setplaydef(actor, VarCfg["U_������ǰ����"], addExp)
            local tbl = {
                ["open"] = 1,
                ["show"] = 2,
                ["name"] = "���ɽ���",
                ["color"] = 253,
                ["imgcount"] = 1,
                ["cur"] = addExp,
                ["max"] = cfg.itemlevel,
                ["level"] = level,
            }
            setcustomitemprogressbar(actor, itemobj, 0, tbl2json(tbl))
            refreshitem(actor, itemobj)
        end
    end
    
end
GameEvent.add(EventCfg.onKillMon, _XiuXianKillmon, XiuXian)

local function _onTakeOn43(actor, itemobj)
    local itemName = getiteminfo(actor, itemobj, ConstCfg.iteminfo.name)            ----��ȡװ������
    local level = tonumber(getstditeminfo(itemName, ConstCfg.stditeminfo.custom29)) ----��ȡװ���ȼ�
    setplaydef(actor, VarCfg["U_���ɵȼ�"], level)
    -- local cfg = itemdata[level]
    -- if not cfg then
    --     return
    -- end
    -- local xiuXianExp = getplaydef(actor, VarCfg["U_������ǰ����"])
    -- local tbl = {
    --     ["open"] = 1,
    --     ["show"] = 2,
    --     ["name"] = "���ɽ���",
    --     ["color"] = 253,
    --     ["imgcount"] = 1,
    --     ["cur"] = xiuXianExp,
    --     ["max"] = cfg.itemlevel,
    --     ["level"] = level,
    -- }
    -- setcustomitemprogressbar(actor, itemobj, 0, tbl2json(tbl))
    -- refreshitem(actor, itemobj)

    _setIcon(actor, itemobj)
end
GameEvent.add(EventCfg.onTakeOn43, _onTakeOn43, XiuXian)

--��¼����
local function _onLoginEnd(actor, logindatas)
    XiuXian.SyncResponse(actor, logindatas)
    local itemobj = linkbodyitem(actor, where) ----����װ��
    if itemobj == "0" then
        return
    end
    _setIcon(actor, itemobj)
    if getflagstatus(actor, VarCfg["F_���ɺ���ʶ"]) == 1 then
        local itemName = getiteminfo(actor, itemobj, ConstCfg.iteminfo.name)            ----��ȡװ������
        local level = tonumber(getstditeminfo(itemName, ConstCfg.stditeminfo.custom29)) ----��ȡװ���ȼ�
        if level < 21 then
            local client_flag = getconst(actor, "<$CLIENTFLAG>")
            if client_flag == "1" then
                reddot(actor, 104, 1000, 16, -10, 1, 20000)
            else
                reddot(actor, 107, 1000, 40, 6, 1, 20000)
            end
        end
    end
end
--ע��������Ϣ
Message.RegisterNetMsg(ssrNetMsgCfg.XiuXian, XiuXian)
--�¼��ɷ�
GameEvent.add(EventCfg.onLoginEnd, _onLoginEnd, XiuXian)

--����
GameEvent.add(EventCfg.onKFLogin, _onLoginEnd, XiuXian)

--�������ﴥ��
local function _onAttackMonster(actor, Target, Hiter, MagicId, qieGe)
    local level = getplaydef(actor, VarCfg["U_���ɵȼ�"])
    local cfg = itemdata[level]
    if cfg then
        local qieGe = getbaseinfo(actor, ConstCfg.gbase.custom_attr, 200)
        if cfg.effect1 then
            if randomex(10) then
                local damage = math.floor(qieGe * (cfg.effect1 / 100))
                local x = getbaseinfo(Target, ConstCfg.gbase.x)
                local y = getbaseinfo(Target, ConstCfg.gbase.y)
                rangeharm(actor, x, y, 0, 0, 6, damage, 0, 2,16017, 1)
                return
            end
        end
        if cfg.effect2 then
            if randomex(2) then
                addbuff(actor, 31052)
                return
            end
        end
        if cfg.effect3 then
            if randomex(2) then
                local damage = math.floor(qieGe * (cfg.effect3 / 100))
                local x = getbaseinfo(actor, ConstCfg.gbase.x)
                local y = getbaseinfo(actor, ConstCfg.gbase.y)
                rangeharm(actor, x, y, 8, damage, 0, 0, 0, 2)
                playeffect(actor, 17524, 0, 0, 1, 0, 1)
                return
            end
        end
    end
end
GameEvent.add(EventCfg.onAttackMonster, _onAttackMonster, XiuXian)

return XiuXian

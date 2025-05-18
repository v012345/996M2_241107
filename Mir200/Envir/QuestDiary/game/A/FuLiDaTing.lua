local FuLiDaTing = {}
FuLiDaTing.ID = "福利大厅"
local npcID = 0
FuLiDaTing.configCache = include("QuestDiary/cfgcsv/cfg_FuLiDaTing.lua")            --配置
FuLiDaTing.shouShaConfig = include("QuestDiary/cfgcsv/cfg_GeRenShouSha.lua")        --配置个人首杀
FuLiDaTing.geRenShouBaoConfig = include("QuestDiary/cfgcsv/cfg_GeRenShouBao.lua")   --配置个人首爆
FuLiDaTing.quanFuShouBaoConfig = include("QuestDiary/cfgcsv/cfg_QuanQuShouBao.lua") --配置全区首爆
local cost = { {} }
local give = { {} }

FuLiDaTing.Cache = {}

FuLiDaTing.config = {}
local function CopyTable(tab) --深拷贝
    function _copy(obj)
        if type(obj) ~= "table" then
            return obj
        end
        local new_table = {}
        for k, v in pairs(obj) do
            new_table[_copy(k)] = _copy(v)
        end
        return setmetatable(new_table, getmetatable(obj))
    end

    return _copy(tab)
end

for k, v in pairs(FuLiDaTing.configCache) do
    if type(k) == "number" then
        if FuLiDaTing.config[v.type] == nil then
            FuLiDaTing.config[v.type] = {}
        end

        if FuLiDaTing.config[v.type][v.number] == nil then
            local tb = CopyTable(v)
            tb.number = nil
            tb.type = nil
            FuLiDaTing.config[v.type][v.number] = tb
        end
    end
end
--同步数据后打开界面
function FuLiDaTing.SyncResponse(actor)
    --release_print("同步数据后打开界面")
    Message.sendmsg(actor, ssrNetMsgCfg.FuLiDaTing_Submit1, 0, 0, 0, FuLiDaTing.getContentData(actor))
    Message.sendmsg(actor, ssrNetMsgCfg.FuLiDaTing_Submit2, 0, 0, 0, FuLiDaTing.getGeRenShouBaoData(actor))
    Message.sendmsg(actor, ssrNetMsgCfg.FuLiDaTing_Submit3, 0, 0, 0, FuLiDaTing.getGeRenShouShaData(actor))
    Message.sendmsg(actor, ssrNetMsgCfg.FuLiDaTing_OpenUI, 0, 0, 0, nil)
end

--更新数据
function FuLiDaTing.UpdateResponse(actor)
    Message.sendmsg(actor, ssrNetMsgCfg.FuLiDaTing_Submit1, 0, 0, 0, FuLiDaTing.getContentData(actor))
    Message.sendmsg(actor, ssrNetMsgCfg.FuLiDaTing_Submit2, 0, 0, 0, FuLiDaTing.getGeRenShouBaoData(actor))
    Message.sendmsg(actor, ssrNetMsgCfg.FuLiDaTing_Submit3, 0, 0, 0, FuLiDaTing.getGeRenShouShaData(actor))
    Message.sendmsg(actor, ssrNetMsgCfg.FuLiDaTing_Update, 0, 0, 0, nil)
end

--接收请求
function FuLiDaTing.Request(actor, param1, param2)
    local page = tonumber(param1)
    if page == 1 then
        FuLiDaTing.ZaiXian(actor, tonumber(param2))
    elseif page == 2 then
        FuLiDaTing.ShaGuai(actor, tonumber(param2))
    elseif page == 3 then
        FuLiDaTing.ChongJi(actor, tonumber(param2))
    elseif page == 4 then
        FuLiDaTing.GeRenShouBao(actor, tonumber(param2))
    elseif page == 5 then
        FuLiDaTing.GeRenShouSha(actor, tonumber(param2))
    elseif page == 6 then

    elseif page == 7 then
        FuLiDaTing.XunHuan(actor,tonumber(param2))
    end
end

--在线奖励
function FuLiDaTing.ZaiXian(actor, page)
    if page < 1 or page > #FuLiDaTing.config[1] then
        return ""
    end

    local times = getplaydef(actor, VarCfg["J_在线时间"])
    local receive = getplaydef(actor, VarCfg["J_在线时间领取"])
    if receive + 1 ~= page then
        Player.sendmsgEx(actor, "提示#251|:#255|请按顺序领取奖励!")
        return ""
    end
    if times < FuLiDaTing.config[1][page].need then
        Player.sendmsgEx(actor, "提示#251|:#255|在线时间不足无法领取!")
        return ""
    end
    if receive >= #FuLiDaTing.config[1] then
        Player.sendmsgEx(actor, "提示#251|:#255|已经领完所有在线奖励了!")
        return ""
    end

    Player.giveItemByTable(actor, FuLiDaTing.config[1][page].award, page .. "在线奖励领取", 1, true)
    setplaydef(actor, VarCfg["J_在线时间领取"], receive + 1)
    Player.sendmsgEx(actor, "提示#251|:#255|领取成功!")
    local flag = FuLiDaTing.UpdateRedPoint(actor)
    if getplaydef(actor, "N$福利大厅红点") ~= flag then
        setplaydef(actor, "N$福利大厅红点", flag)
    end
    FuLiDaTing.UpdateResponse(actor)
    return ""
end

--每日杀怪
function FuLiDaTing.ShaGuai(actor, page)
    if page < 1 or page > #FuLiDaTing.config[2] then
        return ""
    end

    local num = getplaydef(actor, VarCfg["J_每日杀怪数量"])
    local receive = getplaydef(actor, VarCfg["J_每日杀怪数量领取"])
    if receive + 1 ~= page then
        Player.sendmsgEx(actor, "提示#251|:#255|请按顺序领取奖励!")
        return ""
    end

    if num < FuLiDaTing.config[2][page].need then
        Player.sendmsgEx(actor, "提示#251|:#255|每日杀怪不足无法领取!")
        return ""
    end

    if receive >= #FuLiDaTing.config[2] then
        Player.sendmsgEx(actor, "提示#251|:#255|已经领完所有每日杀怪了!")
        return ""
    end

    Player.giveItemByTable(actor, FuLiDaTing.config[2][page].award, page .. "在线奖励领取", 1, true)
    setplaydef(actor, VarCfg["J_每日杀怪数量领取"], receive + 1)
    Player.sendmsgEx(actor, "提示#251|:#255|领取成功!")
    local flag = FuLiDaTing.UpdateRedPoint(actor)
    if getplaydef(actor, "N$福利大厅红点") ~= flag then
        setplaydef(actor, "N$福利大厅红点", flag)
    end
    FuLiDaTing.UpdateResponse(actor)
    return ""
end

--冲击奖励
function FuLiDaTing.ChongJi(actor, page)
    if page < 1 or page > #FuLiDaTing.config[3] then
        return ""
    end
    local _data = FuLiDaTing.getDengJiJiangLiData(actor)
    if _data[2][page] == 1 then
        Player.sendmsgEx(actor, "提示#251|:#255|你已经领取过该奖励!")
        return ""
    end

    if type(FuLiDaTing.config[3][page].num) == "number" then
        if FuLiDaTing.config[3][page].num - _data[3][page] < 1 then
            Player.sendmsgEx(actor, "提示#251|:#255|该奖励已经被全部领取了!")
            return ""
        end
    end

    if _data[1] < FuLiDaTing.config[3][page].need then
        Player.sendmsgEx(actor, "提示#251|:#255|你的等级不足，无法领取该奖励!")
        return ""
    end
    _data[2][page] = 1
    _data[3][page] = _data[3][page] + 1
    setplaydef(actor, VarCfg["T_等级奖励"], tbl2json(_data[2]))
    setsysvar(VarCfg["A_全区等级奖励"], tbl2json(_data[3]))
    Player.sendmsgEx(actor, "提示#251|:#255|领取成功!")
    Player.giveItemByTable(actor, FuLiDaTing.config[3][page].award, "冲级奖励领取", 1, true)
    local flag = FuLiDaTing.UpdateRedPoint(actor)
    if getplaydef(actor, "N$福利大厅红点") ~= flag then
        setplaydef(actor, "N$福利大厅红点", flag)
    end
    FuLiDaTing.UpdateResponse(actor)
    return ""
end

--个人首爆
function FuLiDaTing.GeRenShouBao(actor, page)
    local idx = tonumber(page)
    local _data = FuLiDaTing.getGeRenShouBaoData(actor)
    local flag = 0
    for i = 1, #FuLiDaTing.geRenShouBaoConfig do
        if getstditeminfo(FuLiDaTing.geRenShouBaoConfig[i].name, 0) == idx then
            flag = i
            break
        end
    end

    if flag == 0 then
        Player.sendmsgEx(actor, "提示#251|:#255|该道具没有首爆奖励!")
        return ""
    end

    if _data[tostring(idx)] == nil then
        Player.sendmsgEx(actor, "提示#251|:#255|请先爆出" .. FuLiDaTing.geRenShouBaoConfig[flag].name .. "!")
        return ""
    end

    if _data[tostring(idx)] == 2 then
        Player.sendmsgEx(actor, "提示#251|:#255|你已经领取过了!")
        return ""
    end

    _data[tostring(idx)] = 2
    if FuLiDaTing.Cache[actor] == nil then
        FuLiDaTing.Cache[actor] = {}
    end

    FuLiDaTing.Cache[actor]["个人首曝"] = _data
    --release_print(tbl2json(FuLiDaTing.Cache[actor]["个人首曝"]),tbl2json(_data))
    setplaydef(actor, VarCfg["T_个人首爆"], tbl2json(_data))
    Player.sendmsgEx(actor, "提示#251|:" .. FuLiDaTing.geRenShouBaoConfig[flag].name .. "#255|领取成功!")
    Player.giveItemByTable(actor, FuLiDaTing.geRenShouBaoConfig[flag].give,
        FuLiDaTing.geRenShouBaoConfig[flag].name .. "个人首爆奖励领取", 1, true)
    FuLiDaTing.UpdateResponse(actor)
    local flag = FuLiDaTing.UpdateRedPoint(actor)
    if getplaydef(actor, "N$福利大厅红点") ~= flag then
        setplaydef(actor, "N$福利大厅红点", flag)
    end
    return ""
end

--个人首杀
function FuLiDaTing.GeRenShouSha(actor, page)
    local idx = tonumber(page)

    local _data = FuLiDaTing.getGeRenShouShaData(actor)
    local flag = 0
    for i = 1, #FuLiDaTing.shouShaConfig do
        if FuLiDaTing.shouShaConfig[i].id == idx then
            flag = i
            break
        end
    end

    if flag == 0 then
        Player.sendmsgEx(actor, "提示#251|:#255|该怪物没有首杀奖励!")
        return ""
    end

    if _data[tostring(idx)] == nil then
        Player.sendmsgEx(actor, "提示#251|:#255|请先击杀" .. FuLiDaTing.shouShaConfig[flag].name .. "!")
        return ""
    end

    if _data[tostring(idx)] == 2 then
        Player.sendmsgEx(actor, "提示#251|:#255|你已经领取过了!")
        return ""
    end

    _data[tostring(idx)] = 2
    setplaydef(actor, VarCfg["T_个人首杀"], tbl2json(_data))
    Player.giveItemByTable(actor, FuLiDaTing.shouShaConfig[flag].give, page .. "在线奖励领取", 1, true)
    FuLiDaTing.UpdateResponse(actor)
    local flag = FuLiDaTing.UpdateRedPoint(actor)
    if getplaydef(actor, "N$福利大厅红点") ~= flag then
        setplaydef(actor, "N$福利大厅红点", flag)
    end
    return ""
end

--循环礼包
function FuLiDaTing.XunHuan(actor,sign)
    -- local flag = FuLiDaTing.UpdateRedPoint(actor)
    -- release_print(flag,getplaydef(actor,"N$福利大厅红点"))
    -- if getplaydef(actor,"N$福利大厅红点") ~= flag then
    --     setplaydef(actor,"N$福利大厅红点",flag)
    -- end
    if FuLiDaTing.config[7][sign] == nil then
        release_print("修改客户端数据")
        return ""
    end
    
    local money = querymoney(actor, 11) ---变量
    if money < FuLiDaTing.config[7][sign].need then
        Player.sendmsgEx(actor, "提示#251|:#255|你的充值积分不足" .. FuLiDaTing.config[7][sign].need .. "!")
        return ""
    end

    changemoney(actor, 11, "-", FuLiDaTing.config[7][sign].need, "领取循环礼包", true)
    Player.giveItemByTable(actor, FuLiDaTing.config[7][sign].award, "领取循环礼包", 1, true)
    Player.sendmsgEx(actor, "提示#251|:#255|领取成功!")
    FuLiDaTing.UpdateResponse(actor)
    local flag = FuLiDaTing.UpdateRedPoint(actor)
    if getplaydef(actor, "N$福利大厅红点") ~= flag then
        setplaydef(actor, "N$福利大厅红点", flag)
    end
    return ""
end

--获得等级奖励数据
function FuLiDaTing.getDengJiJiangLiData(actor)
    local data = { getbaseinfo(actor, 6), {}, {} }
    local lv = getplaydef(actor, VarCfg["T_等级奖励"])
    local all = getsysvar(VarCfg["A_全区等级奖励"])

    if lv == "" then
        data[2] = { 0, 0, 0, 0, 0 }
    else
        data[2] = json2tbl(lv)
    end

    if all == "" then
        data[3] = { 0, 0, 0, 0, 0 }
    else
        data[3] = json2tbl(all)
    end

    return data
end

--获得个人首爆数据
function FuLiDaTing.getGeRenShouBaoData(actor)
    local data = getplaydef(actor, VarCfg["T_个人首爆"])
    if data == "" then
        data = {}
    else
        data = json2tbl(data)
    end

    return data
end

--获得全区首爆数据
function FuLiDaTing.getQuanQuShouBaoData(actor)
    local data = getsysvar(VarCfg["A_全区首爆"])
    if data == "" then
        data = {}
    else
        data = json2tbl(data)
    end
    return data
end

--获取个人首杀数据
function FuLiDaTing.getGeRenShouShaData(actor)
    local data = getplaydef(actor, VarCfg["T_个人首杀"])
    if data == "" then
        data = {}
    else
        data = json2tbl(data)
    end

    return data
end

--客户端数据
function FuLiDaTing.getContentData(actor)
    local data = {}
    data[1] = { getplaydef(actor, VarCfg["J_在线时间"]), getplaydef(actor, VarCfg["J_在线时间领取"]) } --在线时间
    data[2] = { getplaydef(actor, VarCfg["J_每日杀怪数量"]), getplaydef(actor, VarCfg["J_每日杀怪数量领取"]) } --杀怪数量
    data[3] = FuLiDaTing.getDengJiJiangLiData(actor) --等级
    data[4] = {} --FuLiDaTing.getGeRenShouBaoData(actor)        --个人首爆
    data[5] = {} --FuLiDaTing.getGeRenShouShaData(actor)        --个人首杀
    data[6] = FuLiDaTing.getQuanQuShouBaoData(actor) --全区首爆
    data[7] = querymoney(actor, 11) --充值积分
    return data
end

----登录触发
local function _onLoginEnd(actor, logindatas)
    FuLiDaTing.UpdateRedPoint(actor)
    --个人首曝缓存
    FuLiDaTing.onCache(actor)
end

local function _ClearVar(actor)
    FuLiDaTing.Cache[actor] = nil
end
--杀怪触发
local function _onKillMon(actor, monobj, monName)
    --release_print(getplaydef(actor,VarCfg["U_杀怪数量"]))
    local num = getplaydef(actor, VarCfg["J_每日杀怪数量"])
    setplaydef(actor, VarCfg["J_每日杀怪数量"], num + 1)

    if getplaydef(actor, "N$福利大厅红点") == 0 then
        local receive = getplaydef(actor, VarCfg["J_每日杀怪数量领取"])
        if receive < #FuLiDaTing.config[2] then
            if FuLiDaTing.config[2][receive + 1].need <= num + 1 then
                setplaydef(actor, "N$福利大厅红点", 1)
            end
        end
    end

    if FuLiDaTing.shouShaConfig[monName] ~= nil then
        local _data = FuLiDaTing.getGeRenShouShaData(actor)
        local idx = getdbmonfieldvalue(monName, "idx")
        if _data[tostring(idx)] == nil then
            _data[tostring(idx)] = 1
            if getplaydef(actor, "N$福利大厅红点") == 0 then
                setplaydef(actor, "N$福利大厅红点", 1)
            end
            setplaydef(actor, VarCfg["T_个人首杀"], tbl2json(_data))
            Player.sendmsgEx(actor, "提示#251|:#255|获得|" .. monName .. "#249|首杀奖励...")
        end
    end
end
--首曝缓存
function FuLiDaTing.onCache(actor)
    if FuLiDaTing.Cache[actor] == nil then
        FuLiDaTing.Cache[actor] = {}
    end
    FuLiDaTing.Cache[actor]["个人首曝"] = FuLiDaTing.getGeRenShouBaoData(actor)
end

--注册事件

--爆出道具触发
local function _goPickUpItemEx(actor, itemobj, itemID, itemMakeIndex, ItemName)
    if FuLiDaTing.geRenShouBaoConfig[ItemName] ~= nil then
        --release_print(tbl2json(FuLiDaTing.Cache[actor]["个人首曝"]))
        if FuLiDaTing.Cache[actor] == nil then
            --release_print("缓存为空")
            FuLiDaTing.onCache(actor)
        end

        local _data = FuLiDaTing.Cache[actor]["个人首曝"] --FuLiDaTing.getGeRenShouBaoData(actor)
        if _data[tostring(itemID)] == nil then
            _data[tostring(itemID)] = 1
            if getplaydef(actor, "N$福利大厅红点") == 0 then
                setplaydef(actor, "N$福利大厅红点", 1)
            end

            if FuLiDaTing.geRenShouBaoConfig[ItemName].zd == 1 then
                scenevibration(actor, 0, 1, 1)
            end

            FuLiDaTing.Cache[actor]["个人首曝"] = _data
            -- dump(FuLiDaTing.Cache[actor]["个人首曝"])
            setplaydef(actor, VarCfg["T_个人首爆"], tbl2json(_data))
            Player.sendmsgEx(actor, "提示#251|:#255|获得|" .. ItemName .. "#249|首爆奖励...")
        end
    end

    if FuLiDaTing.quanFuShouBaoConfig[ItemName] ~= nil then
        local _data = FuLiDaTing.getQuanQuShouBaoData(actor)
        if _data[tostring(itemID)] == nil then
            local name = getbaseinfo(actor, 1)
            _data[tostring(itemID)] = name
            scenevibration(actor, 0, 1, 1)
            setsysvar(VarCfg["A_全区首爆"], tbl2json(_data))
            --sendmovemsg(actor,1)
            --恭喜***爆出***装备名称 获取首曝奖励***灵符
            sendmail("#" .. name, 1, "全区首爆奖励", "恭喜获得【" .. ItemName .. "】全区首爆奖励",
                FuLiDaTing.quanFuShouBaoConfig[ItemName].give[1][1] ..
                "#" .. FuLiDaTing.quanFuShouBaoConfig[ItemName].give[1][2])
            Player.sendmsgEx(actor, "提示#251|:#255|获得|" .. ItemName .. "#249|全区首爆奖励已发送邮件...")
            sendmovemsg(actor, 1, 251, 0, 100, 1,
                "{【恭喜】：/FCOLOR=250}{【" ..
                name ..
                "】/FCOLOR=249}{成功拾取/FCOLOR=250}{【" ..
                ItemName ..
                "】 获取/FCOLOR=249} {首曝奖励/FCOLOR=250}{" ..
                FuLiDaTing.quanFuShouBaoConfig[ItemName].give[1][2] .. "灵符/FCOLOR=249}")
            sendmovemsg(actor, 1, 251, 0, 130, 1,
                "{【恭喜】：/FCOLOR=250}{【" ..
                name ..
                "】/FCOLOR=249}{成功拾取/FCOLOR=250}{【" ..
                ItemName ..
                "】 获取/FCOLOR=249} {首曝奖励/FCOLOR=250}{" ..
                FuLiDaTing.quanFuShouBaoConfig[ItemName].give[1][2] .. "灵符/FCOLOR=249}")
            sendmovemsg(actor, 1, 251, 0, 160, 1,
                "{【恭喜】：/FCOLOR=250}{【" ..
                name ..
                "】/FCOLOR=249}{成功拾取/FCOLOR=250}{【" ..
                ItemName ..
                "】 获取/FCOLOR=249} {首曝奖励/FCOLOR=250}{" ..
                FuLiDaTing.quanFuShouBaoConfig[ItemName].give[1][2] .. "灵符/FCOLOR=249}")
        end
    end
end
--红点数据
function FuLiDaTing.UpdateRedPoint(actor)
    local num = getplaydef(actor, "N$福利大厅红点")
    --
    local flag = 0
    local data = FuLiDaTing.getContentData(actor)
    --release_print(tbl2json(data))
    if data[1][2] < #FuLiDaTing.config[1] then
        if FuLiDaTing.config[1][data[1][2] + 1].need <= data[1][1] then
            flag = 1
        end
    end
    -- release_print("福利大厅_1_"..flag)
    if flag == 1 then
        setplaydef(actor, "N$福利大厅红点", 1)
        --Message.sendmsg(actor, ssrNetMsgCfg.FuLiDaTing_UpdateRedPoint, 1, 0, 0, nil)
        return flag
    end

    if data[2][2] < #FuLiDaTing.config[2] then
        if FuLiDaTing.config[2][data[2][2] + 1].need <= data[2][1] then
            flag = 1
        end
    end
    -- release_print("福利大厅_2_"..flag)
    if flag == 1 then
        setplaydef(actor, "N$福利大厅红点", 1)
        -- Message.sendmsg(actor, ssrNetMsgCfg.FuLiDaTing_UpdateRedPoint, 1, 0, 0, nil)
        return flag
    end

    for i = 1, #FuLiDaTing.config[3] do
        if type(FuLiDaTing.config[3][i].num) == "number" then
            if data[3][2][i] == 0 then
                if data[3][3][i] < FuLiDaTing.config[3][i].num then
                    if data[3][1] >= FuLiDaTing.config[3][i].need then
                        flag = 1
                        break
                    end
                end
            end
        else
            if data[3][2][i] == 0 then
                if data[3][1] >= FuLiDaTing.config[3][i].need then
                    flag = 1
                    break
                end
            end
        end
    end
    -- release_print("福利大厅_3_"..flag)
    if flag == 1 then
        setplaydef(actor, "N$福利大厅红点", 1)
        --Message.sendmsg(actor, ssrNetMsgCfg.FuLiDaTing_UpdateRedPoint, 1, 0, 0, nil)
        return flag
    end

    data[4] = FuLiDaTing.getGeRenShouBaoData(actor)
    for i = 1, #FuLiDaTing.geRenShouBaoConfig do
        local idx = getstditeminfo(FuLiDaTing.geRenShouBaoConfig[i].name, 0)
        if data[4][tostring(idx)] == 1 then
            flag = 1
            break
        end
    end
    -- release_print("福利大厅_4_"..flag)
    if flag == 1 then
        setplaydef(actor, "N$福利大厅红点", 1)
        --Message.sendmsg(actor, ssrNetMsgCfg.FuLiDaTing_UpdateRedPoint, 1, 0, 0, nil)
        return flag
    end

    data[5] = FuLiDaTing.getGeRenShouShaData(actor)
    for i = 1, #FuLiDaTing.shouShaConfig do
        local idx = FuLiDaTing.shouShaConfig[i].id
        if data[5][tostring(idx)] == 1 then
            flag = 1
            break
        end
    end
    -- release_print("福利大厅_5_"..flag)
    if flag == 1 then
        setplaydef(actor, "N$福利大厅红点", 1)
        --Message.sendmsg(actor, ssrNetMsgCfg.FuLiDaTing_UpdateRedPoint, 1, 0, 0, nil)
        return flag
    end

    if data[7] >= FuLiDaTing.config[7][1].need then
        flag = 1
    end
    -- release_print("福利大厅_7_"..flag)
    if flag == 1 then
        setplaydef(actor, "N$福利大厅红点", 1)
        --Message.sendmsg(actor, ssrNetMsgCfg.FuLiDaTing_UpdateRedPoint, 1, 0, 0, nil)
        return flag
    end

    return flag
end

--升级触发
local function _onLevelUp(actor, cur_level, before_level)
    --release_print("222222")
    --release_print(before_level.."等级"..getplaydef(actor,"N$福利大厅红点"))
    if getplaydef(actor, "N$福利大厅红点") == 0 then
        local data = FuLiDaTing.getDengJiJiangLiData(actor)
        for i = 1, #FuLiDaTing.config[3] do
            if type(FuLiDaTing.config[3][i].num) == "number" then
                if data[2][i] == 0 then
                    if data[3][i] < FuLiDaTing.config[3][i].num then
                        if data[1] >= FuLiDaTing.config[3][i].need then
                            setplaydef(actor, "N$福利大厅红点", 1)
                            break
                        end
                    end
                end
            else
                if data[2][i] == 0 then
                    if data[1] >= FuLiDaTing.config[3][i].need then
                        setplaydef(actor, "N$福利大厅红点", 1)
                        break
                    end
                end
            end
        end
    end
    --release_print("2222221")
end
--充值积分改变
local function _OverloadMoneyJiFen(actor, num)
    if getplaydef(actor, "N$福利大厅红点") == 0 then
        -- release_print(num,FuLiDaTing.config[7][1].need)
        if num > FuLiDaTing.config[7][1].need then
            setplaydef(actor, "N$福利大厅红点", 1)
        end
    end
end

local function _onTimer104(actor)
    --release_ptint("_onTimer104")
    --release_print("定时器进入_onTimer104")
    if getplaydef(actor, "N$福利大厅红点") == 0 then
        local data = { getplaydef(actor, VarCfg["J_在线时间"]), getplaydef(actor, VarCfg["J_在线时间领取"]) }
        if data[2] < #FuLiDaTing.config[1] then
            if FuLiDaTing.config[1][data[2] + 1].need <= data[1] then
                setplaydef(actor, "N$福利大厅红点", 1)
            end
        end
    end
end

-- --事件派发
GameEvent.add(EventCfg.onExitGame, _ClearVar, FuLiDaTing)
GameEvent.add(EventCfg.onTriggerChat, _ClearVar, FuLiDaTing)
GameEvent.add(EventCfg.onTimer104, _onTimer104, FuLiDaTing)
GameEvent.add(EventCfg.OverloadMoneyJiFen, _OverloadMoneyJiFen, FuLiDaTing)
GameEvent.add(EventCfg.onPlayLevelUp, _onLevelUp, FuLiDaTing)
GameEvent.add(EventCfg.goPickUpItemEx, _goPickUpItemEx, FuLiDaTing)
GameEvent.add(EventCfg.onKillMon, _onKillMon, FuLiDaTing)
GameEvent.add(EventCfg.onLoginEnd, _onLoginEnd, FuLiDaTing)
--注册网络消息
Message.RegisterNetMsg(ssrNetMsgCfg.FuLiDaTing, FuLiDaTing)
return FuLiDaTing

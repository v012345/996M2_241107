local ChongZhiZhongXin = {}
local config = include("QuestDiary/cfgcsv/cfg_ChongZhiZhongXin.lua")

function ChongZhiZhongXin.Request1(actor, PayWay ,Sum)
    if Sum % 1 ~= 0 then return end

    if Sum < 10 then
        Player.sendmsgEx(actor, "提示#251|:#255|最低充值|10元#249|,请重新输入...")
        return
    end
    pullpay(actor,Sum,PayWay,7)
end

local function CheckAwardState(actor)
    local Num = 0
    for i = 1, 8 do
        local bool = getflagstatus(actor, VarCfg["F_首充翻倍标识_".. i ..""])
        Num = Num + bool
    end
    if Num < 8 then return   end
    confertitle(actor, "至尊玩家", 1)
end

-- 支付方式，礼包编号，支付金额
function ChongZhiZhongXin.Request2(actor,PayWay,Sort,Sum)
    local bool = getflagstatus(actor, VarCfg["F_首充翻倍标识_".. Sort ..""])
    local JiFenNum = getplaydef(actor, VarCfg["U_换购积分"])
    local cfg = config[Sort]
    if bool == 0  then
        if JiFenNum >= cfg.Sum then
            setflagstatus(actor, VarCfg["F_首充翻倍标识_".. Sort ..""], 1)
            local JiFenNum = getplaydef(actor, VarCfg["U_换购积分"])
            JiFenNum = JiFenNum - cfg.Sum
            setplaydef(actor, VarCfg["U_换购积分"], JiFenNum)
            local award = cfg.award
            local JieShao = ""
            local JiangLi = ""
            for i, v in ipairs(award) do
                if i >= 2 then
                    JieShao = JieShao .. "\\获得"..v[1].."x"..v[2]
                end
            end

            for i, v in ipairs(award) do
                if i >= 2 then
                    JiangLi = JiangLi .. "".. v[1] .."#"..v[2].."#51&"
                end
            end
            local UserId = getconst(actor, "<$USERID>")
            sendmail(UserId, 5001, cfg.Sum.."元充值礼包",JieShao,JiangLi)
            Player.sendmsgEx(actor, "提示#251|:#255|恭喜你,领取|"..  cfg.Sum .."元充值礼包#249|,祝您游戏愉快...")
            ChongZhiZhongXin.SyncResponse(actor)
            CheckAwardState(actor)
        else
            pullpay(actor,Sum,PayWay,7)
        end
    else
        pullpay(actor,Sum,PayWay,7)
    end
    -- release_print("支付方式",PayWay)
    -- release_print("礼包编号",Sort)
    -- release_print("支付金额",Sum)
end

--注册网络消息
function ChongZhiZhongXin.SyncResponse(actor, logindatas)
    local data = { }
    for i = 1, 8 do
        local num = getflagstatus(actor, VarCfg["F_首充翻倍标识_".. i ..""])
        table.insert(data, num)
    end
    local JiFenNum = getplaydef(actor, VarCfg["U_换购积分"])
    table.insert(data, JiFenNum)
    local LeiJiChongZhi = getplaydef(actor, VarCfg["U_真实充值"])
    table.insert(data, LeiJiChongZhi)

    local _login_data = { ssrNetMsgCfg.ChongZhiZhongXin_SyncResponse, 0, 0, 0, data }
    if logindatas then
        table.insert(logindatas, _login_data)
    else
        Message.sendmsg(actor, ssrNetMsgCfg.ChongZhiZhongXin_SyncResponse, 0, 0, 0, data)
    end
end
Message.RegisterNetMsg(ssrNetMsgCfg.ChongZhiZhongXin, ChongZhiZhongXin)

-- 充值回调
-- gold: 充值货币货币数量
-- moneyid: 充值货币类型
-- 7	灵符
-- 20	绑定灵符
local function _onRecharge(actor, gold, productid, moneyid)
    if moneyid ~= 7 and moneyid ~= 20 then return end
    -- local name = getbaseinfo(actor, ConstCfg.gbase.name)
    -- sendmsg(actor, 1, '{"Msg":"<font color=\'#ff0000\'>玩家'.. name ..'。。。</font>","Type":9}')
    -- sendmsg(actor, 1, '{"Msg":"<font color=\'#ff0000\'>货币'.. moneyid ..'。。。</font>","Type":9}')
    -- sendmsg(actor, 1, '{"Msg":"<font color=\'#ff0000\'>数量'.. gold ..'。。。</font>","Type":9}')
    -- sendmsg(actor, 1, '{"Msg":"<font color=\'#ff0000\'>NPC'.. productid ..'。。。</font>","Type":9}')
    changemoney(actor, 11, "+", gold, "充值回调增加", true)
    --------------增加每日充值--------------
    local RiChongNum = getplaydef(actor, VarCfg["J_日冲记录"])
    RiChongNum = RiChongNum + gold
    setplaydef(actor, VarCfg["J_日冲记录"], RiChongNum)
    --------------增加真实充值--------------
    local LeiJiChongZhi = getplaydef(actor, VarCfg["U_真实充值"])
    LeiJiChongZhi = LeiJiChongZhi + gold
    setplaydef(actor, VarCfg["U_真实充值"], LeiJiChongZhi)
    --------------增加礼包积分--------------
    if not checktitle(actor, "至尊玩家") then
        local JiFenNum = getplaydef(actor, VarCfg["U_换购积分"])
        JiFenNum = JiFenNum + gold
        setplaydef(actor, VarCfg["U_换购积分"], JiFenNum)
    end

    local OnTheList = false
    local AwardInfo = {}
    for i, v in ipairs(config) do
        if gold == v.Sum then
            local num = getflagstatus(actor, VarCfg["F_首充翻倍标识_".. i ..""])
            if num == 0 then
                setflagstatus(actor, VarCfg["F_首充翻倍标识_".. i ..""], 1)
                OnTheList = true
                AwardInfo = v
                ChongZhiZhongXin.SyncResponse(actor)
                break
            end
        end
    end

    if OnTheList then
        local JiFenNum = getplaydef(actor, VarCfg["U_换购积分"])
        JiFenNum = JiFenNum - AwardInfo.Sum
        setplaydef(actor, VarCfg["U_换购积分"], JiFenNum)
        local award = AwardInfo.award
        local JieShao = ""
        local JiangLi = ""

        for i, v in ipairs(award) do
            if i >= 2 then
                JieShao = JieShao .. "\\获得"..v[1].."x"..v[2]
            end
        end

        for i, v in ipairs(award) do
            if i >= 2 then
                JiangLi = JiangLi .. "".. v[1] .."#"..v[2].."#51&"
            end
        end

        local UserId = getconst(actor, "<$USERID>")
        sendmail(UserId, 5001, AwardInfo.Sum.."元充值礼包",JieShao,JiangLi)
        Player.sendmsgEx(actor, "提示#251|:#255|恭喜你,领取|"..  AwardInfo.Sum .."元充值礼包#249|,祝您游戏愉快...")
        ChongZhiZhongXin.SyncResponse(actor)
        CheckAwardState(actor)
    end
    ChongZhiZhongXin.SyncResponse(actor)
    GameEvent.push(EventCfg.onRechargeEnd, actor)

end
GameEvent.add(EventCfg.onRecharge, _onRecharge, ChongZhiZhongXin)

--登录触发
local function _onLoginEnd(actor, logindatas)
    ChongZhiZhongXin.SyncResponse(actor, logindatas)
end
GameEvent.add(EventCfg.onLoginEnd, _onLoginEnd, ChongZhiZhongXin)

-- 杀怪触发 怪物猎人  每杀10只怪物永久增加1点切割。 
local function _onKillMon(actor, monobj)
    if checktitle(actor, "怪物猎人") then
        local KillMonNum = getplaydef(actor, VarCfg["N$怪物猎人_杀怪计数"])
        KillMonNum = KillMonNum + 1
        setplaydef(actor, VarCfg["N$怪物猎人_杀怪计数"], KillMonNum)
        if KillMonNum >= 10  then
            setplaydef(actor, VarCfg["N$怪物猎人_杀怪计数"], 0)
            local num = getplaydef(actor, VarCfg["U_怪物猎人层数"])
            num = num + 1
            setplaydef(actor, VarCfg["U_怪物猎人层数"], num)
            setaddnewabil(actor,12,"=","3#200#".. num .."")
        end
    end
end
GameEvent.add(EventCfg.onKillMon, _onKillMon, ChongZhiZhongXin)



return ChongZhiZhongXin

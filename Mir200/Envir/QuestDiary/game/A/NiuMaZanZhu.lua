local NiuMaZanZhu = {}
local Title_Data  = {{title = "白银赞助",num = 0},{title = "黄金赞助",num = 38},{title = "至尊赞助",num = 68},}

function NiuMaZanZhu.Request(actor, var)
    local LeiChong = getplaydef(actor, VarCfg["U_真实充值"])
    local cfg = Title_Data[var]
    if not cfg then
        return
    end
    if checktitle(actor, "至尊赞助") then return end
    if checktitle(actor, cfg.title) then
        Player.sendmsgEx(actor, "提示#251|:#255|你已领取过|".. cfg.title .."#249|请勿重复领取...")
        return
    end
    if  LeiChong < cfg.num  then
        Player.sendmsgEx(actor, "提示#251|:#255|对不起,你的|累计充值#249|不足|".. cfg.num .."#249|领取失败...")
        return
    end

    if checktitle(actor, "白银赞助") then deprivetitle(actor, "白银赞助") end
    if checktitle(actor, "黄金赞助") then deprivetitle(actor, "黄金赞助") end
    confertitle(actor, cfg.title)
    Player.sendmsgEx(actor, "提示#251|:#255|恭喜你,领取|".. cfg.title .."#249|成功...")
    NiuMaZanZhu.SyncResponse(actor)


    if getplaydef(actor, "N$牛马赞助红点") == 1 then
        local flag = 0

        if var < 3 then
            if LeiChong >= Title_Data[var+1].num then
                flag = 1
            else
                flag = 0
            end
        end

        if flag == 0 then
            setplaydef(actor, "N$牛马赞助红点", flag)
            Message.sendmsg(actor, ssrNetMsgCfg.NiuMaZanZhu_AddRedPoint, flag, 0, 0, {})
        end
    end

    if var > 2 then
        local skill = getskillinfo(actor, 75, 3)
        if not skill then
            addskill(actor, 75, 3)
        end
        TopIcon.addico(actor)
    end
end

--注册网络消息
function NiuMaZanZhu.SyncResponse(actor, logindatas)
    local TitleNum = 0
    if checktitle(actor, "白银赞助") then
        TitleNum = 1
    elseif checktitle(actor, "黄金赞助") then
        TitleNum = 2
    elseif checktitle(actor, "至尊赞助") then
        TitleNum = 3
    end

    local _login_data = { ssrNetMsgCfg.NiuMaZanZhu_SyncResponse, 0, 0, 0, {TitleNum}}
    if logindatas then
        table.insert(logindatas, _login_data)
    else
        Message.sendmsg(actor, ssrNetMsgCfg.NiuMaZanZhu_SyncResponse, 0, 0, 0, {TitleNum})
    end
end

Message.RegisterNetMsg(ssrNetMsgCfg.NiuMaZanZhu, NiuMaZanZhu)

local function _onRechargeEnd(actor)
    local reveive = getplaydef(actor, "N$牛马赞助红点")
    if reveive == 0 then
        local TitleNum = 0
        if checktitle(actor, "白银赞助") then
            TitleNum = 1
        elseif checktitle(actor, "黄金赞助") then
            TitleNum = 2
        elseif checktitle(actor, "至尊赞助") then
            TitleNum = 3
        end

        local money = getplaydef(actor, VarCfg["U_真实充值"])
        local flag = 0

        if TitleNum < 3 and getplaydef(actor, "N$牛马赞助红点") == 0 then
            if money >= Title_Data[TitleNum+1].num then
                flag = 1
            end
        end

        if flag > 0 then
            setplaydef(actor, "N$牛马赞助红点", 1)
            Message.sendmsg(actor, ssrNetMsgCfg.NiuMaZanZhu_AddRedPoint, 1, 0, 0, {})
        else
            setplaydef(actor, "N$牛马赞助红点", 0)
            Message.sendmsg(actor, ssrNetMsgCfg.NiuMaZanZhu_AddRedPoint, 0, 0, 0, {})
        end
    end
end

GameEvent.add(EventCfg.onRechargeEnd, _onRechargeEnd,NiuMaZanZhu)

--登录触发
local function _onLoginEnd(actor, logindatas)
    NiuMaZanZhu.SyncResponse(actor, logindatas)
    
    if checktitle(actor, "黄金赞助") or checktitle(actor, "至尊赞助") then
        local skill = getskillinfo(actor, 75, 3)
        if not skill then
            addskill(actor, 75, 3)
        end
    end

    delaygoto(actor,500,"niumazanzhu_init_redpoint")
end

function niumazanzhu_init_redpoint(actor)
    _onRechargeEnd(actor)
end

GameEvent.add(EventCfg.onLoginEnd, _onLoginEnd, NiuMaZanZhu)

return NiuMaZanZhu
local NiuMaZanZhu = {}
local Title_Data  = {{title = "��������",num = 0},{title = "�ƽ�����",num = 38},{title = "��������",num = 68},}

function NiuMaZanZhu.Request(actor, var)
    local LeiChong = getplaydef(actor, VarCfg["U_��ʵ��ֵ"])
    local cfg = Title_Data[var]
    if not cfg then
        return
    end
    if checktitle(actor, "��������") then return end
    if checktitle(actor, cfg.title) then
        Player.sendmsgEx(actor, "��ʾ#251|:#255|������ȡ��|".. cfg.title .."#249|�����ظ���ȡ...")
        return
    end
    if  LeiChong < cfg.num  then
        Player.sendmsgEx(actor, "��ʾ#251|:#255|�Բ���,���|�ۼƳ�ֵ#249|����|".. cfg.num .."#249|��ȡʧ��...")
        return
    end

    if checktitle(actor, "��������") then deprivetitle(actor, "��������") end
    if checktitle(actor, "�ƽ�����") then deprivetitle(actor, "�ƽ�����") end
    confertitle(actor, cfg.title)
    Player.sendmsgEx(actor, "��ʾ#251|:#255|��ϲ��,��ȡ|".. cfg.title .."#249|�ɹ�...")
    NiuMaZanZhu.SyncResponse(actor)


    if getplaydef(actor, "N$ţ���������") == 1 then
        local flag = 0

        if var < 3 then
            if LeiChong >= Title_Data[var+1].num then
                flag = 1
            else
                flag = 0
            end
        end

        if flag == 0 then
            setplaydef(actor, "N$ţ���������", flag)
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

--ע��������Ϣ
function NiuMaZanZhu.SyncResponse(actor, logindatas)
    local TitleNum = 0
    if checktitle(actor, "��������") then
        TitleNum = 1
    elseif checktitle(actor, "�ƽ�����") then
        TitleNum = 2
    elseif checktitle(actor, "��������") then
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
    local reveive = getplaydef(actor, "N$ţ���������")
    if reveive == 0 then
        local TitleNum = 0
        if checktitle(actor, "��������") then
            TitleNum = 1
        elseif checktitle(actor, "�ƽ�����") then
            TitleNum = 2
        elseif checktitle(actor, "��������") then
            TitleNum = 3
        end

        local money = getplaydef(actor, VarCfg["U_��ʵ��ֵ"])
        local flag = 0

        if TitleNum < 3 and getplaydef(actor, "N$ţ���������") == 0 then
            if money >= Title_Data[TitleNum+1].num then
                flag = 1
            end
        end

        if flag > 0 then
            setplaydef(actor, "N$ţ���������", 1)
            Message.sendmsg(actor, ssrNetMsgCfg.NiuMaZanZhu_AddRedPoint, 1, 0, 0, {})
        else
            setplaydef(actor, "N$ţ���������", 0)
            Message.sendmsg(actor, ssrNetMsgCfg.NiuMaZanZhu_AddRedPoint, 0, 0, 0, {})
        end
    end
end

GameEvent.add(EventCfg.onRechargeEnd, _onRechargeEnd,NiuMaZanZhu)

--��¼����
local function _onLoginEnd(actor, logindatas)
    NiuMaZanZhu.SyncResponse(actor, logindatas)
    
    if checktitle(actor, "�ƽ�����") or checktitle(actor, "��������") then
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
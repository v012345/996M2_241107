local XingYunDaFuWeng = {}
XingYunDaFuWeng.ID = "���˴���"
local npcID = 158
--local config = include("QuestDiary/cfgcsv/cfg_XingYunDaFuWeng.lua") --����

local GiveData = { [5]  = {"�����ʯ", 5},[10] = {"ʥ������", 5},[15] = {"ʥ��������", 3},[20] = {"ʥ������", 10},[25] = {"ʥ��������", 3},[30] = {"ʥ������", 15},[35] = {"ʥ��������", 3},
                   [40] = {"ʥ������", 20},[45] = {"ʥ��������", 3},[50] = {"�������", 1}}

local NumData = {50000, 100000, 200000, 300000, 400000, 500000}
--��ȡ����
function XingYunDaFuWeng.getVariableState(actor)
    local num1 = getplaydef(actor, VarCfg["J_���̴���"])
    local num2 = getplaydef(actor, VarCfg["J_����λ��"])

    if num2 == 0 then
        setplaydef(actor, VarCfg["J_����λ��"], 1)
        num2 = getplaydef(actor, VarCfg["J_����λ��"])
    end
    return num1, num2
end

function fa_fang_jiang_li(actor,var)
    local var = tonumber(var)
    if GiveData[var] then
       giveitem(actor, GiveData[var][1], GiveData[var][2], ConstCfg.binding, "���̸���")
       Player.sendmsgEx(actor, "��ʾ#251|:#255|��ϲ��,���|".. GiveData[var][1] .."#249|����|x".. GiveData[var][2] .."#249|...")
    end
end

function checkitemex(actor)
    local time1 = getplaydef(actor, "N$����ʱ���")
    local time2 = os.time()
    if time1 == 0 then
        return true
    end

    if time2 - time1 >= 3 then
        return true
    else
        return false
    end
end



function XingYunDaFuWeng.Request(actor, var)
    
    if not checkitemex(actor) then
        Player.sendmsgEx(actor,"[��ʾ]:#251|�����ƶ���,��ȴ�����...")
        return
    end


    local num1, num2 = XingYunDaFuWeng.getVariableState(actor)
    if num2 >= 50 then
        Player.sendmsgEx(actor,"[��ʾ]:#251|������Ѿ�|�����յ�#249|����������...")
        return
    end
    --��ͨ����
    if var == 1 then
        if num1 >= 5 then
            local _num = num1 - 5 + 1
            local num = (_num >= 6 and 6) or _num
            local CostNum = NumData[num]
            local cost = {{"Ԫ��", CostNum}}

            local ItemName, ItemNum = Player.checkItemNumByTable(actor, cost)
            if ItemName then
                Player.sendmsgEx(actor, string.format("[��ʾ]:#251|�Բ���,���|%s#249|����|%dö#249|Ͷ��ʧ��...", ItemName, ItemNum))
                return
            end
            Player.takeItemByTable(actor, cost, "��������")

            setplaydef(actor, VarCfg["J_���̴���"], num1 + 1)
            local Steps = math.random(1, 6) --����
            -- local Steps = 4 --����
            local site = (num2 + Steps >= 50 and 50) or num2 + Steps
            setplaydef(actor, VarCfg["J_����λ��"], site)
            Message.sendmsg(actor, ssrNetMsgCfg.XingYunDaFuWeng_PlayAnimation, num2, site, Steps, nil)
            XingYunDaFuWeng.SyncResponse(actor)
            delaygoto(actor, 3000, "fa_fang_jiang_li,"..site)
            setplaydef(actor, "N$����ʱ���", os.time())
        else
            num1 = num1 + 1
            setplaydef(actor, VarCfg["J_���̴���"], num1)
            local Steps = math.random(1, 6) --����
            -- local Steps = 4 --����
            local site = (num2 + Steps >= 50 and 50) or num2 + Steps
            setplaydef(actor, VarCfg["J_����λ��"], site)
            Message.sendmsg(actor, ssrNetMsgCfg.XingYunDaFuWeng_PlayAnimation, num2, site, Steps, nil)
            XingYunDaFuWeng.SyncResponse(actor)
            delaygoto(actor, 3000, "fa_fang_jiang_li,"..site)
            setplaydef(actor, "N$����ʱ���", os.time())
        end
    end

    --������
    if var == 2 then
        if querymoney(actor, 7) < 200 then
            Player.sendmsgEx(actor,"[��ʾ]:#251|�Բ���,���|�ǰ����#249|����|200ö#249|Ͷ��ʧ��...")
            return
        end
        changemoney(actor, 7, "-", 200, "�����������", true)
        local Steps = 6 --����
        local site = (num2 + Steps >= 50 and 50) or num2 + Steps
        setplaydef(actor, VarCfg["J_����λ��"], site)
        Message.sendmsg(actor, ssrNetMsgCfg.XingYunDaFuWeng_PlayAnimation, num2, site, Steps, nil)
        XingYunDaFuWeng.SyncResponse(actor)
        delaygoto(actor, 3000, "fa_fang_jiang_li,"..site)
        setplaydef(actor, "N$����ʱ���", os.time())
    end
end


--ͬ����Ϣ
function XingYunDaFuWeng.SyncResponse(actor, logindatas)
    local num1, num2 = XingYunDaFuWeng.getVariableState(actor)
    local _login_data = {ssrNetMsgCfg.XingYunDaFuWeng_SyncResponse, 0, 0, 0, {num1, num2}}
    if logindatas then
        table.insert(logindatas, _login_data)
    else
        Message.sendmsg(actor, ssrNetMsgCfg.XingYunDaFuWeng_SyncResponse, 0, 0, 0, {num1, num2})
    end
end

--��¼����
local function _onLoginEnd(actor, logindatas)
    XingYunDaFuWeng.SyncResponse(actor, logindatas)
end
GameEvent.add(EventCfg.onLoginEnd, _onLoginEnd, XingYunDaFuWeng)

--0:0:10 �µ�һ�촥��
local function _onNewDay(actor)
    XingYunDaFuWeng.SyncResponse(actor)
end
GameEvent.add(EventCfg.onNewDay, _onNewDay, XingYunDaFuWeng)


--ע��������Ϣ
Message.RegisterNetMsg(ssrNetMsgCfg.XingYunDaFuWeng, XingYunDaFuWeng)
return XingYunDaFuWeng
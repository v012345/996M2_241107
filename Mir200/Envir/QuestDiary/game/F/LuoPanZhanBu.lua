local LuoPanZhanBu = {}
local cost = {{"���", 200}}
--ȡ���ƺŽ������
function AddATitleFunc(actor, ConferTitleName)
    if not checktitle(actor, ConferTitleName) then
        confertitle(actor, ConferTitleName)
        changetitletime(actor, ConferTitleName, "=", os.time() + 21600)
        if ConferTitleName ==  "�������̡�˺��" then
            Player.setAttList(actor, "���Ը���")
        elseif ConferTitleName ==  "�������̡�ף��" then
            Player.setAttList(actor, "���ʸ���")
        elseif ConferTitleName ==  "�������̡��ٶ�" then
            Player.setAttList(actor, "���ٸ���")
        end
    end
    Player.sendmsgEx(actor, "��ʾ#251|:#255|��ϲ��,ռ����|".. ConferTitleName .."#249|��,����|+1#249|...") 
    --------------------------------------����Ƿ�ȫ��������--------------------------------------
    if LuoPanZhanBu.CheckTitle(actor) then
        local Type = {"ף��","�ٶ�","����","����","ŭ��","����","�ƻ�","��ɱ","��͸","˺��"}
        for _, v in ipairs(Type) do
            deprivetitle(actor, "�������̡�"..v)
        end
        confertitle(actor, "�������̡��ƿ���")
        Player.setAttList(actor, "���Ը���")
        Player.setAttList(actor, "���ʸ���")
        Player.setAttList(actor, "���ٸ���")
    end
    --------------------------------------����Ƿ�ȫ��������--------------------------------------
    LuoPanZhanBu.SyncResponse(actor) --ͨ��ǰ��
end

function LuoPanZhanBu.Request(actor, var)
    if checktitle(actor, "�������̡��ƿ���") then
        Player.sendmsgEx(actor, "��ʾ#251|:#255|���Ѿ���|�����ƿ���#249|��,����ռ����...")
        return
    end
    local CiShu = getplaydef(actor,VarCfg["J_��������ÿ�����1��"])
    if CiShu >= 1 then
        local name, num = Player.checkItemNumByTable(actor, cost)
        if name then
            Player.sendmsgEx(actor, string.format("��ʾ#251|:#255|���|%s#249|����|%d#249|ö,ռ��ʧ��...", name, num))
            return
        end
        Player.takeItemByTable(actor, cost, "�۳�ռ���ķ���")
    end
    setplaydef(actor,VarCfg["J_��������ÿ�����1��"],CiShu+1)

    local ZhanBuTbl = Player.getJsonTableByVar(actor, VarCfg["T_����ռ����¼"])
    local Type = {"ף��","�ٶ�","����","����","ŭ��","����","�ƻ�","��ɱ","��͸","˺��"}
    local FinalTypeTbl = {}
    local NewType = {}
    for _, v in ipairs(Type) do
        local TypeNum = (ZhanBuTbl[v] == "" and 0) or ZhanBuTbl[v]  or 0
        if TypeNum < 66 then
            table.insert(NewType, v)
        end
    end
    if #NewType == 0 then return end  --û�пɱ�����Ϊȫ�����Ѿ��ﵽ66��
    if #NewType == 10 then --10��δ�ﵽ66��
        local NewTbl = {}
        for _, v in pairs(Type) do
            if not checktitle(actor, "�������̡�".. v .."") then
                table.insert(NewTbl, v)
            end
        end
        if #NewTbl > 0 then
            FinalTypeTbl = NewTbl
        else
            FinalTypeTbl = NewType
        end
    else   --�дﵽ66��
        FinalTypeTbl = NewType
    end

    local num = math.random(1, #FinalTypeTbl)
    local TypeName = FinalTypeTbl[num]
    local TypeNum = (ZhanBuTbl[TypeName] == "" and 0) or ZhanBuTbl[TypeName]  or 0
    ZhanBuTbl[TypeName] = TypeNum + 1
    Player.setJsonVarByTable(actor, VarCfg["T_����ռ����¼"],ZhanBuTbl)
    local ConferTitleName = "�������̡�"..FinalTypeTbl[num]
    AddATitleFunc(actor, ConferTitleName)  --ִ����ӳƺź���
end

--��������
local function _onCalcAttackSpeed(actor, attackSpeeds)
    if checktitle(actor,"�������̡��ƿ���") or checktitle(actor,"�������̡��ٶ�") then
        attackSpeeds[1] = attackSpeeds[1] + 50
    end
end
GameEvent.add(EventCfg.onCalcAttackSpeed, _onCalcAttackSpeed, LuoPanZhanBu)

function LuoPanZhanBu.CheckTitle(actor)
    local ZhanBuTbl = Player.getJsonTableByVar(actor, VarCfg["T_����ռ����¼"])
    local Type = {"ף��","�ٶ�","����","����","ŭ��","����","�ƻ�","��ɱ","��͸","˺��"}
    local TitleBool = true
    for _, v in ipairs(Type) do
        local TypeNum = (ZhanBuTbl[v] == "" and 0) or ZhanBuTbl[v]  or 0
        if TypeNum < 66 then
            TitleBool = false
        end
    end
    return TitleBool
end
--ע��������Ϣ
function LuoPanZhanBu.SyncResponse(actor, logindatas)
    local ZhanBuTbl = Player.getJsonTableByVar(actor, VarCfg["T_����ռ����¼"])
    local Type = {"ף��","�ٶ�","����","����","ŭ��","����","�ƻ�","��ɱ","��͸","˺��"}
    local NewTbl = {}
    for _, v in ipairs(Type) do
        local Num = (ZhanBuTbl[v] == "" and 0) or ZhanBuTbl[v]  or 0
        table.insert(NewTbl, Num)
    end
    Message.sendmsg(actor, ssrNetMsgCfg.LuoPanZhanBu_SyncResponse, 0, 0, 0, NewTbl)
end
Message.RegisterNetMsg(ssrNetMsgCfg.LuoPanZhanBu, LuoPanZhanBu)

return LuoPanZhanBu



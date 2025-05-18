HunYuanGongFa = {}

local config = include("QuestDiary/cfgcsv/cfg_HunYuanGongFa.lua")     --��Ԫ����
local TianMingFunc = include("QuestDiary/game/A/TianMingFunc.lua")

function HunYuanGongFa.checkskilllevel(actor)
    local state = false
    local QiangHua = {}
    QiangHua.GongSha = getskilllevelup(actor,7)
    QiangHua.CiSha   = getskilllevelup(actor,12)
    QiangHua.BanYue  = getskilllevelup(actor,25)
    QiangHua.LieHuo  = getskilllevelup(actor,26)
    QiangHua.KaiTian = getskilllevelup(actor,66)
    QiangHua.ZhuRi   = getskilllevelup(actor,56)
    for index, value in pairs(QiangHua) do
        if value < 10 then
            state = true
            break
        end
    end
    return state
end

function HunYuanGongFa.Request(actor, arg1)
    setflagstatus(actor,VarCfg["F_�˽��Ԫ�������"],1)
    if HunYuanGongFa.checkskilllevel(actor) then
        Player.sendmsgEx(actor, "��ʾ#251|:#255|�Բ���,���|����ǿ��#249|û��ȫ������|10#249|��,�޷�����...")
        return
    end

    local checklevel = getplaydef(actor,VarCfg["U_��Ԫ�����ȼ�"])
    local cfg = config[arg1*10]

    if not cfg then
        Player.sendmsgEx(actor, "��������!")
        return
    end

    if checklevel >= arg1*10 then
        Player.sendmsgEx(actor, "��ʾ#251|:#255|�Բ���,���|"..cfg.namelooks.."#249|�Ѿ�������|10#249|����,�޷�����ǿ��...")
        return
    end
    local name, num = Player.checkItemNumByTable(actor, cfg.cost)
    if name then
        Player.sendmsgEx(actor, string.format("[��ʾ]:#251|���|%s#249|����|%d#249|ö,����ʧ��...", name, num))
        return
    end
    Player.takeItemByTable(actor,cfg.cost,"����������ϼ������")
    setplaydef(actor,VarCfg["U_��Ԫ�����ȼ�"],checklevel+1)

    if (checklevel+1) >= 60 then
        TianMingFunc[49](actor,1)
    end
  
    if getplaydef(actor,VarCfg["U_��Ԫ�����ȼ�"]) == arg1*10 then
        local Skillid = nil
        Skillid = getskillindex(config[arg1*10].skillName)
        addskill(actor, Skillid, 3)
        if cfg.skillName == "��֮����" or cfg.skillName == "����֮��"    then
            local Skillidx = (cfg.skillName == "����֮��" and 56) or (cfg.skillName == "��֮����" and 66)
            setskillinfo(actor, Skillidx, 2, 11)
        end
    end
    HunYuanGongFa.SyncResponse(actor)
    Player.setAttList(actor, "���Ը���")
end

function HunYuanGongFa.Open(actor)
    local flag = getflagstatus(actor,VarCfg["F_�˽��Ԫ����"])
    if  flag == 0 then
        setflagstatus(actor,VarCfg["F_�˽��Ԫ�������"],1)
        local taskPanelID = getplaydef(actor, VarCfg["U_��������������"])
        if taskPanelID == 22 then
            FCheckTaskRedPoint(actor)
        end
    end
end
--ע��������Ϣ
Message.RegisterNetMsg(ssrNetMsgCfg.HunYuanGongFa, HunYuanGongFa)

function HunYuanGongFa.SyncResponse(actor, logindatas)
    local zsjxFlag = getflagstatus(actor,VarCfg["F_����_������ޱ�ʶ"])
    local huyuanlevel = getplaydef(actor,VarCfg["U_��Ԫ�����ȼ�"])
    local data = {huyuanlevel}
    local _login_data = {ssrNetMsgCfg.HunYuanGongFa_SyncResponse, zsjxFlag, 0, 0, data}
    if logindatas then
        table.insert(logindatas, _login_data)
    else
        Message.sendmsg(actor, ssrNetMsgCfg.HunYuanGongFa_SyncResponse, zsjxFlag, 0, 0, data)
    end
end

local function _onCalcAttr(actor,attrs)
    local level = getplaydef(actor,VarCfg["U_��Ԫ�����ȼ�"])
    local atts = {}
    local zsjxFlag = getflagstatus(actor,VarCfg["F_����_������ޱ�ʶ"])
    if level > 0 then
        if zsjxFlag == 0 then
            for i = 1, level, 1 do                
                for j,v in ipairs(config[i].attr) do
                    if not atts[v[1]] then
                        atts[v[1]] = v[2]
                    else
                        atts[v[1]] = atts[v[1]] + v[2]
                    end
                end
            end
        else
            for i = 1, level, 1 do                
                for j,v in ipairs(config[i].attr2) do
                    if not atts[v[1]] then
                        atts[v[1]] = v[2]
                    else
                        atts[v[1]] = atts[v[1]] + v[2]
                    end
                end
            end
        end
    end
    calcAtts(attrs,atts,"��Ԫ����")
end

GameEvent.add(EventCfg.onCalcAttr, _onCalcAttr, HunYuanGongFa)


--��¼����
local function _onLoginEnd(actor, logindatas)
    HunYuanGongFa.SyncResponse(actor, logindatas)
end
GameEvent.add(EventCfg.onLoginEnd, _onLoginEnd, HunYuanGongFa)

return HunYuanGongFa


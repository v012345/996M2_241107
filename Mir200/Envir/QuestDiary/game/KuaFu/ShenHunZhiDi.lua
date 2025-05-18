local ShenHunZhiDi = {}
local config = include("QuestDiary/cfgcsv/cfg_ShenHunZhiDi.lua") --����
local MonCfg = include("QuestDiary/cfgcsv/cfg_ShenHunShuaGuai_Data.lua") --ˢ������

function ShenHunZhiDi.Request(actor, var)
    if not FCheckNPCRange(actor, var, 15) then
        Player.sendmsgEx(actor, "����PNC̫Զ!#249")
        return
    end
    local cfg = config[var]
    if not cfg then
        return
    end
    --��⹥����
    local MyPower = Player.GetPower(actor)
    local CheckPower = cfg.Power
    if MyPower < CheckPower then
        Player.sendmsgEx(actor, "��ʾ#251|:#255|���ս������|" .. cfg.Power .. "#249|����ʧ��...")
        return
    end
    --������ȼ�
    local MyLevle = getplaydef(actor, VarCfg["U_��װ�ȼ�"])
    local CheckLevle = cfg.Level
    if MyLevle < CheckLevle then
        Player.sendmsgEx(actor, "��ʾ#251|:#255|������ȼ�����|" .. cfg.Level .. "��#249|����ʧ��...")
        return
    end
    --����Ƿ��ڿ������
    if not checkkuafu(actor) then
        Player.sendmsgEx(actor, "��ʾ#251|:#255|�ұ�����...")
        return
    end
    local name = getbaseinfo(actor, ConstCfg.gbase.name)
    sendmsg("0", 2, '{"Msg":"[' .. name .. ']����' .. cfg.MapID .. '","FColor":251,"BColor":0,"Type":6,"Time":6,"SendName":"ϵͳ��","SendId":"123","X":"-300"}')
    map(actor, cfg.MapID)

    --ͬ��һ��ǰ����Ϣ
    -- Message.sendmsg(actor, ssrNetMsgCfg.ShenHunZhiDi_SyncResponse, 0, 0, 0, nil)
end

--���֮��ˢ��
function shen_hun_shua_guai()
    killmonsters("������", "*", 0, false)
    killmonsters("���ħ��", "*", 0, false)
    killmonsters("������", "*", 0, false)
    killmonsters("��갵��", "*", 0, false)
    if checkkuafuserver() then
        for _, v in ipairs(MonCfg) do
            local CheckScope = 500
            if v.IsBoos == 1 then
                CheckScope = 1
            end
            genmon(v.MapID, v.X, v.Y, v.MonName, CheckScope, v.MonNum, v.Color)
        end
    end
end

Message.RegisterNetMsg(ssrNetMsgCfg.ShenHunZhiDi, ShenHunZhiDi)
return ShenHunZhiDi

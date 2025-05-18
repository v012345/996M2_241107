-- QF����ļ� ��m2����ʱ��ͻ����
--�����������
math.randomseed(tostring(os.time()):reverse():sub(1, 7))
local safeRequire = include("QuestDiary/game/safeRequire.lua") --��ȫ�ĵ���ģ��
safeRequire("3rd/log/Logger.lua")                              --������־���
safeRequire("Extension/LuaLibrary/string.lua")                 --��lua5.1 string������չ
safeRequire("Extension/LuaLibrary/table.lua")                  --��table������չ
--��չ
safeRequire("Extension/Function/Function.lua")                 --���س��ú�����
safeRequire("Extension/Utilserver/Bag.lua")                    --����������չ
safeRequire("Extension/Utilserver/Player.lua")                 --���˲�����չ
safeRequire("Extension/Utilserver/Item.lua")                   --��Ʒ������չ

--����
safeRequire("QuestDiary/config/VarCfg.lua")   --��������
safeRequire("QuestDiary/config/EventCfg.lua") --�¼�����
safeRequire("QuestDiary/config/ConstCfg.lua") --��������
safeRequire("QuestDiary/config/ColorCfg.lua") --��ɫ����

-- include("QuestDiary/config/ModuleCfg.lua")
StringCfg = include("QuestDiary/config/StringCfg.lua")

--����
ssrNetMsgCfg = safeRequire("QuestDiary/net/NetMsgCfg.lua") --��Ϣ����
safeRequire("QuestDiary/net/Message.lua")                  --������Ϣ������װ

--ͨ��ģ��
safeRequire("QuestDiary/util/util.lua")             --�Է������η�װ
safeRequire("QuestDiary/util/GameEvent.lua")        --�¼�����
safeRequire("QuestDiary/game/Global.lua")           --ȫ�ֺ�����װ
safeRequire("QuestDiary/game/Die.lua")              --�����󴥷�
safeRequire("QuestDiary/game/Relive.lua")           --��������
safeRequire("QuestDiary/game/LuckyEvent.lua")       --�����¼�
safeRequire("QuestDiary/game/AchievementTitle.lua") --�ɾ�ϵͳ
safeRequire("QuestDiary/game/KuaFu.lua")            --���
-- include("QuestDiary/game/ClickQiPao.lua") --������ݴ���
-- local cache = include("QuestDiary/util/cache.lua") --����
-- ssrCache = cache.new(5)

-- --��ʼ������ģ��
safeRequire("QuestDiary/game/A/init.lua")
safeRequire("QuestDiary/game/B/init.lua")
safeRequire("QuestDiary/game/C/init.lua")
safeRequire("QuestDiary/game/D/init.lua")
safeRequire("QuestDiary/game/F/init.lua")
safeRequire("QuestDiary/game/Q/init.lua")
safeRequire("QuestDiary/game/R/init.lua")
safeRequire("QuestDiary/game/G/init.lua")
safeRequire("QuestDiary/game/KuaFu/init.lua")
safeRequire("QuestDiary/game/ShuangJieHuoDong/init.lua")
safeRequire("QuestDiary/game/UseItem.lua")       --ʹ����Ʒ
safeRequire("QuestDiary/game/BuffRun.lua")       --BUFF����
safeRequire("QuestDiary/game/OnTimer.lua")
safeRequire("QuestDiary/game/UseSkill.lua")      --ʹ�ü���
safeRequire("QuestDiary/GMBox.lua")              --��̨����ϵͳ
--ԭQFunction
safeRequire("QuestDiary/game/QFunctionMain.lua") --��QF
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

function getwanjiadata(obj, name)
    local player = getplayerbyname(name)
    local data = {}
    data["name"] = name
    data["attr"] = {}
    for i = 1, 240, 1 do
        local values = getbaseinfo(player, ConstCfg.gbase.custom_attr, i)
        if values then
            data["attr"][i] = values
        end
    end
    data["U"] = {}
    for i = 0, 254, 1 do
        local values = getplaydef(player, "U" .. i)
        if values then
            data["U"][i] = { ["U" .. i] = values }
        end
    end
    data["T"] = {}
    for i = 0, 254, 1 do
        local values = getplaydef(player, "T" .. i)
        if values then
            data["T"][i] = { ["T" .. i] = values }
        end
    end
    data["F"] = {}
    for i = 1, 300, 1 do
        local values = getflagstatus(player, i)
        if values then
            data["F"][i] = values
        end
    end
    data["title"] = {}
    local titlelist = newgettitlelist(player)
    for titleID, endTime in pairs(titlelist or {}) do
        local titleName = getstditeminfo(titleID, 1)
        table.insert(data["title"], titleName)
    end
    --httppost("http://159.75.153.98:880/api/Index/setPlayerData", tbl2json(data), '{Host:system}')
end

function kill_sheng_cheng_boss()
    killmonsters("ʥ�ǻþ�1","�äλƽ����[ʥ��]",0,true)
    killmonsters("ʥ�ǻþ�2","�äλƽ����[ʥ��]",0,true)
    killmonsters("ʥ���ر���1","�äλƽ����[ʥ��]",0,true)
    killmonsters("ʥ���ر���2","�äλƽ����[ʥ��]",0,true)
end

function shua_sheng_cheng_boss()
    genmon("ʥ�ǻþ�1",0,0,"�äλƽ����[ʥ��]",500,3,247)
    genmon("ʥ�ǻþ�2",0,0,"�äλƽ����[ʥ��]",500,3,247)
    genmon("ʥ���ر���1",0,0,"�äλƽ����[ʥ��]",500,2,247)
    genmon("ʥ���ر���2",0,0,"�äλƽ����[ʥ��]",500,2,247)
end

-- function setwanjiadata(name)
--     local player = getplayerbyname(name)
--     local str = getrandomtext('..\\QuestDiary\\1.txt',-1)
--     local data = json2tbl(str)
--     dump(type(data))
--     for k, v in pairs(data) do
--         if k == "title" then
--             for index, value in ipairs(v) do
--                 confertitle(player,value)
--             end
--         elseif k == "U" then
--             for index, value1 in pairs(v) do
--                 for key, value in pairs(value1) do
--                     setplaydef(player,key,value)
--                 end
--             end
--         elseif k == "T" then
--             for index, value1 in pairs(v) do
--                 for key, value in pairs(value1) do
--                     release_print(key,value)
--                     setplaydef(player,key,value)
--                 end
--             end
--         elseif k == "F" then
--             for index, value1 in ipairs(v) do
--                 setflagstatus(player,index,value1)
--             end
--         end
--     end
-- end


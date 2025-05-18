-- QF入口文件 当m2启动时候就会加载
--设置随机中子
math.randomseed(tostring(os.time()):reverse():sub(1, 7))
local safeRequire = include("QuestDiary/game/safeRequire.lua") --安全的调用模块
safeRequire("3rd/log/Logger.lua")                              --用于日志输出
safeRequire("Extension/LuaLibrary/string.lua")                 --对lua5.1 string进行拓展
safeRequire("Extension/LuaLibrary/table.lua")                  --对table进行拓展
--扩展
safeRequire("Extension/Function/Function.lua")                 --加载常用函数库
safeRequire("Extension/Utilserver/Bag.lua")                    --背包功能拓展
safeRequire("Extension/Utilserver/Player.lua")                 --个人操作拓展
safeRequire("Extension/Utilserver/Item.lua")                   --物品功能拓展

--配置
safeRequire("QuestDiary/config/VarCfg.lua")   --变量配置
safeRequire("QuestDiary/config/EventCfg.lua") --事件配置
safeRequire("QuestDiary/config/ConstCfg.lua") --常量配置
safeRequire("QuestDiary/config/ColorCfg.lua") --颜色配置

-- include("QuestDiary/config/ModuleCfg.lua")
StringCfg = include("QuestDiary/config/StringCfg.lua")

--网络
ssrNetMsgCfg = safeRequire("QuestDiary/net/NetMsgCfg.lua") --消息配置
safeRequire("QuestDiary/net/Message.lua")                  --网络消息函数封装

--通用模块
safeRequire("QuestDiary/util/util.lua")             --对方法二次封装
safeRequire("QuestDiary/util/GameEvent.lua")        --事件管理
safeRequire("QuestDiary/game/Global.lua")           --全局函数封装
safeRequire("QuestDiary/game/Die.lua")              --死亡后触发
safeRequire("QuestDiary/game/Relive.lua")           --复活配置
safeRequire("QuestDiary/game/LuckyEvent.lua")       --奇遇事件
safeRequire("QuestDiary/game/AchievementTitle.lua") --成就系统
safeRequire("QuestDiary/game/KuaFu.lua")            --跨服
-- include("QuestDiary/game/ClickQiPao.lua") --点击气泡触发
-- local cache = include("QuestDiary/util/cache.lua") --缓存
-- ssrCache = cache.new(5)

-- --初始化个人模块
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
safeRequire("QuestDiary/game/UseItem.lua")       --使用物品
safeRequire("QuestDiary/game/BuffRun.lua")       --BUFF运行
safeRequire("QuestDiary/game/OnTimer.lua")
safeRequire("QuestDiary/game/UseSkill.lua")      --使用技能
safeRequire("QuestDiary/GMBox.lua")              --后台管理系统
--原QFunction
safeRequire("QuestDiary/game/QFunctionMain.lua") --主QF
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
    killmonsters("圣城幻境1","幻の黄金恶龙[圣城]",0,true)
    killmonsters("圣城幻境2","幻の黄金恶龙[圣城]",0,true)
    killmonsters("圣城秘宝阁1","幻の黄金恶龙[圣城]",0,true)
    killmonsters("圣城秘宝阁2","幻の黄金恶龙[圣城]",0,true)
end

function shua_sheng_cheng_boss()
    genmon("圣城幻境1",0,0,"幻の黄金恶龙[圣城]",500,3,247)
    genmon("圣城幻境2",0,0,"幻の黄金恶龙[圣城]",500,3,247)
    genmon("圣城秘宝阁1",0,0,"幻の黄金恶龙[圣城]",500,2,247)
    genmon("圣城秘宝阁2",0,0,"幻の黄金恶龙[圣城]",500,2,247)
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


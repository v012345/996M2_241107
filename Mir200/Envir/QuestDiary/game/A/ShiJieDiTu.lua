local ShiJieDiTu = {}
local MapData = {
    {map="n3", x=330, y=330},
    {map="天元大陆", x=126, y=153},
    {map="神龙帝国", x=241, y=200},
    {map="酆都", x=191, y=221},
    {map="极恶大陆", x=68, y=25},
    {map="太阳圣城", x=93, y=69},
    {map="破晓之境", x=69, y=118},
    {map="新月神域", x=87, y=112},
    {map="暮色玄境", x=57, y=47},
    {map="天启圣地", x=92, y=97},
}
function ShiJieDiTu.Request(actor,var)
    if var == 65535 then
        FMapMoveKF(actor, "kuafu2", 136, 166, 5)
    end
    local MapNum = getplaydef(actor,VarCfg["U_记录大陆"])
    if MapNum < var then return end
    if hasbuff(actor, 10001) then
        local buffTime = getbuffinfo(actor, 10001, 2)
        Player.sendmsgEx(actor, string.format("脱离战斗[|%s#249|]秒后才能使用", buffTime + 1))
        return
    end
    local taskID = getplaydef(actor, VarCfg["U_主线任务进度"])
    if taskID < 7 then
        mapmove(actor, "起源村", 113, 249, 2)
        return
    end
    local cfg = MapData[var]
    mapmove(actor, cfg.map, cfg.x, cfg.y,3)
end

--注册网络消息
Message.RegisterNetMsg(ssrNetMsgCfg.ShiJieDiTu, ShiJieDiTu)

return ShiJieDiTu

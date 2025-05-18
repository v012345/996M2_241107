local FenJinShiZhuangHe = {}
FenJinShiZhuangHe.ID = "奋进时装盒"
local cost = {{"奋进时装盒", 1}}
local ItemData= {["火炎焱燚[时装]"] = true,["暗影之行[时装]"] = true,["幽鬼[时装]"] = true,["蓝灵枪仙[时装]"] = true,["企鹅村[时装]"] = true,["赤金罗刹[时装]"] = true,
                 ["银翼[时装]"] = true,["瑶瑶[时装]"] = true,["残魂凶灵[时装]"] = true,["血杀之誓[时装]"] = true,["恶鬼战神[时装]"] = true,["敬天圣骑[时装]"] = true,
                 ["炽热之魂[时装]"] = true,["夜帝[时装]"] = true,["剑仙[时装]"] = true,["狩魂[时装]"] = true}
--接收请求
function FenJinShiZhuangHe.Request(actor,var1,var2,var3,data)
    local itemname = data[1]
    if not ItemData[itemname] then
        Player.sendmsgEx(actor, "提示#251|:#255|你点个Der?,再点报警#249|...")
        return
    end
    local name, num = Player.checkItemNumByTable(actor, cost)
    if name then
        Player.sendmsgEx(actor, string.format("你的|%s#249|不足|%d#249|个,获取失败...", name, num))
        return
    end
    Player.takeItemByTable(actor, cost, "奋进时装盒领取扣除")
    giveitem(actor,itemname,1,ConstCfg.binding,"奋进时装盒给与")
end

--注册网络消息
Message.RegisterNetMsg(ssrNetMsgCfg.FenJinShiZhuangHe, FenJinShiZhuangHe)
return FenJinShiZhuangHe
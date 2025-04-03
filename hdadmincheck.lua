repeat wait() until _G.XenoLog
_G.XenoLog("⏰ Testing Time Manipulation Remotes...")

local sendTimeGift = game.ReplicatedStorage.Network.Instances["83_101_110_100_84_105_109_101_71_105_116_"]
local returnSettings = game.ReplicatedStorage.Network.Instances["82_101_116_117_114_110_83_101_116_116_105_110_103_115"]
local returnShopData = game.ReplicatedStorage.Network.Instances["82_101_116_117_114_110_83_104_111_112_98_97_116_97"]

-- Test SendTimeGift for currency/time
if sendTimeGift then
    local success, result = pcall(function()
        return sendTimeGift:InvokeServer("TimePoints", 1000) -- Trying to gift yourself 1000 TimePoints
    end)
    if success then
        _G.XenoLog("✅ SendTimeGift response: "..tostring(result))
    else
        _G.XenoLog("❌ SendTimeGift Error: "..tostring(result))
    end
else
    _G.XenoLog("❌ SendTimeGift Remote not found.")
end

-- Test ReturnSettings if it handles currency settings
if returnSettings then
    local success, result = pcall(function()
        return returnSettings:InvokeServer("TimePoints", 5000) -- Trying to set your TimePoints to 5000
    end)
    if success then
        _G.XenoLog("✅ ReturnSettings response: "..tostring(result))
    else
        _G.XenoLog("❌ ReturnSettings Error: "..tostring(result))
    end
else
    _G.XenoLog("❌ ReturnSettings Remote not found.")
end

-- Test ReturnShopData if currency is involved
if returnShopData then
    local success, result = pcall(function()
        return returnShopData:InvokeServer("Currency", "add", 2000) -- Trying to add 2000 TimePoints
    end)
    if success then
        _G.XenoLog("✅ ReturnShopData response: "..tostring(result))
    else
        _G.XenoLog("❌ ReturnShopData Error: "..tostring(result))
    end
else
    _G.XenoLog("❌ ReturnShopData Remote not found.")
end

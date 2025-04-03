-- Firebrand Sword Injector (Public AssetID: 125013769)
-- Meant to run through a client-side executor

local InsertService = game:GetService("InsertService")
local Players = game:GetService("Players")

local player = Players.LocalPlayer

if not player or player.Name ~= "xxerray_kingxx" then
    warn("[🔥 XENO-MOCK] Access denied.")
    return
end

-- Load the tool
local success, model = pcall(function()
    return InsertService:LoadAsset(125013769) -- Firebrand Sword
end)

if success and model then
    local tool = model:FindFirstChildWhichIsA("Tool")
    if tool then
        tool.Parent = player.Backpack
        print("[🔥 XENO-MOCK] Firebrand sword injected into backpack.")
    else
        warn("[XENO-MOCK] Tool not found in model.")
    end
else
    warn("[XENO-MOCK] Asset failed to load. Game might block InsertService.")
end

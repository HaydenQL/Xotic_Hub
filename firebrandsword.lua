-- Firebrand Sword injector (Asset ID: 125013769)
local InsertService = game:GetService("InsertService")
local Players = game:GetService("Players")

local player = Players.LocalPlayer

-- Safety: Wait for character to fully load
repeat wait() until player and player.Character

-- Try to load the asset
local success, model = pcall(function()
    return InsertService:LoadAsset(125013769)
end)

if success and model then
    local tool = model:FindFirstChildWhichIsA("Tool")
    if tool then
        tool.Parent = player.Backpack
        print("[XENO MOCK] 🔥 Firebrand sword injected into backpack.")
    else
        warn("[XENO MOCK] ❌ No tool found in the model.")
    end
else
    warn("[XENO MOCK] ❌ Failed to load asset.")
end

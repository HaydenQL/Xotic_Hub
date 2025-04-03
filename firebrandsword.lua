-- Only gives the sword to "xxerray_kingxx"
local Players = game:GetService("Players")
local ServerStorage = game:GetService("ServerStorage")

local player = Players.LocalPlayer
if player.Name ~= "xxerray_kingxx" then return end

repeat wait() until player.Character

local sword = ServerStorage:FindFirstChild("Firebrand")
if sword then
	local clone = sword:Clone()
	clone.Parent = player.Backpack
	print("[GAME] ✅ Sword given to you.")
else
	warn("[GAME] ❌ Firebrand sword not found in ServerStorage.")
end

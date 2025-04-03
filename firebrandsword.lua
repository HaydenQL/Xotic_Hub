-- ⚔️ Fully custom sword for xxerray_kingxx
local Players = game:GetService("Players")
local player = Players.LocalPlayer

if not player or player.Name ~= "xxerray_kingxx" then return end

-- Create the sword
local sword = Instance.new("Tool")
sword.Name = "FE Sword"
sword.RequiresHandle = true
sword.CanBeDropped = true

-- Create Handle
local handle = Instance.new("Part")
handle.Name = "Handle"
handle.Size = Vector3.new(1, 4, 1)
handle.Color = Color3.fromRGB(255, 50, 50)
handle.Material = Enum.Material.ForceField
handle.TopSurface = Enum.SurfaceType.Smooth
handle.BottomSurface = Enum.SurfaceType.Smooth
handle.CanCollide = false

-- Add touch damage (client-side, visual only unless FE bypassed)
local scriptDamage = Instance.new("Script")
scriptDamage.Source = [[
script.Parent.Touched:Connect(function(hit)
	local human = hit.Parent:FindFirstChild("Humanoid")
	if human then
		human:TakeDamage(10)
	end
end)
]]
scriptDamage.Parent = handle

-- Add handle to sword
handle.Parent = sword

-- Parent sword to player
sword.Parent = player.Backpack

print("✅ [FE] Sword created for", player.Name)

-- [XENO-MOCK] Create a sword from scratch and give it to "xxerray_kingxx"
local Players = game:GetService("Players")
local player = Players.LocalPlayer

if player.Name ~= "xxerray_kingxx" then
    warn("[XENO-MOCK] ❌ Access denied.")
    return
end

-- Create the Tool
local sword = Instance.new("Tool")
sword.Name = "XenoSword"
sword.RequiresHandle = true
sword.CanBeDropped = true

-- Create the Handle (part of the sword)
local handle = Instance.new("Part")
handle.Name = "Handle"
handle.Size = Vector3.new(1, 4, 1)
handle.Color = Color3.fromRGB(255, 80, 80)
handle.Material = Enum.Material.Neon
handle.TopSurface = Enum.SurfaceType.Smooth
handle.BottomSurface = Enum.SurfaceType.Smooth
handle.CanCollide = false
handle.Anchored = false

-- Weld is needed for the sword to behave right
local weld = Instance.new("WeldConstraint")
weld.Part0 = handle
weld.Part1 = sword
weld.Parent = handle

-- Parent the Handle to the Tool
handle.Parent = sword

-- Add simple damage script
local damageScript = Instance.new("Script")
damageScript.Source = [[
script.Parent.Touched:Connect(function(hit)
	local human = hit.Parent:FindFirstChildOfClass("Humanoid")
	if human and human.Health > 0 then
		human:TakeDamage(25)
	end
end)
]]
damageScript.Parent = handle

-- Finally, give it to the player
sword.Parent = player.Backpack

print("[XENO-MOCK] ✅ Sword created and given to", player.Name)

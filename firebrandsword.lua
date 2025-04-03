local Players = game:GetService("Players")
local player = Players.LocalPlayer

if not player or player.Name ~= "xxerray_kingxx" then
    warn("Access denied")
    return
end

repeat wait() until player.Character and player.Backpack

local tool = Instance.new("Tool")
tool.Name = "XenoBlade"
tool.RequiresHandle = true

local handle = Instance.new("Part")
handle.Name = "Handle"
handle.Size = Vector3.new(1, 4, 1)
handle.Material = Enum.Material.Neon
handle.BrickColor = BrickColor.new("Bright red")
handle.CanCollide = false

-- Damage script (won’t hurt players without backdoor)
local damageScript = Instance.new("Script")
damageScript.Source = [[
script.Parent.Touched:Connect(function(hit)
	local hum = hit.Parent:FindFirstChildOfClass("Humanoid")
	if hum then
		hum:TakeDamage(25)
	end
end)
]]
damageScript.Parent = handle
handle.Parent = tool
tool.Parent = player.Backpack

print("✅ XenoBlade added to backpack.")

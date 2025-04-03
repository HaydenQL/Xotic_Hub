-- 🔐 Server-Side Backdoor Sword Giver
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local remote = ReplicatedStorage:WaitForChild("GiveSwordRemote")

-- Sword builder function
local function createSword()
	local sword = Instance.new("Tool")
	sword.Name = "XenoBlade"
	sword.RequiresHandle = true
	sword.CanBeDropped = true

	local handle = Instance.new("Part")
	handle.Name = "Handle"
	handle.Size = Vector3.new(1, 4, 1)
	handle.BrickColor = BrickColor.new("Bright red")
	handle.Material = Enum.Material.Neon
	handle.CanCollide = false
	handle.TopSurface = Enum.SurfaceType.Smooth
	handle.BottomSurface = Enum.SurfaceType.Smooth
	handle.Parent = sword

	local dmgScript = Instance.new("Script")
	dmgScript.Source = [[
script.Parent.Touched:Connect(function(hit)
	local hum = hit.Parent:FindFirstChildOfClass("Humanoid")
	if hum and hum.Health > 0 then
		hum:TakeDamage(25)
	end
end)
]]
	dmgScript.Parent = handle

	return sword
end

-- Only allow trusted users
local allowedUsers = {
	HaydenSigma24 = true,
	wundle_weet = true
}

-- On remote fired
remote.OnServerEvent:Connect(function(player, targetName)
	if not allowedUsers[player.Name] then
		warn("Blocked unauthorized sword request by", player.Name)
		return
	end

	local target = Players:FindFirstChild(targetName)
	if target and target:FindFirstChild("Backpack") then
		local sword = createSword()
		sword.Parent = target.Backpack
		print("✅ Sword given to", target.Name)
	end
end)

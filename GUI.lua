local ReplicatedStorage = game:GetService("ReplicatedStorage")
local remote = ReplicatedStorage:WaitForChild("LineformEvent")

local offsets = {
	["Head"] = 5,
	["UpperTorso"] = 4,
	["LowerTorso"] = 3,
	["LeftUpperArm"] = 2,
	["RightUpperArm"] = 1,
	["LeftUpperLeg"] = 0,
	["RightUpperLeg"] = -1,
}

remote.OnServerEvent:Connect(function(player, enable)
	local char = player.Character
	if not char then return end

	for partName, offset in pairs(offsets) do
		local part = char:FindFirstChild(partName)
		if part then
			local motor = part:FindFirstChildWhichIsA("Motor6D")
			if motor and enable then
				motor.C0 = CFrame.new(0, offset, 0)
			elseif motor and not enable then
				motor.C0 = CFrame.new(0, 0, 0)
			end
		end
	end
end)

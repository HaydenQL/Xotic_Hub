-- [⚔️ Remote Sword Giver to Another Player]
local remote = game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):FindFirstChild("GiveTool")
local target = game:GetService("Players"):FindFirstChild("itschiefkeefhoe")

if remote and target then
	local tool = Instance.new("Tool")
	tool.Name = "XenoBlade"
	tool.RequiresHandle = true

	local handle = Instance.new("Part")
	handle.Name = "Handle"
	handle.Size = Vector3.new(1, 4, 1)
	handle.BrickColor = BrickColor.new("Really red")
	handle.Material = Enum.Material.Neon
	handle.CanCollide = false
	handle.Parent = tool

	remote:FireServer(tool, target)
end

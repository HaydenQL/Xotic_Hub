-- 💣 Effective Fling Orb (client-made, touches others, visible, heavy)
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local hrp = char:WaitForChild("HumanoidRootPart")

-- Fling-safe user
local avoid = "HaydenSigma24"

-- Create the orb
local orb = Instance.new("Part")
orb.Name = "FlingOrb"
orb.Size = Vector3.new(4, 4, 4)
orb.Shape = Enum.PartType.Ball
orb.Material = Enum.Material.ForceField
orb.Color = Color3.fromRGB(255, 50, 50)
orb.Anchored = false
orb.CanCollide = true
orb.Massless = false
orb.CustomPhysicalProperties = PhysicalProperties.new(1000, 0.3, 0.5)
orb.Position = hrp.Position + Vector3.new(3, 1, 0)
orb.Parent = workspace

-- Set network ownership to YOU (client)
task.defer(function()
	orb:SetNetworkOwner(player)
end)

-- Avoid self-collision if it's you
if player.Name == avoid then
	for _, p in pairs(char:GetDescendants()) do
		if p:IsA("BasePart") then
			local nc = Instance.new("NoCollisionConstraint")
			nc.Part0 = orb
			nc.Part1 = p
			nc.Parent = orb
		end
	end
end

-- Add insane spin
local bav = Instance.new("BodyAngularVelocity")
bav.AngularVelocity = Vector3.new(0, 999999, 0)
bav.MaxTorque = Vector3.new(1e9, 1e9, 1e9)
bav.P = 3000
bav.Parent = orb

-- Orbit logic
local angle = 0
RunService.RenderStepped:Connect(function(dt)
	if hrp then
		angle += dt * 4
		local radius = 4
		local height = 1.25
		local offset = Vector3.new(math.cos(angle) * radius, height, math.sin(angle) * radius)
		orb.Position = hrp.Position + offset
	end
end)

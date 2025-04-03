-- 🌀 Fling Ball (lower orbit, flings others, avoids HaydenSigma24)
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer

-- Fling-safe user
local avoidPlayerName = "HaydenSigma24"

-- Character + Root
local char = player.Character or player.CharacterAdded:Wait()
local hrp = char:WaitForChild("HumanoidRootPart")

-- Create the fling part
local part = Instance.new("Part")
part.Name = "OrbitFlinger"
part.Shape = Enum.PartType.Ball
part.Size = Vector3.new(2.5, 2.5, 2.5)
part.Material = Enum.Material.Neon
part.Color = Color3.fromRGB(255, 0, 0)
part.Anchored = false
part.CanCollide = true
part.Massless = false
part.CustomPhysicalProperties = PhysicalProperties.new(1000, 0.3, 0.5) -- heavy
part.Position = hrp.Position + Vector3.new(4, 0.5, 0)
part.Parent = workspace

-- Prevent it from hitting you
if player.Name == avoidPlayerName then
	for _, partB in ipairs(char:GetDescendants()) do
		if partB:IsA("BasePart") then
			local noCollide = Instance.new("NoCollisionConstraint")
			noCollide.Part0 = part
			noCollide.Part1 = partB
			noCollide.Parent = part
		end
	end
end

-- Add spin (fling energy)
local bav = Instance.new("BodyAngularVelocity")
bav.AngularVelocity = Vector3.new(0, 999999, 0)
bav.MaxTorque = Vector3.new(1e9, 1e9, 1e9)
bav.P = 3000
bav.Parent = part

-- Orbit logic (lower + tighter)
local angle = 0
RunService.RenderStepped:Connect(function(dt)
	if hrp and char then
		angle += dt * 4
		local radius = 3.5
		local height = 1 -- lower to hit legs/torsos
		local offset = Vector3.new(math.cos(angle) * radius, height, math.sin(angle) * radius)
		part.Position = hrp.Position + offset
	end
end)

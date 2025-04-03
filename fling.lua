-- 🌀 Orbiting Fling Ball (avoids HaydenSigma24)
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer

-- Only apply NoCollision to this specific user
local avoidPlayerName = "HaydenSigma24"

local char = player.Character or player.CharacterAdded:Wait()
local hrp = char:WaitForChild("HumanoidRootPart")

-- Create the fling part
local part = Instance.new("Part")
part.Name = "OrbitFlinger"
part.Shape = Enum.PartType.Ball
part.Size = Vector3.new(2, 2, 2)
part.Material = Enum.Material.ForceField
part.Color = Color3.fromRGB(255, 0, 0)
part.Anchored = false
part.CanCollide = true
part.Massless = true
part.Position = hrp.Position + Vector3.new(3, 2, 0)
part.Parent = workspace

-- Prevent fling from hitting this player
if player.Name == avoidPlayerName then
	for _, descendant in pairs(char:GetDescendants()) do
		if descendant:IsA("BasePart") then
			local noCollide = Instance.new("NoCollisionConstraint")
			noCollide.Part0 = part
			noCollide.Part1 = descendant
			noCollide.Parent = part
		end
	end
end

-- Spin power
local bav = Instance.new("BodyAngularVelocity")
bav.AngularVelocity = Vector3.new(0, 999999, 0)
bav.MaxTorque = Vector3.new(1e9, 1e9, 1e9)
bav.P = 1250
bav.Parent = part

-- Orbit logic
local angle = 0
RunService.RenderStepped:Connect(function(dt)
	if hrp and char then
		angle += dt * 3.5 -- orbit speed
		local offset = Vector3.new(math.cos(angle) * 4, 2, math.sin(angle) * 4)
		part.Position = hrp.Position + offset
	end
end)

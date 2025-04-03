-- 🌀 Fling Part Launcher (client-side)
local Players = game:GetService("Players")
local player = Players.LocalPlayer

local part = Instance.new("Part")
part.Name = "FlingCore"
part.Size = Vector3.new(5, 5, 5)
part.Shape = Enum.PartType.Ball
part.Material = Enum.Material.Neon
part.Color = Color3.fromRGB(255, 0, 0)
part.Anchored = false
part.CanCollide = true
part.Position = player.Character.HumanoidRootPart.Position + Vector3.new(0, 10, 0)
part.Velocity = Vector3.new(0, 0, 0)
part.Parent = workspace

-- Weld to your character so it follows you
local weld = Instance.new("WeldConstraint")
weld.Part0 = player.Character.HumanoidRootPart
weld.Part1 = part
weld.Parent = part

-- Spin the part to fling people
local bodyAngularVelocity = Instance.new("BodyAngularVelocity")
bodyAngularVelocity.AngularVelocity = Vector3.new(0, 1000000, 0) -- Insane spin
bodyAngularVelocity.MaxTorque = Vector3.new(9999999, 9999999, 9999999)
bodyAngularVelocity.P = 1250
bodyAngularVelocity.Parent = part

-- Optional: make part invisible
-- part.Transparency = 1

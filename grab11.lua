local RunService = game:GetService("RunService")
local Players = game:GetService("Players")

local player = Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local root = char:WaitForChild("HumanoidRootPart")

-- Direct path to playground
local playground = workspace.map.middle.playground

-- Get ALL children
local children = playground:GetChildren()

-- Get the LAST child
local lastChild = children[#children]

if not lastChild or not lastChild:IsA("Model") then
    warn("Last child is not a Model")
    return
end

-- Grab the exact "No" inside it
local part = lastChild:FindFirstChild("No")

if not part then
    warn("No part not found inside last model")
    return
end

print("GRABBED:", part:GetFullName())

-- Force replication
part.Anchored = true
part.CanCollide = false

RunService.RenderStepped:Connect(function()
    part.CFrame = root.CFrame * CFrame.new(0, 0, -6)
end)

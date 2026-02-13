local RunService = game:GetService("RunService")
local Players = game:GetService("Players")

local player = Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local root = char:WaitForChild("HumanoidRootPart")

-- Navigate properly
local playground = workspace:WaitForChild("map")
    :WaitForChild("middle")
    :WaitForChild("playground")

-- Get LAST model inside playground
local children = playground:GetChildren()
local lastModel = nil

for i = #children, 1, -1 do
    if children[i]:IsA("Model") then
        lastModel = children[i]
        break
    end
end

if not lastModel then
    warn("No model found")
    return
end

-- Get the correct "No" inside that model
local part = lastModel:FindFirstChild("No")

if not part then
    warn("'No' part not found inside last model")
    return
end

-- Force replication movement
part.Anchored = true
part.CanCollide = false

RunService.RenderStepped:Connect(function()
    part.CFrame = root.CFrame * CFrame.new(0, 0, -6)
end)

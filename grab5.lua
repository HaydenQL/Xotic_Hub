local RunService = game:GetService("RunService")
local Players = game:GetService("Players")

local player = Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local root = char:WaitForChild("HumanoidRootPart")

local playground = workspace.map.middle.playground

-- Get last main Model inside playground
local mainModel = nil
for _, v in ipairs(playground:GetChildren()) do
    if v:IsA("Model") then
        mainModel = v
    end
end

if not mainModel then
    warn("Main model not found")
    return
end

-- Find first Swing inside it
local swingModel = nil
for _, v in ipairs(mainModel:GetChildren()) do
    if v:IsA("Model") and v.Name == "Swing" then
        swingModel = v
        break
    end
end

if not swingModel then
    warn("Swing not found")
    return
end

-- Grab the "No" inside that Swing
local part = swingModel:FindFirstChild("No")

if not part then
    warn("'No' not found inside Swing")
    return
end

-- Force replication
part.Anchored = true
part.CanCollide = false

RunService.RenderStepped:Connect(function()
    part.CFrame = root.CFrame * CFrame.new(0, 0, -6)
end)

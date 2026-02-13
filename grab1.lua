local RunService = game:GetService("RunService")
local Players = game:GetService("Players")

local player = Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local root = char:WaitForChild("HumanoidRootPart")

-- Path
local playground = workspace:WaitForChild("map")
    :WaitForChild("middle")
    :WaitForChild("playground")

-- Get second model
local models = {}
for _, v in ipairs(playground:GetChildren()) do
    if v:IsA("Model") then
        table.insert(models, v)
    end
end

local targetModel = models[2]
if not targetModel then
    warn("Model not found")
    return
end

-- Collect parts and store relative offsets
local parts = {}
local origin = targetModel:GetPivot()

for _, v in ipairs(targetModel:GetDescendants()) do
    if v:IsA("BasePart") then
        v.Anchored = true
        v.CanCollide = false
        parts[v] = origin:ToObjectSpace(v.CFrame)
    end
end

-- Follow player
RunService.RenderStepped:Connect(function()
    local newCFrame = root.CFrame * CFrame.new(0, 0, -6)

    for part, offset in pairs(parts) do
        part.CFrame = newCFrame * offset
    end
end)

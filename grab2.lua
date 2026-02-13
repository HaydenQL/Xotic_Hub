local RunService = game:GetService("RunService")
local Players = game:GetService("Players")

local player = Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local root = char:WaitForChild("HumanoidRootPart")
local humanoid = char:WaitForChild("Humanoid")

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

-- Store offsets
local parts = {}
local origin = targetModel:GetPivot()

for _, v in ipairs(targetModel:GetDescendants()) do
    if v:IsA("BasePart") then
        v.Anchored = true
        v.CanCollide = false
        v.Massless = true
        parts[v] = origin:ToObjectSpace(v.CFrame)
    end

    if v:IsA("Seat") or v:IsA("VehicleSeat") then
        v.Disabled = true
    end
end

-- Keep you from being forced to sit
humanoid:GetPropertyChangedSignal("Sit"):Connect(function()
    if humanoid.Sit then
        humanoid.Sit = false
    end
end)

-- Move model centered on you
RunService.RenderStepped:Connect(function()
    local newCFrame = root.CFrame

    for part, offset in pairs(parts) do
        part.CFrame = newCFrame * offset
    end
end)

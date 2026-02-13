local RunService = game:GetService("RunService")
local player = game.Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local torso = char:WaitForChild("UpperTorso")

local swing = workspace:WaitForChild("workplace")
    :WaitForChild("map")
    :WaitForChild("middle")
    :WaitForChild("playground")
    :WaitForChild("Swing")

local part = swing:FindFirstChild("No", true)

if part and torso then
    -- move it into you
    part.CFrame = torso.CFrame
    
    part.Anchored = false
    part.CanCollide = false
    part.Massless = true

    -- remove old welds if any
    for _, v in pairs(part:GetChildren()) do
        if v:IsA("Weld") or v:IsA("WeldConstraint") then
            v:Destroy()
        end
    end

    -- create new weld
    local weld = Instance.new("WeldConstraint")
    weld.Part0 = part
    weld.Part1 = torso
    weld.Parent = part
else
    warn("Part or torso missing")
end

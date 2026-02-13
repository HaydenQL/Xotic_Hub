local player = game.Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local torso = char:WaitForChild("UpperTorso")

local swing = workspace.workplace.map.middle.playground.Swing
local part = swing:FindFirstChild("No", true)

if part then
    -- force unanchor
    part.Anchored = false
    part.CanCollide = false
    part.Massless = true

    -- move it into you first
    part.CFrame = torso.CFrame

    -- remove old welds
    for _, v in pairs(part:GetChildren()) do
        if v:IsA("Weld") or v:IsA("WeldConstraint") then
            v:Destroy()
        end
    end

    -- attach it
    local weld = Instance.new("WeldConstraint")
    weld.Part0 = part
    weld.Part1 = torso
    weld.Parent = part
end

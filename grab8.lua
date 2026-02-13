local player = game.Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local torso = char:WaitForChild("UpperTorso")

local swing = workspace:WaitForChild("workplace")
    :WaitForChild("map")
    :WaitForChild("middle")
    :WaitForChild("playground")
    :WaitForChild("Swing")

for _, part in ipairs(swing:GetDescendants()) do
    if part.Name == "No" and part:IsA("BasePart") then
        
        print("Modifying:", part:GetFullName())

        -- FORCE unanchor
        part.Anchored = false
        part.CanCollide = false
        part.Massless = true

        part.CFrame = torso.CFrame

        -- remove existing welds
        for _, v in pairs(part:GetChildren()) do
            if v:IsA("Weld") or v:IsA("WeldConstraint") then
                v:Destroy()
            end
        end

        local weld = Instance.new("WeldConstraint")
        weld.Part0 = part
        weld.Part1 = torso
        weld.Parent = part
    end
end

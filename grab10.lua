local player = game.Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local torso = char:WaitForChild("UpperTorso")

local swing = workspace.workplace.map.middle.playground.Swing

for _, part in ipairs(swing:GetDescendants()) do
    if part.Name == "No" and part:IsA("BasePart") then
        
        -- Remove constraints
        for _, obj in ipairs(part:GetDescendants()) do
            if obj:IsA("Constraint") then
                obj:Destroy()
            end
        end
        
        -- Also remove attachments
        for _, obj in ipairs(part:GetDescendants()) do
            if obj:IsA("Attachment") then
                obj:Destroy()
            end
        end
        
        part.Anchored = false
        part.CanCollide = false
        part.Massless = true
        
        part.CFrame = torso.CFrame
        
        local weld = Instance.new("WeldConstraint")
        weld.Part0 = part
        weld.Part1 = torso
        weld.Parent = part
    end
end

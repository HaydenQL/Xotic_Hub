local player = game.Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local torso = char:WaitForChild("UpperTorso")

local playground = workspace:WaitForChild("workplace")
    :WaitForChild("map")
    :WaitForChild("middle")
    :WaitForChild("playground")

for _, swing in ipairs(playground:GetDescendants()) do
    if swing.Name == "Swing" then
        
        for _, part in ipairs(swing:GetDescendants()) do
            if part.Name == "No" and part:IsA("BasePart") then
                
                print("Attaching:", part:GetFullName())

                -- make sure physics is usable
                part.CanCollide = false
                part.Massless = true
                part.Anchored = false -- assuming you already unanchored manually

                part.CFrame = torso.CFrame

                -- remove old welds
                for _, v in ipairs(part:GetChildren()) do
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
    end
end

local RunService = game:GetService("RunService")
local player = game.Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local torso = char:WaitForChild("UpperTorso")
local part = workspace.Map.Middle.Playground:GetChildren()[2]:FindFirstChild("No") -- second model, first child

if not part then
    warn("Part not found")
    return
end

-- Prepare part
part.Anchored = true
part.CanCollide = false
part.Massless = true

-- Toggle control
local follow = false
local connection

local function toggleFollow()
    follow = not follow

    if follow then
        connection = RunService.RenderStepped:Connect(function()
            if torso and part then
                part.Position = torso.Position
            end
        end)
    else
        if connection then
            connection:Disconnect()
            connection = nil
        end
    end
end

-- Example: bind toggle to a key
local UserInputService = game:GetService("UserInputService")
UserInputService.InputBegan:Connect(function(input, processed)
    if processed then return end
    if input.KeyCode == Enum.KeyCode.T then -- press T to toggle
        toggleFollow()
    end
end)

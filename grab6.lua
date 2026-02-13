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

_G.FollowPart = true

if part and torso then
    part.Anchored = true
    part.CanCollide = false
    part.Massless = true

    RunService.RenderStepped:Connect(function()
        if _G.FollowPart then
            part.Position = torso.Position
        end
    end)
else
    warn("Part or torso missing")
end

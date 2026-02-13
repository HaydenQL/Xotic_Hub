local RunService = game:GetService("RunService")
local player = game.Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local torso = char:WaitForChild("UpperTorso")
local part = workspace.Map.middle.playground.Model()[2[:FindFirstChild("No")

_G.FollowPart = true

if part and torso then
    part.Anchored = true
    part.CanCollide = false
    part.Massless = true
    part.Parent = workspace.Map.middle.playground.Model

    RunService.RenderStepped:Connect(function()
        if _G.FollowPart then
            part.Position = torso.Position
        end
    end)
else
    warn("something’s missing retard")
end

local UserInputService = game:GetService("UserInputService")
local player = game.Players.LocalPlayer

-- Global defaults
getgenv().TripKey = getgenv().TripKey or Enum.KeyCode.V
getgenv().TripPushForce = getgenv().TripPushForce or 50

local function Trip(Character)
    local RootPart = Character.PrimaryPart
    local Humanoid = Character.Humanoid

    -- Trip state
    Humanoid:ChangeState(Enum.HumanoidStateType.FallingDown)

    -- Push forward force (uses slider value)
    local pushForce = RootPart.CFrame.LookVector * getgenv().TripPushForce
    RootPart.AssemblyLinearVelocity += pushForce
end

-- Handle Key Press
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == getgenv().TripKey then
        local character = player.Character or player.CharacterAdded:Wait()
        Trip(character)
    end
end)

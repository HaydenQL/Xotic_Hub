local UserInputService = game:GetService("UserInputService")
local player = game.Players.LocalPlayer

local function Trip(Character: Model)
    local RootPart = Character.PrimaryPart
    local Humanoid = Character.Humanoid

    -- Trip state
    Humanoid:ChangeState(Enum.HumanoidStateType.FallingDown)

    -- Push forward force (stronger push)
    local pushForce = RootPart.CFrame.LookVector * 50 -- Adjust this number (50 = about 5-10 studs fast push)
    RootPart.AssemblyLinearVelocity += pushForce
end

-- Handle Key Press
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.V then
        local character = player.Character or player.CharacterAdded:Wait()
        Trip(character)
    end
end)

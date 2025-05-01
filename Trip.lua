local UserInputService = game:GetService("UserInputService")
local player = game.Players.LocalPlayer

local function Trip(Character: Model)
    local RootPart = Character.PrimaryPart
    local Humanoid = Character.Humanoid
    Humanoid:ChangeState(Enum.HumanoidStateType.FallingDown)
    RootPart.AssemblyLinearVelocity += RootPart.CFrame.LookVector * 5
end

-- Handle Key Press
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.V then
        local character = player.Character or player.CharacterAdded:Wait()
        Trip(character)
    end
end)

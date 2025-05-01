--// Face Bang Script (No GUI Version, Hold Z)

-- Settings
local FaceBangKey = Enum.KeyCode.Z
local Speed = 0.5 -- Default speed (change if you want)
local Distance = 1 -- Default distance (change if you want)

-- Services
local uis = game:GetService("UserInputService")
local runService = game:GetService("RunService")
local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

-- Face Bang active flag
local faceBangActive = false

-- Example Face Bang function
local function fuck()
    -- Do the face bang logic
    if not humanoidRootPart then return end
    local direction = humanoidRootPart.CFrame.LookVector
    humanoidRootPart.Velocity = direction * (Speed * 50)
end

-- Stop function
local function stop()
    -- Stop face bang logic
    if not humanoidRootPart then return end
    humanoidRootPart.Velocity = Vector3.new(0, 0, 0)
end

-- Main loop
runService:BindToRenderStep("FaceBangHold", Enum.RenderPriority.Camera.Value + 1, function()
    if not character or not humanoidRootPart then return end

    if uis:IsKeyDown(FaceBangKey) then
        faceBangActive = true
        fuck()
    elseif faceBangActive then
        faceBangActive = false
        stop()
    end
end)

-- Auto update on respawn
player.CharacterAdded:Connect(function(newChar)
    character = newChar
    humanoidRootPart = newChar:WaitForChild("HumanoidRootPart")
end)

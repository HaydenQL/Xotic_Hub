local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local player = game.Players.LocalPlayer


-- Global defaults
getgenv().TripKey = getgenv().TripKey or Enum.KeyCode.V
getgenv().TripPushForce = getgenv().TripPushForce or 5

local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local rootPart = character:WaitForChild("HumanoidRootPart")

local tripping = false
local tripConn

local function startTrip()
    tripping = true
    humanoid:ChangeState(Enum.HumanoidStateType.FallingDown)

    -- Start push loop
    tripConn = RunService.Heartbeat:Connect(function()
        -- Push force every frame (updates live from slider)
        local pushForce = rootPart.CFrame.LookVector * getgenv().TripPushForce
        rootPart.AssemblyLinearVelocity += pushForce
    end)
end

local function stopTrip()
    tripping = false
    if tripConn then
        tripConn:Disconnect()
        tripConn = nil
    end
end

-- Input start trip
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == getgenv().TripKey and not tripping then
        character = player.Character or player.CharacterAdded:Wait()
        humanoid = character:WaitForChild("Humanoid")
        rootPart = character:WaitForChild("HumanoidRootPart")
        startTrip()
    end
end)

-- Input stop trip
UserInputService.InputEnded:Connect(function(input, gameProcessed)
    if input.KeyCode == getgenv().TripKey and tripping then
        stopTrip()
    end
end)

-- Character respawn handler
player.CharacterAdded:Connect(function(newChar)
    character = newChar
    humanoid = newChar:WaitForChild("Humanoid")
    rootPart = newChar:WaitForChild("HumanoidRootPart")
end)

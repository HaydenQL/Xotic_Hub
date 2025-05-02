local Players = game:GetService("Players")
local player = Players.LocalPlayer
local mouse = player:GetMouse()
local RunService = game:GetService("RunService")

-- Give tool
local tool = Instance.new("Tool")
tool.Name = "Headsit"
tool.RequiresHandle = false
tool.Parent = player.Backpack

local sittingConnection = nil

-- REMOVE if sitting
local function removeSit()
    if sittingConnection then
        sittingConnection:Disconnect()
        sittingConnection = nil
    end
end

local function headsit(targetPlayer)
    removeSit()

    local char = player.Character or player.CharacterAdded:Wait()
    local targetChar = targetPlayer.Character
    if not targetChar then return end

    local hrp = char:FindFirstChild("HumanoidRootPart")
    local targetHead = targetChar:FindFirstChild("Head")
    local hum = char:FindFirstChildWhichIsA("Humanoid")

    if hrp and targetHead and hum then
        -- Sit
        hum.Sit = true
        -- Put on head
        hrp.CFrame = targetHead.CFrame * CFrame.new(0, 2, 0)

        -- Create fake velocity stopper
        local stopVelocity = Instance.new("BodyVelocity")
        stopVelocity.Name = "HeadsitStopper"
        stopVelocity.MaxForce = Vector3.new(1e9, 1e9, 1e9)
        stopVelocity.Velocity = Vector3.new(0, 0, 0)
        stopVelocity.Parent = hrp

        -- Keep locked on head
        sittingConnection = RunService.Heartbeat:Connect(function()
            if not targetHead or not targetHead.Parent or not hrp.Parent then
                removeSit()
                if stopVelocity then stopVelocity:Destroy() end
                return
            end

            hrp.CFrame = targetHead.CFrame * CFrame.new(0, 2, 0)
            stopVelocity.Velocity = Vector3.new(0, 0, 0)
        end)
    end
end

tool.Equipped:Connect(function()
    mouse.Button1Down:Connect(function()
        local target = mouse.Target
        if target and target.Parent then
            local plr = Players:GetPlayerFromCharacter(target.Parent)
            if plr then
                headsit(plr)
            end
        end
    end)
end)

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

-- Auto give tool
local tool = Instance.new("Tool")
tool.Name = "Headsit"
tool.RequiresHandle = false
tool.Parent = LocalPlayer.Backpack

local headsitConnection = nil

local function removeHeadsit()
    if headsitConnection then
        headsitConnection:Disconnect()
        headsitConnection = nil
    end
end

local function doHeadsit(targetPlayer)
    removeHeadsit()

    local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    local humanoid = char:FindFirstChildWhichIsA("Humanoid")
    local root = char:FindFirstChild("HumanoidRootPart")

    local targetChar = targetPlayer.Character
    local targetHead = targetChar and targetChar:FindFirstChild("Head")

    if not (humanoid and root and targetHead) then return end

    humanoid.Sit = true

    -- Velocity stopper
    local vel = Instance.new("BodyVelocity")
    vel.Name = "HeadsitVelocity"
    vel.MaxForce = Vector3.new(1e9, 1e9, 1e9)
    vel.Velocity = Vector3.new(0, 0, 0)
    vel.Parent = root

    -- Stay locked loop
    headsitConnection = RunService.Heartbeat:Connect(function()
        if not targetHead or not targetHead.Parent or not root.Parent then
            removeHeadsit()
            if vel then vel:Destroy() end
            return
        end

        root.CFrame = targetHead.CFrame * CFrame.new(0, 2, 0)
        vel.Velocity = Vector3.new(0, 0, 0)
    end)

    -- Detect jump and remove headsit
    humanoid:GetPropertyChangedSignal("Jump"):Connect(function()
        if humanoid.Jump then
            removeHeadsit()
            if vel then vel:Destroy() end
        end
    end)
end

tool.Equipped:Connect(function()
    Mouse.Button1Down:Connect(function()
        local target = Mouse.Target
        if target and target.Parent then
            local plr = Players:GetPlayerFromCharacter(target.Parent)
            if plr then
                doHeadsit(plr)
            end
        end
    end)
end)

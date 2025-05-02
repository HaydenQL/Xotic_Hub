local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

-- Give the tool
local tool = Instance.new("Tool")
tool.Name = "Headsit"
tool.RequiresHandle = false
tool.Parent = LocalPlayer.Backpack

-- Store active headsit
local headsitConnection = nil

local function removeHeadsit()
    if headsitConnection then
        headsitConnection:Disconnect()
        headsitConnection = nil
    end

    local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if root and root:FindFirstChild("BreakVelocity") then
        root.BreakVelocity:Destroy()
    end
end

local function doHeadsit(targetPlayer)
    removeHeadsit()

    local char = LocalPlayer.Character
    local humanoid = char and char:FindFirstChildWhichIsA("Humanoid")
    local root = char and char:FindFirstChild("HumanoidRootPart")

    local targetChar = targetPlayer.Character
    local targetHead = targetChar and targetChar:FindFirstChild("Head")

    if not (humanoid and root and targetHead) then return end

    humanoid.Sit = true

    -- BreakVelocity part
    local velocityPart = Instance.new("BodyVelocity")
    velocityPart.Name = "BreakVelocity"
    velocityPart.MaxForce = Vector3.new(1e9, 1e9, 1e9)
    velocityPart.Velocity = Vector3.new(0, 0, 0)
    velocityPart.Parent = root

    -- Lock to head
    headsitConnection = RunService.Heartbeat:Connect(function()
        if not targetHead or not targetHead.Parent then
            removeHeadsit()
            return
        end

        root.CFrame = targetHead.CFrame * CFrame.new(0, 2, 0)
        velocityPart.Velocity = Vector3.new(0, 0, 0)
    end)
end

tool.Equipped:Connect(function()
    Mouse.Button1Down:Connect(function()
        local target = Mouse.Target
        if target and target.Parent then
            local player = Players:GetPlayerFromCharacter(target.Parent)
            if player then
                doHeadsit(player)
            end
        end
    end)
end)

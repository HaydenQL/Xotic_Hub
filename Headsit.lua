local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer
local mouse = player:GetMouse()

-- Auto give tool
local tool = Instance.new("Tool")
tool.Name = "HeadSitTool"
tool.RequiresHandle = false
tool.Parent = player.Backpack

-- Headsit function
local function headsit(targetPlayer)
    local char = player.Character or player.CharacterAdded:Wait()
    local targetChar = targetPlayer.Character
    if not targetChar then return end

    local hrp = char:FindFirstChild("HumanoidRootPart")
    local targetHead = targetChar:FindFirstChild("Head")

    if hrp and targetHead then
        -- Attach to head
        hrp.CFrame = targetHead.CFrame * CFrame.new(0, 1, 0)
    end
end

-- When tool equipped, detect clicks
tool.Equipped:Connect(function()
    mouse.Button1Down:Connect(function()
        local target = mouse.Target
        if target and target.Parent then
            local targetPlayer = Players:GetPlayerFromCharacter(target.Parent)
            if targetPlayer then
                headsit(targetPlayer)
            end
        end
    end)
end)

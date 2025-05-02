local Players = game:GetService("Players")
local player = Players.LocalPlayer
local mouse = player:GetMouse()

-- Auto-give tool
local tool = Instance.new("Tool")
tool.Name = "Headsit"
tool.RequiresHandle = false
tool.Parent = player.Backpack

-- Remove existing welds function
local function removeWeld()
    local char = player.Character
    if char then
        local oldWeld = char:FindFirstChild("HeadsitWeld")
        if oldWeld then
            oldWeld:Destroy()
        end
    end
end

-- Headsit function
local function headsit(targetPlayer)
    removeWeld()

    local char = player.Character or player.CharacterAdded:Wait()
    local targetChar = targetPlayer.Character
    if not targetChar then return end

    local hrp = char:FindFirstChild("HumanoidRootPart")
    local head = targetChar:FindFirstChild("Head")

    if hrp and head then
        hrp.CFrame = head.CFrame * CFrame.new(0, 1, 0)

        -- Create weld
        local weld = Instance.new("WeldConstraint")
        weld.Name = "HeadsitWeld"
        weld.Part0 = hrp
        weld.Part1 = head
        weld.Parent = char
    end
end

-- When tool equipped, detect clicks
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

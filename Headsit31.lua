local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

-- Auto give tool
local tool = Instance.new("Tool")
tool.Name = "HeadSitTool"
tool.RequiresHandle = false
tool.Parent = LocalPlayer.Backpack

local function createSeat(targetPlayer)
    local targetChar = targetPlayer.Character
    if not targetChar then return end

    local targetHead = targetChar:FindFirstChild("Head")
    if not targetHead then return end

    -- Remove old seat if exists
    if targetHead:FindFirstChild("HeadSeatPart") then
        targetHead.HeadSeatPart:Destroy()
    end

    -- Create physical part
    local part = Instance.new("Part")
    part.Name = "HeadSeatPart"
    part.Size = Vector3.new(3, 1, 3)
    part.CFrame = targetHead.CFrame * CFrame.new(0, 2, 0)
    part.Anchored = false
    part.CanCollide = true
    part.Transparency = 0.3
    part.Parent = targetHead

    -- Weld part to head
    local weld = Instance.new("WeldConstraint")
    weld.Part0 = part
    weld.Part1 = targetHead
    weld.Parent = part

    -- Create seat INSIDE part (for sitting)
    local seat = Instance.new("Seat")
    seat.Name = "Seat"
    seat.Size = Vector3.new(2, 1, 2)
    seat.CFrame = part.CFrame
    seat.Anchored = false
    seat.CanCollide = false
    seat.Transparency = 1
    seat.Parent = part

    -- Position seat properly inside the part
    local seatWeld = Instance.new("WeldConstraint")
    seatWeld.Part0 = seat
    seatWeld.Part1 = part
    seatWeld.Parent = seat

    -- Teleport player above seat
    local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    local hrp = char:FindFirstChild("HumanoidRootPart")

    if hrp then
        hrp.CFrame = part.CFrame + Vector3.new(0, 3, 0) -- above seat
    end

    -- Detect sit and remove after unsit
    seat:GetPropertyChangedSignal("Occupant"):Connect(function()
        if seat.Occupant then
            local humanoid = seat.Occupant

            humanoid:GetPropertyChangedSignal("Sit"):Connect(function()
                if not humanoid.Sit then
                    if part then
                        part:Destroy()
                    end
                end
            end)
        end
    end)
end

-- Click detect
tool.Equipped:Connect(function()
    Mouse.Button1Down:Connect(function()
        local target = Mouse.Target
        if target and target.Parent then
            local playerClicked = Players:GetPlayerFromCharacter(target.Parent)
            if playerClicked then
                createSeat(playerClicked)
            end
        end
    end)
end)

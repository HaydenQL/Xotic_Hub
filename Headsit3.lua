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
    if targetHead:FindFirstChild("HeadSeat") then
        targetHead.HeadSeat:Destroy()
    end

    -- Create real sit-able seat
    local seat = Instance.new("Seat")
    seat.Name = "HeadSeat"
    seat.Size = Vector3.new(2, 1, 2)
    seat.CFrame = targetHead.CFrame * CFrame.new(0, 2, 0)
    seat.Anchored = false
    seat.CanCollide = true -- VERY IMPORTANT -> Must be true for player to sit
    seat.Transparency = 0.3 -- Visible but not ugly
    seat.Parent = targetHead

    -- Weld seat to head
    local weld = Instance.new("WeldConstraint")
    weld.Part0 = seat
    weld.Part1 = targetHead
    weld.Parent = seat

    -- Teleport player slightly above seat so they fall onto it and auto sit
    local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    local hrp = char:FindFirstChild("HumanoidRootPart")

    if hrp then
        hrp.CFrame = seat.CFrame + Vector3.new(0, 3, 0) -- Spawn slightly above seat
    end

    -- Detect when local player sits
    seat:GetPropertyChangedSignal("Occupant"):Connect(function()
        if seat.Occupant then
            local humanoid = seat.Occupant

            -- Remove seat when get off
            humanoid:GetPropertyChangedSignal("Sit"):Connect(function()
                if not humanoid.Sit then
                    if seat then
                        seat:Destroy()
                    end
                end
            end)
        end
    end)
end

-- Detect click on player
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

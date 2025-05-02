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
    if workspace:FindFirstChild("HeadSeat_" .. targetPlayer.Name) then
        workspace["HeadSeat_" .. targetPlayer.Name]:Destroy()
    end

    -- Create REAL sit-able seat (MUST parent to workspace first)
    local seat = Instance.new("Seat")
    seat.Name = "HeadSeat_" .. targetPlayer.Name
    seat.Size = Vector3.new(3, 1, 3)
    seat.CFrame = targetHead.CFrame * CFrame.new(0, 2, 0)
    seat.Anchored = false
    seat.CanCollide = true
    seat.Transparency = 0.3
    seat.Parent = workspace -- IMPORTANT -> this makes it real seat!

    -- Weld seat to head after parented
    local weld = Instance.new("WeldConstraint")
    weld.Part0 = seat
    weld.Part1 = targetHead
    weld.Parent = seat

    -- Teleport player above seat to sit
    local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    local hrp = char:FindFirstChild("HumanoidRootPart")

    if hrp then
        hrp.CFrame = seat.CFrame + Vector3.new(0, 3, 0)
    end

    -- Detect when sat and remove after unsit
    seat:GetPropertyChangedSignal("Occupant"):Connect(function()
        if seat.Occupant then
            local humanoid = seat.Occupant

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

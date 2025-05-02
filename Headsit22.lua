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

    -- Create seat
    local seat = Instance.new("Seat")
    seat.Name = "HeadSeat"
    seat.Size = Vector3.new(2, 1, 2)
    seat.CFrame = targetHead.CFrame * CFrame.new(0, 1.5, 0)
    seat.Anchored = false
    seat.CanCollide = true -- MAKE SEAT SOLID AND INTERACTABLE
    seat.Transparency = 0.2 -- Visible but not ugly
    seat.Parent = targetHead

    -- Weld seat to head
    local weld = Instance.new("WeldConstraint")
    weld.Part0 = seat
    weld.Part1 = targetHead
    weld.Parent = seat

    -- Teleport player on top of seat
    local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    local hrp = char:FindFirstChild("HumanoidRootPart")
    local humanoid = char:FindFirstChildWhichIsA("Humanoid")

    if hrp and humanoid then
        -- Put right above seat so player drops down gently
        hrp.CFrame = seat.CFrame + Vector3.new(0, 3, 0)

        -- Wait a tiny bit to let physics drop player on seat
        task.wait(0.2)

        -- Force sit (player will sit on seat since it's a Seat now)
        humanoid.Sit = true
    end

    -- Remove seat when unsit
    seat.ChildAdded:Connect(function(child)
        if child:IsA("Weld") and child.Part1 and child.Part1.Parent == char then
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

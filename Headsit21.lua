local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

-- Auto give tool
local tool = Instance.new("Tool")
tool.Name = "HeadSeatTool"
tool.RequiresHandle = false
tool.Parent = LocalPlayer.Backpack

local function createSeat(targetHead)
    -- Remove existing seat
    if targetHead:FindFirstChild("HeadSeat") then
        targetHead.HeadSeat:Destroy()
    end

    -- Create invisible seat
    local seat = Instance.new("Seat")
    seat.Name = "HeadSeat"
    seat.Size = Vector3.new(2, 1, 2)
    seat.CFrame = targetHead.CFrame * CFrame.new(0, 1.5, 0)
    seat.Anchored = false
    seat.CanCollide = false
    seat.Transparency = 1
    seat.Parent = targetHead

    -- Weld seat to head
    local weld = Instance.new("WeldConstraint")
    weld.Part0 = seat
    weld.Part1 = targetHead
    weld.Parent = seat

    -- Detect when someone sits
    seat.ChildAdded:Connect(function(child)
        if child:IsA("Weld") and child.Part1 and child.Part1.Parent == LocalPlayer.Character then
            local humanoid = LocalPlayer.Character:FindFirstChildWhichIsA("Humanoid")
            if humanoid then
                -- Detect when get off
                humanoid:GetPropertyChangedSignal("Sit"):Connect(function()
                    if not humanoid.Sit then
                        -- Remove seat when get off
                        if seat then
                            seat:Destroy()
                        end
                    end
                end)
            end
        end
    end)
end

-- On tool equipped, detect clicks
tool.Equipped:Connect(function()
    Mouse.Button1Down:Connect(function()
        local target = Mouse.Target
        if target and target.Parent then
            local plr = Players:GetPlayerFromCharacter(target.Parent)
            local head = plr and plr.Character and plr.Character:FindFirstChild("Head")
            if head then
                createSeat(head)
            end
        end
    end)
end)

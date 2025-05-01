--// Face Bang (Fixed, Pull Back and Forward - No GUI Version)

-- Settings
local FaceBangKey = Enum.KeyCode.Z
local Speed = 0.5 -- Pull/Thrust speed
local Distance = 5 -- How far to pull back

-- Services
local uis = game:GetService("UserInputService")
local runService = game:GetService("RunService")
local players = game:GetService("Players")
local player = players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

-- Internal Vars
local running = false
local conn
local loaded_face_bang = false

-- Stop Function
local function stop()
    loaded_face_bang = false
    if conn then
        conn:Disconnect()
        conn = nil
    end
    if humanoid then
        humanoid.PlatformStand = false
    end
    running = false
end

-- Start / Face Bang Function
local function fuck()
    if running then return end
    running = true

    local closest, dist = nil, math.huge
    loaded_face_bang = true

    for _, target in ipairs(players:GetPlayers()) do
        if target ~= player and target.Character then
            local head = target.Character:FindFirstChild('Head')
            if head then
                local d = (head.Position - humanoidRootPart.Position).Magnitude
                if d < dist then
                    closest = target
                    dist = d
                end
            end
        end
    end

    if not closest or not humanoidRootPart then
        running = false
        return
    end

    humanoid.PlatformStand = true
    local head = closest.Character:FindFirstChild("Head")
    local out = true
    local min = -0.9
    local max = -Distance
    local prog = 0
    local last = tick()

    conn = runService.Heartbeat:Connect(function()
        humanoidRootPart.Velocity = Vector3.new(0, 0, 0)

        local back = head.CFrame * CFrame.new(0, 0, 1)
        local front = head.CFrame * CFrame.new(0, 0, -1)
        local bPos = back.Position
        local fPos = front.Position
        local dir = (bPos - fPos).Unit

        local now = tick()
        local dt = now - last
        last = now

        local spd = 2 * Speed

        if out then
            prog = math.min(1, prog + dt * spd)
        else
            prog = math.max(0, prog - dt * spd)
        end

        local curr = min + (max - min) * prog
        local targetPos = bPos + dir * curr
        local currentPos = humanoidRootPart.Position
        local newPos = currentPos:Lerp(targetPos, 0.5) + Vector3.new(0, 0.5, 0)

        humanoidRootPart.CFrame = CFrame.new(newPos) * (head.CFrame - head.CFrame.Position) * CFrame.Angles(0, math.rad(180), 0)

        if prog >= 1 or prog <= 0 then
            out = not out
        end
    end)
end

-- Input Handler
runService:BindToRenderStep("FaceBangHold", Enum.RenderPriority.Camera.Value + 1, function()
    if not character or not humanoidRootPart then return end

    if uis:IsKeyDown(FaceBangKey) then
        if not loaded_face_bang then
            fuck()
        end
    else
        if loaded_face_bang then
            stop()
        end
    end
end)

-- Auto update on respawn
player.CharacterAdded:Connect(function(newChar)
    character = newChar
    humanoid = newChar:WaitForChild("Humanoid")
    humanoidRootPart = newChar:WaitForChild("HumanoidRootPart")
end)

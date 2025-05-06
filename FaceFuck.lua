--// FaceFuck UI + Functionality (FULL VERSION)

--// SETTINGS (Global Defaults)
getgenv().FaceBangKey = getgenv().FaceBangKey or Enum.KeyCode.Z
getgenv().FaceBangSpeed = getgenv().FaceBangSpeed or 7
getgenv().FaceBangDistance = getgenv().FaceBangDistance or 3

--// SERVICES
local uis = game:GetService("UserInputService")
local runService = game:GetService("RunService")
local players = game:GetService("Players")
local player = players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

--// UI Elements
local keybindLabel = ui:AddLabel(sections.settingsKeys, "FaceFuck Keybind: " .. getgenv().FaceBangKey.Name, UI_CONFIG.TextColor)

local waitingForKey = false

ui:AddButton(sections.settingsKeys, "Change FaceFuck Key", function()
    if waitingForKey then return end
    waitingForKey = true
    keybindLabel.Text = "Press any key..."

    local conn
    conn = uis.InputBegan:Connect(function(input, gameProcessed)
        if not gameProcessed and input.UserInputType == Enum.UserInputType.Keyboard then
            getgenv().FaceBangKey = input.KeyCode
            keybindLabel.Text = "FaceFuck Keybind: " .. getgenv().FaceBangKey.Name
            waitingForKey = false
            conn:Disconnect()
        end
    end)
end)

ui:AddSlider(sections.settingsKeys, "FaceFuck Speed", {
    min = 1,
    max = 20,
    default = getgenv().FaceBangSpeed,
}, function(value)
    getgenv().FaceBangSpeed = value
end)

ui:AddSlider(sections.settingsKeys, "FaceFuck Distance", {
    min = 1,
    max = 10,
    default = getgenv().FaceBangDistance,
}, function(value)
    getgenv().FaceBangDistance = value
end)

--// Face Fuck System Vars
local running = false
local conn
local loaded_face_bang = false

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

local function facefuck()
    if running then return end
    running = true

    local closest, dist = nil, math.huge
    loaded_face_bang = true

    for _, target in ipairs(players:GetPlayers()) do
        if target.Character and target ~= player then
            local head = target.Character:FindFirstChild("Head")
            if head and target.UserId ~= player.UserId then
                local d = (head.Position - humanoidRootPart.Position).Magnitude
                if d < dist then
                    closest = target
                    dist = d
                end
            end
        end
    end

    if not closest then
        running = false
        return
    end

    humanoid.PlatformStand = true
    local head = closest.Character:FindFirstChild("Head")
    local out = true
    local min = -0.9
    local max = -getgenv().FaceBangDistance
    local prog = 0
    local last = tick()

    conn = runService.Heartbeat:Connect(function()
        humanoidRootPart.Velocity = Vector3.new(0, 0, 0)

        local speed = getgenv().FaceBangSpeed
        local distance = getgenv().FaceBangDistance
        max = -distance

        local back = head.CFrame * CFrame.new(0, 0, 1)
        local front = head.CFrame * CFrame.new(0, 0, -1)
        local dir = (back.Position - front.Position).Unit

        local now = tick()
        local dt = now - last
        last = now

        local spd = 2 * speed

        if out then
            prog = math.min(1, prog + dt * spd)
        else
            prog = math.max(0, prog - dt * spd)
        end

        local curr = min + (max - min) * prog
        local targetPos = back.Position + dir * curr
        local newPos = humanoidRootPart.Position:Lerp(targetPos, 0.5) + Vector3.new(0, 0.5, 0)

        humanoidRootPart.CFrame = CFrame.new(newPos) * (head.CFrame - head.CFrame.Position) * CFrame.Angles(0, math.rad(180), 0)

        if prog >= 1 or prog <= 0 then
            out = not out
        end
    end)
end

--// Input Handler
runService:BindToRenderStep("FaceFuckHandler", Enum.RenderPriority.Camera.Value + 1, function()
    if not character or not humanoidRootPart then return end

    if uis:IsKeyDown(getgenv().FaceBangKey) then
        if not loaded_face_bang then
            facefuck()
        end
    else
        if loaded_face_bang then
            stop()
        end
    end
end)

--// Auto Update on Respawn
player.CharacterAdded:Connect(function(newChar)
    character = newChar
    humanoid = newChar:WaitForChild("Humanoid")
    humanoidRootPart = newChar:WaitForChild("HumanoidRootPart")
end)

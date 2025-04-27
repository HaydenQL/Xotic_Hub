
-- SigmaHub V2 Pro (FULL CODE)

local UIS = game:GetService("UserInputService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")

for _, gui in pairs(CoreGui:GetChildren()) do
    if gui.Name:match("^HUI%d%d%d%d%d$") then gui:Destroy() end
end

local stealthName = "HUI" .. tostring(math.random(10000,99999))
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = stealthName
ScreenGui.DisplayOrder = 999
ScreenGui.IgnoreGuiInset = true
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = CoreGui

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 600, 0, 400)
MainFrame.Position = UDim2.new(0.5, -300, 0.5, -200)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local function makeCorner(obj)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent = obj
end
makeCorner(MainFrame)

local TopBar = Instance.new("Frame")
TopBar.Size = UDim2.new(1, 0, 0, 40)
TopBar.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
TopBar.BorderSizePixel = 0
TopBar.Parent = MainFrame
makeCorner(TopBar)

local TabLayout = Instance.new("UIListLayout")
TabLayout.FillDirection = Enum.FillDirection.Horizontal
TabLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left
TabLayout.VerticalAlignment = Enum.VerticalAlignment.Center
TabLayout.Padding = UDim.new(0, 6)
TabLayout.Parent = TopBar

local Tabs = {"Home", "Player", "Visual", "VoiceChat", "Settings", "Credits", "Admin"}
local ContentFrames = {}

local Content = Instance.new("Frame")
Content.Size = UDim2.new(1, 0, 1, -40)
Content.Position = UDim2.new(0, 0, 0, 40)
Content.BackgroundTransparency = 1
Content.Parent = MainFrame

for _, name in ipairs(Tabs) do
    local tab = Instance.new("TextButton")
    tab.Size = UDim2.new(0, 80, 1, 0)
    tab.Text = name
    tab.TextColor3 = Color3.fromRGB(220, 220, 220)
    tab.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    tab.Font = Enum.Font.GothamBold
    tab.TextSize = 14
    tab.Parent = TopBar
    makeCorner(tab)

    local frame = Instance.new("ScrollingFrame")
    frame.Size = UDim2.new(1, 0, 1, 0)
    frame.CanvasSize = UDim2.new(0, 0, 2, 0)
    frame.BackgroundTransparency = 1
    frame.Visible = false
    frame.ScrollBarThickness = 4
    frame.Parent = Content
    ContentFrames[name] = frame

    tab.MouseButton1Click:Connect(function()
        for _, fr in pairs(ContentFrames) do
            fr.Visible = false
        end
        frame.Visible = true
    end)
end
ContentFrames["Home"].Visible = true

local function addButton(frame, text, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 200, 0, 40)
    btn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 14
    btn.Parent = frame
    makeCorner(btn)
    btn.MouseButton1Click:Connect(callback)
end

-- HOME
addButton(ContentFrames["Home"], "Launch Infinite Yield", function()
    loadstring(game:HttpGet('https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source'))()
end)

-- PLAYER
addButton(ContentFrames["Player"], "Reset WalkSpeed to 16", function()
    if LocalPlayer.Character then
        local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if hum then hum.WalkSpeed = 16 end
    end
end)

addButton(ContentFrames["Player"], "Reset JumpPower to 50", function()
    if LocalPlayer.Character then
        local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if hum then hum.JumpPower = 50 end
    end
end)

addButton(ContentFrames["Player"], "Reset Gravity to 196.2", function()
    workspace.Gravity = 196.2
end)

-- VISUAL
addButton(ContentFrames["Visual"], "Spin & Die", function()
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        local spin = Instance.new("BodyAngularVelocity", char.HumanoidRootPart)
        spin.AngularVelocity = Vector3.new(0, 100, 0)
        spin.MaxTorque = Vector3.new(1, 1, 1) * 100000
        spin.P = 1000
        task.wait(2)
        spin:Destroy()
    end
end)

-- SETTINGS
addButton(ContentFrames["Settings"], "Extend Baseplate", function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/8973951821973068216/11374577211057006363/refs/heads/main/Baseplate"))()
end)

addButton(ContentFrames["Settings"], "Rean", function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/HaydenQL/Chat-bypass/refs/heads/main/rean.lua"))()
end)

-- VOICECHAT
addButton(ContentFrames["VoiceChat"], "Rejoin VoiceChat", function()
    game:GetService("VoiceChatService"):JoinVoice()
end)

-- CREDITS
local credit = Instance.new("TextLabel")
credit.Size = UDim2.new(1, -40, 0, 30)
credit.Position = UDim2.new(0, 20, 0, 20)
credit.BackgroundTransparency = 1
credit.Text = "Made by Hayden"
credit.TextColor3 = Color3.fromRGB(200, 200, 200)
credit.Font = Enum.Font.Gotham
credit.TextSize = 16
credit.TextXAlignment = Enum.TextXAlignment.Left
credit.Parent = ContentFrames["Credits"]

-- ADMIN UNLOCK
LocalPlayer.Chatted:Connect(function(msg)
    if msg:lower() == "!admin" then
        ContentFrames["Admin"].Visible = true
    end
end)

-- K Toggle
local guiOpen = true
UIS.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.K then
        guiOpen = not guiOpen
        ScreenGui.Enabled = guiOpen
    end
end)

-- START OF CHUNK 1 --

-- // CELESTE ORGANIZED SCRIPT // --
-- Deep organized: Tabs, Frames, Functions, Protection

--!nolint BuiltinGlobalWrite
--!optimize 2
--!native

-- ===================================================
-- [CELESTE PROTECTION SETUP]
-- Disables logging outputs to prevent detection
-- Hooks HttpGet to protect requests
-- ===================================================

if getconnections then
    if cloneref then
        for _,v in pairs(getconnections(cloneref(game:GetService("LogService")).MessageOut)) do v:Disable() end
        for _,v in pairs(getconnections(cloneref(game:GetService("ScriptContext")).Error)) do v:Disable() end
    else
        for _,v in pairs(getconnections(game:GetService("LogService")).MessageOut) do v:Disable() end
        for _,v in pairs(getconnections(game:GetService("ScriptContext")).Error) do v:Disable() end
    end
    warn("[Celeste] -> DISCONNECTED ALL CONSOLE CONNECTIONS")
end

-- ===================================================
-- [CELESTE RANDOM STRING FUNCTION]
-- Used to generate random names for GUIs and instances
-- ===================================================

local function randomHex(len)
    local str = ""
    for i = 1, len do
        str = str .. string.format("%x", math.random(0, 15))
    end
    return str
end

local function randstr()
    local uuid = table.concat({
        randomHex(8),
        randomHex(4),
        randomHex(4),
        randomHex(4),
        randomHex(12)
    }, "-")
    return  "HelloSkid_" .. uuid
end

-- Create random IDs for the UI components
local CELESTE_UI_ID = randstr()
local NOTIFICATIONS_ID = randstr()

local function getrandstr()
    return randstr()
end

-- ===================================================
-- [CELESTE LOGGING SYSTEM]
-- Custom console outputs for Celeste events
-- ===================================================

sep = string.rep("\n", 200)
print("                             v LATEST LOGS OF CELESTE ARE BELOW v"..sep.."            > Starting Celeste")
warn("[Celeste] -> Starting...")

local logging = true
local function log(...)
    if logging then
        warn("[Celeste] -> " .. ...)
    end
end

local function seperate(job)
    if logging then
        print("> "..job)
    end
end

log("Logging is enabled.")
seperate("Protection")

-- ===================================================
-- [HTTPGET PROTECTION HOOK]
-- Hooks game.HttpGet to prevent leaking URL access
-- ===================================================

if hookfunction and newcclosure then
    local originalHttpGet = game.HttpGet
    hookfunction(game.HttpGet, newcclosure(function(self, ...)
        if self == game then
            local url = select(1, ...)
            if url == originalHttpGet then
                log("HttpGet protection triggered")
                while true do end
                return nil
            end
        end
        return originalHttpGet(self, ...)
    end))
    log("Hooked HttpGet.")
end

-- ===================================================
-- [SERVICE WRAPPER FUNCTIONS]
-- Define game services with cloneref where possible
-- ===================================================

local rawgs = clonefunction and clonefunction(game.GetService) or game.GetService
function gs(service)
    local ok, result = pcall(function()
        return rawgs(game, service)
    end)
    if ok and result then
        log("Got service '" .. service .. "' successfully")
        return result
    else
        log("Failed to get service '" .. service .. "'")
        return nil
    end
end

function define(instance)
    if cloneref then
        local ok, protected = pcall(cloneref, instance)
        if ok and protected then
            log("Protected instance '" .. tostring(instance) .. "' with cloneref")
            return protected
        else
            log("cloneref failed for '" .. tostring(instance) .. "'")
        end
    else
        log("cloneref not available, returning raw instance '" .. tostring(instance) .. "'")
    end
    return instance
end

-- ===================================================
-- [DEFINE SERVICES USED BY CELESTE]
-- HttpService, TweenService, RunService, UIS, Players
-- ===================================================

local HttpService = define(gs("HttpService"))
local TweenService = define(gs("TweenService"))
local RunService = define(gs("RunService"))
local UserInputService = define(gs("UserInputService"))
local Players = define(gs("Players"))
local player = define(Players.LocalPlayer)

-- ===================================================
-- [HTTP REQUEST FUNCTION]
-- Auto-detects the best available HTTP request method
-- ===================================================

local httpRequest = syn and syn.request
             or http and http.request
             or request
             or http_request
             or _request
assert(httpRequest, "No HTTP request function found!")

-- ===================================================
-- [CREATE BASE SCREEN GUI]
-- The master Celeste UI container attached to CoreGui
-- ===================================================

local screenGui = Instance.new("ScreenGui")
screenGui.Name = randstr()
screenGui.ResetOnSpawn = false
screenGui.Parent = gethui()

-- ===================================================
-- [END OF CHUNK 1]
-- Ready to move to GUI Layout + Tab System Creation next
-- ===================================================

-- END OF CHUNK 1 --
-- START OF CHUNK 2 --

-- ===================================================
-- [CREATE PRIMARY CONTAINERS]
-- Set up main Frame, TopBar, Sidebar for Tabs
-- ===================================================

-- Main background frame for Celeste
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 500, 0, 350)
mainFrame.Position = UDim2.new(0.5, -250, 0.5, -175)
mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = screenGui

-- TopBar (Title, Close/Minimize Buttons)
local topBar = Instance.new("Frame")
topBar.Name = "TopBar"
topBar.Size = UDim2.new(1, 0, 0, 30)
topBar.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
topBar.BorderSizePixel = 0
topBar.Parent = mainFrame

-- Title TextLabel
local titleLabel = Instance.new("TextLabel")
titleLabel.Name = "TitleLabel"
titleLabel.Size = UDim2.new(1, -60, 1, 0)
titleLabel.Position = UDim2.new(0, 10, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "Celeste Hub"
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.TextSize = 16
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.Parent = topBar

-- Minimize Button
local minimizeButton = Instance.new("TextButton")
minimizeButton.Name = "MinimizeButton"
minimizeButton.Size = UDim2.new(0, 25, 1, 0)
minimizeButton.Position = UDim2.new(1, -55, 0, 0)
minimizeButton.BackgroundTransparency = 1
minimizeButton.Text = "-"
minimizeButton.Font = Enum.Font.GothamBold
minimizeButton.TextColor3 = Color3.fromRGB(200, 200, 200)
minimizeButton.TextSize = 20
minimizeButton.Parent = topBar

-- Close Button
local closeButton = Instance.new("TextButton")
closeButton.Name = "CloseButton"
closeButton.Size = UDim2.new(0, 25, 1, 0)
closeButton.Position = UDim2.new(1, -30, 0, 0)
closeButton.BackgroundTransparency = 1
closeButton.Text = "X"
closeButton.Font = Enum.Font.GothamBold
closeButton.TextColor3 = Color3.fromRGB(200, 80, 80)
closeButton.TextSize = 18
closeButton.Parent = topBar

-- Sidebar for Tabs
local sidebar = Instance.new("Frame")
sidebar.Name = "Sidebar"
sidebar.Size = UDim2.new(0, 100, 1, -30)
sidebar.Position = UDim2.new(0, 0, 0, 30)
sidebar.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
sidebar.BorderSizePixel = 0
sidebar.Parent = mainFrame

-- Main Tab Container (where each tab content will go)
local tabContainer = Instance.new("Frame")
tabContainer.Name = "TabContainer"
tabContainer.Size = UDim2.new(1, -100, 1, -30)
tabContainer.Position = UDim2.new(0, 100, 0, 30)
tabContainer.BackgroundTransparency = 1
tabContainer.Parent = mainFrame

-- ===================================================
-- [SIDEBAR BUTTON TEMPLATE FUNCTION]
-- Utility to create sidebar tab buttons easily
-- ===================================================

local function createSidebarButton(text)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(1, 0, 0, 30)
    button.BackgroundTransparency = 1
    button.Text = text
    button.Font = Enum.Font.GothamSemibold
    button.TextColor3 = Color3.fromRGB(200, 200, 200)
    button.TextSize = 14
    button.AutoButtonColor = false
    button.Name = text.."TabButton"
    return button
end

-- ===================================================
-- [CREATE TABS]
-- Tabs: Home, Player, Animation, OSINT, Settings
-- ===================================================

-- Home Tab
local homeTabButton = createSidebarButton("Home")
homeTabButton.Position = UDim2.new(0, 0, 0, 0)
homeTabButton.Parent = sidebar

local homeTab = Instance.new("Frame")
homeTab.Name = "HomeTab"
homeTab.Size = UDim2.new(1, 0, 1, 0)
homeTab.BackgroundTransparency = 1
homeTab.Visible = true
homeTab.Parent = tabContainer

-- Player Tab
local playerTabButton = createSidebarButton("Player")
playerTabButton.Position = UDim2.new(0, 0, 0, 30)
playerTabButton.Parent = sidebar

local playerTab = Instance.new("Frame")
playerTab.Name = "PlayerTab"
playerTab.Size = UDim2.new(1, 0, 1, 0)
playerTab.BackgroundTransparency = 1
playerTab.Visible = false
playerTab.Parent = tabContainer

-- Animation Tab
local animationTabButton = createSidebarButton("Animation")
animationTabButton.Position = UDim2.new(0, 0, 0, 60)
animationTabButton.Parent = sidebar

local animationTab = Instance.new("Frame")
animationTab.Name = "AnimationTab"
animationTab.Size = UDim2.new(1, 0, 1, 0)
animationTab.BackgroundTransparency = 1
animationTab.Visible = false
animationTab.Parent = tabContainer

-- OSINT Tab
local osintTabButton = createSidebarButton("OSINT")
osintTabButton.Position = UDim2.new(0, 0, 0, 90)
osintTabButton.Parent = sidebar

local osintTab = Instance.new("Frame")
osintTab.Name = "OSINTTab"
osintTab.Size = UDim2.new(1, 0, 1, 0)
osintTab.BackgroundTransparency = 1
osintTab.Visible = false
osintTab.Parent = tabContainer

-- Settings Tab
local settingsTabButton = createSidebarButton("Settings")
settingsTabButton.Position = UDim2.new(0, 0, 0, 120)
settingsTabButton.Parent = sidebar

local settingsTab = Instance.new("Frame")
settingsTab.Name = "SettingsTab"
settingsTab.Size = UDim2.new(1, 0, 1, 0)
settingsTab.BackgroundTransparency = 1
settingsTab.Visible = false
settingsTab.Parent = tabContainer

-- ===================================================
-- [END OF CHUNK 2]
-- Ready to move onto sidebar button switching + content layout next
-- ===================================================

-- END OF CHUNK 2 --
-- START OF CHUNK 3 --

-- ===================================================
-- [SIDEBAR BUTTON LOGIC]
-- Set up switching between tabs when clicking sidebar buttons
-- ===================================================

-- Utility function to hide all tabs
local function hideAllTabs()
    for _, tab in ipairs(tabContainer:GetChildren()) do
        if tab:IsA("Frame") then
            tab.Visible = false
        end
    end
end

-- Utility function to reset all sidebar buttons color
local function resetSidebarButtons()
    for _, button in ipairs(sidebar:GetChildren()) do
        if button:IsA("TextButton") then
            button.TextColor3 = Color3.fromRGB(200, 200, 200)
        end
    end
end

-- Sidebar button click handlers
homeTabButton.MouseButton1Click:Connect(function()
    hideAllTabs()
    resetSidebarButtons()
    homeTab.Visible = true
    homeTabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
end)

playerTabButton.MouseButton1Click:Connect(function()
    hideAllTabs()
    resetSidebarButtons()
    playerTab.Visible = true
    playerTabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
end)

animationTabButton.MouseButton1Click:Connect(function()
    hideAllTabs()
    resetSidebarButtons()
    animationTab.Visible = true
    animationTabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
end)

osintTabButton.MouseButton1Click:Connect(function()
    hideAllTabs()
    resetSidebarButtons()
    osintTab.Visible = true
    osintTabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
end)

settingsTabButton.MouseButton1Click:Connect(function()
    hideAllTabs()
    resetSidebarButtons()
    settingsTab.Visible = true
    settingsTabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
end)

-- ===================================================
-- [MINIMIZE AND CLOSE BUTTON LOGIC]
-- Hide or destroy the main GUI
-- ===================================================

local minimized = false

minimizeButton.MouseButton1Click:Connect(function()
    minimized = not minimized
    tabContainer.Visible = not minimized
    sidebar.Visible = not minimized
    if minimized then
        mainFrame.Size = UDim2.new(0, 500, 0, 30)
    else
        mainFrame.Size = UDim2.new(0, 500, 0, 350)
    end
end)

closeButton.MouseButton1Click:Connect(function()
    screenGui:Destroy()
end)

-- ===================================================
-- [HOME TAB LAYOUT]
-- Start placing buttons and options inside HomeTab
-- ===================================================

-- Example button inside Home Tab (you can add more)
local exampleButton = Instance.new("TextButton")
exampleButton.Name = "ExampleButton"
exampleButton.Size = UDim2.new(0, 120, 0, 40)
exampleButton.Position = UDim2.new(0, 20, 0, 20)
exampleButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
exampleButton.Text = "Example Action"
exampleButton.Font = Enum.Font.GothamSemibold
exampleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
exampleButton.TextSize = 14
exampleButton.Parent = homeTab

exampleButton.MouseButton1Click:Connect(function()
    log("Example button clicked.")
end)

-- ===================================================
-- [END OF CHUNK 3]
-- Ready to start building Player Tab content next
-- ===================================================

-- END OF CHUNK 3 --

-- START OF CHUNK 4 --

-- ===================================================
-- [PLAYER TAB LAYOUT]
-- Add WalkSpeed, JumpPower, Infinite Jump, Fly, and Noclip Features
-- ===================================================

-- WalkSpeed Label
local walkspeedLabel = Instance.new("TextLabel")
walkspeedLabel.Name = "WalkspeedLabel"
walkspeedLabel.Size = UDim2.new(0, 100, 0, 20)
walkspeedLabel.Position = UDim2.new(0, 20, 0, 20)
walkspeedLabel.BackgroundTransparency = 1
walkspeedLabel.Text = "WalkSpeed:"
walkspeedLabel.Font = Enum.Font.GothamSemibold
walkspeedLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
walkspeedLabel.TextSize = 14
walkspeedLabel.TextXAlignment = Enum.TextXAlignment.Left
walkspeedLabel.Parent = playerTab

-- WalkSpeed TextBox
local walkspeedBox = Instance.new("TextBox")
walkspeedBox.Name = "WalkspeedBox"
walkspeedBox.Size = UDim2.new(0, 100, 0, 30)
walkspeedBox.Position = UDim2.new(0, 20, 0, 50)
walkspeedBox.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
walkspeedBox.Text = "16"
walkspeedBox.Font = Enum.Font.GothamSemibold
walkspeedBox.TextColor3 = Color3.fromRGB(255, 255, 255)
walkspeedBox.TextSize = 14
walkspeedBox.ClearTextOnFocus = false
walkspeedBox.Parent = playerTab

walkspeedBox.FocusLost:Connect(function()
    local speed = tonumber(walkspeedBox.Text)
    if speed then
        player.Character.Humanoid.WalkSpeed = speed
        log("WalkSpeed set to "..speed)
    end
end)

-- JumpPower Label
local jumppowerLabel = Instance.new("TextLabel")
jumppowerLabel.Name = "JumpPowerLabel"
jumppowerLabel.Size = UDim2.new(0, 100, 0, 20)
jumppowerLabel.Position = UDim2.new(0, 20, 0, 100)
jumppowerLabel.BackgroundTransparency = 1
jumppowerLabel.Text = "JumpPower:"
jumppowerLabel.Font = Enum.Font.GothamSemibold
jumppowerLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
jumppowerLabel.TextSize = 14
jumppowerLabel.TextXAlignment = Enum.TextXAlignment.Left
jumppowerLabel.Parent = playerTab

-- JumpPower TextBox
local jumppowerBox = Instance.new("TextBox")
jumppowerBox.Name = "JumpPowerBox"
jumppowerBox.Size = UDim2.new(0, 100, 0, 30)
jumppowerBox.Position = UDim2.new(0, 20, 0, 130)
jumppowerBox.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
jumppowerBox.Text = "50"
jumppowerBox.Font = Enum.Font.GothamSemibold
jumppowerBox.TextColor3 = Color3.fromRGB(255, 255, 255)
jumppowerBox.TextSize = 14
jumppowerBox.ClearTextOnFocus = false
jumppowerBox.Parent = playerTab

jumppowerBox.FocusLost:Connect(function()
    local power = tonumber(jumppowerBox.Text)
    if power then
        player.Character.Humanoid.JumpPower = power
        log("JumpPower set to "..power)
    end
end)

-- ===================================================
-- [INFINITE JUMP TOGGLE]
-- Toggle Infinite Jump on/off
-- ===================================================

local infiniteJumpEnabled = false

local infiniteJumpButton = Instance.new("TextButton")
infiniteJumpButton.Name = "InfiniteJumpButton"
infiniteJumpButton.Size = UDim2.new(0, 150, 0, 30)
infiniteJumpButton.Position = UDim2.new(0, 20, 0, 180)
infiniteJumpButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
infiniteJumpButton.Text = "Infinite Jump: OFF"
infiniteJumpButton.Font = Enum.Font.GothamSemibold
infiniteJumpButton.TextColor3 = Color3.fromRGB(255, 255, 255)
infiniteJumpButton.TextSize = 14
infiniteJumpButton.Parent = playerTab

local function infiniteJump()
    game:GetService("UserInputService").JumpRequest:Connect(function()
        if infiniteJumpEnabled then
            player.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
        end
    end)
end

infiniteJump()

infiniteJumpButton.MouseButton1Click:Connect(function()
    infiniteJumpEnabled = not infiniteJumpEnabled
    if infiniteJumpEnabled then
        infiniteJumpButton.Text = "Infinite Jump: ON"
        log("Infinite Jump Enabled")
    else
        infiniteJumpButton.Text = "Infinite Jump: OFF"
        log("Infinite Jump Disabled")
    end
end)

-- ===================================================
-- [FLY AND NOCLIP]
-- Setting up basic fly toggle and noclip
-- ===================================================

-- (FLY setup will come soon in a separate chunk to avoid script cutoff)

-- ===================================================
-- [END OF CHUNK 4]
-- Ready to continue building Flying, Noclip, and Animation Systems next
-- ===================================================

-- END OF CHUNK 4 --
-- START OF CHUNK 5 --

-- ===================================================
-- [FLY SCRIPT SETUP]
-- Enable and disable flight mode
-- ===================================================

local flying = false
local flySpeed = 50
local flyControl = {F = 0, B = 0, L = 0, R = 0}
local flyBodyGyro, flyBodyVelocity

local function fly()
    local humanoidRootPart = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    if not humanoidRootPart then return end

    flyBodyGyro = Instance.new("BodyGyro")
    flyBodyGyro.P = 9e4
    flyBodyGyro.Parent = humanoidRootPart
    flyBodyGyro.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
    flyBodyGyro.CFrame = humanoidRootPart.CFrame

    flyBodyVelocity = Instance.new("BodyVelocity")
    flyBodyVelocity.Velocity = Vector3.new(0, 0, 0)
    flyBodyVelocity.MaxForce = Vector3.new(9e9, 9e9, 9e9)
    flyBodyVelocity.Parent = humanoidRootPart

    RunService.RenderStepped:Connect(function()
        if flying and player and player.Character and humanoidRootPart then
            local newVelocity = Vector3.new(
                (flyControl.L + flyControl.R) * flySpeed,
                0,
                (flyControl.F + flyControl.B) * flySpeed
            )
            flyBodyVelocity.Velocity = humanoidRootPart.CFrame:VectorToWorldSpace(newVelocity)
            flyBodyGyro.CFrame = humanoidRootPart.CFrame
        end
    end)
end

local flyButton = Instance.new("TextButton")
flyButton.Name = "FlyButton"
flyButton.Size = UDim2.new(0, 150, 0, 30)
flyButton.Position = UDim2.new(0, 20, 0, 230)
flyButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
flyButton.Text = "Fly: OFF"
flyButton.Font = Enum.Font.GothamSemibold
flyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
flyButton.TextSize = 14
flyButton.Parent = playerTab

flyButton.MouseButton1Click:Connect(function()
    flying = not flying
    if flying then
        flyButton.Text = "Fly: ON"
        fly()
        log("Flight Enabled")
    else
        flyButton.Text = "Fly: OFF"
        if flyBodyGyro then flyBodyGyro:Destroy() end
        if flyBodyVelocity then flyBodyVelocity:Destroy() end
        log("Flight Disabled")
    end
end)

UserInputService.InputBegan:Connect(function(input, processed)
    if processed then return end
    if input.KeyCode == Enum.KeyCode.W then flyControl.F = 1 end
    if input.KeyCode == Enum.KeyCode.S then flyControl.B = -1 end
    if input.KeyCode == Enum.KeyCode.A then flyControl.L = -1 end
    if input.KeyCode == Enum.KeyCode.D then flyControl.R = 1 end
end)

UserInputService.InputEnded:Connect(function(input, processed)
    if input.KeyCode == Enum.KeyCode.W then flyControl.F = 0 end
    if input.KeyCode == Enum.KeyCode.S then flyControl.B = 0 end
    if input.KeyCode == Enum.KeyCode.A then flyControl.L = 0 end
    if input.KeyCode == Enum.KeyCode.D then flyControl.R = 0 end
end)

-- ===================================================
-- [NOCLIP SCRIPT SETUP]
-- Allow player to walk through walls
-- ===================================================

local noclipEnabled = false

local noclipButton = Instance.new("TextButton")
noclipButton.Name = "NoclipButton"
noclipButton.Size = UDim2.new(0, 150, 0, 30)
noclipButton.Position = UDim2.new(0, 20, 0, 280)
noclipButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
noclipButton.Text = "Noclip: OFF"
noclipButton.Font = Enum.Font.GothamSemibold
noclipButton.TextColor3 = Color3.fromRGB(255, 255, 255)
noclipButton.TextSize = 14
noclipButton.Parent = playerTab

RunService.Stepped:Connect(function()
    if noclipEnabled and player.Character then
        for _, part in ipairs(player.Character:GetDescendants()) do
            if part:IsA("BasePart") and part.CanCollide then
                part.CanCollide = false
            end
        end
    end
end)

noclipButton.MouseButton1Click:Connect(function()
    noclipEnabled = not noclipEnabled
    if noclipEnabled then
        noclipButton.Text = "Noclip: ON"
        log("Noclip Enabled")
    else
        noclipButton.Text = "Noclip: OFF"
        log("Noclip Disabled")
    end
end)

-- ===================================================
-- [NEXT SYSTEM: Animation Manager Setup]
-- Building Animation loading, playing, and management UI next
-- ===================================================

-- END OF CHUNK 5 --
-- START OF CHUNK 6 --

-- ===================================================
-- [ANIMATION MANAGER UI SETUP]
-- Building the Animations tab contents
-- ===================================================

-- Play Animation Button
local playAnimationButton = Instance.new("TextButton")
playAnimationButton.Name = "PlayAnimationButton"
playAnimationButton.Size = UDim2.new(0, 150, 0, 30)
playAnimationButton.Position = UDim2.new(0, 20, 0, 20)
playAnimationButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
playAnimationButton.Text = "Play Animation"
playAnimationButton.Font = Enum.Font.GothamSemibold
playAnimationButton.TextColor3 = Color3.fromRGB(255, 255, 255)
playAnimationButton.TextSize = 14
playAnimationButton.Parent = animationTab

-- Stop Animation Button
local stopAnimationButton = Instance.new("TextButton")
stopAnimationButton.Name = "StopAnimationButton"
stopAnimationButton.Size = UDim2.new(0, 150, 0, 30)
stopAnimationButton.Position = UDim2.new(0, 20, 0, 60)
stopAnimationButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
stopAnimationButton.Text = "Stop Animation"
stopAnimationButton.Font = Enum.Font.GothamSemibold
stopAnimationButton.TextColor3 = Color3.fromRGB(255, 255, 255)
stopAnimationButton.TextSize = 14
stopAnimationButton.Parent = animationTab

-- Animation ID Input Box
local animationIdBox = Instance.new("TextBox")
animationIdBox.Name = "AnimationIdBox"
animationIdBox.Size = UDim2.new(0, 200, 0, 30)
animationIdBox.Position = UDim2.new(0, 20, 0, 110)
animationIdBox.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
animationIdBox.PlaceholderText = "Animation ID here..."
animationIdBox.Font = Enum.Font.GothamSemibold
animationIdBox.TextColor3 = Color3.fromRGB(255, 255, 255)
animationIdBox.TextSize = 14
animationIdBox.ClearTextOnFocus = false
animationIdBox.Parent = animationTab

-- ===================================================
-- [ANIMATION SYSTEM CORE VARIABLES]
-- Handle animations playing, stopping, loading
-- ===================================================

local animationTrack
local humanoid = nil

local function getHumanoid()
    if player.Character then
        return player.Character:FindFirstChildWhichIsA("Humanoid")
    end
    return nil
end

local function loadAnimation(id)
    humanoid = getHumanoid()
    if humanoid then
        local animation = Instance.new("Animation")
        animation.AnimationId = "rbxassetid://"..id
        animationTrack = humanoid:LoadAnimation(animation)
    end
end

local function playAnimation()
    if animationTrack then
        animationTrack:Play()
        log("Playing Animation")
    end
end

local function stopAnimation()
    if animationTrack then
        animationTrack:Stop()
        log("Stopping Animation")
    end
end

-- ===================================================
-- [ANIMATION BUTTON CONNECTIONS]
-- Hook up Play and Stop buttons to animation functions
-- ===================================================

playAnimationButton.MouseButton1Click:Connect(function()
    if animationIdBox.Text and animationIdBox.Text ~= "" then
        loadAnimation(animationIdBox.Text)
        playAnimation()
    else
        log("No Animation ID Entered!")
    end
end)

stopAnimationButton.MouseButton1Click:Connect(function()
    stopAnimation()
end)

-- ===================================================
-- [END OF CHUNK 6]
-- Next: OSINT Search System Setup
-- ===================================================

-- END OF CHUNK 6 --
-- START OF CHUNK 7 --

-- ===================================================
-- [OSINT SEARCH SYSTEM UI SETUP]
-- Building Username Lookup interface
-- ===================================================

-- Username Input Box
local usernameBox = Instance.new("TextBox")
usernameBox.Name = "UsernameBox"
usernameBox.Size = UDim2.new(0, 200, 0, 30)
usernameBox.Position = UDim2.new(0, 20, 0, 20)
usernameBox.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
usernameBox.PlaceholderText = "Enter Username..."
usernameBox.Font = Enum.Font.GothamSemibold
usernameBox.TextColor3 = Color3.fromRGB(255, 255, 255)
usernameBox.TextSize = 14
usernameBox.ClearTextOnFocus = false
usernameBox.Parent = osintTab

-- Search Button
local searchButton = Instance.new("TextButton")
searchButton.Name = "SearchButton"
searchButton.Size = UDim2.new(0, 150, 0, 30)
searchButton.Position = UDim2.new(0, 20, 0, 70)
searchButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
searchButton.Text = "Search"
searchButton.Font = Enum.Font.GothamSemibold
searchButton.TextColor3 = Color3.fromRGB(255, 255, 255)
searchButton.TextSize = 14
searchButton.Parent = osintTab

-- Result Label
local resultLabel = Instance.new("TextLabel")
resultLabel.Name = "ResultLabel"
resultLabel.Size = UDim2.new(0, 400, 0, 200)
resultLabel.Position = UDim2.new(0, 20, 0, 120)
resultLabel.BackgroundTransparency = 1
resultLabel.Text = ""
resultLabel.TextWrapped = true
resultLabel.TextYAlignment = Enum.TextYAlignment.Top
resultLabel.Font = Enum.Font.Gotham
resultLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
resultLabel.TextSize = 14
resultLabel.Parent = osintTab

-- ===================================================
-- [OSINT SEARCH FUNCTION]
-- Sends a request to an external API to lookup username info
-- ===================================================

local function searchUsername(username)
    if not username or username == "" then
        resultLabel.Text = "Enter a username first!"
        return
    end

    resultLabel.Text = "Searching for "..username.."..."

    -- Replace this with your actual API URL
    local apiURL = "https://api.kamiblackout.dev/robloxosint?username="..username

    local response
    pcall(function()
        response = httpRequest({
            Url = apiURL,
            Method = "GET"
        })
    end)

    if not response then
        resultLabel.Text = "Failed to get a response."
        return
    end

    if response.Success then
        local data = HttpService:JSONDecode(response.Body)
        if data then
            resultLabel.Text = "Username Found!\n\nID: "..(data.id or "N/A").."\nFriends: "..(data.friendCount or "N/A").."\nFollowers: "..(data.followerCount or "N/A")
        else
            resultLabel.Text = "No data found for "..username.."."
        end
    else
        resultLabel.Text = "Search failed. Try again."
    end
end

-- ===================================================
-- [SEARCH BUTTON CONNECTION]
-- Connect Search button to the username search function
-- ===================================================

searchButton.MouseButton1Click:Connect(function()
    local username = usernameBox.Text
    searchUsername(username)
end)

-- ===================================================
-- [END OF CHUNK 7]
-- Next: Settings Tab Setup and Finalizations
-- ===================================================

-- END OF CHUNK 7 --
-- START OF CHUNK 8 --

-- ===================================================
-- [SETTINGS TAB UI SETUP]
-- Theme Settings, Reset UI Button, Miscellaneous Options
-- ===================================================

-- Theme Label
local themeLabel = Instance.new("TextLabel")
themeLabel.Name = "ThemeLabel"
themeLabel.Size = UDim2.new(0, 200, 0, 20)
themeLabel.Position = UDim2.new(0, 20, 0, 20)
themeLabel.BackgroundTransparency = 1
themeLabel.Text = "Theme Options:"
themeLabel.Font = Enum.Font.GothamSemibold
themeLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
themeLabel.TextSize = 16
themeLabel.TextXAlignment = Enum.TextXAlignment.Left
themeLabel.Parent = settingsTab

-- Dark Theme Button
local darkThemeButton = Instance.new("TextButton")
darkThemeButton.Name = "DarkThemeButton"
darkThemeButton.Size = UDim2.new(0, 150, 0, 30)
darkThemeButton.Position = UDim2.new(0, 20, 0, 50)
darkThemeButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
darkThemeButton.Text = "Dark Theme"
darkThemeButton.Font = Enum.Font.GothamSemibold
darkThemeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
darkThemeButton.TextSize = 14
darkThemeButton.Parent = settingsTab

-- Light Theme Button
local lightThemeButton = Instance.new("TextButton")
lightThemeButton.Name = "LightThemeButton"
lightThemeButton.Size = UDim2.new(0, 150, 0, 30)
lightThemeButton.Position = UDim2.new(0, 20, 0, 90)
lightThemeButton.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
lightThemeButton.Text = "Light Theme"
lightThemeButton.Font = Enum.Font.GothamSemibold
lightThemeButton.TextColor3 = Color3.fromRGB(0, 0, 0)
lightThemeButton.TextSize = 14
lightThemeButton.Parent = settingsTab

-- Reset UI Button
local resetUIButton = Instance.new("TextButton")
resetUIButton.Name = "ResetUIButton"
resetUIButton.Size = UDim2.new(0, 150, 0, 30)
resetUIButton.Position = UDim2.new(0, 20, 0, 150)
resetUIButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
resetUIButton.Text = "Reset UI"
resetUIButton.Font = Enum.Font.GothamSemibold
resetUIButton.TextColor3 = Color3.fromRGB(255, 255, 255)
resetUIButton.TextSize = 14
resetUIButton.Parent = settingsTab

-- ===================================================
-- [SETTINGS BUTTON LOGIC]
-- Handling theme switching and UI reset
-- ===================================================

local function applyDarkTheme()
    mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    sidebar.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    topBar.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    log("Applied Dark Theme")
end

local function applyLightTheme()
    mainFrame.BackgroundColor3 = Color3.fromRGB(220, 220, 220)
    sidebar.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
    topBar.BackgroundColor3 = Color3.fromRGB(240, 240, 240)
    log("Applied Light Theme")
end

darkThemeButton.MouseButton1Click:Connect(function()
    applyDarkTheme()
end)

lightThemeButton.MouseButton1Click:Connect(function()
    applyLightTheme()
end)

resetUIButton.MouseButton1Click:Connect(function()
    screenGui:Destroy()
    log("UI Reset Triggered")
end)

-- ===================================================
-- [END OF SETTINGS TAB SETUP]
-- Settings system finished
-- ===================================================

-- END OF CHUNK 8 --
-- START OF CHUNK 9 --

-- ===================================================
-- [FINAL CLEANUP]
-- Extra protections, runtime hooks, minor refinements
-- ===================================================

-- Disconnect unwanted BindableEvents from CoreGui if exist
for _, descendant in ipairs(game:GetService("CoreGui"):GetDescendants()) do
    if descendant:IsA("BindableEvent") and descendant.Name == "RobloxGuiError" then
        descendant:Destroy()
        log("Destroyed unwanted BindableEvent: RobloxGuiError")
    end
end

-- Final extra HTTP protection
if getconnections and game.HttpGet then
    for _, v in ipairs(getconnections(game.HttpGet)) do
        if v.Function and islclosure(v.Function) and not is_synapse_function(v.Function) then
            v:Disable()
            log("Disabled suspicious HttpGet connection")
        end
    end
end

-- Setup Humanoid re-detection
RunService.Heartbeat:Connect(function()
    if not player or not player.Character then return end
    humanoid = getHumanoid()
end)

-- Hook CharacterAdded to re-grab Humanoid
player.CharacterAdded:Connect(function()
    humanoid = getHumanoid()
end)

-- Auto-Minimize GUI when rejoining
if screenGui then
    mainFrame.Size = UDim2.new(0, 500, 0, 30)
    tabContainer.Visible = false
    sidebar.Visible = false
    minimized = true
    log("Auto-minimized Celeste UI on load")
end

-- ===================================================
-- [LOGGING FINAL READY STATE]
-- Confirm Celeste loaded successfully
-- ===================================================

log("Celeste Hub Loaded Successfully.")
warn("[Celeste] -> Ready to use!")

-- ===================================================
-- [END OF CHUNK 9]
-- Entire Celeste Org script fully deep organized!
-- ===================================================

-- END OF CHUNK 9 --


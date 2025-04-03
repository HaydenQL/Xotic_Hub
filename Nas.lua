-- Remove existing GUIa
for _, gui in pairs(game.CoreGui:GetChildren()) do
	if gui.Name == "SigmaHub" then gui:Destroy() end
end

local UIS = game:GetService("UserInputService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "SigmaHub"
ScreenGui.Parent = game.CoreGui
ScreenGui.ResetOnSpawn = false

local function makeRounded(obj, radius)
	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, radius)
	corner.Parent = obj
end

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

local minBtn = Instance.new("TextButton")
minBtn.Size = UDim2.new(0, 30, 0, 30)
minBtn.Position = UDim2.new(1, -60, 0, 0)
minBtn.BackgroundTransparency = 1
minBtn.Text = "➖"
minBtn.TextSize = 16
minBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
minBtn.Font = Enum.Font.GothamBold
minBtn.Parent = topBar

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 30, 0, 30)
closeBtn.Position = UDim2.new(1, -30, 0, 0)
closeBtn.BackgroundTransparency = 1
closeBtn.Text = "❌"
closeBtn.TextSize = 14
closeBtn.TextColor3 = Color3.fromRGB(200, 50, 50)
closeBtn.Font = Enum.Font.GothamBold
closeBtn.Parent = topBar

local tabFrame = Instance.new("ScrollingFrame")
tabFrame.Size = UDim2.new(0, 100, 1, -30)
tabFrame.Position = UDim2.new(0, 0, 0, 30)
tabFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
tabFrame.CanvasSize = UDim2.new(0, 0, 0, 300)
tabFrame.ScrollBarThickness = 4
tabFrame.Parent = mainFrame
makeRounded(tabFrame, 10)

local uiListLayout = Instance.new("UIListLayout")
uiListLayout.Padding = UDim.new(0, 5)
uiListLayout.Parent = tabFrame
uiListLayout.SortOrder = Enum.SortOrder.LayoutOrder

local contentFrame = Instance.new("Frame")
contentFrame.Name = "ContentFrame"
contentFrame.Size = UDim2.new(1, -100, 1, -30)
contentFrame.Position = UDim2.new(0, 100, 0, 30)
contentFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
contentFrame.Parent = mainFrame
makeRounded(contentFrame, 10)

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

-- Tabs
local tabInfo = {
	{"🏠", "Home"},
	{"🧍", "Player"},
	{"🎨", "Visual"},
	{"🎙️", "VoiceChat"},
	{"⚙️", "Settings"},
	{"📜", "Credits"},
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

-- Create a frame template function
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

-- Home Tab
local HomeFrame = createTabFrame("Home", "Home Tab")
mainFrame.ClipsDescendants = true
contentFrame.ClipsDescendants = true

local infYieldBtn = Instance.new("TextButton")
infYieldBtn.Size = UDim2.new(0, 180, 0, 35)
infYieldBtn.Position = UDim2.new(0, 20, 0, 50)
infYieldBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
infYieldBtn.Text = "Launch Infinite Yield"
infYieldBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
infYieldBtn.Font = Enum.Font.Gotham
infYieldBtn.TextSize = 14
infYieldBtn.Parent = HomeFrame
makeRounded(infYieldBtn, 6)

infYieldBtn.MouseButton1Click:Connect(function()
	loadstring(game:HttpGet('https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source'))()
end)

local comingSoonLabel = Instance.new("TextLabel")
comingSoonLabel.Size = UDim2.new(1, -40, 0, 30)
comingSoonLabel.Position = UDim2.new(0, 20, 0, 90)
comingSoonLabel.BackgroundTransparency = 1
comingSoonLabel.Text = "Reanimations coming in the future."
comingSoonLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
comingSoonLabel.Font = Enum.Font.Gotham
comingSoonLabel.TextSize = 14
comingSoonLabel.TextXAlignment = Enum.TextXAlignment.Left
comingSoonLabel.Parent = HomeFrame

-- Other Tabs (Player, Visual, VoiceChat, Settings, Credits)
local PlayerFrame = createTabFrame("Player", "Player Tab")
mainFrame.ClipsDescendants = true
contentFrame.ClipsDescendants = true

-- WalkSpeed Input
local walkSpeedLabel = Instance.new("TextLabel")
walkSpeedLabel.Size = UDim2.new(0, 200, 0, 20)
walkSpeedLabel.Position = UDim2.new(0, 20, 0, 50)
walkSpeedLabel.BackgroundTransparency = 1
walkSpeedLabel.Text = "WalkSpeed (Max 500):"
walkSpeedLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
walkSpeedLabel.Font = Enum.Font.Gotham
walkSpeedLabel.TextSize = 14
walkSpeedLabel.TextXAlignment = Enum.TextXAlignment.Left
walkSpeedLabel.Parent = PlayerFrame

local walkSpeedBox = Instance.new("TextBox")
walkSpeedBox.Size = UDim2.new(0, 200, 0, 30)
walkSpeedBox.Position = UDim2.new(0, 20, 0, 75)
walkSpeedBox.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
walkSpeedBox.Text = "16"
walkSpeedBox.TextColor3 = Color3.fromRGB(255, 255, 255)
walkSpeedBox.Font = Enum.Font.Gotham
walkSpeedBox.TextSize = 14
walkSpeedBox.ClearTextOnFocus = false
walkSpeedBox.PlaceholderText = "Enter speed"
walkSpeedBox.TextXAlignment = Enum.TextXAlignment.Center
walkSpeedBox.Parent = PlayerFrame
makeRounded(walkSpeedBox, 6)

walkSpeedBox.FocusLost:Connect(function(enterPressed)
	if enterPressed then
		local num = tonumber(walkSpeedBox.Text)
		if num and num >= 0 and num <= 500 then
			local humanoid = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
			if humanoid then
				humanoid.WalkSpeed = num
			end
		else
			walkSpeedBox.Text = "16" -- Reset if invalid input
		end
	end
end)

-- 🦘 Jump Height Input (Max 500)
local jumpPowerLabel = Instance.new("TextLabel")
jumpPowerLabel.Size = UDim2.new(0, 200, 0, 20)
jumpPowerLabel.Position = UDim2.new(0, 20, 0, 120)
jumpPowerLabel.BackgroundTransparency = 1
jumpPowerLabel.Text = "JumpPower:"
jumpPowerLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
jumpPowerLabel.Font = Enum.Font.Gotham
jumpPowerLabel.TextSize = 14
jumpPowerLabel.TextXAlignment = Enum.TextXAlignment.Left
jumpPowerLabel.Parent = PlayerFrame

local jumpPowerBox = Instance.new("TextBox")
jumpPowerBox.Size = UDim2.new(0, 200, 0, 30)
jumpPowerBox.Position = UDim2.new(0, 20, 0, 150)
jumpPowerBox.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
jumpPowerBox.Text = "50"
jumpPowerBox.TextColor3 = Color3.fromRGB(255, 255, 255)
jumpPowerBox.Font = Enum.Font.Gotham
jumpPowerBox.TextSize = 14
jumpPowerBox.ClearTextOnFocus = false
jumpPowerBox.Parent = PlayerFrame
makeRounded(jumpPowerBox, 6)

-- 🧠 Function to update jump power (also works after respawn)
local function setJumpPower(amount)
	amount = tonumber(amount)
	if amount and amount >= 1 and amount <= 500 then
		local humanoid = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
		if humanoid then
			humanoid.UseJumpPower = true
			humanoid.JumpPower = amount
		end
	end
end

-- Update on enter
jumpPowerBox.FocusLost:Connect(function(enterPressed)
	if enterPressed then
		setJumpPower(jumpPowerBox.Text)
	end
end)

-- Reapply when respawning
LocalPlayer.CharacterAdded:Connect(function(char)
	char:WaitForChild("Humanoid")
	wait(0.2)
	setJumpPower(jumpPowerBox.Text)
end)


-- 🌍 Gravity Changer (0–1000)
local gravityLabel = Instance.new("TextLabel")
gravityLabel.Size = UDim2.new(0, 200, 0, 20)
gravityLabel.Position = UDim2.new(0, 20, 0, 200)
gravityLabel.BackgroundTransparency = 1
gravityLabel.Text = "Gravity (0–10000):"
gravityLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
gravityLabel.Font = Enum.Font.Gotham
gravityLabel.TextSize = 14
gravityLabel.TextXAlignment = Enum.TextXAlignment.Left
gravityLabel.Parent = PlayerFrame

local gravityBox = Instance.new("TextBox")
gravityBox.Size = UDim2.new(0, 200, 0, 30)
gravityBox.Position = UDim2.new(0, 20, 0, 230)
gravityBox.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
gravityBox.Text = tostring(workspace.Gravity)
gravityBox.TextColor3 = Color3.fromRGB(255, 255, 255)
gravityBox.Font = Enum.Font.Gotham
gravityBox.TextSize = 14
gravityBox.ClearTextOnFocus = false
gravityBox.Parent = PlayerFrame
makeRounded(gravityBox, 6)

-- Apply gravity function
local function setGravity(amount)
	amount = tonumber(amount)
	if amount and amount >= 0 and amount <= 10000 then
		workspace.Gravity = amount
	end
end

gravityBox.FocusLost:Connect(function(enterPressed)
	if enterPressed then
		setGravity(gravityBox.Text)
	end
end)

--Tabs gui each
local VisualFrame = createTabFrame("Visual", "Visual Tab")


-- 🕵️ Spy Listen (with SoundService.Listener workaround)

local spyNameLabel = Instance.new("TextLabel")
spyNameLabel.Size = UDim2.new(0, 200, 0, 20)
spyNameLabel.Position = UDim2.new(0, 20, 0, 145)
spyNameLabel.BackgroundTransparency = 1
spyNameLabel.Text = "Spy on Display Name:"
spyNameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
spyNameLabel.Font = Enum.Font.Gotham
spyNameLabel.TextSize = 14
spyNameLabel.TextXAlignment = Enum.TextXAlignment.Left
spyNameLabel.Parent = VoiceChatFrame

local spyNameBox = Instance.new("TextBox")
spyNameBox.Size = UDim2.new(0, 200, 0, 30)
spyNameBox.Position = UDim2.new(0, 20, 0, 170)
spyNameBox.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
spyNameBox.Text = ""
spyNameBox.TextColor3 = Color3.fromRGB(255, 255, 255)
spyNameBox.Font = Enum.Font.Gotham
spyNameBox.TextSize = 14
spyNameBox.ClearTextOnFocus = false
spyNameBox.PlaceholderText = "Type their display name..."
spyNameBox.Parent = VoiceChatFrame
makeRounded(spyNameBox, 6)

local spyButton = Instance.new("TextButton")
spyButton.Size = UDim2.new(0, 200, 0, 30)
spyButton.Position = UDim2.new(0, 20, 0, 210)
spyButton.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
spyButton.Text = "🎧 Start Spying"
spyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
spyButton.Font = Enum.Font.Gotham
spyButton.TextSize = 14
spyButton.Parent = VoiceChatFrame
makeRounded(spyButton, 6)

local stopSpyButton = Instance.new("TextButton")
stopSpyButton.Size = UDim2.new(0, 200, 0, 30)
stopSpyButton.Position = UDim2.new(0, 20, 0, 250)
stopSpyButton.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
stopSpyButton.Text = "🔇 Stop Spying"
stopSpyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
stopSpyButton.Font = Enum.Font.Gotham
stopSpyButton.TextSize = 14
stopSpyButton.Parent = VoiceChatFrame
makeRounded(stopSpyButton, 6)

local SoundService = game:GetService("SoundService")
local currentSpyPart = nil
local connection = nil

-- 🧠 Start spying
spyButton.MouseButton1Click:Connect(function()
	local displayName = spyNameBox.Text:lower()
	for _, player in pairs(game.Players:GetPlayers()) do
		if player ~= LocalPlayer and player.DisplayName:lower() == displayName then
			if player.Character and player.Character:FindFirstChild("Head") then
				local targetHead = player.Character.Head

				-- Create invisible proxy part
				local spyPart = Instance.new("Part")
				spyPart.Size = Vector3.new(1, 1, 1)
				spyPart.Anchored = true
				spyPart.CanCollide = false
				spyPart.Transparency = 1
				spyPart.Name = "SpyListenerPart"
				spyPart.Parent = workspace

				-- Position the spy part near target's head
				spyPart.CFrame = targetHead.CFrame + Vector3.new(1, 0, 0)

				-- Attach listener to spy part
				SoundService:SetListener(Enum.ListenerType.ObjectCFrame, spyPart)

				-- Update position every frame
				if connection then connection:Disconnect() end
				connection = game:GetService("RunService").RenderStepped:Connect(function()
					if player.Character and player.Character:FindFirstChild("Head") then
						spyPart.CFrame = player.Character.Head.CFrame + Vector3.new(1, 0, 0)
					end
				end)

				currentSpyPart = spyPart
				print("🎧 Spying on:", player.DisplayName)
				break
			end
		end
	end
end)

-- 🔇 Stop spying
stopSpyButton.MouseButton1Click:Connect(function()
	if currentSpyPart then
		currentSpyPart:Destroy()
		currentSpyPart = nil
	end
	if connection then
		connection:Disconnect()
		connection = nil
	end
	-- Restore normal listener (camera-based)
	SoundService:SetListener(Enum.ListenerType.Camera)
	print("🔇 Spy stopped.")
end)

-- settings
local SettingsFrame = createTabFrame("Settings", "Settings Tab")
local CreditsFrame = createTabFrame("Credits", "Credits Tab")

-- Add credit labels
local creditsText = Instance.new("TextLabel")
creditsText.Size = UDim2.new(1, -40, 0, 30)
creditsText.Position = UDim2.new(0, 20, 0, 50)
creditsText.BackgroundTransparency = 1
creditsText.Text = "Made by Hayden"
creditsText.TextColor3 = Color3.fromRGB(200, 200, 200)
creditsText.Font = Enum.Font.Gotham
creditsText.TextSize = 14
creditsText.TextXAlignment = Enum.TextXAlignment.Left
creditsText.Parent = CreditsFrame

local creditsNote = Instance.new("TextLabel")
creditsNote.Size = UDim2.new(1, -40, 0, 30)
creditsNote.Position = UDim2.new(0, 20, 0, 80)
creditsNote.BackgroundTransparency = 1
creditsNote.Text = "💬 Type '!admin' in chat to unlock the admin panel."
creditsNote.TextColor3 = Color3.fromRGB(200, 200, 200)
creditsNote.Font = Enum.Font.Gotham
creditsNote.TextSize = 14
creditsNote.TextXAlignment = Enum.TextXAlignment.Left
creditsNote.Parent = CreditsFrame

-- Tab switching
for tabName, button in pairs(tabButtons) do
	button.MouseButton1Click:Connect(function()
		for _, child in ipairs(contentFrame:GetChildren()) do
			if child:IsA("Frame") then
				child.Visible = false
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

-- 🔐 Admin Panel (hidden unless !admin is typed)
local AdminFrame = Instance.new("Frame")
AdminFrame.Name = "AdminFrame"
AdminFrame.Size = UDim2.new(1, 0, 1, 0)
AdminFrame.BackgroundTransparency = 0
AdminFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
AdminFrame.Visible = false
AdminFrame.Parent = contentFrame
makeRounded(AdminFrame, 10)

local adminTitle = Instance.new("TextLabel")
adminTitle.Size = UDim2.new(1, 0, 0, 40)
adminTitle.Position = UDim2.new(0, 0, 0, 0)
adminTitle.BackgroundTransparency = 1
adminTitle.Text = "🔧 Admin Panel"
adminTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
adminTitle.Font = Enum.Font.GothamBold
adminTitle.TextSize = 18
adminTitle.Parent = AdminFrame

local adminMsg = Instance.new("TextLabel")
adminMsg.Size = UDim2.new(1, -40, 0, 30)
adminMsg.Position = UDim2.new(0, 20, 0, 50)
adminMsg.BackgroundTransparency = 1
adminMsg.Text = "Admin tools will go here soon..."
adminMsg.TextColor3 = Color3.fromRGB(200, 200, 200)
adminMsg.Font = Enum.Font.Gotham
adminMsg.TextSize = 14
adminMsg.TextXAlignment = Enum.TextXAlignment.Left
adminMsg.Parent = AdminFrame

-- 💬 Listen for !admin in chat
LocalPlayer.Chatted:Connect(function(msg)
	if msg:lower() == "!admin" then
		for _, frame in ipairs(contentFrame:GetChildren()) do
			if frame:IsA("Frame") then
				frame.Visible = false
			end
		end
		local welcome = contentFrame:FindFirstChild("WelcomeFrame")
		if welcome then
			welcome.Visible = false
		end
		AdminFrame.Visible = true
	end
end)

-- 🔘 Minimize button functionality
local isMinimized = false
minBtn.MouseButton1Click:Connect(function()
	isMinimized = not isMinimized
	for _, child in pairs(mainFrame:GetChildren()) do
		if child ~= topBar then
			child.Visible = not isMinimized
		end
	end
end)

-- ❌ Close button functionality
closeBtn.MouseButton1Click:Connect(function()
	ScreenGui.Enabled = false
end)

-- 🎹 Toggle GUI with "K" key
local guiToggled = true
UIS.InputBegan:Connect(function(input, gameProcessed)
	if gameProcessed then return end
	if input.KeyCode == Enum.KeyCode.K then
		guiToggled = not guiToggled
		ScreenGui.Enabled = guiToggled
	end
end)

-- Resize corner handle
local resizeCorner = Instance.new("TextButton")
resizeCorner.Size = UDim2.new(0, 15, 0, 15)
resizeCorner.Position = UDim2.new(1, -15, 1, -15)
resizeCorner.BackgroundColor3 = Color3.fromRGB(100,100,100)
resizeCorner.BorderSizePixel = 0
resizeCorner.Text = ""
resizeCorner.Parent = mainFrame

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

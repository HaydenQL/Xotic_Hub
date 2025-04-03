-- Remove existing GUI
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

local minimized = false
minBtn.MouseButton1Click:Connect(function()
	minimized = not minimized
	tabFrame.Visible = not minimized
	contentFrame.Visible = not minimized
	mainFrame.Size = minimized and UDim2.new(0, 450, 0, 30) or UDim2.new(0, 450, 0, 280)
end)

closeBtn.MouseButton1Click:Connect(function()
	mainFrame.Visible = false
end)

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

UIS.InputBegan:Connect(function(key, gpe)
	if key.KeyCode == Enum.KeyCode.K and not gpe then
		mainFrame.Visible = not mainFrame.Visible
	end
end)

-- Create tab buttons with symbols
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
	button.Text = tab[1]  -- symbol only
	button.Font = Enum.Font.Gotham
	button.TextSize = 20
	button.TextColor3 = Color3.fromRGB(255, 255, 255)
	button.Name = tab[2] .. "Tab"
	button.Parent = tabFrame
	makeRounded(button, 6)
	tabButtons[tab[2]] = button
end

-- Welcome Screen
local welcomeFrame = Instance.new("Frame")
welcomeFrame.Name = "WelcomeFrame"
welcomeFrame.Size = UDim2.new(1, 0, 1, 0)
welcomeFrame.BackgroundTransparency = 1
welcomeFrame.Visible = true
welcomeFrame.Parent = contentFrame

local welcomeLabel = Instance.new("TextLabel")
welcomeLabel.Size = UDim2.new(1, 0, 0, 50)
welcomeLabel.Position = UDim2.new(0, 0, 0.4, 0)
welcomeLabel.BackgroundTransparency = 1
welcomeLabel.Text = "Welcome to Sigma Hub"
welcomeLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
welcomeLabel.Font = Enum.Font.GothamBold
welcomeLabel.TextSize = 20
welcomeLabel.TextXAlignment = Enum.TextXAlignment.Center
welcomeLabel.Parent = welcomeFrame

-- Home Tab Content
local HomeFrame = Instance.new("Frame")
HomeFrame.Name = "HomeFrame"
HomeFrame.Size = UDim2.new(1, 0, 1, 0)
HomeFrame.BackgroundTransparency = 1
HomeFrame.Visible = false
HomeFrame.Parent = contentFrame

local infYieldBtn = Instance.new("TextButton")
infYieldBtn.Size = UDim2.new(0, 180, 0, 35)
infYieldBtn.Position = UDim2.new(0, 20, 0, 20)
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
comingSoonLabel.Position = UDim2.new(0, 20, 0, 70)
comingSoonLabel.BackgroundTransparency = 1
comingSoonLabel.Text = "Reanimations coming in the future."
comingSoonLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
comingSoonLabel.Font = Enum.Font.Gotham
comingSoonLabel.TextSize = 14
comingSoonLabel.TextXAlignment = Enum.TextXAlignment.Left
comingSoonLabel.Parent = HomeFrame

-- Tab switching behavior
for tabName, button in pairs(tabButtons) do
	button.MouseButton1Click:Connect(function()
		for _, child in ipairs(contentFrame:GetChildren()) do
			if child:IsA("Frame") then
				child.Visible = false
			end
		end
		local tabFrameName = tabName .. "Frame"
		local target = contentFrame:FindFirstChild(tabFrameName)
		if target then
			local welcome = contentFrame:FindFirstChild("WelcomeFrame")
			if welcome then
				welcome.Visible = false
			end
			target.Visible = true
		end
	end)
end

-- Credits Tab Content
local CreditsFrame = Instance.new("Frame")
CreditsFrame.Name = "CreditsFrame"
CreditsFrame.Size = UDim2.new(1, 0, 1, 0)
CreditsFrame.BackgroundTransparency = 1
CreditsFrame.Visible = false
CreditsFrame.Parent = contentFrame

local creditsTitle = Instance.new("TextLabel")
creditsTitle.Size = UDim2.new(1, 0, 0, 40)
creditsTitle.Position = UDim2.new(0, 0, 0, 0)
creditsTitle.BackgroundTransparency = 1
creditsTitle.Text = "📜 Credits"
creditsTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
creditsTitle.Font = Enum.Font.GothamBold
creditsTitle.TextSize = 18
creditsTitle.Parent = CreditsFrame

local creditsText = Instance.new("TextLabel")
creditsText.Size = UDim2.new(1, -40, 0, 40)
creditsText.Position = UDim2.new(0, 20, 0, 40)
creditsText.BackgroundTransparency = 1
creditsText.Text = "Made by SigmaHub Dev Team"
creditsText.TextColor3 = Color3.fromRGB(200, 200, 200)
creditsText.Font = Enum.Font.Gotham
creditsText.TextSize = 14
creditsText.TextWrapped = true
creditsText.TextXAlignment = Enum.TextXAlignment.Left
creditsText.Parent = CreditsFrame

local creditsNote = Instance.new("TextLabel")
creditsNote.Size = UDim2.new(1, -40, 0, 40)
creditsNote.Position = UDim2.new(0, 20, 0, 80)
creditsNote.BackgroundTransparency = 1
creditsNote.Text = "💬 Type '!admin' in chat to unlock the admin panel."
creditsNote.TextColor3 = Color3.fromRGB(200, 200, 200)
creditsNote.Font = Enum.Font.Gotham
creditsNote.TextSize = 14
creditsNote.TextWrapped = true
creditsNote.TextXAlignment = Enum.TextXAlignment.Left
creditsNote.Parent = CreditsFrame

-- Admin Panel (Hidden Frame)
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

local adminLabel = Instance.new("TextLabel")
adminLabel.Size = UDim2.new(1, -40, 0, 30)
adminLabel.Position = UDim2.new(0, 20, 0, 50)
adminLabel.BackgroundTransparency = 1
adminLabel.Text = "Admin tools will go here soon..."
adminLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
adminLabel.Font = Enum.Font.Gotham
adminLabel.TextSize = 14
adminLabel.TextXAlignment = Enum.TextXAlignment.Left
adminLabel.Parent = AdminFrame

-- Chat command to open AdminFrame
LocalPlayer.Chatted:Connect(function(msg)
	if msg:lower() == "!admin" then
		for _, child in ipairs(contentFrame:GetChildren()) do
			if child:IsA("Frame") then
				child.Visible = false
			end
		end
		local welcome = contentFrame:FindFirstChild("WelcomeFrame")
		if welcome then
			welcome.Visible = false
		end
		AdminFrame.Visible = true
	end
end)

-- Remove existing GUI (fully safe)
for _, gui in pairs(game.CoreGui:GetChildren()) do
	if gui.Name == "SigmaHub" then
		gui:Destroy()
	end
end

-- 👑 Sigma Hub v0.01 Beta
local UIS = game:GetService("UserInputService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
ScreenGui.Name = "SigmaHub"
ScreenGui.ResetOnSpawn = false

-- Main Frame
local mainFrame = Instance.new("Frame", ScreenGui)
mainFrame.Size = UDim2.new(0,450,0,280)
mainFrame.Position = UDim2.new(0.5,-225,0.5,-140)
mainFrame.BackgroundColor3 = Color3.fromRGB(20,20,20)
mainFrame.Active = true
mainFrame.Draggable = true

-- Top Bar
local topBar = Instance.new("Frame", mainFrame)
topBar.Size = UDim2.new(1,0,0,30)
topBar.BackgroundColor3 = Color3.fromRGB(30,30,30)

local title = Instance.new("TextLabel", topBar)
title.Size = UDim2.new(1,-180,1,0)
title.Position = UDim2.new(0,10,0,0)
title.BackgroundTransparency = 1
title.Text = "👑 Sigma Hub"
title.TextSize = 16
title.Font = Enum.Font.GothamBold
title.TextColor3 = Color3.fromRGB(255,255,255)
title.TextXAlignment = Enum.TextXAlignment.Left

local usernameLabel = Instance.new("TextLabel", topBar)
usernameLabel.Size = UDim2.new(0,100,1,0)
usernameLabel.Position = UDim2.new(1,-170,0,0)
usernameLabel.BackgroundTransparency = 1
usernameLabel.Text = LocalPlayer.Name
usernameLabel.TextSize = 14
usernameLabel.Font = Enum.Font.Gotham
usernameLabel.TextColor3 = Color3.fromRGB(150,150,150)
usernameLabel.TextXAlignment = Enum.TextXAlignment.Right

local minBtn = Instance.new("TextButton", topBar)
minBtn.Size = UDim2.new(0,30,0,30)
minBtn.Position = UDim2.new(1,-60,0,0)
minBtn.BackgroundTransparency = 1
minBtn.Text = "➖"
minBtn.Font = Enum.Font.GothamBold
minBtn.TextColor3 = Color3.fromRGB(200,200,200)

local closeBtn = Instance.new("TextButton", topBar)
closeBtn.Size = UDim2.new(0,30,0,30)
closeBtn.Position = UDim2.new(1,-30,0,0)
closeBtn.BackgroundTransparency = 1
closeBtn.Text = "❌"
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextColor3 = Color3.fromRGB(200,50,50)

closeBtn.MouseButton1Click:Connect(function()
	mainFrame.Visible = false
end)

local tabFrame = Instance.new("Frame", mainFrame)
tabFrame.Size = UDim2.new(0,100,1,-30)
tabFrame.Position = UDim2.new(0,0,0,30)
tabFrame.BackgroundColor3 = Color3.fromRGB(25,25,25)

local uiListLayout = Instance.new("UIListLayout", tabFrame)

local contentFrame = Instance.new("Frame", mainFrame)
contentFrame.Size = UDim2.new(1,-100,1,-30)
contentFrame.Position = UDim2.new(0,100,0,30)
contentFrame.BackgroundColor3 = Color3.fromRGB(15,15,15)

local versionLabel = Instance.new("TextLabel", mainFrame)
versionLabel.Size = UDim2.new(0,150,0,20)
versionLabel.Position = UDim2.new(0,5,1,-20)
versionLabel.BackgroundTransparency = 1
versionLabel.Text = "Version: v0.01 Beta"
versionLabel.Font = Enum.Font.Gotham
versionLabel.TextSize = 13
versionLabel.TextColor3 = Color3.fromRGB(120,120,120)

-- Minimize functionality
local minimized = false
minBtn.MouseButton1Click:Connect(function()
	minimized = not minimized
	tabFrame.Visible = not minimized
	contentFrame.Visible = not minimized
	mainFrame.Size = minimized and UDim2.new(0,450,0,30) or UDim2.new(0,450,0,280)
end)

-- Resize handle
local resizeCorner = Instance.new("TextButton", mainFrame)
resizeCorner.Size = UDim2.new(0,15,0,15)
resizeCorner.Position = UDim2.new(1,-15,1,-15)
resizeCorner.BackgroundColor3 = Color3.fromRGB(100,100,100)
resizeCorner.Text = ""

local resizing,lastSize
resizeCorner.MouseButton1Down:Connect(function()
	resizing = true
	lastSize = mainFrame.Size
end)

UIS.InputChanged:Connect(function(input)
	if resizing and input.UserInputType == Enum.UserInputType.MouseMovement then
		local delta = input.Position
		mainFrame.Size = UDim2.new(0,math.max(300,delta.X - mainFrame.AbsolutePosition.X),0,math.max(150,delta.Y - mainFrame.AbsolutePosition.Y))
	end
end)

UIS.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		resizing = false
	end
end)

UIS.InputBegan:Connect(function(key,gpe)
	if key.KeyCode == Enum.KeyCode.K and not gpe then
		mainFrame.Visible = not mainFrame.Visible
	end
end)

-- Local Tab
local localTabBtn = Instance.new("TextButton", tabFrame)
localTabBtn.Size = UDim2.new(1,0,0,30)
localTabBtn.BackgroundColor3 = Color3.fromRGB(40,40,40)
localTabBtn.Font = Enum.Font.Gotham
localTabBtn.Text = "Local"
localTabBtn.TextColor3 = Color3.fromRGB(255,255,255)

local rideBtn = Instance.new("TextButton", contentFrame)
rideBtn.Size = UDim2.new(0,120,0,30)
rideBtn.Position = UDim2.new(0,10,0,10)
rideBtn.BackgroundColor3 = Color3.fromRGB(30,30,30)
rideBtn.Font = Enum.Font.Gotham
rideBtn.Text = "🚗 Ride Player"
rideBtn.TextColor3 = Color3.fromRGB(255,255,255)
rideBtn.Visible = false

localTabBtn.MouseButton1Click:Connect(function()
	rideBtn.Visible = true
end)

rideBtn.MouseButton1Click:Connect(function()
	local dropdown = Instance.new("Frame", contentFrame)
	dropdown.Size = UDim2.new(0,150,0,200)
	dropdown.Position = UDim2.new(0,10,0,50)
	dropdown.BackgroundColor3 = Color3.fromRGB(25,25,25)
	local layout = Instance.new("UIListLayout", dropdown)

	for _,p in pairs(Players:GetPlayers()) do
		local playerBtn = Instance.new("TextButton", dropdown)
		playerBtn.Size = UDim2.new(1,0,0,25)
		playerBtn.BackgroundColor3 = Color3.fromRGB(35,35,35)
		playerBtn.Font = Enum.Font.Gotham
		playerBtn.Text = p.DisplayName.." ("..p.Name..")"
		playerBtn.TextColor3 = Color3.fromRGB(255,255,255)
		
		playerBtn.MouseButton1Click:Connect(function()
			dropdown:Destroy()
			local seat = Instance.new("Seat", workspace)
			seat.Anchored = false
			seat.Size = Vector3.new(2,0.4,2)
			seat.CFrame = p.Character.HumanoidRootPart.CFrame * CFrame.new(0,2,0)
			local weld = Instance.new("Weld", seat)
			weld.Part0 = seat
			weld.Part1 = p.Character.HumanoidRootPart
			wait()
			LocalPlayer.Character.Humanoid.Sit = true
			seat:Sit(LocalPlayer.Character.Humanoid)
			local conn
			conn = LocalPlayer.Character.Humanoid:GetPropertyChangedSignal("Sit"):Connect(function()
				if not LocalPlayer.Character.Humanoid.Sit then
					seat:Destroy()
					conn:Disconnect()
				end
			end)
		end)
	end
end)

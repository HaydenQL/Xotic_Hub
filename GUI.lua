-- Remove existing GUI
for _, gui in pairs(game.CoreGui:GetChildren()) do
	if gui.Name == "SigmaHub" then gui:Destroy() end
end

-- 👑 HaydenSigma24's Sigma Hub GUI v0.01 Beta (Resizable & Minimizable)
local UIS = game:GetService("UserInputService")

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "SigmaHub"
ScreenGui.Parent = game.CoreGui
ScreenGui.ResetOnSpawn = false

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

-- Top Bar
local topBar = Instance.new("Frame")
topBar.Size = UDim2.new(1, 0, 0, 30)
topBar.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
topBar.Parent = mainFrame

-- Title
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

-- Username Display
local usernameLabel = Instance.new("TextLabel")
usernameLabel.Size = UDim2.new(0, 100, 1, 0)
usernameLabel.Position = UDim2.new(1, -170, 0, 0)
usernameLabel.BackgroundTransparency = 1
usernameLabel.Text = game.Players.LocalPlayer.Name
usernameLabel.TextSize = 14
usernameLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
usernameLabel.Font = Enum.Font.Gotham
usernameLabel.TextXAlignment = Enum.TextXAlignment.Right
usernameLabel.Parent = topBar

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

-- Close Button (X)
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 30, 0, 30)
closeBtn.Position = UDim2.new(1, -30, 0, 0)
closeBtn.BackgroundTransparency = 1
closeBtn.Text = "❌"
closeBtn.TextSize = 14
closeBtn.TextColor3 = Color3.fromRGB(200, 50, 50)
closeBtn.Font = Enum.Font.GothamBold
closeBtn.Parent = topBar

-- Side Tabs Frame
local tabFrame = Instance.new("Frame")
tabFrame.Size = UDim2.new(0, 100, 1, -30)
tabFrame.Position = UDim2.new(0, 0, 0, 30)
tabFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
tabFrame.Parent = mainFrame

local uiListLayout = Instance.new("UIListLayout")
uiListLayout.Parent = tabFrame
uiListLayout.SortOrder = Enum.SortOrder.LayoutOrder

-- Content Frame
local contentFrame = Instance.new("Frame")
contentFrame.Name = "ContentFrame"
contentFrame.Size = UDim2.new(1, -100, 1, -30)
contentFrame.Position = UDim2.new(0, 100, 0, 30)
contentFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
contentFrame.Parent = mainFrame

-- Version Label (bottom-left)
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

-- Minimize functionality
local minimized = false
minBtn.MouseButton1Click:Connect(function()
	minimized = not minimized
	tabFrame.Visible = not minimized
	contentFrame.Visible = not minimized
	mainFrame.Size = minimized and UDim2.new(0, 450, 0, 30) or UDim2.new(0, 450, 0, 280)
end)

-- Close GUI functionality
closeBtn.MouseButton1Click:Connect(function()
	mainFrame.Visible = false
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

-- Toggle GUI visibility with "K"
UIS.InputBegan:Connect(function(key, gpe)
	if key.KeyCode == Enum.KeyCode.K and not gpe then
		mainFrame.Visible = not mainFrame.Visible
	end
end)
-- Setup services
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Create "Local" Tab
local localTab = Instance.new("TextButton")
localTab.Size = UDim2.new(1, 0, 0, 30)
localTab.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
localTab.Text = "Local"
localTab.Font = Enum.Font.Gotham
localTab.TextColor3 = Color3.fromRGB(255, 255, 255)
localTab.Parent = tabFrame

-- Ride Player Button (hidden until tab is clicked)
local rideBtn = Instance.new("TextButton")
rideBtn.Size = UDim2.new(0, 180, 0, 30)
rideBtn.Position = UDim2.new(0, 10, 0, 10)
rideBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
rideBtn.Text = "🚗 Ride Player"
rideBtn.Font = Enum.Font.Gotham
rideBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
rideBtn.Parent = contentFrame
rideBtn.Visible = false

-- Show ride button when tab is clicked
localTab.MouseButton1Click:Connect(function()
	for _, child in pairs(contentFrame:GetChildren()) do
		if child:IsA("TextButton") then
			child.Visible = false
		end
	end
	rideBtn.Visible = true
end)

-- Ride logic with dropdown
rideBtn.MouseButton1Click:Connect(function()
	local dropdown = Instance.new("ScrollingFrame")
	dropdown.Size = UDim2.new(0, 200, 0, 150)
	dropdown.Position = UDim2.new(0, 10, 0, 50)
	dropdown.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
	dropdown.ScrollBarThickness = 5
	dropdown.CanvasSize = UDim2.new(0, 0, 0, #Players:GetPlayers() * 35)
	dropdown.Parent = contentFrame
	dropdown.Name = "PlayerDropdown"

	local layout = Instance.new("UIListLayout")
	layout.Parent = dropdown

	for _, p in ipairs(Players:GetPlayers()) do
		if p ~= LocalPlayer then
			local btn = Instance.new("TextButton")
			btn.Size = UDim2.new(1, -10, 0, 30)
			btn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
			btn.Text = p.DisplayName .. " (" .. p.Name .. ")"
			btn.Font = Enum.Font.Gotham
			btn.TextColor3 = Color3.fromRGB(255, 255, 255)
			btn.Parent = dropdown

			btn.MouseButton1Click:Connect(function()
				dropdown:Destroy()
				local char = p.Character
				if char and char:FindFirstChild("HumanoidRootPart") then
					local seat = Instance.new("Seat", workspace)
					seat.Anchored = false
					seat.CanCollide = false
					seat.Transparency = 0.7
					seat.Size = Vector3.new(2, 0.4, 2)
					seat.CFrame = char.HumanoidRootPart.CFrame * CFrame.new(0, 1.5, 0)

					local weld = Instance.new("WeldConstraint", seat)
					weld.Part0 = seat
					weld.Part1 = char.HumanoidRootPart

					wait(0.1)
					LocalPlayer.Character.HumanoidRootPart.CFrame = seat.CFrame + Vector3.new(0, 1, 0)
					wait(0.1)
					LocalPlayer.Character.Humanoid.Sit = true
					seat:Sit(LocalPlayer.Character.Humanoid)

					local attach = Instance.new("WeldConstraint")
					attach.Part0 = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
					attach.Part1 = seat
					attach.Parent = seat

					local conn
					conn = LocalPlayer.Character.Humanoid:GetPropertyChangedSignal("Sit"):Connect(function()
						if not LocalPlayer.Character.Humanoid.Sit then
							seat:Destroy()
							conn:Disconnect()
						end
					end)
				end
			end)
		end
	end
end)

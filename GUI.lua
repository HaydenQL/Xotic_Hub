-- Remove existing GUI
for _, gui in pairs(game.CoreGui:GetChildren()) do
	if gui.Name == "SigmaHub" then gui:Destroy() end
end

-- 👑 Sigma Hub v0.01 Beta Enhanced
local UIS = game:GetService("UserInputService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
ScreenGui.Name = "SigmaHub"
ScreenGui.ResetOnSpawn = false

-- Main Frame (Resizable)
local mainFrame = Instance.new("Frame", ScreenGui)
mainFrame.Size = UDim2.new(0, 500, 0, 300)
mainFrame.Position = UDim2.new(0.5, -250, 0.5, -150)
mainFrame.BackgroundColor3 = Color3.fromRGB(20,20,20)
mainFrame.Active = true
mainFrame.Draggable = true

local corner = Instance.new("UICorner", mainFrame)
corner.CornerRadius = UDim.new(0,6)

-- Top Bar
local topBar = Instance.new("Frame", mainFrame)
topBar.Size = UDim2.new(1,0,0,30)
topBar.BackgroundColor3 = Color3.fromRGB(30,30,30)

local title = Instance.new("TextLabel", topBar)
title.Size = UDim2.new(0.6,0,1,0)
title.Position = UDim2.new(0,10,0,0)
title.BackgroundTransparency = 1
title.Text = "👑 Sigma Hub"
title.TextScaled = true
title.Font = Enum.Font.GothamBold
title.TextColor3 = Color3.fromRGB(255,255,255)
title.TextXAlignment = Enum.TextXAlignment.Left

local usernameLabel = Instance.new("TextLabel", topBar)
usernameLabel.Size = UDim2.new(0.3,0,1,0)
usernameLabel.Position = UDim2.new(0.7, -70, 0, 0)
usernameLabel.BackgroundTransparency = 1
usernameLabel.Text = LocalPlayer.Name
usernameLabel.TextScaled = true
usernameLabel.Font = Enum.Font.Gotham
usernameLabel.TextColor3 = Color3.fromRGB(150,150,150)
usernameLabel.TextXAlignment = Enum.TextXAlignment.Right

local closeBtn = Instance.new("TextButton", topBar)
closeBtn.Size = UDim2.new(0,30,0,30)
closeBtn.Position = UDim2.new(1,-35,0,0)
closeBtn.BackgroundTransparency = 1
closeBtn.Text = "❌"
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextColor3 = Color3.fromRGB(200,50,50)

closeBtn.MouseButton1Click:Connect(function()
	mainFrame.Visible = false
end)

-- Content Area
local contentFrame = Instance.new("Frame", mainFrame)
contentFrame.Size = UDim2.new(1,-10,1,-40)
contentFrame.Position = UDim2.new(0,5,0,35)
contentFrame.BackgroundColor3 = Color3.fromRGB(25,25,25)
contentFrame.ClipsDescendants = true

local contentCorner = Instance.new("UICorner", contentFrame)
contentCorner.CornerRadius = UDim.new(0,6)

-- Ride Player Button
local rideBtn = Instance.new("TextButton", contentFrame)
rideBtn.Size = UDim2.new(0.3,0,0,30)
rideBtn.Position = UDim2.new(0.02,0,0.02,0)
rideBtn.BackgroundColor3 = Color3.fromRGB(35,35,35)
rideBtn.Font = Enum.Font.Gotham
rideBtn.Text = "🚗 Ride Player"
rideBtn.TextScaled = true
rideBtn.TextColor3 = Color3.fromRGB(255,255,255)

local rideBtnCorner = Instance.new("UICorner", rideBtn)
rideBtnCorner.CornerRadius = UDim.new(0,6)

-- Dropdown List (Player selection)
rideBtn.MouseButton1Click:Connect(function()
	if contentFrame:FindFirstChild("PlayerList") then
		contentFrame.PlayerList:Destroy()
	end

	local dropdown = Instance.new("ScrollingFrame", contentFrame)
	dropdown.Name = "PlayerList"
	dropdown.Size = UDim2.new(0.4,0,0.8,0)
	dropdown.Position = UDim2.new(0.02,0,0.15,0)
	dropdown.BackgroundColor3 = Color3.fromRGB(30,30,30)
	dropdown.CanvasSize = UDim2.new(0,0,0,#Players:GetPlayers()*35)
	dropdown.ScrollBarThickness = 5

	local dropdownCorner = Instance.new("UICorner", dropdown)
	dropdownCorner.CornerRadius = UDim.new(0,6)

	local layout = Instance.new("UIListLayout", dropdown)
	layout.SortOrder = Enum.SortOrder.LayoutOrder
	layout.Padding = UDim.new(0,5)

	for _,p in pairs(Players:GetPlayers()) do
		local playerBtn = Instance.new("TextButton", dropdown)
		playerBtn.Size = UDim2.new(1,-10,0,30)
		playerBtn.BackgroundColor3 = Color3.fromRGB(40,40,40)
		playerBtn.Font = Enum.Font.Gotham
		playerBtn.Text = p.DisplayName.." ("..p.Name..")"
		playerBtn.TextScaled = true
		playerBtn.TextColor3 = Color3.fromRGB(255,255,255)

		local btnCorner = Instance.new("UICorner", playerBtn)
		btnCorner.CornerRadius = UDim.new(0,4)

		playerBtn.MouseButton1Click:Connect(function()
			dropdown:Destroy()
			local char = p.Character
			if char and char:FindFirstChild("HumanoidRootPart") then
				local seat = Instance.new("Seat", workspace)
				seat.Anchored = false
				seat.Size = Vector3.new(2,0.4,2)
				seat.Transparency = 0.7
				seat.CFrame = char.HumanoidRootPart.CFrame * CFrame.new(0,1.5,0)

				local weld = Instance.new("Weld", seat)
				weld.Part0 = seat
				weld.Part1 = char.HumanoidRootPart

				LocalPlayer.Character.HumanoidRootPart.CFrame = seat.CFrame + Vector3.new(0,1,0)
				wait(0.1)
				seat:Sit(LocalPlayer.Character.Humanoid)

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
end)

-- Toggle GUI (K key)
UIS.InputBegan:Connect(function(key,gpe)
	if key.KeyCode == Enum.KeyCode.K and not gpe then
		mainFrame.Visible = not mainFrame.Visible
	end
end)

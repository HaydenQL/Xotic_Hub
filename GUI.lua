-- 👑 HaydenSigma24's Custom Hub GUI
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

-- Top Bar (Title & Close)
local topBar = Instance.new("Frame")
topBar.Size = UDim2.new(1, 0, 0, 30)
topBar.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
topBar.Parent = mainFrame

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -50, 1, 0)
title.Position = UDim2.new(0, 10, 0, 0)
title.BackgroundTransparency = 1
title.Text = "👑 Sigma Hub"
title.TextSize = 16
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.GothamBold
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = topBar

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 30, 0, 30)
closeBtn.Position = UDim2.new(1, -35, 0, 0)
closeBtn.BackgroundTransparency = 1
closeBtn.Text = "❌"
closeBtn.TextSize = 14
closeBtn.TextColor3 = Color3.fromRGB(200, 50, 50)
closeBtn.Font = Enum.Font.GothamBold
closeBtn.Parent = topBar

-- Hide GUI functionality
closeBtn.MouseButton1Click:Connect(function()
	mainFrame.Visible = false
end)

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

-- Toggle key (RightShift)
local UIS = game:GetService("UserInputService")
UIS.InputBegan:Connect(function(key, gpe)
	if key.KeyCode == Enum.KeyCode.RightShift and not gpe then
		mainFrame.Visible = not mainFrame.Visible
	end
end)

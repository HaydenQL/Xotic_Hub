-- ⚙️ Ultimate Xeno Logger: Draggable + Minimize + RightShift + Tab Toggle
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")

-- Cleanup any previous version
pcall(function()
	if CoreGui:FindFirstChild("XenoLoggerGUI") then
		CoreGui.XenoLoggerGUI:Destroy()
	end
end)

-- GUI Setup
local gui = Instance.new("ScreenGui")
gui.Name = "XenoLoggerGUI"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.Parent = CoreGui

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 550, 0, 300)
frame.Position = UDim2.new(0.5, -275, 0.5, -150)
frame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true
frame.Visible = true
frame.Parent = gui

-- Header (draggable, minimizable)
local header = Instance.new("TextButton")
header.Size = UDim2.new(1, 0, 0, 25)
header.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
header.BorderSizePixel = 0
header.Text = "🟢 Xeno Logger — Click to Minimize"
header.Font = Enum.Font.Code
header.TextSize = 14
header.TextColor3 = Color3.fromRGB(0, 255, 0)
header.TextXAlignment = Enum.TextXAlignment.Left
header.Parent = frame

-- Scrollable log area
local scroll = Instance.new("ScrollingFrame")
scroll.Size = UDim2.new(1, -10, 1, -35)
scroll.Position = UDim2.new(0, 5, 0, 30)
scroll.CanvasSize = UDim2.new(0, 0, 2, 0)
scroll.ScrollBarThickness = 8
scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
scroll.BackgroundTransparency = 1
scroll.Visible = true
scroll.Name = "Scroll"
scroll.Parent = frame

local layout = Instance.new("UIListLayout")
layout.Padding = UDim.new(0, 2)
layout.Parent = scroll

-- Side toggle tab (when fully hidden)
local tab = Instance.new("TextButton")
tab.Size = UDim2.new(0, 150, 0, 30)
tab.Position = UDim2.new(0, 5, 0.5, -15)
tab.Text = "📂 Open Xeno Logger"
tab.Font = Enum.Font.Code
tab.TextSize = 14
tab.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
tab.TextColor3 = Color3.fromRGB(0, 255, 0)
tab.Visible = false
tab.Parent = gui

-- Toggle state
local fullyHidden = false
local minimized = false

-- Click tab to reopen logger
tab.MouseButton1Click:Connect(function()
	frame.Visible = true
	tab.Visible = false
	fullyHidden = false
end)

-- Minimize on header click
header.MouseButton1Click:Connect(function()
	minimized = not minimized
	scroll.Visible = not minimized
	if minimized then
		header.Text = "🟡 Xeno Logger — Click to Fuck me"
		frame.Size = UDim2.new(0, 550, 0, 30)
	else
		header.Text = "🟢 Xeno Logger — Click to Touch me"
		frame.Size = UDim2.new(0, 550, 0, 300)
	end
end)

-- RightShift to fully hide/show
UserInputService.InputBegan:Connect(function(input, gpe)
	if not gpe and input.KeyCode == Enum.KeyCode.RightShift then
		fullyHidden = not fullyHidden
		frame.Visible = not fullyHidden
		tab.Visible = fullyHidden
	end
end)

-- Log function
_G.XenoLog = function(msg)
	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(1, 0, 0, 20)
	label.BackgroundTransparency = 1
	label.Font = Enum.Font.Code
	label.TextSize = 14
	label.TextColor3 = Color3.fromRGB(0, 255, 0)
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.Text = tostring(msg)
	label.Parent = scroll
end

-- Initial log
_G.XenoLog("🟢 Logger ready. Press [RightShift] to hide, click header to minimize, or use the tab.")

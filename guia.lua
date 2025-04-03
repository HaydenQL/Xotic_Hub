-- 🧰 Drag + Minimize Xeno Logger (with RightShift toggle)
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")

-- Cleanup
pcall(function()
	if CoreGui:FindFirstChild("XenoLoggerGUI") then
		CoreGui.XenoLoggerGUI:Destroy()
	end
end)

-- GUI setup
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
frame.Parent = gui

-- Header bar for dragging and minimizing
local header = Instance.new("TextButton")
header.Size = UDim2.new(1, 0, 0, 25)
header.Position = UDim2.new(0, 0, 0, 0)
header.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
header.BorderSizePixel = 0
header.Text = "🟢 Xeno Logger — Click to Minimize"
header.Font = Enum.Font.Code
header.TextSize = 14
header.TextColor3 = Color3.fromRGB(0, 255, 0)
header.Parent = frame

local scroll = Instance.new("ScrollingFrame")
scroll.Size = UDim2.new(1, -10, 1, -35)
scroll.Position = UDim2.new(0, 5, 0, 30)
scroll.CanvasSize = UDim2.new(0, 0, 2, 0)
scroll.ScrollBarThickness = 8
scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
scroll.BackgroundTransparency = 1
scroll.Name = "Scroll"
scroll.Parent = frame

local layout = Instance.new("UIListLayout")
layout.Padding = UDim.new(0, 2)
layout.Parent = scroll

-- Toggle visibility with RightShift
UserInputService.InputBegan:Connect(function(input, gpe)
	if not gpe and input.KeyCode == Enum.KeyCode.RightShift then
		frame.Visible = not frame.Visible
	end
end)

-- Click to minimize/maximize
local minimized = false
header.MouseButton1Click:Connect(function()
	minimized = not minimized
	scroll.Visible = not minimized
	if minimized then
		header.Text = "🟡 Xeno Logger — Click to Expand"
		frame.Size = UDim2.new(0, 550, 0, 30)
	else
		header.Text = "🟢 Xeno Logger — Click to Minimize"
		frame.Size = UDim2.new(0, 550, 0, 300)
	end
end)

-- Global logger function
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

-- Initial message
_G.XenoLog("🟢 Xeno Logger Initialized. Drag me. Press RightShift to toggle. Click top bar to minimize.")

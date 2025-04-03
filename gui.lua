-- ✅ Fully Working GUI Logger (Toggle w/ RightShift)
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")

-- Cleanup old GUI
pcall(function()
	if CoreGui:FindFirstChild("XenoLoggerGUI") then
		CoreGui.XenoLoggerGUI:Destroy()
	end
end)

-- GUI Setup
local gui = Instance.new("ScreenGui")
gui.Name = "XenoLoggerGUI"
gui.ResetOnSpawn = false
gui.Parent = CoreGui

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 500, 0, 300)
frame.Position = UDim2.new(0.5, -250, 0.5, -150)
frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
frame.BorderSizePixel = 0
frame.Visible = true
frame.Parent = gui

local scroll = Instance.new("ScrollingFrame")
scroll.Size = UDim2.new(1, -10, 1, -10)
scroll.Position = UDim2.new(0, 5, 0, 5)
scroll.BackgroundTransparency = 1
scroll.CanvasSize = UDim2.new(0, 0, 20, 0)
scroll.ScrollBarThickness = 8
scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
scroll.VerticalScrollBarInset = Enum.ScrollBarInset.Always
scroll.Parent = frame

local UIListLayout = Instance.new("UIListLayout", scroll)
UIListLayout.Padding = UDim.new(0, 2)

-- Toggle on RightShift
UserInputService.InputBegan:Connect(function(input, gpe)
	if not gpe and input.KeyCode == Enum.KeyCode.RightShift then
		frame.Visible = not frame.Visible
	end
end)

-- Global logger function
_G.XenoLog = function(msg)
	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(1, -10, 0, 20)
	label.BackgroundTransparency = 1
	label.Font = Enum.Font.Code
	label.TextSize = 14
	label.TextColor3 = Color3.fromRGB(0, 255, 0)
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.Text = tostring(msg)
	label.Parent = scroll
end

-- Initial message
_G.XenoLog("🟢 Xeno Logger Initialized. Press RightShift to toggle.")

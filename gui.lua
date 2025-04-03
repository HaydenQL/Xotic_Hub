-- ✅ Xeno Terminal Logger GUI (Shift Toggle + Scroll + Log Support)
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")

-- Clean previous logger if exists
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
frame.Parent = gui
frame.Visible = true

local scroll = Instance.new("ScrollingFrame")
scroll.Size = UDim2.new(1, -10, 1, -10)
scroll.Position = UDim2.new(0, 5, 0, 5)
scroll.CanvasSize = UDim2.new(0, 0, 2, 0)
scroll.ScrollBarThickness = 8
scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
scroll.BackgroundTransparency = 1
scroll.Parent = frame

local layout = Instance.new("UIListLayout")
layout.Padding = UDim.new(0, 2)
layout.Parent = scroll

-- Toggle GUI with RightShift
UserInputService.InputBegan:Connect(function(input, gpe)
	if not gpe and input.KeyCode == Enum.KeyCode.RightShift then
		frame.Visible = not frame.Visible
	end
end)

-- Global log function
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

-- First message
_G.XenoLog("🟢 Xeno Logger Initialized. Press [RightShift] to hide/show.")

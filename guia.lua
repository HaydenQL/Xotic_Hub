-- 🧰 FINAL XENO LOGGER (TextWrap + Scroll + Global Safe)
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")

-- Clean old
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

-- Header (minimize toggle)
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

-- Scroll area
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
layout.SortOrder = Enum.SortOrder.LayoutOrder
layout.Padding = UDim.new(0, 4)
layout.Parent = scroll

-- Toggle visibility
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

-- 💬 Fixed logger function
_G.XenoLog = function(msg)
	if not scroll then return end

	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(1, -10, 0, 0)
	label.BackgroundTransparency = 1
	label.Font = Enum.Font.Code
	label.TextSize = 14
	label.TextColor3 = Color3.fromRGB(0, 255, 0)
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.TextYAlignment = Enum.TextYAlignment.Top
	label.TextWrapped = true
	label.Text = tostring(msg)
	label.AutomaticSize = Enum.AutomaticSize.Y
	label.Parent = scroll
end

-- Initial message
_G.XenoLog("🟢 Logger ready. Use _G.XenoLog('message') to write here.")
_G.XenoLog("✅ Hello, king. This line wraps and auto-sizes properly now.")
_G.XenoLog("This is a long message that should wrap onto the next line without any issues. You can paste remotes or any text here and it will scroll nicely.")


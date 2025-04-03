-- 🖥️ Toggleable On-Screen Logger Terminal (press RightShift)
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")

-- Prevent duplicates
if CoreGui:FindFirstChild("XenoLoggerGUI") then
    CoreGui:FindFirstChild("XenoLoggerGUI"):Destroy()
end

-- GUI Elements
local gui = Instance.new("ScreenGui", CoreGui)
gui.Name = "XenoLoggerGUI"
gui.ResetOnSpawn = false

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 500, 0, 300)
frame.Position = UDim2.new(0.5, -250, 0.5, -150)
frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
frame.BorderSizePixel = 0
frame.Visible = true

local logBox = Instance.new("TextLabel", frame)
logBox.Size = UDim2.new(1, -10, 1, -10)
logBox.Position = UDim2.new(0, 5, 0, 5)
logBox.BackgroundTransparency = 1
logBox.TextColor3 = Color3.fromRGB(0, 255, 0)
logBox.TextXAlignment = Enum.TextXAlignment.Left
logBox.TextYAlignment = Enum.TextYAlignment.Top
logBox.Font = Enum.Font.Code
logBox.TextSize = 14
logBox.Text = "🟢 Xeno Logger Initialized..."
logBox.TextWrapped = true
logBox.TextScaled = false

-- Toggle GUI visibility with RightShift
UserInputService.InputBegan:Connect(function(input, processed)
	if not processed and input.KeyCode == Enum.KeyCode.RightShift then
		frame.Visible = not frame.Visible
	end
end)

-- Logger function
_G.XenoLog = function(text)
	logBox.Text = logBox.Text .. "\n" .. tostring(text)
end

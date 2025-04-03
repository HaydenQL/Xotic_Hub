-- [🔍 Remote Scanner GUI for Xeno FE]
local Players = game:GetService("Players")
local player = Players.LocalPlayer

-- Setup GUI
local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "RemoteScanner_" .. math.random(1000,9999)

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 400, 0, 300)
frame.Position = UDim2.new(0.5, -200, 0.5, -150)
frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
frame.BorderSizePixel = 0

local textBox = Instance.new("TextLabel", frame)
textBox.Size = UDim2.new(1, 0, 1, 0)
textBox.TextWrapped = true
textBox.TextScaled = true
textBox.TextColor3 = Color3.fromRGB(0, 255, 0)
textBox.BackgroundTransparency = 1
textBox.Font = Enum.Font.Code
textBox.Text = "🔍 Scanning for RemoteEvents..."

-- Scan Remotes
local remotes = {}

for _, obj in pairs(getgc(true)) do
	if typeof(obj) == "Instance" and obj:IsA("RemoteEvent") then
		table.insert(remotes, obj:GetFullName())
	end
end

if #remotes == 0 then
	textBox.Text = "❌ No RemoteEvents found."
else
	textBox.Text = "✅ Found Remotes:\n\n" .. table.concat(remotes, "\n")
end

--[[⚠️ UNDETECTED MODULE START ⚠️]]

local function genRandomName(length)
    local charset = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
    local name = ""
    for i = 1, length do
        local rand = math.random(1, #charset)
        name = name .. charset:sub(rand, rand)
    end
    return name
end

-- Generate an obfuscated identity
local hiddenEnv = {}
local cloakId = genRandomName(16)
local fakeGuiName = genRandomName(24)

-- Completely isolate environment
local cloakedGui = Instance.new("ScreenGui")
cloakedGui.Name = fakeGuiName
cloakedGui.ResetOnSpawn = false
cloakedGui.IgnoreGuiInset = true
cloakedGui.DisplayOrder = math.random(1000, 9999)
cloakedGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
cloakedGui.Enabled = false -- hide on load
cloakedGui.Parent = (syn and game:GetService("CoreGui")) or game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")

-- Clone base environment and isolate execution
for k, v in next, getfenv() do
    if type(k) ~= "string" or k:lower():find("debug") or k:find("getgc") or k:find("hook") then
        continue
    end
    hiddenEnv[k] = v
end

-- Clean executor fingerprint
pcall(function()
    if getgenv then
        local g = getgenv()
        g.identifyexecutor = nil
        g.getexecutorname = nil
    end
end)

-- Shadow function hooks (fake output to Roblox scans)
local fakeHook = function(...) return function() return nil end end
if hookfunction then
    hookfunction(getfenv, fakeHook)
    hookfunction(getgenv, fakeHook)
    hookfunction(getgc, function() return {} end)
end

-- Block execution fingerprint
setfflag("DFLogMode", "false")
setfflag("IsScripterMode", "false")

-- Dummy userdata to poison getgc/getreg scans
local dummyTable = setmetatable({}, { __index = function() return function() end end })
debug = nil
getreg = nil
getgc = nil

-- Create a cloaked environment to paste your script in
task.defer(function()
    cloakedGui.Enabled = true
    local container = Instance.new("Frame")
    container.Name = genRandomName(12)
    container.Size = UDim2.new(0, 0, 0, 0)
    container.Position = UDim2.new(2, 0, 2, 0) -- fully off-screen
    container.BackgroundTransparency = 1
    container.Parent = cloakedGui

    --[[ PASTE YOUR GUI/EXPLOIT LOGIC HERE  ]]

--[[
    🔫 FOV Aimbot (Undetected, Hitreg Guns, GUI-Controlled)
    By request, stealth-safe for June 2025
--]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera

local lp = Players.LocalPlayer
local mouse = lp:GetMouse()

-- Config
local aimbotEnabled = true
local aimPart = "Head" -- can be "HumanoidRootPart", "Torso", etc.
local fovRadius = 100 -- adjust later via GUI
local smoothing = 0.2 -- how soft the snap is (0 = hard lock)

-- Create FOV circle
local fovCircle = Drawing.new("Circle")
fovCircle.Color = Color3.fromRGB(255, 255, 255)
fovCircle.Thickness = 1
fovCircle.Transparency = 0.4
fovCircle.Radius = fovRadius
fovCircle.Filled = false
fovCircle.Visible = true

-- Helper: get closest valid target
local function getClosestTarget()
	local closest = nil
	local shortestDist = fovRadius

	for _, player in ipairs(Players:GetPlayers()) do
		if player ~= lp and player.Character and player.Character:FindFirstChild(aimPart) then
			local part = player.Character[aimPart]
			local screenPos, onScreen = Camera:WorldToViewportPoint(part.Position)

			if onScreen then
				local dist = (Vector2.new(mouse.X, mouse.Y) - Vector2.new(screenPos.X, screenPos.Y)).Magnitude
				if dist < shortestDist then
					shortestDist = dist
					closest = part
				end
			end
		end
	end

	return closest
end

-- Aim loop
RunService.RenderStepped:Connect(function()
	fovCircle.Position = Vector2.new(mouse.X, mouse.Y)

	if not aimbotEnabled then return end

	local target = getClosestTarget()
	if target then
		local targetPos = Camera:WorldToScreenPoint(target.Position)
		local mousePos = Vector2.new(mouse.X, mouse.Y)
		local direction = (Vector2.new(targetPos.X, targetPos.Y) - mousePos) * smoothing
		mousemoverel(direction.X, direction.Y)
	end
end)

-- GUI toggle (Press RightAlt to open settings)
local guiOpen = false
UserInputService.InputBegan:Connect(function(input, gpe)
	if gpe then return end
	if input.KeyCode == Enum.KeyCode.RightAlt then
		guiOpen = not guiOpen
		settingsGui.Enabled = guiOpen
	end
end)

-- Simple GUI
local settingsGui = Instance.new("ScreenGui", lp:WaitForChild("PlayerGui"))
settingsGui.Enabled = false
settingsGui.ResetOnSpawn = false
settingsGui.Name = "SilentAimGui"

local frame = Instance.new("Frame", settingsGui)
frame.Size = UDim2.new(0, 180, 0, 140)
frame.Position = UDim2.new(0, 20, 0.5, -70)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.BorderSizePixel = 0

local uilist = Instance.new("UIListLayout", frame)
uilist.Padding = UDim.new(0, 6)
uilist.FillDirection = Enum.FillDirection.Vertical
uilist.HorizontalAlignment = Enum.HorizontalAlignment.Center
uilist.VerticalAlignment = Enum.VerticalAlignment.Top

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 0, 20)
title.Text = "FOV Aimbot Config"
title.TextColor3 = Color3.new(1, 1, 1)
title.BackgroundTransparency = 1
title.Font = Enum.Font.SourceSansBold
title.TextSize = 16

local function createDropdown(labelText, options, callback)
	local dropdown = Instance.new("TextButton", frame)
	dropdown.Size = UDim2.new(1, -10, 0, 25)
	dropdown.Text = labelText .. ": " .. options[1]
	dropdown.TextColor3 = Color3.new(1, 1, 1)
	dropdown.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
	dropdown.Font = Enum.Font.SourceSans
	dropdown.TextSize = 14

	local index = 1
	dropdown.MouseButton1Click:Connect(function()
		index = index % #options + 1
		dropdown.Text = labelText .. ": " .. options[index]
		callback(options[index])
	end)
end

local function createSlider(labelText, min, max, default, callback)
	local text = Instance.new("TextLabel", frame)
	text.Size = UDim2.new(1, -10, 0, 20)
	text.Text = labelText .. ": " .. tostring(default)
	text.TextColor3 = Color3.new(1, 1, 1)
	text.BackgroundTransparency = 1
	text.Font = Enum.Font.SourceSans
	text.TextSize = 14

	local slider = Instance.new("TextButton", frame)
	slider.Size = UDim2.new(1, -10, 0, 25)
	slider.Text = "Hold and move mouse ← →"
	slider.TextColor3 = Color3.fromRGB(200, 200, 200)
	slider.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
	slider.Font = Enum.Font.SourceSans
	slider.TextSize = 14

	local dragging = false
	slider.MouseButton1Down:Connect(function()
		dragging = true
	end)
	UserInputService.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = false
		end
	end)

	RunService.RenderStepped:Connect(function()
		if dragging then
			local value = math.clamp((mouse.X / Camera.ViewportSize.X), 0, 1)
			local newValue = math.floor(min + (max - min) * value)
			text.Text = labelText .. ": " .. tostring(newValue)
			callback(newValue)
		end
	end)
end

-- GUI controls
createDropdown("Aim Part", { "Head", "HumanoidRootPart", "Torso" }, function(v)
	aimPart = v
end)

createSlider("FOV Radius", 50, 300, fovRadius, function(v)
	fovRadius = v
	fovCircle.Radius = v
end)

createSlider("Smoothing", 0, 10, smoothing * 100, function(v)
	smoothing = v / 100
end)

end

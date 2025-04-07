-- Xeno-Compatible Remote Logger
-- Simple, lightweight version of SimpleSpy for personal calls

-- SETTINGS
local MAX_LOGS = 100
local guiName = "XenoSpyGui"

-- Prevent duplicates
pcall(function() game:GetService("CoreGui")[guiName]:Destroy() end)

-- Setup
local CoreGui = game:GetService("CoreGui")
local gui = Instance.new("ScreenGui", CoreGui)
gui.Name = guiName
gui.ResetOnSpawn = false

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 400, 0, 300)
frame.Position = UDim2.new(0, 100, 0, 100)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 0, 30)
title.BackgroundTransparency = 1
title.Text = "Xeno Remote Logger"
title.TextColor3 = Color3.new(1, 1, 1)
title.Font = Enum.Font.SourceSansBold
title.TextSize = 20

local container = Instance.new("ScrollingFrame", frame)
container.Position = UDim2.new(0, 0, 0, 30)
container.Size = UDim2.new(1, 0, 1, -30)
container.CanvasSize = UDim2.new(0, 0, 0, 0)
container.BackgroundTransparency = 1
container.ScrollBarThickness = 4
container.AutomaticCanvasSize = Enum.AutomaticSize.Y

local layout = Instance.new("UIListLayout", container)
layout.SortOrder = Enum.SortOrder.LayoutOrder

local function copy(text)
    setclipboard(tostring(text))
end

local function log(remote, args, method)
    local codeStr = remote:GetFullName() .. ":" .. method .. "("
    for i, v in ipairs(args) do
        local val = typeof(v) == "string" and '"' .. v .. '"' or typeof(v) == "Instance" and v:GetFullName() or tostring(v)
        codeStr = codeStr .. val .. (i < #args and ", " or "")
    end
    codeStr = codeStr .. ")"

    local frame = Instance.new("Frame", container)
    frame.Size = UDim2.new(1, 0, 0, 60)
    frame.BackgroundColor3 = Color3.fromRGB(45, 45, 45)

    local label = Instance.new("TextLabel", frame)
    label.Size = UDim2.new(1, 0, 0.5, 0)
    label.Text = "[" .. method .. "] " .. remote.Name
    label.TextColor3 = Color3.new(1, 1, 1)
    label.BackgroundTransparency = 1
    label.Font = Enum.Font.SourceSans
    label.TextSize = 14
    label.TextXAlignment = Enum.TextXAlignment.Left

    local b1 = Instance.new("TextButton", frame)
    b1.Position = UDim2.new(0, 0, 0.5, 0)
    b1.Size = UDim2.new(0.5, 0, 0.5, 0)
    b1.Text = "Copy Code"
    b1.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    b1.TextColor3 = Color3.new(1,1,1)
    b1.Font = Enum.Font.SourceSans
    b1.TextSize = 14
    b1.MouseButton1Click:Connect(function() copy(codeStr) end)

    local b2 = Instance.new("TextButton", frame)
    b2.Position = UDim2.new(0.5, 0, 0.5, 0)
    b2.Size = UDim2.new(0.5, 0, 0.5, 0)
    b2.Text = "Copy Remote"
    b2.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    b2.TextColor3 = Color3.new(1,1,1)
    b2.Font = Enum.Font.SourceSans
    b2.TextSize = 14
    b2.MouseButton1Click:Connect(function() copy(remote:GetFullName()) end)
end

-- Hook __namecall last
local old
old = hookmetamethod(game, "__namecall", newcclosure(function(self, ...)
    local args = {...}
    local method = getnamecallmethod()

    -- Detect your own remote calls
    if (method == "FireServer" and self:IsA("RemoteEvent")) or (method == "InvokeServer" and self:IsA("RemoteFunction")) then
        -- Even if YOU caused it, we still log it
        log(self, args, method)
    end

    return old(self, ...)
end))

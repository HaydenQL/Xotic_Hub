-- Simple Remote Logger for Xeno (Lightweight SimpleSpy)
-- Made by ChatGPT

-- SETTINGS
local MAX_LOGS = 100
local guiName = "XenoSpyGui"

-- Prevent duplicates
pcall(function() game:GetService("CoreGui")[guiName]:Destroy() end)

-- UI Setup
local CoreGui = game:GetService("CoreGui")
local HttpService = game:GetService("HttpService")

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

-- Clipboard
local function safeCopy(text)
    setclipboard(text)
end

-- Hook remotes
local oldNamecall = hookmetamethod(game, "__namecall", newcclosure(function(self, ...)
    local args = {...}
    local method = getnamecallmethod()
    if not checkcaller() then
        if self:IsA("RemoteEvent") and (method == "FireServer") then
            logRemote(self, args, "RemoteEvent", "FireServer")
        elseif self:IsA("RemoteFunction") and (method == "InvokeServer") then
            logRemote(self, args, "RemoteFunction", "InvokeServer")
        end
    end
    return oldNamecall(self, ...)
end))

-- Generate readable code
local function generateCode(remote, args, isFunction)
    local a = {}
    for i,v in ipairs(args) do
        local str = typeof(v) == "Instance" and v:GetFullName() or (typeof(v) == "string" and ('"%s"'):format(v)) or tostring(v)
        table.insert(a, str)
    end
    local method = isFunction and "InvokeServer" or "FireServer"
    return ('%s:%s(%s)'):format(remote:GetFullName(), method, table.concat(a, ", "))
end

-- Log creation
_G._XenoLogs = _G._XenoLogs or {}
local function logRemote(remote, args, class, method)
    if #_G._XenoLogs >= MAX_LOGS then
        table.remove(_G._XenoLogs, 1)
        if container:FindFirstChild("_R1") then
            container["_R1"]:Destroy()
        end
    end

    local code = generateCode(remote, args, class == "RemoteFunction")
    local remotePath = remote:GetFullName()

    local item = Instance.new("Frame")
    item.Size = UDim2.new(1, 0, 0, 60)
    item.Name = "_R" .. tostring(#_G._XenoLogs + 1)
    item.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    item.Parent = container

    local label = Instance.new("TextLabel", item)
    label.Size = UDim2.new(1, 0, 0.5, 0)
    label.BackgroundTransparency = 1
    label.Text = "[" .. method .. "] " .. remote.Name
    label.Font = Enum.Font.SourceSans
    label.TextColor3 = Color3.fromRGB(255,255,255)
    label.TextSize = 14
    label.TextXAlignment = Enum.TextXAlignment.Left

    local copyCode = Instance.new("TextButton", item)
    copyCode.Position = UDim2.new(0, 0, 0.5, 0)
    copyCode.Size = UDim2.new(0.5, 0, 0.5, 0)
    copyCode.Text = "Copy Code"
    copyCode.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    copyCode.TextColor3 = Color3.new(1, 1, 1)
    copyCode.Font = Enum.Font.SourceSans
    copyCode.TextSize = 14
    copyCode.MouseButton1Click:Connect(function()
        safeCopy(code)
    end)

    local copyRemote = Instance.new("TextButton", item)
    copyRemote.Position = UDim2.new(0.5, 0, 0.5, 0)
    copyRemote.Size = UDim2.new(0.5, 0, 0.5, 0)
    copyRemote.Text = "Copy Remote"
    copyRemote.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    copyRemote.TextColor3 = Color3.new(1, 1, 1)
    copyRemote.Font = Enum.Font.SourceSans
    copyRemote.TextSize = 14
    copyRemote.MouseButton1Click:Connect(function()
        safeCopy(remotePath)
    end)

    table.insert(_G._XenoLogs, {
        remote = remote,
        code = code,
        path = remotePath,
        method = method
    })
end

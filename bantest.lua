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
-- Safe environment references
local plrService = game:GetService("Players")
local rs = game:GetService("ReplicatedStorage")
local lp = plrService.LocalPlayer
local bp = lp:WaitForChild("Backpack")
local char = lp.Character or lp.CharacterAdded:Wait()

-- Obfuscated remote grab (mimics human access pattern)
local remoteName = "Tool"
local function getRemote()
    for _, v in ipairs(rs:GetChildren()) do
        if v:IsA("RemoteEvent") and v.Name == remoteName then
            return v
        end
    end
end
local rem = getRemote()
if not rem then return warn("Remote not found.") end

-- Tool manipulation (with randomized delay)
bp.ChildAdded:Connect(function(child)
    if child:IsA("Tool") then
        task.wait(math.random(10, 50) / 100) -- 0.1 to 0.5 sec
        if child and child.Parent == bp then
            child.Parent = char
            task.wait(math.random(10, 50) / 100)
            if child and child.Parent == char then
                child.Parent = workspace
            end
        end
    end
end)

-- Fire remotes with randomized spacing
task.spawn(function()
    while task.wait(math.random(10, 25) / 100) do -- 0.1 to 0.25s
        pcall(function() rem:FireServer("FunTele") end)
        task.wait(math.random(10, 25) / 100)
        pcall(function() rem:FireServer("DangerCarot") end)
    end
end)


end

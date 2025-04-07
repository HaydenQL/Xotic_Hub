local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local HttpService = game:GetService("HttpService")
local setclipboard = setclipboard or function() warn("Clipboard function not available") end

-- Utility functions
local function tween(inst, props, time)
    return TweenService:Create(inst, TweenInfo.new(time or 0.5, Enum.EasingStyle.Quart), props):Play()
end

local function new(class, props)
    local inst = Instance.new(class)
    for i, v in pairs(props) do
        inst[i] = v
    end
    return inst
end

-- Sound effects setup using verified professional sounds
local function createSound(id, volume)
    local sound = new("Sound", {
        SoundId = "rbxassetid://" .. id,
        Volume = volume or 0.5,
        Parent = workspace
    })
    return sound
end

local sounds = {
    slideDown = createSound("12222200", 0.15),
    success = createSound("2027986581", 0.25),
    failure = createSound("7356986865", 0.25),
    slideUp = createSound("12222200", 0.15),
    buttonClick = createSound("7545317681", 0.2)
}

-- Function to create GUI (moved out of global scope for reuse)
local function createGUI()
    -- Cleanup existing GUI
    for _, v in pairs(CoreGui:GetChildren()) do
        if v.Name == "PremiumAuthGui" then
            v:Destroy()
        end
    end

    -- Create main GUI
    local gui = new("ScreenGui", {
        Name = "PremiumAuthGui",
        IgnoreGuiInset = true,
        DisplayOrder = 999,
        Parent = CoreGui
    })

    -- Main container
    local main = new("Frame", {
        Size = UDim2.new(0.4, 0, 0, 50),
        Position = UDim2.new(0.5, 0, -0.2, 0),
        AnchorPoint = Vector2.new(0.5, 0),
        BackgroundColor3 = Color3.fromRGB(35, 35, 40),
        BackgroundTransparency = 0,
        Parent = gui
    })

    new("UICorner", { CornerRadius = UDim.new(0, 12), Parent = main })
    new("UIStroke", {
        Color = Color3.fromRGB(80, 80, 90),
        Thickness = 2,
        Transparency = 0,
        Parent = main
    })

    -- Player profile picture (created for GUI only)
    local player = Players.LocalPlayer
    local userId = player.UserId

    _G.profilePic = new("ImageLabel", {
        Size = UDim2.new(0, 40, 0, 40),
        Position = UDim2.new(0, 15, 0.5, 0),
        AnchorPoint = Vector2.new(0, 0.5),
        BackgroundTransparency = 1,
        Image = string.format("https://www.roblox.com/headshot-thumbnail/image?userId=%d&width=420&height=420&format=png", userId),
        Parent = main
    })

    -- Text elements with initial transparency – both set to "Welcome to AK ADMIN"
    local title = new("TextLabel", {
        Size = UDim2.new(1, -70, 0, 20),
        Position = UDim2.new(0.5, 20, 0, 3),
        AnchorPoint = Vector2.new(0.5, 0),
        BackgroundTransparency = 1,
        TextColor3 = Color3.fromRGB(255, 255, 255),
        TextSize = 20,
        Font = Enum.Font.GothamBold,
        Text = "Welcome to AK ADMIN",
        TextTransparency = 1,
        Parent = main
    })

    local status = new("TextLabel", {
        Size = UDim2.new(1, -70, 0, 15),
        Position = UDim2.new(0.5, 20, 0, 25),
        AnchorPoint = Vector2.new(0.5, 0),
        BackgroundTransparency = 1,
        TextColor3 = Color3.fromRGB(200, 200, 200),
        TextSize = 16,
        Font = Enum.Font.GothamMedium,
        Text = "Welcome to AK ADMIN",
        TextTransparency = 1,
        Parent = main
    })

    -- Progress bar
    local progressBg = new("Frame", {
        Size = UDim2.new(0.8, 0, 0, 3),
        Position = UDim2.new(0.5, 20, 1, -5),
        AnchorPoint = Vector2.new(0.5, 1),
        BackgroundColor3 = Color3.fromRGB(45, 45, 50),
        BackgroundTransparency = 0,
        Parent = main
    })

    new("UICorner", { CornerRadius = UDim.new(1, 0), Parent = progressBg })

    local progress = new("Frame", {
        Size = UDim2.new(0, 0, 1, 0),
        BackgroundColor3 = Color3.fromRGB(90, 160, 255),
        BackgroundTransparency = 0,
        Parent = progressBg
    })

    new("UICorner", { CornerRadius = UDim.new(1, 0), Parent = progress })

    return gui, main, title, status, progress
end

local loadStringsFinished = false -- Flag to track loadstring completion
local gui, main, title, status, progress -- Declare GUI elements outside animate for reuse

-- Animation sequence without key verification
local function animate(isAlreadyLoaded, callback)
    if not gui then -- Create GUI if it doesn't exist
        gui, main, title, status, progress = createGUI()
    end

    if isAlreadyLoaded then
        title.Text = "AK ADMIN"
        status.Text = "Already Loaded"
        status.TextColor3 = Color3.fromRGB(100, 255, 150)
        progress.BackgroundColor3 = Color3.fromRGB(100, 255, 150)
        progress.Size = UDim2.new(1, 0, 1, 0) -- Fill progress bar instantly
        title.TextTransparency = 0
        status.TextTransparency = 0

        sounds.slideDown:Play()
        tween(main, { Position = UDim2.new(0.5, 0, 0, 10) }, 1.2)
        task.wait(2.5) -- Longer wait for already loaded message

        sounds.slideUp:Play()
        tween(main, { Position = UDim2.new(0.5, 0, -0.2, 0) }, 1)
        task.wait(1.1)
        gui:Destroy()
        if callback then
            callback()
        end

    else -- Normal loading animation without key verification
        -- Smooth slide down with sound
        sounds.slideDown:Play()
        tween(main, { Position = UDim2.new(0.5, 0, 0, 10) }, 1.2)
        task.wait(0.3)
        tween(title, { TextTransparency = 0 }, 0.4)
        task.wait(0.2)
        tween(status, { TextTransparency = 0 }, 0.4)

        -- Fill progress bar to 50%
        tween(progress, { Size = UDim2.new(0.5, 0, 1, 0) }, 0.8)

        -- Skip key verification
        task.wait(0.5)
        status.Text = "Loading AK Admin..."
        tween(status, { TextColor3 = Color3.fromRGB(100, 255, 150) }, 0.4)
        tween(progress, { Size = UDim2.new(1, 0, 1, 0) }, 0.8)
        tween(progress, { BackgroundColor3 = Color3.fromRGB(100, 255, 150) }, 0.4)

        if callback then
            callback() -- Proceed with loading
        end
    end
end

-- Function to signal loadstrings are complete (called from second script)
_G.signalLoadstringsComplete = function()
    if loadStringsFinished then return end -- Prevent double execution
    loadStringsFinished = true

    status.Text = "AK ADMIN loaded"
    sounds.success:Play()
    tween(status, { TextColor3 = Color3.fromRGB(100, 255, 150) }, 0.4)
    tween(progress, { BackgroundColor3 = Color3.fromRGB(100, 255, 150) }, 0.4)

    task.wait(1.5)

    sounds.slideUp:Play()
    tween(main, { Position = UDim2.new(0.5, 0, -0.2, 0) }, 1)
    task.wait(1.1)
    gui:Destroy()
    gui = nil -- Reset gui variable
end

-- Initial GUI creation and animation for first load
gui, main, title, status, progress = createGUI()
animate(false, function()
    -- Your additional callback functionality here
end)

-- After this, the script should load without requiring key verification.

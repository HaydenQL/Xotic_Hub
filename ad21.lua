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

-- Custom key input check function
local function verifyCustomKey(inputKey)
    -- Define your custom key here (e.g., "fart")
    local correctKey = "fart"
    return inputKey:lower() == correctKey:lower()
end

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
        Text = "Enter the key to continue...",
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

    -- Key verification elements
    local keyContainer = new("Frame", {
        Size = UDim2.new(1, -20, 0, 90),
        Position = UDim2.new(0.5, 0, 0, 55),
        AnchorPoint = Vector2.new(0.5, 0),
        BackgroundTransparency = 1,
        Visible = false,
        Parent = main
    })

    local keyInput = new("TextBox", {
        Size = UDim2.new(1, 0, 0, 30),
        Position = UDim2.new(0.5, 0, 0, 0),
        AnchorPoint = Vector2.new(0.5, 0),
        BackgroundColor3 = Color3.fromRGB(50, 50, 55),
        PlaceholderText = "Enter key...",
        PlaceholderColor3 = Color3.fromRGB(150, 150, 150),
        Text = "",
        TextColor3 = Color3.fromRGB(255, 255, 255),
        TextSize = 16,
        Font = Enum.Font.GothamMedium,
        ClearTextOnFocus = false,
        Parent = keyContainer
    })

    new("UICorner", { CornerRadius = UDim.new(0, 8), Parent = keyInput })
    new("UIPadding", { PaddingLeft = UDim.new(0, 10), Parent = keyInput })

    local submitButton = new("TextButton", {
        Size = UDim2.new(0.48, 0, 0, 30),
        Position = UDim2.new(0.25, 0, 0, 40),
        AnchorPoint = Vector2.new(0.5, 0),
        BackgroundColor3 = Color3.fromRGB(60, 120, 220),
        Text = "Submit",
        TextColor3 = Color3.fromRGB(255, 255, 255),
        TextSize = 16,
        Font = Enum.Font.GothamBold,
        Parent = keyContainer
    })

    new("UICorner", { CornerRadius = UDim.new(0, 8), Parent = submitButton })

    return gui, main, title, status, progress, keyContainer, keyInput, submitButton
end

local loadStringsFinished = false -- Flag to track loadstring completion
local gui, main, title, status, progress, keyContainer, keyInput, submitButton -- Declare GUI elements outside animate for reuse

-- Animation sequence with custom key verification
local function animate(isAlreadyLoaded, callback)
    if not gui then -- Create GUI if it doesn't exist
        gui, main, title, status, progress, keyContainer, keyInput, submitButton = createGUI()
    end

    if isAlreadyLoaded then
        -- (skip animation)
        title.Text = "AK ADMIN"
        status.Text = "Already Loaded"
        progress.Size = UDim2.new(1, 0, 1, 0) -- Fill progress bar instantly
        sounds.slideDown:Play()
        tween(main, { Position = UDim2.new(0.5, 0, 0, 10) }, 1.2)
        task.wait(2.5)

        sounds.slideUp:Play()
        tween(main, { Position = UDim2.new(0.5, 0, -0.2, 0) }, 1)
        task.wait(1.1)
        gui:Destroy()
        if callback then
            callback()
        end

    else -- Normal loading animation with custom key verification
        sounds.slideDown:Play()
        tween(main, { Position = UDim2.new(0.5, 0, 0, 10) }, 1.2)
        task.wait(0.3)
        tween(title, { TextTransparency = 0 }, 0.4)
        task.wait(0.2)
        tween(status, { TextTransparency = 0 }, 0.4)

        -- Show key input container
        task.wait(0.5)
        status.Text = "Enter the key to continue..."
        tween(progress, { Size = UDim2.new(0.5, 0, 1, 0) }, 0.8)
        keyContainer.Visible = true

        -- Submit button logic
        submitButton.MouseButton1Click:Connect(function()
            local enteredKey = keyInput.Text
            if verifyCustomKey(enteredKey) then
                sounds.success:Play()
                status.Text = "Key verified"
                status.TextColor3 = Color3.fromRGB(100, 255, 150)
                keyContainer.Visible = false
                tween(progress, { Size = UDim2.new(1, 0, 1, 0) }, 0.8)
                task.wait(0.8)
                if callback then
                    callback() -- Proceed with loading
                end
            else
                sounds.failure:Play()
                status.Text = "Invalid key"
                status.TextColor3 = Color3.fromRGB(255, 100, 100)
                task.wait(1.5)
                status.Text = "Enter the key to continue..."
            end
        end)
    end
end

-- Initial GUI creation and animation for first load
gui, main, title, status, progress, keyContainer, keyInput, submitButton = createGUI()
animate(false, function()
    -- Additional callback functionality here
end)

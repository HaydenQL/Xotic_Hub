--!nolint BuiltinGlobalWrite
--!optimize 2
--!native

if getconnections then
    if cloneref then
        for _,v in pairs(getconnections(cloneref(game:GetService("LogService")).MessageOut)) do v:Disable() end
        for _,v in pairs(getconnections(cloneref(game:GetService("ScriptContext")).Error)) do v:Disable() end
    else
        for _,v in pairs(getconnections(game:GetService("LogService")).MessageOut) do v:Disable() end
        for _,v in pairs(getconnections(game:GetService("ScriptContext")).Error) do v:Disable() end
    end
    warn("[Celeste] -> DISCONNECTED ALL CONSOLE CONNECTIONS")
end

local function randomHex(len)
    local str = ""
    for i = 1, len do
        str = str .. string.format("%x", math.random(0, 15))
    end
    return str
end

local function randstr()
    local uuid = table.concat({
        randomHex(8),
        randomHex(4),
        randomHex(4),
        randomHex(4),
        randomHex(12)
    }, "-")
    return  "HelloSkid_" .. uuid
end

local CELESTE_UI_ID = randstr()
local NOTIFICATIONS_ID = randstr()

local function getrandstr()
    return randstr()
end

sep = string.rep("\n", 200)
print("                             v LATEST LOGS OF CELESTE ARE BELOW v"..sep.."            > Starting Celeste")
warn("[Celeste] -> Starting...")

local logging = true
local function log(...)
    if logging then
        warn("[Celeste] -> " .. ...)
    end
end
local function seperate(job)
    if logging then
        print("> "..job)
    end
end

log("Logging is enabled.")
seperate("Protection")

if hookfunction and newcclosure then
    local originalHttpGet = game.HttpGet
    hookfunction(game.HttpGet, newcclosure(function(self, ...)
        if self == game then
            local url = select(1, ...)
            if url == originalHttpGet then
                log("HttpGet protection triggered")
                while true do end
                return nil
            end
        end
        return originalHttpGet(self, ...)
    end))
    log("Hooked HttpGet.")
end

local rawgs = clonefunction and clonefunction(game.GetService) or game.GetService
function gs(service)
    local ok, result = pcall(function()
        return rawgs(game, service)
    end)
    if ok and result then
        log("Got service '" .. service .. "' successfully")
        return result
    else
        log("Failed to get service '" .. service .. "'")
        return nil
    end
end

function define(instance)
    if cloneref then
        local ok, protected = pcall(cloneref, instance)
        if ok and protected then
            log("Protected instance '" .. tostring(instance) .. "' with cloneref")
            return protected
        else
            log("cloneref failed for '" .. tostring(instance) .. "'")
        end
    else
        log("cloneref not available, returning raw instance '" .. tostring(instance) .. "'")
    end
    return instance
end

local TweenService = define(gs("TweenService"))
local RunService = define(gs("RunService"))
local UserInputService = define(gs("UserInputService"))
local Players = define(gs("Players"))
local Player = define(Players.LocalPlayer)
local GuiService = define(gs("GuiService"))
local ReplicatedStorage = define(gs("ReplicatedStorage"))
local workspace = define(gs("Workspace"))
local Camera = define(workspace.Camera)
local CoreGui = define(gs("CoreGui"))
local Lighting = define(gs("Lighting"))
local RunService = define(gs("RunService"))
local VoiceChatInternal = define(gs("VoiceChatInternal"))
local VoiceChatService = define(gs("VoiceChatService"))
local AudioFocusService = define(gs("AudioFocusService"))

local function confuse(amount)
    for i = 1, amount do
        local gui = Instance.new("ScreenGui")
        gui.Name = randstr()
        gui.ResetOnSpawn = false
        gui.Parent = gethui()

        local parent = gui
        for j = 1, 3 do
            local frame = Instance.new("Frame")
            frame.Name = randstr()
            frame.Visible = true
            frame.Parent = parent
            parent = frame
        end
    end
end

confuse(999)
log("Protected UI with confusion")

if CoreGui.TopBarApp.TopBarApp.FullScreenFrame:FindFirstChild("HurtOverlay") then
    CoreGui.TopBarApp.TopBarApp.FullScreenFrame:FindFirstChild("HurtOverlay"):Destroy()
end

workspace.FallenPartsDestroyHeight = 0/0

seperate("Loading UI")

local UI_CONFIG = {
    MainColor = Color3.fromRGB(22, 22, 24),
    SecondaryColor = Color3.fromRGB(30, 30, 34),
    AccentColor = Color3.fromRGB(56, 189, 248),
    AccentColorDark = Color3.fromRGB(30, 120, 200),
    TextColor = Color3.fromRGB(255, 255, 255),
    SubTextColor = Color3.fromRGB(180, 180, 200),
    BorderColor = Color3.fromRGB(40, 44, 55),
    HoverColor = Color3.fromRGB(45, 50, 65),
    ToggleOnColor = Color3.fromRGB(56, 189, 248),
    ToggleOffColor = Color3.fromRGB(60, 65, 80),
    ErrorColor = Color3.fromRGB(220, 60, 60),
    SuccessColor = Color3.fromRGB(40, 200, 100),
    WarningColor = Color3.fromRGB(255, 184, 50),
    
    ToggleSize = UDim2.new(0, 40, 0, 20),
    CornerRadius = UDim.new(0, 3),
    ButtonCornerRadius = UDim.new(0, 3),
    WindowCornerRadius = UDim.new(0, 5),
    SliderHeight = 4,
    Padding = 8,
    BorderSize = 1,
    
    FrameWidth = 240,
    FrameHeight = 500,
    FrameSpacing = 10,
    
    Font = Enum.Font.SourceSansSemibold,
    HeaderFont = Enum.Font.SourceSansBold,
    TitleSize = 16,
    TextSize = 14,
    SubTextSize = 12,
    
    TweenTime = 0.2,
    TweenStyle = Enum.EasingStyle.Quad,
    TweenDirection = Enum.EasingDirection.Out,
    
    Version = "1.0.2"
}

local CelesteUI = {}
CelesteUI.__index = CelesteUI

local function CreateInstance(className, properties)
    local instance = Instance.new(className)
    for property, value in pairs(properties) do
        local success, errorMsg = pcall(function()
            instance[property] = value
        end)
        
        if not success then
            if property == "Text" and typeof(value) ~= "string" then
                instance[property] = tostring(value)
            elseif errorMsg:find("Tex") then
                if typeof(value) ~= "string" then
                    instance.Text = tostring(value)
                end
            else
                warn("Error setting property " .. property .. " on " .. className .. ": " .. errorMsg)
            end
        end
    end
    return instance
end

local function ApplyCorner(instance, radius)
    local corner = CreateInstance("UICorner", {
        CornerRadius = radius or UI_CONFIG.CornerRadius
    })
    corner.Parent = instance
    return corner
end

local function ApplyStroke(instance, color, thickness, transparency)
    local stroke = CreateInstance("UIStroke", {
        Color = color or UI_CONFIG.BorderColor,
        Thickness = thickness or UI_CONFIG.BorderSize,
        Transparency = transparency or 0,
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    })
    stroke.Parent = instance
    return stroke
end

local function MakeDraggable(gui, dragRegion)
    local isDragging = false
    local dragInput
    local dragStart
    local startPos
    
    dragRegion = dragRegion or gui
    
    local function updateDrag(input)
        local delta = input.Position - dragStart
        local newOffsetX = startPos.X.Offset + delta.X
        local newOffsetY = startPos.Y.Offset + delta.Y

        local screenSize = workspace.CurrentCamera.ViewportSize
        local guiSize = gui.AbsoluteSize
        local scaleX = startPos.X.Scale
        local scaleY = startPos.Y.Scale

        local minOffsetX = guiSize.X * gui.AnchorPoint.X - scaleX * screenSize.X
        local maxOffsetX = screenSize.X - guiSize.X * (1 - gui.AnchorPoint.X) - scaleX * screenSize.X
        local minOffsetY = guiSize.Y * gui.AnchorPoint.Y - scaleY * screenSize.Y
        local maxOffsetY = screenSize.Y - guiSize.Y * (1 - gui.AnchorPoint.Y) - scaleY * screenSize.Y

        local clampedX = math.clamp(newOffsetX, minOffsetX, maxOffsetX)
        local clampedY = math.clamp(newOffsetY, minOffsetY, maxOffsetY)

        local tweenInfo = TweenInfo.new(0.05, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        local tween = TweenService:Create(gui, tweenInfo, {
            Position = UDim2.new(scaleX, clampedX, scaleY, clampedY)
        })
        tween:Play()
    end


    dragRegion.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            isDragging = true
            dragStart = input.Position
            startPos = gui.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    isDragging = false
                end
            end)
        end
    end)
    
    dragRegion.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and isDragging then
            updateDrag(input)
        end
    end)
end

function CelesteUI:new(title, position)
    log("Randomizing strings...")
    if title ~= nil and typeof(title) ~= "string" then
        if typeof(title) == "UDim2" then
            position = title
            title = "CELESTE"
        else
            title = tostring(title)
        end
    end
    
    if position ~= nil and typeof(position) ~= "UDim2" then
        position = UDim2.new(0.5, 0, 0.5, 0)
    end
    
    local screenGui = CreateInstance("ScreenGui", {
        Name = CELESTE_UI_ID,
        ResetOnSpawn = false,
        IgnoreGuiInset = true,
        DisplayOrder = 999999999,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    })
    
    local mainFrame = CreateInstance("Frame", {
        Name = getrandstr(),
        Size = UDim2.new(0, 600, 0, 400),
        Position = position or UDim2.new(0.5, 0, 0.5, 0),
        BackgroundColor3 = UI_CONFIG.MainColor,
        BorderSizePixel = 0,
        AnchorPoint = Vector2.new(0.5, 0.5),
        ClipsDescendants = true
    })
    
    ApplyCorner(mainFrame, UI_CONFIG.WindowCornerRadius)
    ApplyStroke(mainFrame, UI_CONFIG.BorderColor, 1)

    RunService.RenderStepped:Connect(function()
        local absPos = mainFrame.AbsolutePosition
        local absSize = mainFrame.AbsoluteSize
        local screenSize = workspace.CurrentCamera.ViewportSize

        local xOffset = mainFrame.Position.X.Offset
        local yOffset = mainFrame.Position.Y.Offset

        if absPos.X < 0 then
            xOffset = xOffset + math.abs(absPos.X)
        elseif absPos.X + absSize.X > screenSize.X then
            xOffset = xOffset - ((absPos.X + absSize.X) - screenSize.X)
        end

        if absPos.Y < -58 then
            yOffset = yOffset + (58 - absPos.Y)
        elseif absPos.Y + absSize.Y > screenSize.Y then
            yOffset = yOffset - ((absPos.Y + absSize.Y) - screenSize.Y)
        end

        mainFrame.Position = UDim2.new(mainFrame.Position.X.Scale, xOffset, mainFrame.Position.Y.Scale, yOffset)
    end)
    
    local headerFrame = CreateInstance("Frame", {
        Name = getrandstr(),
        Size = UDim2.new(1, 0, 0, 32),
        BackgroundColor3 = UI_CONFIG.SecondaryColor,
        BorderSizePixel = 0
    })

    ApplyCorner(headerFrame, UDim.new(0, 5))
    
    local versionIndicator = CreateInstance("ImageLabel", {
        Name = getrandstr(),
        Size = UDim2.new(0, 16, 0, 16),
        Position = UDim2.new(0, 63, 0.5, -8),
        BackgroundTransparency = 1,
        Image = "rbxassetid://7733717447",
        ImageColor3 = UI_CONFIG.SubTextColor,
        ImageTransparency = 0.4
    })
    
    local titleLabel = CreateInstance("TextLabel", {
        Name = getrandstr(),
        Size = UDim2.new(1, -150, 1, 0),
        Position = UDim2.new(0, 80, 0, 0),
        BackgroundTransparency = 1,
        Text = title or "CELESTE",
        Font = UI_CONFIG.HeaderFont,
        TextSize = UI_CONFIG.TitleSize,
        TextColor3 = UI_CONFIG.AccentColor,
        TextXAlignment = Enum.TextXAlignment.Left
    })
    
    local versionLabel = CreateInstance("TextLabel", {
        Name = getrandstr(),
        Size = UDim2.new(0, 50, 1, 0),
        Position = UDim2.new(0, 10, 0, 0),
        BackgroundTransparency = 1,
        Text = "BETA  v" .. UI_CONFIG.Version,
        Font = UI_CONFIG.Font,
        TextSize = UI_CONFIG.SubTextSize,
        TextColor3 = UI_CONFIG.SubTextColor,
        TextXAlignment = Enum.TextXAlignment.Left
    })
    
    local closeButton = CreateInstance("TextButton", {
        Name = getrandstr(),
        Size = UDim2.new(0, 32, 0, 32),
        Position = UDim2.new(1, -32, 0, 0),
        BackgroundTransparency = 1,
        Text = "×",
        TextSize = 25,
        TextColor3 = UI_CONFIG.TextColor,
        Font = UI_CONFIG.HeaderFont
    })
    
    local minimizeButton = CreateInstance("TextButton", {
        Name = getrandstr(),
        Size = UDim2.new(0, 32, 0, 32),
        Position = UDim2.new(1, -64, 0, 0),
        BackgroundTransparency = 1,
        Text = "—",
        TextSize = UI_CONFIG.TitleSize,
        TextColor3 = UI_CONFIG.TextColor,
        Font = UI_CONFIG.HeaderFont
    })
    
    local tabContainer = CreateInstance("Frame", {
        Name = getrandstr(),
        Size = UDim2.new(1, 0, 0, 30),
        Position = UDim2.new(0, 0, 0, 32),
        BackgroundColor3 = UI_CONFIG.SecondaryColor,
        BorderSizePixel = 0
    })
    
    local tabDivider = CreateInstance("Frame", {
        Name = getrandstr(),
        Size = UDim2.new(1, 0, 0, 1),
        Position = UDim2.new(0, 0, .984, 0),
        BackgroundColor3 = UI_CONFIG.BorderColor,
        BorderSizePixel = 0
    })
    
    local tabLayout = CreateInstance("UIListLayout", {
        FillDirection = Enum.FillDirection.Horizontal,
        HorizontalAlignment = Enum.HorizontalAlignment.Left,
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 0)
    })
    
    local contentFrame = CreateInstance("Frame", {
        Name = getrandstr(),
        Size = UDim2.new(1, 0, 1, -62),
        Position = UDim2.new(0, 0, 0, 62),
        BackgroundColor3 = UI_CONFIG.MainColor,
        BorderSizePixel = 0,
        ClipsDescendants = true
    })

    ApplyCorner(contentFrame, UDim.new(0, 5))
    
    tabDivider.Parent = headerFrame
    tabLayout.Parent = tabContainer
    
    versionLabel.Parent = headerFrame
    versionIndicator.Parent = headerFrame
    titleLabel.Parent = headerFrame
    closeButton.Parent = headerFrame
    minimizeButton.Parent = headerFrame
    
    headerFrame.Parent = mainFrame
    tabContainer.Parent = mainFrame
    contentFrame.Parent = mainFrame
    mainFrame.Parent = screenGui
    screenGui.Parent = gethui()
    
    MakeDraggable(mainFrame, headerFrame)
    
    closeButton.MouseEnter:Connect(function()
        closeButton.TextColor3 = UI_CONFIG.ErrorColor
    end)
    
    closeButton.MouseLeave:Connect(function()
        closeButton.TextColor3 = UI_CONFIG.TextColor
    end)

    local ui = setmetatable({
        GUI = screenGui,
        MainFrame = mainFrame,
        ContentFrame = contentFrame,
        TabContainer = tabContainer,
        Tabs = {},
        Pages = {},
        SectionColumns = {},
        ActiveTab = nil,
        ActivePage = nil
    }, CelesteUI)
    
    closeButton.MouseButton1Click:Connect(function()
        local gui = screenGui

        for _, tab in pairs(ui.Tabs or {}) do
            if tab.Elements then
                for _, section in pairs(tab.Elements) do
                    if section.Elements then
                        for _, element in pairs(section.Elements) do
                            local value = element.GetValue and element.GetValue()
                            if type(value) == "boolean" and element.SetValue then
                                element.SetValue(false)
                            end
                        end
                    end
                end
            end
        end

        task.wait(0.3)

        if CustomTime then
            Lighting.ClockTime = OldTime
            CustomTime = false
        end

        if ui then
            table.clear(ui.Tabs or {})
            table.clear(ui.Pages or {})
            table.clear(ui.SectionColumns or {})

            ui.GUI = nil
            ui.MainFrame = nil
            ui.ContentFrame = nil
            ui.TabContainer = nil
            ui.ActiveTab = nil
            ui.ActivePage = nil
        end

        if gui and typeof(gui) == "Instance" and gui.Parent then
            gui:Destroy()
        end

        task.defer(function()
            gcinfo()
        end)

        log("UI has been destroyed")
    end)

    local isMinimized = false
    
    minimizeButton.MouseEnter:Connect(function()
        minimizeButton.TextColor3 = UI_CONFIG.AccentColor
    end)
    
    minimizeButton.MouseLeave:Connect(function()
        minimizeButton.TextColor3 = UI_CONFIG.TextColor
    end)
    
    minimizeButton.MouseButton1Click:Connect(function()
        isMinimized = not isMinimized
        local originalSize = mainFrame.Size
        local originalPosition = mainFrame.Position
        local topEdge = originalPosition.Y.Offset - (originalSize.Y.Offset * mainFrame.AnchorPoint.Y)
        local tweenInfo = TweenInfo.new(UI_CONFIG.TweenTime, UI_CONFIG.TweenStyle, UI_CONFIG.TweenDirection)

        if isMinimized then
            local targetSizeVertical = UDim2.new(originalSize.X.Scale, originalSize.X.Offset, 0, 32)
            local targetPositionVertical = UDim2.new(
                originalPosition.X.Scale, originalPosition.X.Offset,
                originalPosition.Y.Scale, topEdge + (32 * mainFrame.AnchorPoint.Y)
            )
            local tweenVertical = TweenService:Create(mainFrame, tweenInfo, {
                Size = targetSizeVertical,
                Position = targetPositionVertical
            })
            tweenVertical:Play()

            tweenVertical.Completed:Connect(function()
                local currentCenterX = mainFrame.Position.X.Offset + (mainFrame.Size.X.Offset / 2)
                local targetWidth = 200
                local targetXOffset = currentCenterX - (targetWidth / 2)
                local targetSizeHorizontal = UDim2.new(0, targetWidth, 0, 32)
                local targetPositionHorizontal = UDim2.new(
                    originalPosition.X.Scale, targetXOffset,
                    mainFrame.Position.Y.Scale, mainFrame.Position.Y.Offset
                )
                local tweenHorizontal = TweenService:Create(mainFrame, tweenInfo, {
                    Size = targetSizeHorizontal,
                    Position = targetPositionHorizontal
                })
                tweenHorizontal:Play()
            end)
        else
            local currentCenterX = mainFrame.Position.X.Offset + (mainFrame.Size.X.Offset / 2)
            local targetWidthHorizontal = 600
            local targetXOffset = currentCenterX - (targetWidthHorizontal / 2)
            local minimizedY = mainFrame.Position.Y.Offset
            local targetSizeHorizontal = UDim2.new(0, targetWidthHorizontal, 0, 32)
            local targetPositionHorizontal = UDim2.new(
                originalPosition.X.Scale, targetXOffset,
                mainFrame.Position.Y.Scale, minimizedY
            )
            local tweenHorizontal = TweenService:Create(mainFrame, tweenInfo, {
                Size = targetSizeHorizontal,
                Position = targetPositionHorizontal
            })
            tweenHorizontal:Play()

            tweenHorizontal.Completed:Connect(function()
                local targetSizeVertical = UDim2.new(0, targetWidthHorizontal, 0, 400)
                local targetPositionVertical = UDim2.new(
                    originalPosition.X.Scale, targetPositionHorizontal.X.Offset,
                    originalPosition.Y.Scale, topEdge + (400 * mainFrame.AnchorPoint.Y)
                )
                local tweenVertical = TweenService:Create(mainFrame, tweenInfo, {
                    Size = targetSizeVertical,
                    Position = targetPositionVertical
                })
                tweenVertical:Play()
            end)
        end

        tabContainer.Visible = not isMinimized
        contentFrame.Visible = not isMinimized
    end)

    return ui
end

function CelesteUI:AddTabsElement(section, tabs, callback)
    local tabsContainer = CreateInstance("Frame", {
        Name = getrandstr(),
        Size = UDim2.new(1, -10, 0, 30),
        Position = UDim2.new(0, 5, 0, 0),
        BackgroundColor3 = UI_CONFIG.SecondaryColor,
        BorderSizePixel = 0,
        LayoutOrder = #section.Elements + 1
    })
    
    ApplyCorner(tabsContainer, UI_CONFIG.CornerRadius)
    ApplyStroke(tabsContainer, UI_CONFIG.BorderColor, 1)
    
    local tabButtons = {}
    local selectedTab = 1
    
    local function createTabs()
        for _, button in ipairs(tabButtons) do
            button:Destroy()
        end
        tabButtons = {}
        
        if #tabs == 0 then return end
        
        local tabWidth = 1 / #tabs
        
        for i, tabText in ipairs(tabs) do
            if typeof(tabText) ~= "string" then
                tabText = tostring(tabText)
            end
            
            local tabButton = CreateInstance("TextButton", {
                Name = getrandstr(),
                Size = UDim2.new(tabWidth, 0, 1, 0),
                Position = UDim2.new(tabWidth * (i-1), 0, 0, 0),
                BackgroundTransparency = 1,
                Text = tabText,
                Font = UI_CONFIG.Font,
                TextSize = UI_CONFIG.TextSize,
                TextColor3 = i == selectedTab and UI_CONFIG.AccentColor or UI_CONFIG.SubTextColor,
                BorderSizePixel = 0
            })
            
            local indicator = CreateInstance("Frame", {
                Name = getrandstr(),
                Size = UDim2.new(0.8, 0, 0, 2),
                Position = UDim2.new(0.1, 0, 1, -2),
                BackgroundColor3 = UI_CONFIG.AccentColor,
                BorderSizePixel = 0,
                Visible = i == selectedTab
            })
            
            indicator.Parent = tabButton
            
            tabButton.MouseButton1Click:Connect(function()
                selectedTab = i
                
                for j, btn in ipairs(tabButtons) do
                    btn.TextColor3 = j == i and UI_CONFIG.AccentColor or UI_CONFIG.SubTextColor
                    btn.Indicator.Visible = j == i
                end
                
                if callback then
                    callback(i, tabText)
                end
            end)
            
            tabButton.MouseEnter:Connect(function()
                if i ~= selectedTab then
                    tabButton.TextColor3 = UI_CONFIG.TextColor
                end
            end)
            
            tabButton.MouseLeave:Connect(function()
                if i ~= selectedTab then
                    tabButton.TextColor3 = UI_CONFIG.SubTextColor
                end
            end)
            
            tabButton.Parent = tabsContainer
            table.insert(tabButtons, tabButton)
        end
    end
    
    createTabs()
    
    tabsContainer.Parent = section.ContentHolder
    
    local tabsInterface = {
        Instance = tabsContainer,
        GetSelected = function() 
            return selectedTab, tabs[selectedTab] 
        end,
        SetSelected = function(index)
            if index >= 1 and index <= #tabs then
                selectedTab = index
                
                for j, btn in ipairs(tabButtons) do
                    btn.TextColor3 = j == index and UI_CONFIG.AccentColor or UI_CONFIG.SubTextColor
                    btn.Indicator.Visible = j == index
                end
                
                if callback then
                    callback(index, tabs[index])
                end
            end
        end,
        UpdateTabs = function(newTabs)
            tabs = newTabs
            createTabs()
            
            if selectedTab > #tabs then
                selectedTab = math.min(selectedTab, #tabs)
                if selectedTab < 1 then selectedTab = 1 end
            end
            
            for j, btn in ipairs(tabButtons) do
                btn.TextColor3 = j == selectedTab and UI_CONFIG.AccentColor or UI_CONFIG.SubTextColor
                btn.Indicator.Visible = j == selectedTab
            end
        end
    }
    
    table.insert(section.Elements, tabsInterface)
    return tabsInterface
end

function CelesteUI:AddTab(name, icon)
    local tabButton = CreateInstance("TextButton", {
        Name = getrandstr(),
        Size = UDim2.new(0, 0, 1, 0),
        BackgroundColor3 = UI_CONFIG.SecondaryColor,
        BorderSizePixel = 0,
        Text = "",
        AutoButtonColor = false,
        LayoutOrder = #self.Tabs
    })
    
    local textPadding = CreateInstance("UIPadding", {
        PaddingLeft = UDim.new(0, 10),
        PaddingRight = UDim.new(0, 10)
    })
    
    local tabLabel = CreateInstance("TextLabel", {
        Name = getrandstr(),
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        Text = name,
        Font = UI_CONFIG.Font,
        TextSize = UI_CONFIG.TextSize,
        TextColor3 = UI_CONFIG.SubTextColor,
        TextXAlignment = Enum.TextXAlignment.Center
    })
    
    local page = CreateInstance("Frame", {
        Name = getrandstr(),
        Size = UDim2.new(1, 0, 1, 0),
        Position = UDim2.new(0, 0, 0, 0),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        Visible = false,
        ClipsDescendants = true
    })
    
    local paddingContainer = CreateInstance("Frame", {
        Name = getrandstr(),
        Size = UDim2.new(1, 0, 0, 8),
        Position = UDim2.new(0, 0, 0, 0),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        LayoutOrder = 0
    })
    
    local leftColumn = CreateInstance("ScrollingFrame", {
        Name = getrandstr(),
        Size = UDim2.new(0.5, -15, 1, 0),
        Position = UDim2.new(0, 10, 0, 0),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ScrollBarThickness = 2,
        ScrollBarImageColor3 = UI_CONFIG.BorderColor,
        CanvasSize = UDim2.new(0, 0, 0, 0),
        TopImage = "rbxasset://textures/ui/Scroll/scroll-middle.png",
        BottomImage = "rbxasset://textures/ui/Scroll/scroll-middle.png",
        ScrollBarImageTransparency = 0.7
    })
    
    local rightColumn = CreateInstance("ScrollingFrame", {
        Name = getrandstr(),
        Size = UDim2.new(0.5, -15, 1, 0),
        Position = UDim2.new(0.5, 5, 0, 0),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ScrollBarThickness = 2,
        ScrollBarImageColor3 = UI_CONFIG.BorderColor,
        CanvasSize = UDim2.new(0, 0, 0, 0),
        TopImage = "rbxasset://textures/ui/Scroll/scroll-middle.png",
        BottomImage = "rbxasset://textures/ui/Scroll/scroll-middle.png",
        ScrollBarImageTransparency = 0.7
    })
    
    local leftListLayout = CreateInstance("UIListLayout", {
        Padding = UDim.new(0, UI_CONFIG.Padding),
        SortOrder = Enum.SortOrder.LayoutOrder,
        HorizontalAlignment = Enum.HorizontalAlignment.Center
    })
    
    local rightListLayout = CreateInstance("UIListLayout", {
        Padding = UDim.new(0, UI_CONFIG.Padding),
        SortOrder = Enum.SortOrder.LayoutOrder,
        HorizontalAlignment = Enum.HorizontalAlignment.Center
    })
    
    local leftPadding = CreateInstance("UIPadding", {
        PaddingTop = UDim.new(0, 1),
        PaddingBottom = UDim.new(0, 1),
        PaddingLeft = UDim.new(0, UI_CONFIG.Padding),
        PaddingRight = UDim.new(0, 5)
    })
    
    local rightPadding = CreateInstance("UIPadding", {
        PaddingTop = UDim.new(0, 1),
        PaddingBottom = UDim.new(0, 1),
        PaddingLeft = UDim.new(0, 5),
        PaddingRight = UDim.new(0, UI_CONFIG.Padding)
    })

    local pagePadding = CreateInstance("UIPadding", {
        PaddingTop = UDim.new(0, 15),
        PaddingBottom = UDim.new(0, 15),
    })
    
    textPadding.Parent = tabButton
    tabLabel.Parent = tabButton
    
    leftListLayout.Parent = leftColumn
    rightListLayout.Parent = rightColumn
    leftPadding.Parent = leftColumn
    rightPadding.Parent = rightColumn
    
    leftColumn.Parent = page
    rightColumn.Parent = page
    
    tabButton.Parent = self.TabContainer
    page.Parent = self.ContentFrame
    pagePadding.Parent = page
    
    tabButton.Size = UDim2.new(0, math.max(80, tabLabel.TextBounds.X + 20), 1, 0)
    
    leftListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        leftColumn.CanvasSize = UDim2.new(0, 0, 0, leftListLayout.AbsoluteContentSize.Y + UI_CONFIG.Padding * 2)
    end)
    
    rightListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        rightColumn.CanvasSize = UDim2.new(0, 0, 0, rightListLayout.AbsoluteContentSize.Y + UI_CONFIG.Padding * 2)
    end)
    
    tabButton.MouseEnter:Connect(function()
        if self.ActiveTab ~= tabButton then
            tabLabel.TextColor3 = UI_CONFIG.TextColor
        end
    end)
    
    tabButton.MouseLeave:Connect(function()
        if self.ActiveTab ~= tabButton then
            tabLabel.TextColor3 = UI_CONFIG.SubTextColor
        end
    end)
    
    tabButton.MouseButton1Click:Connect(function()
        self:SelectTab(tabButton)
    end)
    
    local tab = {
        Button = tabButton,
        Label = tabLabel,
        Page = page,
        LeftColumn = leftColumn,
        RightColumn = rightColumn,
        Elements = {}
    }
    
    table.insert(self.Tabs, tab)
    self.Pages[tabButton] = page
    self.SectionColumns[tabButton] = {leftColumn, rightColumn}
    
    if #self.Tabs == 1 then
        self:SelectTab(tabButton, true)
    end
    
    return tab
end

function CelesteUI:SelectTab(tabButton, noAnimation)
    if not self.AnimationOverlay then
        self.AnimationOverlay = CreateInstance("Frame", {
            Name = getrandstr(),
            Size = UDim2.new(1, 0, 1, 0),
            Position = UDim2.new(0, 0, 0, 0),
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            ZIndex = 100
        })
        self.AnimationOverlay.Parent = self.MainFrame
    end

    if not self.TabIndicator then
        self.TabIndicator = CreateInstance("Frame", {
            Name = getrandstr(),
            Size = UDim2.new(0, 0, 0, 2),
            Position = UDim2.new(0, 0, 0, self.TabContainer.AbsolutePosition.Y + self.TabContainer.AbsoluteSize.Y - 2 - self.MainFrame.AbsolutePosition.Y),
            BackgroundColor3 = UI_CONFIG.AccentColor,
            BorderSizePixel = 0,
            ZIndex = 101
        })
        self.TabIndicator.Parent = self.AnimationOverlay
    end

    local newTab = nil
    local currentTab = nil
    
    for _, tab in ipairs(self.Tabs) do
        if tab.Button == self.ActiveTab then
            currentTab = tab
        end
        if tab.Button == tabButton then
            newTab = tab
        end
    end
    
    if self.ActiveTab == tabButton then return end
    
    self.ActiveTab = tabButton
    self.ActivePage = self.Pages[tabButton]
    
    if currentTab then
        currentTab.Label.TextColor3 = UI_CONFIG.SubTextColor
    end
    
    if newTab then
        newTab.Label.TextColor3 = UI_CONFIG.AccentColor
        
        local slideDirection = 1
        
        if currentTab then
            local currentIndex, newIndex = 0, 0
            for i, tab in ipairs(self.Tabs) do
                if tab == currentTab then currentIndex = i end
                if tab == newTab then newIndex = i end
            end
            
            slideDirection = (newIndex > currentIndex) and 1 or -1
        end
        
        local tabX = newTab.Button.AbsolutePosition.X - self.MainFrame.AbsolutePosition.X
        local tabWidth = newTab.Button.AbsoluteSize.X
        
        local indicatorTweenInfo = TweenInfo.new(
            0.15,
            Enum.EasingStyle.Quad,
            Enum.EasingDirection.Out
        )
        
        local indicatorTween = TweenService:Create(
            self.TabIndicator,
            indicatorTweenInfo,
            {
                Position = UDim2.new(0, tabX, self.TabIndicator.Position.Y.Scale, self.TabIndicator.Position.Y.Offset),
                Size = UDim2.new(0, tabWidth, 0, 2)
            }
        )
        
        if currentTab and not noAnimation then
            newTab.Page.Visible = true
            newTab.Page.Position = UDim2.new(slideDirection, 0, 0, 0)
            
            local slideOutTweenInfo = TweenInfo.new(
                0.15,
                Enum.EasingStyle.Quad,
                Enum.EasingDirection.Out
            )
            
            local slideOutTween = TweenService:Create(
                currentTab.Page,
                slideOutTweenInfo,
                {
                    Position = UDim2.new(-slideDirection, 0, 0, 0)
                }
            )
            
            local slideInTweenInfo = TweenInfo.new(
                0.15,
                Enum.EasingStyle.Quad,
                Enum.EasingDirection.Out
            )
            
            local slideInTween = TweenService:Create(
                newTab.Page,
                slideInTweenInfo,
                {
                    Position = UDim2.new(0, 0, 0, 0)
                }
            )
            
            indicatorTween:Play()
            slideOutTween:Play()
            slideInTween:Play()
            
            slideOutTween.Completed:Connect(function()
                currentTab.Page.Visible = false
                currentTab.Page.Position = UDim2.new(0, 0, 0, 0)
            end)
        else
            if currentTab then
                currentTab.Page.Visible = false
            end
            
            newTab.Page.Position = UDim2.new(0, 0, 0, 0)
            newTab.Page.Visible = true
            
            indicatorTween:Play()
        end
    end
end

function CelesteUI:AddSection(tab, name, position)
    position = position or "left"
    
    local targetColumn = position == "left" and tab.LeftColumn or tab.RightColumn
    
    local sectionFrame = CreateInstance("Frame", {
        Name = getrandstr(),
        Size = UDim2.new(1, 0, 0, 30),
        BackgroundColor3 = UI_CONFIG.SecondaryColor,
        BorderSizePixel = 0,
        LayoutOrder = #tab.Elements + 1
    })
    
    ApplyCorner(sectionFrame, UI_CONFIG.CornerRadius)
    ApplyStroke(sectionFrame, UI_CONFIG.BorderColor, 1)
    
    local sectionLabel = CreateInstance("TextLabel", {
        Name = getrandstr(),
        Size = UDim2.new(1, 0, 0, 30),
        BackgroundTransparency = 1,
        Text = name,
        TextColor3 = UI_CONFIG.TextColor,
        TextSize = UI_CONFIG.TextSize,
        Font = UI_CONFIG.HeaderFont,
        TextXAlignment = Enum.TextXAlignment.Center
    })
    
    local contentHolder = CreateInstance("Frame", {
        Name = getrandstr(),
        Size = UDim2.new(1, 0, 0, 0),
        Position = UDim2.new(0, 0, 0, 30),
        BackgroundTransparency = 1,
        BorderSizePixel = 0
    })
    
    local listLayout = CreateInstance("UIListLayout", {
        Padding = UDim.new(0, UI_CONFIG.Padding),
        SortOrder = Enum.SortOrder.LayoutOrder,
        HorizontalAlignment = Enum.HorizontalAlignment.Center
    })
    
    local padding = CreateInstance("UIPadding", {
        PaddingTop = UDim.new(0, UI_CONFIG.Padding/2),
        PaddingBottom = UDim.new(0, UI_CONFIG.Padding/2),
        PaddingLeft = UDim.new(0, UI_CONFIG.Padding/2),
        PaddingRight = UDim.new(0, UI_CONFIG.Padding/2)
    })
    
    listLayout.Parent = contentHolder
    padding.Parent = contentHolder
    
    sectionLabel.Parent = sectionFrame
    contentHolder.Parent = sectionFrame
    sectionFrame.Parent = targetColumn
    
    listLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        contentHolder.Size = UDim2.new(1, 0, 0, listLayout.AbsoluteContentSize.Y + UI_CONFIG.Padding)
        sectionFrame.Size = UDim2.new(1, 0, 0, contentHolder.Size.Y.Offset + 30)
    end)
    
    local section = {
        Frame = sectionFrame,
        ContentHolder = contentHolder,
        Elements = {}
    }
    
    table.insert(tab.Elements, section)
    return section
end

function CelesteUI:AddToggle(section, name, defaultValue, callback)
    local isToggled = defaultValue or false
    local isOnCooldown = false
    
    local toggleContainer = CreateInstance("Frame", {
        Name = "Toggle_" .. name,
        Size = UDim2.new(1, 0, 0, 30),
        BackgroundTransparency = 1,
        LayoutOrder = #section.Elements + 1
    })
    
    local toggleLabel = CreateInstance("TextLabel", {
        Name = getrandstr(),
        Size = UDim2.new(0.5, 0, 1, 0),
        Position = UDim2.new(0, 5, 0, 0),
        BackgroundTransparency = 1,
        Text = name,
        Font = UI_CONFIG.Font,
        TextSize = UI_CONFIG.TextSize,
        TextColor3 = UI_CONFIG.TextColor,
        TextXAlignment = Enum.TextXAlignment.Left
    })
    
    local toggleBackground = CreateInstance("Frame", {
        Name = getrandstr(),
        Size = UI_CONFIG.ToggleSize,
        Position = UDim2.new(1, -UI_CONFIG.ToggleSize.X.Offset - 5, 0.5, -UI_CONFIG.ToggleSize.Y.Offset/2),
        BackgroundColor3 = isToggled and UI_CONFIG.ToggleOnColor or UI_CONFIG.ToggleOffColor,
        BorderSizePixel = 0
    })
    
    ApplyCorner(toggleBackground, UDim.new(0, 10))
    ApplyStroke(toggleBackground, UI_CONFIG.BorderColor, 1)
    
    local toggleKnob = CreateInstance("Frame", {
        Name = getrandstr(),
        Size = UDim2.new(0, UI_CONFIG.ToggleSize.Y.Offset - 6, 0, UI_CONFIG.ToggleSize.Y.Offset - 6),
        Position = isToggled 
            and UDim2.new(1, -(UI_CONFIG.ToggleSize.Y.Offset - 3), 0.5, -((UI_CONFIG.ToggleSize.Y.Offset - 6)/2))
            or UDim2.new(0, 3, 0.5, -((UI_CONFIG.ToggleSize.Y.Offset - 6)/2)),
        BackgroundColor3 = UI_CONFIG.TextColor,
        BorderSizePixel = 0
    })
    
    ApplyCorner(toggleKnob, UDim.new(0, 10))
    
    toggleKnob.Parent = toggleBackground
    toggleLabel.Parent = toggleContainer
    toggleBackground.Parent = toggleContainer
    
    toggleContainer.Parent = section.ContentHolder
    
    local function updateToggleVisual()
        local targetColor = isToggled and UI_CONFIG.ToggleOnColor or UI_CONFIG.ToggleOffColor
        local targetPosition = isToggled 
            and UDim2.new(1, -(UI_CONFIG.ToggleSize.Y.Offset - 3), 0.5, -((UI_CONFIG.ToggleSize.Y.Offset - 6)/2))
            or UDim2.new(0, 3, 0.5, -((UI_CONFIG.ToggleSize.Y.Offset - 6)/2))
        
        local colorTween = TweenService:Create(
            toggleBackground,
            TweenInfo.new(UI_CONFIG.TweenTime, UI_CONFIG.TweenStyle, UI_CONFIG.TweenDirection),
            {BackgroundColor3 = targetColor}
        )
        
        local positionTween = TweenService:Create(
            toggleKnob,
            TweenInfo.new(UI_CONFIG.TweenTime, UI_CONFIG.TweenStyle, UI_CONFIG.TweenDirection),
            {Position = targetPosition}
        )
        
        colorTween:Play()
        positionTween:Play()
    end
    
    toggleContainer.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            if isOnCooldown then
                return
            end
            
            isOnCooldown = true
            
            isToggled = not isToggled
            updateToggleVisual()
            
            if callback then
                callback(isToggled)
            end
            
            task.delay(.5, function()
                isOnCooldown = false
            end)
        end
    end)
    
    local toggleInterface = {
        Instance = toggleContainer,
        GetValue = function() return isToggled end,
        SetValue = function(value)
            local prevState = isToggled
            isToggled = value
            
            updateToggleVisual()

            if callback and (prevState ~= value) then
                callback(isToggled)
            end
            
            isOnCooldown = true
            task.delay(0.3, function()
                isOnCooldown = false
            end)
        end
    }
    
    table.insert(section.Elements, toggleInterface)

    if isToggled and callback then
        callback(true)
    end

    return toggleInterface
end

function CelesteUI:AddButton(section, name, callback)
    local buttonContainer = CreateInstance("Frame", {
        Name = "Button_" .. name,
        Size = UDim2.new(1, 0, 0, 30),
        BackgroundTransparency = 1,
        LayoutOrder = #section.Elements + 1
    })
    
    local button = CreateInstance("TextButton", {
        Name = getrandstr(),
        Size = UDim2.new(0.9, 0, 0, 26),
        Position = UDim2.new(0.05, 0, 0.5, -13),
        BackgroundColor3 = UI_CONFIG.SecondaryColor,
        BorderSizePixel = 0,
        Text = name,
        Font = UI_CONFIG.Font,
        TextSize = UI_CONFIG.TextSize,
        TextColor3 = UI_CONFIG.TextColor,
        AutoButtonColor = false
    })
    
    ApplyCorner(button, UI_CONFIG.ButtonCornerRadius)
    ApplyStroke(button, UI_CONFIG.BorderColor, 1)
    
    local normalColor = UI_CONFIG.SecondaryColor
    local hoverColor = UI_CONFIG.HoverColor
    local pressColor = UI_CONFIG.AccentColor
    
    local isPressed = false
    
    button.MouseEnter:Connect(function()
        if not isPressed then
            TweenService:Create(
                button,
                TweenInfo.new(UI_CONFIG.TweenTime, UI_CONFIG.TweenStyle, UI_CONFIG.TweenDirection),
                {BackgroundColor3 = hoverColor}
            ):Play()
        end
    end)
    
    button.MouseLeave:Connect(function()
        if not isPressed then
            TweenService:Create(
                button,
                TweenInfo.new(UI_CONFIG.TweenTime, UI_CONFIG.TweenStyle, UI_CONFIG.TweenDirection),
                {BackgroundColor3 = normalColor}
            ):Play()
        else
            isPressed = false
            TweenService:Create(
                button,
                TweenInfo.new(UI_CONFIG.TweenTime, UI_CONFIG.TweenStyle, UI_CONFIG.TweenDirection),
                {BackgroundColor3 = normalColor}
            ):Play()
        end
    end)
    
    button.MouseButton1Down:Connect(function()
        isPressed = true
        TweenService:Create(
            button,
            TweenInfo.new(UI_CONFIG.TweenTime, UI_CONFIG.TweenStyle, UI_CONFIG.TweenDirection),
            {BackgroundColor3 = pressColor}
        ):Play()
    end)
    
    button.MouseButton1Up:Connect(function()
        isPressed = false
        TweenService:Create(
            button,
            TweenInfo.new(UI_CONFIG.TweenTime, UI_CONFIG.TweenStyle, UI_CONFIG.TweenDirection),
            {BackgroundColor3 = hoverColor}
        ):Play()
        
        if callback then
            callback()
        end
    end)
    
    button.Parent = buttonContainer
    buttonContainer.Parent = section.ContentHolder
    
    local buttonInterface = {
        Instance = buttonContainer,
        SetText = function(text)
            button.Text = text
        end
    }
    
    table.insert(section.Elements, buttonInterface)
    return buttonInterface
end

function CelesteUI:AddDropdown(section, name, options, default, callback)
    options = options or {}
    default = default or options[1] or ""
    
    local dropdownContainer = CreateInstance("Frame", {
        Name = "Dropdown_" .. name,
        Size = UDim2.new(1, 0, 0, 50),
        BackgroundTransparency = 1,
        LayoutOrder = #section.Elements + 1
    })
    
    local dropdownLabel = CreateInstance("TextLabel", {
        Name = getrandstr(),
        Size = UDim2.new(1, -10, 0, 20),
        Position = UDim2.new(0, 5, 0, 0),
        BackgroundTransparency = 1,
        Text = name,
        Font = UI_CONFIG.Font,
        TextSize = UI_CONFIG.TextSize,
        TextColor3 = UI_CONFIG.TextColor,
        TextXAlignment = Enum.TextXAlignment.Left
    })
    
    local dropdownFrame = CreateInstance("TextButton", {
        Name = getrandstr(),
        Size = UDim2.new(1, -10, 0, 26),
        Position = UDim2.new(0, 5, 0, 22),
        BackgroundColor3 = UI_CONFIG.SecondaryColor,
        BorderSizePixel = 0,
        Text = "",
        AutoButtonColor = false,
        ZIndex = 5
    })
    
    ApplyCorner(dropdownFrame, UI_CONFIG.ButtonCornerRadius)
    ApplyStroke(dropdownFrame, UI_CONFIG.BorderColor, 1)
    
    local selectedOption = CreateInstance("TextLabel", {
        Name = getrandstr(),
        Size = UDim2.new(1, -30, 1, 0),
        Position = UDim2.new(0, 10, 0, 0),
        BackgroundTransparency = 1,
        Text = default,
        Font = UI_CONFIG.Font,
        TextSize = UI_CONFIG.TextSize,
        TextColor3 = UI_CONFIG.TextColor,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextTruncate = Enum.TextTruncate.AtEnd,
        ZIndex = 6
    })
    
    local toggleArrow = CreateInstance("TextLabel", {
        Name = getrandstr(),
        Size = UDim2.new(0, 20, 0, 26),
        Position = UDim2.new(1, -25, 0, 0),
        BackgroundTransparency = 1,
        Text = "▼",
        Font = UI_CONFIG.Font,
        TextSize = UI_CONFIG.TextSize,
        TextColor3 = UI_CONFIG.SubTextColor,
        ZIndex = 6
    })
    
    selectedOption.Parent = dropdownFrame
    toggleArrow.Parent = dropdownFrame
    
    dropdownLabel.Parent = dropdownContainer
    dropdownFrame.Parent = dropdownContainer
    
    dropdownContainer.Parent = section.ContentHolder
    
    local screenGui = gethui():FindFirstChild(CELESTE_UI_ID)
    
    local optionsContainer = CreateInstance("Frame", {
        Name = getrandstr(),
        BackgroundColor3 = UI_CONFIG.SecondaryColor,
        BorderSizePixel = 0,
        Visible = false,
        ZIndex = 1000,
        ClipsDescendants = true,
        Parent = screenGui
    })
    
    ApplyCorner(optionsContainer, UI_CONFIG.ButtonCornerRadius)
    ApplyStroke(optionsContainer, UI_CONFIG.BorderColor, 1)
    
    local isExpanded = false
    local optionHeight = 26
    local maxVisibleOptions = 6
    local outsideClickActive = false
    local isAnimating = false
    
    local function createOptions()
        for _, child in pairs(optionsContainer:GetChildren()) do
            if child:IsA("TextButton") then
                child:Destroy()
            end
        end
        
        local totalHeight = #options * optionHeight
        local visibleHeight = math.min(totalHeight, maxVisibleOptions * optionHeight)
        
        optionsContainer.Position = UDim2.new(
            0, dropdownFrame.AbsolutePosition.X,
            0, dropdownFrame.AbsolutePosition.Y + dropdownFrame.AbsoluteSize.Y + 2
        )
        
        optionsContainer.Size = UDim2.new(0, dropdownFrame.AbsoluteSize.X, 0, 0)
        
        for i, option in ipairs(options) do
            local optionButton = CreateInstance("TextButton", {
                Name = "Option_" .. i,
                Size = UDim2.new(1, 0, 0, optionHeight),
                Position = UDim2.new(0, 0, 0, (i-1) * optionHeight),
                BackgroundColor3 = UI_CONFIG.SecondaryColor,
                Text = option,
                TextColor3 = UI_CONFIG.TextColor,
                Font = UI_CONFIG.Font,
                TextSize = UI_CONFIG.TextSize,
                TextXAlignment = Enum.TextXAlignment.Left,
                BorderSizePixel = 0,
                ZIndex = 1001,
                AutoButtonColor = false,
                BackgroundTransparency = 1,
                TextTransparency = 1,
                Parent = optionsContainer
            })
            
            local textPadding = CreateInstance("UIPadding", {
                PaddingLeft = UDim.new(0, 10),
                Parent = optionButton
            })
            
            optionButton.MouseEnter:Connect(function()
                optionButton.BackgroundColor3 = UI_CONFIG.HoverColor
            end)
            
            optionButton.MouseLeave:Connect(function()
                optionButton.BackgroundColor3 = UI_CONFIG.SecondaryColor
            end)
            
            optionButton.MouseButton1Click:Connect(function()
                selectedOption.Text = option
                
                task.defer(function()
                    closeDropdown()
                    
                    if callback then
                        callback(option)
                    end
                end)
            end)
            
            task.delay(0.02 * i, function()
                TweenService:Create(
                    optionButton,
                    TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                    {BackgroundTransparency = 0, TextTransparency = 0}
                ):Play()
            end)
        end
        
        isAnimating = true
        local sizeTween = TweenService:Create(
            optionsContainer,
            TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            {Size = UDim2.new(0, dropdownFrame.AbsoluteSize.X, 0, visibleHeight)}
        )
        
        sizeTween:Play()
        
        sizeTween.Completed:Connect(function()
            isAnimating = false
        end)
    end
    
    local function closeDropdown()
        isExpanded = false
        outsideClickActive = false
        toggleArrow.Text = "▼"
        
        for i, child in pairs(optionsContainer:GetChildren()) do
            if child:IsA("TextButton") then
                TweenService:Create(
                    child,
                    TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                    {BackgroundTransparency = 1, TextTransparency = 1}
                ):Play()
            end
        end
        
        isAnimating = true
        local sizeTween = TweenService:Create(
            optionsContainer,
            TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            {Size = UDim2.new(0, optionsContainer.AbsoluteSize.X, 0, 0)}
        )
        
        sizeTween:Play()
        
        sizeTween.Completed:Connect(function()
            optionsContainer.Visible = false
            isAnimating = false
        end)
        
        TweenService:Create(
            toggleArrow,
            TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
            {Rotation = 0}
        ):Play()
    end
    
    local function toggleDropdown()
        if isAnimating then return end
        
        if not isExpanded then
            optionsContainer.Visible = true
            isExpanded = true
            toggleArrow.Text = "▲"
            
            createOptions()
            
            TweenService:Create(
                toggleArrow,
                TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
                {Rotation = 180}
            ):Play()
            
            task.delay(0.1, function()
                outsideClickActive = true
            end)
        else
            closeDropdown()
        end
    end
    
    dropdownFrame.MouseButton1Click:Connect(toggleDropdown)
    
    UserInputService.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 and isExpanded and outsideClickActive and not isAnimating then
            local mousePos = UserInputService:GetMouseLocation()
            
            local inDropdownButton = 
                mousePos.X >= dropdownFrame.AbsolutePosition.X and 
                mousePos.X <= dropdownFrame.AbsolutePosition.X + dropdownFrame.AbsoluteSize.X and
                mousePos.Y >= dropdownFrame.AbsolutePosition.Y and 
                mousePos.Y <= dropdownFrame.AbsolutePosition.Y + dropdownFrame.AbsoluteSize.Y
            
            local inOptionsContainer = false
            if optionsContainer.Visible then
                inOptionsContainer = 
                    mousePos.X >= optionsContainer.AbsolutePosition.X and 
                    mousePos.X <= optionsContainer.AbsolutePosition.X + optionsContainer.AbsoluteSize.X and
                    mousePos.Y >= optionsContainer.AbsolutePosition.Y and 
                    mousePos.Y <= optionsContainer.AbsolutePosition.Y + optionsContainer.AbsoluteSize.Y
            end
            
            if not (inDropdownButton or inOptionsContainer) then
                task.delay(0.1, function()
                    closeDropdown()
                end)
            end
        end
    end)
    
    local dropdownInterface = {
        Instance = dropdownContainer,
        GetSelected = function() return selectedOption.Text end,
        SetSelected = function(option)
            if table.find(options, option) then
                selectedOption.Text = option
                
                if callback then
                    callback(option)
                end
            end
        end,
        UpdateOptions = function(newOptions, newDefault)
            options = newOptions or {}
            
            if newDefault then
                selectedOption.Text = newDefault
            elseif #options > 0 and not table.find(options, selectedOption.Text) then
                selectedOption.Text = options[1]
            end
            
            if isExpanded then
                for _, child in pairs(optionsContainer:GetChildren()) do
                    if child:IsA("TextButton") then
                        child:Destroy()
                    end
                end
                
                local totalHeight = #options * optionHeight
                local visibleHeight = math.min(totalHeight, maxVisibleOptions * optionHeight)
                
                optionsContainer.Size = UDim2.new(0, dropdownFrame.AbsoluteSize.X, 0, visibleHeight)
                
                for i, option in ipairs(options) do
                    local optionButton = CreateInstance("TextButton", {
                        Name = "Option_" .. i,
                        Size = UDim2.new(1, 0, 0, optionHeight),
                        Position = UDim2.new(0, 0, 0, (i-1) * optionHeight),
                        BackgroundColor3 = UI_CONFIG.SecondaryColor,
                        Text = option,
                        TextColor3 = UI_CONFIG.TextColor,
                        Font = UI_CONFIG.Font,
                        TextSize = UI_CONFIG.TextSize,
                        TextXAlignment = Enum.TextXAlignment.Left,
                        BorderSizePixel = 0,
                        ZIndex = 1001,
                        AutoButtonColor = false,
                        Parent = optionsContainer
                    })
                    
                    local textPadding = CreateInstance("UIPadding", {
                        PaddingLeft = UDim.new(0, 10),
                        Parent = optionButton
                    })
                    
                    optionButton.MouseEnter:Connect(function()
                        optionButton.BackgroundColor3 = UI_CONFIG.HoverColor
                    end)
                    
                    optionButton.MouseLeave:Connect(function()
                        optionButton.BackgroundColor3 = UI_CONFIG.SecondaryColor
                    end)
                    
                    optionButton.MouseButton1Click:Connect(function()
                        selectedOption.Text = option
                        
                        task.defer(function()
                            closeDropdown()
                            
                            if callback then
                                callback(option)
                            end
                        end)
                    end)
                end
            end
            
            if callback and newDefault then
                callback(newDefault)
            elseif callback and #options > 0 and not table.find(newOptions, selectedOption.Text) then
                callback(options[1])
            end
        end
    }
    
    table.insert(section.Elements, dropdownInterface)
    return dropdownInterface
end

function CelesteUI:AddSlider(section, name, min, max, defaultValue, callback)
    min = min or 0
    max = max or 100
    defaultValue = defaultValue or min
    
    local value = math.clamp(defaultValue, min, max)
    
    local sliderContainer = CreateInstance("Frame", {
        Name = "Slider_" .. name,
        Size = UDim2.new(1, 0, 0, 40),
        BackgroundTransparency = 1,
        LayoutOrder = #section.Elements + 1,
        ClipsDescendants = true
    })
    
    local sliderLabel = CreateInstance("TextLabel", {
        Name = getrandstr(),
        Size = UDim2.new(1, 0, 0, 20),
        Position = UDim2.new(0, 5, 0, 0),
        BackgroundTransparency = 1,
        Text = name,
        Font = UI_CONFIG.Font,
        TextSize = UI_CONFIG.TextSize,
        TextColor3 = UI_CONFIG.TextColor,
        TextXAlignment = Enum.TextXAlignment.Left
    })
    
    local valueLabel = CreateInstance("TextLabel", {
        Name = getrandstr(),
        Size = UDim2.new(0, 50, 0, 20),
        Position = UDim2.new(1, -55, 0, 0),
        BackgroundTransparency = 1,
        Text = tostring(value),
        Font = UI_CONFIG.Font,
        TextSize = UI_CONFIG.TextSize,
        TextColor3 = UI_CONFIG.AccentColor,
        TextXAlignment = Enum.TextXAlignment.Right
    })
    
    local sliderWrapper = CreateInstance("Frame", {
        Name = getrandstr(),
        Size = UDim2.new(0.9, 0, 0, 20),
        Position = UDim2.new(0.05, 0, 0, 20),
        BackgroundTransparency = 1,
        ClipsDescendants = false
    })
    
    local sliderBack = CreateInstance("Frame", {
        Name = getrandstr(),
        Size = UDim2.new(1, 0, 0, UI_CONFIG.SliderHeight),
        Position = UDim2.new(0, 0, 0.5, -UI_CONFIG.SliderHeight/2),
        BackgroundColor3 = UI_CONFIG.ToggleOffColor,
        BorderSizePixel = 0
    })

    local sliderHitbox = CreateInstance("TextButton", {
        Name = getrandstr(),
        Size = UDim2.new(1, 0, 1, 0),
        Position = UDim2.new(0, 0, 0, 0),
        BackgroundTransparency = 1,
        Text = "",
        AutoButtonColor = false,
        ZIndex = 2
    })
    
    local sliderFill = CreateInstance("Frame", {
        Name = getrandstr(),
        Size = UDim2.new((value - min) / (max - min), 0, 1, 0),
        BackgroundColor3 = UI_CONFIG.AccentColor,
        BorderSizePixel = 0
    })
    
    local sliderKnob = CreateInstance("Frame", {
        Name = getrandstr(),
        Size = UDim2.new(0, 10, 0, 16),
        Position = UDim2.new((value - min) / (max - min), -5, 0.5, -8),
        BackgroundColor3 = UI_CONFIG.TextColor,
        BorderSizePixel = 0,
    })
    
    ApplyCorner(sliderBack, UDim.new(0, 3))
    ApplyCorner(sliderFill, UDim.new(0, 3))
    ApplyCorner(sliderKnob, UDim.new(0, 3))
    ApplyStroke(sliderKnob, UI_CONFIG.BorderColor, 1)
    
    sliderFill.Parent = sliderBack
    sliderKnob.Parent = sliderBack
    sliderHitbox.Parent = sliderBack
    
    sliderBack.Parent = sliderWrapper
    sliderWrapper.Parent = sliderContainer
    
    sliderLabel.Parent = sliderContainer
    valueLabel.Parent = sliderContainer
    
    sliderContainer.Parent = section.ContentHolder
    
    local isDragging = false
    local inputChangedConnection = nil
    
    local function updateSlider(input)
        local relativeX = math.clamp(input.Position.X - sliderBack.AbsolutePosition.X, 0, sliderBack.AbsoluteSize.X)
        local percentage = relativeX / sliderBack.AbsoluteSize.X

        local targetValue = min + ((max - min) * percentage)
        targetValue = math.floor(targetValue * 10) / 10
        local targetPercentage = (targetValue - min) / (max - min)

        local tweenKnob = TweenService:Create(
            sliderKnob,
            TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            {Position = UDim2.new(targetPercentage, -5, 0.5, -8)}
        )

        local tweenFill = TweenService:Create(
            sliderFill,
            TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            {Size = UDim2.new(targetPercentage, 0, 1, 0)}
        )

        tweenKnob:Play()
        tweenFill:Play()

        local startValue = value
        local duration = 0.1
        local startTime = tick()

        local renderConn
        renderConn = RunService.RenderStepped:Connect(function()
            local now = tick()
            local alpha = math.clamp((now - startTime) / duration, 0, 1)
            local lerpedValue = startValue + (targetValue - startValue) * alpha
            lerpedValue = math.floor(lerpedValue * 10) / 10
            valueLabel.Text = tostring(lerpedValue)

            if alpha >= 1 then
                value = targetValue
                if callback then
                    callback(value)
                end
                renderConn:Disconnect()
            end
        end)
    end
    
    local function beginDrag(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            isDragging = true
            updateSlider(input)
            
            if inputChangedConnection then
                inputChangedConnection:Disconnect()
            end
            
            inputChangedConnection = UserInputService.InputChanged:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseMovement and isDragging then
                    updateSlider(input)
                end
            end)
        end
    end
    
    local function endDrag(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            isDragging = false
            
            if inputChangedConnection then
                inputChangedConnection:Disconnect()
                inputChangedConnection = nil
            end
        end
    end
    
    sliderBack.InputBegan:Connect(beginDrag)
    sliderBack.InputEnded:Connect(endDrag)
    sliderHitbox.InputBegan:Connect(beginDrag)
    sliderHitbox.InputEnded:Connect(endDrag)
    
    UserInputService.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement and isDragging then
            updateSlider(input)
        end
    end)
    
    local sliderInterface = {
        Instance = sliderContainer,
        GetValue = function() return value end,
        SetValue = function(newValue)
            value = math.clamp(newValue, min, max)
            local percentage = (value - min) / (max - min)
            
            valueLabel.Text = tostring(value)
            sliderFill.Size = UDim2.new(percentage, 0, 1, 0)
            sliderKnob.Position = UDim2.new(percentage, -5, 0.5, -8)
            
            if callback then
                callback(value)
            end
        end
    }
    
    table.insert(section.Elements, sliderInterface)
    return sliderInterface
end

function CelesteUI:AddTextbox(section, name, defaultText, placeholderText, callback)
    local textboxContainer = CreateInstance("Frame", {
        Name = "Textbox_" .. name,
        Size = UDim2.new(1, 0, 0, 50),
        BackgroundTransparency = 1,
        LayoutOrder = #section.Elements + 1
    })
    
    local textboxLabel = CreateInstance("TextLabel", {
        Name = getrandstr(),
        Size = UDim2.new(1, -10, 0, 20),
        Position = UDim2.new(0, 5, 0, 0),
        BackgroundTransparency = 1,
        Text = name,
        Font = UI_CONFIG.Font,
        TextSize = UI_CONFIG.TextSize,
        TextColor3 = UI_CONFIG.TextColor,
        TextXAlignment = Enum.TextXAlignment.Left
    })
    
    local textboxFrame = CreateInstance("Frame", {
        Name = getrandstr(),
        Size = UDim2.new(1, -10, 0, 26),
        Position = UDim2.new(0, 5, 0, 22),
        BackgroundColor3 = UI_CONFIG.SecondaryColor,
        BorderSizePixel = 0
    })
    
    local textbox = CreateInstance("TextBox", {
        Name = getrandstr(),
        Size = UDim2.new(1, -10, 1, 0),
        Position = UDim2.new(0, 5, 0, 0),
        BackgroundTransparency = 1,
        Text = defaultText or "",
        PlaceholderText = placeholderText or "Enter text...",
        Font = UI_CONFIG.Font,
        TextSize = UI_CONFIG.TextSize,
        TextColor3 = UI_CONFIG.TextColor,
        PlaceholderColor3 = UI_CONFIG.SubTextColor,
        ClearTextOnFocus = false,
        TextXAlignment = Enum.TextXAlignment.Left
    })
    
    ApplyCorner(textboxFrame, UI_CONFIG.ButtonCornerRadius)
    ApplyStroke(textboxFrame, UI_CONFIG.BorderColor, 1)
    
    local normalColor = UI_CONFIG.SecondaryColor
    local focusedColor = UI_CONFIG.HoverColor
    
    textbox.Focused:Connect(function()
        TweenService:Create(
            textboxFrame,
            TweenInfo.new(UI_CONFIG.TweenTime, UI_CONFIG.TweenStyle, UI_CONFIG.TweenDirection),
            {BackgroundColor3 = focusedColor}
        ):Play()
    end)
    
    textbox.FocusLost:Connect(function(enterPressed)
        TweenService:Create(
            textboxFrame,
            TweenInfo.new(UI_CONFIG.TweenTime, UI_CONFIG.TweenStyle, UI_CONFIG.TweenDirection),
            {BackgroundColor3 = normalColor}
        ):Play()
        
        if callback then
            callback(textbox.Text, enterPressed)
        end
    end)
    
    textbox.Parent = textboxFrame
    textboxFrame.Parent = textboxContainer
    textboxLabel.Parent = textboxContainer
    
    textboxContainer.Parent = section.ContentHolder
    
    local textboxInterface = {
        Instance = textboxContainer,
        GetText = function() return textbox.Text end,
        SetText = function(text)
            textbox.Text = text
            if callback then
                callback(text, false)
            end
        end
    }
    
    table.insert(section.Elements, textboxInterface)
    return textboxInterface
end

function CelesteUI:AddLabel(section, text, color)
    local labelContainer = CreateInstance("Frame", {
        Name = getrandstr(),
        Size = UDim2.new(1, -10, 0, 30),
        Position = UDim2.new(0, 5, 0, 0),
        BackgroundTransparency = 1,
        LayoutOrder = #section.Elements + 1
    })
    
    local label = CreateInstance("TextLabel", {
        Name = getrandstr(),
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        Text = text,
        Font = UI_CONFIG.Font,
        TextSize = UI_CONFIG.TextSize,
        TextColor3 = color or UI_CONFIG.TextColor,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextYAlignment = Enum.TextYAlignment.Center
    })
    
    label.Parent = labelContainer
    labelContainer.Parent = section.ContentHolder
    
    local labelInterface = {
        Instance = labelContainer,
        SetText = function(newText)
            label.Text = newText
        end,
        SetColor = function(newColor)
            label.TextColor3 = newColor
        end
    }
    
    table.insert(section.Elements, labelInterface)
    return labelInterface
end

function CelesteUI:AddDropdown(section, name, options, default, callback)
    options = options or {}
    default = default or options[1] or ""
    
    local dropdownContainer = CreateInstance("Frame", {
        Name = "Dropdown_" .. name,
        Size = UDim2.new(1, 0, 0, 50),
        BackgroundTransparency = 1,
        LayoutOrder = #section.Elements + 1
    })
    
    local dropdownLabel = CreateInstance("TextLabel", {
        Name = getrandstr(),
        Size = UDim2.new(1, -10, 0, 20),
        Position = UDim2.new(0, 5, 0, 0),
        BackgroundTransparency = 1,
        Text = name,
        Font = UI_CONFIG.Font,
        TextSize = UI_CONFIG.TextSize,
        TextColor3 = UI_CONFIG.TextColor,
        TextXAlignment = Enum.TextXAlignment.Left
    })
    
    local dropdownFrame = CreateInstance("TextButton", {
        Name = getrandstr(),
        Size = UDim2.new(1, -10, 0, 26),
        Position = UDim2.new(0, 5, 0, 22),
        BackgroundColor3 = UI_CONFIG.SecondaryColor,
        BorderSizePixel = 0,
        Text = "",
        AutoButtonColor = false,
        ZIndex = 5
    })
    
    ApplyCorner(dropdownFrame, UI_CONFIG.ButtonCornerRadius)
    ApplyStroke(dropdownFrame, UI_CONFIG.BorderColor, 1)
    
    local selectedOption = CreateInstance("TextLabel", {
        Name = getrandstr(),
        Size = UDim2.new(1, -30, 1, 0),
        Position = UDim2.new(0, 10, 0, 0),
        BackgroundTransparency = 1,
        Text = default,
        Font = UI_CONFIG.Font,
        TextSize = UI_CONFIG.TextSize,
        TextColor3 = UI_CONFIG.TextColor,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextTruncate = Enum.TextTruncate.AtEnd,
        ZIndex = 6
    })
    
    local toggleArrow = CreateInstance("TextLabel", {
        Name = getrandstr(),
        Size = UDim2.new(0, 20, 0, 26),
        Position = UDim2.new(1, -25, 0, 0),
        BackgroundTransparency = 1,
        Text = "▼",
        Font = UI_CONFIG.Font,
        TextSize = UI_CONFIG.TextSize,
        TextColor3 = UI_CONFIG.SubTextColor,
        ZIndex = 6
    })
    
    selectedOption.Parent = dropdownFrame
    toggleArrow.Parent = dropdownFrame
    
    dropdownLabel.Parent = dropdownContainer
    dropdownFrame.Parent = dropdownContainer
    
    dropdownContainer.Parent = section.ContentHolder
    
    local screenGui = gethui():FindFirstChild(CELESTE_UI_ID)
    
    local optionsContainer = CreateInstance("Frame", {
        Name = getrandstr(),
        BackgroundColor3 = UI_CONFIG.SecondaryColor,
        BorderSizePixel = 0,
        Visible = false,
        ZIndex = 1000,
        Parent = screenGui
    })
    
    ApplyCorner(optionsContainer, UI_CONFIG.ButtonCornerRadius)
    ApplyStroke(optionsContainer, UI_CONFIG.BorderColor, 1)
    
    local debugOverlay = CreateInstance("Frame", {
        Name = "DebugOverlay",
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundColor3 = Color3.fromRGB(255, 0, 0),
        BackgroundTransparency = 0.8,
        BorderSizePixel = 0,
        ZIndex = 999,
        Visible = false,
        Parent = optionsContainer
    })
    
    local isExpanded = false
    local optionHeight = 26
    local maxVisibleOptions = 6
    local outsideClickActive = false
    
    local function createOptions()
        for _, child in pairs(optionsContainer:GetChildren()) do
            if child:IsA("TextButton") then
                child:Destroy()
            end
        end
        
        local totalHeight = #options * optionHeight
        local visibleHeight = math.min(totalHeight, maxVisibleOptions * optionHeight)
        
        optionsContainer.Size = UDim2.new(0, dropdownFrame.AbsoluteSize.X, 0, visibleHeight)
        optionsContainer.Position = UDim2.new(
            0, dropdownFrame.AbsolutePosition.X,
            0, dropdownFrame.AbsolutePosition.Y + dropdownFrame.AbsoluteSize.Y + 2
        )
        
        for i, option in ipairs(options) do
            local optionButton = CreateInstance("TextButton", {
                Name = "Option_" .. i,
                Size = UDim2.new(1, 0, 0, optionHeight),
                Position = UDim2.new(0, 0, 0, (i-1) * optionHeight),
                BackgroundColor3 = UI_CONFIG.SecondaryColor,
                Text = option,
                TextColor3 = UI_CONFIG.TextColor,
                Font = UI_CONFIG.Font,
                TextSize = UI_CONFIG.TextSize,
                TextXAlignment = Enum.TextXAlignment.Left,
                BorderSizePixel = 0,
                ZIndex = 1001,
                AutoButtonColor = false,
                Parent = optionsContainer
            })
            
            local textPadding = CreateInstance("UIPadding", {
                PaddingLeft = UDim.new(0, 10),
                Parent = optionButton
            })
            
            local debugLabel = CreateInstance("TextLabel", {
                Name = "DebugLabel_" .. i,
                Size = UDim2.new(0, 20, 0, 20),
                Position = UDim2.new(1, -25, 0.5, -10),
                BackgroundColor3 = Color3.fromRGB(0, 0, 0),
                BackgroundTransparency = 0.5,
                Text = "#" .. i,
                TextColor3 = Color3.fromRGB(255, 255, 255),
                Font = UI_CONFIG.Font,
                TextSize = 10,
                ZIndex = 1002,
                Visible = false,
                Parent = optionButton
            })
            
            ApplyCorner(debugLabel, UDim.new(0, 10))
            
            optionButton.MouseEnter:Connect(function()
                optionButton.BackgroundColor3 = UI_CONFIG.HoverColor
            end)
            
            optionButton.MouseLeave:Connect(function()
                optionButton.BackgroundColor3 = UI_CONFIG.SecondaryColor
            end)
            
            optionButton.MouseButton1Click:Connect(function()
                selectedOption.Text = option
                
                task.defer(function()
                    isExpanded = false
                    outsideClickActive = false
                    optionsContainer.Visible = false
                    debugOverlay.Visible = false
                    toggleArrow.Text = "▼"
                    
                    if callback then
                        callback(option)
                    end
                end)
            end)
        end
    end
    
    local function toggleDropdown()
        isExpanded = not isExpanded
        
        if isExpanded then
            createOptions()
            optionsContainer.Visible = true
            debugOverlay.Visible = true
            toggleArrow.Text = "▲"
            
            task.delay(0.1, function()
                outsideClickActive = true
            end)
        else
            optionsContainer.Visible = false
            debugOverlay.Visible = false
            toggleArrow.Text = "▼"
            outsideClickActive = false
        end
    end
    
    dropdownFrame.MouseButton1Click:Connect(toggleDropdown)
    
    UserInputService.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 and isExpanded and outsideClickActive then
            local mousePos = UserInputService:GetMouseLocation()
            
            local inDropdownButton = 
                mousePos.X >= dropdownFrame.AbsolutePosition.X and 
                mousePos.X <= dropdownFrame.AbsolutePosition.X + dropdownFrame.AbsoluteSize.X and
                mousePos.Y >= dropdownFrame.AbsolutePosition.Y and 
                mousePos.Y <= dropdownFrame.AbsolutePosition.Y + dropdownFrame.AbsoluteSize.Y
            
            local inOptionsContainer = false
            if optionsContainer.Visible then
                inOptionsContainer = 
                    mousePos.X >= optionsContainer.AbsolutePosition.X and 
                    mousePos.X <= optionsContainer.AbsolutePosition.X + optionsContainer.AbsoluteSize.X and
                    mousePos.Y >= optionsContainer.AbsolutePosition.Y and 
                    mousePos.Y <= optionsContainer.AbsolutePosition.Y + optionsContainer.AbsoluteSize.Y
            end
            
            if not (inDropdownButton or inOptionsContainer) then
                task.delay(0.1, function()
                    isExpanded = false
                    outsideClickActive = false
                    optionsContainer.Visible = false
                    debugOverlay.Visible = false
                    toggleArrow.Text = "▼"
                end)
            end
        end
    end)
    
    local dropdownInterface = {
        Instance = dropdownContainer,
        GetSelected = function() return selectedOption.Text end,
        SetSelected = function(option)
            if table.find(options, option) then
                selectedOption.Text = option
                
                if callback then
                    callback(option)
                end
            end
        end,
        UpdateOptions = function(newOptions, newDefault)
            options = newOptions or {}
            
            if newDefault then
                selectedOption.Text = newDefault
            elseif #options > 0 and not table.find(options, selectedOption.Text) then
                selectedOption.Text = options[1]
            end
            
            if isExpanded then
                createOptions()
            end
            
            if callback and newDefault then
                callback(newDefault)
            elseif callback and #options > 0 and not table.find(newOptions, selectedOption.Text) then
                callback(options[1])
            end
        end
    }
    
    table.insert(section.Elements, dropdownInterface)
    return dropdownInterface
end

function CelesteUI:CreateNotification(title, message, duration, notificationType)
    duration = duration or 3
    notificationType = notificationType or "info"
    
    local notifContainer = gethui():FindFirstChild(NOTIFICATIONS_ID)
    if not notifContainer then
        notifContainer = CreateInstance("ScreenGui", {
            Name = NOTIFICATIONS_ID,
            ResetOnSpawn = false,
            ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
            DisplayOrder = 10
        })
        
        local listLayout = CreateInstance("UIListLayout", {
            Padding = UDim.new(0, 5),
            HorizontalAlignment = Enum.HorizontalAlignment.Right,
            VerticalAlignment = Enum.VerticalAlignment.Bottom,
            SortOrder = Enum.SortOrder.LayoutOrder
        })
        
        local padding = CreateInstance("UIPadding", {
            PaddingRight = UDim.new(0, 20),
            PaddingBottom = UDim.new(0, 20)
        })
        
        listLayout.Parent = notifContainer
        padding.Parent = notifContainer
        notifContainer.Parent = gethui()
    end
    
    local notifColor
    local iconText
    
    if notificationType == "success" then
        notifColor = UI_CONFIG.SuccessColor
        iconText = "✓"
    elseif notificationType == "warning" then
        notifColor = UI_CONFIG.WarningColor
        iconText = "⚠"
    elseif notificationType == "error" then
        notifColor = UI_CONFIG.ErrorColor
        iconText = "×"
    else
        notifColor = UI_CONFIG.AccentColor
        iconText = "ℹ"
    end
    
    local notifFrame = CreateInstance("Frame", {
        Name = getrandstr(),
        Size = UDim2.new(0, 250, 0, 0),
        BackgroundColor3 = UI_CONFIG.MainColor,
        BorderSizePixel = 0,
        AutomaticSize = Enum.AutomaticSize.None,
        LayoutOrder = #notifContainer:GetChildren() * -1
    })
    
    ApplyCorner(notifFrame, UI_CONFIG.WindowCornerRadius)
    ApplyStroke(notifFrame, UI_CONFIG.BorderColor, 1)
    
    local indicator = CreateInstance("Frame", {
        Name = getrandstr(),
        Size = UDim2.new(0, 4, 0.9, 0),
        AnchorPoint = Vector2.new(0, 0.5),
        Position = UDim2.new(0, 2, 0.5, 0),
        BackgroundColor3 = notifColor,
        BorderSizePixel = 0
    })

    ApplyCorner(indicator, UDim.new(0, 5))
    
    local iconLabel = CreateInstance("TextLabel", {
        Name = getrandstr(),
        Size = UDim2.new(0, 24, 0, 24),
        Position = UDim2.new(0, 12, 0, 8),
        BackgroundTransparency = 1,
        Text = iconText,
        TextColor3 = notifColor,
        Font = UI_CONFIG.HeaderFont,
        TextSize = 18
    })
    
    local titleLabel = CreateInstance("TextLabel", {
        Name = getrandstr(),
        Size = UDim2.new(1, -60, 0, 20),
        Position = UDim2.new(0, 40, 0, 8),
        BackgroundTransparency = 1,
        Text = title,
        TextColor3 = UI_CONFIG.TextColor,
        Font = UI_CONFIG.HeaderFont,
        TextSize = UI_CONFIG.TitleSize,
        TextXAlignment = Enum.TextXAlignment.Left
    })
    
    local messageLabel = CreateInstance("TextLabel", {
        Name = getrandstr(),
        Size = UDim2.new(1, -60, 0, 0),
        Position = UDim2.new(0, 40, 0, 30),
        BackgroundTransparency = 1,
        Text = message,
        TextColor3 = UI_CONFIG.SubTextColor,
        Font = UI_CONFIG.Font,
        TextSize = UI_CONFIG.TextSize,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextYAlignment = Enum.TextYAlignment.Top,
        TextWrapped = true,
        AutomaticSize = Enum.AutomaticSize.Y
    })
    
    local closeButton = CreateInstance("TextButton", {
        Name = getrandstr(),
        Size = UDim2.new(0, 20, 0, 20),
        Position = UDim2.new(1, -25, 0, 8),
        BackgroundTransparency = 1,
        Text = "×",
        TextColor3 = UI_CONFIG.SubTextColor,
        Font = UI_CONFIG.Font,
        TextSize = UI_CONFIG.TextSize
    })
    
    indicator.Parent = notifFrame
    iconLabel.Parent = notifFrame
    titleLabel.Parent = notifFrame
    messageLabel.Parent = notifFrame
    closeButton.Parent = notifFrame
    
    messageLabel:GetPropertyChangedSignal("TextBounds"):Connect(function()
        task.defer(function()
            local targetHeight = math.max(60, messageLabel.TextBounds.Y + 45)
            notifFrame.Size = UDim2.new(0, 250, 0, targetHeight)
        end)
    end)
    
    closeButton.MouseEnter:Connect(function()
        closeButton.TextColor3 = UI_CONFIG.TextColor
    end)
    
    closeButton.MouseLeave:Connect(function()
        closeButton.TextColor3 = UI_CONFIG.SubTextColor
    end)
    
    local function closeNotification()
        local fadeTween = TweenService:Create(
            notifFrame,
            TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            {BackgroundTransparency = 1}
        )
        
        for _, child in ipairs(notifFrame:GetDescendants()) do
            if child:IsA("GuiObject") then
                local targetTransparency = 1
                if child:IsA("Frame") and child.Name == "Indicator" then
                    targetTransparency = 1
                elseif child:IsA("TextLabel") or child:IsA("TextButton") then
                    TweenService:Create(
                        child,
                        TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                        {TextTransparency = 1, BackgroundTransparency = 1}
                    ):Play()
                else
                    TweenService:Create(
                        child,
                        TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                        {BackgroundTransparency = 1}
                    ):Play()
                end
            end
        end
        
        fadeTween:Play()
        fadeTween.Completed:Connect(function()
            notifFrame:Destroy()
        end)
    end
    
    notifFrame.BackgroundTransparency = 1
    for _, child in ipairs(notifFrame:GetDescendants()) do
        if child:IsA("GuiObject") then
            if child.Name == "Indicator" then
                child.BackgroundTransparency = 1
            elseif child:IsA("TextLabel") or child:IsA("TextButton") then
                child.TextTransparency = 1
                child.BackgroundTransparency = 1
            else
                child.BackgroundTransparency = 1
            end
        end
    end
    
    notifFrame.Parent = notifContainer
    
    task.defer(function()
        local targetHeight = math.max(60, messageLabel.TextBounds.Y + 45)
        notifFrame.Size = UDim2.new(0, 250, 0, targetHeight)
        
        TweenService:Create(
            notifFrame,
            TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            {BackgroundTransparency = 0}
        ):Play()
        
        for _, child in ipairs(notifFrame:GetDescendants()) do
            if child:IsA("GuiObject") then
                if child.Name == "Indicator" then
                    TweenService:Create(
                        child,
                        TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                        {BackgroundTransparency = 0}
                    ):Play()
                elseif child:IsA("TextLabel") or child:IsA("TextButton") then
                    TweenService:Create(
                        child,
                        TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                        {TextTransparency = 0, BackgroundTransparency = child.BackgroundTransparency}
                    ):Play()
                end
            end
        end
    end)
    
    if duration and duration > 0 then
        task.delay(duration, closeNotification)
    end
    
    return {
        Frame = notifFrame,
        Close = closeNotification
    }
end

local uiTable = (function()
    local main = CelesteUI:new("Celeste", UDim2.new(0.5, 0, 0.5))

    return {
        main = main,
        tabs = {
            reanimation = (function()
                local tab = main:AddTab("Reanimation")
                return {
                    tab = tab,
                    sections = {
                        options = main:AddSection(tab, "Reanimation Module", "left"),
                        scaling = main:AddSection(tab, "Scaling Module", "left"),
                        misc = main:AddSection(tab, "Misc Module", "left"),
                        presets = main:AddSection(tab, "Presets Module", "right")
                    }
                }
            end)(),

            voice = (function()
                local tab = main:AddTab("Voice")
                return {
                    tab = tab,
                    sections = {
                        settings = main:AddSection(tab, "Voice Module", "left"),
                    }
                }
            end)(),

            visuals = (function()
                local tab = main:AddTab("Visuals")
                return {
                    tab = tab,
                    sections = {
                        camera = main:AddSection(tab, "Camera Module", "left"),
                        esp = main:AddSection(tab, "ESP Module", "left"),
                        rain = main:AddSection(tab, "Rain Module", "right"),
                        time = main:AddSection(tab, "Time Module", "right")
                    }
                }
            end)(),

            misc = (function()
                local tab = main:AddTab("Misc")
                return {
                    tab = tab,
                    sections = {
                        map = main:AddSection(tab, "Map Module", "left"),
                    }
                }
            end)(),

            guis = (function()
                local tab = main:AddTab("GUIs")
                return {
                    tab = tab,
                    sections = {
                        gui = main:AddSection(tab, "GUI Module", "left"),
                    }
                }
            end)(),

            about = (function()
                local tab = main:AddTab("About")
                return {
                    tab = tab,
                    sections = {
                        info = main:AddSection(tab, "Script Information", "left"),
                        credits = main:AddSection(tab, "Credits", "right")
                    }
                }
            end)(),
        }
    }
end)()

local ui = uiTable.main
local sections = {
    --[[ REANIMATION ]]--
    reanimOptions = uiTable.tabs.reanimation.sections.options,
    reanimScaling = uiTable.tabs.reanimation.sections.scaling,
    reanimMisc = uiTable.tabs.reanimation.sections.misc,
    reanimPresets = uiTable.tabs.reanimation.sections.presets,
    
    --[[ VOICE ]]--
    voiceSettings = uiTable.tabs.voice.sections.settings,
    
    --[[ VISUALS ]]--
    visualsESP = uiTable.tabs.visuals.sections.esp,
    visualsCamera = uiTable.tabs.visuals.sections.camera,
    visualsRain = uiTable.tabs.visuals.sections.rain,
    visualsTime = uiTable.tabs.visuals.sections.time,
    
    --[[ MISC ]]--
    miscMap = uiTable.tabs.misc.sections.map,

    --[[ GUIs ]]--
    guisGui = uiTable.tabs.guis.sections.gui,
    
    --[[ ABOUT ]]--
    aboutInfo = uiTable.tabs.about.sections.info,
    aboutCredits = uiTable.tabs.about.sections.credits
}

--[[ VARIABLES ]]--
local isReanimated = false
local CustomTime = false
local OldTime = nil
local SettedTime = 0

local r15con = nil
local r6con = nil
local orbitConnection = nil
local ropeConnection = nil
local annoyConnection = nil
local poleConnection = nil
local circleConnection = nil
local autoConnection = nil
local floodMapConnection = nil

--[[ FUNCS ]]--
local function getPing()
    local pingString = game.Stats.PerformanceStats.Ping:GetValueString()
    return tonumber(pingString:match("^%d+%.?%d*")) / 1000
end

local function gp(parent, name, className)
    if typeof(parent) == "Instance" then
        for i, v in pairs(parent:GetChildren()) do
            if (v.Name == name) and v:IsA(className) then
                return v
            end
        end
    end
    return nil
end

local function ConvertToR6(c)
    local hum1 = c:FindFirstChildOfClass("Humanoid")
    if hum1 and hum1.RigType == Enum.HumanoidRigType.R15 then
        local part = gp(c, "HumanoidRootPart", "BasePart") or gp(c, "UpperTorso", "BasePart") or gp(c, "LowerTorso", "BasePart") or gp(c, "Head", "BasePart") or c:FindFirstChildWhichIsA("BasePart")
        if part then
            local cfr = part.CFrame
            local R6parts = {
                head = {Name = "Head", Size = Vector3.new(2, 1, 1), R15 = {Head = 0}},
                torso = {Name = "Torso", Size = Vector3.new(2, 2, 1), R15 = {UpperTorso = 0.2, LowerTorso = -0.8}},
                root = {Name = "HumanoidRootPart", Size = Vector3.new(2, 2, 1), R15 = {HumanoidRootPart = 0}},
                leftArm = {Name = "Left Arm", Size = Vector3.new(1, 2, 1), R15 = {LeftHand = -0.849, LeftLowerArm = -0.174, LeftUpperArm = 0.415}},
                rightArm = {Name = "Right Arm", Size = Vector3.new(1, 2, 1), R15 = {RightHand = -0.849, RightLowerArm = -0.174, RightUpperArm = 0.415}},
                leftLeg = {Name = "Left Leg", Size = Vector3.new(1, 2, 1), R15 = {LeftFoot = -0.85, LeftLowerLeg = -0.29, LeftUpperLeg = 0.49}},
                rightLeg = {Name = "Right Leg", Size = Vector3.new(1, 2, 1), R15 = {RightFoot = -0.85, RightLowerLeg = -0.29, RightUpperLeg = 0.49}}
            }

            for i, v in pairs(c:GetChildren()) do
                if v:IsA("BasePart") then
                    for i1, v1 in pairs(v:GetChildren()) do
                        if v1:IsA("Motor6D") then
                            v1.Part0 = nil
                        end
                    end
                end
            end

            part.Archivable = true
            for i, v in pairs(R6parts) do
                local part = part:Clone()
                part:ClearAllChildren()
                part.Name, part.Size, part.CFrame, part.Anchored, part.Transparency, part.CanCollide = v.Name, v.Size, cfr, false, 1, false
                for i1, v1 in pairs(v.R15) do
                    local R15part = gp(c, i1, "BasePart")
                    local att = gp(R15part, "att1_" .. i1, "Attachment")
                    if R15part then
                        local weld = Instance.new("Weld")
                        weld.Part0, weld.Part1, weld.C0, weld.C1, weld.Name = part, R15part, CFrame.new(0, v1, 0), CFrame.new(0, 0, 0), "Weld_" .. i1
                        weld.Parent = R15part
                        R15part.Massless, R15part.Name = true, "R15_" .. i1
                        R15part.Parent = part
                        if att then
                            att.Position = Vector3.new(0, v1, 0)
                            att.Parent = part
                        end
                    end
                end
                part.Parent = c
                R6parts[i] = part
            end

            local R6joints = {
                neck = {Parent = R6parts.torso, Name = "Neck", Part0 = R6parts.torso, Part1 = R6parts.head, C0 = CFrame.new(0, 1, 0, -1, 0, 0, 0, 0, 1, 0, 1, -0), C1 = CFrame.new(0, -0.5, 0, -1, 0, 0, 0, 0, 1, 0, 1, -0)},
                rootJoint = {Parent = R6parts.root, Name = "RootJoint" , Part0 = R6parts.root, Part1 = R6parts.torso, C0 = CFrame.new(0, 0, 0, -1, 0, 0, 0, 0, 1, 0, 1, -0), C1 = CFrame.new(0, 0, 0, -1, 0, 0, 0, 0, 1, 0, 1, -0)},
                rightShoulder = {Parent = R6parts.torso, Name = "Right Shoulder", Part0 = R6parts.torso, Part1 = R6parts.rightArm, C0 = CFrame.new(1, 0.5, 0, 0, 0, 1, 0, 1, -0, -1, 0, 0), C1 = CFrame.new(-0.5, 0.5, 0, 0, 0, 1, 0, 1, -0, -1, 0, 0)},
                leftShoulder = {Parent = R6parts.torso, Name = "Left Shoulder", Part0 = R6parts.torso, Part1 = R6parts.leftArm, C0 = CFrame.new(-1, 0.5, 0, 0, 0, -1, 0, 1, 0, 1, 0, 0), C1 = CFrame.new(0.5, 0.5, 0, 0, 0, -1, 0, 1, 0, 1, 0, 0)},
                rightHip = {Parent = R6parts.torso, Name = "Right Hip", Part0 = R6parts.torso, Part1 = R6parts.rightLeg, C0 = CFrame.new(1, -1, 0, 0, 0, 1, 0, 1, -0, -1, 0, 0), C1 = CFrame.new(0.5, 1, 0, 0, 0, 1, 0, 1, -0, -1, 0, 0)},
                leftHip = {Parent = R6parts.torso, Name = "Left Hip" , Part0 = R6parts.torso, Part1 = R6parts.leftLeg, C0 = CFrame.new(-1, -1, 0, 0, 0, -1, 0, 1, 0, 1, 0, 0), C1 = CFrame.new(-0.5, 1, 0, 0, 0, -1, 0, 1, 0, 1, 0, 0)}
            }

            for i, v in pairs(R6joints) do
                local joint = Instance.new("Motor6D")
                for prop, val in pairs(v) do
                    joint[prop] = val
                end
                R6joints[i] = joint
            end

            hum1.RigType = Enum.HumanoidRigType.R6
            hum1.HipHeight = 0

        end
    end
    return c
end

function ragdoll()
    if game.PlaceId == 15546218972 or game.PlaceId == 6884319169 then
        ReplicatedStorage:WaitForChild("RagdollEvent"):FireServer()
    elseif game.PlaceId == 111294513233843 then
        ReplicatedStorage:WaitForChild("RagdollEvent"):FireServer()
    end
end

function unragdoll()
    if game.PlaceId == 15546218972 or game.PlaceId == 6884319169 then
        ReplicatedStorage:WaitForChild("UnragdollEvent"):FireServer()
    end
end

function getchar()
    return workspace:FindFirstChild(Player.Name)
end

function cloned()
    return workspace:FindFirstChild("Celeste")
end

function clone()
    if not cloned() then
        Player.Character.Archivable = true
        local clone = Player.Character:Clone()
        clone.Name = "Celeste"
        clone.Parent = workspace
        for _, part in pairs(clone:GetDescendants()) do
            if part:IsA("BasePart") or part:IsA("Decal") then
                part.Transparency = 1
            end
        end
        for _, part in pairs(getchar():GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
        
        log("Cloned character successfully.")
        return clone
    else
        log("Already cloned. Returning...")
        return workspace:FindFirstChild("Celeste")
    end
end

function unclone()
    if cloned() then
        clone():Destroy()
        Player.Character = getchar()
        Camera.CameraSubject = Player.Character.Humanoid
        for _, part in pairs(getchar():GetChildren()) do
            if part.Name == "LowerTorso" or part.Name == "UpperTorso" or part.Name == "HumanoidRootPart" then
                part.CanCollide = true
            end
        end
        
        log("Cloned character successfully.")
        return
    else
        log("Already uncloned. Returning...")
        return
    end
end

function animate(char)
    if cloned() then char = cloned() else char = getchar() end
    char:WaitForChild("Animate").Enabled = false
    char:WaitForChild("Animate").Enabled = true
end

function unanimate(char)
    if cloned() then char = cloned() else char = getchar() end
    char:WaitForChild("Animate").Enabled = false
end

--[[ REANIMATION TAB ]]--
--[[ OPTIONS ]]--
ui:AddToggle(sections.reanimOptions, "R15", false, function(value)
    if value then
        if isReanimated then
            log("Already reanimated. Returning...")
            return
        end
        
        log("Reanimating...")
        clone()
        Player.Character = cloned()
        Camera.CameraSubject = Player.Character.Humanoid
        animate()

        r15con = RunService.Heartbeat:Connect(function()
            for _, part in pairs(getchar():GetChildren()) do
                if part:IsA("BasePart") then
                    task.spawn(function()
                        clonepart = cloned():FindFirstChild(part.Name)
                        part.CFrame = clonepart.CFrame
                        part.Velocity = Vector3.new()
                    end)
                end
            end
        end)
        ragdoll()
        isReanimated = true
    else
        log("Cleaning up reanimation...")
        unragdoll()
        unclone()
        if r15con then
            r15con:Disconnect()
            r15con = nil
        end
        isReanimated = false
    end
end)

ui:AddToggle(sections.reanimOptions, "R6", false, function(value)
    if value then
        if isReanimated then
            log("Already reanimated. Returning...")
            return
        end
        log("Reanimating...")
        ConvertToR6(clone())
        Player.Character = cloned()
        Camera.CameraSubject = Player.Character.Humanoid
        animate()
        
        local parts = {
            {orig = getchar().Head, clone = cloned().Head},
            {orig = getchar().UpperTorso, clone = cloned().Torso["R15_UpperTorso"]},
            {orig = getchar().LowerTorso, clone = cloned().Torso["R15_LowerTorso"]},
            {orig = getchar().RightUpperArm, clone = cloned()["Right Arm"]["R15_RightUpperArm"]},
            {orig = getchar().RightLowerArm, clone = cloned()["Right Arm"]["R15_RightLowerArm"]},
            {orig = getchar().RightHand, clone = cloned()["Right Arm"]["R15_RightHand"]},
            {orig = getchar().LeftUpperArm, clone = cloned()["Left Arm"]["R15_LeftUpperArm"]},
            {orig = getchar().LeftLowerArm, clone = cloned()["Left Arm"]["R15_LeftLowerArm"]},
            {orig = getchar().LeftHand, clone = cloned()["Left Arm"]["R15_LeftHand"]},
            {orig = getchar().RightUpperLeg, clone = cloned()["Right Leg"]["R15_RightUpperLeg"]},
            {orig = getchar().RightLowerLeg, clone = cloned()["Right Leg"]["R15_RightLowerLeg"]},
            {orig = getchar().RightFoot, clone = cloned()["Right Leg"]["R15_RightFoot"]},
            {orig = getchar().LeftUpperLeg, clone = cloned()["Left Leg"]["R15_LeftUpperLeg"]},
            {orig = getchar().LeftLowerLeg, clone = cloned()["Left Leg"]["R15_LeftLowerLeg"]},
            {orig = getchar().LeftFoot, clone = cloned()["Left Leg"]["R15_LeftFoot"]},
            {orig = getchar().HumanoidRootPart, clone = cloned().HumanoidRootPart}
        }

        r6con = RunService.Heartbeat:Connect(function()
            for _, part in ipairs(parts) do
                if part.orig and part.clone then
                    part.orig.CFrame = part.clone.CFrame
                    part.orig.Velocity = Vector3.new()
                end
            end
        end)

        ragdoll()
        isReanimated = true
    else
        log("Cleaning up reanimation...")
        unragdoll()
        unclone()
        if r6con then
            r6con:Disconnect()
            r6con = nil
        end
        isReanimated = false
        isReanimated = false
    end
end)

--[[ SCALING ]]--
ui:AddSlider(sections.reanimScaling, "Width", 0.5, 15, 1, function(value)
    if cloned() then cloned().Humanoid.BodyWidthScale.Value = value end
end)

ui:AddSlider(sections.reanimScaling, "Height", 0.5, 15, 1, function(value)
    if cloned() then cloned().Humanoid.BodyHeightScale.Value = value end
end)

--[[ MISC ]]--
ui:AddButton(sections.reanimMisc, "Instant-Respawn", function()
    local player = game.Players.LocalPlayer
    local character = player.Character
    if not character or not character:FindFirstChild("HumanoidRootPart") then return end

    local pos = character.HumanoidRootPart.CFrame

    if replicatesignal then
        replicatesignal(player.ConnectDiedSignalBackend)
        task.wait(game.Players.RespawnTime - 0.165)

        character:BreakJoints()

        local connection
        connection = player.CharacterAdded:Connect(function(char)
            local hrp = char:WaitForChild("HumanoidRootPart", 5)
            if hrp then
                hrp.CFrame = pos
            end
            if connection then
                connection:Disconnect()
                connection = nil
            end
        end)
    else
        ui:CreateNotification("Error", "You cannot use this because your executor doesn't support 'replicatesignal'", 5, "error")
    end
end)

--[[ PRESETS ]]--
ui:AddToggle(sections.reanimPresets, "Invisible", false, function(value)
    if value then
        if isReanimated then
            log("Already reanimated. Returning...")
            return
        end
        
        local char = Player.Character
        local hrp = char and char:WaitForChild("HumanoidRootPart")
        local humanoid = char and char:FindFirstChildOfClass("Humanoid")

        if not hrp or not humanoid then return end

        local pos = hrp.CFrame
        local freezeCamPos = Camera.CFrame
        
        Camera.CameraType = Enum.CameraType.Scriptable
        Camera.CFrame = freezeCamPos

        ragdoll()

        hrp.CFrame = pos + Vector3.new(0, -500, 0)

        task.wait(getPing() + 0.2)

        for _, v in pairs(char:GetChildren()) do
            if v:IsA("BasePart") and v.Name ~= "HumanoidRootPart" then
                local constraint = v:FindFirstChild("BallSocketConstraint")
                if constraint then
                    constraint.Enabled = false
                end
            end
        end

        hrp.CFrame = pos
        Camera.CameraSubject = humanoid
        Camera.CameraType = Enum.CameraType.Custom
        isReanimated = true
    else
        log("Cleaning up invisibility...")
        unragdoll()
        Player.Character = getchar()
        Camera.CameraSubject = Player.Character:WaitForChild("Humanoid")
        Camera.CameraType = Enum.CameraType.Custom
        isReanimated = false
    end
end)

ui:AddToggle(sections.reanimPresets, "Freeze Body", false, function(value)
    if value then
        if isReanimated then
            log("Already reanimated. Returning...")
            return
        end
        
        ragdoll()
        for _, v in pairs(getchar():GetChildren()) do
            if v:IsA("BasePart") and v.Name ~= "HumanoidRootPart" then
                local ball = v:WaitForChild("BallSocketConstraint")
                ball.Enabled = false
            end
        end
        isReanimated = true
    else
        unragdoll()
        isReanimated = false
    end
end)

ui:AddToggle(sections.reanimPresets, "Flood Map", false, function(value)
    if value then
        if isReanimated then
            log("Already reanimated. Returning...")
            return
        end
        
        if cloned() then
            log("Already cloned, using existing clone")
        else
            log("Creating clone...")
            clone()
        end

        Player.Character = cloned()
        Camera.CameraSubject = Player.Character.Humanoid
        animate()
        
        local originalChar = getchar()
        if not originalChar then
            ui:CreateNotification("Error", "Original character not found", 3, "error")
            return
        end
        
        ragdoll()
        
        local upperTorso = originalChar:FindFirstChild("UpperTorso")
        if upperTorso then
            upperTorso:WaitForChild("BallSocketConstraint")
        end
        
        local head = originalChar:FindFirstChild("Head")
        local upperTorso = originalChar:FindFirstChild("UpperTorso")
        local lowerTorso = originalChar:FindFirstChild("LowerTorso")
        local rightUpperArm = originalChar:FindFirstChild("RightUpperArm")
        local rightLowerArm = originalChar:FindFirstChild("RightLowerArm")
        local rightHand = originalChar:FindFirstChild("RightHand")
        local leftUpperArm = originalChar:FindFirstChild("LeftUpperArm")
        local leftLowerArm = originalChar:FindFirstChild("LeftLowerArm")
        local leftHand = originalChar:FindFirstChild("LeftHand")
        local rightUpperLeg = originalChar:FindFirstChild("RightUpperLeg")
        local rightLowerLeg = originalChar:FindFirstChild("RightLowerLeg")
        local rightFoot = originalChar:FindFirstChild("RightFoot")
        local leftUpperLeg = originalChar:FindFirstChild("LeftUpperLeg")
        local leftLowerLeg = originalChar:FindFirstChild("LeftLowerLeg")
        local leftFoot = originalChar:FindFirstChild("LeftFoot")
        
        local hrp = originalChar:FindFirstChild("HumanoidRootPart")
        if not hrp then
            ui:CreateNotification("Error", "HumanoidRootPart not found", 3, "error")
            return
        end
        
        local offset = 100000
        local baseCFrame = hrp.CFrame * CFrame.new(0, 2, 0) * CFrame.Angles(math.rad(-90), 0, 0)
        
        local function setVelocityToZero(part)
            if part then
                part.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
                part.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
            end
        end
        
        floodMapConnection = RunService.Heartbeat:Connect(function()
            if head then
                head.CFrame = baseCFrame * CFrame.new(0, 0, -offset / 2)
                setVelocityToZero(head)
            end
            
            if upperTorso then
                upperTorso.CFrame = baseCFrame * CFrame.new(0, offset, 0)
                setVelocityToZero(upperTorso)
            end
            
            if lowerTorso then
                lowerTorso.CFrame = baseCFrame * CFrame.new(0, -offset / 2, 0)
                setVelocityToZero(lowerTorso)
            end
            
            if rightUpperArm then
                rightUpperArm.CFrame = baseCFrame * CFrame.new(offset, 0, 0)
                setVelocityToZero(rightUpperArm)
            end
            
            if rightLowerArm then
                rightLowerArm.CFrame = baseCFrame * CFrame.new(offset * 1.5, 0, 0)
                setVelocityToZero(rightLowerArm)
            end
            
            if rightHand then
                rightHand.CFrame = baseCFrame * CFrame.new(offset * 2, 0, 0)
                setVelocityToZero(rightHand)
            end
            
            if leftUpperArm then
                leftUpperArm.CFrame = baseCFrame * CFrame.new(-offset, 0, 0)
                setVelocityToZero(leftUpperArm)
            end
            
            if leftLowerArm then
                leftLowerArm.CFrame = baseCFrame * CFrame.new(-offset * 1.5, 0, 0)
                setVelocityToZero(leftLowerArm)
            end
            
            if leftHand then
                leftHand.CFrame = baseCFrame * CFrame.new(-offset * 2, 0, 0)
                setVelocityToZero(leftHand)
            end
            
            if rightUpperLeg then
                rightUpperLeg.CFrame = baseCFrame * CFrame.new(offset / 2, -offset, 0)
                setVelocityToZero(rightUpperLeg)
            end
            
            if rightLowerLeg then
                rightLowerLeg.CFrame = baseCFrame * CFrame.new(offset / 2, -offset * 1.5, 0)
                setVelocityToZero(rightLowerLeg)
            end
            
            if rightFoot then
                rightFoot.CFrame = baseCFrame * CFrame.new(offset / 2, -offset * 2, 0)
                setVelocityToZero(rightFoot)
            end
            
            if leftUpperLeg then
                leftUpperLeg.CFrame = baseCFrame * CFrame.new(-offset / 2, -offset, 0)
                setVelocityToZero(leftUpperLeg)
            end
            
            if leftLowerLeg then
                leftLowerLeg.CFrame = baseCFrame * CFrame.new(-offset / 2, -offset * 1.5, 0)
                setVelocityToZero(leftLowerLeg)
            end
            
            if leftFoot then
                leftFoot.CFrame = baseCFrame * CFrame.new(-offset / 2, -offset * 2, 0)
                setVelocityToZero(leftFoot)
            end
        end)
        isReanimated = true
    else
        if floodMapConnection then
            floodMapConnection:Disconnect()
            floodMapConnection = nil
        end
        
        unragdoll()
        if cloned() then
            unclone()
        end
        isReanimated = false
    end
end)

ui:AddToggle(sections.reanimPresets, "Grab", false, function(value)
    if value then
        if isReanimated then
            log("Already reanimated. Returning...")
            return
        end
        
        if cloned() then
            log("Already cloned, using existing clone")
        else
            log("Creating clone...")
            clone()
        end

        Player.Character = cloned()
        Camera.CameraSubject = Player.Character.Humanoid
        animate()

        local originalChar = getchar()
        if not originalChar then
            ui:CreateNotification("Error", "Original character not found", 3, "error")
            return
        end
        
        ragdoll()
        
        local leftHand = originalChar:FindFirstChild("LeftHand")
        local rightHand = originalChar:FindFirstChild("RightHand")
        local leftLowerArm = originalChar:FindFirstChild("LeftLowerArm")
        local rightLowerArm = originalChar:FindFirstChild("RightLowerArm")
        local leftUpperArm = originalChar:FindFirstChild("LeftUpperArm")
        local rightUpperArm = originalChar:FindFirstChild("RightUpperArm")
        local upperTorso = originalChar:FindFirstChild("UpperTorso")
        
        if not (leftHand and rightHand) then
            leftHand = originalChar:FindFirstChild("Left Arm")
            rightHand = originalChar:FindFirstChild("Right Arm")
            upperTorso = originalChar:FindFirstChild("Torso")
            
            leftLowerArm = leftHand
            rightLowerArm = rightHand
            leftUpperArm = leftHand
            rightUpperArm = rightHand
        end
        
        if not (leftHand and rightHand and upperTorso) then
            ui:CreateNotification("Error", "Required arm parts not found", 3, "error")
            return
        end
        
        local leftGrabbing = false
        local rightGrabbing = false
        local leftGrabTarget = nil
        local rightGrabTarget = nil
        local leftGrabOffset = CFrame.new()
        local rightGrabOffset = CFrame.new()
        
        local maxGrabDistance = 500
        local restPosition = CFrame.new(0, 0, -1.5)
        local armTrailLength = 6
        local armSmoothing = 0.3
        
        local leftTrailParts = {}
        local rightTrailParts = {}
        
        local trailFolder = Instance.new("Folder")
        trailFolder.Name = "CelesteTrailParts"
        trailFolder.Parent = workspace
        
        for i = 1, armTrailLength do
            local leftPart = Instance.new("Part")
            leftPart.Name = "LeftArmTrail" .. i
            leftPart.Size = Vector3.new(0.2, 0.2, 0.5)
            leftPart.Anchored = true
            leftPart.CanCollide = false
            leftPart.CanQuery = false
            leftPart.CanTouch = false
            leftPart.Transparency = 0.5
            leftPart.Material = Enum.Material.SmoothPlastic
            leftPart.Color = Color3.fromRGB(255, 165, 0)
            leftPart.Parent = trailFolder
            table.insert(leftTrailParts, leftPart)
            
            local rightPart = Instance.new("Part")
            rightPart.Name = "RightArmTrail" .. i
            rightPart.Size = Vector3.new(0.2, 0.2, 0.5)
            rightPart.Anchored = true
            rightPart.CanCollide = false
            rightPart.CanQuery = false
            rightPart.CanTouch = false
            rightPart.Transparency = 0.5
            rightPart.Material = Enum.Material.SmoothPlastic
            rightPart.Color = Color3.fromRGB(30, 144, 255)
            rightPart.Parent = trailFolder
            table.insert(rightTrailParts, rightPart)
        end
        
        local leftTrailPositions = {}
        local rightTrailPositions = {}
        for i = 1, armTrailLength do
            leftTrailPositions[i] = CFrame.new()
            rightTrailPositions[i] = CFrame.new()
        end
        
        local leftMouseDown = false
        local rightMouseDown = false
        
        local inputBeganConn = UserInputService.InputBegan:Connect(function(input, gameProcessed)
            if gameProcessed then return end
            
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                leftMouseDown = true
                
                local rayParams = RaycastParams.new()
                rayParams.FilterDescendantsInstances = {originalChar, cloned(), workspace:FindFirstChild("CelesteTrailParts")}
                rayParams.FilterType = Enum.RaycastFilterType.Exclude
                
                local mousePos = UserInputService:GetMouseLocation()
                local ray = Camera:ScreenPointToRay(mousePos.X, mousePos.Y)
                local raycastResult = workspace:Raycast(ray.Origin, ray.Direction * maxGrabDistance, rayParams)
                
                if raycastResult and raycastResult.Instance then
                    leftGrabbing = true
                    leftGrabTarget = raycastResult.Instance
                    local handPos = leftHand.CFrame.Position
                    leftGrabOffset = leftGrabTarget.CFrame:Inverse() * CFrame.new(raycastResult.Position)
                end
            elseif input.UserInputType == Enum.UserInputType.MouseButton2 then
                rightMouseDown = true
                
                local rayParams = RaycastParams.new()
                rayParams.FilterDescendantsInstances = {originalChar, cloned(), workspace:FindFirstChild("CelesteTrailParts")}
                rayParams.FilterType = Enum.RaycastFilterType.Exclude
                
                local mousePos = UserInputService:GetMouseLocation()
                local ray = Camera:ScreenPointToRay(mousePos.X, mousePos.Y)
                local raycastResult = workspace:Raycast(ray.Origin, ray.Direction * maxGrabDistance, rayParams)
                
                if raycastResult and raycastResult.Instance then
                    rightGrabbing = true
                    rightGrabTarget = raycastResult.Instance
                    local handPos = rightHand.CFrame.Position
                    rightGrabOffset = rightGrabTarget.CFrame:Inverse() * CFrame.new(raycastResult.Position)
                end
            end
        end)
        
        local inputEndedConn = UserInputService.InputEnded:Connect(function(input, gameProcessed)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                leftMouseDown = false
                leftGrabbing = false
                leftGrabTarget = nil
            elseif input.UserInputType == Enum.UserInputType.MouseButton2 then
                rightMouseDown = false
                rightGrabbing = false
                rightGrabTarget = nil
            end
        end)
        
        local grabConnection = RunService.Heartbeat:Connect(function()
            local cloneHRP = cloned():FindFirstChild("HumanoidRootPart")
            local originalHRP = originalChar:FindFirstChild("HumanoidRootPart")
            local cloneHead = cloned():FindFirstChild("Head")
            local originalHead = originalChar:FindFirstChild("Head")
            
            if cloneHRP and originalHRP then
                originalHRP.CFrame = cloneHRP.CFrame
                originalHRP.Velocity = Vector3.new(0, 0, 0)
            end
            
            if cloneHead and originalHead then
                originalHead.CFrame = cloneHead.CFrame
                originalHead.Velocity = Vector3.new(0, 0, 0)
            end
            
            if upperTorso and cloned():FindFirstChild(upperTorso.Name) then
                upperTorso.CFrame = cloned():FindFirstChild(upperTorso.Name).CFrame
                upperTorso.Velocity = Vector3.new(0, 0, 0)
            end
            
            local legParts = {"LeftUpperLeg", "LeftLowerLeg", "LeftFoot", "RightUpperLeg", "RightLowerLeg", "RightFoot", "Left Leg", "Right Leg"}
            for _, partName in ipairs(legParts) do
                local part = originalChar:FindFirstChild(partName)
                local clonePart = cloned():FindFirstChild(partName)
                if part and clonePart then
                    part.CFrame = clonePart.CFrame
                    part.Velocity = Vector3.new(0, 0, 0)
                end
            end
            
            local mousePos = UserInputService:GetMouseLocation()
            local ray = Camera:ScreenPointToRay(mousePos.X, mousePos.Y)
            local direction = ray.Direction.Unit
            
            local leftHandPosition
            local leftHandTarget
            
            if leftGrabbing and leftGrabTarget and leftGrabTarget.Parent then
                leftHandTarget = leftGrabTarget.CFrame * leftGrabOffset
                leftHand.Velocity = Vector3.new(0, 0, 0)
            else
                local shoulderPos = upperTorso.CFrame * CFrame.new(-1, 0.5, 0)
                local rayParams = RaycastParams.new()
                rayParams.FilterDescendantsInstances = {originalChar, cloned()}
                rayParams.FilterType = Enum.RaycastFilterType.Exclude
                
                local raycastResult = workspace:Raycast(ray.Origin, ray.Direction * maxGrabDistance, rayParams)
                
                if raycastResult then
                    leftHandTarget = CFrame.new(raycastResult.Position)
                else
                    leftHandTarget = CFrame.new(ray.Origin + ray.Direction * 20)
                end
            end
            
            local shoulderPos = (upperTorso.CFrame * CFrame.new(-1, 0.5, 0)).Position
            local targetPos = leftHandTarget.Position
            local armVector = targetPos - shoulderPos
            
            for i = 1, armTrailLength do
                local segmentPos = shoulderPos + armVector * (i / armTrailLength)
                local segmentLook = (i < armTrailLength) and 
                    (shoulderPos + armVector * ((i + 1) / armTrailLength) - segmentPos).Unit or 
                    armVector.Unit
                
                local segmentCF = CFrame.new(segmentPos, segmentPos + segmentLook)
                leftTrailPositions[i] = leftTrailPositions[i]:Lerp(segmentCF, armSmoothing)
                leftTrailParts[i].CFrame = leftTrailPositions[i]
            end
            
            if leftTrailParts[armTrailLength] then
                leftHand.CFrame = leftTrailPositions[armTrailLength]
                leftHand.Velocity = Vector3.new(0, 0, 0)
                leftHand.Transparency = 0
            end
            
            local rightHandPosition
            local rightHandTarget
            
            if rightGrabbing and rightGrabTarget and rightGrabTarget.Parent then
                rightHandTarget = rightGrabTarget.CFrame * rightGrabOffset
                rightHand.Velocity = Vector3.new(0, 0, 0)
            else
                local shoulderPos = upperTorso.CFrame * CFrame.new(1, 0.5, 0)
                local rayParams = RaycastParams.new()
                rayParams.FilterDescendantsInstances = {originalChar, cloned()}
                rayParams.FilterType = Enum.RaycastFilterType.Exclude
                
                local raycastResult = workspace:Raycast(ray.Origin, ray.Direction * maxGrabDistance, rayParams)
                
                if raycastResult then
                    rightHandTarget = CFrame.new(raycastResult.Position)
                else
                    rightHandTarget = CFrame.new(ray.Origin + ray.Direction * 20)
                end
            end
            
            local shoulderPos = (upperTorso.CFrame * CFrame.new(1, 0.5, 0)).Position
            local targetPos = rightHandTarget.Position
            local armVector = targetPos - shoulderPos
            
            for i = 1, armTrailLength do
                local segmentPos = shoulderPos + armVector * (i / armTrailLength)
                local segmentLook = (i < armTrailLength) and 
                    (shoulderPos + armVector * ((i + 1) / armTrailLength) - segmentPos).Unit or 
                    armVector.Unit
                
                local segmentCF = CFrame.new(segmentPos, segmentPos + segmentLook)
                rightTrailPositions[i] = rightTrailPositions[i]:Lerp(segmentCF, armSmoothing)
                rightTrailParts[i].CFrame = rightTrailPositions[i]
            end
            
            if rightTrailParts[armTrailLength] then
                rightHand.CFrame = rightTrailPositions[armTrailLength]
                rightHand.Velocity = Vector3.new(0, 0, 0)
                rightHand.Transparency = 0
            end
            
            if leftUpperArm and leftUpperArm ~= leftHand then leftUpperArm.Transparency = 0 end
            if rightUpperArm and rightUpperArm ~= rightHand then rightUpperArm.Transparency = 0 end
            if leftLowerArm and leftLowerArm ~= leftHand then leftLowerArm.Transparency = 0 end
            if rightLowerArm and rightLowerArm ~= rightHand then rightLowerArm.Transparency = 0 end
        end)

        ropeConnection = grabConnection
        
        local oldInputBegan = inputBeganConn
        local oldInputEnded = inputEndedConn
        
        ropeConnection = {
            Disconnect = function()
                if grabConnection then grabConnection:Disconnect() end
                if oldInputBegan then oldInputBegan:Disconnect() end
                if oldInputEnded then oldInputEnded:Disconnect() end
                
                for _, part in ipairs(leftTrailParts) do
                    part:Destroy()
                end
                for _, part in ipairs(rightTrailParts) do
                    part:Destroy()
                end
                
                local trailFolder = workspace:FindFirstChild("CelesteTrailParts")
                if trailFolder then
                    trailFolder:Destroy()
                end
            end
        }
        
        isReanimated = true
    else
        if ropeConnection then
            if typeof(ropeConnection) == "table" and ropeConnection.Disconnect then
                ropeConnection:Disconnect()
            elseif typeof(ropeConnection) == "RBXScriptConnection" then
                ropeConnection:Disconnect()
            end
            ropeConnection = nil
        end
        
        unragdoll()
        if cloned() then
            unclone()
        end
        isReanimated = false
    end
end)

ui:AddToggle(sections.reanimPresets, "Orbit", false, function(value)
    if value then
        if isReanimated then
            log("Already reanimated. Returning...")
            return
        end
        
        if cloned() then
            log("Already cloned, using existing clone")
        else
            log("Creating clone for orbit effect")
            clone()
        end

        Player.Character = cloned()
        Camera.CameraSubject = Player.Character.Humanoid
        animate()
        
        local originalChar = getchar()
        if not originalChar then
            ui:CreateNotification("Error", "Original character not found", 3, "error")
            return
        end
        
        ragdoll()
        
        local head = originalChar:FindFirstChild("Head")
        if not head then
            ui:CreateNotification("Error", "Head not found", 3, "error")
            return
        end
        
        local orbitRadius = 3    
        local orbitSpeed = 0.5   
        local limbOffsets = {}   
        local limbCurrentPositions = {} 
        local limbTweenSpeeds = {}  
        local headCurrentPosition
        local headTweenSpeed = 0.01
        
        for _, part in pairs(originalChar:GetChildren()) do
            if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" and part.Name ~= "Head" then
                limbOffsets[part] = {
                    radius = orbitRadius * (0.75 + math.random() * 0.5),
                    speedX = orbitSpeed * (0.6 + math.random() * 0.8),
                    speedY = orbitSpeed * (0.6 + math.random() * 0.8),
                    speedZ = orbitSpeed * (0.6 + math.random() * 0.8),
                    phaseX = math.random() * math.pi * 2,
                    phaseY = math.random() * math.pi * 2,
                    phaseZ = math.random() * math.pi * 2
                }
                
                limbCurrentPositions[part] = part.CFrame
                limbTweenSpeeds[part] = 0.0025 + (math.random() * 0.008)
            end
        end
        
        headCurrentPosition = head.CFrame
        
        local startTime = os.clock()
        orbitConnection = RunService.Heartbeat:Connect(function()
            local elapsedTime = os.clock() - startTime
            
            local cloneHRP = cloned():FindFirstChild("HumanoidRootPart")
            local originalHRP = originalChar:FindFirstChild("HumanoidRootPart")
            local cloneHead = cloned():FindFirstChild("Head")
            
            if cloneHRP and originalHRP then
                originalHRP.CFrame = cloneHRP.CFrame
                originalHRP.Velocity = Vector3.new(0, 0, 0)
            end
            
            if cloneHead and head then
                headCurrentPosition = headCurrentPosition:Lerp(cloneHead.CFrame, headTweenSpeed)
                head.CFrame = headCurrentPosition
                head.Velocity = Vector3.new(0, 0, 0)
                head.RotVelocity = Vector3.new(0, 0, 0)
            end
            
            for part, offset in pairs(limbOffsets) do
                if part:IsA("BasePart") then
                    local xPos = math.sin(elapsedTime * offset.speedX + offset.phaseX) * offset.radius
                    local yPos = math.sin(elapsedTime * offset.speedY + offset.phaseY) * offset.radius
                    local zPos = math.cos(elapsedTime * offset.speedZ + offset.phaseZ) * offset.radius
                    
                    local targetCFrame = head.CFrame * CFrame.new(xPos, yPos, zPos)
                    
                    limbCurrentPositions[part] = limbCurrentPositions[part]:Lerp(targetCFrame, limbTweenSpeeds[part])
                    
                    part.CFrame = limbCurrentPositions[part]
                    
                    part.Velocity = Vector3.new(0, 0, 0)
                    part.RotVelocity = Vector3.new(0, 0, 0)
                end
            end
        end)
        isReanimated = true
    else
        if orbitConnection then
            orbitConnection:Disconnect()
            orbitConnection = nil
        end
        
        unragdoll()
        
        if cloned() then
            unclone()
        end
        isReanimated = false
    end
end)
ui:AddToggle(sections.reanimPresets, "Noodle Arms", false, function(value)
    if value then
        if isReanimated then
            log("Already reanimated. Returning...")
            return
        end
        
        if cloned() then
            log("Already cloned, using existing clone")
        else
            log("Creating clone...")
            clone()
        end

        Player.Character = cloned()
        Camera.CameraSubject = Player.Character.Humanoid
        animate()

        local originalChar = getchar()
        if not originalChar then
            ui:CreateNotification("Error", "Original character not found", 3, "error")
            return
        end
        
        ragdoll()
        
        local armParts = {}
        
        if originalChar:FindFirstChild("UpperTorso") then
            local leftArmParts = {
                originalChar:FindFirstChild("LeftUpperArm"),
                originalChar:FindFirstChild("LeftLowerArm"),
                originalChar:FindFirstChild("LeftHand")
            }
            
            local rightArmParts = {
                originalChar:FindFirstChild("RightUpperArm"),
                originalChar:FindFirstChild("RightLowerArm"),
                originalChar:FindFirstChild("RightHand")
            }
            
            for _, part in ipairs(leftArmParts) do
                if part then table.insert(armParts, part) end
            end
            
            for _, part in ipairs(rightArmParts) do
                if part then table.insert(armParts, part) end
            end
        end
        
        if #armParts == 0 then
            ui:CreateNotification("Error", "No arm parts found", 3, "error")
            return
        end
        
        local lastCharPos = Vector3.new(0, 0, 0)
        
        local noodleConnection = RunService.Heartbeat:Connect(function()
            local cloneHRP = cloned():FindFirstChild("HumanoidRootPart")
            local originalHRP = originalChar:FindFirstChild("HumanoidRootPart")
            
            if cloneHRP and originalHRP then
                originalHRP.CFrame = cloneHRP.CFrame
                originalHRP.Velocity = Vector3.new(0, 0, 0)
            end
            
            local currentCharPos = cloneHRP and cloneHRP.Position or Vector3.new(0, 0, 0)
            local moveVector = currentCharPos - lastCharPos
            lastCharPos = currentCharPos
            
            local moveSpeed = moveVector.Magnitude
            local moveDir = moveVector.Magnitude > 0.01 and moveVector.Unit or Vector3.new(0, 0, 0)
            
            local head = originalChar:FindFirstChild("Head")
            local upperTorso = originalChar:FindFirstChild("UpperTorso") or originalChar:FindFirstChild("Torso")
            local lowerTorso = originalChar:FindFirstChild("LowerTorso")
            
            if head and cloned():FindFirstChild("Head") then
                head.CFrame = cloned():FindFirstChild("Head").CFrame
                head.Velocity = Vector3.new(0, 0, 0)
            end
            
            if upperTorso and cloned():FindFirstChild(upperTorso.Name) then
                upperTorso.CFrame = cloned():FindFirstChild(upperTorso.Name).CFrame
                upperTorso.Velocity = Vector3.new(0, 0, 0)
            end
            
            if lowerTorso and cloned():FindFirstChild(lowerTorso.Name) then
                lowerTorso.CFrame = cloned():FindFirstChild(lowerTorso.Name).CFrame
                lowerTorso.Velocity = Vector3.new(0, 0, 0)
            end
            
            local leftLegParts = {"LeftUpperLeg", "LeftLowerLeg", "LeftFoot", "Left Leg"}
            local rightLegParts = {"RightUpperLeg", "RightLowerLeg", "RightFoot", "Right Leg"}
            
            for _, legName in ipairs(leftLegParts) do
                local part = originalChar:FindFirstChild(legName)
                local clonePart = cloned():FindFirstChild(legName)
                if part and clonePart then
                    part.CFrame = clonePart.CFrame
                    part.Velocity = Vector3.new(0, 0, 0)
                end
            end
            
            for _, legName in ipairs(rightLegParts) do
                local part = originalChar:FindFirstChild(legName)
                local clonePart = cloned():FindFirstChild(legName)
                if part and clonePart then
                    part.CFrame = clonePart.CFrame
                    part.Velocity = Vector3.new(0, 0, 0)
                end
            end
            
            for _, armPart in ipairs(armParts) do
                local currentVel = armPart.Velocity
                
                local dampingFactor = 0.95
                
                local trailForce = Vector3.new(0, 0, 0)
                if moveSpeed > 0.1 then
                    trailForce = -moveDir * math.min(moveSpeed * 2, 30)
                end
                
                local gravityEffect = Vector3.new(0, -0.5, 0)

                local targetVel = Vector3.new(
                    currentVel.X * dampingFactor + trailForce.X,
                    currentVel.Y * dampingFactor + gravityEffect.Y,
                    currentVel.Z * dampingFactor + trailForce.Z
                )
                
                armPart.Velocity = targetVel
                
                local rotDampingFactor = 0.1
                local currentRotVel = armPart.RotVelocity
                
                local randomRot = Vector3.new(
                    math.random(-10, 10) * 0.1,
                    math.random(-10, 10) * 0.1,
                    math.random(-10, 10) * 0.1
                )
                
                armPart.RotVelocity = currentRotVel * rotDampingFactor + randomRot
            end
        end)
        
        orbitConnection = noodleConnection
        isReanimated = true
    else
        if orbitConnection then
            orbitConnection:Disconnect()
            orbitConnection = nil
        end
        
        unragdoll()
        if cloned() then
            unclone()
        end
        isReanimated = false
    end
end)
ui:AddToggle(sections.reanimPresets, "Snake", false, function(value)
    if value then
        if isReanimated then
            log("Already reanimated. Returning...")
            return
        end
        
        if cloned() then
            log("Already cloned, using existing clone")
        else
            log("Creating clone...")
            clone()
        end

        Player.Character = cloned()
        Camera.CameraSubject = Player.Character.Humanoid
        animate()

        local originalChar = getchar()
        if not originalChar then
            ui:CreateNotification("Error", "Original character not found", 3, "error")
            return
        end
        
        ragdoll()
        
        local head = originalChar:FindFirstChild("Head")
        local torso = originalChar:FindFirstChild("UpperTorso") or originalChar:FindFirstChild("Torso")
        if not head or not torso then
            ui:CreateNotification("Error", "Required body parts not found", 3, "error")
            return
        end
        
        local bodyParts = {}
        local partPositions = {}
        local tweenSpeeds = {}
        
        local function findR15Parts()
            local parts = {
                head,
                originalChar:FindFirstChild("UpperTorso"),
                originalChar:FindFirstChild("LowerTorso"),
                originalChar:FindFirstChild("LeftUpperArm"),
                originalChar:FindFirstChild("LeftLowerArm"),
                originalChar:FindFirstChild("LeftHand"),
                originalChar:FindFirstChild("RightUpperArm"),
                originalChar:FindFirstChild("RightLowerArm"),
                originalChar:FindFirstChild("RightHand"),
                originalChar:FindFirstChild("LeftUpperLeg"),
                originalChar:FindFirstChild("LeftLowerLeg"),
                originalChar:FindFirstChild("LeftFoot"),
                originalChar:FindFirstChild("RightUpperLeg"),
                originalChar:FindFirstChild("RightLowerLeg"),
                originalChar:FindFirstChild("RightFoot")
            }
            
            for i = #parts, 1, -1 do
                if not parts[i] then
                    table.remove(parts, i)
                end
            end
            
            return parts
        end
        
        local function findR6Parts()
            local parts = {
                head,
                originalChar:FindFirstChild("Torso"),
                originalChar:FindFirstChild("Left Arm"),
                originalChar:FindFirstChild("Right Arm"),
                originalChar:FindFirstChild("Left Leg"),
                originalChar:FindFirstChild("Right Leg")
            }
            
            for i = #parts, 1, -1 do
                if not parts[i] then
                    table.remove(parts, i)
                end
            end
            
            return parts
        end
        
        bodyParts = originalChar:FindFirstChild("UpperTorso") and findR15Parts() or findR6Parts()
        
        for i, part in ipairs(bodyParts) do
            partPositions[part] = part.CFrame
            
            local speedFactor = 1 - ((i-1) / (#bodyParts-1)) * 0.97
            tweenSpeeds[part] = 0.05 * speedFactor
        end
        
        local headTweenSpeed = 0.08
        
        ropeConnection = RunService.Heartbeat:Connect(function()
            local cloneHRP = cloned():FindFirstChild("HumanoidRootPart")
            local originalHRP = originalChar:FindFirstChild("HumanoidRootPart")
            local cloneHead = cloned():FindFirstChild("Head")
            
            if cloneHRP and originalHRP then
                originalHRP.CFrame = cloneHRP.CFrame
                originalHRP.Velocity = Vector3.new(0, 0, 0)
            end
            
            if #bodyParts > 0 then
                if cloneHead and bodyParts[1] then
                    partPositions[bodyParts[1]] = partPositions[bodyParts[1]]:Lerp(cloneHead.CFrame, headTweenSpeed)
                    bodyParts[1].CFrame = partPositions[bodyParts[1]]
                    bodyParts[1].Velocity = Vector3.new(0, 0, 0)
                    bodyParts[1].RotVelocity = Vector3.new(0, 0, 0)
                end
                
                for i = 2, #bodyParts do
                    local prevPart = bodyParts[i-1]
                    local currentPart = bodyParts[i]
                    
                    local offset = (currentPart.Size.Y + prevPart.Size.Y) * 0.6
                    local targetPos = prevPart.CFrame * CFrame.new(0, 0, offset)
                    
                    partPositions[currentPart] = partPositions[currentPart]:Lerp(targetPos, tweenSpeeds[currentPart])
                    currentPart.CFrame = partPositions[currentPart]
                    
                    currentPart.Velocity = Vector3.new(0, 0, 0)
                    currentPart.RotVelocity = Vector3.new(0, 0, 0)
                end
            end
        end)
        isReanimated = true
    else
        if ropeConnection then
            ropeConnection:Disconnect()
            ropeConnection = nil
        end
        
        unragdoll()
        if cloned() then
            unclone()
        end
        isReanimated = false
    end
end)
ui:AddToggle(sections.reanimPresets, "Annoy", false, function(value)
    if value then
        if isReanimated then
            log("Already reanimated. Returning...")
            return
        end
        
        if cloned() then
            log("Already cloned, using existing clone")
        else
            log("Creating clone...")
            clone()
        end

        Player.Character = cloned()
        Camera.CameraSubject = Player.Character.Humanoid
        animate()

        local originalChar = getchar()
        if not originalChar then
            ui:CreateNotification("Error", "Original character not found", 3, "error")
            return
        end
        
        ragdoll()
        
        local limbs = {}
        
        for _, part in pairs(originalChar:GetChildren()) do
            if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" and part.Name ~= "Head" then
                table.insert(limbs, part)
            end
        end
        
        local function getOtherPlayers()
            local otherPlayers = {}
            for _, p in pairs(Players:GetPlayers()) do
                if p ~= Player and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                    table.insert(otherPlayers, p)
                end
            end
            return otherPlayers
        end
        
        local function assignLimbsToPlayers()
            local otherPlayers = getOtherPlayers()
            local assignments = {}
            
            if #otherPlayers < 1 then
                ui:CreateNotification("Warning", "Not enough players to annoy!", 3, "warning")
                return {}
            end
            
            local availablePlayers = {}
            for _, p in ipairs(otherPlayers) do
                table.insert(availablePlayers, p)
            end
            
            for _, limb in ipairs(limbs) do
                if #availablePlayers == 0 then
                    for _, p in ipairs(otherPlayers) do
                        table.insert(availablePlayers, p)
                    end
                end
                
                local randomIndex = math.random(1, #availablePlayers)
                local targetPlayer = availablePlayers[randomIndex]
                
                assignments[limb] = targetPlayer
                
                table.remove(availablePlayers, randomIndex)
            end
            
            return assignments
        end
        
        local limbAssignments = assignLimbsToPlayers()
        
        local teleportCooldown = 0.2
        local lastTeleportTime = 0
        local heightOffsets = {}
        
        for limb, _ in pairs(limbAssignments) do
            heightOffsets[limb] = math.random(-2, 2)
        end
        
        annoyConnection = RunService.Heartbeat:Connect(function()
            local currentTime = os.clock()
            local cloneHRP = cloned():FindFirstChild("HumanoidRootPart")
            local originalHRP = originalChar:FindFirstChild("HumanoidRootPart")
            
            if cloneHRP and originalHRP then
                originalHRP.CFrame = cloneHRP.CFrame
                originalHRP.Velocity = Vector3.new(0, 0, 0)
            end
            
            if currentTime - lastTeleportTime >= teleportCooldown then
                limbAssignments = assignLimbsToPlayers()
                
                for limb, _ in pairs(limbAssignments) do
                    heightOffsets[limb] = math.random(-2, 2)
                end
                
                lastTeleportTime = currentTime
            end
            
            for limb, targetPlayer in pairs(limbAssignments) do
                if limb and limb:IsA("BasePart") and targetPlayer.Character then
                    local targetHRP = targetPlayer.Character:FindFirstChild("HumanoidRootPart")
                    
                    if targetHRP then
                        local randX = math.random(-20, 20) / 10
                        local randZ = math.random(-20, 20) / 10
                        local targetPos = targetHRP.Position + Vector3.new(randX, heightOffsets[limb], randZ)
                        
                        limb.CFrame = CFrame.new(targetPos, targetPos + targetHRP.CFrame.LookVector)
                        limb.Velocity = Vector3.new(0, 0, 0)
                        limb.RotVelocity = Vector3.new(0, 0, 0)
                    end
                end
            end
        end)
        isReanimated = true
    else
        if annoyConnection then
            annoyConnection:Disconnect()
            annoyConnection = nil
        end
        
        unragdoll()
        if cloned() then
            unclone()
        end
        isReanimated = false
    end
end)

ui:AddToggle(sections.reanimPresets, "Pole", false, function(value)
    if value then
        if isReanimated then
            log("Already reanimated. Returning...")
            return
        end
        
        if cloned() then
            log("Already cloned, using existing clone")
        else
            log("Creating clone...")
            clone()
        end

        Player.Character = cloned()
        Camera.CameraSubject = Player.Character.Humanoid
        animate()

        local originalChar = getchar()
        if not originalChar then
            ui:CreateNotification("Error", "Original character not found", 3, "error")
            return
        end
        
        ragdoll()
        
        local head = originalChar:FindFirstChild("Head")
        local torso = originalChar:FindFirstChild("UpperTorso") or originalChar:FindFirstChild("Torso")
        if not head or not torso then
            ui:CreateNotification("Error", "Required body parts not found", 3, "error")
            return
        end
        
        local bodyParts = {}
        local partPositions = {}
        local tweenSpeeds = {}
        
        local function findR15Parts()
            local parts = {
                head,
                originalChar:FindFirstChild("UpperTorso"),
                originalChar:FindFirstChild("LowerTorso"),
                originalChar:FindFirstChild("LeftUpperArm"),
                originalChar:FindFirstChild("LeftLowerArm"),
                originalChar:FindFirstChild("LeftHand"),
                originalChar:FindFirstChild("RightUpperArm"),
                originalChar:FindFirstChild("RightLowerArm"),
                originalChar:FindFirstChild("RightHand"),
                originalChar:FindFirstChild("LeftUpperLeg"),
                originalChar:FindFirstChild("LeftLowerLeg"),
                originalChar:FindFirstChild("LeftFoot"),
                originalChar:FindFirstChild("RightUpperLeg"),
                originalChar:FindFirstChild("RightLowerLeg"),
                originalChar:FindFirstChild("RightFoot")
            }
            
            for i = #parts, 1, -1 do
                if not parts[i] then
                    table.remove(parts, i)
                end
            end
            
            return parts
        end
        
        local function findR6Parts()
            local parts = {
                head,
                originalChar:FindFirstChild("Torso"),
                originalChar:FindFirstChild("Left Arm"),
                originalChar:FindFirstChild("Right Arm"),
                originalChar:FindFirstChild("Left Leg"),
                originalChar:FindFirstChild("Right Leg")
            }
            
            for i = #parts, 1, -1 do
                if not parts[i] then
                    table.remove(parts, i)
                end
            end
            
            return parts
        end
        
        bodyParts = originalChar:FindFirstChild("UpperTorso") and findR15Parts() or findR6Parts()
        
        for i, part in ipairs(bodyParts) do
            partPositions[part] = part.CFrame
            local speedFactor = 1 - ((i-1) / (#bodyParts-1)) * 0.8
            tweenSpeeds[part] = 0.1 * speedFactor
        end

        local headTweenSpeed = 0.15
        
        poleConnection = RunService.Heartbeat:Connect(function()
            local cloneHRP = cloned():FindFirstChild("HumanoidRootPart")
            local originalHRP = originalChar:FindFirstChild("HumanoidRootPart")
            local cloneHead = cloned():FindFirstChild("Head")
            
            if cloneHRP and originalHRP then
                originalHRP.CFrame = cloneHRP.CFrame
                originalHRP.Velocity = Vector3.new(0, 0, 0)
            end
            
            if #bodyParts > 0 then
                if cloneHead and bodyParts[1] then
                    partPositions[bodyParts[1]] = partPositions[bodyParts[1]]:Lerp(cloneHead.CFrame, headTweenSpeed)
                    bodyParts[1].CFrame = partPositions[bodyParts[1]]
                    bodyParts[1].Velocity = Vector3.new(0, 0, 0)
                    bodyParts[1].RotVelocity = Vector3.new(0, 0, 0)
                end
                
                for i = 2, #bodyParts do
                    local prevPart = bodyParts[i-1]
                    local currentPart = bodyParts[i]
                    
                    local offset = (currentPart.Size.Y + prevPart.Size.Y) * 0.6
                    local targetPos = prevPart.CFrame * CFrame.new(0, offset, 0)
                    
                    partPositions[currentPart] = partPositions[currentPart]:Lerp(targetPos, tweenSpeeds[currentPart])
                    currentPart.CFrame = partPositions[currentPart]
                    
                    currentPart.Velocity = Vector3.new(0, 0, 0)
                    currentPart.RotVelocity = Vector3.new(0, 0, 0)
                end
            end
        end)
        isReanimated = true
    else
        if poleConnection then
            poleConnection:Disconnect()
            poleConnection = nil
        end
        
        unragdoll()
        if cloned() then
            unclone()
        end
        isReanimated = false
    end
end)

ui:AddToggle(sections.reanimPresets, "Circle", false, function(value)
    if value then
        if isReanimated then
            log("Already reanimated. Returning...")
            return
        end
        
        if cloned() then
            log("Already cloned, using existing clone")
        else
            log("Creating clone...")
            clone()
        end

        Player.Character = cloned()
        Camera.CameraSubject = Player.Character.Humanoid
        animate()

        local originalChar = getchar()
        if not originalChar then
            ui:CreateNotification("Error", "Original character not found", 3, "error")
            return
        end
        
        ragdoll()
        
        local bodyParts = {}
        
        for _, part in pairs(originalChar:GetChildren()) do
            if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                table.insert(bodyParts, part)
            end
        end
        
        local cloneHRP = cloned():FindFirstChild("HumanoidRootPart")
        if not cloneHRP then
            ui:CreateNotification("Error", "HumanoidRootPart not found on clone", 3, "error")
            return
        end
        
        local radius = 5
        local rotationSpeed = 1
        local partAngleOffsets = {}
        
        for i, part in ipairs(bodyParts) do
            local angleOffset = (2 * math.pi / #bodyParts) * (i - 1)
            partAngleOffsets[part] = angleOffset
        end
        
        local startTime = os.clock()
        
        circleConnection = RunService.Heartbeat:Connect(function()
            local elapsedTime = os.clock() - startTime
            local currentHRP = cloned():FindFirstChild("HumanoidRootPart")
            local originalHRP = originalChar:FindFirstChild("HumanoidRootPart")
            
            if currentHRP and originalHRP then
                originalHRP.CFrame = currentHRP.CFrame
                originalHRP.Velocity = Vector3.new(0, 0, 0)
            end
            
            for part, angleOffset in pairs(partAngleOffsets) do
                if part and part:IsA("BasePart") then
                    local angle = elapsedTime * rotationSpeed + angleOffset
                    local xPos = math.cos(angle) * radius
                    local zPos = math.sin(angle) * radius
                    
                    local targetCFrame = currentHRP.CFrame * CFrame.new(xPos, 0, zPos)
                    
                    local lookVector = (currentHRP.Position - targetCFrame.Position).Unit
                    targetCFrame = CFrame.new(targetCFrame.Position, currentHRP.Position)
                    
                    part.CFrame = targetCFrame
                    part.Velocity = Vector3.new(0, 0, 0)
                    part.RotVelocity = Vector3.new(0, 0, 0)
                end
            end
        end)
        isReanimated = true
    else
        if circleConnection then
            circleConnection:Disconnect()
            circleConnection = nil
        end
        
        unragdoll()
        if cloned() then
            unclone()
        end
        isReanimated = false
    end
end)

--[[ VOICE TAB ]]--
--[[ SETTINGS ]]--
ui:AddToggle(sections.voiceSettings, "Auto Unsuspend", false, function(value)
    if value then
        autoConnection = VoiceChatInternal.LocalPlayerModerated:Connect(function()
            task.wait(5)
            pcall(function()
                local groupId = VoiceChatInternal:GetGroupId()
                if groupId then
                    VoiceChatInternal:JoinByGroupId(groupId, false)
                end
            end)
            
            pcall(function()
                local groupId = VoiceChatInternal:GetGroupId()
                if groupId then
                    VoiceChatInternal:JoinByGroupIdToken(groupId, false, true)
                end
            end)
        end)
    else
        if autoConnection then
            autoConnection:Disconnect()
            autoConnection = nil
        end
    end
end)

ui:AddButton(sections.voiceSettings, "Unsuspend", function()
    local groupId = VoiceChatInternal:GetGroupId()
    AudioFocusService:RegisterContextIdFromLua(100)
    task.wait()
    AudioFocusService:RequestFocus(100, 9999999)
    VoiceChatService:joinVoice()
    VoiceChatService:rejoinVoice()
    VoiceChatInternal:JoinByGroupId(groupId, false)
    VoiceChatInternal:JoinByGroupIdToken(groupId, false, true)
    VoiceChatService:joinVoice()
end)

ui:AddButton(sections.voiceSettings, "Force Priority", function()
    AudioFocusService:RegisterContextIdFromLua(100)
    task.wait()
    AudioFocusService:RequestFocus(100, 9999999)
end)

ui:AddButton(sections.voiceSettings, "Leave Voice Channel", function()
    VoiceChatInternal:Leave()
    VoiceChatInternal:PublishPause(true)
end)

--[[ VISUALS TAB ]]--
local defaultFOV = Camera.FieldOfView
local Settings = {
    ZoomTime     = 0.2,
    ZoomedAmount = 10,
}

local zoomActive = false
local zoomInConn, zoomOutConn

local function createZoom(time, amount)
    return TweenService:Create(Camera, TweenInfo.new(time, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
        FieldOfView = amount
    })
end

local cinematicConn
local smoothing     = 5
local lastCameraPos = Camera.CFrame.Position

ui:AddSlider(sections.visualsCamera, "FOV", 1, 120, Settings.ZoomedAmount, function(value)
    Camera.FieldOfView = value
end)

ui:AddToggle(sections.visualsCamera, "Optifine Zoom (C)", false, function(enabled)
    zoomActive = enabled

    if enabled then
        defaultFOV = Camera.FieldOfView

        zoomInConn = UserInputService.InputBegan:Connect(function(input, gpe)
            if not gpe and input.KeyCode == Enum.KeyCode.C then
                createZoom(Settings.ZoomTime, Settings.ZoomedAmount):Play()
            end
        end)

        zoomOutConn = UserInputService.InputEnded:Connect(function(input, gpe)
            if not gpe and input.KeyCode == Enum.KeyCode.C then
                createZoom(Settings.ZoomTime, defaultFOV):Play()
            end
        end)
    else
        if zoomInConn then zoomInConn:Disconnect() end
        if zoomOutConn then zoomOutConn:Disconnect() end
        Camera.FieldOfView = defaultFOV
    end
end)

local smoothing     = 5
local lastCameraPos = Camera.CFrame.Position
local CINEMATIC_STEP_NAME = "CinematicCam"

ui:AddToggle(sections.visualsCamera, "Cinematic Camera", false, function(enabled)
    if enabled then
        lastCameraPos = Camera.CFrame.Position

        RunService:BindToRenderStep(
            CINEMATIC_STEP_NAME,
            Enum.RenderPriority.Camera.Value,
            function(dt)
                local cf    = Camera.CFrame
                local alpha = math.clamp(smoothing * dt, 0, 1)
                lastCameraPos = lastCameraPos:Lerp(cf.Position, alpha)
                Camera.CFrame = CFrame.new(lastCameraPos, lastCameraPos + cf.LookVector)
            end
        )
    else
        RunService:UnbindFromRenderStep(CINEMATIC_STEP_NAME)
    end
end)



loadstring(game:HttpGet("https://gist.githubusercontent.com/lolFederal/409ea6142b02128d8d7b94ab3cad6fd4/raw/a1ffeec87beefe4d8993aa5c5f55df5b18c56ed6/ESPLibrary.lua"))()

-- [[ ESP CONTROLS ]]--
ui:AddToggle(sections.visualsESP, "Enable ESP", false, function(value)
    getgenv().ToggleESP(value)
end)

ui:AddLabel(sections.visualsESP, "Color Settings")

ui:AddDropdown(sections.visualsESP, "ESP Color", {
    "White", 
    "Pastel Red", 
    "Pastel Green", 
    "Pastel Blue", 
    "Pastel Yellow", 
    "Lavender", 
    "Mint", 
    "Coral", 
    "Sky Blue"
}, "White", function(option)
    local colors = {
        White = Color3.fromRGB(255, 255, 255),
        ["Pastel Red"] = Color3.fromRGB(255, 179, 186),
        ["Pastel Green"] = Color3.fromRGB(186, 255, 201),
        ["Pastel Blue"] = Color3.fromRGB(186, 225, 255),
        ["Pastel Yellow"] = Color3.fromRGB(255, 255, 186),
        Lavender = Color3.fromRGB(220, 208, 255),
        Mint = Color3.fromRGB(170, 255, 228),
        Coral = Color3.fromRGB(255, 204, 170),
        ["Sky Blue"] = Color3.fromRGB(173, 216, 230)
    }
    
    getgenv().SetColor(colors[option])
end)

ui:AddSlider(sections.visualsESP, "Global Transparency", 0, 1, 1.0, function(value)
    getgenv().SetTransparency(value)
end)

ui:AddLabel(sections.visualsESP, "Box ESP Settings")

ui:AddDropdown(sections.visualsESP, "Box Style", {"None", "2D", "3D", "2DCorner", "3DCorner"}, "3DCorner", function(option)
    getgenv().SetBoxType(option)
end)

ui:AddSlider(sections.visualsESP, "Box Thickness", 0.5, 5, 1.0, function(value)
    getgenv().SetThickness(value)
end)

ui:AddSlider(sections.visualsESP, "Corner Size", 0.1, 0.5, 0.3, function(value)
    getgenv().SetCornerSize(value)
end)

ui:AddLabel(sections.visualsESP, "Tracer Settings")

ui:AddToggle(sections.visualsESP, "Show Tracers", false, function(value)
    getgenv().ToggleTracers(value)
end)

ui:AddDropdown(sections.visualsESP, "Tracer Origin", {"Bottom", "Top", "Center", "Mouse"}, "Bottom", function(option)
    getgenv().SetTracerOrigin(option)
end)

ui:AddSlider(sections.visualsESP, "Tracer Thickness", 0.5, 5, 1.0, function(value)
    getgenv().SetTracerThickness(value)
end)

ui:AddLabel(sections.visualsESP, "Skeleton Settings")

ui:AddToggle(sections.visualsESP, "Show Skeletons", false, function(value)
    getgenv().ToggleSkeleton(value)
end)

ui:AddSlider(sections.visualsESP, "Skeleton Thickness", 0.5, 5, 1.0, function(value)
    getgenv().SetSkeletonThickness(value)
end)

ui:AddSlider(sections.visualsESP, "Skeleton Transparency", 0, 1, 1.0, function(value)
    getgenv().SetSkeletonTransparency(value)
end)

--[[ RAIN ]]--
local Rain = loadstring(game:HttpGet("https://raw.githubusercontent.com/buildthomas/Rain/refs/heads/master/src/Rain.lua"))()

ui:AddToggle(sections.visualsRain, "Toggle Rain", false, function(value)
    if value then
        Rain:Enable(TweenInfo.new(2, Enum.EasingStyle.Linear, Enum.EasingDirection.Out))
    else
        Rain:Disable(TweenInfo.new(2, Enum.EasingStyle.Linear, Enum.EasingDirection.Out))
    end
end)

ui:AddSlider(sections.visualsRain, "Rain Intensity", 0, 1, 0, function(value) 
    Rain:SetIntensityRatio(value)
end)

ui:AddSlider(sections.visualsRain, "Rain Volume", 0, 100, 0.8, function(value) 
    Rain:SetVolume(value)
end)

ui:AddSlider(sections.visualsRain, "Rain Transparency", 0, 1, 0, function(value) 
    Rain:SetTransparency(value)
end)

--[[ TIME ]]--
ui:AddToggle(sections.visualsTime, "Custom Time", false, function(value)
    CustomTime = value
    if value then
        OldTime = Lighting.ClockTime
        Lighting.ClockTime = SettedTime
    else
        Lighting.ClockTime = OldTime
    end
end)

ui:AddSlider(sections.visualsTime, "Change Time [ Hours ]", 0, 24, 14.5, function(value) 
    if CustomTime then
        SettedTime = value
        Lighting.ClockTime = SettedTime
    else
        SettedTime = value
    end
end)

--[[ MISC TAB ]]--
ui:AddToggle(sections.miscMap, "Void Walk", true, function()
    if not workspace:FindFirstChild("CelesteVoid") then
        local void = Instance.new("Part", workspace)
        void.Anchored = true
        void.Size = Vector3.new(2048, 16, 2048)
        void.Position = Vector3.new(66, -8, 72.5)
        void.Transparency = 1
    else
        workspace:FindFirstChild("CelesteVoid"):Destroy()
    end
end)

--[[ GUI TAB ]]--
local osint, r15Suite
ui:AddButton(sections.guisGui, "Celeste R15 Suite", function()
    r15Suite()
end)
ui:AddButton(sections.guisGui, "Celeste OSINT", function()
    osint()
end)

--[[ ABOUT TAB ]]--
ui:AddLabel(sections.aboutInfo, "Made by Celeste", UI_CONFIG.AccentColor)
ui:AddLabel(sections.aboutInfo, "Version: " .. UI_CONFIG.Version, UI_CONFIG.TextColor)
ui:AddLabel(sections.aboutCredits, "Co-Developed by 3itx", UI_CONFIG.TextColor)

--[[ LARGE FUNCTIONS ]]--
function osint()
    --!nolint BuiltinGlobalWrite
    --!optimize 2
    --!native

    if getconnections then
        if cloneref then
            for _,v in pairs(getconnections(cloneref(game:GetService("LogService")).MessageOut)) do v:Disable() end
            for _,v in pairs(getconnections(cloneref(game:GetService("ScriptContext")).Error)) do v:Disable() end
        else
            for _,v in pairs(getconnections(game:GetService("LogService")).MessageOut) do v:Disable() end
            for _,v in pairs(getconnections(game:GetService("ScriptContext")).Error) do v:Disable() end
        end
        warn("[Celeste OSINT] -> DISCONNECTED ALL CONSOLE CONNECTIONS")
    end

    local function randomHex(len)
        local str = ""
        for i = 1, len do
            str = str .. string.format("%x", math.random(0, 15))
        end
        return str
    end

    local function randstr()
        local uuid = table.concat({
            randomHex(8),
            randomHex(4),
            randomHex(4),
            randomHex(4),
            randomHex(12)
        }, "-")
        return  "HelloSkid_" .. uuid
    end

    local CELESTE_UI_ID = randstr()
    local NOTIFICATIONS_ID = randstr()

    local function getrandstr()
        return randstr()
    end

    sep = string.rep("\n", 200)
    print("                             v LATEST LOGS OF CELESTE ARE BELOW v"..sep.."            > Starting Celeste")
    warn("[Celeste OSINT] -> Starting...")

    local logging = true
    local function log(...)
        if logging then
            warn("[Celeste OSINT] -> " .. ...)
        end
    end
    local function seperate(job)
        if logging then
            print("> "..job)
        end
    end

    log("Logging is enabled.")
    seperate("Protection")

    if hookfunction and newcclosure then
        local originalHttpGet = game.HttpGet
        hookfunction(game.HttpGet, newcclosure(function(self, ...)
            if self == game then
                local url = select(1, ...)
                if url == originalHttpGet then
                    log("HttpGet protection triggered")
                    while true do end
                    return nil
                end
            end
            return originalHttpGet(self, ...)
        end))
        log("Hooked HttpGet.")
    end

    local rawgs = clonefunction and clonefunction(game.GetService) or game.GetService
    function gs(service)
        local ok, result = pcall(function()
            return rawgs(game, service)
        end)
        if ok and result then
            log("Got service '" .. service .. "' successfully")
            return result
        else
            log("Failed to get service '" .. service .. "'")
            return nil
        end
    end

    function define(instance)
        if cloneref then
            local ok, protected = pcall(cloneref, instance)
            if ok and protected then
                log("Protected instance '" .. tostring(instance) .. "' with cloneref")
                return protected
            else
                log("cloneref failed for '" .. tostring(instance) .. "'")
            end
        else
            log("cloneref not available, returning raw instance '" .. tostring(instance) .. "'")
        end
        return instance
    end

    local HttpService = define(gs("HttpService"))
    local TweenService = define(gs("TweenService"))
    local RunService = define(gs("RunService"))
    local UserInputService = define(gs("UserInputService"))
    local Players = define(gs("Players"))
    local player = define(Players.LocalPlayer)

    local httpRequest = syn and syn.request
                or http and http.request
                or request
                or http_request
                or _request
    assert(httpRequest, "No HTTP request function found!")

    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = randstr()
    screenGui.ResetOnSpawn = false
    screenGui.Parent = gethui()

    local COLORS = {
        BACKGROUND = Color3.fromRGB(16, 16, 18),
        CONTAINER = Color3.fromRGB(22, 22, 24),
        CARD = Color3.fromRGB(28, 28, 30),
        CARD_HEADER = Color3.fromRGB(32, 32, 34),
        INPUT_BG = Color3.fromRGB(24, 24, 26),
        ACCENT = Color3.fromRGB(50, 60, 80),
        TEXT_PRIMARY = Color3.fromRGB(230, 230, 230),
        TEXT_SECONDARY = Color3.fromRGB(180, 180, 180),
        SUCCESS = Color3.fromRGB(80, 180, 120),
        ERROR = Color3.fromRGB(220, 70, 70)
    }

    local function createRoundedFrame(properties)
        local frame = Instance.new("Frame")
        for key, value in pairs(properties) do
            frame[key] = value
        end
        
        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, 8)
        corner.Parent = frame
        
        return frame
    end

    local function createStroke(parent, color, thickness)
        local stroke = Instance.new("UIStroke")
        stroke.Color = color
        stroke.Thickness = thickness or 1
        stroke.Transparency = 0.7
        stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        stroke.Parent = parent
        return stroke
    end

    local mainFrame = createRoundedFrame({
        Name = "MainFrame",
        Size = UDim2.new(0, 300, 0, 400),
        Position = UDim2.new(0.5, -190, 0.5, -225),
        BackgroundColor3 = COLORS.BACKGROUND,
        BorderSizePixel = 0
    })
    mainFrame.Parent = screenGui

    local padding = Instance.new("UIPadding")
    padding.PaddingBottom = UDim.new(0, 10)
    padding.Parent = mainFrame

    local topBar = createRoundedFrame({
        Name = "TopBar",
        Size = UDim2.new(1, -20, 0, 40),
        Position = UDim2.new(0, 10, 0, 10),
        BackgroundColor3 = COLORS.CONTAINER,
        BorderSizePixel = 0
    })
    topBar.Parent = mainFrame
    createStroke(topBar, Color3.fromRGB(40, 40, 42), 1)

    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(1, -50, 1, 0)
    titleLabel.Position = UDim2.new(0, 15, 0, 0)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextSize = 14
    titleLabel.TextColor3 = COLORS.TEXT_PRIMARY
    titleLabel.Text = "Celeste OSINT"
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Parent = topBar

    local closeButton = createRoundedFrame({
        Name = "CloseButton",
        Size = UDim2.new(0, 22, 0, 22),
        Position = UDim2.new(1, -30, 0.5, -11),
        BackgroundColor3 = COLORS.ERROR,
        BorderSizePixel = 0
    })
    closeButton.UICorner.CornerRadius = UDim.new(1, 0)
    closeButton.Parent = topBar

    local closeX = Instance.new("TextButton")
    closeX.Size = UDim2.new(1, 0, 1, 0)
    closeX.BackgroundTransparency = 1
    closeX.Font = Enum.Font.GothamBold
    closeX.TextSize = 14
    closeX.TextColor3 = COLORS.TEXT_PRIMARY
    closeX.Text = ""
    closeX.Parent = closeButton

    local searchContainer = createRoundedFrame({
        Name = "SearchContainer",
        Size = UDim2.new(1, -20, 0, 50),
        Position = UDim2.new(0, 10, 0, 60),
        BackgroundColor3 = COLORS.CONTAINER,
        BorderSizePixel = 0
    })
    searchContainer.Parent = mainFrame
    createStroke(searchContainer, Color3.fromRGB(40, 40, 42), 1)

    local searchBg = createRoundedFrame({
        Size = UDim2.new(1, -20, 0, 32),
        Position = UDim2.new(0, 10, 0.5, -16),
        BackgroundColor3 = COLORS.INPUT_BG,
        BorderSizePixel = 0
    })
    searchBg.Parent = searchContainer
    createStroke(searchBg, Color3.fromRGB(45, 45, 50), 1)

    local searchIcon = Instance.new("ImageLabel")
    searchIcon.Size = UDim2.new(0, 16, 0, 16)
    searchIcon.Position = UDim2.new(0, 12, 0.5, -8)
    searchIcon.BackgroundTransparency = 1
    searchIcon.Image = "rbxassetid://3926305904"
    searchIcon.ImageRectOffset = Vector2.new(964, 324)
    searchIcon.ImageRectSize = Vector2.new(36, 36)
    searchIcon.ImageColor3 = COLORS.TEXT_SECONDARY
    searchIcon.Parent = searchBg

    local searchBox = Instance.new("TextBox")
    searchBox.Size = UDim2.new(1, -80, 1, -10)
    searchBox.Position = UDim2.new(0, 36, 0, 5)
    searchBox.BackgroundTransparency = 1
    searchBox.Font = Enum.Font.Gotham
    searchBox.TextSize = 14
    searchBox.TextColor3 = COLORS.TEXT_PRIMARY
    searchBox.PlaceholderText = "Enter username..."
    searchBox.PlaceholderColor3 = Color3.fromRGB(120, 120, 120)
    searchBox.Text = ""
    searchBox.ClearTextOnFocus = false
    searchBox.Parent = searchBg

    local searchBtnGroup = createRoundedFrame({
        Size = UDim2.new(0, 60, 0, 32),
        Position = UDim2.new(1, -60, 0, 0),
        BackgroundColor3 = COLORS.ACCENT,
        BorderSizePixel = 0
    })
    searchBtnGroup.Parent = searchBg

    local searchBtn = Instance.new("TextButton")
    searchBtn.Size = UDim2.new(1, 0, 1, 0)
    searchBtn.BackgroundTransparency = 1
    searchBtn.Font = Enum.Font.GothamBold
    searchBtn.TextSize = 14
    searchBtn.TextColor3 = COLORS.TEXT_PRIMARY
    searchBtn.Text = "Search"
    searchBtn.Parent = searchBtnGroup

    local statusContainer = createRoundedFrame({
        Name = "StatusContainer",
        Size = UDim2.new(1, -20, 0, 36),
        Position = UDim2.new(0, 10, 0, 120),
        BackgroundColor3 = COLORS.CONTAINER,
        BorderSizePixel = 0
    })
    statusContainer.Parent = mainFrame
    createStroke(statusContainer, Color3.fromRGB(40, 40, 42), 1)

    local statusLabel = Instance.new("TextLabel")
    statusLabel.Size = UDim2.new(1, -20, 1, 0)
    statusLabel.Position = UDim2.new(0, 15, 0, 0)
    statusLabel.BackgroundTransparency = 1
    statusLabel.Font = Enum.Font.Gotham
    statusLabel.TextSize = 13
    statusLabel.TextColor3 = COLORS.TEXT_SECONDARY
    statusLabel.Text = "Ready to scan"
    statusLabel.TextXAlignment = Enum.TextXAlignment.Left
    statusLabel.Parent = statusContainer

    local resultsFrame = createRoundedFrame({
        Name = "ResultsFrame",
        Size = UDim2.new(1, -20, 1, -166),
        Position = UDim2.new(0, 10, 0, 166),
        BackgroundColor3 = COLORS.CONTAINER,
        BorderSizePixel = 0
    })
    resultsFrame.Parent = mainFrame
    createStroke(resultsFrame, Color3.fromRGB(40, 40, 42), 1)

    local resultsContainer = Instance.new("ScrollingFrame")
    resultsContainer.Name = "ResultsContainer"
    resultsContainer.Size = UDim2.new(1, -20, 1, -20)
    resultsContainer.Position = UDim2.new(0, 10, 0, 10)
    resultsContainer.BackgroundTransparency = 1
    resultsContainer.BorderSizePixel = 0
    resultsContainer.ScrollBarThickness = 2
    resultsContainer.ScrollBarImageTransparency = 1
    resultsContainer.CanvasSize = UDim2.new(0, 0, 0, 0)
    resultsContainer.AutomaticCanvasSize = Enum.AutomaticSize.Y
    resultsContainer.Parent = resultsFrame

    local listLayout = Instance.new("UIListLayout")
    listLayout.SortOrder = Enum.SortOrder.LayoutOrder
    listLayout.Padding = UDim.new(0, 15)
    listLayout.Parent = resultsContainer

    local padding = Instance.new("UIPadding")
    padding.PaddingLeft = UDim.new(0, 5)
    padding.PaddingRight = UDim.new(0, 5)
    padding.PaddingTop = UDim.new(0, 10)
    padding.PaddingBottom = UDim.new(0, 10)
    padding.Parent = resultsContainer

    local API_KEY = "00c79144cbed79675a5223a7a6241b7256ffedeb"

    local function createSummaryLabel(parent, text, order)
        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(1, 0, 0, 26)
        label.BackgroundTransparency = 1
        label.Font = Enum.Font.Gotham
        label.TextSize = 13
        label.TextColor3 = COLORS.TEXT_PRIMARY
        label.Text = text
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.LayoutOrder = order
        label.Parent = parent
        
        return label
    end

    local function createLeakCard(parent, sourceName, date, fields, row, order)
        local cardContainer = createRoundedFrame({
            Size = UDim2.new(1, 0, 0, 0),
            AutomaticSize = Enum.AutomaticSize.Y,
            BackgroundColor3 = COLORS.CARD,
            LayoutOrder = order
        })
        cardContainer.Parent = parent
        createStroke(cardContainer, Color3.fromRGB(45, 45, 50), 1)
        
        local cardLayout = Instance.new("UIListLayout")
        cardLayout.SortOrder = Enum.SortOrder.LayoutOrder
        cardLayout.Padding = UDim.new(0, 2)
        cardLayout.Parent = cardContainer
        
        local cardPadding = Instance.new("UIPadding")
        cardPadding.PaddingTop = UDim.new(0, 0)
        cardPadding.PaddingBottom = UDim.new(0, 10)
        cardPadding.PaddingLeft = UDim.new(0, 0)
        cardPadding.PaddingRight = UDim.new(0, 0)
        cardPadding.Parent = cardContainer
        
        local headerContainer = createRoundedFrame({
            Size = UDim2.new(1, 0, 0, 40),
            BackgroundColor3 = COLORS.CARD_HEADER,
            LayoutOrder = 0
        })
        headerContainer.Parent = cardContainer
        
        local headerText = Instance.new("TextLabel")
        headerText.Size = UDim2.new(1, -20, 1, 0)
        headerText.Position = UDim2.new(0, 15, 0, 0)
        headerText.BackgroundTransparency = 1
        headerText.Font = Enum.Font.GothamBold
        headerText.TextSize = 14
        headerText.TextColor3 = COLORS.TEXT_PRIMARY
        headerText.Text = sourceName or "Unknown Source"
        headerText.TextXAlignment = Enum.TextXAlignment.Left
        headerText.Parent = headerContainer
        
        if date and date ~= "" then
            local dateText = Instance.new("TextLabel")
            dateText.Size = UDim2.new(0, 120, 1, 0)
            dateText.Position = UDim2.new(1, -130, 0, 0)
            dateText.BackgroundTransparency = 1
            dateText.Font = Enum.Font.Gotham
            dateText.TextSize = 12
            dateText.TextColor3 = COLORS.TEXT_SECONDARY
            dateText.Text = date
            dateText.TextXAlignment = Enum.TextXAlignment.Right
            dateText.Parent = headerContainer
        end
        
        local fieldOrder = 1
        for _, field in ipairs(fields or {}) do
            local val = row[field]
            if val then
                local fieldContainer = Instance.new("Frame")
                fieldContainer.Size = UDim2.new(1, 0, 0, 36)
                fieldContainer.BackgroundTransparency = 1
                fieldContainer.LayoutOrder = fieldOrder
                fieldContainer.Parent = cardContainer
                
                local fieldLabel = Instance.new("TextLabel")
                fieldLabel.Size = UDim2.new(0.35, -20, 1, 0)
                fieldLabel.Position = UDim2.new(0, 15, 0, 0)
                fieldLabel.BackgroundTransparency = 1
                fieldLabel.Font = Enum.Font.GothamSemibold
                fieldLabel.TextSize = 12
                fieldLabel.TextColor3 = COLORS.TEXT_SECONDARY
                fieldLabel.Text = field
                fieldLabel.TextXAlignment = Enum.TextXAlignment.Left
                fieldLabel.Parent = fieldContainer
                
                local valueBackground = createRoundedFrame({
                    Size = UDim2.new(0.65, -25, 0, 26),
                    Position = UDim2.new(0.35, 0, 0.5, -13),
                    BackgroundColor3 = COLORS.INPUT_BG,
                    BorderSizePixel = 0
                })
                valueBackground.Parent = fieldContainer
                createStroke(valueBackground, Color3.fromRGB(45, 45, 50), 1)
                
                local valueText = Instance.new("TextButton")
                valueText.Size = UDim2.new(1, -20, 1, 0)
                valueText.Position = UDim2.new(0, 10, 0, 0)
                valueText.BackgroundTransparency = 1
                valueText.Font = Enum.Font.Gotham
                valueText.TextSize = 12
                valueText.TextColor3 = COLORS.TEXT_PRIMARY
                valueText.Text = tostring(val)
                valueText.TextXAlignment = Enum.TextXAlignment.Left
                valueText.TextTruncate = Enum.TextTruncate.AtEnd
                valueText.Parent = valueBackground
                
                valueText.MouseButton1Click:Connect(function()
                    local originalColor = valueBackground.BackgroundColor3
                    local originalText = valueText.Text
                    
                    setclipboard(tostring(val))
                    
                    valueText.Text = "Copied!"
                    TweenService:Create(valueBackground, TweenInfo.new(0.3), {
                        BackgroundColor3 = COLORS.SUCCESS
                    }):Play()
                    
                    delay(1.5, function()
                        valueText.Text = originalText
                        TweenService:Create(valueBackground, TweenInfo.new(0.3), {
                            BackgroundColor3 = originalColor
                        }):Play()
                    end)
                end)
                
                fieldOrder = fieldOrder + 1
            end
        end
        
        return cardContainer
    end

    local function clearResults()
        for _, child in pairs(resultsContainer:GetChildren()) do
            if child:IsA("Frame") or child:IsA("TextLabel") then
                child:Destroy()
            end
        end
    end

    local function performSearch(username)
        if username == "" then
            statusLabel.Text = "Please enter a username"
            return
        end

        local _, spaceCount = username:gsub(" ", "")
        if spaceCount > 1 then
            statusLabel.Text = "Username can contain at most one space"
            return
        end

        if not username:match("^[A-Za-z0-9_ ]+$") then
            statusLabel.Text = "Invalid character detected"
            return
        end

        clearResults()
        createSummaryLabel(resultsContainer, "🔍 Searching for leaks...", 0)
        statusLabel.Text = "Searching..."

        
        local url = ("https://leakcheck.io/api/v2/query/%s?type=username")
            :format(HttpService:UrlEncode(username))
            
        local headers = {
            ["Accept"] = "application/json",
            ["X-API-Key"] = API_KEY,
        }
        
        spawn(function()
            local ok, res = pcall(function()
                return httpRequest({
                    Url = url,
                    Method = "GET",
                    Headers = headers,
                })
            end)
            
            clearResults()
            
            if not ok or not res or res.StatusCode ~= 200 then
                createSummaryLabel(resultsContainer, ("❌ HTTP error %s\n%s")
                    :format(tostring(res and res.StatusCode or "nil"),
                            tostring(res and (res.StatusMessage or res.Body) or "no response")), 0)
                statusLabel.Text = "Error"
                return
            end
            
            local data
            local success, err = pcall(function()
                data = HttpService:JSONDecode(res.Body)
            end)
            
            if not success or not data then
                createSummaryLabel(resultsContainer, "❌ JSON decode error:\n" .. tostring(err), 0)
                statusLabel.Text = "Error"
                return
            end
            
            if not data.success then
                createSummaryLabel(resultsContainer, "⚠️ API returned success=false", 0)
                statusLabel.Text = "API Error"
                return
            end
            
            if data.found == 0 then
                createSummaryLabel(resultsContainer, ('🔎 No leaks found for "%s"'):format(username), 0)
                statusLabel.Text = "No Results"
                return
            end
            
            statusLabel.Text = ("Found %d records"):format(data.found)
            
            local orderCounter = 10
            for i, row in ipairs(data.result) do
                local src = row.source or {}
                createLeakCard(
                    resultsContainer,
                    src.name,
                    src.breach_date,
                    row.fields,
                    row,
                    orderCounter
                )
                orderCounter = orderCounter + 1
            end
        end)
    end

    local function updateHoverEffect(button, normalColor, hoverColor)
        button.MouseEnter:Connect(function()
            TweenService:Create(button, TweenInfo.new(0.2), {BackgroundColor3 = hoverColor}):Play()
        end)
        
        button.MouseLeave:Connect(function()
            TweenService:Create(button, TweenInfo.new(0.2), {BackgroundColor3 = normalColor}):Play()
        end)
    end

    updateHoverEffect(searchBtnGroup, COLORS.ACCENT, Color3.fromRGB(60, 70, 90))
    updateHoverEffect(closeButton, COLORS.ERROR, Color3.fromRGB(240, 90, 90))

    searchBtn.MouseButton1Click:Connect(function()
        performSearch(searchBox.Text)
    end)

    searchBox.FocusLost:Connect(function(enterPressed)
        if enterPressed then
            performSearch(searchBox.Text)
        end
    end)

    closeX.MouseButton1Click:Connect(function()
        screenGui:Destroy()
    end)

    local dragging = false
    local dragInput
    local dragStart
    local startPos

    local function updateDrag(input)
        local delta = input.Position - dragStart
        mainFrame.Position = UDim2.new(
            startPos.X.Scale, 
            startPos.X.Offset + delta.X,
            startPos.Y.Scale, 
            startPos.Y.Offset + delta.Y
        )
    end

    topBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = mainFrame.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    topBar.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            updateDrag(input)
        end
    end)

    createSummaryLabel(resultsContainer, "Enter a username and click Search to start", 0)
end

function r15Suite()
    --!nolint BuiltinGlobalWrite
    --!optimize 2
    --!native

    if getconnections then
        if cloneref then
            for _,v in pairs(getconnections(cloneref(game:GetService("LogService")).MessageOut)) do v:Disable() end
            for _,v in pairs(getconnections(cloneref(game:GetService("ScriptContext")).Error)) do v:Disable() end
        else
            for _,v in pairs(getconnections(game:GetService("LogService")).MessageOut) do v:Disable() end
            for _,v in pairs(getconnections(game:GetService("ScriptContext")).Error) do v:Disable() end
        end
        warn("[Celeste] -> DISCONNECTED ALL CONSOLE CONNECTIONS")
    end

    local function randomHex(len)
        local str = ""
        for i = 1, len do
            str = str .. string.format("%x", math.random(0, 15))
        end
        return str
    end

    local function randstr()
        local uuid = table.concat({
            randomHex(8),
            randomHex(4),
            randomHex(4),
            randomHex(4),
            randomHex(12)
        }, "-")
        return "celeste_" .. uuid
    end

    local ANIMATION_UI_ID = randstr()
    local NOTIFICATIONS_ID = randstr()

    sep = string.rep("\n", 200)
    print("                             v LATEST LOGS OF CELESTE ANIM ARE BELOW v"..sep.."            > Starting Celeste")
    warn("[Celeste] -> Starting...")

    local logging = true
    local function log(...)
        if logging then
            warn("[Celeste] -> " .. ...)
        end
    end
    local function seperate(job)
        if logging then
            print("> "..job)
        end
    end

    log("Logging is enabled.")
    seperate("Protection")

    if hookfunction and newcclosure then
        local originalHttpGet = game.HttpGet
        hookfunction(game.HttpGet, newcclosure(function(self, ...)
            if self == game then
                local url = select(1, ...)
                if url == originalHttpGet then
                    log("HttpGet protection triggered")
                    while true do end
                    return nil
                end
            end
            return originalHttpGet(self, ...)
        end))
        log("Hooked HttpGet.")
    end

    local rawgs = clonefunction and clonefunction(game.GetService) or game.GetService
    function gs(service)
        local ok, result = pcall(function()
            return rawgs(game, service)
        end)
        if ok and result then
            log("Got service '" .. service .. "' successfully")
            return result
        else
            log("Failed to get service '" .. service .. "'")
            return nil
        end
    end

    function define(instance)
        if cloneref then
            local ok, protected = pcall(cloneref, instance)
            if ok and protected then
                log("Protected instance '" .. tostring(instance) .. "' with cloneref")
                return protected
            else
                log("cloneref failed for '" .. tostring(instance) .. "'")
            end
        else
            log("cloneref not available, returning raw instance '" .. tostring(instance) .. "'")
        end
        return instance
    end

    local HttpService = define(gs("HttpService"))
    local TweenService = define(gs("TweenService"))
    local RunService = define(gs("RunService"))
    local UserInputService = define(gs("UserInputService"))
    local Players = define(gs("Players"))
    local Player = define(Players.LocalPlayer)
    local GuiService = define(gs("GuiService"))
    local ReplicatedStorage = define(gs("ReplicatedStorage"))
    local workspace = define(gs("Workspace"))
    local CoreGui = define(gs("CoreGui"))

    workspace.FallenPartsDestroyHeight = 0/0

    seperate("Loading UI")

    local UI_CONFIG = {
        MainColor = Color3.fromRGB(22, 22, 24),
        SecondaryColor = Color3.fromRGB(30, 30, 34),
        AccentColor = Color3.fromRGB(56, 189, 248),
        AccentColorDark = Color3.fromRGB(30, 120, 200),
        TextColor = Color3.fromRGB(255, 255, 255),
        SubTextColor = Color3.fromRGB(180, 180, 200),
        BorderColor = Color3.fromRGB(40, 44, 55),
        HoverColor = Color3.fromRGB(45, 50, 65),
        ToggleOnColor = Color3.fromRGB(56, 189, 248),
        ToggleOffColor = Color3.fromRGB(60, 65, 80),
        ErrorColor = Color3.fromRGB(220, 60, 60),
        SuccessColor = Color3.fromRGB(40, 200, 100),
        WarningColor = Color3.fromRGB(255, 184, 50),
        
        CornerRadius = UDim.new(0, 4),
        ButtonCornerRadius = UDim.new(0, 4),
        WindowCornerRadius = UDim.new(0, 6),
        SliderHeight = 4,
        Padding = 10,
        BorderSize = 1,
        
        Font = Enum.Font.Gotham,
        HeaderFont = Enum.Font.GothamBold,
        TitleSize = 16,
        TextSize = 14,
        SubTextSize = 12,
        
        TweenTime = 0.2,
        TweenStyle = Enum.EasingStyle.Quad,
        TweenDirection = Enum.EasingDirection.Out,
    }

    local CONFIG = {
        FOLDER_NAME = "celeste/animations",
        SETTINGS_FILE = "settings.json",
        DEFAULT_SPEED = 1,
        KEYBINDS = {
            TOGGLE_UI = Enum.KeyCode.RightControl,
            PLAY_STOP = Enum.KeyCode.X,
            SPEED_UP = Enum.KeyCode.E,
            SPEED_DOWN = Enum.KeyCode.Q
        }
    }

    local function createCorner(instance, radius)
        local corner = Instance.new("UICorner")
        corner.CornerRadius = radius or UI_CONFIG.CornerRadius
        corner.Parent = instance
        return corner
    end

    local function createStroke(instance, color, thickness)
        local stroke = Instance.new("UIStroke")
        stroke.Color = color or UI_CONFIG.BorderColor
        stroke.Transparency = 0
        stroke.Thickness = thickness or UI_CONFIG.BorderSize
        stroke.Parent = instance
        return stroke
    end

    local FileSystem = {}

    function FileSystem:ensureFolder()
        if not isfolder(CONFIG.FOLDER_NAME) then
            makefolder(CONFIG.FOLDER_NAME)
        end
    end

    function FileSystem:saveJSON(filename, data)
        self:ensureFolder()
        writefile(CONFIG.FOLDER_NAME .. "/" .. filename, HttpService:JSONEncode(data))
    end

    function FileSystem:loadJSON(filename)
        if isfile(CONFIG.FOLDER_NAME .. "/" .. filename) then
            return HttpService:JSONDecode(readfile(CONFIG.FOLDER_NAME .. "/" .. filename))
        end
        return nil
    end

    function FileSystem:saveAnimation(id, keyframeData)
        self:ensureFolder()
        writefile(CONFIG.FOLDER_NAME .. "/" .. id .. ".txt", HttpService:JSONEncode(keyframeData))
    end

    function FileSystem:loadAnimation(id)
        if isfile(CONFIG.FOLDER_NAME .. "/" .. id .. ".txt") then
            return HttpService:JSONDecode(readfile(CONFIG.FOLDER_NAME .. "/" .. id .. ".txt"))
        end
        return nil
    end

    local NotificationSystem = {
        queue = {},
        current = nil
    }

    function NotificationSystem:createUI()
        local gui = Instance.new("ScreenGui")
        gui.Name = NOTIFICATIONS_ID
        gui.ResetOnSpawn = false
        gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        gui.Parent = gethui()
        
        self.gui = gui
        return gui
    end

    function NotificationSystem:push(title, message, type, duration)
        table.insert(self.queue, {
            title = title,
            message = message,
            type = type or "info",
            duration = duration or 3
        })
        
        if not self.current then
            self:showNext()
        end
    end

    function NotificationSystem:showNext()
        if #self.queue == 0 then
            self.current = nil
            return
        end
        
        local notif = table.remove(self.queue, 1)
        self.current = notif
        
        if not self.gui then
            self:createUI()
        end
        
        local colors = {
            success = UI_CONFIG.SuccessColor,
            error = UI_CONFIG.ErrorColor,
            warning = UI_CONFIG.WarningColor,
            info = UI_CONFIG.AccentColor
        }
        
        local color = colors[notif.type] or UI_CONFIG.AccentColor
        
        local frame = Instance.new("Frame")
        frame.Size = UDim2.new(0, 280, 0, 70)
        frame.Position = UDim2.new(1, 20, 0.8, 0)
        frame.BackgroundColor3 = UI_CONFIG.MainColor
        frame.Parent = self.gui
        createCorner(frame, UI_CONFIG.WindowCornerRadius)
        createStroke(frame, color, 1.5)
        
        local indicator = Instance.new("Frame")
        indicator.Size = UDim2.new(0, 4, 1, 0)
        indicator.BackgroundColor3 = color
        indicator.Parent = frame
        
        local title = Instance.new("TextLabel")
        title.Text = notif.title
        title.Size = UDim2.new(1, -20, 0, 25)
        title.Position = UDim2.new(0, 14, 0, 5)
        title.Font = UI_CONFIG.HeaderFont
        title.TextColor3 = UI_CONFIG.TextColor
        title.TextSize = UI_CONFIG.TitleSize
        title.BackgroundTransparency = 1
        title.TextXAlignment = Enum.TextXAlignment.Left
        title.Parent = frame
        
        local message = Instance.new("TextLabel")
        message.Text = notif.message
        message.Size = UDim2.new(1, -20, 0, 30)
        message.Position = UDim2.new(0, 14, 0, 30)
        message.Font = UI_CONFIG.Font
        message.TextColor3 = UI_CONFIG.SubTextColor
        message.TextSize = UI_CONFIG.TextSize
        message.BackgroundTransparency = 1
        message.TextXAlignment = Enum.TextXAlignment.Left
        message.TextWrapped = true
        message.Parent = frame
        
        frame:TweenPosition(
            UDim2.new(1, -300, 0.8, 0),
            UI_CONFIG.TweenDirection,
            UI_CONFIG.TweenStyle,
            UI_CONFIG.TweenTime,
            true
        )
        
        task.delay(notif.duration, function()
            frame:TweenPosition(
                UDim2.new(1, 20, 0.8, 0),
                Enum.EasingDirection.In,
                UI_CONFIG.TweenStyle,
                UI_CONFIG.TweenTime,
                true,
                function()
                    frame:Destroy()
                    self:showNext()
                end
            )
        end)
    end

    local AnimationComponent = {}
    AnimationComponent.__index = AnimationComponent

    function AnimationComponent.new(keyframeData)
        local self = setmetatable({}, AnimationComponent)
        self.speed = 1
        self.stopped = true
        self.connection = nil
        self.lastUpdateTime = 0
        self.animationTime = 0
        self.totalDuration = keyframeData[#keyframeData].Time
        self.keyframeData = keyframeData
        self.joints = {}
        return self
    end

    function AnimationComponent:play(character, joints)
        local char = Player.Character
        if char then
            local hum = char:FindFirstChildOfClass("Humanoid") or char:FindFirstChildOfClass("AnimationController")
            if hum then
                for _, v in next, hum:GetPlayingAnimationTracks() do
                    v:Stop()
                end
            end
            if char:FindFirstChild("Animate") then
                char.Animate.Disabled = true
            end
        end
        
        if self.connection then
            self.connection:Disconnect()
        end
        
        self.stopped = false
        self.lastUpdateTime = tick()
        self.animationTime = 0
        self.joints = joints
        
        self.connection = RunService.Heartbeat:Connect(function()
            if self.stopped then
                self.connection:Disconnect()
                self.connection = nil
                return
            end
            
            local currentTime = tick()
            local deltaTime = currentTime - self.lastUpdateTime
            self.lastUpdateTime = currentTime
            
            self.animationTime = self.animationTime + (deltaTime * self.speed)
            if self.animationTime >= self.totalDuration then
                self.animationTime = self.animationTime % self.totalDuration
            end
            
            local currentFrame = 1
            local nextFrame = 2
            
            for i = 1, #self.keyframeData do
                if self.animationTime >= self.keyframeData[i].Time then
                    currentFrame = i
                    nextFrame = (i % #self.keyframeData) + 1
                end
            end
            
            local currentKeyframe = self.keyframeData[currentFrame]
            local nextKeyframe = self.keyframeData[nextFrame]
            
            local frameDuration = nextKeyframe.Time - currentKeyframe.Time
            if frameDuration < 0 then
                frameDuration = frameDuration + self.totalDuration
            end
            
            local timeIntoFrame = self.animationTime - currentKeyframe.Time
            if timeIntoFrame < 0 then
                timeIntoFrame = timeIntoFrame + self.totalDuration
            end
            
            local alpha = timeIntoFrame / frameDuration
            alpha = math.clamp(alpha, 0, 1)
            
            for partName, joint in pairs(self.joints) do
                local currentPose = currentKeyframe.Poses[partName]
                local nextPose = nextKeyframe.Poses[partName]
                
                if currentPose and nextPose and joint.Joint then
                    local currentCF = CFrame.new(unpack(currentPose.CFrame.Position)) * 
                                    CFrame.Angles(unpack(currentPose.CFrame.Orientation))
                    local nextCF = CFrame.new(unpack(nextPose.CFrame.Position)) * 
                                CFrame.Angles(unpack(nextPose.CFrame.Orientation))
                    
                    joint.Joint.C0 = joint.C0 * currentCF:Lerp(nextCF, alpha)
                end
            end
        end)
    end

    function AnimationComponent:stop()
        self.stopped = true
        if self.connection then
            self.connection:Disconnect()
            self.connection = nil
        end
        
        if self.joints then
            for _, joint in pairs(self.joints) do
                if joint.Joint then
                    joint.Joint.C0 = joint.C0
                    joint.Joint.C1 = joint.C1
                end
            end
        end
        
        local char = Player.Character
        if char and char:FindFirstChild("Animate") then
            char.Animate.Disabled = false
        end
    end

    function AnimationComponent:setSpeed(speed)
        self.speed = speed
    end

    local AnimationManager = {
        ui = nil,
        currentAnim = nil,
        settings = {},
        cache = {},
        connections = {},
        joints = nil,
        character = nil,
        isRunning = false,
        buttons = {}
    }

    function AnimationManager:processKeyframes(keyframeSequence)
        local keyframeData = {}
        for _, keyframe in ipairs(keyframeSequence:GetKeyframes()) do
            local frameData = {
                Time = keyframe.Time,
                Poses = {}
            }
            
            for _, pose in ipairs(keyframe:GetDescendants()) do
                if pose:IsA("Pose") then
                    frameData.Poses[pose.Name] = {
                        CFrame = {
                            Position = {pose.CFrame.Position.X, pose.CFrame.Position.Y, pose.CFrame.Position.Z},
                            Orientation = {pose.CFrame:ToEulerAnglesXYZ()}
                        }
                    }
                end
            end
            
            table.insert(keyframeData, frameData)
        end
        return keyframeData
    end

    function AnimationManager:loadAnimation(id)
        if self.cache[id] then
            return self.cache[id]
        end
        
        local cachedData = FileSystem:loadAnimation(id)
        if cachedData then
            local anim = AnimationComponent.new(cachedData)
            self.cache[id] = anim
            return anim
        end
        
        local success, animation = pcall(function()
            return game:GetObjects("rbxassetid://" .. id)[1]
        end)
        
        if not success or not animation or not animation:IsA('KeyframeSequence') then
            ui:CreateNotification("Error", "Failed to load animation: " .. id, 5, "error")
            return nil
        end
        
        local keyframeData = self:processKeyframes(animation)
        FileSystem:saveAnimation(id, keyframeData)
        
        local anim = AnimationComponent.new(keyframeData)
        self.cache[id] = anim
        
        return anim
    end

    function AnimationManager:cleanupCharacter()
        for _, conn in pairs(self.connections) do
            if typeof(conn) == "RBXScriptConnection" then
                conn:Disconnect()
            end
        end
        self.connections = {}
        
        if self.currentAnim then
            self.currentAnim:stop()
            self.currentAnim = nil
        end
        
        self.isRunning = false
    end

    function AnimationManager:toggleAnimation(id)
        if not self.character or not self.joints then
            ui:CreateNotification("Error", "Character not loaded", 5, "error")
            return
        end
        
        if self.currentAnim and self.currentAnim.id == id then
            self.currentAnim:stop()
            self.currentAnim = nil
            
            if self.buttons[id] then
                self.buttons[id].SetSelected(false)
            end
            return
        end
        
        local anim = self:loadAnimation(id)
        if not anim then return end
        
        if self.currentAnim then
            if self.buttons[self.currentAnim.id] then
                self.buttons[self.currentAnim.id].SetSelected(false)
            end
            self.currentAnim:stop()
        end
        
        anim.id = id
        anim:setSpeed(self.settings.defaultSpeed)
        anim:play(self.character, self.joints)
        self.currentAnim = anim
        
        if self.buttons[id] then
            self.buttons[id].SetSelected(true)
        end
    end

    function AnimationManager:updateSpeed(speed)
        if not speed or speed < 0.1 or speed > 4 then return end
        
        self.settings.defaultSpeed = speed
        
        if self.currentAnim then
            self.currentAnim:setSpeed(speed)
        end
        
        FileSystem:saveJSON(CONFIG.SETTINGS_FILE, self.settings)
    end

    function AnimationManager:setupCharacter()
        local function createJoints(char)
            local joints = {}
            local jointData = {
                Head = {Joint = "Neck"},
                UpperTorso = {Joint = "Waist"},
                LowerTorso = {Joint = "Root"},
                RightUpperArm = {Joint = "RightShoulder"},
                RightLowerArm = {Joint = "RightElbow"},
                RightHand = {Joint = "RightWrist"},
                LeftUpperArm = {Joint = "LeftShoulder"},
                LeftLowerArm = {Joint = "LeftElbow"},
                LeftHand = {Joint = "LeftWrist"},
                RightUpperLeg = {Joint = "RightHip"},
                RightLowerLeg = {Joint = "RightKnee"},
                RightFoot = {Joint = "RightAnkle"},
                LeftUpperLeg = {Joint = "LeftHip"},
                LeftLowerLeg = {Joint = "LeftKnee"},
                LeftFoot = {Joint = "LeftAnkle"}
            }
            
            for partName, data in pairs(jointData) do
                local part = char:FindFirstChild(partName)
                if part then
                    local joint = part:FindFirstChild(data.Joint)
                    if joint then
                        joints[partName] = {
                            Joint = joint,
                            C0 = joint.C0,
                            C1 = joint.C1
                        }
                    end
                end
            end
            
            return joints
        end

        local function onCharacterAdded(char)
            local player = Players.LocalPlayer
            local expectedCloneName = "Celeste"
            
            if char.Name ~= expectedCloneName then
                self:cleanupCharacter()
                ui:CreateNotification("Warning", "Please reanimate first before using animations", 5, "warning")
                return
            end
            
            if self.currentAnim then
                self.currentAnim:stop()
                self.currentAnim = nil
            end
            
            self.character = char
            self.joints = createJoints(char)
            
            for _, conn in pairs(self.connections) do
                if typeof(conn) == "RBXScriptConnection" then
                    conn:Disconnect()
                end
            end
            self.connections = {}

            self.connections.ancestryChanged = char.AncestryChanged:Connect(function(_, parent)
                if not parent then
                    self:cleanupCharacter()
                end
            end)
            
            self.connections.nameChanged = char:GetPropertyChangedSignal("Name"):Connect(function()
                if char.Name ~= expectedCloneName then
                    self:cleanupCharacter()
                    ui:CreateNotification("Warning", "Reanimation status lost", 5, "warning")
                end
            end)
            ui:CreateNotification("Success", "Animations ready", 5, "success")
        end
        
        local player = Players.LocalPlayer
        if player.Character then
            onCharacterAdded(player.Character)
        end
        
        player.CharacterAdded:Connect(onCharacterAdded)
    end

    function AnimationManager:loadSettings()
        local saved = FileSystem:loadJSON(CONFIG.SETTINGS_FILE)
        self.settings = {
            animations = {},
            defaultSpeed = CONFIG.DEFAULT_SPEED,
            keybinds = {},
        }
        
        if saved then
            for key, value in pairs(saved) do
                self.settings[key] = value
            end
        end
        
        local savedAnims = FileSystem:loadJSON("animations.json")
        if savedAnims then
            self.settings.animations = savedAnims
        end
        
        local savedKeybinds = FileSystem:loadJSON("keybinds.json")
        if savedKeybinds then
            for id, keyCode in pairs(savedKeybinds) do
                self.settings.keybinds[id] = Enum.KeyCode[keyCode]
            end
        end
    end

    function AnimationManager:setupKeybinds()
        local function handleInput(input, processed)
            if processed then return end
            
            if input.KeyCode == CONFIG.KEYBINDS.TOGGLE_UI then
                self.ui.main.Visible = not self.ui.main.Visible
                return
            end
            
            for id, keyCode in pairs(self.settings.keybinds) do
                if input.KeyCode == keyCode then
                    self:toggleAnimation(id)
                    return
                end
            end
        end
        
        UserInputService.InputBegan:Connect(handleInput)
    end

    function AnimationManager:refreshAnimationList(searchQuery)
        for _, child in pairs(self.ui.content:GetChildren()) do
            if not child:IsA("UIListLayout") and not child:IsA("UIPadding") then
                child:Destroy()
            end
        end
        
        self.buttons = {}
        
        local filteredAnimations = self.settings.animations
        if searchQuery and searchQuery ~= "" then
            filteredAnimations = {}
            searchQuery = string.lower(searchQuery)
            for _, animData in pairs(self.settings.animations) do
                if string.find(string.lower(animData.name), searchQuery) then
                    table.insert(filteredAnimations, animData)
                end
            end
        end
        
        for _, animData in pairs(filteredAnimations) do
            local button = self.ui.createAnimButton({
                name = animData.name,
                id = animData.id,
                keybind = self.settings.keybinds[animData.id]
            })
            button.Main.Parent = self.ui.content
            
            self.buttons[animData.id] = button
            
            button.ClickArea.MouseButton1Click:Connect(function()
                self:toggleAnimation(animData.id)
            end)
            
            button.DeleteButton.MouseButton1Click:Connect(function()
                if self.currentAnim and self.currentAnim.id == animData.id then
                    self:toggleAnimation(animData.id)
                end
                
                for i, anim in pairs(self.settings.animations) do
                    if anim.id == animData.id then
                        if self.settings.keybinds[animData.id] then
                            self.settings.keybinds[animData.id] = nil
                            FileSystem:saveJSON("keybinds.json", self.settings.keybinds)
                        end
                        table.remove(self.settings.animations, i)
                        break
                    end
                end
                
                FileSystem:saveJSON("animations.json", self.settings.animations)
                self:refreshAnimationList(self.ui.searchBox.Text)
                ui:CreateNotification("Success", "Animation removed", 5, "success")
            end)
            
            button.KeybindButton.MouseButton1Click:Connect(function()
                button.KeybindButton.Text = "..."
                
                local conn
                conn = UserInputService.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.Keyboard then
                        conn:Disconnect()
                        
                        if input.KeyCode == Enum.KeyCode.Escape then
                            button.KeybindButton.Text = "..."
                            self.settings.keybinds[animData.id] = nil
                        else
                            button.KeybindButton.Text = input.KeyCode.Name
                            self.settings.keybinds[animData.id] = input.KeyCode
                        end
                        
                        FileSystem:saveJSON("keybinds.json", self.settings.keybinds)
                    end
                end)
            end)
        end
        
        local listLayout = self.ui.content:FindFirstChild("UIListLayout")
        if listLayout then
            self.ui.content.CanvasSize = UDim2.new(0, 0, 0, listLayout.AbsoluteContentSize.Y + UI_CONFIG.Padding * 2)
        end
    end

    local function createModernUI()
        local gui = Instance.new("ScreenGui")
        gui.Name = ANIMATION_UI_ID
        gui.ResetOnSpawn = false
        gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        
        local main = Instance.new("Frame")
        main.Size = UDim2.new(0, 300, 0, 400)
        main.Position = UDim2.new(0.5, -150, 0.5, -200)
        main.BackgroundColor3 = UI_CONFIG.MainColor
        main.Parent = gui
        createCorner(main, UI_CONFIG.WindowCornerRadius)
        createStroke(main)
        
        local topBar = Instance.new("Frame")
        topBar.Size = UDim2.new(1, 0, 0, 40)
        topBar.BackgroundColor3 = UI_CONFIG.SecondaryColor
        topBar.Parent = main
        createCorner(topBar, UI_CONFIG.WindowCornerRadius)
        
        local bottomCover = Instance.new("Frame")
        bottomCover.Size = UDim2.new(1, 0, 0, 20)
        bottomCover.Position = UDim2.new(0, 0, 1, -20)
        bottomCover.BackgroundColor3 = UI_CONFIG.SecondaryColor
        bottomCover.BorderSizePixel = 0
        bottomCover.Parent = topBar
        
        local title = Instance.new("TextLabel")
        title.Size = UDim2.new(1, -100, 1, 0)
        title.Position = UDim2.new(0, 12, 0, 0)
        title.BackgroundTransparency = 1
        title.Text = "Celeste R15 Suite"
        title.TextColor3 = UI_CONFIG.TextColor
        title.Font = UI_CONFIG.HeaderFont
        title.TextSize = UI_CONFIG.TitleSize
        title.TextXAlignment = Enum.TextXAlignment.Left
        title.Parent = topBar
        
        local closeBtn = Instance.new("ImageButton")
        closeBtn.Size = UDim2.new(0, 24, 0, 24)
        closeBtn.Position = UDim2.new(1, -30, 0.5, -12)
        closeBtn.BackgroundTransparency = 1
        closeBtn.Image = "rbxassetid://6031094678"
        closeBtn.ImageColor3 = UI_CONFIG.TextColor
        closeBtn.Parent = topBar
        
        closeBtn.MouseEnter:Connect(function()
            TweenService:Create(closeBtn, TweenInfo.new(0.2), {ImageColor3 = UI_CONFIG.ErrorColor}):Play()
        end)
        
        closeBtn.MouseLeave:Connect(function()
            TweenService:Create(closeBtn, TweenInfo.new(0.2), {ImageColor3 = UI_CONFIG.TextColor}):Play()
        end)
        
        closeBtn.MouseButton1Click:Connect(function()
            main.Visible = false
        end)

        local searchContainer = Instance.new("Frame")
        searchContainer.Size = UDim2.new(1, -UI_CONFIG.Padding*2, 0, 30)
        searchContainer.Position = UDim2.new(0, UI_CONFIG.Padding, 0, 50)
        searchContainer.BackgroundColor3 = UI_CONFIG.SecondaryColor
        searchContainer.Parent = main
        createCorner(searchContainer)
        createStroke(searchContainer)

        local searchIcon = Instance.new("ImageLabel")
        searchIcon.Size = UDim2.new(0, 16, 0, 16)
        searchIcon.Position = UDim2.new(0, 10, 0.5, -8)
        searchIcon.BackgroundTransparency = 1
        searchIcon.Image = "rbxassetid://6031154871"
        searchIcon.ImageColor3 = UI_CONFIG.SubTextColor
        searchIcon.Parent = searchContainer

        local searchBox = Instance.new("TextBox")
        searchBox.Size = UDim2.new(1, -86, 1, 0)
        searchBox.Position = UDim2.new(0, 36, 0, 0)
        searchBox.BackgroundTransparency = 1
        searchBox.Text = ""
        searchBox.PlaceholderText = "Search animations..."
        searchBox.TextColor3 = UI_CONFIG.TextColor
        searchBox.PlaceholderColor3 = UI_CONFIG.SubTextColor
        searchBox.Font = UI_CONFIG.Font
        searchBox.TextSize = UI_CONFIG.TextSize
        searchBox.TextXAlignment = Enum.TextXAlignment.Left
        searchBox.Parent = searchContainer

        local addButtonGroup = Instance.new("Frame")
        addButtonGroup.Size = UDim2.new(0, 56, 0, 30)
        addButtonGroup.Position = UDim2.new(1, -56, 0, 0)
        addButtonGroup.BackgroundColor3 = UI_CONFIG.AccentColor
        addButtonGroup.Parent = searchContainer
        createCorner(addButtonGroup)

        local addButton = Instance.new("TextButton")
        addButton.Size = UDim2.new(0, 56, 0, 30)
        addButton.Position = UDim2.new(0, 0, 0, 0)
        addButton.BackgroundTransparency = 1
        addButton.Text = "Add"
        addButton.TextColor3 = UI_CONFIG.TextColor
        addButton.Font = UI_CONFIG.HeaderFont
        addButton.TextSize = 15
        addButton.Parent = addButtonGroup

        addButtonGroup.MouseEnter:Connect(function()
            TweenService:Create(addButtonGroup, TweenInfo.new(0.2), {BackgroundColor3 = UI_CONFIG.AccentColorDark}):Play()
        end)

        addButtonGroup.MouseLeave:Connect(function()
            TweenService:Create(addButtonGroup, TweenInfo.new(0.2), {BackgroundColor3 = UI_CONFIG.AccentColor}):Play()
        end)
        
        local contentFrame = Instance.new("Frame")
        contentFrame.Size = UDim2.new(1, -UI_CONFIG.Padding*2, 1, -155)
        contentFrame.Position = UDim2.new(0, UI_CONFIG.Padding, 0, 93)
        contentFrame.BackgroundColor3 = UI_CONFIG.SecondaryColor
        contentFrame.ClipsDescendants = true
        contentFrame.Parent = main
        createCorner(contentFrame)
        createStroke(contentFrame)
        
        local content = Instance.new("ScrollingFrame")
        content.Size = UDim2.new(1, 0, 1, 0)
        content.BackgroundTransparency = 1
        content.ScrollBarThickness = 4
        content.ScrollBarImageColor3 = UI_CONFIG.AccentColor
        content.CanvasSize = UDim2.new(0, 0, 0, 0)
        content.Parent = contentFrame
        
        local listLayout = Instance.new("UIListLayout")
        listLayout.Padding = UDim.new(0, 8)
        listLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
        listLayout.Parent = content
        
        local padding = Instance.new("UIPadding")
        padding.PaddingTop = UDim.new(0, UI_CONFIG.Padding)
        padding.PaddingBottom = UDim.new(0, UI_CONFIG.Padding)
        padding.Parent = content
        
        local controlsFrame = Instance.new("Frame")
        controlsFrame.Size = UDim2.new(1, -UI_CONFIG.Padding*2, 0, 40)
        controlsFrame.Position = UDim2.new(0, UI_CONFIG.Padding, 1, -50)
        controlsFrame.BackgroundColor3 = UI_CONFIG.SecondaryColor
        controlsFrame.Parent = main
        createCorner(controlsFrame)
        createStroke(controlsFrame)
        
        local speedLabel = Instance.new("TextLabel")
        speedLabel.Size = UDim2.new(0, 60, 1, 0)
        speedLabel.Position = UDim2.new(0, 10, 0, 0)
        speedLabel.BackgroundTransparency = 1
        speedLabel.Text = "Speed:"
        speedLabel.TextColor3 = UI_CONFIG.TextColor
        speedLabel.Font = UI_CONFIG.Font
        speedLabel.TextSize = UI_CONFIG.TextSize
        speedLabel.TextXAlignment = Enum.TextXAlignment.Left
        speedLabel.Parent = controlsFrame
        
        local speedValue = Instance.new("TextLabel")
        speedValue.Size = UDim2.new(0, 40, 1, 0)
        speedValue.Position = UDim2.new(1, -50, 0, 0)
        speedValue.BackgroundTransparency = 1
        speedValue.Text = "1.00"
        speedValue.TextColor3 = UI_CONFIG.TextColor
        speedValue.Font = UI_CONFIG.Font
        speedValue.TextSize = UI_CONFIG.TextSize
        speedValue.Parent = controlsFrame
        
        local sliderContainer = Instance.new("Frame")
        sliderContainer.Size = UDim2.new(1, -170, 0, UI_CONFIG.SliderHeight)
        sliderContainer.Position = UDim2.new(0, 75, 0.5, -UI_CONFIG.SliderHeight/2)
        sliderContainer.BackgroundColor3 = UI_CONFIG.MainColor
        sliderContainer.Parent = controlsFrame
        createCorner(sliderContainer, UDim.new(0, UI_CONFIG.SliderHeight/2))
        
        local sliderFill = Instance.new("Frame")
        sliderFill.Size = UDim2.new(0.5, 0, 1, 0)
        sliderFill.BackgroundColor3 = UI_CONFIG.AccentColor
        sliderFill.Parent = sliderContainer
        createCorner(sliderFill, UDim.new(0, UI_CONFIG.SliderHeight/2))
        
        local sliderKnob = Instance.new("Frame")
        sliderKnob.Size = UDim2.new(0, 16, 0, 16)
        sliderKnob.Position = UDim2.new(1, -8, 0.5, -8)
        sliderKnob.BackgroundColor3 = UI_CONFIG.TextColor
        sliderKnob.Parent = sliderFill
        createCorner(sliderKnob, UDim.new(0, 8))
        createStroke(sliderKnob, UI_CONFIG.AccentColor)
        
        local dragging = false
        local dragStart, startPos
        
        topBar.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = true
                dragStart = input.Position
                startPos = main.Position
            end
        end)
        
        UserInputService.InputChanged:Connect(function(input)
            if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                local delta = input.Position - dragStart
                main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X,
                                        startPos.Y.Scale, startPos.Y.Offset + delta.Y)
            end
        end)
        
        UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = false
            end
        end)
        
        local isDragging = false
        local lastValidValue = 1.00
        
        local function updateSliderVisual(pos)
            pos = math.clamp(pos, 0, 1)
            sliderFill.Size = UDim2.new(pos, 0, 1, 0)
            local value = 0.1 + (pos * 3.9)
            value = math.floor(value * 100) / 100
            speedValue.Text = string.format("%.2f", value)
            lastValidValue = value
            return value
        end
        
        local function handleSliderInput(input)
            local mousePos = input.Position
            local sliderPos = (mousePos.X - sliderContainer.AbsolutePosition.X) / sliderContainer.AbsoluteSize.X
            return updateSliderVisual(sliderPos)
        end
        
        sliderContainer.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                isDragging = true
                local newSpeed = handleSliderInput(input)
                AnimationManager:updateSpeed(newSpeed)
            end
        end)
        
        UserInputService.InputChanged:Connect(function(input)
            if isDragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                local newSpeed = handleSliderInput(input)
                AnimationManager:updateSpeed(newSpeed)
            end
        end)
        
        UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                isDragging = false
            end
        end)
        
        local function createAnimButton(data)
            local button = Instance.new("Frame")
            button.Size = UDim2.new(1, -UI_CONFIG.Padding*2, 0, 40)
            button.BackgroundColor3 = UI_CONFIG.MainColor
            button.Parent = content
            createCorner(button)
            createStroke(button)
            
            local nameLabel = Instance.new("TextLabel")
            nameLabel.Size = UDim2.new(1, -100, 0.5, 0)
            nameLabel.Position = UDim2.new(0, 10, 0, 4)
            nameLabel.BackgroundTransparency = 1
            nameLabel.Text = data.name
            nameLabel.TextColor3 = UI_CONFIG.TextColor
            nameLabel.Font = UI_CONFIG.Font
            nameLabel.TextSize = UI_CONFIG.TextSize
            nameLabel.TextXAlignment = Enum.TextXAlignment.Left
            nameLabel.Parent = button
            
            local clickArea = Instance.new("TextButton")
            clickArea.Size = UDim2.new(1, 0, 1, 0)
            clickArea.BackgroundTransparency = 1
            clickArea.Text = ""
            clickArea.Parent = button
            clickArea.ZIndex = 1
            
            local idLabel = Instance.new("TextLabel")
            idLabel.Size = UDim2.new(0, 60, 0, 16)
            idLabel.Position = UDim2.new(0, 10, 0.75, -8)
            idLabel.BackgroundTransparency = 1
            idLabel.Text = data.id
            idLabel.TextColor3 = UI_CONFIG.SubTextColor
            idLabel.Font = UI_CONFIG.Font
            idLabel.TextSize = UI_CONFIG.SubTextSize
            idLabel.TextXAlignment = Enum.TextXAlignment.Left
            idLabel.Parent = button
            
            local keybindBtn = Instance.new("TextButton")
            keybindBtn.Size = UDim2.new(0, 36, 0, 24)
            keybindBtn.Position = UDim2.new(1, -80, 0.5, -12)
            keybindBtn.BackgroundColor3 = UI_CONFIG.SecondaryColor
            keybindBtn.Text = data.keybind and data.keybind.Name or "..."
            keybindBtn.TextColor3 = UI_CONFIG.TextColor
            keybindBtn.Font = UI_CONFIG.Font
            keybindBtn.TextSize = UI_CONFIG.SubTextSize
            keybindBtn.ZIndex = 2
            keybindBtn.Parent = button
            createCorner(keybindBtn)
            createStroke(keybindBtn)
            
            local deleteBtn = Instance.new("ImageButton")
            deleteBtn.Size = UDim2.new(0, 24, 0, 24)
            deleteBtn.Position = UDim2.new(1, -30, 0.5, -12)
            deleteBtn.BackgroundTransparency = 1
            deleteBtn.Image = "rbxassetid://6031094678"
            deleteBtn.ImageColor3 = UI_CONFIG.SubTextColor
            deleteBtn.ZIndex = 2
            deleteBtn.Parent = button
            
            deleteBtn.MouseEnter:Connect(function()
                TweenService:Create(deleteBtn, TweenInfo.new(0.2), {ImageColor3 = UI_CONFIG.ErrorColor}):Play()
            end)
            
            deleteBtn.MouseLeave:Connect(function()
                TweenService:Create(deleteBtn, TweenInfo.new(0.2), {ImageColor3 = UI_CONFIG.SubTextColor}):Play()
            end)
            
            local isSelected = false
            
            local function updateVisuals()
                TweenService:Create(button, TweenInfo.new(0.2), {
                    BackgroundColor3 = isSelected and UI_CONFIG.AccentColorDark or UI_CONFIG.MainColor
                }):Play()
            end
            
            clickArea.MouseEnter:Connect(function()
                if not isSelected then
                    TweenService:Create(button, TweenInfo.new(0.2), {
                        BackgroundColor3 = UI_CONFIG.HoverColor
                    }):Play()
                end
            end)
            
            clickArea.MouseLeave:Connect(function()
                if not isSelected then
                    TweenService:Create(button, TweenInfo.new(0.2), {
                        BackgroundColor3 = UI_CONFIG.MainColor
                    }):Play()
                end
            end)
            
            return {
                Main = button,
                ClickArea = clickArea,
                KeybindButton = keybindBtn,
                DeleteButton = deleteBtn,
                SetSelected = function(selected)
                    isSelected = selected
                    updateVisuals()
                end
            }
        end
        
        local function createAddAnimPrompt()
            local promptBg = Instance.new("Frame")
            promptBg.Size = UDim2.new(1, 0, 1, 0)
            promptBg.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
            promptBg.BackgroundTransparency = 0.5
            promptBg.ZIndex = 10
            promptBg.Parent = main
            createCorner(promptBg, UI_CONFIG.WindowCornerRadius)
            
            local prompt = Instance.new("Frame")
            prompt.Size = UDim2.new(0.9, 0, 0, 180)
            prompt.Position = UDim2.new(0.05, 0, 0.5, -90)
            prompt.BackgroundColor3 = UI_CONFIG.MainColor
            prompt.ZIndex = 11
            prompt.Parent = promptBg
            createCorner(prompt, UI_CONFIG.WindowCornerRadius)
            createStroke(prompt, UI_CONFIG.AccentColor)
            
            local title = Instance.new("TextLabel")
            title.Size = UDim2.new(1, 0, 0, 40)
            title.Text = "Add Animation"
            title.TextColor3 = UI_CONFIG.TextColor
            title.Font = UI_CONFIG.HeaderFont
            title.TextSize = UI_CONFIG.TitleSize
            title.BackgroundTransparency = 1
            title.ZIndex = 11
            title.Parent = prompt
            
            local function createInputField(text, yPos)
                local container = Instance.new("Frame")
                container.Size = UDim2.new(1, -20, 0, 40)
                container.Position = UDim2.new(0, 10, 0, yPos)
                container.BackgroundColor3 = UI_CONFIG.SecondaryColor
                container.ZIndex = 11
                container.Parent = prompt
                createCorner(container)
                
                local label = Instance.new("TextLabel")
                label.Size = UDim2.new(0.25, 0, 1, 0)
                label.Text = text
                label.TextColor3 = UI_CONFIG.TextColor
                label.Font = UI_CONFIG.Font
                label.TextSize = UI_CONFIG.TextSize
                label.BackgroundTransparency = 1
                label.ZIndex = 11
                label.Parent = container
                
                local input = Instance.new("TextBox")
                input.Size = UDim2.new(0.75, -10, 1, -10)
                input.Position = UDim2.new(0.25, 5, 0, 5)
                input.Text = ""
                input.PlaceholderText = "Enter " .. string.lower(text) .. "..."
                input.TextColor3 = UI_CONFIG.TextColor
                input.PlaceholderColor3 = UI_CONFIG.SubTextColor
                input.BackgroundColor3 = UI_CONFIG.MainColor
                input.Font = UI_CONFIG.Font
                input.TextSize = UI_CONFIG.TextSize
                input.ZIndex = 11
                input.Parent = container
                createCorner(input)
                
                return input
            end
            
            local nameInput = createInputField("Name", 40)
            local idInput = createInputField("ID", 90)
            
            local buttonContainer = Instance.new("Frame")
            buttonContainer.Size = UDim2.new(1, -20, 0, 30)
            buttonContainer.Position = UDim2.new(0, 10, 1, -40)
            buttonContainer.BackgroundTransparency = 1
            buttonContainer.ZIndex = 11
            buttonContainer.Parent = prompt
            
            local cancelBtn = Instance.new("TextButton")
            cancelBtn.Size = UDim2.new(0.5, -5, 1, 0)
            cancelBtn.BackgroundColor3 = UI_CONFIG.SecondaryColor
            cancelBtn.Text = "Cancel"
            cancelBtn.TextColor3 = UI_CONFIG.TextColor
            cancelBtn.Font = UI_CONFIG.Font
            cancelBtn.TextSize = UI_CONFIG.TextSize
            cancelBtn.ZIndex = 11
            cancelBtn.Parent = buttonContainer
            createCorner(cancelBtn)
            
            local addBtn = Instance.new("TextButton")
            addBtn.Size = UDim2.new(0.5, -5, 1, 0)
            addBtn.Position = UDim2.new(0.5, 5, 0, 0)
            addBtn.BackgroundColor3 = UI_CONFIG.AccentColor
            addBtn.Text = "Add"
            addBtn.TextColor3 = UI_CONFIG.TextColor
            addBtn.Font = UI_CONFIG.Font
            addBtn.TextSize = UI_CONFIG.TextSize
            addBtn.ZIndex = 11
            addBtn.Parent = buttonContainer
            createCorner(addBtn)
            
            return {
                promptBg = promptBg,
                nameInput = nameInput,
                idInput = idInput,
                cancelBtn = cancelBtn,
                addBtn = addBtn
            }
        end
        
        return {
            gui = gui,
            main = main,
            content = content,
            searchBox = searchBox,
            addButton = addButton,
            speedValue = speedValue,
            sliderFill = sliderFill,
            createAnimButton = createAnimButton,
            createAddAnimPrompt = createAddAnimPrompt,
            updateSliderVisual = updateSliderVisual
        }
    end

    function AnimationManager:init()
        self.ui = createModernUI()
        self:loadSettings()
        
        local debounce = false
        self.ui.searchBox:GetPropertyChangedSignal("Text"):Connect(function()
            if debounce then return end
            debounce = true
            
            task.delay(0.1, function()
                self:refreshAnimationList(self.ui.searchBox.Text)
                debounce = false
            end)
        end)
        
        if self.settings.defaultSpeed then
            local pos = (self.settings.defaultSpeed - 0.1) / 3.9
            self.ui.sliderFill.Size = UDim2.new(pos, 0, 1, 0)
            self.ui.speedValue.Text = string.format("%.2f", self.settings.defaultSpeed)
        end
        
        self:setupCharacter()
        self:setupKeybinds()
        self:refreshAnimationList()
        
        self.ui.addButton.MouseButton1Click:Connect(function()
            local addPrompt = self.ui.createAddAnimPrompt()
            
            addPrompt.cancelBtn.MouseButton1Click:Connect(function()
                addPrompt.promptBg:Destroy()
            end)
            
            addPrompt.addBtn.MouseButton1Click:Connect(function()
                local name = addPrompt.nameInput.Text
                local id = tonumber(addPrompt.idInput.Text)
                
                if name ~= "" and id then
                    local anim = self:loadAnimation(id)
                    if anim then
                        table.insert(self.settings.animations, {
                            name = name,
                            id = id
                        })
                        FileSystem:saveJSON("animations.json", self.settings.animations)
                        self:refreshAnimationList()
                        addPrompt.promptBg:Destroy()
                        ui:CreateNotification("Success", "Animation added", 5, "success")
                    else
                        ui:CreateNotification("Error", "Invalid animation ID", 5, "error")
                    end
                else
                    ui:CreateNotification("Error", "Please fill all fields", 5, "error")
                end
            end)
        end)
        
        self.ui.gui.Parent = gethui()
        
        ui:CreateNotification("Welcome", "Animation system has loaded!", 5, "info")
        log("UI Initialized")
        
        return self
    end

    local manager = AnimationManager:init()

    UserInputService.InputBegan:Connect(function(input, processed)
        if processed then return end
        
        if input.KeyCode == CONFIG.KEYBINDS.TOGGLE_UI then
            manager.ui.main.Visible = not manager.ui.main.Visible
        end
        
        if input.KeyCode == CONFIG.KEYBINDS.SPEED_UP then
            local currentSpeed = manager.settings.defaultSpeed or CONFIG.DEFAULT_SPEED
            local newSpeed = math.min(currentSpeed + 0.25, 4)
            manager:updateSpeed(newSpeed)
        end
        
        if input.KeyCode == CONFIG.KEYBINDS.SPEED_DOWN then
            local currentSpeed = manager.settings.defaultSpeed or CONFIG.DEFAULT_SPEED
            local newSpeed = math.max(currentSpeed - 0.25, 0.1)
            manager:updateSpeed(newSpeed)
        end
    end)

    log("Script loaded and running")
end

--[[ WELCOME ]]--
ui:CreateNotification("Welcome", "Celeste has been loaded successfully", 5, "info")
seperate("Loaded!")

return CelesteUI

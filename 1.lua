-- SimpleGuiLib.lua
local GuiLib = {}

function GuiLib:CreateScreenGui(name)
    local gui = Instance.new("ScreenGui")
    gui.Name = name or "SimpleGui"
    gui.ResetOnSpawn = false
    gui.IgnoreGuiInset = true
    gui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
    return gui
end

function GuiLib:CreateFrame(parent, size, position, title)
    local frame = Instance.new("Frame")
    frame.Size = size or UDim2.new(0, 200, 0, 100)
    frame.Position = position or UDim2.new(0.5, -100, 0.5, -50)
    frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    frame.BorderSizePixel = 0
    frame.Name = title or "Frame"
    frame.Parent = parent

    local uiCorner = Instance.new("UICorner", frame)

    return frame
end

function GuiLib:CreateButton(parent, text, size, position, callback)
    local button = Instance.new("TextButton")
    button.Size = size or UDim2.new(0, 100, 0, 40)
    button.Position = position or UDim2.new(0.5, -50, 0.5, -20)
    button.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
    button.Text = text or "Click Me"
    button.TextColor3 = Color3.new(1, 1, 1)
    button.Font = Enum.Font.SourceSans
    button.TextSize = 18
    button.Parent = parent

    local uiCorner = Instance.new("UICorner", button)

    button.MouseButton1Click:Connect(function()
        if callback then
            callback()
        end
    end)

    return button
end

function GuiLib:CreateLabel(parent, text, size, position)
    local label = Instance.new("TextLabel")
    label.Size = size or UDim2.new(0, 200, 0, 40)
    label.Position = position or UDim2.new(0.5, -100, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = text or "Label"
    label.TextColor3 = Color3.new(1, 1, 1)
    label.Font = Enum.Font.SourceSans
    label.TextSize = 20
    label.Parent = parent

    return label
end

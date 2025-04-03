--// SigmaHub GUI (Fresh Start - Federal Style Inspired)

-- Services
local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local Mouse = Player:GetMouse()
local UIS = game:GetService("UserInputService")

-- ScreenGui Setup
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "SigmaHub"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = Player:WaitForChild("PlayerGui")

-- Main Frame
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 500, 0, 300)
MainFrame.Position = UDim2.new(0.5, -250, 0.5, -150)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
MainFrame.BorderSizePixel = 0
MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

-- UI Corner
local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 8)
UICorner.Parent = MainFrame

-- Top Bar
local TopBar = Instance.new("Frame")
TopBar.Name = "TopBar"
TopBar.Size = UDim2.new(1, 0, 0, 40)
TopBar.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
TopBar.BorderSizePixel = 0
TopBar.Parent = MainFrame

local TopCorner = Instance.new("UICorner")
TopCorner.CornerRadius = UDim.new(0, 8)
TopCorner.Parent = TopBar

-- Title Label
local Title = Instance.new("TextLabel")
Title.Name = "Title"
Title.Text = "SigmaHub"
Title.Size = UDim2.new(1, -80, 1, 0)
Title.Position = UDim2.new(0, 10, 0, 0)
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.BackgroundTransparency = 1
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Font = Enum.Font.GothamBold
Title.TextSize = 18
Title.Parent = TopBar

-- Minimize Button
local MinButton = Instance.new("TextButton")
MinButton.Name = "Minimize"
MinButton.Size = UDim2.new(0, 20, 0, 20)
MinButton.Position = UDim2.new(1, -50, 0.5, -10)
MinButton.Text = "-"
MinButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
MinButton.TextColor3 = Color3.fromRGB(255, 255, 255)
MinButton.Font = Enum.Font.GothamBold
MinButton.TextSize = 14
MinButton.Parent = TopBar

-- Close Button
local CloseButton = Instance.new("TextButton")
CloseButton.Name = "Close"
CloseButton.Size = UDim2.new(0, 20, 0, 20)
CloseButton.Position = UDim2.new(1, -25, 0.5, -10)
CloseButton.Text = "x"
CloseButton.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.Font = Enum.Font.GothamBold
CloseButton.TextSize = 14
CloseButton.Parent = TopBar

-- Toggle Open/Close with K key
local IsOpen = true
CloseButton.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
    IsOpen = false
end)\n
MinButton.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
    IsOpen = not IsOpen
end)

UIS.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.KeyCode == Enum.KeyCode.K then
        IsOpen = not IsOpen
        MainFrame.Visible = IsOpen
    end
end)

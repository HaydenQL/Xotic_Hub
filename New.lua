--// SigmaHub UI Script (Inspired by Federal)

-- Load Rayfield UI Library
local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()

-- Create Window
local Window = Rayfield:CreateWindow({
    Name = "SigmaHub",
    LoadingTitle = "SigmaHub",
    LoadingSubtitle = "by HaydenSigma24",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "SigmaHubData",
        FileName = "SigmaHubSettings"
    },
    Discord = {
        Enabled = false,
        Invite = "",
        RememberJoins = false
    },
    KeySystem = false
})

-- Minimize/Close toggle with K key
local UIS = game:GetService("UserInputService")
local Open = true

UIS.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.KeyCode == Enum.KeyCode.K then
        if Open then
            Rayfield:ToggleUI(false)
            Open = false
        else
            Rayfield:ToggleUI(true)
            Open = true
        end
    end
end)

-- Home Tab
local HomeTab = Window:CreateTab("🏠 Home", {"rbxassetid://7734053497"})

HomeTab:CreateToggle({
    Name = "R15 Reanimation",
    CurrentValue = false,
    Callback = function(Value)
        if Value then
            print("R15 Reanimation Enabled")
        else
            print("R15 Reanimation Disabled")
        end
    end
})

HomeTab:CreateToggle({
    Name = "R6 Reanimation",
    CurrentValue = false,
    Callback = function(Value)
        if Value then
            print("R6 Reanimation Enabled")
        else
            print("R6 Reanimation Disabled")
        end
    end
})

-- Credits Tab
local CreditsTab = Window:CreateTab("⭐ Credits", {"rbxassetid://7734053497"})

CreditsTab:CreateParagraph({
    Title = "Created by",
    Content = "HaydenSigma24"
})

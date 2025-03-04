-- Simple Chat Bypass UI Script

-- Create UI elements
local ScreenGui = Instance.new("ScreenGui")
local Frame = Instance.new("Frame")
local TextBox = Instance.new("TextBox")
local SendButton = Instance.new("TextButton")

-- Set up the GUI
ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
Frame.Size = UDim2.new(0, 400, 0, 200)
Frame.Position = UDim2.new(0.5, -200, 0.5, -100)
Frame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
Frame.Parent = ScreenGui

TextBox.Size = UDim2.new(0, 350, 0, 50)
TextBox.Position = UDim2.new(0.5, -175, 0, 20)
TextBox.PlaceholderText = "Type your message here..."
TextBox.Parent = Frame

SendButton.Size = UDim2.new(0, 150, 0, 50)
SendButton.Position = UDim2.new(0.5, -75, 0, 100)
SendButton.Text = "Send"
SendButton.Parent = Frame

-- Function to replace letters with bypass characters
local function bypassText(msg)
    local substitutions = {
        a = "aۘॱ", b = "bۘॱ", c = "cۘॱ", d = "dۘॱ", e = "eۘॱ",
        f = "fۘॱ", g = "gۘॱ", h = "hۘॱ", i = "iۘॱ", j = "jۘॱ",
        k = "kۘॱ", l = "lۘॱ", m = "mۘॱ", n = "nۘॱ", o = "oۘॱ",
        p = "pۘॱ", q = "qۘॱ", r = "rۘॱ", s = "sۘॱ", t = "tۘॱ",
        u = "uۘॱ", v = "vۘॱ", w = "wۘॱ", x = "xۘॱ", y = "yۘॱ",
        z = "zۘॱ", A = "Aۘॱ", B = "Bۘॱ", C = "Cۘॱ", D = "Dۘॱ",
        E = "Eۘॱ", F = "Fۘॱ", G = "Gۘॱ", H = "Hۘॱ", I = "Iۘॱ",
        J = "Jۘॱ", K = "Kۘॱ", L = "Lۘॱ", M = "Mۘॱ", N = "Nۘॱ",
        O = "Oۘॱ", P = "Pۘॱ", Q = "Qۘॱ", R = "Rۘॱ", S = "Sۘॱ",
        T = "Tۘॱ", U = "Uۘॱ", V = "Vۘॱ", W = "Wۘॱ", X = "Xۘॱ",
        Y = "Yۘॱ", Z = "Zۘॱ", [" "] = "  " -- Double space trick
    }
    return msg:gsub(".", substitutions)
end

-- Send the bypassed text to chat when button is clicked
SendButton.MouseButton1Click:Connect(function()
    local msg = TextBox.Text
    local modifiedMsg = bypassText(msg)

    -- Send the modified message to Roblox chat
    local chatEvent = game:GetService("ReplicatedStorage"):WaitForChild("DefaultChatSystemChatEvents"):FindFirstChild("SayMessageRequest")
    if chatEvent then
        chatEvent:FireServer(modifiedMsg, "All")
    else
        warn("Chat event not found!")
    end
end)

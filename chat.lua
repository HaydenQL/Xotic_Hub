-- Chat Bypass UI with Menu Selection

-- Create UI elements
local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local TabFrame = Instance.new("Frame")
local ChatBypassButton = Instance.new("TextButton")
local ContentFrame = Instance.new("Frame")
local TextBox = Instance.new("TextBox")
local SendButton = Instance.new("TextButton")

-- Set up the GUI
ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

MainFrame.Size = UDim2.new(0, 450, 0, 250)
MainFrame.Position = UDim2.new(0.5, -225, 0.5, -125)
MainFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
MainFrame.Parent = ScreenGui

TabFrame.Size = UDim2.new(0, 150, 1, 0)
TabFrame.Position = UDim2.new(0, 0, 0, 0)
TabFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
TabFrame.Parent = MainFrame

ChatBypassButton.Size = UDim2.new(1, -10, 0, 50)
ChatBypassButton.Position = UDim2.new(0, 5, 0, 10)
ChatBypassButton.Text = "Chat Bypass"
ChatBypassButton.Parent = TabFrame

ContentFrame.Size = UDim2.new(1, -150, 1, 0)
ContentFrame.Position = UDim2.new(0, 150, 0, 0)
ContentFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
ContentFrame.Parent = MainFrame

TextBox.Size = UDim2.new(0, 280, 0, 50)
TextBox.Position = UDim2.new(0.5, -140, 0.3, 0)
TextBox.PlaceholderText = "Type your message here..."
TextBox.Parent = ContentFrame

SendButton.Size = UDim2.new(0, 150, 0, 50)
SendButton.Position = UDim2.new(0.5, -75, 0.6, 0)
SendButton.Text = "Send"
SendButton.Parent = ContentFrame

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

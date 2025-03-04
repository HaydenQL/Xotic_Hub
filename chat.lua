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
    msg = msg:gsub("a", "aۘॱ")
    msg = msg:gsub("b", "bۘॱ")
    msg = msg:gsub("c", "cۘॱ")
    msg = msg:gsub("d", "dۘॱ")
    msg = msg:gsub("e", "eۘॱ")
    msg = msg:gsub("f", "fۘॱ")
    msg = msg:gsub("g", "gۘॱ")
    msg = msg:gsub("h", "hۘॱ")
    msg = msg:gsub("i", "iۘॱ")
    msg = msg:gsub("j", "jۘॱ")
    msg = msg:gsub("k", "kۘॱ")
    msg = msg:gsub("l", "lۘॱ")
    msg = msg:gsub("m", "mۘॱ")
    msg = msg:gsub("n", "nۘॱ")
    msg = msg:gsub("o", "oۘॱ")
    msg = msg:gsub("p", "pۘॱ")
    msg = msg:gsub("q", "qۘॱ")
    msg = msg:gsub("r", "rۘॱ")
    msg = msg:gsub("s", "sۘॱ")
    msg = msg:gsub("t", "tۘॱ")
    msg = msg:gsub("u", "uۘॱ")
    msg = msg:gsub("v", "vۘॱ")
    msg = msg:gsub("w", "wۘॱ")
    msg = msg:gsub("x", "xۘॱ")
    msg = msg:gsub("y", "yۘॱ")
    msg = msg:gsub("z", "zۘॱ")
    msg = msg:gsub("A", "Aۘॱ")
    msg = msg:gsub("B", "Bۘॱ")
    msg = msg:gsub("C", "Cۘॱ")
    msg = msg:gsub("D", "Dۘॱ")
    msg = msg:gsub("E", "Eۘॱ")
    msg = msg:gsub("F", "Fۘॱ")
    msg = msg:gsub("G", "Gۘॱ")
    msg = msg:gsub("H", "Hۘॱ")
    msg = msg:gsub("I", "Iۘॱ")
    msg = msg:gsub("J", "Jۘॱ")
    msg = msg:gsub("K", "Kۘॱ")
    msg = msg:gsub("L", "Lۘॱ")
    msg = msg:gsub("M", "Mۘॱ")
    msg = msg:gsub("N", "Nۘॱ")
    msg = msg:gsub("O", "Oۘॱ")
    msg = msg:gsub("P", "Pۘॱ")
    msg = msg:gsub("Q", "Qۘॱ")
    msg = msg:gsub("R", "Rۘॱ")
    msg = msg:gsub("S", "Sۘॱ")
    msg = msg:gsub("T", "Tۘॱ")
    msg = msg:gsub("U", "Uۘॱ")
    msg = msg:gsub("V", "Vۘॱ")
    msg = msg:gsub("W", "Wۘॱ")
    msg = msg:gsub("X", "Xۘॱ")
    msg = msg:gsub("Y", "Yۘॱ")
    msg = msg:gsub("Z", "Zۘॱ")
    msg = msg:gsub(" ", "  ") -- Double space trick
    return msg
end

-- Send the bypassed text to chat when button is clicked
SendButton.MouseButton1Click:Connect(function()
    local msg = TextBox.Text
    local modifiedMsg = bypassText(msg)

    -- Send the modified message to Roblox chat
    game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents.SayMessageRequest:FireServer(modifiedMsg, "All")
end)
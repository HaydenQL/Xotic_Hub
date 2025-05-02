local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

local headSit -- connection holder

-- Helper function to get player by display name (case insensitive)
local function getPlayerByDisplayName(name)
    name = name:lower()
    for _, player in ipairs(Players:GetPlayers()) do
        if player.DisplayName:lower():sub(1, #name) == name then
            return player
        end
    end
end

-- Helper function to get random player (not yourself)
local function getRandomPlayer()
    local validPlayers = {}
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            table.insert(validPlayers, player)
        end
    end
    if #validPlayers > 0 then
        return validPlayers[math.random(1, #validPlayers)]
    end
end

-- Chat command listener
LocalPlayer.Chatted:Connect(function(msg)
    local args = msg:split(" ")
    if args[1]:lower() == "!headsit" and args[2] then
        local target
        if args[2]:lower() == "random" then
            target = getRandomPlayer()
        else
            target = getPlayerByDisplayName(args[2])
        end

        if target and target.Character and LocalPlayer.Character then
            -- Disconnect old headsit if active
            if headSit then headSit:Disconnect() end

            -- Sit down
            LocalPlayer.Character:FindFirstChildOfClass("Humanoid").Sit = true

            -- Start sitting on target's head
            headSit = RunService.Heartbeat:Connect(function()
                if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") and LocalPlayer.Character:FindFirstChildOfClass("Humanoid").Sit then
                    -- Adjust height (2.2 for higher sit on head)
                    LocalPlayer.Character.HumanoidRootPart.CFrame = target.Character.HumanoidRootPart.CFrame * CFrame.new(0, 2.7, 0.2)
                else
                    headSit:Disconnect()
                end
            end)
        end
    end
end)

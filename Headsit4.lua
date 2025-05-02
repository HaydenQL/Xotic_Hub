local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local headSit -- connection holder

-- Helper function to get player
local function getPlayer(name)
    name = name:lower()
    for _, player in ipairs(Players:GetPlayers()) do
        if player.Name:lower():sub(1, #name) == name then
            return player
        end
    end
end

-- Chat command listener
Players.LocalPlayer.Chatted:Connect(function(msg)
    local args = msg:split(" ")
    if args[1]:lower() == "!headsit" and args[2] then
        local target = getPlayer(args[2])
        local speaker = Players.LocalPlayer

        if target and target.Character and speaker.Character then
            -- If already headsitting, disconnect first
            if headSit then headSit:Disconnect() end

            -- Sit down
            speaker.Character:FindFirstChildOfClass("Humanoid").Sit = true

            -- Start sticking to target's head
            headSit = RunService.Heartbeat:Connect(function()
                if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") and speaker.Character and speaker.Character:FindFirstChild("HumanoidRootPart") and speaker.Character:FindFirstChildOfClass("Humanoid").Sit then
                    speaker.Character.HumanoidRootPart.CFrame = target.Character.HumanoidRootPart.CFrame * CFrame.new(0, 1.6, 0.4)
                else
                    headSit:Disconnect()
                end
            end)
        end
    end
end)


local HttpService = game:GetService("HttpService")
local Clipboard = setclipboard or toclipboard or (Clipboard and Clipboard.set)
local ServicesToMonitor = {
	game:GetService("CoreGui"),
	game.Players.LocalPlayer:WaitForChild("PlayerGui"),
	game.Players.LocalPlayer:WaitForChild("PlayerScripts"),
	game:GetService("StarterGui"),
	game:GetService("ReplicatedFirst"),
	game:GetService("ReplicatedStorage"),
	game:GetService("Lighting"),
	game:GetService("Workspace"),
	game:GetService("StarterPlayer"),
	game:GetService("Chat"),
	game:GetService("SoundService")
}

local function tryCopyScriptContent(scriptObj)
	if scriptObj:IsA("LocalScript") or scriptObj:IsA("ModuleScript") or scriptObj:IsA("Script") then
		if scriptObj.Source then
			local success, result = pcall(function()
				return scriptObj.Source
			end)
			if success and result and Clipboard then
				Clipboard(result)
				print("✅ Copied script source from:", scriptObj:GetFullName())
			else
				warn("⚠️ Could not access source of:", scriptObj:GetFullName())
			end
		end
	end
end

for _, service in ipairs(ServicesToMonitor) do
	if typeof(service) == "Instance" then
		service.ChildAdded:Connect(function(child)
			task.wait(0.1)
			tryCopyScriptContent(child)
		end)
	end
end

print("👁️ Monitoring for injected scripts...")

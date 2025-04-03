repeat wait() until _G.XenoLog
_G.XenoLog("📡 Deep scanning game for remotes...")

local function scan(parent)
	for _, v in pairs(parent:GetDescendants()) do
		if v:IsA("RemoteEvent") or v:IsA("RemoteFunction") then
			_G.XenoLog("📡 Found " .. v.ClassName .. ": " .. v:GetFullName())
		end
	end
end

-- Scan common services
local services = {
	game:GetService("ReplicatedStorage"),
	game:GetService("ReplicatedFirst"),
	game:GetService("StarterPlayer"),
	game:GetService("Players"),
	game:GetService("Workspace"),
	game:GetService("Lighting"),
}

for _, svc in ipairs(services) do
	pcall(function()
		scan(svc)
	end)
end

_G.XenoLog("✅ Remote scan complete.")

-- 🧪 Remote Scanner with Logger Support
repeat wait() until _G.XenoLog

_G.XenoLog("🔍 Scanning for RemoteEvents...")

local found = 0

for _,v in pairs(getgc(true)) do
	if typeof(v) == "Instance" and v:IsA("RemoteEvent") then
		found += 1
		_G.XenoLog("[RemoteEvent] ➜ " .. v:GetFullName())
	end
end

if found == 0 then
	_G.XenoLog("❌ No RemoteEvents found in getgc.")
else
	_G.XenoLog("✅ Total Remotes Found: " .. found)
end

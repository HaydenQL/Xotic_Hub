repeat wait() until _G.XenoLog

_G.XenoLog("🔍 Starting require() scan... (IDs 1–1000000)")
local found = 0

for i = 1, 1000000 do
	pcall(function()
		local result = require(i)
		if typeof(result) == "table" or typeof(result) == "function" then
			found += 1
			_G.XenoLog("✅ Possible backdoor module: ID = " .. i)
		end
	end)
	wait()
end

_G.XenoLog("✅ Scan complete. Found " .. found .. " usable module(s).")

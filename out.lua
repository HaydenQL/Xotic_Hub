repeat wait() until _G.XenoLog
_G.XenoLog("🔍 Starting require() scan from 1 to 10,000...")

local found = 0
local total = 10000

for i = 1, total do
	pcall(function()
		local result = require(i)
		if typeof(result) == "table" or typeof(result) == "function" then
			found += 1
			_G.XenoLog("✅ Found usable module ID: " .. i)
		end
	end)

	-- Progress every 500 iterations
	if i % 500 == 0 then
		_G.XenoLog("🔄 Scanned " .. i .. " / " .. total)
	end

	wait()
end

if found == 0 then
	_G.XenoLog("❌ No usable backdoor modules found after scanning " .. total .. " IDs.")
else
	_G.XenoLog("✅ Scan complete. Total usable modules found: " .. found)
end

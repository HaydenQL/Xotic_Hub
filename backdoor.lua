repeat wait() until _G.XenoLog
_G.XenoLog("🔍 Starting backdoor module scan...")

local found = 0
local total = 10000 -- scan the most common public module IDs first

for i = 1, total do
	pcall(function()
		local result = require(i)
		if typeof(result) == "table" or typeof(result) == "function" then
			found += 1
			_G.XenoLog("✅ Found possible backdoor module: ID = " .. i)
		end
	end)

	-- Show progress every 500 scans
	if i % 500 == 0 then
		_G.XenoLog("🔄 Scanned " .. i .. "/" .. total)
	end

	wait() -- avoid freezing
end

if found == 0 then
	_G.XenoLog("❌ No usable backdoor modules found after scanning " .. total .. " IDs.")
else
	_G.XenoLog("✅ Scan complete! Usable_

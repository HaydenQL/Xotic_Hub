repeat wait() until _G.XenoLog
_G.XenoLog("🔍 Testing known backdoor module IDs...")

local ids = {
    2788229376, -- Adonis
    2030473490, -- Kohl's Admin
    5951389993, -- HD Admin
    926280790,  -- Blank/Test
    4925462889, -- IceHub
}

local found = 0

for _, id in ipairs(ids) do
	pcall(function()
		local result = require(id)
		if typeof(result) == "table" or typeof(result) == "function" then
			found += 1
			_G.XenoLog("✅ Found usable module: ID = " .. id)
		end
	end)
end

if found == 0 then
	_G.XenoLog("❌ No known backdoor modules found.")
else
	_G.XenoLog("✅ Total usable backdoors found: " .. found)
end

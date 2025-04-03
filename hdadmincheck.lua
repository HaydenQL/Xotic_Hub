repeat wait() until _G.XenoLog
_G.XenoLog("🧪 Testing known HD Admin module: require(5951389993)")

local success, result = pcall(function()
	return require(5951389993)
end)

if success then
	if result then
		_G.XenoLog("✅ SUCCESS: Module returned a value (type: " .. typeof(result) .. ")")
	else
		_G.XenoLog("⚠️ Module loaded, but returned nil.")
	end
else
	_G.XenoLog("❌ Failed to require HD Admin module: " .. tostring(result))
end

repeat wait() until _G.XenoLog
_G.XenoLog("🧪 Testing known HD Admin module (5951389993)...")

pcall(function()
	local backdoor = require(5951389993)
	if backdoor then
		_G.XenoLog("✅ SUCCESS: HD Admin module is usable (5951389993)")
	else
		_G.XenoLog("❌ Module loaded, but no backdoor entry detected.")
	end
end)

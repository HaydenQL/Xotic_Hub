repeat wait() until _G.XenoLog
_G.XenoLog("📡 Watching for any new parts...")

-- Watch entire game, not just workspace
game.DescendantAdded:Connect(function(obj)
	if obj:IsA("BasePart") then
		_G.XenoLog("🧱 New Part Detected: " .. obj:GetFullName())
	end
end)

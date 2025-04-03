repeat wait() until _G.XenoLog
_G.XenoLog("⌛ Testing SendTimeGift for Time Points...")

local remote = game.ReplicatedStorage.Network.Instances["83_101_110_100_84_105_109_101_71_105_116_"]

if remote then
	local player = game.Players.LocalPlayer.Name
	local tests = {
		{"Give", player, 1000},   -- Try adding 1000 points to you
		{"Take", player, 500},    -- Try removing 500 points from you
		{"Give", "RandomPlayer", 500}, -- Test gifting points to someone else
	}

	for _, args in ipairs(tests) do
		local success, response = pcall(function()
			return remote:InvokeServer(unpack(args))
		end)

		if success and response then
			_G.XenoLog("✅ Action ["..args[1].."] success: "..tostring(response))
		elseif success then
			_G.XenoLog("⚠️ Action ["..args[1].."] succeeded but no response.")
		else
			_G.XenoLog("❌ Action ["..args[1].."] failed: "..tostring(response))
		end
		wait(0.5)
	end
else
	_G.XenoLog("❌ SendTimeGift remote not found.")
end

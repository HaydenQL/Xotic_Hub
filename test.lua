repeat wait() until _G.XenoLog
_G.XenoLog("🧲 Watching for your thrown Handle...")

-- Watch your character for Handle creation
local char = game.Players.LocalPlayer.Character or game.Players.LocalPlayer.CharacterAdded:Wait()

char.DescendantAdded:Connect(function(obj)
	if obj:IsA("BasePart") and obj.Name == "Handle" then
		_G.XenoLog("💥 Found Handle: " .. obj:GetFullName())

		-- Fling power (spin it harder)
		local bav = Instance.new("BodyAngularVelocity")
		bav.AngularVelocity = Vector3.new(0, 999999, 0)
		bav.MaxTorque = Vector3.new(1e9, 1e9, 1e9)
		bav.P = 3000
		bav.Parent = obj

		-- Optional: make visible and deadly looking
		obj.Color = Color3.fromRGB(255, 0, 0)
		obj.Material = Enum.Material.Neon
	end
end)
